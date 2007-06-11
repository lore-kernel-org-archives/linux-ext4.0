From: Valerie Clement <valerie.clement@bull.net>
Subject: [RFC][PATCH 10/12] add new mkfs option to create ext4 filesystems
Date: Mon, 11 Jun 2007 18:54:39 +0200
Message-ID: <466D7E4F.7090605@bull.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020201080003000807020400"
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:49378 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511AbXFKQxQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Jun 2007 12:53:16 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------020201080003000807020400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

This patch adds a new option to mkfs to allow creating ext4 filesystem.

  lib/ext2fs/ext2_fs.h    |    6 ++++++
  lib/ext2fs/initialize.c |    1 +
  misc/mke2fs.c           |   18 ++++++++++++++++--
  3 files changed, 23 insertions(+), 2 deletions(-)



--------------020201080003000807020400
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
 name="10-new-desc-size-option"
Content-Disposition: inline;
 filename="10-new-desc-size-option"

Index: e2fsprogs-1.39-tyt3-v6/misc/mke2fs.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/misc/mke2fs.c	2007-06-11 12:48:54.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/misc/mke2fs.c	2007-06-11 12:49:01.000000000 +0200
@@ -96,7 +96,7 @@ static void usage(void)
 {
 	fprintf(stderr, _("Usage: %s [-c|-t|-l filename] [-b block-size] "
 	"[-f fragment-size]\n\t[-i bytes-per-inode] [-I inode-size] "
-	"[-j] [-J journal-options]\n"
+	"[-D descriptor-size] [-j] [-J journal-options]\n"
 	"\t[-N number-of-inodes] [-m reserved-blocks-percentage] "
 	"[-o creator-os]\n\t[-g blocks-per-group] [-L volume-label] "
 	"[-M last-mounted-directory]\n\t[-O feature[,...]] "
@@ -903,6 +903,7 @@ static void PRS(int argc, char *argv[])
 	int		blocksize = 0;
 	int		inode_ratio = 0;
 	int		inode_size = 0;
+	int		desc_size = 0;
 	double		reserved_ratio = 5.0;
 	int		sector_size = 0;
 	int		show_version_only = 0;
@@ -981,7 +982,7 @@ static void PRS(int argc, char *argv[])
 	}
 
 	while ((c = getopt (argc, argv,
-		    "b:cf:g:i:jl:m:no:qr:s:tvE:FI:J:L:M:N:O:R:ST:V")) != EOF) {
+		    "b:cf:g:i:jl:m:no:qr:s:tvD:E:FI:J:L:M:N:O:R:ST:V")) != EOF) {
 		switch (c) {
 		case 'b':
 			blocksize = strtol(optarg, &tmp, 0);
@@ -1098,6 +1099,14 @@ static void PRS(int argc, char *argv[])
 				exit(1);
 			}
 			break;
+		case 'D':
+			desc_size = strtoul(optarg, &tmp, 0);
+			if (*tmp) {
+				com_err(program_name, 0,
+					_("invalid descriptor size - %s"), optarg);
+				exit(1);
+			}
+			break;
 		case 'v':
 			verbose = 1;
 			break;
@@ -1428,6 +1437,11 @@ static void PRS(int argc, char *argv[])
 		}
 	}
 
+	if (desc_size >= EXT2_MIN_DESC_SIZE_64BIT) {
+		fs_param.s_feature_incompat |= EXT4_FEATURE_INCOMPAT_64BIT;
+		fs_param.s_desc_size = EXT2_MIN_DESC_SIZE_64BIT;
+	}
+
 	if (!force && EXT2_BLOCKS_COUNT(&fs_param) >= ((unsigned) 1 << 31)) {
 		com_err(program_name, 0,
 			_("Filesystem too large.  No more than 2**31-1 blocks\n"
Index: e2fsprogs-1.39-tyt3-v6/lib/ext2fs/ext2_fs.h
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/lib/ext2fs/ext2_fs.h	2007-06-11 12:48:54.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/lib/ext2fs/ext2_fs.h	2007-06-11 12:49:01.000000000 +0200
@@ -217,6 +217,12 @@ struct ext2_dx_countlimit {
 /*
  * Macro-instructions used to manage group descriptors
  */
+#define EXT2_MIN_DESC_SIZE		32
+#define EXT2_MIN_DESC_SIZE_64BIT	64
+#define EXT2_MAX_DESC_SIZE		EXT2_MIN_BLOCK_SIZE
+#define EXT2_DESC_SIZE(s)						\
+	((EXT2_SB(s)->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT) ? \
+	 EXT2_MIN_DESC_SIZE_64BIT : EXT2_MIN_DESC_SIZE)
 #ifdef _EXT4FS_
 #define EXT2_BLOCKS_PER_GROUP(s)	((__u64)EXT2_SB(s)->s_blocks_per_group)
 #else
Index: e2fsprogs-1.39-tyt3-v6/lib/ext2fs/initialize.c
===================================================================
--- e2fsprogs-1.39-tyt3-v6.orig/lib/ext2fs/initialize.c	2007-06-11 12:48:52.000000000 +0200
+++ e2fsprogs-1.39-tyt3-v6/lib/ext2fs/initialize.c	2007-06-11 12:49:01.000000000 +0200
@@ -149,6 +149,7 @@ errcode_t ext2fs_initialize(const char *
 
 	set_field(s_log_block_size, 0);	/* default blocksize: 1024 bytes */
 	set_field(s_log_frag_size, 0); /* default fragsize: 1024 bytes */
+	set_field(s_desc_size, 0);
 	set_field(s_first_data_block, super->s_log_block_size ? 0 : 1);
 	set_field(s_max_mnt_count, EXT2_DFL_MAX_MNT_COUNT);
 	set_field(s_errors, EXT2_ERRORS_DEFAULT);

--------------020201080003000807020400--
