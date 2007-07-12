From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: Initial results of FLEX_BG feature.
Date: Thu, 12 Jul 2007 10:02:03 -0500
Message-ID: <20070712100203.7f9dbe44@gara>
References: <20070710112307.34c2ba5c@rx8>
 <20070711041213.GH6417@schatzie.adilger.int>
 <20070711003004.531c9307@naruto>
 <20070711221425.GH19456@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:49702 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503AbXGLPDn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jul 2007 11:03:43 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6CF3gQx004928
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jul 2007 11:03:42 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l6CF3fCX168782
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jul 2007 09:03:41 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6CF3fRv029214
	for <linux-ext4@vger.kernel.org>; Thu, 12 Jul 2007 09:03:41 -0600
In-Reply-To: <20070711221425.GH19456@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 11 Jul 2007 18:14:25 -0400
Theodore Tso <tytso@mit.edu> wrote:
> On Wed, Jul 11, 2007 at 12:30:04AM -0500, Jose R. Santos wrote:
> > Right now what I've done is allocate the bitmaps and inode tables at the
> > beginning of each group of 64 BG.  Still need to work on fsck since just
> > removing the restriction on were the bitmaps and inode table are
> > located still gives me errors of uninitialized inodes with dtime set.
> > Seems like fsck still expect inode information to be located at
> > specific locations within the disk.
> 
> Can you send me the patch which you were playing with?  I might be
> able to help you with this.  It should be pretty straightforward to
> remove the constraint on the inode table location.  
> 
> It really should only be a check in e2fsck/super.c:check_super_block(),
> as far as I know.
> 
> If you're seeing errors of unitialized inodes with dtime set, that
> sounds like maybe something else is going on.  All of e2fsprogs should
> be referencing the inode table via fs->group_desc[group_num].bg_inode_table.  
> See lib/ext2fs/inode.c, functions ext2fs_open_inode_scan(), 
> get_next_blockgroup(), and ext2fs_read_inode_full().
> 
> 							- Ted

Here is a very rough patch of the FLEX_BG feature implementation.
Still works as a prototype but there are a couple of thing that are
either broken or hard coded.  As it currently stands, it can not be use
to create filesystem without the FLEX_BG features as I have not made
ext2fs_allocate_tables() backward compatible.

The number of groups per flex group is also hard coded to 64.  Still
thinking on whether I should add this to the super block it self in
order to help recovery of the filesystem as well as possibly making
allocation algorithms in the kernel aware of the new groups
arrangements.

I create a filesystem using the following command:

mke2fs -j -O meta_bg,flex_bg  /dev/sdh

While meta_bg is not required, having block group descriptors spread
across the multiple block groups does increase the chances of
fragmenting the meta data.

-JRS

diff -Naurp e2fsprogs-1.40/e2fsck/super.c /home/jsantos/e2fsprogs-1.40-flex/e2fsck/super.c
--- e2fsprogs-1.40/e2fsck/super.c	2007-06-03 23:48:01.000000000 -0500
+++ /home/jsantos/e2fsprogs-1.40-flex/e2fsck/super.c	2007-07-09 11:27:56.000000000 -0500
@@ -580,27 +580,31 @@ void check_super_block(e2fsck_t ctx)
 
 		first_block = ext2fs_group_first_block(fs, i);
 		last_block = ext2fs_group_last_block(fs, i);
-
+/*
 		if ((gd->bg_block_bitmap < first_block) ||
 		    (gd->bg_block_bitmap > last_block)) {
 			pctx.blk = gd->bg_block_bitmap;
 			if (fix_problem(ctx, PR_0_BB_NOT_GROUP, &pctx))
 				gd->bg_block_bitmap = 0;
 		}
+*/
 		if (gd->bg_block_bitmap == 0) {
 			ctx->invalid_block_bitmap_flag[i]++;
 			ctx->invalid_bitmaps++;
 		}
+/*
 		if ((gd->bg_inode_bitmap < first_block) ||
 		    (gd->bg_inode_bitmap > last_block)) {
 			pctx.blk = gd->bg_inode_bitmap;
 			if (fix_problem(ctx, PR_0_IB_NOT_GROUP, &pctx))
 				gd->bg_inode_bitmap = 0;
 		}
+*/
 		if (gd->bg_inode_bitmap == 0) {
 			ctx->invalid_inode_bitmap_flag[i]++;
 			ctx->invalid_bitmaps++;
 		}
