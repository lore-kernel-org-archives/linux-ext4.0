From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 09/10 v3] ext4: adjust some functions for reclaiming extents from extent status tree
Date: Wed, 23 Jan 2013 20:03:59 +0800
Message-ID: <1358942640-2262-10-git-send-email-wenqing.lz@taobao.com>
References: <1358942640-2262-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1358942640-2262-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Zheng Liu <wenqing.lz@taobao.com>

This commit changes some interfaces in extent status tree because we
need to use inode to count the number of cached objects in a extent
status tree.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/extents_status.c | 49 +++++++++++++++++++++++-------------------------
 1 file changed, 23 insertions(+), 26 deletions(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index fd4354e..badfaa2 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -142,9 +142,8 @@
 
 static struct kmem_cache *ext4_es_cachep;
 
-static int __es_insert_extent(struct ext4_es_tree *tree,
-			      struct extent_status *newes);
-static int __es_remove_extent(struct ext4_es_tree *tree, ext4_lblk_t lblk,
+static int __es_insert_extent(struct inode *inode, struct extent_status *newes);
+static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 			      ext4_lblk_t end);
 
 int __init ext4_init_es(void)
@@ -286,7 +285,7 @@ out:
 }
 
 static struct extent_status *
-ext4_es_alloc_extent(ext4_lblk_t lblk, ext4_lblk_t len,
+ext4_es_alloc_extent(struct inode *inode, ext4_lblk_t lblk, ext4_lblk_t len,
 		     ext4_fsblk_t pblk, int status)
 {
 	struct extent_status *es;
@@ -300,7 +299,7 @@ ext4_es_alloc_extent(ext4_lblk_t lblk, ext4_lblk_t len,
 	return es;
 }
 
-static void ext4_es_free_extent(struct extent_status *es)
+static void ext4_es_free_extent(struct inode *inode, struct extent_status *es)
 {
 	kmem_cache_free(ext4_es_cachep, es);
 }
@@ -329,8 +328,9 @@ static int ext4_es_can_be_merged(struct extent_status *es1,
 }
 
 static struct extent_status *
-ext4_es_try_to_merge_left(struct ext4_es_tree *tree, struct extent_status *es)
+ext4_es_try_to_merge_left(struct inode *inode, struct extent_status *es)
 {
+	struct ext4_es_tree *tree = &EXT4_I(inode)->i_es_tree;
 	struct extent_status *es1;
 	struct rb_node *node;
 
@@ -342,7 +342,7 @@ ext4_es_try_to_merge_left(struct ext4_es_tree *tree, struct extent_status *es)
 	if (ext4_es_can_be_merged(es1, es)) {
 		es1->es_len += es->es_len;
 		rb_erase(&es->rb_node, &tree->root);
-		ext4_es_free_extent(es);
+		ext4_es_free_extent(inode, es);
 		es = es1;
 	}
 
@@ -350,8 +350,9 @@ ext4_es_try_to_merge_left(struct ext4_es_tree *tree, struct extent_status *es)
 }
 
 static struct extent_status *
-ext4_es_try_to_merge_right(struct ext4_es_tree *tree, struct extent_status *es)
+ext4_es_try_to_merge_right(struct inode *inode, struct extent_status *es)
 {
+	struct ext4_es_tree *tree = &EXT4_I(inode)->i_es_tree;
 	struct extent_status *es1;
 	struct rb_node *node;
 
@@ -363,15 +364,15 @@ ext4_es_try_to_merge_right(struct ext4_es_tree *tree, struct extent_status *es)
 	if (ext4_es_can_be_merged(es, es1)) {
 		es->es_len += es1->es_len;
 		rb_erase(node, &tree->root);
-		ext4_es_free_extent(es1);
+		ext4_es_free_extent(inode, es1);
 	}
 
 	return es;
 }
 
-static int __es_insert_extent(struct ext4_es_tree *tree,
-			      struct extent_status *newes)
+static int __es_insert_extent(struct inode *inode, struct extent_status *newes)
 {
+	struct ext4_es_tree *tree = &EXT4_I(inode)->i_es_tree;
 	struct rb_node **p = &tree->root.rb_node;
 	struct rb_node *parent = NULL;
 	struct extent_status *es;
@@ -389,14 +390,14 @@ static int __es_insert_extent(struct ext4_es_tree *tree,
 				es->es_len += newes->es_len;
 				es->es_pblk = ext4_es_get_pblock(es,
 							newes->es_pblk);
-				es = ext4_es_try_to_merge_left(tree, es);
+				es = ext4_es_try_to_merge_left(inode, es);
 				goto out;
 			}
 			p = &(*p)->rb_left;
 		} else if (newes->es_lblk > ext4_es_end(es)) {
 			if (ext4_es_can_be_merged(es, newes)) {
 				es->es_len += newes->es_len;
-				es = ext4_es_try_to_merge_right(tree, es);
+				es = ext4_es_try_to_merge_right(inode, es);
 				goto out;
 			}
 			p = &(*p)->rb_right;
@@ -406,7 +407,7 @@ static int __es_insert_extent(struct ext4_es_tree *tree,
 		}
 	}
 
-	es = ext4_es_alloc_extent(newes->es_lblk, newes->es_len,
+	es = ext4_es_alloc_extent(inode, newes->es_lblk, newes->es_len,
 				  newes->es_pblk, newes->es_status);
 	if (!es)
 		return -ENOMEM;
@@ -428,7 +429,6 @@ out:
 int ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 			  ext4_lblk_t len, ext4_fsblk_t pblk, int status)
 {
-	struct ext4_es_tree *tree;
 	struct extent_status newes;
 	ext4_lblk_t end = lblk + len - 1;
 	int err = 0;
@@ -445,11 +445,10 @@ int ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 	trace_ext4_es_insert_extent(inode, &newes);
 
 	write_lock(&EXT4_I(inode)->i_es_lock);
-	tree = &EXT4_I(inode)->i_es_tree;
-	err = __es_remove_extent(tree, lblk, end);
+	err = __es_remove_extent(inode, lblk, end);
 	if (err != 0)
 		goto error;
-	err = __es_insert_extent(tree, &newes);
+	err = __es_insert_extent(inode, &newes);
 
 error:
 	write_unlock(&EXT4_I(inode)->i_es_lock);
@@ -518,9 +517,10 @@ out:
 	return found;
 }
 
-static int __es_remove_extent(struct ext4_es_tree *tree, ext4_lblk_t lblk,
-				 ext4_lblk_t end)
+static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
+			      ext4_lblk_t end)
 {
+	struct ext4_es_tree *tree = &EXT4_I(inode)->i_es_tree;
 	struct rb_node *node;
 	struct extent_status *es;
 	struct extent_status orig_es;
@@ -554,7 +554,7 @@ static int __es_remove_extent(struct ext4_es_tree *tree, ext4_lblk_t lblk,
 			newes.es_pblk = ext4_es_get_pblock(&orig_es,
 				orig_es.es_pblk + orig_es.es_len - len2);
 			newes.es_status = orig_es.es_status;
-			err = __es_insert_extent(tree, &newes);
+			err = __es_insert_extent(inode, &newes);
 			if (err) {
 				es->es_lblk = orig_es.es_lblk;
 				es->es_len = orig_es.es_len;
@@ -580,7 +580,7 @@ static int __es_remove_extent(struct ext4_es_tree *tree, ext4_lblk_t lblk,
 	while (es && ext4_es_end(es) <= end) {
 		node = rb_next(&es->rb_node);
 		rb_erase(&es->rb_node, &tree->root);
-		ext4_es_free_extent(es);
+		ext4_es_free_extent(inode, es);
 		if (!node) {
 			es = NULL;
 			break;
@@ -610,7 +610,6 @@ out:
 int ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 			  ext4_lblk_t len)
 {
-	struct ext4_es_tree *tree;
 	ext4_lblk_t end;
 	int err = 0;
 
@@ -621,10 +620,8 @@ int ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 	end = lblk + len - 1;
 	BUG_ON(end < lblk);
 
-	tree = &EXT4_I(inode)->i_es_tree;
-
 	write_lock(&EXT4_I(inode)->i_es_lock);
-	err = __es_remove_extent(tree, lblk, end);
+	err = __es_remove_extent(inode, lblk, end);
 	write_unlock(&EXT4_I(inode)->i_es_lock);
 	ext4_es_print_tree(inode);
 	return err;
-- 
1.7.12.rc2.18.g61b472e

