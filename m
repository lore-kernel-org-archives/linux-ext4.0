From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH v4 08/22] Change xip_truncate_page to take a get_block parameter
Date: Sun, 22 Dec 2013 16:49:35 -0500
Message-ID: <f9e1ad4625a16fd8e253fb4b421e0235069d6ae2.1387748521.git.matthew.r.wilcox@intel.com>
References: <cover.1387748521.git.matthew.r.wilcox@intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <cover.1387748521.git.matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1387748521.git.matthew.r.wilcox@intel.com>
References: <cover.1387748521.git.matthew.r.wilcox@intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Just like nobh_truncate_page() and block_truncate_page()

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 fs/ext2/inode.c    |  2 +-
 fs/xip.c           | 44 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |  5 +++--
 mm/filemap_xip.c   | 40 ----------------------------------------
 4 files changed, 48 insertions(+), 43 deletions(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index a3f708f..5c1fb09 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -1207,7 +1207,7 @@ static int ext2_setsize(struct inode *inode, loff_t newsize)
 	inode_dio_wait(inode);
 
 	if (IS_XIP(inode))
-		error = xip_truncate_page(inode->i_mapping, newsize);
+		error = xip_truncate_page(inode, newsize, ext2_get_block);
 	else if (test_opt(inode->i_sb, NOBH))
 		error = nobh_truncate_page(inode->i_mapping,
 				newsize, ext2_get_block);
diff --git a/fs/xip.c b/fs/xip.c
index 5740aed..0c5026f 100644
--- a/fs/xip.c
+++ b/fs/xip.c
@@ -238,3 +238,47 @@ int xip_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	return result;
 }
 EXPORT_SYMBOL_GPL(xip_fault);
+
+/**
+ * xip_truncate_page - handle a partial page being truncated in an XIP file
+ * @inode: The file being truncated
+ * @from: The file offset that is being truncated to
+ * @get_block: The filesystem method used to get blocks
+ *
+ * Similar to block_truncate_page(), this function can be called by a
+ * filesystem when it is truncating an XIP file to handle the partial page.
+ *
+ * We work in terms of PAGE_CACHE_SIZE here for commonality with
+ * block_truncate_page(), but we could go down to PAGE_SIZE if the filesystem
+ * took care of disposing of the unnecessary blocks.  Even if the filesystem
+ * block size is smaller than PAGE_SIZE, we have to zero the rest of the page
+ * since the file might be mmaped.
+ */
+int xip_truncate_page(struct inode *inode, loff_t from, get_block_t get_block)
+{
+	struct buffer_head bh;
+	pgoff_t index = from >> PAGE_CACHE_SHIFT;
+	unsigned offset = from & (PAGE_CACHE_SIZE-1);
+	unsigned length = PAGE_CACHE_ALIGN(from) - from;
+	int err;
+
+	/* Block boundary? Nothing to do */
+	if (!length)
+		return 0;
+
+	memset(&bh, 0, sizeof(bh));
+	bh.b_size = PAGE_CACHE_SIZE;
+	err = get_block(inode, index, &bh, 0);
+	if (err < 0)
+		return err;
+	if (buffer_mapped(&bh)) {
+		void *addr;
+		err = xip_get_addr(inode, &bh, &addr);
+		if (err)
+			return err;
+		memset(addr + offset, 0, length);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xip_truncate_page);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5c6e175..d59a714 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2510,15 +2510,16 @@ extern int generic_file_open(struct inode * inode, struct file * filp);
 extern int nonseekable_open(struct inode * inode, struct file * filp);
 
 #ifdef CONFIG_FS_XIP
-extern int xip_truncate_page(struct address_space *mapping, loff_t from);
+int xip_truncate_page(struct inode *, loff_t from, get_block_t);
 ssize_t xip_do_io(int rw, struct kiocb *, struct inode *, const struct iovec *,
 		loff_t, unsigned segs, get_block_t, dio_iodone_t, int flags);
 int xip_fault(struct vm_area_struct *, struct vm_fault *, get_block_t);
 #else
-static inline int xip_truncate_page(struct address_space *mapping, loff_t from)
+static inline int xip_truncate_page(struct inode *i, loff_t frm, get_block_t gb)
 {
 	return 0;
 }
+
 static inline ssize_t xip_do_io(int rw, struct kiocb *iocb, struct inode *inode,
 		const struct iovec *iov, loff_t offset, unsigned nr_segs,
 		get_block_t get_block, dio_iodone_t end_io, int flags)
diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
index 9dd45f3..6316578 100644
--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -21,43 +21,3 @@
 #include <asm/tlbflush.h>
 #include <asm/io.h>
 
-/*
- * truncate a page used for execute in place
- * functionality is analog to block_truncate_page but does use get_xip_mem
- * to get the page instead of page cache
- */
-int
-xip_truncate_page(struct address_space *mapping, loff_t from)
-{
-	pgoff_t index = from >> PAGE_CACHE_SHIFT;
-	unsigned offset = from & (PAGE_CACHE_SIZE-1);
-	unsigned blocksize;
-	unsigned length;
-	void *xip_mem;
-	unsigned long xip_pfn;
-	int err;
-
-	BUG_ON(!mapping->a_ops->get_xip_mem);
-
-	blocksize = 1 << mapping->host->i_blkbits;
-	length = offset & (blocksize - 1);
-
-	/* Block boundary? Nothing to do */
-	if (!length)
-		return 0;
-
-	length = blocksize - length;
-
-	err = mapping->a_ops->get_xip_mem(mapping, index, 0,
-						&xip_mem, &xip_pfn);
-	if (unlikely(err)) {
-		if (err == -ENODATA)
-			/* Hole? No need to truncate */
-			return 0;
-		else
-			return err;
-	}
-	memset(xip_mem + offset, 0, length);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(xip_truncate_page);
-- 
1.8.4.rc3

