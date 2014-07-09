From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] mke2fs: add support to align hugefiles relative to beginning of the disk
Date: Tue,  8 Jul 2014 20:44:51 -0400
Message-ID: <1404866691-23148-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52592 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940AbaGIApA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 8 Jul 2014 20:45:00 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add the mke2fs.conf configuration option which causes the hugefiles to
be aligned to the beginning of the disk.  This is important if the the
reason for aligning the hugefiles is to support hard-drive specific
features such as Shingled Magnetic Recording (SMR).

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 misc/mk_hugefiles.c   | 154 ++++++++++++++++++++++++++++++++++++++++++++++++--
 misc/mke2fs.c         |   2 +-
 misc/mke2fs.conf.5.in |   7 +++
 misc/mke2fs.h         |   2 +-
 4 files changed, 157 insertions(+), 8 deletions(-)

diff --git a/misc/mk_hugefiles.c b/misc/mk_hugefiles.c
index b7a9840..ea42b6c 100644
--- a/misc/mk_hugefiles.c
+++ b/misc/mk_hugefiles.c
@@ -3,9 +3,11 @@
  */
 
 #define _XOPEN_SOURCE 600 /* for inclusion of PATH_MAX in Solaris */
+#define _BSD_SOURCE	  /* for makedev() and major() */
 
 #include "config.h"
 #include <stdio.h>
+#include <stdarg.h>
 #include <string.h>
 #include <strings.h>
 #include <fcntl.h>
@@ -60,6 +62,141 @@ static char *fn_buf;
 static char *fn_numbuf;
 int zero_hugefile = 1;
 
+#define SYSFS_PATH_LEN 256
+typedef char sysfs_path_t[SYSFS_PATH_LEN];
+
+#ifndef HAVE_SNPRINTF
+/*
+ * We are very careful to avoid needing to worry about buffer
+ * overflows, so we don't really need to use snprintf() except as an
+ * additional safety check.  So if snprintf() is not present, it's
+ * safe to fall back to vsprintf().  This provides portability since
+ * vsprintf() is guaranteed by C89, while snprintf() is only
+ * guaranteed by C99 --- which for example, Microsoft Visual Studio
+ * has *still* not bothered to implement.  :-/  (Not that I expect
+ * mke2fs to be ported to MS Visual Studio any time soon, but
+ * libext2fs *does* get built on Microsoft platforms, and we might
+ * want to move this into libext2fs some day.)
+ */
+static int my_snprintf(char *str, size_t size, const char *format, ...)
+{
+	va_list	ap;
+	int ret;
+
+	va_start(ap, format);
+	ret = vsprintf(str, format, ap);
+	va_end(ap);
+	return ret;
+}
+
+#define snprintf my_snprintf
+#endif
+
+/*
+ * Fall back to Linux's definitions of makedev and major are needed.
+ * The search_sysfs_block() function is highly unlikely to work on
+ * non-Linux systems anyway.
+ */
+#ifndef makedev
+#define makedev(maj, min) (((maj) << 8) + (min))
+#endif
+
+static char *search_sysfs_block(dev_t devno, sysfs_path_t ret_path)
+{
+	struct dirent	*de, *p_de;
+	DIR		*dir = NULL, *p_dir = NULL;
+	FILE		*f;
+	sysfs_path_t	path, p_path;
+	unsigned int	major, minor;
+	char		*ret = ret_path;
+
+	ret_path[0] = 0;
+	if ((dir = opendir("/sys/block")) == NULL)
+		return NULL;
+	while ((de = readdir(dir)) != NULL) {
+		if (!strcmp(de->d_name, ".") || !strcmp(de->d_name, "..") ||
+		    strlen(de->d_name) > sizeof(path)-32)
+			continue;
+		snprintf(path, SYSFS_PATH_LEN,
+			 "/sys/block/%s/dev", de->d_name);
+		f = fopen(path, "r");
+		if (f &&
+		    (fscanf(f, "%u:%u", &major, &minor) == 2)) {
+			fclose(f); f = NULL;
+			if (makedev(major, minor) == devno) {
+				snprintf(ret_path, SYSFS_PATH_LEN,
+					 "/sys/block/%s", de->d_name);
+				goto success;
+			}
+#ifdef major
+			if (major(devno) != major)
+				continue;
+#endif
+		}
+		if (f)
+			fclose(f);
+
+		snprintf(path, SYSFS_PATH_LEN, "/sys/block/%s", de->d_name);
+
+		if (p_dir)
+			closedir(p_dir);
+		if ((p_dir = opendir(path)) == NULL)
+			continue;
+		while ((p_de = readdir(p_dir)) != NULL) {
+			if (!strcmp(p_de->d_name, ".") ||
+			    !strcmp(p_de->d_name, "..") ||
+			    (strlen(p_de->d_name) >
+			     SYSFS_PATH_LEN - strlen(path) - 32))
+				continue;
+			snprintf(p_path, SYSFS_PATH_LEN, "%s/%s/dev",
+				 path, p_de->d_name);
+
+			f = fopen(p_path, "r");
+			if (f &&
+			    (fscanf(f, "%u:%u", &major, &minor) == 2) &&
+			    (((major << 8) + minor) == devno)) {
+				fclose(f);
+				snprintf(ret_path, SYSFS_PATH_LEN, "%s/%s",
+					 path, p_de->d_name);
+				goto success;
+			}
+			if (f)
+				fclose(f);
+		}
+	}
+	ret = NULL;
+success:
+	if (dir)
+		closedir(dir);
+	if (p_dir)
+		closedir(p_dir);
+	return ret;
+}
+
+static blk64_t get_partition_start(const char *device_name)
+{
+	unsigned long long start;
+	sysfs_path_t	path;
+	struct stat	st;
+	FILE		*f;
+	char		*cp;
+	int		n;
+
+	if ((stat(device_name, &st) < 0) || !S_ISBLK(st.st_mode))
+		return 0;
+
+	cp = search_sysfs_block(st.st_rdev, path);
+	if (!cp)
+		return 0;
+	strncat(path, "/start", SYSFS_PATH_LEN);
+	f = fopen(path, "r");
+	if (!f)
+		return 0;
+	n = fscanf(f, "%llu", &start);
+	fclose(f);
+	return (n == 1) ? start : 0;
+}
+
 static errcode_t create_directory(ext2_filsys fs, char *dir,
 				  ext2_ino_t *ret_ino)
 
