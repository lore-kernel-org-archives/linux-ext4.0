From: Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 4/8] fs/ext4: use rbtree postorder iteration helper instead of opencoding
Date: Fri,  1 Nov 2013 15:38:48 -0700
Message-ID: <1383345566-25087-4-git-send-email-cody@linux.vnet.ibm.com>
References: <1383345566-25087-1-git-send-email-cody@linux.vnet.ibm.com>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	"Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1383345566-25087-1-git-send-email-cody@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Use rbtree_postorder_for_each_entry_safe() to destroy the rbtree instead
of opencoding an alternate postorder iteration that modifies the tree

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 fs/ext4/block_validity.c | 33 ++++-----------------------------
 fs/ext4/dir.c            | 35 +++++------------------------------
 2 files changed, 9 insertions(+), 59 deletions(-)

diff --git a/fs/ext4/block_validity.c b/fs/ext4/block_validity.c
index 3f11656..41eb9dc 100644
--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -180,37 +180,12 @@ int ext4_setup_system_zone(struct super_block *sb)
 /* Called when the filesystem is unmounted */
 void ext4_release_system_zone(struct super_block *sb)
 {
-	struct rb_node	*n = EXT4_SB(sb)->system_blks.rb_node;
-	struct rb_node	*parent;
-	struct ext4_system_zone	*entry;
+	struct ext4_system_zone	*entry, *n;
 
-	while (n) {
-		/* Do the node's children first */
-		if (n->rb_left) {
-			n = n->rb_left;
-			continue;
-		}
-		if (n->rb_right) {
-			n = n->rb_right;
-			continue;
-		}
-		/*
-		 * The node has no children; free it, and then zero
-		 * out parent's link to it.  Finally go to the
-		 * beginning of the loop and try to free the parent
-		 * node.
-		 */
-		parent = rb_parent(n);
-		entry = rb_entry(n, struct ext4_system_zone, node);
+	rbtree_postorder_for_each_entry_safe(entry, n,
+			&EXT4_SB(sb)->system_blks, node)
 		kmem_cache_free(ext4_system_zone_cachep, entry);
-		if (!parent)
-			EXT4_SB(sb)->system_blks = RB_ROOT;
-		else if (parent->rb_left == n)
-			parent->rb_left = NULL;
-		else if (parent->rb_right == n)
-			parent->rb_right = NULL;
-		n = parent;
-	}
+
 	EXT4_SB(sb)->system_blks = RB_ROOT;
 }
 
diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 680bb33..d638c57 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -353,41 +353,16 @@ struct fname {
  */
 static void free_rb_tree_fname(struct rb_root *root)
 {
-	struct rb_node	*n = root->rb_node;
-	struct rb_node	*parent;
-	struct fname	*fname;
-
-	while (n) {
-		/* Do the node's children first */
-		if (n->rb_left) {
-			n = n->rb_left;
-			continue;
-		}
-		if (n->rb_right) {
-			n = n->rb_right;
-			continue;
-		}
-		/*
-		 * The node has no children; free it, and then zero
-		 * out parent's link to it.  Finally go to the
-		 * beginning of the loop and try to free the parent
-		 * node.
-		 */
-		parent = rb_parent(n);
-		fname = rb_entry(n, struct fname, rb_hash);
+	struct fname *fname, *next;
+
+	rbtree_postorder_for_each_entry_safe(fname, next, root, rb_hash)
 		while (fname) {
 			struct fname *old = fname;
 			fname = fname->next;
 			kfree(old);
 		}
-		if (!parent)
-			*root = RB_ROOT;
-		else if (parent->rb_left == n)
-			parent->rb_left = NULL;
-		else if (parent->rb_right == n)
-			parent->rb_right = NULL;
-		n = parent;
-	}
+
+	*root = RB_ROOT;
 }
 
 
-- 
1.8.4.2