+/*
 		if ((gd->bg_inode_table < first_block) ||
 		    ((gd->bg_inode_table +
 		      fs->inode_blocks_per_group - 1) > last_block)) {
@@ -608,6 +612,7 @@ void check_super_block(e2fsck_t ctx)
 			if (fix_problem(ctx, PR_0_ITABLE_NOT_GROUP, &pctx))
 				gd->bg_inode_table = 0;
 		}
+*/
 		if (gd->bg_inode_table == 0) {
 			ctx->invalid_inode_table_flag[i]++;
 			ctx->invalid_bitmaps++;
diff -Naurp e2fsprogs-1.40/lib/e2p/feature.c /home/jsantos/e2fsprogs-1.40-flex/lib/e2p/feature.c
--- e2fsprogs-1.40/lib/e2p/feature.c	2007-03-21 15:46:10.000000000 -0500
+++ /home/jsantos/e2fsprogs-1.40-flex/lib/e2p/feature.c	2007-07-10 15:21:25.000000000 -0500
@@ -67,6 +67,8 @@ static struct feature feature_list[] = {
 			"extent" },
 	{	E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_64BIT,
 			"64bit" },
+	{	E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_FLEX_BG,
+		"flex_bg"},
 	{	0, 0, 0 },
 };
 
diff -Naurp e2fsprogs-1.40/lib/ext2fs/alloc_tables.c /home/jsantos/e2fsprogs-1.40-flex/lib/ext2fs/alloc_tables.c
--- e2fsprogs-1.40/lib/ext2fs/alloc_tables.c	2006-09-12 13:56:16.000000000 -0500
+++ /home/jsantos/e2fsprogs-1.40-flex/lib/ext2fs/alloc_tables.c	2007-07-12 09:34:38.988302340 -0500
@@ -102,16 +102,91 @@ errcode_t ext2fs_allocate_group_table(ex
 
 	
 
+errcode_t ext2fs_allocate_contiguous(ext2_filsys fs, dgrp_t group,
+				     int type, blk_t start_blk, blk_t last_blk, 
+				     int count, ext2fs_block_bitmap bmap)
+{
+	errcode_t	retval;
+	blk_t		new_blk, blk;
+	int		j,i, start_group;
+
+	if (!bmap)
+		bmap = fs->block_map;
+
+	switch (type) {
+	case 1:
+		if (!fs->group_desc[group].bg_block_bitmap){
+			retval = ext2fs_get_free_blocks(fs, start_blk, last_blk,
+							1 * count, bmap, &new_blk);
+			if (retval)
+				return retval;
+			for (i=0, blk= new_blk; i < count; i++, blk++){
+				ext2fs_mark_block_bitmap(bmap, blk);
+				fs->group_desc[group+i].bg_block_bitmap = blk;
+			}
+		}
+		break;
+	case 2:
+		if (!fs->group_desc[group].bg_inode_bitmap) {
+			retval = ext2fs_get_free_blocks(fs, start_blk, last_blk,
+							1 * count, bmap, &new_blk);
+			if (retval)
+				return retval;
+			for (i=0, blk= new_blk; i < count; i++, blk++){
+				ext2fs_mark_block_bitmap(bmap, blk);
+				fs->group_desc[group+i].bg_inode_bitmap = blk;
+			}
+		}	
+		break;
+	case 3:
+		for (i=0, blk=new_blk; i < count; i++, blk++){
+			if (!fs->group_desc[group+i].bg_inode_table) {
+				retval = ext2fs_get_free_blocks(fs, start_blk, last_blk,
+								fs->inode_blocks_per_group,
+								bmap, &new_blk);
+				if (retval)
+					return retval;
+				for (j=0, blk = new_blk;
+				     j < fs->inode_blocks_per_group;
+				     j++, blk++)
+					ext2fs_mark_block_bitmap(bmap, blk);
+				fs->group_desc[group+i].bg_inode_table = blk;
+			}
+		}
+		break;
+	}
+	return 0;
+}
+
 errcode_t ext2fs_allocate_tables(ext2_filsys fs)
 {
+
 	errcode_t	retval;
+	blk_t		start, last;
 	dgrp_t		i;
+	int		gpm;
 
-	for (i = 0; i < fs->group_desc_count; i++) {
-		retval = ext2fs_allocate_group_table(fs, i, fs->block_map);
+	gpm = 64;
+
+	for (i = 0; i < fs->group_desc_count; i=i+gpm) {
+		start = ext2fs_group_first_block(fs, i);
+		last = ext2fs_group_last_block(fs, i+gpm-1);
+
+		retval = ext2fs_allocate_contiguous(fs, i, 1,
+						    start, last, gpm,
+						    fs->block_map);
 		if (retval)
 			return retval;
+		retval = ext2fs_allocate_contiguous(fs, i, 2,
+						    start, last, gpm,
+						    fs->block_map);
+		if (retval)
+			return retval;
+		retval = ext2fs_allocate_contiguous(fs, i, 3,
+						    start, last, gpm,
+						    fs->block_map);
+		if (retval)
+			return retval;
+
 	}
-	return 0;
 }
-
diff -Naurp e2fsprogs-1.40/lib/ext2fs/ext2_fs.h /home/jsantos/e2fsprogs-1.40-flex/lib/ext2fs/ext2_fs.h
--- e2fsprogs-1.40/lib/ext2fs/ext2_fs.h	2007-05-31 11:27:31.000000000 -0500
+++ /home/jsantos/e2fsprogs-1.40-flex/lib/ext2fs/ext2_fs.h	2007-07-10 15:23:48.000000000 -0500
@@ -640,6 +640,7 @@ struct ext2_super_block {
 #define EXT3_FEATURE_INCOMPAT_EXTENTS		0x0040
 #define EXT4_FEATURE_INCOMPAT_64BIT		0x0080
 #define EXT4_FEATURE_INCOMPAT_MMP		0x0100
+#define EXT4_FEATURE_INCOMPAT_FLEX_BG		0x0200
 
 
 #define EXT2_FEATURE_COMPAT_SUPP	0
diff -Naurp e2fsprogs-1.40/lib/ext2fs/ext2fs.h /home/jsantos/e2fsprogs-1.40-flex/lib/ext2fs/ext2fs.h
--- e2fsprogs-1.40/lib/ext2fs/ext2fs.h	2007-06-21 10:59:05.000000000 -0500
+++ /home/jsantos/e2fsprogs-1.40-flex/lib/ext2fs/ext2fs.h	2007-07-12 09:31:22.628464371 -0500
@@ -452,12 +452,14 @@ typedef struct ext2_icount *ext2_icount_
 					 EXT2_FEATURE_INCOMPAT_COMPRESSION|\
 					 EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|\
 					 EXT2_FEATURE_INCOMPAT_META_BG|\
-					 EXT3_FEATURE_INCOMPAT_RECOVER)
+					 EXT3_FEATURE_INCOMPAT_RECOVER|\
+					 EXT4_FEATURE_INCOMPAT_FLEX_BG)
 #else
 #define EXT2_LIB_FEATURE_INCOMPAT_SUPP	(EXT2_FEATURE_INCOMPAT_FILETYPE|\
 					 EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|\
 					 EXT2_FEATURE_INCOMPAT_META_BG|\
-					 EXT3_FEATURE_INCOMPAT_RECOVER)
+					 EXT3_FEATURE_INCOMPAT_RECOVER|\
+					 EXT4_FEATURE_INCOMPAT_FLEX_BG)
 #endif
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE)
diff -Naurp e2fsprogs-1.40/misc/mke2fs.c /home/jsantos/e2fsprogs-1.40-flex/misc/mke2fs.c
--- e2fsprogs-1.40/misc/mke2fs.c	2007-05-31 10:28:23.000000000 -0500
+++ /home/jsantos/e2fsprogs-1.40-flex/misc/mke2fs.c	2007-07-12 09:32:27.210692448 -0500
@@ -873,7 +873,8 @@ static __u32 ok_features[3] = {
 		EXT2_FEATURE_COMPAT_LAZY_BG,	/* Compat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE|		/* Incompat */
 		EXT3_FEATURE_INCOMPAT_JOURNAL_DEV|
-		EXT2_FEATURE_INCOMPAT_META_BG,
+		EXT2_FEATURE_INCOMPAT_META_BG|
+		EXT4_FEATURE_INCOMPAT_FLEX_BG,
 	EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER	/* R/O compat */
 };
 
