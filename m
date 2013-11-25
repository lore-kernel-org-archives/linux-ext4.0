From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 14/25] e2fsck: only release clusters when shortening a
 directory during a rehash
Date: Mon, 25 Nov 2013 19:09:33 +0800
Message-ID: <20131125110933.GA15056@gmail.com>
References: <20131018044854.7339.48457.stgit@birch.djwong.org>
 <20131018045027.7339.9686.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:41841 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753156Ab3KYLGq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Nov 2013 06:06:46 -0500
Received: by mail-pb0-f51.google.com with SMTP id up15so5526744pbc.10
        for <linux-ext4@vger.kernel.org>; Mon, 25 Nov 2013 03:06:46 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20131018045027.7339.9686.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 17, 2013 at 09:50:27PM -0700, Darrick J. Wong wrote:
> When the rehash process is running on a bigalloc filesystem, it
> compresses all the directory entries and hash structures into the
> beginning of the directory file and then uses block_iterate3() to free
> the blocks off the end of the file.  It seems to call
> ext2fs_block_alloc_stats2() for every block in a cluster, which is
> unfortunate because this function allocates and frees entire clusters
> (and updates the summary counts accordingly).  In this case e2fsck
> writes out incorrect summary counts.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

                                                - Zheng

> ---
>  e2fsck/rehash.c |   14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
> index 6ef3568..29da9a1 100644
> --- a/e2fsck/rehash.c
> +++ b/e2fsck/rehash.c
> @@ -719,10 +719,18 @@ static int write_dir_block(ext2_filsys fs,
>  		/* We don't need this block, so release it */
>  		e2fsck_read_bitmaps(wd->ctx);
>  		blk = *block_nr;
> -		ext2fs_unmark_block_bitmap2(wd->ctx->block_found_map, blk);
> -		ext2fs_block_alloc_stats2(fs, blk, -1);
> +		/*
> +		 * In theory, we only release blocks from the end of the
> +		 * directory file, so it's fine to clobber a whole cluster at
> +		 * once.
> +		 */
> +		if (blk % EXT2FS_CLUSTER_RATIO(fs) == 0) {
> +			ext2fs_unmark_block_bitmap2(wd->ctx->block_found_map,
> +						    blk);
> +			ext2fs_block_alloc_stats2(fs, blk, -1);
> +			wd->cleared++;
> +		}
>  		*block_nr = 0;
> -		wd->cleared++;
>  		return BLOCK_CHANGED;
>  	}
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
