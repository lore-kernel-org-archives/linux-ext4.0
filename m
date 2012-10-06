From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/3] libext2fs: remove pointless indirection in rbtree bitmaps
Date: Fri,  5 Oct 2012 22:04:10 -0400
Message-ID: <1349489052-18657-1-git-send-email-tytso@mit.edu>
References: <1349408695-11661-2-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54074 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab2JFCEP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Oct 2012 22:04:15 -0400
In-Reply-To: <1349408695-11661-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The code was previously allocating a single 4 or 8 byte pointer for
the rcursor and wcursor fields in the ext2fs_rb_private structure;
this added two extra memory allocations (which could fail), and extra
indirections, for no good reason.  Removing the extra indirection also
makes the code more readable, so it's all upside and no downside.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/blkmap64_rb.c | 46 +++++++++++++++++++---------------------------
 1 file changed, 19 insertions(+), 27 deletions(-)

diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
index c9006f8..900c0d3 100644
--- a/lib/ext2fs/blkmap64_rb.c
+++ b/lib/ext2fs/blkmap64_rb.c
@@ -38,8 +38,8 @@ struct bmap_rb_extent {
 
 struct ext2fs_rb_private {
 	struct rb_root root;
-	struct bmap_rb_extent **wcursor;
-	struct bmap_rb_extent **rcursor;
+	struct bmap_rb_extent *wcursor;
+	struct bmap_rb_extent *rcursor;
 #ifdef BMAP_STATS_OPS
 	__u64 mark_hit;
 	__u64 test_hit;
@@ -148,10 +148,10 @@ inline
 static void rb_free_extent(struct ext2fs_rb_private *bp,
 			   struct bmap_rb_extent *ext)
 {
-	if (*bp->wcursor == ext)
-		*bp->wcursor = NULL;
-	if (*bp->rcursor == ext)
-		*bp->rcursor = NULL;
+	if (bp->wcursor == ext)
+		bp->wcursor = NULL;
+	if (bp->rcursor == ext)
+		bp->rcursor = NULL;
 	ext2fs_free_mem(&ext);
 }
 
@@ -165,14 +165,8 @@ static errcode_t rb_alloc_private_data (ext2fs_generic_bitmap bitmap)
 		return retval;
 
 	bp->root = RB_ROOT;
-	retval = ext2fs_get_mem(sizeof(struct bmap_rb_extent *), &bp->rcursor);
-	if (retval)
-		return retval;
-	retval = ext2fs_get_mem(sizeof(struct bmap_rb_extent *), &bp->wcursor);
-	if (retval)
-		return retval;
-	*bp->rcursor = NULL;
-	*bp->wcursor = NULL;
+	bp->rcursor = NULL;
+	bp->wcursor = NULL;
 
 #ifdef BMAP_STATS_OPS
 	bp->test_hit = 0;
@@ -215,8 +209,6 @@ static void rb_free_bmap(ext2fs_generic_bitmap bitmap)
 	bp = (struct ext2fs_rb_private *) bitmap->private;
 
 	rb_free_tree(&bp->root);
-	ext2fs_free_mem(&bp->rcursor);
-	ext2fs_free_mem(&bp->wcursor);
 	ext2fs_free_mem(&bp);
 	bp = 0;
 }
@@ -235,8 +227,8 @@ static errcode_t rb_copy_bmap(ext2fs_generic_bitmap src,
 
 	src_bp = (struct ext2fs_rb_private *) src->private;
 	dest_bp = (struct ext2fs_rb_private *) dest->private;
-	*src_bp->rcursor = NULL;
-	*dest_bp->rcursor = NULL;
+	src_bp->rcursor = NULL;
+	dest_bp->rcursor = NULL;
 
 	src_node = ext2fs_rb_first(&src_bp->root);
 	while (src_node) {
@@ -299,8 +291,8 @@ static errcode_t rb_resize_bmap(ext2fs_generic_bitmap bmap,
 	}
 
 	bp = (struct ext2fs_rb_private *) bmap->private;
-	*bp->rcursor = NULL;
-	*bp->wcursor = NULL;
+	bp->rcursor = NULL;
+	bp->wcursor = NULL;
 
 	/* truncate tree to new_real_end size */
 	rb_truncate(new_real_end, &bp->root);
@@ -319,7 +311,7 @@ rb_test_bit(struct ext2fs_rb_private *bp, __u64 bit)
 	struct rb_node **n = &bp->root.rb_node;
 	struct bmap_rb_extent *ext;
 
-	rcursor = *bp->rcursor;
+	rcursor = bp->rcursor;
 	if (!rcursor)
 		goto search_tree;
 
@@ -342,7 +334,7 @@ rb_test_bit(struct ext2fs_rb_private *bp, __u64 bit)
 		}
 	}
 
-	rcursor = *bp->wcursor;
+	rcursor = bp->wcursor;
 	if (!rcursor)
 		goto search_tree;
 
@@ -359,7 +351,7 @@ search_tree:
 		else if (bit >= (ext->start + ext->count))
 			n = &(*n)->rb_right;
 		else {
-			*bp->rcursor = ext;
+			bp->rcursor = ext;
 			return 1;
 		}
 	}
@@ -376,7 +368,7 @@ static int rb_insert_extent(__u64 start, __u64 count,
 	struct bmap_rb_extent *ext;
 	int retval = 0;
 
-	ext = *bp->wcursor;
+	ext = bp->wcursor;
 	if (ext) {
 		if (start >= ext->start &&
 		    start <= (ext->start + ext->count)) {
@@ -419,7 +411,7 @@ got_extent:
 	new_node = &new_ext->node;
 	ext2fs_rb_link_node(new_node, parent, n);
 	ext2fs_rb_insert_color(new_node, root);
-	*bp->wcursor = new_ext;
+	bp->wcursor = new_ext;
 
 	node = ext2fs_rb_prev(new_node);
 	if (node) {
@@ -745,8 +737,8 @@ static void rb_clear_bmap(ext2fs_generic_bitmap bitmap)
 	bp = (struct ext2fs_rb_private *) bitmap->private;
 
 	rb_free_tree(&bp->root);
-	*bp->rcursor = NULL;
-	*bp->wcursor = NULL;
+	bp->rcursor = NULL;
+	bp->wcursor = NULL;
 }
 
 #ifdef BMAP_STATS
-- 
1.7.12.rc0.22.gcdd159b

