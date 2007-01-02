From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: [PATCH 1/1] Extent overlap bugfix in ext4
Date: Tue, 2 Jan 2007 14:39:09 +0530
Message-ID: <20070102090909.GA20503@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: suparna@in.ibm.com, cmm@us.ibm.com, alex@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:55139 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932689AbXABJJT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 2 Jan 2007 04:09:19 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0299Gxk005218
	for <linux-ext4@vger.kernel.org>; Tue, 2 Jan 2007 04:09:16 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l0299GwA317296
	for <linux-ext4@vger.kernel.org>; Tue, 2 Jan 2007 02:09:16 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0299Fb7027354
	for <linux-ext4@vger.kernel.org>; Tue, 2 Jan 2007 02:09:16 -0700
To: linux-ext4@vger.kernel.org
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The ext4_ext_get_blocks() and ext4_ext_insert_extent() routines do not
check for extent overlap, when a new extent needs to be inserted in an
inode. An overlap is possible when the new extent being inserted has
ee_block that is not part of any of the existing extents, but the
tail/center portion of this new extent _is_. This is possible only when
we are writing/preallocating blocks across a hole.

This problem was first sighted while stress testing (using modified
fsx-linux stress test) persistent preallocation patches that I posted
earlier.  Though I am not able to reproduce this bug (extent overlap)
without the persistent preallocation patches (because a write through a
hole results in get_blocks() of a single block at a time), but I think
that it is an independant problem and should be solved with a separate
patch. Hence this patch.

Comments please. Thanks!

Signed-off-by: Amit Arora (aarora@in.ibm.com)
---
 fs/ext4/extents.c               |   71 +++++++++++++++++++++++++++++++++++++---
 include/linux/ext4_fs_extents.h |    1 
 2 files changed, 68 insertions(+), 4 deletions(-)

Index: linux-2.6.19.prealloc/fs/ext4/extents.c
===================================================================
--- linux-2.6.19.prealloc.orig/fs/ext4/extents.c	2007-01-02 14:21:57.000000000 +0530
+++ linux-2.6.19.prealloc/fs/ext4/extents.c	2007-01-02 14:22:00.000000000 +0530
@@ -1119,6 +1119,44 @@
 }
 
 /*
+ * ext4_ext_check_overlap:
+ * check if a portion of the "newext" extent overlaps with an
+ * existing extent.
+ */
+struct ext4_extent * ext4_ext_check_overlap(struct inode *inode,
+					struct ext4_extent *newext)
+{
+	struct ext4_ext_path *path;
+	struct ext4_extent *ex;
+	unsigned int depth, b1, b2, len1;
+
+	b1 = le32_to_cpu(newext->ee_block);
+	len1 = le16_to_cpu(newext->ee_len);
+	path = ext4_ext_find_extent(inode, b1, NULL);
+	if (IS_ERR(path))
+		return NULL;
+
+	depth = ext_depth(inode);
+	ex = path[depth].p_ext;
+	if (!ex)
+		return NULL;
+
+	b2 = ext4_ext_next_allocated_block(path);
+	if (b2 == EXT_MAX_BLOCK)
+		return NULL;
+	path = ext4_ext_find_extent(inode, b2, path);
+	if (IS_ERR(path))
+		return NULL;
+	BUG_ON(path[depth].p_hdr == NULL);
+	ex = path[depth].p_ext;
+
+	if (b1 + len1 > b2)
+		return ex;
+
+	return NULL;
+}
+
+/*
  * ext4_ext_insert_extent:
  * tries to merge requsted extent into the existing extent or
  * inserts requested extent as new one into the tree,
@@ -1129,7 +1167,7 @@
 				struct ext4_extent *newext)
 {
 	struct ext4_extent_header * eh;
-	struct ext4_extent *ex, *fex;
+	struct ext4_extent *ex, *fex, *rex;
 	struct ext4_extent *nearex; /* nearest extent */
 	struct ext4_ext_path *npath = NULL;
 	int depth, len, err, next;
