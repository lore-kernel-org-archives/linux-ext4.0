From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5/5] resize2fs: grow uninit_bg file systems more efficiently
Date: Thu, 13 Sep 2012 18:49:20 -0400
Message-ID: <1347576560-5820-6-git-send-email-tytso@mit.edu>
References: <1347576560-5820-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50587 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab2IMXGP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Sep 2012 19:06:15 -0400
In-Reply-To: <1347576560-5820-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If the uninit_bg feature is enabled and the kernel supports
lazy_itable_init, skip zeroing the inode table so that the resize
operation can go much more quickly.  Also set the itable_unused fields
so that the first e2fsck after the resize will run faster.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 resize/resize2fs.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 85de144..861acff 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -62,6 +62,8 @@ static errcode_t fix_sb_journal_backup(ext2_filsys fs);
 				 ((blk) < (ext2fs_inode_table_loc((fs), (i)) + \
 					   (fs)->inode_blocks_per_group)))
 
+int lazy_itable_init;
+
 /*
  * This is the top-level routine which does the dirty deed....
  */
@@ -480,6 +482,8 @@ retry:
 
 	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
+	if (access("/sys/fs/ext4/features/lazy_itable_init", F_OK) == 0)
+		lazy_itable_init = 1;
 	adj = old_fs->group_desc_count;
 	max_group = fs->group_desc_count - adj;
 	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
@@ -494,8 +498,14 @@ retry:
 		adjblocks = 0;
 
 		ext2fs_bg_flags_zap(fs, i);
-		if (csum_flag)
-			ext2fs_bg_flags_set(fs, i, EXT2_BG_INODE_UNINIT | EXT2_BG_INODE_ZEROED);
+		if (csum_flag) {
+			ext2fs_bg_flags_set(fs, i, EXT2_BG_INODE_UNINIT);
+			if (!lazy_itable_init)
+				ext2fs_bg_flags_set(fs, i,
+						    EXT2_BG_INODE_ZEROED);
+			ext2fs_bg_itable_unused_set(fs, i,
+					fs->super->s_inodes_per_group);
+		}
 
 		numblocks = ext2fs_group_blocks_count(fs, i);
 		if ((i < fs->group_desc_count - 1) && csum_flag)
@@ -608,7 +618,19 @@ static errcode_t adjust_superblock(ext2_resize_t rfs, blk64_t new_size)
 	}
 
 	/*
-	 * Initialize the new block group descriptors
+	 * If we are using uninit_bg (aka GDT_CSUM) and the kernel
+	 * supports lazy inode initialization, we can skip
+	 * initializing the inode table.
+	 */
+	if (lazy_itable_init &&
+	    EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
+		retval = 0;
+		goto errout;
+	}
+
+	/*
+	 * Initialize the inode table
 	 */
 	retval = ext2fs_get_array(fs->blocksize, fs->inode_blocks_per_group,
 				&rfs->itable_buf);
-- 
1.7.12.rc0.22.gcdd159b

