Return-Path: <SRS0=tjTT=QF=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 230D3C169C4
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jan 2019 17:52:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1F9F2175B
	for <linux-ext4@archiver.kernel.org>; Tue, 29 Jan 2019 17:52:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nDbDU/wF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbfA2RwG (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 29 Jan 2019 12:52:06 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:33057 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727100AbfA2RwG (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Jan 2019 12:52:06 -0500
Received: by mail-it1-f196.google.com with SMTP id m8so14427306itk.0
        for <linux-ext4@vger.kernel.org>; Tue, 29 Jan 2019 09:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UZ69tAKjh5RWpDlInkgxmxiIEXMar0/eXbKNKxDLgRU=;
        b=nDbDU/wFxOgzxQC8ZqMAl+kUBBiBZ5u+UxQ9LhNjkyCDpA/3rHSI5d3J1wEpUqTVum
         cZm+GRNc3ob87zQTm14XGvfmBD/VVCi1mfcW6hjdnGMLHoV8I5EsngJg4SVXcCGLGmRM
         9n4EBrdSi04FIMeHUHy27XYxUNruar0YD05vfm0KOgIGo/7WvE9XZEciljk57kbbVb/u
         oxEiXyE5OP3TJJm9J0yR8eSZKQiMp6Z3P4piUUAM0Nguifh34R8KX+5Ojur0GdBnPtCL
         +DhtcoRpNvgqnZ53diwkNj0GRjtH9GvynIaZMJUXWZuLfFS0tSQplpvOKfzt7j+H59wo
         1n7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UZ69tAKjh5RWpDlInkgxmxiIEXMar0/eXbKNKxDLgRU=;
        b=i0VzNVXvcFTIBC6ts82qSC6+ood/5c0NEzaDXoDXYcqDdY1qER87VrEafCA885+HTf
         4+jaqFxPIh0g5yg2Hn2mfx6M5bf5MQq/7BOVWZoObVAdgbEdVp9qbZIyIBF2ztT39Hwt
         j0MHYZ1JGStjYAqLlwbbH0gpsI1iaFo9dtK0ptGcq7MllpbILLsILnUG2TQPh37yY4GH
         MTQPg3X15V+37Hp/QAgKWkSkGACHykANQfMs8a9HEpAZ5TueLAZoP3Os5egfZXgXpJpN
         MHxV+T9ygEauvXGqSvfDAGqWx+ZS5RX/yfvsPMZEHpp8PqaXIIKzlj4PIPOvex/6mzQt
         AI5Q==
X-Gm-Message-State: AJcUukdNsdjv5yK1ldIk5TlLylgIHtnzpOKF9d0oIkex9W+sxUlVSAcD
        RR0FxUyeMtNvF/ZIgF03mhUgOgySaUc=
X-Google-Smtp-Source: ALg8bN48R0ogfQACg5wsPrNfVj7PBByepHXJvp9EHq5X+uLOcFnJbgXWCjn1ePZSVJ7o+HfxIr6Q7A==
X-Received: by 2002:a24:4e55:: with SMTP id r82mr15011552ita.128.1548784324493;
        Tue, 29 Jan 2019 09:52:04 -0800 (PST)
Received: from C02TN4C6HTD6.us.cray.com ([63.239.150.218])
        by smtp.gmail.com with ESMTPSA id b5sm15838778ioc.21.2019.01.29.09.52.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Jan 2019 09:52:04 -0800 (PST)
From:   Artem Blagodarenko <artem.blagodarenko@gmail.com>
X-Google-Original-From: Artem Blagodarenko <c17828@cray.com>
To:     linux-ext4@vger.kernel.org
Cc:     adilger.kernel@dilger.ca
Subject: [PATCH v7 4/4] ext2fs: automaticlly open backup superblocks
Date:   Tue, 29 Jan 2019 20:51:34 +0300
Message-Id: <20190129175134.26652-5-c17828@cray.com>
X-Mailer: git-send-email 2.14.3
In-Reply-To: <20190129175134.26652-1-c17828@cray.com>
References: <20190129175134.26652-1-c17828@cray.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

e2image and e2fsck automatically try to open some backup superblocks,
if only blocksize is set or passed superblock can't be opened.
Try few backup superblocks (e.g. {1, 3, 5, 7, 9} * blocksize * 8).

This code is moved to lib/support/.

Signed-off-by: Artem Blagodarenko <c17828@cray.com>
---
 e2fsck/e2fsck.h         |   2 -
 e2fsck/message.c        |   3 +-
 e2fsck/unix.c           |  14 +++--
 e2fsck/util.c           |  73 -------------------------
 lib/support/Makefile.in |   8 ++-
 lib/support/sb_backup.c | 140 ++++++++++++++++++++++++++++++++++++++++++++++++
 lib/support/sb_backup.h |  20 +++++++
 misc/e2image.c          |   7 +++
 8 files changed, 185 insertions(+), 82 deletions(-)

diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index 1c7a67cb..8576ef24 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -633,8 +633,6 @@ extern void e2fsck_write_inode_full(e2fsck_t ctx, unsigned long ino,
 #ifdef MTRACE
 extern void mtrace_print(char *mesg);
 #endif
-extern blk64_t get_backup_sb(e2fsck_t ctx, ext2_filsys fs,
-			   const char *name, io_manager manager);
 extern int ext2_file_type(unsigned int mode);
 extern int write_all(int fd, char *buf, size_t count);
 void dump_mmp_msg(struct mmp_struct *mmp, const char *fmt, ...)
diff --git a/e2fsck/message.c b/e2fsck/message.c
index 727f71d5..ffb40730 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -465,7 +465,8 @@ static _INLINE_ void expand_percent_expression(FILE *f, ext2_filsys fs,
 		fprintf(f, "%*lld", width, (long long) ctx->blkcount);
 		break;
 	case 'S':
-		fprintf(f, "%llu", get_backup_sb(NULL, fs, NULL, NULL));
+		fprintf(f, "%llu", get_first_backup_sb(NULL, NULL, fs,
+						       NULL, NULL));
 		break;
 	case 's':
 		fprintf(f, "%*s", width, ctx->str ? ctx->str : "NULL");
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index ddcf52a4..4ffc039e 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1489,11 +1489,17 @@ restart:
 				retval ? _("Superblock invalid,") :
 				_("Group descriptors look bad..."));
 			orig_superblock = ctx->superblock;
-			get_backup_sb(ctx, fs, ctx->filesystem_name, io_ptr);
-			if (fs)
-				ext2fs_close_free(&fs);
 			orig_retval = retval;
-			retval = try_open_fs(ctx, flags, io_ptr, &fs);
+			retval = try_backups(ctx->filesystem_name,
+					     ctx->io_options,
+					     flags, &ctx->superblock,
+					     &ctx->blocksize, io_ptr, &fs);
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
index db6a1cc1..e2caf3a2 100644
--- a/e2fsck/util.c
+++ b/e2fsck/util.c
@@ -549,79 +549,6 @@ void mtrace_print(char *mesg)
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
diff --git a/lib/support/Makefile.in b/lib/support/Makefile.in
index 1d278642..03fdf555 100644
--- a/lib/support/Makefile.in
+++ b/lib/support/Makefile.in
@@ -22,7 +22,8 @@ OBJS=		cstring.o \
 		quotaio.o \
 		quotaio_v2.o \
 		quotaio_tree.o \
-		dict.o
+		dict.o \
+		sb_backup.o
 
 SRCS=		$(srcdir)/argv_parse.c \
 		$(srcdir)/cstring.c \
@@ -35,7 +36,8 @@ SRCS=		$(srcdir)/argv_parse.c \
 		$(srcdir)/quotaio.c \
 		$(srcdir)/quotaio_tree.c \
 		$(srcdir)/quotaio_v2.c \
-		$(srcdir)/dict.c
+		$(srcdir)/dict.c \
+		$(srcdir)/sb_backup.c
 
 LIBRARY= libsupport
 LIBDIR= support
@@ -168,3 +170,5 @@ quotaio_v2.o: $(srcdir)/quotaio_v2.c $(top_builddir)/lib/config.h \
  $(srcdir)/quotaio_tree.h
 dict.o: $(srcdir)/dict.c $(top_builddir)/lib/config.h \
  $(top_builddir)/lib/dirpaths.h $(srcdir)/dict.h
+sb_backup.o: $(srcdir)/sb_backup.c $(top_builddir)/lib/config.h \
+ $(srcdir)/sb_backup.h
diff --git a/lib/support/sb_backup.c b/lib/support/sb_backup.c
new file mode 100644
index 00000000..cfa671e5
--- /dev/null
+++ b/lib/support/sb_backup.c
@@ -0,0 +1,140 @@
+/*
+ * sb_backup.c -- helper functions for getting backup superblocks 
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Library
+ * General Public License, version 2.
+ * %End-Header%
+ */
+
+
+#include "config.h"
+#include <stdio.h>
+#include <string.h>
+
+#include "ext2fs/ext2_fs.h"
+#include "ext2fs/ext2fs.h"
+
+blk64_t get_first_backup_sb(blk64_t *superblock, unsigned int *block_size,
+			    ext2_filsys fs, const char *name,
+			    io_manager manager)
+{
+	struct ext2_super_block *sb;
+	io_channel		io = NULL;
+	void			*buf = NULL;
+	int			try_blocksize;
+	blk64_t			try_superblock, ret_sb = 8193;
+
+	/* superblock and block_size can be NULL if fs->super is passed */
+	if (fs && fs->super) {
+		ret_sb = fs->super->s_blocks_per_group +
+			  fs->super->s_first_data_block;
+		if (superblock)
+			*superblock = ret_sb;
+		if (block_size)
+			*block_size = fs->blocksize;
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
+errcode_t try_backups(const char *name, const char *io_options,
+		      int flags, blk64_t *superblock,
+		      unsigned int *block_size, io_manager manager,
+		      ext2_filsys *ret_fs)
+{
+	errcode_t retval, retval2;
+	blk64_t try_block_number;
+	unsigned int i;
+
+	/*
+	 * Get first superblock location based on heuristic.
+	 * Blocksize is also returned and used to find next
+	 * superblock copy location.
+	 */
+	try_block_number = get_first_backup_sb(superblock, block_size,
+					       *ret_fs, name, manager);
+	retval = ext2fs_open2(name, io_options, flags, try_block_number,
+			      *block_size, manager, ret_fs);
+	if (!retval)
+		return 0;
+
+	/*
+	 * Try 3d, 5th, 7th, 9th superblock copy
+	 */
+	for (i = 3; i <= 9; i += 2) {
+		try_block_number = (i * (*block_size) * 8);
+		if (*block_size == 1024)
+			try_block_number++;
+		if (*ret_fs) {
+			ext2fs_free(*ret_fs);
+			*ret_fs = NULL;
+		}
+		retval2 = ext2fs_open2(name, io_options, flags,
+				      try_block_number, *block_size, manager,
+				      ret_fs);
+		/*
+		 * Partition is too small to have this superblock copy.
+		 * Return previous reading return code
+		 */
+		if (retval2 == EXT2_ET_SHORT_READ)
+			break;
+
+		retval = retval2;
+		if (!retval) {
+			*superblock = try_block_number;
+			break;
+		}
+	}
+
+	return retval;
+}
diff --git a/lib/support/sb_backup.h b/lib/support/sb_backup.h
new file mode 100644
index 00000000..1e18e37c
--- /dev/null
+++ b/lib/support/sb_backup.h
@@ -0,0 +1,20 @@
+/*
+ * sb_backup.h -- helper functions for getting backup superblocks
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU Library
+ * General Public License, version 2.
+ * %End-Header%
+ */
+
+#include "ext2fs/ext2_fs.h"
+#include "ext2fs/ext2fs.h"
+
+blk64_t get_first_backup_sb(blk64_t *superblock, unsigned int *block_size,
+			    ext2_filsys fs, const char *name,
+			    io_manager manager);
+
+errcode_t try_backups(const char *name, const char *io_options,
+		      int flags, blk64_t *superblock,
+		      unsigned int *block_size, io_manager manager,
+		      ext2_filsys *ret_fs);
diff --git a/misc/e2image.c b/misc/e2image.c
index 3c881fee..786282ec 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -1623,6 +1623,13 @@ int main (int argc, char ** argv)
 	sprintf(offset_opt, "offset=%llu", source_offset);
 	retval = ext2fs_open2(device_name, offset_opt, open_flag,
 			      superblock, blocksize, unix_io_manager, &fs);
+	if (retval & (superblock | blocksize)) {
+		printf(_("Try backups in other location.\n"));
+		retval = try_backups(device_name, offset_opt, open_flag,
+				     &superblock, &blocksize,
+				     unix_io_manager, &fs);
+		printf(_("Use superblock %i.\n"), superblock);
+	}
         if (retval) {
 		com_err (program_name, retval, _("while trying to open %s"),
 			 device_name);
-- 
2.14.3

