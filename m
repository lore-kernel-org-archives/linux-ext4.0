From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 13/49] libext2fs: repair side effects when iterating dirents
 in inline dirs
Date: Mon, 10 Mar 2014 23:55:21 -0700
Message-ID: <20140311065521.30585.9816.stgit@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32377 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823AbaCKGzZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 02:55:25 -0400
In-Reply-To: <20140311065356.30585.47192.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In ext2fs_inline_data_dir_iterate(), we must be very careful to undo
any modifications we make to the dir_context pointer passed in by the
caller, because it's entirely possible that the caller will still want
to do something with the ctx or something inside.

Specifically, ext2fs_dblist_dir_iterate() wants to be able to free
ctx->buf, and it reuses the ctx for multiple dblist entries.  That
means that assigning ctx->buf will cause weird crashes at the end of
dir_iterate().

Since we're being careful with ctx, we might as well handle adding the
INLINE_DATA flag to ctx->flags for ext2fs_process_dir_block, since the
dblist caller forgets to unset the flag before reusing the ctx.

This fixes some crashes and valgrind complaints in resize2fs, and is
necessary for the next patch, which fixes resize2fs not to corrupt
inline_data filesystems.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/dblist_dir.c  |    6 ++----
 lib/ext2fs/dir_iterate.c |    1 -
 lib/ext2fs/inline_data.c |   12 ++++++++++--
 3 files changed, 12 insertions(+), 7 deletions(-)


diff --git a/lib/ext2fs/dblist_dir.c b/lib/ext2fs/dblist_dir.c
index 2fbb772..864a3ca 100644
--- a/lib/ext2fs/dblist_dir.c
+++ b/lib/ext2fs/dblist_dir.c
@@ -76,14 +76,12 @@ static int db_dir_proc(ext2_filsys fs, struct ext2_db_entry2 *db_info,
 	ctx->errcode = ext2fs_read_inode(fs, ctx->dir, &inode);
 	if (ctx->errcode)
 		return DBLIST_ABORT;
-	if (inode.i_flags & EXT4_INLINE_DATA_FL) {
-		ctx->flags = DIRENT_FLAG_INCLUDE_INLINE_DATA;
+	if (inode.i_flags & EXT4_INLINE_DATA_FL)
 		ret = ext2fs_inline_data_dir_iterate(fs, ctx->dir, ctx);
-	} else {
+	else
 		ret = ext2fs_process_dir_block(fs, &db_info->blk,
 					       db_info->blockcnt, 0, 0,
 					       priv_data);
-	}
 	if ((ret & BLOCK_ABORT) && !ctx->errcode)
 		return DBLIST_ABORT;
 	return 0;
diff --git a/lib/ext2fs/dir_iterate.c b/lib/ext2fs/dir_iterate.c
index 8cb6740..67152cc 100644
--- a/lib/ext2fs/dir_iterate.c
+++ b/lib/ext2fs/dir_iterate.c
@@ -128,7 +128,6 @@ errcode_t ext2fs_dir_iterate2(ext2_filsys fs,
 	if (!block_buf)
 		ext2fs_free_mem(&ctx.buf);
 	if (retval == EXT2_ET_INLINE_DATA_CANT_ITERATE) {
-		ctx.flags |= DIRENT_FLAG_INCLUDE_INLINE_DATA;
 		(void) ext2fs_inline_data_dir_iterate(fs, dir, &ctx);
 		retval = 0;
 	}
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index f3cd375..7be0f96 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -120,8 +120,15 @@ int ext2fs_inline_data_dir_iterate(ext2_filsys fs, ext2_ino_t ino,
 	struct ext2_inline_data data;
 	int ret = BLOCK_ABORT;
 	e2_blkcnt_t blockcnt = 0;
+	char *old_buf;
+	unsigned int old_buflen;
+	int old_flags;
 
 	ctx = (struct dir_context *)priv_data;
+	old_buf = ctx->buf;
+	old_buflen = ctx->buflen;
+	old_flags = ctx->flags;
+	ctx->flags |= DIRENT_FLAG_INCLUDE_INLINE_DATA;
 
 	ctx->errcode = ext2fs_read_inode(fs, ino, &inode);
 	if (ctx->errcode)
@@ -235,9 +242,10 @@ int ext2fs_inline_data_dir_iterate(ext2_filsys fs, ext2_ino_t ino,
 
 out1:
 	ext2fs_free_mem(&data.ea_data);
-	ctx->buf = 0;
