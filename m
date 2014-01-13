From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5/5] libext2fs: optimize find_first_{zero,set}() for red-black tree based bitmaps
Date: Sun, 12 Jan 2014 21:48:13 -0500
Message-ID: <1389581293-17955-5-git-send-email-tytso@mit.edu>
References: <1389581293-17955-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47842 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbaAMCsV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Jan 2014 21:48:21 -0500
In-Reply-To: <1389581293-17955-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/blkmap64_rb.c | 114 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)

diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
index 0e0a217..5be6a4c 100644
--- a/lib/ext2fs/blkmap64_rb.c
+++ b/lib/ext2fs/blkmap64_rb.c
@@ -809,6 +809,118 @@ static void rb_clear_bmap(ext2fs_generic_bitmap bitmap)
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
+	__u64 b;
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
+	node = parent;
+	ext = node_to_extent(node);
+	while (ext->start > start) {
+		node = ext2fs_rb_prev(node);
+		if (node == NULL) {
+			*out = start + bitmap->start;
+			return 0;
+		}
+		ext = node_to_extent(node);
+	}
+	while (1) {
+		__u64 ext_end = ext->start + ext->count;
+		if (ext_end >= start && ext_end <= end) {
+			*out = b + bitmap->start;
+			return 0;
+		}
+		if (ext_end > end)
+			return ENOENT;
+		node = ext2fs_rb_next(node);
+		if (node == NULL) {
+			*out = start + bitmap->start;
+			return 0;
+		}
+		ext = node_to_extent(node);
+	}
+	return ENOENT;
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
@@ -890,4 +1002,6 @@ struct ext2_bitmap_ops ext2fs_blkmap64_rbtree = {
 	.get_bmap_range = rb_get_bmap_range,
 	.clear_bmap = rb_clear_bmap,
 	.print_stats = rb_print_stats,
+	.find_first_zero = rb_find_first_zero,
+	.find_first_set = rb_find_first_set,
 };
-- 
1.8.5.rc3.362.gdf10213

