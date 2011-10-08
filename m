From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 30/47] libext2fs: Calculate and verify superblock checksums
Date: Sat, 08 Oct 2011 00:36:26 -0700
Message-ID: <20111008073626.17888.91134.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42556 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab1JHHjT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 03:39:19 -0400
Received: from /spool/local
	by us.ibm.com with XMail ESMTP
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Sat, 8 Oct 2011 03:39:18 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p987aTpB200966
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 03:36:29 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p987aRF4007820
	for <linux-ext4@vger.kernel.org>; Sat, 8 Oct 2011 04:36:28 -0300
In-Reply-To: <20111008073315.17888.22132.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Calculate and verify the superblock checksums.  Each copy of the superblock
records the number of the group it's in and the FS UUID, so we can simply
checksum the whole block.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/ext2fs/closefs.c      |   18 +++++++++++-------
 lib/ext2fs/csum.c         |   34 ++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2_err.et.in |    3 +++
 lib/ext2fs/ext2fs.h       |    4 ++++
 lib/ext2fs/openfs.c       |    6 ++++++
 5 files changed, 58 insertions(+), 7 deletions(-)


diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index 1867be3..008ee91 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -246,14 +246,18 @@ static errcode_t write_backup_super(ext2_filsys fs, dgrp_t group,
 				    blk_t group_block,
 				    struct ext2_super_block *super_shadow)
 {
+	errcode_t retval;
 	dgrp_t	sgrp = group;
 
 	if (sgrp > ((1 << 16) - 1))
 		sgrp = (1 << 16) - 1;
+
+	super_shadow->s_block_group_nr = sgrp;
+	retval = ext2fs_superblock_csum_set(fs, super_shadow);
+	if (retval)
+		return retval;
 #ifdef WORDS_BIGENDIAN
-	super_shadow->s_block_group_nr = ext2fs_swab16(sgrp);
-#else
-	fs->super->s_block_group_nr = sgrp;
+	ext2fs_swap_super(super_shadow);
 #endif
 
 	return io_channel_write_blk64(fs->io, group_block, -SUPERBLOCK_SIZE,
@@ -314,6 +318,7 @@ errcode_t ext2fs_flush2(ext2_filsys fs, int flags)
 				  &group_shadow);
 	if (retval)
 		goto errout;
+	memcpy(super_shadow, fs->super, sizeof(struct ext2_super_block));
 	memcpy(group_shadow, fs->group_desc, (size_t) fs->blocksize *
 	       fs->desc_blocks);
 
@@ -334,10 +339,6 @@ errcode_t ext2fs_flush2(ext2_filsys fs, int flags)
 	 */
 	fs->super->s_state &= ~EXT2_VALID_FS;
 	fs->super->s_feature_incompat &= ~EXT3_FEATURE_INCOMPAT_RECOVER;
-#ifdef WORDS_BIGENDIAN
-	*super_shadow = *fs->super;
-	ext2fs_swap_super(super_shadow);
-#endif
 
 	/*
 	 * If this is an external journal device, don't write out the
@@ -407,6 +408,9 @@ write_primary_superblock_only:
 	fs->super->s_block_group_nr = 0;
 	fs->super->s_state = fs_state;
 	fs->super->s_feature_incompat = feature_incompat;
+	retval = ext2fs_superblock_csum_set(fs, fs->super);
+	if (retval)
+		return retval;
 #ifdef WORDS_BIGENDIAN
 	*super_shadow = *fs->super;
 	ext2fs_swap_super(super_shadow);
diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index aec5c87..d89fa37 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -30,6 +30,40 @@
 #define STATIC static
 #endif
 
+static __u32 ext2fs_superblock_csum(ext2_filsys fs, struct ext2_super_block *sb)
+{
+	int offset = offsetof(struct ext2_super_block, s_checksum);
+
+#ifdef WORDS_BIGENDIAN
+	struct ext2_super_block swabsb;
+	memcpy(&swabsb, sb, sizeof(struct ext2_super_block));
+	ext2fs_swap_super(&swabsb);
+	sb = &swabsb;
+#endif
+
+	return ext2fs_crc32c_le(~0, (unsigned char *)sb, offset);
+}
+
+int ext2fs_superblock_csum_verify(ext2_filsys fs, struct ext2_super_block *sb)
+{
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+	    (sb->s_checksum != ext2fs_superblock_csum(fs, sb)))
+		return 0;
+	return 1;
+}
+
+errcode_t ext2fs_superblock_csum_set(ext2_filsys fs,
+				     struct ext2_super_block *sb)
+{
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 0;
+
+	sb->s_checksum = ext2fs_superblock_csum(fs, sb);
+	return 0;
+}
+
 static errcode_t ext2fs_ext_attr_block_csum(ext2_filsys fs, ext2_ino_t inum,
 					    blk64_t block,
 					    struct ext2_ext_attr_header *hdr,
diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index e210f8d..e4d2caa 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -455,4 +455,7 @@ ec	EXT2_ET_INODE_CSUM_NONZERO,
 ec	EXT2_ET_EXT_ATTR_BLOCK_CORRUPT,
 	"Extended attribute block fails checksum"
 
+ec	EXT2_ET_SB_CSUM_INVALID,
+	"Superblock fails checksum"
+
 	end
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 9f0e8fa..b921f83 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -929,6 +929,10 @@ extern __u32 ext2fs_crc32c_be(__u32 crc, unsigned char const *p, size_t len);
 extern __u32 ext2fs_crc32c_le(__u32 crc, unsigned char const *p, size_t len);
 
 /* csum.c */
+extern errcode_t ext2fs_superblock_csum_set(ext2_filsys fs,
+					    struct ext2_super_block *sb);
+extern int ext2fs_superblock_csum_verify(ext2_filsys fs,
+					 struct ext2_super_block *sb);
 extern errcode_t ext2fs_ext_attr_block_csum_set(ext2_filsys fs,
 					ext2_ino_t inum, blk64_t block,
 					struct ext2_ext_attr_header *hdr);
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 0cefe3f..334240c 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -203,6 +203,12 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 	}
 #endif
 
+	if (!(fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) &&
+	    !ext2fs_superblock_csum_verify(fs, fs->super)) {
+		retval = EXT2_ET_SB_CSUM_INVALID;
+		goto cleanup;
+	}
+
 	if (fs->super->s_magic != EXT2_SUPER_MAGIC) {
 		retval = EXT2_ET_BAD_MAGIC;
 		goto cleanup;

