From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: [RFC][Patch 2/2] Persistent preallocation in ext4
Date: Fri, 15 Dec 2006 18:09:20 +0530
Message-ID: <20061215123920.GB24572@amitarora.in.ibm.com>
References: <20061205134338.GA1894@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: suparna@in.ibm.com, cmm@us.ibm.com, suzuki@in.ibm.com,
	alex@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34102 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752076AbWLOMj2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Dec 2006 07:39:28 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kBFCdNOa026507
	for <linux-ext4@vger.kernel.org>; Fri, 15 Dec 2006 07:39:23 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kBFCdN3a305728
	for <linux-ext4@vger.kernel.org>; Fri, 15 Dec 2006 07:39:24 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kBFCdN0i002407
	for <linux-ext4@vger.kernel.org>; Fri, 15 Dec 2006 07:39:23 -0500
To: linux-ext4@vger.kernel.org
Content-Disposition: inline
In-Reply-To: <20061205134338.GA1894@amitarora.in.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is the second patch in the set.

This patch makes writing to the unitialized extent possible. A write operation on an unitialized extent *may* (depending on the relative block location in the extent and number of blocks being written) result in spliting the extent. There are three possibilities:
1. The extent does not split : This will happen when the entire extent is being written to. In this case the extent will be marked "initialized" and merged (if possible) with the neighbouring extents in the tree.
2. The extent splits in two portions : This will happen when someone is writing to any one end of the extent (i.e. not in the middle, and not to the entire extent). This will result in breaking the extent in two portions, an initialized extent (the set of blocks being written to) and an uninitialized extent (rest of the blocks in the parent extent).
3. The extent is split in three parts: This occurs when someone writes in the middle of the extent. It will result into three extents, two uninitialized (at the both ends) and one initialized (in middle).

Since the extent merge logic was getting redundant, it has been put into a new function ext4_ext_try_to_merge(). This gets called from ext4_ext_insert_extent() and ext4_ext_get_blocks(), when required.


Signed-off-by: Amit Arora (aarora@in.ibm.com)

---
 fs/ext4/extents.c               |  200 ++++++++++++++++++++++++++++++++++------
 include/linux/ext4_fs_extents.h |    1 
 2 files changed, 171 insertions(+), 30 deletions(-)

Index: linux-2.6.19.prealloc/fs/ext4/extents.c
===================================================================
--- linux-2.6.19.prealloc.orig/fs/ext4/extents.c	2006-12-15 17:53:48.000000000 +0530
+++ linux-2.6.19.prealloc/fs/ext4/extents.c	2006-12-15 17:54:32.000000000 +0530
@@ -1131,6 +1131,50 @@
 }
 
 /*
+ * ext4_ext_try_to_merge:
+ * tries to merge the "ex" extent to the next extent in the tree.
+ * It always tries to merge towards right. If you want to merge towards
+ * left, pass "ex - 1" as argument instead of "ex".
+ * Returns 0 if the extents (ex and ex+1) were _not_ merged and returns
+ * 1 if they got merged.
+ */
+int ext4_ext_try_to_merge(struct inode *inode,
+				struct ext4_ext_path *path,
+				struct ext4_extent *ex)
+{
+	struct ext4_extent_header *eh;
+	unsigned int depth, len;
+	int merge_done=0, uninitialized = 0;
+
+	depth = ext_depth(inode);
+	BUG_ON(path[depth].p_hdr == NULL);
+	eh = path[depth].p_hdr;
+
+	while (ex < EXT_LAST_EXTENT(eh)) {
+		if (!ext4_can_extents_be_merged(inode, ex, ex + 1))
+			break;
+		/* merge with next extent! */
+		if (ext4_ext_is_uninitialized(ex))
+			uninitialized = 1;
+		ex->ee_len = cpu_to_le16(ext4_ext_get_actual_len(ex)
+					+ ext4_ext_get_actual_len(ex + 1));
+		if(uninitialized)
+			ext4_ext_mark_uninitialized(ex);
+
+		if (ex + 1 < EXT_LAST_EXTENT(eh)) {
+			len = (EXT_LAST_EXTENT(eh) - ex - 1)
+					* sizeof(struct ext4_extent);
+			memmove(ex + 1, ex + 2, len);
+		}
+		eh->eh_entries = cpu_to_le16(le16_to_cpu(eh->eh_entries)-1);
+		merge_done = 1;
+		BUG_ON(eh->eh_entries == 0);
+	}
+
+	return merge_done;
+}
+
+/*
  * ext4_ext_insert_extent:
  * tries to merge requsted extent into the existing extent or
  * inserts requested extent as new one into the tree,
@@ -1265,25 +1309,7 @@
 
 merge:
 	/* try to merge extents to the right */
