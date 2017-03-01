From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/8] nowait aio: xfs
Date: Wed, 1 Mar 2017 07:40:58 -0800
Message-ID: <20170301154058.GD30631@infradead.org>
References: <20170228233610.25456-1-rgoldwyn@suse.de>
 <20170228233610.25456-8-rgoldwyn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jack@suse.com, hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        Goldwyn Rodrigues <rgoldwyn@suse.com>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170228233610.25456-8-rgoldwyn@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> @@ -528,12 +528,17 @@ xfs_file_dio_aio_write(
>  	    ((iocb->ki_pos + count) & mp->m_blockmask)) {
>  		unaligned_io = 1;
>  		iolock = XFS_IOLOCK_EXCL;
> +		if (iocb->ki_flags & IOCB_NOWAIT)
> +			return -EAGAIN;

So all unaligned I/O will return -EAGAIN?  Why?  Also please explain
that reason in a comment right here.

> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index 1aa3abd..84f981a 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -1020,6 +1020,11 @@ xfs_file_iomap_begin(
>  	if ((flags & IOMAP_REPORT) ||
>  	    (xfs_is_reflink_inode(ip) &&
>  	     (flags & IOMAP_WRITE) && (flags & IOMAP_DIRECT))) {
> +		/* Allocations due to reflinks */
> +		if ((flags & IOMAP_NOWAIT) && !(flags & IOMAP_REPORT)) {
> +			error = -EAGAIN;
> +			goto out_unlock;
> +		}

FYI, this code looks very different in current Linus' tree - I think
you're on some old kernel base.
