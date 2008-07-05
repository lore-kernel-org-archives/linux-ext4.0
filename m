From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 25/52] ext4: cleanup block allocator
Date: Sat,  5 Jul 2008 13:35:51 -0400
Message-ID: <1215279378-30504-26-git-send-email-tytso@mit.edu>
References: <1215279378-30504-1-git-send-email-tytso@mit.edu>
 <1215279378-30504-2-git-send-email-tytso@mit.edu>
 <1215279378-30504-3-git-send-email-tytso@mit.edu>
 <1215279378-30504-4-git-send-email-tytso@mit.edu>
 <1215279378-30504-5-git-send-email-tytso@mit.edu>
 <1215279378-30504-6-git-send-email-tytso@mit.edu>
 <1215279378-30504-7-git-send-email-tytso@mit.edu>
 <1215279378-30504-8-git-send-email-tytso@mit.edu>
 <1215279378-30504-9-git-send-email-tytso@mit.edu>
 <1215279378-30504-10-git-send-email-tytso@mit.edu>
 <1215279378-30504-11-git-send-email-tytso@mit.edu>
 <1215279378-30504-12-git-send-email-tytso@mit.edu>
 <1215279378-30504-13-git-send-email-tytso@mit.edu>
 <1215279378-30504-14-git-send-email-tytso@mit.edu>
 <1215279378-30504-15-git-send-email-tytso@mit.edu>
 <1215279378-30504-16-git-send-email-tytso@mit.edu>
 <1215279378-30504-17-git-send-email-tytso@mit.edu>
 <1215279378-30504-18-git-send-email-tytso@mit.edu>
 <1215279378-30504-19-git-send-email-tytso@mit.edu>
 <1215279378-30504-20-git-send-email-tytso@mit.edu>
 <1215279378-30504-21-git-send-email-tytso@mit.edu>
 <1215279378-30504-22-git-send-email-tytso@mit.edu>
 <1215279378-30504-23-git-send-email-tytso@mit.edu>
 <1215279378-30504-24-git-send-email-tytso@mit.edu>
 <1215279378-30504-25-git-send-email-tytso@mit.edu>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33055 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755449AbYGERgb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jul 2008 13:36:31 -0400
In-Reply-To: <1215279378-30504-25-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Move the code related to block allocation to a single function and add helper
funtions to differient allocation for data and meta data blocks

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/balloc.c  |  127 +++++++++++++++++++++++++++++++----------------------
 fs/ext4/ext4.h    |    2 +-
 fs/ext4/extents.c |   10 +++-
 fs/ext4/inode.c   |    2 +-
 fs/ext4/mballoc.c |    2 +-
 5 files changed, 84 insertions(+), 59 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 816f1db..48787e8 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1640,20 +1640,24 @@ int ext4_should_retry_alloc(struct super_block *sb, int *retries)
 }
 
 /**
- * ext4_new_blocks_old() -- core block(s) allocation function
+ * ext4_old_new_blocks() -- core block bitmap based block allocation function
+ *
  * @handle:		handle to this transaction
  * @inode:		file inode
  * @goal:		given target block(filesystem wide)
  * @count:		target number of blocks to allocate
  * @errp:		error code
  *
- * ext4_new_blocks uses a goal block to assist allocation.  It tries to
- * allocate block(s) from the block group contains the goal block first. If that
- * fails, it will try to allocate block(s) from other block groups without
- * any specific goal block.
+ * ext4_old_new_blocks uses a goal block to assist allocation and look up
+ * the block bitmap directly to do block allocation.  It tries to
+ * allocate block(s) from the block group contains the goal block first. If
+ * that fails, it will try to allocate block(s) from other block groups
+ * without any specific goal block.
+ *
+ * This function is called when -o nomballoc mount option is enabled
  *
  */
