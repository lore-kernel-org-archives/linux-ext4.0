From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: [PATCH, E2FSPROGS] e2fsck: Support long symlinks which use extents
Date: Thu, 13 Mar 2008 23:20:56 -0400
Message-ID: <1205464857-6244-1-git-send-email-tytso@mit.edu>
References: <20080313214731.GE28728@mit.edu>
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:35192 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750783AbYCNDVO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Mar 2008 23:21:14 -0400
In-Reply-To: <20080313214731.GE28728@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/e2fsck.h |    2 +-
 e2fsck/pass1.c  |   32 +++++++++++++++++++++++++++++---
 e2fsck/pass2.c  |    2 +-
 3 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index be6efe1..21208e0 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -429,7 +429,7 @@ extern void e2fsck_setup_tdb_icount(e2fsck_t ctx, int flags,
 extern void e2fsck_use_inode_shortcuts(e2fsck_t ctx, int bool);
 extern int e2fsck_pass1_check_device_inode(ext2_filsys fs,
 					   struct ext2_inode *inode);
-extern int e2fsck_pass1_check_symlink(ext2_filsys fs,
+extern int e2fsck_pass1_check_symlink(ext2_filsys fs, ext2_ino_t ino,
 				      struct ext2_inode *inode, char *buf);
 extern void e2fsck_clear_inode(e2fsck_t ctx, ext2_ino_t ino,
 			       struct ext2_inode *inode, int restart_flag,
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index c598205..8638989 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -163,17 +163,42 @@ int e2fsck_pass1_check_device_inode(ext2_filsys fs EXT2FS_ATTR((unused)),
  * Check to make sure a symlink inode is real.  Returns 1 if the symlink
  * checks out, 0 if not.
  */
-int e2fsck_pass1_check_symlink(ext2_filsys fs, struct ext2_inode *inode,
-			       char *buf)
+int e2fsck_pass1_check_symlink(ext2_filsys fs, ext2_ino_t ino,
+			       struct ext2_inode *inode, char *buf)
 {
 	unsigned int len;
 	int i;
 	blk_t	blocks;
+	ext2_extent_handle_t	handle;
+	struct ext2_extent_info	info;
+	struct ext2fs_extent	extent;
 
 	if ((inode->i_size_high || inode->i_size == 0) ||
 	    (inode->i_flags & EXT2_INDEX_FL))
 		return 0;
 
+	if (inode->i_flags & EXT4_EXTENTS_FL) {
+		if (inode->i_size > fs->blocksize)
+			return 0;
+		if (ext2fs_extent_open(fs, ino, &handle))
+			return 0;
+		i = 0;
+		if (ext2fs_extent_get_info(handle, &info) ||
+		    (info.num_entries != 1) ||
+		    (info.max_depth != 0))
+			goto exit_extent;
+		if (ext2fs_extent_get(handle, EXT2_EXTENT_ROOT, &extent) ||
+		    (extent.e_lblk != 0) ||
+		    (extent.e_len != 1) ||
+		    (extent.e_pblk < fs->super->s_first_data_block) ||
+		    (extent.e_pblk >= fs->super->s_blocks_count))
+			goto exit_extent;
+		i = 1;
+	exit_extent:
+		ext2fs_extent_free(handle);
+		return i;
+	}
+
 	blocks = ext2fs_inode_data_blocks(fs, inode);
 	if (blocks) {
 		if ((inode->i_size >= fs->blocksize) ||
@@ -910,7 +935,8 @@ void e2fsck_pass1(e2fsck_t ctx)
 			check_size(ctx, &pctx);
 			ctx->fs_blockdev_count++;
 		} else if (LINUX_S_ISLNK (inode->i_mode) &&
-			   e2fsck_pass1_check_symlink(fs, inode, block_buf)) {
+			   e2fsck_pass1_check_symlink(fs, ino, inode, 
+						      block_buf)) {
 			check_immutable(ctx, &pctx);
 			ctx->fs_symlinks_count++;
 			if (ext2fs_inode_data_blocks(fs, inode) == 0) {
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index a336755..56f352b 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1218,7 +1218,7 @@ extern int e2fsck_process_bad_inode(e2fsck_t ctx, ext2_ino_t dir,
 		 && !e2fsck_pass1_check_device_inode(fs, &inode))
 		problem = PR_2_BAD_SOCKET;
 	else if (LINUX_S_ISLNK(inode.i_mode)
-		 && !e2fsck_pass1_check_symlink(fs, &inode, buf)) {
+		 && !e2fsck_pass1_check_symlink(fs, ino, &inode, buf)) {
 		problem = PR_2_INVALID_SYMLINK;
 	}
 
-- 
1.5.4.1.144.gdfee-dirty

