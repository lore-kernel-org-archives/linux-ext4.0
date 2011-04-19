From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [Ext4 punch hole 1/6 v5] Ext4 Punch Hole Support: Add flag to ext4_has_free_blocks
Date: Tue, 19 Apr 2011 00:41:12 -0700
Message-ID: <4DAD3C98.3050308@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:56462 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795Ab1DSHlW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Apr 2011 03:41:22 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e1.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p3J7Uisk018545
	for <linux-ext4@vger.kernel.org>; Tue, 19 Apr 2011 03:30:44 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p3J7fGJl364296
	for <linux-ext4@vger.kernel.org>; Tue, 19 Apr 2011 03:41:17 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p3J7fGXD021910
	for <linux-ext4@vger.kernel.org>; Tue, 19 Apr 2011 03:41:16 -0400
Received: from [9.48.114.155] (sig-9-48-114-155.mts.ibm.com [9.48.114.155])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id p3J7fFCg021644
	for <linux-ext4@vger.kernel.org>; Tue, 19 Apr 2011 03:41:15 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds a flag to ext4_has_free_blocks which
enables the use of reserved blocks.  This will allow
a punch hole to proceed even if the disk is full.
Punching a hole may require additional blocks to first
split the extents.  The blocks will be reclaimed after
the punch hole completes.

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
:100644 100644 97b970e... 794c4d2... M	fs/ext4/balloc.c
:100644 100644 4daaf2b... 6c1f415... M	fs/ext4/ext4.h
:100644 100644 dd2cb50... 0b186d9... M	fs/ext4/extents.c
:100644 100644 1a86282... ec890fd... M	fs/ext4/inode.c
:100644 100644 a5837a8... db8b120... M	fs/ext4/mballoc.c
:100644 100644 b545ca1... 2d9b12c... M	fs/ext4/xattr.c
 fs/ext4/balloc.c  |   17 ++++++++++-------
 fs/ext4/ext4.h    |   16 +++++++++++++---
 fs/ext4/extents.c |   27 ++++++++++++++++-----------
 fs/ext4/inode.c   |    6 +++---
 fs/ext4/mballoc.c |    5 +++--
 fs/ext4/xattr.c   |    2 +-
 6 files changed, 46 insertions(+), 27 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 97b970e..794c4d2 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -493,7 +493,8 @@ error_return:
  * Check if filesystem has nblocks free & available for allocation.
  * On success return 1, return 0 on failure.
  */
-static int ext4_has_free_blocks(struct ext4_sb_info *sbi, s64 nblocks)
+static int ext4_has_free_blocks(struct ext4_sb_info *sbi,
+				s64 nblocks, int flags)
 {
 	s64 free_blocks, dirty_blocks, root_blocks;
 	struct percpu_counter *fbc = &sbi->s_freeblocks_counter;
@@ -522,7 +523,9 @@ static int ext4_has_free_blocks(struct ext4_sb_info *sbi, s64 nblocks)
 	/* Hm, nope.  Are (enough) root reserved blocks available? */
 	if (sbi->s_resuid == current_fsuid() ||
 	    ((sbi->s_resgid != 0) && in_group_p(sbi->s_resgid)) ||
-	    capable(CAP_SYS_RESOURCE)) {
+	    capable(CAP_SYS_RESOURCE) ||
+		(flags & EXT4_HAS_FREE_BLKS_USE_ROOTBLKS)) {
+
 		if (free_blocks >= (nblocks + dirty_blocks))
 			return 1;
 	}
@@ -531,9 +534,9 @@ static int ext4_has_free_blocks(struct ext4_sb_info *sbi, s64 nblocks)
 }
 
 int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