-ext4_fsblk_t ext4_new_blocks_old(handle_t *handle, struct inode *inode,
+ext4_fsblk_t ext4_old_new_blocks(handle_t *handle, struct inode *inode,
 			ext4_fsblk_t goal, unsigned long *count, int *errp)
 {
 	struct buffer_head *bitmap_bh = NULL;
@@ -1923,78 +1927,95 @@ out:
 	return 0;
 }
 
-ext4_fsblk_t ext4_new_meta_block(handle_t *handle, struct inode *inode,
-		ext4_fsblk_t goal, int *errp)
-{
-	struct ext4_allocation_request ar;
-	ext4_fsblk_t ret;
-
-	if (!test_opt(inode->i_sb, MBALLOC)) {
-		unsigned long count = 1;
-		ret = ext4_new_blocks_old(handle, inode, goal, &count, errp);
-		return ret;
-	}
+#define EXT4_META_BLOCK 0x1
 
-	memset(&ar, 0, sizeof(ar));
-	ar.inode = inode;
-	ar.goal = goal;
-	ar.len = 1;
-	ret = ext4_mb_new_blocks(handle, &ar, errp);
-	return ret;
-}
-ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
-		ext4_fsblk_t goal, unsigned long *count, int *errp)
-{
-	struct ext4_allocation_request ar;
-	ext4_fsblk_t ret;
-
-	if (!test_opt(inode->i_sb, MBALLOC)) {
-		ret = ext4_new_blocks_old(handle, inode, goal, count, errp);
-		return ret;
-	}
-
-	memset(&ar, 0, sizeof(ar));
-	ar.inode = inode;
-	ar.goal = goal;
-	ar.len = *count;
-	ret = ext4_mb_new_blocks(handle, &ar, errp);
-	*count = ar.len;
-	return ret;
-}
-
-ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
+static ext4_fsblk_t do_blk_alloc(handle_t *handle, struct inode *inode,
 				ext4_lblk_t iblock, ext4_fsblk_t goal,
-				unsigned long *count, int *errp)
+				unsigned long *count, int *errp, int flags)
 {
 	struct ext4_allocation_request ar;
 	ext4_fsblk_t ret;
 
 	if (!test_opt(inode->i_sb, MBALLOC)) {
-		ret = ext4_new_blocks_old(handle, inode, goal, count, errp);
-		return ret;
+		return ext4_old_new_blocks(handle, inode, goal, count, errp);
 	}
 
 	memset(&ar, 0, sizeof(ar));
 	/* Fill with neighbour allocated blocks */
-	ar.lleft  = 0;
-	ar.pleft  = 0;
-	ar.lright = 0;
-	ar.pright = 0;
 
 	ar.inode = inode;
 	ar.goal = goal;
 	ar.len = *count;
 	ar.logical = iblock;
-	if (S_ISREG(inode->i_mode))
+
+	if (S_ISREG(inode->i_mode) && !(flags & EXT4_META_BLOCK))
+		/* enable in-core preallocation for data block allocation */
 		ar.flags = EXT4_MB_HINT_DATA;
 	else
 		/* disable in-core preallocation for non-regular files */
 		ar.flags = 0;
+
 	ret = ext4_mb_new_blocks(handle, &ar, errp);
 	*count = ar.len;
 	return ret;
 }
 
