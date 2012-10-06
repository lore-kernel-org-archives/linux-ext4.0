From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/3] libext2fs: further optimize rb_test_bit
Date: Fri,  5 Oct 2012 22:04:11 -0400
Message-ID: <1349489052-18657-2-git-send-email-tytso@mit.edu>
References: <1349408695-11661-2-git-send-email-tytso@mit.edu>
 <1349489052-18657-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54079 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab2JFCET (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Oct 2012 22:04:19 -0400
In-Reply-To: <1349489052-18657-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Profiling shows that rb_test_bit() is now calling ext2fs_rb_next() a
lot, and this function is now the hot spot when running e2freefrag.
If we cache the results of ext2fs_rb_next(), we can eliminate those
extra calls, which further speeds up both e2freefrag and e2fsck by
reducing the amount of CPU time spent in userspace.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/blkmap64_rb.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
index 900c0d3..40d982f 100644
--- a/lib/ext2fs/blkmap64_rb.c
+++ b/lib/ext2fs/blkmap64_rb.c
@@ -40,6 +40,7 @@ struct ext2fs_rb_private {
 	struct rb_root root;
 	struct bmap_rb_extent *wcursor;
 	struct bmap_rb_extent *rcursor;
+	struct bmap_rb_extent *rcursor_next;
 #ifdef BMAP_STATS_OPS
 	__u64 mark_hit;
 	__u64 test_hit;
@@ -152,6 +153,8 @@ static void rb_free_extent(struct ext2fs_rb_private *bp,
 		bp->wcursor = NULL;
 	if (bp->rcursor == ext)
 		bp->rcursor = NULL;
+	if (bp->rcursor_next == ext)
+		bp->rcursor_next = NULL;
 	ext2fs_free_mem(&ext);
 }
 
@@ -166,6 +169,7 @@ static errcode_t rb_alloc_private_data (ext2fs_generic_bitmap bitmap)
 
 	bp->root = RB_ROOT;
 	bp->rcursor = NULL;
+	bp->rcursor_next = NULL;
 	bp->wcursor = NULL;
 
 #ifdef BMAP_STATS_OPS
@@ -306,7 +310,7 @@ static errcode_t rb_resize_bmap(ext2fs_generic_bitmap bmap,
 inline static int
 rb_test_bit(struct ext2fs_rb_private *bp, __u64 bit)
 {
-	struct bmap_rb_extent *rcursor, *next_ext;
+	struct bmap_rb_extent *rcursor, *next_ext = NULL;
 	struct rb_node *parent = NULL, *next;
 	struct rb_node **n = &bp->root.rb_node;
 	struct bmap_rb_extent *ext;
@@ -322,9 +326,15 @@ rb_test_bit(struct ext2fs_rb_private *bp, __u64 bit)
 		return 1;
 	}
 
-	next = ext2fs_rb_next(&rcursor->node);
-	if (next) {
-		next_ext = ext2fs_rb_entry(next, struct bmap_rb_extent, node);
+	next_ext = bp->rcursor_next;
+	if (!next_ext) {
+		next = ext2fs_rb_next(&rcursor->node);
+		if (next)
+			next_ext = ext2fs_rb_entry(next, struct bmap_rb_extent,
+						   node);
+		bp->rcursor_next = next_ext;
+	}
+	if (next_ext) {
 		if ((bit >= rcursor->start + rcursor->count) &&
 		    (bit < next_ext->start)) {
 #ifdef BMAP_STATS_OPS
@@ -333,6 +343,8 @@ rb_test_bit(struct ext2fs_rb_private *bp, __u64 bit)
 			return 0;
 		}
 	}
+	bp->rcursor = NULL;
+	bp->rcursor_next = NULL;
 
 	rcursor = bp->wcursor;
 	if (!rcursor)
@@ -352,6 +364,7 @@ search_tree:
 			n = &(*n)->rb_right;
 		else {
 			bp->rcursor = ext;
+			bp->rcursor_next = 0;
 			return 1;
 		}
 	}
@@ -368,6 +381,7 @@ static int rb_insert_extent(__u64 start, __u64 count,
 	struct bmap_rb_extent *ext;
 	int retval = 0;
 
+	bp->rcursor_next = NULL;
 	ext = bp->wcursor;
 	if (ext) {
 		if (start >= ext->start &&
@@ -738,6 +752,7 @@ static void rb_clear_bmap(ext2fs_generic_bitmap bitmap)
 
 	rb_free_tree(&bp->root);
 	bp->rcursor = NULL;
+	bp->rcursor_next = NULL;
 	bp->wcursor = NULL;
 }
 
-- 
1.7.12.rc0.22.gcdd159b

