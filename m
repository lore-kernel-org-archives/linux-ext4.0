From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] ext2/3,jbd: replace __FUNCTION__ with __func__
Date: Mon, 21 Jul 2008 02:07:19 +0400
Message-ID: <20080720220719.GB31640@orion>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org, sct@redhat.com,
	akpm@linux-foundation.org, adilger@sun.com,
	kernel-janitors@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.187]:2911 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbYGTWHb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 20 Jul 2008 18:07:31 -0400
Received: by mu-out-0910.google.com with SMTP id w8so718501mue.1
        for <linux-ext4@vger.kernel.org>; Sun, 20 Jul 2008 15:07:29 -0700 (PDT)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Alexander Beregalov <a.beregalov@gmail.com>

ext2/3,jbd: replace __FUNCTION__ with __func__


Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

---

 include/linux/ext2_fs.h  |    2 +-
 include/linux/ext3_fs.h  |    4 ++--
 include/linux/ext3_jbd.h |   14 +++++++-------
 include/linux/jbd.h      |    4 ++--
 include/linux/jbd2.h     |    4 ++--
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
index 84cec2a..e81e148 100644
--- a/include/linux/ext2_fs.h
+++ b/include/linux/ext2_fs.h
@@ -47,7 +47,7 @@
 #ifdef EXT2FS_DEBUG
 #	define ext2_debug(f, a...)	{ \
 					printk ("EXT2-fs DEBUG (%s, %d): %s:", \
-						__FILE__, __LINE__, __FUNCTION__); \
+						__FILE__, __LINE__, __func__); \
 				  	printk (f, ## a); \
 					}
 #else
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 36c5403..c0a20b2 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -43,7 +43,7 @@
 #define ext3_debug(f, a...)						\
 	do {								\
 		printk (KERN_DEBUG "EXT3-fs DEBUG (%s, %d): %s:",	\
-			__FILE__, __LINE__, __FUNCTION__);		\
+			__FILE__, __LINE__, __func__);			\
 		printk (KERN_DEBUG f, ## a);				\
 	} while (0)
 #else
@@ -868,7 +868,7 @@ extern void ext3_update_dynamic_rev (struct super_block *sb);
 #define ext3_std_error(sb, errno)				\
 do {								\
 	if ((errno))						\
-		__ext3_std_error((sb), __FUNCTION__, (errno));	\
+		__ext3_std_error((sb), __func__, (errno));	\
 } while (0)
 
 /*
diff --git a/include/linux/ext3_jbd.h b/include/linux/ext3_jbd.h
index 8c43b13..cf82d51 100644
--- a/include/linux/ext3_jbd.h
+++ b/include/linux/ext3_jbd.h
@@ -137,17 +137,17 @@ int __ext3_journal_dirty_metadata(const char *where,
 				handle_t *handle, struct buffer_head *bh);
 
 #define ext3_journal_get_undo_access(handle, bh) \
-	__ext3_journal_get_undo_access(__FUNCTION__, (handle), (bh))
+	__ext3_journal_get_undo_access(__func__, (handle), (bh))
 #define ext3_journal_get_write_access(handle, bh) \
-	__ext3_journal_get_write_access(__FUNCTION__, (handle), (bh))
+	__ext3_journal_get_write_access(__func__, (handle), (bh))
 #define ext3_journal_revoke(handle, blocknr, bh) \
-	__ext3_journal_revoke(__FUNCTION__, (handle), (blocknr), (bh))
+	__ext3_journal_revoke(__func__, (handle), (blocknr), (bh))
 #define ext3_journal_get_create_access(handle, bh) \
-	__ext3_journal_get_create_access(__FUNCTION__, (handle), (bh))
+	__ext3_journal_get_create_access(__func__, (handle), (bh))
 #define ext3_journal_dirty_metadata(handle, bh) \
-	__ext3_journal_dirty_metadata(__FUNCTION__, (handle), (bh))
+	__ext3_journal_dirty_metadata(__func__, (handle), (bh))
 #define ext3_journal_forget(handle, bh) \
-	__ext3_journal_forget(__FUNCTION__, (handle), (bh))
+	__ext3_journal_forget(__func__, (handle), (bh))
 
 int ext3_journal_dirty_data(handle_t *handle, struct buffer_head *bh);
 
@@ -160,7 +160,7 @@ static inline handle_t *ext3_journal_start(struct inode *inode, int nblocks)
 }
 
 #define ext3_journal_stop(handle) \
-	__ext3_journal_stop(__FUNCTION__, (handle))
+	__ext3_journal_stop(__func__, (handle))
 
 static inline handle_t *ext3_journal_current_handle(void)
 {
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index 07a9b52..83bd836 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -61,7 +61,7 @@ extern u8 journal_enable_debug;
 	do {								\
 		if ((n) <= journal_enable_debug) {			\
 			printk (KERN_DEBUG "(%s, %d): %s: ",		\
-				__FILE__, __LINE__, __FUNCTION__);	\
+				__FILE__, __LINE__, __func__);		\
 			printk (f, ## a);				\
 		}							\
 	} while (0)
@@ -984,7 +984,7 @@ extern int	cleanup_journal_tail(journal_t *);
 
 #define jbd_ENOSYS() \
 do {								           \
-	printk (KERN_ERR "JBD unimplemented function %s\n", __FUNCTION__); \
+	printk (KERN_ERR "JBD unimplemented function %s\n", __func__);     \
 	current->state = TASK_UNINTERRUPTIBLE;			           \
 	schedule();						           \
 } while (1)
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 3dd2090..a7ecc2c 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -61,7 +61,7 @@ extern u8 jbd2_journal_enable_debug;
 	do {								\
 		if ((n) <= jbd2_journal_enable_debug) {			\
 			printk (KERN_DEBUG "(%s, %d): %s: ",		\
-				__FILE__, __LINE__, __FUNCTION__);	\
+				__FILE__, __LINE__, __func__);		\
 			printk (f, ## a);				\
 		}							\
 	} while (0)
@@ -1139,7 +1139,7 @@ extern int	jbd2_cleanup_journal_tail(journal_t *);
 
 #define jbd_ENOSYS() \
 do {								           \
-	printk (KERN_ERR "JBD unimplemented function %s\n", __FUNCTION__); \
+	printk (KERN_ERR "JBD unimplemented function %s\n", __func__);     \
 	current->state = TASK_UNINTERRUPTIBLE;			           \
 	schedule();						           \
 } while (1)
