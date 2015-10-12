From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 4/8] ext4: store checksum seed in superblock
Date: Mon, 12 Oct 2015 14:54:44 -0700
Message-ID: <20151012215444.28872.23113.stgit@birch.djwong.org>
References: <20151012215416.28872.8160.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39149 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbbJLVyu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Oct 2015 17:54:50 -0400
In-Reply-To: <20151012215416.28872.8160.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Allow the filesystem to store the metadata checksum seed in the
superblock and add an incompat feature to say that we're using it.
This enables tune2fs to change the UUID on a mounted metadata_csum
FS without having to (racy!) rewrite all disk metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/ext4.h  |    8 +++++---
 fs/ext4/super.c |    6 +++++-
 2 files changed, 10 insertions(+), 4 deletions(-)


diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index fd1f28b..81ce8ae 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1179,7 +1179,8 @@ struct ext4_super_block {
 	__u8	s_encrypt_algos[4];	/* Encryption algorithms in use  */
 	__u8	s_encrypt_pw_salt[16];	/* Salt used for string2key algorithm */
 	__le32	s_lpf_ino;		/* Location of the lost+found inode */
-	__le32	s_reserved[100];	/* Padding to the end of the block */
+	__le32	s_checksum_seed;	/* crc32c(uuid) if csum_seed set */
+	__le32	s_reserved[99];		/* Padding to the end of the block */
 	__le32	s_checksum;		/* crc32c(superblock) */
 };
 
@@ -1578,7 +1579,7 @@ static inline int ext4_encrypted_inode(struct inode *inode)
 #define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
 #define EXT4_FEATURE_INCOMPAT_EA_INODE		0x0400 /* EA in inode */
 #define EXT4_FEATURE_INCOMPAT_DIRDATA		0x1000 /* data in dirent */
-#define EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM	0x2000 /* use crc32c for bg */
+#define EXT4_FEATURE_INCOMPAT_CSUM_SEED		0x2000
 #define EXT4_FEATURE_INCOMPAT_LARGEDIR		0x4000 /* >2GB or 3-lvl htree */
 #define EXT4_FEATURE_INCOMPAT_INLINE_DATA	0x8000 /* data in inode */
 #define EXT4_FEATURE_INCOMPAT_ENCRYPT		0x10000
@@ -1607,7 +1608,8 @@ static inline int ext4_encrypted_inode(struct inode *inode)
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG| \
 					 EXT4_FEATURE_INCOMPAT_MMP | \
 					 EXT4_FEATURE_INCOMPAT_INLINE_DATA | \
-					 EXT4_FEATURE_INCOMPAT_ENCRYPT)
+					 EXT4_FEATURE_INCOMPAT_ENCRYPT | \
+					 EXT4_FEATURE_INCOMPAT_CSUM_SEED)
 #define EXT4_FEATURE_RO_COMPAT_SUPP	(EXT4_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT4_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM| \
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index a63c7b0..ec9ccb2 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2724,12 +2724,14 @@ EXT4_INFO_ATTR(lazy_itable_init);
 EXT4_INFO_ATTR(batched_discard);
 EXT4_INFO_ATTR(meta_bg_resize);
 EXT4_INFO_ATTR(encryption);
+EXT4_INFO_ATTR(metadata_csum_seed);
 
 static struct attribute *ext4_feat_attrs[] = {
 	ATTR_LIST(lazy_itable_init),
 	ATTR_LIST(batched_discard),
 	ATTR_LIST(meta_bg_resize),
 	ATTR_LIST(encryption),
+	ATTR_LIST(metadata_csum_seed),
 	NULL,
 };
 
@@ -3561,7 +3563,9 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	/* Precompute checksum seed for all metadata */
-	if (ext4_has_metadata_csum(sb))
+	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_CSUM_SEED))
+		sbi->s_csum_seed = le32_to_cpu(es->s_checksum_seed);
+	else if (ext4_has_metadata_csum(sb))
 		sbi->s_csum_seed = ext4_chksum(sbi, ~0, es->s_uuid,
 					       sizeof(es->s_uuid));
 

