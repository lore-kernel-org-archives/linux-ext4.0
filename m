From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH v4 21/22] Add support for pmd_faults
Date: Sun, 22 Dec 2013 16:49:48 -0500
Message-ID: <e944917f571781b46ca4dbb789ae8a86c5166059.1387748521.git.matthew.r.wilcox@intel.com>
References: <cover.1387748521.git.matthew.r.wilcox@intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <cover.1387748521.git.matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1387748521.git.matthew.r.wilcox@intel.com>
References: <cover.1387748521.git.matthew.r.wilcox@intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Introduce the vm_ops ->pmd_fault handler, add a vm_insert_pfn_pmd function
and create an xip_pmd_fault handler.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 fs/ext2/file.c     |   9 ++++-
 fs/ext4/file.c     |   9 ++++-
 fs/xip.c           | 101 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h |   8 ++---
 include/linux/mm.h |   4 +++
 mm/memory.c        |  50 +++++++++++++++++++++++---
 6 files changed, 169 insertions(+), 12 deletions(-)

diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 6e6e803..7d6e492 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -31,8 +31,15 @@ static int ext2_xip_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	return xip_fault(vma, vmf, ext2_get_block);
 }
 
+static int ext2_xip_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
+						pmd_t *pmd, unsigned int flags)
+{
+	return xip_pmd_fault(vma, addr, pmd, flags, ext2_get_block);
+}
+
 static const struct vm_operations_struct ext2_xip_vm_ops = {
 	.fault		= ext2_xip_fault,
+	.pmd_fault	= ext2_xip_pmd_fault,
 	.remap_pages	= generic_file_remap_pages,
 };
 
@@ -43,7 +50,7 @@ static int ext2_file_mmap(struct file *file, struct vm_area_struct *vma)
 
 	file_accessed(file);
 	vma->vm_ops = &ext2_xip_vm_ops;
-	vma->vm_flags |= VM_MIXEDMAP;
+	vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
 	return 0;
 }
 #else
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index d6ae6be..6211f56 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -205,8 +205,15 @@ static int ext4_xip_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 					/* Is this the right get_block? */
 }
 
+static int ext4_xip_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
+						pmd_t *pmd, unsigned int flags)
+{
+	return xip_pmd_fault(vma, addr, pmd, flags, ext4_get_block);
+}
+
 static const struct vm_operations_struct ext4_xip_vm_ops = {
 	.fault		= ext4_xip_fault,
+	.pmd_fault	= ext4_xip_pmd_fault,
 	.remap_pages	= generic_file_remap_pages,
 };
 #else
@@ -224,7 +231,7 @@ static int ext4_file_mmap(struct file *file, struct vm_area_struct *vma)
 	file_accessed(file);
 	if (IS_XIP(file_inode(file))) {
 		vma->vm_ops = &ext4_xip_vm_ops;
-		vma->vm_flags |= VM_MIXEDMAP;
+		vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
 	} else {
 		vma->vm_ops = &ext4_file_vm_ops;
 	}
diff --git a/fs/xip.c b/fs/xip.c
index e6e52ee..d032838 100644
--- a/fs/xip.c
+++ b/fs/xip.c
@@ -273,6 +273,107 @@ int xip_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 }
 EXPORT_SYMBOL_GPL(xip_fault);
 
