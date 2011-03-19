From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [Ext4 punch hole 1/4 v4] Ext4 Punch Hole Support: Convert Blocks
 to Uninit Exts
Date: Fri, 18 Mar 2011 20:03:44 -0700
Message-ID: <4D841D10.80900@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:52178 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab1CSDDp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Mar 2011 23:03:45 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e32.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p2J2r1MK016549
	for <linux-ext4@vger.kernel.org>; Fri, 18 Mar 2011 20:53:01 -0600
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p2J33hgp103582
	for <linux-ext4@vger.kernel.org>; Fri, 18 Mar 2011 21:03:43 -0600
Received: from d03av05.boulder.ibm.com (loopback [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p2J33hFO022940
	for <linux-ext4@vger.kernel.org>; Fri, 18 Mar 2011 21:03:43 -0600
Received: from [9.11.169.111] (IBM-3CEFE379E05.tucson.ibm.com [9.11.169.111])
	by d03av05.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id p2J33g0p022927
	for <linux-ext4@vger.kernel.org>; Fri, 18 Mar 2011 21:03:42 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds a function to convert a range of blocks
to an uninitialized extent.  This function will
be used to first convert the blocks to extents before
punching them out.

This function also adds a routine to split an extent at
a given block.  This routine is used when a range of
blocks to be converted is only partially contained in
an extent.

Signed-off-by: Allison Henderson <achender@us.ibm.com>
---
:100644 100644 9375e7c... b78b41f... M	fs/ext4/extents.c
 fs/ext4/extents.c |  209 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 209 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 9375e7c..b78b41f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2169,6 +2169,109 @@ static int ext4_remove_blocks(handle_t *handle, struct inode *inode,
 	return 0;
 }
 
+/*
+ * ext4_split_extents() Splits a given extent at the block "split"
+ * @handle: The journal handle
+ * @inode: The file inode
+ * @split: The block where the extent will be split
+ * @path: The path to the extent
+ * @flags: flags used to insert the new extent
+ */
+static int ext4_split_extents(handle_t *handle,
+					struct inode *inode,
+					ext4_lblk_t split,
+					struct ext4_ext_path *path,
+					int flags)
+{
+	struct ext4_extent *ex, newex, orig_ex;
+	struct ext4_extent *ex1 = NULL;
+	struct ext4_extent *ex2 = NULL;
+	struct ext4_extent_header *eh;
+	ext4_lblk_t ee_block;
+	unsigned int ee_len, depth;
+	ext4_fsblk_t newblock, origblock;
+	int err = 0;
+
+	ext_debug("ext4_split_extent: inode %lu, split %u\n",
+				inode->i_ino, split);
+	ext4_ext_show_leaf(inode, path);
+
+	depth = ext_depth(inode);
+	eh = path[depth].p_hdr;
+	ex = path[depth].p_ext;
+	ee_block = le32_to_cpu(ex->ee_block);
+	ee_len = ext4_ext_get_actual_len(ex);
+
+	/* if the block is not actually in the extent, go to out */
+	if (split > ee_block+ee_len || split < ee_block)
+		goto out;
+
+	origblock = ee_block + ext4_ext_pblock(ex);
+	newblock = split - ee_block + ext4_ext_pblock(ex);
+	ext_debug("The new block is %llu, the orig block is: %llu\n",
+				newblock, origblock);
+
+	/* save original block in case split fails */
+	orig_ex.ee_block = ex->ee_block;
+	orig_ex.ee_len   = cpu_to_le16(ee_len);
+	ext4_ext_store_pblock(&orig_ex, ext4_ext_pblock(ex));
+
+	err = ext4_ext_get_access(handle, inode, path + depth);
+	if (err)
+		goto out;
+
+	ex1 = ex;
+	ex1->ee_len = cpu_to_le16(split-ee_block);
+
+	ex2 = &newex;
+	ex2->ee_len = cpu_to_le16(ee_len-(split-ee_block));
+	ex2->ee_block = split;
+	ext4_ext_store_pblock(ex2, newblock);
+
+	if (ex1->ee_block == ex2->ee_block) {
+		/* Mark modified extent as dirty */
+		err = ext4_ext_dirty(handle, inode, path + depth);
+		ext_debug("out here\n");
+		goto out;
+	}
+
+	/*
+	 * If this leaf cannot fit in any more extents
+	 * insert it into another leaf
+	 */
+	if (EXT_LAST_EXTENT(eh) >=  EXT_MAX_EXTENT(eh)) {
+		err = ext4_ext_insert_extent(handle, inode, path,
+				&newex, flags);
+		if (err)
+			goto fix_extent_len;
+
+		depth = ext_depth(inode);
+		path = ext4_ext_find_extent(inode, split, path);
+	}
+
+	/* otherwise just scoot all ther other extents down  */
+	else{
+		memmove(ex1+2, ex1+1,
+			(EXT_LAST_EXTENT(eh) - ex1) *
+			sizeof(struct ext4_extent));
+		memcpy(ex1+1, ex2, sizeof(struct ext4_extent));
+		le16_add_cpu(&(eh->eh_entries), 1);
+	}
+
+out:
+	ext4_ext_show_leaf(inode, path);
+	return err;
+
+fix_extent_len:
+	ex->ee_block = orig_ex.ee_block;
+	ex->ee_len   = orig_ex.ee_len;
+	ext4_ext_store_pblock(ex, ext4_ext_pblock(&orig_ex));
+	ext4_ext_mark_uninitialized(ex);
+	ext4_ext_dirty(handle, inode, path + depth);
+
+	return err;
+}
+
 static int
 ext4_ext_rm_leaf(handle_t *handle, struct inode *inode,
 		struct ext4_ext_path *path, ext4_lblk_t start)
@@ -3598,6 +3701,112 @@ out_stop:
 	ext4_journal_stop(handle);
 }
 
+/*
+ * ext4_ext_convert_blocks_uninit()
+ * Converts a range of blocks to uninitialized
+ *
+ * @handle: The journal handle
+ * @inode:  The files inode
+ * @lblock: The logical block where the conversion will start
+ * @len:    The max number of blocks to convert
+ *
+ * Returns the number of blocks successfully converted
+ */
+static int ext4_ext_convert_blocks_uninit(handle_t *handle,
+				struct inode *inode,
+				ext4_lblk_t lblock,
+				ext4_lblk_t len){
+
+	ext4_lblk_t ee_block, iblock, blocks_checked;
+	struct ext4_ext_path *path;
+	struct ext4_extent *ex;
+	unsigned int ee_len;
+	int ret = 0;
+	int err = 0;
+
+	iblock = lblock;
+	while (iblock < lblock+len) {
+		blocks_checked = 1;
+		path = ext4_ext_find_extent(inode, iblock, NULL);
+
+		if (path == NULL)
+			goto next;
+
+		err = ext4_ext_get_access(handle, inode, path);
+		if (err < 0)
+			goto next;
+
+		ex = path->p_ext;
+		if (ex == NULL)
+			goto next;
+
+		ee_block = le32_to_cpu(ex->ee_block);
+		ee_len = ext4_ext_get_actual_len(ex);
+
+		if (ee_block > iblock ||
+			ee_block+ee_len <= iblock)
+			goto next;
+
+		/*
+		 * If the block is in the middle of the extent,
+		 * split the extent to remove the head.
+		 * Then find the new extent that contains the block
+		 */
+		if (ee_block < iblock) {
+			err = ext4_split_extents(handle, inode,
+						iblock, path, 0);
+
+			if (err)
+				goto next;
+
+			/* Release this path before we get the next one */
+			ext4_ext_drop_refs(path);
+			kfree(path);
+
+			path = ext4_ext_find_extent(inode, iblock, NULL);
+
+			if (path == NULL)
+				goto next;
+
+			ex = path->p_ext;
+			if (ex == NULL)
+				goto next;
+
+			ee_block = le32_to_cpu(ex->ee_block);
+			ee_len = ext4_ext_get_actual_len(ex);
+		}
+
+		/*
+		 * If the extent exceeds len, split
+		 * the extent to remove the tail
+		 */
+		if (ee_len > len) {
+			err = ext4_split_extents(handle, inode,
+					lblock+len, path, 0);
+
+			if (err)
+				goto next;
+
+			ee_len = ext4_ext_get_actual_len(ex);
+		}
+
+		/* Mark the extent uninitialized */
+		ext4_ext_mark_uninitialized(ex);
+
+		blocks_checked = ee_len;
+		ret += ee_len;
+next:
+		if (path) {
+			ext4_ext_drop_refs(path);
+			kfree(path);
+		}
+		iblock += blocks_checked;
+	}
+
+	return ret;
+}
+
+
 static void ext4_falloc_update_inode(struct inode *inode,
 				int mode, loff_t new_size, int update_ctime)
 {
-- 
1.7.1

