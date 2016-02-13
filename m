From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/9] libext2fs: store checksum seed in superblock
Date: Sat, 13 Feb 2016 14:37:32 -0800
Message-ID: <20160213223732.25381.26638.stgit@birch.djwong.org>
References: <20160213223725.25381.20929.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:33905 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbcBMWhi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Feb 2016 17:37:38 -0500
In-Reply-To: <20160213223725.25381.20929.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Allow the filesystem to store the metadata checksum seed in the
superblock and add an incompat feature to say that we're using it.
This enables tune2fs to change the UUID on a mounted metadata_csum
FS without having to (racy!) rewrite all disk metadata.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 debugfs/set_fields.c        |    1 +
 lib/e2p/feature.c           |    2 ++
 lib/e2p/ls.c                |    4 ++++
 lib/ext2fs/csum.c           |    9 +++++++++
 lib/ext2fs/ext2_fs.h        |    7 +++++--
 lib/ext2fs/ext2fs.h         |   13 +++----------
 lib/ext2fs/swapfs.c         |    1 +
 lib/ext2fs/tst_super_size.c |    4 +++-
 8 files changed, 28 insertions(+), 13 deletions(-)


diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index ec2340d..5b13c34 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -173,6 +173,7 @@ static struct field_set_info super_fields[] = {
 	  FLAG_ARRAY, 4 },
 	{ "encrypt_pw_salt", &set_sb.s_encrypt_pw_salt, NULL, 16, parse_uuid },
 	{ "lpf_ino", &set_sb.s_lpf_ino, NULL, 4, parse_uint },
+	{ "checksum_seed", &set_sb.s_checksum_seed, NULL, 4, parse_uint },
 	{ 0, 0, 0, 0 }
 };
 
diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index 737b0b9..35e8435 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -95,6 +95,8 @@ static struct feature feature_list[] = {
 			"ea_inode"},
 	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_DIRDATA,
 			"dirdata"},
+	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_CSUM_SEED,
+			"metadata_csum_seed"},
 	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_LARGEDIR,
 			"large_dir"},
 	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_INLINE_DATA,
diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
index 6c82857..8df6bb2 100644
--- a/lib/e2p/ls.c
+++ b/lib/e2p/ls.c
@@ -450,6 +450,10 @@ void list_super2(struct ext2_super_block * sb, FILE *f)
 	if (!e2p_is_null_uuid(sb->s_encrypt_pw_salt))
 		fprintf(f, "Encryption PW Salt:       %s\n",
 			e2p_uuid2str(sb->s_encrypt_pw_salt));
+
+	if (ext2fs_has_feature_csum_seed(sb))
+		fprintf(f, "Checksum seed:            0x%08x\n",
+			sb->s_checksum_seed);
 }
 
 void list_super (struct ext2_super_block * s)
diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index ab8b83f..ccb3057 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -30,6 +30,15 @@
 #define STATIC static
 #endif
 
