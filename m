From: Andrey Sidorov <qrxd43@motorola.com>
Subject: [PATCH 4/5] libext2fs: ffz/ffs for rb_tree bitmap
Date: Tue, 19 Mar 2013 20:06:03 +0400
Message-ID: <1363709164-3210-5-git-send-email-qrxd43@motorola.com>
References: <1363709164-3210-1-git-send-email-qrxd43@motorola.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from exprod5og114.obsmtp.com ([64.18.0.28]:60041 "EHLO
	exprod5og114.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab3CSQG3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Mar 2013 12:06:29 -0400
Received: from il93mgrg01.am.mot-mobility.com ([10.22.94.168])
	by il93mgrg01.am.mot-mobility.com (8.14.3/8.14.3) with ESMTP id r2JFt2sS021490
	for <linux-ext4@vger.kernel.org>; Tue, 19 Mar 2013 11:55:02 -0400 (EDT)
Received: from mail-ee0-f51.google.com (mail-ee0-f51.google.com [74.125.83.51])
	by il93mgrg01.am.mot-mobility.com (8.14.3/8.14.3) with ESMTP id r2JFt1FJ021483
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 19 Mar 2013 11:55:02 -0400 (EDT)
Received: by mail-ee0-f51.google.com with SMTP id d17so327703eek.24
        for <linux-ext4@vger.kernel.org>; Tue, 19 Mar 2013 09:06:26 -0700 (PDT)
In-Reply-To: <1363709164-3210-1-git-send-email-qrxd43@motorola.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

find_first_zero / find_first_set Implementation for
rb_tree bitmap. Use of rcursor / rcursor_next makes
successive ffs/ffz/ffs/... calls to be equivalent of
iterating tree via ext2fs_rb_next.

Signed-off-by: Andrey Sidorov <qrxd43@motorola.com>
---
 lib/ext2fs/blkmap64_rb.c |  164 +++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 156 insertions(+), 8 deletions(-)

diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
index 702187f..76c525e 100644
--- a/lib/ext2fs/blkmap64_rb.c
+++ b/lib/ext2fs/blkmap64_rb.c
@@ -51,6 +51,21 @@ static int rb_insert_extent(__u64 start, __u64 count,
 			    struct ext2fs_rb_private *);
 static void rb_get_new_extent(struct bmap_rb_extent **, __u64, __u64);
 
+static inline struct bmap_rb_extent *
+rb_load_next_cursor(struct ext2fs_rb_private *bp)
+{
+	if (!bp->rcursor_next && bp->rcursor) {
+		struct rb_node *node;
+		node = ext2fs_rb_next(&bp->rcursor->node);
+		if (!node)
+			return NULL;
+		bp->rcursor_next = ext2fs_rb_entry(node,
+						   struct bmap_rb_extent,
+						   node);
+	}
+	return bp->rcursor_next;
+}
+
 /* #define DEBUG_RB */
 
 #ifdef DEBUG_RB
@@ -324,14 +339,7 @@ rb_test_bit(struct ext2fs_rb_private *bp, __u64 bit)
 		return 1;
 	}
 
