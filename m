From: Amir Goldstein <amir73il@users.sf.net>
Subject: [PATCH 2/8] e2fsprogs: Add big_journal feature for Next3.
Date: Wed, 05 May 2010 21:28:50 +0300
Message-ID: <1273084136-6286-3-git-send-email-amir73il@users.sf.net>
References: <1273084136-6286-1-git-send-email-amir73il@users.sf.net>
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org, Amir Goldstein <amir73il@users.sf.net>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mxout3.netvision.net.il ([194.90.6.2]:28329 "EHLO
	mxout3.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab0EESwE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 May 2010 14:52:04 -0400
Received: from localhost.localdomain ([109.186.177.237])
 by mxout3.netvision.net.il
 (Sun Java(tm) System Messaging Server 6.3-9.01 (built Oct 22 2009; 32bit))
 with ESMTP id <0L1Y005YHLXZVNB0@mxout3.netvision.net.il> for
 linux-ext4@vger.kernel.org; Wed, 05 May 2010 21:28:22 +0300 (IDT)
In-reply-to: <1273084136-6286-1-git-send-email-amir73il@users.sf.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Next3 transactions reserve up to 24 times more credits than Ext3
transactions for the same operation.  On mke2fs and tune2fs, if the
'big_journal' feature is set along with the 'has_journal' feature,
increase the default journal size by a factor of 24.

Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 lib/ext2fs/ext2_fs.h   |   11 ++++++++++
 lib/ext2fs/ext2fs.h    |    2 +
 lib/ext2fs/mkjournal.c |   49 ++++++++++++++++++++++++++++++++++++++++++++++++
 misc/mke2fs.c          |    1 +
 misc/tune2fs.c         |   23 +++++++++++++++++++++-
 misc/util.c            |   14 +++++++++++++
 6 files changed, 99 insertions(+), 1 deletions(-)

diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 35b9ac3..7a1fc58 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -621,6 +621,17 @@ struct ext2_super_block {
 #define EXT3_JNL_BACKUP_BLOCKS	1
 
 /*
+ * 'big journal' needs to accomodate extra snapshot COW credits
+ * default size accomodates maximum possible COW credits
+ * minimum required size accomodates the avarage COW credits
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
index c2d9fb9..2af8f1c 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1222,6 +1222,8 @@ extern errcode_t ext2fs_add_journal_device(ext2_filsys fs,
 extern errcode_t ext2fs_add_journal_inode(ext2_filsys fs, blk_t size,
 					  int flags);
 extern int ext2fs_default_journal_size(__u64 blocks);
+extern int ext2fs_big_journal_size(__u64 blocks);
+extern int ext2fs_check_journal_size(ext2_filsys fs);
 
 /* openfs.c */
 extern errcode_t ext2fs_open(const char *name, int flags, int superblock,
diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index 6afbbde..c68cdaa 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -400,6 +400,54 @@ int ext2fs_default_journal_size(__u64 blocks)
 	return 32768;
 }
 
+/* 
+ * Big journal is up to 24 times bigger than the default journal
+ * to accomodate snapshot COW credits in transactions.
+ * journal size is restricted to 1/32 of the filesystem size
+ */
+int ext2fs_big_journal_size(__u64 blocks)
+{
+	int mega_blocks = blocks >> 20;
+	if (!mega_blocks)
+		return -1;
+
+	if (mega_blocks < NEXT3_MAX_COW_CREDITS)
+		/* 32K/1M = 1/32 of filesystem size */
+		return 32768*mega_blocks;
+	
+	/* 24 times bigger than the default journal */
+	return 32768*NEXT3_MAX_COW_CREDITS;
+}
+
+/*
+ * Find the number of blocks in the journal inode
+ * and adjust the file system 'big_journal' feature accordingy
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
+	/* fix the 'big_journal' feature */
+	if (j_blocks >= NEXT3_MIN_JOURNAL_BLOCKS)
+		fs->super->s_feature_compat |= NEXT3_FEATURE_COMPAT_BIG_JOURNAL;
+	else
+		fs->super->s_feature_compat &= ~NEXT3_FEATURE_COMPAT_BIG_JOURNAL;
+
+	return j_blocks;
+}
+
 /*
  * This function adds a journal device to a filesystem
  */
@@ -553,6 +601,7 @@ errcode_t ext2fs_add_journal_inode(ext2_filsys fs, blk_t size, int flags)
 	       sizeof(fs->super->s_journal_uuid));
 	fs->super->s_feature_compat |= EXT3_FEATURE_COMPAT_HAS_JOURNAL;
 
