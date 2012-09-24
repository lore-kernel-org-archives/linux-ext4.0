From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/4] ext4: move_extent code cleanup
Date: Mon, 24 Sep 2012 16:23:51 +0400
Message-ID: <1348489434-22778-2-git-send-email-dmonakhov@openvz.org>
References: <1348489434-22778-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, a-fujita@rs.jp.nec.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53200 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab2IXMYD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Sep 2012 08:24:03 -0400
Received: by lbbgj3 with SMTP id gj3so6602162lbb.19
        for <linux-ext4@vger.kernel.org>; Mon, 24 Sep 2012 05:24:01 -0700 (PDT)
In-Reply-To: <1348489434-22778-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

- Remove usless checks, because it is too late to check that inode != NULL
  at the moment it was referenced several times.
- Double lock routines looks very ugly and locking ordering relays on
  order of i_ino, but other kernel code relay on order of pointers.
  Let's  make them simple and clean.
- check that inodes belongs to the same SB as soon as possible.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/move_extent.c |  131 +++++++++++--------------------------------------
 1 files changed, 29 insertions(+), 102 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index ae0357b..37c8497 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -141,55 +141,21 @@ mext_next_extent(struct inode *inode, struct ext4_ext_path *path,
 }
 
 /**
- * mext_check_null_inode - NULL check for two inodes
- *
- * If inode1 or inode2 is NULL, return -EIO. Otherwise, return 0.
- */
-static int
-mext_check_null_inode(struct inode *inode1, struct inode *inode2,
-		      const char *function, unsigned int line)
-{
-	int ret = 0;
-
-	if (inode1 == NULL) {
-		__ext4_error(inode2->i_sb, function, line,
-			"Both inodes should not be NULL: "
-			"inode1 NULL inode2 %lu", inode2->i_ino);
-		ret = -EIO;
-	} else if (inode2 == NULL) {
-		__ext4_error(inode1->i_sb, function, line,
-			"Both inodes should not be NULL: "
-			"inode1 %lu inode2 NULL", inode1->i_ino);
-		ret = -EIO;
-	}
-	return ret;
-}
-
-/**
  * double_down_write_data_sem - Acquire two inodes' write lock of i_data_sem
  *
- * @orig_inode:		original inode structure
- * @donor_inode:	donor inode structure
- * Acquire write lock of i_data_sem of the two inodes (orig and donor) by
- * i_ino order.
+ * Acquire write lock of i_data_sem of the two inodes
  */
 static void
