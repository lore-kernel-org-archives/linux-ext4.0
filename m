From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH] e2fsprogs: New bitmap and inode table allocation for
 FLEX_BG
Date: Fri, 11 Jan 2008 11:28:06 -0600
Message-ID: <20080111112806.1bbd9f38@gara>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39749 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760404AbYAKR2M (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Jan 2008 12:28:12 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m0BHTxGJ026727
	for <linux-ext4@vger.kernel.org>; Fri, 11 Jan 2008 12:29:59 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m0BHS9vr092976
	for <linux-ext4@vger.kernel.org>; Fri, 11 Jan 2008 12:28:09 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m0BHS9DT023037
	for <linux-ext4@vger.kernel.org>; Fri, 11 Jan 2008 12:28:09 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

commit 38a4134f29b06229843bfe838c23e28f8d323b86
Author: Jose R. Santos <jrs@us.ibm.com>
Date:   Fri Jan 11 11:03:03 2008 -0600

    New bitmap and inode table allocation for FLEX_BG
    
    Change the way we allocate bitmaps and inode tables if the FLEX_BG
    feature is used at mke2fs time.  It places calculates a new offset for
    bitmaps and inode table base on the number of groups that the user
    wishes to pack together using the new "-G" option.  Creating a
    filesystem with 64 block groups in a flex group can be done by:
    
    mke2fs -j -I 256 -O flex_bg -G 32 /dev/sdX
    
    Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
    Singed-off-by: Valerie Clement <valerie.clement@bull.net>

diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
index 4ad2ba9..f85ef97 100644
--- a/lib/ext2fs/alloc_tables.c
+++ b/lib/ext2fs/alloc_tables.c
@@ -27,18 +27,55 @@
 #include "ext2_fs.h"
 #include "ext2fs.h"
 
+blk_t ext2fs_flexbg_offset(ext2_filsys fs, dgrp_t group, int flexbg_size, 
+			   ext2fs_block_bitmap bmap, int offset, int size)
+{
+	int		flexbg;
+	errcode_t	retval;
+	blk_t		start_blk, last_blk, first_free = 0;
+	dgrp_t	       	last_grp;
+	
+	flexbg = group / flexbg_size;
+
+	last_grp = (group + (flexbg_size - (group % flexbg_size) - 1));
+	start_blk = ext2fs_group_first_block(fs, flexbg_size * flexbg);
+	last_blk = ext2fs_group_last_block(fs, last_grp);
+	if (last_grp > fs->group_desc_count)
+		last_grp = fs->group_desc_count;
+
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
+	if (EXT2_HAS_INCOMPAT_FEATURE (fs->super,
+				       EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
+		flexbg_size = 1 << fs->super->s_log_groups_per_flex;
+		rem_grps = flexbg_size - (group % flexbg_size);
+		last_grp = group + rem_grps - 1;
+		if (last_grp > fs->group_desc_count)
+			last_grp = fs->group_desc_count;
+	}
 	
 	/*
 	 * Allocate the block and inode bitmaps, if necessary
@@ -56,6 +93,12 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 	} else
 		start_blk = group_blk;
 
+	if (flexbg_size) {
+		start_blk = ext2fs_flexbg_offset (fs, group, flexbg_size, bmap,
+						  0, rem_grps);
+		last_blk = ext2fs_group_last_block(fs, last_grp);
+	}
+
 	if (!fs->group_desc[group].bg_block_bitmap) {
 		retval = ext2fs_get_free_blocks(fs, start_blk, last_blk,
 						1, bmap, &new_blk);
@@ -68,6 +111,12 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 		fs->group_desc[group].bg_block_bitmap = new_blk;
 	}
 
+	if (flexbg_size) {
+		start_blk = ext2fs_flexbg_offset (fs, group, flexbg_size, bmap,
+						  flexbg_size, rem_grps);
+		last_blk = ext2fs_group_last_block(fs, last_grp);
+	}
+
 	if (!fs->group_desc[group].bg_inode_bitmap) {
 		retval = ext2fs_get_free_blocks(fs, start_blk, last_blk,
 						1, bmap, &new_blk);
@@ -83,6 +132,13 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 	/*
 	 * Allocate the inode table
 	 */
+	if (flexbg_size) {
+		group_blk = ext2fs_flexbg_offset (fs, group, flexbg_size, bmap,
+						  flexbg_size * 2,
+						  fs->inode_blocks_per_group * rem_grps);
+		last_blk = ext2fs_group_last_block(fs, last_grp);
+	}
+
 	if (!fs->group_desc[group].bg_inode_table) {
 		retval = ext2fs_get_free_blocks(fs, group_blk, last_blk,
 						fs->inode_blocks_per_group,
@@ -112,6 +168,7 @@ errcode_t ext2fs_allocate_tables(ext2_filsys fs)
 		if (retval)
 			return retval;
 	}
+
 	return 0;
 }
 
diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index c570256..949c657 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -56,6 +56,7 @@ int ext2fs_super_and_bgd_loc(ext2_filsys fs,
 	unsigned int meta_bg, meta_bg_size;
 	int	numblocks, has_super;
 	int	old_desc_blocks;
+	unsigned int flex_bg_size = 1 << fs->super->s_log_groups_per_flex;
 
 	group_block = fs->super->s_first_data_block +
 		(group * fs->super->s_blocks_per_group);
@@ -101,7 +102,11 @@ int ext2fs_super_and_bgd_loc(ext2_filsys fs,
 		}
 	}
 		
-	numblocks -= 2 + fs->inode_blocks_per_group;
+	if (flex_bg_size) {
+		if ((group % flex_bg_size) == 0)
+			numblocks -= 2 + fs->inode_blocks_per_group;
+	} else
+		numblocks -= 2 + fs->inode_blocks_per_group;
 
 	if (ret_super_blk)
 		*ret_super_blk = super_blk;
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 2394857..bcb88ff 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -577,7 +577,10 @@ struct ext2_super_block {
 	__u16   s_mmp_interval;         /* # seconds to wait in MMP checking */
 	__u64   s_mmp_block;            /* Block for multi-mount protection */
 	__u32   s_raid_stripe_width;    /* blocks on all data disks (N*stride)*/
-	__u32   s_reserved[163];        /* Padding to the end of the block */
+	__u8	s_log_groups_per_flex;	/* FLEX_BG group size */
+	__u8    s_reserved_char_pad;
+	__u16	s_reserved_padg;	/* Padding to next 32bits */
+	__u32   s_reserved[162];        /* Padding to the end of the block */
 };
 
 /*
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 5c461c9..350e322 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -65,6 +65,7 @@ extern "C" {
 
 typedef __u32		ext2_ino_t;
 typedef __u32		blk_t;
+typedef __u64		blk64_t;
 typedef __u32		dgrp_t;
 typedef __u32		ext2_off_t;
 typedef __s64		e2_blkcnt_t;
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 16e9eaa..2efdfeb 100644
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
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 9e2d7a8..504f73b 100644
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
@@ -912,6 +912,7 @@ static void PRS(int argc, char *argv[])
 	int		blocksize = 0;
 	int		inode_ratio = 0;
 	int		inode_size = 0;
+	unsigned long	flex_bg_size = 0;
 	double		reserved_ratio = 5.0;
 	int		sector_size = 0;
 	int		show_version_only = 0;
@@ -994,7 +995,7 @@ static void PRS(int argc, char *argv[])
 	}
 
 	while ((c = getopt (argc, argv,
-		    "b:cf:g:i:jl:m:no:qr:s:tvE:FI:J:L:M:N:O:R:ST:V")) != EOF) {
+		    "b:cf:g:G:i:jl:m:no:qr:s:tvE:FI:J:L:M:N:O:R:ST:V")) != EOF) {
 		switch (c) {
 		case 'b':
 			blocksize = strtol(optarg, &tmp, 0);
@@ -1045,6 +1046,20 @@ static void PRS(int argc, char *argv[])
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
@@ -1444,6 +1459,16 @@ static void PRS(int argc, char *argv[])
 		}
 	}
 
+	if(flex_bg_size) {
+		unsigned int tmp, shift;
+		shift = 0;
+		tmp = flex_bg_size;
+		while ((tmp >>= 1UL) != 0UL)
+			shift++;
+
+		fs_param.s_log_groups_per_flex = tmp;
+	}
+
 	if (!force && fs_param.s_blocks_count >= ((unsigned) 1 << 31)) {
 		com_err(program_name, 0,
 			_("Filesystem too large.  No more than 2**31-1 blocks\n"
