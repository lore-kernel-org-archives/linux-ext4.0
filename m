From: Jan Kara <jack@suse.cz>
Subject: [PATCH 06/18] dax: Remove dead zeroing code from fault handlers
Date: Mon, 18 Apr 2016 23:35:29 +0200
Message-ID: <1461015341-20153-7-git-send-email-jack@suse.cz>
References: <1461015341-20153-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org,
	linux-mm@kvack.org,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-nvdimm@lists.01.org,
	Matthew Wilcox <willy@linux.intel.com>,
	Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1461015341-20153-1-git-send-email-jack@suse.cz>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

Now that all filesystems zero out blocks allocated for a fault handler,
we can just remove the zeroing from the handler itself. Also add checks
that no filesystem returns to us unwritten or new buffer.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index c5ccf745d279..ccb8bc399d78 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -587,11 +587,6 @@ static int dax_insert_mapping(struct inode *inode, struct buffer_head *bh,
 		error = PTR_ERR(dax.addr);
 		goto out;
 	}
-
-	if (buffer_unwritten(bh) || buffer_new(bh)) {
-		clear_pmem(dax.addr, PAGE_SIZE);
-		wmb_pmem();
-	}
 	dax_unmap_atomic(bdev, &dax);
 
 	error = dax_radix_entry(mapping, vmf->pgoff, dax.sector, false,
@@ -670,7 +665,7 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	if (error)
 		goto unlock_page;
 
-	if (!buffer_mapped(&bh) && !buffer_unwritten(&bh) && !vmf->cow_page) {
+	if (!buffer_mapped(&bh) && !vmf->cow_page) {
 		if (vmf->flags & FAULT_FLAG_WRITE) {
 			error = get_block(inode, block, &bh, 1);
 			count_vm_event(PGMAJFAULT);
@@ -722,7 +717,7 @@ int __dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	}
 
 	/* Filesystem should not return unwritten buffers to us! */
-	WARN_ON_ONCE(buffer_unwritten(&bh));
+	WARN_ON_ONCE(buffer_unwritten(&bh) || buffer_new(&bh));
 	error = dax_insert_mapping(inode, &bh, vma, vmf);
 
  out:
@@ -854,7 +849,7 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 		if (get_block(inode, block, &bh, 1) != 0)
 			return VM_FAULT_SIGBUS;
 		alloc = true;
-		WARN_ON_ONCE(buffer_unwritten(&bh));
+		WARN_ON_ONCE(buffer_unwritten(&bh) || buffer_new(&bh));
 	}
 
 	bdev = bh.b_bdev;
@@ -953,14 +948,6 @@ int __dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 			dax_pmd_dbg(&bh, address, "pfn not in memmap");
 			goto fallback;
 		}
-
-		if (buffer_unwritten(&bh) || buffer_new(&bh)) {
-			clear_pmem(dax.addr, PMD_SIZE);
-			wmb_pmem();
-			count_vm_event(PGMAJFAULT);
-			mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
-			result |= VM_FAULT_MAJOR;
-		}
 		dax_unmap_atomic(bdev, &dax);
 
 		/*
-- 
2.6.6

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
