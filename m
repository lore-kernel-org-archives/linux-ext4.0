From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [Ext4 punch hole 1/5 v7] Ext4 Punch Hole Support: Add flag to ext4_has_free_blocks
Date: Sat, 07 May 2011 16:53:56 -0700
Message-ID: <4DC5DB94.8060300@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:50634 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756336Ab1EGXyD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 May 2011 19:54:03 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e7.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p47NVDuL031851
	for <linux-ext4@vger.kernel.org>; Sat, 7 May 2011 19:31:13 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p47Ns2oE071786
	for <linux-ext4@vger.kernel.org>; Sat, 7 May 2011 19:54:02 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p47Ns2oh020360
	for <linux-ext4@vger.kernel.org>; Sat, 7 May 2011 19:54:02 -0400
Received: from [9.48.112.215] (sig-9-48-112-215.mts.ibm.com [9.48.112.215])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id p47Ns1Of020334
	for <linux-ext4@vger.kernel.org>; Sat, 7 May 2011 19:54:02 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds an allocation request flag to the
ext4_has_free_blocks function which
enables the use of reserved blocks.  This will allow
a punch hole to proceed even if the disk is full.
Punching a hole may require additional blocks to first
split the extents.

Because ext4_has_free_blocks is a low level function,
the flag needs to be passed down through several
functions listed below:

ext4_ext_insert_extent
ext4_ext_create_new_leaf
ext4_ext_grow_indepth
ext4_ext_split
ext4_ext_new_meta_block
ext4_mb_new_blocks
ext4_claim_free_blocks
ext4_has_free_blocks

Signed-off-by: Allison Henderson <achender@us.ibm.com>
---
:100644 100644 9c6cd51... 32003c2... M	fs/ext4/balloc.c
:100644 100644 076c5d2... 3ba6c31... M	fs/ext4/ext4.h
:100644 100644 e363f21... e04faeb... M	fs/ext4/extents.c
:100644 100644 f2fa5e8... f92c58b... M	fs/ext4/inode.c
:100644 100644 730c1a7... 85cc3ef... M	fs/ext4/mballoc.c
:100644 100644 b545ca1... 2d9b12c... M	fs/ext4/xattr.c
 fs/ext4/balloc.c  |   17 +++++++++++------
 fs/ext4/ext4.h    |   11 ++++++++---
 fs/ext4/extents.c |   30 ++++++++++++++++++++----------
 fs/ext4/inode.c   |    4 ++--
 fs/ext4/mballoc.c |   16 ++++++++++++----
 fs/ext4/xattr.c   |    2 +-
 6 files changed, 54 insertions(+), 26 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 9c6cd51..32003c2 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -493,7 +493,8 @@ error_return:
  * Check if filesystem has nblocks free & available for allocation.
  * On success return 1, return 0 on failure.
  */
-static int ext4_has_free_blocks(struct ext4_sb_info *sbi, s64 nblocks)
+static int ext4_has_free_blocks(struct ext4_sb_info *sbi,
+				s64 nblocks, unsigned int flags)
 {
 	s64 free_blocks, dirty_blocks, root_blocks;
 	struct percpu_counter *fbc = &sbi->s_freeblocks_counter;
@@ -517,7 +518,9 @@ static int ext4_has_free_blocks(struct ext4_sb_info *sbi, s64 nblocks)
 	/* Hm, nope.  Are (enough) root reserved blocks available? */
 	if (sbi->s_resuid == current_fsuid() ||
 	    ((sbi->s_resgid != 0) && in_group_p(sbi->s_resgid)) ||
-	    capable(CAP_SYS_RESOURCE)) {
+	    capable(CAP_SYS_RESOURCE) ||
+		(flags & EXT4_MB_USE_ROOT_BLOCKS)) {
+
 		if (free_blocks >= (nblocks + dirty_blocks))
 			return 1;
 	}
@@ -526,9 +529,9 @@ static int ext4_has_free_blocks(struct ext4_sb_info *sbi, s64 nblocks)
 }
 
 int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
