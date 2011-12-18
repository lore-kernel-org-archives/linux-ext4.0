From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 5/5] e2fsck: make e2fsck to support inline data in pass2
Date: Sun, 18 Dec 2011 22:44:44 +0800
Message-ID: <1324219484-22443-6-git-send-email-wenqing.lz@taobao.com>
References: <1324219484-22443-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63410 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab1LROo3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Dec 2011 09:44:29 -0500
Received: by mail-iy0-f174.google.com with SMTP id h11so7092185iae.19
        for <linux-ext4@vger.kernel.org>; Sun, 18 Dec 2011 06:44:29 -0800 (PST)
In-Reply-To: <1324219484-22443-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Let e2fsck to support inline data in pass2.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 e2fsck/pass2.c           |   46 ++++++++++++++++++++++++++++-----
 lib/ext2fs/dirblock.c    |   64 ++++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2fs.h      |    4 +++
 lib/ext2fs/inline_data.c |   33 +++++++++++++++++++++++
 4 files changed, 140 insertions(+), 7 deletions(-)

diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 103b155..4637d6b 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -710,6 +710,7 @@ static int check_dir_block(ext2_filsys fs,
 	struct dx_dirblock_info	*dx_db = 0;
 #endif /* ENABLE_HTREE */
 	struct ext2_dir_entry 	*dirent, *prev;
+	struct ext2_inode	inode;
 	ext2_dirhash_t		hash;
 	unsigned int		offset = 0;
 	int			dir_modified = 0;
@@ -729,6 +730,7 @@ static int check_dir_block(ext2_filsys fs,
 	struct problem_context	pctx;
 	int	dups_found = 0;
 	int	ret;
+	int	inline_data_in_extra = 0;
 
 	cd = (struct check_dir_struct *) priv_data;
 	buf = cd->buf;
@@ -775,7 +777,12 @@ static int check_dir_block(ext2_filsys fs,
 #endif
 
 	ehandler_operation(_("reading directory block"));
-	cd->pctx.errcode = ext2fs_read_dir_block3(fs, block_nr, buf, 0);
+	ext2fs_read_inode(fs, ino, &inode);
+	cd->pctx.errcode = ext2fs_read_dir_inline_data(fs, ino, buf);
+	if (cd->pctx.errcode == 0)
+		inline_data_in_extra = ext2fs_inline_data_in_extra(fs, ino);
+	else
+		cd->pctx.errcode = ext2fs_read_dir_block3(fs, block_nr, buf, 0);
 	ehandler_operation(0);
 	if (cd->pctx.errcode == EXT2_ET_DIR_CORRUPTED)
 		cd->pctx.errcode = 0; /* We'll handle this ourselves */
@@ -1088,8 +1095,9 @@ out_htree:
 			if (ctx->dirs_to_hash)
 				ext2fs_u32_list_add(ctx->dirs_to_hash, ino);
 			dups_found++;
-		} else
+		} else {
 			dict_alloc_insert(&de_dict, dirent, dirent);
+		}
 
 		ext2fs_icount_increment(ctx->inode_count, dirent->inode,
 					&links);
@@ -1102,6 +1110,20 @@ out_htree:
 			(void) ext2fs_get_rec_len(fs, dirent, &rec_len);
 		offset += rec_len;
 		dot_state++;
+
+		if ((inode.i_flags & EXT4_INLINE_DATA_FL) &&
+		    offset == EXT4_MIN_INLINE_DATA_SIZE) {
+			if (inline_data_in_extra) {
+				inline_data_in_extra = 0;
+				cd->pctx.errcode =
+					ext2fs_read_dir_inline_data_more(fs,
+								ino, buf);
+				prev = 0;
+			} else
+				break;
+		} else if ((inode.i_flags & EXT4_INLINE_DATA_FL) &&
+			   offset == ext2fs_inline_data_size(fs, ino))
+			break;
 	} while (offset < fs->blocksize);
 #if 0
 	printf("\n");
