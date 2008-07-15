From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: [PATCH 15/15][e2fsprogs] 64-bit mke2fs cleanup
Date: Tue, 15 Jul 2008 11:51:29 -0500
Message-ID: <20080715165129.28567.7837.stgit@ichigo>
References: <20080715164332.28567.27913.stgit@ichigo>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: "Jose R. Santos" <jrs@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:54363 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758295AbYGOQvn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Jul 2008 12:51:43 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e32.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6FGkCNZ024974
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 12:46:12 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6FGpUEQ033992
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 10:51:33 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6FGpUs7011092
	for <linux-ext4@vger.kernel.org>; Tue, 15 Jul 2008 10:51:30 -0600
In-Reply-To: <20080715164332.28567.27913.stgit@ichigo>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Jose R. Santos <jrs@us.ibm.com>

64-bit mke2fs cleanup

Use 64-bit interfaces in mke2fs.  This should be most most of whats
needed to support creating a 64-bit filesystem.  Things missing:

- 64-bit bitmap support being developed by Ted.  We cant make a 64bit
  fs without this.

- 64-bit badblock interface.  Waiting on Ted 64-bit bitmap patches to
  shamelessly steel some of his code. (particularly, the handling of
  different interface through the structure magic numbers)

  This is not needed to create a 64-bit filesystem, but you cant have
  bad blocks above the 32bit block number boundary.

- lost+found and journal file are not created as extent mapped files.
  Should not prevent from creating a 64-bit filesystem and since those
  are typically at the beginning of the disk, don't know if I should
  really care.  Don't know much about the extent format to know for sure.

Signed-off-by: Jose R. Santos <jrs@us.ibm.com>
--

 lib/ext2fs/alloc_tables.c |   77 +++++++++++++++++++++++++--------------------
 lib/ext2fs/initialize.c   |   36 ++++++++++++---------
 misc/mke2fs.c             |   48 +++++++++++++++-------------
 3 files changed, 89 insertions(+), 72 deletions(-)

diff --git a/lib/ext2fs/alloc_tables.c b/lib/ext2fs/alloc_tables.c
index 8c0ecfc..3f7b454 100644
--- a/lib/ext2fs/alloc_tables.c
+++ b/lib/ext2fs/alloc_tables.c
@@ -33,11 +33,11 @@
  * block number with a correct offset were the bitmaps and inode
  * tables can be allocated continously and in order.
  */
