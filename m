From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: FLEX_BG support for the e2fsprogs interim branch.
Date: Tue, 19 Feb 2008 14:29:02 -0600
Message-ID: <20080219142902.1724924e@gara>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/LhlpTD3ZUmf7YHdAWMDVWo7"
To: Theodore Tso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:50970 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbYBSU3I (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Feb 2008 15:29:08 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1JKT5bH012396
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 15:29:05 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1JKT56m178936
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 13:29:05 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1JKT5tF012003
	for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2008 13:29:05 -0700
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--MP_/LhlpTD3ZUmf7YHdAWMDVWo7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Ted,

I've attached two patches to add FLEX_BG support on the interim branch
of e2fsprogs.  The first patch is the grouping of 3 patches already
available in the e2fsprogs-next branch for basic feature support while
the second patch is the meta-data grouping patch that is still waiting
on the e2fsprogs-pu branch.


-JRS

--MP_/LhlpTD3ZUmf7YHdAWMDVWo7
Content-Type: text/x-patch; name=flex_bg_support.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=flex_bg_support.patch

From: Jose R. Santos <jrs@us.ibm.com>

This patch add basic flex_bg support to the e2fsprogs-interim branch.

---

 e2fsck/super.c          |    7 +++++--
 lib/e2p/feature.c       |    2 ++
 lib/ext2fs/check_desc.c |    9 ++++++---
 lib/ext2fs/ext2_fs.h    |    1 +
 lib/ext2fs/ext2fs.h     |    6 ++++--
 misc/mke2fs.c           |    3 ++-
 misc/tune2fs.c          |   13 +++++++++++++
 7 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/e2fsck/super.c b/e2fsck/super.c
index 0b17c48..581e8fe 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -584,8 +584,11 @@ void check_super_block(e2fsck_t ctx)
 	for (i = 0, gd=fs->group_desc; i < fs->group_desc_count; i++, gd++) {
 		pctx.group = i;
 
-		first_block = ext2fs_group_first_block(fs, i);
-		last_block = ext2fs_group_last_block(fs, i);
+		if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+					       EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
+			first_block = ext2fs_group_first_block(fs, i);
+			last_block = ext2fs_group_last_block(fs, i);
+		}
 
 		if ((gd->bg_block_bitmap < first_block) ||
 		    (gd->bg_block_bitmap > last_block)) {
diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index f111ddd..a9791b4 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -67,6 +67,8 @@ static struct feature feature_list[] = {
 			"extent" },
 	{	E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_64BIT,
 			"64bit" },
+	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_FLEX_BG,
+			"flex_bg"},
 	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_MMP,
 			"mmp" },
 	{	0, 0, 0 },
