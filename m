From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 32/32] e2fsck: check inline data in pass2
Date: Mon, 16 Apr 2012 19:40:07 +0800
Message-ID: <1334576407-4007-33-git-send-email-wenqing.lz@taobao.com>
References: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:62902 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab2DPLeu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Apr 2012 07:34:50 -0400
Received: by mail-pz0-f52.google.com with SMTP id e40so6801134dak.11
        for <linux-ext4@vger.kernel.org>; Mon, 16 Apr 2012 04:34:50 -0700 (PDT)
In-Reply-To: <1334576407-4007-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 e2fsck/pass2.c           |   50 ++++++++++++++++++++++++++++++++++++++-------
 lib/ext2fs/inline_data.c |    4 +-
 2 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 882950d..0b902f2 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -70,6 +70,7 @@ static int allocate_dir_block(e2fsck_t ctx,
 static void clear_htree(e2fsck_t ctx, ext2_ino_t ino);
 static int htree_depth(struct dx_dir_info *dx_dir,
 		       struct dx_dirblock_info *dx_db);
+static int is_last_entry(ext2_filsys fs, ext2_ino_t ino, unsigned int offset);
 static EXT2_QSORT_TYPE special_dir_block_cmp(const void *a, const void *b);
 
 struct check_dir_struct {
@@ -715,6 +716,7 @@ static int check_dir_block(ext2_filsys fs,
 	struct dx_dirblock_info	*dx_db = 0;
 #endif /* ENABLE_HTREE */
 	struct ext2_dir_entry 	*dirent, *prev;
+	struct ext2_inode	inode;
 	ext2_dirhash_t		hash;
 	unsigned int		offset = 0;
 	int			dir_modified = 0;
@@ -759,7 +761,8 @@ static int check_dir_block(ext2_filsys fs,
 	cd->pctx.dirent = 0;
 	cd->pctx.num = 0;
 
-	if (db->blk == 0) {
+	/* We don't need to allocate dir blocks for inline_data dir */
+	if (db->blk == 0 && !ext2fs_has_inline_data(fs, db->ino)) {
 		if (allocate_dir_block(ctx, db, buf, &cd->pctx))
 			return 0;
 		block_nr = db->blk;
@@ -780,7 +783,15 @@ static int check_dir_block(ext2_filsys fs,
 #endif
 
 	ehandler_operation(_("reading directory block"));
-	cd->pctx.errcode = ext2fs_read_dir_block3(fs, block_nr, buf, 0);
+	ext2fs_read_inode(fs, ino, &inode);
+	if (inode.i_flags & EXT4_INLINE_DATA_FL) {
+		cd->pctx.errcode = ext2fs_read_dir_inline_data(fs, ino, buf);
+		if (!cd->pctx.errcode)
+			cd->pctx.errcode = ext2fs_read_dir_inline_data_more(fs,
+								ino, buf);
+	} else {
+		cd->pctx.errcode = ext2fs_read_dir_block3(fs, block_nr, buf, 0);
+	}
 	ehandler_operation(0);
 	if (cd->pctx.errcode == EXT2_ET_DIR_CORRUPTED)
 		cd->pctx.errcode = 0; /* We'll handle this ourselves */
@@ -1107,7 +1118,7 @@ out_htree:
 			(void) ext2fs_get_rec_len(fs, dirent, &rec_len);
 		offset += rec_len;
 		dot_state++;
-	} while (offset < fs->blocksize);
+	} while (is_last_entry(fs, ino, offset));
 #if 0
 	printf("\n");
 #endif
@@ -1125,14 +1136,29 @@ out_htree:
 	}
 #endif /* ENABLE_HTREE */
 	if (offset != fs->blocksize) {
-		cd->pctx.num = rec_len - fs->blocksize + offset;
-		if (fix_problem(ctx, PR_2_FINAL_RECLEN, &cd->pctx)) {
-			dirent->rec_len = cd->pctx.num;
-			dir_modified++;
+		if (!(inode.i_flags & EXT4_INLINE_DATA_FL)) {
+			cd->pctx.errcode = rec_len - fs->blocksize + offset;
+			if (fix_problem(ctx, PR_2_FINAL_RECLEN, &cd->pctx)) {
+				dirent->rec_len = cd->pctx.num;
+				dir_modified++;
+			}
+		} else {
+			if (offset != ext2fs_inline_data_size(fs, ino)) {
+				cd->pctx.errcode = rec_len + offset -
+					ext2fs_inline_data_size(fs, ino);
+				if (fix_problem(ctx, PR_2_FINAL_RECLEN,
+						&cd->pctx)) {
+					dirent->rec_len = cd->pctx.num;
+					dir_modified++;
+				}
+			}
 		}
 	}
 	if (dir_modified) {
-		cd->pctx.errcode = ext2fs_write_dir_block(fs, block_nr, buf);
+		if (inode.i_flags & EXT4_INLINE_DATA_FL)
+			cd->pctx.errcode = ext2fs_write_dir_inline_data(fs, ino, buf);
+		else
+			cd->pctx.errcode = ext2fs_write_dir_block(fs, block_nr, buf);
 		if (cd->pctx.errcode) {
 			if (!fix_problem(ctx, PR_2_WRITE_DIRBLOCK,
 					 &cd->pctx))
@@ -1483,3 +1509,11 @@ static int allocate_dir_block(e2fsck_t ctx,
 
 	return 0;
 }
+
+static int is_last_entry(ext2_filsys fs, ext2_ino_t ino, unsigned int offset)
+{
+	if (ext2fs_has_inline_data(fs, ino))
+		return (offset < ext2fs_inline_data_size(fs, ino));
+	else
+		return (offset < fs->blocksize);
+}
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index 4ebd592..8dc7b8c 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -584,7 +584,7 @@ int ext2fs_inline_data_in_extra(ext2_filsys fs, ext2_ino_t ino)
 	ext2fs_get_mem(EXT2_INODE_SIZE(fs->super), &inode);
 	ext2fs_read_inode_full(fs, ino, inode, EXT2_INODE_SIZE(fs->super));
 
-	ext2fs_iget_extra_inode(fs, inode, &idata);
+	ext2fs_iget_extra_inode(fs, (void *)inode, &idata);
 	ext2fs_free_mem(&inode);
 	if (idata.inline_off == 0 ||
 	    idata.inline_size == EXT4_MIN_INLINE_DATA_SIZE)
@@ -601,7 +601,7 @@ int ext2fs_inline_data_size(ext2_filsys fs, ext2_ino_t ino)
 	inode = (struct ext2_inode *) malloc(EXT2_INODE_SIZE(fs->super));
 	ext2fs_read_inode_full(fs, ino, inode, EXT2_INODE_SIZE(fs->super));
 
-	ext2fs_iget_extra_inode(fs, inode, &idata);
+	ext2fs_iget_extra_inode(fs, (void *)inode, &idata);
 	free(inode);
 	if (idata.inline_off == 0)
 		return 0;
-- 
1.7.4.1

