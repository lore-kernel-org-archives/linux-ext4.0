From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 1/2 bigalloc] e2fsprogs: change "blocks" to "clusters" in dumpe2fs
Date: Fri,  5 Aug 2011 12:27:50 +0800
Message-ID: <1312518471-30714-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:56668 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab1HEE2B (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Aug 2011 00:28:01 -0400
Received: by pzk37 with SMTP id 37so3220024pzk.1
        for <linux-ext4@vger.kernel.org>; Thu, 04 Aug 2011 21:28:01 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

When using dumpe2fs to display group detail of a bigalloc-fs, it displays like:

Group 413: (Blocks 54132737-54263808)
Block bitmap at 54132737 (+0), Inode bitmap at 54132738 (+1)
Inode table at 54132739-54133761 (+2)
8127 free blocks, 8184 free inodes, 0 directories
Free blocks: 54133776-54263792
Free inodes: 3379993-3388176

The "8127 free blocks" should be "8127 free clusters".

This patch is based on "next" branch of e2fsprogs.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 misc/dumpe2fs.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index 9a0dd46..bb4eef1 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -226,12 +226,21 @@ static void list_desc (ext2_filsys fs)
 			    inode_blocks_per_group - 1);
 		print_bg_rel_offset(fs, ext2fs_inode_table_loc(fs, i), 1,
 				    first_block, last_block);
-		printf (_("\n  %u free blocks, %u free inodes, "
-			  "%u directories%s"),
-			ext2fs_bg_free_blocks_count(fs, i),
-			ext2fs_bg_free_inodes_count(fs, i),
-			ext2fs_bg_used_dirs_count(fs, i),
-			ext2fs_bg_itable_unused(fs, i) ? "" : "\n");
+		if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_BIGALLOC))
+			printf (_("\n  %u free clusters, %u free inodes, "
+				  "%u directories%s"),
+				ext2fs_bg_free_blocks_count(fs, i),
+				ext2fs_bg_free_inodes_count(fs, i),
+				ext2fs_bg_used_dirs_count(fs, i),
+				ext2fs_bg_itable_unused(fs, i) ? "" : "\n");
+		else
+			printf (_("\n  %u free blocks, %u free inodes, "
+				  "%u directories%s"),
+				ext2fs_bg_free_blocks_count(fs, i),
+				ext2fs_bg_free_inodes_count(fs, i),
+				ext2fs_bg_used_dirs_count(fs, i),
+				ext2fs_bg_itable_unused(fs, i) ? "" : "\n");
 		if (ext2fs_bg_itable_unused(fs, i))
 			printf (_(", %u unused inodes\n"),
 				ext2fs_bg_itable_unused(fs, i));
-- 
1.7.3.2

