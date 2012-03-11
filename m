From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 4/5] libext2fs: Implement ext2fs_find_first_zero_generic_bmap().
Date: Sun, 11 Mar 2012 03:51:05 -0600
Message-ID: <5E845FD5-30E4-47A1-AF8E-70A288E3442D@dilger.ca>
References: <20120310213321.GK6961@sli.dy.fi> <20120310213740.GO6961@sli.dy.fi>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Sami Liedes <sami.liedes@iki.fi>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:60767 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab2CKJuy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 11 Mar 2012 05:50:54 -0400
In-Reply-To: <20120310213740.GO6961@sli.dy.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-03-10, at 2:37 PM, Sami Liedes wrote:
> From a58c07c019e4a7e6181f021ae022ebcdc5cce4e2 Mon Sep 17 00:00:00 2001
> From: Sami Liedes <sami.liedes@iki.fi>
> Date: Sat, 10 Mar 2012 22:36:12 +0200
> Subject: [PATCH] libext2fs: Implement ext2fs_find_first_zero_generic_bmap().
> 
> This function searches a bitmap for the first zero bit within a range.
> It checks if there is a bitmap backend specific implementation
> available (if the relevant field in bitmap_ops is non-NULL). If not,
> it uses a generic and slow method by repeatedly calling test_bmap() in
> a loop. Also change ext2fs_new_inode() to use this new function.
> 
> This change in itself does not result in a large speedup, rather it
> refactors the code in preparation for the introduction of a faster
> find_first_zero() for bitarray based bitmaps.

Rather than making the bitmap searching loop more efficient, I've always thought
it would be better to have an interface that iterates over the bitmap and returns
the next set bit.  It is similar to what you implemented with ->find_first_zero(),
but it would be better to have (IMHO) ->find_next_zero() and ->find_next_set().

This allows the internal bitmap implementation to do efficient walking of the
bitmap/tree/list and in cases where the bitmap is very sparse it can avoid a
lot of scanning.

