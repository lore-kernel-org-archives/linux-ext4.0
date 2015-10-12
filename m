From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 06/12] resize2fs: clean up feature test macros with
 predicate functions
Date: Mon, 12 Oct 2015 14:57:07 -0700
Message-ID: <20151012215707.29065.22042.stgit@birch.djwong.org>
References: <20151012215629.29065.24418.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40130 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbbJLV5L (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Oct 2015 17:57:11 -0400
In-Reply-To: <20151012215629.29065.24418.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Create separate predicate functions to test/set/clear feature flags,
thereby replacing the wordy old macros.  Furthermore, clean out the
places where we open-coded feature tests.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 resize/main.c      |   13 ++++------
 resize/online.c    |   11 +++-----
 resize/resize2fs.c |   70 +++++++++++++++++++++-------------------------------
 3 files changed, 37 insertions(+), 57 deletions(-)


diff --git a/resize/main.c b/resize/main.c
index 3be458f..f25df40 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -158,8 +158,7 @@ static void determine_fs_stride(ext2_filsys fs)
 
 static void bigalloc_check(ext2_filsys fs, int force)
 {
-	if (!force && EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				EXT4_FEATURE_RO_COMPAT_BIGALLOC)) {
+	if (!force && ext2fs_has_feature_bigalloc(fs->super)) {
 		fprintf(stderr, "%s", _("\nResizing bigalloc file systems has "
 					"not been fully tested.  Proceed at\n"
 					"your own risk!  Use the force option "
@@ -511,8 +510,7 @@ int main (int argc, char ** argv)
 	if (flags & (RESIZE_DISABLE_64BIT | RESIZE_ENABLE_64BIT)) {
 		new_size = ext2fs_blocks_count(fs->super);
 	}
-	if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_INCOMPAT_64BIT)) {
+	if (!ext2fs_has_feature_64bit(fs->super)) {
 		/* Take 16T down to 2^32-1 blocks */
 		if (new_size == (1ULL << 32))
 			new_size--;
@@ -578,8 +576,7 @@ int main (int argc, char ** argv)
 			exit(1);
 		}
 		if (flags & RESIZE_ENABLE_64BIT &&
-		    !EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-				EXT3_FEATURE_INCOMPAT_EXTENTS)) {
+		    !ext2fs_has_feature_extents(fs->super)) {
 			fprintf(stderr, _("Please enable the extents feature "
 				"with tune2fs before enabling the 64bit "
 				"feature.\n"));
@@ -592,12 +589,12 @@ int main (int argc, char ** argv)
 		exit(0);
 	}
 	if ((flags & RESIZE_ENABLE_64BIT) &&
-	    EXT2_HAS_INCOMPAT_FEATURE(fs->super, EXT4_FEATURE_INCOMPAT_64BIT)) {
+	    ext2fs_has_feature_64bit(fs->super)) {
 		fprintf(stderr, _("The filesystem is already 64-bit.\n"));
 		exit(0);
 	}
 	if ((flags & RESIZE_DISABLE_64BIT) &&
-	    !EXT2_HAS_INCOMPAT_FEATURE(fs->super, EXT4_FEATURE_INCOMPAT_64BIT)) {
+	    !ext2fs_has_feature_64bit(fs->super)) {
 		fprintf(stderr, _("The filesystem is already 32-bit.\n"));
 		exit(0);
 	}
diff --git a/resize/online.c b/resize/online.c
index 46d86b0..9a4d828 100644
--- a/resize/online.c
+++ b/resize/online.c
@@ -76,8 +76,7 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
 			no_resize_ioctl = 1;
 	}
 
-	if (EXT2_HAS_COMPAT_FEATURE(fs->super,
-				    EXT4_FEATURE_COMPAT_SPARSE_SUPER2) &&
+	if (ext2fs_has_feature_sparse_super2(fs->super) &&
 	    (access("/sys/fs/ext4/features/sparse_super2", R_OK) != 0)) {
 		com_err(program_name, 0, _("kernel does not support online "
 					   "resize with sparse_super2"));
@@ -109,16 +108,14 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
 	 */
 	if ((access("/sys/fs/ext4/features/meta_bg_resize", R_OK) != 0) ||
 	    no_meta_bg_resize) {
-		if (!EXT2_HAS_COMPAT_FEATURE(fs->super,
-					EXT2_FEATURE_COMPAT_RESIZE_INODE) &&
+		if (!ext2fs_has_feature_resize_inode(fs->super) &&
 		    (new_desc_blocks != fs->desc_blocks)) {
 			com_err(program_name, 0,
 				_("Filesystem does not support online resizing"));
 			exit(1);
 		}
 
-		if (EXT2_HAS_COMPAT_FEATURE(fs->super,
-					EXT2_FEATURE_COMPAT_RESIZE_INODE) &&
+		if (ext2fs_has_feature_resize_inode(fs->super) &&
 		    new_desc_blocks > (fs->desc_blocks +
 				       fs->super->s_reserved_gdt_blocks)) {
 			com_err(program_name, 0,
@@ -213,7 +210,7 @@ errcode_t online_resize_fs(ext2_filsys fs, const char *mtpt,
 	 * the layout advantages of flex_bg in the new block groups,
 	 * but at least it allows on-line resizing to function.
 	 */
-	new_fs->super->s_feature_incompat &= ~EXT4_FEATURE_INCOMPAT_FLEX_BG;
+	ext2fs_clear_feature_flex_bg(new_fs->super);
 	retval = adjust_fs_info(new_fs, fs, 0, *new_size);
 	if (retval) {
 		close(fd);
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 07c6a0c..f8df679 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -258,8 +258,7 @@ errout:
 /* Keep the size of the group descriptor region constant */
 static void adjust_reserved_gdt_blocks(ext2_filsys old_fs, ext2_filsys fs)
 {
-	if ((fs->super->s_feature_compat &
-	     EXT2_FEATURE_COMPAT_RESIZE_INODE) &&
+	if (ext2fs_has_feature_resize_inode(fs->super) &&
 	    (old_fs->desc_blocks != fs->desc_blocks)) {
 		int new;
 
@@ -291,12 +290,10 @@ static errcode_t resize_group_descriptors(ext2_resize_t rfs, blk64_t new_size)
 		return EXT2_ET_INVALID_ARGUMENT;
 
 	if (rfs->flags & RESIZE_DISABLE_64BIT) {
-		rfs->new_fs->super->s_feature_incompat &=
-				~EXT4_FEATURE_INCOMPAT_64BIT;
+		ext2fs_clear_feature_64bit(rfs->new_fs->super);
 		rfs->new_fs->super->s_desc_size = EXT2_MIN_DESC_SIZE;
 	} else if (rfs->flags & RESIZE_ENABLE_64BIT) {
-		rfs->new_fs->super->s_feature_incompat |=
-				EXT4_FEATURE_INCOMPAT_64BIT;
+		ext2fs_set_feature_64bit(rfs->new_fs->super);
 		rfs->new_fs->super->s_desc_size = EXT2_MIN_DESC_SIZE_64BIT;
 	}
 
@@ -358,8 +355,7 @@ static errcode_t move_bg_metadata(ext2_resize_t rfs)
 	if (retval)
 		goto out;
 
-	if (EXT2_HAS_INCOMPAT_FEATURE(rfs->old_fs->super,
-				      EXT2_FEATURE_INCOMPAT_META_BG)) {
+	if (ext2fs_has_feature_meta_bg(rfs->old_fs->super)) {
 		old_desc_blocks = rfs->old_fs->super->s_first_meta_bg;
 		new_desc_blocks = rfs->new_fs->super->s_first_meta_bg;
 	} else {
@@ -820,10 +816,9 @@ retry:
 	if (EXT2_DESC_SIZE(old_fs->super) == EXT2_DESC_SIZE(fs->super))
 		adjust_reserved_gdt_blocks(old_fs, fs);
 
-	if ((fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG) &&
+	if (ext2fs_has_feature_meta_bg(fs->super) &&
 	    (fs->super->s_first_meta_bg > fs->desc_blocks)) {
-		fs->super->s_feature_incompat &=
-			~EXT2_FEATURE_INCOMPAT_META_BG;
+		ext2fs_clear_feature_meta_bg(fs->super);
 		fs->super->s_first_meta_bg = 0;
 	}
 
@@ -831,7 +826,7 @@ retry:
 	 * Update the location of the backup superblocks if the
 	 * sparse_super2 feature is enabled.
 	 */
-	if (fs->super->s_feature_compat & EXT4_FEATURE_COMPAT_SPARSE_SUPER2) {
+	if (ext2fs_has_feature_sparse_super2(fs->super)) {
 		dgrp_t last_bg = fs->group_desc_count - 1;
 		dgrp_t old_last_bg = old_fs->group_desc_count - 1;
 
@@ -907,7 +902,7 @@ retry:
 	if (!getenv("RESIZE2FS_FORCE_ITABLE_INIT") &&
 	    access("/sys/fs/ext4/features/lazy_itable_init", F_OK) == 0)
 		lazy_itable_init = 1;
-	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
+	if (ext2fs_has_feature_meta_bg(fs->super))
 		old_desc_blocks = fs->super->s_first_meta_bg;
 	else
 		old_desc_blocks = fs->desc_blocks +
@@ -948,8 +943,7 @@ retry:
 		}
 		meta_bg_size = EXT2_DESC_PER_BLOCK(fs->super);
 		meta_bg = i / meta_bg_size;
-		if (!(fs->super->s_feature_incompat &
-		      EXT2_FEATURE_INCOMPAT_META_BG) ||
+		if (!ext2fs_has_feature_meta_bg(fs->super) ||
 		    (meta_bg < fs->super->s_first_meta_bg)) {
 			if (has_super) {
 				for (j=0; j < old_desc_blocks; j++)
@@ -1197,7 +1191,7 @@ static void mark_fs_metablock(ext2_resize_t rfs,
 		rfs->needed_blocks++;
 		return;
 	}
-	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_FLEX_BG) {
+	if (ext2fs_has_feature_flex_bg(fs->super)) {
 		dgrp_t i;
 
 		for (i=0; i < rfs->old_fs->group_desc_count; i++) {
@@ -1333,12 +1327,12 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 		ext2fs_mark_block_bitmap2(rfs->reserve_blocks, blk);
 	}
 
-	if (old_fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
+	if (ext2fs_has_feature_meta_bg(old_fs->super))
 		old_blocks = old_fs->super->s_first_meta_bg;
 	else
 		old_blocks = old_fs->desc_blocks +
 			old_fs->super->s_reserved_gdt_blocks;
-	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
+	if (ext2fs_has_feature_meta_bg(fs->super))
 		new_blocks = fs->super->s_first_meta_bg;
 	else
 		new_blocks = fs->desc_blocks + fs->super->s_reserved_gdt_blocks;
@@ -1411,8 +1405,7 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 	 * gets interesting....
 	 */
 	meta_bg_size = EXT2_DESC_PER_BLOCK(fs->super);
-	flex_bg = fs->super->s_feature_incompat &
-		EXT4_FEATURE_INCOMPAT_FLEX_BG;
+	flex_bg = ext2fs_has_feature_flex_bg(fs->super);
 	/* first reserve all of the existing fs meta blocks */
 	for (i = 0; i < max_groups; i++) {
 		has_super = ext2fs_bg_has_super(fs, i);
@@ -1420,8 +1413,7 @@ static errcode_t blocks_to_move(ext2_resize_t rfs)
 			mark_fs_metablock(rfs, meta_bmap, i, group_blk);
 
 		meta_bg = i / meta_bg_size;
-		if (!(fs->super->s_feature_incompat &
-		      EXT2_FEATURE_INCOMPAT_META_BG) ||
+		if (!ext2fs_has_feature_meta_bg(fs->super) ||
 		    (meta_bg < fs->super->s_first_meta_bg)) {
 			if (has_super) {
 				for (blk = group_blk+1;
@@ -1886,8 +1878,7 @@ static errcode_t migrate_ea_block(ext2_resize_t rfs, ext2_ino_t ino,
 	ext2fs_file_acl_block_set(rfs->old_fs, inode, new_block);
 
 	/* Update checksum */
-	if (EXT2_HAS_RO_COMPAT_FEATURE(rfs->new_fs->super,
-			EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
+	if (ext2fs_has_feature_metadata_csum(rfs->new_fs->super)) {
 		err = ext2fs_get_mem(rfs->old_fs->blocksize, &buf);
 		if (err)
 			return err;
@@ -2076,8 +2067,7 @@ remap_blocks:
 			goto errout;
 
 		/* Rewrite extent block checksums with new inode number */
-		if (EXT2_HAS_RO_COMPAT_FEATURE(rfs->old_fs->super,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+		if (ext2fs_has_feature_metadata_csum(rfs->old_fs->super) &&
 		    (inode->i_flags & EXT4_EXTENTS_FL)) {
 			rfs->old_fs->flags |= EXT2_FLAG_IGNORE_CSUM_ERRORS;
 			retval = rewrite_extents(rfs->old_fs, new_inode);
@@ -2172,8 +2162,7 @@ static int check_and_change_inodes(ext2_ino_t dir,
 	 * If we have checksums enabled and the inode wasn't present in the
 	 * old fs, then we must rewrite all dir blocks with new checksums.
 	 */
-	if (EXT2_HAS_RO_COMPAT_FEATURE(is->rfs->old_fs->super,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+	if (ext2fs_has_feature_metadata_csum(is->rfs->old_fs->super) &&
 	    !ext2fs_test_inode_bitmap2(is->rfs->old_fs->inode_map, dir))
 		ret |= DIRENT_CHANGED;
 
@@ -2442,7 +2431,7 @@ static errcode_t clear_sparse_super2_last_group(ext2_resize_t rfs)
 	blk64_t		sb, old_desc;
 	blk_t		num;
 
-	if (!(fs->super->s_feature_compat & EXT4_FEATURE_COMPAT_SPARSE_SUPER2))
+	if (!ext2fs_has_feature_sparse_super2(fs->super))
 		return 0;
 
 	if (last_bg <= old_last_bg)
@@ -2492,7 +2481,7 @@ static errcode_t reserve_sparse_super2_last_group(ext2_resize_t rfs,
 	blk_t		i, num;
 	int		realloc = 0;
 
-	if (!(fs->super->s_feature_compat & EXT4_FEATURE_COMPAT_SPARSE_SUPER2))
+	if (!ext2fs_has_feature_sparse_super2(fs->super))
 		return 0;
 
 	if (last_bg >= old_last_bg)
@@ -2576,8 +2565,7 @@ static errcode_t fix_resize_inode(ext2_filsys fs)
 	struct ext2_inode	inode;
 	errcode_t		retval;
 
-	if (!(fs->super->s_feature_compat &
-	      EXT2_FEATURE_COMPAT_RESIZE_INODE))
+	if (!ext2fs_has_feature_resize_inode(fs->super))
 		return 0;
 
 	retval = ext2fs_read_inode(fs, EXT2_RESIZE_INO, &inode);
@@ -2634,7 +2622,7 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 	uninit = ext2fs_bg_flags_test(fs, group, EXT2_BG_BLOCK_UNINIT);
 	ext2fs_super_and_bgd_loc2(fs, group, &super_blk, &old_desc_blk,
 				  &new_desc_blk, 0);
-	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
+	if (ext2fs_has_feature_meta_bg(fs->super))
 		old_desc_blocks = fs->super->s_first_meta_bg;
 	else
 		old_desc_blocks = fs->desc_blocks +
@@ -2671,8 +2659,7 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 			ext2fs_super_and_bgd_loc2(fs, group, &super_blk,
 						  &old_desc_blk,
 						  &new_desc_blk, 0);
-			if (fs->super->s_feature_incompat &
-			    EXT2_FEATURE_INCOMPAT_META_BG)
+			if (ext2fs_has_feature_meta_bg(fs->super))
 				old_desc_blocks = fs->super->s_first_meta_bg;
 			else
 				old_desc_blocks = fs->desc_blocks +
@@ -2724,7 +2711,7 @@ static errcode_t fix_sb_journal_backup(ext2_filsys fs)
 	errcode_t	  retval;
 	struct ext2_inode inode;
 
-	if (!(fs->super->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL))
+	if (!ext2fs_has_feature_journal(fs->super))
 		return 0;
 
 	/* External journal? Nothing to do. */
@@ -2796,7 +2783,7 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
 	/*
 	 * number of old-style block group descriptor blocks
 	 */
-	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG)
+	if (ext2fs_has_feature_meta_bg(fs->super))
 		old_desc_blocks = fs->super->s_first_meta_bg;
 	else
 		old_desc_blocks = fs->desc_blocks +
@@ -2819,7 +2806,7 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
 	 * guaranteed to finish.
 	 */
 	flex_groups = groups;
-	if (fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_FLEX_BG) {
+	if (ext2fs_has_feature_flex_bg(fs->super)) {
 		dgrp_t remainder = groups & (flexbg_size - 1);
 
 		flex_groups += flexbg_size - remainder;
@@ -2877,8 +2864,7 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
 
 		grp = flex_groups;
 		groups += extra_grps;
-		if (!(fs->super->s_feature_incompat &
-		      EXT4_FEATURE_INCOMPAT_FLEX_BG))
+		if (!ext2fs_has_feature_flex_bg(fs->super))
 			flex_groups = groups;
 		else if (groups > flex_groups) {
 			dgrp_t r = groups & (flexbg_size - 1);
@@ -2914,7 +2900,7 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
 
 	/* now for the fun voodoo */
 	grp = groups - 1;
-	if ((fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_FLEX_BG) &&
+	if (ext2fs_has_feature_flex_bg(fs->super) &&
 	    (grp & ~(flexbg_size - 1)) == 0)
 		grp = grp & ~(flexbg_size - 1);
 	overhead = 0;
@@ -3000,7 +2986,7 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
 	 * with each data block needs to be in its own extent, and
 	 * with each inode needing at least one extent block.
 	 */
-	if (fs->super->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS) {
+	if (ext2fs_has_feature_extents(fs->super)) {
 		blk64_t safe_margin = (ext2fs_blocks_count(fs->super) -
 				       blks_needed)/500;
 		unsigned int exts_per_blk = (fs->blocksize /

