From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 2/4] resize2fs: fix 32-bit overflow when calculating the number of free blocks
Date: Thu,  3 Jan 2013 09:13:26 -0500
Message-ID: <1357222408-7310-2-git-send-email-tytso@mit.edu>
References: <1357222408-7310-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:41491 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412Ab3ACONa (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Jan 2013 09:13:30 -0500
In-Reply-To: <1357222408-7310-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This caused the free blocks count in the superblock to be incorrect
after resizing a 64-bit file system if the number of free blocks
overflowed a 32-bit value.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 resize/resize2fs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 0407e41..d9501f9 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1795,7 +1795,8 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 	ext2_ino_t	ino;
 	unsigned int	group = 0;
 	unsigned int	count = 0;
-	int		total_free = 0;
+	blk64_t		total_blocks_free = 0;
+	int		total_inodes_free = 0;
 	int		group_free = 0;
 	int		uninit = 0;
 	blk64_t		super_blk, old_desc_blk, new_desc_blk;
@@ -1827,7 +1828,7 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 			  + fs->inode_blocks_per_group))))) ||
 		    (!ext2fs_fast_test_block_bitmap2(fs->block_map, blk))) {
 			group_free++;
-			total_free++;
+			total_blocks_free++;
 		}
 		count++;
 		if ((count == fs->super->s_blocks_per_group) ||
@@ -1851,13 +1852,12 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 					fs->super->s_reserved_gdt_blocks;
 		}
 	}
-	ext2fs_free_blocks_count_set(fs->super, total_free);
+	ext2fs_free_blocks_count_set(fs->super, total_blocks_free);
 
 	/*
 	 * Next, calculate the inode statistics
 	 */
 	group_free = 0;
-	total_free = 0;
 	count = 0;
 	group = 0;
 
@@ -1867,7 +1867,7 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 		if (uninit ||
 		    !ext2fs_fast_test_inode_bitmap2(fs->inode_map, ino)) {
 			group_free++;
-			total_free++;
+			total_inodes_free++;
 		}
 		count++;
 		if ((count == fs->super->s_inodes_per_group) ||
@@ -1882,7 +1882,7 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 			uninit = ext2fs_bg_flags_test(fs, group, EXT2_BG_INODE_UNINIT);
 		}
 	}
-	fs->super->s_free_inodes_count = total_free;
+	fs->super->s_free_inodes_count = total_inodes_free;
 	ext2fs_mark_super_dirty(fs);
 	return 0;
 }
-- 
1.7.12.rc0.22.gcdd159b

