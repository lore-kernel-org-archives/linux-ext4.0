From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 34/37] libext2fs: Calculate and verify superblock checksums
Date: Wed, 31 Aug 2011 17:38:49 -0700
Message-ID: <20110901003849.1176.83693.stgit@elm3c44.beaverton.ibm.com>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
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
Received: from e1.ny.us.ibm.com ([32.97.182.141]:53182 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757071Ab1IAAiz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 31 Aug 2011 20:38:55 -0400
Received: from /spool/local
	by us.ibm.com with XMail ESMTP
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Wed, 31 Aug 2011 20:38:54 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p810cp3T414800
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:38:52 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p810coV6030414
	for <linux-ext4@vger.kernel.org>; Wed, 31 Aug 2011 20:38:51 -0400
In-Reply-To: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Calculate and verify the superblock checksums.  Each copy of the superblock
records the number of the group it's in and the FS UUID, so we can simply
checksum the whole block.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 lib/ext2fs/closefs.c      |   13 ++++++-------
 lib/ext2fs/csum.c         |   39 +++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2_err.et.in |    3 +++
 lib/ext2fs/ext2_fs.h      |    3 ++-
 lib/ext2fs/ext2fs.h       |    6 ++++++
 lib/ext2fs/openfs.c       |    6 ++++++
 lib/ext2fs/swapfs.c       |    2 ++
 7 files changed, 64 insertions(+), 8 deletions(-)


diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index 73dc136..017e9ba 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -256,10 +256,11 @@ static errcode_t write_backup_super(ext2_filsys fs, dgrp_t group,
 
 	if (sgrp > ((1 << 16) - 1))
 		sgrp = (1 << 16) - 1;
+
+	super_shadow->s_block_group_nr = sgrp;
+	ext2fs_superblock_csum_set(fs, super_shadow);
 #ifdef WORDS_BIGENDIAN
-	super_shadow->s_block_group_nr = ext2fs_swab16(sgrp);
-#else
-	fs->super->s_block_group_nr = sgrp;
+	ext2fs_swap_super(super_shadow);
 #endif
 
 	return io_channel_write_blk64(fs->io, group_block, -SUPERBLOCK_SIZE,
@@ -315,6 +316,7 @@ errcode_t ext2fs_flush(ext2_filsys fs)
 				  &group_shadow);
 	if (retval)
 		goto errout;
+	memcpy(super_shadow, fs->super, sizeof(struct ext2_super_block));
 	memcpy(group_shadow, fs->group_desc, (size_t) fs->blocksize *
 	       fs->desc_blocks);
 
@@ -335,10 +337,6 @@ errcode_t ext2fs_flush(ext2_filsys fs)
 	 */
 	fs->super->s_state &= ~EXT2_VALID_FS;
 	fs->super->s_feature_incompat &= ~EXT3_FEATURE_INCOMPAT_RECOVER;
-#ifdef WORDS_BIGENDIAN
-	*super_shadow = *fs->super;
-	ext2fs_swap_super(super_shadow);
-#endif
 
 	/*
 	 * If this is an external journal device, don't write out the
@@ -408,6 +406,7 @@ write_primary_superblock_only:
 	fs->super->s_block_group_nr = 0;
 	fs->super->s_state = fs_state;
 	fs->super->s_feature_incompat = feature_incompat;
+	ext2fs_superblock_csum_set(fs, fs->super);
 #ifdef WORDS_BIGENDIAN
 	*super_shadow = *fs->super;
 	ext2fs_swap_super(super_shadow);
diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index dc87de3..1da5bfc 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -29,6 +29,45 @@
 #define STATIC static
 #endif
 
+__u32 ext2fs_superblock_csum(ext2_filsys fs, struct ext2_super_block *sb)
+{
+	int offset = offsetof(struct ext2_super_block, s_checksum);
+	__u32 crc = 0;
+
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return 0;
+
+#ifdef WORDS_BIGENDIAN
+	struct ext2_super_block swabsb;
+	memcpy(&swabsb, sb, sizeof(struct ext2_super_block));
+	ext2fs_swap_super(&swabsb);
+	sb = &swabsb;
+#endif
+
+	crc = crc32c_le(~0, (char *)sb, offset);
+
+	return crc;
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
+void ext2fs_superblock_csum_set(ext2_filsys fs, struct ext2_super_block *sb)
+{
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+		return;
+
+	sb->s_checksum = ext2fs_superblock_csum(fs, sb);
+}
+
 __u32 ext2fs_ext_attr_block_csum(ext2_filsys fs, blk64_t block,
 				 struct ext2_ext_attr_header *hdr)
 {
diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index 6e2c22c..956427d 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -434,4 +434,7 @@ ec	EXT2_ET_INODE_CSUM_NONZERO,
 ec	EXT2_ET_EXT_ATTR_BLOCK_CORRUPT,
 	"Extended attribute block fails checksum"
 
+ec	EXT2_ET_SB_CSUM_INVALID,
+	"Superblock fails checksum"
+
 	end
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 40b5900..7d43e15 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -589,7 +589,8 @@ struct ext2_super_block {
 	__u32	s_usr_quota_inum;	/* inode number of user quota file */
 	__u32	s_grp_quota_inum;	/* inode number of group quota file */
 	__u32	s_overhead_blocks;	/* overhead blocks/clusters in fs */
-	__u32   s_reserved[109];        /* Padding to the end of the block */
+	__u32	s_checksum;		/* crc32c(superblock) */
+	__u32   s_reserved[108];        /* Padding to the end of the block */
 };
 
 #define EXT4_S_ERR_LEN (EXT4_S_ERR_END - EXT4_S_ERR_START)
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 0820e43..282806b 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -894,6 +894,12 @@ extern __u32 crc32c_be(__u32 crc, unsigned char const *p, size_t len);
 extern __u32 crc32c_le(__u32 crc, unsigned char const *p, size_t len);
 
 /* csum.c */
+extern __u32 ext2fs_superblock_csum(ext2_filsys fs,
+				    struct ext2_super_block *sb);
+extern int ext2fs_superblock_csum_verify(ext2_filsys fs,
+					 struct ext2_super_block *sb);
+extern void ext2fs_superblock_csum_set(ext2_filsys fs,
+				       struct ext2_super_block *sb);
 extern __u32 ext2fs_ext_attr_block_csum(ext2_filsys fs, blk64_t block,
 					struct ext2_ext_attr_header *hdr);
 extern int ext2fs_ext_attr_block_csum_verify(ext2_filsys fs, blk64_t block,
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 0edeb2f..5472d9a 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -198,6 +198,12 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
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
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index 5cbb4b9..5234451 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -94,6 +94,8 @@ void ext2fs_swap_super(struct ext2_super_block * sb)
 	}
 	for (; i < 17; i++)
 		sb->s_jnl_blocks[i] = ext2fs_swab32(sb->s_jnl_blocks[i]);
+
+	sb->s_checksum = ext2fs_swab32(sb->s_checksum);
 }
 
 void ext2fs_swap_group_desc2(ext2_filsys fs, struct ext2_group_desc *gdp)

