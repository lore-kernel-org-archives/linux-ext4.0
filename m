From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Use inode preallocation with -o noextents
Date: Thu, 15 May 2008 21:23:58 +0530
Message-ID: <1210866839-7195-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com, adilger@sun.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:33969 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbYEOPyJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 May 2008 11:54:09 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m4FFrFDQ021480
	for <linux-ext4@vger.kernel.org>; Fri, 16 May 2008 01:53:15 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4FFrpIm4645090
	for <linux-ext4@vger.kernel.org>; Fri, 16 May 2008 01:53:51 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4FFs2md001956
	for <linux-ext4@vger.kernel.org>; Fri, 16 May 2008 01:54:03 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When mouting ext4 with -o noextents, request for
file data blocks from inode prealloc space.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/balloc.c |    9 ++++++++-
 fs/ext4/ext4.h   |    5 +++--
 fs/ext4/inode.c  |   20 ++++++++++++--------
 3 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index da99437..769b2b3 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1878,7 +1878,8 @@ ext4_fsblk_t ext4_new_block(handle_t *handle, struct inode *inode,
 }
 
 ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
-		ext4_fsblk_t goal, unsigned long *count, int *errp)
+				ext4_lblk_t iblock, ext4_fsblk_t goal,
+				unsigned long *count, int *errp)
 {
 	struct ext4_allocation_request ar;
 	ext4_fsblk_t ret;
@@ -1892,6 +1893,12 @@ ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
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
index 8158083..1bd8e28 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -960,8 +960,9 @@ extern unsigned long ext4_bg_num_gdb(struct super_block *sb,
 			ext4_group_t group);
 extern ext4_fsblk_t ext4_new_block (handle_t *handle, struct inode *inode,
 			ext4_fsblk_t goal, int *errp);
-extern ext4_fsblk_t ext4_new_blocks (handle_t *handle, struct inode *inode,
-			ext4_fsblk_t goal, unsigned long *count, int *errp);
+extern ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
+					ext4_lblk_t iblock, ext4_fsblk_t goal,
+					unsigned long *count, int *errp);
 extern ext4_fsblk_t ext4_new_blocks_old(handle_t *handle, struct inode *inode,
 			ext4_fsblk_t goal, unsigned long *count, int *errp);
 extern void ext4_free_blocks (handle_t *handle, struct inode *inode,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8d97077..0d1923e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -508,8 +508,9 @@ static int ext4_blks_to_allocate(Indirect *branch, int k, unsigned long blks,
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
 	unsigned long count = 0;
@@ -530,7 +531,8 @@ static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
 	while (1) {
 		count = target;
 		/* allocating blocks for indirect blocks and direct blocks */
-		current_block = ext4_new_blocks(handle,inode,goal,&count,err);
+		current_block = ext4_new_blocks(handle, inode, iblock,
+							goal, &count, err);
 		if (*err)
 			goto failed_out;
 
@@ -584,8 +586,9 @@ static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
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
@@ -595,7 +598,7 @@ static int ext4_alloc_branch(handle_t *handle, struct inode *inode,
 	ext4_fsblk_t new_blocks[4];
 	ext4_fsblk_t current_block;
 
-	num = ext4_alloc_blocks(handle, inode, goal, indirect_blks,
+	num = ext4_alloc_blocks(handle, inode, iblock, goal, indirect_blks,
 				*blks, new_blocks, &err);
 	if (err)
 		return err;
@@ -855,8 +858,9 @@ int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
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
-- 
1.5.5.1.211.g65ea3.dirty

