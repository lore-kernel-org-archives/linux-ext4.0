From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Patches for the patchqueue
Date: Thu, 5 Jun 2008 15:21:58 +0530
Message-ID: <20080605095158.GF8942@skywalker>
References: <20080605095032.GE8942@skywalker>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="tsOsTdHNUZQcU9Ye"
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:38878 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758163AbYFEJ6D (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jun 2008 05:58:03 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m559v7V2014588
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jun 2008 19:57:07 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m559vASq222380
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jun 2008 19:57:10 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m559qxKp021944
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jun 2008 19:52:59 +1000
Content-Disposition: inline
In-Reply-To: <20080605095032.GE8942@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--tsOsTdHNUZQcU9Ye
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline



--tsOsTdHNUZQcU9Ye
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="002-blkcleanup.patch"

ext4: cleanup blockallocator

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>


---

 fs/ext4/balloc.c  |   72 +++++++++++++++++++----------------------------------
 fs/ext4/ext4.h    |    2 +
 fs/ext4/mballoc.c |    2 +
 3 files changed, 28 insertions(+), 48 deletions(-)


diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
index b961ad1..c6e6a6f 100644
--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -1645,7 +1645,7 @@ int ext4_should_retry_alloc(struct super_block *sb, int *retries)
 }
 
 /**
- * ext4_new_blocks_old() -- core block(s) allocation function
+ * ext4_orlov_new_blocks() -- core block(s) allocation function
  * @handle:		handle to this transaction
  * @inode:		file inode
  * @goal:		given target block(filesystem wide)
@@ -1658,7 +1658,7 @@ int ext4_should_retry_alloc(struct super_block *sb, int *retries)
  * any specific goal block.
  *
  */
-ext4_fsblk_t ext4_new_blocks_old(handle_t *handle, struct inode *inode,
+ext4_fsblk_t ext4_orlov_new_blocks(handle_t *handle, struct inode *inode,
 			ext4_fsblk_t goal, unsigned long *count, int *errp)
 {
 	struct buffer_head *bitmap_bh = NULL;
@@ -1928,55 +1928,15 @@ ext4_fsblk_t ext4_new_blocks_old(handle_t *handle, struct inode *inode,
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
-
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
+				unsigned long *count, int *errp, int meta)
 {
 	struct ext4_allocation_request ar;
 	ext4_fsblk_t ret;
 
 	if (!test_opt(inode->i_sb, MBALLOC)) {
-		ret = ext4_new_blocks_old(handle, inode, goal, count, errp);
-		return ret;
+		return ext4_orlov_new_blocks(handle, inode, goal, count, errp);
 	}
 
 	memset(&ar, 0, sizeof(ar));
@@ -1990,7 +1950,7 @@ ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
 	ar.goal = goal;
 	ar.len = *count;
 	ar.logical = iblock;
-	if (S_ISREG(inode->i_mode))
+	if (S_ISREG(inode->i_mode) && !meta)
 		ar.flags = EXT4_MB_HINT_DATA;
 	else
 		/* disable in-core preallocation for non-regular files */
@@ -2001,6 +1961,26 @@ ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
 }
 
 
+ext4_fsblk_t ext4_new_meta_block(handle_t *handle, struct inode *inode,
+		ext4_fsblk_t goal, int *errp)
+{
+	unsigned long count = 1;
+	return do_blk_alloc(handle, inode, 0, goal, &count, errp, 1);
+}
+
+ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
+		ext4_fsblk_t goal, unsigned long *count, int *errp)
+{
+	return do_blk_alloc(handle, inode, 0, goal, count, errp, 1);
+}
+
+ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
+				ext4_lblk_t iblock, ext4_fsblk_t goal,
+				unsigned long *count, int *errp)
+{
+	return do_blk_alloc(handle, inode, iblock, goal, count, errp, 0);
+}
+
 /**
  * ext4_count_free_blocks() -- count filesystem free blocks
  * @sb:		superblock
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b3e62b7..e70ab6e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -977,7 +977,7 @@ extern ext4_fsblk_t ext4_new_meta_blocks(handle_t *handle, struct inode *inode,
 extern ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
 					ext4_lblk_t iblock, ext4_fsblk_t goal,
 					unsigned long *count, int *errp);
-extern ext4_fsblk_t ext4_new_blocks_old(handle_t *handle, struct inode *inode,
+extern ext4_fsblk_t ext4_orlov_new_blocks(handle_t *handle, struct inode *inode,
 			ext4_fsblk_t goal, unsigned long *count, int *errp);
 extern void ext4_free_blocks (handle_t *handle, struct inode *inode,
 			ext4_fsblk_t block, unsigned long count, int metadata);
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 21a9e04..0011374 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -4035,7 +4035,7 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t *handle,
 	sbi = EXT4_SB(sb);
 
 	if (!test_opt(sb, MBALLOC)) {
-		block = ext4_new_blocks_old(handle, ar->inode, ar->goal,
+		block = ext4_orlov_new_blocks(handle, ar->inode, ar->goal,
 					    &(ar->len), errp);
 		return block;
 	}

--tsOsTdHNUZQcU9Ye--
