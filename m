From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [Ext4 punch hole 4/4 v4] Ext4 Punch Hole Support: Enable Punch
 Hole
Date: Sun, 20 Mar 2011 08:22:11 -0700
Message-ID: <1300634531.3554.136.camel@mingming-laptop>
References: <4D841D41.3050003@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46913 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab1CTPWR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Mar 2011 11:22:17 -0400
Received: from d01dlp02.pok.ibm.com (d01dlp02.pok.ibm.com [9.56.224.85])
	by e2.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p2KF3b0W020320
	for <linux-ext4@vger.kernel.org>; Sun, 20 Mar 2011 11:03:37 -0400
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id D07BD6E8036
	for <linux-ext4@vger.kernel.org>; Sun, 20 Mar 2011 11:22:16 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p2KFMGhc2355336
	for <linux-ext4@vger.kernel.org>; Sun, 20 Mar 2011 11:22:16 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p2KFMGGL011280
	for <linux-ext4@vger.kernel.org>; Sun, 20 Mar 2011 11:22:16 -0400
In-Reply-To: <4D841D41.3050003@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2011-03-18 at 20:04 -0700, Allison Henderson wrote:
> This patch adds the  new "ext4_punch_hole" "ext4_ext_punch_hole" routines.
> 
> fallocate has been modified to call ext4_punch_hole when the punch hole
> flag is passed.  At the moment, we only support punching holes in
> extents, so this routine is pretty much a wrapper for the ext4_ext_punch_hole
> routine.
> 
> The ext4_ext_punch_hole routine completes all outstanding writes
> with the associated pages, and then releases them.  The unblock
> aligned data is zeroed, and all blocks in between are identified
> as mapped or already punched out. Mapped blocks are then punched
> out using the "ext4_ext_remove_space" routine
> 

Looks good overall! Handles punching holes over delayed allocation and
preallocated space easierly. Much cleaner and simplier than last
version.

Reviewed-by: Mingming Cao <cmm@us.ibm.com>

