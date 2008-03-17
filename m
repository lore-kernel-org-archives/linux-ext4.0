From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH, REWORKED 02/11] Add uninit block group support to various libext2fs functions
Date: Mon, 17 Mar 2008 09:28:38 -0400
Message-ID: <1205760527-14858-3-git-send-email-tytso@mit.edu>
References: <1205760527-14858-1-git-send-email-tytso@mit.edu>
 <1205760527-14858-2-git-send-email-tytso@mit.edu>
Cc: "Jose R. Santos" <jrs@us.ibm.com>,
	Andreas Dilger <adilger@clusterfs.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:60383 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753157AbYCQN3F (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 17 Mar 2008 09:29:05 -0400
In-Reply-To: <1205760527-14858-2-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
Signed-off-by: Andreas Dilger <adilger@clusterfs.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 lib/ext2fs/Makefile.in    |   10 ++++++----
 lib/ext2fs/alloc_stats.c  |   22 ++++++++++++++++++++++
 lib/ext2fs/alloc_tables.c |    4 +---
 lib/ext2fs/ext2fs.h       |    3 ++-
 lib/ext2fs/initialize.c   |    1 +
 lib/ext2fs/inode.c        |   29 +++++++++++++++++++++++------
 lib/ext2fs/openfs.c       |   16 ++++++++++++++++
 lib/ext2fs/rw_bitmaps.c   |   12 ++++++++----
 8 files changed, 79 insertions(+), 18 deletions(-)

diff --git a/lib/ext2fs/Makefile.in b/lib/ext2fs/Makefile.in
index f0f02dc..1de037d 100644
--- a/lib/ext2fs/Makefile.in
+++ b/lib/ext2fs/Makefile.in
@@ -195,11 +195,13 @@ ext2fs.pc: $(srcdir)/ext2fs.pc.in $(top_builddir)/config.status
 	@cd $(top_builddir); CONFIG_FILES=lib/ext2fs/ext2fs.pc ./config.status
 
 tst_badblocks: tst_badblocks.o freefs.o bitmaps.o rw_bitmaps.o \
-		read_bb_file.o write_bb_file.o badblocks.o 
+		read_bb_file.o write_bb_file.o badblocks.o csum.o crc16.o \
+		closefs.o io_manager.o
 	@echo "	LD $@"
-	@$(CC) -o tst_badblocks tst_badblocks.o freefs.o \
-		read_bb_file.o write_bb_file.o badblocks.o rw_bitmaps.o \
-		inline.o bitops.o gen_bitmap.o bitmaps.o $(LIBCOM_ERR)
+	@$(CC) -o tst_badblocks tst_badblocks.o freefs.o read_bb_file.o \
+		write_bb_file.o badblocks.o rw_bitmaps.o inline.o bitops.o \
+		gen_bitmap.o bitmaps.o csum.o crc16.o closefs.o io_manager.o \
+		$(LIBCOM_ERR)
 
 tst_icount: icount.c initialize.o  $(STATIC_LIBEXT2FS)
 	@echo "	LD $@"
diff --git a/lib/ext2fs/alloc_stats.c b/lib/ext2fs/alloc_stats.c
index 4088f7b..725f28d 100644
--- a/lib/ext2fs/alloc_stats.c
+++ b/lib/ext2fs/alloc_stats.c
@@ -27,6 +27,25 @@ void ext2fs_inode_alloc_stats2(ext2_filsys fs, ext2_ino_t ino,
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
+		ext2fs_group_desc_csum_set(fs, group);
+	}
+
 	fs->super->s_free_inodes_count -= inuse;
 	ext2fs_mark_super_dirty(fs);
 	ext2fs_mark_ib_dirty(fs);
@@ -46,6 +65,9 @@ void ext2fs_block_alloc_stats(ext2_filsys fs, blk_t blk, int inuse)
 	else
 		ext2fs_unmark_block_bitmap(fs->block_map, blk);
 	fs->group_desc[group].bg_free_blocks_count -= inuse;
+	fs->group_desc[group].bg_flags &= ~EXT2_BG_BLOCK_UNINIT;
+	ext2fs_group_desc_csum_set(fs, group);
+
 	fs->super->s_free_blocks_count -= inuse;
 	ext2fs_mark_super_dirty(fs);
 	ext2fs_mark_bb_dirty(fs);
diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
index 4ad2ba9..9b4f0e5 100644
--- a/lib/ext2fs/alloc_tables.c
+++ b/lib/ext2fs/alloc_tables.c
@@ -95,13 +95,11 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 			ext2fs_mark_block_bitmap(bmap, blk);
 		fs->group_desc[group].bg_inode_table = new_blk;
 	}
+	ext2fs_group_desc_csum_set(fs, group);
 
-	
 	return 0;
 }
 
-	
-
 errcode_t ext2fs_allocate_tables(ext2_filsys fs)
 {
 	errcode_t	retval;
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index fbea854..0504a7f 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -516,7 +516,8 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG)
 #endif
 #define EXT2_LIB_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER|\
-					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE)
+					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE|\
+					 EXT4_FEATURE_RO_COMPAT_GDT_CSUM)
 
 /*
  * These features are only allowed if EXT2_FLAG_SOFTSUPP_FEATURES is passed
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 2edcd17..c2e00e8 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -377,6 +377,7 @@ ipg_retry:
 		fs->group_desc[i].bg_free_inodes_count =
 			fs->super->s_inodes_per_group;
 		fs->group_desc[i].bg_used_dirs_count = 0;
+		ext2fs_group_desc_csum_set(fs, i);
 	}
 	
 	c = (char) 255;
diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index 818abc9..b4a445d 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -167,6 +167,9 @@ errcode_t ext2fs_open_inode_scan(ext2_filsys fs, int buffer_blocks,
 	if (EXT2_HAS_COMPAT_FEATURE(fs->super, 
 				    EXT2_FEATURE_COMPAT_LAZY_BG))
 		scan->scan_flags |= EXT2_SF_DO_LAZY;
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM))
+		scan->scan_flags |= EXT2_SF_DO_LAZY;
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
index a6a8217..996fbb4 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -303,6 +303,22 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 
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
 	fs->flags &= ~EXT2_FLAG_NOFREE_ON_ERROR;
 	*ret_fs = fs;
 	return 0;
diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index 1897ec3..dd5dc46 100644
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
@@ -233,7 +235,8 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 		if (block_bitmap) {
 			blk = fs->group_desc[i].bg_block_bitmap;
 			if (lazy_flag && fs->group_desc[i].bg_flags &
-			    EXT2_BG_BLOCK_UNINIT)
+			    EXT2_BG_BLOCK_UNINIT &&
+			    ext2fs_group_desc_csum_verify(fs, i))
 				blk = 0;
 			if (blk) {
 				retval = io_channel_read_blk(fs->io, blk,
@@ -254,7 +257,8 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 		if (inode_bitmap) {
 			blk = fs->group_desc[i].bg_inode_bitmap;
 			if (lazy_flag && fs->group_desc[i].bg_flags &
-			    EXT2_BG_INODE_UNINIT)
+			    EXT2_BG_INODE_UNINIT &&
+			    ext2fs_group_desc_csum_verify(fs, i))
 				blk = 0;
 			if (blk) {
 				retval = io_channel_read_blk(fs->io, blk,
-- 
1.5.4.1.144.gdfee-dirty