@@ -1139,6 +1177,18 @@
 	ex = path[depth].p_ext;
 	BUG_ON(path[depth].p_hdr == NULL);
 
+	/* check for overlap */
+	rex = ext4_ext_check_overlap(inode, newext);
+	if (rex) {
+		printk(KERN_ERR "ERROR: ex=%u/%u overlaps newext=%u/%u\n",
+				le32_to_cpu(rex->ee_block),
+				le16_to_cpu(rex->ee_len),
+				le32_to_cpu(newext->ee_block),
+				le16_to_cpu(newext->ee_len));
+		ext4_ext_show_leaf(inode, path);
+		BUG();
+	}
+
 	/* try to insert block into found extent and return */
 	if (ex && ext4_can_extents_be_merged(inode, ex, newext)) {
 		ext_debug("append %d block to %d:%d (from %llu)\n",
@@ -1921,7 +1971,7 @@
 			int create, int extend_disksize)
 {
 	struct ext4_ext_path *path = NULL;
-	struct ext4_extent newex, *ex;
+	struct ext4_extent newex, *ex, *ex2;
 	ext4_fsblk_t goal, newblock;
 	int err = 0, depth;
 	unsigned long allocated = 0;
@@ -1984,6 +2034,10 @@
 		 */
 		if (ee_len > EXT_MAX_LEN)
 			goto out2;
+
+		if (iblock < ee_block && iblock + max_blocks >= ee_block)
+			allocated = ee_block - iblock;
+
 		/* if found extent covers block, simply return it */
 	        if (iblock >= ee_block && iblock < ee_block + ee_len) {
 			newblock = iblock - ee_block + ee_start;
@@ -2016,7 +2070,17 @@
 
 	/* allocate new block */
 	goal = ext4_ext_find_goal(inode, path, iblock);
-	allocated = max_blocks;
+
+	/* Check if we can really insert (iblock)::(iblock+max_blocks) extent */
+	newex.ee_block = cpu_to_le32(iblock);
+	if (!allocated) {
+		newex.ee_len = cpu_to_le16(max_blocks);
+		ex2 = ext4_ext_check_overlap(inode, &newex);
+		if (ex2)
+			allocated = le32_to_cpu(ex2->ee_block) - iblock;
+		else
+			allocated = max_blocks;
+	}
 	newblock = ext4_new_blocks(handle, inode, goal, &allocated, &err);
 	if (!newblock)
 		goto out2;
@@ -2024,7 +2088,6 @@
 			goal, newblock, allocated);
 
 	/* try to insert new extent into found leaf and return */
-	newex.ee_block = cpu_to_le32(iblock);
 	ext4_ext_store_pblock(&newex, newblock);
 	newex.ee_len = cpu_to_le16(allocated);
 	err = ext4_ext_insert_extent(handle, inode, path, &newex);
Index: linux-2.6.19.prealloc/include/linux/ext4_fs_extents.h
===================================================================
--- linux-2.6.19.prealloc.orig/include/linux/ext4_fs_extents.h	2007-01-02 14:21:57.000000000 +0530
+++ linux-2.6.19.prealloc/include/linux/ext4_fs_extents.h	2007-01-02 14:22:00.000000000 +0530
@@ -190,6 +190,7 @@
 
 extern int ext4_extent_tree_init(handle_t *, struct inode *);
 extern int ext4_ext_calc_credits_for_insert(struct inode *, struct ext4_ext_path *);
+extern struct ext4_extent * ext4_ext_check_overlap(struct inode *, struct ext4_extent *);
 extern int ext4_ext_insert_extent(handle_t *, struct inode *, struct ext4_ext_path *, struct ext4_extent *);
 extern int ext4_ext_walk_space(struct inode *, unsigned long, unsigned long, ext_prepare_callback, void *);
 extern struct ext4_ext_path * ext4_ext_find_extent(struct inode *, int, struct ext4_ext_path *);
--
Regards,
Amit Arora
