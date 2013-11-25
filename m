From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 11/25] libext2fs: only punch complete clusters
Date: Mon, 25 Nov 2013 16:51:49 +0800
Message-ID: <20131125085149.GF5964@gmail.com>
References: <20131018044854.7339.48457.stgit@birch.djwong.org>
 <20131018045008.7339.73690.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:35541 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab3KYItD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Nov 2013 03:49:03 -0500
Received: by mail-pb0-f50.google.com with SMTP id rr13so5203764pbb.23
        for <linux-ext4@vger.kernel.org>; Mon, 25 Nov 2013 00:49:03 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20131018045008.7339.73690.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 17, 2013 at 09:50:08PM -0700, Darrick J. Wong wrote:
> When bigalloc is enabled, using ext2fs_block_alloc_stats2() to free
> any block in a cluster has the effect of freeing the entire cluster.
> This is problematic if a caller instructs us to punch, say, blocks
> 12-15 of a 16-block cluster, because blocks 0-11 now point to a "free"
> cluster.
> 
> The naive way to solve this problem is to see if any of the other
> blocks in this logical cluster map to a physical cluster.  If so, then
> we know that the cluster is still in use and it mustn't be freed.
> Otherwise, we are punching the last mapped block in this cluster, so
> we can free the cluster.
> 
> The implementation given only does the rigorous checks for the partial
> clusters at the beginning and end of the punching range.
> 
> v2: Refactor the block free code into a separate helper function that
> should be more efficient.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

                                                - Zheng

