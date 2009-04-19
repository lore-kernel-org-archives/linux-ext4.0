From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/3] resize2fs: Fix data corruption bug when growing an ext4 filesystem off-line
Date: Sat, 18 Apr 2009 23:03:46 -0400
Message-ID: <1240110228-22781-2-git-send-email-tytso@mit.edu>
References: <1240110228-22781-1-git-send-email-tytso@mit.edu>
Cc: sandeen@redhat.com, Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51484 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753828AbZDSDDz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 18 Apr 2009 23:03:55 -0400
In-Reply-To: <1240110228-22781-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When allocating a new set of block group metadata as part of growing
the filesystem, the resize2fs code assumes that the bitmap and inode
table blocks are in their own block group; an assumption which is
changed by the flex_bg feature.  This commit works around the problem
by temporarily turning off flex_bg while allocating the new block
group metadata, to avoid potentially overwriting previously allocated
data blocks.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 resize/resize2fs.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 1173da1..0c1549b 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -746,6 +746,7 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 	errcode_t	retval;
 	ext2_filsys 	fs, old_fs;
 	ext2fs_block_bitmap	meta_bmap;
+	__u32		save_incompat_flag;
 
 	fs = rfs->new_fs;
 	old_fs = rfs->old_fs;
@@ -890,9 +891,29 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 
 		/*
 		 * Allocate the missing data structures
+		 *
+		 * XXX We have a problem with FLEX_BG and off-line
+		 * resizing where we are growing the size of the
+		 * filesystem.  ext2fs_allocate_group_table() will try
+		 * to reserve the inode table in the desired flex_bg
+		 * location.  However, passing rfs->reserve_blocks
+		 * doesn't work since it only has reserved the blocks
+		 * that will be used in the new block group -- and
+		 * with flex_bg, we can and will allocate the tables
+		 * outside of the block group.  And we can't pass in
+		 * the fs->block_map because it doesn't handle
+		 * overlapping inode table movements right.  So for
+		 * now, we temporarily disable flex_bg to force
+		 * ext2fs_allocate_group_tables() to allocate the bg
+		 * metadata in side the block group, and the restore
+		 * it afterwards.  Ugly, until we can fix this up
+		 * right later.
 		 */
+		save_incompat_flag = fs->super->s_feature_incompat;
+		fs->super->s_feature_incompat &= ~EXT4_FEATURE_INCOMPAT_FLEX_BG;
 		retval = ext2fs_allocate_group_table(fs, i,
 						     rfs->reserve_blocks);
+		fs->super->s_feature_incompat = save_incompat_flag;
 		if (retval)
 			goto errout;
 
-- 
1.5.6.3

