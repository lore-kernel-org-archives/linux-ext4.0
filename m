From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 02/13][e2fsprogs] Add uninit block group support on libe2fs.
Date: Thu, 11 Oct 2007 14:16:11 -0500
Message-ID: <20071011191611.4599.58257.stgit@gara>
References: <20071011191559.4599.69332.stgit@gara>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:60611 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908AbXJKTQC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Oct 2007 15:16:02 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9BJG1lY029060
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 15:16:01 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9BJFwvw424152
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 13:16:01 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9BJFw3o016291
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 13:15:58 -0600
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l9BJFvdC016274
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 13:15:58 -0600
Received: from [127.0.1.1] (wecm-9-67-39-149.wecm.ibm.com [9.67.39.149])
	by austin.ibm.com (8.13.8/8.12.10) with ESMTP id l9BJFvbQ040720
	for <linux-ext4@vger.kernel.org>; Thu, 11 Oct 2007 14:15:57 -0500
In-Reply-To: <20071011191559.4599.69332.stgit@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Jose R. Santos <jrs@us.ibm.com>

Add uninit block group support on libe2fs.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 lib/ext2fs/alloc_stats.c  |   25 +++++++++++++++++++++++++
 lib/ext2fs/alloc_tables.c |    5 ++---
 lib/ext2fs/ext2_fs.h      |    1 +
 lib/ext2fs/ext2fs.h       |    4 +++-
 lib/ext2fs/initialize.c   |    2 ++
 lib/ext2fs/inode.c        |   29 +++++++++++++++++++++++------
 lib/ext2fs/openfs.c       |   16 ++++++++++++++++
 lib/ext2fs/rw_bitmaps.c   |   14 ++++++++++----
 8 files changed, 82 insertions(+), 14 deletions(-)

diff --git a/lib/ext2fs/alloc_stats.c b/lib/ext2fs/alloc_stats.c
index 4088f7b..ee4a1e4 100644
--- a/lib/ext2fs/alloc_stats.c
+++ b/lib/ext2fs/alloc_stats.c
@@ -27,6 +27,27 @@ void ext2fs_inode_alloc_stats2(ext2_filsys fs, ext2_ino_t ino,
 	fs->group_desc[group].bg_free_inodes_count -= inuse;
 	if (isdir)
 		fs->group_desc[group].bg_used_dirs_count += inuse;
+
+	/* We don't strictly need to be clearing these if inuse < 0
+	 * (i.e. freeing inodes) but it also means something is bad. */
+	fs->group_desc[group].bg_flags &= ~(EXT2_BG_INODE_UNINIT |
+					    EXT2_BG_BLOCK_UNINIT);
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
+		ext2_ino_t first_unused_inode =	fs->super->s_inodes_per_group -
+			fs->group_desc[group].bg_itable_unused +
+			group * fs->super->s_inodes_per_group + 1;
+
+		if (ino >= first_unused_inode)
+			fs->group_desc[group].bg_itable_unused =
+				group * fs->super->s_inodes_per_group +
+				fs->super->s_inodes_per_group - ino;
+
+		fs->group_desc[group].bg_checksum =
+			ext2fs_group_desc_csum(fs->super, group,
+					       &fs->group_desc[group]);
+	}
+
 	fs->super->s_free_inodes_count -= inuse;
 	ext2fs_mark_super_dirty(fs);
 	ext2fs_mark_ib_dirty(fs);
@@ -46,6 +67,10 @@ void ext2fs_block_alloc_stats(ext2_filsys fs, blk_t blk, int inuse)
 	else
 		ext2fs_unmark_block_bitmap(fs->block_map, blk);
 	fs->group_desc[group].bg_free_blocks_count -= inuse;
