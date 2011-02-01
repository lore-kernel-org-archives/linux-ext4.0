From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/2] resize2fs: Add discard support
Date: Tue,  1 Feb 2011 18:14:25 +0100
Message-ID: <1296580465-28519-2-git-send-email-lczerner@redhat.com>
References: <1296580465-28519-1-git-send-email-lczerner@redhat.com>
Cc: tytso@MIT.EDU, lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949Ab1BAROc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 1 Feb 2011 12:14:32 -0500
In-Reply-To: <1296580465-28519-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This commit adds two new extended options - discard and nodiscard. When
'-E discard' is specified, resize2fs will attempt to discard the portion
of the device which will be used to extend the file system.

As a side-effect, if the discard also zeroes data (every subsequent read
form discarded block will return zeros) resize2fs will skip inode table
initialization, but still set the EXT2_BG_INODE_ZEROED flag. The default
is 'nodiscard'.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 resize/main.c         |   11 ++++++-
 resize/resize2fs.8.in |   14 +++++++++
 resize/resize2fs.c    |   74 ++++++++++++++++++++++++++++++++++++++++++++++++-
 resize/resize2fs.h    |    3 ++
 4 files changed, 100 insertions(+), 2 deletions(-)

diff --git a/resize/main.c b/resize/main.c
index 0f1a8db..f7e6a0e 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -61,6 +61,9 @@ static errcode_t resize_progress_func(ext2_resize_t rfs, int pass,
 			ext2fs_progress_close(progress);
 		progress = 0;
 		switch (pass) {
+		case E2_RSZ_DISCARD_DEVICE:
+			label = _("Discarding device");
+			break;
 		case E2_RSZ_EXTEND_ITABLE_PASS:
 			label = _("Extending the inode table");
 			break;
@@ -181,6 +184,10 @@ static void parse_extended_opts(int *flags, const char *opts)
 				lazy = 1;
 			if (lazy)
 				*flags |= RESIZE_LAZY_ITABLE_INIT;
+		} else if (!strcmp(token, "discard")) {
+			*flags |= RESIZE_DISCARD;
+		} else if (!strcmp(token, "nodiscard")) {
+			*flags &= ~RESIZE_DISCARD;
 		} else {
 			r_usage++;
 			badopt = token;
@@ -192,7 +199,9 @@ static void parse_extended_opts(int *flags, const char *opts)
 			"and may take an argument which\n"
 			"\tis set off by an equals ('=') sign.\n\n"
 			"Valid extended options are:\n"
-			"\tlazy_itable_init=<0 to disable, 1 to enable>\n\n"),
+			"\tlazy_itable_init=<0 to disable, 1 to enable>\n"
+			"\tdiscard\n"
+			"\tnodiscard\n\n"),
 			badopt ? badopt : "");
 		free(buf);
 		exit(1);
diff --git a/resize/resize2fs.8.in b/resize/resize2fs.8.in
index 448265c..3e47610 100644
--- a/resize/resize2fs.8.in
+++ b/resize/resize2fs.8.in
@@ -148,6 +148,20 @@ resize noticeably, but it requires the kernel to finish
 initializing the filesystem in the background when the filesystem is
 mounted.  If the option value is omitted, it defaults to 1 to
 enable lazy inode table initialization.
+TP
+.BI discard
+Attempt to discard blocks
+.BR resize2fs
+is going to use to extend the filesystem (discarding blocks is useful on solid
+state devices and sparse / thin-provisioned storage) before the resize. If the
+device advertises that discard also zeroes data (any subsequent read after the
+discard and before write returns zero), then mark all not-yet-zeroed inode
+tables as zeroed. This significantly speed up filesystem resize if
+.BR lazy_itable_init
+is not specified.
+.TP
+.BI nodiscard
+Do not attempt to discard blocks before resize. This is the default.
 .SH KNOWN BUGS
 The minimum size of the filesystem as estimated by resize2fs may be
 incorrect, especially for filesystems with 1k and 2k blocksizes.
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 1101364..34ac506 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -66,6 +66,54 @@ static errcode_t fix_sb_journal_backup(ext2_filsys fs);
 #define SUPER_OVERHEAD(fs) (1 + (fs)->desc_blocks +\
 			    (fs)->super->s_reserved_gdt_blocks)
 
