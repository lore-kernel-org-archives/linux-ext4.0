From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/3] ext4: Convert to generic reserved quota's space management.
Date: Wed, 09 Dec 2009 05:11:26 +0300
Message-ID: <1260324686-15863-3-git-send-email-dmonakhov@openvz.org>
References: <1260324686-15863-1-git-send-email-dmonakhov@openvz.org>
 <1260324686-15863-2-git-send-email-dmonakhov@openvz.org>
Content-Transfer-Encoding: 7BIT
Cc: aneesh.kumar@linux.vnet.ibm.com, jack@suse.cz, cmm@us.ibm.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:36952 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754397AbZLICLO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Dec 2009 21:11:14 -0500
Received: from localhost.localdomain ([unknown] [10.55.93.124])
 by mail.2ka.mipt.ru
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 with ESMTPA id <0KUD007044YQZ470@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Wed, 09 Dec 2009 05:16:06 +0300 (MSK)
In-reply-to: <1260324686-15863-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

 - ext4_getattr() not longer required
 - ext4_get_reserved_space() not longer required
 - drop i_block_reservation_lock before vfs_dq_reserve_block().
   this fix http://bugzilla.kernel.org/show_bug.cgi?id=14739diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 26d3cf8..6198751 100644

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h  |    2 -
 fs/ext4/file.c  |    1 -
 fs/ext4/inode.c |   67 +++++++++++++-----------------------------------------
 fs/ext4/super.c |    1 -
 4 files changed, 16 insertions(+), 55 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 26d3cf8..6198751 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1407,8 +1407,6 @@ int ext4_get_block(struct inode *inode, sector_t iblock,
 extern struct inode *ext4_iget(struct super_block *, unsigned long);
 extern int  ext4_write_inode(struct inode *, int);
 extern int  ext4_setattr(struct dentry *, struct iattr *);
-extern int  ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
-				struct kstat *stat);
 extern void ext4_delete_inode(struct inode *);
 extern int  ext4_sync_inode(handle_t *, struct inode *);
 extern void ext4_dirty_inode(struct inode *);
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 9630583..36a75e7 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -151,7 +151,6 @@ const struct file_operations ext4_file_operations = {
 const struct inode_operations ext4_file_inode_operations = {
 	.truncate	= ext4_truncate,
 	.setattr	= ext4_setattr,
-	.getattr	= ext4_getattr,
 #ifdef CONFIG_EXT4_FS_XATTR
 	.setxattr	= generic_setxattr,
 	.getxattr	= generic_getxattr,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cc4737e..9a27505 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1048,17 +1048,6 @@ out:
 	return err;
 }
 
-qsize_t ext4_get_reserved_space(struct inode *inode)
-{
-	unsigned long long total;
-
-	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
-	total = EXT4_I(inode)->i_reserved_data_blocks +
-		EXT4_I(inode)->i_reserved_meta_blocks;
-	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
-
-	return (total << inode->i_blkbits);
-}
 /*
  * Calculate the number of metadata blocks need to reserve
  * to allocate @blocks for non extent file based file
@@ -1852,19 +1841,8 @@ repeat:
 	md_needed = mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
 	total = md_needed + nrblocks;
 
-	/*
-	 * Make quota reservation here to prevent quota overflow
-	 * later. Real quota accounting is done at pages writeout
-	 * time.
-	 */
-	if (vfs_dq_reserve_block(inode, total)) {
-		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
-		return -EDQUOT;
-	}
-
 	if (ext4_claim_free_blocks(sbi, total)) {
 		spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
-		vfs_dq_release_reservation_block(inode, total);
 		if (ext4_should_retry_alloc(inode->i_sb, &retries)) {
 			yield();
 			goto repeat;
@@ -1872,10 +1850,24 @@ repeat:
 		return -ENOSPC;
 	}
 	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
-	EXT4_I(inode)->i_reserved_meta_blocks = mdblocks;
+	EXT4_I(inode)->i_reserved_meta_blocks += md_needed;
+	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
+
+	/*
+	 * Make quota reservation here to prevent quota overflow
+	 * later. Real quota accounting is done at pages writeout
+	 * time.
+	 */
+	if (!vfs_dq_reserve_block(inode, total))
+		return 0;       /* success */
 
+	/* Quota reservation has failed, revert inode's reservation */
+	percpu_counter_sub(&sbi->s_dirtyblocks_counter, total);
+	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
+	EXT4_I(inode)->i_reserved_data_blocks -= nrblocks;
+	EXT4_I(inode)->i_reserved_meta_blocks -= md_needed;
 	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
-	return 0;       /* success */
+	return -EDQUOT;
 }
 
 static void ext4_da_release_space(struct inode *inode, int to_free)
@@ -5511,33 +5503,6 @@ err_out:
 	return error;
 }
 
-int ext4_getattr(struct vfsmount *mnt, struct dentry *dentry,
-		 struct kstat *stat)
-{
-	struct inode *inode;
-	unsigned long delalloc_blocks;
-
-	inode = dentry->d_inode;
-	generic_fillattr(inode, stat);
-
-	/*
-	 * We can't update i_blocks if the block allocation is delayed
-	 * otherwise in the case of system crash before the real block
-	 * allocation is done, we will have i_blocks inconsistent with
-	 * on-disk file blocks.
-	 * We always keep i_blocks updated together with real
-	 * allocation. But to not confuse with user, stat
-	 * will return the blocks that include the delayed allocation
-	 * blocks for this file.
-	 */
-	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
-	delalloc_blocks = EXT4_I(inode)->i_reserved_data_blocks;
-	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
-
-	stat->blocks += (delalloc_blocks << inode->i_sb->s_blocksize_bits)>>9;
-	return 0;
-}
