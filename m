From: Andreas Dilger <adilger@whamcloud.com>
Subject: [PATCH 1/4] misc: quiet minor compiler errors
Date: Fri, 23 Sep 2011 17:38:41 -0600
Message-ID: <1316821124-7461-1-git-send-email-adilger@whamcloud.com>
Cc: Andreas Dilger <adilger@whamcloud.com>
To: tytso@mit.edu, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:48272 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab1IWXis (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 23 Sep 2011 19:38:48 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Several compiler errors are quieted:
- zero-length gnu_printf format string
- unused variable
- uninitalized variable (though it isn't actually used for anything)
- use of stat64/open64 on OSX (deprecated API)

Signed-off-by: Andreas Dilger <adilger@whamcloud.com>
---
 e2fsck/ea_refcount.c |   30 ++++++++++++++----------------
 e2fsck/problem.c     |    1 +
 e2fsck/region.c      |    2 +-
 lib/ext2fs/crc32c.c  |    1 -
 lib/ext2fs/ext2fs.h  |   18 ++++++++++++++----
 lib/ext2fs/getsize.c |   10 +++-------
 lib/quota/dqblk_v2.h |    2 +-
 misc/tune2fs.c       |    2 +-
 8 files changed, 35 insertions(+), 31 deletions(-)

diff --git a/e2fsck/ea_refcount.c b/e2fsck/ea_refcount.c
index 115bd6f..35105e4 100644
--- a/e2fsck/ea_refcount.c
+++ b/e2fsck/ea_refcount.c
@@ -407,8 +407,8 @@ int main(int argc, char **argv)
 			size = bcode_program[i++];
 			retval = ea_refcount_create(size, &refcount);
 			if (retval) {
-				com_err("ea_refcount_create",
-					retval, "");
+				com_err("ea_refcount_create", retval,
+					"while creating size %d", size);
 				exit(1);
 			} else
 				printf("Creating refcount with size %d\n",
@@ -422,35 +422,35 @@ int main(int argc, char **argv)
 		case BCODE_STORE:
 			blk = (blk_t) bcode_program[i++];
 			arg = bcode_program[i++];
-			retval = ea_refcount_store(refcount, blk, arg);
 			printf("Storing blk %u with value %d\n", blk, arg);
+			retval = ea_refcount_store(refcount, blk, arg);
 			if (retval)
-				com_err("ea_refcount_store", retval, "");
+				com_err("ea_refcount_store", retval,
+					"while storing blk %u", blk);
 			break;
 		case BCODE_FETCH:
 			blk = (blk_t) bcode_program[i++];
 			retval = ea_refcount_fetch(refcount, blk, &arg);
 			if (retval)
-				com_err("ea_refcount_fetch", retval, "");
+				com_err("ea_refcount_fetch", retval,
+					"while fetching blk %u", blk);
 			else
 				printf("bcode_fetch(%u) returns %d\n",
 				       blk, arg);
 			break;
 		case BCODE_INCR:
 			blk = (blk_t) bcode_program[i++];
-			retval = ea_refcount_increment(refcount, blk,
-							   &arg);
+			retval = ea_refcount_increment(refcount, blk, &arg);
 			if (retval)
 				com_err("ea_refcount_increment", retval,
-					"");
+					"while incrementing blk %u", blk);
 			else
 				printf("bcode_increment(%u) returns %d\n",
 				       blk, arg);
 			break;
 		case BCODE_DECR:
 			blk = (blk_t) bcode_program[i++];
-			retval = ea_refcount_decrement(refcount, blk,
-							   &arg);
+			retval = ea_refcount_decrement(refcount, blk, &arg);
 			if (retval)
 				com_err("ea_refcount_decrement", retval,
 					"while decrementing blk %u", blk);
@@ -461,20 +461,18 @@ int main(int argc, char **argv)
 		case BCODE_VALIDATE:
 			retval = ea_refcount_validate(refcount, stderr);
 			if (retval)
-				com_err("ea_refcount_validate",
-					retval, "");
+				com_err("ea_refcount_validate", retval,
+					"while validating");
 			else
 				printf("Refcount validation OK.\n");
 			break;
 		case BCODE_LIST:
 			ea_refcount_intr_begin(refcount);
 			while (1) {
-				blk = ea_refcount_intr_next(refcount,
-								&arg);
+				blk = ea_refcount_intr_next(refcount, &arg);
 				if (!blk)
 					break;
-				printf("\tblk=%u, count=%d\n", blk,
-				       arg);
+				printf("\tblk=%u, count=%d\n", blk, arg);
 			}
 			break;
 		case BCODE_COLLAPSE:
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 0d56983..2c49493 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1979,6 +1979,7 @@ int main(int argc, char *argv[])
 	e2fsck_t ctx;
 	int rc;
 
+	memset(&ctx, 0, sizeof(ctx)); /* just to quiet compiler */
 	rc = verify_problem_table(ctx);
 	if (rc == 0)
 		printf("e2fsck problem table verified\n");
diff --git a/e2fsck/region.c b/e2fsck/region.c
index 2d59356..e9abb56 100644
--- a/e2fsck/region.c
+++ b/e2fsck/region.c
@@ -173,7 +173,7 @@ int main(int argc, char **argv)
 {
 	region_t	r;
 	int		pc = 0, ret;
-	region_addr_t	start, end, len;
+	region_addr_t	start, end;
 
 
 	while (1) {
diff --git a/lib/ext2fs/crc32c.c b/lib/ext2fs/crc32c.c
index c9b610b..65bca5c 100644
--- a/lib/ext2fs/crc32c.c
+++ b/lib/ext2fs/crc32c.c
@@ -30,7 +30,6 @@
  */
 #include "config.h"
 #include <stdint.h>
-#include <endian.h>
 #include <stdlib.h>
 #include <stdio.h>
 #define __force
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 1b9acc3..ab47621 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -586,7 +586,7 @@ typedef struct ext2_icount *ext2_icount_t;
 #define EXT2FS_NUM_B2C(fs, blks)	(((blks) + EXT2FS_CLUSTER_MASK(fs)) >> \
 					 (fs)->cluster_ratio_bits)
 
-#ifdef HAVE_OPEN64
+#if defined(HAVE_STAT64) && !defined(__OSX_AVAILABLE_BUT_DEPRECATED)
 typedef struct stat64 ext2fs_struct_stat;
 #else
 typedef struct stat ext2fs_struct_stat;
@@ -1403,6 +1403,7 @@ extern unsigned int ext2fs_div_ceil(unsigned int a, unsigned int b);
 extern __u64 ext2fs_div64_ceil(__u64 a, __u64 b);
 extern int ext2fs_open_file(const char *pathname, int flags, ...);
 extern int ext2fs_stat(const char *path, ext2fs_struct_stat *buf);
+extern int ext2fs_fstat(int fd, ext2fs_struct_stat *buf);
 
 /*
  * The actual inlined functions definitions themselves...
@@ -1663,7 +1664,7 @@ _INLINE_ int ext2fs_open_file(const char *pathname, int flags, ...)
 	va_end(args);
 
 	if (mode)
-#ifdef HAVE_OPEN64
+#if defined(HAVE_OPEN64) && !defined(__OSX_AVAILABLE_BUT_DEPRECATED)
 		return open64(pathname, flags, mode);
 	else
 		return open64(pathname, flags);
@@ -1676,10 +1677,19 @@ _INLINE_ int ext2fs_open_file(const char *pathname, int flags, ...)
 
 _INLINE_ int ext2fs_stat(const char *path, ext2fs_struct_stat *buf)
 {
-#ifdef HAVE_OPEN64
+#if defined(HAVE_STAT64) && !defined(__OSX_AVAILABLE_BUT_DEPRECATED)
 	return stat64(path, buf);
 #else
-	return open(path, buf);
+	return stat(path, buf);
+#endif
+}
+
+_INLINE_ int ext2fs_fstat(int fd, ext2fs_struct_stat *buf)
+{
+#if defined(HAVE_STAT64) && !defined(__OSX_AVAILABLE_BUT_DEPRECATED)
+	return fstat64(fd, buf);
+#else
+	return fstat(fd, buf);
 #endif
 }
 
diff --git a/lib/ext2fs/getsize.c b/lib/ext2fs/getsize.c
index 690349c..a2e6e47 100644
--- a/lib/ext2fs/getsize.c
+++ b/lib/ext2fs/getsize.c
@@ -232,13 +232,9 @@ errcode_t ext2fs_get_device_size2(const char *file, int blocksize,
 #endif /* HAVE_SYS_DISKLABEL_H */
 
 	{
-#if defined(HAVE_FSTAT64) && !defined(__OSX__)
-		struct stat64   st;
-		if (fstat64(fd, &st) == 0)
-#else
-		struct stat	st;
-		if (fstat(fd, &st) == 0)
-#endif
+		ext2fs_struct_stat st;
+
+		if (ext2fs_fstat(fd, &st) == 0)
 			if (S_ISREG(st.st_mode)) {
 				*retblocks = st.st_size / blocksize;
 				goto out;
diff --git a/lib/quota/dqblk_v2.h b/lib/quota/dqblk_v2.h
index ca07902..18055c6 100644
--- a/lib/quota/dqblk_v2.h
+++ b/lib/quota/dqblk_v2.h
@@ -32,7 +32,7 @@ struct v2_mem_dqinfo {
 };
 
 struct v2_mem_dqblk {
-	loff_t dqb_off;		/* Offset of dquot in file */
+	long long dqb_off;	/* Offset of dquot in file */
 };
 
 struct quotafile_ops;		/* Will be defined later in quotaio.h */
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 11ef095..3e12697 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -2017,7 +2017,7 @@ retry_open:
 		printf(_("Setting stripe width to %d\n"), stripe_width);
 	}
 	if (ext_mount_opts) {
-		strncpy(fs->super->s_mount_opts, ext_mount_opts,
+		strncpy((char *)(fs->super->s_mount_opts), ext_mount_opts,
 			sizeof(fs->super->s_mount_opts));
 		fs->super->s_mount_opts[sizeof(fs->super->s_mount_opts)-1] = 0;
 		ext2fs_mark_super_dirty(fs);
-- 
1.7.3.4

