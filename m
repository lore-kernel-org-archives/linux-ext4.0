From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 03/12] libext2fs: clean up feature test macros with
 predicate functions
Date: Mon, 12 Oct 2015 14:56:48 -0700
Message-ID: <20151012215648.29065.58433.stgit@birch.djwong.org>
References: <20151012215629.29065.24418.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44522 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbbJLV4w (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Oct 2015 17:56:52 -0400
In-Reply-To: <20151012215629.29065.24418.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Create separate predicate functions to test/set/clear feature flags,
thereby replacing the wordy old macros.  Furthermore, clean out the
places where we open-coded feature tests.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 lib/e2p/ls.c              |   18 +++++----
 lib/ext2fs/alloc_sb.c     |    2 +
 lib/ext2fs/alloc_tables.c |    3 +-
 lib/ext2fs/blknum.c       |   63 +++++++++++++-------------------
 lib/ext2fs/bmap.c         |    6 +--
 lib/ext2fs/check_desc.c   |    3 +-
 lib/ext2fs/closefs.c      |   16 ++++----
 lib/ext2fs/csum.c         |   48 ++++++++----------------
 lib/ext2fs/dir_iterate.c  |    3 +-
 lib/ext2fs/ext2_fs.h      |   89 +++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/ext2fs.h       |   11 ++----
 lib/ext2fs/ext_attr.c     |    6 +--
 lib/ext2fs/i_block.c      |   19 ++++------
 lib/ext2fs/initialize.c   |   17 ++++-----
 lib/ext2fs/inline_data.c  |   11 ++----
 lib/ext2fs/kernel-jbd.h   |   78 +++++++++++++++++++++++++++++++++++----
 lib/ext2fs/link.c         |    5 +--
 lib/ext2fs/mkdir.c        |    9 ++---
 lib/ext2fs/mkjournal.c    |    9 ++---
 lib/ext2fs/mmp.c          |    8 ++--
 lib/ext2fs/newdir.c       |    6 +--
 lib/ext2fs/openfs.c       |   20 ++++------
 lib/ext2fs/read_bb.c      |    3 +-
 lib/ext2fs/res_gdt.c      |    5 +--
 lib/ext2fs/symlink.c      |    6 +--
 lib/support/quotaio.c     |    3 +-
 26 files changed, 278 insertions(+), 189 deletions(-)


diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
index 2e98c14..6c82857 100644
--- a/lib/e2p/ls.c
+++ b/lib/e2p/ls.c
@@ -170,21 +170,21 @@ static void print_super_flags(struct ext2_super_block * s, FILE *f)
 static __u64 e2p_blocks_count(struct ext2_super_block *super)
 {
 	return super->s_blocks_count |
-		(super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT ?
+		(ext2fs_has_feature_64bit(super) ?
 		(__u64) super->s_blocks_count_hi << 32 : 0);
 }
 
 static __u64 e2p_r_blocks_count(struct ext2_super_block *super)
 {
 	return super->s_r_blocks_count |
-		(super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT ?
+		(ext2fs_has_feature_64bit(super) ?
 		(__u64) super->s_r_blocks_count_hi << 32 : 0);
 }
 
 static __u64 e2p_free_blocks_count(struct ext2_super_block *super)
 {
 	return super->s_free_blocks_count |
-		(super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT ?
+		(ext2fs_has_feature_64bit(super) ?
 		(__u64) super->s_free_blocks_hi << 32 : 0);
 }
 
@@ -263,19 +263,19 @@ void list_super2(struct ext2_super_block * sb, FILE *f)
 	fprintf(f, "Free inodes:              %u\n", sb->s_free_inodes_count);
 	fprintf(f, "First block:              %u\n", sb->s_first_data_block);
 	fprintf(f, "Block size:               %u\n", EXT2_BLOCK_SIZE(sb));
-	if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_BIGALLOC)
+	if (ext2fs_has_feature_bigalloc(sb))
 		fprintf(f, "Cluster size:             %u\n",
 			EXT2_CLUSTER_SIZE(sb));
 	else
 		fprintf(f, "Fragment size:            %u\n",
 			EXT2_CLUSTER_SIZE(sb));
-	if (sb->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+	if (ext2fs_has_feature_64bit(sb))
 		fprintf(f, "Group descriptor size:    %u\n", sb->s_desc_size);
 	if (sb->s_reserved_gdt_blocks)
 		fprintf(f, "Reserved GDT blocks:      %u\n",
 			sb->s_reserved_gdt_blocks);
 	fprintf(f, "Blocks per group:         %u\n", sb->s_blocks_per_group);
-	if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_BIGALLOC)
+	if (ext2fs_has_feature_bigalloc(sb))
 		fprintf(f, "Clusters per group:       %u\n",
 			sb->s_clusters_per_group);
 	else
@@ -361,7 +361,7 @@ void list_super2(struct ext2_super_block * sb, FILE *f)
 	if (sb->s_last_orphan)
 		fprintf(f, "First orphan inode:       %u\n",
 			sb->s_last_orphan);
-	if ((sb->s_feature_compat & EXT2_FEATURE_COMPAT_DIR_INDEX) ||
+	if (ext2fs_has_feature_dir_index(sb) ||
 	    sb->s_def_hash_version)
 		fprintf(f, "Default directory hash:   %s\n",
 			e2p_hash2string(sb->s_def_hash_version));
@@ -428,7 +428,7 @@ void list_super2(struct ext2_super_block * sb, FILE *f)
 		fprintf(f, "Last error block #:       %llu\n",
 			sb->s_last_error_block);
 	}
-	if (sb->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) {
+	if (ext2fs_has_feature_mmp(sb)) {
 		fprintf(f, "MMP block number:         %llu\n",
 			(long long)sb->s_mmp_block);
 		fprintf(f, "MMP update interval:      %u\n",
@@ -441,7 +441,7 @@ void list_super2(struct ext2_super_block * sb, FILE *f)
 		fprintf(f, "Group quota inode:        %u\n",
 			sb->s_grp_quota_inum);
 
-	if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) {
+	if (ext2fs_has_feature_metadata_csum(sb)) {
 		fprintf(f, "Checksum type:            %s\n",
 			checksum_type(sb->s_checksum_type));
 		fprintf(f, "Checksum:                 0x%08x\n",
diff --git a/lib/ext2fs/alloc_sb.c b/lib/ext2fs/alloc_sb.c
index 8788c00..8530b40 100644
--- a/lib/ext2fs/alloc_sb.c
+++ b/lib/ext2fs/alloc_sb.c
@@ -52,7 +52,7 @@ int ext2fs_reserve_super_and_bgd(ext2_filsys fs,
 	ext2fs_super_and_bgd_loc2(fs, group, &super_blk,
 				  &old_desc_blk, &new_desc_blk, &used_blks);
 
-	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
+	if (ext2fs_has_feature_meta_bg(fs->super))
 		old_desc_blocks = fs->super->s_first_meta_bg;
 	else
 		old_desc_blocks =
diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
index 3e1952f..da0b15b 100644
--- a/lib/ext2fs/alloc_tables.c
+++ b/lib/ext2fs/alloc_tables.c
@@ -95,8 +95,7 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 	if (!bmap)
 		bmap = fs->block_map;
 
-	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-				      EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
+	if (ext2fs_has_feature_flex_bg(fs->super) &&
 	    fs->super->s_log_groups_per_flex) {
 		flexbg_size = 1 << fs->super->s_log_groups_per_flex;
 		last_grp = group | (flexbg_size - 1);
diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
index 93b64ce..4389a2f 100644
--- a/lib/ext2fs/blknum.c
+++ b/lib/ext2fs/blknum.c
@@ -69,8 +69,7 @@ blk64_t ext2fs_inode_data_blocks2(ext2_filsys fs,
 					struct ext2_inode *inode)
 {
 	return (inode->i_blocks |
-		((fs->super->s_feature_ro_compat &
-		  EXT4_FEATURE_RO_COMPAT_HUGE_FILE) ?
+		(ext2fs_has_feature_huge_file(fs->super) ?
 		 (__u64) inode->osd2.linux2.l_i_blocks_hi << 32 : 0)) -
 		(inode->i_file_acl ? fs->blocksize >> 9 : 0);
 }
@@ -82,8 +81,7 @@ blk64_t ext2fs_inode_i_blocks(ext2_filsys fs,
 					struct ext2_inode *inode)
 {
 	return (inode->i_blocks |
-		((fs->super->s_feature_ro_compat &
-		  EXT4_FEATURE_RO_COMPAT_HUGE_FILE) ?
+		(ext2fs_has_feature_huge_file(fs->super) ?
 		 (__u64)inode->osd2.linux2.l_i_blocks_hi << 32 : 0));
 }
 
@@ -93,7 +91,7 @@ blk64_t ext2fs_inode_i_blocks(ext2_filsys fs,
 blk64_t ext2fs_blocks_count(struct ext2_super_block *super)
 {
 	return super->s_blocks_count |
-		(super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT ?
+		(ext2fs_has_feature_64bit(super) ?
 		(__u64) super->s_blocks_count_hi << 32 : 0);
 }
 
@@ -103,7 +101,7 @@ blk64_t ext2fs_blocks_count(struct ext2_super_block *super)
 void ext2fs_blocks_count_set(struct ext2_super_block *super, blk64_t blk)
 {
 	super->s_blocks_count = blk;
-	if (super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+	if (ext2fs_has_feature_64bit(super))
 		super->s_blocks_count_hi = (__u64) blk >> 32;
 }
 
@@ -123,7 +121,7 @@ void ext2fs_blocks_count_add(struct ext2_super_block *super, blk64_t blk)
 blk64_t ext2fs_r_blocks_count(struct ext2_super_block *super)
 {
 	return super->s_r_blocks_count |
-		(super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT ?
+		(ext2fs_has_feature_64bit(super) ?
 		(__u64) super->s_r_blocks_count_hi << 32 : 0);
 }
 
@@ -133,7 +131,7 @@ blk64_t ext2fs_r_blocks_count(struct ext2_super_block *super)
 void ext2fs_r_blocks_count_set(struct ext2_super_block *super, blk64_t blk)
 {
 	super->s_r_blocks_count = blk;
-	if (super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+	if (ext2fs_has_feature_64bit(super))
 		super->s_r_blocks_count_hi = (__u64) blk >> 32;
 }
 
@@ -153,7 +151,7 @@ void ext2fs_r_blocks_count_add(struct ext2_super_block *super, blk64_t blk)
 blk64_t ext2fs_free_blocks_count(struct ext2_super_block *super)
 {
 	return super->s_free_blocks_count |
-		(super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT ?
+		(ext2fs_has_feature_64bit(super) ?
 		(__u64) super->s_free_blocks_hi << 32 : 0);
 }
 
@@ -163,7 +161,7 @@ blk64_t ext2fs_free_blocks_count(struct ext2_super_block *super)
 void ext2fs_free_blocks_count_set(struct ext2_super_block *super, blk64_t blk)
 {
 	super->s_free_blocks_count = blk;
-	if (super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+	if (ext2fs_has_feature_64bit(super))
 		super->s_free_blocks_hi = (__u64) blk >> 32;
 }
 
@@ -223,8 +221,7 @@ blk64_t ext2fs_block_bitmap_loc(ext2_filsys fs, dgrp_t group)
 
 	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
 	return gdp->bg_block_bitmap |
-		(fs->super->s_feature_incompat
-		 & EXT4_FEATURE_INCOMPAT_64BIT ?
+		(ext2fs_has_feature_64bit(fs->super) ?
 		 (__u64)gdp->bg_block_bitmap_hi << 32 : 0);
 }
 
@@ -237,7 +234,7 @@ void ext2fs_block_bitmap_loc_set(ext2_filsys fs, dgrp_t group, blk64_t blk)
 
 	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
 	gdp->bg_block_bitmap = blk;
-	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+	if (ext2fs_has_feature_64bit(fs->super))
 		gdp->bg_block_bitmap_hi = (__u64) blk >> 32;
 }
 
@@ -265,8 +262,7 @@ blk64_t ext2fs_inode_bitmap_loc(ext2_filsys fs, dgrp_t group)
 
 	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
 	return gdp->bg_inode_bitmap |
-		(fs->super->s_feature_incompat
-		 & EXT4_FEATURE_INCOMPAT_64BIT ?
+		(ext2fs_has_feature_64bit(fs->super) ?
 		 (__u64) gdp->bg_inode_bitmap_hi << 32 : 0);
 }
 
@@ -279,7 +275,7 @@ void ext2fs_inode_bitmap_loc_set(ext2_filsys fs, dgrp_t group, blk64_t blk)
 
 	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
 	gdp->bg_inode_bitmap = blk;
-	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+	if (ext2fs_has_feature_64bit(fs->super))
 		gdp->bg_inode_bitmap_hi = (__u64) blk >> 32;
 }
 
@@ -292,8 +288,7 @@ blk64_t ext2fs_inode_table_loc(ext2_filsys fs, dgrp_t group)
 
 	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
 	return gdp->bg_inode_table |
-		(fs->super->s_feature_incompat
-		 & EXT4_FEATURE_INCOMPAT_64BIT ?
+		(ext2fs_has_feature_64bit(fs->super) ?
 		 (__u64) gdp->bg_inode_table_hi << 32 : 0);
 }
 
@@ -306,7 +301,7 @@ void ext2fs_inode_table_loc_set(ext2_filsys fs, dgrp_t group, blk64_t blk)
 
 	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
 	gdp->bg_inode_table = blk;
-	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+	if (ext2fs_has_feature_64bit(fs->super))
 		gdp->bg_inode_table_hi = (__u64) blk >> 32;
 }
 
@@ -319,8 +314,7 @@ __u32 ext2fs_bg_free_blocks_count(ext2_filsys fs, dgrp_t group)
 
 	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
 	return gdp->bg_free_blocks_count |
-		(fs->super->s_feature_incompat
-		 & EXT4_FEATURE_INCOMPAT_64BIT ?
+		(ext2fs_has_feature_64bit(fs->super) ?
 		 (__u32) gdp->bg_free_blocks_count_hi << 16 : 0);
 }
 
@@ -334,7 +328,7 @@ void ext2fs_bg_free_blocks_count_set(ext2_filsys fs, dgrp_t group, __u32 n)
 	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
 	gdp->bg_free_blocks_count = n;
 
-	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+	if (ext2fs_has_feature_64bit(fs->super))
 		gdp->bg_free_blocks_count_hi = (__u32) n >> 16;
 }
 
@@ -347,8 +341,7 @@ __u32 ext2fs_bg_free_inodes_count(ext2_filsys fs, dgrp_t group)
 
 	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
 	return gdp->bg_free_inodes_count |
-		(fs->super->s_feature_incompat
-		 & EXT4_FEATURE_INCOMPAT_64BIT ?
+		(ext2fs_has_feature_64bit(fs->super) ?
 		 (__u32) gdp->bg_free_inodes_count_hi << 16 : 0);
 }
 
@@ -361,7 +354,7 @@ void ext2fs_bg_free_inodes_count_set(ext2_filsys fs, dgrp_t group, __u32 n)
 
 	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
 	gdp->bg_free_inodes_count = n;
-	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+	if (ext2fs_has_feature_64bit(fs->super))
 		gdp->bg_free_inodes_count_hi = (__u32) n >> 16;
 }
 
@@ -374,8 +367,7 @@ __u32 ext2fs_bg_used_dirs_count(ext2_filsys fs, dgrp_t group)
 
 	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
 	return gdp->bg_used_dirs_count |
-		(fs->super->s_feature_incompat
-		 & EXT4_FEATURE_INCOMPAT_64BIT ?
+		(ext2fs_has_feature_64bit(fs->super) ?
 		 (__u32) gdp->bg_used_dirs_count_hi << 16 : 0);
 }
 
@@ -388,7 +380,7 @@ void ext2fs_bg_used_dirs_count_set(ext2_filsys fs, dgrp_t group, __u32 n)
 
 	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
 	gdp->bg_used_dirs_count = n;
-	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+	if (ext2fs_has_feature_64bit(fs->super))
 		gdp->bg_used_dirs_count_hi = (__u32) n >> 16;
 }
 
@@ -401,8 +393,7 @@ __u32 ext2fs_bg_itable_unused(ext2_filsys fs, dgrp_t group)
 
 	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
 	return gdp->bg_itable_unused |
-		(fs->super->s_feature_incompat
-		 & EXT4_FEATURE_INCOMPAT_64BIT ?
+		(ext2fs_has_feature_64bit(fs->super) ?
 		 (__u32) gdp->bg_itable_unused_hi << 16 : 0);
 }
 
@@ -415,7 +406,7 @@ void ext2fs_bg_itable_unused_set(ext2_filsys fs, dgrp_t group, __u32 n)
 
 	gdp = ext4fs_group_desc(fs, fs->group_desc, group);
 	gdp->bg_itable_unused = n;
-	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+	if (ext2fs_has_feature_64bit(fs->super))
 		gdp->bg_itable_unused_hi = (__u32) n >> 16;
 }
 
@@ -507,7 +498,7 @@ blk64_t ext2fs_file_acl_block(ext2_filsys fs, const struct ext2_inode *inode)
 {
 	blk64_t	blk = inode->i_file_acl;
 
-	if (fs && fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+	if (fs && ext2fs_has_feature_64bit(fs->super))
 		blk |= ((__u64) inode->osd2.linux2.l_i_file_acl_high) << 32;
 	return blk;
 }
@@ -519,7 +510,7 @@ void ext2fs_file_acl_block_set(ext2_filsys fs, struct ext2_inode *inode,
 			       blk64_t blk)
 {
 	inode->i_file_acl = blk;
-	if (fs && fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+	if (fs && ext2fs_has_feature_64bit(fs->super))
 		inode->osd2.linux2.l_i_file_acl_high = (__u64) blk >> 32;
 }
 
@@ -536,11 +527,9 @@ errcode_t ext2fs_inode_size_set(ext2_filsys fs, struct ext2_inode *inode,
 	/* If we're writing a large file, set the large_file flag */
 	if (LINUX_S_ISREG(inode->i_mode) &&
 	    ext2fs_needs_large_file_feature(size) &&
-	    (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE) ||
+	    (!ext2fs_has_feature_large_file(fs->super) ||
 	     fs->super->s_rev_level == EXT2_GOOD_OLD_REV)) {
-		fs->super->s_feature_ro_compat |=
-					EXT2_FEATURE_RO_COMPAT_LARGE_FILE;
+		ext2fs_set_feature_large_file(fs->super);
 		ext2fs_update_dynamic_rev(fs);
 		ext2fs_mark_super_dirty(fs);
 	}
diff --git a/lib/ext2fs/bmap.c b/lib/ext2fs/bmap.c
index c18f742..29da4ef 100644
--- a/lib/ext2fs/bmap.c
+++ b/lib/ext2fs/bmap.c
@@ -145,8 +145,7 @@ static errcode_t implied_cluster_alloc(ext2_filsys fs, ext2_ino_t ino,
 	blk64_t	base_block, pblock = 0;
 	int i;
 
-	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_BIGALLOC))
+	if (!ext2fs_has_feature_bigalloc(fs->super))
 		return 0;
 
 	base_block = lblk & ~EXT2FS_CLUSTER_MASK(fs);
@@ -183,8 +182,7 @@ errcode_t ext2fs_map_cluster_block(ext2_filsys fs, ext2_ino_t ino,
 
 	/* Need bigalloc and extents to be enabled */
 	*pblk = 0;
-	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_BIGALLOC) ||
+	if (!ext2fs_has_feature_bigalloc(fs->super) ||
 	    !(inode->i_flags & EXT4_EXTENTS_FL))
 		return 0;
 
diff --git a/lib/ext2fs/check_desc.c b/lib/ext2fs/check_desc.c
index 1a768f9..3e3fa94 100644
--- a/lib/ext2fs/check_desc.c
+++ b/lib/ext2fs/check_desc.c
@@ -53,8 +53,7 @@ errcode_t ext2fs_check_desc(ext2_filsys fs)
 		ext2fs_reserve_super_and_bgd(fs, i, bmap);
 
 	for (i = 0; i < fs->group_desc_count; i++) {
-		if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-					       EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
+		if (!ext2fs_has_feature_flex_bg(fs->super)) {
 			first_block = ext2fs_group_first_block2(fs, i);
 			last_block = ext2fs_group_last_block2(fs, i);
 		}
diff --git a/lib/ext2fs/closefs.c b/lib/ext2fs/closefs.c
index 3c7c7dc..b69fa09 100644
--- a/lib/ext2fs/closefs.c
+++ b/lib/ext2fs/closefs.c
@@ -37,14 +37,13 @@ int ext2fs_bg_has_super(ext2_filsys fs, dgrp_t group)
 {
 	if (group == 0)
 		return 1;
-	if (fs->super->s_feature_compat & EXT4_FEATURE_COMPAT_SPARSE_SUPER2) {
+	if (ext2fs_has_feature_sparse_super2(fs->super)) {
 		if (group == fs->super->s_backup_bgs[0] ||
 		    group == fs->super->s_backup_bgs[1])
 			return 1;
 		return 0;
 	}
-	if ((group <= 1) || !(fs->super->s_feature_ro_compat &
-			      EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER))
+	if ((group <= 1) || !ext2fs_has_feature_sparse_super(fs->super))
 		return 1;
 	if (!(group & 1))
 		return 0;
@@ -86,7 +85,7 @@ errcode_t ext2fs_super_and_bgd_loc2(ext2_filsys fs,
 	if (group_block == 0 && fs->blocksize == 1024)
 		group_block = 1; /* Deal with 1024 blocksize && bigalloc */
 
-	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
+	if (ext2fs_has_feature_meta_bg(fs->super))
 		old_desc_blocks = fs->super->s_first_meta_bg;
 	else
 		old_desc_blocks =
@@ -101,7 +100,7 @@ errcode_t ext2fs_super_and_bgd_loc2(ext2_filsys fs,
 	meta_bg_size = EXT2_DESC_PER_BLOCK(fs->super);
 	meta_bg = group / meta_bg_size;
 
-	if (!(fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG) ||
+	if (!ext2fs_has_feature_meta_bg(fs->super) ||
 	    (meta_bg < fs->super->s_first_meta_bg)) {
 		if (has_super) {
 			old_desc_blk = group_block + 1;
@@ -347,14 +346,13 @@ errcode_t ext2fs_flush2(ext2_filsys fs, int flags)
 	 * we write out the backup superblocks.)
 	 */
 	fs->super->s_state &= ~EXT2_VALID_FS;
-	fs->super->s_feature_incompat &= ~EXT3_FEATURE_INCOMPAT_RECOVER;
+	ext2fs_clear_feature_journal_needs_recovery(fs->super);
 
 	/*
 	 * If this is an external journal device, don't write out the
 	 * block group descriptors or any of the backup superblocks
 	 */
-	if (fs->super->s_feature_incompat &
-	    EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)
+	if (ext2fs_has_feature_journal_dev(fs->super))
 		goto write_primary_superblock_only;
 
 	/*
@@ -362,7 +360,7 @@ errcode_t ext2fs_flush2(ext2_filsys fs, int flags)
 	 * superblocks and group descriptors.
 	 */
 	group_ptr = (char *) group_shadow;
-	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG) {
+	if (ext2fs_has_feature_meta_bg(fs->super)) {
 		old_desc_blocks = fs->super->s_first_meta_bg;
 		if (old_desc_blocks > fs->desc_blocks)
 			old_desc_blocks = fs->desc_blocks;
diff --git a/lib/ext2fs/csum.c b/lib/ext2fs/csum.c
index 6dcefb9..ab8b83f 100644
--- a/lib/ext2fs/csum.c
+++ b/lib/ext2fs/csum.c
@@ -41,8 +41,7 @@ int ext2fs_mmp_csum_verify(ext2_filsys fs, struct mmp_struct *mmp)
 {
 	__u32 calculated;
 
-	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext2fs_has_feature_metadata_csum(fs->super))
 		return 1;
 
 	calculated = ext2fs_mmp_csum(fs, mmp);
@@ -54,8 +53,7 @@ errcode_t ext2fs_mmp_csum_set(ext2_filsys fs, struct mmp_struct *mmp)
 {
 	__u32 crc;
 
-	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext2fs_has_feature_metadata_csum(fs->super))
 		return 0;
 
 	crc = ext2fs_mmp_csum(fs, mmp);
@@ -66,8 +64,7 @@ errcode_t ext2fs_mmp_csum_set(ext2_filsys fs, struct mmp_struct *mmp)
 
 int ext2fs_verify_csum_type(ext2_filsys fs, struct ext2_super_block *sb)
 {
-	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext2fs_has_feature_metadata_csum(fs->super))
 		return 1;
 
 	return sb->s_checksum_type == EXT2_CRC32C_CHKSUM;
@@ -145,8 +142,7 @@ int ext2fs_ext_attr_block_csum_verify(ext2_filsys fs, ext2_ino_t inum,
 	__u32 calculated;
 	errcode_t retval;
 
-	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext2fs_has_feature_metadata_csum(fs->super))
 		return 1;
 
 	retval = ext2fs_ext_attr_block_csum(fs, inum, block, hdr, &calculated);
@@ -163,8 +159,7 @@ errcode_t ext2fs_ext_attr_block_csum_set(ext2_filsys fs, ext2_ino_t inum,
 	errcode_t retval;
 	__u32 crc;
 
-	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-		EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext2fs_has_feature_metadata_csum(fs->super))
 		return 0;
 
 	retval = ext2fs_ext_attr_block_csum(fs, inum, block, hdr, &crc);
@@ -442,8 +437,7 @@ static errcode_t ext2fs_dx_csum_set(ext2_filsys fs, ext2_ino_t inum,
 int ext2fs_dir_block_csum_verify(ext2_filsys fs, ext2_ino_t inum,
 				 struct ext2_dir_entry *dirent)
 {
-	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext2fs_has_feature_metadata_csum(fs->super))
 		return 1;
 
 	if (__get_dirent_tail(fs, dirent, NULL, 1) == 0)
@@ -457,8 +451,7 @@ int ext2fs_dir_block_csum_verify(ext2_filsys fs, ext2_ino_t inum,
 errcode_t ext2fs_dir_block_csum_set(ext2_filsys fs, ext2_ino_t inum,
 				    struct ext2_dir_entry *dirent)
 {
-	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext2fs_has_feature_metadata_csum(fs->super))
 		return 0;
 
 	if (__get_dirent_tail(fs, dirent, NULL, 1) == 0)
@@ -516,8 +509,7 @@ int ext2fs_extent_block_csum_verify(ext2_filsys fs, ext2_ino_t inum,
 	 * The extent tree structures are accessed in LE order, so we must
 	 * swap the checksum bytes here.
 	 */
-	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext2fs_has_feature_metadata_csum(fs->super))
 		return 1;
 
 	provided = ext2fs_le32_to_cpu(t->et_checksum);
@@ -535,8 +527,7 @@ errcode_t ext2fs_extent_block_csum_set(ext2_filsys fs, ext2_ino_t inum,
 	__u32 crc;
 	struct ext3_extent_tail *t = get_extent_tail(eh);
 
-	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext2fs_has_feature_metadata_csum(fs->super))
 		return 0;
 
 	/*
@@ -557,8 +548,7 @@ int ext2fs_inode_bitmap_csum_verify(ext2_filsys fs, dgrp_t group,
 			ext2fs_group_desc(fs, fs->group_desc, group);
 	__u32 provided, calculated;
 
-	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext2fs_has_feature_metadata_csum(fs->super))
 		return 1;
 	provided = gdp->bg_inode_bitmap_csum_lo;
 	calculated = ext2fs_crc32c_le(fs->csum_seed, (unsigned char *)bitmap,
@@ -578,8 +568,7 @@ errcode_t ext2fs_inode_bitmap_csum_set(ext2_filsys fs, dgrp_t group,
 	struct ext4_group_desc *gdp = (struct ext4_group_desc *)
 			ext2fs_group_desc(fs, fs->group_desc, group);
 
-	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext2fs_has_feature_metadata_csum(fs->super))
 		return 0;
 
 	crc = ext2fs_crc32c_le(fs->csum_seed, (unsigned char *)bitmap, size);
@@ -597,8 +586,7 @@ int ext2fs_block_bitmap_csum_verify(ext2_filsys fs, dgrp_t group,
 			ext2fs_group_desc(fs, fs->group_desc, group);
 	__u32 provided, calculated;
 
-	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext2fs_has_feature_metadata_csum(fs->super))
 		return 1;
 	provided = gdp->bg_block_bitmap_csum_lo;
 	calculated = ext2fs_crc32c_le(fs->csum_seed, (unsigned char *)bitmap,
@@ -618,8 +606,7 @@ errcode_t ext2fs_block_bitmap_csum_set(ext2_filsys fs, dgrp_t group,
 	struct ext4_group_desc *gdp = (struct ext4_group_desc *)
 			ext2fs_group_desc(fs, fs->group_desc, group);
 
-	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext2fs_has_feature_metadata_csum(fs->super))
 		return 0;
 
 	crc = ext2fs_crc32c_le(fs->csum_seed, (unsigned char *)bitmap, size);
@@ -669,8 +656,7 @@ int ext2fs_inode_csum_verify(ext2_filsys fs, ext2_ino_t inum,
 	char *cp;
 
 	if (fs->super->s_creator_os != EXT2_OS_LINUX ||
-	    !EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	    !ext2fs_has_feature_metadata_csum(fs->super))
 		return 1;
 
 	has_hi = (EXT2_INODE_SIZE(fs->super) > EXT2_GOOD_OLD_INODE_SIZE &&
@@ -713,8 +699,7 @@ errcode_t ext2fs_inode_csum_set(ext2_filsys fs, ext2_ino_t inum,
 	int has_hi;
 
 	if (fs->super->s_creator_os != EXT2_OS_LINUX ||
-	    !EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	    !ext2fs_has_feature_metadata_csum(fs->super))
 		return 0;
 
 	has_hi = (EXT2_INODE_SIZE(fs->super) > EXT2_GOOD_OLD_INODE_SIZE &&
@@ -750,8 +735,7 @@ __u16 ext2fs_group_desc_csum(ext2_filsys fs, dgrp_t group)
 	group = ext2fs_swab32(group);
 #endif
 
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
+	if (ext2fs_has_feature_metadata_csum(fs->super)) {
 		/* new metadata csum code */
 		__u16 old_crc;
 		__u32 crc32;
diff --git a/lib/ext2fs/dir_iterate.c b/lib/ext2fs/dir_iterate.c
index 390573a..b2b7769 100644
--- a/lib/ext2fs/dir_iterate.c
+++ b/lib/ext2fs/dir_iterate.c
@@ -218,8 +218,7 @@ int ext2fs_process_dir_block(ext2_filsys fs,
 		buflen = ctx->buflen;
 	}
 
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (ext2fs_has_feature_metadata_csum(fs->super))
 		csum_size = sizeof(struct ext2_dir_entry_tail);
 
 	while (offset < buflen - 8) {
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index cfeaa05..709838d 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -809,6 +809,95 @@ struct ext2_super_block {
 #define EXT4_FEATURE_INCOMPAT_INLINE_DATA	0x8000 /* data in inode */
 #define EXT4_FEATURE_INCOMPAT_ENCRYPT		0x10000
 
+#define EXT4_FEATURE_COMPAT_FUNCS(name, ver, flagname) \
+static inline int ext2fs_has_feature_##name(struct ext2_super_block *sb) \
+{ \
+	return ((EXT2_SB(sb)->s_feature_compat & \
+		 EXT##ver##_FEATURE_COMPAT_##flagname) != 0); \
+} \
+static inline void ext2fs_set_feature_##name(struct ext2_super_block *sb) \
+{ \
+	EXT2_SB(sb)->s_feature_compat |= \
+		EXT##ver##_FEATURE_COMPAT_##flagname; \
+} \
+static inline void ext2fs_clear_feature_##name(struct ext2_super_block *sb) \
+{ \
+	EXT2_SB(sb)->s_feature_compat &= \
+		~EXT##ver##_FEATURE_COMPAT_##flagname; \
+}
+
+#define EXT4_FEATURE_RO_COMPAT_FUNCS(name, ver, flagname) \
+static inline int ext2fs_has_feature_##name(struct ext2_super_block *sb) \
+{ \
+	return ((EXT2_SB(sb)->s_feature_ro_compat & \
+		 EXT##ver##_FEATURE_RO_COMPAT_##flagname) != 0); \
+} \
+static inline void ext2fs_set_feature_##name(struct ext2_super_block *sb) \
+{ \
+	EXT2_SB(sb)->s_feature_ro_compat |= \
+		EXT##ver##_FEATURE_RO_COMPAT_##flagname; \
+} \
+static inline void ext2fs_clear_feature_##name(struct ext2_super_block *sb) \
+{ \
+	EXT2_SB(sb)->s_feature_ro_compat &= \
+		~EXT##ver##_FEATURE_RO_COMPAT_##flagname; \
+}
+
+#define EXT4_FEATURE_INCOMPAT_FUNCS(name, ver, flagname) \
+static inline int ext2fs_has_feature_##name(struct ext2_super_block *sb) \
+{ \
+	return ((EXT2_SB(sb)->s_feature_incompat & \
+		 EXT##ver##_FEATURE_INCOMPAT_##flagname) != 0); \
+} \
+static inline void ext2fs_set_feature_##name(struct ext2_super_block *sb) \
+{ \
+	EXT2_SB(sb)->s_feature_incompat |= \
+		EXT##ver##_FEATURE_INCOMPAT_##flagname; \
+} \
+static inline void ext2fs_clear_feature_##name(struct ext2_super_block *sb) \
+{ \
+	EXT2_SB(sb)->s_feature_incompat &= \
+		~EXT##ver##_FEATURE_INCOMPAT_##flagname; \
+}
+
+EXT4_FEATURE_COMPAT_FUNCS(dir_prealloc,		2, DIR_PREALLOC)
+EXT4_FEATURE_COMPAT_FUNCS(imagic_inodes,	2, IMAGIC_INODES)
+EXT4_FEATURE_COMPAT_FUNCS(journal,		3, HAS_JOURNAL)
+EXT4_FEATURE_COMPAT_FUNCS(xattr,		2, EXT_ATTR)
+EXT4_FEATURE_COMPAT_FUNCS(resize_inode,		2, RESIZE_INODE)
+EXT4_FEATURE_COMPAT_FUNCS(dir_index,		2, DIR_INDEX)
+EXT4_FEATURE_COMPAT_FUNCS(lazy_bg,		2, LAZY_BG)
+EXT4_FEATURE_COMPAT_FUNCS(exclude_bitmap,	2, EXCLUDE_BITMAP)
+EXT4_FEATURE_COMPAT_FUNCS(sparse_super2,	4, SPARSE_SUPER2)
+
+EXT4_FEATURE_RO_COMPAT_FUNCS(sparse_super,	2, SPARSE_SUPER)
+EXT4_FEATURE_RO_COMPAT_FUNCS(large_file,	2, LARGE_FILE)
+EXT4_FEATURE_RO_COMPAT_FUNCS(huge_file,		4, HUGE_FILE)
+EXT4_FEATURE_RO_COMPAT_FUNCS(gdt_csum,		4, GDT_CSUM)
+EXT4_FEATURE_RO_COMPAT_FUNCS(dir_nlink,		4, DIR_NLINK)
+EXT4_FEATURE_RO_COMPAT_FUNCS(extra_isize,	4, EXTRA_ISIZE)
+EXT4_FEATURE_RO_COMPAT_FUNCS(has_snapshot,	4, HAS_SNAPSHOT)
+EXT4_FEATURE_RO_COMPAT_FUNCS(quota,		4, QUOTA)
+EXT4_FEATURE_RO_COMPAT_FUNCS(bigalloc,		4, BIGALLOC)
+EXT4_FEATURE_RO_COMPAT_FUNCS(metadata_csum,	4, METADATA_CSUM)
+EXT4_FEATURE_RO_COMPAT_FUNCS(replica,		4, REPLICA)
+EXT4_FEATURE_RO_COMPAT_FUNCS(readonly,		4, READONLY)
+
+EXT4_FEATURE_INCOMPAT_FUNCS(compression,	2, COMPRESSION)
+EXT4_FEATURE_INCOMPAT_FUNCS(filetype,		2, FILETYPE)
+EXT4_FEATURE_INCOMPAT_FUNCS(journal_needs_recovery,	3, RECOVER)
+EXT4_FEATURE_INCOMPAT_FUNCS(journal_dev,	3, JOURNAL_DEV)
+EXT4_FEATURE_INCOMPAT_FUNCS(meta_bg,		2, META_BG)
+EXT4_FEATURE_INCOMPAT_FUNCS(extents,		3, EXTENTS)
+EXT4_FEATURE_INCOMPAT_FUNCS(64bit,		4, 64BIT)
+EXT4_FEATURE_INCOMPAT_FUNCS(mmp,		4, MMP)
+EXT4_FEATURE_INCOMPAT_FUNCS(flex_bg,		4, FLEX_BG)
+EXT4_FEATURE_INCOMPAT_FUNCS(ea_inode,		4, EA_INODE)
+EXT4_FEATURE_INCOMPAT_FUNCS(dirdata,		4, DIRDATA)
+EXT4_FEATURE_INCOMPAT_FUNCS(largedir,		4, LARGEDIR)
+EXT4_FEATURE_INCOMPAT_FUNCS(inline_data,	4, INLINE_DATA)
+EXT4_FEATURE_INCOMPAT_FUNCS(encrypt,		4, ENCRYPT)
+
 #define EXT2_FEATURE_COMPAT_SUPP	0
 #define EXT2_FEATURE_INCOMPAT_SUPP    (EXT2_FEATURE_INCOMPAT_FILETYPE| \
 				       EXT4_FEATURE_INCOMPAT_MMP)
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 86d860f..30e913c 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -635,9 +635,8 @@ struct ext2_xattr_handle;
  */
 static inline int ext2fs_has_group_desc_csum(ext2_filsys fs)
 {
-	return EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-			EXT4_FEATURE_RO_COMPAT_GDT_CSUM |
-			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM);
+	return ext2fs_has_feature_metadata_csum(fs->super) ||
+	       ext2fs_has_feature_gdt_csum(fs->super);
 }
 
 /* The LARGE_FILE feature should be set if we have stored files 2GB+ in size */
@@ -1658,7 +1657,6 @@ extern errcode_t ext2fs_write_bb_FILE(ext2_badblocks_list bb_list,
 
 /* inline functions */
 #ifdef NO_INLINE_FUNCS
-extern void ext2fs_init_csum_seed(ext2_filsys fs);
 extern errcode_t ext2fs_get_mem(unsigned long size, void *ptr);
 extern errcode_t ext2fs_get_memzero(unsigned long size, void *ptr);
 extern errcode_t ext2fs_get_array(unsigned long count,
@@ -1714,10 +1712,9 @@ extern void ext2fs_dirent_set_file_type(struct ext2_dir_entry *entry, int type);
 #endif /* __STDC_VERSION__ >= 199901L */
 #endif
 
-_INLINE_ void ext2fs_init_csum_seed(ext2_filsys fs)
+static inline void ext2fs_init_csum_seed(ext2_filsys fs)
 {
-	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext2fs_has_feature_metadata_csum(fs->super))
 		return;
 
 	fs->csum_seed = ext2fs_crc32c_le(~0, fs->super->s_uuid,
diff --git a/lib/ext2fs/ext_attr.c b/lib/ext2fs/ext_attr.c
index bb950aa..0a4f8c0 100644
--- a/lib/ext2fs/ext_attr.c
+++ b/lib/ext2fs/ext_attr.c
@@ -1060,10 +1060,8 @@ errcode_t ext2fs_xattrs_open(ext2_filsys fs, ext2_ino_t ino,
 	struct ext2_xattr_handle *h;
 	errcode_t err;
 
-	if (!EXT2_HAS_COMPAT_FEATURE(fs->super,
-				     EXT2_FEATURE_COMPAT_EXT_ATTR) &&
-	    !EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-				     EXT4_FEATURE_INCOMPAT_INLINE_DATA))
+	if (!ext2fs_has_feature_xattr(fs->super) &&
+	    !ext2fs_has_feature_inline_data(fs->super))
 		return EXT2_ET_MISSING_EA_FEATURE;
 
 	err = ext2fs_get_memzero(sizeof(*h), &h);
diff --git a/lib/ext2fs/i_block.c b/lib/ext2fs/i_block.c
index 5ca57e4..2eecf02 100644
--- a/lib/ext2fs/i_block.c
+++ b/lib/ext2fs/i_block.c
@@ -32,18 +32,17 @@ errcode_t ext2fs_iblk_add_blocks(ext2_filsys fs, struct ext2_inode *inode,
 {
 	unsigned long long b = inode->i_blocks;
 
-	if (fs->super->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_HUGE_FILE)
+	if (ext2fs_has_feature_huge_file(fs->super))
 		b += ((long long) inode->osd2.linux2.l_i_blocks_hi) << 32;
 
-	if (!(fs->super->s_feature_ro_compat &
-	      EXT4_FEATURE_RO_COMPAT_HUGE_FILE) ||
+	if (!ext2fs_has_feature_huge_file(fs->super) ||
 	    !(inode->i_flags & EXT4_HUGE_FILE_FL))
 	    num_blocks *= fs->blocksize / 512;
 	num_blocks *= EXT2FS_CLUSTER_RATIO(fs);
 
 	b += num_blocks;
 
-	if (fs->super->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_HUGE_FILE)
+	if (ext2fs_has_feature_huge_file(fs->super))
 		inode->osd2.linux2.l_i_blocks_hi = b >> 32;
 	else if (b > 0xFFFFFFFF)
 		return EOVERFLOW;
@@ -56,11 +55,10 @@ errcode_t ext2fs_iblk_sub_blocks(ext2_filsys fs, struct ext2_inode *inode,
 {
 	unsigned long long b = inode->i_blocks;
 
-	if (fs->super->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_HUGE_FILE)
+	if (ext2fs_has_feature_huge_file(fs->super))
 		b += ((long long) inode->osd2.linux2.l_i_blocks_hi) << 32;
 
-	if (!(fs->super->s_feature_ro_compat &
-	      EXT4_FEATURE_RO_COMPAT_HUGE_FILE) ||
+	if (!ext2fs_has_feature_huge_file(fs->super) ||
 	    !(inode->i_flags & EXT4_HUGE_FILE_FL))
 	    num_blocks *= fs->blocksize / 512;
 	num_blocks *= EXT2FS_CLUSTER_RATIO(fs);
@@ -70,7 +68,7 @@ errcode_t ext2fs_iblk_sub_blocks(ext2_filsys fs, struct ext2_inode *inode,
 
 	b -= num_blocks;
 
-	if (fs->super->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_HUGE_FILE)
+	if (ext2fs_has_feature_huge_file(fs->super))
 		inode->osd2.linux2.l_i_blocks_hi = b >> 32;
 	inode->i_blocks = b & 0xFFFFFFFF;
 	return 0;
@@ -78,14 +76,13 @@ errcode_t ext2fs_iblk_sub_blocks(ext2_filsys fs, struct ext2_inode *inode,
 
 errcode_t ext2fs_iblk_set(ext2_filsys fs, struct ext2_inode *inode, blk64_t b)
 {
-	if (!(fs->super->s_feature_ro_compat &
-	      EXT4_FEATURE_RO_COMPAT_HUGE_FILE) ||
+	if (!ext2fs_has_feature_huge_file(fs->super) ||
 	    !(inode->i_flags & EXT4_HUGE_FILE_FL))
 		b *= fs->blocksize / 512;
 	b *= EXT2FS_CLUSTER_RATIO(fs);
 
 	inode->i_blocks = b & 0xFFFFFFFF;
-	if (fs->super->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_HUGE_FILE)
+	if (ext2fs_has_feature_huge_file(fs->super))
 		inode->osd2.linux2.l_i_blocks_hi = b >> 32;
 	else if (b >> 32)
 		return EOVERFLOW;
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index b5ca928..8714ff5 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -147,8 +147,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	super->s_magic = EXT2_SUPER_MAGIC;
 	super->s_state = EXT2_VALID_FS;
 
-	bigalloc_flag = EXT2_HAS_RO_COMPAT_FEATURE(param,
-				   EXT4_FEATURE_RO_COMPAT_BIGALLOC);
+	bigalloc_flag = ext2fs_has_feature_bigalloc(param);
 
 	assign_field(s_log_block_size);
 
@@ -258,7 +257,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	 * If we're creating an external journal device, we don't need
 	 * to bother with the rest.
 	 */
-	if (super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_JOURNAL_DEV) {
+	if (ext2fs_has_feature_journal_dev(super)) {
 		fs->group_desc_count = 0;
 		ext2fs_mark_super_dirty(fs);
 		*ret_fs = fs;
@@ -275,7 +274,7 @@ retry:
 	}
 
 	set_field(s_desc_size,
-		  super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT ?
+		  ext2fs_has_feature_64bit(super) ?
 		  EXT2_MIN_DESC_SIZE_64BIT : 0);
 
 	fs->desc_blocks = ext2fs_div_ceil(fs->group_desc_count,
@@ -283,7 +282,7 @@ retry:
 
 	i = fs->blocksize >= 4096 ? 1 : 4096 / fs->blocksize;
 
-	if (super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT &&
+	if (ext2fs_has_feature_64bit(super) &&
 	    (ext2fs_blocks_count(super) / i) > (1ULL << 32))
 		set_field(s_inodes_count, ~0U);
 	else
@@ -362,7 +361,7 @@ ipg_retry:
 	/*
 	 * check the number of reserved group descriptor table blocks
 	 */
-	if (super->s_feature_compat & EXT2_FEATURE_COMPAT_RESIZE_INODE)
+	if (ext2fs_has_feature_resize_inode(super))
 		rsv_gdt = calc_reserved_gdt_blocks(fs);
 	else
 		rsv_gdt = 0;
@@ -384,9 +383,9 @@ ipg_retry:
 	/* Enable meta_bg if we'd lose more than 3/4 of a BG to GDT blocks. */
 	if (super->s_reserved_gdt_blocks + fs->desc_blocks >
 	    super->s_blocks_per_group * 3 / 4)
-		fs->super->s_feature_incompat |= EXT2_FEATURE_INCOMPAT_META_BG;
+		ext2fs_set_feature_meta_bg(fs->super);
 
-	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
+	if (ext2fs_has_feature_meta_bg(fs->super))
 		overhead++;
 	else
 		overhead += fs->desc_blocks;
@@ -435,7 +434,7 @@ ipg_retry:
 	 */
 
 	/* Set up the locations of the backup superblocks */
-	if (super->s_feature_compat & EXT4_FEATURE_COMPAT_SPARSE_SUPER2) {
+	if (ext2fs_has_feature_sparse_super2(super)) {
 		if (super->s_backup_bgs[0] >= fs->group_desc_count)
 			super->s_backup_bgs[0] = fs->group_desc_count - 1;
 		if (super->s_backup_bgs[1] >= fs->group_desc_count)
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index 3a81eb0..587b88d 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -291,13 +291,11 @@ static errcode_t ext2fs_inline_data_convert_dir(ext2_filsys fs, ext2_ino_t ino,
 	int csum_size = 0;
 	int filetype = 0;
 
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (ext2fs_has_feature_metadata_csum(fs->super))
 		csum_size = sizeof(struct ext2_dir_entry_tail);
 
 	/* Create '.' and '..' */
-	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-				      EXT2_FEATURE_INCOMPAT_FILETYPE))
+	if (ext2fs_has_feature_filetype(fs->super))
 		filetype = EXT2_FT_DIR;
 
 	/*
@@ -386,7 +384,7 @@ ext2fs_inline_data_dir_expand(ext2_filsys fs, ext2_ino_t ino,
 		goto errout;
 
 	/* Update inode */
-	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super, EXT3_FEATURE_INCOMPAT_EXTENTS))
+	if (ext2fs_has_feature_extents(fs->super))
 		inode->i_flags |= EXT4_EXTENTS_FL;
 	inode->i_flags &= ~EXT4_INLINE_DATA_FL;
 	retval = ext2fs_iblk_add_blocks(fs, inode, 1);
@@ -415,8 +413,7 @@ ext2fs_inline_data_file_expand(ext2_filsys fs, ext2_ino_t ino,
 
 	/* Update inode */
 	memset(inode->i_block, 0, sizeof(inode->i_block));
-	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-				      EXT3_FEATURE_INCOMPAT_EXTENTS)) {
+	if (ext2fs_has_feature_extents(fs->super)) {
 		ext2_extent_handle_t handle;
 
 		inode->i_flags &= ~EXT4_EXTENTS_FL;
diff --git a/lib/ext2fs/kernel-jbd.h b/lib/ext2fs/kernel-jbd.h
index 4653560..772d7ed 100644
--- a/lib/ext2fs/kernel-jbd.h
+++ b/lib/ext2fs/kernel-jbd.h
@@ -245,7 +245,7 @@ typedef struct journal_superblock_s
 	((j)->j_format_version >= 2 &&					\
 	 ((j)->j_superblock->s_feature_incompat & ext2fs_cpu_to_be32((mask))))
 
-#define JFS_FEATURE_COMPAT_CHECKSUM	0x00000001
+#define JFS_FEATURE_COMPAT_CHECKSUM		0x00000001
 
 #define JFS_FEATURE_INCOMPAT_REVOKE		0x00000001
 #define JFS_FEATURE_INCOMPAT_64BIT		0x00000002
@@ -253,6 +253,69 @@ typedef struct journal_superblock_s
 #define JFS_FEATURE_INCOMPAT_CSUM_V2		0x00000008
 #define JFS_FEATURE_INCOMPAT_CSUM_V3		0x00000010
 
+/* journal feature predicate functions */
+#define JFS_FEATURE_COMPAT_FUNCS(name, flagname) \
+static inline int jfs_has_feature_##name(journal_t *j) \
+{ \
+	return ((j)->j_format_version >= 2 && \
+		((j)->j_superblock->s_feature_compat & \
+		 ext2fs_cpu_to_be32(JFS_FEATURE_COMPAT_##flagname)) != 0); \
+} \
+static inline void jfs_set_feature_##name(journal_t *j) \
+{ \
+	(j)->j_superblock->s_feature_compat |= \
+		ext2fs_cpu_to_be32(JFS_FEATURE_COMPAT_##flagname); \
+} \
+static inline void jfs_clear_feature_##name(journal_t *j) \
+{ \
+	(j)->j_superblock->s_feature_compat &= \
+		~ext2fs_cpu_to_be32(JFS_FEATURE_COMPAT_##flagname); \
+}
+
+#define JFS_FEATURE_RO_COMPAT_FUNCS(name, flagname) \
+static inline int jfs_has_feature_##name(journal_t *j) \
+{ \
+	return ((j)->j_format_version >= 2 && \
+		((j)->j_superblock->s_feature_ro_compat & \
+		 ext2fs_cpu_to_be32(JFS_FEATURE_RO_COMPAT_##flagname)) != 0); \
+} \
+static inline void jfs_set_feature_##name(journal_t *j) \
+{ \
+	(j)->j_superblock->s_feature_ro_compat |= \
+		ext2fs_cpu_to_be32(JFS_FEATURE_RO_COMPAT_##flagname); \
+} \
+static inline void jfs_clear_feature_##name(journal_t *j) \
+{ \
+	(j)->j_superblock->s_feature_ro_compat &= \
+		~ext2fs_cpu_to_be32(JFS_FEATURE_RO_COMPAT_##flagname); \
+}
+
+#define JFS_FEATURE_INCOMPAT_FUNCS(name, flagname) \
+static inline int jfs_has_feature_##name(journal_t *j) \
+{ \
+	return ((j)->j_format_version >= 2 && \
+		((j)->j_superblock->s_feature_incompat & \
+		 ext2fs_cpu_to_be32(JFS_FEATURE_INCOMPAT_##flagname)) != 0); \
+} \
+static inline void jfs_set_feature_##name(journal_t *j) \
+{ \
+	(j)->j_superblock->s_feature_incompat |= \
+		ext2fs_cpu_to_be32(JFS_FEATURE_INCOMPAT_##flagname); \
+} \
+static inline void jfs_clear_feature_##name(journal_t *j) \
+{ \
+	(j)->j_superblock->s_feature_incompat &= \
+		~ext2fs_cpu_to_be32(JFS_FEATURE_INCOMPAT_##flagname); \
+}
+
+JFS_FEATURE_COMPAT_FUNCS(checksum,		CHECKSUM)
+
+JFS_FEATURE_INCOMPAT_FUNCS(revoke,		REVOKE)
+JFS_FEATURE_INCOMPAT_FUNCS(64bit,		64BIT)
+JFS_FEATURE_INCOMPAT_FUNCS(async_commit,	ASYNC_COMMIT)
+JFS_FEATURE_INCOMPAT_FUNCS(csum2,		CSUM_V2)
+JFS_FEATURE_INCOMPAT_FUNCS(csum3,		CSUM_V3)
+
 /* Features known to this kernel version: */
 #define JFS_KNOWN_COMPAT_FEATURES	0
 #define JFS_KNOWN_ROCOMPAT_FEATURES	0
@@ -284,28 +347,27 @@ typedef struct journal_superblock_s
 /*
  * helper functions to deal with 32 or 64bit block numbers.
  */
-_INLINE_ size_t journal_tag_bytes(journal_t *journal)
+static inline size_t journal_tag_bytes(journal_t *journal)
 {
 	size_t sz;
 
-	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_CSUM_V3))
+	if (jfs_has_feature_csum3(journal))
 		return sizeof(journal_block_tag3_t);
 
 	sz = sizeof(journal_block_tag_t);
 
-	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_CSUM_V2))
+	if (jfs_has_feature_csum2(journal))
 		sz += sizeof(__u16);
 
-	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_64BIT))
+	if (jfs_has_feature_64bit(journal))
 		return sz;
 
 	return sz - sizeof(__u32);
 }
 
-_INLINE_ int journal_has_csum_v2or3(journal_t *journal)
+static inline int journal_has_csum_v2or3(journal_t *journal)
 {
-	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_CSUM_V2) ||
-	    JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_CSUM_V3))
+	if (jfs_has_feature_csum2(journal) || jfs_has_feature_csum3(journal))
 		return 1;
 
 	return 0;
diff --git a/lib/ext2fs/link.c b/lib/ext2fs/link.c
index 09e6cb4..65dc887 100644
--- a/lib/ext2fs/link.c
+++ b/lib/ext2fs/link.c
@@ -53,8 +53,7 @@ static int link_proc(struct ext2_dir_entry *dirent,
 	if (ls->err)
 		return DIRENT_ABORT;
 
-	if (EXT2_HAS_RO_COMPAT_FEATURE(ls->fs->super,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (ext2fs_has_feature_metadata_csum(ls->fs->super))
 		csum_size = sizeof(struct ext2_dir_entry_tail);
 	/*
 	 * See if the following directory entry (if any) is unused;
@@ -138,7 +137,7 @@ static int link_proc(struct ext2_dir_entry *dirent,
 	dirent->inode = ls->inode;
 	ext2fs_dirent_set_name_len(dirent, ls->namelen);
 	strncpy(dirent->name, ls->name, ls->namelen);
-	if (ls->sb->s_feature_incompat & EXT2_FEATURE_INCOMPAT_FILETYPE)
+	if (ext2fs_has_feature_filetype(ls->sb))
 		ext2fs_dirent_set_file_type(dirent, ls->flags & 0x7);
 
 	ls->done++;
diff --git a/lib/ext2fs/mkdir.c b/lib/ext2fs/mkdir.c
index 433f3b4..2a63aad 100644
--- a/lib/ext2fs/mkdir.c
+++ b/lib/ext2fs/mkdir.c
@@ -51,8 +51,7 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 	 * and ino >= EXT2_FIRST_INO.
 	 */
 	if ((!ino || ino >= EXT2_FIRST_INO(fs->super)) &&
-	    EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-				      EXT4_FEATURE_INCOMPAT_INLINE_DATA))
+	    ext2fs_has_feature_inline_data(fs->super))
 		inline_data = 1;
 
 	/*
@@ -108,8 +107,7 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 		inode.i_flags |= EXT4_INLINE_DATA_FL;
 		inode.i_size = EXT4_MIN_INLINE_DATA_SIZE;
 	} else {
-		if (fs->super->s_feature_incompat &
-		    EXT3_FEATURE_INCOMPAT_EXTENTS)
+		if (ext2fs_has_feature_extents(fs->super))
 			inode.i_flags |= EXT4_EXTENTS_FL;
 		else
 			inode.i_block[0] = blk;
@@ -134,8 +132,7 @@ errcode_t ext2fs_mkdir(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t inum,
 		if (retval)
 			goto cleanup;
 
-		if (fs->super->s_feature_incompat &
-		    EXT3_FEATURE_INCOMPAT_EXTENTS) {
+		if (ext2fs_has_feature_extents(fs->super)) {
 			retval = ext2fs_extent_open2(fs, ino, &inode, &handle);
 			if (retval)
 				goto cleanup;
diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
index 80a1021..af983c7 100644
--- a/lib/ext2fs/mkjournal.c
+++ b/lib/ext2fs/mkjournal.c
@@ -73,8 +73,7 @@ errcode_t ext2fs_create_journal_superblock(ext2_filsys fs,
 	 * If we're creating an external journal device, we need to
 	 * adjust these fields.
 	 */
-	if (fs->super->s_feature_incompat &
-	    EXT3_FEATURE_INCOMPAT_JOURNAL_DEV) {
+	if (ext2fs_has_feature_journal_dev(fs->super)) {
 		jsb->s_nr_users = 0;
 		jsb->s_first = htonl(ext2fs_journal_sb_start(fs->blocksize) + 1);
 	}
@@ -289,7 +288,7 @@ static errcode_t write_journal_inode(ext2_filsys fs, ext2_ino_t journal_ino,
 	if (goal == ~0ULL)
 		goal = get_midpoint_journal_block(fs);
 
-	if (fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS)
+	if (ext2fs_has_feature_extents(fs->super))
 		inode.i_flags |= EXT4_EXTENTS_FL;
 
 	if (!(flags & EXT2_MKJOURNAL_LAZYINIT))
@@ -414,7 +413,7 @@ errcode_t ext2fs_add_journal_device(ext2_filsys fs, ext2_filsys journal_dev)
 	memcpy(fs->super->s_journal_uuid, jsb->s_uuid,
 	       sizeof(fs->super->s_journal_uuid));
 	memset(fs->super->s_jnl_blocks, 0, sizeof(fs->super->s_jnl_blocks));
-	fs->super->s_feature_compat |= EXT3_FEATURE_COMPAT_HAS_JOURNAL;
+	ext2fs_set_feature_journal(fs->super);
 	ext2fs_mark_super_dirty(fs);
 	return 0;
 }
@@ -526,7 +525,7 @@ errcode_t ext2fs_add_journal_inode2(ext2_filsys fs, blk_t num_blocks,
 	fs->super->s_journal_dev = 0;
 	memset(fs->super->s_journal_uuid, 0,
 	       sizeof(fs->super->s_journal_uuid));
-	fs->super->s_feature_compat |= EXT3_FEATURE_COMPAT_HAS_JOURNAL;
+	ext2fs_set_feature_journal(fs->super);
 
 	ext2fs_mark_super_dirty(fs);
 	return 0;
diff --git a/lib/ext2fs/mmp.c b/lib/ext2fs/mmp.c
index ac27837..0570fed 100644
--- a/lib/ext2fs/mmp.c
+++ b/lib/ext2fs/mmp.c
@@ -378,7 +378,7 @@ errcode_t ext2fs_mmp_stop(ext2_filsys fs)
 	struct mmp_struct *mmp, *mmp_cmp;
 	errcode_t retval = 0;
 
-	if (!(fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) ||
+	if (!ext2fs_has_feature_mmp(fs->super) ||
 	    !(fs->flags & EXT2_FLAG_RW) || (fs->flags & EXT2_FLAG_SKIP_MMP))
 		goto mmp_error;
 
@@ -405,7 +405,7 @@ mmp_error:
 
 	return retval;
 #else
-	if (!(fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) ||
+	if (!ext2fs_has_feature_mmp(fs->super) ||
 	    !(fs->flags & EXT2_FLAG_RW) || (fs->flags & EXT2_FLAG_SKIP_MMP))
 		return 0;
 
@@ -425,7 +425,7 @@ errcode_t ext2fs_mmp_update2(ext2_filsys fs, int immediately)
 	struct timeval tv;
 	errcode_t retval = 0;
 
-	if (!(fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) ||
+	if (!ext2fs_has_feature_mmp(fs->super) ||
 	    !(fs->flags & EXT2_FLAG_RW) || (fs->flags & EXT2_FLAG_SKIP_MMP))
 		return 0;
 
@@ -451,7 +451,7 @@ errcode_t ext2fs_mmp_update2(ext2_filsys fs, int immediately)
 mmp_error:
 	return retval;
 #else
-	if (!(fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) ||
+	if (!ext2fs_has_feature_mmp(fs->super) ||
 	    !(fs->flags & EXT2_FLAG_RW) || (fs->flags & EXT2_FLAG_SKIP_MMP))
 		return 0;
 
diff --git a/lib/ext2fs/newdir.c b/lib/ext2fs/newdir.c
index ed250c7..7f47285 100644
--- a/lib/ext2fs/newdir.c
+++ b/lib/ext2fs/newdir.c
@@ -45,8 +45,7 @@ errcode_t ext2fs_new_dir_block(ext2_filsys fs, ext2_ino_t dir_ino,
 	memset(buf, 0, fs->blocksize);
 	dir = (struct ext2_dir_entry *) buf;
 
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (ext2fs_has_feature_metadata_csum(fs->super))
 		csum_size = sizeof(struct ext2_dir_entry_tail);
 
 	retval = ext2fs_set_rec_len(fs, fs->blocksize - csum_size, dir);
@@ -56,8 +55,7 @@ errcode_t ext2fs_new_dir_block(ext2_filsys fs, ext2_ino_t dir_ino,
 	}
 
 	if (dir_ino) {
-		if (fs->super->s_feature_incompat &
-		    EXT2_FEATURE_INCOMPAT_FILETYPE)
+		if (ext2fs_has_feature_filetype(fs->super))
 			filetype = EXT2_FT_DIR;
 		/*
 		 * Set up entry for '.'
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 1d6f147..ba39e01 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -47,7 +47,7 @@ blk64_t ext2fs_descriptor_block_loc2(ext2_filsys fs, blk64_t group_block,
 	if (i == 0 && fs->blocksize == 1024 && EXT2FS_CLUSTER_RATIO(fs) > 1)
 		group_zero_adjust = 1;
 
-	if (!(fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG) ||
+	if (!ext2fs_has_feature_meta_bg(fs->super) ||
 	    (i < fs->super->s_first_meta_bg))
 		return group_block + i + 1 + group_zero_adjust;
 
@@ -269,8 +269,7 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 		}
 
 		if (!(flags & EXT2_FLAG_JOURNAL_DEV_OK) &&
-		    (fs->super->s_feature_incompat &
-		     EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)) {
+		    ext2fs_has_feature_journal_dev(fs->super)) {
 			retval = EXT2_ET_UNSUPP_FEATURE;
 			goto cleanup;
 		}
@@ -286,15 +285,13 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 	 * bigalloc requires cluster-aware bitfield operations, which at the
 	 * moment means we need EXT2_FLAG_64BITS.
 	 */
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_BIGALLOC) &&
+	if (ext2fs_has_feature_bigalloc(fs->super) &&
 	    !(flags & EXT2_FLAG_64BITS)) {
 		retval = EXT2_ET_CANT_USE_LEGACY_BITMAPS;
 		goto cleanup;
 	}
 
-	if (!EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_BIGALLOC) &&
+	if (!ext2fs_has_feature_bigalloc(fs->super) &&
 	    (fs->super->s_log_block_size != fs->super->s_log_cluster_size)) {
 		retval = EXT2_ET_CORRUPT_SUPERBLOCK;
 		goto cleanup;
@@ -306,7 +303,7 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 	}
 
 	/* Enforce the block group descriptor size */
-	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT) {
+	if (ext2fs_has_feature_64bit(fs->super)) {
 		if (fs->super->s_desc_size < EXT2_MIN_DESC_SIZE_64BIT) {
 			retval = EXT2_ET_BAD_DESC_SIZE;
 			goto cleanup;
@@ -345,8 +342,7 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 	 * If this is an external journal device, don't try to read
 	 * the group descriptors, because they're not there.
 	 */
-	if (fs->super->s_feature_incompat &
-	    EXT3_FEATURE_INCOMPAT_JOURNAL_DEV) {
+	if (ext2fs_has_feature_journal_dev(fs->super)) {
 		fs->group_desc_count = 0;
 		*ret_fs = fs;
 		return 0;
@@ -404,7 +400,7 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 #ifdef WORDS_BIGENDIAN
 	groups_per_block = EXT2_DESC_PER_BLOCK(fs->super);
 #endif
-	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG) {
+	if (ext2fs_has_feature_meta_bg(fs->super)) {
 		first_meta_bg = fs->super->s_first_meta_bg;
 		if (first_meta_bg > fs->desc_blocks)
 			first_meta_bg = fs->desc_blocks;
@@ -461,7 +457,7 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 			ext2fs_mark_super_dirty(fs);
 	}
 
-	if ((fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) &&
+	if (ext2fs_has_feature_mmp(fs->super) &&
 	    !(flags & EXT2_FLAG_SKIP_MMP) &&
 	    (flags & (EXT2_FLAG_RW | EXT2_FLAG_EXCLUSIVE))) {
 		retval = ext2fs_mmp_start(fs);
diff --git a/lib/ext2fs/read_bb.c b/lib/ext2fs/read_bb.c
index b5a0d7b..e58b7cb 100644
--- a/lib/ext2fs/read_bb.c
+++ b/lib/ext2fs/read_bb.c
@@ -76,8 +76,7 @@ errcode_t ext2fs_read_bb_inode(ext2_filsys fs, ext2_badblocks_list *bb_list)
 		if (retval)
 			return retval;
 		numblocks = inode.i_blocks;
-		if (!((fs->super->s_feature_ro_compat &
-		       EXT4_FEATURE_RO_COMPAT_HUGE_FILE) &&
+		if (!(ext2fs_has_feature_huge_file(fs->super) &&
 		      (inode.i_flags & EXT4_HUGE_FILE_FL)))
 			numblocks = numblocks / (fs->blocksize / 512);
 		numblocks += 20;
diff --git a/lib/ext2fs/res_gdt.c b/lib/ext2fs/res_gdt.c
index 46db61c..eaa9cf8 100644
--- a/lib/ext2fs/res_gdt.c
+++ b/lib/ext2fs/res_gdt.c
@@ -31,7 +31,7 @@ static unsigned int list_backups(ext2_filsys fs, unsigned int *three,
 	int mult = 3;
 	unsigned int ret;
 
-	if (fs->super->s_feature_compat & EXT4_FEATURE_COMPAT_SPARSE_SUPER2) {
+	if (ext2fs_has_feature_sparse_super2(fs->super)) {
 		if (*min == 1) {
 			*min += 1;
 			if (fs->super->s_backup_bgs[0])
@@ -44,8 +44,7 @@ static unsigned int list_backups(ext2_filsys fs, unsigned int *three,
 		}
 		return fs->group_desc_count;
 	}
-	if (!(fs->super->s_feature_ro_compat &
-	      EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER)) {
+	if (!ext2fs_has_feature_sparse_super(fs->super)) {
 		ret = *min;
 		*min += 1;
 		return ret;
diff --git a/lib/ext2fs/symlink.c b/lib/ext2fs/symlink.c
index 6e988ad..0e6f9a9 100644
--- a/lib/ext2fs/symlink.c
+++ b/lib/ext2fs/symlink.c
@@ -88,8 +88,7 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 	/* The time fields are set by ext2fs_write_new_inode() */
 
 	inlinelink = !fastlink &&
-		     (fs->super->s_feature_incompat &
-					EXT4_FEATURE_INCOMPAT_INLINE_DATA) &&
+		     ext2fs_has_feature_inline_data(fs->super) &&
 		     (target_len < fs->blocksize);
 	if (fastlink) {
 		/* Fast symlinks, target stored in inode */
@@ -114,8 +113,7 @@ errcode_t ext2fs_symlink(ext2_filsys fs, ext2_ino_t parent, ext2_ino_t ino,
 need_block:
 		/* Slow symlinks, target stored in the first block */
 		ext2fs_iblk_set(fs, &inode, 1);
-		if (fs->super->s_feature_incompat &
-		    EXT3_FEATURE_INCOMPAT_EXTENTS) {
+		if (ext2fs_has_feature_extents(fs->super)) {
 			/*
 			 * The extent bmap is setup after the inode and block
 			 * have been written out below.
diff --git a/lib/support/quotaio.c b/lib/support/quotaio.c
index 3af82f7..d30c980 100644
--- a/lib/support/quotaio.c
+++ b/lib/support/quotaio.c
@@ -284,8 +284,7 @@ static errcode_t quota_inode_init_new(ext2_filsys fs, ext2_ino_t ino)
 	inode.i_links_count = 1;
 	inode.i_mode = LINUX_S_IFREG | 0600;
 	inode.i_flags |= EXT2_IMMUTABLE_FL;
-	if (fs->super->s_feature_incompat &
-			EXT3_FEATURE_INCOMPAT_EXTENTS)
+	if (ext2fs_has_feature_extents(fs->super))
 		inode.i_flags |= EXT4_EXTENTS_FL;
 
 	err = ext2fs_write_new_inode(fs, ino, &inode);

