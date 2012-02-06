From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 2/3] ext4: honor the O_SYNC flag for aysnchronous direct I/O requests
Date: Mon, 06 Feb 2012 11:20:29 -0500
Message-ID: <x49bopcq6gi.fsf@segfault.boston.devel.redhat.com>
References: <1327698949-12616-1-git-send-email-jmoyer@redhat.com>
	<1327698949-12616-3-git-send-email-jmoyer@redhat.com>
	<20120202173120.GA6640@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20120202173120.GA6640@quack.suse.cz> (Jan Kara's message of
	"Thu, 2 Feb 2012 18:31:20 +0100")
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>> +	/* workqueue for aio+dio+o_sync disk cache flushing */
>> +	struct workqueue_struct *aio_dio_flush_wq;
>> +
>   Hmm, looking at the patch I'm wondering why did you introduce the new
> workqueue? It seems dio_unwritten_wq would be enough? You just need to
> rename it to something more appropriate ;)

I used a new workqueue as the operations are blocking, and I didn't want
to hold up other progress.  If you think re-using the unwritten_wq is
the right thing to do, I'm happy to comply.

>> +	/*
>> +	 * This function has two callers.  The first is the end_io_work
>> +	 * routine just below.  This is an asynchronous completion context.
>> +	 * The second is in the fsync path.  For the latter path, we can't
>> +	 * return from here until the job is done.  Hence, we issue a
>> +	 * blocking blkdev_issue_flush call.
>> +	 */
>> +	if (io->flag & EXT4_IO_END_NEEDS_SYNC) {
>> +		/*
>> +		 * Ideally, we'd like to know if the force_commit routine
>> +		 * actually did send something to disk.  If it didn't,
>> +		 * then we need to issue the cache flush by hand.  For now,
>> +		 * play it safe and do both.
>> +		 */
>> +		ret = ext4_force_commit(inode->i_sb);
>> +		if (ret)
>> +			goto endio;
>> +		ret = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_NOIO, NULL);
>   Look at what ext4_sync_file() does. It's more efficient than this.
> You need something like:
> 	commit_tid = file->f_flags & __O_SYNC ? EXT4_I(inode)->i_sync_tid :
> 						EXT4_I(inode)->i_datasync_tid;
> 	if (journal->j_flags & JBD2_BARRIER &&
> 	    !jbd2_trans_will_send_data_barrier(journal, commit_tid))
> 		needs_barrier = true;
> 	jbd2_log_start_commit(journal, commit_tid);
> 	jbd2_log_wait_commit(journal, commit_tid);
> 	if (needs_barrier)
> 		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_NOIO, NULL);

Great, thanks for the pointer!

Cheers,
Jeff