+	fs->group_desc[group].bg_flags &= ~EXT2_BG_BLOCK_UNINIT;
+	fs->group_desc[group].bg_checksum =
+		ext2fs_group_desc_csum(fs->super, group,&fs->group_desc[group]);
+
 	fs->super->s_free_blocks_count -= inuse;
 	ext2fs_mark_super_dirty(fs);
 	ext2fs_mark_bb_dirty(fs);
diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
index 4ad2ba9..290e54b 100644
--- a/lib/ext2fs/alloc_tables.c
+++ b/lib/ext2fs/alloc_tables.c
@@ -95,13 +95,12 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 			ext2fs_mark_block_bitmap(bmap, blk);
 		fs->group_desc[group].bg_inode_table = new_blk;
 	}
+	fs->group_desc[group].bg_checksum =
+		ext2fs_group_desc_csum(fs->super, group,&fs->group_desc[group]);
 
-	
 	return 0;
 }
 
-	
-
 errcode_t ext2fs_allocate_tables(ext2_filsys fs)
 {
 	errcode_t	retval;
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index a316665..7b63828 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -173,6 +173,7 @@ struct ext4_group_desc
 
 #define EXT2_BG_INODE_UNINIT	0x0001 /* Inode table/bitmap not initialized */
 #define EXT2_BG_BLOCK_UNINIT	0x0002 /* Block bitmap not initialized */
+#define EXT2_BG_INODE_ZEROED	0x0004 /* On-disk itable initialized to zero */
 
 /*
  * Data structures used by the directory indexing feature
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 1267ee8..c47536b 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -321,6 +321,7 @@ typedef struct ext2_struct_inode_scan *ext2_inode_scan;
 #define EXT2_SF_BAD_EXTRA_BYTES	0x0004
 #define EXT2_SF_SKIP_MISSING_ITABLE	0x0008
 #define EXT2_SF_DO_LAZY		0x0010
+#define EXT2_SF_DO_CSUM		0x0020
 
 /*
  * ext2fs_check_if_mounted flags
@@ -440,7 +441,8 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT3_FEATURE_INCOMPAT_RECOVER)
 #endif
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
-					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE)
+					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE|\
+					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM)
 
 /*
  * These features are only allowed if EXT2_FLAG_SOFTSUPP_FEATURES is passed
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 16e9eaa..5710f04 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -374,6 +374,8 @@ ipg_retry:
 		fs->group_desc[i].bg_free_inodes_count =
 			fs->super->s_inodes_per_group;
 		fs->group_desc[i].bg_used_dirs_count = 0;
+		fs->group_desc[i].bg_checksum =
+			ext2fs_group_desc_csum(fs->super, i,&fs->group_desc[i]);
 	}
 	
 	c = (char) 255;
diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index 6f24b61..6a55c01 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -167,6 +167,9 @@ errcode_t ext2fs_open_inode_scan(ext2_filsys fs, int buffer_blocks,
 	if (EXT2_HAS_COMPAT_FEATURE(fs->super, 
 				    EXT2_FEATURE_COMPAT_LAZY_BG))
 		scan->scan_flags |= EXT2_SF_DO_LAZY;
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
+		scan->scan_flags |= EXT2_SF_DO_LAZY | EXT2_SF_DO_CSUM;
 	*ret_scan = scan;
 	return 0;
 }
@@ -218,18 +221,30 @@ int ext2fs_inode_scan_flags(ext2_inode_scan scan, int set_flags,
  */
 static errcode_t get_next_blockgroup(ext2_inode_scan scan)
 {
+	ext2_filsys fs = scan->fs;
+
 	scan->current_group++;
 	scan->groups_left--;
-			
-	scan->current_block = scan->fs->
-		group_desc[scan->current_group].bg_inode_table;
+
+	scan->current_block =fs->group_desc[scan->current_group].bg_inode_table;
 
 	scan->current_inode = scan->current_group *
-		EXT2_INODES_PER_GROUP(scan->fs->super);
+		EXT2_INODES_PER_GROUP(fs->super);
 
 	scan->bytes_left = 0;
-	scan->inodes_left = EXT2_INODES_PER_GROUP(scan->fs->super);
-	scan->blocks_left = scan->fs->inode_blocks_per_group;
+	scan->inodes_left = EXT2_INODES_PER_GROUP(fs->super);
+	scan->blocks_left = fs->inode_blocks_per_group;
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
+		scan->inodes_left -=
+			fs->group_desc[scan->current_group].bg_itable_unused;
+		scan->blocks_left =
+			(EXT2_INODES_PER_GROUP(fs->super) -
+			 fs->group_desc[scan->current_group].bg_itable_unused +
+			 fs->blocksize / scan->inode_size - 1) *
+			scan->inode_size / fs->blocksize;
+	}
+
 	return 0;
 }
 
