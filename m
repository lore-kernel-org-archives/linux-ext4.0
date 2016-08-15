From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 4/7] dax: rename 'ret' to 'entry' in grab_mapping_entry
Date: Mon, 15 Aug 2016 13:09:15 -0600
Message-ID: <20160815190918.20672-5-ross.zwisler@linux.intel.com>
References: <20160815190918.20672-1-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
 linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
 linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
 Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>,
 linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20160815190918.20672-1-ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

Everywhere else that we get entries via get_unlocked_mapping_entry(), we
save it in 'entry' variables.  Just change this to be more descriptive.

Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 fs/dax.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 8030f93..fed6a52 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -394,13 +394,13 @@ static void *get_unlocked_mapping_entry(struct address_space *mapping,
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
@@ -408,10 +408,10 @@ restart:
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
@@ -423,11 +423,11 @@ restart:
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
@@ -440,9 +440,9 @@ restart:
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
-- 
2.9.0