-						s64 nblocks)
+					s64 nblocks, unsigned int flags)
 {
-	if (ext4_has_free_blocks(sbi, nblocks)) {
+	if (ext4_has_free_blocks(sbi, nblocks, flags)) {
 		percpu_counter_add(&sbi->s_dirtyblocks_counter, nblocks);
 		return 0;
 	} else
@@ -549,7 +552,7 @@ int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
  */
 int ext4_should_retry_alloc(struct super_block *sb, int *retries)
 {
-	if (!ext4_has_free_blocks(EXT4_SB(sb), 1) ||
+	if (!ext4_has_free_blocks(EXT4_SB(sb), 1, 0) ||
 	    (*retries)++ > 3 ||
 	    !EXT4_SB(sb)->s_journal)
 		return 0;
@@ -572,7 +575,8 @@ int ext4_should_retry_alloc(struct super_block *sb, int *retries)
  * error stores in errp pointer
  */
 ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
-		ext4_fsblk_t goal, unsigned long *count, int *errp)
+		ext4_fsblk_t goal, unsigned long *count, int *errp,
+		unsigned int flags)
 {
 	struct ext4_allocation_request ar;
 	ext4_fsblk_t ret;
@@ -582,6 +586,7 @@ ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
 	ar.inode = inode;
 	ar.goal = goal;
 	ar.len = count ? *count : 1;
+	ar.flags = flags;
 
 	ret = ext4_mb_new_blocks(handle, &ar, errp);
 	if (count)
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 076c5d2..3ba6c31 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -108,7 +108,8 @@ typedef unsigned int ext4_group_t;
 #define EXT4_MB_DELALLOC_RESERVED	0x0400
 /* We are doing stream allocation */
 #define EXT4_MB_STREAM_ALLOC		0x0800
-
+/* Use reserved root blocks if needed */
+#define EXT4_MB_USE_ROOT_BLOCKS		0x1000
 
 struct ext4_allocation_request {
 	/* target inode for block we're allocating */
@@ -512,6 +513,8 @@ struct ext4_new_group_data {
 	/* Convert extent to initialized after IO complete */
 #define EXT4_GET_BLOCKS_IO_CONVERT_EXT		(EXT4_GET_BLOCKS_CONVERT|\
 					 EXT4_GET_BLOCKS_CREATE_UNINIT_EXT)
+	/* Punch out blocks of an extent */
+#define EXT4_GET_BLOCKS_PUNCH_OUT_EXT		0x0020
 
 /*
  * Flags used by ext4_free_blocks
@@ -1653,8 +1656,10 @@ extern int ext4_bg_has_super(struct super_block *sb, ext4_group_t group);
 extern unsigned long ext4_bg_num_gdb(struct super_block *sb,
 			ext4_group_t group);
 extern ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
-			ext4_fsblk_t goal, unsigned long *count, int *errp);
-extern int ext4_claim_free_blocks(struct ext4_sb_info *sbi, s64 nblocks);
+			ext4_fsblk_t goal, unsigned long *count,
+			int *errp, unsigned int flags);
+extern int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
+					s64 nblocks, unsigned int flags);
 extern void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
 				ext4_fsblk_t block, unsigned long count);
 extern ext4_fsblk_t ext4_count_free_blocks(struct super_block *);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e363f21..e04faeb 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -192,12 +192,13 @@ static ext4_fsblk_t ext4_ext_find_goal(struct inode *inode,
 static ext4_fsblk_t
 ext4_ext_new_meta_block(handle_t *handle, struct inode *inode,
 			struct ext4_ext_path *path,
-			struct ext4_extent *ex, int *err)
+			struct ext4_extent *ex, int *err, unsigned int flags)
 {
 	ext4_fsblk_t goal, newblock;
 
 	goal = ext4_ext_find_goal(inode, path, le32_to_cpu(ex->ee_block));
-	newblock = ext4_new_meta_blocks(handle, inode, goal, NULL, err);
+	newblock = ext4_new_meta_blocks(handle, inode, goal,
+			NULL, err, flags);
 	return newblock;
 }
 
@@ -793,7 +794,8 @@ static int ext4_ext_insert_index(handle_t *handle, struct inode *inode,
  */
 static int ext4_ext_split(handle_t *handle, struct inode *inode,
 				struct ext4_ext_path *path,
-				struct ext4_extent *newext, int at)
+				struct ext4_extent *newext, int at,
+				unsigned int flags)
 {
 	struct buffer_head *bh = NULL;
 	int depth = ext_depth(inode);
@@ -847,7 +849,7 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 	ext_debug("allocate %d blocks for indexes/leaf\n", depth - at);
 	for (a = 0; a < depth - at; a++) {
 		newblock = ext4_ext_new_meta_block(handle, inode, path,
-						   newext, &err);
+						   newext, &err, flags);
 		if (newblock == 0)
 			goto cleanup;
 		ablocks[a] = newblock;
@@ -1057,7 +1059,8 @@ cleanup:
  */
 static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 					struct ext4_ext_path *path,
-					struct ext4_extent *newext)
+					struct ext4_extent *newext,
+					unsigned int flags)
 {
 	struct ext4_ext_path *curp = path;
 	struct ext4_extent_header *neh;
@@ -1065,7 +1068,8 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 	ext4_fsblk_t newblock;
 	int err = 0;
 
-	newblock = ext4_ext_new_meta_block(handle, inode, path, newext, &err);
+	newblock = ext4_ext_new_meta_block(handle, inode, path,
+		newext, &err, flags);
 	if (newblock == 0)
 		return err;
 
@@ -1141,7 +1145,8 @@ out:
  */
 static int ext4_ext_create_new_leaf(handle_t *handle, struct inode *inode,
 					struct ext4_ext_path *path,
-					struct ext4_extent *newext)
+					struct ext4_extent *newext,
+					unsigned int flags)
 {
 	struct ext4_ext_path *curp;
 	int depth, i, err = 0;
@@ -1161,7 +1166,7 @@ repeat:
 	if (EXT_HAS_FREE_INDEX(curp)) {
 		/* if we found index with free entry, then use that
 		 * entry: create all needed subtree and add new leaf */
-		err = ext4_ext_split(handle, inode, path, newext, i);
+		err = ext4_ext_split(handle, inode, path, newext, i, flags);
 		if (err)
 			goto out;
 
@@ -1174,7 +1179,8 @@ repeat:
 			err = PTR_ERR(path);
 	} else {
 		/* tree is full, time to grow in depth */
-		err = ext4_ext_grow_indepth(handle, inode, path, newext);
+		err = ext4_ext_grow_indepth(handle, inode, path,
+			newext, flags);
 		if (err)
 			goto out;
 
@@ -1693,6 +1699,7 @@ int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 	int depth, len, err;
 	ext4_lblk_t next;
 	unsigned uninitialized = 0;
+	int flags = 0;
 
 	if (unlikely(ext4_ext_get_actual_len(newext) == 0)) {
 		EXT4_ERROR_INODE(inode, "ext4_ext_get_actual_len(newext) == 0");
@@ -1767,7 +1774,10 @@ repeat:
 	 * There is no free space in the found leaf.
 	 * We're gonna add a new leaf in the tree.
 	 */
-	err = ext4_ext_create_new_leaf(handle, inode, path, newext);
+	if (flag & EXT4_GET_BLOCKS_PUNCH_OUT_EXT)
+		flags = EXT4_MB_USE_ROOT_BLOCKS;
+	err = ext4_ext_create_new_leaf(handle, inode, path,
+		newext, flags);
 	if (err)
 		goto cleanup;
 	depth = ext_depth(inode);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f2fa5e8..f92c58b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -640,7 +640,7 @@ static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
 		count = target;
 		/* allocating blocks for indirect blocks and direct blocks */
 		current_block = ext4_new_meta_blocks(handle, inode,
-							goal, &count, err);
+							goal, &count, err, 0);
 		if (*err)
 			goto failed_out;
 
@@ -1930,7 +1930,7 @@ repeat:
 	 * We do still charge estimated metadata to the sb though;
 	 * we cannot afford to run out of free blocks.
 	 */
-	if (ext4_claim_free_blocks(sbi, md_needed + 1)) {
+	if (ext4_claim_free_blocks(sbi, md_needed + 1, 0)) {
 		dquot_release_reservation_block(inode, 1);
 		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
 			yield();
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 730c1a7..85cc3ef 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4299,7 +4299,9 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 		 * there is enough free blocks to do block allocation
 		 * and verify allocation doesn't exceed the quota limits.
 		 */
-		while (ar->len && ext4_claim_free_blocks(sbi, ar->len)) {
+		while (ar->len &&
+			ext4_claim_free_blocks(sbi, ar->len, ar->flags)) {
+
 			/* let others to free the space */
 			yield();
 			ar->len = ar->len >> 1;
@@ -4309,9 +4311,15 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 			return 0;
 		}
 		reserv_blks = ar->len;
-		while (ar->len && dquot_alloc_block(ar->inode, ar->len)) {
-			ar->flags |= EXT4_MB_HINT_NOPREALLOC;
-			ar->len--;
+		if (ar->flags & EXT4_MB_USE_ROOT_BLOCKS) {
+			dquot_alloc_block_nofail(ar->inode, ar->len);
+		} else {
+			while (ar->len &&
+				dquot_alloc_block(ar->inode, ar->len)) {
+
+				ar->flags |= EXT4_MB_HINT_NOPREALLOC;
+				ar->len--;
+			}
 		}
 		inquota = ar->len;
 		if (ar->len == 0) {
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index b545ca1..2d9b12c 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -821,7 +821,7 @@ inserted:
 				goal = goal & EXT4_MAX_BLOCK_FILE_PHYS;
 
 			block = ext4_new_meta_blocks(handle, inode,
-						  goal, NULL, &error);
+						  goal, NULL, &error, 0);
 			if (error)
 				goto cleanup;
 
-- 
1.7.1

