From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v6 14/17] dax: move put_(un)locked_mapping_entry() in dax.c
Date: Wed, 12 Oct 2016 16:50:19 -0600
Message-ID: <20161012225022.15507-15-ross.zwisler@linux.intel.com>
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

No functional change.

The static functions put_locked_mapping_entry() and
put_unlocked_mapping_entry() will soon be used in error cases in
grab_mapping_entry(), so move their definitions above this function.

Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 fs/dax.c | 50 +++++++++++++++++++++++++-------------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index c45cc4d..0582c7c 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -382,6 +382,31 @@ static void *get_unlocked_mapping_entry(struct address_space *mapping,
 	}
 }
 
+static void put_locked_mapping_entry(struct address_space *mapping,
+				     pgoff_t index, void *entry)
+{
+	if (!radix_tree_exceptional_entry(entry)) {
+		unlock_page(entry);
+		put_page(entry);
+	} else {
+		dax_unlock_mapping_entry(mapping, index);
+	}
+}
+
+/*
+ * Called when we are done with radix tree entry we looked up via
+ * get_unlocked_mapping_entry() and which we didn't lock in the end.
+ */
+static void put_unlocked_mapping_entry(struct address_space *mapping,
+				       pgoff_t index, void *entry)
+{
+	if (!radix_tree_exceptional_entry(entry))
+		return;
+
+	/* We have to wake up next waiter for the radix tree entry lock */
+	dax_wake_mapping_entry_waiter(mapping, index, entry, false);
+}
+
 /*
  * Find radix tree entry at given index. If it points to a page, return with
  * the page locked. If it points to the exceptional entry, return with the
@@ -486,31 +511,6 @@ void dax_unlock_mapping_entry(struct address_space *mapping, pgoff_t index)
 	dax_wake_mapping_entry_waiter(mapping, index, entry, false);
 }
 
-static void put_locked_mapping_entry(struct address_space *mapping,
-				     pgoff_t index, void *entry)
-{
-	if (!radix_tree_exceptional_entry(entry)) {
-		unlock_page(entry);
-		put_page(entry);
-	} else {
-		dax_unlock_mapping_entry(mapping, index);
-	}
-}
-
-/*
- * Called when we are done with radix tree entry we looked up via
- * get_unlocked_mapping_entry() and which we didn't lock in the end.
- */
-static void put_unlocked_mapping_entry(struct address_space *mapping,
-				       pgoff_t index, void *entry)
-{
-	if (!radix_tree_exceptional_entry(entry))
-		return;
-
-	/* We have to wake up next waiter for the radix tree entry lock */
-	dax_wake_mapping_entry_waiter(mapping, index, entry, false);
-}
-
 /*
  * Delete exceptional DAX entry at @index from @mapping. Wait for radix tree
  * entry to get unlocked before deleting it.
-- 
2.9.0