-	while (nearex < EXT_LAST_EXTENT(eh)) {
-		if (!ext4_can_extents_be_merged(inode, nearex, nearex + 1))
-			break;
-		/* merge with next extent! */
-		if (ext4_ext_is_uninitialized(nearex))
-			uninitialized = 1;
-		nearex->ee_len = cpu_to_le16(ext4_ext_get_actual_len(nearex)
-					+ ext4_ext_get_actual_len(nearex + 1));
-		if(uninitialized)
-			ext4_ext_mark_uninitialized(nearex);
-
-		if (nearex + 1 < EXT_LAST_EXTENT(eh)) {
-			len = (EXT_LAST_EXTENT(eh) - nearex - 1)
-					* sizeof(struct ext4_extent);
-			memmove(nearex + 1, nearex + 2, len);
-		}
-		eh->eh_entries = cpu_to_le16(le16_to_cpu(eh->eh_entries)-1);
-		BUG_ON(eh->eh_entries == 0);
-	}
+	ext4_ext_try_to_merge(inode, path, nearex);
 
 	/* try to merge extents to the left */
 
@@ -1952,9 +1978,10 @@
 			int create, int extend_disksize)
 {
 	struct ext4_ext_path *path = NULL;
-	struct ext4_extent newex, *ex;
+	struct ext4_extent_header *eh;
+	struct ext4_extent newex, *ex, *ex1 = NULL, *ex2 = NULL, *ex3 = NULL;
 	ext4_fsblk_t goal, newblock;
-	int err = 0, depth;
+	int err = 0, depth, ret;
 	unsigned long allocated = 0;
 
 	__clear_bit(BH_New, &bh_result->b_state);
@@ -2001,6 +2028,7 @@
 	 * this is why assert can't be put in ext4_ext_find_extent()
 	 */
 	BUG_ON(path[depth].p_ext == NULL && depth != 0);
+	eh = path[depth].p_hdr;
 
 	if ((ex = path[depth].p_ext)) {
 	        unsigned long ee_block = le32_to_cpu(ex->ee_block);
@@ -2008,15 +2036,9 @@
 		unsigned short ee_len;
 
 		/*
-		 * Allow future support for preallocated extents to be added
-		 * as an RO_COMPAT feature:
 		 * Uninitialized extents are treated as holes, except that
-		 * we avoid (fail) allocating new blocks during a write.
+		 * we split out initialized portions during a write.
 		 */
-		if (le16_to_cpu(ex->ee_len) > EXT_MAX_LEN
-				&& create != EXT4_CREATE_UNINITIALIZED_EXT)
-			goto out2;
-
 		ee_len  = ext4_ext_get_actual_len(ex);
 		/* if found extent covers block, simply return it */
 	        if (iblock >= ee_block && iblock < ee_block + ee_len) {
@@ -2026,10 +2048,126 @@
 			ext_debug("%d fit into %lu:%d -> %llu\n", (int) iblock,
 					ee_block, ee_len, newblock);
 			/* Do not put uninitialized extent in the cache */
-			if(!ext4_ext_is_uninitialized(ex))
+			if(!ext4_ext_is_uninitialized(ex)) {
 				ext4_ext_put_in_cache(inode, ee_block, ee_len,
 					ee_start, EXT4_EXT_CACHE_EXTENT);
-			goto out;
+				goto out;
+			}
+			if(create == EXT4_CREATE_UNINITIALIZED_EXT)
+				goto out;
+			if (!create)
+				goto out2;
+
+			/* Initializing write within an uninitialized extent */
+			/* Split in upto 3 extents .
+			 * There are three possibilities:
+			 *	a> No split required: Entire extent should be
+			 *		initialized.
+			 *	b> Split into two extents: Only one end of the
+			 *		extent is being written to.
+			 *	c> Split into three extents: Somone is writing
+			 *		in middle of the extent.
+			 */
+			ex2 = ex;
+
+			/* ex3: to ee_block + ee_len : uninitialised */
+			if (allocated > max_blocks) {
+				unsigned int newdepth;
+				ex3 = &newex;
+				ex3->ee_block = cpu_to_le32(iblock
+					+ max_blocks);
+				ext4_ext_store_pblock(ex3, newblock
+					+ max_blocks);
+				ex3->ee_len = cpu_to_le16(allocated
+					- max_blocks);
+				ext4_ext_mark_uninitialized(ex3);
+				err = ext4_ext_insert_extent(handle, inode,
+					path, ex3);
+				if (err)
+					goto out2;
+
+				/* The depth, and hence eh & ex might change
+				 * as part of the insert above.
+				 */
+				newdepth = ext_depth(inode);
+				if(newdepth != depth)
+				{
+					depth=newdepth;
+					path = ext4_ext_find_extent(inode,
+							iblock, NULL);
+					if (IS_ERR(path)) {
+						err = PTR_ERR(path);
+						path = NULL;
+						goto out2;
+					}
+					eh = path[depth].p_hdr;
+					ex = path[depth].p_ext;
+					ex2 = ex;
+				}
+				allocated = max_blocks;
+			}
+
+			/* ex1: ee_block to iblock - 1 : uninitialized */
+			if (iblock > ee_block) {
+				ex1 = ex;
+				ex1->ee_len = cpu_to_le16(iblock - ee_block);
+				ext4_ext_mark_uninitialized(ex1);
+				ex2 = &newex;
+			}
+
+			/* ex2: iblock to iblock + maxblocks-1 : initialised */
+			ex2->ee_block = cpu_to_le32(iblock);
+			ex2->ee_start	= newblock;
+			ext4_ext_store_pblock(ex2, newblock);
+			ex2->ee_len = cpu_to_le16(allocated);
+			if (ex2 != ex)
+				goto insert;
+
+			if ((err = ext4_ext_get_access(handle, inode,
+					path + depth)))
+				goto out2;
+
+			/* New (initialized) extent starts from the first block
+			 * in the current extent. i.e., ex2 == ex
+			 * We have to see if it can be merged with the extent
+			 * on the left.
+			 */
+			if(ex2 > EXT_FIRST_EXTENT(eh)) {
+			/* To merge left, pass "ex2 - 1" to try_to_merge(),
+			 * since it merges towards right _only_.
+			 */
+				ret = ext4_ext_try_to_merge(inode,
+						path, ex2 - 1);
+				if(ret) {
+					err = ext4_ext_correct_indexes(handle,
+								inode, path);
+					if (err)
+						goto out2;
+					depth = ext_depth(inode);
+					ex2--;
+				}
+			}
+
+			/* Try to Merge towards right. This might be required
+			 * only when the whole extent is being written to.
+			 * i.e. ex2==ex and ex3==NULL.
+			 */
+			if(!ex3) {
+				ret = ext4_ext_try_to_merge(inode, path, ex2);
+				if(ret) {
+					err = ext4_ext_correct_indexes(handle,
+								inode, path);
+					if (err)
+						goto out2;
+				}
+			}
+
+			/* Mark modified extent as dirty */
+			err = ext4_ext_dirty(handle, inode,
+				path + depth);
+			if (err)
+				goto out2;
+			goto outnew;
 		}
 	}
 
@@ -2065,6 +2203,7 @@
 	newex.ee_len = cpu_to_le16(allocated);
 	if(create == EXT4_CREATE_UNINITIALIZED_EXT)  /* Mark uninitialized */
 		ext4_ext_mark_uninitialized(&newex);
+insert:
 	err = ext4_ext_insert_extent(handle, inode, path, &newex);
 	if (err)
 		goto out2;
@@ -2074,6 +2213,7 @@
 
 	/* previous routine could use block we allocated */
 	newblock = ext_pblock(&newex);
+outnew:
 	__set_bit(BH_New, &bh_result->b_state);
 
 	/* Cache only when it is _not_ an uninitialized extent */
Index: linux-2.6.19.prealloc/include/linux/ext4_fs_extents.h
===================================================================
--- linux-2.6.19.prealloc.orig/include/linux/ext4_fs_extents.h	2006-12-15 17:50:08.000000000 +0530
+++ linux-2.6.19.prealloc/include/linux/ext4_fs_extents.h	2006-12-15 17:54:17.000000000 +0530
@@ -203,6 +203,7 @@
 
 extern int ext4_extent_tree_init(handle_t *, struct inode *);
 extern int ext4_ext_calc_credits_for_insert(struct inode *, struct ext4_ext_path *);
+extern int ext4_ext_try_to_merge(struct inode *, struct ext4_ext_path *, struct ext4_extent *);
 extern int ext4_ext_insert_extent(handle_t *, struct inode *, struct ext4_ext_path *, struct ext4_extent *);
 extern int ext4_ext_walk_space(struct inode *, unsigned long, unsigned long, ext_prepare_callback, void *);
 extern struct ext4_ext_path * ext4_ext_find_extent(struct inode *, int, struct ext4_ext_path *);