> Signed-off-by: Sami Liedes <sami.liedes@iki.fi>
> 
> diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
> index eb4e0f5..1da9532 100644
> --- a/lib/ext2fs/alloc.c
> +++ b/lib/ext2fs/alloc.c
> @@ -109,7 +109,8 @@ errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t dir,
> 	ext2_ino_t	dir_group = 0;
> 	ext2_ino_t	i;
> 	ext2_ino_t	start_inode;
> -	ext2_ino_t	modulo;
> +	ext2_ino_t	modulo, upto, first_zero;
> +	errcode_t	err;
> 
> 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
> 
> @@ -128,16 +129,27 @@ errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t dir,
> 		return EXT2_ET_INODE_ALLOC_FAIL;
> 	i = start_inode;
> 	modulo = (i - 1) % EXT2_INODES_PER_GROUP(fs->super);
> -
> 	do {
> 		if (modulo == 0)
> 			check_inode_uninit(fs, map, (i - 1) /
> 					   EXT2_INODES_PER_GROUP(fs->super));
> 
> -		if (!ext2fs_fast_test_inode_bitmap2(map, i))
> +		upto = i + (EXT2_INODES_PER_GROUP(fs->super) - modulo);
> +		if (i < start_inode && upto >= start_inode)
> +			upto = start_inode - 1;
> +		if (upto > fs->super->s_inodes_count)
> +			upto = fs->super->s_inodes_count;
> +
> +		err = ext2fs_find_first_zero_inode_bitmap2(map, i, upto, &first_zero);
> +		if (!err) {
> +			i = first_zero;
> 			break;
> -		if (++modulo == EXT2_INODES_PER_GROUP(fs->super))
> -			modulo = 0;
> +		} else {
> +			if (err != ENOENT)
> +				return EXT2_ET_INODE_ALLOC_FAIL;
> +			i = upto;
> +		}
> +
> 		if (++i > fs->super->s_inodes_count) {
> 			i = EXT2_FIRST_INODE(fs->super);
> 			modulo = (i - 1) % EXT2_INODES_PER_GROUP(fs->super);
> diff --git a/lib/ext2fs/bitops.h b/lib/ext2fs/bitops.h
> index 83a01e4..70caa86 100644
> --- a/lib/ext2fs/bitops.h
> +++ b/lib/ext2fs/bitops.h
> @@ -188,6 +188,9 @@ extern void ext2fs_mark_block_bitmap_range2(ext2fs_block_bitmap bitmap,
> 					    blk64_t block, unsigned int num);
> extern void ext2fs_unmark_block_bitmap_range2(ext2fs_block_bitmap bitmap,
> 					      blk64_t block, unsigned int num);
> +extern errcode_t ext2fs_find_first_zero_generic_bmap(ext2fs_generic_bitmap bitmap,
> +						     __u64 start, __u64 end,
> +						     __u64 *out);
> 
> /*
>  * The inline routines themselves...
> @@ -593,6 +596,19 @@ _INLINE_ int ext2fs_fast_test_inode_bitmap2(ext2fs_inode_bitmap bitmap,
> 					inode);
> }
> 
> +_INLINE_ errcode_t ext2fs_find_first_zero_inode_bitmap2(ext2fs_inode_bitmap bitmap,
> +							ext2_ino_t start,
> +							ext2_ino_t end,
> +							ext2_ino_t *out)
> +{
> +	__u64 o;
> +	errcode_t rv = ext2fs_find_first_zero_generic_bmap((ext2fs_generic_bitmap) bitmap,
> +							   start, end, &o);
> +	if (!rv)
> +		*out = o;
> +	return rv;
> +}
> +
> _INLINE_ blk64_t ext2fs_get_block_bitmap_start2(ext2fs_block_bitmap bitmap)
> {
> 	return ext2fs_get_generic_bmap_start((ext2fs_generic_bitmap) bitmap);
> diff --git a/lib/ext2fs/bmap64.h b/lib/ext2fs/bmap64.h
> index 288e1b6..f44d379 100644
> --- a/lib/ext2fs/bmap64.h
> +++ b/lib/ext2fs/bmap64.h
> @@ -89,6 +89,11 @@ struct ext2_bitmap_ops {
> 				    __u64 start, size_t num, void *out);
> 	void (*clear_bmap)(ext2fs_generic_bitmap bitmap);
> 	void (*print_stats)(ext2fs_generic_bitmap);
> +
> +	/* Find the first zero bit between start and end, inclusive.
> +	 * May be NULL, in which case a generic function is used. */
> +	errcode_t (*find_first_zero)(ext2fs_generic_bitmap bitmap,
> +				     __u64 start, __u64 end, __u64 *out);
> };
> 
> extern struct ext2_bitmap_ops ext2fs_blkmap64_bitarray;
> diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
> index fa8d7b7..b57df54 100644
> --- a/lib/ext2fs/gen_bitmap64.c
> +++ b/lib/ext2fs/gen_bitmap64.c
> @@ -762,3 +762,31 @@ errcode_t ext2fs_convert_subcluster_bitmap(ext2_filsys fs,
> 	*bitmap = cmap;
> 	return 0;
> }
> +
> +errcode_t ext2fs_find_first_zero_generic_bmap(ext2fs_generic_bitmap bitmap,
> +					      __u64 start, __u64 end, __u64 *out)
> +{
> +	int b;
> +
> +	if (bitmap->bitmap_ops->find_first_zero)
> +		return bitmap->bitmap_ops->find_first_zero(bitmap, start, end, out);
> +
> +	if (!bitmap || !EXT2FS_IS_64_BITMAP(bitmap) || bitmap->cluster_bits)
> +		return EINVAL;
> +
> +	if (start < bitmap->start || end > bitmap->end || start > end) {
> +		warn_bitmap(bitmap, EXT2FS_TEST_ERROR, start);
> +		return EINVAL;
> +	}
> +
> +	while (start <= end) {
> +		b = bitmap->bitmap_ops->test_bmap(bitmap, start);
> +		if (!b) {
> +			*out = start;
> +			return 0;
> +		}
> +		start++;
> +	}
> +
> +	return ENOENT;
> +}


Cheers, Andreas





