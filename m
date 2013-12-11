From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 37/74] libext2fs: don't always read backup group descriptors
 on a 1k-block meta_bg fs
Date: Tue, 10 Dec 2013 17:22:26 -0800
Message-ID: <20131211012226.30655.66387.stgit@birch.djwong.org>
References: <20131211011813.30655.39624.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43121 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab3LKBWc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 10 Dec 2013 20:22:32 -0500
In-Reply-To: <20131211011813.30655.39624.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On a filesystem with 1K blocks and meta_bg enabled, opening a
filesystem with automatic superblock detection tries to compensate for
the fact that the superblock lives in block 1.  However, the method by
which this is done is later misinterpreted to mean "read the backup
group descriptors", which is not what we want in this case.

Therefore, in ext2fs_open3() separate the 'group zero' adjustment into
its own variable so that we don't get fed backup group descriptors
when we try to load meta_bg group descriptors.

Furthermore, enhance ext2fs_descriptor_block_loc2() to perform its own
group zero correction.  The other caller of this function neglects to
do any group-zero correction of their own, so this fixes them too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/ext2fs/ext2fs.h |    5 +++++
 lib/ext2fs/openfs.c |   30 +++++++++++++++++++++++++-----
 2 files changed, 30 insertions(+), 5 deletions(-)


diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 0624350..edd5ee9 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1449,6 +1449,11 @@ extern errcode_t ext2fs_open2(const char *name, const char *io_options,
 			      int flags, int superblock,
 			      unsigned int block_size, io_manager manager,
 			      ext2_filsys *ret_fs);
+/*
+ * The dgrp_t argument to these two functions is not actually a group number
+ * but a block number offset within a group table!  Convert with the formula
+ * (group_number / groups_per_block).
+ */
 extern blk64_t ext2fs_descriptor_block_loc2(ext2_filsys fs,
 					blk64_t group_block, dgrp_t i);
 extern blk_t ext2fs_descriptor_block_loc(ext2_filsys fs, blk_t group_block,
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 92d9e40..5cf6ae4 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -37,12 +37,19 @@ blk64_t ext2fs_descriptor_block_loc2(ext2_filsys fs, blk64_t group_block,
 				     dgrp_t i)
 {
 	int	bg;
-	int	has_super = 0;
+	int	has_super = 0, group_zero_adjust = 0;
 	blk64_t	ret_blk;
 
+	/*
+	 * On a bigalloc FS with 1K blocks, block 0 is reserved for non-ext4
+	 * stuff, so adjust for that if we're being asked for group 0.
+	 */
+	if (i == 0 && fs->blocksize == 1024 && EXT2FS_CLUSTER_RATIO(fs) > 1)
+		group_zero_adjust = 1;
+
 	if (!(fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG) ||
 	    (i < fs->super->s_first_meta_bg))
-		return (group_block + i + 1);
+		return group_block + i + 1 + group_zero_adjust;
 
 	bg = EXT2_DESC_PER_BLOCK(fs->super) * i;
 	if (ext2fs_bg_has_super(fs, bg))
@@ -71,7 +78,7 @@ blk64_t ext2fs_descriptor_block_loc2(ext2_filsys fs, blk64_t group_block,
 		else
 			has_super = 0;
 	}
-	return ret_blk + has_super;
+	return ret_blk + has_super + group_zero_adjust;
 }
 
 blk_t ext2fs_descriptor_block_loc(ext2_filsys fs, blk_t group_block, dgrp_t i)
@@ -113,6 +120,7 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 	unsigned int	blocks_per_group, io_flags;
 	blk64_t		group_block, blk;
 	char		*dest, *cp;
+	int		group_zero_adjust = 0;
 #ifdef WORDS_BIGENDIAN
 	unsigned int	groups_per_block;
 	struct ext2_group_desc *gdp;
@@ -380,8 +388,19 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 		goto cleanup;
 	if (!group_block)
 		group_block = fs->super->s_first_data_block;
+	/*
+	 * On a FS with a 1K blocksize, block 0 is reserved for bootloaders
+	 * so we must increment block numbers to any group 0 items.
+	 *
+	 * However, we cannot touch group_block directly because in the meta_bg
+	 * case, the ext2fs_descriptor_block_loc2() function will interpret
+	 * group_block != s_first_data_block to mean that we want to access the
+	 * backup group descriptors.  This is not what we want if the caller
+	 * set superblock == 0 (i.e. auto-detect the superblock), which is
+	 * what's going on here.
+	 */
 	if (group_block == 0 && fs->blocksize == 1024)
-		group_block = 1; /* Deal with 1024 blocksize && bigalloc */
+		group_zero_adjust = 1;
 	dest = (char *) fs->group_desc;
 #ifdef WORDS_BIGENDIAN
 	groups_per_block = EXT2_DESC_PER_BLOCK(fs->super);
@@ -391,7 +410,8 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 	else
 		first_meta_bg = fs->desc_blocks;
 	if (first_meta_bg) {
-		retval = io_channel_read_blk(fs->io, group_block+1,
+		retval = io_channel_read_blk(fs->io, group_block +
+					     group_zero_adjust + 1,
 					     first_meta_bg, dest);
 		if (retval)
 			goto cleanup;