@@ -310,24 +447,26 @@ static blk64_t get_start_block(ext2_filsys fs, blk64_t slack)
 	return blk;
 }
 
-static blk64_t round_up_align(blk64_t b, unsigned long align)
+static blk64_t round_up_align(blk64_t b, unsigned long align,
+			      blk64_t part_offset)
 {
 	unsigned long m;
 
 	if (align == 0)
 		return b;
-	m = b % align;
+	part_offset = part_offset % align;
+	m = (b + part_offset) % align;
 	if (m)
 		b += align - m;
 	return b;
 }
 
-errcode_t mk_hugefiles(ext2_filsys fs)
+errcode_t mk_hugefiles(ext2_filsys fs, const char *device_name)
 {
 	unsigned long	i;
 	ext2_ino_t	dir;
 	errcode_t	retval;
-	blk64_t		fs_blocks;
+	blk64_t		fs_blocks, part_offset;
 	unsigned long	align;
 	int		d, dsize;
 	char		*t;
@@ -348,7 +487,10 @@ errcode_t mk_hugefiles(ext2_filsys fs)
 	t = get_string_from_profile(fs_types, "hugefiles_align", "0");
 	align = parse_num_blocks2(t, fs->super->s_log_block_size);
 	free(t);
-	num_blocks = round_up_align(num_blocks, align);
+	if (get_bool_from_profile(fs_types, "hugefiles_align_disk", 0))
+		part_offset = get_partition_start(device_name) /
+			(fs->blocksize / 512);
+	num_blocks = round_up_align(num_blocks, align, 0);
 	zero_hugefile = get_bool_from_profile(fs_types, "zero_hugefiles",
 					      zero_hugefile);
 
@@ -400,7 +542,7 @@ errcode_t mk_hugefiles(ext2_filsys fs)
 	num_slack += calc_overhead(fs, num_blocks) * num_files;
 	num_slack += (num_files / 16) + 1; /* space for dir entries */
 	goal = get_start_block(fs, num_slack);
-	goal = round_up_align(goal, align);
+	goal = round_up_align(goal, align, part_offset);
 
 	if ((num_blocks ? num_blocks : fs_blocks) >
 	    (0x80000000UL / fs->blocksize))
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index ecd47e6..da77e3a 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -2913,7 +2913,7 @@ no_journal:
 				       EXT4_FEATURE_RO_COMPAT_QUOTA))
 		create_quota_inodes(fs);
 
-	retval = mk_hugefiles(fs);
+	retval = mk_hugefiles(fs, device_name);
 	if (retval)
 		com_err(program_name, retval, "while creating huge files");
 
diff --git a/misc/mke2fs.conf.5.in b/misc/mke2fs.conf.5.in
index 8e25892..19458ac 100644
--- a/misc/mke2fs.conf.5.in
+++ b/misc/mke2fs.conf.5.in
@@ -480,6 +480,13 @@ files.  It also forces the size of huge files to be a multiple of the
 requested alignment.  If this relation is not specified, no alignment
 requirement will be imposed on the huge files.
 .TP
+.I hugefiles_align_disk
+Thie relations specifies whether the alignment should be relative to the
+beginning of the hard drive (assuming that the starting offset of the
+partition is available to mke2fs).  The default value is false, which
+if will cause hugefile alignment to be relative to the beginning of the
+file system.
+.TP
 .I hugefiles_name
 This relation specifies the base file name for the huge files.
 .TP
diff --git a/misc/mke2fs.h b/misc/mke2fs.h
index 9fa6bfe..ce72cb3 100644
--- a/misc/mke2fs.h
+++ b/misc/mke2fs.h
@@ -24,7 +24,7 @@ extern int get_bool_from_profile(char **types, const char *opt, int def_val);
 extern int int_log10(unsigned long long arg);
 
 /* mk_hugefiles.c */
-extern errcode_t mk_hugefiles(ext2_filsys fs);
+extern errcode_t mk_hugefiles(ext2_filsys fs, const char *device_name);
 
 
 
-- 
2.0.0

