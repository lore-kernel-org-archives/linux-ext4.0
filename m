From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 8/9] ext4: adjust some functions for reclaiming extents from extent status tree
Date: Mon, 18 Feb 2013 00:27:53 +0800
Message-ID: <1361118474-18310-9-git-send-email-wenqing.lz@taobao.com>
References: <1361118474-18310-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Jan kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f53.google.com ([209.85.210.53]:40020 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab3BQQOF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Feb 2013 11:14:05 -0500
Received: by mail-da0-f53.google.com with SMTP id w3so2098605dad.40
        for <linux-ext4@vger.kernel.org>; Sun, 17 Feb 2013 08:14:05 -0800 (PST)
In-Reply-To: <1361118474-18310-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

This commit changes some interfaces in extent status tree because we
need to use inode to count the cached objects in a extent status tree.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jan kara <jack@suse.cz>
---
 fs/ext4/extents_status.c | 50 +++++++++++++++++++++++-------------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index 473a935..3021858 100644
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
@@ -285,7 +284,8 @@ out:
 }
 
 static struct extent_status *
-ext4_es_alloc_extent(ext4_lblk_t lblk, ext4_lblk_t len, ext4_fsblk_t pblk)
+ext4_es_alloc_extent(struct inode *inode, ext4_lblk_t lblk, ext4_lblk_t len,
+		     ext4_fsblk_t pblk)
 {
 	struct extent_status *es;
 	es = kmem_cache_alloc(ext4_es_cachep, GFP_ATOMIC);
@@ -297,7 +297,7 @@ ext4_es_alloc_extent(ext4_lblk_t lblk, ext4_lblk_t len, ext4_fsblk_t pblk)
 	return es;
 }
 
-static void ext4_es_free_extent(struct extent_status *es)
+static void ext4_es_free_extent(struct inode *inode, struct extent_status *es)
 {
 	kmem_cache_free(ext4_es_cachep, es);
 }
@@ -326,8 +326,9 @@ static int ext4_es_can_be_merged(struct extent_status *es1,
 }
 
 static struct extent_status *
-ext4_es_try_to_merge_left(struct ext4_es_tree *tree, struct extent_status *es)
+ext4_es_try_to_merge_left(struct inode *inode, struct extent_status *es)
 {
+	struct ext4_es_tree *tree = &EXT4_I(inode)->i_es_tree;
 	struct extent_status *es1;
 	struct rb_node *node;
 
@@ -339,7 +340,7 @@ ext4_es_try_to_merge_left(struct ext4_es_tree *tree, struct extent_status *es)
 	if (ext4_es_can_be_merged(es1, es)) {
 		es1->es_len += es->es_len;
 		rb_erase(&es->rb_node, &tree->root);
-		ext4_es_free_extent(es);
+		ext4_es_free_extent(inode, es);
 		es = es1;
 	}
 
@@ -347,8 +348,9 @@ ext4_es_try_to_merge_left(struct ext4_es_tree *tree, struct extent_status *es)
 }
 
 static struct extent_status *
-ext4_es_try_to_merge_right(struct ext4_es_tree *tree, struct extent_status *es)
+ext4_es_try_to_merge_right(struct inode *inode, struct extent_status *es)
 {
+	struct ext4_es_tree *tree = &EXT4_I(inode)->i_es_tree;
 	struct extent_status *es1;
 	struct rb_node *node;
 
@@ -360,15 +362,15 @@ ext4_es_try_to_merge_right(struct ext4_es_tree *tree, struct extent_status *es)
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
@@ -389,14 +391,14 @@ static int __es_insert_extent(struct ext4_es_tree *tree,
 				    ext4_es_is_unwritten(es))
 					ext4_es_store_pblock(es,
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
@@ -406,7 +408,7 @@ static int __es_insert_extent(struct ext4_es_tree *tree,
 		}
 	}
 
-	es = ext4_es_alloc_extent(newes->es_lblk, newes->es_len,
+	es = ext4_es_alloc_extent(inode, newes->es_lblk, newes->es_len,
 				  newes->es_pblk);
 	if (!es)
 		return -ENOMEM;
@@ -430,7 +432,6 @@ int ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
 			  ext4_lblk_t len, ext4_fsblk_t pblk,
 			  unsigned long long status)
 {
-	struct ext4_es_tree *tree;
 	struct extent_status newes;
 	ext4_lblk_t end = lblk + len - 1;
 	int err = 0;
@@ -447,11 +448,10 @@ int ext4_es_insert_extent(struct inode *inode, ext4_lblk_t lblk,
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
@@ -521,9 +521,10 @@ out:
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
@@ -561,7 +562,7 @@ static int __es_remove_extent(struct ext4_es_tree *tree, ext4_lblk_t lblk,
 				ext4_es_store_pblock(&newes, block);
 			}
 			ext4_es_store_status(&newes, ext4_es_status(&orig_es));
-			err = __es_insert_extent(tree, &newes);
+			err = __es_insert_extent(inode, &newes);
 			if (err) {
 				es->es_lblk = orig_es.es_lblk;
 				es->es_len = orig_es.es_len;
@@ -590,7 +591,7 @@ static int __es_remove_extent(struct ext4_es_tree *tree, ext4_lblk_t lblk,
 	while (es && ext4_es_end(es) <= end) {
 		node = rb_next(&es->rb_node);
 		rb_erase(&es->rb_node, &tree->root);
-		ext4_es_free_extent(es);
+		ext4_es_free_extent(inode, es);
 		if (!node) {
 			es = NULL;
 			break;
@@ -622,7 +623,6 @@ out:
 int ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 			  ext4_lblk_t len)
 {
-	struct ext4_es_tree *tree;
 	ext4_lblk_t end;
 	int err = 0;
 
@@ -633,10 +633,8 @@ int ext4_es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 	end = lblk + len - 1;
 	BUG_ON(end < lblk);
 
-	tree = &EXT4_I(inode)->i_es_tree;
