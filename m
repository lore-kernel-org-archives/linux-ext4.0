From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 02/12] e2fsprogs: Create a big journal for Next3
Date: Tue, 20 Jul 2010 18:16:03 +0300
Message-ID: <1279638973-14561-3-git-send-email-amir73il@users.sf.net>
References: <1279638973-14561-1-git-send-email-amir73il@users.sf.net>
Cc: linux-ext4@vger.kernel.org, Amir Goldstein <amir73il@users.sf.net>
To: tytso@mit.edu, andreas.dilger@oracle.com, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42770 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326Ab0GTPRX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Jul 2010 11:17:23 -0400
Received: by mail-ww0-f44.google.com with SMTP id 40so968910wwj.1
        for <linux-ext4@vger.kernel.org>; Tue, 20 Jul 2010 08:17:22 -0700 (PDT)
In-Reply-To: <1279638973-14561-1-git-send-email-amir73il@users.sf.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Next3 transactions reserve up to 24 times more credits than Ext3
transactions for the same operation.  On mke2fs and tune2fs, if the
'-J big' option is used to create a journal, increase the default
journal size by a factor of 24.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 lib/ext2fs/ext2_fs.h   |   11 +++++++++++
 lib/ext2fs/ext2fs.h    |    2 ++
 lib/ext2fs/mkjournal.c |   41 +++++++++++++++++++++++++++++++++++++++++
 misc/mke2fs.c          |   12 ++++++++++++
 misc/util.c            |   30 ++++++++++++++++++++++++++++++
 5 files changed, 96 insertions(+), 0 deletions(-)

diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 3a65515..8e850eb 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -647,6 +647,17 @@ struct ext2_super_block {
 #define EXT3_JNL_BACKUP_BLOCKS	1
 
 /*
+ * A Next3 'big' journal needs to accomodate extra snapshot COW credits.
+ * Default journal size accomodates maximum possible COW credits.
+ * Minimum required journal size accomodates the avarage COW credits.
+ */
+#define EXT3_DEF_JOURNAL_BLOCKS		32768
+#define NEXT3_AVG_COW_CREDITS		16
+#define NEXT3_MAX_COW_CREDITS		24
+#define NEXT3_MIN_JOURNAL_BLOCKS	(EXT3_DEF_JOURNAL_BLOCKS*NEXT3_AVG_COW_CREDITS)
+#define NEXT3_DEF_JOURNAL_BLOCKS	(EXT3_DEF_JOURNAL_BLOCKS*NEXT3_MAX_COW_CREDITS)
+
+/*
  * Feature set definitions
  */
 
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index f0645c3..0c2587f 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1245,6 +1245,8 @@ extern errcode_t ext2fs_add_journal_device(ext2_filsys fs,
 extern errcode_t ext2fs_add_journal_inode(ext2_filsys fs, blk_t size,
 					  int flags);
 extern int ext2fs_default_journal_size(__u64 blocks);
+extern int ext2fs_big_journal_size(int factor, __u64 blocks);
+extern int ext2fs_check_journal_size(ext2_filsys fs);
 
 /* openfs.c */
 extern errcode_t ext2fs_open(const char *name, int flags, int superblock,
diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index 9466e78..a7fb526 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -400,6 +400,47 @@ int ext2fs_default_journal_size(__u64 blocks)
 	return 32768;
 }
 
+/* 
+ * Big journal is up to X times bigger than the default journal
+ * to accomodate snapshot COW credits in transactions.
+ * journal size is restricted to 1/32 of the filesystem size
+ */
+int ext2fs_big_journal_size(int factor, __u64 blocks)
+{
+	int mega_blocks = blocks >> 20;
+	if (!mega_blocks)
+		return ext2fs_default_journal_size(blocks);
+
+	if (mega_blocks < factor)
+		/* 32K/1M = 1/32 of filesystem size */
+		return EXT3_DEF_JOURNAL_BLOCKS*mega_blocks;
+	
+	/* X times bigger than the default journal */
+	return EXT3_DEF_JOURNAL_BLOCKS*factor;
+}
+
+/*
+ * Return the number of blocks in the journal inode
+ */
+int ext2fs_check_journal_size(ext2_filsys fs)
+{
+	struct ext2_inode j_inode;
+	int j_blocks;
+
+	if (!(fs->super->s_feature_compat &
+		EXT3_FEATURE_COMPAT_HAS_JOURNAL) ||
+		!fs->super->s_journal_inum)
+		return 0;
+
+	if (ext2fs_read_inode(fs, fs->super->s_journal_inum, &j_inode))
+		return -1;
+
+	/* read journal inode size */
+	j_blocks = j_inode.i_size >> EXT2_BLOCK_SIZE_BITS(fs->super);
+	
+	return j_blocks;
+}
+
 /*
  * This function adds a journal device to a filesystem
  */
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index add7c0c..88f4230 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -903,6 +903,9 @@ static char **parse_fs_type(const char *fs_type,
 		ext_type = "ext2";
 	else if (!strcmp(program_name, "mke3fs"))
 		ext_type = "ext3";
+	else if (!strcmp(program_name, "mkfs.next3") ||
+		!strcmp(program_name, "mkn3fs"))
+		ext_type = "ext3";
 	else if (progname) {
 		ext_type = strrchr(progname, '/');
 		if (ext_type)
@@ -1164,6 +1167,15 @@ static void PRS(int argc, char *argv[])
 		if (!strcmp(program_name, "mkfs.ext3") ||
 		    !strcmp(program_name, "mke3fs"))
 			journal_size = -1;
+		
+		/* If called as mkfs.next3: */
+		if (!strcmp(program_name, "mkfs.next3") ||
+		    !strcmp(program_name, "mkn3fs")) {
+			/* 1. create a big journal */
+			journal_size = -NEXT3_MAX_COW_CREDITS;
+			/* 2. use system page size as block size */
+			blocksize = sys_page_size;
+		}
 	}
 
 	while ((c = getopt (argc, argv,
diff --git a/misc/util.c b/misc/util.c
index 51bdb60..435557a 100644
--- a/misc/util.c
+++ b/misc/util.c
@@ -222,6 +222,20 @@ void parse_journal_opts(const char *opts)
 			journal_size = strtoul(arg, &p, 0);
 			if (*p)
 				journal_usage++;
+		} else if (strcmp(token, "big") == 0) {
+			/* Create a big journal for Next3 */
+			journal_size = -NEXT3_MAX_COW_CREDITS;
+			continue;
+		} else if (strcmp(token, "bigger") == 0) {
+			/* Create a journal bigger than default */
+			if (!arg) {
+				journal_usage++;
+				continue;
+			}
+			journal_size = -strtoul(arg, &p, 0);
+			if (*p)
+				journal_usage++;
+			continue;
 		} else if (strcmp(token, "v1_superblock") == 0) {
 			journal_flags |= EXT2_MKJOURNAL_V1_SUPER;
 			continue;
@@ -235,6 +249,8 @@ void parse_journal_opts(const char *opts)
 			"\tis set off by an equals ('=') sign.\n\n"
 			"Valid journal options are:\n"
 			"\tsize=<journal size in megabytes>\n"
+			"\tbig (Next3 big journal size)\n"
+			"\tbigger=<X times bigger than default size>\n"
 			"\tdevice=<journal device>\n\n"
 			"The journal size must be between "
 			"1024 and 10240000 filesystem blocks.\n\n"), stderr);
@@ -263,6 +279,20 @@ unsigned int figure_journal_size(int size, ext2_filsys fs)
 		return 0;
 	}
 
+	if (size < -1) {
+		/* bigger journal requested */
+		j_blocks = ext2fs_big_journal_size(-size, fs->super->s_blocks_count);
+		if (j_blocks < EXT3_DEF_JOURNAL_BLOCKS*(-size)) {
+			fputs(_("\nFilesystem too small for requested "
+					"journal size.  "), stderr);
+			if (j_blocks < 0) {
+				fputs(_("Aborting.\n"), stderr);
+				exit(1);
+			}
+			fputs(_("Creating a smaller journal.\n"), stderr);
+		}
+	}
+
 	if (size > 0) {
 		j_blocks = size * 1024 / (fs->blocksize	/ 1024);
 		if (j_blocks < 1024 || j_blocks > 10240000) {
-- 
1.6.6

