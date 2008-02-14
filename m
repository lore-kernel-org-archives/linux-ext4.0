From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH] e2fsprogs: New bitmap and inode table allocation for
 FLEX_BG v2
Date: Wed, 13 Feb 2008 20:47:50 -0600
Message-ID: <20080213204750.5666a560@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47416 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741AbYBNCsI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Feb 2008 21:48:08 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1E2m4AU014061
	for <linux-ext4@vger.kernel.org>; Wed, 13 Feb 2008 21:48:04 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1E2lskx233706
	for <linux-ext4@vger.kernel.org>; Wed, 13 Feb 2008 21:48:04 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1E2lrV6013869
	for <linux-ext4@vger.kernel.org>; Wed, 13 Feb 2008 21:47:54 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

New bitmap and inode table allocation for FLEX_BG

From: Jose R. Santos <jrs@us.ibm.com>

Change the way we allocate bitmaps and inode tables if the FLEX_BG
feature is used at mke2fs time.  It places calculates a new offset for
bitmaps and inode table base on the number of groups that the user
wishes to pack together using the new "-G" option.  Creating a
filesystem with 64 block groups in a flex group can be done by:

mke2fs -j -I 256 -O flex_bg -G 32 /dev/sdX

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
Signed-off-by: Valerie Clement <valerie.clement@bull.net>
---

 lib/ext2fs/alloc_tables.c |  122 ++++++++++++++++++++++++++++++++++++++++++++-
 lib/ext2fs/closefs.c      |    6 +-
 lib/ext2fs/ext2_fs.h      |    6 ++
 lib/ext2fs/initialize.c   |    6 ++
 misc/mke2fs.8.in          |   15 ++++++
 misc/mke2fs.c             |   24 ++++++++-
 6 files changed, 171 insertions(+), 8 deletions(-)

diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
index 4ad2ba9..043293b 100644
--- a/lib/ext2fs/alloc_tables.c
+++ b/lib/ext2fs/alloc_tables.c
@@ -27,18 +27,88 @@
 #include "ext2_fs.h"
 #include "ext2fs.h"
 
