From: Avantika Mathur <mathur@us.ibm.com>
Subject: [PATCH 3/3] Eliminate inline functions
Date: Mon, 27 Nov 2006 16:09:08 -0800
Message-ID: <1164672548.10750.20.camel@dyn9047017105.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56719 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S933598AbWK1AKf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Nov 2006 19:10:35 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id kAS0AWsI010402
	for <linux-ext4@vger.kernel.org>; Mon, 27 Nov 2006 19:10:32 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kAS0AV7k228352
	for <linux-ext4@vger.kernel.org>; Mon, 27 Nov 2006 19:10:32 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kAS0AVs6005387
	for <linux-ext4@vger.kernel.org>; Mon, 27 Nov 2006 19:10:31 -0500
To: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Avantika Mathur <mathur@us.ibm.com>

Removes all inline keywords, since the compiler will make static functions 
inline when it is appropriate.

Signed-off-by: Avantika Mathur <mathur@us.ibm.com>
---
 fs/ext4/extents.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

Index: linux-2.6.19-rc6-mm1/fs/ext4/extents.c
===================================================================
--- linux-2.6.19-rc6-mm1.orig/fs/ext4/extents.c
+++ linux-2.6.19-rc6-mm1/fs/ext4/extents.c
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
@@ -216,7 +216,7 @@ ext4_ext_new_block(handle_t *handle, str
 	return newblock;
 }
 
-static inline int ext4_ext_space_block(struct inode *inode)
+static int ext4_ext_space_block(struct inode *inode)
 {
 	int size;
 
@@ -229,7 +229,7 @@ static inline int ext4_ext_space_block(s
 	return size;
 }
 
-static inline int ext4_ext_space_block_idx(struct inode *inode)
+static int ext4_ext_space_block_idx(struct inode *inode)
 {
 	int size;
 
@@ -242,7 +242,7 @@ static inline int ext4_ext_space_block_i
 	return size;
 }
 
-static inline int ext4_ext_space_root(struct inode *inode)
+static int ext4_ext_space_root(struct inode *inode)
 {
 	int size;
 
@@ -256,7 +256,7 @@ static inline int ext4_ext_space_root(st
 	return size;
 }
 
-static inline int ext4_ext_space_root_idx(struct inode *inode)
+static int ext4_ext_space_root_idx(struct inode *inode)
 {
 	int size;
 
@@ -1103,7 +1103,7 @@ int ext4_ext_correct_indexes(handle_t *h
 	return err;
 }
 
-static int inline
+static int
 ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
 				struct ext4_extent *ex2)
 {
@@ -1395,7 +1395,7 @@ int ext4_ext_walk_space(struct inode *in
 	return err;
 }
 
-static inline void
+static void
 ext4_ext_put_in_cache(struct inode *inode, __u32 block,
 			__u32 len, __u32 start, int type)
 {
@@ -1413,7 +1413,7 @@ ext4_ext_put_in_cache(struct inode *inod
  * calculate boundaries of the gap that the requested block fits into
  * and cache this gap
  */
-static inline void
+static void
 ext4_ext_put_gap_in_cache(struct inode *inode, struct ext4_ext_path *path,
 				unsigned long block)
 {
@@ -1454,7 +1454,7 @@ ext4_ext_put_gap_in_cache(struct inode *
 	ext4_ext_put_in_cache(inode, lblock, len, 0, EXT4_EXT_CACHE_GAP);
 }
 
-static inline int
+static int
 ext4_ext_in_cache(struct inode *inode, unsigned long block,
 			struct ext4_extent *ex)
 {
@@ -1523,7 +1523,7 @@ int ext4_ext_rm_idx(handle_t *handle, st
  * the caller should calculate credits under truncate_mutex and
  * pass the actual path.
  */
-int inline ext4_ext_calc_credits_for_insert(struct inode *inode,
+int ext4_ext_calc_credits_for_insert(struct inode *inode,
 						struct ext4_ext_path *path)
 {
 	int depth, needed;
@@ -1732,7 +1732,7 @@ out:
  * ext4_ext_more_to_rm:
  * returns 1 if current index has to be freed (even partial)
  */
-static int inline
+static int
 ext4_ext_more_to_rm(struct ext4_ext_path *path)
 {
 	BUG_ON(path->p_idx == NULL);
