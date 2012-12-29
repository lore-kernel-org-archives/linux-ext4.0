From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 6/6] resize2fs: create optimized flex_bg block groups
Date: Sat, 29 Dec 2012 03:55:28 -0500
Message-ID: <1356771328-18196-7-git-send-email-tytso@mit.edu>
References: <1356771328-18196-1-git-send-email-tytso@mit.edu>
Cc: George Spelvin <linux@horizon.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40812 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224Ab2L2I5B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 29 Dec 2012 03:57:01 -0500
In-Reply-To: <1356771328-18196-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Now that we are reserving all of the bg-specific metadata before we
try to allocate the metadata for the new block groups, we don't have
to temporarily disable the flex_bg feature flag while we allocate the
new metadata blocks --- this allows the newly created block groups to
have a much more optimized layout, instead of fragmenting the inode
table and block/inode bitmaps in sepraate block groups.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 resize/resize2fs.c | 22 ----------------------
 1 file changed, 22 deletions(-)

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 159846d..092cfbd 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -809,7 +809,6 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 	errcode_t	retval;
 	ext2_filsys 	fs, old_fs;
 	ext2fs_block_bitmap	meta_bmap;
-	__u32		save_incompat_flag;
 	int		flex_bg;
 
 	fs = rfs->new_fs;
@@ -975,29 +974,8 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 		    ext2fs_block_bitmap_loc(fs, i))
 			continue;
 
-		/*
-		 * XXX We have a problem with FLEX_BG and off-line
-		 * resizing where we are growing the size of the
-		 * filesystem.  ext2fs_allocate_group_table() will try
-		 * to reserve the inode table in the desired flex_bg
-		 * location.  However, passing rfs->reserve_blocks
-		 * doesn't work since it only has reserved the blocks
-		 * that will be used in the new block group -- and
-		 * with flex_bg, we can and will allocate the tables
-		 * outside of the block group.  And we can't pass in
-		 * the fs->block_map because it doesn't handle
-		 * overlapping inode table movements right.  So for
-		 * now, we temporarily disable flex_bg to force
-		 * ext2fs_allocate_group_tables() to allocate the bg
-		 * metadata in side the block group, and the restore
-		 * it afterwards.  Ugly, until we can fix this up
-		 * right later.
-		 */
-		save_incompat_flag = fs->super->s_feature_incompat;
-		fs->super->s_feature_incompat &= ~EXT4_FEATURE_INCOMPAT_FLEX_BG;
 		retval = ext2fs_allocate_group_table(fs, i,
 						     rfs->reserve_blocks);
-		fs->super->s_feature_incompat = save_incompat_flag;
 		if (retval)
 			goto errout;
 
-- 
1.7.12.rc0.22.gcdd159b