-						s64 nblocks)
+						s64 nblocks, int flags)
 {
-	if (ext4_has_free_blocks(sbi, nblocks)) {
+	if (ext4_has_free_blocks(sbi, nblocks, flags)) {
 		percpu_counter_add(&sbi->s_dirtyblocks_counter, nblocks);
 		return 0;
 	} else
@@ -554,7 +557,7 @@ int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
  */
 int ext4_should_retry_alloc(struct super_block *sb, int *retries)
 {
-	if (!ext4_has_free_blocks(EXT4_SB(sb), 1) ||
+	if (!ext4_has_free_blocks(EXT4_SB(sb), 1, 0) ||
 	    (*retries)++ > 3 ||
 	    !EXT4_SB(sb)->s_journal)
 		return 0;
@@ -577,7 +580,7 @@ int ext4_should_retry_alloc(struct super_block *sb, int *retries)
  * error stores in errp pointer
  */
 ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
-		ext4_fsblk_t goal, unsigned long *count, int *errp)
+		ext4_fsblk_t goal, unsigned long *count, int *errp, int flags)
 {
 	struct ext4_allocation_request ar;
 	ext4_fsblk_t ret;
@@ -588,7 +591,7 @@ ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
 	ar.goal = goal;
 	ar.len = count ? *count : 1;
 
-	ret = ext4_mb_new_blocks(handle, &ar, errp);
+	ret = ext4_mb_new_blocks(handle, &ar, errp, flags);
 	if (count)
 		*count = ar.len;
 	/*
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 4daaf2b..6c1f415 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -512,6 +512,8 @@ struct ext4_new_group_data {
 	/* Convert extent to initialized after IO complete */
 #define EXT4_GET_BLOCKS_IO_CONVERT_EXT		(EXT4_GET_BLOCKS_CONVERT|\
 					 EXT4_GET_BLOCKS_CREATE_UNINIT_EXT)
+	/* Punch out blocks of an extent */
+#define EXT4_GET_BLOCKS_PUNCH_OUT_EXT		0x0020
 
 /*
  * Flags used by ext4_free_blocks
@@ -521,6 +523,11 @@ struct ext4_new_group_data {
 #define EXT4_FREE_BLOCKS_VALIDATED	0x0004
 
 /*
+ * Flags used by ext4_has_free_blocks
+ */
+#define EXT4_HAS_FREE_BLKS_USE_ROOTBLKS 0x0001
+
+/*
  * ioctl commands
  */
 #define	EXT4_IOC_GETFLAGS		FS_IOC_GETFLAGS
@@ -1638,8 +1645,10 @@ extern int ext4_bg_has_super(struct super_block *sb, ext4_group_t group);
 extern unsigned long ext4_bg_num_gdb(struct super_block *sb,
 			ext4_group_t group);
 extern ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
-			ext4_fsblk_t goal, unsigned long *count, int *errp);
-extern int ext4_claim_free_blocks(struct ext4_sb_info *sbi, s64 nblocks);
+			ext4_fsblk_t goal, unsigned long *count,
+			int *errp, int flags);
+extern int ext4_claim_free_blocks(struct ext4_sb_info *sbi,
+					s64 nblocks, int flags);
 extern void ext4_add_groupblocks(handle_t *handle, struct super_block *sb,
 				ext4_fsblk_t block, unsigned long count);
 extern ext4_fsblk_t ext4_count_free_blocks(struct super_block *);
@@ -1696,7 +1705,8 @@ extern long ext4_mb_max_to_scan;
 extern int ext4_mb_init(struct super_block *, int);
 extern int ext4_mb_release(struct super_block *);
 extern ext4_fsblk_t ext4_mb_new_blocks(handle_t *,
-				struct ext4_allocation_request *, int *);
+				struct ext4_allocation_request *,
+				int *, int flags);
 extern int ext4_mb_reserve_blocks(struct super_block *, int);
 extern void ext4_discard_preallocations(struct inode *);
 extern int __init ext4_init_mballoc(void);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index dd2cb50..0b186d9 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -192,12 +192,12 @@ static ext4_fsblk_t ext4_ext_find_goal(struct inode *inode,
 static ext4_fsblk_t
 ext4_ext_new_meta_block(handle_t *handle, struct inode *inode,
 			struct ext4_ext_path *path,
-			struct ext4_extent *ex, int *err)
+			struct ext4_extent *ex, int *err, int flags)
 {
 	ext4_fsblk_t goal, newblock;
 
 	goal = ext4_ext_find_goal(inode, path, le32_to_cpu(ex->ee_block));
-	newblock = ext4_new_meta_blocks(handle, inode, goal, NULL, err);
+	newblock = ext4_new_meta_blocks(handle, inode, goal, NULL, err, flags);
 	return newblock;
 }
 
