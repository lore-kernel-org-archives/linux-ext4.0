Return-Path: <SRS0=2u2A=ND=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34578 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbeJXFpQ (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2018 01:45:16 -0400
Received: by mail-wm1-f66.google.com with SMTP id f1-v6so875782wmg.1
        for <linux-ext4@vger.kernel.org>; Tue, 23 Oct 2018 14:20:07 -0700 (PDT)
Date: Tue, 23 Oct 2018 22:20:05 +0100
From: Phillip Potter <phil@philpotter.co.uk>
To: jack@suse.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        amir73il@gmail.com, viro@zeniv.linux.org.uk,
        linux-ext4@vger.kernel.org
Subject: [RFC][PATCH v2 04/10] ext2: use common file type conversion
Message-ID: <20181023212005.GA16631@pathfinder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Deduplicate the ext2 file type conversion implementation.

Original patch by Amir Goldstein.

v2:
- Rebased against Linux 4.19 by Phillip Potter
- This version does not remove EXT2_FT_x enum from fs/ext2/ext2.h,
  as these values are now used in compile-time checks added by
  Phillip Potter to make sure they remain the same as FT_x values

v1:
- Initial implementation

Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
---
 fs/ext2/dir.c | 51 ++++++++++++++++++++++-----------------------------
 1 file changed, 22 insertions(+), 29 deletions(-)

diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 3b8114def693..420d4b9e8980 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -252,33 +252,10 @@ ext2_validate_entry(char *base, unsigned offset, unsigned mask)
 	return (char *)p - base;
 }
 
-static unsigned char ext2_filetype_table[EXT2_FT_MAX] = {
-	[EXT2_FT_UNKNOWN]	= DT_UNKNOWN,
-	[EXT2_FT_REG_FILE]	= DT_REG,
-	[EXT2_FT_DIR]		= DT_DIR,
-	[EXT2_FT_CHRDEV]	= DT_CHR,
-	[EXT2_FT_BLKDEV]	= DT_BLK,
-	[EXT2_FT_FIFO]		= DT_FIFO,
-	[EXT2_FT_SOCK]		= DT_SOCK,
-	[EXT2_FT_SYMLINK]	= DT_LNK,
-};
-
-#define S_SHIFT 12
-static unsigned char ext2_type_by_mode[S_IFMT >> S_SHIFT] = {
-	[S_IFREG >> S_SHIFT]	= EXT2_FT_REG_FILE,
-	[S_IFDIR >> S_SHIFT]	= EXT2_FT_DIR,
-	[S_IFCHR >> S_SHIFT]	= EXT2_FT_CHRDEV,
-	[S_IFBLK >> S_SHIFT]	= EXT2_FT_BLKDEV,
-	[S_IFIFO >> S_SHIFT]	= EXT2_FT_FIFO,
-	[S_IFSOCK >> S_SHIFT]	= EXT2_FT_SOCK,
-	[S_IFLNK >> S_SHIFT]	= EXT2_FT_SYMLINK,
-};
-
 static inline void ext2_set_de_type(ext2_dirent *de, struct inode *inode)
 {
-	umode_t mode = inode->i_mode;
 	if (EXT2_HAS_INCOMPAT_FEATURE(inode->i_sb, EXT2_FEATURE_INCOMPAT_FILETYPE))
-		de->file_type = ext2_type_by_mode[(mode & S_IFMT)>>S_SHIFT];
+		de->file_type = fs_umode_to_ftype(inode->i_mode);
 	else
 		de->file_type = 0;
 }
@@ -293,14 +270,14 @@ ext2_readdir(struct file *file, struct dir_context *ctx)
 	unsigned long n = pos >> PAGE_SHIFT;
 	unsigned long npages = dir_pages(inode);
 	unsigned chunk_mask = ~(ext2_chunk_size(inode)-1);
-	unsigned char *types = NULL;
 	bool need_revalidate = !inode_eq_iversion(inode, file->f_version);
+	bool has_filetype;
 
 	if (pos > inode->i_size - EXT2_DIR_REC_LEN(1))
 		return 0;
 
-	if (EXT2_HAS_INCOMPAT_FEATURE(sb, EXT2_FEATURE_INCOMPAT_FILETYPE))
-		types = ext2_filetype_table;
+	has_filetype =
+		EXT2_HAS_INCOMPAT_FEATURE(sb, EXT2_FEATURE_INCOMPAT_FILETYPE);
 
 	for ( ; n < npages; n++, offset = 0) {
 		char *kaddr, *limit;
@@ -335,8 +312,24 @@ ext2_readdir(struct file *file, struct dir_context *ctx)
 			if (de->inode) {
 				unsigned char d_type = DT_UNKNOWN;
 
-				if (types && de->file_type < EXT2_FT_MAX)
-					d_type = types[de->file_type];
+				/*
+				 * compile-time asserts that generic FT_x types
+				 * still match EXT2_FT_x types - no need to list
+				 * for other functions as well as build will
+				 * fail either way
+				 */
+				BUILD_BUG_ON(EXT2_FT_UNKNOWN != FT_UNKNOWN);
+				BUILD_BUG_ON(EXT2_FT_REG_FILE != FT_REG_FILE);
+				BUILD_BUG_ON(EXT2_FT_DIR != FT_DIR);
+				BUILD_BUG_ON(EXT2_FT_CHRDEV != FT_CHRDEV);
+				BUILD_BUG_ON(EXT2_FT_BLKDEV != FT_BLKDEV);
+				BUILD_BUG_ON(EXT2_FT_FIFO != FT_FIFO);
+				BUILD_BUG_ON(EXT2_FT_SOCK != FT_SOCK);
+				BUILD_BUG_ON(EXT2_FT_SYMLINK != FT_SYMLINK);
+				BUILD_BUG_ON(EXT2_FT_MAX != FT_MAX);
+
+				if (has_filetype)
+					d_type = fs_dtype(de->file_type);
 
 				if (!dir_emit(ctx, de->name, de->name_len,
 						le32_to_cpu(de->inode),
-- 
2.17.2