@@ -417,6 +432,8 @@ errcode_t ext2fs_get_next_inode_full(ext2_inode_scan scan, ext2_ino_t *ino,
 	    (scan->fs->group_desc[scan->current_group].bg_flags &
 	     EXT2_BG_INODE_UNINIT))
 		goto force_new_group;
+	if (scan->inodes_left == 0)
+		goto force_new_group;
 	if (scan->current_block == 0) {
 		if (scan->scan_flags & EXT2_SF_SKIP_MISSING_ITABLE) {
 			goto force_new_group;
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 35bd44b..bb1edc8 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -304,6 +304,22 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 
 	fs->stride = fs->super->s_raid_stride;
 
+	/*
+	 * If recovery is from backup superblock, Clear _UNININT flags &
+	 * reset bg_itable_unused to zero
+	 */
+	if (superblock > 1 && EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+					EXT4_FEATURE_RO_COMPAT_GDT_CSUM)) {
+		struct ext2_group_desc *gd;
+		for (i = 0, gd = fs->group_desc; i < fs->group_desc_count;
+		     i++, gd++) {
+			gd->bg_flags &= ~EXT2_BG_BLOCK_UNINIT;
+			gd->bg_flags &= ~EXT2_BG_INODE_UNINIT;
+			gd->bg_itable_unused = 0;
+		}
+		ext2fs_mark_super_dirty(fs);
+	}
+
 	*ret_fs = fs;
 	return 0;
 cleanup:
diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index 1897ec3..8617846 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -152,8 +152,10 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 
 	fs->write_bitmaps = ext2fs_write_bitmaps;
 
-	if (EXT2_HAS_COMPAT_FEATURE(fs->super, 
-				    EXT2_FEATURE_COMPAT_LAZY_BG))
+	if (EXT2_HAS_COMPAT_FEATURE(fs->super,
+				    EXT2_FEATURE_COMPAT_LAZY_BG) ||
+	    EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
 		lazy_flag = 1;
 
 	retval = ext2fs_get_mem(strlen(fs->device_name) + 80, &buf);
@@ -233,7 +235,9 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 		if (block_bitmap) {
 			blk = fs->group_desc[i].bg_block_bitmap;
 			if (lazy_flag && fs->group_desc[i].bg_flags &
-			    EXT2_BG_BLOCK_UNINIT)
+			    EXT2_BG_BLOCK_UNINIT &&
+			    ext2fs_group_desc_csum_verify(fs->super, i,
+							  &fs->group_desc[i]))
 				blk = 0;
 			if (blk) {
 				retval = io_channel_read_blk(fs->io, blk,
@@ -254,7 +258,9 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 		if (inode_bitmap) {
 			blk = fs->group_desc[i].bg_inode_bitmap;
 			if (lazy_flag && fs->group_desc[i].bg_flags &
-			    EXT2_BG_INODE_UNINIT)
+			    EXT2_BG_INODE_UNINIT &&
+			    ext2fs_group_desc_csum_verify(fs->super, i,
+							  &fs->group_desc[i]))
 				blk = 0;
 			if (blk) {
 				retval = io_channel_read_blk(fs->io, blk,