diff --git a/lib/ext2fs/check_desc.c b/lib/ext2fs/check_desc.c
index 146f9e5..900b179 100644
--- a/lib/ext2fs/check_desc.c
+++ b/lib/ext2fs/check_desc.c
@@ -33,13 +33,16 @@ errcode_t ext2fs_check_desc(ext2_filsys fs)
 {
 	dgrp_t i;
 	blk_t first_block = fs->super->s_first_data_block;
-	blk_t last_block;
+	blk_t last_block = fs->super->s_blocks_count-1;
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
 	for (i = 0; i < fs->group_desc_count; i++) {
-		first_block = ext2fs_group_first_block(fs, i);
-		last_block = ext2fs_group_last_block(fs, i);
+		if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
+					       EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
+			first_block = ext2fs_group_first_block(fs, i);
+			last_block = ext2fs_group_last_block(fs, i);
+		}
 
 		/*
 		 * Check to make sure block bitmap for group is
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 9218e42..412b49b 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -661,6 +661,7 @@ struct ext2_super_block {
 #define EXT3_FEATURE_INCOMPAT_EXTENTS		0x0040
 #define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
 #define EXT4_FEATURE_INCOMPAT_MMP		0x0100
+#define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
 
 
 #define EXT2_FEATURE_COMPAT_SUPP	0
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 1d86fa1..b34aff1 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -482,14 +482,16 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT2_FEATURE_INCOMPAT_META_BG|\
 					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
 					 EXT3_FEATURE_INCOMPAT_RECOVER|\
-					 EXT4_FEATURE_INCOMPAT_MMP)
+					 EXT4_FEATURE_INCOMPAT_MMP|\
+					 EXT4_FEATURE_INCOMPAT_FLEX_BG)
 #else
 #define EXT2_LIB_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE|\
 					 EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|\
 					 EXT2_FEATURE_INCOMPAT_META_BG|\
 					 EXT3_FEATURE_INCOMPAT_EXTENTS|\
 					 EXT3_FEATURE_INCOMPAT_RECOVER|\
-					 EXT4_FEATURE_INCOMPAT_MMP)
+					 EXT4_FEATURE_INCOMPAT_MMP|\
+					 EXT4_FEATURE_INCOMPAT_FLEX_BG)
 #endif
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE|\
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 8210c3b..0184af7 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -922,7 +922,8 @@ static __u32 ok_features[3] = {
 	EXT2_FEATURE_INCOMPAT_FILETYPE|		/* Incompat */
 		EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|
 		EXT2_FEATURE_INCOMPAT_META_BG|
-		EXT4_FEATURE_INCOMPAT_MMP,
+		EXT4_FEATURE_INCOMPAT_MMP|
+		EXT4_FEATURE_INCOMPAT_FLEX_BG,
 	EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|	/* R/O compat */
 		EXT4_FEATURE_RO_COMPAT_GDT_CSUM
 };
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index fad4812..d37ceb1 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -303,6 +303,7 @@ static void update_feature_set(ext2_filsys fs, char *features)
 {
 	int sparse, old_sparse, filetype, old_filetype;
 	int journal, old_journal, dxdir, old_dxdir, uninit;
+	int flex_bg, old_flex_bg;
 	int mmp, old_mmp;
 	struct ext2_super_block *sb= fs->super;
 	int dir_nlink, old_dir_nlink;
@@ -319,6 +320,8 @@ static void update_feature_set(ext2_filsys fs, char *features)
 		EXT4_FEATURE_RO_COMPAT_DIR_NLINK;
 	old_filetype = sb->s_feature_incompat &
 		EXT2_FEATURE_INCOMPAT_FILETYPE;
+	old_flex_bg = sb->s_feature_incompat &
+		EXT4_FEATURE_INCOMPAT_FLEX_BG;
 	old_journal = sb->s_feature_compat &
 		EXT3_FEATURE_COMPAT_HAS_JOURNAL;
 	old_dxdir = sb->s_feature_compat &
@@ -339,6 +342,8 @@ static void update_feature_set(ext2_filsys fs, char *features)
 		EXT4_FEATURE_RO_COMPAT_DIR_NLINK;
 	filetype = sb->s_feature_incompat &
 		EXT2_FEATURE_INCOMPAT_FILETYPE;
+	flex_bg = sb->s_feature_incompat &
+		EXT4_FEATURE_INCOMPAT_FLEX_BG;
 	journal = sb->s_feature_compat &
 		EXT3_FEATURE_COMPAT_HAS_JOURNAL;
 	dxdir = sb->s_feature_compat &
@@ -407,6 +412,14 @@ static void update_feature_set(ext2_filsys fs, char *features)
 			 "update interval has been set to %d seconds.\n"),
 		       sb->s_mmp_update_interval);
 	}
