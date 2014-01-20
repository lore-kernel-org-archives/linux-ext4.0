From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 05/12] libext2fs: optimize find_first_{zero,set}() for red-black tree based bitmaps
Date: Mon, 20 Jan 2014 00:54:07 -0500
Message-ID: <1390197254-14583-6-git-send-email-tytso@mit.edu>
References: <1390197254-14583-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49970 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbaATFy3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jan 2014 00:54:29 -0500
In-Reply-To: <1390197254-14583-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/blkmap64_rb.c | 89 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
index 0e0a217..148f856 100644
--- a/lib/ext2fs/blkmap64_rb.c
+++ b/lib/ext2fs/blkmap64_rb.c
@@ -809,6 +809,93 @@ static void rb_clear_bmap(ext2fs_generic_bitmap bitmap)
 	check_tree(&bp->root, __func__);
 }
 
+static errcode_t rb_find_first_zero(ext2fs_generic_bitmap bitmap,
+				   __u64 start, __u64 end, __u64 *out)
+{
+	struct rb_node *parent = NULL, **n;
+	struct rb_node *node, *next;
+	struct ext2fs_rb_private *bp;
+	struct bmap_rb_extent *ext;
+	int retval = 1;
+
+	bp = (struct ext2fs_rb_private *) bitmap->private;
+	n = &bp->root.rb_node;
+	start -= bitmap->start;
+	end -= bitmap->start;
+
+	if (start > end)
+		return EINVAL;
+
+	if (EXT2FS_RB_EMPTY_ROOT(&bp->root))
+		return ENOENT;
+
+	while (*n) {
+		parent = *n;
+		ext = node_to_extent(parent);
+		if (start < ext->start) {
+			n = &(*n)->rb_left;
+		} else if (start >= (ext->start + ext->count)) {
+			n = &(*n)->rb_right;
+		} else if (ext->start + ext->count <= end) {
+			*out = ext->start + ext->count + bitmap->start;
+			return 0;
+		} else
+			return ENOENT;
+	}
+
+	*out = start + bitmap->start;
+	return 0;
+}
+
+static errcode_t rb_find_first_set(ext2fs_generic_bitmap bitmap,
+				   __u64 start, __u64 end, __u64 *out)
+{
+	struct rb_node *parent = NULL, **n;
+	struct rb_node *node, *next;
+	struct ext2fs_rb_private *bp;
+	struct bmap_rb_extent *ext;
+	int retval = 1;
+
+	bp = (struct ext2fs_rb_private *) bitmap->private;
+	n = &bp->root.rb_node;
+	start -= bitmap->start;
+	end -= bitmap->start;
+
+	if (start > end)
+		return EINVAL;
+
+	if (EXT2FS_RB_EMPTY_ROOT(&bp->root))
+		return ENOENT;
+
+	while (*n) {
+		parent = *n;
+		ext = node_to_extent(parent);
+		if (start < ext->start) {
+			n = &(*n)->rb_left;
+		} else if (start >= (ext->start + ext->count)) {
+			n = &(*n)->rb_right;
+		} else {
+			/* The start bit is set */
+			*out = start + bitmap->start;
+			return 0;
+		}
+	}
+
+	node = parent;
+	ext = node_to_extent(node);
+	if (ext->start < start) {
+		node = ext2fs_rb_next(node);
+		if (node == NULL)
+			return ENOENT;
+		ext = node_to_extent(node);
+	}
+	if (ext->start <= end) {
+		*out = ext->start + bitmap->start;
+		return 0;
+	}
+	return ENOENT;
+}
+
 #ifdef BMAP_STATS
 static void rb_print_stats(ext2fs_generic_bitmap bitmap)
 {
@@ -890,4 +977,6 @@ struct ext2_bitmap_ops ext2fs_blkmap64_rbtree = {
 	.get_bmap_range = rb_get_bmap_range,
 	.clear_bmap = rb_clear_bmap,
 	.print_stats = rb_print_stats,
+	.find_first_zero = rb_find_first_zero,
+	.find_first_set = rb_find_first_set,
 };
-- 
1.8.5.rc3.362.gdf10213

