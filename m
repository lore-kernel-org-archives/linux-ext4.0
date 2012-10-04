From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: fix ext4_flush_completed_IO wait semantics
Date: Thu, 4 Oct 2012 12:11:06 +0200
Message-ID: <20121004101106.GC4641@quack.suse.cz>
References: <1349289807-18811-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56580 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496Ab2JDKLJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Oct 2012 06:11:09 -0400
Content-Disposition: inline
In-Reply-To: <1349289807-18811-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 03-10-12 22:43:27, Dmitry Monakhov wrote:
> BUG #1) All places where we call ext4_flush_completed_IO are broken
>     because buffered io and DIO/AIO goes through three stages
>     1) submitted io,
>     2) completed io (in i_completed_io_list) conversion pended
>     3) finished  io (conversion done)
>     And by calling ext4_flush_completed_IO we will flush only
>     requests which were in (2) stage, which is wrong because:
>      1) punch_hole and truncate _must_ wait for all outstanding unwritten io
>       regardless to it's state.
>      2) fsync and nolock_dio_read should also wait because there is
>         a time window between end_page_writeback() and ext4_add_complete_io()
>         As result integrity fsync is broken in case of buffered write
>         to fallocated region:
>         fsync                                      blkdev_completion
> 	 ->filemap_write_and_wait_range
>                                                    ->ext4_end_bio
>                                                      ->end_page_writeback
>           <-- filemap_write_and_wait_range return
> 	 ->ext4_flush_completed_IO
>    	 sees empty i_completed_io_list but pended
>    	 conversion still exist
>                                                      ->ext4_add_complete_io
> 
> BUG #2) Race window becomes wider due to 'ext4: completed_io locking cleanup V4'
> 
> This patch make following changes:
> 1) ext4_flush_completed_io() now first try to flush completed io and when
>    wait for any outstanding unwritten io via ext4_unwritten_wait()
> 2) Rename function to more appropriate name.
> 3) Assert that all callers of ext4_flush_unwritten_io should hold i_mutex to
>    prevent endless wait
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
  This patch looks good except for:

> diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
> index 8d849da..37cd5a4 100644
> --- a/fs/ext4/indirect.c
> +++ b/fs/ext4/indirect.c
> @@ -807,9 +807,11 @@ ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
>  
>  retry:
>  	if (rw == READ && ext4_should_dioread_nolock(inode)) {
> -		if (unlikely(!list_empty(&ei->i_completed_io_list)))
> -			ext4_flush_completed_IO(inode);
> -
> +		if (unlikely(!atomic_read(&EXT4_I(inode)->i_unwritten))) {
  This condition which seems to be inverted...

> +			mutex_lock(&inode->i_mutex);
> +			ext4_flush_unwritten_io(inode);
> +			mutex_unlock(&inode->i_mutex);
> +		}
>  		/*
>  		 * Nolock dioread optimization may be dynamically disabled
>  		 * via ext4_inode_block_unlocked_dio(). Check inode's state

  After fixing that, you can add:
Reviewed-by: Jan Kara <jack@suse.cz>

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
