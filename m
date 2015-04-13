From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH-v2 02/20] ext4 crypto: reserve codepoints used by the ext4 encryption feature
Date: Sun, 12 Apr 2015 23:16:18 -0400
Message-ID: <1428894996-7852-3-git-send-email-tytso@mit.edu>
References: <1428894996-7852-1-git-send-email-tytso@mit.edu>
Cc: mhalcrow@google.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35601 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752538AbbDMDQ6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 12 Apr 2015 23:16:58 -0400
In-Reply-To: <1428894996-7852-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Change-Id: I5f01f62e75426150c32c22188ae8ad3192da95e6
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/ext4.h | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 06e8add..2baab1e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -364,7 +364,8 @@ struct flex_groups {
 #define EXT4_DIRTY_FL			0x00000100
 #define EXT4_COMPRBLK_FL		0x00000200 /* One or more compressed clusters */
 #define EXT4_NOCOMPR_FL			0x00000400 /* Don't compress */
-#define EXT4_ECOMPR_FL			0x00000800 /* Compression error */
+	/* nb: was previously EXT2_ECOMPR_FL */
+#define EXT4_ENCRYPT_FL			0x00000800 /* encrypted file */
 /* End compression flags --- maybe not all used */
 #define EXT4_INDEX_FL			0x00001000 /* hash-indexed directory */
 #define EXT4_IMAGIC_FL			0x00002000 /* AFS directory */
@@ -417,11 +418,11 @@ enum {
 	EXT4_INODE_APPEND	= 5,	/* writes to file may only append */
 	EXT4_INODE_NODUMP	= 6,	/* do not dump file */
 	EXT4_INODE_NOATIME	= 7,	/* do not update atime */
-/* Reserved for compression usage... */
+/* Reserved for compression usage, co-opted for encryption usage */
 	EXT4_INODE_DIRTY	= 8,
 	EXT4_INODE_COMPRBLK	= 9,	/* One or more compressed clusters */
 	EXT4_INODE_NOCOMPR	= 10,	/* Don't compress */
-	EXT4_INODE_ECOMPR	= 11,	/* Compression error */
+	EXT4_INODE_ENCRYPT	= 11,	/* Encrypted */
 /* End compression flags --- maybe not all used */
 	EXT4_INODE_INDEX	= 12,	/* hash-indexed directory */
 	EXT4_INODE_IMAGIC	= 13,	/* AFS directory */
@@ -466,7 +467,7 @@ static inline void ext4_check_flag_values(void)
 	CHECK_FLAG_VALUE(DIRTY);
 	CHECK_FLAG_VALUE(COMPRBLK);
 	CHECK_FLAG_VALUE(NOCOMPR);
-	CHECK_FLAG_VALUE(ECOMPR);
+	CHECK_FLAG_VALUE(ENCRYPT);
 	CHECK_FLAG_VALUE(INDEX);
 	CHECK_FLAG_VALUE(IMAGIC);
 	CHECK_FLAG_VALUE(JOURNAL_DATA);
@@ -581,6 +582,13 @@ enum {
 #define EXT4_FREE_BLOCKS_NOFREE_FIRST_CLUSTER	0x0010
 #define EXT4_FREE_BLOCKS_NOFREE_LAST_CLUSTER	0x0020
 
+/* Encryption algorithms */
+#define EXT4_ENCRYPTION_MODE_INVALID		0
+#define EXT4_ENCRYPTION_MODE_AES_256_XTS	1
+#define EXT4_ENCRYPTION_MODE_AES_256_GCM	2
+#define EXT4_ENCRYPTION_MODE_AES_256_CBC	3
+#define EXT4_ENCRYPTION_MODE_AES_256_CTS	4
+
 /*
  * ioctl commands
  */
@@ -1130,7 +1138,8 @@ struct ext4_super_block {
 	__le32  s_raid_stripe_width;    /* blocks on all data disks (N*stride)*/
 	__u8	s_log_groups_per_flex;  /* FLEX_BG group size */
 	__u8	s_checksum_type;	/* metadata checksum algorithm used */
-	__le16  s_reserved_pad;
+	__u8	s_encryption_level;	/* versioning level for encryption */
+	__u8	s_reserved_pad;		/* Padding to next 32bits */
 	__le64	s_kbytes_written;	/* nr of lifetime kilobytes written */
 	__le32	s_snapshot_inum;	/* Inode number of active snapshot */
 	__le32	s_snapshot_id;		/* sequential ID of active snapshot */
@@ -1156,7 +1165,10 @@ struct ext4_super_block {
 	__le32	s_grp_quota_inum;	/* inode for tracking group quota */
 	__le32	s_overhead_clusters;	/* overhead blocks/clusters in fs */
 	__le32	s_backup_bgs[2];	/* groups with sparse_super2 SBs */
-	__le32	s_reserved[106];	/* Padding to the end of the block */
+	__u8	s_encrypt_algos[4];	/* Encryption algorithms in use  */
+	__u8	s_encrypt_pw_salt[16];	/* Salt used for string2key algorithm */
+	__le32	s_lpf_ino;		/* Location of the lost+found inode */
+	__le32	s_reserved[100];	/* Padding to the end of the block */
 	__le32	s_checksum;		/* crc32c(superblock) */
 };
 
@@ -1537,6 +1549,7 @@ static inline void ext4_clear_state_flags(struct ext4_inode_info *ei)
 #define EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM	0x2000 /* use crc32c for bg */
 #define EXT4_FEATURE_INCOMPAT_LARGEDIR		0x4000 /* >2GB or 3-lvl htree */
 #define EXT4_FEATURE_INCOMPAT_INLINE_DATA	0x8000 /* data in inode */
+#define EXT4_FEATURE_INCOMPAT_ENCRYPT		0x10000
 
 #define EXT2_FEATURE_COMPAT_SUPP	EXT4_FEATURE_COMPAT_EXT_ATTR
 #define EXT2_FEATURE_INCOMPAT_SUPP	(EXT4_FEATURE_INCOMPAT_FILETYPE| \
-- 
2.3.0

