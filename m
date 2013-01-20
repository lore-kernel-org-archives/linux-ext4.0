From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/3] libext2fs: teach the ext2fs_*_block_bitmap_range2() about clusters
Date: Sun, 20 Jan 2013 00:35:23 -0500
Message-ID: <1358660125-19027-1-git-send-email-tytso@mit.edu>
References: <20130120052744.GC9874@thunk.org>
Cc: jon@severinsson.net, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44387 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab3ATFfc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Jan 2013 00:35:32 -0500
In-Reply-To: <20130120052744.GC9874@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The ext2fs_{mark,unmark,test}_block_bitmap2() functions understand
about clusters, and will take block numbers and convert them to
clusters before checking the bitmap.  The
ext2fs_*_block_bitmap_range2() functions did not do this, which made
them inconsistent.  Fortunately, nothing has depended on this
incorrect behavior, and in fact most of the usage of these functions
have only recently been added, and only for optimizations that were
only enabled for non-bigalloc file systems.

So this is a change in previously exported functions, but (a) it
doesn't change the behavior at all for non-bigalloc file systems, and
(b) the change is more likely to fix bugs for bigalloc file systems.
For example, this change fixes a problem with resize2fs and bigalloc
file systems.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/gen_bitmap64.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index 07d6d52..82a552d 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -624,6 +624,8 @@ void ext2fs_set_generic_bmap_padding(ext2fs_generic_bitmap bmap)
 int ext2fs_test_block_bitmap_range2(ext2fs_block_bitmap bmap,
 				    blk64_t block, unsigned int num)
 {
+	__u64	end = block + num;
+
 	if (!bmap)
 		return EINVAL;
 
@@ -646,12 +648,26 @@ int ext2fs_test_block_bitmap_range2(ext2fs_block_bitmap bmap,
 
 	INC_STAT(bmap, test_ext_count);
 
+	/* convert to clusters if necessary */
+	block >>= bmap->cluster_bits;
+	end += (1 << bmap->cluster_bits) - 1;
+	end >>= bmap->cluster_bits;
+	num = end - block;
+
+	if ((block < bmap->start) || (block+num-1 > bmap->end)) {
+		ext2fs_warn_bitmap(EXT2_ET_BAD_BLOCK_TEST, block,
+				   bmap->description);
+		return;
+	}
+
 	return bmap->bitmap_ops->test_clear_bmap_extent(bmap, block, num);
 }
 
 void ext2fs_mark_block_bitmap_range2(ext2fs_block_bitmap bmap,
 				     blk64_t block, unsigned int num)
 {
+	__u64	end = block + num;
+
 	if (!bmap)
 		return;
 
@@ -670,6 +686,12 @@ void ext2fs_mark_block_bitmap_range2(ext2fs_block_bitmap bmap,
 
 	INC_STAT(bmap, mark_ext_count);
 
+	/* convert to clusters if necessary */
+	block >>= bmap->cluster_bits;
+	end += (1 << bmap->cluster_bits) - 1;
+	end >>= bmap->cluster_bits;
+	num = end - block;
+
 	if ((block < bmap->start) || (block+num-1 > bmap->end)) {
 		ext2fs_warn_bitmap(EXT2_ET_BAD_BLOCK_MARK, block,
 				   bmap->description);
@@ -682,6 +704,8 @@ void ext2fs_mark_block_bitmap_range2(ext2fs_block_bitmap bmap,
 void ext2fs_unmark_block_bitmap_range2(ext2fs_block_bitmap bmap,
 				       blk64_t block, unsigned int num)
 {
+	__u64	end = block + num;
+
 	if (!bmap)
 		return;
 
@@ -700,6 +724,12 @@ void ext2fs_unmark_block_bitmap_range2(ext2fs_block_bitmap bmap,
 
 	INC_STAT(bmap, unmark_ext_count);
 
+	/* convert to clusters if necessary */
+	block >>= bmap->cluster_bits;
+	end += (1 << bmap->cluster_bits) - 1;
+	end >>= bmap->cluster_bits;
+	num = end - block;
+
 	if ((block < bmap->start) || (block+num-1 > bmap->end)) {
 		ext2fs_warn_bitmap(EXT2_ET_BAD_BLOCK_UNMARK, block,
 				   bmap->description);
-- 
1.7.12.rc0.22.gcdd159b

