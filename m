From: sho@tnes.nec.co.jp
Subject: [RFC][PATCH 2/3] Move the file data to the new blocks
Date: Thu, 9 Nov 2006 20:10:54 +0900
Message-ID: <20061109201055sho@rifu.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:20159 "EHLO
	tyo201.gate.nec.co.jp") by vger.kernel.org with ESMTP
	id S932792AbWKILKt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Nov 2006 06:10:49 -0500
Received: from mailgate3.nec.co.jp (mailgate53.nec.co.jp [10.7.69.162])
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id kA9BAmWk003808
	for <linux-ext4@vger.kernel.org>; Thu, 9 Nov 2006 20:10:48 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id kA9BAln00765 for linux-ext4@vger.kernel.org; Thu, 9 Nov 2006 20:10:47 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv3.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id kA9BAl803452 for <linux-ext4@vger.kernel.org>; Thu, 9 Nov 2006 20:10:47 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20061109.201541.01504456 for <linux-ext4@vger.kernel.org>
	; Thu, 9 Nov 2006 20:15:41 +0900
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Move the blocks on the temporary inode to the original inode
by a page.
1. Read the file data from the old blocks to the page
2. Move the block on the temporary inode to the original inode
3. Write the file data on the page into the new blocks

Signed-off-by: Takashi Sato <sho@tnes.nec.co.jp>
---
diff -upNr -X linux-2.6.16.8-tmp1/Documentation/dontdiff linux-2.6.16.8-tmp1/fs/ext3/extents.c linux-2.6.16.8-tmp2/fs/ext3/extents.c
--- linux-2.6.16.8-tmp1/fs/ext3/extents.c	2006-11-08 22:12:19.000000000 +0900
+++ linux-2.6.16.8-tmp2/fs/ext3/extents.c	2006-11-08 22:25:07.000000000 +0900
@@ -2424,6 +2424,421 @@ ext3_ext_next_extent(struct inode *inode
 }
 
 /**
+ * ext3_ext_merge_extents - merge new extent to the extent block
+ *
+ * @handle	journal handle
+ * @inode	target file's inode
+ * @org_path	path indicates first extent to be defraged
+ * @o_start	first original extent to be defraged
+ * @o_end	last original extent to be defraged
+ * @start_ext	first new extent to be merged
+ * @new_ext	middle of new extent to be merged
+ * @end_ext	last new extent to be merged
+ * @replaced	the number of blocks which will be replaced with new_ext
+ *
+ * This function returns 0 if succeed, otherwise returns -1.
+ */
+static int
+ext3_ext_merge_extents(handle_t *handle, struct inode *inode,
+		struct ext3_ext_path *org_path,
+		struct ext3_extent *o_start, struct ext3_extent *o_end,
+		struct ext3_extent *start_ext, struct ext3_extent *new_ext,
+		struct ext3_extent *end_ext, unsigned long replaced)
+{
+	int	 i = 0;
+	unsigned need_slots;
+	unsigned slots_range, len;
+	int	 range_to_move;
+	struct ext3_extent_header * eh;
+	struct ext3_extent *free_start, *free_end;
+	int	 depth;
+
+	/* The extents need to be inserted
+	 * start_extent + new_extent + end_extent
+	 */
+	need_slots = (le16_to_cpu(start_ext->ee_len) ? 1 : 0) +
+		     (le16_to_cpu(end_ext->ee_len) ? 1 : 0) +
+		     (le16_to_cpu(new_ext->ee_len) ? 1 : 0);
+
+	/* The number of slots between start and end */
+	slots_range = o_end - o_start + 1;
+
+	/* Range to move the end of extent */
+	range_to_move = need_slots - slots_range;
+	depth = org_path->p_depth;
+	org_path += depth;
+	eh = org_path->p_hdr;
+	/* expansion */
+	if (range_to_move > 0) {
+		if (range_to_move > le16_to_cpu(eh->eh_max)
+					- le16_to_cpu(eh->eh_entries)) {
+			printk("Cannot merge extents due to no space\n");
+			return -1;
+		}
+	}
+	if (depth) {
+		/* Register to journal */
+		if (ext3_journal_get_write_access(handle, org_path->p_bh)) {
+			return -1;
+		}
+	}
+
+	/* Free old blocks
+	 * dest        |---------------|
+	 * org  |---------------|
+	 */
+	free_start = o_start;
+	free_end = o_end;
+	if (le16_to_cpu(start_ext->ee_len)) {
+		if (le16_to_cpu(o_start->ee_len)
+			> le16_to_cpu(start_ext->ee_len)) {
+			ext3_free_blocks(handle, inode,
+				le32_to_cpu(o_start->ee_start)
+					 + le16_to_cpu(start_ext->ee_len),
+				le16_to_cpu(o_start->ee_len)
+					- le16_to_cpu(start_ext->ee_len), 0);
+		}
+		free_start++;
+	}
+
+	/* dest |----------------|
+	 * org          |---------------|
+	 */
+	if (le16_to_cpu(end_ext->ee_len)) {
+		ext3_free_blocks(handle, inode, le32_to_cpu(o_end->ee_start),
+			le16_to_cpu(o_end->ee_len)
+				 - le16_to_cpu(end_ext->ee_len), 0);
+		free_end--;
+	}
+
+	/* dest |-------------------|
+	 * org   |-----------------|
+	 */
+	for (; free_start <= free_end; free_start++) {
+		ext3_free_blocks(handle, inode,
+			le32_to_cpu(free_start->ee_start),
+			le32_to_cpu(free_start->ee_len), 0);
+	}
+
+	/* Move the existing extents */
+	if (range_to_move && o_end < EXT_LAST_EXTENT(eh)) {
+		len = EXT_LAST_EXTENT(eh) - (o_end + 1) + 1;
+		len = len * sizeof(struct ext3_extent);
+		memmove(o_end + 1 + range_to_move, o_end + 1, len);
+	}
+
+	/* Insert start entry */
+	if (le16_to_cpu(start_ext->ee_len)) {
+		o_start[i++].ee_len = start_ext->ee_len;
+	}
+
+	/* Insert new entry */
+	if (le16_to_cpu(new_ext->ee_len)) {
+		o_start[i].ee_block = new_ext->ee_block;
+		o_start[i].ee_len = cpu_to_le16(replaced);
+		o_start[i++].ee_start = new_ext->ee_start;
+	}
+
+	/* Insert end entry */
+	if (end_ext->ee_len) {
+		o_start[i] = *end_ext;
+	}
+
+	/* Increment the total entries counter on the extent block */
+	eh->eh_entries
+		= cpu_to_le16(le16_to_cpu(eh->eh_entries) + range_to_move);
+	if (depth) {
+		if (ext3_journal_dirty_metadata(handle, org_path->p_bh)) {
+			return -1;
+		}
+	} else {
+		if (ext3_mark_inode_dirty(handle, inode) < 0) {
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * ext3_ext_defrag_leaf_block -  Defragmentation for one leaf extent block.
+ * @handle	journal handle
+ * @org_tree	extent tree for the target inode
+ * @org_path	path indicates first extent to be defraged
+ * @dext	destination extent
+ * @from	start offset on the target file
+ *
+ * This function returns 0 if succeed, otherwise returns error value.
+ */
+static int
+ext3_ext_defrag_leaf_block(handle_t *handle, struct ext3_extents_tree *org_tree,
+		  struct ext3_ext_path *org_path, struct ext3_extent *dext,
+		  unsigned long *from)
+{
+	unsigned long depth, replaced = 0;
+	struct ext3_extent *oext, *o_start = NULL, *o_end = NULL, *prev_ext;
+	struct ext3_extent new_ext, start_ext, end_ext;
+	unsigned long new_end;
+	unsigned long lblock;
+	unsigned long long new_phys_end;
+	int	ret;
+
+	depth = EXT_DEPTH(org_tree);
+	start_ext.ee_len = end_ext.ee_len = 0;
+	o_start = o_end = oext = org_path[depth].p_ext;
+	new_ext.ee_start = dext->ee_start;
+	new_ext.ee_len = dext->ee_len;
+	new_ext.ee_block = cpu_to_le32(*from);
+	new_ext.ee_start_hi = start_ext.ee_start_hi = end_ext.ee_start_hi = 0;
+	lblock = le32_to_cpu(oext->ee_block);
+	new_end = le32_to_cpu(new_ext.ee_block)
+			+ le16_to_cpu(new_ext.ee_len) - 1;
+	new_phys_end = le32_to_cpu(new_ext.ee_start)
+			+ le16_to_cpu(new_ext.ee_len) - 1;
+
+	/* First original extent
+	 * dest         |---------------|
+	 * org  |---------------|
+	*/
+	if (le32_to_cpu(new_ext.ee_block) >
+		le32_to_cpu(oext->ee_block) &&
+	    le32_to_cpu(new_ext.ee_block) <
+		le32_to_cpu(oext->ee_block)
+		+ le16_to_cpu(oext->ee_len)) {
+		start_ext.ee_len = cpu_to_le32(le32_to_cpu(new_ext.ee_block)
+					- le32_to_cpu(oext->ee_block));
+		replaced += le16_to_cpu(oext->ee_len)
+				- le16_to_cpu(start_ext.ee_len);
+	} else if (oext > EXT_FIRST_EXTENT(org_path[depth].p_hdr)) {
+		/* We can merge previous extent. */
+		prev_ext = oext -1;
+		if ((le32_to_cpu(prev_ext->ee_start)
+			+ le32_to_cpu(prev_ext->ee_len))
+			== le32_to_cpu(new_ext.ee_start)) {
+			o_start = prev_ext;
+			start_ext.ee_len = cpu_to_le32(
+					le16_to_cpu(prev_ext->ee_len)
+					+ le16_to_cpu(new_ext.ee_len));
+			new_ext.ee_len = 0;
+		}
+	}
+
+	for (;;) {
+
+		/* The extent for destination must be found. */
+		EXT_ASSERT(oext && lblock == le32_to_cpu(oext->ee_block));
+		lblock += le16_to_cpu(oext->ee_len);
+
+		/* Middle of original extent
+		 * dest |-------------------|
+		 * org   |-----------------|
+		 */
+		if (le32_to_cpu(new_ext.ee_block) <=
+			le32_to_cpu(oext->ee_block) &&
+		    new_end >= le32_to_cpu(oext->ee_block)
+			 + le16_to_cpu(oext->ee_len) -1) {
+			replaced += le16_to_cpu(oext->ee_len);
+		}
+
+		/* Last original extent
+		 * dest |----------------|
+		 * org          |---------------|
+		 */
+		if (new_end >= le32_to_cpu(oext->ee_block) &&
+		    new_end < le32_to_cpu(oext->ee_block)
+				+ le16_to_cpu(oext->ee_len) - 1) {
+			end_ext.ee_len
+			    = cpu_to_le16(le32_to_cpu(oext->ee_block)
+				+ le16_to_cpu(oext->ee_len) -1 - new_end);
+			end_ext.ee_start
+			    = cpu_to_le32(le32_to_cpu(o_end->ee_start)
+				+ cpu_to_le16(oext->ee_len)
+				- cpu_to_le16(end_ext.ee_len));
+			end_ext.ee_block
+			    = cpu_to_le32(le32_to_cpu(o_end->ee_block)
+				+ le16_to_cpu(oext->ee_len)
+				- le16_to_cpu(end_ext.ee_len));
+			replaced += le16_to_cpu(oext->ee_len)
+				- le16_to_cpu(end_ext.ee_len);
+		}
+
+		/* Detected the block end, reached the number of replaced
+		 * blocks to dext->ee_len.  Then, merge the extent.
+		 */
+		if (oext == EXT_LAST_EXTENT(org_path[depth].p_hdr) ||
+		    new_end <= le32_to_cpu(oext->ee_block)
+				+ le16_to_cpu(oext->ee_len) - 1) {
+			if (ext3_ext_merge_extents(handle, org_tree->inode,
+				org_path, o_start, o_end,
+				&start_ext, &new_ext, &end_ext, replaced) < 0) {
+				return -EIO;
+			}
+
+			/* All expected blocks are replaced */
+			if (new_ext.ee_len <= 0) {
+				return 0;
+			}
+
+			/* re-calculate new_ext */
+			new_ext.ee_len = cpu_to_le32(le16_to_cpu(new_ext.ee_len)
+					- replaced);
+			new_ext.ee_block =
+				cpu_to_le32(le32_to_cpu(new_ext.ee_block)
+					+ replaced);
+			new_ext.ee_start =
+				cpu_to_le32(le32_to_cpu(new_ext.ee_start)
+					+ replaced);
+			replaced = 0;
+			start_ext.ee_len = end_ext.ee_len = 0;
+			o_start = NULL;
+
+			/* All expected blocks are replaced */
+			if (new_ext.ee_len <= 0) {
+				return 0;
+			}
+		}
+
+		/* Get next extent for original. */
+		if ((ret
+		  = ext3_ext_next_extent(org_tree->inode, org_path, &oext))
+								!= 0) {
+			if (ret == 1)
+				ret = -EIO;
+			return ret;
+		}
+		o_end = oext;
+		if (!o_start)
+			o_start = oext;
+	}
+}
+
+/**
+ * ext3_ext_replace_branches - replace original extents with new extents.
+ * @org_tree	Original extents tree
+ * @dest_tree	New extents tree
+ * @from_page	Page offset
+ * @count_page	Page count to be replaced
+ *
+ * This function returns 0 if succeed, otherwise returns error value.
+ * Replace extents for blocks from "from" to "from+count-1".
+ */
+static int
+ext3_ext_replace_branches(struct ext3_extents_tree *org_tree,
+			  struct ext3_extents_tree *dest_tree,
+			  pgoff_t from_page,  pgoff_t dest_from_page,
+			  pgoff_t count_page)
+{
+	struct ext3_ext_path *org_path = NULL;
+	struct ext3_ext_path *dest_path = NULL;
+	struct ext3_extent   *oext, *dext;
+	struct ext3_extent   tmp_ext;
+	int	err = 0;
+	int	 depth;
+	unsigned long from, count, dest_off, diff, replaced_count = 0;
+	handle_t *handle = NULL;
+	unsigned jnum;
+	struct inode *inode;
+
+
+	from = from_page << (PAGE_CACHE_SHIFT - dest_tree->inode->i_blkbits);
+	count = count_page << (PAGE_CACHE_SHIFT - dest_tree->inode->i_blkbits);
+	dest_off = dest_from_page << (PAGE_CACHE_SHIFT -
+		 dest_tree->inode->i_blkbits);
+	inode = org_tree->inode;
+
+	/* (blocks_per_page * count) * (extent_blocks + index_blocks)
+	 * + super_block + block_bitmap + group_descriptor
+	 * jnum = ext3_ext_writepage_trans_blocks(inode, count) + 3;
+	 */
+	/* TODO:
+	 * Need to consider the way of calculating journal blocks
+	 * because j_max_transaction_buffer may exceed 2048
+	 * if we have a deep depth.
+	 */
+	jnum = 2048;
+	handle = ext3_journal_start(inode, jnum);
+	if (IS_ERR(handle)) {
+		err = PTR_ERR(handle);
+		goto out;
+	}
+
+	/* Get the original extent for the block "from" */
+	org_path = ext3_ext_find_extent(org_tree, from, NULL);
+	if (IS_ERR(org_path)) {
+		err = PTR_ERR(org_path);
+		org_path = NULL;
+		goto out;
+	}
+
+	/* Get the destination extent for the head */
+	dest_path = ext3_ext_find_extent(dest_tree, dest_off, NULL);
+	if (IS_ERR(dest_path)) {
+		err = PTR_ERR(dest_path);
+		dest_path = NULL;
+		goto out;
+	}
+	depth = EXT_DEPTH(dest_tree);
+	dext = dest_path[depth].p_ext;
+	/* When dext is too large, pick up the target range. */
+	diff = dest_off - le32_to_cpu(dext->ee_block);
+	tmp_ext.ee_start = cpu_to_le32(le32_to_cpu(dext->ee_start) + diff);
+	tmp_ext.ee_block = cpu_to_le32(le32_to_cpu(dext->ee_block) + diff);
+	tmp_ext.ee_len = cpu_to_le16(le16_to_cpu(dext->ee_len) - diff);
+	tmp_ext.ee_start_hi = 0;
+	if (count < tmp_ext.ee_len) {
+		tmp_ext.ee_len = cpu_to_le16(count);
+	}
+	dext = &tmp_ext;
+
+	/* loop for the destination extents */
+	while (1) {
+		/* The extent for destination must be found. */
+		EXT_ASSERT(dext && dest_off == le32_to_cpu(dext->ee_block));
+
+		/* loop for the original extent blocks */
+		if ((err = ext3_ext_defrag_leaf_block(handle, org_tree,
+			org_path, dext, &from)) < 0) {
+			goto out;
+		}
+
+		replaced_count += le16_to_cpu(dext->ee_len);
+		dest_off += le16_to_cpu(dext->ee_len);
+		from += le16_to_cpu(dext->ee_len);
+
+		/* Already moved the expected blocks */
+		if (replaced_count >= count)
+			break;
+
+		/* get the next extent on both original and destination. */
+		err = ext3_ext_next_extent(dest_tree->inode, dest_path, &dext);
+		if (err != 0) {
+			if (err > 0) {
+				err = 0;
+			}
+			goto out;
+		}
+		if ((err =
+		  ext3_ext_next_extent(inode, org_path, &oext)) < 0) {
+			goto out;
+		}
+	}
+out:
+	if (handle) {
+		ext3_journal_stop(handle);
+	}
+	if (org_path) {
+		ext3_ext_drop_refs(org_path);
+		kfree(org_path);
+	}
+	if (dest_path) {
+		ext3_ext_drop_refs(dest_path);
+		kfree(dest_path);
+	}
+
+	return err;
+}
+
+/**
  * ext3_ext_remove_index_blocks - remove leaf blocks and index blocks
  * @handle 	handle
  * @dest_tree	extent tree of temporary inode
@@ -2581,6 +2996,73 @@ err:
 }
 
 /**
+ * ext3_ext_defrag_partial - defrag original file partially
+ * @filp:		pointer to file
+ * @org_tree:		extent tree of the original inode
+ * @dest_tree:		extent tree of the temporary inode
+ * @org_offset:		page index on original file
+ * @dest_offset:	page index on temporary file
+ * @nr_to_read:		the number of pages to read
+ *
+ * This function returns 0 if succeeded, otherwise returns error value
+ */
+static int
+ext3_ext_defrag_partial(struct file *filp,
+			struct ext3_extents_tree *org_tree,
+			struct ext3_extents_tree *dest_tree,
+			pgoff_t org_offset,
+			pgoff_t dest_offset,
+			pgoff_t nr_to_read)
+{
+	struct inode *inode = filp->f_dentry->d_inode;
+	struct address_space *mapping = inode->i_mapping;
+	struct page *page;
+	pgoff_t page_end = org_offset + nr_to_read - 1;
+	pgoff_t offset_in_page = PAGE_SIZE;
+	int ret = 0;
+
+	for (; org_offset <= page_end; ++org_offset, ++dest_offset) {
+		page = read_cache_page(inode->i_mapping,
+				       org_offset,
+				       (filler_t *)inode->i_mapping->a_ops->readpage,
+				       NULL);
+		if (IS_ERR(page)) {
+			ret = PTR_ERR(page);
+			break;
+		}
+
+		wait_on_page_locked(page);
+		lock_page(page);
+
+		/* release old bh and drop refs */
+		try_to_release_page(page, 0);
+
+		ret = ext3_ext_replace_branches(org_tree, dest_tree,
+						org_offset, dest_offset, 1);
+		if (ret < 0)
+			goto ERR;
+
+		if (org_offset == ((inode->i_size - 1) >> PAGE_SHIFT))
+			offset_in_page = (inode->i_size & (PAGE_CACHE_SIZE - 1));
+
+		ret = mapping->a_ops->prepare_write(filp, page,
+						    0, offset_in_page);
+		if (ret)
+			goto ERR;
+
+		ret = mapping->a_ops->commit_write(filp, page,
+						   0, offset_in_page);
+ERR:
+		unlock_page(page);
+		page_cache_release(page);
+
+		if (ret < 0)
+			break;
+	}
+	return (ret < 0 ? ret : 0);
+}
+
+/**
  * ext3_ext_new_extent_tree -  allocate contiguous blocks
  * @tmp_inode:		inode of the temporary file
  * @org_tree:		extent tree of the original inode
