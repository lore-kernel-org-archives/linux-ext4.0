From: Hugh Dickins <hughd@google.com>
Subject: [PATCH next/mmotm] ext4: fix cache_es after merge_left
Date: Thu, 27 Sep 2012 13:31:28 -0700 (PDT)
Message-ID: <alpine.LSU.2.00.1209271324060.2184@eggly.anvils>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Zheng Liu <wenqing.lz@taobao.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Allison Henderson <achender@linux.vnet.ibm.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Kernel build with CONFIG_DEBUG_SLAB or CONFIG_SLUB_DEBUG slub_debug=FPZ
gives me kernel BUG at fs/ext4/extents_status.c:142!  That's the
BUG_ON(es->start + es->len < es->start) in extent_status_end() called
from ext4_es_insert_extent().  tree->cache_es has been freed and poisoned.

This comes from when ext4_es_try_to_merge_left() merges es into leftward
es1, but ext4_es_insert_extent()'s out then updates cache_es to the freed
extent_status.  ext4_es_try_to_merge_right() does not pose a problem.

Change ext4_es_try_to_merge_left() to return whichever extent_status
should be recorded in tree->cache_es.  Remove cache_es update from
both of them, leaving that to ext4_es_insert_extent()'s out label.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 fs/ext4/extents_status.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- mmotm/fs/ext4/extents_status.c	2012-09-26 10:15:29.340071552 -0700
+++ linux/fs/ext4/extents_status.c	2012-09-27 11:52:59.284937056 -0700
@@ -244,24 +244,24 @@ static void ext4_es_free_extent(struct e
 	kmem_cache_free(ext4_es_cachep, es);
 }
 
-static void ext4_es_try_to_merge_left(struct ext4_es_tree *tree,
-				      struct extent_status *es)
+static struct extent_status *
+ext4_es_try_to_merge_left(struct ext4_es_tree *tree, struct extent_status *es)
 {
 	struct extent_status *es1;
 	struct rb_node *node;
 
 	node = rb_prev(&es->rb_node);
 	if (!node)
-		return;
+		return es;
 
 	es1 = rb_entry(node, struct extent_status, rb_node);
 	if (es->start == extent_status_end(es1) + 1) {
 		es1->len += es->len;
 		rb_erase(&es->rb_node, &tree->root);
-		if (es == tree->cache_es)
-			tree->cache_es = es1;
 		ext4_es_free_extent(es);
+		es = es1;	/* Caller will update tree->cache_es to this */
 	}
+	return es;
 }
 
 static void ext4_es_try_to_merge_right(struct ext4_es_tree *tree,
@@ -278,9 +278,8 @@ static void ext4_es_try_to_merge_right(s
 	if (es1->start == extent_status_end(es) + 1) {
 		es->len += es1->len;
 		rb_erase(node, &tree->root);
-		if (es1 == tree->cache_es)
-			tree->cache_es = es;
 		ext4_es_free_extent(es1);
+		/* Caller will update tree->cache_es to es */
 	}
 }
 
@@ -318,7 +317,7 @@ int ext4_es_insert_extent(struct inode *
 		es_debug("cached by [%u/%u)\n", es->start, es->len);
 		es->start = offset;
 		es->len += len;
-		ext4_es_try_to_merge_left(tree, es);
+		es = ext4_es_try_to_merge_left(tree, es);
 		goto out;
 	} else if (es && in_range(offset, es->start, es->len)) {
 		es_debug("cached by [%u/%u)\n", es->start, es->len);
