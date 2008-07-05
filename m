From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 24/52] ext4: Use inode preallocation with -o noextents
Date: Sat,  5 Jul 2008 13:35:50 -0400
Message-ID: <1215279378-30504-25-git-send-email-tytso@mit.edu>
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
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33066 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755508AbYGERgb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Jul 2008 13:36:31 -0400
In-Reply-To: <1215279378-30504-24-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

When mballoc is enabled, block allocation for old block-based
files are allocated using mballoc allocator instead of old
block-based allocator. The old ext3 block reservation is turned
off when mballoc is turned on.

However, the in-core preallocation is not enabled for block-based/
non-extent based file block allocation. This result in performance
regression, as now we don't have "reservation" ore in-core preallocation
to prevent interleaved fragmentation in multiple writes workload.

This patch fix this by enable per inode in-core preallocation
for non extent files when mballoc is used.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/balloc.c  |   36 +++++++++++++++++++++++++-
 fs/ext4/ext4.h    |    7 +++-
 fs/ext4/extents.c |    2 +-
 fs/ext4/inode.c   |   72 +++++++++++++++++++++++++++++++++++++++-------------
 fs/ext4/xattr.c   |    2 +-
 5 files changed, 95 insertions(+), 24 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 1327ac3..816f1db 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1923,7 +1923,7 @@ out:
 	return 0;
 }
 
-ext4_fsblk_t ext4_new_block(handle_t *handle, struct inode *inode,
+ext4_fsblk_t ext4_new_meta_block(handle_t *handle, struct inode *inode,
 		ext4_fsblk_t goal, int *errp)
 {
 	struct ext4_allocation_request ar;
@@ -1942,9 +1942,29 @@ ext4_fsblk_t ext4_new_block(handle_t *handle, struct inode *inode,
 	ret = ext4_mb_new_blocks(handle, &ar, errp);
 	return ret;
 }
+ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
+		ext4_fsblk_t goal, unsigned long *count, int *errp)
+{
+	struct ext4_allocation_request ar;
+	ext4_fsblk_t ret;
+
+	if (!test_opt(inode->i_sb, MBALLOC)) {
+		ret = ext4_new_blocks_old(handle, inode, goal, count, errp);
+		return ret;
+	}
+
+	memset(&ar, 0, sizeof(ar));
+	ar.inode = inode;
+	ar.goal = goal;
+	ar.len = *count;
+	ret = ext4_mb_new_blocks(handle, &ar, errp);
+	*count = ar.len;
+	return ret;
+}
 
 ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
-		ext4_fsblk_t goal, unsigned long *count, int *errp)
+				ext4_lblk_t iblock, ext4_fsblk_t goal,
+				unsigned long *count, int *errp)
 {
 	struct ext4_allocation_request ar;
 	ext4_fsblk_t ret;
@@ -1955,9 +1975,21 @@ ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
 	}
 
 	memset(&ar, 0, sizeof(ar));
+	/* Fill with neighbour allocated blocks */
+	ar.lleft  = 0;
+	ar.pleft  = 0;
+	ar.lright = 0;
+	ar.pright = 0;
+
 	ar.inode = inode;
 	ar.goal = goal;
 	ar.len = *count;
