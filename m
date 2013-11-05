From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 1/2] rbtree: fix postorder iteration when the rb_node is not the first element in an entry
Date: Mon,  4 Nov 2013 17:40:01 -0800
Message-ID: <1383615602-1784-1-git-send-email-cody@linux.vnet.ibm.com>
References: <52784ADF.1040104@linux.vnet.ibm.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	LKML <linux-kernel@vger.kernel.org>,
	EXT4 <linux-ext4@vger.kernel.org>,
	Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <52784ADF.1040104@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Provide a new helper called rb_next_postorder_entry() to perform NULL
checks and container_of() coversions and use it in
rbtree_for_each_entry_safe() to fix oopses that occur when rb_node is
not the first element in the entry.

Additionally, remove the missplaced NULL check from rb_next_postorder().

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 include/linux/rbtree.h | 20 +++++++++++++++-----
 lib/rbtree.c           |  2 --
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index aa870a4..630eedb 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -86,6 +86,18 @@ static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
 }
 
 /**
+ * rb_next_postorder_entry - a helper to check for a NULL entry and advance to
+ * the next element.
+ *
+ * @elem: a 'type *' which is contained in an rbtree
+ * @field: the field in 'type' which contains the struct rb_node.
+ */
+#define rb_next_postorder_entry(elem, field) \
+		((elem) ? rb_entry(rb_next_postorder(&(elem)->field), \
+				typeof(*(elem)), field) \
+			: NULL)
+
+/**
  * rbtree_postorder_for_each_entry_safe - iterate over rb_root in post order of
  * given type safe against removal of rb_node entry
  *
@@ -96,11 +108,9 @@ static inline void rb_link_node(struct rb_node * node, struct rb_node * parent,
  */
 #define rbtree_postorder_for_each_entry_safe(pos, n, root, field) \
 	for (pos = rb_entry(rb_first_postorder(root), typeof(*pos), field),\
-		n = rb_entry(rb_next_postorder(&pos->field), \
-			typeof(*pos), field); \
-	     &pos->field; \
+		n = rb_next_postorder_entry(pos, field); \
+	     pos; \
 	     pos = n, \
-		n = rb_entry(rb_next_postorder(&pos->field), \
-			typeof(*pos), field))
+		n = rb_next_postorder_entry(pos, field))
 
 #endif	/* _LINUX_RBTREE_H */
diff --git a/lib/rbtree.c b/lib/rbtree.c
index 65f4eff..08168d0 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -534,8 +534,6 @@ static struct rb_node *rb_left_deepest_node(const struct rb_node *node)
 struct rb_node *rb_next_postorder(const struct rb_node *node)
 {
 	const struct rb_node *parent;
-	if (!node)
-		return NULL;
 	parent = rb_parent(node);
 
 	/* If we're sitting on node, we've already seen our children */
-- 
1.8.4.2
