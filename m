From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 8/8] jbd2: Cleanup journal tail after transaction commit
Date: Thu, 16 Feb 2012 13:59:27 +0100
Message-ID: <20120216125927.GC18613@quack.suse.cz>
References: <1329330854-14237-1-git-send-email-jack@suse.cz>
 <1329330854-14237-9-git-send-email-jack@suse.cz>
 <377B1146-3A57-4959-A0AA-012D5813A514@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Ted Tso <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59497 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231Ab2BPM7a (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Feb 2012 07:59:30 -0500
Content-Disposition: inline
In-Reply-To: <377B1146-3A57-4959-A0AA-012D5813A514@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 15-02-12 14:03:30, Andreas Dilger wrote:
> On 2012-02-15, at 10:34 AM, Jan Kara wrote:
> > Normally, we have to issue a cache flush before we can update journal tail in
> > journal superblock, effectively wiping out old transactions from the journal.
> > So use the fact that during transaction commit we issue cache flush anyway and
> > opportunistically push journal tail as far as we can. Since update of journal
> > superblock is still costly (we have to use WRITE_FUA), we update log tail only
> > if we can free significant amount of space.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> > fs/jbd2/commit.c     |   32 ++++++++++++++++++++++++++++++++
> > fs/jbd2/journal.c    |   13 +++++++++++++
> > include/linux/jbd2.h |    1 +
> > 3 files changed, 46 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> > index f37b783..245201c 100644
> > --- a/fs/jbd2/commit.c
> > +++ b/fs/jbd2/commit.c
> > @@ -331,6 +331,10 @@ void jbd2_journal_commit_transaction(journal_t *journal)
> > 	struct buffer_head *cbh = NULL; /* For transactional checksums */
> > 	__u32 crc32_sum = ~0;
> > 	struct blk_plug plug;
> > +	/* Tail of the journal */
> > +	unsigned long first_block;
> > +	tid_t first_tid;
> > +	int update_tail;
> > 
> > 	/*
> > 	 * First job: lock down the current transaction and wait for
> > @@ -682,10 +686,30 @@ start_journal_io:
> > 		err = 0;
> > 	}
> > 
> > +	/*
> > +	 * Get current oldest transaction in the log before we issue flush
> > +	 * to the filesystem device. After the flush we can be sure that
> > +	 * blocks of all older transactions are checkpointed to persistent
> > +	 * storage and we will be safe to update journal start in the
> > +	 * superblock with the numbers we get here.
> > +	 */
> > +	update_tail =
> > +		jbd2_journal_get_log_tail(journal, &first_tid, &first_block);
> > +
> > 	write_lock(&journal->j_state_lock);
> > +	if (update_tail) {
> > +		long freed = first_block - journal->j_tail;
> > +
> > +		if (first_block < journal->j_tail)
> > +			freed += journal->j_last - journal->j_first;
> > +		/* Update tail only if we free significant amount of space */
> > +		if (freed < journal->j_maxlen / 4)
> > +			update_tail = 0;
> > +	}
> 
> Have you done any performance testing on this?  I expect that it may give
> a nice boost in performance when there are lots of small transactions in
> the journal.  However, it might also increase latency if the journal is
> nearly full and no new transactions can be started until 1/4 of the journal
> is checkpointed.
  Well, I didn't do serious performance testing because I failed to find a
workload where I would think it could make a difference. For example for
workload creating and deleting directories and 0-length files, I saw about
one jbd2_cleanup_journal_tail() invocation per 200 transaction commits. So
the possible gain would be very well in the noise.

> This should probably be conditional on a decent amount of free blocks left
> in the journal, for example:
> 
> 		if (j_free >= j_maxlen / 8 && freed < journal->j_maxlen / 4)
> 			update_tail = 0;
> 
> or
> 		if (freed >= j_free)
> 			update_tail = 0;
  Yeah. Currently, I'm doubtful we should apply this patch at all. But if
we do, tweaking the condition is certainly possible. I mostly wanted to
gather people's thoughts regarding this particular patch in the first
round.

  Thanks for your comments.
								Honza
