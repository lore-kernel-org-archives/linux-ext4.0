From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 1/2] ext3: Add batched discard support for ext3
Date: Thu, 25 Nov 2010 15:27:09 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1011251512020.2871@dhcp-lab-213.englab.brq.redhat.com>
References: <1290603991-6151-1-git-send-email-jack@suse.cz> <1290603991-6151-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org, lczerner@redhat.com,
	greg.freemyer@gmail.com, linux-fsdevel@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045Ab0KYO1R (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Nov 2010 09:27:17 -0500
In-Reply-To: <1290603991-6151-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 24 Nov 2010, Jan Kara wrote:

> From: Lukas Czerner <lczerner@redhat.com>
> 
> Walk through allocation groups and trim all free extents. It can be
> invoked through FITRIM ioctl on the file system. The main idea is to
> provide a way to trim the whole file system if needed, since some SSD's
> may suffer from performance loss after the whole device was filled (it
> does not mean that fs is full!).
> 
> It search for free extents in allocation groups specified by Byte range
> start -> start+len. When the free extent is within this range, blocks are
> marked as used and then trimmed. Afterwards these blocks are marked as
> free in per-group bitmap.
> 
> [JK: Fixed up error handling]
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Reviewed-by: Dmitry Monakhov <dmonakhov@openvz.org>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext3/balloc.c        |  257 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/ext3_fs.h |    1 +
>  2 files changed, 258 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> index b3db226..ae88960 100644
> --- a/fs/ext3/balloc.c
> +++ b/fs/ext3/balloc.c
> @@ -20,6 +20,7 @@
>  #include <linux/ext3_jbd.h>
>  #include <linux/quotaops.h>
>  #include <linux/buffer_head.h>
> +#include <linux/blkdev.h>
>  
>  /*
>   * balloc.c contains the blocks allocation and deallocation routines
> @@ -39,6 +40,23 @@
>  
>  #define in_range(b, first, len)	((b) >= (first) && (b) <= (first) + (len) - 1)
>  
> +/*
> + * Calculate the block group number and offset, given a block number
> + */
> +void ext3_get_group_no_and_offset(struct super_block *sb, ext3_fsblk_t blocknr,
> +		unsigned long *blockgrpp, ext3_grpblk_t *offsetp)
> +{
> +	struct ext3_super_block *es = EXT3_SB(sb)->s_es;
> +	ext3_grpblk_t offset;
> +
> +	blocknr = blocknr - le32_to_cpu(es->s_first_data_block);
> +	offset = do_div(blocknr, EXT3_BLOCKS_PER_GROUP(sb));
> +	if (offsetp)
> +		*offsetp = offset;
> +	if (blockgrpp)
> +		*blockgrpp = blocknr;
> +}
> +
>  /**
>   * ext3_get_group_desc() -- load group descriptor from disk
>   * @sb:			super block
> @@ -1885,3 +1903,242 @@ unsigned long ext3_bg_num_gdb(struct super_block *sb, int group)
>  	return ext3_bg_num_gdb_meta(sb,group);
>  
>  }
> +
> +/**
> + * ext3_trim_all_free -- function to trim all free space in alloc. group
> + * @sb:			super block for file system
> + * @group:		allocation group to trim
> + * @start:		first group block to examine
> + * @max:		last group block to examine
> + * @gdp:		allocation group description structure
> + * @minblocks:		minimum extent block count
> + *
> + * ext3_trim_all_free walks through group's block bitmap searching for free
> + * blocks. When the free block is found, it tries to allocate this block and
> + * consequent free block to get the biggest free extent possible, until it
> + * reaches any used block. Then issue a TRIM command on this extent and free
> + * the extent in the block bitmap. This is done until whole group is scanned.
> + */
> +ext3_grpblk_t ext3_trim_all_free(struct super_block *sb, unsigned int group,
> +				ext3_grpblk_t start, ext3_grpblk_t max,
> +				ext3_grpblk_t minblocks)
> +{
> +	handle_t *handle;
> +	ext3_grpblk_t next, free_blocks, bit, freed, count = 0;
> +	ext3_fsblk_t discard_block;
> +	struct ext3_sb_info *sbi;
> +	struct buffer_head *gdp_bh, *bitmap_bh = NULL;
> +	struct ext3_group_desc *gdp;
> +	int err = 0, ret = 0;
> +
> +	/*
> +	 * We will update one block bitmap, and one group descriptor
> +	 */
> +	handle = ext3_journal_start_sb(sb, 2);
> +	if (IS_ERR(handle))
> +		return PTR_ERR(handle);
> +
> +	bitmap_bh = read_block_bitmap(sb, group);
> +	if (!bitmap_bh) {
> +		err = -EIO;
> +		goto err_out;
> +	}
> +
> +	BUFFER_TRACE(bitmap_bh, "getting undo access");
> +	err = ext3_journal_get_undo_access(handle, bitmap_bh);
> +	if (err)
> +		goto err_out;
> +
> +	gdp = ext3_get_group_desc(sb, group, &gdp_bh);
> +	if (!gdp) {
> +		err = -EIO;
> +		goto err_out;
> +	}
> +
> +	BUFFER_TRACE(gdp_bh, "get_write_access");
> +	err = ext3_journal_get_write_access(handle, gdp_bh);
> +	if (err)
> +		goto err_out;
> +
> +	free_blocks = le16_to_cpu(gdp->bg_free_blocks_count);
> +	sbi = EXT3_SB(sb);
> +
> +	 /* Walk through the whole group */
> +	while (start < max) {
> +		start = bitmap_search_next_usable_block(start, bitmap_bh, max);
> +		if (start < 0)
> +			break;
> +		next = start;
> +
> +		/*
> +		 * Allocate contiguous free extents by setting bits in the
> +		 * block bitmap
> +		 */
> +		while (next < max
> +			&& claim_block(sb_bgl_lock(sbi, group),
> +					next, bitmap_bh)) {
> +			next++;
> +		}
> +
> +		 /* We did not claim any blocks */
> +		if (next == start)
> +			continue;
> +
> +		discard_block = (ext3_fsblk_t)start +
> +				ext3_group_first_block_no(sb, group);
> +
> +		/* Update counters */
> +		spin_lock(sb_bgl_lock(sbi, group));
> +		le16_add_cpu(&gdp->bg_free_blocks_count, start - next);
> +		spin_unlock(sb_bgl_lock(sbi, group));
> +		percpu_counter_sub(&sbi->s_freeblocks_counter, next - start);
> +
> +		/* Do not issue a TRIM on extents smaller than minblocks */
> +		if ((next - start) < minblocks)
> +			goto free_extent;
> +
> +		 /* Send the TRIM command down to the device */
> +		err = sb_issue_discard(sb, discard_block, next - start,
> +				       GFP_NOFS, 0);
> +		count += (next - start);
> +free_extent:
> +		freed = 0;
> +
> +		/*
> +		 * Clear bits in the bitmap
> +		 */
> +		for (bit = start; bit < next; bit++) {
> +			BUFFER_TRACE(bitmap_bh, "clear bit");
> +			if (!ext3_clear_bit_atomic(sb_bgl_lock(sbi, group),
> +						bit, bitmap_bh->b_data)) {
> +				ext3_error(sb, __func__,
> +					"bit already cleared for block "E3FSBLK,
> +					 (unsigned long)bit);
> +				BUFFER_TRACE(bitmap_bh, "bit already cleared");
> +			} else {
> +				freed++;
> +			}
> +		}
> +
> +		/* Update couters */
> +		spin_lock(sb_bgl_lock(sbi, group));
> +		le16_add_cpu(&gdp->bg_free_blocks_count, freed);
> +		spin_unlock(sb_bgl_lock(sbi, group));
> +		percpu_counter_add(&sbi->s_freeblocks_counter, freed);
> +
> +		start = next;
> +		if (err < 0) {
> +			if (err != -EOPNOTSUPP)
> +				ext3_warning(sb, __func__, "Discard command "
> +					     "returned error %d\n", err);
> +			break;
> +		}
> +
> +		if (fatal_signal_pending(current)) {
> +			err = -ERESTARTSYS;
> +			break;
> +		}
> +
> +		cond_resched();
> +
> +		/* No more suitable extents */
> +		if ((free_blocks - count) < minblocks)
> +			break;
> +	}
> +
> +	/* We dirtied the bitmap block */
> +	BUFFER_TRACE(bitmap_bh, "dirtied bitmap block");
> +	err = ext3_journal_dirty_metadata(handle, bitmap_bh);
> +
> +	/* And the group descriptor block */
> +	BUFFER_TRACE(gdp_bh, "dirtied group descriptor block");
> +	ret = ext3_journal_dirty_metadata(handle, gdp_bh);
> +	if (!err)
> +		err = ret;
> +
> +	ext3_debug("trimmed %d blocks in the group %d\n",
> +		count, group);
> +
> +err_out:
> +	if (err)
> +		count = err;
> +	ext3_journal_stop(handle);
> +	brelse(bitmap_bh);
> +
> +	return count;
> +}
> +
> +/**
> + * ext3_trim_fs() -- trim ioctl handle function
> + * @sb:			superblock for filesystem
> + * @start:		First Byte to trim
> + * @len:		number of Bytes to trim from start
> + * @minlen:		minimum extent length in Bytes
> + *
> + * ext3_trim_fs goes through all allocation groups containing Bytes from
> + * start to start+len. For each such a group ext3_trim_all_free function
> + * is invoked to trim all free space.
> + */
> +int ext3_trim_fs(struct super_block *sb, struct fstrim_range *range)
> +{
> +	ext3_grpblk_t last_block, first_block, free_blocks;
> +	unsigned long first_group, last_group;
> +	unsigned long group, ngroups;
> +	struct ext3_group_desc *gdp;
> +	struct ext3_super_block *es;
> +	uint64_t start, len, minlen, trimmed;
> +	int ret = 0;
We probably need to add this:

ext3_fsblk_t blocks_count = le32_to_cpu(EXT3_SB(sb)->s_es->s_blocks_count);

> +
> +	start = range->start >> sb->s_blocksize_bits;
> +	len = range->len >> sb->s_blocksize_bits;
> +	minlen = range->minlen >> sb->s_blocksize_bits;
> +	trimmed = 0;
and this:

	if (len > blocks_count)
		len = blocks_count - start;

Because when determining last group through ext3_get_group_no_and_offset()
the result may be wrong in cases when range->start and range-len are too
big, because it may overflow when summing up those two numbers.


> +
> +	if (unlikely(minlen > EXT3_BLOCKS_PER_GROUP(sb)))
> +		return -EINVAL;
> +
> +	es = EXT3_SB(sb)->s_es;
> +	ngroups = EXT3_SB(sb)->s_groups_count;
> +	smp_rmb();
> +
> +	/* Determine first and last group to examine based on start and len */
> +	ext3_get_group_no_and_offset(sb, (ext3_fsblk_t) start,
> +				     &first_group, &first_block);
> +	ext3_get_group_no_and_offset(sb, (ext3_fsblk_t) (start + len),
							^^^^^^^^^^^^^
							here
overflow may occur.

> +				     &last_group, &last_block);
> +	last_group = (last_group > ngroups - 1) ? ngroups - 1 : last_group;
> +	last_block = EXT3_BLOCKS_PER_GROUP(sb);
> +
> +	if (first_group > last_group)
> +		return -EINVAL;
> +
> +	for (group = first_group; group <= last_group; group++) {
> +		gdp = ext3_get_group_desc(sb, group, NULL);
> +		if (!gdp)
> +			break;
> +
> +		free_blocks = le16_to_cpu(gdp->bg_free_blocks_count);
> +		if (free_blocks < minlen)
> +			continue;
> +
> +		if (len >= EXT3_BLOCKS_PER_GROUP(sb))
> +			len -= (EXT3_BLOCKS_PER_GROUP(sb) - first_block);
> +		else
> +			last_block = len;
> +
> +		ret = ext3_trim_all_free(sb, group, first_block,
> +					last_block, minlen);
> +		if (ret < 0)
> +			break;
> +
> +		trimmed += ret;
> +		first_block = 0;
> +	}
> +
> +	if (ret >= 0)
> +		ret = 0;
> +
> +	range->len = trimmed * sb->s_blocksize;
> +
> +	return ret;
> +}
> diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
> index 6ce1bca..a443965 100644
> --- a/include/linux/ext3_fs.h
> +++ b/include/linux/ext3_fs.h
> @@ -856,6 +856,7 @@ extern struct ext3_group_desc * ext3_get_group_desc(struct super_block * sb,
>  extern int ext3_should_retry_alloc(struct super_block *sb, int *retries);
>  extern void ext3_init_block_alloc_info(struct inode *);
>  extern void ext3_rsv_window_add(struct super_block *sb, struct ext3_reserve_window_node *rsv);
> +extern int ext3_trim_fs(struct super_block *sb, struct fstrim_range *range);
>  
>  /* dir.c */
>  extern int ext3_check_dir_entry(const char *, struct inode *,
> 

-- 
