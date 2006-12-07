From: akpm@osdl.org
Subject: [patch 352/354] ext4: Eliminate inline functions
Date: Wed, 06 Dec 2006 20:41:36 -0800
Message-ID: <200612070441.kB74fac4030394@shell0.pdx.osdl.net>
Cc: akpm@osdl.org, mathur@us.ibm.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:47680 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968778AbWLGEnP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Dec 2006 23:43:15 -0500
To: torvalds@osdl.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Avantika Mathur <mathur@us.ibm.com>

Removes all inline keywords, since the compiler will make static functions
inline when it is appropriate.

Signed-off-by: Avantika Mathur <mathur@us.ibm.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext4/extents.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff -puN fs/ext4/extents.c~ext4-eliminate-inline-functions fs/ext4/extents.c
--- a/fs/ext4/extents.c~ext4-eliminate-inline-functions
+++ a/fs/ext4/extents.c
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
@@ -1733,7 +1733,7 @@ out:
  * ext4_ext_more_to_rm:
  * returns 1 if current index has to be freed (even partial)
  */
-static int inline
+static int
 ext4_ext_more_to_rm(struct ext4_ext_path *path)
 {
 	BUG_ON(path->p_idx == NULL);
_
