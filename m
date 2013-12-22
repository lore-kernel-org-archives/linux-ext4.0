From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH v4 07/22] Rewrite XIP page fault handling
Date: Sun, 22 Dec 2013 16:49:34 -0500
Message-ID: <e7ae2a539935d1cf2a096296f2f988eee6a558de.1387748521.git.matthew.r.wilcox@intel.com>
References: <cover.1387748521.git.matthew.r.wilcox@intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15081 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755922Ab3LVVuL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Dec 2013 16:50:11 -0500
In-Reply-To: <cover.1387748521.git.matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1387748521.git.matthew.r.wilcox@intel.com>
References: <cover.1387748521.git.matthew.r.wilcox@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Instead of calling aops->get_xip_mem from the fault handler, allow the
filesystem to pass in a get_block_t that is used to find the appropriate
blocks.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 fs/ext2/file.c     | 25 ++++++++++++--
 fs/xip.c           | 99 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h | 13 ++++---
 mm/filemap_xip.c   | 92 --------------------------------------------------
 4 files changed, 130 insertions(+), 99 deletions(-)

diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index b0eb1d4..47a0b1d 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -25,6 +25,27 @@
 #include "xattr.h"
 #include "acl.h"
 
+static int ext2_xip_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	return xip_fault(vma, vmf, ext2_get_block);
+}
+
+static const struct vm_operations_struct ext2_xip_vm_ops = {
+	.fault		= ext2_xip_fault,
+	.remap_pages	= generic_file_remap_pages,
+};
+
+static int ext2_file_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	if (!IS_XIP(file_inode(file)))
+		return generic_file_mmap(file, vma);
+
+	file_accessed(file);
+	vma->vm_ops = &ext2_xip_vm_ops;
+	vma->vm_flags |= VM_MIXEDMAP;
+	return 0;
+}
+
 /*
  * Called when filp is released. This happens when all file descriptors
  * for a single struct file are closed. Note that different open() calls
@@ -70,7 +91,7 @@ const struct file_operations ext2_file_operations = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext2_compat_ioctl,
 #endif
-	.mmap		= generic_file_mmap,
+	.mmap		= ext2_file_mmap,
 	.open		= dquot_file_open,
 	.release	= ext2_release_file,
 	.fsync		= ext2_fsync,
@@ -89,7 +110,7 @@ const struct file_operations ext2_xip_file_operations = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ext2_compat_ioctl,
 #endif
-	.mmap		= xip_file_mmap,
+	.mmap		= ext2_file_mmap,
 	.open		= dquot_file_open,
 	.release	= ext2_release_file,
 	.fsync		= ext2_fsync,
diff --git a/fs/xip.c b/fs/xip.c
index fcb6ffd..5740aed 100644
--- a/fs/xip.c
+++ b/fs/xip.c
@@ -18,6 +18,8 @@
 #include <linux/buffer_head.h>
 #include <linux/fs.h>
 #include <linux/genhd.h>
+#include <linux/highmem.h>
+#include <linux/mm.h>
 #include <linux/mutex.h>
 #include <linux/uio.h>
 
@@ -31,6 +33,16 @@ static long xip_get_addr(struct inode *inode, struct buffer_head *bh,
 	return ops->direct_access(bdev, sector, addr, &pfn, bh->b_size);
 }
 
+static long xip_get_pfn(struct inode *inode, struct buffer_head *bh,
+							unsigned long *pfn)
+{
+	struct block_device *bdev = bh->b_bdev;
+	const struct block_device_operations *ops = bdev->bd_disk->fops;
+	void *addr;
+	sector_t sector = bh->b_blocknr << (inode->i_blkbits - 9);
+	return ops->direct_access(bdev, sector, &addr, pfn, bh->b_size);
+}
+
 static ssize_t xip_io(int rw, struct inode *inode, const struct iovec *iov,
 		loff_t start, loff_t end, unsigned nr_segs,
 		get_block_t get_block, struct buffer_head *bh)
@@ -139,3 +151,90 @@ ssize_t xip_do_io(int rw, struct kiocb *iocb, struct inode *inode,
 }
 EXPORT_SYMBOL_GPL(xip_do_io);
 
+static inline void copy_user_bh(struct page *to, struct inode *inode,
+				struct buffer_head *bh, unsigned long vaddr)
+{
+	void *vfrom, *vto;
+	xip_get_addr(inode, bh, &vfrom);	/* XXX: error handling */
+	vto = kmap_atomic(to);
+	copy_user_page(vto, vfrom, vaddr, to);
+	kunmap_atomic(vto);
+}
+
+/*
+ * xip_fault() is invoked via the vma operations vector for a
+ * mapped memory region to read in file data during a page fault.
+ *
+ * This function is derived from filemap_fault, but used for execute in place
+ */
+static int do_xip_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
+			get_block_t get_block)
+{
+	struct file *file = vma->vm_file;
+	struct inode *inode = file_inode(file);
+	struct address_space *mapping = file->f_mapping;
+	struct buffer_head bh;
+	unsigned long vaddr = (unsigned long)vmf->virtual_address;
+	sector_t block;
+	pgoff_t size;
+	unsigned long pfn;
+	int error;
+
+	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	if (vmf->pgoff >= size)
+		return VM_FAULT_SIGBUS;
+
+	memset(&bh, 0, sizeof(bh));
+	block = (sector_t)vmf->pgoff << (PAGE_SHIFT - inode->i_blkbits);
+	bh.b_size = PAGE_SIZE;
+	error = get_block(inode, block, &bh, 0);
+
+	/* Don't allocate backing store if we're going to COW a hole */
+	if (!error && !buffer_mapped(&bh) && !vmf->cow_page) {
+		error = get_block(inode, block, &bh, 1);
+	}
+
+	if (error)
+		return VM_FAULT_SIGBUS;
+
+	/* We must recheck i_size under i_mmap_mutex */
+	mutex_lock(&mapping->i_mmap_mutex);
+	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	if (unlikely(vmf->pgoff >= size)) {
+		mutex_unlock(&mapping->i_mmap_mutex);
+		return VM_FAULT_SIGBUS;
+	}
+	if (vmf->cow_page) {
+		if (buffer_mapped(&bh))
+			copy_user_bh(vmf->cow_page, inode, &bh, vaddr);
+		else
+			clear_user_highpage(vmf->cow_page, vaddr);
+		return VM_FAULT_COWED;
+	}
+
+	error = xip_get_pfn(inode, &bh, &pfn);
+	if (error > 0)
+		error = vm_insert_mixed(vma, vaddr, pfn);
+	mutex_unlock(&mapping->i_mmap_mutex);
+	if (error == -ENOMEM)
+		return VM_FAULT_OOM;
+	/* -EBUSY is fine, somebody else faulted on the same PTE */
+	if (error != -EBUSY)
+		BUG_ON(error);
+	return VM_FAULT_NOPAGE;
+}
+
+int xip_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
+			get_block_t get_block)
+{
+	int result;
+	struct super_block *sb = file_inode(vma->vm_file)->i_sb;
+
+	sb_start_pagefault(sb);
+	file_update_time(vma->vm_file);
+	result = do_xip_fault(vma, vmf, get_block);
+	sb_end_pagefault(sb);
+
+	return result;
+}
+EXPORT_SYMBOL_GPL(xip_fault);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 26e9095..5c6e175 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -48,6 +48,7 @@ struct cred;
 struct swap_info_struct;
 struct seq_file;
 struct workqueue_struct;