@@ -793,7 +793,7 @@ static int ext4_ext_insert_index(handle_t *handle, struct inode *inode,
  */
 static int ext4_ext_split(handle_t *handle, struct inode *inode,
 				struct ext4_ext_path *path,
-				struct ext4_extent *newext, int at)
+				struct ext4_extent *newext, int at, int flags)
 {
 	struct buffer_head *bh = NULL;
 	int depth = ext_depth(inode);
@@ -847,7 +847,7 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 	ext_debug("allocate %d blocks for indexes/leaf\n", depth - at);
 	for (a = 0; a < depth - at; a++) {
 		newblock = ext4_ext_new_meta_block(handle, inode, path,
-						   newext, &err);
+						   newext, &err, flags);
 		if (newblock == 0)
 			goto cleanup;
 		ablocks[a] = newblock;
@@ -1057,7 +1057,7 @@ cleanup:
  */
 static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 					struct ext4_ext_path *path,
-					struct ext4_extent *newext)
+					struct ext4_extent *newext, int flags)
 {
 	struct ext4_ext_path *curp = path;
 	struct ext4_extent_header *neh;
@@ -1065,7 +1065,8 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 	ext4_fsblk_t newblock;
 	int err = 0;
 
-	newblock = ext4_ext_new_meta_block(handle, inode, path, newext, &err);
+	newblock = ext4_ext_new_meta_block(handle, inode, path,
+		newext, &err, flags);
 	if (newblock == 0)
 		return err;
 
@@ -1141,7 +1142,7 @@ out:
  */
 static int ext4_ext_create_new_leaf(handle_t *handle, struct inode *inode,
 					struct ext4_ext_path *path,
-					struct ext4_extent *newext)
+					struct ext4_extent *newext, int flags)
 {
 	struct ext4_ext_path *curp;
 	int depth, i, err = 0;
@@ -1161,7 +1162,7 @@ repeat:
 	if (EXT_HAS_FREE_INDEX(curp)) {
 		/* if we found index with free entry, then use that
 		 * entry: create all needed subtree and add new leaf */
-		err = ext4_ext_split(handle, inode, path, newext, i);
+		err = ext4_ext_split(handle, inode, path, newext, i, flags);
 		if (err)
 			goto out;
 
@@ -1174,7 +1175,7 @@ repeat:
 			err = PTR_ERR(path);
 	} else {
 		/* tree is full, time to grow in depth */
-		err = ext4_ext_grow_indepth(handle, inode, path, newext);
+		err = ext4_ext_grow_indepth(handle, inode, path, newext, flags);
 		if (err)
 			goto out;
 
@@ -1668,6 +1669,7 @@ int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 	int depth, len, err;
 	ext4_lblk_t next;
 	unsigned uninitialized = 0;
+	int free_blks_flags = 0;
 
 	if (unlikely(ext4_ext_get_actual_len(newext) == 0)) {
 		EXT4_ERROR_INODE(inode, "ext4_ext_get_actual_len(newext) == 0");
@@ -1742,7 +1744,10 @@ repeat:
 	 * There is no free space in the found leaf.
 	 * We're gonna add a new leaf in the tree.
 	 */
-	err = ext4_ext_create_new_leaf(handle, inode, path, newext);
+	if (flag & EXT4_GET_BLOCKS_PUNCH_OUT_EXT)
+		free_blks_flags = EXT4_HAS_FREE_BLKS_USE_ROOTBLKS;
+	err = ext4_ext_create_new_leaf(handle, inode, path,
+		newext, free_blks_flags);
 	if (err)
 		goto cleanup;
 	depth = ext_depth(inode);
@@ -3446,7 +3451,7 @@ int ext4_ext_map_blocks(handle_t *handle, struct inode *inode,
 	else
 		/* disable in-core preallocation for non-regular files */
 		ar.flags = 0;
-	newblock = ext4_mb_new_blocks(handle, &ar, &err);
+	newblock = ext4_mb_new_blocks(handle, &ar, &err, 0);
 	if (!newblock)
 		goto out2;
 	ext_debug("allocate new block: goal %llu, found %llu/%u\n",
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 1a86282..ec890fd 100644
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
 
@@ -686,7 +686,7 @@ static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
 		/* enable in-core preallocation only for regular files */
 		ar.flags = EXT4_MB_HINT_DATA;
 
-	current_block = ext4_mb_new_blocks(handle, &ar, err);
+	current_block = ext4_mb_new_blocks(handle, &ar, err, 0);
 	if (unlikely(current_block + ar.len > EXT4_MAX_BLOCK_FILE_PHYS)) {
 		EXT4_ERROR_INODE(inode,
 				 "current_block %llu + ar.len %d > %d!",
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
index a5837a8..db8b120 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4276,7 +4276,8 @@ static int ext4_mb_discard_preallocations(struct super_block *sb, int needed)
  * to usual allocation
  */
 ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
-				struct ext4_allocation_request *ar, int *errp)
+				struct ext4_allocation_request *ar, int *errp,
+				int flags)
 {
 	int freed;
 	struct ext4_allocation_context *ac = NULL;
@@ -4303,7 +4304,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 		 * there is enough free blocks to do block allocation
 		 * and verify allocation doesn't exceed the quota limits.
 		 */
-		while (ar->len && ext4_claim_free_blocks(sbi, ar->len)) {
+		while (ar->len && ext4_claim_free_blocks(sbi, ar->len, flags)) {
 			/* let others to free the space */
 			yield();
 			ar->len = ar->len >> 1;
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