-	next_ext = bp->rcursor_next;
-	if (!next_ext) {
-		next = ext2fs_rb_next(&rcursor->node);
-		if (next)
-			next_ext = ext2fs_rb_entry(next, struct bmap_rb_extent,
-						   node);
-		bp->rcursor_next = next_ext;
-	}
+	next_ext = rb_load_next_cursor(bp);
 	if (next_ext) {
 		if ((bit >= rcursor->start + rcursor->count) &&
 		    (bit < next_ext->start)) {
@@ -855,6 +863,144 @@ static void rb_print_stats(ext2fs_generic_bitmap bitmap)
 static void rb_print_stats(ext2fs_generic_bitmap bitmap){}
 #endif
 
+/* Find the first zero bit between start and end, inclusive. */
+static errcode_t rb_find_first_zero(ext2fs_generic_bitmap bitmap,
+				    __u64 start, __u64 end, __u64 *out)
+{
+	struct ext2fs_rb_private *bp = bitmap->private;
+	struct rb_node *parent = NULL;
+	struct rb_node **n = &bp->root.rb_node;
+	struct bmap_rb_extent *ext = bp->rcursor;
+
+	start -= bitmap->start;
+	end -= bitmap->start;
+
+	if (!ext)
+		goto search_tree;
+
+	if (start >= ext->start) {
+		if (start <= ext->start + ext->count) {
+			goto match;
+		}
+		ext = rb_load_next_cursor(bp);
+		if (ext && start <= ext->start + ext->count) {
+			if (start >= ext->start) {
+				bp->rcursor = ext;
+				bp->rcursor_next = NULL;
+			}
+			goto match;
+		}
+	}
+
+search_tree:
+	while (*n) {
+		parent = *n;
+		ext = ext2fs_rb_entry(parent, struct bmap_rb_extent, node);
+
+		if (start < ext->start) {
+			n = &(*n)->rb_left;
+		} else if (start >= (ext->start + ext->count)) {
+			n = &(*n)->rb_right;
+		} else {
+			break;
+		}
+	}
+	bp->rcursor = ext;
+	bp->rcursor_next = NULL;
+
+match:
+	if (ext) {
+		if (start >= ext->start && start <= ext->start + ext->count) {
+			if (ext->start + ext->count <= end) {
+				*out = bitmap->start + ext->start + ext->count;
+				return 0;
+			}
+			else {
+				return ENOENT;
+			}
+		}
+		else {
+			*out = bitmap->start + start;
+			return 0;
+		}
+	}
+
+	*out = bitmap->start;
+	return 0;
+}
+
+/* Find the first set bit between start and end, inclusive. */
+static errcode_t rb_find_first_set(ext2fs_generic_bitmap bitmap,
+				   __u64 start, __u64 end, __u64 *out)
+{
+	struct ext2fs_rb_private *bp = bitmap->private;
+	struct rb_node *parent = NULL;
+	struct rb_node **n = &bp->root.rb_node;
+	struct bmap_rb_extent *ext = bp->rcursor;
+
+	start -= bitmap->start;
+	end -= bitmap->start;
+
+	if (!ext)
+		goto search_tree;
+
+	if (start >= ext->start) {
+		if (start < ext->start + ext->count) {
+			*out = bitmap->start + start;
+			return 0;
+		}
+
+		ext = rb_load_next_cursor(bp);
+		if (!ext)
+			return ENOENT;
+		if (start < ext->start + ext->count) {
+			bp->rcursor = ext;
+			bp->rcursor_next = NULL;
+			goto match;
+		}
+	}
+
+search_tree:
+	while (*n) {
+		parent = *n;
+		ext = ext2fs_rb_entry(parent, struct bmap_rb_extent, node);
+
+		if (start < ext->start) {
+			n = &(*n)->rb_left;
+		} else if (start >= (ext->start + ext->count)) {
+			n = &(*n)->rb_right;
+		} else {
+			break;
+		}
+	}
+
+	if (ext && start >= ext->start + ext->count) {
+		struct rb_node *next = ext2fs_rb_next(parent);
+		if (next)
+			ext = ext2fs_rb_entry(next, struct bmap_rb_extent,
+					      node);
+	}
+
+	bp->rcursor = ext;
+	bp->rcursor_next = NULL;
+
+match:
+	if (ext) {
+		if (start < ext->start) {
+			if (ext->start <= end) {
+				*out = bitmap->start + ext->start;
+				return 0;
+			}
+		}
+		else if (start < ext->start + ext->count) {
+			*out = bitmap->start + start;
+			return 0;
+		}
+	}
+
+	return ENOENT;
+}
+
 struct ext2_bitmap_ops ext2fs_blkmap64_rbtree = {
 	.type = EXT2FS_BMAP64_RBTREE,
 	.new_bmap = rb_new_bmap,
@@ -871,4 +1017,6 @@ struct ext2_bitmap_ops ext2fs_blkmap64_rbtree = {
 	.get_bmap_range = rb_get_bmap_range,
 	.clear_bmap = rb_clear_bmap,
 	.print_stats = rb_print_stats,
+	.find_first_zero = rb_find_first_zero,
+	.find_first_set = rb_find_first_set,
 };
-- 
1.7.10.4