+void ext2fs_init_csum_seed(ext2_filsys fs)
+{
+	if (ext2fs_has_feature_csum_seed(fs->super))
+		fs->csum_seed = fs->super->s_checksum_seed;
+	else if (ext2fs_has_feature_metadata_csum(fs->super))
+		fs->csum_seed = ext2fs_crc32c_le(~0, fs->super->s_uuid,
+						 sizeof(fs->super->s_uuid));
+}
+
 static __u32 ext2fs_mmp_csum(ext2_filsys fs, struct mmp_struct *mmp)
 {
 	int offset = offsetof(struct mmp_struct, mmp_checksum);
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 1f62c58..d884586 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -719,7 +719,9 @@ struct ext2_super_block {
 	__u8	s_encrypt_algos[4];	/* Encryption algorithms in use  */
 	__u8	s_encrypt_pw_salt[16];	/* Salt used for string2key algorithm */
 	__le32	s_lpf_ino;		/* Location of the lost+found inode */
-	__le32	s_reserved[100];	/* Padding to the end of the block */
+	__le32	s_prj_quota_inum;	/* inode for tracking project quota */
+	__le32	s_checksum_seed;	/* crc32c(orig_uuid) if csum_seed set */
+	__le32	s_reserved[98];		/* Padding to the end of the block */
 	__u32	s_checksum;		/* crc32c(superblock) */
 };
 
@@ -804,7 +806,7 @@ struct ext2_super_block {
 #define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
 #define EXT4_FEATURE_INCOMPAT_EA_INODE		0x0400
 #define EXT4_FEATURE_INCOMPAT_DIRDATA		0x1000
-/* 0x2000 was EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM but this was never used */
+#define EXT4_FEATURE_INCOMPAT_CSUM_SEED		0x2000
 #define EXT4_FEATURE_INCOMPAT_LARGEDIR		0x4000 /* >2GB or 3-lvl htree */
 #define EXT4_FEATURE_INCOMPAT_INLINE_DATA	0x8000 /* data in inode */
 #define EXT4_FEATURE_INCOMPAT_ENCRYPT		0x10000
@@ -894,6 +896,7 @@ EXT4_FEATURE_INCOMPAT_FUNCS(mmp,		4, MMP)
 EXT4_FEATURE_INCOMPAT_FUNCS(flex_bg,		4, FLEX_BG)
 EXT4_FEATURE_INCOMPAT_FUNCS(ea_inode,		4, EA_INODE)
 EXT4_FEATURE_INCOMPAT_FUNCS(dirdata,		4, DIRDATA)
+EXT4_FEATURE_INCOMPAT_FUNCS(csum_seed,		4, CSUM_SEED)
 EXT4_FEATURE_INCOMPAT_FUNCS(largedir,		4, LARGEDIR)
 EXT4_FEATURE_INCOMPAT_FUNCS(inline_data,	4, INLINE_DATA)
 EXT4_FEATURE_INCOMPAT_FUNCS(encrypt,		4, ENCRYPT)
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 30e913c..d9ea105 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -580,7 +580,8 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT4_LIB_INCOMPAT_MMP|\
 					 EXT4_FEATURE_INCOMPAT_64BIT|\
 					 EXT4_FEATURE_INCOMPAT_INLINE_DATA|\
-					 EXT4_FEATURE_INCOMPAT_ENCRYPT)
+					 EXT4_FEATURE_INCOMPAT_ENCRYPT|\
+					 EXT4_FEATURE_INCOMPAT_CSUM_SEED)
 
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
 					 EXT4_FEATURE_RO_COMPAT_HUGE_FILE|\
@@ -985,6 +986,7 @@ extern __u32 ext2fs_crc32_be(__u32 crc, unsigned char const *p, size_t len);
 extern __u32 ext2fs_crc32c_le(__u32 crc, unsigned char const *p, size_t len);
 
 /* csum.c */
+extern void ext2fs_init_csum_seed(ext2_filsys fs);
 extern errcode_t ext2fs_mmp_csum_set(ext2_filsys fs, struct mmp_struct *mmp);
 extern int ext2fs_mmp_csum_verify(ext2_filsys, struct mmp_struct *mmp);
 extern int ext2fs_verify_csum_type(ext2_filsys fs, struct ext2_super_block *sb);
@@ -1712,15 +1714,6 @@ extern void ext2fs_dirent_set_file_type(struct ext2_dir_entry *entry, int type);
 #endif /* __STDC_VERSION__ >= 199901L */
 #endif
 
-static inline void ext2fs_init_csum_seed(ext2_filsys fs)
-{
-	if (!ext2fs_has_feature_metadata_csum(fs->super))
-		return;
-
-	fs->csum_seed = ext2fs_crc32c_le(~0, fs->super->s_uuid,
-					 sizeof(fs->super->s_uuid));
-}
-
 #ifndef EXT2_CUSTOM_MEMORY_ROUTINES
 #include <string.h>
 /*
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index ee7a455..9d2c535 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -101,6 +101,7 @@ void ext2fs_swap_super(struct ext2_super_block * sb)
 		sb->s_jnl_blocks[i] = ext2fs_swab32(sb->s_jnl_blocks[i]);
 	sb->s_backup_bgs[0] = ext2fs_swab32(sb->s_backup_bgs[0]);
 	sb->s_backup_bgs[1] = ext2fs_swab32(sb->s_backup_bgs[1]);
+	sb->s_checksum_seed = ext2fs_swab32(sb->s_checksum_seed);
 }
 
 void ext2fs_swap_group_desc2(ext2_filsys fs, struct ext2_group_desc *gdp)
diff --git a/lib/ext2fs/tst_super_size.c b/lib/ext2fs/tst_super_size.c
index 8e3c21f..0adac41 100644
--- a/lib/ext2fs/tst_super_size.c
+++ b/lib/ext2fs/tst_super_size.c
@@ -140,7 +140,9 @@ int main(int argc, char **argv)
 	check_field(s_encrypt_algos, 4);
 	check_field(s_encrypt_pw_salt, 16);
 	check_field(s_lpf_ino, 4);
-	check_field(s_reserved, 100 * 4);
+	check_field(s_prj_quota_inum, 4);
+	check_field(s_checksum_seed, 4);
+	check_field(s_reserved, 98 * 4);
 	check_field(s_checksum, 4);
 	do_field("Superblock end", 0, 0, cur_offset, 1024);
 #endif