+	ext2fs_check_journal_size(fs);
 	ext2fs_mark_super_dirty(fs);
 	return 0;
 errout:
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 022c12c..0859d61 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -781,6 +781,7 @@ static void parse_extended_opts(struct ext2_super_block *param,
 static __u32 ok_features[3] = {
 	/* Compat */
 	EXT3_FEATURE_COMPAT_HAS_JOURNAL |
+		NEXT3_FEATURE_COMPAT_BIG_JOURNAL |
 		EXT2_FEATURE_COMPAT_RESIZE_INODE |
 		EXT2_FEATURE_COMPAT_DIR_INDEX |
 		EXT2_FEATURE_COMPAT_EXT_ATTR,
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 847b3e2..b4733e8 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -119,6 +119,7 @@ static void usage(void)
 static __u32 ok_features[3] = {
 	/* Compat */
 	EXT3_FEATURE_COMPAT_HAS_JOURNAL |
+		NEXT3_FEATURE_COMPAT_BIG_JOURNAL |
 		EXT2_FEATURE_COMPAT_DIR_INDEX,
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
@@ -136,6 +137,7 @@ static __u32 ok_features[3] = {
 static __u32 clear_ok_features[3] = {
 	/* Compat */
 	EXT3_FEATURE_COMPAT_HAS_JOURNAL |
+		NEXT3_FEATURE_COMPAT_BIG_JOURNAL |
 		EXT2_FEATURE_COMPAT_RESIZE_INODE |
 		EXT2_FEATURE_COMPAT_DIR_INDEX,
 	/* Incompat */
@@ -403,6 +405,23 @@ static void update_feature_set(ext2_filsys fs, char *features)
 		sb->s_feature_compat &= ~EXT3_FEATURE_COMPAT_HAS_JOURNAL;
 	}
 
+	if (FEATURE_CHANGED(E2P_FEATURE_COMPAT, NEXT3_FEATURE_COMPAT_BIG_JOURNAL)) {
+		if (sb->s_feature_compat &
+		    EXT3_FEATURE_COMPAT_HAS_JOURNAL) {
+			/* update 'big_journal' flag according to existing journal size */
+			ext2fs_check_journal_size(fs);
+			if (!FEATURE_CHANGED(E2P_FEATURE_COMPAT, NEXT3_FEATURE_COMPAT_BIG_JOURNAL))
+				fputs(_("the filesystem already has a journal.\n"
+							"Please remove it before changing "
+							"the big_journal flag.\n"), stderr);
+		}
+		else if (sb->s_feature_compat & NEXT3_FEATURE_COMPAT_BIG_JOURNAL) {
+			/* create 'big_journal' */
+			if (!journal_size)
+				journal_size = -1;
+		}
+	}
+
 	if (FEATURE_ON(E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT_DIR_INDEX)) {
 		if (!sb->s_def_hash_version)
 			sb->s_def_hash_version = EXT2_HASH_HALF_MD4;
@@ -1792,8 +1811,10 @@ retry_open:
 		}
 	}
 
-	if (l_flag)
+	if (l_flag) {
+		ext2fs_check_journal_size(fs);
 		list_super(sb);
+	}
 	if (stride_set) {
 		sb->s_raid_stride = stride;
 		ext2fs_mark_super_dirty(fs);
diff --git a/misc/util.c b/misc/util.c
index b8a3cac..8646b8d 100644
--- a/misc/util.c
+++ b/misc/util.c
@@ -259,6 +259,20 @@ unsigned int figure_journal_size(int size, ext2_filsys fs)
 		return 0;
 	}
 
+	if (fs->super->s_feature_compat & NEXT3_FEATURE_COMPAT_BIG_JOURNAL) {
+		/* big journal requested */
+		j_blocks = ext2fs_big_journal_size(fs->super->s_blocks_count);
+		if (j_blocks < NEXT3_MIN_JOURNAL_BLOCKS) {
+			fputs(_("\nFilesystem too small for a big journal.  "),
+					stderr);
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

