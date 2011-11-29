From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 31/50] libext2fs: Calculate and verify superblock checksums
Date: Mon, 28 Nov 2011 16:31:33 -0800
Message-ID: <20111129003133.17953.63629.stgit@elm3c44.beaverton.ibm.com>
References: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e31.co.us.ibm.com ([32.97.110.149]:42345 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab1K2Abp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Nov 2011 19:31:45 -0500
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 28 Nov 2011 17:31:45 -0700
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pAT0VaAb095520
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 17:31:36 -0700
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pAT0VYnr007773
	for <linux-ext4@vger.kernel.org>; Mon, 28 Nov 2011 17:31:36 -0700
In-Reply-To: <20111129002755.17953.19556.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Calculate and verify the superblock checksums.  Each copy of the superblock
records the number of the group it's in and the FS UUID, so we can simply
checksum the whole block.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/ext2fs/closefs.c      |   19 ++++++++++++-------
 lib/ext2fs/csum.c         |   35 +++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2_err.et.in |    3 +++
 lib/ext2fs/ext2fs.h       |    4 ++++
 lib/ext2fs/openfs.c       |    6 ++++++
 5 files changed, 60 insertions(+), 7 deletions(-)


diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index 1867be3..a0e28ba 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -246,15 +246,19 @@ static errcode_t write_backup_super(ext2_filsys fs, dgrp_t group,
 				    blk_t group_block,
 				    struct ext2_super_block *super_shadow)
 {
+	errcode_t retval;
 	dgrp_t	sgrp = group;
 
 	if (sgrp > ((1 << 16) - 1))
 		sgrp = (1 << 16) - 1;
+
+	super_shadow->s_block_group_nr = sgrp;
 #ifdef WORDS_BIGENDIAN
-	super_shadow->s_block_group_nr = ext2fs_swab16(sgrp);
-#else
-	fs->super->s_block_group_nr = sgrp;
+	ext2fs_swap_super(super_shadow);
 #endif
+	retval = ext2fs_superblock_csum_set(fs, super_shadow);
+	if (retval)
+		return retval;
 
 	return io_channel_write_blk64(fs->io, group_block, -SUPERBLOCK_SIZE,
 				    super_shadow);
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
@@ -412,6 +413,10 @@ write_primary_superblock_only:
 	ext2fs_swap_super(super_shadow);
 #endif
 
+	retval = ext2fs_superblock_csum_set(fs, super_shadow);
+	if (retval)
+		return retval;
+
 	if (!(flags & EXT2_FLAG_FLUSH_NO_SYNC))
 		retval = io_channel_flush(fs->io);
 	retval = write_primary_superblock(fs, super_shadow);
diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index e5d8799..e033453 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -30,6 +30,41 @@
 #define STATIC static
 #endif
 
+static __u32 ext2fs_superblock_csum(ext2_filsys fs, struct ext2_super_block *sb)
+{
+	int offset = offsetof(struct ext2_super_block, s_checksum);
+
+	return ext2fs_crc32c_le(~0, (unsigned char *)sb, offset);
+}
+
+int ext2fs_superblock_csum_verify(ext2_filsys fs, struct ext2_super_block *sb)
+{
+	__u32 calculated;
+
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 1;
+
+	calculated = ext2fs_superblock_csum(fs, sb);
+
+	return ext2fs_le32_to_cpu(sb->s_checksum) == calculated;
+}
+
+errcode_t ext2fs_superblock_csum_set(ext2_filsys fs,
+				     struct ext2_super_block *sb)
+{
+	__u32 crc;
+
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 0;
+
+	crc = ext2fs_superblock_csum(fs, sb);
+	sb->s_checksum = ext2fs_cpu_to_le32(crc);
+
+	return 0;
+}
+
 static errcode_t ext2fs_ext_attr_block_csum(ext2_filsys fs, ext2_ino_t inum,
 					    blk64_t block,
 					    struct ext2_ext_attr_header *hdr,
diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index 177a97f..0fab4e0 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -461,4 +461,7 @@ ec	EXT2_ET_DIR_CSUM_INVALID,
 ec	EXT2_ET_EXT_ATTR_CSUM_INVALID,
 	"Extended attribute block checksum does not match block"
 
+ec	EXT2_ET_SB_CSUM_INVALID,
+	"Superblock checksum does not match superblock"
+
 	end
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 9373c01..9a7a1aa 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -942,6 +942,10 @@ extern __u32 ext2fs_crc32c_be(__u32 crc, unsigned char const *p, size_t len);
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
index 40a52c5..3abdaf0 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -193,6 +193,12 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 	if (fs->orig_super)
 		memcpy(fs->orig_super, fs->super, SUPERBLOCK_SIZE);
 
+	if (!(fs->flags & EXT2_FLAG_IGNORE_CSUM_ERRORS) &&
+	    !ext2fs_superblock_csum_verify(fs, fs->super)) {
+		retval = EXT2_ET_SB_CSUM_INVALID;
+		goto cleanup;
+	}
+
 #ifdef WORDS_BIGENDIAN
 	fs->flags |= EXT2_FLAG_SWAP_BYTES;
 	ext2fs_swap_super(fs->super);

