From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/2] libext2fs: optimize rb_test_bit
Date: Thu,  4 Oct 2012 23:44:55 -0400
Message-ID: <1349408695-11661-2-git-send-email-tytso@mit.edu>
References: <1349408695-11661-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53927 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369Ab2JEH3P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Oct 2012 03:29:15 -0400
In-Reply-To: <1349408695-11661-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Optimize testing for a bit in an rbtree-based bitmap for the case
where the calling application is scanning through the bitmap
sequentially.  Previously, we did this for a set of bits which were
inside an allocated extent, but we did not optimize the case where
there was a large number of bits after an allocated extents which were
not in use.

             1111111111111110000000000000000000
             ^ optimized    ^not optimized

In my tests of a roughly half-filled file system, the run time of
e2freefrag was halved, and the cpu time spent in userspace was during
e2fsck's pass 5 was reduced by a factor of 30%.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/blkmap64_rb.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/blkmap64_rb.c b/lib/ext2fs/blkmap64_rb.c
index a83f8ac..c9006f8 100644
--- a/lib/ext2fs/blkmap64_rb.c
+++ b/lib/ext2fs/blkmap64_rb.c
@@ -314,8 +314,8 @@ static errcode_t rb_resize_bmap(ext2fs_generic_bitmap bmap,
 inline static int
 rb_test_bit(struct ext2fs_rb_private *bp, __u64 bit)
 {
-	struct bmap_rb_extent *rcursor;
-	struct rb_node *parent = NULL;
+	struct bmap_rb_extent *rcursor, *next_ext;
+	struct rb_node *parent = NULL, *next;
 	struct rb_node **n = &bp->root.rb_node;
 	struct bmap_rb_extent *ext;
 
@@ -330,6 +330,18 @@ rb_test_bit(struct ext2fs_rb_private *bp, __u64 bit)
 		return 1;
 	}
 
+	next = ext2fs_rb_next(&rcursor->node);
+	if (next) {
+		next_ext = ext2fs_rb_entry(next, struct bmap_rb_extent, node);
+		if ((bit >= rcursor->start + rcursor->count) &&
+		    (bit < next_ext->start)) {
+#ifdef BMAP_STATS_OPS
+			bp->test_hit++;
+#endif
+			return 0;
+		}
+	}
+
 	rcursor = *bp->wcursor;
 	if (!rcursor)
 		goto search_tree;
-- 
1.7.12.rc0.22.gcdd159b

