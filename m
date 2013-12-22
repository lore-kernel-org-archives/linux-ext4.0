From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH v4 02/22] Simplify COW of XIP mappings
Date: Sun, 22 Dec 2013 16:49:29 -0500
Message-ID: <4115b3d3a965a5e908418ddeb33c2ceb51aeb456.1387748521.git.matthew.r.wilcox@intel.com>
References: <cover.1387748521.git.matthew.r.wilcox@intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:42561 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755713Ab3LVVuE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Dec 2013 16:50:04 -0500
In-Reply-To: <cover.1387748521.git.matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1387748521.git.matthew.r.wilcox@intel.com>
References: <cover.1387748521.git.matthew.r.wilcox@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently COW of an XIP file is done by first bringing in a read-only
mapping, then retrying the fault and copying the page.  It is much more
efficient to tell the fault handler that a COW is being attempted (by
passing in the pre-allocated page in the vm_fault structure), and allow
the handler to perform the COW operation itself.

The only minor complexity is that we need to lock against truncation until
the PTE has been established.  We extend the scope of the i_mmap_mutex
in this case until the PTE has been established.  This is parallel with
the holding of the page lock for the situation with pagecache files.

This allows us to get rid of the xip_sparse_page and __xip_unmap, which
is a nice reduction in code.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 include/linux/mm.h |   2 +
 mm/filemap_xip.c   | 185 ++++++++++-------------------------------------------
 mm/memory.c        |  19 +++++-
 3 files changed, 52 insertions(+), 154 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1cedd00..e07c57c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -195,6 +195,7 @@ struct vm_fault {
 	pgoff_t pgoff;			/* Logical page offset based on vma */
 	void __user *virtual_address;	/* Faulting virtual address */
 
+	struct page *cow_page;		/* Handler may choose to COW */
 	struct page *page;		/* ->fault handlers should return a
 					 * page here, unless VM_FAULT_NOPAGE
 					 * is set (which is also implied by
@@ -958,6 +959,7 @@ static inline int page_mapped(struct page *page)
 #define VM_FAULT_HWPOISON 0x0010	/* Hit poisoned small page */
 #define VM_FAULT_HWPOISON_LARGE 0x0020  /* Hit poisoned large page. Index encoded in upper bits */
 
+#define VM_FAULT_COWED	0x0080	/* ->fault COWed the page instead */
 #define VM_FAULT_NOPAGE	0x0100	/* ->fault installed the pte, not return page */
 #define VM_FAULT_LOCKED	0x0200	/* ->fault locked the returned page */
 #define VM_FAULT_RETRY	0x0400	/* ->fault blocked, must retry */
diff --git a/mm/filemap_xip.c b/mm/filemap_xip.c
index c8d23e9..cb088a6 100644
--- a/mm/filemap_xip.c
+++ b/mm/filemap_xip.c
@@ -22,24 +22,10 @@
 #include <asm/io.h>
 
 /*
- * We do use our own empty page to avoid interference with other users
- * of ZERO_PAGE(), such as /dev/zero
+ * Only one caller is allowed to try to create mappings at a time.
+ * Should move down into filesystem code
  */
 static DEFINE_MUTEX(xip_sparse_mutex);
-static seqcount_t xip_sparse_seq = SEQCNT_ZERO(xip_sparse_seq);
-static struct page *__xip_sparse_page;
-
-/* called under xip_sparse_mutex */
-static struct page *xip_sparse_page(void)
-{
-	if (!__xip_sparse_page) {
-		struct page *page = alloc_page(GFP_HIGHUSER | __GFP_ZERO);
-
-		if (page)
-			__xip_sparse_page = page;
-	}
-	return __xip_sparse_page;
-}
 
 /*
  * This is a file read routine for execute in place files, and uses
@@ -154,63 +140,12 @@ xip_file_read(struct file *filp, char __user *buf, size_t len, loff_t *ppos)
 }
 EXPORT_SYMBOL_GPL(xip_file_read);
 
-/*
- * __xip_unmap is invoked from xip_unmap and
- * xip_write
- *
- * This function walks all vmas of the address_space and unmaps the
- * __xip_sparse_page when found at pgoff.
- */
-static void
-__xip_unmap (struct address_space * mapping,
-		     unsigned long pgoff)
+static inline void copy_user_highdest(struct page *to, void *vfrom,
+					unsigned long vaddr)
 {
-	struct vm_area_struct *vma;
-	struct mm_struct *mm;
-	unsigned long address;
-	pte_t *pte;
-	pte_t pteval;
-	spinlock_t *ptl;
-	struct page *page;
-	unsigned count;
-	int locked = 0;
-
-	count = read_seqcount_begin(&xip_sparse_seq);
-
-	page = __xip_sparse_page;
-	if (!page)
-		return;
-
-retry:
-	mutex_lock(&mapping->i_mmap_mutex);
-	vma_interval_tree_foreach(vma, &mapping->i_mmap, pgoff, pgoff) {
-		mm = vma->vm_mm;
-		address = vma->vm_start +
-			((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
-		BUG_ON(address < vma->vm_start || address >= vma->vm_end);
-		pte = page_check_address(page, mm, address, &ptl, 1);
-		if (pte) {
-			/* Nuke the page table entry. */
-			flush_cache_page(vma, address, pte_pfn(*pte));
-			pteval = ptep_clear_flush(vma, address, pte);
-			page_remove_rmap(page);
-			dec_mm_counter(mm, MM_FILEPAGES);
-			BUG_ON(pte_dirty(pteval));
-			pte_unmap_unlock(pte, ptl);
-			/* must invalidate_page _before_ freeing the page */
-			mmu_notifier_invalidate_page(mm, address);
-			page_cache_release(page);
-		}
-	}
-	mutex_unlock(&mapping->i_mmap_mutex);
-
-	if (locked) {
-		mutex_unlock(&xip_sparse_mutex);
-	} else if (read_seqcount_retry(&xip_sparse_seq, count)) {
-		mutex_lock(&xip_sparse_mutex);
-		locked = 1;
-		goto retry;
-	}
+	char *vto = kmap_atomic(to);
+	copy_user_page(vto, vfrom, vaddr, to);
+	kunmap_atomic(vto);
 }
 
 /*
@@ -224,14 +159,12 @@ static int xip_file_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	struct file *file = vma->vm_file;
 	struct address_space *mapping = file->f_mapping;
 	struct inode *inode = mapping->host;
+	unsigned long vaddr = (unsigned long)vmf->virtual_address;
 	pgoff_t size;
 	void *xip_mem;
 	unsigned long xip_pfn;
-	struct page *page;
 	int error;
 
-	/* XXX: are VM_FAULT_ codes OK? */
-again:
 	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 	if (vmf->pgoff >= size)
 		return VM_FAULT_SIGBUS;
@@ -240,87 +173,40 @@ again:
 						&xip_mem, &xip_pfn);
 	if (likely(!error))
 		goto found;
-	if (error != -ENODATA)
-		return VM_FAULT_OOM;
-
-	/* sparse block */
-	if ((vma->vm_flags & (VM_WRITE | VM_MAYWRITE)) &&
-	    (vma->vm_flags & (VM_SHARED | VM_MAYSHARE)) &&
-	    (!(mapping->host->i_sb->s_flags & MS_RDONLY))) {
-		int err;
-
-		/* maybe shared writable, allocate new block */
+	/* Don't allocate backing store if we're going to COW a hole */
+	if (error == -ENODATA && !vmf->cow_page) {
 		mutex_lock(&xip_sparse_mutex);
 		error = mapping->a_ops->get_xip_mem(mapping, vmf->pgoff, 1,
 							&xip_mem, &xip_pfn);
 		mutex_unlock(&xip_sparse_mutex);
-		if (error)
-			return VM_FAULT_SIGBUS;
-		/* unmap sparse mappings at pgoff from all other vmas */
-		__xip_unmap(mapping, vmf->pgoff);
+	}
+	if (error != -ENODATA)
+		return VM_FAULT_SIGBUS;
 
 found:
-		/* We must recheck i_size under i_mmap_mutex */
-		mutex_lock(&mapping->i_mmap_mutex);
-		size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >>
-							PAGE_CACHE_SHIFT;
-		if (unlikely(vmf->pgoff >= size)) {
-			mutex_unlock(&mapping->i_mmap_mutex);
-			return VM_FAULT_SIGBUS;
-		}
-		err = vm_insert_mixed(vma, (unsigned long)vmf->virtual_address,
-							xip_pfn);
-		mutex_unlock(&mapping->i_mmap_mutex);
-		if (err == -ENOMEM)
-			return VM_FAULT_OOM;
-		/*
-		 * err == -EBUSY is fine, we've raced against another thread
-		 * that faulted-in the same page
-		 */
-		if (err != -EBUSY)
-			BUG_ON(err);
-		return VM_FAULT_NOPAGE;
-	} else {
-		int err, ret = VM_FAULT_OOM;
-
-		mutex_lock(&xip_sparse_mutex);
-		write_seqcount_begin(&xip_sparse_seq);
-		error = mapping->a_ops->get_xip_mem(mapping, vmf->pgoff, 0,
-							&xip_mem, &xip_pfn);
-		if (unlikely(!error)) {
-			write_seqcount_end(&xip_sparse_seq);
-			mutex_unlock(&xip_sparse_mutex);
-			goto again;
-		}
-		if (error != -ENODATA)
-			goto out;
-
-		/* We must recheck i_size under i_mmap_mutex */
-		mutex_lock(&mapping->i_mmap_mutex);
-		size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >>
-							PAGE_CACHE_SHIFT;
-		if (unlikely(vmf->pgoff >= size)) {
-			ret = VM_FAULT_SIGBUS;
-			goto unlock;
-		}
-		/* not shared and writable, use xip_sparse_page() */
-		page = xip_sparse_page();
-		if (!page)
-			goto unlock;
-		err = vm_insert_page(vma, (unsigned long)vmf->virtual_address,
-							page);
-		if (err == -ENOMEM)
-			goto unlock;
-
-		ret = VM_FAULT_NOPAGE;
-unlock:
+	/* We must recheck i_size under i_mmap_mutex */
+	mutex_lock(&mapping->i_mmap_mutex);
+	size = (i_size_read(inode) + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
+	if (unlikely(vmf->pgoff >= size)) {
 		mutex_unlock(&mapping->i_mmap_mutex);
-out:
-		write_seqcount_end(&xip_sparse_seq);
-		mutex_unlock(&xip_sparse_mutex);
-
-		return ret;
+		return VM_FAULT_SIGBUS;
 	}
+	if (vmf->cow_page) {
+		if (error == -ENODATA)
+			clear_user_highpage(vmf->cow_page, vaddr);
+		else
+			copy_user_highdest(vmf->cow_page, xip_mem, vaddr);
+		return VM_FAULT_COWED;
+	}
+
+	error = vm_insert_mixed(vma, vaddr, xip_pfn);
+	mutex_unlock(&mapping->i_mmap_mutex);
+	if (error == -ENOMEM)
+		return VM_FAULT_OOM;
+	/* -EBUSY is fine, somebody else faulted on the same PTE */
+	if (error != -EBUSY)
+		BUG_ON(error);
+	return VM_FAULT_NOPAGE;
 }
 
 static const struct vm_operations_struct xip_file_vm_ops = {
@@ -374,9 +260,6 @@ __xip_file_write(struct file *filp, const char __user *buf,
 			status = a_ops->get_xip_mem(mapping, index, 1,
 							&xip_mem, &xip_pfn);
 			mutex_unlock(&xip_sparse_mutex);
-			if (!status)
-				/* unmap page at pgoff from all other vmas */
-				__xip_unmap(mapping, index);
 		}
 
 		if (status)
diff --git a/mm/memory.c b/mm/memory.c
index 5d9025f..ecd63fe 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3335,11 +3335,18 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	vmf.pgoff = pgoff;
 	vmf.flags = flags;
 	vmf.page = NULL;
+	vmf.cow_page = cow_page;
 
 	ret = vma->vm_ops->fault(vma, &vmf);
 	if (unlikely(ret & (VM_FAULT_ERROR | VM_FAULT_NOPAGE |
 			    VM_FAULT_RETRY)))
 		goto uncharge_out;
+	if (unlikely(ret & VM_FAULT_COWED)) {
+		page = cow_page;
+		anon = 1;
+		__SetPageUptodate(page);
+		goto cowed;
+	}
 
 	if (unlikely(PageHWPoison(vmf.page))) {
 		if (ret & VM_FAULT_LOCKED)
@@ -3399,6 +3406,7 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	}
 
+ cowed:
 	page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
 
 	/*
@@ -3465,9 +3473,14 @@ static int __do_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 		if (vma->vm_file && !page_mkwrite)
 			file_update_time(vma->vm_file);
 	} else {
-		unlock_page(vmf.page);
-		if (anon)
-			page_cache_release(vmf.page);
+		if ((ret & VM_FAULT_COWED)) {
+			struct address_space *mapping = vma->vm_file->f_mapping;
+			mutex_unlock(&mapping->i_mmap_mutex);
+		} else {
+			unlock_page(vmf.page);
+			if (anon)
+				page_cache_release(vmf.page);
+		}
 	}
 
 	return ret;
-- 
1.8.4.rc3

