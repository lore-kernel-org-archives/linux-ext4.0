From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v3 4/4] ext2fs: automaticlly open backup superblocks
Date: Mon,  4 Dec 2017 22:35:30 +0300
Message-ID: <20171204193530.54888-5-artem.blagodarenko@gmail.com>
References: <20171204193530.54888-1-artem.blagodarenko@gmail.com>
Cc: adilger.kernel@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:46033 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751104AbdLDTfq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Dec 2017 14:35:46 -0500
Received: by mail-lf0-f67.google.com with SMTP id f13so20450834lff.12
        for <linux-ext4@vger.kernel.org>; Mon, 04 Dec 2017 11:35:45 -0800 (PST)
In-Reply-To: <20171204193530.54888-1-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

e2image and e2fsck automatically try to open some backup superblocks,
if only blocksize is set or passed superblock can't be opened.
Try few backup superblocks (e.g. {1, 3, 5,7, 9} * blocksize * 8).

This code is moved to library.

Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 e2fsck/e2fsck.h     |   2 -
 e2fsck/message.c    |   3 +-
 e2fsck/unix.c       |  16 ++++++--
 e2fsck/util.c       |  73 ---------------------------------
 lib/ext2fs/ext2fs.h |   8 ++++
 lib/ext2fs/openfs.c | 116 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 misc/e2image.c      |  10 ++++-
 7 files changed, 146 insertions(+), 82 deletions(-)

diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index 9eee4bc2..9cd3910e 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -634,8 +634,6 @@ extern void e2fsck_write_inode_full(e2fsck_t ctx, unsigned long ino,
 #ifdef MTRACE
 extern void mtrace_print(char *mesg);
 #endif
-extern blk64_t get_backup_sb(e2fsck_t ctx, ext2_filsys fs,
-			   const char *name, io_manager manager);
 extern int ext2_file_type(unsigned int mode);
 extern int write_all(int fd, char *buf, size_t count);
 void dump_mmp_msg(struct mmp_struct *mmp, const char *msg);
diff --git a/e2fsck/message.c b/e2fsck/message.c
index 727f71d5..df408917 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -465,7 +465,8 @@ static _INLINE_ void expand_percent_expression(FILE *f, ext2_filsys fs,
 		fprintf(f, "%*lld", width, (long long) ctx->blkcount);
 		break;
 	case 'S':
-		fprintf(f, "%llu", get_backup_sb(NULL, fs, NULL, NULL));
+		fprintf(f, "%llu", ext2fs_first_backup_sb(NULL, NULL, fs,
+							  NULL, NULL));
 		break;
 	case 's':
 		fprintf(f, "%*s", width, ctx->str ? ctx->str : "NULL");
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 2865f37a..888a2fce 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1471,11 +1471,19 @@ restart:
 				retval ? _("Superblock invalid,") :
 				_("Group descriptors look bad..."));
 			orig_superblock = ctx->superblock;
-			get_backup_sb(ctx, fs, ctx->filesystem_name, io_ptr);
-			if (fs)
-				ext2fs_close_free(&fs);
 			orig_retval = retval;
-			retval = try_open_fs(ctx, flags, io_ptr, &fs);
+			retval = ext2fs_try_backups(ctx->filesystem_name,
+						    ctx->io_options,
+						    flags,
+						    &ctx->superblock,
+						    &ctx->blocksize, io_ptr,
+						    &fs);
+			if (retval == 0) {
+				fs->priv_data = ctx;
+				e2fsck_set_bitmap_type(fs,
+						       EXT2FS_BMAP64_RBTREE,
+						       "default", NULL);
+			}
 			if ((orig_retval == 0) && retval != 0) {
 				if (fs)
 					ext2fs_close_free(&fs);
diff --git a/e2fsck/util.c b/e2fsck/util.c
index ed947025..b1c638c5 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -548,79 +548,6 @@ void mtrace_print(char *mesg)
 }
 #endif
 
-blk64_t get_backup_sb(e2fsck_t ctx, ext2_filsys fs, const char *name,
-		      io_manager manager)
-{
-	struct ext2_super_block *sb;
-	io_channel		io = NULL;
-	void			*buf = NULL;
-	int			blocksize;
-	blk64_t			superblock, ret_sb = 8193;
-
-	if (fs && fs->super) {
-		ret_sb = (fs->super->s_blocks_per_group +
-			  fs->super->s_first_data_block);
-		if (ctx) {
-			ctx->superblock = ret_sb;
-			ctx->blocksize = fs->blocksize;
-		}
-		return ret_sb;
-	}
-
-	if (ctx) {
-		if (ctx->blocksize) {
-			ret_sb = ctx->blocksize * 8;
-			if (ctx->blocksize == 1024)
-				ret_sb++;
-			ctx->superblock = ret_sb;
-			return ret_sb;
-		}
-		ctx->superblock = ret_sb;
-		ctx->blocksize = 1024;
-	}
-
-	if (!name || !manager)
-		goto cleanup;
-
-	if (manager->open(name, 0, &io) != 0)
-		goto cleanup;
-
-	if (ext2fs_get_mem(SUPERBLOCK_SIZE, &buf))
-		goto cleanup;
-	sb = (struct ext2_super_block *) buf;
-
-	for (blocksize = EXT2_MIN_BLOCK_SIZE;
-	     blocksize <= EXT2_MAX_BLOCK_SIZE ; blocksize *= 2) {
-		superblock = blocksize*8;
-		if (blocksize == 1024)
-			superblock++;
-		io_channel_set_blksize(io, blocksize);
-		if (io_channel_read_blk64(io, superblock,
-					-SUPERBLOCK_SIZE, buf))
-			continue;
-#ifdef WORDS_BIGENDIAN
-		if (sb->s_magic == ext2fs_swab16(EXT2_SUPER_MAGIC))
-			ext2fs_swap_super(sb);
-#endif
-		if ((sb->s_magic == EXT2_SUPER_MAGIC) &&
-		    (EXT2_BLOCK_SIZE(sb) == blocksize)) {
-			ret_sb = superblock;
-			if (ctx) {
-				ctx->superblock = superblock;
-				ctx->blocksize = blocksize;
-			}
-			break;
-		}
-	}
-
-cleanup:
-	if (io)
-		io_channel_close(io);
-	if (buf)
-		ext2fs_free_mem(&buf);
-	return (ret_sb);
-}
-
 /*
  * Given a mode, return the ext2 file type
  */
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 6774e32c..942b46ea 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1584,6 +1584,14 @@ extern int ext2fs_journal_sb_start(int blocksize);
 extern errcode_t ext2fs_open(const char *name, int flags, int superblock,
 			     unsigned int block_size, io_manager manager,
 			     ext2_filsys *ret_fs);
+extern blk64_t ext2fs_first_backup_sb(blk64_t *superblock,
+				      unsigned int *blocksize,
+				      ext2_filsys fs, const char *name,
+				      io_manager manager);
+extern errcode_t ext2fs_try_backups(const char *name, const char *io_options,
+				    int flags, blk64_t *superblock,
+				    unsigned int *block_size,
+				    io_manager manager, ext2_filsys *ret_fs);
 extern errcode_t ext2fs_open2(const char *name, const char *io_options,
 			      int flags, int superblock,
 			      unsigned int block_size, io_manager manager,
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 585ad766..d0e1d3bd 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -497,6 +497,122 @@ cleanup:
 	return retval;
 }
 
+blk64_t ext2fs_first_backup_sb(blk64_t *superblock, unsigned int *block_size,
+			       ext2_filsys fs, const char *name,
+			       io_manager manager)
+{
+	struct ext2_super_block *sb;
+	io_channel		io = NULL;
+	void			*buf = NULL;
+	int			try_blocksize;
+	blk64_t			try_superblock, ret_sb = 8193;
+
+	if (fs && fs->super) {
+		ret_sb = (fs->super->s_blocks_per_group +
+			  fs->super->s_first_data_block);
+		*superblock = ret_sb;
+		*block_size = fs->blocksize;
+		return ret_sb;
+	}
+
+	if (*block_size) {
+		ret_sb = *block_size * 8;
+		if (*block_size == 1024)
+			ret_sb++;
+		*superblock = ret_sb;
+		return ret_sb;
+	}
+
+	*superblock = ret_sb;
+	*block_size = 1024;
+
+	if (!name || !manager)
+		goto cleanup;
+
+	if (manager->open(name, 0, &io) != 0)
+		goto cleanup;
+
+	if (ext2fs_get_mem(SUPERBLOCK_SIZE, &buf))
+		goto cleanup;
+	sb = (struct ext2_super_block *) buf;
+
+	for (try_blocksize = EXT2_MIN_BLOCK_SIZE;
+	     try_blocksize <= EXT2_MAX_BLOCK_SIZE ; try_blocksize *= 2) {
+		try_superblock = try_blocksize*8;
+		if (try_blocksize == 1024)
+			try_superblock++;
+		io_channel_set_blksize(io, try_blocksize);
+		if (io_channel_read_blk64(io, try_superblock,
+					-SUPERBLOCK_SIZE, buf))
+			continue;
+#ifdef WORDS_BIGENDIAN
+		if (sb->s_magic == ext2fs_swab16(EXT2_SUPER_MAGIC))
+			ext2fs_swap_super(sb);
+#endif
+		if ((sb->s_magic == EXT2_SUPER_MAGIC) &&
+		    (EXT2_BLOCK_SIZE(sb) == try_blocksize)) {
+			ret_sb = try_superblock;
+			*superblock = try_superblock;
+			*block_size = try_blocksize;
+			break;
+		}
+	}
+
+cleanup:
+	if (io)
+		io_channel_close(io);
+	if (buf)
+		ext2fs_free_mem(&buf);
+	return ret_sb;
+}
+
+errcode_t ext2fs_try_backups(const char *name, const char *io_options,
+			    int flags, blk64_t *superblock,
+			    unsigned int *block_size, io_manager manager,
+			    ext2_filsys *ret_fs)
+{
+	errcode_t retval;
+	blk64_t try_block_number;
+	unsigned int i;
+
+	/*
+	 * Get first superblock location based on heuristic.
+	 * Blocksize is also returned and used to find next
+	 * superblock copy location.
+	 */
+	try_block_number = ext2fs_first_backup_sb(superblock, block_size,
+						  *ret_fs, name, manager);
+	retval = ext2fs_open2(name,
+			      io_options, flags,
+			      try_block_number, *block_size,
+			      manager, ret_fs);
+	if (!retval)
+		return 0;
+
+	/*
+	 * Trt 3d, 5th, 7th, 9th superblock copy
+	 */
+	for (i = 3; i <= 9; i += 2) {
+		try_block_number = (i * (*block_size) * 8);
+		if (*block_size == 1024)
+			try_block_number++;
+		if (*ret_fs) {
+			ext2fs_free(*ret_fs);
+			*ret_fs = NULL;
+		}
+		retval = ext2fs_open2(name,
+				      io_options, flags,
+				      try_block_number, *block_size,
+				      manager, ret_fs);
+		if (!retval) {
+			*superblock = try_block_number;
+			break;
+		}
+	}
+
+	return retval;
+}
+
 errcode_t ext2fs_open2(const char *name, const char *io_options,
 		       int flags, int superblock,
 		       unsigned int block_size, io_manager manager,
diff --git a/misc/e2image.c b/misc/e2image.c
index b1b7a17d..069768e1 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -1611,8 +1611,14 @@ int main (int argc, char ** argv)
 	}
 	sprintf(offset_opt, "offset=%llu", source_offset);
 	retval = ext2fs_open2(device_name, offset_opt, open_flag,
-				    superblock, blocksize, unix_io_manager,
-				    &fs);
+			      superblock, blocksize, unix_io_manager, &fs);
+	if (retval & (superblock | blocksize)) {
+		printf(_("Try backups in other location.\n"));
+		retval = ext2fs_try_backups(device_name, offset_opt, open_flag,
+					    &superblock, &blocksize,
+					    unix_io_manager, &fs);
+		printf(_("Use superblock %i.\n"), superblock);
+	}
         if (retval) {
 		com_err (program_name, retval, _("while trying to open %s"),
 			 device_name);
-- 
2.13.6 (Apple Git-96)
