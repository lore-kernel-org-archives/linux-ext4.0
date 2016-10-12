From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v6 09/17] dax: remove dax_pmd_fault()
Date: Wed, 12 Oct 2016 16:50:14 -0600
Message-ID: <20161012225022.15507-10-ross.zwisler@linux.intel.com>
References: <20161012225022.15507-1-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
 Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
 Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20161012225022.15507-1-ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

dax_pmd_fault() is the old struct buffer_head + get_block_t based 2 MiB DAX
fault handler.  This fault handler has been disabled for several kernel
releases, and support for PMDs will be reintroduced using the struct iomap
interface instead.

Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 fs/dax.c            | 213 ----------------------------------------------------
 include/linux/dax.h |   6 +-
 2 files changed, 1 insertion(+), 218 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index e103053..3d0b103 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -915,219 +915,6 @@ int dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 }
 EXPORT_SYMBOL_GPL(dax_fault);
 
-#if defined(CONFIG_TRANSPARENT_HUGEPAGE)
-/*
- * The 'colour' (ie low bits) within a PMD of a page offset.  This comes up
- * more often than one might expect in the below function.
- */
-#define PG_PMD_COLOUR	((PMD_SIZE >> PAGE_SHIFT) - 1)
-
-static void __dax_dbg(struct buffer_head *bh, unsigned long address,
-		const char *reason, const char *fn)
-{
-	if (bh) {
-		char bname[BDEVNAME_SIZE];
-		bdevname(bh->b_bdev, bname);
-		pr_debug("%s: %s addr: %lx dev %s state %lx start %lld "
-			"length %zd fallback: %s\n", fn, current->comm,
-			address, bname, bh->b_state, (u64)bh->b_blocknr,
-			bh->b_size, reason);
-	} else {
-		pr_debug("%s: %s addr: %lx fallback: %s\n", fn,
-			current->comm, address, reason);
-	}
-}
-
-#define dax_pmd_dbg(bh, address, reason)	__dax_dbg(bh, address, reason, "dax_pmd")
-
-/**
- * dax_pmd_fault - handle a PMD fault on a DAX file
- * @vma: The virtual memory area where the fault occurred
- * @vmf: The description of the fault
- * @get_block: The filesystem method used to translate file offsets to blocks
- *
- * When a page fault occurs, filesystems may call this helper in their
- * pmd_fault handler for DAX files.
- */
-int dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
-		pmd_t *pmd, unsigned int flags, get_block_t get_block)
-{
-	struct file *file = vma->vm_file;
-	struct address_space *mapping = file->f_mapping;
-	struct inode *inode = mapping->host;
-	struct buffer_head bh;
-	unsigned blkbits = inode->i_blkbits;
-	unsigned long pmd_addr = address & PMD_MASK;
-	bool write = flags & FAULT_FLAG_WRITE;
-	struct block_device *bdev;
-	pgoff_t size, pgoff;
-	sector_t block;
-	int result = 0;
-	bool alloc = false;
-
-	/* dax pmd mappings require pfn_t_devmap() */
-	if (!IS_ENABLED(CONFIG_FS_DAX_PMD))
-		return VM_FAULT_FALLBACK;
-
-	/* Fall back to PTEs if we're going to COW */
-	if (write && !(vma->vm_flags & VM_SHARED)) {
-		split_huge_pmd(vma, pmd, address);
-		dax_pmd_dbg(NULL, address, "cow write");
-		return VM_FAULT_FALLBACK;
-	}
-	/* If the PMD would extend outside the VMA */
-	if (pmd_addr < vma->vm_start) {
-		dax_pmd_dbg(NULL, address, "vma start unaligned");
-		return VM_FAULT_FALLBACK;
-	}
-	if ((pmd_addr + PMD_SIZE) > vma->vm_end) {
-		dax_pmd_dbg(NULL, address, "vma end unaligned");
-		return VM_FAULT_FALLBACK;
-	}
-
-	pgoff = linear_page_index(vma, pmd_addr);
-	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	if (pgoff >= size)
-		return VM_FAULT_SIGBUS;
-	/* If the PMD would cover blocks out of the file */
-	if ((pgoff | PG_PMD_COLOUR) >= size) {
-		dax_pmd_dbg(NULL, address,
-				"offset + huge page size > file size");
-		return VM_FAULT_FALLBACK;
-	}
-
-	memset(&bh, 0, sizeof(bh));
-	bh.b_bdev = inode->i_sb->s_bdev;
-	block = (sector_t)pgoff << (PAGE_SHIFT - blkbits);
-
-	bh.b_size = PMD_SIZE;
-
-	if (get_block(inode, block, &bh, 0) != 0)
-		return VM_FAULT_SIGBUS;
-
-	if (!buffer_mapped(&bh) && write) {
-		if (get_block(inode, block, &bh, 1) != 0)
-			return VM_FAULT_SIGBUS;
-		alloc = true;
-		WARN_ON_ONCE(buffer_unwritten(&bh) || buffer_new(&bh));
-	}
-
-	bdev = bh.b_bdev;
-
-	if (bh.b_size < PMD_SIZE) {
-		dax_pmd_dbg(&bh, address, "allocated block too small");
-		return VM_FAULT_FALLBACK;
-	}
-
-	/*
-	 * If we allocated new storage, make sure no process has any
-	 * zero pages covering this hole
-	 */
-	if (alloc) {
-		loff_t lstart = pgoff << PAGE_SHIFT;
-		loff_t lend = lstart + PMD_SIZE - 1; /* inclusive */
-
-		truncate_pagecache_range(inode, lstart, lend);
-	}
-
-	if (!write && !buffer_mapped(&bh)) {
-		spinlock_t *ptl;
-		pmd_t entry;
-		struct page *zero_page = get_huge_zero_page();
-
-		if (unlikely(!zero_page)) {
-			dax_pmd_dbg(&bh, address, "no zero page");
-			goto fallback;
-		}
-
-		ptl = pmd_lock(vma->vm_mm, pmd);
-		if (!pmd_none(*pmd)) {
-			spin_unlock(ptl);
-			dax_pmd_dbg(&bh, address, "pmd already present");
-			goto fallback;
-		}
-
-		dev_dbg(part_to_dev(bdev->bd_part),
-				"%s: %s addr: %lx pfn: <zero> sect: %llx\n",
-				__func__, current->comm, address,
-				(unsigned long long) to_sector(&bh, inode));
-
-		entry = mk_pmd(zero_page, vma->vm_page_prot);
-		entry = pmd_mkhuge(entry);
-		set_pmd_at(vma->vm_mm, pmd_addr, pmd, entry);
-		result = VM_FAULT_NOPAGE;
-		spin_unlock(ptl);
-	} else {
-		struct blk_dax_ctl dax = {
-			.sector = to_sector(&bh, inode),
-			.size = PMD_SIZE,
-		};
-		long length = dax_map_atomic(bdev, &dax);
-
-		if (length < 0) {
-			dax_pmd_dbg(&bh, address, "dax-error fallback");
-			goto fallback;
-		}
-		if (length < PMD_SIZE) {
-			dax_pmd_dbg(&bh, address, "dax-length too small");
-			dax_unmap_atomic(bdev, &dax);
-			goto fallback;
-		}
-		if (pfn_t_to_pfn(dax.pfn) & PG_PMD_COLOUR) {
-			dax_pmd_dbg(&bh, address, "pfn unaligned");
-			dax_unmap_atomic(bdev, &dax);
-			goto fallback;
-		}
-
-		if (!pfn_t_devmap(dax.pfn)) {
-			dax_unmap_atomic(bdev, &dax);
-			dax_pmd_dbg(&bh, address, "pfn not in memmap");
-			goto fallback;
-		}
-		dax_unmap_atomic(bdev, &dax);
-
-		/*
-		 * For PTE faults we insert a radix tree entry for reads, and
-		 * leave it clean.  Then on the first write we dirty the radix
-		 * tree entry via the dax_pfn_mkwrite() path.  This sequence
-		 * allows the dax_pfn_mkwrite() call to be simpler and avoid a
-		 * call into get_block() to translate the pgoff to a sector in
-		 * order to be able to create a new radix tree entry.
-		 *
-		 * The PMD path doesn't have an equivalent to
-		 * dax_pfn_mkwrite(), though, so for a read followed by a
-		 * write we traverse all the way through dax_pmd_fault()
-		 * twice.  This means we can just skip inserting a radix tree
-		 * entry completely on the initial read and just wait until
-		 * the write to insert a dirty entry.
-		 */
-		if (write) {
-			/*
-			 * We should insert radix-tree entry and dirty it here.
-			 * For now this is broken...
-			 */
-		}
-
-		dev_dbg(part_to_dev(bdev->bd_part),
-				"%s: %s addr: %lx pfn: %lx sect: %llx\n",
-				__func__, current->comm, address,
-				pfn_t_to_pfn(dax.pfn),
-				(unsigned long long) dax.sector);
-		result |= vmf_insert_pfn_pmd(vma, address, pmd,
-				dax.pfn, write);
-	}
-
- out:
-	return result;
-
- fallback:
-	count_vm_event(THP_FAULT_FALLBACK);
-	result = VM_FAULT_FALLBACK;
-	goto out;
-}
-EXPORT_SYMBOL_GPL(dax_pmd_fault);
-#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-
 /**
  * dax_pfn_mkwrite - handle first write to DAX page
  * @vma: The virtual memory area where the fault occurred
diff --git a/include/linux/dax.h b/include/linux/dax.h
index a41a747..0f74866 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -48,16 +48,12 @@ static inline int __dax_zero_page_range(struct block_device *bdev,
 }
 #endif
 
-#if defined(CONFIG_TRANSPARENT_HUGEPAGE)
-int dax_pmd_fault(struct vm_area_struct *, unsigned long addr, pmd_t *,
-				unsigned int flags, get_block_t);
-#else
 static inline int dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
 				pmd_t *pmd, unsigned int flags, get_block_t gb)
 {
 	return VM_FAULT_FALLBACK;
 }
-#endif
+
 int dax_pfn_mkwrite(struct vm_area_struct *, struct vm_fault *);
 #define dax_mkwrite(vma, vmf, gb)	dax_fault(vma, vmf, gb)
 
-- 
2.9.0
