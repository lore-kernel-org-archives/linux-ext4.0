From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: [PATCH] mm, hugetlb: switch hugetlbfs to multi-order radix-tree
 entries
Date: Wed, 10 Aug 2016 00:54:14 +0000
Message-ID: <20160810005413.GC28043@hori1.linux.bs1.fc.nec.co.jp>
References: <1469493335-3622-1-git-send-email-kirill.shutemov@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	"Hugh Dickins" <hughd@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	Dave Hansen <dave.hansen@intel.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	"Ross Zwisler" <ross.zwisler@linux.intel.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1469493335-3622-1-git-send-email-kirill.shutemov@linux.intel.com>
Content-Language: ja-JP
Content-ID: <FB3F07EDCBA7C54B9C2179DAA43FE3A9@gisp.nec.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Kirill,

I wrote a patch to switch hugetlbfs to multi-order radix tree.
Hopefully it's queued to your series.

Thanks,
Naoya Horiguchi
---
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Date: Wed, 10 Aug 2016 09:49:09 +0900
Subject: [PATCH] mm, hugetlb: switch hugetlbfs to multi-order radix-tree
 entries

Currently, hugetlb pages are linked to page cache on the basis of hugepage
offset (derived from vma_hugecache_offset()) for historical reason, which
doesn't match to the generic usage of page cache and requires some routines
to covert page offset <=> hugepage offset in common path. This patch
adjusts code for multi-order radix-tree to avoid the situation.

Main change is on the behavior of page->index for hugetlbfs. Before this
patch, it represented hugepage offset, but with this patch it represents
page offset. So index-related code have to be updated.
Note that hugetlb_fault_mutex_hash() and reservation region handling are
still working with hugepage offset.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 fs/hugetlbfs/inode.c    | 22 ++++++++++------------
 include/linux/pagemap.h | 10 +---------
 mm/filemap.c            | 26 +++++++++++++++-----------
 mm/hugetlb.c            | 19 ++++++-------------
 4 files changed, 32 insertions(+), 45 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 4ea71eba40a5..fc918c0e33e9 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -388,8 +388,8 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
 {
 	struct hstate *h = hstate_inode(inode);
 	struct address_space *mapping = &inode->i_data;
-	const pgoff_t start = lstart >> huge_page_shift(h);
-	const pgoff_t end = lend >> huge_page_shift(h);
+	const pgoff_t start = lstart >> PAGE_SHIFT;
+	const pgoff_t end = lend >> PAGE_SHIFT;
 	struct vm_area_struct pseudo_vma;
 	struct pagevec pvec;
 	pgoff_t next;
@@ -447,8 +447,7 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
 
 				i_mmap_lock_write(mapping);
 				hugetlb_vmdelete_list(&mapping->i_mmap,
-					next * pages_per_huge_page(h),
-					(next + 1) * pages_per_huge_page(h));
+					next, next + 1);
 				i_mmap_unlock_write(mapping);
 			}
 
@@ -467,7 +466,8 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
 			freed++;
 			if (!truncate_op) {
 				if (unlikely(hugetlb_unreserve_pages(inode,
-							next, next + 1, 1)))
+						(next) << huge_page_order(h),
+						(next + 1) << huge_page_order(h), 1)))
 					hugetlb_fix_reserve_counts(inode,
 								rsv_on_error);
 			}
@@ -552,8 +552,6 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 	struct hstate *h = hstate_inode(inode);
 	struct vm_area_struct pseudo_vma;
 	struct mm_struct *mm = current->mm;
-	loff_t hpage_size = huge_page_size(h);
-	unsigned long hpage_shift = huge_page_shift(h);
 	pgoff_t start, index, end;
 	int error;
 	u32 hash;
@@ -569,8 +567,8 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 	 * For this range, start is rounded down and end is rounded up
 	 * as well as being converted to page offsets.
 	 */
-	start = offset >> hpage_shift;
-	end = (offset + len + hpage_size - 1) >> hpage_shift;
+	start = offset >> PAGE_SHIFT;
+	end = (offset + len + huge_page_size(h) - 1) >> PAGE_SHIFT;
 
 	inode_lock(inode);
 
