From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v2] libext2fs: preload block group on request
Date: Fri,  3 Mar 2017 16:01:50 +0300
Message-ID: <1488546110-31366-1-git-send-email-artem.blagodarenko@gmail.com>
References: <34190257-2334-4DA5-90BD-AA0F7167E4C2@dilger.ca>
Cc: adilger.kernel@dilger.ca, alexey.lyashkov@gmail.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34994 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752312AbdCCT7V (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Mar 2017 14:59:21 -0500
Received: by mail-lf0-f67.google.com with SMTP id v2so2540957lfi.2
        for <linux-ext4@vger.kernel.org>; Fri, 03 Mar 2017 11:59:20 -0800 (PST)
In-Reply-To: <34190257-2334-4DA5-90BD-AA0F7167E4C2@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Artem Blagodarenko <artem.blagodarenko@seagate.com>

---
 lib/ext2fs/blknum.c  |   46 ++++++++++++++++++++++++++++++++++++++++++++--
 lib/ext2fs/closefs.c |    7 +++++--
 lib/ext2fs/ext2_fs.h |    1 +
 lib/ext2fs/ext2fs.h  |    3 +++
 lib/ext2fs/openfs.c  |   29 +++++++----------------------
 5 files changed, 60 insertions(+), 26 deletions(-)

diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
index ac80849..a5d5082 100644
--- a/lib/ext2fs/blknum.c
+++ b/lib/ext2fs/blknum.c
@@ -186,8 +186,50 @@ struct ext2_group_desc *ext2fs_group_desc(ext2_filsys fs,
 					  dgrp_t group)
 {
 	int desc_size = EXT2_DESC_SIZE(fs->super) & ~7;
-
-	return (struct ext2_group_desc *)((char *)gdp + group * desc_size);
+	struct ext2_group_desc *ret_gdp;
+	struct ext2_group_desc *tmp_gdp;
+	char *dest;
+	dgrp_t block;
+	blk64_t blk;
+	int retval;
+	unsigned int i;
+	unsigned int groups_per_block = EXT2_DESC_PER_BLOCK(fs->super);
+
+	ret_gdp = (struct ext2_group_desc *)((char *)gdp + group * desc_size);
+
+	if (fs->first_meta_desc && group >= fs->first_meta_desc 
+	    && ret_gdp->bg_block_bitmap == 0) {
+		block = group / groups_per_block;
+		blk = ext2fs_descriptor_block_loc2(fs, fs->group_block, block);
+		dest = (char *) gdp + fs->blocksize * block;
+		retval = io_channel_read_blk64(fs->io, blk, 1, dest);
+		if (retval)
+			return NULL;
+
+		tmp_gdp = (struct ext2_group_desc *)dest;
+
+		for (i=0; i < groups_per_block; i++) {
+			/*
+			 * TDB: If recovery is from backup superblock, Clear
+			 * _UNININT flags & reset bg_itable_unused to zero
+			 */
+#ifdef WORDS_BIGENDIAN
+			ext2fs_swap_group_desc2(fs, tmp_gdp);
+#endif
+			if (fs->orig_super == 0 &&
+			    EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+			    EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
+				ext2fs_bg_flags_clear(fs, block * groups_per_block + i, EXT2_BG_BLOCK_UNINIT);
+				ext2fs_bg_flags_clear(fs,  block * groups_per_block + i, EXT2_BG_INODE_UNINIT);
+				ext2fs_bg_itable_unused_set(fs,  block * groups_per_block + i, 0);
+				// The checksum will be reset later, but fix it here
+				// anyway to avoid printing a lot of spurious errors. 
+				ext2fs_group_desc_csum_set(fs,  block * groups_per_block + i);
+			}
+			tmp_gdp = (struct ext2_group_desc *)((char *)tmp_gdp + EXT2_DESC_SIZE(fs->super));
+		}
+	}
+	return ret_gdp;
 }
 
 /* Do the same but as an ext4 group desc for internal use here */
diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index b255759..994b841 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -285,10 +285,8 @@ errcode_t ext2fs_flush2(ext2_filsys fs, int flags)
 	__u32		feature_incompat;
 	struct ext2_super_block *super_shadow = 0;
 	struct ext2_group_desc *group_shadow = 0;
-#ifdef WORDS_BIGENDIAN
 	struct ext2_group_desc *gdp;
 	dgrp_t		j;
-#endif
 	char	*group_ptr;
 	blk64_t	old_desc_blocks;
 	struct ext2fs_numeric_progress_struct progress;
@@ -337,6 +335,11 @@ errcode_t ext2fs_flush2(ext2_filsys fs, int flags)
 	}
 #else
 	super_shadow = fs->super;
