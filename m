From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] jbd2: finish inode data buffers immediately after
 submiting data buffers
Date: Thu, 13 Nov 2014 23:15:39 +0100
Message-ID: <20141113221539.GA15477@quack.suse.cz>
References: <545C6F67.9090600@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Joseph Qi <joseph.qi@huawei.com>, linux-fsdevel@vger.kernel.org
To: alex chen <alex.chen@huawei.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48344 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933065AbaKMWPm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Nov 2014 17:15:42 -0500
Content-Disposition: inline
In-Reply-To: <545C6F67.9090600@huawei.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri 07-11-14 15:06:15, alex chen wrote:
> During commit process, journal_finish_inode_data_buffers will flush plug
> list as follow:
> jbd2_journal_commit_transaction
> ->journal_finish_inode_data_buffers
> ->filemap_fdatawait_range
> ->wait_on_page_bit
> ->__wait_on_bit
> ->sleep_on_page
> ->io_schedule
> ->blk_flush_plug_list
> 
> When ASYNC_COMMIT feature is set, the journal_finish_inode_data_buffers
> separates the commit blocks from the rest of the journal blocks. So we
> should finish inode data buffers immediately after submiting data
> buffers, this allow most of the journal blocks to be written in a single
> I/O operation and improve journal commit performance.
  So the combination of ASYNC_COMMIT and data=ordered mode is broken - it
can happen that all journal writes make it to stable storage while data
writes don't on power failure thus exposing stale data on next boot. So
optimizing this combination is futile - we rather have to make sure we
don't allow users to run such combination. I'll look into it tomorrow.

								Honza
> 
> Signed-off-by: Alex Chen <alex.chen@huawei.com>
> ---
>  fs/jbd2/commit.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
> index b73e021..dc33d89 100644
> --- a/fs/jbd2/commit.c
> +++ b/fs/jbd2/commit.c
> @@ -555,6 +555,16 @@ void jbd2_journal_commit_transaction(journal_t *journal)
>  	if (err)
>  		jbd2_journal_abort(journal, err);
> 
> +	err = journal_finish_inode_data_buffers(journal, commit_transaction);
> +	if (err) {
> +		printk(KERN_WARNING
> +			"JBD2: Detected IO errors while flushing file data "
> +		       "on %s\n", journal->j_devname);
> +		if (journal->j_flags & JBD2_ABORT_ON_SYNCDATA_ERR)
> +			jbd2_journal_abort(journal, err);
> +		err = 0;
> +	}
> +
>  	blk_start_plug(&plug);
>  	jbd2_journal_write_revoke_records(journal, commit_transaction,
>  					  &log_bufs, WRITE_SYNC);
> @@ -752,16 +762,6 @@ start_journal_io:
>  		}
>  	}
> 
> -	err = journal_finish_inode_data_buffers(journal, commit_transaction);
> -	if (err) {
> -		printk(KERN_WARNING
> -			"JBD2: Detected IO errors while flushing file data "
> -		       "on %s\n", journal->j_devname);
> -		if (journal->j_flags & JBD2_ABORT_ON_SYNCDATA_ERR)
> -			jbd2_journal_abort(journal, err);
> -		err = 0;
> -	}
> -
>  	/*
>  	 * Get current oldest transaction in the log before we issue flush
>  	 * to the filesystem device. After the flush we can be sure that
> -- 
> 1.8.4.3
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
