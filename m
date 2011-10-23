From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 1/8] e2fsprogs: add exclude bitmap support in libext2fs
Date: Sun, 23 Oct 2011 15:21:21 +0800
Message-ID: <1319354488-6050-2-git-send-email-xiaoqiangnk@gmail.com>
References: <1319354488-6050-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: amir73il@users.sf.net, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58496 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab1JWJKz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 23 Oct 2011 05:10:55 -0400
Received: by mail-iy0-f174.google.com with SMTP id y12so71200iab.19
        for <linux-ext4@vger.kernel.org>; Sun, 23 Oct 2011 02:10:55 -0700 (PDT)
In-Reply-To: <1319354488-6050-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Exclude bitmap is needed by ext4 snapshot.  This patch adds
exclude bitmap support in libext2fs.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
---
 lib/e2p/ls.c              |   13 ++++
 lib/ext2fs/alloc.c        |    3 +
 lib/ext2fs/alloc_tables.c |   44 ++++++++++++++-
 lib/ext2fs/bitmaps.c      |   70 +++++++++++++++++++++++
 lib/ext2fs/blknum.c       |   27 +++++++++
 lib/ext2fs/bmap64.h       |    2 +
 lib/ext2fs/csum.c         |    5 +-
 lib/ext2fs/dupfs.c        |    5 ++
 lib/ext2fs/ext2_err.et.in |   21 +++++++
 lib/ext2fs/ext2_fs.h      |    2 +
 lib/ext2fs/ext2fs.h       |   28 +++++++++
 lib/ext2fs/freefs.c       |    2 +
 lib/ext2fs/gen_bitmap.c   |   48 ++++++++++++++++
 lib/ext2fs/gen_bitmap64.c |    3 +
 lib/ext2fs/initialize.c   |   16 +++++
 lib/ext2fs/openfs.c       |    2 +
 lib/ext2fs/rw_bitmaps.c   |  136 ++++++++++++++++++++++++++++++++++++++++-----
 lib/ext2fs/swapfs.c       |    2 +
 18 files changed, 409 insertions(+), 20 deletions(-)

diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
index f05e16d..0cd5b37 100644
--- a/lib/e2p/ls.c
+++ b/lib/e2p/ls.c
@@ -161,6 +161,19 @@ static void print_super_flags(struct ext2_super_block * s, FILE *f)
 		fputs("test_filesystem ", f);
 		flags_found++;
 	}
+	if (s->s_flags & EXT2_FLAGS_IS_SNAPSHOT) {
+		fputs("is_snapshot ", f);
+		flags_found++;
+	}
+	if (s->s_flags & EXT2_FLAGS_FIX_SNAPSHOT) {
+		fputs("fix_snapshot ", f);
+		flags_found++;
+	}
+	if (s->s_flags & EXT2_FLAGS_FIX_EXCLUDE) {
+		fputs("fix_snapshot_bitmap ", f);
+		flags_found++;
+	}
+
 	if (flags_found)
 		fputs("\n", f);
 	else
diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index 948a0ec..a0b91dd 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -65,6 +65,9 @@ static void check_block_uninit(ext2_filsys fs, ext2fs_block_bitmap map,
 		     (blk < old_desc_blk + old_desc_blocks)) ||
 		    (new_desc_blk && (blk == new_desc_blk)) ||
 		    (blk == ext2fs_block_bitmap_loc(fs, group)) ||
