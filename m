From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 05/21] misc: fix various endianness problems with inline_data
Date: Mon, 04 Aug 2014 18:05:30 -0700
Message-ID: <20140805010530.2611.80567.stgit@birch.djwong.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40175 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbaHEBFe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2014 21:05:34 -0400
In-Reply-To: <20140805010457.2611.89813.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The inline data code fails to perform endianness conversions correctly
or at all in a number of places, so fix this so that big-endian
machines function properly.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass2.c           |   25 +++++++++++++++++++++++--
 lib/ext2fs/inline_data.c |    5 ++++-
 lib/ext2fs/newdir.c      |    9 +++++++++
 3 files changed, 36 insertions(+), 3 deletions(-)


diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index e968831..38bf37a 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -870,11 +870,21 @@ static int check_dir_block(ext2_filsys fs,
 #endif
 
 	ehandler_operation(_("reading directory block"));
-	if (inline_data_size)
+	if (inline_data_size) {
 		cd->pctx.errcode = ext2fs_inline_data_get(fs, ino, 0, buf, 0);
-	else
+		if (cd->pctx.errcode)
+			goto inline_read_fail;
+#ifdef WORDS_BIGENDIAN
+		*((__u32 *)buf) = ext2fs_le32_to_cpu(*((__u32 *)buf));
+		cd->pctx.errcode = ext2fs_dirent_swab_in2(fs,
+				buf + EXT4_INLINE_DATA_DOTDOT_SIZE,
+				inline_data_size - EXT4_INLINE_DATA_DOTDOT_SIZE,
+				0);
+#endif
+	} else
 		cd->pctx.errcode = ext2fs_read_dir_block4(fs, block_nr,
 							  buf, 0, ino);
+inline_read_fail:
 	ehandler_operation(0);
 	if (cd->pctx.errcode == EXT2_ET_DIR_CORRUPTED)
 		cd->pctx.errcode = 0; /* We'll handle this ourselves */
@@ -1311,6 +1321,17 @@ write_and_fix:
 			ctx->fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
 		}
 		if (inline_data_size) {
+#ifdef WORDS_BIGENDIAN
+			*((__u32 *)buf) = ext2fs_le32_to_cpu(*((__u32 *)buf));
+			cd->pctx.errcode = ext2fs_dirent_swab_out2(fs,
+					buf + EXT4_INLINE_DATA_DOTDOT_SIZE,
+					inline_data_size -
+					EXT4_INLINE_DATA_DOTDOT_SIZE,
+					0);
+			if (cd->pctx.errcode &&
+			    !fix_problem(ctx, PR_2_WRITE_DIRBLOCK, &cd->pctx))
+				goto abort_free_dict;
+#endif
 			cd->pctx.errcode =
 				ext2fs_inline_data_set(fs, ino, 0, buf,
 						       inline_data_size);
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index 19248a0..c188d75 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -361,13 +361,16 @@ ext2fs_inline_data_dir_expand(ext2_filsys fs, ext2_ino_t ino,
 		return retval;
 
 #ifdef WORDS_BIGENDIAN
-	retval = ext2fs_dirent_swab_in2(fs, buf, size, 0);
+	retval = ext2fs_dirent_swab_in2(fs, buf + EXT4_INLINE_DATA_DOTDOT_SIZE,
+					size, 0);
 	if (retval)
 		goto errout;
 #endif
 
 	/* Adjust the rec_len */
 	retval = ext2fs_inline_data_convert_dir(fs, ino, blk_buf, buf, size);
+	if (retval)
+		goto errout;
 	/* Allocate a new block */
 	retval = ext2fs_new_block2(fs, 0, 0, &blk);
 	if (retval)
diff --git a/lib/ext2fs/newdir.c b/lib/ext2fs/newdir.c
index cd32d0a..506d609 100644
--- a/lib/ext2fs/newdir.c
+++ b/lib/ext2fs/newdir.c
@@ -115,6 +115,15 @@ errcode_t ext2fs_new_dir_inline_data(ext2_filsys fs, ext2_ino_t dir_ino,
 	dir->inode = 0;
 	rec_len = EXT4_MIN_INLINE_DATA_SIZE - EXT4_INLINE_DATA_DOTDOT_SIZE;
 	retval = ext2fs_set_rec_len(fs, rec_len, dir);
+	if (retval)
+		goto errout;
+
+#ifdef WORDS_BIGENDIAN
+	retval = ext2fs_dirent_swab_out2(fs, (char *)dir, rec_len, 0);
+	if (retval)
+		goto errout;
+#endif
 
+errout:
 	return retval;
 }

