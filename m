From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [CALL FOR TESTING] Make Ext3 fsck way faster [2.6.24-rc6 -mm
 patch]
Date: Mon, 14 Jan 2008 16:34:12 -0800
Message-ID: <20080114163412.83a8b18d.akpm@linux-foundation.org>
References: <200801140839.01986.abhishekrai@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, rohitseth@google.com,
	linux-ext4@vger.kernel.org
To: Abhishek Rai <abhishekrai@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46056 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750991AbYAOAeV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jan 2008 19:34:21 -0500
In-Reply-To: <200801140839.01986.abhishekrai@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 14 Jan 2008 08:39:01 -0500
Abhishek Rai <abhishekrai@google.com> wrote:

> This is the patch for 2.6.24-rc6 -mm tree, please let me know if anyone would like a patch against another recent kernel. Ingo Molnar has already posted a patch for 2.6.24-rc7.
> 

Please always retain and maintain the full changelog with each version of a
patch.  The changelog in your earlier "Clustering indirect blocks in Ext3"
patch was good.  I retained that (after renaming it to "ext3: indirect
block clustering" rather than this dopey name) and then, err, dropped the
patch ;)

Please cc linux-ext4 on ext2/3/4-related work.

Please update Documentation/filesystems/ext3.txt when adding new mount
options.

Here's a quick low-levelish nitpickingish implementation review.  I haven't
thought about the design-level things yet.

This code will need careful checking regarding the journalling side of
things - to verify that if the machine crashes at any stage, recovery will
produce a consistent and secure fs.  It is all-nigh impossible to spot bugs
in this area via the usual kernel bug reporting process and it is very hard
to effectively runtime test recovery even in a development situation. 
Careful review unusually important here.

> +/
> + * Count number of free blocks in a block group that don't lie in the
> + * metacluster region of the block group.
> + */
> +static void
> +ext3_init_grp_free_nonmc_blocks(struct super_block *sb,
> +				struct buffer_head *bitmap_bh,
> +				unsigned long block_group)
> +{
> +	struct ext3_sb_info *sbi = EXT3_SB(sb);
> +	struct ext3_bg_info *bgi = &sbi->s_bginfo[block_group];
> +
> +	BUG_ON(!test_opt(sb, METACLUSTER));
> +
> +	spin_lock(sb_bgl_lock(sbi, block_group));
> +	if (bgi->bgi_free_nonmc_blocks_count >= 0)
> +		goto out;
> +
> +	bgi->bgi_free_nonmc_blocks_count =
> +		ext3_count_free(bitmap_bh, sbi->s_nonmc_blocks_per_group/8);
> +
> +out:
> +	spin_unlock(sb_bgl_lock(sbi, block_group));
> +	BUG_ON(bgi->bgi_free_nonmc_blocks_count >
> +		sbi->s_nonmc_blocks_per_group);
> +}

hm, so ext3_count_free() hits prime time.

ext3_count_free() should be converted to use the standard hweight8(). 
Really it should be converted to hweight_long() or hweight32() or something
- it is presently probably inefficient.

This function appears to be called frequently and it calls the slow-looking
ext3_count_free() under spinlock.  This might have scalability problems on
the right machine running the right workload.

Can we address that before we hit it?

