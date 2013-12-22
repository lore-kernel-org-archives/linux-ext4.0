From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH v4 22/22] xip: Add reporting of major faults
Date: Sun, 22 Dec 2013 16:49:49 -0500
Message-ID: <1bca6add4731223107b3440f045d4c4c37dc21ad.1387748521.git.matthew.r.wilcox@intel.com>
References: <cover.1387748521.git.matthew.r.wilcox@intel.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:27948 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756675Ab3LVVup (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Dec 2013 16:50:45 -0500
In-Reply-To: <cover.1387748521.git.matthew.r.wilcox@intel.com>
In-Reply-To: <cover.1387748521.git.matthew.r.wilcox@intel.com>
References: <cover.1387748521.git.matthew.r.wilcox@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we have to call get_block with the create argument set to 1, then
the filesystem almost certainly had to zero the block. which is an I/O,
which should be reported as a major fault.

Note that major faults on XIP files happen for different reasons than
major faults on non-XIP files.  XIP files behave as if everything except
file holes is already cached.  That's all the more reason to report
major faults when we do have to do I/O; it may be a valuable resource
for sysadmins trying to diagnose performance problems.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 fs/xip.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/xip.c b/fs/xip.c
index d032838..4eb4596 100644
--- a/fs/xip.c
+++ b/fs/xip.c
@@ -19,10 +19,12 @@
 #include <linux/fs.h>
 #include <linux/genhd.h>
 #include <linux/highmem.h>
+#include <linux/memcontrol.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
 #include <linux/sched.h>
 #include <linux/uio.h>
+#include <linux/vmstat.h>
 
 int xip_clear_blocks(struct inode *inode, sector_t block, long size)
 {
@@ -213,6 +215,7 @@ static int do_xip_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	pgoff_t size;
 	unsigned long pfn;
 	int error;
+	int major = 0;
 
 	size = (i_size_read(inode) + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	if (vmf->pgoff >= size)
@@ -226,6 +229,9 @@ static int do_xip_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	/* Don't allocate backing store if we're going to COW a hole */
 	if (!error && !buffer_mapped(&bh) && !vmf->cow_page) {
 		error = get_block(inode, block, &bh, 1);
+		count_vm_event(PGMAJFAULT);
+		mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
+		major = VM_FAULT_MAJOR;
 	}
 
 	if (error)
@@ -255,7 +261,7 @@ static int do_xip_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	/* -EBUSY is fine, somebody else faulted on the same PTE */
 	if (error != -EBUSY)
 		BUG_ON(error);
-	return VM_FAULT_NOPAGE;
+	return VM_FAULT_NOPAGE | major;
 }
 
 int xip_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
@@ -297,6 +303,7 @@ static int do_xip_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 	pgoff_t size, pgoff;
 	sector_t block;
 	unsigned long pfn;
+	int major = 0;
 
 	/* Fall back to PTEs if we're going to COW */
 	if ((flags & FAULT_FLAG_WRITE) && !(vma->vm_flags & VM_SHARED))
@@ -324,6 +331,9 @@ static int do_xip_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 	/* Next, try to allocate the whole thing */
 	bh.b_size = PMD_SIZE;
 	length = get_block(inode, block, &bh, 1);
+	count_vm_event(PGMAJFAULT);
+	mem_cgroup_count_vm_event(vma->vm_mm, PGMAJFAULT);
+	major = VM_FAULT_MAJOR;
 	if (length)
 		return VM_FAULT_SIGBUS;
 	if (bh.b_size == PMD_SIZE)
@@ -356,7 +366,7 @@ static int do_xip_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 	/* -EBUSY is fine, somebody else faulted on the same PMD */
 	if (length != -EBUSY)
 		BUG_ON(length);
-	return VM_FAULT_NOPAGE;
+	return VM_FAULT_NOPAGE | major;
 }
 
 int xip_pmd_fault(struct vm_area_struct *vma, unsigned long address,
-- 
1.8.4.rc3