+struct vm_fault;
 
 extern void __init inode_init(void);
 extern void __init inode_init_early(void);
@@ -2509,14 +2510,10 @@ extern int generic_file_open(struct inode * inode, struct file * filp);
 extern int nonseekable_open(struct inode * inode, struct file * filp);
 
 #ifdef CONFIG_FS_XIP
-extern ssize_t xip_file_read(struct file *filp, char __user *buf, size_t len,
-			     loff_t *ppos);
-extern int xip_file_mmap(struct file * file, struct vm_area_struct * vma);
-extern ssize_t xip_file_write(struct file *filp, const char __user *buf,
-			      size_t len, loff_t *ppos);
 extern int xip_truncate_page(struct address_space *mapping, loff_t from);
 ssize_t xip_do_io(int rw, struct kiocb *, struct inode *, const struct iovec *,
 		loff_t, unsigned segs, get_block_t, dio_iodone_t, int flags);
+int xip_fault(struct vm_area_struct *, struct vm_fault *, get_block_t);
 #else
 static inline int xip_truncate_page(struct address_space *mapping, loff_t from)
 {
@@ -2528,6 +2525,12 @@ static inline ssize_t xip_do_io(int rw, struct kiocb *iocb, struct inode *inode,
 {
 	return -ENOTTY;
 }
+
+static inline int xip_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
+				get_block_t gb)
+{
+	return 0;
+}
 #endif
 
 #ifdef CONFIG_BLOCK
diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
index bea0980..9dd45f3 100644
--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -22,98 +22,6 @@
 #include <asm/io.h>
 
 /*
- * Only one caller is allowed to try to create mappings at a time.
- * Should move down into filesystem code
- */
-static DEFINE_MUTEX(xip_sparse_mutex);
-
-static inline void copy_user_highdest(struct page *to, void *vfrom,
-					unsigned long vaddr)
-{
-	char *vto = kmap_atomic(to);
-	copy_user_page(vto, vfrom, vaddr, to);
-	kunmap_atomic(vto);
-}
-
-/*
- * xip_fault() is invoked via the vma operations vector for a
- * mapped memory region to read in file data during a page fault.
- *
- * This function is derived from filemap_fault, but used for execute in place
- */
-static int xip_file_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
-{
-	struct file *file = vma->vm_file;
-	struct address_space *mapping = file->f_mapping;
-	struct inode *inode = mapping->host;
-	unsigned long vaddr = (unsigned long)vmf->virtual_address;
-	pgoff_t size;
-	void *xip_mem;
-	unsigned long xip_pfn;
-	int error;
-
-	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
-	if (vmf->pgoff >= size)
-		return VM_FAULT_SIGBUS;
-
-	error = mapping->a_ops->get_xip_mem(mapping, vmf->pgoff, 0,
-						&xip_mem, &xip_pfn);
-	if (likely(!error))
-		goto found;
-	/* Don't allocate backing store if we're going to COW a hole */
-	if (error == -ENODATA && !vmf->cow_page) {
-		mutex_lock(&xip_sparse_mutex);
-		error = mapping->a_ops->get_xip_mem(mapping, vmf->pgoff, 1,
-							&xip_mem, &xip_pfn);
-		mutex_unlock(&xip_sparse_mutex);
-	}
-	if (error != -ENODATA)
-		return VM_FAULT_SIGBUS;
-
-found:
-	/* We must recheck i_size under i_mmap_mutex */
-	mutex_lock(&mapping->i_mmap_mutex);
-	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
-	if (unlikely(vmf->pgoff >= size)) {
-		mutex_unlock(&mapping->i_mmap_mutex);
-		return VM_FAULT_SIGBUS;
-	}
-	if (vmf->cow_page) {
-		if (error == -ENODATA)
-			clear_user_highpage(vmf->cow_page, vaddr);
-		else
-			copy_user_highdest(vmf->cow_page, xip_mem, vaddr);
-		return VM_FAULT_COWED;
-	}
-
-	error = vm_insert_mixed(vma, vaddr, xip_pfn);
-	mutex_unlock(&mapping->i_mmap_mutex);
-	if (error == -ENOMEM)
-		return VM_FAULT_OOM;
-	/* -EBUSY is fine, somebody else faulted on the same PTE */
-	if (error != -EBUSY)
-		BUG_ON(error);
-	return VM_FAULT_NOPAGE;
-}
-
-static const struct vm_operations_struct xip_file_vm_ops = {
-	.fault	= xip_file_fault,
-	.page_mkwrite	= filemap_page_mkwrite,
-	.remap_pages = generic_file_remap_pages,
-};
-
-int xip_file_mmap(struct file * file, struct vm_area_struct * vma)
-{
-	BUG_ON(!file->f_mapping->a_ops->get_xip_mem);
-
-	file_accessed(file);
-	vma->vm_ops = &xip_file_vm_ops;
-	vma->vm_flags |= VM_MIXEDMAP;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(xip_file_mmap);
