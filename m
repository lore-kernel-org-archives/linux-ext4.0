From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/7] dax: Remove dead zeroing code from fault handlers
Date: Wed, 11 May 2016 11:58:50 +0200
Message-ID: <1462960733-29634-5-git-send-email-jack@suse.cz>
References: <1462960733-29634-1-git-send-email-jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
To: linux-nvdimm@lists.01.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43899 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbcEKJ7W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 May 2016 05:59:22 -0400
In-Reply-To: <1462960733-29634-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Now that all filesystems zero out blocks allocated for a fault handler,
we can just remove the zeroing from the handler itself. Also add checks
that no filesystem returns to us unwritten or new buffer.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
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