+	/* make sure all in memory */
+	for (j = 0; j < fs->group_desc_count; j++) {
+		gdp = ext2fs_group_desc(fs, group_shadow, j);
+	}
+
 	group_shadow = ext2fs_group_desc(fs, fs->group_desc, 0);
 #endif
 
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 27a7d3a..4858684 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -202,6 +202,7 @@ struct ext4_group_desc
 #define EXT2_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not initialized */
 #define EXT2_BG_BLOCK_UNINIT	0x0002 /* Block bitmap not initialized */
 #define EXT2_BG_INODE_ZEROED	0x0004 /* On-disk itable initialized to zero */
+#define EXT2_BG_READ		0x0008 /* Block group was read from disk */
 
 /*
  * Data structures used by the directory indexing feature
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 8ff49ca..d23bd99 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -221,6 +221,9 @@ struct struct_ext2_filsys {
 	int				fragsize;
 	dgrp_t				group_desc_count;
 	unsigned long			desc_blocks;
+	blk64_t				group_block;
+	/* first meta descriptor block */
+	dgrp_t				first_meta_desc;
 	struct opaque_ext2_group_desc *	group_desc;
 	unsigned int			inode_blocks_per_group;
 	ext2fs_inode_bitmap		inode_map;
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index ba39e01..12a3935 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -121,11 +121,9 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 	blk64_t		group_block, blk;
 	char		*dest, *cp;
 	int		group_zero_adjust = 0;
-#ifdef WORDS_BIGENDIAN
 	unsigned int	groups_per_block;
 	struct ext2_group_desc *gdp;
 	int		j;
-#endif
 
 	EXT2_CHECK_MAGIC(manager, EXT2_ET_MAGIC_IO_MANAGER);
 
@@ -377,7 +375,7 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 	}
 	fs->desc_blocks = ext2fs_div_ceil(fs->group_desc_count,
 					  EXT2_DESC_PER_BLOCK(fs->super));
-	retval = ext2fs_get_array(fs->desc_blocks, fs->blocksize,
+	retval = ext2fs_get_arrayzero(fs->desc_blocks, fs->blocksize,
 				&fs->group_desc);
 	if (retval)
 		goto cleanup;
@@ -412,40 +410,27 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 					     first_meta_bg, dest);
 		if (retval)
 			goto cleanup;
-#ifdef WORDS_BIGENDIAN
-		gdp = (struct ext2_group_desc *) dest;
 		for (j=0; j < groups_per_block*first_meta_bg; j++) {
 			gdp = ext2fs_group_desc(fs, fs->group_desc, j);
-			ext2fs_swap_group_desc2(fs, gdp);
-		}
-#endif
-		dest += fs->blocksize*first_meta_bg;
-	}
-	for (i=first_meta_bg ; i < fs->desc_blocks; i++) {
-		blk = ext2fs_descriptor_block_loc2(fs, group_block, i);
-		retval = io_channel_read_blk64(fs->io, blk, 1, dest);
-		if (retval)
-			goto cleanup;
 #ifdef WORDS_BIGENDIAN
-		for (j=0; j < groups_per_block; j++) {
-			gdp = ext2fs_group_desc(fs, fs->group_desc,
-						i * groups_per_block + j);
 			ext2fs_swap_group_desc2(fs, gdp);
-		}
 #endif
-		dest += fs->blocksize;
+		}
+		dest += fs->blocksize*first_meta_bg;
 	}
 
+	fs->first_meta_desc = groups_per_block * first_meta_bg;
+	fs->group_block = group_block;
 	fs->stride = fs->super->s_raid_stride;
 
 	/*
 	 * If recovery is from backup superblock, Clear _UNININT flags &
 	 * reset bg_itable_unused to zero
 	 */
-	if (superblock > 1 && ext2fs_has_group_desc_csum(fs)) {
+	if (first_meta_bg && superblock > 1 && ext2fs_has_group_desc_csum(fs)) {
 		dgrp_t group;
 
-		for (group = 0; group < fs->group_desc_count; group++) {
+		for (group = 0; group < groups_per_block*first_meta_bg; group++) {
 			ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
 			ext2fs_bg_flags_clear(fs, group, EXT2_BG_INODE_UNINIT);
 			ext2fs_bg_itable_unused_set(fs, group, 0);
-- 
1.7.1
