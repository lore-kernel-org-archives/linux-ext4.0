From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 04/27] libext2fs: fix problems with LE<->BE conversions on
 BE platforms
Date: Sat, 16 Aug 2014 16:46:16 -0700
Message-ID: <20140816234616.11171.78225.stgit@birch.djwong.org>
References: <20140816234550.11171.61585.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23805 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbaHPXqV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 16 Aug 2014 19:46:21 -0400
In-Reply-To: <20140816234550.11171.61585.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix more problems that I found when testing on ppc64:

- Inode swap cut and paste error leads to immutable inodes being
  detected as inlinedata inodes, leading to e2fsck incorrectly barfing
  on i_block[] contents.

- Superblock csum/verify must be aware of the fs->super byte order
  when checking for metadata_csum feature flag.  (Hint: in _openfs(),
  fs->super is in LE order for the first csum verification)

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/csum.c   |   26 ++++++++++++++++++--------
 lib/ext2fs/swapfs.c |    2 +-
 2 files changed, 19 insertions(+), 9 deletions(-)


diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index d7dbca8..12f6fe9 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -81,12 +81,17 @@ static __u32 ext2fs_superblock_csum(ext2_filsys fs EXT2FS_ATTR((unused)),
 	return ext2fs_crc32c_le(~0, (unsigned char *)sb, offset);
 }
 
+/* NOTE: The input to this function MUST be in LE order */
 int ext2fs_superblock_csum_verify(ext2_filsys fs, struct ext2_super_block *sb)
 {
-	__u32 calculated;
+	__u32 flag, calculated;
 
-	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (fs->flags & EXT2_FLAG_SWAP_BYTES)
+		flag = EXT4_FEATURE_RO_COMPAT_METADATA_CSUM;
+	else
+		flag = ext2fs_cpu_to_le32(EXT4_FEATURE_RO_COMPAT_METADATA_CSUM);
+
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super, flag))
 		return 1;
 
 	calculated = ext2fs_superblock_csum(fs, sb);
@@ -94,13 +99,18 @@ int ext2fs_superblock_csum_verify(ext2_filsys fs, struct ext2_super_block *sb)
 	return ext2fs_le32_to_cpu(sb->s_checksum) == calculated;
 }
 
+/* NOTE: The input to this function MUST be in LE order */
 errcode_t ext2fs_superblock_csum_set(ext2_filsys fs,
 				     struct ext2_super_block *sb)
 {
-	__u32 crc;
+	__u32 flag, crc;
 
-	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (fs->flags & EXT2_FLAG_SWAP_BYTES)
+		flag = EXT4_FEATURE_RO_COMPAT_METADATA_CSUM;
+	else
+		flag = ext2fs_cpu_to_le32(EXT4_FEATURE_RO_COMPAT_METADATA_CSUM);
+
+	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super, flag))
 		return 0;
 
 	crc = ext2fs_superblock_csum(fs, sb);
@@ -756,8 +766,8 @@ __u16 ext2fs_group_desc_csum(ext2_filsys fs, dgrp_t group)
 #ifdef WORDS_BIGENDIAN
 		if (save_size > ext4_bg_size)
 			crc32 = ext2fs_crc32c_le(crc32,
-					   (char *)save_desc + ext4_bg_size,
-					   save_size - ext4_bg_size);
+				     (unsigned char *)save_desc + ext4_bg_size,
+	                             save_size - ext4_bg_size);
 #endif
 		crc = crc32 & 0xFFFF;
 		goto out;
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index e2aa41d..ee7a455 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -243,7 +243,7 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct ext2_inode_large *t,
 	t->i_flags = ext2fs_swab32(f->i_flags);
 	if (!hostorder && (t->i_flags & EXT4_EXTENTS_FL))
 		has_extents = 1;
-	if (!hostorder && (f->i_flags & EXT4_INLINE_DATA_FL))
+	if (!hostorder && (t->i_flags & EXT4_INLINE_DATA_FL))
 		has_inline_data = 1;
 	t->i_dir_acl = ext2fs_swab32(f->i_dir_acl);
 	/*

