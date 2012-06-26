From: Tony Breeds <tony@bakeyournoodle.com>
Subject: [PATCH 2/2] Make Multi Mount Protection (MMP) optional at configure time.
Date: Tue, 26 Jun 2012 11:42:15 +1000
Message-ID: <1340674935-1503-2-git-send-email-tony@bakeyournoodle.com>
References: <1340674935-1503-1-git-send-email-tony@bakeyournoodle.com>
To: linux-ext4 <linux-ext4@vger.kernel.org>, Ted Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:34488 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757942Ab2FZBmW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 25 Jun 2012 21:42:22 -0400
In-Reply-To: <1340674935-1503-1-git-send-email-tony@bakeyournoodle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add --{en,dis}able-mmp options for configure, default to enabled.
Also make tools fail gracefully in the event of encoutering a filesystem
with MMP enabled when the tools were compiled with --disable-mmp

Signed-off-by: Tony Breeds <tony@bakeyournoodle.com>
---
 configure.in         |   17 +++++++++++++++++
 debugfs/debugfs.c    |    5 +++++
 debugfs/set_fields.c |    5 +++++
 lib/config.h.in      |    3 +++
 lib/ext2fs/ext2fs.h  |    8 +++++++-
 lib/ext2fs/mmp.c     |   32 ++++++++++++++++++++++++++++++++
 6 files changed, 69 insertions(+), 1 deletions(-)

diff --git a/configure.in b/configure.in
index 7373e8e..a02234d 100644
--- a/configure.in
+++ b/configure.in
@@ -746,6 +746,23 @@ AC_MSG_RESULT([Building uuidd by default])
 )
 AC_SUBST(UUIDD_CMT)
 dnl
+dnl handle --disable-mmp
+dnl
+AH_TEMPLATE([CONFIG_MMP], [Define to 1 to enable mmp support])
+AC_ARG_ENABLE([mmp],
+[  --disable-mmp   	  disable support mmp, Multi Mount Protection],
+if test "$enableval" = "no"
+then
+	AC_MSG_RESULT([Disabling mmp support])
+else
+	AC_MSG_RESULT([Enabling mmp support])
+	AC_DEFINE(CONFIG_MMP, 1)
+fi
+,
+AC_MSG_RESULT([Enabling mmp support by default])
+AC_DEFINE(CONFIG_MMP, 1)
+)
+dnl
 dnl
 dnl
 MAKEFILE_LIBRARY=$srcdir/lib/Makefile.library
diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index cf80bd0..0c27b1e 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -2194,6 +2194,7 @@ void do_punch(int argc, char *argv[])
 
 void do_dump_mmp(int argc EXT2FS_ATTR((unused)), char *argv[])
 {
+#if CONFIG_MMP
 	struct ext2_super_block *sb;
 	struct mmp_struct *mmp_s;
 	time_t t;
@@ -2237,6 +2238,10 @@ void do_dump_mmp(int argc EXT2FS_ATTR((unused)), char *argv[])
 	fprintf(stdout, "node_name: %s\n", mmp_s->mmp_nodename);
 	fprintf(stdout, "device_name: %s\n", mmp_s->mmp_bdevname);
 	fprintf(stdout, "magic: 0x%x\n", mmp_s->mmp_magic);
+#else
+	fprintf(stdout, "MMP is unsupported, please recompile with "
+	                "--enable-mmp\n");
+#endif
 }
 
 static int source_file(const char *cmd_file, int sci_idx)
diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index 08bfd8d..a42faa2 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -765,6 +765,7 @@ static errcode_t parse_mmp_clear(struct field_set_info *info,
 
 void do_set_mmp_value(int argc, char *argv[])
 {
+#ifdef CONFIG_MMP
 	const char *usage = "<field> <value>\n"
 		"\t\"set_mmp_value -l\" will list the names of "
 		"MMP fields\n\twhich can be set.";
@@ -819,5 +820,9 @@ void do_set_mmp_value(int argc, char *argv[])
 				 &set_mmp);
 		*mmp_s = set_mmp;
 	}
+#else
+	fprintf(stdout, "MMP is unsupported, please recompile with "
+	                "--enable-mmp\n");
+#endif
 }
 
diff --git a/lib/config.h.in b/lib/config.h.in
index 90e9743..52c3897 100644
--- a/lib/config.h.in
+++ b/lib/config.h.in
@@ -12,6 +12,9 @@
 /* Define to 1 if debugging ext3/4 journal code */
 #undef CONFIG_JBD_DEBUG
 
+/* Define to 1 to enable mmp support */
+#undef CONFIG_MMP
+
 /* Define to 1 to enable quota support */
 #undef CONFIG_QUOTA
 
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 7be148e..542b20f 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -559,6 +559,12 @@ typedef struct ext2_icount *ext2_icount_t;
 #define EXT2_LIB_INCOMPAT_COMPRESSION	(0)
 #endif
 
+#ifdef CONFIG_MMP
+#define EXT4_LIB_INCOMPAT_MMP		EXT4_FEATURE_INCOMPAT_MMP
+#else
+#define EXT4_LIB_INCOMPAT_MMP		(0)
+#endif
+
 #define EXT2_LIB_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE|\
 					 EXT2_LIB_INCOMPAT_COMPRESSION|\
 					 EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|\
