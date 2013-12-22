From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH v4 17/22] xip: Add xip_zero_page_range
Date: Sun, 22 Dec 2013 16:49:44 -0500
Message-ID: <b5aac90d472d59c4d47eeb02062c8549fac137be.1387748521.git.matthew.r.wilcox@intel.com>
References: <cover.1387748521.git.matthew.r.wilcox@intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:21055 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755924Ab3LVVun (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Dec 2013 16:50:43 -0500
In-Reply-To: <cover.1387748521.git.matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1387748521.git.matthew.r.wilcox@intel.com>
References: <cover.1387748521.git.matthew.r.wilcox@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This new function allows us to support hole-punch for XIP files by zeroing
a partial page, as opposed to the xip_truncate_page() function which can
only truncate to the end of the page.  Reimplement xip_truncate_page() as
a macro that calls xip_zero_page_range().

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
[ported to 3.13-rc2]
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/xip.c           | 15 +++++++++------
 include/linux/fs.h | 11 +++++++++--
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/fs/xip.c b/fs/xip.c
index 991a705..e6e52ee 100644
--- a/fs/xip.c
+++ b/fs/xip.c
@@ -274,13 +274,16 @@ int xip_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 EXPORT_SYMBOL_GPL(xip_fault);
 
 /**
- * xip_truncate_page - handle a partial page being truncated in an XIP file
+ * xip_zero_page_range - zero a range within a page of an XIP file
  * @inode: The file being truncated
  * @from: The file offset that is being truncated to
+ * @length: The number of bytes to zero
  * @get_block: The filesystem method used to get blocks
  *
- * Similar to block_truncate_page(), this function can be called by a
- * filesystem when it is truncating an XIP file to handle the partial page.
+ * This function can be called by a filesystem when it is zeroing part of a
+ * page in an XIP file.  This is intended for hole-punch operations.  If
+ * you are truncating a file, the helper function xip_truncate_page() may be
+ * more convenient.
  *
  * We work in terms of PAGE_CACHE_SIZE here for commonality with
  * block_truncate_page(), but we could go down to PAGE_SIZE if the filesystem
@@ -288,12 +291,12 @@ EXPORT_SYMBOL_GPL(xip_fault);
  * block size is smaller than PAGE_SIZE, we have to zero the rest of the page
  * since the file might be mmaped.
  */
-int xip_truncate_page(struct inode *inode, loff_t from, get_block_t get_block)
+int xip_zero_page_range(struct inode *inode, loff_t from, unsigned length,
+							get_block_t get_block)
 {
 	struct buffer_head bh;
 	pgoff_t index = from >> PAGE_CACHE_SHIFT;
 	unsigned offset = from & (PAGE_CACHE_SIZE-1);
-	unsigned length = PAGE_CACHE_ALIGN(from) - from;
 	int err;
 
 	/* Block boundary? Nothing to do */
@@ -315,4 +318,4 @@ int xip_truncate_page(struct inode *inode, loff_t from, get_block_t get_block)
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(xip_truncate_page);
+EXPORT_SYMBOL_GPL(xip_zero_page_range);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a0c6812..3a4a217 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2509,7 +2509,7 @@ extern int nonseekable_open(struct inode * inode, struct file * filp);
 
 #ifdef CONFIG_FS_XIP
 int xip_clear_blocks(struct inode *, sector_t block, long size);
-int xip_truncate_page(struct inode *, loff_t from, get_block_t);
+int xip_zero_page_range(struct inode *, loff_t from, unsigned len, get_block_t);
 ssize_t xip_do_io(int rw, struct kiocb *, struct inode *, const struct iovec *,
 		loff_t, unsigned segs, get_block_t, dio_iodone_t, int flags);
 int xip_fault(struct vm_area_struct *, struct vm_fault *, get_block_t);
@@ -2519,7 +2519,8 @@ static inline int xip_clear_blocks(struct inode *i, sector_t blk, long sz)
 	return 0;
 }
 
-static inline int xip_truncate_page(struct inode *i, loff_t frm, get_block_t gb)
+static inline int xip_zero_page_range(struct inode *inode, loff_t from,
+						unsigned len, get_block_t gb)
 {
 	return 0;
 }
@@ -2538,6 +2539,12 @@ static inline int xip_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 }
 #endif
 
+/* PAGE_CACHE_ALIGN is defined in pagemap.h */
+#define xip_truncate_page(inode, from, get_block)	\
+	xip_zero_page_range(inode, from, PAGE_CACHE_ALIGN(from) - from, \
+					get_block)
+
+
 #ifdef CONFIG_BLOCK
 typedef void (dio_submit_t)(int rw, struct bio *bio, struct inode *inode,
 			    loff_t file_offset);
-- 
1.8.4.rc3

