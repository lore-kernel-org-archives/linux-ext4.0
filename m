From: Theodore Tso <tytso@MIT.EDU>
Subject: [PATCH 1 of 4] Add default journal size function
Date: Thu, 21 Jun 2007 13:00:08 -0400
Message-ID: <5daddb24f35d514c4d21.1182445208@candygram.thunk.org>
References: <patchbomb.1182445207@candygram.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: kalpak@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:55955 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755072AbXFURBr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Jun 2007 13:01:47 -0400
In-Reply-To: <patchbomb.1182445207@candygram.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

3 files changed, 26 insertions(+), 18 deletions(-)
lib/ext2fs/ext2fs.h    |    1 +
lib/ext2fs/mkjournal.c |   20 ++++++++++++++++++++
misc/util.c            |   23 +++++------------------


# HG changeset patch
# User tytso@mit.edu
# Date 1182441546 14400
# Node ID 5daddb24f35d514c4d21a7d79bd470439b74866e
# Parent  ee079e7cb509d2da74a65411e670efaa5e88850a
Add default journal size function

Factor out the code which sets the default journal size and move it
into libext2fs.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff -r ee079e7cb509 -r 5daddb24f35d lib/ext2fs/ext2fs.h
--- a/lib/ext2fs/ext2fs.h	Tue Jun 19 03:29:47 2007 -0400
+++ b/lib/ext2fs/ext2fs.h	Thu Jun 21 11:59:06 2007 -0400
@@ -881,6 +881,7 @@ extern errcode_t ext2fs_add_journal_devi
 					   ext2_filsys journal_dev);
 extern errcode_t ext2fs_add_journal_inode(ext2_filsys fs, blk_t size,
 					  int flags);
+extern int ext2fs_default_journal_size(__u64 blocks);
 
 /* openfs.c */
 extern errcode_t ext2fs_open(const char *name, int flags, int superblock,
diff -r ee079e7cb509 -r 5daddb24f35d lib/ext2fs/mkjournal.c
--- a/lib/ext2fs/mkjournal.c	Tue Jun 19 03:29:47 2007 -0400
+++ b/lib/ext2fs/mkjournal.c	Thu Jun 21 11:59:06 2007 -0400
@@ -248,6 +248,26 @@ errout:
 }
 
 /*
+ * Find a reasonable journal file size (in blocks) given the number of blocks
+ * in the filesystem.  For very small filesystems, it is not reasonable to
+ * have a journal that fills more than half of the filesystem.
+ */
+int ext2fs_default_journal_size(__u64 blocks)
+{
+	if (blocks < 2048)
+		return -1;
+	if (blocks < 32768)
+		return (1024);
+	if (blocks < 256*1024)
+		return (4096);
+	if (blocks < 512*1024)
+		return (8192);
+	if (blocks < 1024*1024)
+		return (16384);
+	return 32768;
+}
+
+/*
  * This function adds a journal device to a filesystem
  */
 errcode_t ext2fs_add_journal_device(ext2_filsys fs, ext2_filsys journal_dev)
diff -r ee079e7cb509 -r 5daddb24f35d misc/util.c
--- a/misc/util.c	Tue Jun 19 03:29:47 2007 -0400
+++ b/misc/util.c	Thu Jun 21 11:59:06 2007 -0400
@@ -251,9 +251,10 @@ void parse_journal_opts(const char *opts
  */
 int figure_journal_size(int size, ext2_filsys fs)
 {
-	blk_t j_blocks;
-
-	if (fs->super->s_blocks_count < 2048) {
+	int j_blocks;
+
+	j_blocks = ext2fs_default_journal_size(fs->super->s_blocks_count);
+	if (j_blocks < 0) {
 		fputs(_("\nFilesystem too small for a journal\n"), stderr);
 		return 0;
 	}
@@ -273,21 +274,7 @@ int figure_journal_size(int size, ext2_f
 			      stderr);
 			exit(1);
 		}
-		return j_blocks;
-	}
-
-	if (fs->super->s_blocks_count < 32768)
-		j_blocks = 1400;
-	else if (fs->super->s_blocks_count < 256*1024)
-		j_blocks = 4096;
-	else if (fs->super->s_blocks_count < 512*1024)
-		j_blocks = 8192;
-	else if (fs->super->s_blocks_count < 1024*1024)
-		j_blocks = 16384;
-	else
-		j_blocks = 32768;
-
-
+	}
 	return j_blocks;
 }
 
