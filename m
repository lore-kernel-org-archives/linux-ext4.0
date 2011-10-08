From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 33/47] libext2fs: Record the checksum algorithm in use in the
	superblock
Date: Sat, 08 Oct 2011 00:36:47 -0700
Message-ID: <20111008073647.17888.17591.stgit@elm3c44.beaverton.ibm.com>
References: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	"Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:49900 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab1JHHjP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 03:39:15 -0400
Received: from d01relay03.pok.ibm.com (d01relay03.pok.ibm.com [9.56.227.235])
	by e6.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p987CesG024147
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:12:40 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay03.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987aoUr239092
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:36:50 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987amxn019089
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:36:50 -0400
In-Reply-To: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Record the type of checksum algorithm we're using for metadata in the
superblock, in case we ever want/need to change the algorithm.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 debugfs/set_fields.c      |    1 +
 lib/e2p/ls.c              |   15 ++++++++++++++-
 lib/ext2fs/csum.c         |    9 +++++++++
 lib/ext2fs/ext2_err.et.in |    3 +++
 lib/ext2fs/ext2_fs.h      |    5 ++++-
 lib/ext2fs/ext2fs.h       |    1 +
 lib/ext2fs/openfs.c       |   12 ++++++++----
 7 files changed, 40 insertions(+), 6 deletions(-)


diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index d461275..0103497 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -148,6 +148,7 @@ static struct field_set_info super_fields[] = {
 	{ "grp_quota_inum", &set_sb.s_grp_quota_inum, NULL, 4, parse_uint },
 	{ "overhead_blocks", &set_sb.s_overhead_blocks, NULL, 4, parse_uint },
 	{ "checksum", &set_sb.s_checksum, NULL, 4, parse_uint },
+	{ "checksum_type", &set_sb.s_checksum_type, NULL, 1, parse_uint },
 	{ 0, 0, 0, 0 }
 };
 
diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
index f05e16d..d2e84eb 100644
--- a/lib/e2p/ls.c
+++ b/lib/e2p/ls.c
@@ -196,6 +196,16 @@ static __u64 e2p_free_blocks_count(struct ext2_super_block *super)
 #define EXT2_GOOD_OLD_REV 0
 #endif
 
+static const char *checksum_type(__u8 type)
+{
+	switch (type) {
+	case EXT2_CRC32C_CHKSUM:
+		return "crc32c";
+	default:
+		return "unknown";
+	}
+}
+
 void list_super2(struct ext2_super_block * sb, FILE *f)
 {
 	int inode_blocks_per_group;
@@ -421,9 +431,12 @@ void list_super2(struct ext2_super_block * sb, FILE *f)
 		fprintf(f, "Group quota inode:        %u\n",
 			sb->s_grp_quota_inum);
 
-	if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
+	if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) {
+		fprintf(f, "Checksum type:            %s\n",
+			checksum_type(sb->s_checksum_type));
 		fprintf(f, "Checksum:                 0x%08x\n",
 			sb->s_checksum);
+	}
 }
 
 void list_super (struct ext2_super_block * s)
diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index e2c32f4..9e4536e 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -30,6 +30,15 @@
 #define STATIC static
 #endif
 
+int ext2fs_verify_csum_type(ext2_filsys fs, struct ext2_super_block *sb)
+{
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 1;
+
+	return sb->s_checksum_type == EXT2_CRC32C_CHKSUM;
+}
+
 static __u32 ext2fs_superblock_csum(ext2_filsys fs, struct ext2_super_block *sb)
 {
 	int offset = offsetof(struct ext2_super_block, s_checksum);
diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index e4d2caa..3b92eac 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -458,4 +458,7 @@ ec	EXT2_ET_EXT_ATTR_BLOCK_CORRUPT,
 ec	EXT2_ET_SB_CSUM_INVALID,
 	"Superblock fails checksum"
 
+ec	EXT2_ET_UNKNOWN_CSUM,
+	"Unknown checksum algorithm"
+
 	end
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 3d2ade0..d6cd6e0 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -553,6 +553,9 @@ struct ext2_inode_large {
 #define ext4_offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
 #endif
 
+/* Metadata checksum algorithms */
+#define EXT2_CRC32C_CHKSUM		1
+
 /*
  * Structure of the super block
  */
@@ -638,7 +641,7 @@ struct ext2_super_block {
 	__u64   s_mmp_block;            /* Block for multi-mount protection */
 	__u32   s_raid_stripe_width;    /* blocks on all data disks (N*stride)*/
 	__u8	s_log_groups_per_flex;	/* FLEX_BG group size */
-	__u8    s_reserved_char_pad;
+	__u8    s_checksum_type;	/* metadata checksum algorithm */
 	__u16	s_reserved_pad;		/* Padding to next 32bits */
 	__u64	s_kbytes_written;	/* nr of lifetime kilobytes written */
 	__u32	s_snapshot_inum;	/* Inode number of active snapshot */
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index b921f83..9311336 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -929,6 +929,7 @@ extern __u32 ext2fs_crc32c_be(__u32 crc, unsigned char const *p, size_t len);
 extern __u32 ext2fs_crc32c_le(__u32 crc, unsigned char const *p, size_t len);
 
 /* csum.c */
+extern int ext2fs_verify_csum_type(ext2_filsys fs, struct ext2_super_block *sb);
 extern errcode_t ext2fs_superblock_csum_set(ext2_filsys fs,
 					    struct ext2_super_block *sb);
 extern int ext2fs_superblock_csum_verify(ext2_filsys fs,
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 334240c..2a672e0 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -203,10 +203,14 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 	}
 #endif
 
-	if (!(fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) &&
-	    !ext2fs_superblock_csum_verify(fs, fs->super)) {
-		retval = EXT2_ET_SB_CSUM_INVALID;
-		goto cleanup;
+	if (!(fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS)) {
+		retval = 0;
+		if (!ext2fs_verify_csum_type(fs, fs->super))
+			retval = EXT2_ET_UNKNOWN_CSUM;
+		if (!ext2fs_superblock_csum_verify(fs, fs->super))
+			retval = EXT2_ET_SB_CSUM_INVALID;
+		if (retval)
+			goto cleanup;
 	}
 
 	if (fs->super->s_magic != EXT2_SUPER_MAGIC) {

