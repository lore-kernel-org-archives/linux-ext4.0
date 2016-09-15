From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv3 06/41] radix-tree: Handle multiorder entries being deleted by replace_clear_tags
Date: Thu, 15 Sep 2016 14:54:48 +0300
Message-ID: <20160915115523.29737-7-kirill.shutemov@linux.intel.com>
References: <20160915115523.29737-1-kirill.shutemov@linux.intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Hugh Dickins <hughd@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-block@vger.kernel.org,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20160915115523.29737-1-kirill.shutemov@linux.intel.com>
Sender: linux-block-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Matthew Wilcox <willy@infradead.org>

radix_tree_replace_clear_tags() can be called with NULL as the replacement
value; in this case we need to delete sibling entries which point to
the slot.

Signed-off-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 lib/radix-tree.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index e58855435c01..57c15c4d0796 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -1805,17 +1805,23 @@ void *radix_tree_delete(struct radix_tree_root *root, unsigned long index)
 }
 EXPORT_SYMBOL(radix_tree_delete);
 
+/*
+ * If the caller passes NULL for @entry, it must take care to adjust
+ * node->count.  See page_cache_tree_delete() for an example.
+ */
 struct radix_tree_node *radix_tree_replace_clear_tags(
 			struct radix_tree_root *root,
 			unsigned long index, void *entry)
 {
 	struct radix_tree_node *node;
 	void **slot;
+	unsigned int offset;
 
 	__radix_tree_lookup(root, index, &node, &slot);
 
 	if (node) {
-		unsigned int tag, offset = get_slot_offset(node, slot);
+		unsigned int tag;
+		offset = get_slot_offset(node, slot);
 		for (tag = 0; tag < RADIX_TREE_MAX_TAGS; tag++)
 			node_tag_clear(root, node, tag, offset);
 	} else {
@@ -1824,6 +1830,9 @@ struct radix_tree_node *radix_tree_replace_clear_tags(
 	}
 
 	radix_tree_replace_slot(slot, entry);
+	if (!entry && node)
+		delete_sibling_entries(node, node_to_entry(slot), offset);
+
 	return node;
 }
 
-- 
2.9.3

