From: rjevskiy@gmail.com
Subject: [PATCH 3/3] ext4: Convert to generic reserved quota's space management. [V5]
Date: Sat, 12 Dec 2009 19:19:47 +0300
Message-ID: <1260634787-29370-3-git-send-email-rjevskiy@gmail.com>
References: <1260634787-29370-1-git-send-email-rjevskiy@gmail.com>
 <1260634787-29370-2-git-send-email-rjevskiy@gmail.com>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:59541 "HELO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934123AbZLMBrt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Dec 2009 20:47:49 -0500
Received: by bwz27 with SMTP id 27so1362132bwz.21
        for <linux-ext4@vger.kernel.org>; Sat, 12 Dec 2009 17:47:46 -0800 (PST)
In-Reply-To: <1260634787-29370-2-git-send-email-rjevskiy@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Dmitry Monakhov <dmonakhov@openvz.org>

This patch fix write vs chown race condition.

Changes from V4
 - Coding style cleanup according to Jan's comment.
Changes from V2:
 - add missed i_reserved_quota iniatilization.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h  |    6 +++++-
 fs/ext4/inode.c |   16 +++++++---------
 fs/ext4/super.c |    3 +++
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 26d3cf8..708496f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -705,6 +705,10 @@ struct ext4_inode_info {
 	struct list_head i_aio_dio_complete_list;
 	/* current io_end structure for async DIO write*/
 	ext4_io_end_t *cur_aio_dio;
+#ifdef CONFIG_QUOTA
+	/* quota space reservation, managed internally by quota code */
+	qsize_t i_reserved_quota;
+#endif
 };
 
 /*
@@ -1427,7 +1431,7 @@ extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
 extern int ext4_block_truncate_page(handle_t *handle,
 		struct address_space *mapping, loff_t from);
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
-extern qsize_t ext4_get_reserved_space(struct inode *inode);
+extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 extern int flush_aio_dio_completed_IO(struct inode *inode);
 /* ioctl.c */
 extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d99173a..8254fe6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1048,17 +1048,12 @@ out:
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
-	return (total << inode->i_blkbits);
+	return &EXT4_I(inode)->i_reserved_quota;
 }
+#endif
 /*
  * Calculate the number of metadata blocks need to reserve
  * to allocate @blocks for non extent file based file
@@ -5048,6 +5043,9 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
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
index 4c87d97..4697272 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -713,6 +713,9 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	spin_lock_init(&(ei->i_block_reservation_lock));
 	INIT_LIST_HEAD(&ei->i_aio_dio_complete_list);
 	ei->cur_aio_dio = NULL;
+#ifdef CONFIG_QUOTA
+	ei->i_reserved_quota = 0;
+#endif
 
 	return &ei->vfs_inode;
 }
-- 
1.6.0.4

