From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH -v2] ext4: fake direct I/O mode for data=journal
Date: Wed, 17 Aug 2011 13:42:52 +0200
Message-ID: <20110817114252.GD9959@quack.suse.cz>
References: <20110815180311.GC5948@thunk.org>
 <1313523145-31631-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47041 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab1HQLmy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Aug 2011 07:42:54 -0400
Content-Disposition: inline
In-Reply-To: <1313523145-31631-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 16-08-11 15:32:25, Ted Tso wrote:
> Currently attempts to open a file with O_DIRECT in data=journal mode
> causes the open to fail with -EINVAL.  This makes it very hard to test
> data=journal mode.  So we will let the open succeed, but then always
> fall back to O_DSYNC buffered writes.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/ext4/file.c  |   28 +++++++++++++++++++++++++++-
>  fs/ext4/inode.c |    1 +
>  2 files changed, 28 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index e4095e9..566f33f 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -89,6 +89,24 @@ ext4_unaligned_aio(struct inode *inode, const struct iovec *iov,
>  	return 0;
>  }
>  
> +ssize_t
> +ext4_file_read(struct kiocb *iocb, const struct iovec *iov,
> +	       unsigned long nr_segs, loff_t pos)
> +{
> +	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
> +
> +	/*
> +	 * If O_DIRECT is set and we are doing data journalling we
> +	 * don't support O_DIRECT so force it off.
> +	 */
> +	if ((iocb->ki_filp->f_flags & O_DIRECT) &&
> +	    ext4_should_journal_data(inode))
> +		iocb->ki_filp->f_flags &= ~O_DIRECT;
> +
> +	return generic_file_aio_read(iocb, iov, nr_segs, pos);
> +}
> +
> +
  Two empty lines here?

>  static ssize_t
>  ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
>  		unsigned long nr_segs, loff_t pos)
> @@ -98,6 +116,14 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
>  	int ret;
>  
>  	/*
> +	 * If O_DIRECT is set and we are doing data journalling we
> +	 * don't support O_DIRECT so force it off.
> +	 */
> +	if ((iocb->ki_filp->f_flags & O_DIRECT) &&
> +	    ext4_should_journal_data(inode))
> +		iocb->ki_filp->f_flags &= ~O_DIRECT;
> +
> +	/*
>  	 * If we have encountered a bitmap-format file, the size limit
>  	 * is smaller than s_maxbytes, which is for extent-mapped files.
>  	 */
> @@ -277,7 +303,7 @@ const struct file_operations ext4_file_operations = {
>  	.llseek		= ext4_llseek,
>  	.read		= do_sync_read,
>  	.write		= do_sync_write,
> -	.aio_read	= generic_file_aio_read,
> +	.aio_read	= ext4_file_read,
>  	.aio_write	= ext4_file_write,
>  	.unlocked_ioctl = ext4_ioctl,
>  #ifdef CONFIG_COMPAT
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 762e803..b7088e2 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -2921,6 +2921,7 @@ static const struct address_space_operations ext4_journalled_aops = {
>  	.bmap			= ext4_bmap,
>  	.invalidatepage		= ext4_invalidatepage,
>  	.releasepage		= ext4_releasepage,
> +	.direct_IO		= ext4_direct_IO,
>  	.is_partially_uptodate  = block_is_partially_uptodate,
>  	.error_remove_page	= generic_error_remove_page,
>  };
  Strictly speaking this is racy wrt. to fcntl() setting O_DIRECT bit.
Fixing it is actually quite simple - just provide ext4_noop_direct_IO
function that will just "return 0" and generic write code will fall
back to buffered IO automatically. We don't want to use the fallback all
the time since it incurs overhead of flushing and invalidating the mapping
so what you did above will catch the common case.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
