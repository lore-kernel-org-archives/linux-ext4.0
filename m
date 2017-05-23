From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext4: fix off-by-one error when writing back pages
 before dio read
Date: Tue, 23 May 2017 09:53:05 +0200
Message-ID: <20170523075305.GA1230@quack2.suse.cz>
References: <20170523013441.49030-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Jan Kara <jack@suse.com>, Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37493 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935055AbdEWHxI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 23 May 2017 03:53:08 -0400
Content-Disposition: inline
In-Reply-To: <20170523013441.49030-1-ebiggers3@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 22-05-17 18:34:41, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The 'lend' argument of filemap_write_and_wait_range() is inclusive, so
> we need to subtract 1 from pos + count.
> 
> Note that 'count' is guaranteed to be nonzero since
> ext4_file_read_iter() returns early when given a 0 count.
> 
> Fixes: 16c54688592c ("ext4: Allow parallel DIO reads")
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Yeah. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 7c6e715b4d2e..3080ea82dd6d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -3710,7 +3710,7 @@ static ssize_t ext4_direct_IO_read(struct kiocb *iocb, struct iov_iter *iter)
>  	 */
>  	inode_lock_shared(inode);
>  	ret = filemap_write_and_wait_range(mapping, iocb->ki_pos,
> -					   iocb->ki_pos + count);
> +					   iocb->ki_pos + count - 1);
>  	if (ret)
>  		goto out_unlock;
>  	ret = __blockdev_direct_IO(iocb, inode, inode->i_sb->s_bdev,
> -- 
> 2.13.0.219.gdb65acc882-goog
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