@@ -588,7 +586,7 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 	pseudo_vma.vm_flags = (VM_HUGETLB | VM_MAYSHARE | VM_SHARED);
 	pseudo_vma.vm_file = file;
 
-	for (index = start; index < end; index++) {
+	for (index = start; index < end; index += pages_per_huge_page(h)) {
 		/*
 		 * This is supposed to be the vaddr where the page is being
 		 * faulted in, but we have no vaddr here.
@@ -609,10 +607,10 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 		}
 
 		/* Set numa allocation policy based on index */
-		hugetlb_set_vma_policy(&pseudo_vma, inode, index);
+		hugetlb_set_vma_policy(&pseudo_vma, inode, index >> huge_page_order(h));
 
 		/* addr is the offset within the file (zero based) */
-		addr = index * hpage_size;
+		addr = index << PAGE_SHIFT & ~huge_page_mask(h);
 
 		/* mutex taken here, fault path and hole punch */
 		hash = hugetlb_fault_mutex_hash(h, mm, &pseudo_vma, mapping,
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index d9cf4e0f35dc..e7b79ec9673d 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -380,15 +380,11 @@ static inline struct page *read_mapping_page(struct address_space *mapping,
 
 /*
  * Get the offset in PAGE_SIZE.
- * (TODO: hugepage should have ->index in PAGE_SIZE)
  */
 static inline pgoff_t page_to_pgoff(struct page *page)
 {
 	pgoff_t pgoff;
 
-	if (unlikely(PageHeadHuge(page)))
-		return page->index << compound_order(page);
-
 	if (likely(!PageTransTail(page)))
 		return page->index;
 
@@ -414,15 +410,11 @@ static inline loff_t page_file_offset(struct page *page)
 	return ((loff_t)page_file_index(page)) << PAGE_SHIFT;
 }
 
-extern pgoff_t linear_hugepage_index(struct vm_area_struct *vma,
-				     unsigned long address);
-
 static inline pgoff_t linear_page_index(struct vm_area_struct *vma,
 					unsigned long address)
 {
 	pgoff_t pgoff;
-	if (unlikely(is_vm_hugetlb_page(vma)))
-		return linear_hugepage_index(vma, address);
+
 	pgoff = (address - vma->vm_start) >> PAGE_SHIFT;
 	pgoff += vma->vm_pgoff;
 	return pgoff;
diff --git a/mm/filemap.c b/mm/filemap.c
index 3d46db277e73..f0bcb1329df4 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -114,7 +114,7 @@ static void page_cache_tree_delete(struct address_space *mapping,
 				   struct page *page, void *shadow)
 {
 	struct radix_tree_node *node;
-	int nr = PageHuge(page) ? 1 : hpage_nr_pages(page);
+	int nr = hpage_nr_pages(page);
 
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(PageTail(page), page);
@@ -667,16 +667,20 @@ static int __add_to_page_cache_locked(struct page *page,
 	page->index = offset;
 
 	spin_lock_irq(&mapping->tree_lock);
-	if (PageTransHuge(page)) {
+	if (PageCompound(page)) {
 		/* TODO: shadow handling */
 		error = __radix_tree_insert(&mapping->page_tree, offset,
 				compound_order(page), page);
 
 		if (!error) {
-			count_vm_event(THP_FILE_ALLOC);
-			mapping->nrpages += HPAGE_PMD_NR;
-			*shadowp = NULL;
-			__inc_node_page_state(page, NR_FILE_THPS);
+			if (hugetlb) {
+				mapping->nrpages += 1 << compound_order(page);
+			} else if (PageTransHuge(page)) {
+				count_vm_event(THP_FILE_ALLOC);
+				mapping->nrpages += HPAGE_PMD_NR;
+				*shadowp = NULL;
+				__inc_node_page_state(page, NR_FILE_THPS);
+			}
 		}
 	} else {
 		error = page_cache_tree_insert(mapping, page, shadowp);
@@ -1118,9 +1122,9 @@ struct page *find_get_entry(struct address_space *mapping, pgoff_t offset)
 		}
 
 		/* For multi-order entries, find relevant subpage */
-		if (PageTransHuge(page)) {
+		if (PageCompound(page)) {
 			VM_BUG_ON(offset - page->index < 0);
-			VM_BUG_ON(offset - page->index >= HPAGE_PMD_NR);
+			VM_BUG_ON(offset - page->index >= 1 << compound_order(page));
 			page += offset - page->index;
 		}
 	}
@@ -1475,16 +1479,16 @@ unsigned find_get_pages(struct address_space *mapping, pgoff_t start,
 		}
 
 		/* For multi-order entries, find relevant subpage */
-		if (PageTransHuge(page)) {
+		if (PageCompound(page)) {
 			VM_BUG_ON(iter.index - page->index < 0);
-			VM_BUG_ON(iter.index - page->index >= HPAGE_PMD_NR);
+			VM_BUG_ON(iter.index - page->index >= 1 << compound_order(page));
 			page += iter.index - page->index;
 		}
 
 		pages[ret] = page;
 		if (++ret == nr_pages)
 			break;
-		if (!PageTransCompound(page))
+		if (PageHuge(page) || !PageTransCompound(page))
 			continue;
 		for (refs = 0; ret < nr_pages &&
 				(iter.index + 1) % HPAGE_PMD_NR;
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 51a04e5e9373..e4f1b9e84dda 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -622,13 +622,6 @@ static pgoff_t vma_hugecache_offset(struct hstate *h,
 			(vma->vm_pgoff >> huge_page_order(h));
 }
 
-pgoff_t linear_hugepage_index(struct vm_area_struct *vma,
-				     unsigned long address)
-{
-	return vma_hugecache_offset(hstate_vma(vma), vma, address);
-}
-EXPORT_SYMBOL_GPL(linear_hugepage_index);
-
 /*
  * Return the size of the pages allocated when backing a VMA. In the majority
  * cases this will be same size as used by the page table entries.
@@ -3486,7 +3479,7 @@ static struct page *hugetlbfs_pagecache_page(struct hstate *h,
 	pgoff_t idx;
 
 	mapping = vma->vm_file->f_mapping;
-	idx = vma_hugecache_offset(h, vma, address);
+	idx = linear_page_index(vma, address);
 
 	return find_lock_page(mapping, idx);
 }
@@ -3503,7 +3496,7 @@ static bool hugetlbfs_pagecache_present(struct hstate *h,
 	struct page *page;
 
 	mapping = vma->vm_file->f_mapping;
-	idx = vma_hugecache_offset(h, vma, address);
+	idx = linear_page_index(vma, address);
 
 	page = find_get_page(mapping, idx);
 	if (page)
@@ -3558,7 +3551,7 @@ static int hugetlb_no_page(struct mm_struct *mm, struct vm_area_struct *vma,
 retry:
 	page = find_lock_page(mapping, idx);
 	if (!page) {
-		size = i_size_read(mapping->host) >> huge_page_shift(h);
+		size = i_size_read(mapping->host) >> PAGE_SHIFT;
 		if (idx >= size)
 			goto out;
 		page = alloc_huge_page(vma, address, 0);
@@ -3620,7 +3613,7 @@ static int hugetlb_no_page(struct mm_struct *mm, struct vm_area_struct *vma,
 
 	ptl = huge_pte_lockptr(h, mm, ptep);
 	spin_lock(ptl);
-	size = i_size_read(mapping->host) >> huge_page_shift(h);
+	size = i_size_read(mapping->host) >> PAGE_SHIFT;
 	if (idx >= size)
 		goto backout;
 
@@ -3667,7 +3660,7 @@ u32 hugetlb_fault_mutex_hash(struct hstate *h, struct mm_struct *mm,
 
 	if (vma->vm_flags & VM_SHARED) {
 		key[0] = (unsigned long) mapping;
-		key[1] = idx;
+		key[1] = idx >> huge_page_order(h);
 	} else {
 		key[0] = (unsigned long) mm;
 		key[1] = address >> huge_page_shift(h);
@@ -3723,7 +3716,7 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	}
 
 	mapping = vma->vm_file->f_mapping;
-	idx = vma_hugecache_offset(h, vma, address);
+	idx = linear_page_index(vma, address);
 
 	/*
 	 * Serialize hugepage allocation and instantiation, so that we don't
-- 
2.7.4