@@ -566,7 +572,7 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT3_FEATURE_INCOMPAT_RECOVER|\
 					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
-					 EXT4_FEATURE_INCOMPAT_MMP|\
+					 EXT4_LIB_INCOMPAT_MMP|\
 					 EXT4_FEATURE_INCOMPAT_64BIT)
 #ifdef CONFIG_QUOTA
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
diff --git a/lib/ext2fs/mmp.c b/lib/ext2fs/mmp.c
index bb3772d..c76aefa 100644
--- a/lib/ext2fs/mmp.c
+++ b/lib/ext2fs/mmp.c
@@ -33,6 +33,7 @@
 
 errcode_t ext2fs_mmp_read(ext2_filsys fs, blk64_t mmp_blk, void *buf)
 {
+#ifdef CONFIG_MMP
 	struct mmp_struct *mmp_cmp;
 	errcode_t retval = 0;
 
@@ -88,10 +89,14 @@ errcode_t ext2fs_mmp_read(ext2_filsys fs, blk64_t mmp_blk, void *buf)
 
 out:
 	return retval;
+#else
+	return EXT2_ET_OP_NOT_SUPPORTED;
+#endif
 }
 
 errcode_t ext2fs_mmp_write(ext2_filsys fs, blk64_t mmp_blk, void *buf)
 {
+#ifdef CONFIG_MMP
 	struct mmp_struct *mmp_s = buf;
 	struct timeval tv;
 	errcode_t retval = 0;
@@ -119,6 +124,9 @@ errcode_t ext2fs_mmp_write(ext2_filsys fs, blk64_t mmp_blk, void *buf)
 	/* Make sure the block gets to disk quickly */
 	io_channel_flush(fs->io);
 	return retval;
+#else
+	return EXT2_ET_OP_NOT_SUPPORTED;
+#endif
 }
 
 #ifdef HAVE_SRANDOM
@@ -128,6 +136,7 @@ errcode_t ext2fs_mmp_write(ext2_filsys fs, blk64_t mmp_blk, void *buf)
 
 unsigned ext2fs_mmp_new_seq()
 {
+#ifdef CONFIG_MMP
 	unsigned new_seq;
 	struct timeval tv;
 
@@ -144,6 +153,9 @@ unsigned ext2fs_mmp_new_seq()
 	} while (new_seq > EXT4_MMP_SEQ_MAX);
 
 	return new_seq;
+#else
+	return EXT2_ET_OP_NOT_SUPPORTED;
+#endif
 }
 
 static errcode_t ext2fs_mmp_reset(ext2_filsys fs)
@@ -182,6 +194,7 @@ out:
 
 errcode_t ext2fs_mmp_clear(ext2_filsys fs)
 {
+#ifdef CONFIG_MMP
 	errcode_t retval = 0;
 
 	if (!(fs->flags & EXT2_FLAG_RW))
@@ -190,10 +203,14 @@ errcode_t ext2fs_mmp_clear(ext2_filsys fs)
 	retval = ext2fs_mmp_reset(fs);
 
 	return retval;
+#else
+	return EXT2_ET_OP_NOT_SUPPORTED;
+#endif
 }
 
 errcode_t ext2fs_mmp_init(ext2_filsys fs)
 {
+#ifdef CONFIG_MMP
 	struct ext2_super_block *sb = fs->super;
 	blk64_t mmp_block;
 	errcode_t retval;
@@ -222,6 +239,9 @@ errcode_t ext2fs_mmp_init(ext2_filsys fs)
 
 out:
 	return retval;
+#else
+	return EXT2_ET_OP_NOT_SUPPORTED;
+#endif
 }
 
 /*
@@ -229,6 +249,7 @@ out:
  */
 errcode_t ext2fs_mmp_start(ext2_filsys fs)
 {
+#ifdef CONFIG_MMP
 	struct mmp_struct *mmp_s;
 	unsigned seq;
 	unsigned int mmp_check_interval;
@@ -318,6 +339,9 @@ clean_seq:
 
 mmp_error:
 	return retval;
+#else
+	return EXT2_ET_OP_NOT_SUPPORTED;
+#endif
 }
 
 /*
@@ -328,6 +352,7 @@ mmp_error:
  */
 errcode_t ext2fs_mmp_stop(ext2_filsys fs)
 {
+#ifdef CONFIG_MMP
 	struct mmp_struct *mmp, *mmp_cmp;
 	errcode_t retval = 0;
 
@@ -357,6 +382,9 @@ mmp_error:
 	}
 
 	return retval;
+#else
+	return EXT2_ET_OP_NOT_SUPPORTED;
+#endif
 }
 
 #define EXT2_MIN_MMP_UPDATE_INTERVAL 60
@@ -366,6 +394,7 @@ mmp_error:
  */
 errcode_t ext2fs_mmp_update(ext2_filsys fs)
 {
+#ifdef CONFIG_MMP
 	struct mmp_struct *mmp, *mmp_cmp;
 	struct timeval tv;
 	errcode_t retval = 0;
@@ -394,4 +423,7 @@ errcode_t ext2fs_mmp_update(ext2_filsys fs)
 
 mmp_error:
 	return retval;
+#else
+	return EXT2_ET_OP_NOT_SUPPORTED;
+#endif
 }
-- 
1.7.7.6

