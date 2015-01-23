From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] Reserve the codepoints for the new INCOMPAT feature ENCRYPT
Date: Fri, 23 Jan 2015 12:57:47 -0500
Message-ID: <1422035867-28831-1-git-send-email-tytso@mit.edu>
Cc: mhalcrow@google.com, savagaon@google.com, muslukhovi@gmail.com,
	Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57688 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754098AbbAWR5w (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Jan 2015 12:57:52 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 debugfs/set_fields.c        |  2 ++
 lib/e2p/feature.c           |  2 ++
 lib/e2p/pf.c                |  2 +-
 lib/ext2fs/ext2_fs.h        | 13 +++++++++++--
 lib/ext2fs/ext2fs.h         |  2 +-
 lib/ext2fs/tst_super_size.c |  3 ++-
 misc/chattr.1.in            |  4 ++--
 7 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index 7460c28..60695ad 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -165,6 +165,8 @@ static struct field_set_info super_fields[] = {
 	{ "last_error_block", &set_sb.s_last_error_block, NULL, 8, parse_uint },
 	{ "last_error_func", &set_sb.s_last_error_func, NULL, 32, parse_string },
 	{ "last_error_line", &set_sb.s_last_error_ino, NULL, 4, parse_uint },
+	{ "encrypt_algos", &set_sb.s_encrypt_algos, NULL, 1, parse_uint,
+	  FLAG_ARRAY, 4 },
 	{ 0, 0, 0, 0 }
 };
 
diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index 6e53cfe..30d2db1 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -97,6 +97,8 @@ static struct feature feature_list[] = {
 			"large_dir"},
 	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_INLINE_DATA,
 			"inline_data"},
+	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_ENCRYPT,
+			"encrypt"},
 	{	0, 0, 0 },
 };
 
diff --git a/lib/e2p/pf.c b/lib/e2p/pf.c
index f116ac3..788c445 100644
--- a/lib/e2p/pf.c
+++ b/lib/e2p/pf.c
@@ -41,8 +41,8 @@ static struct flags_name flags_array[] = {
 	{ EXT2_COMPRBLK_FL, "B", "Compressed_File" },
 	{ EXT2_DIRTY_FL, "Z", "Compressed_Dirty_File" },
 	{ EXT2_NOCOMPR_FL, "X", "Compression_Raw_Access" },
-	{ EXT2_ECOMPR_FL, "E", "Compression_Error" },
 #endif
+	{ EXT4_ENCRYPT_FL, "E", "Encrypted" },
 	{ EXT3_JOURNAL_DATA_FL, "j", "Journaled_Data" },
 	{ EXT2_INDEX_FL, "I", "Indexed_directory" },
 	{ EXT2_NOTAIL_FL, "t", "No_Tailmerging" },
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 2b24080..541bef2 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -307,7 +307,8 @@ struct ext2_dx_tail {
 #define EXT2_DIRTY_FL			0x00000100
 #define EXT2_COMPRBLK_FL		0x00000200 /* One or more compressed clusters */
 #define EXT2_NOCOMPR_FL			0x00000400 /* Access raw compressed data */
-#define EXT2_ECOMPR_FL			0x00000800 /* Compression error */
+	/* nb: was previously EXT2_ECOMPR_FL */
+#define EXT4_ENCRYPT_FL			0x00000800 /* encrypted file */
 /* End compression flags --- maybe not all used */
 #define EXT2_BTREE_FL			0x00001000 /* btree format dir */
 #define EXT2_INDEX_FL			0x00001000 /* hash-indexed directory */
@@ -564,6 +565,12 @@ struct ext2_inode_large {
 /* Metadata checksum algorithms */
 #define EXT2_CRC32C_CHKSUM		1
 
+/* Encryption algorithms */
+#define EXT4_ENCRYPTION_MODE_INVALID		0
+#define EXT4_ENCRYPTION_MODE_AES_256_XTS	1
+#define EXT4_ENCRYPTION_MODE_AES_256_GCM	2
+#define EXT4_ENCRYPTION_MODE_AES_256_CBC	3
+
 /*
  * Structure of the super block
  */
@@ -675,7 +682,8 @@ struct ext2_super_block {
 	__u32	s_grp_quota_inum;	/* inode number of group quota file */
 	__u32	s_overhead_blocks;	/* overhead blocks/clusters in fs */
 	__u32	s_backup_bgs[2];	/* If sparse_super2 enabled */
-	__u32   s_reserved[106];        /* Padding to the end of the block */
+	__u8	s_encrypt_algos[4];	/* Encryption algorithms in use  */
+	__u32   s_reserved[105];        /* Padding to the end of the block */
 	__u32	s_checksum;		/* crc32c(superblock) */
 };
 
@@ -761,6 +769,7 @@ struct ext2_super_block {
 /* 0x2000 was EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM but this was never used */
 #define EXT4_FEATURE_INCOMPAT_LARGEDIR		0x4000 /* >2GB or 3-lvl htree */
 #define EXT4_FEATURE_INCOMPAT_INLINE_DATA	0x8000 /* data in inode */
+#define EXT4_FEATURE_INCOMPAT_ENCRYPT		0x10000
 
 #define EXT2_FEATURE_COMPAT_SUPP	0
 #define EXT2_FEATURE_INCOMPAT_SUPP    (EXT2_FEATURE_INCOMPAT_FILETYPE| \
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 42c4ce1..f090df1 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -614,7 +614,7 @@ typedef struct ext2_icount *ext2_icount_t;
  * These features are only allowed if EXT2_FLAG_SOFTSUPP_FEATURES is passed
  * to ext2fs_openfs()
  */
-#define EXT2_LIB_SOFTSUPP_INCOMPAT	(EXT4_FEATURE_INCOMPAT_INLINE_DATA)
+#define EXT2_LIB_SOFTSUPP_INCOMPAT	(EXT4_FEATURE_INCOMPAT_ENCRYPT)
 #define EXT2_LIB_SOFTSUPP_RO_COMPAT	(EXT4_FEATURE_RO_COMPAT_REPLICA)
 
 
diff --git a/lib/ext2fs/tst_super_size.c b/lib/ext2fs/tst_super_size.c
index b085bbb..f6c74f7 100644
--- a/lib/ext2fs/tst_super_size.c
+++ b/lib/ext2fs/tst_super_size.c
@@ -136,7 +136,8 @@ int main(int argc, char **argv)
 	check_field(s_grp_quota_inum, 4);
 	check_field(s_overhead_blocks, 4);
 	check_field(s_backup_bgs, 8);
-	check_field(s_reserved, 106 * 4);
+	check_field(s_encrypt_algos, 4);
+	check_field(s_reserved, 105 * 4);
 	check_field(s_checksum, 4);
 	do_field("Superblock end", 0, 0, cur_offset, 1024);
 #endif
diff --git a/misc/chattr.1.in b/misc/chattr.1.in
index 75b3ed8..33ef9a2 100644
--- a/misc/chattr.1.in
+++ b/misc/chattr.1.in
@@ -107,8 +107,8 @@ The 'e' attribute indicates that the file is using extents for mapping
 the blocks on disk.  It may not be removed using
 .BR chattr (1).
 .PP
-The 'E' attribute is used by the experimental compression patches to
-indicate that a compressed file has a compression error.  It may not be
+The 'E' attribute is used by the experimental encryption patches to
+indicate that the file has been encrypted.  It may not be
 set or reset using
 .BR chattr (1),
 although it can be displayed by
-- 
2.1.0

