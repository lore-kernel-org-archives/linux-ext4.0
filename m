From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/6] dax: Finish fault completely when loading holes
Date: Mon, 12 Dec 2016 17:47:06 +0100
Message-ID: <20161212164708.23244-5-jack@suse.cz>
References: <20161212164708.23244-1-jack@suse.cz>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>,
	<linux-mm@kvack.org>,
	<linux-ext4@vger.kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20161212164708.23244-1-jack@suse.cz>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

The only case when we do not finish the page fault completely is when we
are loading hole pages into a radix tree. Avoid this special case and
finish the fault in that case as well inside the DAX fault handler. It
will allow us for easier iomap handling.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 97858dd5dab6..e186bba0a642 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -540,15 +540,16 @@ int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
  * otherwise it will simply fall out of the page cache under memory
  * pressure without ever having been dirtied.
  */
-static int dax_load_hole(struct address_space *mapping, void *entry,
+static int dax_load_hole(struct address_space *mapping, void **entry,
 			 struct vm_fault *vmf)
 {
 	struct page *page;
+	int ret;
 
 	/* Hole page already exists? Return it...  */
-	if (!radix_tree_exceptional_entry(entry)) {
-		vmf->page = entry;
-		return VM_FAULT_LOCKED;
+	if (!radix_tree_exceptional_entry(*entry)) {
+		page = *entry;
+		goto out;
 	}
 
 	/* This will replace locked radix tree entry with a hole page */
@@ -556,8 +557,17 @@ static int dax_load_hole(struct address_space *mapping, void *entry,
 				   vmf->gfp_mask | __GFP_ZERO);
 	if (!page)
 		return VM_FAULT_OOM;
+ out:
 	vmf->page = page;
-	return VM_FAULT_LOCKED;
+	ret = finish_fault(vmf);
+	vmf->page = NULL;
+	*entry = page;
+	if (!ret) {
+		/* Grab reference for PTE that is now referencing the page */
+		get_page(page);
+		return VM_FAULT_NOPAGE;
+	}
+	return ret;
 }
 
 static int copy_user_dax(struct block_device *bdev, sector_t sector, size_t size,
@@ -1164,8 +1174,8 @@ int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 	case IOMAP_UNWRITTEN:
 	case IOMAP_HOLE:
 		if (!(vmf->flags & FAULT_FLAG_WRITE)) {
-			vmf_ret = dax_load_hole(mapping, entry, vmf);
-			break;
+			vmf_ret = dax_load_hole(mapping, &entry, vmf);
+			goto finish_iomap;
 		}
 		/*FALLTHRU*/
 	default:
@@ -1186,8 +1196,7 @@ int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
 		}
 	}
  unlock_entry:
-	if (vmf_ret != VM_FAULT_LOCKED || error)
-		put_locked_mapping_entry(mapping, vmf->pgoff, entry);
+	put_locked_mapping_entry(mapping, vmf->pgoff, entry);
  out:
 	if (error == -ENOMEM)
 		return VM_FAULT_OOM | major;
-- 
2.10.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
