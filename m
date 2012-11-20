From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/9] xfs: factor out everything but the
 filemap_write_and_wait from xfs_file_fsync
Date: Tue, 20 Nov 2012 21:47:37 +1100
Message-ID: <20121120104737.GB2591@dastard>
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
 <20121120074138.24645.36708.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, tytso@mit.edu, jmoyer@redhat.com, bpm@sgi.com,
	viro@zeniv.linux.org.uk, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, hch@infradead.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:17738 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751798Ab2KTKrl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Nov 2012 05:47:41 -0500
Content-Disposition: inline
In-Reply-To: <20121120074138.24645.36708.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 19, 2012 at 11:41:38PM -0800, Darrick J. Wong wrote:
> Hi,
> 
> Fsyncing is tricky business, so factor out the bits of the xfs_file_fsync
> function that can be used from the I/O post-processing path.
> 
> From: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> ---
>  fs/xfs/xfs_file.c  |   44 +++++++++++++++++++++++++++++---------------
>  fs/xfs/xfs_inode.h |    1 +
>  2 files changed, 30 insertions(+), 15 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index aa473fa..507f446 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -152,25 +152,18 @@ xfs_dir_fsync(
>  	return _xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, NULL);
>  }
>  
> -STATIC int
> -xfs_file_fsync(
> -	struct file		*file,
> -	loff_t			start,
> -	loff_t			end,
> +/*
> + * Returns 0 on success, -errno on failure.
> + */
> +int
> +do_xfs_file_fsync(
> +	struct xfs_inode	*ip,
> +	struct xfs_mount	*mp,
>  	int			datasync)

xfs_do_file_fsync()

And being an internal XFS function, it should return a positive
error number.

....

> +{
> +	struct inode		*inode = file->f_mapping->host;
> +	struct xfs_inode	*ip = XFS_I(inode);
> +	struct xfs_mount	*mp = ip->i_mount;
> +	int			error = 0;
> +
> +	trace_xfs_file_fsync(ip);
> +
> +	error = filemap_write_and_wait_range(inode->i_mapping, start, end);
> +	if (error)
> +		return error;
> +
> +	return do_xfs_file_fsync(ip, mp, datasync);

And be negated here.

> +}
> +
>  STATIC ssize_t
>  xfs_file_aio_read(
>  	struct kiocb		*iocb,
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index 94b32f9..d5bf105 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -546,6 +546,7 @@ do { \
>  	iput(VFS_I(ip)); \
>  } while (0)
>  
> +int	do_xfs_file_fsync(struct xfs_inode *, struct xfs_mount *, int);
>  #endif /* __KERNEL__ */

This should probably go in fs/xfs/xfs_vnodeops.h (like the only
other non-static function (xfs_zero_eof) in fs/xfs/xfs_file.c is.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
