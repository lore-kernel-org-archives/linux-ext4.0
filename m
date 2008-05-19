From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -v2] ext4: Use inode preallocation with -o noextents
Date: Tue, 20 May 2008 02:04:22 +0530
Message-ID: <1211229262-11012-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:59833 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760769AbYESUed (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 May 2008 16:34:33 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m4JKXc89006131
	for <linux-ext4@vger.kernel.org>; Tue, 20 May 2008 06:33:38 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4JKcYur292584
	for <linux-ext4@vger.kernel.org>; Tue, 20 May 2008 06:38:34 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4JKYQJ3011463
	for <linux-ext4@vger.kernel.org>; Tue, 20 May 2008 06:34:27 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When mouting ext4 with -o noextents, request for
file data blocks from inode prealloc space.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/balloc.c  |   36 +++++++++++++++++++++++++-
 fs/ext4/ext4.h    |    7 +++-
 fs/ext4/extents.c |    2 +-
 fs/ext4/inode.c   |   72 +++++++++++++++++++++++++++++++++++++++-------------
 fs/ext4/xattr.c   |    2 +-
 5 files changed, 95 insertions(+), 24 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index 30494c5..bc7e1cd 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1862,7 +1862,7 @@ ext4_fsblk_t ext4_new_blocks_old(handle_t *handle, struct inode *inode,
 	return 0;
 }
 
-ext4_fsblk_t ext4_new_block(handle_t *handle, struct inode *inode,
+ext4_fsblk_t ext4_new_meta_block(handle_t *handle, struct inode *inode,
 		ext4_fsblk_t goal, int *errp)
 {
 	struct ext4_allocation_request ar;
@@ -1881,9 +1881,29 @@ ext4_fsblk_t ext4_new_block(handle_t *handle, struct inode *inode,
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
@@ -1894,9 +1914,21 @@ ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
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
index 8158083..899406b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -958,10 +958,13 @@ extern ext4_grpblk_t ext4_block_group_offset(struct super_block *sb,
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
index 47929c4..5ba81b3 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -188,7 +188,7 @@ ext4_ext_new_block(handle_t *handle, struct inode *inode,
 	ext4_fsblk_t goal, newblock;
 
 	goal = ext4_ext_find_goal(inode, path, le32_to_cpu(ex->ee_block));
-	newblock = ext4_new_block(handle, inode, goal, err);
+	newblock = ext4_new_meta_block(handle, inode, goal, err);
 	return newblock;
 }
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8d97077..3f4182f 100644
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
+	long count = 0, blk_allocated = 0;
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
@@ -584,8 +618,9 @@ static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
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
@@ -810,7 +810,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 			/* We need to allocate a new block */
 			ext4_fsblk_t goal = ext4_group_first_block_no(sb,
 						EXT4_I(inode)->i_block_group);
-			ext4_fsblk_t block = ext4_new_block(handle, inode,
+			ext4_fsblk_t block = ext4_new_meta_block(handle, inode,
 							goal, &error);
 			if (error)
 				goto cleanup;
-- 
1.5.5.1.211.g65ea3.dirty

