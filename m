From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 6/6] e2fsck: optimize pass 5 for CPU utilization
Date: Mon, 26 Nov 2012 12:59:12 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1211261257030.18234@localhost>
References: <1353803794-11593-1-git-send-email-tytso@mit.edu> <1353803794-11593-7-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab2KZL7Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Nov 2012 06:59:16 -0500
In-Reply-To: <1353803794-11593-7-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 24 Nov 2012, Theodore Ts'o wrote:

> Date: Sat, 24 Nov 2012 19:36:34 -0500
> From: Theodore Ts'o <tytso@mit.edu>
> To: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Cc: Theodore Ts'o <tytso@mit.edu>
> Subject: [PATCH 6/6] e2fsck: optimize pass 5 for CPU utilization
> 
> Add a fast past optimization in e2fsck's pass 5 for the common case
> where the block bitmap is correct.  The optimization works by
> extracting each block group's block allocation bitmap into a memory
> buffer, and comparing it with the expected allocation bitmap using
> memcmp().  If it matches, then we can just update the free block
> counts and be on our way, and skip checking each bit individually.
> 
> Addresses-Google-Bug: #7534813

Looks good, we can always move the discard operation at the end of
the function before we free the bitmap, but that's further
optimization.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  e2fsck/pass5.c | 55 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 53 insertions(+), 2 deletions(-)
> 
> diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
> index 8312fe0..5aff55c 100644
> --- a/e2fsck/pass5.c
> +++ b/e2fsck/pass5.c
> @@ -212,6 +212,12 @@ static void check_block_bitmaps(e2fsck_t ctx)
>  	int	cmp_block = 0;
>  	int	redo_flag = 0;
>  	blk64_t	super_blk, old_desc_blk, new_desc_blk;
> +	char *actual_buf, *bitmap_buf;
> +
> +	actual_buf = (char *) e2fsck_allocate_memory(ctx, fs->blocksize,
> +						     "actual bitmap buffer");
> +	bitmap_buf = (char *) e2fsck_allocate_memory(ctx, fs->blocksize,
> +						     "bitmap block buffer");
>  
>  	clear_problem_context(&pctx);
>  	free_array = (unsigned int *) e2fsck_allocate_memory(ctx,
> @@ -259,11 +265,53 @@ redo_counts:
>  	for (i = B2C(fs->super->s_first_data_block);
>  	     i < ext2fs_blocks_count(fs->super);
>  	     i += EXT2FS_CLUSTER_RATIO(fs)) {
> +		int first_block_in_bg = (B2C(i) -
> +					 B2C(fs->super->s_first_data_block)) %
> +			fs->super->s_clusters_per_group == 0;
> +		int n, nbytes = fs->super->s_clusters_per_group / 8;
> +
>  		actual = ext2fs_fast_test_block_bitmap2(ctx->block_found_map, i);
>  
> +		/*
> +		 * Try to optimize pass5 by extracting a bitmap block
> +		 * as expected from what we have on disk, and then
> +		 * comparing the two.  If they are identical, then
> +		 * update the free block counts and go on to the next
> +		 * block group.  This is much faster than doing the
> +		 * individual bit-by-bit comparison.  The one downside
> +		 * is that this doesn't work if we are asking e2fsck
> +		 * to do a discard operation.
> +		 */
> +		if (!first_block_in_bg ||
> +		    (group == (int)fs->group_desc_count - 1) ||
> +		    (ctx->options & E2F_OPT_DISCARD))
> +			goto no_optimize;
> +
> +		retval = ext2fs_get_block_bitmap_range2(ctx->block_found_map,
> +				B2C(i), fs->super->s_clusters_per_group,
> +				actual_buf);
> +		if (retval)
> +			goto no_optimize;
> +		if (ext2fs_bg_flags_test(fs, group, EXT2_BG_BLOCK_UNINIT))
> +			memset(bitmap_buf, 0, nbytes);
> +		else {
> +			retval = ext2fs_get_block_bitmap_range2(fs->block_map,
> +					B2C(i), fs->super->s_clusters_per_group,
> +					bitmap_buf);
> +			if (retval)
> +				goto no_optimize;
> +		}
> +		if (memcmp(actual_buf, bitmap_buf, nbytes) != 0)
> +			goto no_optimize;
> +		n = ext2fs_bitcount(actual_buf, nbytes);
> +		group_free = fs->super->s_clusters_per_group - n;
> +		free_blocks += group_free;
> +		i += fs->super->s_clusters_per_group - 1;
> +		goto next_group;
> +	no_optimize:
> +
>  		if (skip_group) {
> -			if ((B2C(i) - B2C(fs->super->s_first_data_block)) %
> -			    fs->super->s_clusters_per_group == 0) {
> +			if (first_block_in_bg) {
>  				super_blk = 0;
>  				old_desc_blk = 0;
>  				new_desc_blk = 0;
> @@ -401,6 +449,7 @@ redo_counts:
>  			if (!bitmap && i >= first_free)
>  				e2fsck_discard_blocks(ctx, first_free,
>  						      (i - first_free) + 1);
> +		next_group:
>  			first_free = ext2fs_blocks_count(fs->super);
>  
>  			free_array[group] = group_free;
> @@ -475,6 +524,8 @@ redo_counts:
>  	}
>  errout:
>  	ext2fs_free_mem(&free_array);
> +	ext2fs_free_mem(&actual_buf);
> +	ext2fs_free_mem(&bitmap_buf);
>  }
>  
>  static void check_inode_bitmaps(e2fsck_t ctx)
> 
