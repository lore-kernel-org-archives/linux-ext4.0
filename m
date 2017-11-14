From: Artem Blagodarenko <artem.blagodarenko@gmail.com>
Subject: [PATCH v2 5/7] ext2fs: add EXT4_FEATURE_INCOMPAT_64INODE support
Date: Tue, 14 Nov 2017 10:04:38 +0300
Message-ID: <20171114070440.79510-6-artem.blagodarenko@gmail.com>
References: <20171114070440.79510-1-artem.blagodarenko@gmail.com>
Cc: adilger.kernel@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:47743 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752644AbdKNHE5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Nov 2017 02:04:57 -0500
Received: by mail-lf0-f65.google.com with SMTP id f125so21030123lff.4
        for <linux-ext4@vger.kernel.org>; Mon, 13 Nov 2017 23:04:56 -0800 (PST)
In-Reply-To: <20171114070440.79510-1-artem.blagodarenko@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Inodes count and free inodes count should be 64 bit long.
This patch also changes s_inodes_count* to 64 bit

Lustre-bug: https://jira.hpdd.intel.com/browse/LU-9309
Signed-off-by: Artem Blagodarenko <artem.blagodarenko@gmail.com>
---
 debugfs/debugfs.c           |  2 +-
 debugfs/set_fields.c        |  3 ++-
 debugfs/util.c              |  5 +++--
 e2fsck/extents.c            |  8 ++++----
 e2fsck/journal.c            |  2 +-
 e2fsck/pass1.c              | 16 ++++++++--------
 e2fsck/pass1b.c             |  2 +-
 e2fsck/pass2.c              |  4 ++--
 e2fsck/pass4.c              |  2 +-
 e2fsck/pass5.c              | 20 ++++++++++----------
 e2fsck/quota.c              |  2 +-
 e2fsck/super.c              | 18 ++++++++++--------
 e2fsck/unix.c               | 15 ++++++++-------
 ext2ed/inode_com.c          |  7 +++++--
 ext2ed/super_com.c          |  6 ++++--
 lib/e2p/feature.c           |  2 ++
 lib/e2p/ls.c                |  8 +++++---
 lib/ext2fs/alloc.c          |  8 ++++----
 lib/ext2fs/alloc_stats.c    |  6 ++++--
 lib/ext2fs/bitmaps.c        |  2 +-
 lib/ext2fs/ext2_fs.h        | 12 ++++++++++--
 lib/ext2fs/ext2fs.h         | 44 ++++++++++++++++++++++++++++++++++++++++++++
 lib/ext2fs/extent.c         |  2 +-
 lib/ext2fs/gen_bitmap64.c   |  3 ++-
 lib/ext2fs/get_num_dirs.c   |  4 ++--
 lib/ext2fs/icount.c         |  7 ++++---
 lib/ext2fs/initialize.c     | 19 +++++++++++--------
 lib/ext2fs/inline_data.c    |  2 +-
 lib/ext2fs/inode.c          |  8 ++++----
 lib/ext2fs/openfs.c         |  4 ++--
 lib/ext2fs/rw_bitmaps.c     |  2 +-
 lib/ext2fs/swapfs.c         |  2 ++
 lib/ext2fs/tst_bitmaps.c    |  7 ++++---
 lib/ext2fs/tst_iscan.c      |  2 +-
 lib/ext2fs/tst_super_size.c |  5 ++++-
 misc/findsuper.c            |  8 +++++---
 misc/fuse2fs.c              |  6 +++---
 misc/mke2fs.c               | 29 ++++++++++++++++++-----------
 misc/tune2fs.c              | 10 ++++++----
 resize/main.c               |  3 ++-
 resize/resize2fs.c          | 30 ++++++++++++++++--------------
 tests/progs/test_icount.c   |  4 ++--
 42 files changed, 222 insertions(+), 129 deletions(-)

diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 4a533b53..a80cf668 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -829,7 +829,7 @@ void internal_dump_inode(FILE *out, const char *prefix,
 	else if (LINUX_S_ISFIFO(inode->i_mode)) i_type = "FIFO";
 	else if (LINUX_S_ISSOCK(inode->i_mode)) i_type = "socket";
 	else i_type = "bad type";
-	fprintf(out, "%sInode: %u   Type: %s    ", prefix, inode_num, i_type);
+	fprintf(out, "%sInode: %lu   Type: %s    ", prefix, inode_num, i_type);
 	fprintf(out, "%sMode:  0%03o   Flags: 0x%x\n",
 		prefix, inode->i_mode & 07777, inode->i_flags);
 	if (is_large_inode && large_inode->i_extra_isize >= 24) {
diff --git a/debugfs/set_fields.c b/debugfs/set_fields.c
index 8dfbba9c..bfab7ff8 100644
--- a/debugfs/set_fields.c
+++ b/debugfs/set_fields.c
@@ -79,7 +79,8 @@ static errcode_t parse_mmp_clear(struct field_set_info *info, char *field,
 #pragma GCC diagnostic ignored "-Wmissing-field-initializers"
 
 static struct field_set_info super_fields[] = {
-	{ "inodes_count", &set_sb.s_inodes_count, NULL, 4, parse_uint },
+	{ "inodes_count", &set_sb.s_inodes_count, &set_sb.s_inodes_count_hi,
+		4, parse_uint },
 	{ "blocks_count", &set_sb.s_blocks_count, &set_sb.s_blocks_count_hi,
 		4, parse_uint },
 	{ "r_blocks_count", &set_sb.s_r_blocks_count,
diff --git a/debugfs/util.c b/debugfs/util.c
index 452de749..3e4fcb5a 100644
--- a/debugfs/util.c
+++ b/debugfs/util.c
@@ -119,7 +119,8 @@ ext2_ino_t string_to_inode(char *str)
 	 */
 	if ((len > 2) && (str[0] == '<') && (str[len-1] == '>')) {
 		ino = strtoul(str+1, &end, 0);
-		if (*end=='>' && (ino <= current_fs->super->s_inodes_count))
+		if (*end == '>' &&
+			(ino <= ext2fs_get_inodes_count(current_fs->super)))
 			return ino;
 	}
 
@@ -128,7 +129,7 @@ ext2_ino_t string_to_inode(char *str)
 		com_err(str, retval, 0);
 		return 0;
 	}
-	if (ino > current_fs->super->s_inodes_count) {
+	if (ino > ext2fs_get_inodes_count(current_fs->super)) {
 		com_err(str, 0, "resolves to an illegal inode number: %u\n",
 			ino);
 		return 0;
diff --git a/e2fsck/extents.c b/e2fsck/extents.c
index ef3146d8..d6bfcfb1 100644
--- a/e2fsck/extents.c
+++ b/e2fsck/extents.c
@@ -381,7 +381,7 @@ static void rebuild_extents(e2fsck_t ctx, const char *pass_name, int pr_header)
 	while (1) {
 		retval = ext2fs_find_first_set_inode_bitmap2(
 				ctx->inodes_to_rebuild, ino + 1,
-				ctx->fs->super->s_inodes_count, &ino);
+				ext2fs_get_inodes_count(ctx->fs->super), &ino);
 		if (retval)
 			break;
 		pctx.ino = ino;
@@ -396,9 +396,9 @@ static void rebuild_extents(e2fsck_t ctx, const char *pass_name, int pr_header)
 		}
 		if (ctx->progress && !ctx->progress_fd)
 			e2fsck_simple_progress(ctx, "Rebuilding extents",
-					100.0 * (float) ino /
-					(float) ctx->fs->super->s_inodes_count,
-					ino);
+				100.0 * (float) ino /
+				(float) ext2fs_get_inodes_count(ctx->fs->super),
+				ino);
 	}
 	end_problem_latch(ctx, PR_LATCH_OPTIMIZE_EXT);
 
diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index c4f58f1b..9b107384 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -1132,7 +1132,7 @@ void e2fsck_move_ext3_journal(e2fsck_t ctx)
 	ext2fs_mark_ib_dirty(fs);
 	ext2fs_bg_free_inodes_count_set(fs, group, ext2fs_bg_free_inodes_count(fs, group) + 1);
 	ext2fs_group_desc_csum_set(fs, group);
-	fs->super->s_free_inodes_count++;
+	ext2fs_inc_free_inodes_count(fs->super);
 	return;
 
 err_out:
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 686c2019..24f8e215 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -341,7 +341,7 @@ static problem_t check_large_ea_inode(e2fsck_t ctx,
 
 	/* Check if inode is within valid range */
 	if ((entry->e_value_inum < EXT2_FIRST_INODE(ctx->fs->super)) ||
-	    (entry->e_value_inum > ctx->fs->super->s_inodes_count)) {
+	    (entry->e_value_inum > ext2fs_get_inodes_count(ctx->fs->super))) {
 		pctx->num = entry->e_value_inum;
 		return PR_1_ATTR_VALUE_EA_INODE;
 	}
@@ -724,10 +724,10 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 		de.inode = ext2fs_le32_to_cpu(de.inode);
 		de.rec_len = ext2fs_le16_to_cpu(de.rec_len);
 		ext2fs_get_rec_len(ctx->fs, &de, &rec_len2);
-		if (dotdot >= ctx->fs->super->s_inodes_count ||
+		if (dotdot >= ext2fs_get_inodes_count(ctx->fs->super) ||
 		    (dotdot < EXT2_FIRST_INO(ctx->fs->super) &&
 		     dotdot != EXT2_ROOT_INO) ||
-		    de.inode >= ctx->fs->super->s_inodes_count ||
+		    de.inode >= ext2fs_get_inodes_count(ctx->fs->super) ||
 		    (de.inode < EXT2_FIRST_INO(ctx->fs->super) &&
 		     de.inode != 0) ||
 		    rec_len2 > EXT4_MIN_INLINE_DATA_SIZE -
@@ -1098,7 +1098,7 @@ out:
 	if (err) {
 		/* Error; disable itable readahead */
 		*group = ctx->fs->group_desc_count;
-		*next_ino = ctx->fs->super->s_inodes_count;
+		*next_ino = ext2fs_get_inodes_count(ctx->fs->super);
 	} else {
 		/*
 		 * Don't do more readahead until we've reached the first inode
@@ -1338,10 +1338,10 @@ void e2fsck_pass1(e2fsck_t ctx)
 	if (ctx->progress && ((ctx->progress)(ctx, 1, 0,
 					      ctx->fs->group_desc_count)))
 		goto endit;
-	if ((fs->super->s_wtime < fs->super->s_inodes_count) ||
-	    (fs->super->s_mtime < fs->super->s_inodes_count) ||
+	if ((fs->super->s_wtime < ext2fs_get_inodes_count(fs->super)) ||
+	    (fs->super->s_mtime < ext2fs_get_inodes_count(fs->super)) ||
 	    (fs->super->s_mkfs_time &&
-	     fs->super->s_mkfs_time < fs->super->s_inodes_count))
+	     fs->super->s_mkfs_time < ext2fs_get_inodes_count(fs->super)))
 		low_dtime_check = 0;
 
 	if (ext2fs_has_feature_mmp(fs->super) &&
@@ -1444,7 +1444,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 		 * shouldn't be any bugs in the orphan list handling.  :-)
 		 */
 		if (inode->i_dtime && low_dtime_check &&
-		    inode->i_dtime < ctx->fs->super->s_inodes_count) {
+		    inode->i_dtime < ext2fs_get_inodes_count(ctx->fs->super)) {
 			if (fix_problem(ctx, PR_1_LOW_DTIME, &pctx)) {
 				inode->i_dtime = inode->i_links_count ?
 					0 : ctx->now;
diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index 392ff2c6..1607bfb0 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -470,7 +470,7 @@ static void pass1c(e2fsck_t ctx, char *block_buf)
 	 */
 	sd.count = dup_inode_count - dup_inode_founddir;
 	sd.first_inode = EXT2_FIRST_INODE(fs->super);
-	sd.max_inode = fs->super->s_inodes_count;
+	sd.max_inode = ext2fs_get_inodes_count(fs->super);
 	ext2fs_dblist_dir_iterate(fs->dblist, 0, block_buf,
 				  search_dirent_proc, &sd);
 }
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 1a719b2f..08553003 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -829,7 +829,7 @@ static void salvage_directory(ext2_filsys fs,
 	if ((left < 0) &&
 	    ((int) rec_len + left > EXT2_DIR_ENTRY_HEADER_LEN) &&
 	    ((int) name_len + EXT2_DIR_ENTRY_HEADER_LEN <= (int) rec_len + left) &&
-	    dirent->inode <= fs->super->s_inodes_count &&
+	    dirent->inode <= ext2fs_get_inodes_count(fs->super) &&
 	    strnlen(dirent->name, name_len) == name_len) {
 		(void) ext2fs_set_rec_len(fs, (int) rec_len + left, dirent);
 		return;
@@ -1363,7 +1363,7 @@ skip_checksum:
 		name_len = ext2fs_dirent_name_len(dirent);
 		if (((dirent->inode != EXT2_ROOT_INO) &&
 		     (dirent->inode < EXT2_FIRST_INODE(fs->super))) ||
-		    (dirent->inode > fs->super->s_inodes_count)) {
+		    (dirent->inode > ext2fs_get_inodes_count(fs->super))) {
 			problem = PR_2_BAD_INO;
 		} else if (ctx->inode_bb_map &&
 			   (ext2fs_test_inode_bitmap2(ctx->inode_bb_map,
diff --git a/e2fsck/pass4.c b/e2fsck/pass4.c
index 9a491b13..7a76c472 100644
--- a/e2fsck/pass4.c
+++ b/e2fsck/pass4.c
@@ -177,7 +177,7 @@ void e2fsck_pass4(e2fsck_t ctx)
 	inode = e2fsck_allocate_memory(ctx, inode_size, "scratch inode");
 
 	/* Protect loop from wrap-around if s_inodes_count maxed */
-	for (i=1; i <= fs->super->s_inodes_count && i > 0; i++) {
+	for (i = 1; i <= ext2fs_get_inodes_count(fs->super) && i > 0; i++) {
 		int isdir;
 
 		if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index 7803e8b8..746d8299 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -587,11 +587,11 @@ static void check_inode_bitmaps(e2fsck_t ctx)
 	   fs->group_desc_count * sizeof(ext2_ino_t), "directory count array");
 
 	if ((1 < ext2fs_get_inode_bitmap_start2(ctx->inode_used_map)) ||
-	    (fs->super->s_inodes_count >
+	    (ext2fs_get_inodes_count(fs->super) >
 	     ext2fs_get_inode_bitmap_end2(ctx->inode_used_map))) {
 		pctx.num = 3;
 		pctx.blk = 1;
-		pctx.blk2 = fs->super->s_inodes_count;
+		pctx.blk2 = ext2fs_get_inodes_count(fs->super);
 		pctx.ino = ext2fs_get_inode_bitmap_start2(ctx->inode_used_map);
 		pctx.ino2 = ext2fs_get_inode_bitmap_end2(ctx->inode_used_map);
 		fix_problem(ctx, PR_5_BMAP_ENDPOINTS, &pctx);
@@ -600,11 +600,11 @@ static void check_inode_bitmaps(e2fsck_t ctx)
 		goto errout;
 	}
 	if ((1 < ext2fs_get_inode_bitmap_start2(fs->inode_map)) ||
-	    (fs->super->s_inodes_count >
+	    (ext2fs_get_inodes_count(fs->super) >
 	     ext2fs_get_inode_bitmap_end2(fs->inode_map))) {
 		pctx.num = 4;
 		pctx.blk = 1;
-		pctx.blk2 = fs->super->s_inodes_count;
+		pctx.blk2 = ext2fs_get_inodes_count(fs->super);
 		pctx.ino = ext2fs_get_inode_bitmap_start2(fs->inode_map);
 		pctx.ino2 = ext2fs_get_inode_bitmap_end2(fs->inode_map);
 		fix_problem(ctx, PR_5_BMAP_ENDPOINTS, &pctx);
@@ -623,7 +623,7 @@ redo_counts:
 		skip_group++;
 
 	/* Protect loop from wrap-around if inodes_count is maxed */
-	for (i = 1; i <= fs->super->s_inodes_count && i > 0; i++) {
+	for (i = 1; i <= ext2fs_get_inodes_count(fs->super) && i > 0; i++) {
 		bitmap = 0;
 		if (skip_group &&
 		    i % fs->super->s_inodes_per_group == 1) {
@@ -721,7 +721,7 @@ do_counts:
 		}
 
 		if ((inodes == fs->super->s_inodes_per_group) ||
-		    (i == fs->super->s_inodes_count)) {
+		    (i == ext2fs_get_inodes_count(fs->super))) {
 			/*
 			 * If the last inode is free, we can discard it as well.
 			 */
@@ -755,7 +755,7 @@ do_counts:
 					    fs->group_desc_count*2))
 					goto errout;
 			if (csum_flag &&
-			    (i != fs->super->s_inodes_count) &&
+			    (i != ext2fs_get_inodes_count(fs->super)) &&
 			    (ext2fs_bg_flags_test(fs, group, EXT2_BG_INODE_UNINIT)
 			     ))
 				skip_group++;
@@ -818,13 +818,13 @@ do_counts:
 				ext2fs_unmark_valid(fs);
 		}
 	}
-	if (free_inodes != fs->super->s_free_inodes_count) {
+	if (free_inodes != ext2fs_get_free_inodes_count(fs->super)) {
 		pctx.group = -1;
-		pctx.ino = fs->super->s_free_inodes_count;
+		pctx.ino = ext2fs_get_free_inodes_count(fs->super);
 		pctx.ino2 = free_inodes;
 
 		if (fix_problem(ctx, PR_5_FREE_INODE_COUNT, &pctx)) {
-			fs->super->s_free_inodes_count = free_inodes;
+			ext2fs_set_free_inodes_count(fs->super, free_inodes);
 			ext2fs_mark_super_dirty(fs);
 		}
 	}
diff --git a/e2fsck/quota.c b/e2fsck/quota.c
index b0f9af63..529e87ef 100644
--- a/e2fsck/quota.c
+++ b/e2fsck/quota.c
@@ -108,7 +108,7 @@ void e2fsck_validate_quota_inodes(e2fsck_t ctx)
 		     (pctx.ino == EXT2_JOURNAL_INO) ||
 		     (pctx.ino == EXT2_EXCLUDE_INO) ||
 		     (pctx.ino == EXT4_REPLICA_INO) ||
-		     (pctx.ino > fs->super->s_inodes_count)) &&
+		     (pctx.ino > ext2fs_get_inodes_count(fs->super))) &&
 		    fix_problem(ctx, PR_0_INVALID_QUOTA_INO, &pctx)) {
 			*quota_sb_inump(sb, qtype) = 0;
 			ext2fs_mark_super_dirty(fs);
diff --git a/e2fsck/super.c b/e2fsck/super.c
index 47c89c56..7183755c 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -272,7 +272,7 @@ static int release_orphan_inodes(e2fsck_t ctx)
 		return 0;
 
 	if ((ino < EXT2_FIRST_INODE(fs->super)) ||
-	    (ino > fs->super->s_inodes_count)) {
+	    (ino > ext2fs_get_inodes_count(fs->super))) {
 		clear_problem_context(&pctx);
 		pctx.ino = ino;
 		fix_problem(ctx, PR_0_ORPHAN_ILLEGAL_HEAD_INODE, &pctx);
@@ -296,7 +296,7 @@ static int release_orphan_inodes(e2fsck_t ctx)
 		next_ino = inode.i_dtime;
 		if (next_ino &&
 		    ((next_ino < EXT2_FIRST_INODE(fs->super)) ||
-		     (next_ino > fs->super->s_inodes_count))) {
+		     (next_ino > ext2fs_get_inodes_count(fs->super)))) {
 			pctx.ino = next_ino;
 			fix_problem(ctx, PR_0_ORPHAN_ILLEGAL_INODE, &pctx);
 			goto return_abort;
@@ -529,7 +529,7 @@ void check_super_block(e2fsck_t ctx)
 	/*
 	 * Verify the super block constants...
 	 */
-	check_super_value(ctx, "inodes_count", sb->s_inodes_count,
+	check_super_value(ctx, "inodes_count", ext2fs_get_inodes_count(sb),
 			  MIN_CHECK, 1, 0);
 	check_super_value64(ctx, "blocks_count", ext2fs_blocks_count(sb),
 			    MIN_CHECK | MAX_CHECK, 1, blks_max);
@@ -560,7 +560,8 @@ void check_super_block(e2fsck_t ctx)
 	if (sb->s_rev_level > EXT2_GOOD_OLD_REV)
 		check_super_value(ctx, "first_ino", sb->s_first_ino,
 				  MIN_CHECK | MAX_CHECK,
-				  EXT2_GOOD_OLD_FIRST_INO, sb->s_inodes_count);
+				  EXT2_GOOD_OLD_FIRST_INO,
+				  ext2fs_get_inodes_count(sb));
 	inode_size = EXT2_INODE_SIZE(sb);
 	check_super_value(ctx, "inode_size",
 			  inode_size, MIN_CHECK | MAX_CHECK | LOG2_CHECK,
@@ -597,11 +598,11 @@ void check_super_block(e2fsck_t ctx)
 	should_be = (blk64_t)sb->s_inodes_per_group * fs->group_desc_count;
 	if (should_be > UINT_MAX)
 		should_be = UINT_MAX;
-	if (sb->s_inodes_count != should_be) {
-		pctx.ino = sb->s_inodes_count;
+	if (ext2fs_get_inodes_count(sb) != should_be) {
+		pctx.ino = ext2fs_get_inodes_count(sb);
 		pctx.ino2 = should_be;
 		if (fix_problem(ctx, PR_0_INODE_COUNT_WRONG, &pctx)) {
-			sb->s_inodes_count = should_be;
+			ext2fs_set_inodes_count(sb, should_be);
 			ext2fs_mark_super_dirty(fs);
 		}
 	}
@@ -789,7 +790,7 @@ void check_super_block(e2fsck_t ctx)
 	ctx->free_inodes = free_inodes;
 
 	if ((ext2fs_free_blocks_count(sb) > ext2fs_blocks_count(sb)) ||
-	    (sb->s_free_inodes_count > sb->s_inodes_count))
+	    (ext2fs_get_free_inodes_count(sb) > ext2fs_get_inodes_count(sb)))
 		ext2fs_unmark_valid(fs);
 
 
@@ -1046,6 +1047,7 @@ int check_backup_super_block(e2fsck_t ctx)
 		    SUPER_DIFFERENT(s_blocks_count) ||
 		    SUPER_DIFFERENT(s_blocks_count_hi) ||
 		    SUPER_DIFFERENT(s_inodes_count) ||
+		    SUPER_DIFFERENT(s_inodes_count_hi) ||
 		    memcmp(fs->super->s_uuid, backup_sb->s_uuid,
 			   sizeof(fs->super->s_uuid)))
 			ret = 1;
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index b46dcb2d..38bc63e5 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -112,9 +112,9 @@ static void show_stats(e2fsck_t	ctx)
 	dir_links = 2 * ctx->fs_directory_count - 1;
 	num_files = ctx->fs_total_count - dir_links;
 	num_links = ctx->fs_links_count - dir_links;
-	inodes = fs->super->s_inodes_count;
-	inodes_used = (fs->super->s_inodes_count -
-		       fs->super->s_free_inodes_count);
+	inodes = ext2fs_get_inodes_count(fs->super);
+	inodes_used = (ext2fs_get_inodes_count(fs->super) -
+		       ext2fs_get_free_inodes_count(fs->super));
 	blocks = ext2fs_blocks_count(fs->super);
 	blocks_used = (ext2fs_blocks_count(fs->super) -
 		       ext2fs_free_blocks_count(fs->super));
@@ -412,12 +412,12 @@ static void check_if_skip(e2fsck_t ctx)
 	 * using dumpe2fs.  (This is for cosmetic reasons only.)
 	 */
 	clear_problem_context(&pctx);
-	pctx.ino = fs->super->s_free_inodes_count;
+	pctx.ino = ext2fs_get_free_inodes_count(fs->super);
 	pctx.ino2 = ctx->free_inodes;
 	if ((pctx.ino != pctx.ino2) &&
 	    !(ctx->options & E2F_OPT_READONLY) &&
 	    fix_problem(ctx, PR_0_FREE_INODE_COUNT, &pctx)) {
-		fs->super->s_free_inodes_count = ctx->free_inodes;
+		ext2fs_set_free_inodes_count(fs->super, ctx->free_inodes);
 		ext2fs_mark_super_dirty(fs);
 	}
 	clear_problem_context(&pctx);
@@ -433,8 +433,9 @@ static void check_if_skip(e2fsck_t ctx)
 	/* Print the summary message when we're skipping a full check */
 	log_out(ctx, _("%s: clean, %u/%u files, %llu/%llu blocks"),
 		ctx->device_name,
-		fs->super->s_inodes_count - fs->super->s_free_inodes_count,
-		fs->super->s_inodes_count,
+		ext2fs_get_free_inodes_count(fs->super) -
+		ext2fs_get_free_inodes_count(fs->super),
+		ext2fs_get_inodes_count(fs->super),
 		ext2fs_blocks_count(fs->super) -
 		ext2fs_free_blocks_count(fs->super),
 		ext2fs_blocks_count(fs->super));
diff --git a/ext2ed/inode_com.c b/ext2ed/inode_com.c
index 2d3dd6d6..279ce3c1 100644
--- a/ext2ed/inode_com.c
+++ b/ext2ed/inode_com.c
@@ -210,8 +210,11 @@ void type_ext2_inode___show (char *command_line)
 
 	wmove (show_win,1,0);
 
-	wprintw (show_win,"Inode %ld of %ld. Entry %ld of %ld in group descriptor %ld.\n"
-		,inode_num,file_system_info.super_block.s_inodes_count,entry_num,last_entry,group_num);
+	wprintw (show_win,
+		 "Inode %ld of %ld. Entry %ld of %ld in group descriptor %ld.\n",
+		 inode_num,
+		 ext2fs_get_inodes_count(&file_system_info.super_block),
+		 entry_num, last_entry, group_num);
 
 	wprintw (show_win,"Inode type: ");
 
diff --git a/ext2ed/super_com.c b/ext2ed/super_com.c
index a998970e..98558c58 100644
--- a/ext2ed/super_com.c
+++ b/ext2ed/super_com.c
@@ -35,8 +35,10 @@ void type_ext2_super_block___show (char *command_line)
 		wmove (show_pad,3,40);wprintw (show_pad,"%2.2f%%",100*(float) ext2fs_free_blocks_count(super)/ (float) ext2fs_blocks_count(super));
 	}
 
-	if (super->s_inodes_count != 0) {
-		wmove (show_pad,4,40);wprintw (show_pad,"%2.2f%%",100*(float) super->s_free_inodes_count/ (float) super->s_inodes_count);
+	if (ext2fs_get_inodes_count(super) != 0) {
+		wmove(show_pad, 4, 40); wprintw(show_pad, "%2.2f%%",
+		100*(float) ext2fs_get_free_inodes_count(super)/
+		(float) ext2fs_get_inodes_count(super);
 	}
 
 	wmove (show_pad,6,40);
diff --git a/lib/e2p/feature.c b/lib/e2p/feature.c
index b7f6c1d2..fd77dedd 100644
--- a/lib/e2p/feature.c
+++ b/lib/e2p/feature.c
@@ -105,6 +105,8 @@ static struct feature feature_list[] = {
 			"inline_data"},
 	{       E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_ENCRYPT,
 			"encrypt"},
+	{	E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_INODE64,
+			"inode64"},
 	{	0, 0, 0 },
 };
 
diff --git a/lib/e2p/ls.c b/lib/e2p/ls.c
index a7586e09..45437520 100644
--- a/lib/e2p/ls.c
+++ b/lib/e2p/ls.c
@@ -269,14 +269,16 @@ void list_super2(struct ext2_super_block * sb, FILE *f)
 	str = e2p_os2string(sb->s_creator_os);
 	fprintf(f, "Filesystem OS type:       %s\n", str);
 	free(str);
-	fprintf(f, "Inode count:              %u\n", sb->s_inodes_count);
+	fprintf(f, "Inode count:              %u\n",
+			ext2fs_get_inodes_count(sb));
 	fprintf(f, "Block count:              %llu\n", e2p_blocks_count(sb));
 	fprintf(f, "Reserved block count:     %llu\n", e2p_r_blocks_count(sb));
 	if (sb->s_overhead_blocks)
 		fprintf(f, "Overhead blocks:          %u\n",
 			sb->s_overhead_blocks);
-	fprintf(f, "Free blocks:              %llu\n", e2p_free_blocks_count(sb));
-	fprintf(f, "Free inodes:              %u\n", sb->s_free_inodes_count);
+	fprintf(f, "Free blocks:              %llu\n",
+			e2p_free_blocks_count(sb));
+	fprintf(f, "Free inodes:              %u\n", ext2fs_get_free_inodes_count(sb));
 	fprintf(f, "First block:              %u\n", sb->s_first_data_block);
 	fprintf(f, "Block size:               %u\n", EXT2_BLOCK_SIZE(sb));
 	if (ext2fs_has_feature_bigalloc(sb))
diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index 3fd92167..e4ef9061 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -107,7 +107,7 @@ errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t dir,
 	}
 	if (start_inode < EXT2_FIRST_INODE(fs->super))
 		start_inode = EXT2_FIRST_INODE(fs->super);
-	if (start_inode > fs->super->s_inodes_count)
+	if (start_inode > ext2fs_get_inodes_count(fs->super))
 		return EXT2_ET_INODE_ALLOC_FAIL;
 	i = start_inode;
 	do {
@@ -118,8 +118,8 @@ errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t dir,
 		upto = i + (EXT2_INODES_PER_GROUP(fs->super) - ino_in_group);
 		if (i < start_inode && upto >= start_inode)
 			upto = start_inode - 1;
-		if (upto > fs->super->s_inodes_count)
-			upto = fs->super->s_inodes_count;
+		if (upto > ext2fs_get_inodes_count(fs->super))
+			upto = ext2fs_get_inodes_count(fs->super);
 
 		retval = ext2fs_find_first_zero_inode_bitmap2(map, i, upto,
 							      &first_zero);
@@ -130,7 +130,7 @@ errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t dir,
 		if (retval != ENOENT)
 			return EXT2_ET_INODE_ALLOC_FAIL;
 		i = upto + 1;
-		if (i > fs->super->s_inodes_count)
+		if (i > ext2fs_get_inodes_count(fs->super))
 			i = EXT2_FIRST_INODE(fs->super);
 	} while (i != start_inode);
 
diff --git a/lib/ext2fs/alloc_stats.c b/lib/ext2fs/alloc_stats.c
index 3949f618..9a145b43 100644
--- a/lib/ext2fs/alloc_stats.c
+++ b/lib/ext2fs/alloc_stats.c
@@ -20,7 +20,7 @@ void ext2fs_inode_alloc_stats2(ext2_filsys fs, ext2_ino_t ino,
 {
 	int	group = ext2fs_group_of_ino(fs, ino);
 
-	if (ino > fs->super->s_inodes_count) {
+	if (ino > ext2fs_get_inodes_count(fs->super)) {
 #ifndef OMIT_COM_ERR
 		com_err("ext2fs_inode_alloc_stats2", 0,
 			"Illegal inode number: %lu", (unsigned long) ino);
@@ -48,7 +48,9 @@ void ext2fs_inode_alloc_stats2(ext2_filsys fs, ext2_ino_t ino,
 		ext2fs_group_desc_csum_set(fs, group);
 	}
 
-	fs->super->s_free_inodes_count -= inuse;
+	ext2fs_set_free_inodes_count(fs->super,
+				     ext2fs_get_free_inodes_count(fs->super) -
+								  inuse);
 	ext2fs_mark_super_dirty(fs);
 	ext2fs_mark_ib_dirty(fs);
 }
diff --git a/lib/ext2fs/bitmaps.c b/lib/ext2fs/bitmaps.c
index 84021917..bbfab1ae 100644
--- a/lib/ext2fs/bitmaps.c
+++ b/lib/ext2fs/bitmaps.c
@@ -61,7 +61,7 @@ errcode_t ext2fs_allocate_inode_bitmap(ext2_filsys fs,
 	fs->write_bitmaps = ext2fs_write_bitmaps;
 
 	start = 1;
-	end = fs->super->s_inodes_count;
+	end = ext2fs_get_inodes_count(fs->super);
 	real_end = (EXT2_INODES_PER_GROUP(fs->super) * fs->group_desc_count);
 
 	/* Are we permitted to use new-style bitmaps? */
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index 90294ed0..cb0f59d4 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -737,7 +737,10 @@ struct ext2_super_block {
 	__le32	s_lpf_ino;		/* Location of the lost+found inode */
 	__le32  s_prj_quota_inum;	/* inode for tracking project quota */
 	__le32	s_checksum_seed;	/* crc32c(orig_uuid) if csum_seed set */
-	__le32	s_reserved[98];		/* Padding to the end of the block */
+	__le32	s_inodes_count_hi;	/* higth part of inode count */
+	__le32	s_free_inodes_count_hi;	/* Free inodes count */
+	__le32	s_prj_quota_inum_hi;
+	__le32	s_reserved[93];		/* Padding to the end of the block */
 	__u32	s_checksum;		/* crc32c(superblock) */
 };
 
@@ -827,6 +830,8 @@ struct ext2_super_block {
 #define EXT4_FEATURE_INCOMPAT_LARGEDIR		0x4000 /* >2GB or 3-lvl htree */
 #define EXT4_FEATURE_INCOMPAT_INLINE_DATA	0x8000 /* data in inode */
 #define EXT4_FEATURE_INCOMPAT_ENCRYPT		0x10000
+#define EXT4_FEATURE_INCOMPAT_INODE64		0x20000
+
 
 #define EXT4_FEATURE_COMPAT_FUNCS(name, ver, flagname) \
 static inline int ext2fs_has_feature_##name(struct ext2_super_block *sb) \
@@ -918,13 +923,16 @@ EXT4_FEATURE_INCOMPAT_FUNCS(csum_seed,		4, CSUM_SEED)
 EXT4_FEATURE_INCOMPAT_FUNCS(largedir,		4, LARGEDIR)
 EXT4_FEATURE_INCOMPAT_FUNCS(inline_data,	4, INLINE_DATA)
 EXT4_FEATURE_INCOMPAT_FUNCS(encrypt,		4, ENCRYPT)
+EXT4_FEATURE_INCOMPAT_FUNCS(inode64,		4, INODE64)
+
 
 #define EXT2_FEATURE_COMPAT_SUPP	0
 #define EXT2_FEATURE_INCOMPAT_SUPP    (EXT2_FEATURE_INCOMPAT_FILETYPE| \
 				       EXT4_FEATURE_INCOMPAT_MMP| \
 				       EXT4_FEATURE_INCOMPAT_LARGEDIR| \
 				       EXT4_FEATURE_INCOMPAT_EA_INODE| \
-				       EXT4_FEATURE_INCOMPAT_DIRDATA)
+				       EXT4_FEATURE_INCOMPAT_DIRDATA \
+				       EXT4_FEATURE_INCOMPAT_INODE64)
 #define EXT2_FEATURE_RO_COMPAT_SUPP	(EXT2_FEATURE_RO_COMPAT_SPARSE_SUPER| \
 					 EXT2_FEATURE_RO_COMPAT_LARGE_FILE| \
 					 EXT4_FEATURE_RO_COMPAT_DIR_NLINK| \
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index b653012f..785042df 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -74,6 +74,7 @@ extern "C" {
 #endif /* EXT2_FLAT_INCLUDES */
 
 typedef __u32 __bitwise		ext2_ino_t;
+typedef __u64 __bitwise ext2_ino64_t;
 typedef __u32 __bitwise		blk_t;
 typedef __u64 __bitwise		blk64_t;
 typedef __u32 __bitwise		dgrp_t;
@@ -601,6 +602,7 @@ typedef struct ext2_icount *ext2_icount_t;
 					 EXT4_FEATURE_INCOMPAT_FLEX_BG|\
 					 EXT4_FEATURE_INCOMPAT_EA_INODE|\
 					 EXT4_FEATURE_INCOMPAT_DIRDATA|\
+					 EXT4_FEATURE_INCOMPAT_INODE64|\
 					 EXT4_LIB_INCOMPAT_MMP|\
 					 EXT4_FEATURE_INCOMPAT_64BIT|\
 					 EXT4_FEATURE_INCOMPAT_INLINE_DATA|\
@@ -2048,6 +2050,48 @@ ext2fs_const_inode(const struct ext2_inode_large * large_inode)
 	return (const struct ext2_inode *) large_inode;
 }
 
+static inline ext2_ino64_t ext2fs_get_inodes_count(struct ext2_super_block *sb)
+{
+	ext2_ino64_t inodes_count = sb->s_inodes_count;
+
+	if (ext2fs_has_feature_inode64(sb))
+		inodes_count |= (ext2_ino64_t)sb->s_inodes_count_hi << 32;
+	return inodes_count;
+}
+
+static inline void ext2fs_set_inodes_count(struct ext2_super_block *sb,
+					   ext2_ino64_t val)
+{
+	if (ext2fs_has_feature_inode64(sb))
+		sb->s_inodes_count_hi =  val >> 32;
+	sb->s_inodes_count = val;
+}
+
+static inline ext2_ino64_t
+ext2fs_get_free_inodes_count(struct ext2_super_block *sb)
+{
+	ext2_ino64_t inodes_count = sb->s_free_inodes_count;
+
+	if (ext2fs_has_feature_inode64(sb))
+		inodes_count |= (ext2_ino64_t)sb->s_free_inodes_count_hi << 32;
+	return inodes_count;
+}
+
+static inline void ext2fs_set_free_inodes_count(struct ext2_super_block *sb,
+						ext2_ino64_t val)
+{
+	if (ext2fs_has_feature_inode64(sb))
+		sb->s_free_inodes_count_hi =  (__u32)(val >> 32);
+	sb->s_free_inodes_count = val;
+}
+
+static inline void ext2fs_inc_free_inodes_count(struct ext2_super_block *sb)
+{
+	__u64 val = ext2fs_get_free_inodes_count(sb);
+
+	ext2fs_set_free_inodes_count(sb, ++val);
+}
+
 #undef _INLINE_
 #endif
 
diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index a9cdae79..7d14da67 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -226,7 +226,7 @@ errcode_t ext2fs_extent_open2(ext2_filsys fs, ext2_ino_t ino,
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
 	if (!inode)
-		if ((ino == 0) || (ino > fs->super->s_inodes_count))
+		if ((ino == 0) || (ino > ext2fs_get_inodes_count(fs->super)))
 			return EXT2_ET_BAD_INODE_NUM;
 
 	retval = ext2fs_get_mem(sizeof(struct ext2_extent_handle), &handle);
diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index 3fc73498..4c676f23 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -110,7 +110,8 @@ errcode_t ext2fs_alloc_generic_bmap(ext2_filsys fs, errcode_t magic,
 		break;
 	case EXT2FS_BMAP64_AUTODIR:
 		retval = ext2fs_get_num_dirs(fs, &num_dirs);
-		if (retval || num_dirs > (fs->super->s_inodes_count / 320))
+		if (retval ||
+		    num_dirs > (ext2fs_get_inodes_count(fs->super) / 320))
 			ops = &ext2fs_blkmap64_bitarray;
 		else
 			ops = &ext2fs_blkmap64_rbtree;
diff --git a/lib/ext2fs/get_num_dirs.c b/lib/ext2fs/get_num_dirs.c
index f5644f8e..552ac477 100644
--- a/lib/ext2fs/get_num_dirs.c
+++ b/lib/ext2fs/get_num_dirs.c
@@ -40,8 +40,8 @@ errcode_t ext2fs_get_num_dirs(ext2_filsys fs, ext2_ino_t *ret_num_dirs)
 		else
 			num_dirs += ext2fs_bg_used_dirs_count(fs, i);
 	}
-	if (num_dirs > fs->super->s_inodes_count)
-		num_dirs = fs->super->s_inodes_count;
+	if (num_dirs > ext2fs_get_inodes_count(fs->super))
+		num_dirs = ext2fs_get_inodes_count(fs->super);
 
 	*ret_num_dirs = num_dirs;
 
diff --git a/lib/ext2fs/icount.c b/lib/ext2fs/icount.c
index d7de19fe..e652a0ad 100644
--- a/lib/ext2fs/icount.c
+++ b/lib/ext2fs/icount.c
@@ -112,7 +112,7 @@ static errcode_t alloc_icount(ext2_filsys fs, int flags, ext2_icount_t *ret)
 		return retval;
 	memset(icount, 0, sizeof(struct ext2_icount));
 	icount->magic = EXT2_ET_MAGIC_ICOUNT;
-	icount->num_inodes = fs->super->s_inodes_count;
+	icount->num_inodes = ext2fs_get_inodes_count(fs->super);
 
 	if ((flags & EXT2_ICOUNT_OPT_FULLMAP) &&
 	    (flags & EXT2_ICOUNT_OPT_INCREMENT)) {
@@ -235,7 +235,8 @@ errcode_t ext2fs_create_icount_tdb(ext2_filsys fs EXT2FS_NO_TDB_UNUSED,
 	 * which case the number of inodes in use approaches the ideal
 	 * value.
 	 */
-	num_inodes = fs->super->s_inodes_count - fs->super->s_free_inodes_count;
+	num_inodes = ext2fs_get_inodes_count(fs->super) -
+		     ext2fs_get_free_inodes_count(fs->super);
 
 	icount->tdb = tdb_open(fn, num_inodes, TDB_NOLOCK | TDB_NOSYNC,
 			       O_RDWR | O_CREAT | O_TRUNC, 0600);
@@ -286,7 +287,7 @@ errcode_t ext2fs_create_icount2(ext2_filsys fs, int flags, unsigned int size,
 		retval = ext2fs_get_num_dirs(fs, &icount->size);
 		if (retval)
 			goto errout;
-		icount->size += fs->super->s_inodes_count / 50;
+		icount->size += ext2fs_get_inodes_count(fs->super) / 50;
 	}
 
 	bytes = (size_t) (icount->size * sizeof(struct ext2_icount_el));
diff --git a/lib/ext2fs/initialize.c b/lib/ext2fs/initialize.c
index 32f43210..2554b2dd 100644
--- a/lib/ext2fs/initialize.c
+++ b/lib/ext2fs/initialize.c
@@ -285,16 +285,18 @@ retry:
 
 	if (ext2fs_has_feature_64bit(super) &&
 	    (ext2fs_blocks_count(super) / i) > (1ULL << 32))
-		set_field(s_inodes_count, ~0U);
+		ext2fs_set_inodes_count(super, ~0U);
 	else
-		set_field(s_inodes_count, ext2fs_blocks_count(super) / i);
+		ext2fs_set_inodes_count(super, ext2fs_get_inodes_count(param) ?
+					ext2fs_get_inodes_count(param) :
+					ext2fs_blocks_count(super) / i);
 
 	/*
 	 * Make sure we have at least EXT2_FIRST_INO + 1 inodes, so
 	 * that we have enough inodes for the filesystem(!)
 	 */
-	if (super->s_inodes_count < EXT2_FIRST_INODE(super)+1)
-		super->s_inodes_count = EXT2_FIRST_INODE(super)+1;
+	if (ext2fs_get_inodes_count(super) < EXT2_FIRST_INODE(super)+1)
+		ext2fs_set_inodes_count(super, EXT2_FIRST_INODE(super)+1);
 
 	/*
 	 * There should be at least as many inodes as the user
@@ -302,7 +304,8 @@ retry:
 	 * should be.  But make sure that we don't allocate more than
 	 * one bitmap's worth of inodes each group.
 	 */
-	ipg = ext2fs_div_ceil(super->s_inodes_count, fs->group_desc_count);
+	ipg = ext2fs_div_ceil(ext2fs_get_inodes_count(super),
+			      fs->group_desc_count);
 	if (ipg > fs->blocksize * 8) {
 		if (!bigalloc_flag && super->s_blocks_per_group >= 256) {
 			/* Try again with slightly different parameters */
@@ -355,9 +358,9 @@ ipg_retry:
 		ipg--;
 		goto ipg_retry;
 	}
-	super->s_inodes_count = super->s_inodes_per_group *
-		fs->group_desc_count;
-	super->s_free_inodes_count = super->s_inodes_count;
+	ext2fs_set_inodes_count(super, (ext2_ino64_t)super->s_inodes_per_group *
+		fs->group_desc_count);
+	ext2fs_set_free_inodes_count(super, ext2fs_get_inodes_count(super));
 
 	/*
 	 * check the number of reserved group descriptor table blocks
diff --git a/lib/ext2fs/inline_data.c b/lib/ext2fs/inline_data.c
index 2ce2f6f7..4517afdd 100644
--- a/lib/ext2fs/inline_data.c
+++ b/lib/ext2fs/inline_data.c
@@ -784,7 +784,7 @@ int main(int argc, char *argv[])
 
 	memset(&param, 0, sizeof(param));
 	ext2fs_blocks_count_set(&param, 32768);
-	param.s_inodes_count = 100;
+	ext2fs_set_inodes_count(&param, 100);
 
 	param.s_feature_incompat |= EXT4_FEATURE_INCOMPAT_INLINE_DATA;
 	param.s_rev_level = EXT2_DYNAMIC_REV;
diff --git a/lib/ext2fs/inode.c b/lib/ext2fs/inode.c
index ad01a9fc..182e9819 100644
--- a/lib/ext2fs/inode.c
+++ b/lib/ext2fs/inode.c
@@ -752,7 +752,7 @@ errcode_t ext2fs_read_inode_full(ext2_filsys fs, ext2_ino_t ino,
 		if (retval != EXT2_ET_CALLBACK_NOTHANDLED)
 			return retval;
 	}
-	if ((ino == 0) || (ino > fs->super->s_inodes_count))
+	if ((ino == 0) || (ino > ext2fs_get_inodes_count(fs->super)))
 		return EXT2_ET_BAD_INODE_NUM;
 	/* Create inode cache if not present */
 	if (!fs->icache) {
@@ -867,7 +867,7 @@ errcode_t ext2fs_write_inode_full(ext2_filsys fs, ext2_ino_t ino,
 			return retval;
 	}
 
-	if ((ino == 0) || (ino > fs->super->s_inodes_count))
+	if ((ino == 0) || (ino > ext2fs_get_inodes_count(fs->super)))
 		return EXT2_ET_BAD_INODE_NUM;
 
 	/* Prepare our shadow buffer for read/modify/byteswap/write */
@@ -1022,7 +1022,7 @@ errcode_t ext2fs_get_blocks(ext2_filsys fs, ext2_ino_t ino, blk_t *blocks)
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
-	if (ino > fs->super->s_inodes_count)
+	if (ino > ext2fs_get_inodes_count(fs->super))
 		return EXT2_ET_BAD_INODE_NUM;
 
 	if (fs->get_blocks) {
@@ -1044,7 +1044,7 @@ errcode_t ext2fs_check_directory(ext2_filsys fs, ext2_ino_t ino)
 
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
 
-	if (ino > fs->super->s_inodes_count)
+	if (ino > ext2fs_get_inodes_count(fs->super))
 		return EXT2_ET_BAD_INODE_NUM;
 
 	if (fs->check_directory) {
diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index f74cd245..2e9464cf 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -5,7 +5,7 @@
  *
  * %Begin-Header%
  * This file may be redistributed under the terms of the GNU Library
- * General Public License, version 2.
+* General Public License, version 2.
  * %End-Header%
  */
 
@@ -381,7 +381,7 @@ errcode_t ext2fs_open2(const char *name, const char *io_options,
 	}
 	fs->group_desc_count = 	groups_cnt;
 	if (fs->group_desc_count * EXT2_INODES_PER_GROUP(fs->super) !=
-	    fs->super->s_inodes_count) {
+	    ext2fs_get_inodes_count(fs->super)) {
 		retval = EXT2_ET_CORRUPT_SUPERBLOCK;
 		goto cleanup;
 	}
diff --git a/lib/ext2fs/rw_bitmaps.c b/lib/ext2fs/rw_bitmaps.c
index ae593d49..66c8ee69 100644
--- a/lib/ext2fs/rw_bitmaps.c
+++ b/lib/ext2fs/rw_bitmaps.c
@@ -252,7 +252,7 @@ static errcode_t read_bitmaps(ext2_filsys fs, int do_inode, int do_block)
 
 	if (fs->flags & EXT2_FLAG_IMAGE_FILE) {
 		blk = (fs->image_header->offset_inodemap / fs->blocksize);
-		ino_cnt = fs->super->s_inodes_count;
+		ino_cnt = ext2fs_get_inodes_count(fs->super);
 		while (inode_nbytes > 0) {
 			retval = io_channel_read_blk64(fs->image_io, blk++,
 						     1, inode_bitmap);
diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index b9d8f557..b7c01005 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -26,10 +26,12 @@ void ext2fs_swap_super(struct ext2_super_block * sb)
 {
   	int i;
 	sb->s_inodes_count = ext2fs_swab32(sb->s_inodes_count);
+	sb->s_inodes_count_hi = ext2fs_swab32(sb->s_inodes_count_hi);
 	sb->s_blocks_count = ext2fs_swab32(sb->s_blocks_count);
 	sb->s_r_blocks_count = ext2fs_swab32(sb->s_r_blocks_count);
 	sb->s_free_blocks_count = ext2fs_swab32(sb->s_free_blocks_count);
 	sb->s_free_inodes_count = ext2fs_swab32(sb->s_free_inodes_count);
+	sb->s_free_inodes_count_hi = ext2fs_swab32(sb->s_free_inodes_count_hi);
 	sb->s_first_data_block = ext2fs_swab32(sb->s_first_data_block);
 	sb->s_log_block_size = ext2fs_swab32(sb->s_log_block_size);
 	sb->s_log_cluster_size = ext2fs_swab32(sb->s_log_cluster_size);
diff --git a/lib/ext2fs/tst_bitmaps.c b/lib/ext2fs/tst_bitmaps.c
index 574fb7a7..5ca4c680 100644
--- a/lib/ext2fs/tst_bitmaps.c
+++ b/lib/ext2fs/tst_bitmaps.c
@@ -158,7 +158,7 @@ static void setup_filesystem(const char *name,
 
 	memset(&param, 0, sizeof(param));
 	ext2fs_blocks_count_set(&param, blocks);
-	param.s_inodes_count = inodes;
+	ext2fs_set_inodes_count(&param, inodes);
 
 	retval = ext2fs_initialize("test fs", flags, &param,
 				   test_io_manager, &test_fs);
@@ -275,9 +275,10 @@ void dump_inode_bitmap_cmd(int argc, char **argv)
 		return;
 
 	printf("inode bitmap: ");
-	dump_bitmap(test_fs->inode_map, 1, test_fs->super->s_inodes_count);
+	dump_bitmap(test_fs->inode_map, 1,
+		    ext2fs_get_inodes_count(test_fs->super));
 }
-	
+
 void dump_block_bitmap_cmd(int argc, char **argv)
 {
 	if (check_fs_open(argv[0]))
diff --git a/lib/ext2fs/tst_iscan.c b/lib/ext2fs/tst_iscan.c
index 70bfbecc..6c9ceaf6 100644
--- a/lib/ext2fs/tst_iscan.c
+++ b/lib/ext2fs/tst_iscan.c
@@ -200,7 +200,7 @@ static void check_map(void)
 		}
 	}
 	printf("Bad inodes: ");
-	for (i=1; i <= test_fs->super->s_inodes_count; i++) {
+	for (i = 1; i <= ext2fs_get_inodes_count(test_fs->super); i++) {
 		if (ext2fs_test_inode_bitmap2(bad_inode_map, i)) {
 			if (first)
 				first = 0;
diff --git a/lib/ext2fs/tst_super_size.c b/lib/ext2fs/tst_super_size.c
index 0adac411..e3dc608a 100644
--- a/lib/ext2fs/tst_super_size.c
+++ b/lib/ext2fs/tst_super_size.c
@@ -142,7 +142,10 @@ int main(int argc, char **argv)
 	check_field(s_lpf_ino, 4);
 	check_field(s_prj_quota_inum, 4);
 	check_field(s_checksum_seed, 4);
-	check_field(s_reserved, 98 * 4);
+	check_field(s_inodes_count_hi, 4);
+	check_field(s_free_inodes_count_hi, 4);
+	check_field(s_prj_quota_inum_hi, 4);
+	check_field(s_reserved, 93 * 4);
 	check_field(s_checksum, 4);
 	do_field("Superblock end", 0, 0, cur_offset, 1024);
 #endif
diff --git a/misc/findsuper.c b/misc/findsuper.c
index ff20b988..e73e92a5 100644
--- a/misc/findsuper.c
+++ b/misc/findsuper.c
@@ -226,9 +226,11 @@ int main(int argc, char *argv[])
 			WHY("free_blocks_count > blocks_count\n (%u > %u)\n",
 			    ext2fs_free_blocks_count(&ext2),
 			    ext2fs_blocks_count(&ext2));
-		if (ext2.s_free_inodes_count > ext2.s_inodes_count)
-			WHY("free_inodes_count > inodes_count (%u > %u)\n",
-			    ext2.s_free_inodes_count, ext2.s_inodes_count);
+		if (ext2fs_get_free_inodes_count(&ext2) >
+				ext2fs_get_inodes_count(&ext2))
+			WHY("free_inodes_count > inodes_count (%lu > %lu)\n",
+			    ext2fs_get_free_inodes_count(&ext2),
+			    ext2fs_get_inodes_count(&ext);
 
 		if (ext2.s_mkfs_time != 0)
 			tm = ext2.s_mkfs_time;
diff --git a/misc/fuse2fs.c b/misc/fuse2fs.c
index 9feafd72..75e87536 100644
--- a/misc/fuse2fs.c
+++ b/misc/fuse2fs.c
@@ -2368,9 +2368,9 @@ static int op_statfs(const char *path EXT2FS_ATTR((unused)),
 		buf->f_bavail = 0;
 	else
 		buf->f_bavail = free - reserved;
-	buf->f_files = fs->super->s_inodes_count;
-	buf->f_ffree = fs->super->s_free_inodes_count;
-	buf->f_favail = fs->super->s_free_inodes_count;
+	buf->f_files = ext2fs_get_inodes_count(fs->super);
+	buf->f_ffree = ext2fs_get_inodes_count(fs->super);
+	buf->f_favail = ext2fs_get_free_inodes_count(fs->super);
 	f = (uint64_t *)fs->super->s_uuid;
 	fsid = *f;
 	f++;
diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 1edc0cd1..64102b79 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -654,9 +654,9 @@ static void show_stats(ext2_filsys fs)
 
 	if (!verbose) {
 		printf(_("Creating filesystem with %llu %dk blocks and "
-			 "%u inodes\n"),
+			 "%lu inodes\n"),
 		       ext2fs_blocks_count(s), fs->blocksize >> 10,
-		       s->s_inodes_count);
+		       ext2fs_get_inodes_count(s));
 		goto skip_details;
 	}
 
@@ -682,7 +682,7 @@ static void show_stats(ext2_filsys fs)
 		       s->s_log_cluster_size);
 	printf(_("Stride=%u blocks, Stripe width=%u blocks\n"),
 	       s->s_raid_stride, s->s_raid_stripe_width);
-	printf(_("%u inodes, %llu blocks\n"), s->s_inodes_count,
+	printf(_("%lu inodes, %llu blocks\n"), ext2fs_get_inodes_count(s),
 	       ext2fs_blocks_count(s));
 	printf(_("%llu blocks (%2.2f%%) reserved for the super user\n"),
 		ext2fs_r_blocks_count(s),
@@ -1089,7 +1089,8 @@ static __u32 ok_features[3] = {
 		EXT4_FEATURE_INCOMPAT_INLINE_DATA|
 		EXT4_FEATURE_INCOMPAT_ENCRYPT |
 		EXT4_FEATURE_INCOMPAT_CSUM_SEED |
-		EXT4_FEATURE_INCOMPAT_LARGEDIR,
+		EXT4_FEATURE_INCOMPAT_LARGEDIR|
+		EXT4_FEATURE_INCOMPAT_INODE64,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE|
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -2457,13 +2458,15 @@ profile_error:
 	if (num_inodes == 0) {
 		unsigned long long n;
 		n = ext2fs_blocks_count(&fs_param) * blocksize / inode_ratio;
-		if (n > MAX_32_NUM) {
-			if (ext2fs_has_feature_64bit(&fs_param))
+		if (n > MAX_32_NUM && !(fs_param.s_feature_incompat &
+		    EXT4_FEATURE_INCOMPAT_INODE64)) {
+			if (fs_param.s_feature_incompat &
+			    EXT4_FEATURE_INCOMPAT_64BIT)
 				num_inodes = MAX_32_NUM;
 			else {
 				com_err(program_name, 0,
 					_("too many inodes (%llu), raise "
-					  "inode ratio?"), n);
+					"inode ratio?"), num_inodes);
 				exit(1);
 			}
 		}
@@ -2476,10 +2479,14 @@ profile_error:
 	/*
 	 * Calculate number of inodes based on the inode ratio
 	 */
-	fs_param.s_inodes_count = num_inodes ? num_inodes :
-		(ext2fs_blocks_count(&fs_param) * blocksize) / inode_ratio;
+	if (num_inodes == 0)
+		num_inodes = (ext2fs_blocks_count(&fs_param) * blocksize) /
+			inode_ratio;
 
-	if ((((unsigned long long)fs_param.s_inodes_count) *
+	ext2fs_set_inodes_count(&fs_param, num_inodes);
+
+
+	if ((ext2fs_get_inodes_count(&fs_param) *
 	     (inode_size ? inode_size : EXT2_GOOD_OLD_INODE_SIZE)) >=
 	    ((ext2fs_blocks_count(&fs_param)) *
 	     EXT2_BLOCK_SIZE(&fs_param))) {
@@ -2489,7 +2496,7 @@ profile_error:
 					  "specify higher inode_ratio (-i)\n\t"
 					  "or lower inode count (-N).\n"),
 			inode_size ? inode_size : EXT2_GOOD_OLD_INODE_SIZE,
-			fs_param.s_inodes_count,
+			ext2fs_get_inodes_count(&fs_param),
 			(unsigned long long) ext2fs_blocks_count(&fs_param));
 		exit(1);
 	}
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 44dd41a5..3538ab9c 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -161,7 +161,8 @@ static __u32 ok_features[3] = {
 		EXT4_FEATURE_INCOMPAT_64BIT |
 		EXT4_FEATURE_INCOMPAT_ENCRYPT |
 		EXT4_FEATURE_INCOMPAT_CSUM_SEED |
-		EXT4_FEATURE_INCOMPAT_LARGEDIR,
+		EXT4_FEATURE_INCOMPAT_LARGEDIR |
+		EXT4_FEATURE_INCOMPAT_INODE64,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -2614,21 +2615,22 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 	group = 0;
 
 	/* Protect loop from wrap-around if s_inodes_count maxed */
-	for (ino = 1; ino <= fs->super->s_inodes_count && ino > 0; ino++) {
+	for (ino = 1;
+	     ino <= ext2fs_get_inodes_count(fs->super) && ino > 0; ino++) {
 		if (!ext2fs_fast_test_inode_bitmap2(fs->inode_map, ino)) {
 			group_free++;
 			total_free++;
 		}
 		count++;
 		if ((count == fs->super->s_inodes_per_group) ||
-		    (ino == fs->super->s_inodes_count)) {
+		    (ino == ext2fs_get_inodes_count(fs->super))) {
 			ext2fs_bg_free_inodes_count_set(fs, group++,
 							group_free);
 			count = 0;
 			group_free = 0;
 		}
 	}
-	fs->super->s_free_inodes_count = total_free;
+	ext2fs_set_free_inodes_count(fs->super, total_free);
 	ext2fs_mark_super_dirty(fs);
 	return 0;
 }
diff --git a/resize/main.c b/resize/main.c
index ba6bb6b1..79523803 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -441,7 +441,8 @@ int main (int argc, char ** argv)
 			checkit = 1;
 
 		if ((fs->super->s_free_blocks_count > fs->super->s_blocks_count) ||
-		    (fs->super->s_free_inodes_count > fs->super->s_inodes_count))
+		    (ext2fs_get_free_inodes_count(fs->super) >
+		     ext2fs_get_inodes_count(fs->super)))
 			checkit = 1;
 
 		if (checkit) {
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index 0bd325ba..ec13436c 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -760,8 +760,8 @@ retry:
 				   new_inodes, ~0U);
 		return EXT2_ET_TOO_MANY_INODES;
 	}
-	fs->super->s_inodes_count = fs->super->s_inodes_per_group *
-		fs->group_desc_count;
+	ext2fs_set_inodes_count(fs->super, fs->super->s_inodes_per_group *
+		fs->group_desc_count);
 
 	/*
 	 * Adjust the number of free blocks
@@ -788,8 +788,8 @@ retry:
 	/*
 	 * Adjust the bitmaps for size
 	 */
-	retval = ext2fs_resize_inode_bitmap2(fs->super->s_inodes_count,
-					    fs->super->s_inodes_count,
+	retval = ext2fs_resize_inode_bitmap2(ext2fs_get_inodes_count(fs->super),
+					    ext2fs_get_inodes_count(fs->super),
 					    fs->inode_map);
 	if (retval) goto errout;
 
@@ -987,8 +987,9 @@ retry:
 		numblocks -= adjblocks;
 		ext2fs_free_blocks_count_set(fs->super,
 			     ext2fs_free_blocks_count(fs->super) - adjblocks);
-		fs->super->s_free_inodes_count +=
-			fs->super->s_inodes_per_group;
+		ext2fs_set_free_inodes_count(fs->super,
+				ext2fs_get_free_inodes_count(fs->super) +
+				fs->super->s_inodes_per_group);
 		ext2fs_bg_free_blocks_count_set(fs, i, numblocks);
 		ext2fs_bg_free_inodes_count_set(fs, i,
 						fs->super->s_inodes_per_group);
@@ -1046,9 +1047,9 @@ static errcode_t adjust_superblock(ext2_resize_t rfs, blk64_t new_size)
 	/*
 	 * Check to make sure there are enough inodes
 	 */
-	if ((rfs->old_fs->super->s_inodes_count -
-	     rfs->old_fs->super->s_free_inodes_count) >
-	    rfs->new_fs->super->s_inodes_count) {
+	if ((ext2fs_get_inodes_count(rfs->old_fs->super) -
+	     ext2fs_get_free_inodes_count(rfs->old_fs->super)) >
+	    ext2fs_get_inodes_count(rfs->new_fs->super)) {
 		retval = ENOSPC;
 		goto errout;
 	}
@@ -2866,7 +2867,8 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 
 	/* Protect loop from wrap-around if s_inodes_count maxed */
 	uninit = ext2fs_bg_flags_test(fs, group, EXT2_BG_INODE_UNINIT);
-	for (ino = 1; ino <= fs->super->s_inodes_count && ino > 0; ino++) {
+	for (ino = 1;
+	     ino <= ext2fs_get_inodes_count(fs->super) && ino > 0; ino++) {
 		if (uninit ||
 		    !ext2fs_fast_test_inode_bitmap2(fs->inode_map, ino)) {
 			group_free++;
@@ -2874,7 +2876,7 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 		}
 		count++;
 		if ((count == fs->super->s_inodes_per_group) ||
-		    (ino == fs->super->s_inodes_count)) {
+		    (ino == ext2fs_get_inodes_count(fs->super))) {
 			ext2fs_bg_free_inodes_count_set(fs, group, group_free);
 			ext2fs_group_desc_csum_set(fs, group);
 			group++;
@@ -2885,7 +2887,7 @@ static errcode_t ext2fs_calculate_summary_stats(ext2_filsys fs)
 			uninit = ext2fs_bg_flags_test(fs, group, EXT2_BG_INODE_UNINIT);
 		}
 	}
-	fs->super->s_free_inodes_count = total_inodes_free;
+	ext2fs_set_free_inodes_count(fs->super, total_inodes_free);
 	ext2fs_mark_super_dirty(fs);
 	return 0;
 }
@@ -2955,8 +2957,8 @@ blk64_t calculate_minimum_resize_size(ext2_filsys fs, int flags)
 	 * first figure out how many group descriptors we need to
 	 * handle the number of inodes we have
 	 */
-	inode_count = fs->super->s_inodes_count -
-		fs->super->s_free_inodes_count;
+	inode_count = ext2fs_get_inodes_count(fs->super) -
+		ext2fs_get_free_inodes_count(fs->super);
 	blks_needed = ext2fs_div_ceil(inode_count,
 				      fs->super->s_inodes_per_group) *
 		(blk64_t) EXT2_BLOCKS_PER_GROUP(fs->super);
diff --git a/tests/progs/test_icount.c b/tests/progs/test_icount.c
index d028a601..b4dd013b 100644
--- a/tests/progs/test_icount.c
+++ b/tests/progs/test_icount.c
@@ -208,7 +208,7 @@ void do_dump(int argc, char **argv)
 
 	if (check_icount(argv[0]))
 		return;
-	for (i=1; i <= test_fs->super->s_inodes_count; i++) {
+	for (i = 1; i <= ext2fs_get_inodes_count(test_fs->super); i++) {
 		retval = ext2fs_icount_fetch(test_icount, i, &count);
 		if (retval) {
 			com_err(argv[0], retval,
@@ -312,7 +312,7 @@ int main(int argc, char **argv)
 	 */
 	memset(&param, 0, sizeof(struct ext2_super_block));
 	ext2fs_blocks_count_set(&param, 80000);
-	param.s_inodes_count = 20000;
+	ext2fs_set_inodes_count(&param, 20000);
 	retval = ext2fs_initialize("/dev/null", 0, &param,
 				   unix_io_manager, &test_fs);
 	if (retval) {
-- 
2.13.6 (Apple Git-96)