+#define DISCARD_STEP_MB		(2048)
+
+static int resize2fs_discard_device(ext2_resize_t rfs, blk64_t start,
+				    blk64_t end)
+{
+	ext2_filsys fs = rfs->new_fs;
+	blk64_t blocks = end - start;
+	blk64_t count = DISCARD_STEP_MB;
+	blk64_t cur = 0;
+	int retval = 0;
+
+	if (start >= end)
+		return -EINVAL;
+
+	count *= (1024 * 1024);
+	count /= fs->blocksize;
+
+	if (rfs->progress) {
+		retval = rfs->progress(rfs, E2_RSZ_DISCARD_DEVICE,
+				       cur, blocks);
+		if (retval)
+			return retval;
+	}
+
+	while (cur < blocks) {
+		if (cur + count > blocks)
+			count = blocks - cur;
+		retval = io_channel_discard(fs->io, start + cur, count,
+					    fs->blocksize);
+		if (retval)
+			break;
+
+		cur += count;
+		if (rfs->progress) {
+			retval = rfs->progress(rfs, E2_RSZ_DISCARD_DEVICE,
+					       cur, blocks);
+			if (retval)
+				break;
+		}
+	}
+
+	if (retval && rfs->progress) {
+		printf(_("\nDiscard Failed - "));
+		printf("%s\n",error_message(retval));
+	}
+	return retval;
+}
+
 /*
  * This is the top-level routine which does the dirty deed....
  */
@@ -103,6 +151,28 @@ errcode_t resize_fs(ext2_filsys fs, blk64_t *new_size, int flags,
 	if (retval)
 		goto errout;
 
+	/*
+	 * Attempt to discard space which we are going to use to extend the
+	 * file system. We do no need to abort file system resize if this
+	 * fails due to EOPNOTSUPP, just clear RESIZE_DISCARD flag
+	 */
+	if ((flags & RESIZE_DISCARD) &&
+	    (*new_size > ext2fs_blocks_count(fs->super))) {
+		if (io_channel_discard_zeroes_data(rfs->new_fs->io))
+			flags |= RESIZE_DISCARD_ZEROES;
+		retval = resize2fs_discard_device(rfs,
+					ext2fs_blocks_count(fs->super),
+					*new_size);
+		if (retval = -EOPNOTSUPP)
+			flags &= ~(RESIZE_DISCARD & RESIZE_DISCARD_ZEROES);
+		else {
+			fprintf(stderr, _("Warning: Something went wrong"
+				"while discarding, maybe due programming"
+				"error, or the device is broken. Exiting!\n"));
+			exit(retval);
+		}
+	}
+
 	retval = adjust_superblock(rfs, *new_size, flags);
 	if (retval)
 		goto errout;
@@ -499,6 +569,8 @@ retry:
 		adjblocks = 0;
 
 		ext2fs_bg_flags_zap(fs, i);
+		if (csum_flag && (flags & RESIZE_DISCARD_ZEROES))
+			ext2fs_bg_flags_set(fs, i, EXT2_BG_INODE_ZEROED);
 		if (csum_flag && (flags & RESIZE_LAZY_ITABLE_INIT))
 			ext2fs_bg_flags_set(fs, i, EXT2_BG_INODE_UNINIT);
 		else if (csum_flag)
@@ -672,7 +744,7 @@ static errcode_t adjust_superblock(ext2_resize_t rfs, blk64_t new_size,
 	if (retval)
 		goto errout;
 
-	if (!(flags & RESIZE_LAZY_ITABLE_INIT))
+	if (!(flags & (RESIZE_LAZY_ITABLE_INIT | RESIZE_DISCARD_ZEROES)))
 		retval = write_inode_tables(rfs, fs);
 errout:
 	return retval;
diff --git a/resize/resize2fs.h b/resize/resize2fs.h
index a968071..d9aee33 100644
--- a/resize/resize2fs.h
+++ b/resize/resize2fs.h
@@ -80,6 +80,8 @@ typedef struct ext2_sim_progress *ext2_sim_progmeter;
 #define RESIZE_PERCENT_COMPLETE		0x0100
 #define RESIZE_VERBOSE			0x0200
 #define RESIZE_LAZY_ITABLE_INIT		0x0400	/* Do not initialize inode tables*/
+#define RESIZE_DISCARD			0x0800	/* Discard space before attempt to resize */
+#define RESIZE_DISCARD_ZEROES		0x1000	/* Discard zeroes data */
 
 /*
  * The core state structure for the ext2 resizer
@@ -115,6 +117,7 @@ struct ext2_resize_struct {
 /*
  * Progress pass numbers...
  */
+#define E2_RSZ_DISCARD_DEVICE		0
 #define E2_RSZ_EXTEND_ITABLE_PASS	1
 #define E2_RSZ_BLOCK_RELOC_PASS		2
 #define E2_RSZ_INODE_SCAN_PASS		3
-- 
1.7.2.3

