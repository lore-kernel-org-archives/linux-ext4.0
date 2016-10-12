From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v6 04/17] ext2: remove support for DAX PMD faults
Date: Wed, 12 Oct 2016 16:50:09 -0600
Message-ID: <20161012225022.15507-5-ross.zwisler@linux.intel.com>
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

DAX PMD support was added via the following commit:

commit e7b1ea2ad658 ("ext2: huge page fault support")

I believe this path to be untested as ext2 doesn't reliably provide block
allocations that are aligned to 2MiB.  In my testing I've been unable to
get ext2 to actually fault in a PMD.  It always fails with a "pfn
unaligned" message because the sector returned by ext2_get_block() isn't
aligned.

I've tried various settings for the "stride" and "stripe_width" extended
options to mkfs.ext2, without any luck.

Since we can't reliably get PMDs, remove support so that we don't have an
untested code path that we may someday traverse when we happen to get an
aligned block allocation.  This should also make 4k DAX faults in ext2 a
bit faster since they will no longer have to call the PMD fault handler
only to get a response of VM_FAULT_FALLBACK.

Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 fs/ext2/file.c | 29 ++++++-----------------------
 1 file changed, 6 insertions(+), 23 deletions(-)

diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 0ca363d..0f257f8 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -107,27 +107,6 @@ static int ext2_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	return ret;
 }
 
-static int ext2_dax_pmd_fault(struct vm_area_struct *vma, unsigned long addr,
-						pmd_t *pmd, unsigned int flags)
-{
-	struct inode *inode = file_inode(vma->vm_file);
-	struct ext2_inode_info *ei = EXT2_I(inode);
-	int ret;
-
-	if (flags & FAULT_FLAG_WRITE) {
-		sb_start_pagefault(inode->i_sb);
-		file_update_time(vma->vm_file);
-	}
-	down_read(&ei->dax_sem);
-
-	ret = dax_pmd_fault(vma, addr, pmd, flags, ext2_get_block);
-
-	up_read(&ei->dax_sem);
-	if (flags & FAULT_FLAG_WRITE)
-		sb_end_pagefault(inode->i_sb);
-	return ret;
-}
-
 static int ext2_dax_pfn_mkwrite(struct vm_area_struct *vma,
 		struct vm_fault *vmf)
 {
@@ -154,7 +133,11 @@ static int ext2_dax_pfn_mkwrite(struct vm_area_struct *vma,
 
 static const struct vm_operations_struct ext2_dax_vm_ops = {
 	.fault		= ext2_dax_fault,
-	.pmd_fault	= ext2_dax_pmd_fault,
+	/*
+	 * .pmd_fault is not supported for DAX because allocation in ext2
+	 * cannot be reliably aligned to huge page sizes and so pmd faults
+	 * will always fail and fail back to regular faults.
+	 */
 	.page_mkwrite	= ext2_dax_fault,
 	.pfn_mkwrite	= ext2_dax_pfn_mkwrite,
 };
@@ -166,7 +149,7 @@ static int ext2_file_mmap(struct file *file, struct vm_area_struct *vma)
 
 	file_accessed(file);
 	vma->vm_ops = &ext2_dax_vm_ops;
-	vma->vm_flags |= VM_MIXEDMAP | VM_HUGEPAGE;
+	vma->vm_flags |= VM_MIXEDMAP;
 	return 0;
 }
 #else
-- 
2.9.0
