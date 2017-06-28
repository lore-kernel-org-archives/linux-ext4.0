From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v3 2/5] dax: relocate some dax functions
Date: Wed, 28 Jun 2017 16:01:49 -0600
Message-ID: <20170628220152.28161-3-ross.zwisler@linux.intel.com>
References: <20170628220152.28161-1-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>,
 Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
 "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>,
 Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
 Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170628220152.28161-1-ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

dax_load_hole() will soon need to call dax_insert_mapping_entry(), so it
needs to be moved lower in dax.c so the definition exists.

dax_wake_mapping_entry_waiter() will soon be removed from dax.h and be made
static to dax.c, so we need to move its definition above all its callers.

Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 fs/dax.c | 138 +++++++++++++++++++++++++++++++--------------------------------
 1 file changed, 69 insertions(+), 69 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 9187f3b..e850837 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -122,6 +122,31 @@ static int wake_exceptional_entry_func(wait_queue_t *wait, unsigned int mode,
 }
 
 /*
+ * We do not necessarily hold the mapping->tree_lock when we call this
+ * function so it is possible that 'entry' is no longer a valid item in the
+ * radix tree.  This is okay because all we really need to do is to find the
+ * correct waitqueue where tasks might be waiting for that old 'entry' and
+ * wake them.
+ */
+void dax_wake_mapping_entry_waiter(struct address_space *mapping,
+		pgoff_t index, void *entry, bool wake_all)
+{
+	struct exceptional_entry_key key;
+	wait_queue_head_t *wq;
+
+	wq = dax_entry_waitqueue(mapping, index, entry, &key);
+
+	/*
+	 * Checking for locked entry and prepare_to_wait_exclusive() happens
+	 * under mapping->tree_lock, ditto for entry handling in our callers.
+	 * So at this point all tasks that could have seen our entry locked
+	 * must be in the waitqueue and the following check will see them.
+	 */
+	if (waitqueue_active(wq))
+		__wake_up(wq, TASK_NORMAL, wake_all ? 0 : 1, &key);
+}
+
+/*
  * Check whether the given slot is locked. The function must be called with
  * mapping->tree_lock held
  */
@@ -393,31 +418,6 @@ static void *grab_mapping_entry(struct address_space *mapping, pgoff_t index,
 	return entry;
 }
 
-/*
- * We do not necessarily hold the mapping->tree_lock when we call this
- * function so it is possible that 'entry' is no longer a valid item in the
- * radix tree.  This is okay because all we really need to do is to find the
- * correct waitqueue where tasks might be waiting for that old 'entry' and
- * wake them.
- */
-void dax_wake_mapping_entry_waiter(struct address_space *mapping,
-		pgoff_t index, void *entry, bool wake_all)
-{
-	struct exceptional_entry_key key;
-	wait_queue_head_t *wq;
-
-	wq = dax_entry_waitqueue(mapping, index, entry, &key);
-
-	/*
-	 * Checking for locked entry and prepare_to_wait_exclusive() happens
-	 * under mapping->tree_lock, ditto for entry handling in our callers.
-	 * So at this point all tasks that could have seen our entry locked
-	 * must be in the waitqueue and the following check will see them.
-	 */
-	if (waitqueue_active(wq))
-		__wake_up(wq, TASK_NORMAL, wake_all ? 0 : 1, &key);
-}
-
 static int __dax_invalidate_mapping_entry(struct address_space *mapping,
 					  pgoff_t index, bool trunc)
 {
@@ -469,50 +469,6 @@ int dax_invalidate_mapping_entry_sync(struct address_space *mapping,
 	return __dax_invalidate_mapping_entry(mapping, index, false);
 }
 
-/*
- * The user has performed a load from a hole in the file.  Allocating
- * a new page in the file would cause excessive storage usage for
- * workloads with sparse files.  We allocate a page cache page instead.
- * We'll kick it out of the page cache if it's ever written to,
- * otherwise it will simply fall out of the page cache under memory
- * pressure without ever having been dirtied.
- */
-static int dax_load_hole(struct address_space *mapping, void **entry,
-			 struct vm_fault *vmf)
-{
-	struct inode *inode = mapping->host;
-	struct page *page;
-	int ret;
-
-	/* Hole page already exists? Return it...  */
-	if (!radix_tree_exceptional_entry(*entry)) {
-		page = *entry;
-		goto finish_fault;
-	}
-
-	/* This will replace locked radix tree entry with a hole page */
-	page = find_or_create_page(mapping, vmf->pgoff,
-				   vmf->gfp_mask | __GFP_ZERO);
-	if (!page) {
-		ret = VM_FAULT_OOM;
-		goto out;
-	}
-
-finish_fault:
-	vmf->page = page;
-	ret = finish_fault(vmf);
-	vmf->page = NULL;
-	*entry = page;
-	if (!ret) {
-		/* Grab reference for PTE that is now referencing the page */
-		get_page(page);
-		ret = VM_FAULT_NOPAGE;
-	}
-out:
-	trace_dax_load_hole(inode, vmf, ret);
-	return ret;
-}
-
 static int copy_user_dax(struct block_device *bdev, struct dax_device *dax_dev,
 		sector_t sector, size_t size, struct page *to,
 		unsigned long vaddr)
@@ -937,6 +893,50 @@ int dax_pfn_mkwrite(struct vm_fault *vmf)
 }
 EXPORT_SYMBOL_GPL(dax_pfn_mkwrite);
 
+/*
+ * The user has performed a load from a hole in the file.  Allocating
+ * a new page in the file would cause excessive storage usage for
+ * workloads with sparse files.  We allocate a page cache page instead.
+ * We'll kick it out of the page cache if it's ever written to,
+ * otherwise it will simply fall out of the page cache under memory
+ * pressure without ever having been dirtied.
+ */
+static int dax_load_hole(struct address_space *mapping, void **entry,
+			 struct vm_fault *vmf)
+{
+	struct inode *inode = mapping->host;
+	struct page *page;
+	int ret;
+
+	/* Hole page already exists? Return it...  */
+	if (!radix_tree_exceptional_entry(*entry)) {
+		page = *entry;
+		goto finish_fault;
+	}
+
+	/* This will replace locked radix tree entry with a hole page */
+	page = find_or_create_page(mapping, vmf->pgoff,
+				   vmf->gfp_mask | __GFP_ZERO);
+	if (!page) {
+		ret = VM_FAULT_OOM;
+		goto out;
+	}
+
+finish_fault:
+	vmf->page = page;
+	ret = finish_fault(vmf);
+	vmf->page = NULL;
+	*entry = page;
+	if (!ret) {
+		/* Grab reference for PTE that is now referencing the page */
+		get_page(page);
+		ret = VM_FAULT_NOPAGE;
+	}
+out:
+	trace_dax_load_hole(inode, vmf, ret);
+	return ret;
+}
+
 static bool dax_range_is_aligned(struct block_device *bdev,
 				 unsigned int offset, unsigned int length)
 {
-- 
2.9.4