+	ar.logical = iblock;
+	if (S_ISREG(inode->i_mode))
+		ar.flags = EXT4_MB_HINT_DATA;
+	else
+		/* disable in-core preallocation for non-regular files */
+		ar.flags = 0;
 	ret = ext4_mb_new_blocks(handle, &ar, errp);
 	*count = ar.len;
 	return ret;
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index c4aa1ce..b3e62b7 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -970,10 +970,13 @@ extern ext4_grpblk_t ext4_block_group_offset(struct super_block *sb,
 extern int ext4_bg_has_super(struct super_block *sb, ext4_group_t group);
 extern unsigned long ext4_bg_num_gdb(struct super_block *sb,
 			ext4_group_t group);
-extern ext4_fsblk_t ext4_new_block (handle_t *handle, struct inode *inode,
+extern ext4_fsblk_t ext4_new_meta_block(handle_t *handle, struct inode *inode,
 			ext4_fsblk_t goal, int *errp);
-extern ext4_fsblk_t ext4_new_blocks (handle_t *handle, struct inode *inode,
+extern ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
 			ext4_fsblk_t goal, unsigned long *count, int *errp);
+extern ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
+					ext4_lblk_t iblock, ext4_fsblk_t goal,
+					unsigned long *count, int *errp);
 extern ext4_fsblk_t ext4_new_blocks_old(handle_t *handle, struct inode *inode,
 			ext4_fsblk_t goal, unsigned long *count, int *errp);
 extern void ext4_free_blocks (handle_t *handle, struct inode *inode,
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 17ea8bb..c729b35 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -187,7 +187,7 @@ ext4_ext_new_block(handle_t *handle, struct inode *inode,
 	ext4_fsblk_t goal, newblock;
 
 	goal = ext4_ext_find_goal(inode, path, le32_to_cpu(ex->ee_block));
-	newblock = ext4_new_block(handle, inode, goal, err);
+	newblock = ext4_new_meta_block(handle, inode, goal, err);
 	return newblock;
 }
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8d97077..04059ba 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -508,11 +508,12 @@ static int ext4_blks_to_allocate(Indirect *branch, int k, unsigned long blks,
  *		direct blocks
  */
 static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
-			ext4_fsblk_t goal, int indirect_blks, int blks,
-			ext4_fsblk_t new_blocks[4], int *err)
+				ext4_lblk_t iblock, ext4_fsblk_t goal,
+				int indirect_blks, int blks,
+				ext4_fsblk_t new_blocks[4], int *err)
 {
 	int target, i;
-	unsigned long count = 0;
+	unsigned long count = 0, blk_allocated = 0;
 	int index = 0;
 	ext4_fsblk_t current_block = 0;
 	int ret = 0;
@@ -525,12 +526,13 @@ static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
 	 * the first direct block of this branch.  That's the
 	 * minimum number of blocks need to allocate(required)
 	 */
-	target = blks + indirect_blks;
-
-	while (1) {
+	/* first we try to allocate the indirect blocks */
+	target = indirect_blks;
+	while (target > 0) {
 		count = target;
 		/* allocating blocks for indirect blocks and direct blocks */
-		current_block = ext4_new_blocks(handle,inode,goal,&count,err);
+		current_block = ext4_new_meta_blocks(handle, inode,
+							goal, &count, err);
 		if (*err)
 			goto failed_out;
 
@@ -540,16 +542,48 @@ static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
 			new_blocks[index++] = current_block++;
 			count--;
 		}
-
-		if (count > 0)
+		if (count > 0) {
+			/*
+			 * save the new block number
+			 * for the first direct block
+			 */
+			new_blocks[index] = current_block;
+			printk(KERN_INFO "%s returned more blocks than "
+						"requested\n", __func__);
+			WARN_ON(1);
 			break;
+		}
 	}
 
-	/* save the new block number for the first direct block */
-	new_blocks[index] = current_block;
-
+	target = blks - count ;
+	blk_allocated = count;
+	if (!target)
+		goto allocated;
+	/* Now allocate data blocks */
+	count = target;
+	/* allocating blocks for indirect blocks and direct blocks */
+	current_block = ext4_new_blocks(handle, inode, iblock,
+						goal, &count, err);
+	if (*err && (target == blks)) {
+		/*
+		 * if the allocation failed and we didn't allocate
+		 * any blocks before
+		 */
+		goto failed_out;
+	}
+	if (!*err) {
+		if (target == blks) {
+		/*
+		 * save the new block number
+		 * for the first direct block
+		 */
+			new_blocks[index] = current_block;
+		}
+		blk_allocated += count;
+	}
+allocated:
 	/* total number of blocks allocated for direct blocks */
-	ret = count;
+	ret = blk_allocated;
 	*err = 0;
 	return ret;
 failed_out:
@@ -584,8 +618,9 @@ failed_out:
  *	as described above and return 0.
  */
 static int ext4_alloc_branch(handle_t *handle, struct inode *inode,
-			int indirect_blks, int *blks, ext4_fsblk_t goal,
-			ext4_lblk_t *offsets, Indirect *branch)
+				ext4_lblk_t iblock, int indirect_blks,
+				int *blks, ext4_fsblk_t goal,
+				ext4_lblk_t *offsets, Indirect *branch)
 {
 	int blocksize = inode->i_sb->s_blocksize;
 	int i, n = 0;
@@ -595,7 +630,7 @@ static int ext4_alloc_branch(handle_t *handle, struct inode *inode,
 	ext4_fsblk_t new_blocks[4];
 	ext4_fsblk_t current_block;
 
-	num = ext4_alloc_blocks(handle, inode, goal, indirect_blks,
+	num = ext4_alloc_blocks(handle, inode, iblock, goal, indirect_blks,
 				*blks, new_blocks, &err);
 	if (err)
 		return err;
@@ -855,8 +890,9 @@ int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
 	/*
 	 * Block out ext4_truncate while we alter the tree
 	 */
-	err = ext4_alloc_branch(handle, inode, indirect_blks, &count, goal,
-				offsets + (partial - chain), partial);
+	err = ext4_alloc_branch(handle, inode, iblock, indirect_blks,
+					&count, goal,
+					offsets + (partial - chain), partial);
 
 	/*
 	 * The ext4_splice_branch call will free and forget any buffers
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index ff08633..93c5fdc 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -810,7 +810,7 @@ inserted:
 			/* We need to allocate a new block */
 			ext4_fsblk_t goal = ext4_group_first_block_no(sb,
 						EXT4_I(inode)->i_block_group);
-			ext4_fsblk_t block = ext4_new_block(handle, inode,
+			ext4_fsblk_t block = ext4_new_meta_block(handle, inode,
 							goal, &error);
 			if (error)
 				goto cleanup;
-- 
1.5.6.rc3.1.g36b7.dirty

