From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 10/10] libext2fs: add bitmap statistics
Date: Mon, 19 Dec 2011 12:43:17 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1112191242380.30656@dhcp-27-109.brq.redhat.com>
References: <1324190558-7436-1-git-send-email-tytso@mit.edu> <1324190558-7436-11-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Lukas Czerner <lczerner@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077Ab1LSLnW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Dec 2011 06:43:22 -0500
In-Reply-To: <1324190558-7436-11-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 18 Dec 2011, Theodore Ts'o wrote:

> From: Lukas Czerner <lczerner@redhat.com>
> 
> This feature is especially useful for better understanding how e2fsprogs
> tools (mainly e2fsck) treats bitmaps and what bitmap backend can be most
> suitable for particular bitmap. Backend itself (if implemented) can
> provide statistics of its own as well.
> 
> [ Changed to provide basic statistics when enabled with the
>   E2FSPROGS_BITMAPS_STATS environment variable -- tytso]

Actually it is 'E2FSPROGS_BITMAP_STATS' so BITMAP instead of BITMAPS,
not sure what was intended.

-Lukas

> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  lib/ext2fs/blkmap64_ba.c  |    8 +++
>  lib/ext2fs/blkmap64_rb.c  |   85 ++++++++++++++++++++++++++-
>  lib/ext2fs/bmap64.h       |   32 ++++++++++
>  lib/ext2fs/ext2fs.h       |    4 +
>  lib/ext2fs/gen_bitmap64.c |  140 +++++++++++++++++++++++++++++++++++++++++++-
>  lib/ext2fs/icount.c       |    4 +-
>  6 files changed, 265 insertions(+), 8 deletions(-)
> 
> diff --git a/lib/ext2fs/blkmap64_ba.c b/lib/ext2fs/blkmap64_ba.c
> index 9253af2..3f0c643 100644
> --- a/lib/ext2fs/blkmap64_ba.c
> +++ b/lib/ext2fs/blkmap64_ba.c
> @@ -310,6 +310,13 @@ static void ba_clear_bmap(ext2fs_generic_bitmap bitmap)
>  	       (size_t) (((bitmap->real_end - bitmap->start) / 8) + 1));
>  }
>  
> +static void ba_print_stats(ext2fs_generic_bitmap bitmap)
> +{
> +	fprintf(stderr, "%16llu Bytes used by bitarray\n",
> +		((bitmap->real_end - bitmap->start) >> 3) + 1 +
> +		sizeof(struct ext2fs_ba_private_struct));
> +}
> +
>  struct ext2_bitmap_ops ext2fs_blkmap64_bitarray = {
>  	.type = EXT2FS_BMAP64_BITARRAY,
>  	.new_bmap = ba_new_bmap,
> @@ -325,4 +332,5 @@ struct ext2_bitmap_ops ext2fs_blkmap64_bitarray = {
>  	.set_bmap_range = ba_set_bmap_range,
>  	.get_bmap_range = ba_get_bmap_range,
>  	.clear_bmap = ba_clear_bmap,
> +	.print_stats = ba_print_stats,
>  };
> diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
> index 31fc393..aba7cfd 100644
> --- a/lib/ext2fs/blkmap64_rb.c
> +++ b/lib/ext2fs/blkmap64_rb.c
> @@ -40,6 +40,10 @@ struct ext2fs_rb_private {
>  	struct rb_root root;
>  	struct bmap_rb_extent **wcursor;
>  	struct bmap_rb_extent **rcursor;
> +#ifdef BMAP_STATS_OPS
> +	__u64 mark_hit;
> +	__u64 test_hit;
> +#endif
>  };
>  
>  static int rb_insert_extent(__u64 start, __u64 count,
> @@ -170,6 +174,11 @@ static errcode_t rb_alloc_private_data (ext2fs_generic_bitmap bitmap)
>  	*bp->rcursor = NULL;
>  	*bp->wcursor = NULL;
>  
> +#ifdef BMAP_STATS_OPS
> +	bp->test_hit = 0;
> +	bp->mark_hit = 0;
> +#endif
> +
>  	bitmap->private = (void *) bp;
>  	return 0;
>  }
> @@ -315,8 +324,12 @@ rb_test_bit(struct ext2fs_rb_private *bp, __u64 bit)
>  	if (!rcursor)
>  		goto search_tree;
>  
> -	if (bit >= rcursor->start && bit < rcursor->start + rcursor->count)
> +	if (bit >= rcursor->start && bit < rcursor->start + rcursor->count) {
> +#ifdef BMAP_STATS_OPS
> +		bp->test_hit++;
> +#endif
>  		return 1;
> +	}
>  
>  	rcursor = *bp->wcursor;
>  	if (!rcursor)
> @@ -355,8 +368,12 @@ static int rb_insert_extent(__u64 start, __u64 count,
>  	ext = *bp->wcursor;
>  	if (ext) {
>  		if (start >= ext->start &&
> -		    start <= (ext->start + ext->count))
> +		    start <= (ext->start + ext->count)) {
> +#ifdef BMAP_STATS_OPS
> +			bp->mark_hit++;
> +#endif
>  			goto got_extent;
> +		}
>  	}
>  
>  	while (*n) {
> @@ -725,6 +742,69 @@ static void rb_clear_bmap(ext2fs_generic_bitmap bitmap)
>  	*bp->wcursor = NULL;
>  }
>  
> +#ifdef BMAP_STATS
> +static void rb_print_stats(ext2fs_generic_bitmap bitmap)
> +{
> +	struct ext2fs_rb_private *bp;
> +	struct rb_node *node = NULL;
> +	struct bmap_rb_extent *ext;
> +	__u64 count = 0;
> +	__u64 max_size = 0;
> +	__u64 min_size = ULONG_MAX;
> +	__u64 size = 0, avg_size = 0;
> +	__u64 mark_all, test_all;
> +	double eff, m_hit = 0.0, t_hit = 0.0;
> +
> +	bp = (struct ext2fs_rb_private *) bitmap->private;
> +
> +	node = ext2fs_rb_first(&bp->root);
> +	for (node = ext2fs_rb_first(&bp->root); node != NULL;
> +	     node = ext2fs_rb_next(node)) {
> +		ext = ext2fs_rb_entry(node, struct bmap_rb_extent, node);
> +		count++;
> +		if (ext->count > max_size)
> +			max_size = ext->count;
> +		if (ext->count < min_size)
> +			min_size = ext->count;
> +		size += ext->count;
> +	}
> +
> +	if (count)
> +		avg_size = size / count;
> +	if (min_size == ULONG_MAX)
> +		min_size = 0;
> +	eff = (double)((count * sizeof(struct bmap_rb_extent)) << 3) /
> +	      (bitmap->real_end - bitmap->start);
> +#ifdef BMAP_STATS_OPS
> +	mark_all = bitmap->stats.mark_count + bitmap->stats.mark_ext_count;
> +	test_all = bitmap->stats.test_count + bitmap->stats.test_ext_count;
> +	if (mark_all)
> +		m_hit = ((double)bp->mark_hit / mark_all) * 100;
> +	if (test_all)
> +		t_hit = ((double)bp->test_hit / test_all) * 100;
> +
> +	fprintf(stderr, "%16llu cache hits on test (%.2f%%)\n"
> +		"%16llu cache hits on mark (%.2f%%)\n",
> +		bp->test_hit, t_hit, bp->mark_hit, m_hit);
> +#endif
> +	fprintf(stderr, "%16llu extents (%llu bytes)\n",
> +		count, ((count * sizeof(struct bmap_rb_extent)) +
> +			sizeof(struct ext2fs_rb_private)));
> + 	fprintf(stderr, "%16llu bits minimum size\n",
> +		min_size);
> +	fprintf(stderr, "%16llu bits maximum size\n"
> +		"%16llu bits average size\n",
> +		max_size, avg_size);
> +	fprintf(stderr, "%16llu bits set in bitmap (out of %llu)\n", size,
> +		bitmap->real_end - bitmap->start);
> +	fprintf(stderr,
> +		"%16.4lf memory / bitmap bit memory ratio (bitarray = 1)\n",
> +		eff);
> +}
> +#else
> +static void rb_print_stats(ext2fs_generic_bitmap bitmap){}
> +#endif
> +
>  struct ext2_bitmap_ops ext2fs_blkmap64_rbtree = {
>  	.type = EXT2FS_BMAP64_RBTREE,
>  	.new_bmap = rb_new_bmap,
> @@ -740,4 +820,5 @@ struct ext2_bitmap_ops ext2fs_blkmap64_rbtree = {
>  	.set_bmap_range = rb_set_bmap_range,
>  	.get_bmap_range = rb_get_bmap_range,
>  	.clear_bmap = rb_clear_bmap,
> +	.print_stats = rb_print_stats,
>  };
> diff --git a/lib/ext2fs/bmap64.h b/lib/ext2fs/bmap64.h
> index 21d24ad..288e1b6 100644
> --- a/lib/ext2fs/bmap64.h
> +++ b/lib/ext2fs/bmap64.h
> @@ -9,6 +9,34 @@
>   * %End-Header%
>   */
>  
> +struct ext2_bmap_statistics {
> +	int		type;
> +	struct timeval	created;
> +
> +#ifdef BMAP_STATS_OPS
> +	unsigned long	copy_count;
> +	unsigned long	resize_count;
> +	unsigned long	mark_count;
> +	unsigned long	unmark_count;
> +	unsigned long	test_count;
> +	unsigned long	mark_ext_count;
> +	unsigned long	unmark_ext_count;
> +	unsigned long	test_ext_count;
> +	unsigned long	set_range_count;
> +	unsigned long	get_range_count;
> +	unsigned long	clear_count;
> +
> +	blk64_t		last_marked;
> +	blk64_t		last_tested;
> +	blk64_t		mark_back;
> +	blk64_t		test_back;
> +
> +	unsigned long	mark_seq;
> +	unsigned long	test_seq;
> +#endif /* BMAP_STATS_OPS */
> +};
> +
> +
>  struct ext2fs_struct_generic_bitmap {
>  	errcode_t		magic;
>  	ext2_filsys 		fs;
> @@ -20,6 +48,9 @@ struct ext2fs_struct_generic_bitmap {
>  	char			*description;
>  	void			*private;
>  	errcode_t		base_error_code;
> +#ifdef BMAP_STATS
> +	struct ext2_bmap_statistics	stats;
> +#endif
>  };
>  
>  #define EXT2FS_IS_32_BITMAP(bmap) \
> @@ -57,6 +88,7 @@ struct ext2_bitmap_ops {
>  	errcode_t (*get_bmap_range)(ext2fs_generic_bitmap bitmap,
>  				    __u64 start, size_t num, void *out);
>  	void (*clear_bmap)(ext2fs_generic_bitmap bitmap);
> +	void (*print_stats)(ext2fs_generic_bitmap);
>  };
>  
>  extern struct ext2_bitmap_ops ext2fs_blkmap64_bitarray;
> diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> index 3f8333f..7343090 100644
> --- a/lib/ext2fs/ext2fs.h
> +++ b/lib/ext2fs/ext2fs.h
> @@ -1168,6 +1168,10 @@ extern errcode_t ext2fs_set_generic_bitmap_range(ext2fs_generic_bitmap bmap,
>  						 void *in);
>  
>  /* gen_bitmap64.c */
> +
> +/* Generate and print bitmap usage statistics */
> +#define BMAP_STATS
> +
>  void ext2fs_free_generic_bmap(ext2fs_generic_bitmap bmap);
>  errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
>  				    int type, __u64 start, __u64 end,
> diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
> index 9dcca03..bf1a76b 100644
> --- a/lib/ext2fs/gen_bitmap64.c
> +++ b/lib/ext2fs/gen_bitmap64.c
> @@ -77,6 +77,12 @@ static void warn_bitmap(ext2fs_generic_bitmap bitmap,
>  #endif
>  }
>  
> +#ifdef BMAP_STATS_OPS
> +#define INC_STAT(map, name) map->stats.name
> +#else
> +#define INC_STAT(map, name) ;;
> +#endif
> +
>  
>  errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
>  				    int type, __u64 start, __u64 end,
> @@ -110,11 +116,20 @@ errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
>  		return EINVAL;
>  	}
>  
> -	retval = ext2fs_get_mem(sizeof(struct ext2fs_struct_generic_bitmap),
> -				&bitmap);
> +	retval = ext2fs_get_memzero(sizeof(struct ext2fs_struct_generic_bitmap),
> +				    &bitmap);
>  	if (retval)
>  		return retval;
>  
> +#ifdef BMAP_STATS
> +	if (gettimeofday(&bitmap->stats.created,
> +			 (struct timezone *) NULL) == -1) {
> +		perror("gettimeofday");
> +		return 1;
> +	}
> +	bitmap->stats.type = type;
> +#endif
> +
>  	/* XXX factor out, repeated in copy_bmap */
>  	bitmap->magic = magic;
>  	bitmap->fs = fs;
> @@ -155,6 +170,71 @@ errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
>  	return 0;
>  }
>  
> +#ifdef BMAP_STATS
> +void ext2fs_print_bmap_statistics(ext2fs_generic_bitmap bitmap)
> +{
> +	struct ext2_bmap_statistics *stats = &bitmap->stats;
> +	float mark_seq_perc = 0.0, test_seq_perc = 0.0;
> +	float mark_back_perc = 0.0, test_back_perc = 0.0;
> +	double inuse;
> +	struct timeval now;
> +
> +#ifdef BMAP_STATS_OPS
> +	if (stats->test_count) {
> +		test_seq_perc = ((float)stats->test_seq /
> +				 stats->test_count) * 100;
> +		test_back_perc = ((float)stats->test_back /
> +				  stats->test_count) * 100;
> +	}
> +
> +	if (stats->mark_count) {
> +		mark_seq_perc = ((float)stats->mark_seq /
> +				 stats->mark_count) * 100;
> +		mark_back_perc = ((float)stats->mark_back /
> +				  stats->mark_count) * 100;
> +	}
> +#endif
> +
> +	if (gettimeofday(&now, (struct timezone *) NULL) == -1) {
> +		perror("gettimeofday");
> +		return;
> +	}
> +
> +	inuse = (double) now.tv_sec + \
> +		(((double) now.tv_usec) * 0.000001);
> +	inuse -= (double) stats->created.tv_sec + \
> +		(((double) stats->created.tv_usec) * 0.000001);
> +
> +	fprintf(stderr, "\n[+] %s bitmap (type %d)\n", bitmap->description,
> +		stats->type);
> +	fprintf(stderr, "=================================================\n");
> +#ifdef BMAP_STATS_OPS
> +	fprintf(stderr, "%16llu bits long\n",
> +		bitmap->real_end - bitmap->start);
> +	fprintf(stderr, "%16lu copy_bmap\n%16lu resize_bmap\n",
> +		stats->copy_count, stats->resize_count);
> +	fprintf(stderr, "%16lu mark bmap\n%16lu unmark_bmap\n",
> +		stats->mark_count, stats->unmark_count);
> +	fprintf(stderr, "%16lu test_bmap\n%16lu mark_bmap_extent\n",
> +		stats->test_count, stats->mark_ext_count);
> +	fprintf(stderr, "%16lu unmark_bmap_extent\n"
> +		"%16lu test_clear_bmap_extent\n",
> +		stats->unmark_ext_count, stats->test_ext_count);
> +	fprintf(stderr, "%16lu set_bmap_range\n%16lu set_bmap_range\n",
> +		stats->set_range_count, stats->get_range_count);
> +	fprintf(stderr, "%16lu clear_bmap\n%16lu contiguous bit test (%.2f%%)\n",
> +		stats->clear_count, stats->test_seq, test_seq_perc);
> +	fprintf(stderr, "%16lu contiguous bit mark (%.2f%%)\n"
> +		"%16llu bits tested backwards (%.2f%%)\n",
> +		stats->mark_seq, mark_seq_perc,
> +		stats->test_back, test_back_perc);
> +	fprintf(stderr, "%16llu bits marked backwards (%.2f%%)\n"
> +		"%16.2f seconds in use\n",
> +		stats->mark_back, mark_back_perc, inuse);
> +#endif /* BMAP_STATS_OPS */
> +}
> +#endif
> +
>  void ext2fs_free_generic_bmap(ext2fs_generic_bitmap bmap)
>  {
>  	if (!bmap)
> @@ -168,6 +248,13 @@ void ext2fs_free_generic_bmap(ext2fs_generic_bitmap bmap)
>  	if (!EXT2FS_IS_64_BITMAP(bmap))
>  		return;
>  
> +#ifdef BMAP_STATS
> +	if (getenv("E2FSPROGS_BITMAP_STATS")) {
> +		ext2fs_print_bmap_statistics(bmap);
> +		bmap->bitmap_ops->print_stats(bmap);
> +	}
> +#endif
> +
>  	bmap->bitmap_ops->free_bmap(bmap);
>  
>  	if (bmap->description) {
> @@ -195,11 +282,24 @@ errcode_t ext2fs_copy_generic_bmap(ext2fs_generic_bitmap src,
>  		return EINVAL;
>  
>  	/* Allocate a new bitmap struct */
> -	retval = ext2fs_get_mem(sizeof(struct ext2fs_struct_generic_bitmap),
> -				&new_bmap);
> +	retval = ext2fs_get_memzero(sizeof(struct ext2fs_struct_generic_bitmap),
> +				    &new_bmap);
>  	if (retval)
>  		return retval;
>  
> +
> +#ifdef BMAP_STATS_OPS
> +	src->stats.copy_count++;
> +#endif
> +#ifdef BMAP_STATS
> +	if (gettimeofday(&new_bmap->stats.created,
> +			 (struct timezone *) NULL) == -1) {
> +		perror("gettimeofday");
> +		return 1;
> +	}
> +	new_bmap->stats.type = src->stats.type;
> +#endif
> +
>  	/* Copy all the high-level parts over */
>  	new_bmap->magic = src->magic;
>  	new_bmap->fs = src->fs;
> @@ -247,6 +347,8 @@ errcode_t ext2fs_resize_generic_bmap(ext2fs_generic_bitmap bmap,
>  	if (!EXT2FS_IS_64_BITMAP(bmap))
>  		return EINVAL;
>  
> +	INC_STAT(bmap, resize_count);
> +
>  	return bmap->bitmap_ops->resize_bmap(bmap, new_end, new_real_end);
>  }
>  
> @@ -335,6 +437,15 @@ int ext2fs_mark_generic_bmap(ext2fs_generic_bitmap bitmap,
>  
>  	arg >>= bitmap->cluster_bits;
>  
> +#ifdef BMAP_STATS_OPS
> +	if (arg == bitmap->stats.last_marked + 1)
> +		bitmap->stats.mark_seq++;
> +	if (arg < bitmap->stats.last_marked)
> +		bitmap->stats.mark_back++;
> +	bitmap->stats.last_marked = arg;
> +	bitmap->stats.mark_count++;
> +#endif
> +
>  	if ((arg < bitmap->start) || (arg > bitmap->end)) {
>  		warn_bitmap(bitmap, EXT2FS_MARK_ERROR, arg);
>  		return 0;
> @@ -363,6 +474,8 @@ int ext2fs_unmark_generic_bmap(ext2fs_generic_bitmap bitmap,
>  
>  	arg >>= bitmap->cluster_bits;
>  
> +	INC_STAT(bitmap, unmark_count);
> +
>  	if ((arg < bitmap->start) || (arg > bitmap->end)) {
>  		warn_bitmap(bitmap, EXT2FS_UNMARK_ERROR, arg);
>  		return 0;
> @@ -391,6 +504,15 @@ int ext2fs_test_generic_bmap(ext2fs_generic_bitmap bitmap,
>  
>  	arg >>= bitmap->cluster_bits;
>  
> +#ifdef BMAP_STATS_OPS
> +	bitmap->stats.test_count++;
> +	if (arg == bitmap->stats.last_tested + 1)
> +		bitmap->stats.test_seq++;
> +	if (arg < bitmap->stats.last_tested)
> +		bitmap->stats.test_back++;
> +	bitmap->stats.last_tested = arg;
> +#endif
> +
>  	if ((arg < bitmap->start) || (arg > bitmap->end)) {
>  		warn_bitmap(bitmap, EXT2FS_TEST_ERROR, arg);
>  		return 0;
> @@ -419,6 +541,8 @@ errcode_t ext2fs_set_generic_bmap_range(ext2fs_generic_bitmap bmap,
>  	if (!EXT2FS_IS_64_BITMAP(bmap))
>  		return EINVAL;
>  
> +	INC_STAT(bmap, set_range_count);
> +
>  	return bmap->bitmap_ops->set_bmap_range(bmap, start, num, in);
>  }
>  
> @@ -442,6 +566,8 @@ errcode_t ext2fs_get_generic_bmap_range(ext2fs_generic_bitmap bmap,
>  	if (!EXT2FS_IS_64_BITMAP(bmap))
>  		return EINVAL;
>  
> +	INC_STAT(bmap, get_range_count);
> +
>  	return bmap->bitmap_ops->get_bmap_range(bmap, start, num, out);
>  }
>  
> @@ -513,6 +639,8 @@ int ext2fs_test_block_bitmap_range2(ext2fs_block_bitmap bmap,
>  	if (!EXT2FS_IS_64_BITMAP(bmap))
>  		return EINVAL;
>  
> +	INC_STAT(bmap, test_ext_count);
> +
>  	return bmap->bitmap_ops->test_clear_bmap_extent(bmap, block, num);
>  }
>  
> @@ -535,6 +663,8 @@ void ext2fs_mark_block_bitmap_range2(ext2fs_block_bitmap bmap,
>  	if (!EXT2FS_IS_64_BITMAP(bmap))
>  		return;
>  
> +	INC_STAT(bmap, mark_ext_count);
> +
>  	if ((block < bmap->start) || (block+num-1 > bmap->end)) {
>  		ext2fs_warn_bitmap(EXT2_ET_BAD_BLOCK_MARK, block,
>  				   bmap->description);
> @@ -563,6 +693,8 @@ void ext2fs_unmark_block_bitmap_range2(ext2fs_block_bitmap bmap,
>  	if (!EXT2FS_IS_64_BITMAP(bmap))
>  		return;
>  
> +	INC_STAT(bmap, unmark_ext_count);
> +
>  	if ((block < bmap->start) || (block+num-1 > bmap->end)) {
>  		ext2fs_warn_bitmap(EXT2_ET_BAD_BLOCK_UNMARK, block,
>  				   bmap->description);
> diff --git a/lib/ext2fs/icount.c b/lib/ext2fs/icount.c
> index 5d64ac4..8b46eda 100644
> --- a/lib/ext2fs/icount.c
> +++ b/lib/ext2fs/icount.c
> @@ -104,12 +104,12 @@ static errcode_t alloc_icount(ext2_filsys fs, int flags, ext2_icount_t *ret)
>  		return retval;
>  	memset(icount, 0, sizeof(struct ext2_icount));
>  
> -	retval = ext2fs_allocate_inode_bitmap(fs, 0, &icount->single);
> +	retval = ext2fs_allocate_inode_bitmap(fs, "icount", &icount->single);
>  	if (retval)
>  		goto errout;
>  
>  	if (flags & EXT2_ICOUNT_OPT_INCREMENT) {
> -		retval = ext2fs_allocate_inode_bitmap(fs, 0,
> +		retval = ext2fs_allocate_inode_bitmap(fs, "icount_inc",
>  						      &icount->multiple);
>  		if (retval)
>  			goto errout;
> 

-- 
