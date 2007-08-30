From: Valerie Clement <valerie.clement@bull.net>
Subject: [PATCH 3/8][e2fsprogs] add new -D <desc-size> option to mkfs
Date: Thu, 30 Aug 2007 17:37:01 +0200
Message-ID: <1188488221.15770.46.camel@ext1.frec.bull.fr>
References: <1188487715.15770.35.camel@ext1.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4 <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43736 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757874AbXH3N0k (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 30 Aug 2007 09:26:40 -0400
In-Reply-To: <1188487715.15770.35.camel@ext1.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


From: Valerie Clement <valerie.clement@bull.net>

This patch adds a new option -D <descriptor-size> to mkfs to allow creating
ext4 filesystems with larger group descriptor size.

By default, the group descriptor size is 32 bytes.
To support 64-bit physical block numbers and thus to be able to use filesystems
 > 16TB, the group descriptor size must be increased to 64 bytes.

Use mkfs -t ext4 -D 64 to create an ext4 filesystem with 64-byte group
descriptor size. This set the EXT4_FEATURE_INCOMPAT_64BIT flag on device.

The descriptor size is limited to a power-of-two value and to the block size.

Signed-off-by: Valerie Clement <valerie.clement@bull.net>
---

 lib/ext2fs/ext2_fs.h    |    7 +++++++
 lib/ext2fs/initialize.c |    1 +
 misc/mke2fs.c           |   33 +++++++++++++++++++++++++++++++--
 3 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index a316665..f6e8b36 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -217,6 +217,13 @@ struct ext2_dx_countlimit {
 /*
  * Macro-instructions used to manage group descriptors
  */
+#define EXT2_MIN_DESC_SIZE		32
+#define EXT2_MIN_DESC_SIZE_64BIT	64
+#define EXT2_MAX_DESC_SIZE		EXT2_MIN_BLOCK_SIZE
+#define EXT2_DESC_SIZE(s)						\
+	((EXT2_SB(s)->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT) ? \
+	 (s)->s_desc_size : EXT2_MIN_DESC_SIZE)
+
 #define EXT2_BLOCKS_PER_GROUP(s)	(EXT2_SB(s)->s_blocks_per_group)
 #define EXT2_INODES_PER_GROUP(s)	(EXT2_SB(s)->s_inodes_per_group)
 #define EXT2_INODES_PER_BLOCK(s)	(EXT2_BLOCK_SIZE(s)/EXT2_INODE_SIZE(s))
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 16e9eaa..ee7af93 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -149,6 +149,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 
 	set_field(s_log_block_size, 0);	/* default blocksize: 1024 bytes */
 	set_field(s_log_frag_size, 0); /* default fragsize: 1024 bytes */
+	set_field(s_desc_size, 0);
 	set_field(s_first_data_block, super->s_log_block_size ? 0 : 1);
 	set_field(s_max_mnt_count, EXT2_DFL_MAX_MNT_COUNT);
 	set_field(s_errors, EXT2_ERRORS_DEFAULT);
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 4a6cace..115eef9 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -96,7 +96,7 @@ static void usage(void)
 {
 	fprintf(stderr, _("Usage: %s [-c|-t|-l filename] [-b block-size] "
 	"[-f fragment-size]\n\t[-i bytes-per-inode] [-I inode-size] "
-	"[-j] [-J journal-options]\n"
+	"[-D descriptor-size] [-j] [-J journal-options]\n"
 	"\t[-N number-of-inodes] [-m reserved-blocks-percentage] "
 	"[-o creator-os]\n\t[-g blocks-per-group] [-L volume-label] "
 	"[-M last-mounted-directory]\n\t[-O feature[,...]] "
@@ -911,6 +911,7 @@ static void PRS(int argc, char *argv[])
 	int		blocksize = 0;
 	int		inode_ratio = 0;
 	int		inode_size = 0;
+	int		desc_size = 0;
 	double		reserved_ratio = 5.0;
 	int		sector_size = 0;
 	int		show_version_only = 0;
@@ -993,7 +994,7 @@ static void PRS(int argc, char *argv[])
 	}
 
 	while ((c = getopt (argc, argv,
-		    "b:cf:g:i:jl:m:no:qr:s:tvE:FI:J:L:M:N:O:R:ST:V")) != EOF) {
+		    "b:cf:g:i:jl:m:no:qr:s:tvD:E:FI:J:L:M:N:O:R:ST:V")) != EOF) {
 		switch (c) {
 		case 'b':
 			blocksize = strtol(optarg, &tmp, 0);
@@ -1110,6 +1111,14 @@ static void PRS(int argc, char *argv[])
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
@@ -1439,6 +1448,26 @@ static void PRS(int argc, char *argv[])
 		}
 	}
 
+	if (desc_size) {
+		if (desc_size < EXT2_MIN_DESC_SIZE ||
+		    desc_size > EXT2_BLOCK_SIZE(&fs_param) ||
+		    desc_size & (desc_size -1)) {
+			com_err(program_name, 0,
+				_("invalid descriptor size %d (min %d/max %d)"),
+				desc_size, EXT2_MIN_DESC_SIZE,
+				blocksize);
+			exit(1);
+		}
+		if (desc_size != EXT2_MIN_DESC_SIZE)
+			fprintf(stderr, _("Warning: %d-byte descriptors not "
+				"usable on older systems\n"),
+				desc_size);
+		fs_param.s_desc_size = desc_size;
+		if (desc_size > EXT2_MIN_DESC_SIZE)
+			fs_param.s_feature_incompat |= EXT4_FEATURE_INCOMPAT_64BIT;
+	}
+
+
 	if (!force && fs_param.s_blocks_count >= ((unsigned) 1 << 31)) {
 		com_err(program_name, 0,
 			_("Filesystem too large.  No more than 2**31-1 blocks\n"
