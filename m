From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/4] jbd: fix error handling for checkpoint io (rebased)
Date: Mon, 19 May 2008 05:38:05 +0200
Message-ID: <20080519033805.GD10233@duck.suse.cz>
References: <482A6E00.6080303@hitachi.com> <482A6FA3.9000104@hitachi.com> <20080514143217.GF24363@duck.suse.cz> <482D61FB.7050706@hitachi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	sct@redhat.com, adilger@clusterfs.com,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Josef Bacik <jbacik@redhat.com>, Mingming Cao <cmm@us.ibm.com>,
	Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>,
	sugita <yumiko.sugita.yf@hitachi.com>
To: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:41335 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754154AbYESDiH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 May 2008 23:38:07 -0400
Content-Disposition: inline
In-Reply-To: <482D61FB.7050706@hitachi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Fri 16-05-08 19:29:15, Hidehiro Kawai wrote:
> Jan Kara wrote:
> >> /*
> >> + * We couldn't write back some metadata buffers to the filesystem.
> >> + * To avoid unwritten-back metadata buffers from losing, set
> >> + * JFS_CP_ABORT flag and make sure that the journal space isn't
> >> + * cleaned.  This function also aborts journaling.
> >> + */
> >> +static void __journal_abort_checkpoint(journal_t *journal, int errno)
> >> +{
> >> +	if (is_checkpoint_aborted(journal))
> >> +		return;
> >> +
> >> +	spin_lock(&journal->j_state_lock);
> >> +	journal->j_flags |= JFS_CP_ABORT;
> >> +	spin_unlock(&journal->j_state_lock);
> >> +	printk(KERN_WARNING "JBD: Checkpointing failed.  Some metadata blocks "
> >> +	       "are still old.\n");
> >> +	journal_abort(journal, errno);
> >> +}
> 
> [snip]
> 
> >>Index: linux-2.6.26-rc2/include/linux/jbd.h
> >>===================================================================
> >>--- linux-2.6.26-rc2.orig/include/linux/jbd.h
> >>+++ linux-2.6.26-rc2/include/linux/jbd.h
> >>@@ -816,6 +816,8 @@ struct journal_s
> >> #define JFS_FLUSHED	0x008	/* The journal superblock has been flushed */
> >> #define JFS_LOADED	0x010	/* The journal superblock has been loaded */
> >> #define JFS_BARRIER	0x020	/* Use IDE barriers */
> >>+#define JFS_CP_ABORT	0x040	/* Checkpointing has failed.  We don't have to
> >>+				 * clean the journal space.  */
> >> 
> >> /*
> >>  * Function declarations for the journaling transaction and buffer
> >>@@ -1004,6 +1006,11 @@ static inline int is_journal_aborted(jou
> >> 	return journal->j_flags & JFS_ABORT;
> >> }
> >> 
> >>+static inline int is_checkpoint_aborted(journal_t *journal)
> >>+{
> >>+	return journal->j_flags & JFS_CP_ABORT;
> >>+}
> >>+
> > 
> >   Actually, I don't think this new flag is needed (not that it would really
> > harm anything). At least at the places where you check it you can as well
> > check whether the journal is aborted (maybe except for journal_destroy()
> > but see my comment there).
> 
> As you say, JFS_CP_ABORT isn't necessarily needed in the most cases,
> but it is needed for __journal_abort_checkpoint() which report the
> checkpoint related error by printk only once.  If we use JFS_ABORT
> to check whether this call is second time, the error message may be
> never printed out because the journal has been aborted by another
> reason.  If we don't check for the second call, the error message
> will be printed out several times.
  Yes, I think that checking out for JFS_ABORT is the right thing to do.
Once the journal has aborted for some reason, it is enough that we print
some error message (and that is responsibility of the first caller of
journal_abort()). Printing that checkpointing has not succeeded as well is
IMO not needed.

> Instead of using __journal_abort_checkpoint(), we'll be able to do
> the similar thing by adding the printk() directly in journal_destroy(),
> journal_flush(), and __log_wait_for_space() (but it can be more
> than one time).
> 
> I agree that we should not add another flag as much as possible.
> So I'll try to revise to remove the flag if you agree to add
> 3 printk()s.
  Well, as I said, one flag in journal is not a big deal but I found it a
bit confusing why there's a special flag for checkpoint abort when standard
abort would do fine as well.

> >>Index: linux-2.6.26-rc2/fs/ext3/super.c
> >>===================================================================
> >>--- linux-2.6.26-rc2.orig/fs/ext3/super.c
> >>+++ linux-2.6.26-rc2/fs/ext3/super.c
> >>@@ -395,7 +395,10 @@ static void ext3_put_super (struct super
> >> 	ext3_xattr_put_super(sb);
> >> 	journal_destroy(sbi->s_journal);
> >> 	if (!(sb->s_flags & MS_RDONLY)) {
> >>-		EXT3_CLEAR_INCOMPAT_FEATURE(sb, EXT3_FEATURE_INCOMPAT_RECOVER);
> >>+		if (!is_checkpoint_aborted(sbi->s_journal)) {
> >>+			EXT3_CLEAR_INCOMPAT_FEATURE(sb,
> >>+				EXT3_FEATURE_INCOMPAT_RECOVER);
> >>+		}
> > 
> >   I think you should test here whether the journal is aborted (and
> > EXT3_MOUNT_ABORT isn't set) and if so, call ext3_abort() and just
> > completely avoid updating super block...
> 
> Your idea looks good.  But as Josef pointed out, journal_destroy()
> frees sbi->s_journal, so we need to make journal_destroy() return the
> error status.
  Yes.

> >>@@ -1151,7 +1151,8 @@ void journal_destroy(journal_t *journal)
> >> 	journal->j_tail = 0;
> >> 	journal->j_tail_sequence = ++journal->j_transaction_sequence;
> >> 	if (journal->j_sb_buffer) {
> >>-		journal_update_superblock(journal, 1);
> >>+		if (!is_checkpoint_aborted(journal))
> >>+			journal_update_superblock(journal, 1);
> >> 		brelse(journal->j_sb_buffer);
> >> 	}
> > 
> >   I don't like this much. I'd rather completely avoid updating j_tail and
> > j_tail_sequence above in case the journal is aborted but I'd write the
> > journal superblock so that information about abortion gets written...
> 
> log_do_checkpoint() calls cleanup_journal_tail(), which advances
> j_tail and j_tail_sequence.  So if we adopt the policy that we don't
> modify j_tail and j_tail_sequence when checkpointing failed, we should
> also fix cleanup_journal_tail().
> 
> I adopted the policy that we don't update the journal super block
> when checkpointing failed.  When checkpointing failed, journal_abort()
> is called before cleanup_journal_tail().  So what we want to write
> should be in the journal super block.
  I see. The thing I'm afraid of with this policy is, that when sometime later
we add somewhere journal_update_superblock() and forget about checking
whether journal isn't aborted, we will magically get filesystem corruption
when IO error happens and that would be really hard to debug. So I'd
rather refrain from updating j_tail and j_tail_sequence.

> >>@@ -1333,7 +1334,6 @@ static int journal_convert_superblock_v1
> >> 
> >> int journal_flush(journal_t *journal)
> >> {
> >>-	int err = 0;
> >> 	transaction_t *transaction = NULL;
> >> 	unsigned long old_tail;
> >> 
> >>@@ -1356,14 +1356,19 @@ int journal_flush(journal_t *journal)
> >> 		spin_unlock(&journal->j_state_lock);
> >> 	}
> >> 
> >>-	/* ...and flush everything in the log out to disk. */
> >>+	/* ...and flush everything in the log out to disk.
> >>+	 * Even if an error occurs, we don't stop this loop.
> >>+	 * We do checkpoint as much as possible.  */
> >> 	spin_lock(&journal->j_list_lock);
> >>-	while (!err && journal->j_checkpoint_transactions != NULL) {
> >>+	while (journal->j_checkpoint_transactions != NULL) {
> >> 		spin_unlock(&journal->j_list_lock);
> >>-		err = log_do_checkpoint(journal);
> >>+		log_do_checkpoint(journal);
> >> 		spin_lock(&journal->j_list_lock);
> >> 	}
> >> 	spin_unlock(&journal->j_list_lock);
> >>+	if (is_checkpoint_aborted(journal))
> >>+		return -EIO;
> >>+
> > 
> >   Why do you change the loop? If we fail to checkpoint some buffer, we stop
> > journaling anyway and so journal will be replayed when fsck is run...
> 
> Certainly, fsck or journal_recover() replay the unwritten-back metadata
> block.  journal_destroy() also call log_do_checkpoint() against all
> un-checkpointed transactions.  I just thought `flush' means writing out
> all data which we should write to disk.  There is no problem if I
> don't change the loop.
  "flush" means "make journal empty". If we are not able to do it all, it
does not really matter how much do we manage to write out. So I wouldn't
change the loop.
								Honza
 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
