From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2 23/28] e2fsck: check inline_data in pass2
Date: Tue,  3 Dec 2013 20:11:50 +0800
Message-ID: <1386072715-9869-24-git-send-email-wenqing.lz@taobao.com>
References: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
Cc: Theodore Ts'o <tytso@mit.edu>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f51.google.com ([209.85.160.51]:64592 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798Ab3LCMJ7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Dec 2013 07:09:59 -0500
Received: by mail-pb0-f51.google.com with SMTP id up15so20868164pbc.38
        for <linux-ext4@vger.kernel.org>; Tue, 03 Dec 2013 04:09:58 -0800 (PST)
In-Reply-To: <1386072715-9869-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 e2fsck/pass2.c |  128 +++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 100 insertions(+), 28 deletions(-)

diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 3c0bf49..aa996bf 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -730,6 +730,15 @@ static void salvage_directory(ext2_filsys fs,
 	}
 }
 
+static int is_last_entry(ext2_filsys fs, int inline_data_size,
+			 unsigned int offset, int csum_size)
+{
+	if (inline_data_size)
+		return (offset < inline_data_size);
+	else
+		return (offset < fs->blocksize - csum_size);
+}
+
 static int check_dir_block(ext2_filsys fs,
 			   struct ext2_db_entry2 *db,
 			   void *priv_data)
@@ -738,7 +747,7 @@ static int check_dir_block(ext2_filsys fs,
 #ifdef ENABLE_HTREE
 	struct dx_dirblock_info	*dx_db = 0;
 #endif /* ENABLE_HTREE */
-	struct ext2_dir_entry 	*dirent, *prev;
+	struct ext2_dir_entry 	*dirent, *prev, dot, dotdot;
 	ext2_dirhash_t		hash;
 	unsigned int		offset = 0;
 	int			dir_modified = 0;
@@ -761,6 +770,8 @@ static int check_dir_block(ext2_filsys fs,
 	int	dx_csum_size = 0, de_csum_size = 0;
 	int	failed_csum = 0;
 	int	is_leaf = 1;
+	int	inline_data_size = 0;
+	int	filetype = 0;
 
 	cd = (struct check_dir_struct *) priv_data;
 	buf = cd->buf;
@@ -778,6 +789,10 @@ static int check_dir_block(ext2_filsys fs,
 		de_csum_size = sizeof(struct ext2_dir_entry_tail);
 	}
 
+	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+				      EXT2_FEATURE_INCOMPAT_FILETYPE))
+		filetype = EXT2_FT_DIR << 8;
+
 	/*
 	 * Make sure the inode is still in use (could have been
 	 * deleted in the duplicate/bad blocks pass.
@@ -792,7 +807,16 @@ static int check_dir_block(ext2_filsys fs,
 	cd->pctx.dirent = 0;
 	cd->pctx.num = 0;
 
-	if (db->blk == 0) {
+	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+				      EXT4_FEATURE_INCOMPAT_INLINE_DATA)) {
+		errcode_t ec;
+
+		ec = ext2fs_inline_data_size(fs, ino, &inline_data_size);
+		if (ec && ec != EXT2_ET_NO_INLINE_DATA)
+			return DIRENT_ABORT;
+	}
+
+	if (db->blk == 0 && !inline_data_size) {
 		if (allocate_dir_block(ctx, db, buf, &cd->pctx))
 			return 0;
 		block_nr = db->blk;
@@ -813,7 +837,11 @@ static int check_dir_block(ext2_filsys fs,
 #endif
 
 	ehandler_operation(_("reading directory block"));
-	cd->pctx.errcode = ext2fs_read_dir_block4(fs, block_nr, buf, 0, ino);
+	if (inline_data_size)
+		cd->pctx.errcode = ext2fs_inline_data_get(fs, ino, 0, buf, 0);
+	else
+		cd->pctx.errcode = ext2fs_read_dir_block4(fs, block_nr,
+							  buf, 0, ino);
 	ehandler_operation(0);
 	if (cd->pctx.errcode == EXT2_ET_DIR_CORRUPTED)
 		cd->pctx.errcode = 0; /* We'll handle this ourselves */
@@ -884,7 +912,7 @@ out_htree:
 #endif /* ENABLE_HTREE */
 
 	/* Verify checksum. */
