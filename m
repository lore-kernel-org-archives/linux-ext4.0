From: Andreas Dilger <adilger@dilger.ca>
Subject: [PATCH] misc: fix compile warnings on master branch
Date: Tue, 20 May 2014 17:04:22 -0600
Message-ID: <1400627062-74327-1-git-send-email-adilger@dilger.ca>
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45912 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbaETXEV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 May 2014 19:04:21 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix compile warnings found on the master branch when using LLVM.

- Add missing format string when using the libintl _() macro
- include <limits.h> header to get PATH_MAX definition
- fix format vs. variable mismatches
- add header block for create_inode.c file
- remove use of bzero(), use ext2fs_get_memzero() instead

Signed-off-by: Andreas Dilger <adilger@dilger.ca>
---
 e2fsck/pass5.c           |  4 ++--
 lib/ext2fs/inline_data.c | 14 ++++++++------
 misc/create_inode.c      | 12 ++++++++++++
 misc/dumpe2fs.c          |  4 ++--
 misc/mke2fs.c            | 32 ++++++++++++++++----------------
 misc/tune2fs.c           |  2 +-
 6 files changed, 41 insertions(+), 27 deletions(-)

diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index 04d8843..e23680a 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -100,7 +100,7 @@ static void check_inode_bitmap_checksum(e2fsck_t ctx)
 	retval = ext2fs_get_memalign(ctx->fs->blocksize, ctx->fs->blocksize,
 				     &buf);
 	if (retval) {
-		com_err(ctx->program_name, 0,
+		com_err(ctx->program_name, 0, "%s",
 		    _("check_inode_bitmap_checksum: Memory allocation error"));
 		fatal_error(ctx, 0);
 	}
@@ -156,7 +156,7 @@ static void check_block_bitmap_checksum(e2fsck_t ctx)
 	retval = ext2fs_get_memalign(ctx->fs->blocksize, ctx->fs->blocksize,
 				     &buf);
 	if (retval) {
-		com_err(ctx->program_name, 0,
+		com_err(ctx->program_name, 0, "%s",
 		    _("check_block_bitmap_checksum: Memory allocation error"));
 		fatal_error(ctx, 0);
 	}
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index 7be0f96..fb6a02e 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -12,6 +12,7 @@
 #include "config.h"
 #include <stdio.h>
 #include <time.h>
+#include <limits.h> /* for PATH_MAX */
 
 #include "ext2_fs.h"
 #include "ext2_ext_attr.h"
@@ -283,7 +284,7 @@ static errcode_t ext2fs_inline_data_convert_dir(ext2_filsys fs, ext2_ino_t ino,
 	unsigned int offset;
 	int csum_size = 0;
 	int filetype = 0;
-	int rec_len;
+	unsigned rec_len;
 
 	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
@@ -657,7 +658,7 @@ static errcode_t file_test(ext2_filsys fs)
 
 	if (size != BUFF_SIZE) {
 		fprintf(stderr,
-			"tst_inline_data: size %lu != buflen %lu\n",
+			"tst_inline_data: size %lu != buflen %u\n",
 			size, BUFF_SIZE);
 		retval = 1;
 		goto err;
@@ -730,14 +731,14 @@ static errcode_t dir_test(ext2_filsys fs)
 	}
 
 	if (parent != tmp) {
-		fprintf(stderr, "tst_inline_data: parent (%lu) != tmp (%lu)\n",
+		fprintf(stderr, "tst_inline_data: parent (%u) != tmp (%u)\n",
 			parent, tmp);
 		return 1;
 	}
 
 	for (i = 0, dir = 13; i < 4; i++, dir++) {
 		tmp = 0;
-		snprintf(dirname, PATH_MAX, "%d", i);
+		snprintf(dirname, sizeof(dirname), "%d", i);
 		retval = ext2fs_mkdir(fs, parent, 0, dirname);
 		if (retval) {
 			com_err("dir_test", retval,
@@ -754,13 +755,14 @@ static errcode_t dir_test(ext2_filsys fs)
 		}
 
 		if (dir != tmp) {
-			fprintf(stderr, "tst_inline_data: dir (%lu) != tmp (%lu)\n",
+			fprintf(stderr,
+				"tst_inline_data: dir (%u) != tmp (%u)\n",
 				dir, tmp);
 			return 1;
 		}
 	}
 
-	snprintf(dirname, PATH_MAX, "%d", i);
+	snprintf(dirname, sizeof(dirname), "%d", i);
 	retval = ext2fs_mkdir(fs, parent, 0, dirname);
 	if (retval && retval != EXT2_ET_DIR_NO_SPACE) {
 		com_err("dir_test", retval, "while creating %s dir", dirname);
diff --git a/misc/create_inode.c b/misc/create_inode.c
index 964c66a..4e901b2 100644
--- a/misc/create_inode.c
+++ b/misc/create_inode.c
@@ -1,5 +1,17 @@
+/*
+ * create_inode.c --- create an inode
+ *
+ * Copyright (C) 2014 Robert Yang <liezhi.yang@windriver.com>
+ *
+ * %Begin-Header%
+ * This file may be redistributed under the terms of the GNU library
+ * General Public License, version 2.
+ * %End-Header%
+ */
+
 #include <time.h>
 #include <unistd.h>
+#include <limits.h> /* for PATH_MAX */
 
 #include "create_inode.h"
 
diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
index ae54f8a..3a14e3c 100644
--- a/misc/dumpe2fs.c
+++ b/misc/dumpe2fs.c
@@ -414,7 +414,7 @@ static void print_inline_journal_information(ext2_filsys fs)
 	       (unsigned int)ntohl(jsb->s_start));
 	if (jsb->s_feature_compat &
 	    ext2fs_cpu_to_be32(JFS_FEATURE_COMPAT_CHECKSUM))
-		printf(_("Journal checksum type:    crc32\n"));
+		printf("%s", _("Journal checksum type:    crc32\n"));
 	if (jsb->s_feature_incompat &
 	    ext2fs_cpu_to_be32(JFS_FEATURE_INCOMPAT_CSUM_V2))
 		printf(_("Journal checksum type:    %s\n"
@@ -453,7 +453,7 @@ static void print_journal_information(ext2_filsys fs)
 
 	if (jsb->s_feature_compat &
 	    ext2fs_cpu_to_be32(JFS_FEATURE_COMPAT_CHECKSUM))
-		printf(_("Journal checksum type:    crc32\n"));
+		printf("%s", _("Journal checksum type:    crc32\n"));
 	if (jsb->s_feature_incompat &
 	    ext2fs_cpu_to_be32(JFS_FEATURE_INCOMPAT_CSUM_V2))
 		printf(_("Journal checksum type:    %s\n"
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index aecd5d5..1a48dd8 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -16,7 +16,7 @@
  * enforced (but it's not much fun on a character device :-).
  */
 
-#define _XOPEN_SOURCE 600 /* for inclusion of PATH_MAX in Solaris */
+#define _XOPEN_SOURCE 600 /* for inclusion of PATH_MAX */
 
 #include "config.h"
 #include <stdio.h>
@@ -338,13 +338,11 @@ static void write_reserved_inodes(ext2_filsys fs)
 	ext2_ino_t	ino;
 	struct ext2_inode *inode;
 
-	retval = ext2fs_get_mem(EXT2_INODE_SIZE(fs->super), &inode);
+	retval = ext2fs_get_memzero(EXT2_INODE_SIZE(fs->super), &inode);
 	if (retval) {
-		com_err("inode_init", retval,
-			"while allocating memory");
+		com_err("inode_init", retval, "while allocating memory");
 		exit(1);
 	}
-	bzero(inode, EXT2_INODE_SIZE(fs->super));
 
 	for (ino = 1; ino < EXT2_FIRST_INO(fs->super); ino++)
 		ext2fs_write_inode_full(fs, ino, inode,
@@ -1904,20 +1902,20 @@ profile_error:
 	if (for_hurd(creator_os)) {
 		if (fs_param.s_feature_incompat &
 		    EXT2_FEATURE_INCOMPAT_FILETYPE) {
-			fprintf(stderr, _("The HURD does not support the "
-					  "filetype feature.\n"));
+			fprintf(stderr, "%s", _("The HURD does not support the "
+						"filetype feature.\n"));
 			exit(1);
 		}
 		if (fs_param.s_feature_ro_compat &
 		    EXT4_FEATURE_RO_COMPAT_HUGE_FILE) {
-			fprintf(stderr, _("The HURD does not support the "
-					  "huge_file feature.\n"));
+			fprintf(stderr, "%s", _("The HURD does not support the "
+						"huge_file feature.\n"));
 			exit(1);
 		}
 		if (fs_param.s_feature_ro_compat &
 		    EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) {
-			fprintf(stderr, _("The HURD does not support the "
-					  "metadata_csum feature.\n"));
+			fprintf(stderr, "%s", _("The HURD does not support the "
+						"metadata_csum feature.\n"));
 			exit(1);
 		}
 	}
@@ -2645,17 +2643,19 @@ int main (int argc, char *argv[])
 				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
 		if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
 				EXT3_FEATURE_INCOMPAT_EXTENTS))
-			printf(_("Extents are not enabled.  The file extent "
+			printf("%s",
+			       _("Extents are not enabled.  The file extent "
 				 "tree can be checksummed, whereas block maps "
 				 "cannot.  Not enabling extents reduces the "
 				 "coverage of metadata checksumming.  "
 				 "Pass -O extents to rectify.\n"));
 		if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
 				EXT4_FEATURE_INCOMPAT_64BIT))
-			printf(_("64-bit filesystem support is not "
-				 "enabled.  The larger fields afforded by "
-				 "this feature enable full-strength "
-				 "checksumming.  Pass -O 64bit to rectify.\n"));
+			printf("%s",
+			       _("64-bit filesystem support is not enabled.  "
+				 "The larger fields afforded by this feature "
+				 "enable full-strength checksumming.  "
+				 "Pass -O 64bit to rectify.\n"));
 	}
 
 	/* Calculate journal blocks */
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 6571764..147c270 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -387,7 +387,7 @@ static void request_dir_fsck_afterwards(ext2_filsys fs)
 	fs->super->s_state &= ~EXT2_VALID_FS;
 	printf("\n%s\n", _(please_dir_fsck));
 	if (mount_flags & EXT2_MF_READONLY)
-		printf(_("(and reboot afterwards!)\n"));
+		printf("%s", _("(and reboot afterwards!)\n"));
 }
 
 static void request_fsck_afterwards(ext2_filsys fs)
-- 
1.9.3

