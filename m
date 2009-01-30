From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [RFC][PATCH 2/3] ext4: Exchange the blocks between two inodes
Date: Fri, 30 Jan 2009 15:13:37 +0900
Message-ID: <49829A91.8000800@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:40805 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbZA3GPo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Jan 2009 01:15:44 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: online defrag -- Exchange the blocks between two inodes

From: Akira Fujita <a-fujita@rs.jp.nec.com>

For each page, exchange the extents between original inode
and destination inode, and then write the file data of
the original inode to destination inode.


Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 fs/ext4/defrag.c |  754 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 753 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/defrag.c b/fs/ext4/defrag.c
index c9f903e..a281ff8 100644
--- a/fs/ext4/defrag.c
+++ b/fs/ext4/defrag.c
@@ -94,12 +94,764 @@ err:
 	return -EIO;
 }

+/**
+ * ext4_defrag_insert_across_blocks - Insert extents across leaf block
+ *
+ * @handle:		journal handle
+ * @org_inode:		original inode
+ * @o_start:		first original extent to be changed
+ * @o_end:		last original extent to be changed
+ * @start_ext:		first new extent to be inserted
+ * @new_ext:		middle of new extent to be inserted
+ * @end_ext:		last new extent to be inserted
+ *
+ * Allocate a new leaf block and insert extents into it. Return 0 on success,
+ * or a negative error value on failure.
+ */
+static int
+ext4_defrag_insert_across_blocks(handle_t *handle, struct inode *org_inode,
+		struct ext4_extent *o_start, struct ext4_extent *o_end,
+		struct ext4_extent *start_ext, struct ext4_extent *new_ext,
+		struct ext4_extent *end_ext)
+{
+	struct ext4_ext_path *org_path = NULL;
+	ext4_lblk_t eblock = 0;
+	int new_flag = 0;
+	int end_flag = 0;
+	int err;
+
+	if (ext4_ext_get_actual_len(start_ext) &&
+		ext4_ext_get_actual_len(new_ext) &&
+		ext4_ext_get_actual_len(end_ext)) {
+
+		if (o_start == o_end) {
+
+			/*       start_ext   new_ext    end_ext
+			 * dest |---------|-----------|--------|
+			 * org  |------------------------------|
+			 */
+
+			end_flag = 1;
+		} else {
+
+			/*       start_ext   new_ext   end_ext
+			 * dest |---------|----------|---------|
+			 * org  |---------------|--------------|
+			 */
+
+			o_end->ee_block = end_ext->ee_block;
+			o_end->ee_len =
+				cpu_to_le16(ext4_ext_get_actual_len(end_ext));
+			ext4_ext_store_pblock(o_end, ext_pblock(end_ext));
+		}
+
+		o_start->ee_len =
+			cpu_to_le16(ext4_ext_get_actual_len(start_ext));
+		new_flag = 1;
+
+	} else if (ext4_ext_get_actual_len(start_ext) &&
+			ext4_ext_get_actual_len(new_ext) &&
+			!ext4_ext_get_actual_len(end_ext) &&
+			o_start == o_end) {
+
+		/*	 start_ext	new_ext
+		 * dest |--------------|---------------|
+		 * org  |------------------------------|
+		 */
+
+		o_start->ee_len =
+			cpu_to_le16(ext4_ext_get_actual_len(start_ext));
+		new_flag = 1;
+
+	} else if (!ext4_ext_get_actual_len(start_ext) &&
+			ext4_ext_get_actual_len(new_ext) &&
+			ext4_ext_get_actual_len(end_ext) &&
+			o_start == o_end) {
+
+		/*	  new_ext	end_ext
+		 * dest |--------------|---------------|
+		 * org  |------------------------------|
+		 */
+
+		o_end->ee_block = end_ext->ee_block;
+		o_end->ee_len =
+			cpu_to_le16(ext4_ext_get_actual_len(end_ext));
+		ext4_ext_store_pblock(o_end, ext_pblock(end_ext));
+
+		/*
+		 * Set 0 to the extent block if new_ext was
+		 * the first block.
+		 */
+		if (!new_ext->ee_block)
+			eblock = 0;
+		else
+			eblock = le32_to_cpu(new_ext->ee_block);
+
+		new_flag = 1;
+	} else {
+		printk(KERN_ERR "ext4 defrag: Unexpected insert case\n");
+		return -EIO;
+	}
+
+	if (new_flag) {
+		org_path = ext4_ext_find_extent(org_inode, eblock, NULL);
+		if (IS_ERR(org_path)) {
+			err = PTR_ERR(org_path);
+			org_path = NULL;
+			goto out;
+		}
+		err = ext4_ext_insert_extent(handle, org_inode,
+					org_path, new_ext);
+		if (err)
+			goto out;
+	}
+
+	if (end_flag) {
+		org_path = ext4_ext_find_extent(org_inode,
+				le32_to_cpu(end_ext->ee_block) - 1, org_path);
+		if (IS_ERR(org_path)) {
+			err = PTR_ERR(org_path);
+			org_path = NULL;
+			goto out;
+		}
+		err = ext4_ext_insert_extent(handle, org_inode,
+					org_path, end_ext);
+		if (err)
+			goto out;
+	}
+out:
+	if (org_path) {
+		ext4_ext_drop_refs(org_path);
+		kfree(org_path);
+	}
+
+	return err;
+
+}
+
+/**
+ * ext4_defrag_insert_inside_block - Insert new extent to the extent block
+ *
+ * @o_start:		first original extent to be moved
+ * @o_end:		last original extent to be moved
+ * @start_ext:		first new extent to be inserted
+ * @new_ext:		middle of new extent to be inserted
+ * @end_ext:		last new extent to be inserted
+ * @eh:			extent header of target leaf block
+ * @replaced:		the number of blocks which will be replaced with new_ext
+ * @range_to_move:	used to decide how to insert extent
+ *
+ * Insert extents into the leaf block. The extent (@o_start) is overwritten
+ * by inserted extents.
+ */
+static int
+ext4_defrag_insert_inside_block(struct ext4_extent *o_start,
+		struct ext4_extent *o_end, struct ext4_extent *start_ext,
+		struct ext4_extent *new_ext, struct ext4_extent *end_ext,
+		struct ext4_extent_header *eh, ext4_fsblk_t replaced,
+		int range_to_move)
+{
+	int i = 0;
+	unsigned len;
+
+	/* Move the existing extents */
+	if (range_to_move && o_end < EXT_LAST_EXTENT(eh)) {
+		len = (unsigned long)(EXT_LAST_EXTENT(eh) + 1) -
+			(unsigned long)(o_end + 1);
+		memmove(o_end + 1 + range_to_move, o_end + 1, len);
+	}
+
+	/* Insert start entry */
+	if (ext4_ext_get_actual_len(start_ext))
+		o_start[i++].ee_len =
+			cpu_to_le16(ext4_ext_get_actual_len(start_ext));
+
+	/* Insert new entry */
+	if (ext4_ext_get_actual_len(new_ext)) {
+		o_start[i].ee_block = new_ext->ee_block;
+		o_start[i].ee_len = cpu_to_le16(replaced);
+		ext4_ext_store_pblock(&o_start[i++], ext_pblock(new_ext));
+	}
+
+	/* Insert end entry */
+	if (ext4_ext_get_actual_len(end_ext))
+		o_start[i] = *end_ext;
+
+	/* Increment the total entries counter on the extent block */
+	le16_add_cpu(&eh->eh_entries, range_to_move);
+
+	return 0;
+}
+
+/**
+ * ext4_defrag_insert_extents - Insert new extent
+ *
+ * @handle:	journal handle
+ * @org_inode:	original inode
+ * @org_path:	path indicates first extent to be defraged
+ * @o_start:	first original extent to be defraged
+ * @o_end:	last original extent to be defraged
+ * @start_ext:	first new extent to be inserted
+ * @new_ext:	middle of new extent to be inserted
+ * @end_ext:	last new extent to be inserted
+ * @replaced:	the number of blocks which will be replaced with new_ext
+ *
+ * Call the function to insert extents. If we cannot add more extents into
+ * the leaf block, we call ext4_defrag_insert_across_blocks() to create a
+ * new leaf block. Otherwise call ext4_defrag_insert_inside_block(). Return 0
+ * on success, or a negative error value on failure.
+ */
+static int
+ext4_defrag_insert_extents(handle_t *handle, struct inode *org_inode,
+		struct ext4_ext_path *org_path,
+		struct ext4_extent *o_start, struct ext4_extent *o_end,
+		struct ext4_extent *start_ext, struct ext4_extent *new_ext,
+		struct ext4_extent *end_ext, ext4_fsblk_t replaced)
+{
+	struct  ext4_extent_header *eh;
+	unsigned need_slots, slots_range;
+	int	range_to_move, depth, ret;
+
+	/*
+	 * The extents need to be inserted
+	 * start_extent + new_extent + end_extent.
+	 */
+	need_slots = (ext4_ext_get_actual_len(start_ext) ? 1 : 0) +
+			(ext4_ext_get_actual_len(end_ext) ? 1 : 0) +
+			(ext4_ext_get_actual_len(new_ext) ? 1 : 0);
+
+	/* The number of slots between start and end */
+	slots_range = ((unsigned long)(o_end + 1) - (unsigned long)o_start + 1)
+					/ sizeof(struct ext4_extent);
+
+	/* Range to move the end of extent */
+	range_to_move = need_slots - slots_range;
+	depth = org_path->p_depth;
+	org_path += depth;
+	eh = org_path->p_hdr;
+
+	if (depth) {
+		/* Register to journal */
+		ret = ext4_journal_get_write_access(handle, org_path->p_bh);
+		if (ret)
+			return ret;
+	}
+
+	/* Expansion */
+	if (range_to_move > 0 &&
+		(range_to_move > le16_to_cpu(eh->eh_max)
+			- le16_to_cpu(eh->eh_entries))) {
+
+		ret = ext4_defrag_insert_across_blocks(handle, org_inode,
+					o_start, o_end, start_ext, new_ext,
+					end_ext);
+		if (ret < 0)
+			return ret;
+	} else {
+		ret = ext4_defrag_insert_inside_block(o_start, o_end,
+					start_ext, new_ext, end_ext, eh,
+					replaced, range_to_move);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (depth) {
+		ret = ext4_handle_dirty_metadata(handle, org_inode,
+							org_path->p_bh);
+		if (ret)
+			return ret;
+	} else {
+		ret = ext4_mark_inode_dirty(handle, org_inode);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+
+}
+
+/**
+ * ext4_defrag_leaf_block - Defragmentation for one leaf extent block
+ *
+ * @handle:		journal handle
+ * @org_inode:		original inode
+ * @org_path:		path indicates first extent to be defraged
+ * @dext:		destination extent
+ * @from:		start offset on the target file
+ *
+ * In order to insert extents into the leaf block, we must divide the extent
+ * in the leaf block into three extents. The one is located to be inserted
+ * extents, and the others are located around it.
+ *
+ * Therefore, this function creates structures to save extents of the leaf
+ * block, and inserts extents by calling ext4_defrag_insert_extents() with
+ * created extents. Return 0 on success, or a negative error value on failure.
+ */
+static int
+ext4_defrag_leaf_block(handle_t *handle, struct inode *org_inode,
+		struct ext4_ext_path *org_path, struct ext4_extent *dext,
+		ext4_lblk_t *from)
+{
+	struct ext4_extent *oext, *o_start = NULL, *o_end = NULL, *prev_ext;
+	struct ext4_extent new_ext, start_ext, end_ext;
+	ext4_fsblk_t replaced = 0;
+	ext4_lblk_t new_end, lblock;
+	unsigned long depth;
+	unsigned short len;
+	ext4_fsblk_t new_phys_end;
+	int	ret;
+
+	depth = ext_depth(org_inode);
+	start_ext.ee_len = end_ext.ee_len = 0;
+	o_start = o_end = oext = org_path[depth].p_ext;
+	ext4_ext_store_pblock(&new_ext, ext_pblock(dext));
+	new_ext.ee_len =
+		cpu_to_le16(ext4_ext_get_actual_len(dext));
+	len = le16_to_cpu(new_ext.ee_len);
+	new_ext.ee_block = cpu_to_le32(*from);
+	lblock = le32_to_cpu(oext->ee_block);
+	new_end = le32_to_cpu(new_ext.ee_block)
+		+ le16_to_cpu(new_ext.ee_len) - 1;
+	new_phys_end = ext_pblock(&new_ext)
+		+ le16_to_cpu(new_ext.ee_len) - 1;
+
+	/*
+	 * First original extent
+	 * dest	 |---------------|
+	 * org  |---------------|
+	 */
+	if (le32_to_cpu(new_ext.ee_block) >
+		le32_to_cpu(oext->ee_block) &&
+		le32_to_cpu(new_ext.ee_block) <
+		le32_to_cpu(oext->ee_block)
+		+ ext4_ext_get_actual_len(oext)) {
+		start_ext.ee_len = cpu_to_le16(le32_to_cpu(new_ext.ee_block)
+					- le32_to_cpu(oext->ee_block));
+		replaced += ext4_ext_get_actual_len(oext)
+					- le16_to_cpu(start_ext.ee_len);
+	} else if (oext > EXT_FIRST_EXTENT(org_path[depth].p_hdr)) {
+		/* We can merge previous extent. */
+		prev_ext = oext - 1;
+		if (ext4_can_extents_be_merged(org_inode, prev_ext, &new_ext)) {
+			o_start = prev_ext;
+			start_ext.ee_len = cpu_to_le16(
+					ext4_ext_get_actual_len(prev_ext)
+					+ le16_to_cpu(new_ext.ee_len));
+			new_ext.ee_len = 0;
+		}
+	}
+
+	for (;;) {
+		/* The extent for destination must be found. */
+		BUG_ON(!oext || lblock != le32_to_cpu(oext->ee_block));
+		lblock += ext4_ext_get_actual_len(oext);
+
+		/*
+		 * Middle of original extent
+		 * dest |-------------------|
+		 * org   |-----------------|
+		 */
+		if (le32_to_cpu(new_ext.ee_block) <=
+			le32_to_cpu(oext->ee_block) &&
+			new_end >= le32_to_cpu(oext->ee_block)
+			+ ext4_ext_get_actual_len(oext) - 1)
+			replaced += ext4_ext_get_actual_len(oext);
+
+		/*
+		 * Last original extent
+		 * dest |----------------|
+		 * org	  |---------------|
+		 */
+		if (new_end >= le32_to_cpu(oext->ee_block) &&
+			new_end < le32_to_cpu(oext->ee_block)
+				+ ext4_ext_get_actual_len(oext) - 1) {
+			end_ext.ee_len
+				= cpu_to_le16(le32_to_cpu(oext->ee_block)
+				+ ext4_ext_get_actual_len(oext) - 1 - new_end);
+			ext4_ext_store_pblock(&end_ext, (ext_pblock(o_end)
+				+ ext4_ext_get_actual_len(oext)
+				- le16_to_cpu(end_ext.ee_len)));
+			end_ext.ee_block
+				= cpu_to_le32(le32_to_cpu(o_end->ee_block)
+				+ ext4_ext_get_actual_len(oext)
+				- le16_to_cpu(end_ext.ee_len));
+			replaced += ext4_ext_get_actual_len(oext)
+				- le16_to_cpu(end_ext.ee_len);
+		}
+
+		/*
+		 * Detected the block end, reached the number of replaced
+		 * blocks to dext->ee_len. Then merge the extent.
+		 */
+		if (oext == EXT_LAST_EXTENT(org_path[depth].p_hdr) ||
+			new_end <= le32_to_cpu(oext->ee_block)
+				+ ext4_ext_get_actual_len(oext) - 1) {
+			ret = ext4_defrag_insert_extents(handle, org_inode,
+					org_path, o_start, o_end, &start_ext,
+					&new_ext, &end_ext, replaced);
+			if (ret < 0)
+				return ret;
+
+			/* All expected blocks are replaced */
+			if (le16_to_cpu(new_ext.ee_len) <= 0)
+				return 0;
+
+			/* Re-calculate new_ext */
+			le16_add_cpu(&new_ext.ee_len, -replaced);
+			le32_add_cpu(&new_ext.ee_block, replaced);
+			ext4_ext_store_pblock(&new_ext, ext_pblock(&new_ext)
+					+ replaced);
+			replaced = 0;
+			start_ext.ee_len = end_ext.ee_len = 0;
+			o_start = NULL;
+
+			/* All expected blocks are replaced. */
+			if (le16_to_cpu(new_ext.ee_len) <= 0)
+				return 0;
+		}
+
+		/* Get the next extent for original. */
+		if (org_path)
+			ext4_ext_drop_refs(org_path);
+		org_path = ext4_ext_find_extent(org_inode, lblock, org_path);
+		if (IS_ERR(org_path)) {
+			ret = PTR_ERR(org_path);
+			org_path = NULL;
+			return ret;
+		}
+		depth = ext_depth(org_inode);
+		oext = org_path[depth].p_ext;
+		if (le32_to_cpu(oext->ee_block) + ext4_ext_get_actual_len(oext)
+			<= lblock)
+			return -ENOENT;
+
+		o_end = oext;
+		if (!o_start)
+			o_start = oext;
+	}
+}
+
+/**
+ * ext4_defrag_replace_branches - Replace original extents with new extents
+ *
+ * @handle:		journal handle
+ * @org_inode:		original inode
+ * @dest_inode:		destination inode
+ * @from:		block offset of org_inode
+ * @count:		block count to be replaced
+ *
+ * Replace original inode extents and destination inode extents every page.
+ * We implement this replacement in the following three steps:
+ * 1. Save the block information of original and destination inodes into
+ *    dummy extents.
+ * 2. Change the block information of original inode to point at the
+ *    destination inode blocks.
+ * 3. Change the block information of destination inode to point at the saved
+ *    original inode blocks in the dummy extents.
+ *
+ * Return 0 on success, or a negative error value on failure.
+ */
+static int
+ext4_defrag_replace_branches(handle_t *handle, struct inode *org_inode,
+			struct inode *dest_inode, ext4_lblk_t from,
+			ext4_lblk_t count)
+{
+	struct ext4_ext_path *org_path = NULL;
+	struct ext4_ext_path *dest_path = NULL;
+	struct ext4_extent *oext, *dext, *swap_ext;
+	struct ext4_extent tmp_ext, tmp_ext2;
+	ext4_lblk_t diff, org_diff, dest_off = from;
+	int err = 0;
+	int depth;
+	int replaced_count = 0;
+
+	/* Get the original extent for the block "from" */
+	org_path = ext4_ext_find_extent(org_inode, from, NULL);
+	if (IS_ERR(org_path)) {
+		err = PTR_ERR(org_path);
+		org_path = NULL;
+		goto out;
+	}
+
+	/* Get the destination extent for the head */
+	dest_path = ext4_ext_find_extent(dest_inode, dest_off, NULL);
+	if (IS_ERR(dest_path)) {
+		err = PTR_ERR(dest_path);
+		dest_path = NULL;
+		goto out;
+	}
+	depth = ext_depth(dest_inode);
+	dext = dest_path[depth].p_ext;
+	/* When dext is too large, pick up the target range. */
+	diff = dest_off - le32_to_cpu(dext->ee_block);
+	ext4_ext_store_pblock(&tmp_ext, ext_pblock(dext) + diff);
+	tmp_ext.ee_block = cpu_to_le32(le32_to_cpu(dext->ee_block) + diff);
+	tmp_ext.ee_len = cpu_to_le16(ext4_ext_get_actual_len(dext) - diff);
+	if (count < le16_to_cpu(tmp_ext.ee_len))
+		tmp_ext.ee_len = cpu_to_le16(count);
+	dext = &tmp_ext;
+
+	depth = ext_depth(org_inode);
+	oext = org_path[depth].p_ext;
+	org_diff = from - le32_to_cpu(oext->ee_block);
+	ext4_ext_store_pblock(&tmp_ext2, ext_pblock(oext) + org_diff);
+	tmp_ext2.ee_block = tmp_ext.ee_block;
+
+	/* Adjust extent length when blocksize != pagesize */
+	if (le16_to_cpu(tmp_ext.ee_len) <=
+		ext4_ext_get_actual_len(oext) - org_diff) {
+		tmp_ext2.ee_len = tmp_ext.ee_len;
+	} else {
+		tmp_ext2.ee_len = cpu_to_le16(ext4_ext_get_actual_len(oext)
+						- org_diff);
+		tmp_ext.ee_len = tmp_ext2.ee_len;
+	}
+	swap_ext = &tmp_ext2;
+
+	/* Loop for the destination extents */
+	while (1) {
+		/* The extent for destination must be found. */
+		BUG_ON(!dext || dest_off != le32_to_cpu(dext->ee_block));
+
+		/* Loop for the original extent blocks */
+		err = ext4_defrag_leaf_block(handle, org_inode,
+						org_path, dext, &from);
+		if (err < 0)
+			goto out;
+
+		/*
+		 * We need the function which fixes extent information for
+		 * inserting.
+		 * e.g. ext4_defrag_inset_extents()
+		 */
+		err = ext4_defrag_leaf_block(handle, dest_inode,
+					dest_path, swap_ext, &dest_off);
+		if (err < 0)
+			goto out;
+
+		replaced_count += ext4_ext_get_actual_len(dext);
+		dest_off += ext4_ext_get_actual_len(dext);
+		from += ext4_ext_get_actual_len(dext);
+
+		/* Already moved the expected blocks */
+		if (replaced_count >= count)
+			break;
+
+		if (org_path)
+			ext4_ext_drop_refs(org_path);
+		org_path = ext4_ext_find_extent(org_inode, from, NULL);
+		if (IS_ERR(org_path)) {
+			err = PTR_ERR(org_path);
+			org_path = NULL;
+			goto out;
+		}
+		depth = ext_depth(org_inode);
+		oext = org_path[depth].p_ext;
+		if (le32_to_cpu(oext->ee_block) + ext4_ext_get_actual_len(oext)
+			<= from) {
+			err = 0;
+			goto out;
+		}
+
+		if (dest_path)
+			ext4_ext_drop_refs(dest_path);
+		dest_path = ext4_ext_find_extent(dest_inode, dest_off, NULL);
+		if (IS_ERR(dest_path)) {
+			err = PTR_ERR(dest_path);
+			dest_path = NULL;
+			goto out;
+		}
+		depth = ext_depth(dest_inode);
+		dext = dest_path[depth].p_ext;
+		if (le32_to_cpu(dext->ee_block) + ext4_ext_get_actual_len(dext)
+			<= dest_off) {
+			err = 0;
+			goto out;
+		}
+
+		/* When dext is too large, pick up the target range. */
+		diff = dest_off - le32_to_cpu(dext->ee_block);
+		ext4_ext_store_pblock(&tmp_ext, ext_pblock(dext) + diff);
+		tmp_ext.ee_block =
+			cpu_to_le32(le32_to_cpu(dext->ee_block) + diff);
+		tmp_ext.ee_len = cpu_to_le16(ext4_ext_get_actual_len(dext)
+						- diff);
+
+		if (count - replaced_count < le16_to_cpu(tmp_ext.ee_len))
+			tmp_ext.ee_len = cpu_to_le16(count - replaced_count);
+
+		dext = &tmp_ext;
+
+		org_diff = from - le32_to_cpu(oext->ee_block);
+		ext4_ext_store_pblock(&tmp_ext2, ext_pblock(oext) + org_diff);
+		tmp_ext2.ee_block = tmp_ext.ee_block;
+
+		/* Adjust extent length when blocksize != pagesize */
+		if (le16_to_cpu(tmp_ext.ee_len) <=
+			ext4_ext_get_actual_len(oext) - org_diff) {
+			tmp_ext2.ee_len = tmp_ext.ee_len;
+		} else {
+			tmp_ext2.ee_len = cpu_to_le16(
+						ext4_ext_get_actual_len(oext)
+						- org_diff);
+			tmp_ext.ee_len = tmp_ext2.ee_len;
+		}
+		swap_ext = &tmp_ext2;
+	}
+
+out:
+	if (org_path) {
+		ext4_ext_drop_refs(org_path);
+		kfree(org_path);
+	}
+	if (dest_path) {
+		ext4_ext_drop_refs(dest_path);
+		kfree(dest_path);
+	}
+
+	return err;
+}
+
+/**
+ * ext4_defrag_partial - Defrag a file per page
+ *
+ * @o_filp:			file structure of original file
+ * @dest_inode:			destination inode
+ * @org_page_offset:		page index on original file
+ * @data_offset_in_page:	block index where data swapping starts
+ * @block_len_in_page:		the number of blocks to be swapped
+ *
+ * Save the data in original inode blocks and replace original inode extents
+ * with destination inode extents by calling ext4_defrag_replace_branches().
+ * Finally, write out the saved data in new original inode blocks. Return 0
+ * on success, or a negative error value on failure.
+ */
 static int
 ext4_defrag_partial(struct file *o_filp, struct inode *dest_inode,
 			pgoff_t org_page_offset, int data_offset_in_page,
 			int block_len_in_page)
 {
-	return 0;
+	struct inode *org_inode = o_filp->f_dentry->d_inode;
+	struct address_space *mapping = org_inode->i_mapping;
+	struct buffer_head *bh;
+	struct page *page = NULL;
+	const struct address_space_operations *a_ops = mapping->a_ops;
+	handle_t *handle;
+	ext4_lblk_t org_blk_offset;
+	long long offs = org_page_offset << PAGE_CACHE_SHIFT;
+	unsigned long blocksize = org_inode->i_sb->s_blocksize;
+	unsigned int w_flags = 0;
+	unsigned int tmp_data_len;
+	unsigned data_len;
+	void *fsdata;
+	int ret, i, jblocks;
+	int blocks_per_page = PAGE_CACHE_SIZE >> org_inode->i_blkbits;
+
+	/*
+	 * It needs twice the amount of ordinary journal buffers because
+	 * inode and dest_inode may change each different metadata blocks.
+	 */
+	jblocks = ext4_writepage_trans_blocks(org_inode) * 2;
+	handle = ext4_journal_start(org_inode, jblocks);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		return ret;
+	}
+
+	if (segment_eq(get_fs(), KERNEL_DS))
+		w_flags |= AOP_FLAG_UNINTERRUPTIBLE;
+
+	org_blk_offset = org_page_offset * blocks_per_page +
+							data_offset_in_page;
+	offs = (long long)org_blk_offset << org_inode->i_blkbits;
+
+	/* Calculate data_len */
+	if ((org_blk_offset + block_len_in_page - 1) ==
+			((org_inode->i_size - 1) >> org_inode->i_blkbits)) {
+		/* the case which we replace the last block */
+		tmp_data_len = org_inode->i_size & (blocksize - 1);
+		/*
+		 * If data_len equal zero, it shows data_len is multiples of
+		 * blocksize. So we set appropriate value.
+		 */
+		if (tmp_data_len == 0)
+			tmp_data_len = blocksize;
+
+		data_len = tmp_data_len +
+			((block_len_in_page - 1) << org_inode->i_blkbits);
+	} else {
+		data_len = block_len_in_page << org_inode->i_blkbits;
+	}
+
+	up_write(&EXT4_I(org_inode)->i_data_sem);
+	ret = a_ops->write_begin(o_filp, mapping, offs, data_len, w_flags,
+								&page, &fsdata);
+	down_write(&EXT4_I(org_inode)->i_data_sem);
+
+	if (unlikely(ret < 0))
+		goto out;
+
+	if (!PageUptodate(page)) {
+		up_write(&EXT4_I(org_inode)->i_data_sem);
+		mapping->a_ops->readpage(o_filp, page);
+		down_write(&EXT4_I(org_inode)->i_data_sem);
+		lock_page(page);
+	}
+
+	/*
+	 * try_to_release_page() doesn't call releasepage in writeback mode.
+	 * We should care about the order of writing to the same file
+	 * by multiple defrag processes.
+	 * It needs to call wait_on_page_writeback() to wait for the
+	 * writeback of the page.
+	 */
+	if (PageWriteback(page))
+		wait_on_page_writeback(page);
+
+	/* Release old bh and drop refs */
+	try_to_release_page(page, 0);
+	ret = ext4_defrag_replace_branches(handle, org_inode, dest_inode,
+						org_blk_offset,
+						block_len_in_page);
+	if (ret < 0)
+		goto out;
+
+	/* Clear the inode cache not to refer to the old data */
+	ext4_ext_invalidate_cache(org_inode);
+
+	if (!page_has_buffers(page))
+		create_empty_buffers(page, 1 << org_inode->i_blkbits, 0);
+
+	bh = page_buffers(page);
+	for (i = 0; i < data_offset_in_page; i++)
+		bh = bh->b_this_page;
+
+	for (i = 0; i < block_len_in_page; i++) {
+		up_write(&EXT4_I(org_inode)->i_data_sem);
+		ret = ext4_get_block(org_inode, (sector_t)(org_blk_offset + i),
+									bh, 0);
+		down_write(&EXT4_I(org_inode)->i_data_sem);
+
+		if (ret < 0)
+			goto out;
+
+		if (bh->b_this_page != NULL)
+			bh = bh->b_this_page;
+	}
+
+	ret = a_ops->write_end(o_filp, mapping, offs, data_len, data_len, page,
+									fsdata);
+	page = NULL;
+
+out:
+	if (unlikely(page)) {
+		if (PageLocked(page))
+			unlock_page(page);
+		page_cache_release(page);
+	}
+	ext4_journal_stop(handle);
+
+	return ret < 0 ? ret : 0;
 }

 /**