> +/*
> + * ext3_update_nonmc_block_count:
> + *	Update bgi_free_nonmc_blocks_count for block group 'group_no' following
> + *	an allocation or deallocation.
> + *
> + *	@group_no:	affected block group
> + *	@start:		start of the [de]allocated range
> + *	@count:		number of blocks [de]allocated
> + *	@allocation:	1 if blocks were allocated, 0 otherwise.
> + */
> +static inline void
> +ext3_update_nonmc_block_count(struct ext3_sb_info *sbi, unsigned long group_no,
> +				ext3_grpblk_t start, unsigned long count,
> +				int allocation)
> +{
> +	struct ext3_bg_info *bginfo = &sbi->s_bginfo[group_no];
> +	ext3_grpblk_t change;
> +
> +	BUG_ON(bginfo->bgi_free_nonmc_blocks_count < 0);
> +	BUG_ON(start >= sbi->s_nonmc_blocks_per_group);
> +
> +	change = min_t(ext3_grpblk_t, start + count,
> +			sbi->s_nonmc_blocks_per_group) - start;
> +
> +	spin_lock(sb_bgl_lock(sbi, group_no));
> +	BUG_ON(bginfo->bgi_free_nonmc_blocks_count >
> +		sbi->s_nonmc_blocks_per_group);
> +	BUG_ON(allocation && bginfo->bgi_free_nonmc_blocks_count < change);
> +
> +	bginfo->bgi_free_nonmc_blocks_count += (allocation ? -change : change);
> +
> +	BUG_ON(bginfo->bgi_free_nonmc_blocks_count >
> +		sbi->s_nonmc_blocks_per_group);
> +	spin_unlock(sb_bgl_lock(sbi, group_no));
> +}

Far too large to inline.  Please just remove all inlines from the patch. 
The compiler will sort it out.

> +static ext3_grpblk_t
> +bitmap_find_prev_zero_bit(char *map, ext3_grpblk_t start, ext3_grpblk_t lowest)
> +{
> +	ext3_grpblk_t k, blk;
> +
> +	k = start & ~7;
> +	while (lowest <= k) {
> +		if (map[k/8] != '\255' &&
> +			(blk = ext3_find_next_zero_bit(map, k + 8, k))
> +			 < (k + 8))
> +				return blk;
> +
> +		k -= 8;
> +	}
> +	return -1;
> +}