+void ext2fs_bgd_set_flex_meta_flag(ext2_filsys fs, blk_t block)
+{
+	dgrp_t	group;
+
+	group = ext2fs_group_of_blk(fs, block);
+	if (!(fs->group_desc[group].bg_flags & EXT2_BG_FLEX_METADATA))
+		fs->group_desc[group].bg_flags |= EXT2_BG_FLEX_METADATA;
+}
+
+/*
+ * This routine searches for free blocks that can allocate a full
+ * group of bitmaps or inode tables for a flexbg group.  Returns the
+ * block number with a correct offset were the bitmaps and inode
+ * tables can be allocated continously and in order.
+ */
+blk_t ext2fs_flexbg_offset(ext2_filsys fs, dgrp_t group, blk_t start_blk,
+			   ext2fs_block_bitmap bmap, int offset, int size)
+{
+	int		flexbg, flexbg_size, elem_size;
+	blk_t		last_blk, first_free = 0;
+	dgrp_t	       	last_grp;
+
+	flexbg_size = 1 << fs->super->s_log_groups_per_flex;
+	flexbg = group / flexbg_size;
+
+	if (size > fs->super->s_blocks_per_group / 8)
+		size = fs->super->s_blocks_per_group / 8;
+
+	/*
+	 * Dont do a long search if the previous block
+	 * search is still valid.
+	 */
+	if (start_blk && group % flexbg_size) {
+		if (size > flexbg_size)
+			elem_size = fs->inode_blocks_per_group;
+		else
+			elem_size = 1;
+		if (ext2fs_test_block_bitmap_range(bmap, start_blk + elem_size,
+						   size))
+			return start_blk + elem_size;
+	}
+
+	start_blk = ext2fs_group_first_block(fs, flexbg_size * flexbg);
+	last_grp = group | (flexbg_size - 1);
+	if (last_grp > fs->group_desc_count)
+		last_grp = fs->group_desc_count;
+	last_blk = ext2fs_group_last_block(fs, last_grp);
+
+	/* Find the first available block */
+	if (ext2fs_get_free_blocks(fs, start_blk, last_blk, 1, bmap,
+				   &first_free))
+		return first_free;
+
+	if (ext2fs_get_free_blocks(fs, first_free + offset, last_blk, size,
+				   bmap, &first_free))
+		return first_free;
+
+	return first_free;
+}
+
 errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 				      ext2fs_block_bitmap bmap)
 {
 	errcode_t	retval;
 	blk_t		group_blk, start_blk, last_blk, new_blk, blk;
-	int		j;
+	dgrp_t		last_grp;
+	int		j, rem_grps, flexbg_size = 0;
 
 	group_blk = ext2fs_group_first_block(fs, group);
 	last_blk = ext2fs_group_last_block(fs, group);
 
 	if (!bmap)
 		bmap = fs->block_map;
+
+	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
+		flexbg_size = 1 << fs->super->s_log_groups_per_flex;
+		last_grp = group | (flexbg_size - 1);
+		rem_grps = last_grp - group;
+		if (last_grp > fs->group_desc_count)
+			last_grp = fs->group_desc_count;
+	}
 	
 	/*
 	 * Allocate the block and inode bitmaps, if necessary
@@ -56,6 +126,15 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 	} else
 		start_blk = group_blk;
 
+	if (flexbg_size) {
+		int prev_block = 0;
+		if (group && fs->group_desc[group-1].bg_block_bitmap)
+			prev_block = fs->group_desc[group-1].bg_block_bitmap;
+		start_blk = ext2fs_flexbg_offset(fs, group, prev_block, bmap,
+						 0, rem_grps);
+		last_blk = ext2fs_group_last_block(fs, last_grp);
+	}
+
 	if (!fs->group_desc[group].bg_block_bitmap) {
 		retval = ext2fs_get_free_blocks(fs, start_blk, last_blk,
 						1, bmap, &new_blk);
@@ -66,6 +145,21 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 			return retval;
 		ext2fs_mark_block_bitmap(bmap, new_blk);
 		fs->group_desc[group].bg_block_bitmap = new_blk;
+		if (flexbg_size) {
+			dgrp_t tmp = ext2fs_group_of_blk(fs, new_blk);
+			ext2fs_bgd_set_flex_meta_flag(fs, new_blk);
+			fs->group_desc[tmp].bg_free_blocks_count--;
+			fs->super->s_free_blocks_count--;
+		}
+	}
+
+	if (flexbg_size) {
+		int prev_block = 0;
+		if (group && fs->group_desc[group-1].bg_inode_bitmap)
+			prev_block = fs->group_desc[group-1].bg_inode_bitmap;
+		start_blk = ext2fs_flexbg_offset(fs, group, prev_block, bmap,
+						 flexbg_size, rem_grps);
+		last_blk = ext2fs_group_last_block(fs, last_grp);
 	}
 
 	if (!fs->group_desc[group].bg_inode_bitmap) {
@@ -78,11 +172,28 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 			return retval;
 		ext2fs_mark_block_bitmap(bmap, new_blk);
 		fs->group_desc[group].bg_inode_bitmap = new_blk;
+		if (flexbg_size) {
+			dgrp_t tmp = ext2fs_group_of_blk(fs, new_blk);
+			ext2fs_bgd_set_flex_meta_flag(fs, new_blk);
+			fs->group_desc[tmp].bg_free_blocks_count--;
+			fs->super->s_free_blocks_count--;
+		}
 	}
 
 	/*
 	 * Allocate the inode table
 	 */
+	if (flexbg_size) {
+		int prev_block = 0;
+		if (group && fs->group_desc[group-1].bg_inode_table)
+			prev_block = fs->group_desc[group-1].bg_inode_table;
+		group_blk = ext2fs_flexbg_offset(fs, group, prev_block, bmap,
+						 flexbg_size * 2,
+						 fs->inode_blocks_per_group *
+						 rem_grps);
+		last_blk = ext2fs_group_last_block(fs, last_grp);
+	}
+
 	if (!fs->group_desc[group].bg_inode_table) {
 		retval = ext2fs_get_free_blocks(fs, group_blk, last_blk,
 						fs->inode_blocks_per_group,
@@ -91,8 +202,15 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 			return retval;
 		for (j=0, blk = new_blk;
 		     j < fs->inode_blocks_per_group;
-		     j++, blk++)
+		     j++, blk++) {
 			ext2fs_mark_block_bitmap(bmap, blk);
+			if (flexbg_size) {
+				dgrp_t tmp = ext2fs_group_of_blk(fs, blk);
+				ext2fs_bgd_set_flex_meta_flag(fs, blk);
+				fs->group_desc[tmp].bg_free_blocks_count--;
+				fs->super->s_free_blocks_count--;
+			}
+		}
 		fs->group_desc[group].bg_inode_table = new_blk;
 	}
 
diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index a523c8e..83d7cc4 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -56,6 +56,7 @@ int ext2fs_super_and_bgd_loc(ext2_filsys fs,
 	unsigned int meta_bg, meta_bg_size;
 	blk_t	numblocks, old_desc_blocks;
 	int	has_super;
+	unsigned int flex_bg_size = 1 << fs->super->s_log_groups_per_flex;
 
 	group_block = ext2fs_group_first_block(fs, group);
 
@@ -99,8 +100,9 @@ int ext2fs_super_and_bgd_loc(ext2_filsys fs,
 			numblocks--;
 		}
 	}
-		
-	numblocks -= 2 + fs->inode_blocks_per_group;
+
+	if (!fs->super->s_log_groups_per_flex)
+		numblocks -= 2 + fs->inode_blocks_per_group;
 
 	if (ret_super_blk)
 		*ret_super_blk = super_blk;
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index e04ba9a..3400d8e 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -173,6 +173,7 @@ struct ext4_group_desc
 
 #define EXT2_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not initialized */
 #define EXT2_BG_BLOCK_UNINIT	0x0002 /* Block bitmap not initialized */
+#define EXT2_BG_FLEX_METADATA	0x0008 /* FLEX_BG block group contains meta-data */
 
 /*
  * Data structures used by the directory indexing feature
@@ -558,7 +559,10 @@ struct ext2_super_block {
 	__u16   s_mmp_interval;         /* # seconds to wait in MMP checking */
 	__u64   s_mmp_block;            /* Block for multi-mount protection */
 	__u32   s_raid_stripe_width;    /* blocks on all data disks (N*stride)*/
-	__u32   s_reserved[163];        /* Padding to the end of the block */
+	__u8	s_log_groups_per_flex;	/* FLEX_BG group size */
+	__u8    s_reserved_char_pad;
+	__u16	s_reserved_pad;		/* Padding to next 32bits */
+	__u32   s_reserved[162];        /* Padding to the end of the block */
 };
 
 /*
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 69bbcf3..f8b39a9 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -156,6 +156,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	set_field(s_feature_incompat, 0);
 	set_field(s_feature_ro_compat, 0);
 	set_field(s_first_meta_bg, 0);
+	set_field(s_log_groups_per_flex, 0);
 	if (super->s_feature_incompat & ~EXT2_LIB_FEATURE_INCOMPAT_SUPP) {
 		retval = EXT2_ET_UNSUPP_FEATURE;
 		goto cleanup;
@@ -363,7 +364,10 @@ ipg_retry:
 	 * group, and fill in the correct group statistics for group.
 	 * Note that although the block bitmap, inode bitmap, and
 	 * inode table have not been allocated (and in fact won't be
-	 * by this routine), they are accounted for nevertheless.
+	 * by this routine), they are accounted for nevertheless.  If
+	 * FLEX_BG meta-data grouping is used, only account for the
+	 * superblock and group descriptors (the inode tables and
+	 * bitmaps will be accounted for when allocated).
 	 */
 	super->s_free_blocks_count = 0;
 	for (i = 0; i < fs->group_desc_count; i++) {
diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
index a3dc4a1..1128978 100644
--- a/misc/mke2fs.8.in
+++ b/misc/mke2fs.8.in
@@ -26,6 +26,10 @@ mke2fs \- create an ext2/ext3 filesystem
 .I blocks-per-group
 ]
 [
+.B \-G
+.I number-of-groups
+]
+[
 .B \-i
 .I bytes-per-inode
 ]
