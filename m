From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 25/31] e2fsck: Only release clusters when shortening a
 directory during a rehash
Date: Thu, 10 Oct 2013 18:13:15 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1310101807110.1925@localhost.localdomain>
References: <20131001012642.28415.89353.stgit@birch.djwong.org> <20131001012921.28415.90047.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756515Ab3JJQNV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 10 Oct 2013 12:13:21 -0400
In-Reply-To: <20131001012921.28415.90047.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 30 Sep 2013, Darrick J. Wong wrote:

> Date: Mon, 30 Sep 2013 18:29:21 -0700
> From: Darrick J. Wong <darrick.wong@oracle.com>
> To: tytso@mit.edu, darrick.wong@oracle.com
> Cc: linux-ext4@vger.kernel.org
> Subject: [PATCH 25/31] e2fsck: Only release clusters when shortening a
>     directory during a rehash
> 
> When the rehash process is running on a bigalloc filesystem, it compresses all
> the directory entries and hash structures into the beginning of the directory
> file and then uses block_iterate3() to free the blocks off the end of the file.
> It seems to call ext2fs_block_alloc_stats2() for every block in a cluster,
> which is unfortunate because this function allocates and frees entire clusters
> (and updates the summary counts accordingly).  In this case e2fsck writes out
> incorrect summary counts.


Looks good.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
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
> 
