From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 3/4] xip: Add xip_zero_page_range
Date: Thu,  5 Dec 2013 13:02:47 -0700
Message-ID: <1386273769-12828-4-git-send-email-ross.zwisler@linux.intel.com>
References: <1386273769-12828-1-git-send-email-ross.zwisler@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	carsteno@de.ibm.com, matthew.r.wilcox@intel.com,
	andreas.dilger@intel.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:60453 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718Ab3LEUDA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Dec 2013 15:03:00 -0500
In-Reply-To: <1386273769-12828-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Matthew Wilcox <matthew.r.wilcox@intel.com>

This new function allows us to support hole-punch for XIP files by zeroing
a partial page, as opposed to the xip_truncate_page() function which can
only truncate to the end of the page.  Reimplement xip_truncate_page() as
a caller of xip_zero_page_range().

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
[ported to 3.13-rc2]
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 include/linux/fs.h |    8 ++++++++
 mm/filemap_xip.c   |   31 +++++++++++++++----------------
 2 files changed, 23 insertions(+), 16 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 121f11f..a063bff 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2509,11 +2509,19 @@ extern int xip_file_mmap(struct file * file, struct vm_area_struct * vma);
 extern ssize_t xip_file_write(struct file *filp, const char __user *buf,
 			      size_t len, loff_t *ppos);
 extern int xip_truncate_page(struct address_space *mapping, loff_t from);
+extern int xip_zero_page_range(struct address_space *, loff_t from,
+			       unsigned length);
 #else
 static inline int xip_truncate_page(struct address_space *mapping, loff_t from)
 {
 	return 0;
 }
+
+static inline int xip_zero_page_range(struct address_space *mapping,
+				      loff_t from, unsigned length)
+{
+	return 0;
+}
 #endif
 
 #ifdef CONFIG_BLOCK
diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
index c8d23e9..d808b72 100644
--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -461,33 +461,19 @@ xip_file_write(struct file *filp, const char __user *buf, size_t len,
 }
 EXPORT_SYMBOL_GPL(xip_file_write);
 
-/*
- * truncate a page used for execute in place
- * functionality is analog to block_truncate_page but does use get_xip_mem
- * to get the page instead of page cache
- */
-int
-xip_truncate_page(struct address_space *mapping, loff_t from)
+int xip_zero_page_range(struct address_space *mapping, loff_t from,
+			unsigned length)
 {
 	pgoff_t index = from >> PAGE_CACHE_SHIFT;
 	unsigned offset = from & (PAGE_CACHE_SIZE-1);
-	unsigned blocksize;
-	unsigned length;
 	void *xip_mem;
 	unsigned long xip_pfn;
 	int err;
 
-	BUG_ON(!mapping->a_ops->get_xip_mem);
-
-	blocksize = 1 << mapping->host->i_blkbits;
-	length = offset & (blocksize - 1);
-
 	/* Block boundary? Nothing to do */
 	if (!length)
 		return 0;
 
-	length = blocksize - length;
-
 	err = mapping->a_ops->get_xip_mem(mapping, index, 0,
 						&xip_mem, &xip_pfn);
 	if (unlikely(err)) {
@@ -497,7 +483,20 @@ xip_truncate_page(struct address_space *mapping, loff_t from)
 		else
 			return err;
 	}
+
 	memset(xip_mem + offset, 0, length);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(xip_zero_page_range);
+
+/*
+ * truncate a page used for execute in place
+ * functionality is analog to block_truncate_page but does use get_xip_mem
+ * to get the page instead of page cache
+ */
+int xip_truncate_page(struct address_space *mapping, loff_t from)
+{
+	unsigned length = PAGE_CACHE_ALIGN(from) - from;
+	return xip_zero_page_range(mapping, from, length);
+}
 EXPORT_SYMBOL_GPL(xip_truncate_page);
-- 
1.7.10.4