@@ -215,6 +219,12 @@ option rather than manipulating the number of blocks per group.)
 This option is generally used by developers who
 are developing test cases.  
 .TP
+.BI \-G " number-of-groups"
+Specify the number of block goups that will be packed together to
+create one large virtual block group on an ext4 filesystem.  This
+improves meta-data locality and performance on meta-data heavy
+workloads.  The number of goups must be a power of 2.
+.TP
 .BI \-i " bytes-per-inode"
 Specify the bytes/inode ratio. 
 .B mke2fs
@@ -404,6 +414,11 @@ Use hashed b-trees to speed up lookups in large directories.
 .B filetype
 Store file type information in directory entries.
 .TP
+.B flex_bg
+Allow bitmaps and inode tables for a block group to be placed anywhere
+on the storage media (use with -G option to group meta-data in order
+to create a large virtual block group).
+.TP
 .B has_journal
 Create an ext3 journal (as if using the
 .B \-j
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 44f45aa..40d6c76 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -96,7 +96,7 @@ static void usage(void)
 {
 	fprintf(stderr, _("Usage: %s [-c|-t|-l filename] [-b block-size] "
 	"[-f fragment-size]\n\t[-i bytes-per-inode] [-I inode-size] "
-	"[-j] [-J journal-options]\n"
+	"[-j] [-J journal-options] [-G meta group size]\n"
 	"\t[-N number-of-inodes] [-m reserved-blocks-percentage] "
 	"[-o creator-os]\n\t[-g blocks-per-group] [-L volume-label] "
 	"[-M last-mounted-directory]\n\t[-O feature[,...]] "
@@ -464,6 +464,8 @@ static void setup_lazy_bg(ext2_filsys fs)
 				sb->s_free_inodes_count -= 
 					sb->s_inodes_per_group;
 			}
+			if ((bg->bg_flags & EXT2_BG_FLEX_METADATA))
+				continue;
 			blks = ext2fs_super_and_bgd_loc(fs, i, 0, 0, 0, 0);
 			if (bg->bg_free_blocks_count == blks) {
 				bg->bg_free_blocks_count = 0;
@@ -909,6 +911,7 @@ static void PRS(int argc, char *argv[])
 	int		blocksize = 0;
 	int		inode_ratio = 0;
 	int		inode_size = 0;
+	unsigned long	flex_bg_size = 0;
 	double		reserved_ratio = 5.0;
 	int		sector_size = 0;
 	int		show_version_only = 0;
@@ -991,7 +994,7 @@ static void PRS(int argc, char *argv[])
 	}
 
 	while ((c = getopt (argc, argv,
-		    "b:cf:g:i:jl:m:no:qr:s:tvE:FI:J:L:M:N:O:R:ST:V")) != EOF) {
+		    "b:cf:g:G:i:jl:m:no:qr:s:tvE:FI:J:L:M:N:O:R:ST:V")) != EOF) {
 		switch (c) {
 		case 'b':
 			blocksize = strtol(optarg, &tmp, 0);
@@ -1042,6 +1045,20 @@ static void PRS(int argc, char *argv[])
 				exit(1);
 			}
 			break;
+		case 'G':
+			flex_bg_size = strtoul(optarg, &tmp, 0);
+			if (*tmp) {
+				com_err(program_name, 0,
+					_("Illegal number for Flex_BG size"));
+				exit(1);
+			}
+			if (flex_bg_size < 2 ||
+			    (flex_bg_size & (flex_bg_size-1)) != 0) {
+				com_err(program_name, 0,
+					_("Flex_BG size must be a power of 2"));
+				exit(1);
+			}
+			break;
 		case 'i':
 			inode_ratio = strtoul(optarg, &tmp, 0);
 			if (inode_ratio < EXT2_MIN_BLOCK_SIZE ||
@@ -1437,6 +1454,9 @@ static void PRS(int argc, char *argv[])
 		}
 	}
 
+	if (flex_bg_size)
+		fs_param.s_log_groups_per_flex = int_log2(flex_bg_size);
+
 	if (!force && fs_param.s_blocks_count >= ((unsigned) 1 << 31)) {
 		com_err(program_name, 0,
 			_("Filesystem too large.  No more than 2**31-1 blocks\n"
