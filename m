From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: [PATCH, E2FSPROGS] ext2fs_set_gdt_csum(): Clean up superblock dirty flag handling
Date: Mon, 31 Mar 2008 19:36:25 -0400
Message-ID: <1207006592-13980-4-git-send-email-tytso@mit.edu>
References: <20080325084039.GA10804@webber.adilger.int>
 <1207006592-13980-1-git-send-email-tytso@mit.edu>
 <1207006592-13980-2-git-send-email-tytso@mit.edu>
 <1207006592-13980-3-git-send-email-tytso@mit.edu>
Cc: Andreas Dilger <adilger@dilger.ca>, "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61534 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751469AbYCaXj2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 31 Mar 2008 19:39:28 -0400
In-Reply-To: <1207006592-13980-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Andreas Dilger <adilger@dilger.ca>

Only mark the superblock as dirty if the function actually managed to
change part of the block group descriptor.

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/csum.c |   28 +++++++++++-----------------
 1 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index c35d924..a385d76 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -104,6 +104,8 @@ void ext2fs_set_gdt_csum(ext2_filsys fs)
 
 	for (i = 0; i < fs->group_desc_count; i++, bg++) {
 		int old_csum = bg->bg_checksum;
+		int old_unused = bg->bg_itable_unused;
+		int old_flags = bg->bg_flags;
 
 		/* Even if it wasn't zeroed, by the time this function is
 		 * called by e2fsck we have already scanned and corrected
@@ -112,31 +114,21 @@ void ext2fs_set_gdt_csum(ext2_filsys fs)
 		 * zeroing of the inode table if mke2fs didn't do it, to help
 		 * out if we need to do a full itable scan sometime later. */
 		if (!(bg->bg_flags & (EXT2_BG_INODE_UNINIT |
-				      EXT2_BG_INODE_ZEROED))) {
+				      EXT2_BG_INODE_ZEROED)))
 			fs->group_desc[i].bg_flags |= EXT2_BG_INODE_ZEROED;
-			dirty = 1;
-		}
 
 		if (bg->bg_free_inodes_count == sb->s_inodes_per_group &&
 		    i > 0 && (i < fs->group_desc_count - 1 || csum_flag)) {
-			if (!(bg->bg_flags & EXT2_BG_INODE_UNINIT)) {
+			if (!(bg->bg_flags & EXT2_BG_INODE_UNINIT))
 				bg->bg_flags |= EXT2_BG_INODE_UNINIT;
-				dirty = 1;
-			}
-			if (csum_flag) {
-				int old_unused = bg->bg_itable_unused;
+
+			if (csum_flag)
 				bg->bg_itable_unused = sb->s_inodes_per_group;
-				if (old_unused != bg->bg_itable_unused)
-					dirty = 1;
-			}
 		} else if (csum_flag) {
-			int old_unused = bg->bg_itable_unused;
 			bg->bg_flags &= ~EXT2_BG_INODE_UNINIT;
 			bg->bg_itable_unused = sb->s_inodes_per_group -
 				find_last_inode_ingrp(fs->inode_map,
 						      sb->s_inodes_per_group,i);
-			if (old_unused != bg->bg_itable_unused)
-				dirty = 1;
 		}
 
 		/* skip first and last groups, or groups with GDT backups
@@ -148,12 +140,14 @@ void ext2fs_set_gdt_csum(ext2_filsys fs)
 		blks = ext2fs_super_and_bgd_loc(fs, i, 0, 0, 0, 0);
 		if (bg->bg_free_blocks_count == blks &&
 		    bg->bg_flags & EXT2_BG_INODE_UNINIT &&
-		    !(bg->bg_flags & EXT2_BG_BLOCK_UNINIT)) {
+		    !(bg->bg_flags & EXT2_BG_BLOCK_UNINIT))
 			bg->bg_flags |= EXT2_BG_BLOCK_UNINIT;
-			dirty = 1;
-		}
 checksum:
 		ext2fs_group_desc_csum_set(fs, i);
+		if (old_flags != bg->bg_flags)
+			dirty = 1;
+		if (old_unused != bg->bg_itable_unused)
+			dirty = 1;
 		if (old_csum != bg->bg_checksum)
 			dirty = 1;
 	}
-- 
1.5.4.1.144.gdfee-dirty

