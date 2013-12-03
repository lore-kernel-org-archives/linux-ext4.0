From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2 10/28] libext2fs: handle inline_data in block iterator function
Date: Tue,  3 Dec 2013 20:11:37 +0800
Message-ID: <1386072715-9869-11-git-send-email-wenqing.lz@taobao.com>
References: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:43447 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab3LCMJa (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Dec 2013 07:09:30 -0500
Received: by mail-pa0-f41.google.com with SMTP id lf10so2891884pab.14
        for <linux-ext4@vger.kernel.org>; Tue, 03 Dec 2013 04:09:29 -0800 (PST)
In-Reply-To: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

After applied this commit (a7f4c635), we have banned to traverse blocks
for an inode which has inline data because no block belongs to it.  But
before calling this function, we need to check inline data flag.  This
commit add a sanity check ext2fs_inode_has_valid_blocks2() to fix them
except that ext2fs_expand_dir because it will be fixed by another patch.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 debugfs/filefrag.c     |   12 +++++++-----
 debugfs/lsdel.c        |   17 ++++++++++-------
 lib/ext2fs/valid_blk.c |    7 +++++++
 misc/tune2fs.c         |    3 ++-
 4 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/debugfs/filefrag.c b/debugfs/filefrag.c
index e82d133..7a82e8d 100644
--- a/debugfs/filefrag.c
+++ b/debugfs/filefrag.c
@@ -154,11 +154,13 @@ static void filefrag(ext2_ino_t ino, struct ext2_inode *inode,
 			fs->name, num_blocks, EXT2_I_SIZE(inode));
 	}
 	print_header(fs);
-	retval = ext2fs_block_iterate3(current_fs, ino,
-				       BLOCK_FLAG_READ_ONLY, NULL,
-				       filefrag_blocks_proc, fs);
-	if (retval)
-		com_err("ext2fs_block_iterate3", retval, 0);
+	if (ext2fs_inode_has_valid_blocks2(current_fs, inode)) {
+		retval = ext2fs_block_iterate3(current_fs, ino,
+					       BLOCK_FLAG_READ_ONLY, NULL,
+					       filefrag_blocks_proc, fs);
+		if (retval)
+			com_err("ext2fs_block_iterate3", retval, 0);
+	}
 
 	report_filefrag(fs);
 	fprintf(fs->f, "%s: %d contiguous extents%s\n", fs->name, fs->ext,
diff --git a/debugfs/lsdel.c b/debugfs/lsdel.c
index bed0ce6..ba84611 100644
--- a/debugfs/lsdel.c
+++ b/debugfs/lsdel.c
@@ -141,13 +141,16 @@ void do_lsdel(int argc, char **argv)
 		lsd.free_blocks = 0;
 		lsd.bad_blocks = 0;
 
-		retval = ext2fs_block_iterate3(current_fs, ino,
-					       BLOCK_FLAG_READ_ONLY, block_buf,
-					       lsdel_proc, &lsd);
-		if (retval) {
-			com_err("ls_deleted_inodes", retval,
-				"while calling ext2fs_block_iterate2");
-			goto next;
+		if (ext2fs_inode_has_valid_blocks2(current_fs, &inode)) {
+			retval = ext2fs_block_iterate3(current_fs, ino,
+						       BLOCK_FLAG_READ_ONLY,
+						       block_buf,
+						       lsdel_proc, &lsd);
+			if (retval) {
+				com_err("ls_deleted_inodes", retval,
+					"while calling ext2fs_block_iterate2");
+				goto next;
+			}
 		}
 		if (lsd.free_blocks && !lsd.bad_blocks) {
 			if (num_delarray >= max_delarray) {
diff --git a/lib/ext2fs/valid_blk.c b/lib/ext2fs/valid_blk.c
index 895e36e..db5d90a 100644
--- a/lib/ext2fs/valid_blk.c
+++ b/lib/ext2fs/valid_blk.c
@@ -52,6 +52,13 @@ int ext2fs_inode_has_valid_blocks2(ext2_filsys fs, struct ext2_inode *inode)
 			return 0; /* Probably a fast symlink */
 		}
 	}
+
+	/*
+	 * If this inode has inline data, it shouldn't have valid block
+	 * entries.
+	 */
+	if (inode->i_flags & EXT4_INLINE_DATA_FL)
+		return 0;
 	return 1;
 }
 
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 1ae0ee6..95c1886 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -688,7 +688,8 @@ static void rewrite_inodes(ext2_filsys fs)
 			exit(1);
 		}
 
-		if (LINUX_S_ISDIR(inode->i_mode)) {
+		if (LINUX_S_ISDIR(inode->i_mode) &&
+		    ext2fs_inode_has_valid_blocks2(fs, inode)) {
 			retval = rewrite_directory(fs, ino, inode);
 			if (retval) {
 				com_err("rewrite_directory", retval,
-- 
1.7.9.7