> ---
>  lib/ext2fs/bmap.c   |   29 ++++++++++++++++++
>  lib/ext2fs/ext2fs.h |    3 ++
>  lib/ext2fs/punch.c  |   82 ++++++++++++++++++++++++++++++++++++++++++++++++---
>  3 files changed, 109 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/lib/ext2fs/bmap.c b/lib/ext2fs/bmap.c
> index 5074587..80f8f86 100644
> --- a/lib/ext2fs/bmap.c
> +++ b/lib/ext2fs/bmap.c
> @@ -173,6 +173,35 @@ static errcode_t implied_cluster_alloc(ext2_filsys fs, ext2_ino_t ino,
>  	return 0;
>  }
>  
> +/* Try to map a logical block to an already-allocated physical cluster. */
> +errcode_t ext2fs_map_cluster_block(ext2_filsys fs, ext2_ino_t ino,
> +				   struct ext2_inode *inode, blk64_t lblk,
> +				   blk64_t *pblk)
> +{
> +	ext2_extent_handle_t handle;
> +	errcode_t retval;
> +
> +	/* Need bigalloc and extents to be enabled */
> +	*pblk = 0;
> +	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
> +					EXT4_FEATURE_RO_COMPAT_BIGALLOC) ||
> +	    !(inode->i_flags & EXT4_EXTENTS_FL))
> +		return 0;
> +
> +	retval = ext2fs_extent_open2(fs, ino, inode, &handle);
> +	if (retval)
> +		goto out;
> +
> +	retval = implied_cluster_alloc(fs, ino, inode, handle, lblk, pblk);
> +	if (retval)
> +		goto out2;
> +
> +out2:
> +	ext2fs_extent_free(handle);
> +out:
> +	return retval;
> +}
> +
>  static errcode_t extent_bmap(ext2_filsys fs, ext2_ino_t ino,
>  			     struct ext2_inode *inode,
>  			     ext2_extent_handle_t handle,
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index 8f82dae..5247922 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -924,6 +924,9 @@ extern errcode_t ext2fs_bmap2(ext2_filsys fs, ext2_ino_t ino,
>  			      struct ext2_inode *inode,
>  			      char *block_buf, int bmap_flags, blk64_t block,
>  			      int *ret_flags, blk64_t *phys_blk);
> +errcode_t ext2fs_map_cluster_block(ext2_filsys fs, ext2_ino_t ino,
> +				   struct ext2_inode *inode, blk64_t lblk,
> +				   blk64_t *pblk);
>  
>  #if 0
>  /* bmove.c */
> diff --git a/lib/ext2fs/punch.c b/lib/ext2fs/punch.c
> index 790a0ad8..1e4398e 100644
> --- a/lib/ext2fs/punch.c
> +++ b/lib/ext2fs/punch.c
> @@ -177,6 +177,75 @@ static void dbg_print_extent(char *desc, struct ext2fs_extent *extent)
>  #define dbg_printf(f, a...)		do { } while (0)
>  #endif
>  
> +/* Free a range of blocks, respecting cluster boundaries */
> +static errcode_t punch_extent_blocks(ext2_filsys fs, ext2_ino_t ino,
> +				     struct ext2_inode *inode,
> +				     blk64_t lfree_start, blk64_t free_start,
> +				     __u32 free_count, int *freed)
> +{
> +	blk64_t		pblk;
> +	int		freed_now = 0;
> +	__u32		cluster_freed;
> +	errcode_t	retval = 0;
> +
> +	/* No bigalloc?  Just free each block. */
> +	if (EXT2FS_CLUSTER_RATIO(fs) == 1) {
> +		*freed += free_count;
> +		while (free_count-- > 0)
> +			ext2fs_block_alloc_stats2(fs, free_start++, -1);
> +		return retval;
> +	}
> +
> +	/*
> +	 * Try to free up to the next cluster boundary.  We assume that all
> +	 * blocks in a logical cluster map to blocks from the same physical
> +	 * cluster, and that the offsets within the [pl]clusters match.
> +	 */
> +	if (free_start & EXT2FS_CLUSTER_MASK(fs)) {
> +		retval = ext2fs_map_cluster_block(fs, ino, inode,
> +						  lfree_start, &pblk);
> +		if (retval)
> +			goto errout;
> +		if (!pblk) {
> +			ext2fs_block_alloc_stats2(fs, free_start, -1);
> +			freed_now++;
> +		}
> +		cluster_freed = EXT2FS_CLUSTER_RATIO(fs) -
> +			(free_start & EXT2FS_CLUSTER_MASK(fs));
> +		if (cluster_freed > free_count)
> +			cluster_freed = free_count;
> +		free_count -= cluster_freed;
> +		free_start += cluster_freed;
> +		lfree_start += cluster_freed;
> +	}
> +
> +	/* Free whole clusters from the middle of the range. */
> +	while (free_count > 0 && free_count >= EXT2FS_CLUSTER_RATIO(fs)) {
> +		ext2fs_block_alloc_stats2(fs, free_start, -1);
> +		freed_now++;
> +		cluster_freed = EXT2FS_CLUSTER_RATIO(fs);
> +		free_count -= cluster_freed;
> +		free_start += cluster_freed;
> +		lfree_start += cluster_freed;
> +	}
> +
> +	/* Try to free the last cluster. */
> +	if (free_count > 0) {
> +		retval = ext2fs_map_cluster_block(fs, ino, inode,
> +						  lfree_start, &pblk);
> +		if (retval)
> +			goto errout;
> +		if (!pblk) {
> +			ext2fs_block_alloc_stats2(fs, free_start, -1);
> +			freed_now++;
> +		}
> +	}
> +
> +errout:
> +	*freed += freed_now;
> +	return retval;
> +}
> +
>  static errcode_t ext2fs_punch_extent(ext2_filsys fs, ext2_ino_t ino,
>  				     struct ext2_inode *inode,
>  				     blk64_t start, blk64_t end)
> @@ -184,7 +253,7 @@ static errcode_t ext2fs_punch_extent(ext2_filsys fs, ext2_ino_t ino,
>  	ext2_extent_handle_t	handle = 0;
>  	struct ext2fs_extent	extent;
>  	errcode_t		retval;
> -	blk64_t			free_start, next;
> +	blk64_t			free_start, next, lfree_start;
>  	__u32			free_count, newlen;
>  	int			freed = 0;
>  	int			op;
> @@ -211,6 +280,7 @@ static errcode_t ext2fs_punch_extent(ext2_filsys fs, ext2_ino_t ino,
>  			/* Start of deleted region before extent; 
>  			   adjust beginning of extent */
>  			free_start = extent.e_pblk;
> +			lfree_start = extent.e_lblk;
>  			if (next > end)
>  				free_count = end - extent.e_lblk + 1;
>  			else
> @@ -226,6 +296,7 @@ static errcode_t ext2fs_punch_extent(ext2_filsys fs, ext2_ino_t ino,
>  			dbg_printf("Case #%d\n", 2);
>  			newlen = start - extent.e_lblk;
>  			free_start = extent.e_pblk + newlen;
> +			lfree_start = extent.e_lblk + newlen;
>  			free_count = extent.e_len - newlen;
>  			extent.e_len = newlen;
>  		} else {
> @@ -241,6 +312,7 @@ static errcode_t ext2fs_punch_extent(ext2_filsys fs, ext2_ino_t ino,
>  
>  			extent.e_len = start - extent.e_lblk;
>  			free_start = extent.e_pblk + extent.e_len;
> +			lfree_start = extent.e_lblk + extent.e_len;
>  			free_count = end - start + 1;
>  
>  			dbg_print_extent("inserting", &newex);
> @@ -281,10 +353,10 @@ static errcode_t ext2fs_punch_extent(ext2_filsys fs, ext2_ino_t ino,
>  			goto errout;
>  		dbg_printf("Free start %llu, free count = %u\n",
>  		       free_start, free_count);
> -		while (free_count-- > 0) {
> -			ext2fs_block_alloc_stats2(fs, free_start++, -1);
> -			freed++;
> -		}
> +		retval = punch_extent_blocks(fs, ino, inode, lfree_start,
> +					     free_start, free_count, &freed);
> +		if (retval)
> +			goto errout;
>  	next_extent:
>  		retval = ext2fs_extent_get(handle, op,
>  					   &extent);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
