From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH 2/3] Move the file data to the new blocks
Date: Mon, 5 Feb 2007 14:12:04 +0100
Message-ID: <20070205131204.GA15596@atrey.karlin.mff.cuni.cz>
References: <20070116210520sho@rifu.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: sho@tnes.nec.co.jp
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070116210520sho@rifu.tnes.nec.co.jp>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hi,

  I'm replying rather late but I've been busy with my PhD thesis lately.
So sorry for that.

> Move the blocks on the temporary inode to the original inode
> by a page.
> 1. Read the file data from the old blocks to the page
> 2. Move the block on the temporary inode to the original inode
> 3. Write the file data on the page into the new blocks
  I have one thing - it's probably not good to use page cache for
defragmentation. As you will read/write tons of data and that will push
out all other data from the cache. I think it may be better to allocate
some separate pages and use them as buffers.
  Also I'm intending to work on a similar functionality for ext3
(without extents/mballoc). It would be probably good to find some common
parts so that they don't have to be duplicated.

								Honza

> Signed-off-by: Takashi Sato <sho@tnes.nec.co.jp>
> ---
> diff -Nrup -X linux-2.6.19-rc6-org/Documentation/dontdiff linux-2.6.19-rc6-1/fs/ext4/extents.c linux-2.6.19-rc6-FULL/fs/ext4/extents.c
> --- linux-2.6.19-rc6-1/fs/ext4/extents.c	2007-01-16 09:46:13.000000000 +0900
> +++ linux-2.6.19-rc6-FULL/fs/ext4/extents.c	2007-01-16 09:43:45.000000000 +0900
> @@ -2539,6 +2539,470 @@ ext4_ext_next_extent(struct inode *inode
>  }
>  
>  /**
> + * ext4_ext_merge_extents - merge new extent to the extent block
> + *
> + * @handle      journal handle
> + * @inode       target file's inode
> + * @org_path    path indicates first extent to be defraged
> + * @o_start     first original extent to be defraged
> + * @o_end       last original extent to be defraged
> + * @start_ext   first new extent to be merged
> + * @new_ext     middle of new extent to be merged
> + * @end_ext     last new extent to be merged
> + * @replaced    the number of blocks which will be replaced with new_ext
> + *
> + * This function returns 0 if succeed, otherwise returns -1.
> + */
> +static int
> +ext4_ext_merge_extents(handle_t *handle, struct inode *inode,
> +		struct ext4_ext_path *org_path,
> +		struct ext4_extent *o_start, struct ext4_extent *o_end,
> +		struct ext4_extent *start_ext, struct ext4_extent *new_ext,
> +		struct ext4_extent *end_ext, unsigned long replaced)
> +{
> +	int	i = 0;
> +	unsigned need_slots;
> +	unsigned slots_range, len;
> +	int	 range_to_move;
> +	struct	ext4_extent_header * eh;
> +	struct	ext4_extent *free_start, *free_end;
> +	int	depth;
> +
> +	/* The extents need to be inserted
> +	 * start_extent + new_extent + end_extent
> +	 */
> +	need_slots = (le16_to_cpu(start_ext->ee_len) ? 1 : 0) +
> +			(le16_to_cpu(end_ext->ee_len) ? 1 : 0) +
> +			(le16_to_cpu(new_ext->ee_len) ? 1 : 0);
> +
> +	/* The number of slots between start and end */
> +	slots_range = o_end - o_start + 1;
> +
> +	/* Range to move the end of extent */
> +	range_to_move = need_slots - slots_range;
> +	depth = org_path->p_depth;
> +	org_path += depth;
> +	eh = org_path->p_hdr;
> +	/* expansion */
> +	if (range_to_move > 0) {
> +		if (range_to_move > le16_to_cpu(eh->eh_max)
> +				- le16_to_cpu(eh->eh_entries)) {
> +			printk("Cannot merge extents due to no space\n");
> +			return -1;
> +		}
> +	}
> +	if (depth) {
> +		/* Register to journal */
> +		if (ext4_journal_get_write_access(handle, org_path->p_bh)) {
> +			return -1;
> +		}
> +	}
> +
> +	/* Free old blocks
> +	 * dest        |---------------|
> +	 * org  |---------------|
> +	 */
> +	free_start = o_start;
> +	free_end = o_end;
> +	if (le16_to_cpu(start_ext->ee_len)) {
> +		if (le16_to_cpu(o_start->ee_len)
> +			> le16_to_cpu(start_ext->ee_len)) {
> +			ext4_free_blocks(handle, inode,
> +				ext_pblock(o_start)
> +					+ le16_to_cpu(start_ext->ee_len),
> +				le16_to_cpu(o_start->ee_len)
> +					- le16_to_cpu(start_ext->ee_len), 0);
> +		}
> +		free_start++;
> +	}
> +
> +	/* dest |----------------|
> +	 * org          |---------------|
> +	 */
> +	if (le16_to_cpu(end_ext->ee_len)) {
> +		ext4_free_blocks(handle, inode, ext_pblock(o_end),
> +			le16_to_cpu(o_end->ee_len)
> +				- le16_to_cpu(end_ext->ee_len), 0);
> +		free_end--;
> +	}
> +
> +	/* dest |-------------------|
> +	 * org   |-----------------|
> +	 */
> +	for (; free_start <= free_end; free_start++) {
> +		ext4_free_blocks(handle, inode,
> +			ext_pblock(free_start),
> +			le32_to_cpu(free_start->ee_len), 0);
> +	}
> +
> +	/* Move the existing extents */
> +	if (range_to_move && o_end < EXT_LAST_EXTENT(eh)) {
> +		len = EXT_LAST_EXTENT(eh) - (o_end + 1) + 1;
> +		len = len * sizeof(struct ext4_extent);
> +		memmove(o_end + 1 + range_to_move, o_end + 1, len);
> +	}
> +
> +	/* Insert start entry */
> +	if (le16_to_cpu(start_ext->ee_len)) {
> +		o_start[i++].ee_len = start_ext->ee_len;
> +	}
> +
> +	/* Insert new entry */
> +	if (le16_to_cpu(new_ext->ee_len)) {
> +		o_start[i].ee_block = new_ext->ee_block;
> +		o_start[i].ee_len = cpu_to_le16(replaced);
> +		ext4_ext_store_pblock(&o_start[i++], ext_pblock(new_ext));
> +	}
> +
> +	/* Insert end entry */
> +	if (end_ext->ee_len) {
> +		o_start[i] = *end_ext;
> +	}
> +
> +	/* Increment the total entries counter on the extent block */
> +	eh->eh_entries
> +		= cpu_to_le16(le16_to_cpu(eh->eh_entries) + range_to_move);
> +	if (depth) {
> +		if (ext4_journal_dirty_metadata(handle, org_path->p_bh)) {
> +			return -1;
> +		}
> +	} else {
> +		if (ext4_mark_inode_dirty(handle, inode) < 0) {
> +			return -1;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * ext4_ext_defrag_leaf_block -  Defragmentation for one leaf extent block.
> + * @handle      journal handle
> + * @org_inode   target inode
> + * @org_path    path indicates first extent to be defraged
> + * @dext        destination extent
> + * @from        start offset on the target file
> + *
> + * This function returns 0 if succeed, otherwise returns error value.
> + */
> +static int
> +ext4_ext_defrag_leaf_block(handle_t *handle, struct inode *org_inode,
> +		struct ext4_ext_path *org_path, struct ext4_extent *dext,
> +		unsigned long *from, unsigned long *delete_start)
> +{
> +	unsigned long depth, replaced = 0;
> +	struct ext4_extent *oext, *o_start = NULL, *o_end = NULL, *prev_ext;
> +	struct ext4_extent new_ext, start_ext, end_ext;
> +	unsigned long new_end;
> +	unsigned long lblock;
> +	unsigned long len;
> +	unsigned long long new_phys_end;
> +	int	ret;
> +
> +	depth = ext_depth(org_inode);
> +	start_ext.ee_len = end_ext.ee_len = 0;
> +	o_start = o_end = oext = org_path[depth].p_ext;
> +	ext4_ext_store_pblock(&new_ext, ext_pblock(dext));	
> +	len = new_ext.ee_len = dext->ee_len;
> +	new_ext.ee_block = cpu_to_le32(*from);
> +	lblock = le32_to_cpu(oext->ee_block);
> +	new_end = le32_to_cpu(new_ext.ee_block)
> +		+ le16_to_cpu(new_ext.ee_len) - 1;
> +	new_phys_end = ext_pblock(&new_ext)
> +		+ le16_to_cpu(new_ext.ee_len) - 1;
> +
> +	/* First original extent
> +	 * dest         |---------------|
> +	 * org  |---------------|
> +	 */
> +	if (le32_to_cpu(new_ext.ee_block) >
> +		le32_to_cpu(oext->ee_block) &&
> +		le32_to_cpu(new_ext.ee_block) <
> +		le32_to_cpu(oext->ee_block)
> +		+ le16_to_cpu(oext->ee_len)) {
> +		start_ext.ee_len = cpu_to_le32(le32_to_cpu(new_ext.ee_block)
> +					- le32_to_cpu(oext->ee_block));
> +		replaced += le16_to_cpu(oext->ee_len)
> +					- le16_to_cpu(start_ext.ee_len);
> +	} else if (oext > EXT_FIRST_EXTENT(org_path[depth].p_hdr)) {
> +		/* We can merge previous extent. */
> +		prev_ext = oext -1;
> +		if ((ext_pblock(prev_ext)
> +			+ le32_to_cpu(prev_ext->ee_len))
> +			== ext_pblock(&new_ext)) {
> +			o_start = prev_ext;
> +			start_ext.ee_len = cpu_to_le32(
> +					le16_to_cpu(prev_ext->ee_len)
> +					+ le16_to_cpu(new_ext.ee_len));
> +			new_ext.ee_len = 0;
> +		}
> +	}
> +
> +	for (;;) {
> +
> +		/* The extent for destination must be found. */
> +		BUG_ON(!oext || lblock != le32_to_cpu(oext->ee_block));
> +		lblock += le16_to_cpu(oext->ee_len);
> +
> +		/* Middle of original extent
> +		 * dest |-------------------|
> +		 * org   |-----------------|
> +		 */
> +		if (le32_to_cpu(new_ext.ee_block) <=
> +			le32_to_cpu(oext->ee_block) &&
> +			new_end >= le32_to_cpu(oext->ee_block)
> +			+ le16_to_cpu(oext->ee_len) -1) {
> +			replaced += le16_to_cpu(oext->ee_len);
> +		}
> +
> +		/* Last original extent
> +		 * dest |----------------|
> +		 * org          |---------------|
> +		 */
> +		if (new_end >= le32_to_cpu(oext->ee_block) &&
> +			new_end < le32_to_cpu(oext->ee_block)
> +				+ le16_to_cpu(oext->ee_len) - 1) {
> +			end_ext.ee_len
> +				= cpu_to_le16(le32_to_cpu(oext->ee_block)
> +				+ le16_to_cpu(oext->ee_len) -1 - new_end);
> +			ext4_ext_store_pblock(&end_ext, (ext_pblock(o_end)
> +				+ cpu_to_le16(oext->ee_len)
> +				- cpu_to_le16(end_ext.ee_len)));
> +			end_ext.ee_block
> +				= cpu_to_le32(le32_to_cpu(o_end->ee_block)
> +				+ le16_to_cpu(oext->ee_len)
> +				- le16_to_cpu(end_ext.ee_len));
> +			replaced += le16_to_cpu(oext->ee_len)
> +				- le16_to_cpu(end_ext.ee_len);
> +		}
> +
> +		/* Detected the block end, reached the number of replaced
> +		 * blocks to dext->ee_len.  Then, merge the extent.
> +		 */
> +		if (oext == EXT_LAST_EXTENT(org_path[depth].p_hdr) ||
> +			new_end <= le32_to_cpu(oext->ee_block)
> +				+ le16_to_cpu(oext->ee_len) - 1) {
> +			if (ext4_ext_merge_extents(handle, org_inode,
> +				org_path, o_start, o_end,
> +				&start_ext, &new_ext, &end_ext, replaced) < 0) {
> +				return -EIO;
> +			}
> +
> +			*delete_start = le32_to_cpu(new_ext.ee_block)
> +							+ replaced;
> +
> +			/* All expected blocks are replaced */
> +			if (new_ext.ee_len <= 0) {
> +				if (DQUOT_ALLOC_BLOCK
> +					(org_inode, len)) {
> +					return -EDQUOT;
> +				}
> +				return 0;
> +			}
> +
> +			/* re-calculate new_ext */
> +			new_ext.ee_len = cpu_to_le32(le16_to_cpu(new_ext.ee_len)
> +				- replaced);
> +			new_ext.ee_block =
> +				cpu_to_le32(le32_to_cpu(new_ext.ee_block)
> +				+ replaced);
> +			ext4_ext_store_pblock(&new_ext, ext_pblock(&new_ext)
> +					 + replaced);
> +			replaced = 0;
> +			start_ext.ee_len = end_ext.ee_len = 0;
> +			o_start = NULL;
> +
> +			/* All expected blocks are replaced */
> +			if (new_ext.ee_len <= 0) {
> +				if (DQUOT_ALLOC_BLOCK
> +					(org_inode, len)) {
> +					return -EDQUOT;
> +				}
> +				return 0;
> +			}
> +		}
> +
> +		/* Get next extent for original. */
> +		if ((ret
> +		 = ext4_ext_next_extent(org_inode, org_path, &oext))
> +								!= 0) {
> +			if (ret == 1)
> +				ret = -EIO;
> +			return ret;
> +		}
> +		o_end = oext;
> +		if (!o_start)
> +			o_start = oext;
> +	}
> +}
> +
> +/**
> + * ext4_ext_replace_branches - replace original extents with new extents.
> + * @org_inode    Original inode
> + * @dest_inode   temporary inode
> + * @from_page    Page offset
> + * @count_page   Page count to be replaced
> + * @delete_start block offset for deletion
> + *
> + * This function returns 0 if succeed, otherwise returns error value.
> + * Replace extents for blocks from "from" to "from+count-1".
> + */
> +static int
> +ext4_ext_replace_branches(struct inode *org_inode, struct inode *dest_inode,
> +			pgoff_t from_page,  pgoff_t dest_from_page,
> +			pgoff_t count_page, unsigned long *delete_start) 
> +{
> +	struct ext4_ext_path *org_path = NULL;
> +	struct ext4_ext_path *dest_path = NULL;
> +	struct ext4_extent   *oext, *dext;
> +	struct ext4_extent   tmp_ext;
> +	int	err = 0;
> +	int	depth;
> +	unsigned long from, count, dest_off, diff, replaced_count = 0;
> +	handle_t *handle = NULL;
> +	unsigned jnum;
> +
> +	from = from_page << (PAGE_CACHE_SHIFT - dest_inode->i_blkbits);
> +	count = count_page << (PAGE_CACHE_SHIFT - dest_inode->i_blkbits);
> +	dest_off = dest_from_page << (PAGE_CACHE_SHIFT - 
> +			dest_inode->i_blkbits);
> +	jnum = ext4_ext_writepage_trans_blocks(org_inode, count) + 3;
> +	handle = ext4_journal_start(org_inode, jnum);
> +	if (IS_ERR(handle)) {
> +		err = PTR_ERR(handle);
> +		goto out;
> +	}
> +
> +	/* Get the original extent for the block "from" */
> +	org_path = ext4_ext_find_extent(org_inode, from, NULL);
> +	if (IS_ERR(org_path)) {
> +		err = PTR_ERR(org_path);
> +		org_path = NULL;
> +		goto out;
> +	}
> +
> +	/* Get the destination extent for the head */
> +	dest_path = ext4_ext_find_extent(dest_inode, dest_off, NULL);
> +	if (IS_ERR(dest_path)) {
> +		err = PTR_ERR(dest_path);
> +		dest_path = NULL;
> +		goto out;
> +	}
> +	depth = ext_depth(dest_inode);
> +	dext = dest_path[depth].p_ext;
> +	/* When dext is too large, pick up the target range. */
> +	diff = dest_off - le32_to_cpu(dext->ee_block);
> +	ext4_ext_store_pblock(&tmp_ext, ext_pblock(dext) + diff);
> +	tmp_ext.ee_block = cpu_to_le32(le32_to_cpu(dext->ee_block) + diff);
> +	tmp_ext.ee_len = cpu_to_le16(le16_to_cpu(dext->ee_len) - diff);
> +	if (count < tmp_ext.ee_len) {
> +		tmp_ext.ee_len = cpu_to_le16(count);
> +	}
> +	dext = &tmp_ext;
> +
> +	/* loop for the destination extents */
> +	while (1) {
> +		/* The extent for destination must be found. */
> +		BUG_ON(!dext || dest_off != le32_to_cpu(dext->ee_block));
> +
> +		/* loop for the original extent blocks */
> +		if ((err = ext4_ext_defrag_leaf_block(handle, org_inode,
> +			org_path, dext, &from, delete_start)) < 0) {
> +			goto out;
> +		}
> +
> +		replaced_count += le16_to_cpu(dext->ee_len);
> +		dest_off += le16_to_cpu(dext->ee_len);
> +		from += le16_to_cpu(dext->ee_len);
> +
> +		/* Already moved the expected blocks */
> +		if (replaced_count >= count)
> +			break;
> +
> +		/* get the next extent on both original and destination. */
> +		err = ext4_ext_next_extent(dest_inode, dest_path, &dext);
> +		if (err != 0) {
> +			if (err > 0) {
> +				err = 0;
> +			}
> +			goto out;
> +		}
> +		if ((err =
> +			ext4_ext_next_extent(org_inode, org_path, &oext)) < 0) {
> +			goto out;
> +		}
> +	}
> +out:
> +	if (handle) {
> +		ext4_journal_stop(handle);
> +	}
> +	if (org_path) {
> +		ext4_ext_drop_refs(org_path);
> +		kfree(org_path);
> +	}
> +	if (dest_path) {
> +		ext4_ext_drop_refs(dest_path);
> +		kfree(dest_path);
> +	}
> +
> +	return err;
> +}
> +
> +/**
> + * ext4_ext_remove_index_blocks - remove leaf blocks and index blocks
> + * @handle      handle
> + * @dest_inode  temporary inode
> + * @eh          extent header
> + * @depth       depth of extent tree
> + *
> + * This function returns 0 if succeed, otherwise returns error value
> + */
> +static int ext4_ext_remove_index_blocks(handle_t *handle,
> +			struct inode *dest_inode,
> +			struct ext4_extent_header *eh, int depth)
> +{
> +	struct ext4_extent_idx *idx;
> +	struct buffer_head *bh;
> +	int metadata = 1;
> +	int credits = 0;
> +	int i, ret = 0;
> +
> +	if (depth == 0) {
> +		eh->eh_entries = 0;
> +		return 0;
> +	}
> +
> +	idx = EXT_FIRST_INDEX(eh);
> +
> +	for (i = 1; i <= eh->eh_entries; i++) {
> +		if (depth > 1) {
> +			bh = sb_bread(dest_inode->i_sb, idx->ei_leaf);
> +			if (!bh) {
> +				ret = -EIO;
> +			} else {
> +				ret = ext4_ext_remove_index_blocks(handle,
> +					dest_inode, ext_block_hdr(bh),
> +					depth - 1);
> +				brelse(bh);
> +			}
> +		}
> +#ifdef CONFIG_QUOTA
> +		credits = 2 * EXT4_QUOTA_TRANS_BLOCKS(dest_inode->i_sb);
> +#endif
> +		handle = ext4_ext_journal_restart(handle,
> +				credits + EXT4_TRANS_META_BLOCKS);
> +		if (IS_ERR(handle))
> +			return PTR_ERR(handle);
> +
> +		ext4_free_blocks(handle, dest_inode,
> +				idx->ei_leaf, 1, metadata);
> +		eh->eh_entries--;
> +		idx++;
> +	}
> +	return ret;
> +}
> +
> +/**
>   * ext4_ext_alloc_blocks - allocate contiguous blocks to temporary inode
>   * @dest_inode   temporary inode for multiple block allocation
>   * @iblock       file related offset
> @@ -2673,6 +3137,61 @@ out2:
>  }
>  
>  /**
> + * ext4_ext_defrag_partial - defrag original file partially
> + * @filp:		pointer to file
> + * @org_offset:		page index on original file
> + * @dest_offset:	page index on temporary file
> + *
> + * This function returns 0 if succeeded, otherwise returns error value
> + */
> +static int
> +ext4_ext_defrag_partial(struct inode *tmp_inode,
> +			struct file *filp,
> +			pgoff_t org_offset,
> +			pgoff_t dest_offset, unsigned long *delete_start)
> +{
> +	struct inode *inode = filp->f_dentry->d_inode;
> +	struct address_space *mapping = inode->i_mapping;
> +	struct page *page;
> +	pgoff_t offset_in_page = PAGE_SIZE;
> +	int ret = 0;
> +
> +	page = read_cache_page(inode->i_mapping,
> +		       org_offset, (filler_t *)inode->i_mapping->a_ops->readpage,
> +		       NULL);
> +
> +	if (IS_ERR(page)) {
> +		ret = PTR_ERR(page);
> +		return ret;
> +	}
> +
> +	wait_on_page_locked(page);
> +	lock_page(page);
> +	/* release old bh and drop refs */
> +	try_to_release_page(page, 0);
> +	ret = ext4_ext_replace_branches(inode, tmp_inode, org_offset, 
> +			dest_offset, 1, delete_start);
> +	if (ret < 0)
> +		goto ERR;
> +
> +	if (org_offset == ((inode->i_size - 1) >> PAGE_SHIFT))
> +		offset_in_page = (inode->i_size & (PAGE_CACHE_SIZE - 1));
> +
> +	ret = mapping->a_ops->prepare_write(filp, page,
> +					    0, offset_in_page);
> +	if (ret)
> +		goto ERR;
> +
> +	ret = mapping->a_ops->commit_write(filp, page,
> +					   0, offset_in_page);
> +ERR:
> +	unlock_page(page);
> +	page_cache_release(page);
> +
> +	return (ret < 0 ? ret : 0);
> +}
> +
> +/**
>   * ext4_ext_new_extent_tree -  allocate contiguous blocks
>   * @inode:		inode of the original file
>   * @tmp_inode:		inode of the temporary file
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
