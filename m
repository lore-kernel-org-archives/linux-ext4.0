From: Avantika Mathur <mathur@us.ibm.com>
Subject: [PATCH] extents.c remove inlines
Date: Thu, 02 Nov 2006 15:53:53 -0800
Message-ID: <1162511634.10173.0.camel@dyn9047017105.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:62385 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1752838AbWKBXyW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Nov 2006 18:54:22 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kA2NsLN0022958
	for <linux-ext4@vger.kernel.org>; Thu, 2 Nov 2006 18:54:21 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kA2NsKXm148760
	for <linux-ext4@vger.kernel.org>; Thu, 2 Nov 2006 18:54:20 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kA2NsK4A017503
	for <linux-ext4@vger.kernel.org>; Thu, 2 Nov 2006 18:54:20 -0500
Received: from dyn9047017105.beaverton.ibm.com (dyn9047017105.beaverton.ibm.com [9.47.17.105])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id kA2NsK1K017256
	for <linux-ext4@vger.kernel.org>; Thu, 2 Nov 2006 18:54:20 -0500
To: ext4 <linux-ext4@vger.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch is in response to comments on too many inline functions in extents.c.
Removes all inline keywords, since the compiler will make static functions 
inline when it is appropriate.

Signed-off-by: Avantika Mathur <mathur@us.ibm.com>
---
Index: linux-2.6.19-rc3/fs/ext4/extents.c
===================================================================
--- linux-2.6.19-rc3.orig/fs/ext4/extents.c
+++ linux-2.6.19-rc3/fs/ext4/extents.c
@@ -48,7 +48,7 @@
  * ext_pblock:
  * combine low and high parts of physical block number into ext4_fsblk_t
  */
-static inline ext4_fsblk_t ext_pblock(struct ext4_extent *ex)
+static ext4_fsblk_t ext_pblock(struct ext4_extent *ex)
 {
 	ext4_fsblk_t block;
 
@@ -61,7 +61,7 @@ static inline ext4_fsblk_t ext_pblock(st
  * idx_pblock:
  * combine low and high parts of a leaf physical block number into ext4_fsblk_t
  */
-static inline ext4_fsblk_t idx_pblock(struct ext4_extent_idx *ix)
+static ext4_fsblk_t idx_pblock(struct ext4_extent_idx *ix)
 {
 	ext4_fsblk_t block;
 
@@ -75,7 +75,7 @@ static inline ext4_fsblk_t idx_pblock(st
  * stores a large physical block number into an extent struct,
  * breaking it into parts
  */
-static inline void ext4_ext_store_pblock(struct ext4_extent *ex, ext4_fsblk_t pb)
+static void ext4_ext_store_pblock(struct ext4_extent *ex, ext4_fsblk_t pb)
 {
 	ex->ee_start = cpu_to_le32((unsigned long) (pb & 0xffffffff));
 	ex->ee_start_hi = cpu_to_le16((unsigned long) ((pb >> 31) >> 1) & 0xffff);
@@ -86,7 +86,7 @@ static inline void ext4_ext_store_pblock
  * stores a large physical block number into an index struct,
  * breaking it into parts
  */
-static inline void ext4_idx_store_pblock(struct ext4_extent_idx *ix, ext4_fsblk_t pb)
+static void ext4_idx_store_pblock(struct ext4_extent_idx *ix, ext4_fsblk_t pb)
 {
 	ix->ei_leaf = cpu_to_le32((unsigned long) (pb & 0xffffffff));
 	ix->ei_leaf_hi = cpu_to_le16((unsigned long) ((pb >> 31) >> 1) & 0xffff);
@@ -215,7 +215,7 @@ ext4_ext_new_block(handle_t *handle, str
 	return newblock;
 }
 
-static inline int ext4_ext_space_block(struct inode *inode)
+static int ext4_ext_space_block(struct inode *inode)
 {
 	int size;
 
@@ -228,7 +228,7 @@ static inline int ext4_ext_space_block(s
 	return size;
 }
 
-static inline int ext4_ext_space_block_idx(struct inode *inode)
+static int ext4_ext_space_block_idx(struct inode *inode)
 {
 	int size;
 
@@ -241,7 +241,7 @@ static inline int ext4_ext_space_block_i
 	return size;
 }
 
-static inline int ext4_ext_space_root(struct inode *inode)
+static int ext4_ext_space_root(struct inode *inode)
 {
 	int size;
 
@@ -255,7 +255,7 @@ static inline int ext4_ext_space_root(st
 	return size;
 }
 
-static inline int ext4_ext_space_root_idx(struct inode *inode)
+static int ext4_ext_space_root_idx(struct inode *inode)
 {
 	int size;
 
@@ -1093,7 +1093,7 @@ int ext4_ext_correct_indexes(handle_t *h
 	return err;
 }
 
-static int inline
+static int
 ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
 				struct ext4_extent *ex2)
 {
@@ -1383,7 +1383,7 @@ int ext4_ext_walk_space(struct inode *in
 	return err;
 }
 
-static inline void
+static void
 ext4_ext_put_in_cache(struct inode *inode, __u32 block,
 			__u32 len, __u32 start, int type)
 {
@@ -1401,7 +1401,7 @@ ext4_ext_put_in_cache(struct inode *inod
  * calculate boundaries of the gap that the requested block fits into
  * and cache this gap
  */
-static inline void
+static void
 ext4_ext_put_gap_in_cache(struct inode *inode, struct ext4_ext_path *path,
 				unsigned long block)
 {
@@ -1442,7 +1442,7 @@ ext4_ext_put_gap_in_cache(struct inode *
 	ext4_ext_put_in_cache(inode, lblock, len, 0, EXT4_EXT_CACHE_GAP);
 }
 
-static inline int
+static int
 ext4_ext_in_cache(struct inode *inode, unsigned long block,
 			struct ext4_extent *ex)
 {
@@ -1509,7 +1509,7 @@ int ext4_ext_rm_idx(handle_t *handle, st
  * the caller should calculate credits under truncate_mutex and
  * pass the actual path.
  */
-int inline ext4_ext_calc_credits_for_insert(struct inode *inode,
+int ext4_ext_calc_credits_for_insert(struct inode *inode,
 						struct ext4_ext_path *path)
 {
 	int depth, needed;
@@ -1718,7 +1718,7 @@ out:
  * ext4_ext_more_to_rm:
  * returns 1 if current index has to be freed (even partial)
  */
-static int inline
+static int
 ext4_ext_more_to_rm(struct ext4_ext_path *path)
 {
 	BUG_ON(path->p_idx == NULL);
