From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH 4/6] dax: Finish fault completely when loading holes
Date: Thu, 24 Nov 2016 10:46:34 +0100
Message-ID: <1479980796-26161-5-git-send-email-jack@suse.cz>
References: <1479980796-26161-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
 Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1479980796-26161-1-git-send-email-jack-AlSwsSmVLrQ@public.gmane.org>
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

The only case when we do not finish the page fault completely is when we
are loading hole pages into a radix tree. Avoid this special case and
finish the fault in that case as well inside the DAX fault handler. It
will allow us for easier iomap handling.

Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 fs/dax.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index ddf77ef2ca18..38f996976ebf 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -540,15 +540,16 @@ int dax_invalidate_clean_mapping_entry(struct address_space *mapping,
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
@@ -1162,8 +1172,8 @@ int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
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
@@ -1184,8 +1194,7 @@ int dax_iomap_fault(struct vm_area_struct *vma, struct vm_fault *vmf,
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
2.6.6
