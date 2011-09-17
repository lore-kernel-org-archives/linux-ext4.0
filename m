From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] e2fsck: add migration inodes cleanup support
Date: Sat, 17 Sep 2011 17:33:29 +0400
Message-ID: <1316266409-18932-1-git-send-email-dmonakhov@openvz.org>
Cc: aneesh.kumar@linux.vnet.ibm.com, tytso@mit.edu,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:64332 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab1IQNdg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 17 Sep 2011 09:33:36 -0400
Received: by mail-bw0-f46.google.com with SMTP id zt4so4173708bkb.19
        for <linux-ext4@vger.kernel.org>; Sat, 17 Sep 2011 06:33:35 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Inodes with MIGRATION flag enabled are temporal
and does not own it's data blocks.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 e2fsck/super.c       |    9 ++++++++-
 lib/ext2fs/ext2_fs.h |    1 +
 2 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/e2fsck/super.c b/e2fsck/super.c
index a61eb33..69566a3 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -46,6 +46,7 @@ struct process_block_struct {
 	char 		*buf;
 	struct problem_context *pctx;
 	int		truncating;
+	int		release_data_block;
 	int		truncate_offset;
 	e2_blkcnt_t	truncate_block;
 	int		truncated_blocks;
@@ -88,7 +89,8 @@ static int release_inode_block(ext2_filsys fs,
 		fix_problem(ctx, PR_0_ORPHAN_ALREADY_CLEARED_BLOCK, pctx);
 		goto return_abort;
 	}
-
+	if (!pb->release_data_block && blockcnt >= 0)
+		return 0;
 	/*
 	 * If we are deleting an orphan, then we leave the fields alone.
 	 * If we are truncating an orphan, then update the inode fields
@@ -178,6 +180,11 @@ static int release_inode_blocks(e2fsck_t ctx, ext2_ino_t ino,
 		pb.truncate_block = 0;
 		pb.truncate_offset = 0;
 	}
+	if (inode->i_flags & EXT4_MIGRATE_FL)
+		pb.release_data_block = 0;
+	else
+		pb.release_data_block = 1;
+
 	pb.truncated_blocks = 0;
 	retval = ext2fs_block_iterate3(fs, ino, BLOCK_FLAG_DEPTH_TRAVERSE,
 				      block_buf, release_inode_block, &pb);
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 54cb3d4..e2fc101 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -284,6 +284,7 @@ struct ext2_dx_countlimit {
 #define EXT4_SNAPFILE_FL		0x01000000  /* Inode is a snapshot */
 #define EXT4_SNAPFILE_DELETED_FL	0x04000000  /* Snapshot is being deleted */
 #define EXT4_SNAPFILE_SHRUNK_FL		0x08000000  /* Snapshot shrink has completed */
+#define EXT4_MIGRATE_FL                 0x10000000 /* Inode used for data migration */
 #define EXT2_RESERVED_FL		0x80000000 /* reserved for ext2 lib */
 
 #define EXT2_FL_USER_VISIBLE		0x004BDFFF /* User visible flags */
-- 
1.7.2.3