-double_down_write_data_sem(struct inode *orig_inode, struct inode *donor_inode)
+double_down_write_data_sem(struct inode *first, struct inode *second)
 {
-	struct inode *first = orig_inode, *second = donor_inode;
+	if (first < second) {
+		down_write(&EXT4_I(first)->i_data_sem);
+		down_write_nested(&EXT4_I(second)->i_data_sem, SINGLE_DEPTH_NESTING);
+	} else {
+		down_write(&EXT4_I(second)->i_data_sem);
+		down_write_nested(&EXT4_I(first)->i_data_sem, SINGLE_DEPTH_NESTING);
 
-	/*
-	 * Use the inode number to provide the stable locking order instead
-	 * of its address, because the C language doesn't guarantee you can
-	 * compare pointers that don't come from the same array.
-	 */
-	if (donor_inode->i_ino < orig_inode->i_ino) {
-		first = donor_inode;
-		second = orig_inode;
 	}
-
-	down_write(&EXT4_I(first)->i_data_sem);
-	down_write_nested(&EXT4_I(second)->i_data_sem, SINGLE_DEPTH_NESTING);
 }
 
 /**
@@ -969,14 +935,6 @@ mext_check_arguments(struct inode *orig_inode,
 		return -EINVAL;
 	}
 
-	/* Files should be in the same ext4 FS */
-	if (orig_inode->i_sb != donor_inode->i_sb) {
-		ext4_debug("ext4 move extent: The argument files "
-			"should be in same FS [ino:orig %lu, donor %lu]\n",
-			orig_inode->i_ino, donor_inode->i_ino);
-		return -EINVAL;
-	}
-
 	/* Ext4 move extent supports only extent based file */
 	if (!(ext4_test_inode_flag(orig_inode, EXT4_INODE_EXTENTS))) {
 		ext4_debug("ext4 move extent: orig file is not extents "
@@ -1072,35 +1030,19 @@ mext_check_arguments(struct inode *orig_inode,
  * @inode1:	the inode structure
  * @inode2:	the inode structure
  *
- * Lock two inodes' i_mutex by i_ino order.
- * If inode1 or inode2 is NULL, return -EIO. Otherwise, return 0.
+ * Lock two inodes' i_mutex
  */
-static int
+static void
 mext_inode_double_lock(struct inode *inode1, struct inode *inode2)
 {
-	int ret = 0;
-
-	BUG_ON(inode1 == NULL && inode2 == NULL);
-
-	ret = mext_check_null_inode(inode1, inode2, __func__, __LINE__);
-	if (ret < 0)
-		goto out;
-
-	if (inode1 == inode2) {
-		mutex_lock(&inode1->i_mutex);
-		goto out;
-	}
-
-	if (inode1->i_ino < inode2->i_ino) {
+	BUG_ON(inode1 == inode2);
+	if (inode1 < inode2) {
 		mutex_lock_nested(&inode1->i_mutex, I_MUTEX_PARENT);
 		mutex_lock_nested(&inode2->i_mutex, I_MUTEX_CHILD);
 	} else {
 		mutex_lock_nested(&inode2->i_mutex, I_MUTEX_PARENT);
 		mutex_lock_nested(&inode1->i_mutex, I_MUTEX_CHILD);
 	}
-
-out:
-	return ret;
 }
 
 /**
@@ -1109,28 +1051,13 @@ out:
  * @inode1:     the inode that is released first
  * @inode2:     the inode that is released second
  *
- * If inode1 or inode2 is NULL, return -EIO. Otherwise, return 0.
  */
 
-static int
+static void
 mext_inode_double_unlock(struct inode *inode1, struct inode *inode2)
 {
-	int ret = 0;
-
-	BUG_ON(inode1 == NULL && inode2 == NULL);
-
-	ret = mext_check_null_inode(inode1, inode2, __func__, __LINE__);
-	if (ret < 0)
-		goto out;
-
-	if (inode1)
-		mutex_unlock(&inode1->i_mutex);
-
-	if (inode2 && inode2 != inode1)
-		mutex_unlock(&inode2->i_mutex);
-
-out:
-	return ret;
+	mutex_unlock(&inode1->i_mutex);
+	mutex_unlock(&inode2->i_mutex);
 }
 
 /**
@@ -1187,16 +1114,23 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
 	ext4_lblk_t block_end, seq_start, add_blocks, file_end, seq_blocks = 0;
 	ext4_lblk_t rest_blocks;
 	pgoff_t orig_page_offset = 0, seq_end_page;
-	int ret1, ret2, depth, last_extent = 0;
+	int ret1, depth, last_extent = 0;
 	int blocks_per_page = PAGE_CACHE_SIZE >> orig_inode->i_blkbits;
 	int data_offset_in_page;
 	int block_len_in_page;
 	int uninit;
 
-	/* orig and donor should be different file */
-	if (orig_inode->i_ino == donor_inode->i_ino) {
+	if (orig_inode->i_sb != donor_inode->i_sb) {
+		ext4_debug("ext4 move extent: The argument files "
+			"should be in same FS [ino:orig %lu, donor %lu]\n",
+			orig_inode->i_ino, donor_inode->i_ino);
+		return -EINVAL;
+	}
+
+	/* orig and donor should be different inodes */
+	if (orig_inode == donor_inode) {
 		ext4_debug("ext4 move extent: The argument files should not "
-			"be same file [ino:orig %lu, donor %lu]\n",
+			"be same inode [ino:orig %lu, donor %lu]\n",
 			orig_inode->i_ino, donor_inode->i_ino);
 		return -EINVAL;
 	}
@@ -1210,9 +1144,7 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp,
 	}
 
 	/* Protect orig and donor inodes against a truncate */
-	ret1 = mext_inode_double_lock(orig_inode, donor_inode);
-	if (ret1 < 0)
-		return ret1;
+	mext_inode_double_lock(orig_inode, donor_inode);
 
 	/* Wait for all existing dio workers */
 	ext4_inode_block_unlocked_dio(orig_inode);
@@ -1420,12 +1352,7 @@ out:
 	double_up_write_data_sem(orig_inode, donor_inode);
 	ext4_inode_block_unlocked_dio(orig_inode);
 	ext4_inode_block_unlocked_dio(donor_inode);
-	ret2 = mext_inode_double_unlock(orig_inode, donor_inode);
+	mext_inode_double_unlock(orig_inode, donor_inode);
 
-	if (ret1)
-		return ret1;
-	else if (ret2)
-		return ret2;
