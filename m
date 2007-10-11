From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 07/13][e2fsprogs] Make resize2fs uninit block group aware.
Date: Thu, 11 Oct 2007 14:16:41 -0500
Message-ID: <20071011191641.4599.51500.stgit@gara>
References: <20071011191559.4599.69332.stgit@gara>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:42425 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbXJKTQa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Oct 2007 15:16:30 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9BJGTOR011421
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 15:16:29 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9BJGSSW490636
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 13:16:28 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9BJGSh6007265
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 13:16:28 -0600
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l9BJGSck007243
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 13:16:28 -0600
Received: from [127.0.1.1] (wecm-9-67-39-149.wecm.ibm.com [9.67.39.149])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l9BJGRH8040730
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 14:16:27 -0500
In-Reply-To: <20071011191559.4599.69332.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Jose R. Santos <jrs@us.ibm.com>

Make resize2fs uninit block group aware.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 resize/main.c      |    7 +++++++
 resize/resize2fs.c |   29 ++++++++++++++++++++++++-----
 2 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/resize/main.c b/resize/main.c
index 7db4ebc..7c1d0c1 100644
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
index 0d6a082..ce0111c 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -339,7 +339,9 @@ retry:
 		numblocks = fs->super->s_blocks_per_group;
 	i = old_fs->group_desc_count - 1;
 	fs->group_desc[i].bg_free_blocks_count += (numblocks-old_numblocks);
-		
+	fs->group_desc[i].bg_checksum =
+		ext2fs_group_desc_csum(fs->super, i, &fs->group_desc[i]);
+
 	/*
 	 * If the number of block groups is staying the same, we're
 	 * done and can exit now.  (If the number block groups is
@@ -415,6 +417,8 @@ retry:
 		fs->group_desc[i].bg_free_inodes_count =
 			fs->super->s_inodes_per_group;
 		fs->group_desc[i].bg_used_dirs_count = 0;
+		fs->group_desc[i].bg_checksum =
+			ext2fs_group_desc_csum(fs->super, i,&fs->group_desc[i]);
 
 		retval = ext2fs_allocate_group_table(fs, i, 0);
 		if (retval) goto errout;
@@ -1223,9 +1227,13 @@ static errcode_t inode_scan_and_fix(ext2_resize_t rfs)
 		if (retval) goto errout;
 
 		group = (new_inode-1) / EXT2_INODES_PER_GROUP(rfs->new_fs->super);
-		if (LINUX_S_ISDIR(inode.i_mode))
+		if (LINUX_S_ISDIR(inode.i_mode)) {
 			rfs->new_fs->group_desc[group].bg_used_dirs_count++;
-		
+			rfs->new_fs->group_desc[group].bg_checksum =
+				ext2fs_group_desc_csum(rfs->new_fs->super,group,
+					       &rfs->new_fs->group_desc[group]);
+		}
+
 #ifdef RESIZE2FS_DEBUG
 		if (rfs->flags & RESIZE_DEBUG_INODEMAP)
 			printf("Inode moved %u->%u\n", ino, new_inode);
@@ -1478,6 +1486,9 @@ static errcode_t move_itables(ext2_resize_t rfs)
 			ext2fs_unmark_block_bitmap(fs->block_map, blk);
 
 		rfs->old_fs->group_desc[i].bg_inode_table = new_blk;
+		rfs->old_fs->group_desc[i].bg_checksum =
+			ext2fs_group_desc_csum(rfs->old_fs->super, i,
+					       &rfs->old_fs->group_desc[i]);
 		ext2fs_mark_super_dirty(rfs->old_fs);
 		ext2fs_flush(rfs->old_fs);
 
@@ -1575,8 +1586,12 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 		count++;
 		if ((count == fs->super->s_blocks_per_group) ||
 		    (blk == fs->super->s_blocks_count-1)) {
-			fs->group_desc[group++].bg_free_blocks_count =
+			fs->group_desc[group].bg_free_blocks_count =
 				group_free;
+			fs->group_desc[group].bg_checksum =
+				ext2fs_group_desc_csum(fs->super, group,
+						       &fs->group_desc[group]);
+			group++;
 			count = 0;
 			group_free = 0;
 		}
@@ -1600,8 +1615,12 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 		count++;
 		if ((count == fs->super->s_inodes_per_group) ||
 		    (ino == fs->super->s_inodes_count)) {
-			fs->group_desc[group++].bg_free_inodes_count =
+			fs->group_desc[group].bg_free_inodes_count =
 				group_free;
+			fs->group_desc[group].bg_checksum =
+				ext2fs_group_desc_csum(fs->super, group,
+						       &fs->group_desc[group]);
+			group++;
 			count = 0;
 			group_free = 0;
 		}