> Signed-off-by: Allison Henderson <achender@us.ibm.com>
> ---
> :100644 100644 c722e31... fe92010... M	fs/ext4/ext4.h
> :100644 100644 01a83a1... 0020044... M	fs/ext4/extents.c
> :100644 100644 78c5bc4... a37a2f4... M	fs/ext4/inode.c
>  fs/ext4/ext4.h    |    3 +
>  fs/ext4/extents.c |  170 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/ext4/inode.c   |   27 +++++++++
>  3 files changed, 196 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index c722e31..fe92010 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -1729,6 +1729,7 @@ extern int ext4_change_inode_journal_flag(struct inode *, int);
>  extern int ext4_get_inode_loc(struct inode *, struct ext4_iloc *);
>  extern int ext4_can_truncate(struct inode *inode);
>  extern void ext4_truncate(struct inode *);
> +extern int ext4_punch_hole(struct file *file, loff_t offset, loff_t length);
>  extern int ext4_truncate_restart_trans(handle_t *, struct inode *, int nblocks);
>  extern void ext4_set_inode_flags(struct inode *);
>  extern void ext4_get_inode_flags(struct ext4_inode_info *);
> @@ -2066,6 +2067,8 @@ extern int ext4_ext_index_trans_blocks(struct inode *inode, int nrblocks,
>  extern int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
>  			       struct ext4_map_blocks *map, int flags);
>  extern void ext4_ext_truncate(struct inode *);
> +extern int ext4_ext_punch_hole(struct file *file, loff_t offset,
> +				loff_t length);
>  extern void ext4_ext_init(struct super_block *);
>  extern void ext4_ext_release(struct super_block *);
>  extern long ext4_fallocate(struct file *file, int mode, loff_t offset,
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index 01a83a1..0020044 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -3963,10 +3963,6 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>  	struct ext4_map_blocks map;
>  	unsigned int credits, blkbits = inode->i_blkbits;
> 
> -	/* We only support the FALLOC_FL_KEEP_SIZE mode */
> -	if (mode & ~FALLOC_FL_KEEP_SIZE)
> -		return -EOPNOTSUPP;
> -
>  	/*
>  	 * currently supporting (pre)allocate mode for extent-based
>  	 * files _only_
> @@ -3974,6 +3970,13 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>  	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
>  		return -EOPNOTSUPP;
> 
> +	/* Return error if mode is not supported */
> +	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
> +		return -EOPNOTSUPP;
> +
> +	if (mode & FALLOC_FL_PUNCH_HOLE)
> +		return ext4_punch_hole(file, offset, len);
> +
>  	map.m_lblk = offset >> blkbits;
>  	/*
>  	 * We can't just convert len to max_blocks because
> @@ -4351,3 +4354,162 @@ int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>  	return error;
>  }
> 
> +/*
> + * ext4_ext_punch_hole
> + *
> + * Punches a hole of "length" bytes in a file starting
> + * at byte "offset"
> + *
> + * @inode:  The inode of the file to punch a hole in
> + * @offset: The starting byte offset of the hole
> + * @length: The length of the hole
> + *
> + * Returns the number of blocks removed or negative on err
> + */
> +int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
> +{
> +	struct inode *inode = file->f_path.dentry->d_inode;
> +	struct super_block *sb = inode->i_sb;
> +	struct ext4_extent newex;
> +	ext4_lblk_t first_block, last_block, num_blocks, iblock, max_blocks;
> +	struct address_space *mapping = inode->i_mapping;
> +	struct ext4_map_blocks map;
> +	handle_t *handle;
> +	loff_t first_block_offset, last_block_offset, block_len;
> +	loff_t first_page, last_page, first_page_offset, last_page_offset;
> +	int err, credits, ret = 0;
> +	int blocks_removed = 0;
> +
> +	first_block = (offset + sb->s_blocksize - 1)
> +			>> EXT4_BLOCK_SIZE_BITS(sb);
> +	last_block = (offset + length) >> EXT4_BLOCK_SIZE_BITS(sb);
> +
> +	first_block_offset = first_block
> +			<< EXT4_BLOCK_SIZE_BITS(sb);
> +	last_block_offset = last_block << EXT4_BLOCK_SIZE_BITS(sb);
> +
> +	first_page = (offset + PAGE_CACHE_SIZE - 1)
> +			>> PAGE_CACHE_SHIFT;
> +	last_page = (offset + length) >> PAGE_CACHE_SHIFT;
> +
> +	first_page_offset = first_page
> +			<< PAGE_CACHE_SHIFT;
> +	last_page_offset = last_page << PAGE_CACHE_SHIFT;
> +
> +	/*
> +	 * Write out all dirty pages to avoid race conditions
> +	 * Then release them.
> +	 */
> +	if (last_page_offset > first_page_offset) {
> +		if (mapping->nrpages && mapping_tagged(mapping,
> +			PAGECACHE_TAG_DIRTY)){
> +			err = filemap_write_and_wait_range(mapping,
> +				first_page_offset, last_page_offset-1);
> +			if (err)
> +				return err;
> +		}
> +		truncate_inode_pages_range(mapping, first_page_offset,
> +			last_page_offset-1);
> +	}
> +
> +	/* finish any pending end_io work */
> +	ext4_flush_completed_IO(inode);
> +
> +	credits = ext4_writepage_trans_blocks(inode);
> +	handle = ext4_journal_start(inode, credits);
> +	if (IS_ERR(handle))
> +		return PTR_ERR(handle);
> +
> +	if (ext4_orphan_add(handle, inode))
> +		goto out;
> +
> +	/*
> +	 * Now we need to zero out the un block aligned data.
> +	 * If the file is smaller than a block, just
> +	 * zero out the middle and return
> +	 */
> +	if (first_block > last_block)
> +		ext4_block_zero_page_range(handle, mapping, offset, length);
> +	else {
> +		/* zero out the head of the hole before the first block */
> +		block_len  = first_block_offset - offset;
> +		if (block_len > 0)
> +			ext4_block_zero_page_range(handle, mapping,
> +				offset, block_len);
> +
> +		/* zero out the tail of the hole after the last block */
> +		block_len = offset + length - last_block_offset;
> +		if (block_len > 0) {
> +			ext4_block_zero_page_range(handle, mapping,
> +				last_block_offset, block_len);
> +		}
> +	}
> +
> +	/* If there are no blocks to remove, return now */
> +	if (first_block >= last_block)
> +		goto out;
> +
> +	down_write(&EXT4_I(inode)->i_data_sem);
> +	ext4_ext_invalidate_cache(inode);
> +	ext4_discard_preallocations(inode);
> +
> +	/*
> +	 * Loop over all the blocks and identify blocks
> +	 * that need to be punched out
> +	 */
> +	iblock = first_block;
> +	while (iblock < last_block) {
> +		max_blocks = last_block - iblock;
> +		num_blocks = 1;
> +		memset(&map, 0, sizeof(map));
> +		map.m_lblk = iblock;
> +		map.m_len = max_blocks;
> +		ret = ext4_ext_map_blocks(handle, inode, &map, 0);
> +
> +		if (ret > 0) {
> +			num_blocks = ret > max_blocks ? max_blocks : ret;
> +
> +			/*
> +			 * If the blocks are mapped or preallocated,
> +			 * release them
> +			 */
> +			if (map.m_flags & EXT4_MAP_MAPPED)
> +				ext4_ext_convert_blocks_uninit(handle,
> +					inode, iblock, num_blocks);
> +
> +			ext4_ext_remove_space(inode, iblock,
> +				iblock + num_blocks);
> +			blocks_removed += num_blocks;
> +		} else if (ret == 0) {
> +			/*
> +			 * If map blocks could not find the block,
> +			 * then it is in a hole.  If the hole was
> +			 * not already cached, then map blocks should
> +			 * put it in the cache
> +			 */
> +			memset(&newex, 0, sizeof(newex));
> +			if ((ext4_ext_in_cache(inode, iblock, &newex)) &&
> +				(!newex.ee_start_lo && !newex.ee_start_hi)) {
> +				/* The hole is cached */
> +				num_blocks = (newex.ee_block + newex.ee_len) -
> +						iblock;
> +			}
> +		} else {
> +			/* Block lookup error */
> +			ext_debug("Block lookup failed");
> +		}
> +
> +		iblock += num_blocks;
> +	}
> +
> +	if (IS_SYNC(inode))
> +		ext4_handle_sync(handle);
> +
> +	up_write(&EXT4_I(inode)->i_data_sem);
> +out:
> +	ext4_orphan_del(handle, inode);
> +	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
> +	ext4_mark_inode_dirty(handle, inode);
> +	ext4_journal_stop(handle);
> +	return blocks_removed;
> +}
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 78c5bc4..a37a2f4 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4406,6 +4406,33 @@ int ext4_can_truncate(struct inode *inode)
>  }
> 
>  /*
> + * ext4_punch_hole: punches a hole in a file by releaseing the blocks
> + * associated with the given offset and length
> + *
> + * @inode:  File inode
> + * @offset: The offset where the hole will begin
> + * @len:    The length of the hole
> + *
> + * Returns: 0 on sucess or negative on failure
> + */
> +
> +int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
> +{
> +	struct inode *inode = file->f_path.dentry->d_inode;
> +	if (!S_ISREG(inode->i_mode))
> +		return -ENOTSUPP;
> +
> +	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) {
> +		/* TODO: Add support for non extent hole punching */
> +		return -ENOTSUPP;
> +	}
> +
> +	ext4_ext_punch_hole(file, offset, length);
> +
> +	return 0;
> +}
> +
> +/*
>   * ext4_truncate()
>   *
>   * We block out ext4_get_block() block instantiations across the entire


