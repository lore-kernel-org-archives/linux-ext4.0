From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH, REWORKED 07/11] Make resize2fs uninit block group aware
Date: Mon, 17 Mar 2008 09:28:43 -0400
Message-ID: <1205760527-14858-8-git-send-email-tytso@mit.edu>
References: <1205760527-14858-1-git-send-email-tytso@mit.edu>
 <1205760527-14858-2-git-send-email-tytso@mit.edu>
 <1205760527-14858-3-git-send-email-tytso@mit.edu>
 <1205760527-14858-4-git-send-email-tytso@mit.edu>
 <1205760527-14858-5-git-send-email-tytso@mit.edu>
 <1205760527-14858-6-git-send-email-tytso@mit.edu>
 <1205760527-14858-7-git-send-email-tytso@mit.edu>
Cc: "Jose R. Santos" <jrs@us.ibm.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:60379 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752875AbYCQN3F (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Mar 2008 09:29:05 -0400
In-Reply-To: <1205760527-14858-7-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 resize/main.c      |    7 +++++++
 resize/resize2fs.c |   19 ++++++++++++++-----
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/resize/main.c b/resize/main.c
index f283e41..5811ec8 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -298,6 +298,13 @@ int main (int argc, char ** argv)
 		printf (_("Couldn't find valid filesystem superblock.\n"));
 		exit (1);
 	}
+
+	if (fs->super->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_GDT_CSUM) {
+		com_err(program_name, EXT2_ET_RO_UNSUPP_FEATURE,
+			":- uninit_groups");
+		exit(1);
+	}
+
 	/*
 	 * Check for compatibility with the feature sets.  We need to
 	 * be more stringent than ext2fs_open().
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index da86ece..3d1c003 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -339,7 +339,8 @@ retry:
 		numblocks = fs->super->s_blocks_per_group;
 	i = old_fs->group_desc_count - 1;
 	fs->group_desc[i].bg_free_blocks_count += (numblocks-old_numblocks);
-		
+	ext2fs_group_desc_csum_set(fs, i);
+
 	/*
 	 * If the number of block groups is staying the same, we're
 	 * done and can exit now.  (If the number block groups is
@@ -414,6 +415,7 @@ retry:
 		fs->group_desc[i].bg_free_inodes_count =
 			fs->super->s_inodes_per_group;
 		fs->group_desc[i].bg_used_dirs_count = 0;
+		ext2fs_group_desc_csum_set(fs, i);
 
 		retval = ext2fs_allocate_group_table(fs, i, 0);
 		if (retval) goto errout;
@@ -1231,9 +1233,11 @@ static errcode_t inode_scan_and_fix(ext2_resize_t rfs)
 		if (retval) goto errout;
 
 		group = (new_inode-1) / EXT2_INODES_PER_GROUP(rfs->new_fs->super);
-		if (LINUX_S_ISDIR(inode->i_mode))
+		if (LINUX_S_ISDIR(inode->i_mode)) {
 			rfs->new_fs->group_desc[group].bg_used_dirs_count++;
-		
+			ext2fs_group_desc_csum_set(rfs->new_fs, group);
+		}
+
 #ifdef RESIZE2FS_DEBUG
 		if (rfs->flags & RESIZE_DEBUG_INODEMAP)
 			printf("Inode moved %u->%u\n", ino, new_inode);
@@ -1488,6 +1492,7 @@ static errcode_t move_itables(ext2_resize_t rfs)
 			ext2fs_unmark_block_bitmap(fs->block_map, blk);
 
 		rfs->old_fs->group_desc[i].bg_inode_table = new_blk;
+		ext2fs_group_desc_csum_set(rfs->old_fs, i);
 		ext2fs_mark_super_dirty(rfs->old_fs);
 		ext2fs_flush(rfs->old_fs);
 
@@ -1585,8 +1590,10 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 		count++;
 		if ((count == fs->super->s_blocks_per_group) ||
 		    (blk == fs->super->s_blocks_count-1)) {
-			fs->group_desc[group++].bg_free_blocks_count =
+			fs->group_desc[group].bg_free_blocks_count =
 				group_free;
+			ext2fs_group_desc_csum_set(fs, group);
+			group++;
 			count = 0;
 			group_free = 0;
 		}
@@ -1610,8 +1617,10 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 		count++;
 		if ((count == fs->super->s_inodes_per_group) ||
 		    (ino == fs->super->s_inodes_count)) {
-			fs->group_desc[group++].bg_free_inodes_count =
+			fs->group_desc[group].bg_free_inodes_count =
 				group_free;
+			ext2fs_group_desc_csum_set(fs, group);
+			group++;
 			count = 0;
 			group_free = 0;
 		}
-- 
1.5.4.1.144.gdfee-dirty

