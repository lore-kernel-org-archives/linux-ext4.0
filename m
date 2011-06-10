From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH 2/3] mke2fs: skip zeroing journal blocks
Date: Fri, 10 Jun 2011 04:00:18 -0600
Message-ID: <1307700019-4551-2-git-send-email-adilger@whamcloud.com>
References: <1307700019-4551-1-git-send-email-adilger@whamcloud.com>
Cc: Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:12460 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab1FJKAX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 10 Jun 2011 06:00:23 -0400
In-Reply-To: <1307700019-4551-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add the ability to skip zeroing journal blocks on disk.  This can
significantly speed up mke2fs with large journals.  At worst the
uninitialized journal is only a very short-term risk (if at all),
because the journal will be overwritten on any new filesystem as
soon as any significant amount of data is written to disk, and
the new journal TID would need to match the offset/TID of an old
commit block still left on disk.

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 lib/ext2fs/ext2fs.h    |    5 ++---
 lib/ext2fs/mkjournal.c |   20 +++++++++++++++++---
 misc/mke2fs.8.in       |   10 +++++++++-
 misc/mke2fs.c          |   17 ++++++++++++++++-
 4 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 44447bf..6ce9975 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -204,10 +204,9 @@ typedef struct ext2_file *ext2_file_t;
 
 /*
  * Flags for mkjournal
- *
- * EXT2_MKJOURNAL_V1_SUPER	Make a (deprecated) V1 journal superblock
  */
-#define EXT2_MKJOURNAL_V1_SUPER	0x0000001
+#define EXT2_MKJOURNAL_V1_SUPER	0x0000001 /* create V1 superblock (deprecated) */
+#define EXT2_MKJOURNAL_LAZYINIT	0x0000002 /* don't zero journal inode before use*/
 
 struct opaque_ext2_group_desc;
 
diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index 36b75be..0b6c0c1 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -104,7 +104,7 @@ static errcode_t write_journal_file(ext2_filsys fs, char *filename,
 	/* Open the device or journal file */
 	if ((fd = open(filename, O_WRONLY)) < 0) {
 		retval = errno;
-		goto errout;
+		goto errfree;
 	}
 
 	/* Write the superblock out */
@@ -118,6 +118,9 @@ static errcode_t write_journal_file(ext2_filsys fs, char *filename,
 		goto errout;
 	memset(buf, 0, fs->blocksize);
 
+	if (flags & EXT2_MKJOURNAL_LAZYINIT)
+		goto success;
+
 	for (i = 1; i < num_blocks; i++) {
 		ret_size = write(fd, buf, fs->blocksize);
 		if (ret_size < 0) {
@@ -127,10 +130,12 @@ static errcode_t write_journal_file(ext2_filsys fs, char *filename,
 		if (ret_size != (int) fs->blocksize)
 			goto errout;
 	}
-	close(fd);
 
+success:
 	retval = 0;
 errout:
+	close(fd);
+errfree:
 	ext2fs_free_mem(&buf);
 	return retval;
 }
@@ -214,6 +219,7 @@ struct mkjournal_struct {
 	blk64_t		goal;
 	blk64_t		blk_to_zero;
 	int		zero_count;
+	int		flags;
 	char		*buf;
 	errcode_t	err;
 };
@@ -245,7 +251,7 @@ static int mkjournal_proc(ext2_filsys	fs,
 	retval = 0;
 	if (blockcnt <= 0)
 		retval = io_channel_write_blk64(fs->io, new_blk, 1, es->buf);
-	else {
+	else if (!(es->flags & EXT2_MKJOURNAL_LAZYINIT)) {
 		if (es->zero_count) {
 			if ((es->blk_to_zero + es->zero_count == new_blk) &&
 			    (es->zero_count < 1024))
@@ -311,6 +317,7 @@ static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
 	es.newblocks = 0;
 	es.buf = buf;
 	es.err = 0;
+	es.flags = flags;
 	es.zero_count = 0;
 
 	if (fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS) {
@@ -513,6 +520,13 @@ errcode_t ext2fs_add_journal_inode(ext2_filsys fs, blk_t num_blocks, int flags)
 		if ((fd = open(jfile, O_CREAT|O_WRONLY, 0600)) < 0)
 			return errno;
 
+		/* Note that we can't do lazy journal initialization for mounted
+		 * filesystems, since the zero writing is also allocating the
+		 * journal blocks.  We could use fallocate, but not all kernels
+		 * support that, and creating a journal on a mounted ext2
+		 * filesystems is extremely rare these days...  Ignore it. */
+		flags &= ~EXT2_MKJOURNAL_LAZYINIT;
+
 		if ((retval = write_journal_file(fs, jfile, num_blocks, flags)))
 			goto errout;
 
diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index 4a3b0c3..0d4b046 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -232,7 +232,15 @@ This speeds up filesystem
 initialization noticeably, but it requires the kernel to finish
 initializing the filesystem in the background when the filesystem is
 first mounted.  If the option value is omitted, it defaults to 1 to
-enable lazy inode table initialization.
+enable lazy inode table zeroing.
+.TP
+.B lazy_journal_init\fR[\fB= \fI<0 to disable, 1 to enable>\fR]
+If enabled, the journal inode will not be fully zeroed out by
+.BR mke2fs .
+This speeds up filesystem initialization noticeably, but carries some
+small risk if the system crashes before the journal has been overwritten
+entirely one time.  If the option value is omitted, it defaults to 1 to
+enable lazy journal inode zeroing.
 .TP
 .B test_fs
 Set a flag in the filesystem superblock indicating that it may be
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 9472016..7627e6d 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -503,6 +503,10 @@ static void create_journal_dev(ext2_filsys fs)
 			_("while initializing journal superblock"));
 		exit(1);
 	}
+ 
+	if (journal_flags & EXT2_MKJOURNAL_LAZYINIT)
+		goto write_superblock;
+ 
 	ext2fs_numeric_progress_init(fs, &progress,
 				     _("Zeroing journal device: "),
 				     ext2fs_blocks_count(fs->super));
@@ -527,6 +531,8 @@ static void create_journal_dev(ext2_filsys fs)
 	}
 	ext2fs_zero_blocks2(0, 0, 0, 0, 0);
 
+	ext2fs_numeric_progress_close(fs, &progress, NULL);
+write_superblock:
 	retval = io_channel_write_blk64(fs->io,
 					fs->super->s_first_data_block+1,
 					1, buf);
@@ -535,7 +541,6 @@ static void create_journal_dev(ext2_filsys fs)
 			_("while writing journal superblock"));
 		exit(1);
 	}
-	ext2fs_numeric_progress_close(fs, &progress, NULL);
 }
 
 static void show_stats(ext2_filsys fs)
@@ -761,6 +766,12 @@ static void parse_extended_opts(struct ext2_super_block *param,
 				lazy_itable_init = strtoul(arg, &p, 0);
 			else
 				lazy_itable_init = 1;
+		} else if (!strcmp(token, "lazy_journal_init")) {
+			if (arg)
+				journal_flags |= strtoul(arg, &p, 0) ?
+						EXT2_MKJOURNAL_LAZYINIT : 0;
+			else
+				journal_flags |= EXT2_MKJOURNAL_LAZYINIT;
 		} else if (!strcmp(token, "discard")) {
 			discard = 1;
 		} else if (!strcmp(token, "nodiscard")) {
@@ -780,6 +791,7 @@ static void parse_extended_opts(struct ext2_super_block *param,
 			"\tstripe-width=<RAID stride * data disks in blocks>\n"
 			"\tresize=<resize maximum size in blocks>\n"
 			"\tlazy_itable_init=<0 to disable, 1 to enable>\n"
+			"\tlazy_journal_init=<0 to disable, 1 to enable>\n"
 			"\ttest_fs\n"
 			"\tdiscard\n"
 			"\tnodiscard\n\n"),
@@ -1810,6 +1822,9 @@ profile_error:
 						 "lazy_itable_init",
 						 lazy_itable_init);
 	discard = get_bool_from_profile(fs_types, "discard" , discard);
+	journal_flags |= get_bool_from_profile(fs_types,
+					       "lazy_journal_init", 0) ?
+					       EXT2_MKJOURNAL_LAZYINIT : 0;
 
 	/* Get options from profile */
 	for (cpp = fs_types; *cpp; cpp++) {
-- 
1.7.3.4