@@ -1120,14 +1142,19 @@ out_htree:
 	}
 #endif /* ENABLE_HTREE */
 	if (offset != fs->blocksize) {
-		cd->pctx.num = rec_len - fs->blocksize + offset;
-		if (fix_problem(ctx, PR_2_FINAL_RECLEN, &cd->pctx)) {
-			dirent->rec_len = cd->pctx.num;
-			dir_modified++;
+		if (!(inode.i_flags & EXT4_INLINE_DATA_FL)) {
+			cd->pctx.num = rec_len - fs->blocksize + offset;
+			if (fix_problem(ctx, PR_2_FINAL_RECLEN, &cd->pctx)) {
+				dirent->rec_len = cd->pctx.num;
+				dir_modified++;
+			}
 		}
+		/* TODO: handle inline data record */
 	}
 	if (dir_modified) {
-		cd->pctx.errcode = ext2fs_write_dir_block(fs, block_nr, buf);
+		cd->pctx.errcode = ext2fs_write_dir_inline_data(fs, ino, buf);
+		if (cd->pctx.errcode != 0)
+			cd->pctx.errcode = ext2fs_write_dir_block(fs, block_nr, buf);
 		if (cd->pctx.errcode) {
 			if (!fix_problem(ctx, PR_2_WRITE_DIRBLOCK,
 					 &cd->pctx))
@@ -1410,6 +1437,11 @@ static int allocate_dir_block(e2fsck_t ctx,
 	char			*block;
 	struct ext2_inode	inode;
 
+	/* read inode first to check inline data */
+	e2fsck_read_inode(ctx, db->ino, &inode, "allocate_dir_block");
+	if (inode.i_flags & EXT4_INLINE_DATA_FL)
+		return 0;
+
 	if (fix_problem(ctx, PR_2_DIRECTORY_HOLE, pctx) == 0)
 		return 1;
 
diff --git a/lib/ext2fs/dirblock.c b/lib/ext2fs/dirblock.c
index cb3a104..75830c0 100644
--- a/lib/ext2fs/dirblock.c
+++ b/lib/ext2fs/dirblock.c
@@ -20,6 +20,47 @@
 #include "ext2_fs.h"
 #include "ext2fs.h"
 
+errcode_t ext2fs_read_dir_inline_data_more(ext2_filsys fs, ext2_ino_t ino, void *buf)
+{
+	struct ext2_inode *inode;
+	struct inline_data idata;
+
+	inode = (struct ext2_inode *) malloc(EXT2_INODE_SIZE(fs->super));
+	ext2fs_read_inode_full(fs, ino, inode, EXT2_INODE_SIZE(fs->super));
+
+	if (!(inode->i_flags & EXT4_INLINE_DATA_FL))
+		return -1;
+
+	ext2fs_iget_extra_inode(fs, inode, &idata);
+	if (idata.inline_off == 0 ||
+	    idata.inline_size == EXT4_MIN_INLINE_DATA_SIZE)
+		return 0;
+
+	memcpy(buf + EXT4_MIN_INLINE_DATA_SIZE,
+	       ext2fs_get_inline_xattr_pos(inode, &idata),
+	       idata.inline_size - EXT4_MIN_INLINE_DATA_SIZE);
+
+	free(inode);
+	return 0;
+}
+
+errcode_t ext2fs_read_dir_inline_data(ext2_filsys fs, ext2_ino_t ino, void *buf)
+{
+	struct ext2_inode *inode;
+	struct inline_data idata;
+
+	inode = (struct ext2_inode *) malloc(EXT2_INODE_SIZE(fs->super));
+	ext2fs_read_inode_full(fs, ino, inode, EXT2_INODE_SIZE(fs->super));
+
+	if (!(inode->i_flags & EXT4_INLINE_DATA_FL))
+		return -1;
+
+	memcpy(buf, inode->i_block, EXT4_MIN_INLINE_DATA_SIZE);
+
+	free(inode);
+	return 0;
+}
+
 errcode_t ext2fs_read_dir_block3(ext2_filsys fs, blk64_t block,
 				 void *buf, int flags EXT2FS_ATTR((unused)))
 {
@@ -125,3 +166,26 @@ errcode_t ext2fs_write_dir_block(ext2_filsys fs, blk_t block,
 	return ext2fs_write_dir_block3(fs, block, inbuf, 0);
 }
 
+errcode_t ext2fs_write_dir_inline_data(ext2_filsys fs, ext2_ino_t ino, void *buf)
+{
+	struct ext2_inode *inode;
+	struct inline_data idata;
+
+	inode = (struct ext2_inode *) malloc(EXT2_INODE_SIZE(fs->super));
+	ext2fs_read_inode_full(fs, ino, inode, EXT2_INODE_SIZE(fs->super));
+
+	memcpy(inode->i_block, buf, EXT4_MIN_INLINE_DATA_SIZE);
+	ext2fs_iget_extra_inode(fs, inode, &idata);
+	if (idata.inline_off == 0 ||
+	    idata.inline_size == EXT4_MIN_INLINE_DATA_SIZE)
+		goto out;
+
+	memcpy(inode->i_block + EXT4_MIN_INLINE_DATA_SIZE,
+		ext2fs_get_inline_xattr_pos(inode, &idata),
+		idata.inline_size - EXT4_MIN_INLINE_DATA_SIZE);
+
+out:
+	ext2fs_write_inode_full(fs, ino, inode, EXT2_INODE_SIZE(fs->super));
+	free(inode);
+	return 0;
+}
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index dc40359..9f91270 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1004,6 +1004,8 @@ extern errcode_t ext2fs_write_dir_block2(ext2_filsys fs, blk_t block,
 					 void *buf, int flags);
 extern errcode_t ext2fs_write_dir_block3(ext2_filsys fs, blk64_t block,
 					 void *buf, int flags);
+extern errcode_t ext2fs_write_dir_inline_data(ext2_filsys fs,
+					      ext2_ino_t ino, void *buf);
 
 /* dirhash.c */
 extern errcode_t ext2fs_dirhash(int version, const char *name, int len,
@@ -1231,6 +1233,8 @@ extern errcode_t ext2fs_find_inline_entry(ext2_filsys fs,
 					  void *priv_data);
 extern errcode_t ext2fs_search_dir_inline_data(ext2_filsys fs, ext2_ino_t ino,
 					       char *search_name, int len);
+extern int ext2fs_inline_data_in_extra(ext2_filsys fs, ext2_ino_t ino);
+extern int ext2fs_inline_data_size(ext2_filsys fs, ext2_ino_t ino);
 extern void *ext2fs_get_inline_xattr_pos(struct ext2_inode *inode,
 					 struct inline_data *idata);
 extern void ext2fs_iget_extra_inode(ext2_filsys fs, struct ext2_inode *inode,
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index 3a29ee7..fd067a6 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -235,3 +235,36 @@ errcode_t ext2fs_inline_data_header_verify(ext2_filsys fs,
 
 	return ret;
 }
+
+int ext2fs_inline_data_in_extra(ext2_filsys fs, ext2_ino_t ino)
+{
+	struct ext2_inode *inode;
+	struct inline_data idata;
+
+	inode = (struct ext2_inode *) malloc(EXT2_INODE_SIZE(fs->super));
+	ext2fs_read_inode_full(fs, ino, inode, EXT2_INODE_SIZE(fs->super));
+
+	ext2fs_iget_extra_inode(fs, inode, &idata);
+	free(inode);
+	if (idata.inline_off == 0 ||
+	    idata.inline_size == EXT4_MIN_INLINE_DATA_SIZE)
+		return 0;
+	else
+		return 1;
+}
+
+int ext2fs_inline_data_size(ext2_filsys fs, ext2_ino_t ino)
+{
+	struct ext2_inode *inode;
+	struct inline_data idata;
+
+	inode = (struct ext2_inode *) malloc(EXT2_INODE_SIZE(fs->super));
+	ext2fs_read_inode_full(fs, ino, inode, EXT2_INODE_SIZE(fs->super));
+
+	ext2fs_iget_extra_inode(fs, inode, &idata);
+	free(inode);
+	if (idata.inline_off == 0)
+		return 0;
+	else
+		return idata.inline_size;
+}
-- 
1.7.4.1

