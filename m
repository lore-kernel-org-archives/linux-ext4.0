From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Date: Wed, 24 Oct 2012 01:23:51 -0400
Message-ID: <20121024052351.GB21714@thunk.org>
References: <87objupjlr.fsf@spindle.srvr.nix>
 <20121023013343.GB6370@fieldses.org>
 <87mwzdnuww.fsf@spindle.srvr.nix>
 <20121023143019.GA3040@fieldses.org>
 <874nllxi7e.fsf_-_@spindle.srvr.nix>
 <87pq48nbyz.fsf_-_@spindle.srvr.nix>
 <508740B2.2030401@redhat.com>
 <87txtkld4h.fsf@spindle.srvr.nix>
 <50876E1D.3040501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nix <nix@esperi.org.uk>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Bryan Schumaker <bjschuma@netapp.com>,
	Peng Tao <bergwolf@gmail.com>, Trond.Myklebust@netapp.com,
	gregkh@linuxfoundation.org,
	Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57169 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730Ab2JXFYH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Oct 2012 01:24:07 -0400
Content-Disposition: inline
In-Reply-To: <50876E1D.3040501@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 23, 2012 at 11:27:09PM -0500, Eric Sandeen wrote:
> 
> Ok, fair enough.  If the BBU is working, nobarrier is ok; I don't trust
> journal_async_commit, but that doesn't mean this isn't a regression.

Note that Toralf has reported almost exactly the same set of symptoms,
but he's using an external USB stick --- and as far as I know he
wasn't using nobarrier and/or the journal_async_commit.  Toralf, can
you confirm what, if any, mount options you were using when you saw
it.

I've been looking at this some more, and there's one other thing that
the short circuit code does, which is neglects setting the
JBD2_FLUSHED flag, which is used by the commit code to know when it
needs to reset the s_start fields in the superblock when we make our
next commit.  However, this would only happen if the short circuit
code is getting hit some time other than when the file system is
getting unmounted --- and that's what Eric and I can't figure out how
it might be happening.  Journal flushes outside of an unmount does
happen as part of online resizing, the FIBMAP ioctl, or when the file
system is frozen.  But it didn't sound like Toralf or Nix was using
any of those features.  (Toralf, Nix, please correct me if my
assumptions here is wrong).

So here's a replacement patch which essentially restores the effects
of eeecef0af5e while still keeping the optimization and fixing the
read/only testing issue which eeecef0af5e is trying to fix up.  It
also have a debugging printk that will trigger so we can perhaps have
a better chance of figuring out what might be going on.

Toralf, Nix, if you could try applying this patch (at the end of this
message), and let me know how and when the WARN_ON triggers, and if it
does, please send the empty_bug_workaround plus the WARN_ON(1) report.
I know about the case where a file system is mounted and then
immediately unmounted, but we don't think that's the problematic case.
If you see any other cases where WARN_ON is triggering, it would be
really good to know....

      	    	       		      - Ted

P.S.  This is a list of all of the commits between v3.6.1 and v3.6.2
(there were no ext4-related changes between v3.6.2 and v3.6.3), and a
quick analysis of the patch.  The last commit, 14b4ed2, is the only
one that I could see as potentially being problematic, which is why
I've been pushing so hard on this one even though my original analysis
doesn't seem to be correct, and Eric and I can't see how the change in
14b4ed2 could be causing the fs corruption.


Online Defrag
=============
22a5672 ext4: online defrag is not supported for journaled files
ba57d9e ext4: move_extent code cleanup
   No behavioral change unless e4defrag has been used.

Online Resize
=============
5018ddd ext4: avoid duplicate writes of the backup bg descriptor blocks
256ae46 ext4: don't copy non-existent gdt blocks when resizing
416a688 ext4: ignore last group w/o enough space when resizing instead of BUG'ing
   No observable change unless online resizing (e2resize) has been used

