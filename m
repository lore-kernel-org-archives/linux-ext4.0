Return-Path: <SRS0=2u2A=ND=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38444 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728947AbeJXEpA (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2018 00:45:00 -0400
Received: by mail-wm1-f66.google.com with SMTP id b14-v6so488255wmj.3
        for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2018 13:20:02 -0700 (PDT)
Date: Tue, 23 Oct 2018 21:20:00 +0100
From: Phillip Potter <phil@philpotter.co.uk>
To: tytso@mit.edu
Cc: linux-kernel@vger.kernel.org, amir73il@gmail.com,
        viro@zeniv.linux.org.uk, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [RFC][PATCH v2 06/10] ext4: use common file type conversion
Message-ID: <20181023202000.GA15724@pathfinder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Deduplicate the ext4 file type conversion implementation.

Original patch by Amir Goldstein.

v2:
- Rebased against Linux 4.19 by Phillip Potter
- This version does not replace the EXT4_FT_x defines from
  fs/ext4/ext4.h, as these values are now used in compile-time
  checks added by Phillip Potter to make sure they remain the
  same as FT_x values

v1:
- Initial implementation

Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
---
 fs/ext4/ext4.h | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index caff935fbeb8..4cb77a2cacdf 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2361,16 +2361,13 @@ static inline void ext4_update_dx_flag(struct inode *inode)
 	if (!ext4_has_feature_dir_index(inode->i_sb))
 		ext4_clear_inode_flag(inode, EXT4_INODE_INDEX);
 }
-static const unsigned char ext4_filetype_table[] = {
-	DT_UNKNOWN, DT_REG, DT_DIR, DT_CHR, DT_BLK, DT_FIFO, DT_SOCK, DT_LNK
-};
 
 static inline  unsigned char get_dtype(struct super_block *sb, int filetype)
 {
-	if (!ext4_has_feature_filetype(sb) || filetype >= EXT4_FT_MAX)
+	if (!ext4_has_feature_filetype(sb))
 		return DT_UNKNOWN;
 
-	return ext4_filetype_table[filetype];
+	return fs_dtype(filetype);
 }
 extern int ext4_check_all_de(struct inode *dir, struct buffer_head *bh,
 			     void *buf, int buf_size);
@@ -3055,22 +3052,28 @@ extern void initialize_dirent_tail(struct ext4_dir_entry_tail *t,
 extern int ext4_handle_dirty_dirent_node(handle_t *handle,
 					 struct inode *inode,
 					 struct buffer_head *bh);
-#define S_SHIFT 12
-static const unsigned char ext4_type_by_mode[(S_IFMT >> S_SHIFT) + 1] = {
-	[S_IFREG >> S_SHIFT]	= EXT4_FT_REG_FILE,
-	[S_IFDIR >> S_SHIFT]	= EXT4_FT_DIR,
-	[S_IFCHR >> S_SHIFT]	= EXT4_FT_CHRDEV,
-	[S_IFBLK >> S_SHIFT]	= EXT4_FT_BLKDEV,
-	[S_IFIFO >> S_SHIFT]	= EXT4_FT_FIFO,
-	[S_IFSOCK >> S_SHIFT]	= EXT4_FT_SOCK,
-	[S_IFLNK >> S_SHIFT]	= EXT4_FT_SYMLINK,
-};
 
 static inline void ext4_set_de_type(struct super_block *sb,
 				struct ext4_dir_entry_2 *de,
 				umode_t mode) {
+	/*
+	 * compile-time asserts that generic FT_x types
+	 * still match EXT4_FT_x types - no need to list
+	 * for other functions as well as build will
+	 * fail either way
+	 */
+	BUILD_BUG_ON(EXT4_FT_UNKNOWN != FT_UNKNOWN);
+	BUILD_BUG_ON(EXT4_FT_REG_FILE != FT_REG_FILE);
+	BUILD_BUG_ON(EXT4_FT_DIR != FT_DIR);
+	BUILD_BUG_ON(EXT4_FT_CHRDEV != FT_CHRDEV);
+	BUILD_BUG_ON(EXT4_FT_BLKDEV != FT_BLKDEV);
+	BUILD_BUG_ON(EXT4_FT_FIFO != FT_FIFO);
+	BUILD_BUG_ON(EXT4_FT_SOCK != FT_SOCK);
+	BUILD_BUG_ON(EXT4_FT_SYMLINK != FT_SYMLINK);
+	BUILD_BUG_ON(EXT4_FT_MAX != FT_MAX);
+
 	if (ext4_has_feature_filetype(sb))
-		de->file_type = ext4_type_by_mode[(mode & S_IFMT)>>S_SHIFT];
+		de->file_type = fs_umode_to_ftype(mode);
 }
 
 /* readpages.c */
-- 
2.17.2