Please rename `k' to something meaningful.

The logic in here looks odd.  If (map[k/8] != 0xff) then the
ext3_find_next_zero_bit() cannot fail.  So why do we test for it in this
fashion?

Perhaps some commnetary is needed here.

> +static ext3_grpblk_t
> +bitmap_search_prev_usable_block(ext3_grpblk_t start, struct buffer_head *bh,
> +					ext3_grpblk_t lowest)
> +{
> +	ext3_grpblk_t next;
> +	struct journal_head *jh = bh2jh(bh);
> +
> +	/*
> +	 * The bitmap search --- search backward alternately through the actual
> +	 * bitmap and the last-committed copy until we find a bit free in
> +	 * both
> +	 */
> +	while (start >= lowest) {

Little style nit: in bitmap_find_prev_zero_bit() you used (lowest < k)
which is a little surprising but I assumeed that you were following the (a
< b < c) layout.  But here you're not doing that.


> +		next = bitmap_find_prev_zero_bit(bh->b_data, start, lowest);
> +		if (next < lowest)
> +			return -1;
> +		if (ext3_test_allocatable(next, bh))
> +			return next;
> +		jbd_lock_bh_state(bh);
> +		if (jh->b_committed_data)
> +			start = bitmap_find_prev_zero_bit(jh->b_committed_data,
> +								next, lowest);
> +		jbd_unlock_bh_state(bh);
> +	}
> +	return -1;
> +}
>
> ...
>
> +int ext3_alloc_indirect_blocks(struct super_block *sb,
> +			struct buffer_head *bitmap_bh,
> +			struct ext3_group_desc *gdp,
> +			int group_no, unsigned long indirect_blks,
> +			ext3_fsblk_t new_blocks[])
> +{
> +	struct ext3_bg_info *bgi = &EXT3_SB(sb)->s_bginfo[group_no];
> +	ext3_grpblk_t blk = EXT3_BLOCKS_PER_GROUP(sb) - 1;
> +	ext3_grpblk_t mc_start = EXT3_SB(sb)->s_nonmc_blocks_per_group;
> +	ext3_fsblk_t group_first_block;
> +	int allocated = 0;
> +
> +	BUG_ON(!test_opt(sb, METACLUSTER));
> +
> +	/* This check is racy but that wouldn't harm us. */
> +	if (bgi->bgi_free_nonmc_blocks_count >=
> +		le16_to_cpu(gdp->bg_free_blocks_count))
> +		return 0;
> +
> +	group_first_block = ext3_group_first_block_no(sb, group_no);
> +	while (allocated < indirect_blks && blk >= mc_start) {
> +		if (!ext3_test_allocatable(blk, bitmap_bh)) {
> +			blk = bitmap_search_prev_usable_block(blk, bitmap_bh,
> +								mc_start);
> +			continue;
> +		}
> +		if (claim_block(sb_bgl_lock(EXT3_SB(sb), group_no), blk,
> +				bitmap_bh)) {
> +			new_blocks[allocated++] = group_first_block + blk;
> +		} else {
> +			/*
> +			 * The block was allocated by another thread, or it
> +			 * was allocated and then freed by another thread
> +			 */
> +			cpu_relax();

Whoa.  The first ever use of cpu_relax in a filesystem (apart from sysfs,
but that's hardy endorsement).

What are you trying to do here?  Why was this needed?

> +		}
> +		if (allocated < indirect_blks)
> +			blk = bitmap_search_prev_usable_block(blk, bitmap_bh,
> +								mc_start);
> +	}
> +	return allocated;
> +}
> +
> +/*
> + * check_allocated_blocks:
> + * 	Helper function for ext3_new_blocks. Checks newly allocated block
> + * 	numbers.
> + */
> +int check_allocated_blocks(ext3_fsblk_t blk, unsigned long num,
> +				struct super_block *sb, int group_no,
> +				struct ext3_group_desc *gdp,
> +				struct buffer_head *bitmap_bh)
> +{
> +	struct ext3_super_block *es = EXT3_SB(sb)->s_es;
> +	struct ext3_sb_info *sbi = EXT3_SB(sb);
> +	ext3_fsblk_t grp_blk = blk - ext3_group_first_block_no(sb, group_no);
> +
> +	if (in_range(le32_to_cpu(gdp->bg_block_bitmap), blk, num) ||
> +		in_range(le32_to_cpu(gdp->bg_inode_bitmap), blk, num) ||
> +		in_range(blk, le32_to_cpu(gdp->bg_inode_table),
> +				EXT3_SB(sb)->s_itb_per_group) ||
> +		in_range(blk + num - 1, le32_to_cpu(gdp->bg_inode_table),
> +				EXT3_SB(sb)->s_itb_per_group)) {
> +		ext3_error(sb, "ext3_new_blocks",
> +				"Allocating block in system zone - "
> +				"blocks from "E3FSBLK", length %lu",
> +				blk, num);
> +		return 1;
> +	}
> +
> +#ifdef CONFIG_JBD_DEBUG
> +	{
> +		struct buffer_head *debug_bh;
> +
> +		/* Record bitmap buffer state in the newly allocated block */
> +		debug_bh = sb_find_get_block(sb, blk);
> +		if (debug_bh) {
> +			BUFFER_TRACE(debug_bh, "state when allocated");
> +			BUFFER_TRACE2(debug_bh, bitmap_bh, "bitmap state");
> +			brelse(debug_bh);
> +		}
> +	}
> +	jbd_lock_bh_state(bitmap_bh);
> +	spin_lock(sb_bgl_lock(sbi, group_no));
> +	if (buffer_jbd(bitmap_bh) && bh2jh(bitmap_bh)->b_committed_data) {
> +		int i;
> +
> +		for (i = 0; i < num; i++) {
> +			if (ext3_test_bit(grp_blk+i,
> +					bh2jh(bitmap_bh)->b_committed_data))
> +				printk(KERN_ERR "%s: block was unexpectedly set"
> +					" in b_committed_data\n", __FUNCTION__);
> +		}
> +	}
> +	ext3_debug("found bit %d\n", grp_blk);
> +	spin_unlock(sb_bgl_lock(sbi, group_no));
> +	jbd_unlock_bh_state(bitmap_bh);
> +#endif

Has the CONFIG_JBD_DEBUG=y code been tested?

> +
> +	if (blk + num - 1 >= le32_to_cpu(es->s_blocks_count)) {
> +		ext3_error(sb, "ext3_new_blocks",
> +				"block("E3FSBLK") >= blocks count(%d) - "
> +				"block_group = %d, es == %p ", blk,
> +				le32_to_cpu(es->s_blocks_count), group_no, es);
> +		return 1;
> +	}
> +
> +	return 0;
> +}
>
> ...
>
> +				- (indirect_blks_done + grp_mc_alloc);
>  		grp_alloc_blk = ext3_try_to_allocate_with_rsv(sb, handle,
> -					group_no, bitmap_bh, -1, my_rsv,
> -					&num, &fatal);
> +					group_no, bitmap_bh, grp_target_blk,
> +					my_rsv, &grp_alloc);
> +		if (grp_alloc_blk < 0)
> +			grp_alloc = 0;
> +
> +		/*
> +		 * If we couldn't allocate anything, there is nothing more to
> +		 * do with this block group, so move over to the next. But
> +		 * before that We must release write access to the old one via
> +		 * ext3_journal_release_buffer(), else we'll run out of credits.
> +		 */
> +		if (grp_mc_alloc == 0 && grp_alloc == 0) {
> +			BUFFER_TRACE(bitmap_bh, "journal_release_buffer");
> +			ext3_journal_release_buffer(handle, bitmap_bh);
> +			goto next;
> +		}
> +
> +		BUFFER_TRACE(bitmap_bh, "journal_dirty_metadata for "
> +					"bitmap block");
> +		fatal = ext3_journal_dirty_metadata(handle, bitmap_bh);
>  		if (fatal)
>  			goto out;
> -		if (grp_alloc_blk >= 0)
> +
> +		ext3_debug("using block group %d(%d)\n",
> +				group_no, gdp->bg_free_blocks_count);
> +
> +		BUFFER_TRACE(gdp_bh, "get_write_access");
> +		fatal = ext3_journal_get_write_access(handle, gdp_bh);
> +		if (fatal)
> +			goto out;
> +
> +		/* Should this be called before ext3_journal_dirty_metadata? */

If you're concerned here I'd suggest that you formulate a question for the
ext3/4 maintainers to think about.


> +		for (i = 0; i < grp_mc_alloc; i++) {
> +			if (check_allocated_blocks(
> +				new_blocks[indirect_blks_done + i], 1, sb,
> +				group_no, gdp, bitmap_bh))
> +				goto out;
> +		}
> +		if (grp_alloc > 0) {
> +			ret_block = ext3_group_first_block_no(sb, group_no) +
> +				grp_alloc_blk;
> +			if (check_allocated_blocks(ret_block, grp_alloc, sb,
> +						group_no, gdp, bitmap_bh))
> +				goto out;
> +		}
> +
> +		indirect_blks_done += grp_mc_alloc;
> +		performed_allocation = 1;
> +
> +		/* The caller will add the new buffer to the journal. */
> +		if (grp_alloc > 0)
> +			ext3_debug("allocating block %lu. "
> +					"Goal hits %d of %d.\n",
> +					ret_block, goal_hits, goal_attempts);
> +
> +		spin_lock(sb_bgl_lock(sbi, group_no));
> +		gdp->bg_free_blocks_count =
> +			cpu_to_le16(le16_to_cpu(gdp->bg_free_blocks_count) -
> +					(grp_mc_alloc + grp_alloc));
> +		spin_unlock(sb_bgl_lock(sbi, group_no));
> +		percpu_counter_sub(&sbi->s_freeblocks_counter,
> +				(grp_mc_alloc + grp_alloc));
> +
> +		BUFFER_TRACE(gdp_bh, "journal_dirty_metadata for "
> +				"group descriptor");
> +		err = ext3_journal_dirty_metadata(handle, gdp_bh);
> +		if (!fatal)
> +			fatal = err;
> +
> +		sb->s_dirt = 1;
> +		if (fatal)
> +			goto out;
> +
> +		brelse(bitmap_bh);
> +		bitmap_bh = NULL;
> +
>
> ...
>
> +
> +/*
> + * ext3_ind_read_end_bio --
> + *
> + * 	bio callback for read IO issued from ext3_read_indblocks.
> + * 	May be called multiple times until the whole I/O completes at
> + * 	which point bio->bi_size = 0 and it frees read_info and bio.
> + * 	The first time it is called, first_bh is unlocked so that any sync
> + * 	waier can unblock.

typo.

> + */
> +static void ext3_ind_read_end_bio(struct bio *bio, int err)
> +{
> +	struct ext3_ind_read_info *read_info = bio->bi_private;
> +	struct buffer_head *bh;
> +	int uptodate = !err && test_bit(BIO_UPTODATE, &bio->bi_flags);

It's pretty regrettable that ext3 now starts using bios directly.  All of
jbd and ext3 has thus far avoided this additional coupling.

Why was this necessary?

> +	int i;
> +
> +	if (err == -EOPNOTSUPP)
> +		set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
> +
> +	/* Wait for all buffers to finish - is this needed? */
> +	if (bio->bi_size)
> +		return;
> +
> +	for (i = 0; i < read_info->count; i++) {
> +		bh = read_info->bh[i];
> +		if (err == -EOPNOTSUPP)
> +			set_bit(BH_Eopnotsupp, &bh->b_state);
> +
> +		if (uptodate) {
> +			BUG_ON(buffer_uptodate(bh));
> +			BUG_ON(ext3_buffer_prefetch(bh));
> +			set_buffer_uptodate(bh);
> +			if (read_info->seq_prefetch)
> +				ext3_set_buffer_prefetch(bh);
> +		}
> +
> +		unlock_buffer(bh);
> +		brelse(bh);
> +	}
> +
> +	kfree(read_info);
> +	bio_put(bio);
> +}
> +
> +/*
> + * ext3_get_max_read --
> + * 	@inode: inode of file.
> + * 	@block: block number in file (starting from zero).
> + * 	@offset_in_dind_block: offset of the indirect block inside it's
> + * 	parent doubly-indirect block.
> + *
> + *      Compute the maximum no. of indirect blocks that can be read
> + *      satisfying following constraints:
> + *              - Don't read indirect blocks beyond the end of current
> + *              doubly-indirect block.
> + *              - Don't read beyond eof.
> + */
> +static inline unsigned long ext3_get_max_read(const struct inode *inode,
> +						  int block,
> +						  int offset_in_dind_block)

This is far too large to be inlined.

> +{
> +	const struct super_block *sb = inode->i_sb;
> +	unsigned long max_read;
> +	unsigned long ptrs = EXT3_ADDR_PER_BLOCK(inode->i_sb);
> +	unsigned long ptrs_bits = EXT3_ADDR_PER_BLOCK_BITS(inode->i_sb);
> +	unsigned long blocks_in_file =
> +		(inode->i_size + sb->s_blocksize - 1) >> sb->s_blocksize_bits;
> +	unsigned long remaining_ind_blks_in_dind =
> +		(ptrs >= offset_in_dind_block) ? (ptrs - offset_in_dind_block)
> +					       : 0;
> +	unsigned long remaining_ind_blks_before_eof =
> +		((blocks_in_file - EXT3_NDIR_BLOCKS + ptrs - 1) >> ptrs_bits) -
> +		((block - EXT3_NDIR_BLOCKS) >> ptrs_bits);
> +
> +	BUG_ON(block >= blocks_in_file);
> +
> +	max_read = min_t(unsigned long, remaining_ind_blks_in_dind,
> +			 remaining_ind_blks_before_eof);

Can use plain old min() here.

> +	BUG_ON(max_read < 1);

Please prefer to use the (much) friendlier ext3_error() over the
user-hostile BUG.  Where it makes sense.

This is especially the case where the assertion could be triggered by
corrupted disk contents - doing a BUG() in response to that is a coding
bug.

> +	return max_read;
> +}
> +
> +static void ext3_read_indblocks_submit(struct bio **pbio,
> +					struct ext3_ind_read_info **pread_info,
> +					int *read_cnt, int seq_prefetch)
> +{
> +	struct bio *bio = *pbio;
> +	struct ext3_ind_read_info *read_info = *pread_info;
> +
> +	BUG_ON(*read_cnt < 1);
> +
> +	read_info->seq_prefetch = seq_prefetch;
> +	read_info->count = *read_cnt;
> +	read_info->size = bio->bi_size;
> +	bio->bi_private = read_info;
> +	bio->bi_end_io = ext3_ind_read_end_bio;
> +	submit_bio(READ, bio);
> +
> +	*pbio = NULL;
> +	*pread_info = NULL;
> +	*read_cnt = 0;
> +}
> +
> +struct ind_block_info {
> +	ext3_fsblk_t		blockno;
> +	struct buffer_head	*bh;
> +};
> +
> +static int ind_info_cmp(const void *a, const void *b)
> +{
> +	struct ind_block_info *info_a = (struct ind_block_info *)a;
> +	struct ind_block_info *info_b = (struct ind_block_info *)b;
> +
> +	return info_a->blockno - info_b->blockno;
> +}
> +
> +static void ind_info_swap(void *a, void *b, int size)
> +{
> +	struct ind_block_info *info_a = (struct ind_block_info *)a;
> +	struct ind_block_info *info_b = (struct ind_block_info *)b;
> +	struct ind_block_info tmp;
> +
> +	tmp = *info_a;
> +	*info_a = *info_b;
> +	*info_b = tmp;
> +}

Unneeded (and undesirable) casts of void*.

> +/*
> + * ext3_read_indblocks_async --
> + *      @sb:            super block
> + *      @ind_blocks[]:  array of indirect block numbers on disk
> + *      @count:         maximum number of indirect blocks to read
> + *      @first_bh:      buffer_head for indirect block ind_blocks[0], may be
> + *                      NULL
> + *      @seq_prefetch:  if this is part of a sequential prefetch and buffers'
> + *                      prefetch bit must be set.
> + *      @blocks_done:   number of blocks considered for prefetching.
> + *
> + *      Issue a single bio request to read upto count buffers identified in
> + *      ind_blocks[]. Fewer than count buffers may be read in some cases:
> + *      - If a buffer is found to be uptodate and it's prefetch bit is set, we
> + *      don't look at any more buffers as they will most likely be in the cache.
> + *      - We skip buffers we cannot lock without blocking (except for first_bh
> + *      if specified).
> + *      - We skip buffers beyond a certain range on disk.
> + *
> + *      This function must issue read on first_bh if specified unless of course
> + *      it's already uptodate.
> + */

This comment is almost-but-not-quite in kerneldoc format.  Please review
the /** comments in ext3 and convert newly-added commetns to match.

> +static int ext3_read_indblocks_async(struct super_block *sb,
> +				     const __le32 ind_blocks[], int count,
> +				     struct buffer_head *first_bh,
> +				     int seq_prefetch,
> +				     unsigned long *blocks_done)
> +{
> +	struct buffer_head *bh;
> +	struct bio *bio = NULL;
> +	struct ext3_ind_read_info *read_info = NULL;
> +	int read_cnt = 0, blk;
> +	ext3_fsblk_t prev_blk = 0, io_start_blk = 0, curr;
> +	struct ind_block_info *ind_info = NULL;
> +	int err = 0, ind_info_count = 0;
> +
> +	BUG_ON(count < 1);
> +	/* Don't move this to ext3_get_max_read() since callers often need to
> +	 * trim the count returned by that function. So this bound must only
> +	 * be imposed at the last moment. */
> +	count = min_t(unsigned long, count, EXT3_IND_READ_MAX);

Both count and EXT3_IND_READ_MAX are plain old int.  Forcing them to ulong
for this comparison is a little odd.

Please check whether those two things have appropriate types - can they
ever legitimately go negative?  I doubt it, in which case they should have
unsigned types.

Please review all newly-added min_t's for these things.

> +	*blocks_done = 0UL;
> +
> +	if (count == 1 && first_bh) {

This comparison could do with a comment explaining what's happening?

> +		lock_buffer(first_bh);
> +		get_bh(first_bh);
> +		first_bh->b_end_io = end_buffer_read_sync;
> +		submit_bh(READ, first_bh);
> +		*blocks_done = 1UL;
> +		return 0;
> +	}
> +
> +	ind_info = kmalloc(count * sizeof(*ind_info), GFP_KERNEL);
> +	if (unlikely(!ind_info))
> +		return -ENOMEM;
> +
> +	/*
> +	 * First pass: sort block numbers for all indirect blocks that we'll
> +	 * read. This allows us to scan blocks in sequenial order during the
> +	 * second pass which helps coalasce requests to contiguous blocks.
> +	 * Since we sort block numbers here instead of assuming any specific
> +	 * layout on the disk, we have some protection against different
> +	 * indirect block layout strategies as long as they keep all indirect
> +	 * blocks close by.
> +	 */
> +	for (blk = 0; blk < count; blk++) {
> +		curr = le32_to_cpu(ind_blocks[blk]);
> +		if (!curr)
> +			continue;
> +
> +		/*
> +		 * Skip this block if it lies too far from blocks we have
> +		 * already decided to read. "Too far" should typically indicate
> +		 * lying on a different track on the disk. EXT3_IND_READ_MAX
> +		 * seems reasonable for most disks.
> +		 */
> +		if (io_start_blk > 0 &&
> +			(max(io_start_blk, curr) - min(io_start_blk, curr) >=
> +				EXT3_IND_READ_MAX))
> +			continue;
> +
> +		if (blk == 0 && first_bh) {
> +			bh = first_bh;
> +			get_bh(first_bh);
> +		} else {
> +			bh = sb_getblk(sb, curr);
> +			if (unlikely(!bh)) {
> +				err = -ENOMEM;
> +				goto failure;
> +			}
> +		}
> +
> +		if (buffer_uptodate(bh)) {
> +			if (ext3_buffer_prefetch(bh)) {
> +				brelse(bh);
> +				break;
> +			}
> +			brelse(bh);

brelse() is an old-fashioned thing which checks for a NULL arg.  Unless you
really have a bh* which might legitimately be NULL, please prefer put_bh().


> +			continue;
> +		}
> +
> +		if (io_start_blk == 0)
> +			io_start_blk = curr;
> +
> +		ind_info[ind_info_count].blockno = curr;
> +		ind_info[ind_info_count].bh = bh;
> +		ind_info_count++;
> +	}
> +	*blocks_done = blk;
> +
> +	sort(ind_info, ind_info_count, sizeof(*ind_info),
> +		ind_info_cmp, ind_info_swap);
> +
> +	/* Second pass: compose bio requests and issue them. */
> +	for (blk = 0; blk < ind_info_count; blk++) {
> +		bh = ind_info[blk].bh;
> +		curr = ind_info[blk].blockno;
> +
> +		if (prev_blk > 0 && curr != prev_blk + 1) {
> +			ext3_read_indblocks_submit(&bio, &read_info,
> +						&read_cnt, seq_prefetch);
> +			prev_blk = 0;
> +		}
> +
> +		/* Lock the buffer without blocking, skipping any buffers
> +		 * which would require us to block. first_bh when specified is
> +		 * an exception as caller typically wants it to be read for
> +		 * sure (e.g., ext3_read_indblocks_sync).
> +		 */
> +		if (bh == first_bh) {
> +			lock_buffer(bh);
> +		} else if (test_set_buffer_locked(bh)) {
> +			brelse(bh);
> +			continue;
> +		}
> +
>
> ...
>
> +
> +	kfree(ind_info);
> +	return 0;
> +
> +failure:
> +	while (--read_cnt >= 0) {
> +		unlock_buffer(read_info->bh[read_cnt]);
> +		brelse(read_info->bh[read_cnt]);
> +	}
> +	*blocks_done = 0UL;
> +
> +done:
> +	kfree(read_info);
> +
> +	if (bio)
> +		bio_put(bio);
> +
> +	kfree(ind_info);
> +	return err;
> +}

Again, I really don't see why we needed to dive into the BIO layer for
this.  Why not use submit_bh() and friends for all of this?

Also, why is it necessary to do block sorting at the filesystem level?  The
block layer does that.

> +							NULL, 1, &blocks_done);
> +
> +				goto done;
> +			}
> +			brelse(prev_bh);
> +		}
> +
> +		/* Either random read, or sequential detection failed above.
> +		 * We always prefetch the next indirect block in this case
> +		 * whenever possible.
> +		 * This is because for random reads of size ~512KB, there is
> +		 * >12% chance that a read will span two indirect blocks.
> +		 */
> +		*err = ext3_read_indblocks_sync(sb, ind_blocks,
> +						(max_read >= 2) ? 2 : 1,
> +						first_bh, 0, &blocks_done);
> +		if (*err)
> +			goto out;
> +	}
> +
> +done:
> +	/* Reader: pointers */
> +	if (!verify_chain(chain, &chain[depth - 2])) {
> +		brelse(first_bh);
> +		goto changed;
> +	}
> +	add_chain(&chain[depth - 1], first_bh,
> +		  (__le32 *)first_bh->b_data + offsets[depth - 1]);
> +	/* Reader: end */
> +	if (!chain[depth - 1].key)
> +		goto out;
> +
> +	BUG_ON(!buffer_uptodate(first_bh));
> +	return NULL;
> +
> +changed:
> +	*err = -EAGAIN;
> +	goto out;
> +failure:
> +	*err = -EIO;
> +out:
> +	if (*err) {
> +		ext3_debug("Error %d reading indirect blocks\n", *err);
> +		return &chain[depth - 2];
> +	} else
> +		return &chain[depth - 1];
> +}

I'm wondering about the interaction between this code and the
buffer_boundary() logic.  I guess we should disable the buffer_boundary()
handling when this code is in effect.  Have you reviewed and tested that
aspect?


> @@ -1692,6 +1699,13 @@ static int ext3_fill_super (struct super
>  	}
>  	sbi->s_frags_per_block = 1;
>  	sbi->s_blocks_per_group = le32_to_cpu(es->s_blocks_per_group);
> +	if (test_opt(sb, METACLUSTER)) {
> +		sbi->s_nonmc_blocks_per_group = sbi->s_blocks_per_group -
> +			sbi->s_blocks_per_group / 12;
> +		sbi->s_nonmc_blocks_per_group &= ~7;
> +	} else
> +		sbi->s_nonmc_blocks_per_group = sbi->s_blocks_per_group;
> +

hm, magic numbers.

> +		sbi->s_bginfo = kmalloc(sbi->s_groups_count *
> +					sizeof(*sbi->s_bginfo), GFP_KERNEL);
> +		if (!sbi->s_bginfo) {
> +			printk(KERN_ERR "EXT3-fs: not enough memory\n");
> +			goto failed_mount3;
> +		}
> +		for (i = 0; i < sbi->s_groups_count; i++)
> +			sbi->s_bginfo[i].bgi_free_nonmc_blocks_count = -1;
> +	} else
> +		sbi->s_bginfo = NULL;
> +
>  	/*
>  	 * set up enough so that it can read an inode
>  	 */
