From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/2] ext4: Convert to generic reserved quota's space management.
Date: Thu, 10 Dec 2009 04:44:07 +0300
Message-ID: <1260409447-4444-2-git-send-email-dmonakhov@openvz.org>
References: <1260409447-4444-1-git-send-email-dmonakhov@openvz.org>
Content-Transfer-Encoding: 7BIT
Cc: aneesh.kumar@linux.vnet.ibm.com, jack@suse.cz, cmm@us.ibm.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:43582 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759381AbZLJBnz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 9 Dec 2009 20:43:55 -0500
Received: from localhost.localdomain ([unknown] [10.55.93.124])
 by mail.2ka.mipt.ru
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 with ESMTPA id <0KUE0099WYD98370@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Thu, 10 Dec 2009 04:48:48 +0300 (MSK)
In-reply-to: <1260409447-4444-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch solves write vs chown race condition.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h  |    6 +++++-
 fs/ext4/inode.c |   13 ++++---------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 26d3cf8..992cecd 100644
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
+extern qsize_t* ext4_get_reserved_space(struct inode *inode);
 extern int flush_aio_dio_completed_IO(struct inode *inode);
 /* ioctl.c */
 extern long ext4_ioctl(struct file *, unsigned int, unsigned long);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f693768..d833e5a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1048,17 +1048,12 @@ out:
 	return err;
 }
 
-qsize_t ext4_get_reserved_space(struct inode *inode)
+#ifdef CONFIG_QUOTA
+qsize_t* ext4_get_reserved_space(struct inode *inode)
 {
-	unsigned long long total;
-
-	spin_lock(&EXT4_I(inode)->i_block_reservation_lock);
-	total = EXT4_I(inode)->i_reserved_data_blocks +
-		EXT4_I(inode)->i_reserved_meta_blocks;
-	spin_unlock(&EXT4_I(inode)->i_block_reservation_lock);