-static blk_t flexbg_offset(ext2_filsys fs, dgrp_t group, blk_t start_blk,
+static blk64_t flexbg_offset(ext2_filsys fs, dgrp_t group, blk_t start_blk,
 			   ext2fs_block_bitmap bmap, int offset, int size)
 {
 	int		flexbg, flexbg_size, elem_size;
-	blk_t		last_blk, first_free = 0;
+	blk64_t		last_blk, first_free = 0;
 	dgrp_t	       	last_grp;
 
 	flexbg_size = 1 << fs->super->s_log_groups_per_flex;
@@ -70,11 +70,11 @@ static blk_t flexbg_offset(ext2_filsys fs, dgrp_t group, blk_t start_blk,
 	last_blk = ext2fs_group_last_block(fs, last_grp);
 
 	/* Find the first available block */
-	if (ext2fs_get_free_blocks(fs, start_blk, last_blk, 1, bmap,
+	if (ext2fs_get_free_blocks2(fs, start_blk, last_blk, 1, bmap,
 				   &first_free))
 		return first_free;
 
-	if (ext2fs_get_free_blocks(fs, first_free + offset, last_blk, size,
+	if (ext2fs_get_free_blocks2(fs, first_free + offset, last_blk, size,
 				   bmap, &first_free))
 		return first_free;
 
@@ -85,12 +85,12 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 				      ext2fs_block_bitmap bmap)
 {
 	errcode_t	retval;
-	blk_t		group_blk, start_blk, last_blk, new_blk, blk;
+	blk64_t		group_blk, start_blk, last_blk, new_blk, blk;
 	dgrp_t		last_grp = 0;
 	int		j, rem_grps = 0, flexbg_size = 0;
 
-	group_blk = ext2fs_group_first_block(fs, group);
-	last_blk = ext2fs_group_last_block(fs, group);
+	group_blk = ext2fs_group_first_block2(fs, group);
+	last_blk = ext2fs_group_last_block2(fs, group);
 
 	if (!bmap)
 		bmap = fs->block_map;
@@ -109,8 +109,8 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 	 * Allocate the block and inode bitmaps, if necessary
 	 */
 	if (fs->stride) {
-		retval = ext2fs_get_free_blocks(fs, group_blk, last_blk,
-						1, bmap, &start_blk);
+		retval = ext2fs_get_free_blocks2(fs, group_blk, last_blk,
+						 1, bmap, &start_blk);
 		if (retval)
 			return retval;
 		start_blk += fs->inode_blocks_per_group;
@@ -123,27 +123,30 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 
 	if (flexbg_size) {
 		int prev_block = 0;
-		if (group && fs->group_desc[group-1].bg_block_bitmap)
-			prev_block = fs->group_desc[group-1].bg_block_bitmap;
+		if (group && ext2fs_block_bitmap_loc(fs, group - 1))
+			prev_block = ext2fs_block_bitmap_loc(fs, group - 1);
 		start_blk = flexbg_offset(fs, group, prev_block, bmap,
 						 0, rem_grps);
-		last_blk = ext2fs_group_last_block(fs, last_grp);
+		last_blk = ext2fs_group_last_block2(fs, last_grp);
 	}
 
 	if (!fs->group_desc[group].bg_block_bitmap) {
-		retval = ext2fs_get_free_blocks(fs, start_blk, last_blk,
-						1, bmap, &new_blk);
+		retval = ext2fs_get_free_blocks2(fs, start_blk, last_blk,
+						 1, bmap, &new_blk);
 		if (retval == EXT2_ET_BLOCK_ALLOC_FAIL) 
-			retval = ext2fs_get_free_blocks(fs, group_blk,
+			retval = ext2fs_get_free_blocks2(fs, group_blk,
 					last_blk, 1, bmap, &new_blk);
 		if (retval)
 			return retval;
+		/* FIXME-64 */
 		ext2fs_mark_block_bitmap(bmap, new_blk);
-		fs->group_desc[group].bg_block_bitmap = new_blk;
+		ext2fs_block_bitmap_loc_set(fs, group, new_blk);
 		if (flexbg_size) {
-			dgrp_t gr = ext2fs_group_of_blk(fs, new_blk);
+			dgrp_t gr = ext2fs_group_of_blk2(fs, new_blk);
 			fs->group_desc[gr].bg_free_blocks_count--;
-			fs->super->s_free_blocks_count--;
+			ext2fs_free_blocks_count_set(fs->super,
+						     ext2fs_free_blocks_count(
+							     fs->super) - 1);
 			fs->group_desc[gr].bg_flags &= ~EXT2_BG_BLOCK_UNINIT;
 			ext2fs_group_desc_csum_set(fs, gr);
 		}
@@ -151,27 +154,30 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 
 	if (flexbg_size) {
 		int prev_block = 0;
-		if (group && fs->group_desc[group-1].bg_inode_bitmap)
-			prev_block = fs->group_desc[group-1].bg_inode_bitmap;
+		if (group && ext2fs_inode_bitmap_loc(fs, group - 1))
+			prev_block = ext2fs_inode_bitmap_loc(fs, group - 1);
 		start_blk = flexbg_offset(fs, group, prev_block, bmap,
 						 flexbg_size, rem_grps);
-		last_blk = ext2fs_group_last_block(fs, last_grp);
+		last_blk = ext2fs_group_last_block2(fs, last_grp);
 	}
 
 	if (!fs->group_desc[group].bg_inode_bitmap) {
-		retval = ext2fs_get_free_blocks(fs, start_blk, last_blk,
-						1, bmap, &new_blk);
+		retval = ext2fs_get_free_blocks2(fs, start_blk, last_blk,
+						 1, bmap, &new_blk);
 		if (retval == EXT2_ET_BLOCK_ALLOC_FAIL) 
-			retval = ext2fs_get_free_blocks(fs, group_blk,
+			retval = ext2fs_get_free_blocks2(fs, group_blk,
 					last_blk, 1, bmap, &new_blk);
 		if (retval)
 			return retval;
+		/* FIXME-64 */
 		ext2fs_mark_block_bitmap(bmap, new_blk);
-		fs->group_desc[group].bg_inode_bitmap = new_blk;
+		ext2fs_inode_bitmap_loc_set(fs, group, new_blk);
 		if (flexbg_size) {
-			dgrp_t gr = ext2fs_group_of_blk(fs, new_blk);
+			dgrp_t gr = ext2fs_group_of_blk2(fs, new_blk);
 			fs->group_desc[gr].bg_free_blocks_count--;
-			fs->super->s_free_blocks_count--;
+			ext2fs_free_blocks_count_set(fs->super,
+						     ext2fs_free_blocks_count(
+							     fs->super) - 1);
 			fs->group_desc[gr].bg_flags &= ~EXT2_BG_BLOCK_UNINIT;
 			ext2fs_group_desc_csum_set(fs, gr);
 		}
@@ -182,17 +188,17 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 	 */
 	if (flexbg_size) {
 		int prev_block = 0;
-		if (group && fs->group_desc[group-1].bg_inode_table)
-			prev_block = fs->group_desc[group-1].bg_inode_table;
+		if (group && ext2fs_inode_table_loc(fs, group - 1))
+			prev_block = ext2fs_inode_table_loc(fs, group - 1);
 		group_blk = flexbg_offset(fs, group, prev_block, bmap,
 						 flexbg_size * 2,
 						 fs->inode_blocks_per_group *
 						 rem_grps);
-		last_blk = ext2fs_group_last_block(fs, last_grp);
+		last_blk = ext2fs_group_last_block2(fs, last_grp);
 	}
 
 	if (!fs->group_desc[group].bg_inode_table) {
-		retval = ext2fs_get_free_blocks(fs, group_blk, last_blk,
+		retval = ext2fs_get_free_blocks2(fs, group_blk, last_blk,
 						fs->inode_blocks_per_group,
 						bmap, &new_blk);
 		if (retval)
@@ -200,16 +206,19 @@ errcode_t ext2fs_allocate_group_table(ext2_filsys fs, dgrp_t group,
 		for (j=0, blk = new_blk;
 		     j < fs->inode_blocks_per_group;
 		     j++, blk++) {
+			/* FIXME-64 */
 			ext2fs_mark_block_bitmap(bmap, blk);
 			if (flexbg_size) {
-				dgrp_t gr = ext2fs_group_of_blk(fs, blk);
+				dgrp_t gr = ext2fs_group_of_blk2(fs, blk);
 				fs->group_desc[gr].bg_free_blocks_count--;
-				fs->super->s_free_blocks_count--;
+				ext2fs_free_blocks_count_set(fs->super,
+							     ext2fs_free_blocks_count(
+								     fs->super) - 1);
 				fs->group_desc[gr].bg_flags &= ~EXT2_BG_BLOCK_UNINIT;
 				ext2fs_group_desc_csum_set(fs, gr);
 			}
 		}
-		fs->group_desc[group].bg_inode_table = new_blk;
+		ext2fs_inode_table_loc_set(fs, group, new_blk);
 	}
 	ext2fs_group_desc_csum_set(fs, group);
 	return 0;
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index e9bfe49..5060fda 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -75,8 +75,8 @@ static unsigned int calc_reserved_gdt_blocks(ext2_filsys fs)
 	/* We set it at 1024x the current filesystem size, or
 	 * the upper block count limit (2^32), whichever is lower.
 	 */
-	if (sb->s_blocks_count < max_blocks / 1024)
-		max_blocks = sb->s_blocks_count * 1024;
+	if (ext2fs_blocks_count(sb) < max_blocks / 1024)
+		max_blocks = ext2fs_blocks_count(sb) * 1024;
 	rsv_groups = ext2fs_div_ceil(max_blocks - sb->s_first_data_block, bpg);
 	rsv_gdb = ext2fs_div_ceil(rsv_groups, gdpb) - fs->desc_blocks;
 	if (rsv_gdb > EXT2_ADDR_PER_BLOCK(sb))
@@ -108,7 +108,7 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	char		*buf = 0;
 	char		c;
 
-	if (!param || !param->s_blocks_count)
+	if (!param || !ext2fs_blocks_count(param))
 		return EXT2_ET_INVALID_ARGUMENT;
 	
 	retval = ext2fs_get_mem(sizeof(struct struct_ext2_filsys), &fs);
@@ -200,9 +200,9 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 		super->s_blocks_per_group = EXT2_MAX_BLOCKS_PER_GROUP(super);
 	super->s_frags_per_group = super->s_blocks_per_group * frags_per_block;
 	
-	super->s_blocks_count = param->s_blocks_count;
-	super->s_r_blocks_count = param->s_r_blocks_count;
-	if (super->s_r_blocks_count >= param->s_blocks_count) {
+	ext2fs_blocks_count_set(super, param->s_blocks_count);
+	ext2fs_r_blocks_count_set(super, param->s_r_blocks_count);
+	if (ext2fs_r_blocks_count(super) >= ext2fs_blocks_count(param)) {
 		retval = EXT2_ET_INVALID_ARGUMENT;
 		goto cleanup;
 	}
@@ -219,9 +219,9 @@ errcode_t ext2fs_initialize(const char *name, int flags,
 	}
 
 retry:
-	fs->group_desc_count = ext2fs_div_ceil(super->s_blocks_count -
-					       super->s_first_data_block,
-					       EXT2_BLOCKS_PER_GROUP(super));
+	fs->group_desc_count = (blk_t) ext2fs_div64_ceil(
+		ext2fs_blocks_count(super) - super->s_first_data_block,
+		EXT2_BLOCKS_PER_GROUP(super));
 	if (fs->group_desc_count == 0) {
 		retval = EXT2_ET_TOOSMALL;
 		goto cleanup;
@@ -230,7 +230,8 @@ retry:
 					  EXT2_DESC_PER_BLOCK(super));
 
 	i = fs->blocksize >= 4096 ? 1 : 4096 / fs->blocksize;
-	set_field(s_inodes_count, super->s_blocks_count / i);
+	/* FIXME-64 */
+	set_field(s_inodes_count, ext2fs_blocks_count(super) / i);
 
 	/*
 	 * Make sure we have at least EXT2_FIRST_INO + 1 inodes, so
@@ -250,7 +251,8 @@ retry:
 		if (super->s_blocks_per_group >= 256) {
 			/* Try again with slightly different parameters */
 			super->s_blocks_per_group -= 8;
-			super->s_blocks_count = param->s_blocks_count;
+			ext2fs_blocks_count_set(super,
+						ext2fs_blocks_count(param));
 			super->s_frags_per_group = super->s_blocks_per_group *
 				frags_per_block;
 			goto retry;
@@ -334,12 +336,14 @@ ipg_retry:
 	overhead = (int) (2 + fs->inode_blocks_per_group);
 	if (ext2fs_bg_has_super(fs, fs->group_desc_count - 1))
 		overhead += 1 + fs->desc_blocks + super->s_reserved_gdt_blocks;
-	rem = ((super->s_blocks_count - super->s_first_data_block) %
+	rem = ((ext2fs_blocks_count(super) - super->s_first_data_block) %
 	       super->s_blocks_per_group);
 	if ((fs->group_desc_count == 1) && rem && (rem < overhead))
 		return EXT2_ET_TOOSMALL;
 	if (rem && (rem < overhead+50)) {
-		super->s_blocks_count -= rem;
+		ext2fs_blocks_count_set(super, ext2fs_blocks_count(super) +
+					rem);
+
 		goto retry;
 	}
 
@@ -383,7 +387,7 @@ ipg_retry:
 	 * superblock and group descriptors (the inode tables and
 	 * bitmaps will be accounted for when allocated).
 	 */
-	super->s_free_blocks_count = 0;
+	ext2fs_free_blocks_count_set(super, 0);
 	csum_flag = EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
 					       EXT4_FEATURE_RO_COMPAT_GDT_CSUM);
 	for (i = 0; i < fs->group_desc_count; i++) {
@@ -405,7 +409,9 @@ ipg_retry:
 		if (fs->super->s_log_groups_per_flex)
 			numblocks += 2 + fs->inode_blocks_per_group;
 
-		super->s_free_blocks_count += numblocks;
+		ext2fs_free_blocks_count_set(super,
+					     ext2fs_free_blocks_count(super) +
+					     numblocks);
 		fs->group_desc[i].bg_free_blocks_count = numblocks;
 		fs->group_desc[i].bg_free_inodes_count =
 			fs->super->s_inodes_per_group;
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 7171990..817be56 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -348,7 +348,7 @@ static void progress_close(struct progress_struct *progress)
 static void write_inode_tables(ext2_filsys fs, int lazy_flag)
 {
 	errcode_t	retval;
-	blk_t		blk;
+	blk64_t		blk;
 	dgrp_t		i;
 	int		num, ipb;
 	struct progress_struct progress;
@@ -362,7 +362,7 @@ static void write_inode_tables(ext2_filsys fs, int lazy_flag)
 	for (i = 0; i < fs->group_desc_count; i++) {
 		progress_update(&progress, i);
 		
-		blk = fs->group_desc[i].bg_inode_table;
+		blk = ext2fs_inode_table_loc(fs, i);
 		num = fs->inode_blocks_per_group;
 
 		if (lazy_flag) {
@@ -377,10 +377,10 @@ static void write_inode_tables(ext2_filsys fs, int lazy_flag)
 			fs->group_desc[i].bg_flags |= EXT2_BG_INODE_ZEROED;
 			ext2fs_group_desc_csum_set(fs, i);
 		}
-		retval = ext2fs_zero_blocks(fs, blk, num, &blk, &num);
+		retval = ext2fs_zero_blocks2(fs, blk, num, &blk, &num);
 		if (retval) {
 			fprintf(stderr, _("\nCould not write %d "
-				  "blocks in inode table starting at %u: %s\n"),
+				  "blocks in inode table starting at %ull: %s\n"),
 				num, blk, error_message(retval));
 			exit(1);
 		}
@@ -511,7 +511,7 @@ static void zap_sector(ext2_filsys fs, int sect, int nsect)
 
 	if (sect == 0) {
 		/* Check for a BSD disklabel, and don't erase it if so */
-		retval = io_channel_read_blk(fs->io, 0, -512, buf);
+		retval = io_channel_read_blk64(fs->io, 0, -512, buf);
 		if (retval)
 			fprintf(stderr,
 				_("Warning: could not read block 0: %s\n"),
@@ -1074,7 +1074,7 @@ static void PRS(int argc, char *argv[])
 	char *		extended_opts = 0;
 	const char *	fs_type = 0;
 	const char *	usage_types = 0;
-	blk_t		dev_size;
+	blk64_t		dev_size;
 #ifdef __linux__
 	struct 		utsname ut;
 #endif
@@ -1402,12 +1402,12 @@ static void PRS(int argc, char *argv[])
 
 	fs_param.s_log_frag_size = fs_param.s_log_block_size;
 
-	if (noaction && fs_param.s_blocks_count) {
-		dev_size = fs_param.s_blocks_count;
+	if (noaction && ext2fs_blocks_count(&fs_param)) {
+		dev_size = ext2fs_blocks_count(&fs_param);
 		retval = 0;
 	} else {
 	retry:
-		retval = ext2fs_get_device_size(device_name,
+		retval = ext2fs_get_device_size2(device_name,
 						EXT2_BLOCK_SIZE(&fs_param),
 						&dev_size);
 		if ((retval == EFBIG) &&
@@ -1431,7 +1431,7 @@ static void PRS(int argc, char *argv[])
 			_("while trying to determine filesystem size"));
 		exit(1);
 	}
-	if (!fs_param.s_blocks_count) {
+	if (!ext2fs_blocks_count(&fs_param)) {
 		if (retval == EXT2_ET_UNIMPLEMENTED) {
 			com_err(program_name, 0,
 				_("Couldn't determine device size; you "
@@ -1451,13 +1451,16 @@ static void PRS(int argc, char *argv[])
 				  ));
 				exit(1);
 			}
-			fs_param.s_blocks_count = dev_size;
-			if (sys_page_size > EXT2_BLOCK_SIZE(&fs_param))
-				fs_param.s_blocks_count &= ~((sys_page_size /
-					   EXT2_BLOCK_SIZE(&fs_param))-1);
+			ext2fs_blocks_count_set(&fs_param, dev_size);
+			if (sys_page_size > EXT2_BLOCK_SIZE(&fs_param)) {
+				blk64_t tmp = ext2fs_blocks_count(&fs_param);
+				tmp &= ~((sys_page_size /
+					  EXT2_BLOCK_SIZE(&fs_param))-1);
+				ext2fs_blocks_count_set(&fs_param, tmp);
+			}
 		}
 		
-	} else if (!force && (fs_param.s_blocks_count > dev_size)) {
+	} else if (!force && (ext2fs_blocks_count(&fs_param) > dev_size)) {
 		com_err(program_name, 0,
 			_("Filesystem larger than apparent device size."));
 		proceed_question();
@@ -1667,7 +1670,7 @@ static void PRS(int argc, char *argv[])
 	/* Make sure number of inodes specified will fit in 32 bits */
 	if (num_inodes == 0) {
 		unsigned long long n;
-		n = (unsigned long long) fs_param.s_blocks_count * blocksize / inode_ratio;
+		n = ext2fs_blocks_count(&fs_param) * blocksize / inode_ratio;
 		if (n > ~0U) {
 			com_err(program_name, 0,
 			    _("too many inodes (%llu), raise inode ratio?"), n);
@@ -1683,29 +1686,28 @@ static void PRS(int argc, char *argv[])
 	 * Calculate number of inodes based on the inode ratio
 	 */
 	fs_param.s_inodes_count = num_inodes ? num_inodes : 
-		((__u64) fs_param.s_blocks_count * blocksize)
-			/ inode_ratio;
+		(ext2fs_blocks_count(&fs_param) * blocksize) / inode_ratio;
 
 	if ((((long long)fs_param.s_inodes_count) *
 	     (inode_size ? inode_size : EXT2_GOOD_OLD_INODE_SIZE)) >=
-	    (((long long)fs_param.s_blocks_count) * 
+	    ((ext2fs_blocks_count(&fs_param)) *
 	     EXT2_BLOCK_SIZE(&fs_param))) {
 		com_err(program_name, 0, _("inode_size (%u) * inodes_count "
 					  "(%u) too big for a\n\t"
-					  "filesystem with %lu blocks, "
+					  "filesystem with %llu blocks, "
 					  "specify higher inode_ratio (-i)\n\t"
 					  "or lower inode count (-N).\n"),
 			inode_size ? inode_size : EXT2_GOOD_OLD_INODE_SIZE,
 			fs_param.s_inodes_count, 
-			(unsigned long) fs_param.s_blocks_count);
+			(unsigned long long) ext2fs_blocks_count(&fs_param));
 		exit(1);
 	}
 
 	/*
 	 * Calculate number of blocks to reserve
 	 */
-	fs_param.s_r_blocks_count = (unsigned int) (reserved_ratio *
-					fs_param.s_blocks_count / 100.0);
+	ext2fs_r_blocks_count_set(&fs_param, reserved_ratio *
+				  ext2fs_blocks_count(&fs_param) / 100.0);
 }
 
 static int should_do_undo(const char *name)

