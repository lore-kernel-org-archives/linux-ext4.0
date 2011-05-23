From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] ext4: Fix waiting and sending of a barrier in
 ext4_sync_file()
Date: Mon, 23 May 2011 19:17:47 +0200
Message-ID: <20110523171747.GG4716@quack.suse.cz>
References: <20110522211239.GB10009@thunk.org>
 <1306098825-469-2-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43542 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755722Ab1EWRRu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 May 2011 13:17:50 -0400
Content-Disposition: inline
In-Reply-To: <1306098825-469-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun 22-05-11 17:13:45, Ted Tso wrote:
> From: Jan Kara <jack@suse.cz>
> 
> jbd2_log_start_commit() returns 1 only when we really start a
> transaction.  But we also need to wait for a transaction when the
> commit is already running.  Fix this problem by waiting for
> transaction commit unconditionally (which is just a quick check if the
> transaction is already committed).
> 
> Also we have to be more careful with sending of a barrier because when
> transaction is being committed in parallel to ext4_sync_file()
> running, we cannot be sure that the barrier the journalling code sends
> happens after we wrote all the data for fsync (note that not every
> data writeout needs to trigger metadata changes thus commit of some
> metadata changes can be running while other data is still written
> out). So use jbd2_will_send_data_barrier() helper to detect the common
> cases when we can be sure barrier will be issued by the commit code
> and issue the barrier ourselves in the remaining cases.
> 
> [ Modified by tytso so that the external journal cases are handled in
>   ext4_sync_file() to avoid needlessly issuing extra flush requests in
>   the data=ordered and data=journalled cases. ]
  Well, in data=journal case I agree your change will work (but that's your
minor concern I guess). In data=ordered it's harder:
a) The flush of j_fs_dev in jbd2_journal_commit_transaction() is issued
earlier than we set T_COMMIT_RECORD but that's easy to handle.
b) Whether we do or don't send the flush in
jbd2_journal_commit_transaction() depends on whether t_flushed_data_blocks
is set.  We can't know in advance whether it gets set or not because it
depends on whether some inode is in transaction's t_inode_list and inodes
can get removed from there when flusher thread has written all the pages
and inode has been reclaimed. OTOH this looks like a bug in the commit code
anyway - I guess t_flushed_data_blocks (or better named equivalent) should
be set in jbd2_journal_file_inode(). Then such variable will also become
a reliable indicator whether the data flush is going to be sent or not.

I'll update the patch set to reflect this...

								Honza
> Signed-off-by: Jan Kara <jack@suse.cz>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/fsync.c |   31 ++++++++++++++++++++-----------
>  1 files changed, 20 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
> index 60fe572..b0e03fa 100644
> --- a/fs/ext4/fsync.c
> +++ b/fs/ext4/fsync.c
> @@ -172,6 +172,7 @@ int ext4_sync_file(struct file *file, int datasync)
>  	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
>  	int ret;
>  	tid_t commit_tid;
> +	bool needs_barrier = false;
>  
>  	J_ASSERT(ext4_journal_current_handle() == NULL);
>  
> @@ -211,22 +212,30 @@ int ext4_sync_file(struct file *file, int datasync)
>  	}
>  
>  	commit_tid = datasync ? ei->i_datasync_tid : ei->i_sync_tid;
> -	if (jbd2_log_start_commit(journal, commit_tid)) {
> +	if (journal->j_flags & JBD2_BARRIER) {
>  		/*
>  		 * When the journal is on a different device than the
> -		 * fs data disk, we need to issue the barrier in
> -		 * writeback mode.  (In ordered mode, the jbd2 layer
> -		 * will take care of issuing the barrier.  In
> +		 * fs data disk, when data=writeback, we need to issue
> +		 * a barrier unconditionally.  (In ordered mode, the
> +		 * jbd2 layer will take care of issuing the barrier if
> +		 * there were any writes associated with the inode; in
>  		 * data=journal, all of the data blocks are written to
>  		 * the journal device.)
>  		 */
> -		if (ext4_should_writeback_data(inode) &&
> -		    (journal->j_fs_dev != journal->j_dev) &&
> -		    (journal->j_flags & JBD2_BARRIER))
> -			blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL,
> -					NULL);
> -		ret = jbd2_log_wait_commit(journal, commit_tid);
> -	} else if (journal->j_flags & JBD2_BARRIER)
> +		if ((journal->j_fs_dev != journal->j_dev) &&
> +		    ext4_should_writeback_data(inode))
> +			needs_barrier = true;
> +		else if (!jbd2_trans_will_send_data_barrier(journal,
> +							    commit_tid))
> +			/*
> +			 * If the journal layer isn't going to issue
> +			 * the barrier, then we'd better.
> +			 */
> +			needs_barrier = true;
> +	}
> +	jbd2_log_start_commit(journal, commit_tid);
> +	ret = jbd2_log_wait_commit(journal, commit_tid);
> +	if (needs_barrier)
>  		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
>   out:
>  	trace_ext4_sync_file_exit(inode, ret);
> -- 
> 1.7.3.1
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