+		    (EXT2_HAS_COMPAT_FEATURE(fs->super,
+			EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP) &&
+		    (blk == ext2fs_exclude_bitmap_loc(fs, group))) ||
 		    (blk == ext2fs_inode_bitmap_loc(fs, group)) ||
 		    (blk >= ext2fs_inode_table_loc(fs, group) &&
 		     (blk < ext2fs_inode_table_loc(fs, group)
diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
index 9f3d4e0..b5e2f0c 100644
--- a/lib/ext2fs/alloc_tables.c
+++ b/lib/ext2fs/alloc_tables.c
@@ -87,7 +87,7 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 	errcode_t	retval;
 	blk64_t		group_blk, start_blk, last_blk, new_blk, blk;
 	dgrp_t		last_grp = 0;
-	int		rem_grps = 0, flexbg_size = 0;
+	int		rem_grps = 0, flexbg_size = 0, exclude_bitmap = 0;
 
 	group_blk = ext2fs_group_first_block2(fs, group);
 	last_blk = ext2fs_group_last_block2(fs, group);
@@ -105,8 +105,12 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 		rem_grps = last_grp - group + 1;
 	}
 
+	if (EXT2_HAS_COMPAT_FEATURE(fs->super,
+				    EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP))
+		exclude_bitmap = 1;
+
 	/*
-	 * Allocate the block and inode bitmaps, if necessary
+	 * Allocate the block, exclude and inode bitmaps, if necessary
 	 */
 	if (fs->stride) {
 		retval = ext2fs_get_free_blocks2(fs, group_blk, last_blk,
@@ -150,13 +154,47 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 		}
 	}
 
+	if (exclude_bitmap && flexbg_size) {
+		blk64_t prev_block = 0;
+
+		if (group % flexbg_size)
+			prev_block = ext2fs_exclude_bitmap_loc(fs, group - 1) + 1;
+		else
+			prev_block = ext2fs_block_bitmap_loc(fs, group) +
+				flexbg_size;
+		start_blk = flexbg_offset(fs, group, prev_block, bmap,
+					  rem_grps, 1);
+		last_blk = ext2fs_group_last_block2(fs, last_grp);
+	}
+
+	if (exclude_bitmap && !ext2fs_exclude_bitmap_loc(fs, group)) {
+		retval = ext2fs_get_free_blocks2(fs, start_blk, last_blk,
+						1, bmap, &new_blk);
+		if (retval == EXT2_ET_BLOCK_ALLOC_FAIL)
+			retval = ext2fs_get_free_blocks2(fs, group_blk,
+					last_blk, 1, bmap, &new_blk);
+		if (retval)
+			return retval;
+		ext2fs_mark_block_bitmap2(bmap, new_blk);
+		ext2fs_exclude_bitmap_loc_set(fs, group, new_blk);
+		if (flexbg_size) {
+			dgrp_t gr = ext2fs_group_of_blk2(fs, new_blk);
+			ext2fs_bg_free_blocks_count_set(fs, gr,
+				ext2fs_bg_free_blocks_count(fs, gr) - 1);
+			ext2fs_free_blocks_count_add(fs->super, -1);
+			ext2fs_bg_flags_clear(fs, gr, EXT2_BG_BLOCK_UNINIT);
+			ext2fs_group_desc_csum_set(fs, gr);
+		}
+	}
+
 	if (flexbg_size) {
 		blk64_t prev_block = 0;
 		if (group % flexbg_size)
 			prev_block = ext2fs_inode_bitmap_loc(fs, group - 1) + 1;
 		else
-			prev_block = ext2fs_block_bitmap_loc(fs, group) +
+			prev_block = ext2fs_exclude_bitmap_loc(fs, group) +
 				flexbg_size;
+
 		start_blk = flexbg_offset(fs, group, prev_block, bmap,
 					  rem_grps, 1);
 		last_blk = ext2fs_group_last_block2(fs, last_grp);
diff --git a/lib/ext2fs/bitmaps.c b/lib/ext2fs/bitmaps.c
index e518295..4709fa2 100644
--- a/lib/ext2fs/bitmaps.c
+++ b/lib/ext2fs/bitmaps.c
@@ -35,6 +35,11 @@ void ext2fs_free_inode_bitmap(ext2fs_inode_bitmap bitmap)
 	ext2fs_free_generic_bmap(bitmap);
 }
 
+void ext2fs_free_exclude_bitmap(ext2fs_exclude_bitmap bitmap)
+{
+	ext2fs_free_generic_bmap(bitmap);
+}
+
 void ext2fs_free_block_bitmap(ext2fs_block_bitmap bitmap)
 {
 	ext2fs_free_generic_bmap(bitmap);
@@ -82,6 +87,39 @@ errcode_t ext2fs_allocate_inode_bitmap(ext2_filsys fs,
 					 (ext2fs_generic_bitmap *) ret));
 }
 
+errcode_t ext2fs_allocate_exclude_bitmap(ext2_filsys fs,
+				       const char *descr,
+				       ext2fs_exclude_bitmap *ret)
+{
+	__u32		start, end, real_end;
+
+	if (!EXT2_HAS_COMPAT_FEATURE(fs->super,
+				    EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP))
+		return 0;
+
+	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
+
+	fs->write_bitmaps = ext2fs_write_bitmaps;
+
+	start = fs->super->s_first_data_block;
+	end = fs->super->s_blocks_count-1;
+	real_end = (EXT2_BLOCKS_PER_GROUP(fs->super)
+		    * fs->group_desc_count)-1 + start;
+
+	if (fs->flags & EXT2_FLAG_64BITS)
+		return ext2fs_alloc_generic_bmap(fs,
+				  EXT2_ET_MAGIC_EXCLUDE_BITMAP64,
+				  EXT2FS_BMAP64_BITARRAY,
+				  start, end, real_end, descr, ret);
+
+	if ((end > ~0U) || (real_end > ~0U))
+		return EXT2_ET_CANT_USE_LEGACY_BITMAPS;
+
+	return ext2fs_make_generic_bitmap(EXT2_ET_MAGIC_EXCLUDE_BITMAP, fs,
+					   start, end, real_end,
+					   descr, 0, ret);
+}
+
 errcode_t ext2fs_allocate_block_bitmap(ext2_filsys fs,
 				       const char *descr,
 				       ext2fs_block_bitmap *ret)
@@ -268,6 +306,38 @@ errcode_t ext2fs_get_inode_bitmap_range(ext2fs_inode_bitmap bmap,
 						start, num, out));
 }
 
+errcode_t ext2fs_set_exclude_bitmap_range(ext2fs_exclude_bitmap bmap,
+					blk_t start, unsigned int num,
+					void *in)
+{
+	return ext2fs_set_generic_bitmap_range(bmap,
+						EXT2_ET_MAGIC_EXCLUDE_BITMAP,
+						start, num, in);
+}
+
+errcode_t ext2fs_set_exclude_bitmap_range2(ext2fs_exclude_bitmap bmap,
+					blk64_t start, size_t num,
+					void *in)
+{
+	return ext2fs_set_generic_bmap_range(bmap, start, num, in);
+}
+
+errcode_t ext2fs_get_exclude_bitmap_range(ext2fs_exclude_bitmap bmap,
+					blk_t start, unsigned int num,
+					void *out)
+{
+	return ext2fs_get_generic_bitmap_range(bmap,
+						EXT2_ET_MAGIC_EXCLUDE_BITMAP,
+						start, num, out);
+}
+
+errcode_t ext2fs_get_exclude_bitmap_range2(ext2fs_exclude_bitmap bmap,
+					blk64_t start, size_t num,
+					void *out)
+{
+	return ext2fs_get_generic_bmap_range(bmap, start, num, out);
+}
+
 errcode_t ext2fs_get_inode_bitmap_range2(ext2fs_inode_bitmap bmap,
 					 __u64 start, size_t num,
 					 void *out)
diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
index fd203b4..17df8c7 100644
--- a/lib/ext2fs/blknum.c
+++ b/lib/ext2fs/blknum.c
@@ -230,6 +230,33 @@ void ext2fs_block_bitmap_loc_set(ext2_filsys fs, dgrp_t group, blk64_t blk)
 }
 
 /*
+ * Return the exclude bitmap block of a group
+ */
+blk64_t ext2fs_exclude_bitmap_loc(ext2_filsys fs, dgrp_t group)
+{
+	struct ext4_group_desc *gdp;
+
+	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
+	return gdp->bg_exclude_bitmap_lo |
+		(fs->super->s_feature_incompat
+		 & EXT4_FEATURE_INCOMPAT_64BIT ?
+		 (__u64)gdp->bg_exclude_bitmap_hi << 32 : 0);
+}
+
+/*
+ * Set the exclude bitmap block of a group
+ */
+void ext2fs_exclude_bitmap_loc_set(ext2_filsys fs, dgrp_t group, blk64_t blk)
+{
+	struct ext4_group_desc *gdp;
+
+	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
+	gdp->bg_exclude_bitmap_lo = blk;
+	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+		gdp->bg_exclude_bitmap_hi = (__u64) blk >> 32;
+}
+
+/*
  * Return the inode bitmap block of a group
  */
 blk64_t ext2fs_inode_bitmap_loc(ext2_filsys fs, dgrp_t group)
