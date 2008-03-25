From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH] e2fsprogs: New bitmap and inode table allocation for
	FLEX_BG v2
Date: Tue, 25 Mar 2008 18:24:27 -0400
Message-ID: <20080325222426.GA24980@mit.edu>
References: <20080213204750.5666a560@gara> <20080324134650.GA13621@mit.edu> <20080325171202.1dce62a6@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Jose R. Santos" <jrs@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:52023 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753449AbYCYWYc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Mar 2008 18:24:32 -0400
Content-Disposition: inline
In-Reply-To: <20080325171202.1dce62a6@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 25, 2008 at 05:12:02PM -0500, Jose R. Santos wrote:
> As I started looking at implementing this, I noticed that patch in pu
> has some chunks that don't belong to the flex_bg patch.  These are the
> offending lines at the end on the commit:
> 
> +       if (!force && fs_param.s_blocks_count >= ((unsigned) 1 << 31)) {
> +               com_err(program_name, 0,
> +                       _("Filesystem too large.  No more than 2**31-1 blocks\n"
> +                         "\t (8TB using a blocksize of 4k) are currently supported."));
> +             exit(1);
> +       }
> +
> +       if ((blocksize > 4096) &&
> +           (fs_param.s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL))
> +               fprintf(stderr, _("\nWarning: some 2.4 kernels do not support "
> +                       "blocksizes greater than 4096\n\tusing ext3.  "
> +                       "Use -b 4096 if this is an issue for you.\n\n"));
> +
> 
> These line probably got damaged during one of the merges.  You probably
> want to fix this so that the changes are not lost when rebasing to a
> newer flex_bg patch.

Actually, these were supposed to be deleted, and yes, a badly done
merge put them back in.  :-)

So just yank them from your version; I already did in mine, before I
decided there was enough other stuff that needed to be changed that
I'd let you resend the patch.

							- Ted

This is what I had before I decided to stop.  This just had the rename
of the functions to remove ext2fs_, making the functions static, and
removing the mis-merged lines.

commit 73bcad3ba9350ce0fd40fd3f89ccc2ef1143a8da
Author: Jose R. Santos <jrs@us.ibm.com>
Date:   Wed Feb 13 20:47:50 2008 -0600

    mke2fs: New bitmap and inode table allocation for FLEX_BG
    
    Change the way we allocate bitmaps and inode tables if the FLEX_BG
    feature is used at mke2fs time.  It places calculates a new offset for
    bitmaps and inode table base on the number of groups that the user
    wishes to pack together using the new "-G" option.  Creating a
    filesystem with 64 block groups in a flex group can be done by:
    
    mke2fs -j -I 256 -O flex_bg -G 32 /dev/sdX
    
    Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
    Signed-off-by: Valerie Clement <valerie.clement@bull.net>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>

diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
index 9b4f0e5..2183198 100644
--- a/lib/ext2fs/alloc_tables.c
+++ b/lib/ext2fs/alloc_tables.c
@@ -27,18 +27,88 @@
 #include "ext2_fs.h"
 #include "ext2fs.h"
 
+static void bgd_set_flex_meta_flag(ext2_filsys fs, blk_t block)
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
+static blk_t flexbg_offset(ext2_filsys fs, dgrp_t group, blk_t start_blk,
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
@@ -56,6 +126,14 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 	} else
 		start_blk = group_blk;
 
