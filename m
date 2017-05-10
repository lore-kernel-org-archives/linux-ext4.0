From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH 1/4] dax: prevent invalidation of mapped DAX entries
Date: Wed, 10 May 2017 10:54:16 +0200
Message-ID: <20170510085419.27601-2-jack@suse.cz>
References: <20170510085419.27601-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 "\[4.10+\]" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
 linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170510085419.27601-1-jack-AlSwsSmVLrQ@public.gmane.org>
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

From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

dax_invalidate_mapping_entry() currently removes DAX exceptional entries
only if they are clean and unlocked.  This is done via:

invalidate_mapping_pages()
  invalidate_exceptional_entry()
    dax_invalidate_mapping_entry()

However, for page cache pages removed in invalidate_mapping_pages() there
is an additional criteria which is that the page must not be mapped.  This
is noted in the comments above invalidate_mapping_pages() and is checked in
invalidate_inode_page().

For DAX entries this means that we can can end up in a situation where a
DAX exceptional entry, either a huge zero page or a regular DAX entry,
could end up mapped but without an associated radix tree entry. This is
inconsistent with the rest of the DAX code and with what happens in the
page cache case.

We aren't able to unmap the DAX exceptional entry because according to its
comments invalidate_mapping_pages() isn't allowed to block, and
unmap_mapping_range() takes a write lock on the mapping->i_mmap_rwsem.

Since we essentially never have unmapped DAX entries to evict from the
radix tree, just remove dax_invalidate_mapping_entry().

Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Fixes: c6dcf52c23d2 ("mm: Invalidate DAX radix tree entries only if appropriate")
Reported-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>    [4.10+]
Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 fs/dax.c            | 29 -----------------------------
 include/linux/dax.h |  1 -
 mm/truncate.c       |  9 +++------
 3 files changed, 3 insertions(+), 36 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 66d79067eedf..38deebb8c86e 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -461,35 +461,6 @@ int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index)
 }
 
 /*
- * Invalidate exceptional DAX entry if easily possible. This handles DAX
- * entries for invalidate_inode_pages() so we evict the entry only if we can
- * do so without blocking.
- */
-int dax_invalidate_mapping_entry(struct address_space *mapping, pgoff_t index)
-{
-	int ret = 0;
-	void *entry, **slot;
-	struct radix_tree_root *page_tree = &mapping->page_tree;
-
-	spin_lock_irq(&mapping->tree_lock);
-	entry = __radix_tree_lookup(page_tree, index, NULL, &slot);
-	if (!entry || !radix_tree_exceptional_entry(entry) ||
-	    slot_locked(mapping, slot))
-		goto out;
-	if (radix_tree_tag_get(page_tree, index, PAGECACHE_TAG_DIRTY) ||
-	    radix_tree_tag_get(page_tree, index, PAGECACHE_TAG_TOWRITE))
-		goto out;
-	radix_tree_delete(page_tree, index);
-	mapping->nrexceptional--;
-	ret = 1;
-out:
-	spin_unlock_irq(&mapping->tree_lock);
-	if (ret)
-		dax_wake_mapping_entry_waiter(mapping, index, entry, true);
-	return ret;
-}
-
-/*
  * Invalidate exceptional DAX entry if it is clean.
  */
 int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
diff --git a/include/linux/dax.h b/include/linux/dax.h
index d3158e74a59e..d1236d16ef00 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -63,7 +63,6 @@ ssize_t dax_iomap_rw(struct kiocb *iocb, struct iov_iter *iter,
 int dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
 		    const struct iomap_ops *ops);
 int dax_delete_mapping_entry(struct address_space *mapping, pgoff_t index);
-int dax_invalidate_mapping_entry(struct address_space *mapping, pgoff_t index);
 int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 				      pgoff_t index);
 void dax_wake_mapping_entry_waiter(struct address_space *mapping,
diff --git a/mm/truncate.c b/mm/truncate.c
index 83a059e8cd1d..706cff171a15 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -67,17 +67,14 @@ static void truncate_exceptional_entry(struct address_space *mapping,
 
 /*
  * Invalidate exceptional entry if easily possible. This handles exceptional
- * entries for invalidate_inode_pages() so for DAX it evicts only unlocked and
- * clean entries.
+ * entries for invalidate_inode_pages().
  */
 static int invalidate_exceptional_entry(struct address_space *mapping,
 					pgoff_t index, void *entry)
 {
-	/* Handled by shmem itself */
-	if (shmem_mapping(mapping))
+	/* Handled by shmem itself, or for DAX we do nothing. */
+	if (shmem_mapping(mapping) || dax_mapping(mapping))
 		return 1;
-	if (dax_mapping(mapping))
-		return dax_invalidate_mapping_entry(mapping, index);
 	clear_shadow_entry(mapping, index, entry);
 	return 1;
 }
-- 
2.12.0