+/*
+ * The 'colour' (ie low bits) within a PMD of a page offset.  This comes up
+ * more often than one might expect in the below function.
+ */
+#define PG_PMD_COLOUR	((PMD_SIZE >> PAGE_SHIFT) - 1)
+
+/*
+ * We are willing to use a PMD mapping to cover the end of a file if it
+ * could be mapped by a complete PMD's worth of PTEs.  That is, the last
+ * part of the file might be slightly smaller than PMD_SIZE, but as long
+ * as it's at least (PMD_SIZE - PAGE_SIZE + 1) bytes long, we allow the
+ * PMD mapping.
+ */
+static int do_xip_pmd_fault(struct vm_area_struct *vma, unsigned long address,
+			pmd_t *pmd, unsigned int flags, get_block_t get_block)
+{
+	struct file *file = vma->vm_file;
+	struct inode *inode = file_inode(file);
+	struct address_space *mapping = file->f_mapping;
+	struct buffer_head bh;
+	long length;
+	pgoff_t size, pgoff;
+	sector_t block;
+	unsigned long pfn;
+
+	/* Fall back to PTEs if we're going to COW */
+	if ((flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED))
+		return VM_FAULT_FALLBACK;
+
+	pgoff = ((address - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
+	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	if (pgoff >= size)
+		return VM_FAULT_SIGBUS;
+	if ((pgoff | PG_PMD_COLOUR) >= size)
+		return VM_FAULT_FALLBACK;
+
+	memset(&bh, 0, sizeof(bh));
+	block = ((sector_t)pgoff & ~PG_PMD_COLOUR) <<
+					(PAGE_SHIFT - inode->i_blkbits);
+
+	/* Start by seeing if we already have an allocated block */
+	bh.b_size = PMD_SIZE;
+	length = get_block(inode, block, &bh, 0);
+	if (length)
+		return VM_FAULT_SIGBUS;
+	if (buffer_mapped(&bh) && bh.b_size == PMD_SIZE)
+		goto insert;
+
+	/* Next, try to allocate the whole thing */
+	bh.b_size = PMD_SIZE;
+	length = get_block(inode, block, &bh, 1);
+	if (length)
+		return VM_FAULT_SIGBUS;
+	if (bh.b_size == PMD_SIZE)
+		goto insert;
+
+	return VM_FAULT_FALLBACK;
+
+ insert:
+	length = xip_get_pfn(inode, &bh, &pfn);
+	if (length < 0)
+		return VM_FAULT_SIGBUS;
+	if (length < PMD_SIZE)
+		return VM_FAULT_FALLBACK;
+	if (pfn & PG_PMD_COLOUR)
+		return VM_FAULT_FALLBACK;	/* not aligned */
+
+	/* We must recheck i_size under i_mmap_mutex */
+	mutex_lock(&mapping->i_mmap_mutex);
+	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	if ((pgoff | PG_PMD_COLOUR) < size)
+		length = vm_insert_pfn_pmd(vma, address, pmd, pfn);
+	mutex_unlock(&mapping->i_mmap_mutex);
+
+	if (pgoff >= size)
+		return VM_FAULT_SIGBUS;
+	if ((pgoff | PG_PMD_COLOUR) >= size)
+		return VM_FAULT_FALLBACK;
+	if (length == -ENOMEM)
+		return VM_FAULT_OOM;
+	/* -EBUSY is fine, somebody else faulted on the same PMD */
+	if (length != -EBUSY)
+		BUG_ON(length);
+	return VM_FAULT_NOPAGE;
+}
+
+int xip_pmd_fault(struct vm_area_struct *vma, unsigned long address,
+			pmd_t *pmd, unsigned int flags, get_block_t get_block)
+{
+	int result;
+	struct super_block *sb = file_inode(vma->vm_file)->i_sb;
+
+	sb_start_pagefault(sb);
+	file_update_time(vma->vm_file);
+	result = do_xip_pmd_fault(vma, address, pmd, flags, get_block);
+	sb_end_pagefault(sb);
+
+	return result;
+}
+EXPORT_SYMBOL_GPL(xip_pmd_fault);
+
 /**
  * xip_zero_page_range - zero a range within a page of an XIP file
  * @inode: The file being truncated
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3a4a217..e789218 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2513,6 +2513,8 @@ int xip_zero_page_range(struct inode *, loff_t from, unsigned len, get_block_t);
 ssize_t xip_do_io(int rw, struct kiocb *, struct inode *, const struct iovec *,
 		loff_t, unsigned segs, get_block_t, dio_iodone_t, int flags);
 int xip_fault(struct vm_area_struct *, struct vm_fault *, get_block_t);
+int xip_pmd_fault(struct vm_area_struct *, unsigned long addr, pmd_t *,
+					unsigned int flags, get_block_t);
 #else
 static inline int xip_clear_blocks(struct inode *i, sector_t blk, long sz)
 {
@@ -2531,12 +2533,6 @@ static inline ssize_t xip_do_io(int rw, struct kiocb *iocb, struct inode *inode,
 {
 	return -ENOTTY;
 }
-
-static inline int xip_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
-				get_block_t gb)
-{
-	return 0;
-}
 #endif
 
 /* PAGE_CACHE_ALIGN is defined in pagemap.h */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index e07c57c..d48913d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -212,6 +212,8 @@ struct vm_operations_struct {
 	void (*open)(struct vm_area_struct * area);
 	void (*close)(struct vm_area_struct * area);
 	int (*fault)(struct vm_area_struct *vma, struct vm_fault *vmf);
+	int (*pmd_fault)(struct vm_area_struct *, unsigned long address,
+						pmd_t *, unsigned int flags);
 
 	/* notification that a previously read-only page is about to become
 	 * writable, if an error is returned it will cause a SIGBUS */
@@ -1857,6 +1859,8 @@ int vm_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
 int vm_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
+int vm_insert_pfn_pmd(struct vm_area_struct *, unsigned long addr, pmd_t *,
+			unsigned long pfn);
 int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len);
 
 
diff --git a/mm/memory.c b/mm/memory.c
index ecd63fe..0d332cf 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2249,6 +2249,41 @@ int vm_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 }
 EXPORT_SYMBOL(vm_insert_mixed);
 
+static int insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
+			pmd_t *pmd, unsigned long pfn, pgprot_t prot)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	int retval;
+	pmd_t entry;
+	spinlock_t *ptl;
+
+	ptl = pmd_lock(mm, pmd);
+	retval = -EBUSY;
+	if (!pmd_none(*pmd))
+		goto out_unlock;
+
+	/* Ok, finally just insert the thing.. */
+	entry = pfn_pmd(pfn, prot); /* XXX: pmd_mkspecial? */
+	set_pmd_at(mm, addr, pmd, entry);
+	update_mmu_cache_pmd(vma, addr, pmd);
+
+	retval = 0;
+ out_unlock:
+	spin_unlock(ptl);
+	return retval;
+}
+
+int vm_insert_pfn_pmd(struct vm_area_struct *vma, unsigned long addr,
+					pmd_t *pmd, unsigned long pfn)
+{
+	BUG_ON(!(vma->vm_flags & VM_MIXEDMAP));
+
+	if (addr < vma->vm_start || addr >= vma->vm_end)
+		return -EFAULT;
+	return insert_pfn_pmd(vma, addr, pmd, pfn, vma->vm_page_prot);
+}
+EXPORT_SYMBOL(vm_insert_pfn_pmd);
+
 /*
  * maps a range of physical memory into the requested pages. the old
  * mappings are removed. any references to nonexistent pages results
@@ -3630,6 +3665,16 @@ out:
 	return 0;
 }
 
+static int create_huge_pmd(struct mm_struct *mm, struct vm_area_struct *vma,
+			unsigned long address, pmd_t *pmd, unsigned int flags)
+{
+	if (!vma->vm_ops)
+		return do_huge_pmd_anonymous_page(mm, vma, address, pmd, flags);
+	if (vma->vm_ops->pmd_fault)
+		return vma->vm_ops->pmd_fault(vma, address, pmd, flags);
+	return VM_FAULT_FALLBACK;
+}
+
 /*
  * These routines also need to handle stuff like marking pages dirty
  * and/or accessed for architectures that don't do it in hardware (most
@@ -3722,10 +3767,7 @@ retry:
 	if (!pmd)
 		return VM_FAULT_OOM;
 	if (pmd_none(*pmd) && transparent_hugepage_enabled(vma)) {
-		int ret = VM_FAULT_FALLBACK;
-		if (!vma->vm_ops)
-			ret = do_huge_pmd_anonymous_page(mm, vma, address,
-					pmd, flags);
+		int ret = create_huge_pmd(mm, vma, address, pmd, flags);
 		if (!(ret & VM_FAULT_FALLBACK))
 			return ret;
 	} else {
-- 
1.8.4.rc3