+	if (flexbg_size) {
+		int prev_block = 0;
+		if (group && fs->group_desc[group-1].bg_block_bitmap)
+			prev_block = fs->group_desc[group-1].bg_block_bitmap;
+		start_blk = flexbg_offset(fs, group, prev_block, bmap, 0, rem_grps);
+		last_blk = ext2fs_group_last_block(fs, last_grp);
+	}
+
 	if (!fs->group_desc[group].bg_block_bitmap) {
 		retval = ext2fs_get_free_blocks(fs, start_blk, last_blk,
 						1, bmap, &new_blk);
@@ -66,6 +144,21 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 			return retval;
 		ext2fs_mark_block_bitmap(bmap, new_blk);
 		fs->group_desc[group].bg_block_bitmap = new_blk;
+		if (flexbg_size) {
+			dgrp_t tmp = ext2fs_group_of_blk(fs, new_blk);
+			bgd_set_flex_meta_flag(fs, new_blk);
+			fs->group_desc[tmp].bg_free_blocks_count--;
+			fs->super->s_free_blocks_count--;
+		}
+	}
+
+	if (flexbg_size) {
+		int prev_block = 0;
+		if (group && fs->group_desc[group-1].bg_inode_bitmap)
+			prev_block = fs->group_desc[group-1].bg_inode_bitmap;
+		start_blk = flexbg_offset(fs, group, prev_block, bmap,
+					  flexbg_size, rem_grps);
+		last_blk = ext2fs_group_last_block(fs, last_grp);
 	}
 
 	if (!fs->group_desc[group].bg_inode_bitmap) {
@@ -78,11 +171,27 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 			return retval;
 		ext2fs_mark_block_bitmap(bmap, new_blk);
 		fs->group_desc[group].bg_inode_bitmap = new_blk;
+		if (flexbg_size) {
+			dgrp_t tmp = ext2fs_group_of_blk(fs, new_blk);
+			bgd_set_flex_meta_flag(fs, new_blk);
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
+		group_blk = flexbg_offset(fs, group, prev_block, bmap,
+					  flexbg_size * 2, 
+					  fs->inode_blocks_per_group * rem_grps);
+		last_blk = ext2fs_group_last_block(fs, last_grp);
+	}
+
 	if (!fs->group_desc[group].bg_inode_table) {
 		retval = ext2fs_get_free_blocks(fs, group_blk, last_blk,
 						fs->inode_blocks_per_group,
@@ -91,8 +200,15 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 			return retval;
 		for (j=0, blk = new_blk;
 		     j < fs->inode_blocks_per_group;
-		     j++, blk++)
+		     j++, blk++) {
 			ext2fs_mark_block_bitmap(bmap, blk);
+			if (flexbg_size) {
+				dgrp_t tmp = ext2fs_group_of_blk(fs, blk);
+				bgd_set_flex_meta_flag(fs, blk);
+				fs->group_desc[tmp].bg_free_blocks_count--;
+				fs->super->s_free_blocks_count--;
+			}
+		}
 		fs->group_desc[group].bg_inode_table = new_blk;
 	}
 	ext2fs_group_desc_csum_set(fs, group);
diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index 086c28a..19fcb5e 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -99,8 +99,9 @@ int ext2fs_super_and_bgd_loc(ext2_filsys fs,
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
index 444211d..29a1bb5 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -174,6 +174,7 @@ struct ext4_group_desc
 #define EXT2_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not initialized */
 #define EXT2_BG_BLOCK_UNINIT	0x0002 /* Block bitmap not initialized */
 #define EXT2_BG_INODE_ZEROED	0x0004 /* On-disk itable initialized to zero */
+#define EXT2_BG_FLEX_METADATA	0x0008 /* FLEX_BG block group contains meta-data */
 
 /*
  * Data structures used by the directory indexing feature
@@ -563,7 +564,10 @@ struct ext2_super_block {
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
index c2e00e8..30cbc6c 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -158,6 +158,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	set_field(s_first_meta_bg, 0);
 	set_field(s_raid_stride, 0);		/* default stride size: 0 */
 	set_field(s_raid_stripe_width, 0);	/* default stripe width: 0 */
+	set_field(s_log_groups_per_flex, 0);
 	set_field(s_flags, 0);
 	if (super->s_feature_incompat & ~EXT2_LIB_FEATURE_INCOMPAT_SUPP) {
 		retval = EXT2_ET_UNSUPP_FEATURE;
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
index a32c34a..9cc3895 100644
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
@@ -425,6 +435,11 @@ Use hashed b-trees to speed up lookups in large directories.
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
 .TP
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 857d345..58b4579 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -97,8 +97,9 @@ static void usage(void)
 	fprintf(stderr, _("Usage: %s [-c|-l filename] [-b block-size] "
 	"[-f fragment-size]\n\t[-i bytes-per-inode] [-I inode-size] "
 	"[-J journal-options]\n"
-	"\t[-N number-of-inodes] [-m reserved-blocks-percentage] "
-	"[-o creator-os]\n\t[-g blocks-per-group] [-L volume-label] "
+	"\t[-G meta group size] [-N number-of-inodes]\n"
+	"\t[-m reserved-blocks-percentage] [-o creator-os]\n"
+	"\t[-g blocks-per-group] [-L volume-label] "
 	"[-M last-mounted-directory]\n\t[-O feature[,...]] "
 	"[-r fs-revision] [-E extended-option[,...]]\n"
 	"\t[-T fs-type] [-jnqvFSV] device [blocks-count]\n"),
@@ -480,6 +481,9 @@ static void setup_lazy_bg(ext2_filsys fs)
 			    i == fs->group_desc_count - 1)
 				continue;
 
+			if ((bg->bg_flags & EXT2_BG_FLEX_METADATA))
+				continue;
+
 			blks = ext2fs_super_and_bgd_loc(fs, i, 0, 0, 0, 0);
 			if (bg->bg_free_blocks_count == blks &&
 			    bg->bg_flags & EXT2_BG_INODE_UNINIT) {
@@ -967,6 +971,7 @@ static void PRS(int argc, char *argv[])
 	int		blocksize = 0;
 	int		inode_ratio = 0;
 	int		inode_size = 0;
+	unsigned long	flex_bg_size = 0;
 	double		reserved_ratio = 5.0;
 	int		sector_size = 0;
 	int		show_version_only = 0;
@@ -1049,7 +1054,7 @@ static void PRS(int argc, char *argv[])
 	}
 
 	while ((c = getopt (argc, argv,
-		    "b:cf:g:i:jl:m:no:qr:s:tvE:FI:J:L:M:N:O:R:ST:V")) != EOF) {
+		    "b:cf:g:G:i:jl:m:no:qr:s:tvE:FI:J:L:M:N:O:R:ST:V")) != EOF) {
 		switch (c) {
 		case 'b':
 			blocksize = strtol(optarg, &tmp, 0);
@@ -1100,6 +1105,20 @@ static void PRS(int argc, char *argv[])
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
@@ -1495,6 +1514,9 @@ static void PRS(int argc, char *argv[])
 		}
 	}
 
+	if (flex_bg_size)
+		fs_param.s_log_groups_per_flex = int_log2(flex_bg_size);
+
 	if (inode_size == 0) {
 		profile_get_integer(profile, "defaults", "inode_size", NULL,
 				    0, &inode_size);
