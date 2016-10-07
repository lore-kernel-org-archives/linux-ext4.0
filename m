From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v5 08/17] dax: consistent variable naming for DAX entries
Date: Fri,  7 Oct 2016 15:08:55 -0600
Message-ID: <1475874544-24842-9-git-send-email-ross.zwisler@linux.intel.com>
References: <1475874544-24842-1-git-send-email-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
 Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
 Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>,
 linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1475874544-24842-1-git-send-email-ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

No functional change.

Consistently use the variable name 'entry' instead of 'ret' for DAX radix
tree entries.  This was already happening in most of the code, so update
get_unlocked_mapping_entry(), grab_mapping_entry() and
dax_unlock_mapping_entry().

Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 fs/dax.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 98189ac..152a6e1 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -357,7 +357,7 @@ static inline void *unlock_slot(struct address_space *mapping, void **slot)
 static void *get_unlocked_mapping_entry(struct address_space *mapping,
 					pgoff_t index, void ***slotp)
 {
-	void *ret, **slot;
+	void *entry, **slot;
 	struct wait_exceptional_entry_queue ewait;
 	wait_queue_head_t *wq = dax_entry_waitqueue(mapping, index);
 
@@ -367,13 +367,13 @@ static void *get_unlocked_mapping_entry(struct address_space *mapping,
 	ewait.key.index = index;
 
 	for (;;) {
-		ret = __radix_tree_lookup(&mapping->page_tree, index, NULL,
+		entry = __radix_tree_lookup(&mapping->page_tree, index, NULL,
 					  &slot);
-		if (!ret || !radix_tree_exceptional_entry(ret) ||
+		if (!entry || !radix_tree_exceptional_entry(entry) ||
 		    !slot_locked(mapping, slot)) {
 			if (slotp)
 				*slotp = slot;
-			return ret;
+			return entry;
 		}
 		prepare_to_wait_exclusive(wq, &ewait.wait,
 					  TASK_UNINTERRUPTIBLE);
@@ -396,13 +396,13 @@ static void *get_unlocked_mapping_entry(struct address_space *mapping,
  */
 static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index)
 {
-	void *ret, **slot;
+	void *entry, **slot;
 
 restart:
 	spin_lock_irq(&mapping->tree_lock);
-	ret = get_unlocked_mapping_entry(mapping, index, &slot);
+	entry = get_unlocked_mapping_entry(mapping, index, &slot);
 	/* No entry for given index? Make sure radix tree is big enough. */
-	if (!ret) {
+	if (!entry) {
 		int err;
 
 		spin_unlock_irq(&mapping->tree_lock);
@@ -410,10 +410,10 @@ restart:
 				mapping_gfp_mask(mapping) & ~__GFP_HIGHMEM);
 		if (err)
 			return ERR_PTR(err);
-		ret = (void *)(RADIX_TREE_EXCEPTIONAL_ENTRY |
+		entry = (void *)(RADIX_TREE_EXCEPTIONAL_ENTRY |
 			       RADIX_DAX_ENTRY_LOCK);
 		spin_lock_irq(&mapping->tree_lock);
-		err = radix_tree_insert(&mapping->page_tree, index, ret);
+		err = radix_tree_insert(&mapping->page_tree, index, entry);
 		radix_tree_preload_end();
 		if (err) {
 			spin_unlock_irq(&mapping->tree_lock);
@@ -425,11 +425,11 @@ restart:
 		/* Good, we have inserted empty locked entry into the tree. */
 		mapping->nrexceptional++;
 		spin_unlock_irq(&mapping->tree_lock);
-		return ret;
+		return entry;
 	}
 	/* Normal page in radix tree? */
-	if (!radix_tree_exceptional_entry(ret)) {
-		struct page *page = ret;
+	if (!radix_tree_exceptional_entry(entry)) {
+		struct page *page = entry;
 
 		get_page(page);
 		spin_unlock_irq(&mapping->tree_lock);
@@ -442,9 +442,9 @@ restart:
 		}
 		return page;
 	}
-	ret = lock_slot(mapping, slot);
+	entry = lock_slot(mapping, slot);
 	spin_unlock_irq(&mapping->tree_lock);
-	return ret;
+	return entry;
 }
 
 void dax_wake_mapping_entry_waiter(struct address_space *mapping,
@@ -469,11 +469,11 @@ void dax_wake_mapping_entry_waiter(struct address_space *mapping,
 
 void dax_unlock_mapping_entry(struct address_space *mapping, pgoff_t index)
 {
-	void *ret, **slot;
+	void *entry, **slot;
 
 	spin_lock_irq(&mapping->tree_lock);
-	ret = __radix_tree_lookup(&mapping->page_tree, index, NULL, &slot);
-	if (WARN_ON_ONCE(!ret || !radix_tree_exceptional_entry(ret) ||
+	entry = __radix_tree_lookup(&mapping->page_tree, index, NULL, &slot);
+	if (WARN_ON_ONCE(!entry || !radix_tree_exceptional_entry(entry) ||
 			 !slot_locked(mapping, slot))) {
 		spin_unlock_irq(&mapping->tree_lock);
 		return;
-- 
2.7.4
