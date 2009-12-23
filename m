From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/5] ext4: Convert to generic reserved quota's space management.
Date: Wed, 23 Dec 2009 18:27:54 +0100
Message-ID: <1261589276-1380-4-git-send-email-jack@suse.cz>
References: <1261589276-1380-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
	Dmitry Monakhov <dmonakhov@openvz.org>, Jan Kara <jack@suse.cz>
To: stable@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52957 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398AbZLWR2E (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Dec 2009 12:28:04 -0500
In-Reply-To: <1261589276-1380-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Dmitry Monakhov <dmonakhov@openvz.org>

This patch also fixes write vs chown race condition.

Acked-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h  |    6 +++++-
 fs/ext4/inode.c |   17 ++++++++---------
 fs/ext4/super.c |    5 +++++
 3 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 9714db3..daff7d1 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -653,6 +653,10 @@ struct ext4_inode_info {
 	__u16 i_extra_isize;
 
 	spinlock_t i_block_reservation_lock;
+#ifdef CONFIG_QUOTA
+	/* quota space reservation, managed internally by quota code */
+	qsize_t i_reserved_quota;
+#endif
 };
 
 /*
@@ -1377,7 +1381,7 @@ extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
 extern int ext4_block_truncate_page(handle_t *handle,
 		struct address_space *mapping, loff_t from);
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
-extern qsize_t ext4_get_reserved_space(struct inode *inode);
+extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 
 /* ioctl.c */
 extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f9c642b..620ccd5 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1020,17 +1020,13 @@ out:
 	return err;
 }
 
-qsize_t ext4_get_reserved_space(struct inode *inode)
+#ifdef CONFIG_QUOTA
+qsize_t *ext4_get_reserved_space(struct inode *inode)
 {
-	unsigned long long total;
-
-	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
-	total = EXT4_I(inode)->i_reserved_data_blocks +
-		EXT4_I(inode)->i_reserved_meta_blocks;
-	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
-
-	return total;
+	return &EXT4_I(inode)->i_reserved_quota;
 }
+#endif
+
 /*
  * Calculate the number of metadata blocks need to reserve
  * to allocate @blocks for non extent file based file
@@ -4369,6 +4365,9 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 			((__u64)le16_to_cpu(raw_inode->i_file_acl_high)) << 32;
 	inode->i_size = ext4_isize(raw_inode);
 	ei->i_disksize = inode->i_size;
+#ifdef CONFIG_QUOTA
+	ei->i_reserved_quota = 0;
+#endif
 	inode->i_generation = le32_to_cpu(raw_inode->i_generation);
 	ei->i_block_group = iloc.block_group;
 	ei->i_last_alloc_group = ~0;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 8f4f079..f281c5d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -682,6 +682,9 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	ei->i_allocated_meta_blocks = 0;
 	ei->i_delalloc_reserved_flag = 0;
 	spin_lock_init(&(ei->i_block_reservation_lock));
+#ifdef CONFIG_QUOTA
+	ei->i_reserved_quota = 0;
+#endif
 
 	return &ei->vfs_inode;
 }
@@ -969,7 +972,9 @@ static struct dquot_operations ext4_quota_operations = {
 	.reserve_space	= dquot_reserve_space,
 	.claim_space	= dquot_claim_space,
 	.release_rsv	= dquot_release_reserved_space,
+#ifdef CONFIG_QUOTA
 	.get_reserved_space = ext4_get_reserved_space,
+#endif
 	.alloc_inode	= dquot_alloc_inode,
 	.free_space	= dquot_free_space,
 	.free_inode	= dquot_free_inode,
-- 
1.6.4.2

