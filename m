From: Joel Becker <jlbec@evilplan.org>
Subject: Re: [PATCH 7/9] ocfs2: Use generic handlers of O_SYNC AIO DIO
Date: Wed, 21 Nov 2012 11:32:41 -0800
Message-ID: <20121121193240.GL2822@localhost>
References: <20121120074116.24645.36369.stgit@blackbox.djwong.org>
 <20121120075114.25270.83181.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: axboe@kernel.dk, tytso@mit.edu, david@fromorbit.com,
	jmoyer@redhat.com, bpm@sgi.com, viro@zeniv.linux.org.uk,
	jack@suse.cz, linux-fsdevel@vger.kernel.org, hch@infradead.org,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	xfs@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:44880 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768Ab2KUTdD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Nov 2012 14:33:03 -0500
Content-Disposition: inline
In-Reply-To: <20121120075114.25270.83181.stgit@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 19, 2012 at 11:51:14PM -0800, Darrick J. Wong wrote:
> Use generic handlers to queue fsync() when AIO DIO is completed for O_SYNC
> file.
> 
> From: Jan Kara <jack@suse.cz>
> Signed-off-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Acked-by: Joel Becker <jlbec@evilplan.org>

> ---
>  fs/ocfs2/aops.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 6577432..60457cc 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -593,9 +593,7 @@ static void ocfs2_dio_end_io(struct kiocb *iocb,
>  	level = ocfs2_iocb_rw_locked_level(iocb);
>  	ocfs2_rw_unlock(inode, level);
>  
> -	if (is_async)
> -		aio_complete(iocb, ret, 0);
> -	inode_dio_done(inode);
> +	generic_dio_end_io(iocb, offset, bytes, private, ret, is_async);
>  }
>  
>  /*
> @@ -642,7 +640,7 @@ static ssize_t ocfs2_direct_IO(int rw,
>  	return __blockdev_direct_IO(rw, iocb, inode, inode->i_sb->s_bdev,
>  				    iov, offset, nr_segs,
>  				    ocfs2_direct_IO_get_blocks,
> -				    ocfs2_dio_end_io, NULL, 0);
> +				    ocfs2_dio_end_io, NULL, DIO_SYNC_WRITES);
>  }
>  
>  static void ocfs2_figure_cluster_boundaries(struct ocfs2_super *osb,
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

"Hell is oneself, hell is alone, the other figures in it, merely projections."
        - T. S. Eliot

			http://www.jlbec.org/
			jlbec@evilplan.org