diff --git a/lib/ext2fs/bmap64.h b/lib/ext2fs/bmap64.h
index 3056544..d1baef2 100644
--- a/lib/ext2fs/bmap64.h
+++ b/lib/ext2fs/bmap64.h
@@ -25,11 +25,13 @@ struct ext2fs_struct_generic_bitmap {
 #define EXT2FS_IS_32_BITMAP(bmap) \
 	(((bmap)->magic == EXT2_ET_MAGIC_GENERIC_BITMAP) || \
 	 ((bmap)->magic == EXT2_ET_MAGIC_BLOCK_BITMAP) || \
+	 ((bmap)->magic == EXT2_ET_MAGIC_EXCLUDE_BITMAP) || \
 	 ((bmap)->magic == EXT2_ET_MAGIC_INODE_BITMAP))
 
 #define EXT2FS_IS_64_BITMAP(bmap) \
 	(((bmap)->magic == EXT2_ET_MAGIC_GENERIC_BITMAP64) || \
 	 ((bmap)->magic == EXT2_ET_MAGIC_BLOCK_BITMAP64) || \
+	 ((bmap)->magic == EXT2_ET_MAGIC_EXCLUDE_BITMAP64) || \
 	 ((bmap)->magic == EXT2_ET_MAGIC_INODE_BITMAP64))
 
 struct ext2_bitmap_ops {
diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index 596923e..d6158e1 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -229,8 +229,9 @@ int main(int argc, char **argv)
 
 	for (i=0; i < fs->group_desc_count; i++) {
 		ext2fs_block_bitmap_loc_set(fs, i, 124);
-		ext2fs_inode_bitmap_loc_set(fs, i, 125);
-		ext2fs_inode_table_loc_set(fs, i, 126);
+		ext2fs_exclude_bitmap_loc_set(fs, i, 125);
+		ext2fs_inode_bitmap_loc_set(fs, i, 126);
+		ext2fs_inode_table_loc_set(fs, i, 127);
 		ext2fs_bg_free_blocks_count_set(fs, i, 31119);
 		ext2fs_bg_free_inodes_count_set(fs, i, 15701);
 		ext2fs_bg_used_dirs_count_set(fs, i, 2);
diff --git a/lib/ext2fs/dupfs.c b/lib/ext2fs/dupfs.c
index 64d3124..e7c00c1 100644
--- a/lib/ext2fs/dupfs.c
+++ b/lib/ext2fs/dupfs.c
@@ -77,6 +77,11 @@ errcode_t ext2fs_dup_handle(ext2_filsys src, ext2_filsys *dest)
 		if (retval)
 			goto errout;
 	}
+	if (src->exclude_map) {
+		retval = ext2fs_copy_bitmap(src->exclude_map, &fs->exclude_map);
+		if (retval)
+			goto errout;
+	}
 	if (src->badblocks) {
 		retval = ext2fs_badblocks_copy(src->badblocks, &fs->badblocks);
 		if (retval)
diff --git a/lib/ext2fs/ext2_err.et.in b/lib/ext2fs/ext2_err.et.in
index e759b6f..c49f0d0 100644
--- a/lib/ext2fs/ext2_err.et.in
+++ b/lib/ext2fs/ext2_err.et.in
@@ -38,6 +38,9 @@ ec	EXT2_ET_MAGIC_BLOCK_BITMAP,
 ec	EXT2_ET_MAGIC_INODE_BITMAP,
 	"Wrong magic number for inode_bitmap structure"
 
+ec	EXT2_ET_MAGIC_EXCLUDE_BITMAP,
+	"Wrong magic number for snapshot_bitmap structure"
+
 ec	EXT2_ET_MAGIC_GENERIC_BITMAP,
 	"Wrong magic number for generic_bitmap structure"
 
@@ -101,6 +104,12 @@ ec	EXT2_ET_BLOCK_BITMAP_WRITE,
 ec	EXT2_ET_BLOCK_BITMAP_READ,
 	"Can't read an block bitmap"
 
+ec	EXT2_ET_EXCLUDE_BITMAP_WRITE,
+	"Can't write an snapshot bitmap"
+
+ec	EXT2_ET_EXCLUDE_BITMAP_READ,
+	"Can't read an snapshot bitmap"
+
 ec	EXT2_ET_INODE_TABLE_WRITE,
 	"Can't write an inode table"
 
@@ -344,6 +353,9 @@ ec	EXT2_ET_MAGIC_BLOCK_BITMAP64,
 ec	EXT2_ET_MAGIC_INODE_BITMAP64,
 	"Wrong magic number for 64-bit inode bitmap"
 
+ec	EXT2_ET_MAGIC_EXCLUDE_BITMAP64,
+	"Wrong magic number for 64-bit exclude bitmap"
+
 ec	EXT2_ET_MAGIC_RESERVED_13,
 	"Wrong magic number --- RESERVED_13"
 
@@ -443,4 +455,13 @@ ec	EXT2_ET_MMP_CHANGE_ABORT,
 ec	EXT2_ET_MMP_OPEN_DIRECT,
 	"MMP: open with O_DIRECT failed"
 
+ec	EXT2_ET_BAD_EXCLUDE_TEST,
+	"Illegal block number passed to ext2fs_test_exclude_bitmap"
+
+ec	EXT2_ET_BAD_EXCLUDE_MARK,
+	"Illegal block number passed to ext2fs_mark_exclude_bitmap"
+
+ec	EXT2_ET_BAD_EXCLUDE_UNMARK,
+	"Illegal block number passed to ext2fs_unmark_exclude_bitmap"
+
 	end
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 0f8cde8..a1e29d0 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -194,6 +194,7 @@ struct ext4_group_desc
 #define EXT2_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not initialized */
 #define EXT2_BG_BLOCK_UNINIT	0x0002 /* Block bitmap not initialized */
 #define EXT2_BG_INODE_ZEROED	0x0004 /* On-disk itable initialized to zero */
+#define EXT2_BG_EXCLUDE_UNINIT	0x0008 /* Exclude bitmap not initialized */
 
 /*
  * Data structures used by the directory indexing feature
@@ -724,6 +725,7 @@ struct ext2_super_block {
 #define EXT2_FEATURE_INCOMPAT_SUPP    (EXT2_FEATURE_INCOMPAT_FILETYPE| \
 				       EXT4_FEATURE_INCOMPAT_MMP)
 #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
+					 EXT4_FEATURE_RO_COMPAT_HAS_SNAPSHOT|\
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK| \
 					 EXT2_FEATURE_RO_COMPAT_BTREE_DIR)
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 203d222..d1f0d98 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -113,7 +113,9 @@ typedef struct struct_ext2_filsys *ext2_filsys;
 
 typedef struct ext2fs_struct_generic_bitmap *ext2fs_generic_bitmap;
 typedef struct ext2fs_struct_generic_bitmap *ext2fs_inode_bitmap;
+typedef struct ext2fs_struct_generic_bitmap *ext2fs_exclude_bitmap;
 typedef struct ext2fs_struct_generic_bitmap *ext2fs_block_bitmap;
+typedef struct ext2fs_struct_generic_bitmap *ext2fs_exclude_bitmap;
 
 #define EXT2_FIRST_INODE(s)	EXT2_FIRST_INO(s)
 
@@ -196,6 +198,7 @@ typedef struct ext2_file *ext2_file_t;
 #define EXT2_FLAG_PRINT_PROGRESS	0x40000
 #define EXT2_FLAG_DIRECT_IO		0x80000
 #define EXT2_FLAG_SKIP_MMP		0x100000
+#define EXT2_FLAG_EB_DIRTY		0x200000
 
 /*
  * Special flag in the ext2 inode i_flag field that means that this is
@@ -225,6 +228,7 @@ struct struct_ext2_filsys {
 	unsigned int			inode_blocks_per_group;
 	ext2fs_inode_bitmap		inode_map;
 	ext2fs_block_bitmap		block_map;
+	ext2fs_exclude_bitmap		exclude_map;
 	/* XXX FIXME-64: not 64-bit safe, but not used? */
 	errcode_t (*get_blocks)(ext2_filsys fs, ext2_ino_t ino, blk_t *blocks);
 	errcode_t (*check_directory)(ext2_filsys fs, ext2_ino_t ino);
@@ -543,6 +547,7 @@ typedef struct ext2_icount *ext2_icount_t;
 #define EXT2_LIB_FEATURE_COMPAT_SUPP	(EXT2_FEATURE_COMPAT_DIR_PREALLOC|\
 					 EXT2_FEATURE_COMPAT_IMAGIC_INODES|\
 					 EXT3_FEATURE_COMPAT_HAS_JOURNAL|\
+					 EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP|\
 					 EXT2_FEATURE_COMPAT_RESIZE_INODE|\
 					 EXT2_FEATURE_COMPAT_DIR_INDEX|\
 					 EXT2_FEATURE_COMPAT_EXT_ATTR)
@@ -721,8 +726,10 @@ extern errcode_t ext2fs_copy_bitmap(ext2fs_generic_bitmap src,
 				    ext2fs_generic_bitmap *dest);
 extern errcode_t ext2fs_write_inode_bitmap(ext2_filsys fs);
 extern errcode_t ext2fs_write_block_bitmap (ext2_filsys fs);
+extern errcode_t ext2fs_write_exclude_bitmap (ext2_filsys fs);
 extern errcode_t ext2fs_read_inode_bitmap (ext2_filsys fs);
 extern errcode_t ext2fs_read_block_bitmap(ext2_filsys fs);
+extern errcode_t ext2fs_read_exclude_bitmap (ext2_filsys fs);
 extern errcode_t ext2fs_allocate_block_bitmap(ext2_filsys fs,
 					      const char *descr,
 					      ext2fs_block_bitmap *ret);
@@ -813,6 +820,9 @@ extern struct ext2_group_desc *ext2fs_group_desc(ext2_filsys fs,
 extern blk64_t ext2fs_block_bitmap_loc(ext2_filsys fs, dgrp_t group);
 extern void ext2fs_block_bitmap_loc_set(ext2_filsys fs, dgrp_t group,
 					blk64_t blk);
+extern blk64_t ext2fs_exclude_bitmap_loc(ext2_filsys fs, dgrp_t group);
+extern void ext2fs_block_exclude_loc_set(ext2_filsys fs, dgrp_t group,
+					blk64_t blk);
 extern blk64_t ext2fs_inode_bitmap_loc(ext2_filsys fs, dgrp_t group);
 extern void ext2fs_inode_bitmap_loc_set(ext2_filsys fs, dgrp_t group,
 					blk64_t blk);
@@ -1619,6 +1629,16 @@ _INLINE_ void ext2fs_mark_bb_dirty(ext2_filsys fs)
 }
 
 /*
+ * Mark the exclude bitmap as dirty
+ */
+_INLINE_ void ext2fs_mark_eb_dirty(ext2_filsys fs)
+{
+	if (EXT2_HAS_COMPAT_FEATURE(fs->super,
+				    EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP))
+		fs->flags |= EXT2_FLAG_EB_DIRTY | EXT2_FLAG_CHANGED;
+}
+
+/*
  * Check to see if a filesystem's inode bitmap is dirty
  */
 _INLINE_ int ext2fs_test_ib_dirty(ext2_filsys fs)
@@ -1635,6 +1655,14 @@ _INLINE_ int ext2fs_test_bb_dirty(ext2_filsys fs)
 }
 
 /*
+ * Check to see if a filesystem's exclude bitmap is dirty
+ */
+_INLINE_ int ext2fs_test_eb_dirty(ext2_filsys fs)
+{
+	return fs->flags & EXT2_FLAG_EB_DIRTY;
+}
+
+/*
  * Return the group # of a block
  */
 _INLINE_ int ext2fs_group_of_blk(ext2_filsys fs, blk_t blk)
diff --git a/lib/ext2fs/freefs.c b/lib/ext2fs/freefs.c
index 28c4132..488f077 100644
--- a/lib/ext2fs/freefs.c
+++ b/lib/ext2fs/freefs.c
@@ -43,6 +43,8 @@ void ext2fs_free(ext2_filsys fs)
 		ext2fs_free_block_bitmap(fs->block_map);
 	if (fs->inode_map)
 		ext2fs_free_inode_bitmap(fs->inode_map);
+	if (fs->exclude_map)
+		ext2fs_free_exclude_bitmap(fs->exclude_map);
 
 	if (fs->badblocks)
 		ext2fs_badblocks_list_free(fs->badblocks);
diff --git a/lib/ext2fs/gen_bitmap.c b/lib/ext2fs/gen_bitmap.c
index 6679bff..0285c33 100644
--- a/lib/ext2fs/gen_bitmap.c
+++ b/lib/ext2fs/gen_bitmap.c
@@ -42,11 +42,13 @@ struct ext2fs_struct_generic_bitmap {
 #define EXT2FS_IS_32_BITMAP(bmap) \
 	(((bmap)->magic == EXT2_ET_MAGIC_GENERIC_BITMAP) || \
 	 ((bmap)->magic == EXT2_ET_MAGIC_BLOCK_BITMAP) || \
+	 ((bmap)->magic == EXT2_ET_MAGIC_EXCLUDE_BITMAP) || \
 	 ((bmap)->magic == EXT2_ET_MAGIC_INODE_BITMAP))
 
 #define EXT2FS_IS_64_BITMAP(bmap) \
 	(((bmap)->magic == EXT2_ET_MAGIC_GENERIC_BITMAP64) || \
 	 ((bmap)->magic == EXT2_ET_MAGIC_BLOCK_BITMAP64) || \
+	 ((bmap)->magic == EXT2_ET_MAGIC_EXCLUDE_BITMAP64) || \
 	 ((bmap)->magic == EXT2_ET_MAGIC_INODE_BITMAP64))
 
 /*
@@ -69,6 +71,7 @@ static errcode_t check_magic(ext2fs_generic_bitmap bitmap)
 {
 	if (!bitmap || !((bitmap->magic == EXT2_ET_MAGIC_GENERIC_BITMAP) ||
 			 (bitmap->magic == EXT2_ET_MAGIC_INODE_BITMAP) ||
+			 (bitmap->magic == EXT2_ET_MAGIC_EXCLUDE_BITMAP) ||
 			 (bitmap->magic == EXT2_ET_MAGIC_BLOCK_BITMAP)))
 		return EXT2_ET_MAGIC_GENERIC_BITMAP;
 	return 0;
@@ -100,6 +103,9 @@ errcode_t ext2fs_make_generic_bitmap(errcode_t magic, ext2_filsys fs,
 	case EXT2_ET_MAGIC_BLOCK_BITMAP:
 		bitmap->base_error_code = EXT2_ET_BAD_BLOCK_MARK;
 		break;
+	case EXT2_ET_MAGIC_EXCLUDE_BITMAP:
+		bitmap->base_error_code = EXT2_ET_BAD_EXCLUDE_MARK;
+		break;
 	default:
 		bitmap->base_error_code = EXT2_ET_BAD_GENERIC_MARK;
 	}
@@ -517,6 +523,19 @@ int ext2fs_test_block_bitmap_range(ext2fs_block_bitmap bitmap,
 						      bitmap, block, num);
 }
 
+int ext2fs_test_exlucde_bitmap_range(ext2fs_exclude_bitmap bitmap,
+				   blk_t block, int num)
+{
+	EXT2_CHECK_MAGIC(bitmap, EXT2_ET_MAGIC_EXCLUDE_BITMAP);
+	if ((block < bitmap->start) || (block+num-1 > bitmap->real_end)) {
+		ext2fs_warn_bitmap(EXT2_ET_BAD_EXCLUDE_TEST,
+				   block, bitmap->description);
+		return 0;
+	}
+	return ext2fs_test_clear_generic_bitmap_range((ext2fs_generic_bitmap)
+						      bitmap, block, num);
+}
+
 int ext2fs_test_inode_bitmap_range(ext2fs_inode_bitmap bitmap,
 				   ino_t inode, int num)
 {
@@ -558,3 +577,32 @@ void ext2fs_unmark_block_bitmap_range(ext2fs_block_bitmap bitmap,
 		ext2fs_fast_clear_bit(block + i - bitmap->start,
 				      bitmap->bitmap);
 }
+
+void ext2fs_mark_exclude_bitmap_range(ext2fs_exclude_bitmap bitmap,
+				    blk_t block, int num)
+{
+	int	i;
+
+	if ((block < bitmap->start) || (block+num-1 > bitmap->end)) {
+		ext2fs_warn_bitmap(EXT2_ET_BAD_EXCLUDE_MARK, block,
+				   bitmap->description);
+		return;
+	}
+	for (i = 0; i < num; i++)
+		ext2fs_fast_set_bit(block + i - bitmap->start, bitmap->bitmap);
+}
+
+void ext2fs_unmark_exclude_bitmap_range(ext2fs_exclude_bitmap bitmap,
+					       blk_t block, int num)
+{
+	int	i;
+
+	if ((block < bitmap->start) || (block+num-1 > bitmap->end)) {
+		ext2fs_warn_bitmap(EXT2_ET_BAD_EXCLUDE_UNMARK, block,
+				   bitmap->description);
+		return;
+	}
+	for (i = 0; i < num; i++)
+		ext2fs_fast_clear_bit(block + i - bitmap->start,
+				      bitmap->bitmap);
+}
diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index 9dbbf9f..abceb0f 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -117,6 +117,9 @@ errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
 		bitmap->base_error_code = EXT2_ET_BAD_BLOCK_MARK;
 		bitmap->cluster_bits = fs->cluster_ratio_bits;
 		break;
+	case EXT2_ET_MAGIC_EXCLUDE_BITMAP64:
+		bitmap->base_error_code = EXT2_ET_BAD_EXCLUDE_MARK;
+		break;
 	default:
 		bitmap->base_error_code = EXT2_ET_BAD_GENERIC_MARK;
 	}
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 47f0b1c..0dc8852 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -97,6 +97,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	int		rsv_gdt;
 	int		csum_flag;
 	int		bigalloc_flag;
+	int		exclude_flag;
 	int		io_flags;
 	char		*buf = 0;
 	char		c;
@@ -407,6 +408,17 @@ ipg_retry:
 	if (retval)
 		goto cleanup;
 
+	exclude_flag = EXT2_HAS_COMPAT_FEATURE(fs->super,
+				    EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP);
+	if (exclude_flag) {
+		strcpy(buf, "exclude bitmap for ");
+		strcat(buf, fs->device_name);
+		retval = ext2fs_allocate_exclude_bitmap(fs, buf,
+							&fs->exclude_map);
+		if (retval)
+			goto cleanup;
+	}
+
 	strcpy(buf, "inode bitmap for ");
 	strcat(buf, fs->device_name);
 	retval = ext2fs_allocate_inode_bitmap(fs, buf, &fs->inode_map);
@@ -445,6 +457,9 @@ ipg_retry:
 			if (i != fs->group_desc_count - 1)
 				ext2fs_bg_flags_set(fs, i,
 						    EXT2_BG_BLOCK_UNINIT);
+			if (exclude_flag)
+				ext2fs_bg_flags_set(fs, i,
+						    EXT2_BG_EXCLUDE_UNINIT);
 			ext2fs_bg_flags_set(fs, i, EXT2_BG_INODE_UNINIT);
 			numblocks = super->s_inodes_per_group;
 			if (i == 0)
@@ -473,6 +488,7 @@ ipg_retry:
 
 	ext2fs_mark_super_dirty(fs);
 	ext2fs_mark_bb_dirty(fs);
+	ext2fs_mark_eb_dirty(fs);
 	ext2fs_mark_ib_dirty(fs);
 
 	io_channel_set_blksize(fs->io, fs->blocksize);
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 0cefe3f..a047d0d 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -376,6 +376,8 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 
 		for (group = 0; group < fs->group_desc_count; group++) {
 			ext2fs_bg_flags_clear(fs, group, EXT2_BG_BLOCK_UNINIT);
+			ext2fs_bg_flags_clear(fs, group,
+					      EXT2_BG_EXCLUDE_UNINIT);
 			ext2fs_bg_flags_clear(fs, group, EXT2_BG_INODE_UNINIT);
 			ext2fs_bg_itable_unused_set(fs, group, 0);
 		}
diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index 1d5f7b2..3126733 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -28,17 +28,21 @@
 #include "ext2fs.h"
 #include "e2image.h"
 
-static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
+static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block,
+			       int do_exclude)
 {
 	dgrp_t 		i;
 	unsigned int	j;
 	int		block_nbytes, inode_nbytes;
 	unsigned int	nbits;
 	errcode_t	retval;
-	char		*block_buf = NULL, *inode_buf = NULL;
+	char		*block_buf = NULL, *inode_buf = NULL,
+			*exclude_buf = NULL;
 	int		csum_flag = 0;
 	blk64_t		blk;
 	blk64_t		blk_itr = EXT2FS_B2C(fs, fs->super->s_first_data_block);
+	blk64_t		exclude_itr =
+			EXT2FS_B2C(fs, fs->super->s_first_data_block);
 	ext2_ino_t	ino_itr = 1;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
@@ -46,6 +50,10 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 	if (!(fs->flags & EXT2_FLAG_RW))
 		return EXT2_ET_RO_FILSYS;
 
+	if (!EXT2_HAS_COMPAT_FEATURE(fs->super,
+				EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP))
+		do_exclude = 0;
+
 	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
 		csum_flag = 1;
@@ -59,6 +67,14 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 			goto errout;
 		memset(block_buf, 0xff, fs->blocksize);
 	}
+	if (do_exclude) {
+		block_nbytes = EXT2_BLOCKS_PER_GROUP(fs->super) / 8;
+		retval = ext2fs_get_memalign(fs->blocksize, fs->blocksize,
+					     &exclude_buf);
+		if (retval)
+			return retval;
+		memset(exclude_buf, 0x0, fs->blocksize);
+	}
 	if (do_inode) {
 		inode_nbytes = (size_t)
 			((EXT2_INODES_PER_GROUP(fs->super)+7) / 8);
@@ -104,6 +120,26 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 	skip_this_block_bitmap:
 		blk_itr += block_nbytes << 3;
 	skip_block_bitmap:
+		if (!do_exclude)
+			goto skip_exclude_bitmap;
+		if (csum_flag && ext2fs_bg_flags_test(fs, i, EXT2_BG_EXCLUDE_UNINIT)
+		    )
+			goto skip_this_exclude_bitmap;
+
+		retval = ext2fs_get_block_bitmap_range2(fs->exclude_map,
+				exclude_itr, block_nbytes << 3, exclude_buf);
+		if (retval)
+			goto errout;
+		blk = ext2fs_exclude_bitmap_loc(fs, i);
+		if (blk) {
+			retval = io_channel_write_blk64(fs->io, blk, 1,
+						      exclude_buf);
+			if (retval)
+				return EXT2_ET_EXCLUDE_BITMAP_WRITE;
+		}
+	skip_this_exclude_bitmap:
+		exclude_itr += block_nbytes << 3;
+	skip_exclude_bitmap:
 
 		if (!do_inode)
 			continue;
@@ -126,7 +162,7 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 				goto errout;
 			}
 		}
-	skip_this_inode_bitmap:
+skip_this_inode_bitmap:
 		ino_itr += inode_nbytes << 3;
 
 	}
@@ -134,6 +170,10 @@ static errcode_t write_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 		fs->flags &= ~EXT2_FLAG_BB_DIRTY;
 		ext2fs_free_mem(&block_buf);
 	}
+	if (do_exclude) {
+		fs->flags &= ~EXT2_FLAG_EB_DIRTY;
+		ext2fs_free_mem(&exclude_buf);
+	}
 	if (do_inode) {
 		fs->flags &= ~EXT2_FLAG_IB_DIRTY;
 		ext2fs_free_mem(&inode_buf);
@@ -147,10 +187,11 @@ errout:
 	return retval;
 }
 
-static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
+static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block,
+		int do_exclude)
 {
 	dgrp_t i;
-	char *block_bitmap = 0, *inode_bitmap = 0;
+	char *block_bitmap = 0, *inode_bitmap = 0, *exclude_bitmap = 0;
 	char *buf;
 	errcode_t retval;
 	int block_nbytes = EXT2_CLUSTERS_PER_GROUP(fs->super) / 8;
@@ -168,6 +209,10 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 
 	fs->write_bitmaps = ext2fs_write_bitmaps;
 
+	if (!EXT2_HAS_COMPAT_FEATURE(fs->super,
+				EXT2_FEATURE_COMPAT_EXCLUDE_BITMAP))
+		do_exclude = 0;
+
 	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
 		csum_flag = 1;
@@ -192,7 +237,25 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 			
 		if (retval)
 			goto cleanup;
-	} else
+	}
+	if (do_exclude) {
+		if (fs->exclude_map)
+			ext2fs_free_block_bitmap(fs->exclude_map);
+		strcpy(buf, "exclude bitmap for ");
+		strcat(buf, fs->device_name);
+		retval = ext2fs_allocate_block_bitmap(fs, buf, &fs->exclude_map);
+		if (retval)
+			goto cleanup;
+		if (do_image)
+			retval = ext2fs_get_mem(fs->blocksize, &exclude_bitmap);
+		else
+			retval = ext2fs_get_memalign((unsigned) block_nbytes,
+						     fs->blocksize,
+						     &exclude_bitmap);
+		if (retval)
+			goto cleanup;
+	}
+	if (!do_block && !do_exclude)
 		block_nbytes = 0;
 	if (do_inode) {
 		if (fs->inode_map)
@@ -234,6 +297,11 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 		blk_cnt = (blk64_t)EXT2_CLUSTERS_PER_GROUP(fs->super) *
 			fs->group_desc_count;
 		while (block_nbytes > 0) {
+			if (do_exclude) {
+				retval = EXT2_ET_EXCLUDE_BITMAP_READ;
+				goto cleanup;
+			}
+
 			retval = io_channel_read_blk64(fs->image_io, blk++,
 						     1, block_bitmap);
 			if (retval)
@@ -273,8 +341,30 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 					       blk_itr, cnt, block_bitmap);
 			if (retval)
 				goto cleanup;
-			blk_itr += block_nbytes << 3;
 		}
+		if (exclude_bitmap) {
+			blk = ext2fs_exclude_bitmap_loc(fs, i);
+			if (csum_flag &&
+			    ext2fs_bg_flags_test(fs, i, EXT2_BG_EXCLUDE_UNINIT) &&
+			    ext2fs_group_desc_csum_verify(fs, i))
+				blk = 0;
+			if (blk) {
+				retval = io_channel_read_blk64(fs->io, blk,
+					     -block_nbytes, exclude_bitmap);
+				if (retval) {
+					retval = EXT2_ET_EXCLUDE_BITMAP_READ;
+					goto cleanup;
+				}
+			} else
+				memset(exclude_bitmap, 0, block_nbytes);
+			cnt = block_nbytes << 3;
+			retval = ext2fs_set_block_bitmap_range2(fs->exclude_map,
+					       blk_itr, cnt, exclude_bitmap);
+			if (retval)
+				goto cleanup;
+		}
+		if (block_nbytes)
+			blk_itr += block_nbytes << 3;
 		if (inode_bitmap) {
 			blk = ext2fs_inode_bitmap_loc(fs, i);
 			if (csum_flag &&
@@ -303,6 +393,8 @@ success_cleanup:
 		ext2fs_free_mem(&inode_bitmap);
 	if (block_bitmap)
 		ext2fs_free_mem(&block_bitmap);
+	if (exclude_bitmap)
+		ext2fs_free_mem(&exclude_bitmap);
 	return 0;
 
 cleanup:
@@ -318,6 +410,8 @@ cleanup:
 		ext2fs_free_mem(&inode_bitmap);
 	if (block_bitmap)
 		ext2fs_free_mem(&block_bitmap);
+	if (exclude_bitmap)
+		ext2fs_free_mem(&exclude_bitmap);
 	if (buf)
 		ext2fs_free_mem(&buf);
 	return retval;
@@ -325,39 +419,51 @@ cleanup:
 
 errcode_t ext2fs_read_inode_bitmap(ext2_filsys fs)
 {
-	return read_bitmaps(fs, 1, 0);
+	return read_bitmaps(fs, 1, 0, 0);
 }
 
 errcode_t ext2fs_read_block_bitmap(ext2_filsys fs)
 {
-	return read_bitmaps(fs, 0, 1);
+	return read_bitmaps(fs, 0, 1, 0);
+}
+
+errcode_t ext2fs_read_exclude_bitmap (ext2_filsys fs)
+{
+	return read_bitmaps(fs, 0, 0, 1);
 }
 
 errcode_t ext2fs_write_inode_bitmap(ext2_filsys fs)
 {
-	return write_bitmaps(fs, 1, 0);
+	return write_bitmaps(fs, 1, 0, 0);
 }
 
 errcode_t ext2fs_write_block_bitmap (ext2_filsys fs)
 {
-	return write_bitmaps(fs, 0, 1);
+	return write_bitmaps(fs, 0, 1, 0);
+}
+
+errcode_t ext2fs_write_exclude_bitmap (ext2_filsys fs)
+{
+	return write_bitmaps(fs, 0, 0, 1);
 }
 
 errcode_t ext2fs_read_bitmaps(ext2_filsys fs)
 {
-	if (fs->inode_map && fs->block_map)
+	if (fs->inode_map && fs->block_map && fs->exclude_map)
 		return 0;
 
-	return read_bitmaps(fs, !fs->inode_map, !fs->block_map);
+	return read_bitmaps(fs, !fs->inode_map, !fs->block_map,
+			    !fs->exclude_map);
 }
 
 errcode_t ext2fs_write_bitmaps(ext2_filsys fs)
 {
 	int do_inode = fs->inode_map && ext2fs_test_ib_dirty(fs);
 	int do_block = fs->block_map && ext2fs_test_bb_dirty(fs);
+	int do_exclude = fs->exclude_map && ext2fs_test_eb_dirty(fs);
 
-	if (!do_inode && !do_block)
+	if (!do_inode && !do_block && !do_exclude)
 		return 0;
 
-	return write_bitmaps(fs, do_inode, do_block);
+	return write_bitmaps(fs, do_inode, do_block, do_exclude);
 }
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index 7962472..07ba1cd 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -105,6 +105,7 @@ void ext2fs_swap_group_desc2(ext2_filsys fs, struct ext2_group_desc *gdp)
 {
 	/* Do the 32-bit parts first */
 	gdp->bg_block_bitmap = ext2fs_swab32(gdp->bg_block_bitmap);
+	gdp->bg_exclude_bitmap = ext2fs_swab32(gdp->bg_exclude_bitmap);
 	gdp->bg_inode_bitmap = ext2fs_swab32(gdp->bg_inode_bitmap);
 	gdp->bg_inode_table = ext2fs_swab32(gdp->bg_inode_table);
 	gdp->bg_free_blocks_count = ext2fs_swab16(gdp->bg_free_blocks_count);
@@ -126,6 +127,7 @@ void ext2fs_swap_group_desc2(ext2_filsys fs, struct ext2_group_desc *gdp)
 	/* Swap the 64-bit parts */
 	struct ext4_group_desc *gdp4 = (struct ext4_group_desc *) gdp;
 	gdp4->bg_block_bitmap_hi = ext2fs_swab32(gdp4->bg_block_bitmap_hi);
+	gdp4->bg_exclude_bitmap_hi = ext2fs_swab32(gdp4->bg_exclude_bitmap_hi);
 	gdp4->bg_inode_bitmap_hi = ext2fs_swab32(gdp4->bg_inode_bitmap_hi);
 	gdp4->bg_inode_table_hi = ext2fs_swab32(gdp4->bg_inode_table_hi);
 	gdp4->bg_free_blocks_count_hi =
-- 
1.7.5.1

