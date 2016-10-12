From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v6 12/17] dax: dax_iomap_fault() needs to call iomap_end()
Date: Wed, 12 Oct 2016 16:50:17 -0600
Message-ID: <20161012225022.15507-13-ross.zwisler@linux.intel.com>
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

Currently iomap_end() doesn't do anything for DAX page faults for both ext2
and XFS.  ext2_iomap_end() just checks for a write underrun, and
xfs_file_iomap_end() checks to see if it needs to finish a delayed
allocation.  However, in the future iomap_end() calls might be needed to
make sure we have balanced allocations, locks, etc.  So, add calls to
iomap_end() with appropriate error handling to dax_iomap_fault().

Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Suggested-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 fs/dax.c | 37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 7737954..6edd89b 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1165,6 +1165,7 @@ int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	struct iomap iomap = { 0 };
 	unsigned flags = 0;
 	int error, major = 0;
+	int locked_status = 0;
 	void *entry;
 
 	/*
@@ -1194,7 +1195,7 @@ int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		goto unlock_entry;
 	if (WARN_ON_ONCE(iomap.offset + iomap.length < pos + PAGE_SIZE)) {
 		error = -EIO;		/* fs corruption? */
-		goto unlock_entry;
+		goto finish_iomap;
 	}
 
 	sector = dax_iomap_sector(&iomap, pos);
@@ -1216,13 +1217,15 @@ int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		}
 
 		if (error)
-			goto unlock_entry;
+			goto finish_iomap;
 		if (!radix_tree_exceptional_entry(entry)) {
 			vmf->page = entry;
-			return VM_FAULT_LOCKED;
+			locked_status = VM_FAULT_LOCKED;
+		} else {
+			vmf->entry = entry;
+			locked_status = VM_FAULT_DAX_LOCKED;
 		}
-		vmf->entry = entry;
-		return VM_FAULT_DAX_LOCKED;
+		goto finish_iomap;
 	}
 
 	switch (iomap.type) {
@@ -1237,8 +1240,10 @@ int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		break;
 	case IOMAP_UNWRITTEN:
 	case IOMAP_HOLE:
-		if (!(vmf->flags & FAULT_FLAG_WRITE))
-			return dax_load_hole(mapping, entry, vmf);
+		if (!(vmf->flags & FAULT_FLAG_WRITE)) {
+			locked_status = dax_load_hole(mapping, entry, vmf);
+			break;
+		}
 		/*FALLTHRU*/
 	default:
 		WARN_ON_ONCE(1);
@@ -1246,14 +1251,30 @@ int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		break;
 	}
 
+ finish_iomap:
+	if (ops->iomap_end) {
+		if (error) {
+			/* keep previous error */
+			ops->iomap_end(inode, pos, PAGE_SIZE, 0, flags,
+					&iomap);
+		} else {
+			error = ops->iomap_end(inode, pos, PAGE_SIZE,
+					PAGE_SIZE, flags, &iomap);
+		}
+	}
  unlock_entry:
-	put_locked_mapping_entry(mapping, vmf->pgoff, entry);
+	if (!locked_status || error)
+		put_locked_mapping_entry(mapping, vmf->pgoff, entry);
  out:
 	if (error == -ENOMEM)
 		return VM_FAULT_OOM | major;
 	/* -EBUSY is fine, somebody else faulted on the same PTE */
 	if (error < 0 && error != -EBUSY)
 		return VM_FAULT_SIGBUS | major;
+	if (locked_status) {
+		WARN_ON_ONCE(error); /* -EBUSY from ops->iomap_end? */
+		return locked_status;
+	}
 	return VM_FAULT_NOPAGE | major;
 }
 EXPORT_SYMBOL_GPL(dax_iomap_fault);
-- 
2.9.0