Other Commits
=============
92b7722 ext4: fix mtime update in nodelalloc mode
   Changes where we call file_update_time()

34414b2 ext4: fix fdatasync() for files with only i_size changes
   Forces the inode changes to be commited if only i_sync changes when
   fdatasync() is called.  No changes except performance impact
   to fdatasync() and correctness after a system crash.

12ebdf0 ext4: always set i_op in ext4_mknod()
   Fixes a bug if CONFIG_EXT4_FS_XATTR is not defined;
   no change if CONFIG_EXT4_FS_XATTR is defined

2fdb112 ext4: fix crash when accessing /proc/mounts concurrently
   Remove an erroneous "static" for an function so it is allocated on the stack;
   fixes a bug if two processes cat /proc/mounts at the same time

1638f1f ext4: fix potential deadlock in ext4_nonda_switch()
   Fixes a circular lock dependency

14b4ed2 jbd2: don't write superblock when if its empty
   If journal->s_start is zero, we may not update journal->s_sequence when
   it might be needed.  (But we at the moement we can't see how this could
   lead to the reported fs corruptions.)


commit cb57108637e01ec2f02d9311cedc3013e96f25d4
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Wed Oct 24 01:01:41 2012 -0400

    jbd2: fix a potential fs corrupting bug in jbd2_mark_journal_empty
    
    Fix a potential file system corrupting bug which was introduced by
    commit eeecef0af5ea4efd763c9554cf2bd80fc4a0efd3: jbd2: don't write
    superblock when if its empty.
    
    We should only skip writing the journal superblock if there is nothing
    to do --- not just when s_start is zero.
    
    This has caused users to report file system corruptions in ext4 that
    look like this:
    
    EXT4-fs error (device sdb3): ext4_mb_generate_buddy:741: group 436, 22902 clusters in bitmap, 22901 in gd
    JBD2: Spotted dirty metadata buffer (dev = sdb3, blocknr = 0). There's a risk of filesystem corruption in case of system crash.
    
    after the file system has been corrupted.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
    Cc: stable@vger.kernel.org

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 0f16edd..26b2983 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1351,24 +1351,33 @@ void jbd2_journal_update_sb_log_tail(journal_t *journal, tid_t tail_tid,
 static void jbd2_mark_journal_empty(journal_t *journal)
 {
 	journal_superblock_t *sb = journal->j_superblock;
+	__be32		new_tail_sequence;
 
 	BUG_ON(!mutex_is_locked(&journal->j_checkpoint_mutex));
 	read_lock(&journal->j_state_lock);
-	/* Is it already empty? */
+	new_tail_sequence = cpu_to_be32(journal->j_tail_sequence);
+	/* Nothing to do? */
 	if (sb->s_start == 0) {
+		pr_err("JBD2: jbd2_mark_journal_empty bug workaround (%u, %u)\n",
+		       (unsigned) be32_to_cpu(sb->s_sequence),
+		       (unsigned) be32_to_cpu(new_tail_sequence));
+		WARN_ON(1);
+	}
+	if (sb->s_start == 0 && sb->s_sequence == new_tail_sequence) {
 		read_unlock(&journal->j_state_lock);
-		return;
+		goto set_flushed;
 	}
 	jbd_debug(1, "JBD2: Marking journal as empty (seq %d)\n",
 		  journal->j_tail_sequence);
 
-	sb->s_sequence = cpu_to_be32(journal->j_tail_sequence);
+	sb->s_sequence = new_tail_sequence;
 	sb->s_start    = cpu_to_be32(0);
 	read_unlock(&journal->j_state_lock);
 
 	jbd2_write_superblock(journal, WRITE_FUA);
 
-	/* Log is no longer empty */
+set_flushed:
+	/* Log is empty */
 	write_lock(&journal->j_state_lock);
 	journal->j_flags |= JBD2_FLUSHED;
 	write_unlock(&journal->j_state_lock);