+	if (!flex_bg && old_flex_bg) {
+		if (ext2fs_check_desc(fs)) {
+			fputs(_("Clearing the flex_bg flag would "
+				"cause the the filesystem to be\n"
+				"inconsistent.\n"), stderr);
+			exit(1);
+		}
+	}
 
 	if (old_mmp && !mmp) {
 		blk_t mmp_block;

--MP_/LhlpTD3ZUmf7YHdAWMDVWo7
Content-Type: text/x-patch; name=flex_bg_metadata_grouping.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=flex_bg_metadata_grouping.patch

From: Jose R. Santos <jrs@us.ibm.com>

    New bitmap and inode table allocation for FLEX_BG

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
 lib/ext2fs/closefs.c      |    5 +-
 lib/ext2fs/ext2_fs.h      |    6 ++
 lib/ext2fs/initialize.c   |    6 ++
 misc/mke2fs.8.in          |   15 ++++++
 misc/mke2fs.c             |   25 ++++++++-
 6 files changed, 170 insertions(+), 9 deletions(-)

diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
index 290e54b..bee02f3 100644
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
 	fs->group_desc[group].bg_checksum =
diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index 659ee27..86ef29a 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -100,8 +100,9 @@ int ext2fs_super_and_bgd_loc(ext2_filsys fs,
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
index 412b49b..caaeba2 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -174,6 +174,7 @@ struct ext4_group_desc
 #define EXT2_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not initialized */
 #define EXT2_BG_BLOCK_UNINIT	0x0002 /* Block bitmap not initialized */
 #define EXT2_BG_INODE_ZEROED	0x0004 /* On-disk itable initialized to zero */
+#define EXT2_BG_FLEX_METADATA	0x0008 /* FLEX_BG block group contains meta-data */
 
 /*
  * Data structures used by the directory indexing feature
@@ -598,7 +599,10 @@ struct ext2_super_block {
 	__u16	s_mmp_update_interval;	/* # seconds to wait in MMP checking */
 	__u64	s_mmp_block;		/* Block for multi-mount protection */
 	__u32	s_raid_stripe_width;	/* blocks on all data disks (N*stride)*/
-	__u32	s_reserved[163];	/* Padding to the end of the block */
+	__u8    s_log_groups_per_flex;  /* FLEX_BG group size */
+	__u8    s_reserved_char_pad;
+	__u16   s_reserved_pad;         /* Padding to next 32bits */
+	__u32	s_reserved[162];	/* Padding to the end of the block */
 };
 
 /*
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 1916655..c3939e5 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -159,6 +159,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	set_field(s_raid_stride, 0);		/* default stride size: 0 */
 	set_field(s_raid_stripe_width, 0);	/* default stripe width: 0 */
 	set_field(s_flags, 0);
+	set_field(s_log_groups_per_flex, 0);
 	if (super->s_feature_incompat & ~EXT2_LIB_FEATURE_INCOMPAT_SUPP) {
 		retval = EXT2_ET_UNSUPP_FEATURE;
 		goto cleanup;
@@ -366,7 +367,10 @@ ipg_retry:
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
index c7db240..a6bded4 100644
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
@@ -232,6 +236,12 @@ option rather than manipulating the number of blocks per group.)
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
@@ -421,6 +431,11 @@ Use hashed b-trees to speed up lookups in large directories.
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
index 0184af7..40dac03 100644
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
@@ -476,7 +476,8 @@ static void setup_lazy_bg(ext2_filsys fs)
 			 * group because it may need block bitmap padding. */
 			if ((ext2fs_bg_has_super(fs, i) &&
 			     sb->s_reserved_gdt_blocks) ||
-			    i == fs->group_desc_count - 1)
+			    i == fs->group_desc_count - 1 ||
+			    (bg->bg_flags & EXT2_BG_FLEX_METADATA))
 				continue;
 
 			blks = ext2fs_super_and_bgd_loc(fs, i, 0, 0, 0, 0);
@@ -962,6 +963,7 @@ static void PRS(int argc, char *argv[])
 	int		blocksize = 0;
 	int		inode_ratio = 0;
 	int		inode_size = 0;
+	unsigned long	flex_bg_size = 0;
 	double		reserved_ratio = 5.0;
 	int		sector_size = 0;
 	int		show_version_only = 0;
@@ -1044,7 +1046,7 @@ static void PRS(int argc, char *argv[])
 	}
 
 	while ((c = getopt (argc, argv,
-		    "b:cf:g:i:jl:m:no:qr:s:tvE:FI:J:L:M:N:O:R:ST:V")) != EOF) {
+		    "b:cf:g:G:i:jl:m:no:qr:s:tvE:FI:J:L:M:N:O:R:ST:V")) != EOF) {
 		switch (c) {
 		case 'b':
 			blocksize = strtol(optarg, &tmp, 0);
@@ -1095,6 +1097,20 @@ static void PRS(int argc, char *argv[])
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
@@ -1490,6 +1506,9 @@ static void PRS(int argc, char *argv[])
 		}
 	}
 
+	if (flex_bg_size)
+		fs_param.s_log_groups_per_flex = int_log2(flex_bg_size);
+
 	if (!force && fs_param.s_blocks_count >= ((unsigned) 1 << 31)) {
 		com_err(program_name, 0,
 			_("Filesystem too large.  No more than 2**31-1 blocks\n"

--MP_/LhlpTD3ZUmf7YHdAWMDVWo7--