+/*
+ * ext4_new_meta_block() -- allocate block for meta data (indexing) blocks
+ *
+ * @handle:             handle to this transaction
+ * @inode:              file inode
+ * @goal:               given target block(filesystem wide)
+ * @errp:               error code
+ *
+ * Return allocated block number on success
+ */
+ext4_fsblk_t ext4_new_meta_block(handle_t *handle, struct inode *inode,
+		ext4_fsblk_t goal, int *errp)
+{
+	unsigned long count = 1;
+	return do_blk_alloc(handle, inode, 0, goal,
+			&count, errp, EXT4_META_BLOCK);
+}
+
+/*
+ * ext4_new_meta_blocks() -- allocate block for meta data (indexing) blocks
+ *
+ * @handle:             handle to this transaction
+ * @inode:              file inode
+ * @goal:               given target block(filesystem wide)
+ * @count:		total number of blocks need
+ * @errp:               error code
+ *
+ * Return 1st allocated block numberon success, *count stores total account
+ * error stores in errp pointer
+ */
+ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
+		ext4_fsblk_t goal, unsigned long *count, int *errp)
+{
+	return do_blk_alloc(handle, inode, 0, goal,
+			count, errp, EXT4_META_BLOCK);
+}
+
+/*
+ * ext4_new_blocks() -- allocate data blocks
+ *
+ * @handle:             handle to this transaction
+ * @inode:              file inode
+ * @goal:               given target block(filesystem wide)
+ * @count:		total number of blocks need
+ * @errp:               error code
+ *
+ * Return 1st allocated block numberon success, *count stores total account
+ * error stores in errp pointer
+ */
+
+ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
+				ext4_lblk_t iblock, ext4_fsblk_t goal,
+				unsigned long *count, int *errp)
+{
+	return do_blk_alloc(handle, inode, iblock, goal, count, errp, 0);
+}
 
 /**
  * ext4_count_free_blocks() -- count filesystem free blocks
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b3e62b7..ed04642 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -977,7 +977,7 @@ extern ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
 extern ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
 					ext4_lblk_t iblock, ext4_fsblk_t goal,
 					unsigned long *count, int *errp);
-extern ext4_fsblk_t ext4_new_blocks_old(handle_t *handle, struct inode *inode,
+extern ext4_fsblk_t ext4_old_new_blocks(handle_t *handle, struct inode *inode,
 			ext4_fsblk_t goal, unsigned long *count, int *errp);
 extern void ext4_free_blocks (handle_t *handle, struct inode *inode,
 			ext4_fsblk_t block, unsigned long count, int metadata);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index c729b35..555155d 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -179,8 +179,11 @@ static ext4_fsblk_t ext4_ext_find_goal(struct inode *inode,
 	return bg_start + colour + block;
 }
 
+/*
+ * Allocation for a meta data block
+ */
 static ext4_fsblk_t
-ext4_ext_new_block(handle_t *handle, struct inode *inode,
+ext4_ext_new_meta_block(handle_t *handle, struct inode *inode,
 			struct ext4_ext_path *path,
 			struct ext4_extent *ex, int *err)
 {
@@ -690,7 +693,8 @@ static int ext4_ext_split(handle_t *handle, struct inode *inode,
 	/* allocate all needed blocks */
 	ext_debug("allocate %d blocks for indexes/leaf\n", depth - at);
 	for (a = 0; a < depth - at; a++) {
-		newblock = ext4_ext_new_block(handle, inode, path, newext, &err);
+		newblock = ext4_ext_new_meta_block(handle, inode, path,
+						   newext, &err);
 		if (newblock == 0)
 			goto cleanup;
 		ablocks[a] = newblock;
@@ -886,7 +890,7 @@ static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 	ext4_fsblk_t newblock;
 	int err = 0;
 
-	newblock = ext4_ext_new_block(handle, inode, path, newext, &err);
+	newblock = ext4_ext_new_meta_block(handle, inode, path, newext, &err);
 	if (newblock == 0)
 		return err;
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 04059ba..884cf89 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -561,7 +561,7 @@ static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
 		goto allocated;
 	/* Now allocate data blocks */
 	count = target;
-	/* allocating blocks for indirect blocks and direct blocks */
+	/* allocating blocks for data blocks */
 	current_block = ext4_new_blocks(handle, inode, iblock,
 						goal, &count, err);
 	if (*err && (target == blks)) {
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 8b67414..007b97b 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4035,7 +4035,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 	sbi = EXT4_SB(sb);
 
 	if (!test_opt(sb, MBALLOC)) {
-		block = ext4_new_blocks_old(handle, ar->inode, ar->goal,
+		block = ext4_old_new_blocks(handle, ar->inode, ar->goal,
 					    &(ar->len), errp);
 		return block;
 	}
-- 
1.5.6.rc3.1.g36b7.dirty