-	if (is_leaf && de_csum_size) {
+	if (is_leaf && de_csum_size && !inline_data_size) {
 		/* No space for csum?  Rebuild dirs in pass 3A. */
 		if (!ext2fs_dirent_has_tail(fs, (struct ext2_dir_entry *)buf)) {
 			de_csum_size = 0;
@@ -923,20 +951,44 @@ skip_checksum:
 		unsigned int name_len;
 
 		problem = 0;
-		dirent = (struct ext2_dir_entry *) (buf + offset);
-		(void) ext2fs_get_rec_len(fs, dirent, &rec_len);
-		cd->pctx.dirent = dirent;
-		cd->pctx.num = offset;
-		if (((offset + rec_len) > fs->blocksize) ||
-		    (rec_len < 12) ||
-		    ((rec_len % 4) != 0) ||
-		    ((ext2fs_dirent_name_len(dirent) + 8) > rec_len)) {
-			if (fix_problem(ctx, PR_2_DIR_CORRUPTED, &cd->pctx)) {
-				salvage_directory(fs, dirent, prev, &offset);
-				dir_modified++;
-				continue;
-			} else
-				goto abort_free_dict;
+		if (!inline_data_size || dot_state > 1) {
+			dirent = (struct ext2_dir_entry *) (buf + offset);
+			(void) ext2fs_get_rec_len(fs, dirent, &rec_len);
+			cd->pctx.dirent = dirent;
+			cd->pctx.num = offset;
+			if (((offset + rec_len) > fs->blocksize) ||
+			    (rec_len < 12) ||
+			    ((rec_len % 4) != 0) ||
+			    ((ext2fs_dirent_name_len(dirent) + 8) > rec_len)) {
+				if (fix_problem(ctx, PR_2_DIR_CORRUPTED, &cd->pctx)) {
+					salvage_directory(fs, dirent, prev, &offset);
+					dir_modified++;
+					continue;
+				} else
+					goto abort_free_dict;
+			}
+		} else {
+			if (dot_state == 0) {
+				memset(&dot, 0, sizeof(dot));
+				dirent = &dot;
+				dirent->inode = ino;
+				dirent->rec_len = EXT2_DIR_REC_LEN(1);
+				dirent->name_len = 1 | filetype;
+				dirent->name[0] = '.';
+			} else if (dot_state == 1) {
+				memset(&dotdot, 0, sizeof(dotdot));
+				dirent = &dotdot;
+				dirent->inode =
+					((struct ext2_dir_entry *)buf)->inode;
+				dirent->rec_len = EXT2_DIR_REC_LEN(2);
+				dirent->name_len = 2 | filetype;
+				dirent->name[0] = '.';
+				dirent->name[1] = '.';
+			} else {
+				fatal_error(ctx, _("Can not continue."));
+			}
+			cd->pctx.dirent = dirent;
+			cd->pctx.num = offset;
 		}
 
 		if (dot_state == 0) {
@@ -1175,9 +1227,14 @@ skip_checksum:
 		prev = dirent;
 		if (dir_modified)
 			(void) ext2fs_get_rec_len(fs, dirent, &rec_len);
-		offset += rec_len;
+		if (!inline_data_size || dot_state > 1) {
+			offset += rec_len;
+		} else {
+			if (dot_state == 1)
+				offset = 4;
+		}
 		dot_state++;
-	} while (offset < fs->blocksize - de_csum_size);
+	} while (is_last_entry(fs, inline_data_size, offset, de_csum_size));
 #if 0
 	printf("\n");
 #endif
@@ -1195,12 +1252,22 @@ skip_checksum:
 	}
 #endif /* ENABLE_HTREE */
 
-	if (offset != fs->blocksize - de_csum_size) {
-		cd->pctx.num = rec_len - (fs->blocksize - de_csum_size) +
-			       offset;
-		if (fix_problem(ctx, PR_2_FINAL_RECLEN, &cd->pctx)) {
-			dirent->rec_len = cd->pctx.num;
-			dir_modified++;
+	if (inline_data_size) {
+		if (offset != inline_data_size) {
+			cd->pctx.num = rec_len + offset - inline_data_size;
+			if (fix_problem(ctx, PR_2_FINAL_RECLEN, &cd->pctx)) {
+				dirent->rec_len = cd->pctx.num;
+				dir_modified++;
+			}
+		}
+	} else {
+		if (offset != fs->blocksize - de_csum_size) {
+			cd->pctx.num = rec_len - (fs->blocksize - de_csum_size) +
+				       offset;
+			if (fix_problem(ctx, PR_2_FINAL_RECLEN, &cd->pctx)) {
+				dirent->rec_len = cd->pctx.num;
+				dir_modified++;
+			}
 		}
 	}
 	if (dir_modified) {
@@ -1214,8 +1281,13 @@ skip_checksum:
 write_and_fix:
 		if (e2fsck_dir_will_be_rehashed(ctx, ino))
 			ctx->fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
-		cd->pctx.errcode = ext2fs_write_dir_block4(fs, block_nr, buf,
-							   0, ino);
+		if (inline_data_size) {
+			cd->pctx.errcode =
+				ext2fs_inline_data_set(fs, ino, 0, buf,
+						       inline_data_size);
+		} else
+			cd->pctx.errcode = ext2fs_write_dir_block4(fs, block_nr,
+								   buf, 0, ino);
 		if (e2fsck_dir_will_be_rehashed(ctx, ino))
 			ctx->fs->flags &= ~EXT2_FLAG_IGNORE_CSUM_ERRORS;
 		if (cd->pctx.errcode) {
-- 
1.7.9.7

