From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 04/12] e2fsck: clean up feature test macros with predicate
 functions
Date: Mon, 12 Oct 2015 14:56:54 -0700
Message-ID: <20151012215654.29065.20743.stgit@birch.djwong.org>
References: <20151012215629.29065.24418.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44589 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbbJLV5B (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Oct 2015 17:57:01 -0400
In-Reply-To: <20151012215629.29065.24418.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Create separate predicate functions to test/set/clear feature flags,
thereby replacing the wordy old macros.  Furthermore, clean out the
places where we open-coded feature tests.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/extents.c  |    9 +++-----
 e2fsck/journal.c  |   52 ++++++++++++++++++++---------------------------
 e2fsck/message.c  |    3 +--
 e2fsck/pass1.c    |   59 ++++++++++++++++++++---------------------------------
 e2fsck/pass1b.c   |    4 ++--
 e2fsck/pass2.c    |   36 ++++++++++++--------------------
 e2fsck/pass3.c    |    3 +--
 e2fsck/pass5.c    |    6 ++---
 e2fsck/quota.c    |    5 ++--
 e2fsck/recovery.c |   18 ++++++----------
 e2fsck/rehash.c   |   16 +++++---------
 e2fsck/super.c    |   46 ++++++++++++++---------------------------
 e2fsck/unix.c     |    9 ++++----
 13 files changed, 101 insertions(+), 165 deletions(-)


diff --git a/e2fsck/extents.c b/e2fsck/extents.c
index 407dafb..c4167e1 100644
--- a/e2fsck/extents.c
+++ b/e2fsck/extents.c
@@ -29,8 +29,7 @@ errcode_t e2fsck_rebuild_extents_later(e2fsck_t ctx, ext2_ino_t ino)
 {
 	errcode_t retval = 0;
 
-	if (!EXT2_HAS_INCOMPAT_FEATURE(ctx->fs->super,
-				       EXT3_FEATURE_INCOMPAT_EXTENTS) ||
+	if (!ext2fs_has_feature_extents(ctx->fs->super) ||
 	    (ctx->options & E2F_OPT_NO) ||
 	    (ino != EXT2_ROOT_INO && ino < ctx->fs->super->s_first_ino))
 		return 0;
@@ -314,8 +313,7 @@ static errcode_t e2fsck_rebuild_extents(e2fsck_t ctx, ext2_ino_t ino)
 	struct extent_list	list;
 	errcode_t err;
 
-	if (!EXT2_HAS_INCOMPAT_FEATURE(ctx->fs->super,
-				       EXT3_FEATURE_INCOMPAT_EXTENTS) ||
+	if (!ext2fs_has_feature_extents(ctx->fs->super) ||
 	    (ctx->options & E2F_OPT_NO) ||
 	    (ino != EXT2_ROOT_INO && ino < ctx->fs->super->s_first_ino))
 		return 0;
@@ -344,8 +342,7 @@ static void rebuild_extents(e2fsck_t ctx, const char *pass_name, int pr_header)
 	ext2_ino_t		ino = 0;
 	errcode_t		retval;
 
-	if (!EXT2_HAS_INCOMPAT_FEATURE(ctx->fs->super,
-				       EXT3_FEATURE_INCOMPAT_EXTENTS) ||
+	if (!ext2fs_has_feature_extents(ctx->fs->super) ||
 	    !ext2fs_test_valid(ctx->fs) ||
 	    ctx->invalid_bitmaps) {
 		if (ctx->inodes_to_rebuild)
diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index 9f32095..c8ac57d 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -239,7 +239,7 @@ void wait_on_buffer(struct buffer_head *bh)
 
 static void e2fsck_clear_recover(e2fsck_t ctx, int error)
 {
-	ctx->fs->super->s_feature_incompat &= ~EXT3_FEATURE_INCOMPAT_RECOVER;
+	ext2fs_clear_feature_journal_needs_recovery(ctx->fs->super);
 
 	/* if we had an error doing journal recovery, we need a full fsck */
 	if (error)
@@ -461,7 +461,7 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
 			ext2fs_swap_super(&jsuper);
 #endif
 		if (jsuper.s_magic != EXT2_SUPER_MAGIC ||
-		    !(jsuper.s_feature_incompat & EXT3_FEATURE_INCOMPAT_JOURNAL_DEV)) {
+		    !ext2fs_has_feature_journal_dev(&jsuper)) {
 			fix_problem(ctx, PR_0_EXT_JOURNAL_BAD_SUPER, &pctx);
 			retval = EXT2_ET_LOAD_EXT_JOURNAL;
 			brelse(bh);
@@ -477,8 +477,7 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
 		}
 
 		/* Check the superblock checksum */
-		if (jsuper.s_feature_ro_compat &
-		    EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) {
+		if (ext2fs_has_feature_metadata_csum(&jsuper)) {
 			struct struct_ext2_filsys fsx;
 			struct ext2_super_block	superx;
 			void *p;
@@ -487,8 +486,7 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
 			memcpy(&fsx, ctx->fs, sizeof(fsx));
 			memcpy(&superx, ctx->fs->super, sizeof(superx));
 			fsx.super = &superx;
-			fsx.super->s_feature_ro_compat |=
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM;
+			ext2fs_set_feature_metadata_csum(fsx.super);
 			if (!ext2fs_superblock_csum_verify(&fsx, p) &&
 			    fix_problem(ctx, PR_0_EXT_JOURNAL_SUPER_CSUM_INVALID,
 					&pctx)) {
@@ -535,10 +533,8 @@ static errcode_t e2fsck_journal_fix_bad_inode(e2fsck_t ctx,
 					      struct problem_context *pctx)
 {
 	struct ext2_super_block *sb = ctx->fs->super;
-	int recover = ctx->fs->super->s_feature_incompat &
-		EXT3_FEATURE_INCOMPAT_RECOVER;
-	int has_journal = ctx->fs->super->s_feature_compat &
-		EXT3_FEATURE_COMPAT_HAS_JOURNAL;
+	int recover = ext2fs_has_feature_journal_needs_recovery(ctx->fs->super);
+	int has_journal = ext2fs_has_feature_journal(ctx->fs->super);
 
 	if (has_journal || sb->s_journal_inum) {
 		/* The journal inode is bogus, remove and force full fsck */
@@ -546,7 +542,7 @@ static errcode_t e2fsck_journal_fix_bad_inode(e2fsck_t ctx,
 		if (fix_problem(ctx, PR_0_JOURNAL_BAD_INODE, pctx)) {
 			if (has_journal && sb->s_journal_inum)
 				printf("*** journal has been deleted ***\n\n");
-			sb->s_feature_compat &= ~EXT3_FEATURE_COMPAT_HAS_JOURNAL;
+			ext2fs_clear_feature_journal(sb);
 			sb->s_journal_inum = 0;
 			memset(sb->s_jnl_blocks, 0, sizeof(sb->s_jnl_blocks));
 			ctx->flags |= E2F_FLAG_JOURNAL_INODE;
@@ -647,12 +643,11 @@ static errcode_t e2fsck_journal_load(journal_t *journal)
 		return EXT2_ET_RO_UNSUPP_FEATURE;
 
 	/* Checksum v1-3 are mutually exclusive features. */
-	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_CSUM_V2) &&
-	    JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_CSUM_V3))
+	if (jfs_has_feature_csum2(journal) && jfs_has_feature_csum3(journal))
 		return EXT2_ET_CORRUPT_SUPERBLOCK;
 
 	if (journal_has_csum_v2or3(journal) &&
-	    JFS_HAS_COMPAT_FEATURE(journal, JFS_FEATURE_COMPAT_CHECKSUM))
+	    jfs_has_feature_checksum(journal))
 		return EXT2_ET_CORRUPT_SUPERBLOCK;
 
 	if (!e2fsck_journal_verify_csum_type(journal, jsb) ||
@@ -741,10 +736,9 @@ static errcode_t e2fsck_journal_fix_corrupt_super(e2fsck_t ctx,
 						  struct problem_context *pctx)
 {
 	struct ext2_super_block *sb = ctx->fs->super;
-	int recover = ctx->fs->super->s_feature_incompat &
-		EXT3_FEATURE_INCOMPAT_RECOVER;
+	int recover = ext2fs_has_feature_journal_needs_recovery(ctx->fs->super);
 
-	if (sb->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL) {
+	if (ext2fs_has_feature_journal(sb)) {
 		if (fix_problem(ctx, PR_0_JOURNAL_BAD_SUPER, pctx)) {
 			e2fsck_journal_reset_super(ctx, journal->j_superblock,
 						   journal);
@@ -799,15 +793,14 @@ errcode_t e2fsck_check_ext3_journal(e2fsck_t ctx)
 {
 	struct ext2_super_block *sb = ctx->fs->super;
 	journal_t *journal;
-	int recover = ctx->fs->super->s_feature_incompat &
-		EXT3_FEATURE_INCOMPAT_RECOVER;
+	int recover = ext2fs_has_feature_journal_needs_recovery(ctx->fs->super);
 	struct problem_context pctx;
 	problem_t problem;
 	int reset = 0, force_fsck = 0;
 	errcode_t retval;
 
 	/* If we don't have any journal features, don't do anything more */
-	if (!(sb->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL) &&
+	if (!ext2fs_has_feature_journal(sb) &&
 	    !recover && sb->s_journal_inum == 0 && sb->s_journal_dev == 0 &&
 	    uuid_is_null(sb->s_journal_uuid))
  		return 0;
@@ -848,8 +841,8 @@ errcode_t e2fsck_check_ext3_journal(e2fsck_t ctx)
 	 * with -y, -n, or -p, only if a user isn't making up their mind.
 	 */
 no_has_journal:
-	if (!(sb->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL)) {
-		recover = sb->s_feature_incompat & EXT3_FEATURE_INCOMPAT_RECOVER;
+	if (!ext2fs_has_feature_journal(sb)) {
+		recover = ext2fs_has_feature_journal_needs_recovery(sb);
 		if (fix_problem(ctx, PR_0_JOURNAL_HAS_JOURNAL, &pctx)) {
 			if (recover &&
 			    !fix_problem(ctx, PR_0_JOURNAL_RECOVER_SET, &pctx))
@@ -867,14 +860,14 @@ no_has_journal:
 			       sizeof(sb->s_journal_uuid));
 			e2fsck_clear_recover(ctx, force_fsck);
 		} else if (!(ctx->options & E2F_OPT_READONLY)) {
-			sb->s_feature_compat |= EXT3_FEATURE_COMPAT_HAS_JOURNAL;
+			ext2fs_set_feature_journal(sb);
 			ctx->fs->flags &= ~EXT2_FLAG_MASTER_SB_ONLY;
 			ext2fs_mark_super_dirty(ctx->fs);
 		}
 	}
 
-	if (sb->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL &&
-	    !(sb->s_feature_incompat & EXT3_FEATURE_INCOMPAT_RECOVER) &&
+	if (ext2fs_has_feature_journal(sb) &&
+	    !ext2fs_has_feature_journal_needs_recovery(sb) &&
 	    journal->j_superblock->s_start != 0) {
 		/* Print status information */
 		fix_problem(ctx, PR_0_JOURNAL_RECOVERY_CLEAR, &pctx);
@@ -884,8 +877,7 @@ no_has_journal:
 			problem = PR_0_JOURNAL_RUN;
 		if (fix_problem(ctx, problem, &pctx)) {
 			ctx->options |= E2F_OPT_FORCE;
-			sb->s_feature_incompat |=
-				EXT3_FEATURE_INCOMPAT_RECOVER;
+			ext2fs_set_feature_journal_needs_recovery(sb);
 			ext2fs_mark_super_dirty(ctx->fs);
 		} else if (fix_problem(ctx,
 				       PR_0_JOURNAL_RESET_JOURNAL, &pctx)) {
@@ -911,7 +903,7 @@ no_has_journal:
 	 * the journal's errno is set; if so, we need to mark the file
 	 * system as being corrupt and clear the journal's s_errno.
 	 */
-	if (!(sb->s_feature_incompat & EXT3_FEATURE_INCOMPAT_RECOVER) &&
+	if (!ext2fs_has_feature_journal_needs_recovery(sb) &&
 	    journal->j_superblock->s_errno) {
 		ctx->fs->super->s_state |= EXT2_ERROR_FS;
 		ext2fs_mark_super_dirty(ctx->fs);
@@ -1047,7 +1039,7 @@ void e2fsck_move_ext3_journal(e2fsck_t ctx)
 	 */
 	if ((ctx->options & E2F_OPT_READONLY) ||
 	    (sb->s_journal_inum == 0) ||
-	    !(sb->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL))
+	    !ext2fs_has_feature_journal(sb))
 		return;
 
 	/*
@@ -1159,7 +1151,7 @@ int e2fsck_fix_ext3_journal_hint(e2fsck_t ctx)
 	char uuid[37], *journal_name;
 	struct stat st;
 
-	if (!(sb->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL) ||
+	if (!ext2fs_has_feature_journal(sb) ||
 	    uuid_is_null(sb->s_journal_uuid))
  		return 0;
 
diff --git a/e2fsck/message.c b/e2fsck/message.c
index 9c1433f..74e7b94 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -296,8 +296,7 @@ static _INLINE_ void expand_inode_expression(FILE *f, ext2_filsys fs, char ch,
 		fprintf(f, "%u", large_inode->i_extra_isize);
 		break;
 	case 'b':
-		if (fs->super->s_feature_ro_compat &
-		    EXT4_FEATURE_RO_COMPAT_HUGE_FILE) 
+		if (ext2fs_has_feature_huge_file(fs->super)) 
 			fprintf(f, "%llu", inode->i_blocks +
 				(((long long) inode->osd2.linux2.l_i_blocks_hi)
 				 << 32));
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 61ae2d9..0a8e23e 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -540,10 +540,8 @@ static void check_is_really_dir(e2fsck_t ctx, struct problem_context *pctx,
 	 * data.  If it's true, we will treat it as a directory.
 	 */
 
-	extent_fs = (ctx->fs->super->s_feature_incompat &
-		     EXT3_FEATURE_INCOMPAT_EXTENTS);
-	inlinedata_fs = (ctx->fs->super->s_feature_incompat &
-			 EXT4_FEATURE_INCOMPAT_INLINE_DATA);
+	extent_fs = ext2fs_has_feature_extents(ctx->fs->super);
+	inlinedata_fs = ext2fs_has_feature_inline_data(ctx->fs->super);
 	if (inlinedata_fs && (inode->i_flags & EXT4_INLINE_DATA_FL)) {
 		size_t size;
 		__u32 dotdot;
@@ -830,10 +828,8 @@ static int fix_inline_data_extents_file(e2fsck_t ctx,
 	int dirty = 0;
 
 	/* Both feature flags not set?  Just run the regular checks */
-	if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-				       EXT3_FEATURE_INCOMPAT_EXTENTS) &&
-	    !EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_INCOMPAT_INLINE_DATA))
+	if (!ext2fs_has_feature_extents(fs->super) &&
+	    !ext2fs_has_feature_inline_data(fs->super))
 		return 0;
 
 	/* Clear both flags if it's a special file */
@@ -992,7 +988,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 	if (!(ctx->options & E2F_OPT_PREEN))
 		fix_problem(ctx, PR_1_PASS_HEADER, &pctx);
 
-	if ((fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_DIR_INDEX) &&
+	if (ext2fs_has_feature_dir_index(fs->super) &&
 	    !(ctx->options & E2F_OPT_NO)) {
 		if (ext2fs_u32_list_create(&ctx->dirs_to_hash, 50))
 			ctx->dirs_to_hash = 0;
@@ -1013,10 +1009,9 @@ void e2fsck_pass1(e2fsck_t ctx)
 	}
 #undef EXT2_BPP
 
-	imagic_fs = (sb->s_feature_compat & EXT2_FEATURE_COMPAT_IMAGIC_INODES);
-	extent_fs = (sb->s_feature_incompat & EXT3_FEATURE_INCOMPAT_EXTENTS);
-	inlinedata_fs = (sb->s_feature_incompat &
-			EXT4_FEATURE_INCOMPAT_INLINE_DATA);
+	imagic_fs = ext2fs_has_feature_imagic_inodes(sb);
+	extent_fs = ext2fs_has_feature_extents(sb);
+	inlinedata_fs = ext2fs_has_feature_inline_data(sb);
 
 	/*
 	 * Allocate bitmaps structures
@@ -1150,7 +1145,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 	     fs->super->s_mkfs_time < fs->super->s_inodes_count))
 		low_dtime_check = 0;
 
-	if ((fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) &&
+	if (ext2fs_has_feature_mmp(fs->super) &&
 	    fs->super->s_mmp_block > fs->super->s_first_data_block &&
 	    fs->super->s_mmp_block < ext2fs_blocks_count(fs->super))
 		ext2fs_mark_block_bitmap2(ctx->block_found_map,
@@ -1263,8 +1258,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 			pctx.errcode = ext2fs_inline_data_size(fs, ino, &size);
 			if (!pctx.errcode && size &&
 			    fix_problem(ctx, PR_1_INLINE_DATA_FEATURE, &pctx)) {
-				sb->s_feature_incompat |=
-					EXT4_FEATURE_INCOMPAT_INLINE_DATA;
+				ext2fs_set_feature_inline_data(sb);
 				ext2fs_mark_super_dirty(fs);
 				inlinedata_fs = 1;
 			} else if (fix_problem(ctx, PR_1_INLINE_DATA_SET, &pctx)) {
@@ -1353,7 +1347,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 			if ((ext2fs_extent_header_verify(inode->i_block,
 						 sizeof(inode->i_block)) == 0) &&
 			    fix_problem(ctx, PR_1_EXTENT_FEATURE, &pctx)) {
-				sb->s_feature_incompat |= EXT3_FEATURE_INCOMPAT_EXTENTS;
+				ext2fs_set_feature_extents(sb);
 				ext2fs_mark_super_dirty(fs);
 				extent_fs = 1;
 			} else if (fix_problem(ctx, PR_1_EXTENTS_SET, &pctx)) {
@@ -1507,8 +1501,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 		} else if ((ino == EXT4_USR_QUOTA_INO) ||
 			   (ino == EXT4_GRP_QUOTA_INO)) {
 			ext2fs_mark_inode_bitmap2(ctx->inode_used_map, ino);
-			if ((fs->super->s_feature_ro_compat &
-					EXT4_FEATURE_RO_COMPAT_QUOTA) &&
+			if (ext2fs_has_feature_quota(fs->super) &&
 			    ((fs->super->s_usr_quota_inum == ino) ||
 			     (fs->super->s_grp_quota_inum == ino))) {
 				if (!LINUX_S_ISREG(inode->i_mode) &&
@@ -1639,13 +1632,11 @@ void e2fsck_pass1(e2fsck_t ctx)
 		    (LINUX_S_ISDIR(inode->i_mode) && inode->i_dir_acl))
 			mark_inode_bad(ctx, ino);
 		if ((fs->super->s_creator_os == EXT2_OS_LINUX) &&
-		    !(fs->super->s_feature_incompat &
-		      EXT4_FEATURE_INCOMPAT_64BIT) &&
+		    !ext2fs_has_feature_64bit(fs->super) &&
 		    inode->osd2.linux2.l_i_file_acl_high != 0)
 			mark_inode_bad(ctx, ino);
 		if ((fs->super->s_creator_os == EXT2_OS_LINUX) &&
-		    !(fs->super->s_feature_ro_compat &
-		      EXT4_FEATURE_RO_COMPAT_HUGE_FILE) &&
+		    !ext2fs_has_feature_huge_file(fs->super) &&
 		    (inode->osd2.linux2.l_i_blocks_hi != 0))
 			mark_inode_bad(ctx, ino);
 		if (inode->i_flags & EXT2_IMAGIC_FL) {
@@ -2154,7 +2145,7 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 	 * Or if the extended attribute block is an invalid block,
 	 * then the inode is also corrupted.
 	 */
-	if (!(fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR) ||
+	if (!ext2fs_has_feature_xattr(fs->super) ||
 	    (blk < fs->super->s_first_data_block) ||
 	    (blk >= ext2fs_blocks_count(fs->super))) {
 		mark_inode_bad(ctx, ino);
@@ -2348,7 +2339,7 @@ static int handle_htree(e2fsck_t ctx, struct problem_context *pctx,
 
 	if ((!LINUX_S_ISDIR(inode->i_mode) &&
 	     fix_problem(ctx, PR_1_HTREE_NODIR, pctx)) ||
-	    (!(fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_DIR_INDEX) &&
+	    (!ext2fs_has_feature_dir_index(fs->super) &&
 	     fix_problem(ctx, PR_1_HTREE_SET, pctx)))
 		return 1;
 
@@ -2982,10 +2973,8 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	pctx->ino = ino;
 	pctx->errcode = 0;
 
-	extent_fs = (ctx->fs->super->s_feature_incompat &
-                     EXT3_FEATURE_INCOMPAT_EXTENTS);
-	inlinedata_fs = (ctx->fs->super->s_feature_incompat &
-			 EXT4_FEATURE_INCOMPAT_INLINE_DATA);
+	extent_fs = ext2fs_has_feature_extents(ctx->fs->super);
+	inlinedata_fs = ext2fs_has_feature_inline_data(ctx->fs->super);
 
 	if (check_ext_attr(ctx, pctx, block_buf)) {
 		if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
@@ -3085,8 +3074,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		quota_data_inodes(ctx->qctx, inode, ino, +1);
 	}
 
-	if (!(fs->super->s_feature_ro_compat &
-	      EXT4_FEATURE_RO_COMPAT_HUGE_FILE) ||
+	if (!ext2fs_has_feature_huge_file(fs->super) ||
 	    !(inode->i_flags & EXT4_HUGE_FILE_FL))
 		pb.num_blocks *= (fs->blocksize / 512);
 	pb.num_blocks *= EXT2FS_CLUSTER_RATIO(fs);
@@ -3170,8 +3158,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		ctx->large_files++;
 	if ((fs->super->s_creator_os == EXT2_OS_LINUX) &&
 	    ((pb.num_blocks != ext2fs_inode_i_blocks(fs, inode)) ||
-	     ((fs->super->s_feature_ro_compat &
-	       EXT4_FEATURE_RO_COMPAT_HUGE_FILE) &&
+	     (ext2fs_has_feature_huge_file(fs->super) &&
 	      (inode->i_flags & EXT4_HUGE_FILE_FL) &&
 	      (inode->osd2.linux2.l_i_blocks_hi != 0)))) {
 		pctx->num = pb.num_blocks;
@@ -3188,8 +3175,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	 * a block mapped file, so rebuild it as an extent file.  We can skip
 	 * symlinks because they're never rewritten.
 	 */
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-			EXT4_FEATURE_RO_COMPAT_BIGALLOC) &&
+	if (ext2fs_has_feature_bigalloc(fs->super) &&
 	    (LINUX_S_ISREG(inode->i_mode) || LINUX_S_ISDIR(inode->i_mode)) &&
 	    ext2fs_inode_data_blocks2(fs, inode) > 0 &&
 	    (ino == EXT2_ROOT_INO || ino >= EXT2_FIRST_INO(fs->super)) &&
@@ -3655,8 +3641,7 @@ static void new_table_block(e2fsck_t ctx, blk64_t first_block, dgrp_t group,
 	 * within the flex_bg, and if that fails then try finding the
 	 * space anywhere in the filesystem.
 	 */
-	is_flexbg = EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-					      EXT4_FEATURE_INCOMPAT_FLEX_BG);
+	is_flexbg = ext2fs_has_feature_flex_bg(fs->super);
 	if (is_flexbg) {
 		flexbg_size = 1 << fs->super->s_log_groups_per_flex;
 		flexbg = group / flexbg_size;
diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index e0f34e0..2cbf82a 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -327,7 +327,7 @@ static void pass1b(e2fsck_t ctx, char *block_buf)
 					     BLOCK_FLAG_READ_ONLY, block_buf,
 					     process_pass1b_block, &pb);
 		/* If the feature is not set, attrs will be cleared later anyway */
-		if ((fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR) &&
+		if (ext2fs_has_feature_xattr(fs->super) &&
 		    ext2fs_file_acl_block(fs, &inode)) {
 			blk64_t blk = ext2fs_file_acl_block(fs, &inode);
 			process_pass1b_block(fs, &blk,
@@ -686,7 +686,7 @@ static void delete_file(e2fsck_t ctx, ext2_ino_t ino,
 	e2fsck_read_inode(ctx, ino, &dp->inode, "delete_file");
 	e2fsck_clear_inode(ctx, ino, &dp->inode, 0, "delete_file");
 	if (ext2fs_file_acl_block(fs, &dp->inode) &&
-	    (fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR)) {
+	    ext2fs_has_feature_xattr(fs->super)) {
 		count = 1;
 		pctx.errcode = ext2fs_adjust_ea_refcount3(fs,
 					ext2fs_file_acl_block(fs, &dp->inode),
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 4b81575..532b0eb 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -155,7 +155,7 @@ void e2fsck_pass2(e2fsck_t ctx)
 	if (ctx->progress)
 		(void) (ctx->progress)(ctx, 2, 0, cd.max);
 
-	if (fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_DIR_INDEX)
+	if (ext2fs_has_feature_dir_index(fs->super))
 		ext2fs_dblist_sort2(fs->dblist, special_dir_block_cmp);
 
 	check_dir_func = cd.ra_entries ? check_dir_block2 : check_dir_block;
@@ -282,11 +282,9 @@ void e2fsck_pass2(e2fsck_t ctx)
 
 	clear_problem_context(&pctx);
 	if (ctx->large_files) {
-		if (!(sb->s_feature_ro_compat &
-		      EXT2_FEATURE_RO_COMPAT_LARGE_FILE) &&
+		if (!ext2fs_has_feature_large_file(sb) &&
 		    fix_problem(ctx, PR_2_FEATURE_LARGE_FILES, &pctx)) {
-			sb->s_feature_ro_compat |=
-				EXT2_FEATURE_RO_COMPAT_LARGE_FILE;
+			ext2fs_set_feature_large_file(sb);
 			fs->flags &= ~EXT2_FLAG_MASTER_SB_ONLY;
 			ext2fs_mark_super_dirty(fs);
 		}
@@ -520,8 +518,7 @@ static _INLINE_ int check_filetype(e2fsck_t ctx,
 	int	should_be = EXT2_FT_UNKNOWN;
 	struct ext2_inode	inode;
 
-	if (!(ctx->fs->super->s_feature_incompat &
-	      EXT2_FEATURE_INCOMPAT_FILETYPE)) {
+	if (!ext2fs_has_feature_filetype(ctx->fs->super)) {
 		if (filetype == 0 ||
 		    !fix_problem(ctx, PR_2_CLEAR_FILETYPE, pctx))
 			return 0;
@@ -611,8 +608,7 @@ static void parse_int_node(ext2_filsys fs,
 #endif
 
 	count = ext2fs_le16_to_cpu(limit->count);
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (ext2fs_has_feature_metadata_csum(fs->super))
 		csum_size = sizeof(struct ext2_dx_tail);
 	expect_limit = (fs->blocksize -
 			(csum_size + ((char *) ent - block_buf))) /
@@ -932,14 +928,12 @@ static int check_dir_block(ext2_filsys fs,
 	if (ctx->progress && (ctx->progress)(ctx, 2, cd->count++, cd->max))
 		return DIRENT_ABORT;
 
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)) {
+	if (ext2fs_has_feature_metadata_csum(fs->super)) {
 		dx_csum_size = sizeof(struct ext2_dx_tail);
 		de_csum_size = sizeof(struct ext2_dir_entry_tail);
 	}
 
-	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-				      EXT2_FEATURE_INCOMPAT_FILETYPE))
+	if (ext2fs_has_feature_filetype(fs->super))
 		filetype = EXT2_FT_DIR << 8;
 
 	/*
@@ -956,8 +950,7 @@ static int check_dir_block(ext2_filsys fs,
 	cd->pctx.dirent = 0;
 	cd->pctx.num = 0;
 
-	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-				      EXT4_FEATURE_INCOMPAT_INLINE_DATA)) {
+	if (ext2fs_has_feature_inline_data(fs->super)) {
 		errcode_t ec;
 
 		ec = ext2fs_inline_data_size(fs, ino, &inline_data_size);
@@ -1512,8 +1505,7 @@ skip_checksum:
 	if (dir_modified) {
 		int	flags, will_rehash;
 		/* leaf block with no tail?  Rehash dirs later. */
-		if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
+		if (ext2fs_has_feature_metadata_csum(fs->super) &&
 		    is_leaf &&
 		    !inline_data_size &&
 		    !ext2fs_dirent_has_tail(fs, (struct ext2_dir_entry *)buf)) {
@@ -1640,7 +1632,7 @@ static void deallocate_inode(e2fsck_t ctx, ext2_ino_t ino, char* block_buf)
 	ext2fs_inode_alloc_stats2(fs, ino, -1, LINUX_S_ISDIR(inode.i_mode));
 
 	if (ext2fs_file_acl_block(fs, &inode) &&
-	    (fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR)) {
+	    ext2fs_has_feature_xattr(fs->super)) {
 		pctx.errcode = ext2fs_adjust_ea_refcount3(fs,
 				ext2fs_file_acl_block(fs, &inode),
 				block_buf, -1, &count, ino);
@@ -1722,7 +1714,7 @@ int e2fsck_process_bad_inode(e2fsck_t ctx, ext2_ino_t dir,
 	pctx.inode = &inode;
 
 	if (ext2fs_file_acl_block(fs, &inode) &&
-	    !(fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR)) {
+	    !ext2fs_has_feature_xattr(fs->super)) {
 		if (fix_problem(ctx, PR_2_FILE_ACL_ZERO, &pctx)) {
 			ext2fs_file_acl_block_set(fs, &inode, 0);
 			inode_modified++;
@@ -1799,8 +1791,7 @@ int e2fsck_process_bad_inode(e2fsck_t ctx, ext2_ino_t dir,
 	}
 
 	if ((fs->super->s_creator_os == EXT2_OS_LINUX) &&
-	    !(fs->super->s_feature_ro_compat &
-	      EXT4_FEATURE_RO_COMPAT_HUGE_FILE) &&
+	    !ext2fs_has_feature_huge_file(fs->super) &&
 	    (inode.osd2.linux2.l_i_blocks_hi != 0)) {
 		pctx.num = inode.osd2.linux2.l_i_blocks_hi;
 		if (fix_problem(ctx, PR_2_BLOCKS_HI_ZERO, &pctx)) {
@@ -1810,8 +1801,7 @@ int e2fsck_process_bad_inode(e2fsck_t ctx, ext2_ino_t dir,
 	}
 
 	if ((fs->super->s_creator_os == EXT2_OS_LINUX) &&
-	    !(fs->super->s_feature_incompat &
-	     EXT4_FEATURE_INCOMPAT_64BIT) &&
+	    !ext2fs_has_feature_64bit(fs->super) &&
 	    inode.osd2.linux2.l_i_file_acl_high != 0) {
 		pctx.num = inode.osd2.linux2.l_i_file_acl_high;
 		if (fix_problem(ctx, PR_2_I_FILE_ACL_HI_ZERO, &pctx)) {
diff --git a/e2fsck/pass3.c b/e2fsck/pass3.c
index d7b8802..3b076c4 100644
--- a/e2fsck/pass3.c
+++ b/e2fsck/pass3.c
@@ -716,8 +716,7 @@ static int fix_dotdot_proc(struct ext2_dir_entry *dirent,
 		fix_problem(fp->ctx, PR_3_ADJUST_INODE, &pctx);
 	}
 	dirent->inode = fp->parent;
-	if (fp->ctx->fs->super->s_feature_incompat &
-	    EXT2_FEATURE_INCOMPAT_FILETYPE)
+	if (ext2fs_has_feature_filetype(fp->ctx->fs->super))
 		ext2fs_dirent_set_file_type(dirent, EXT2_FT_DIR);
 	else
 		ext2fs_dirent_set_file_type(dirent, EXT2_FT_UNKNOWN);
diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index 64fb7fe..4a7e53c 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -90,8 +90,7 @@ static void check_inode_bitmap_checksum(e2fsck_t ctx)
 	ext2_ino_t	ino_itr;
 	errcode_t	retval;
 
-	if (!EXT2_HAS_RO_COMPAT_FEATURE(ctx->fs->super,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext2fs_has_feature_metadata_csum(ctx->fs->super))
 		return;
 
 	/* If bitmap is dirty from being fixed, checksum will be corrected */
@@ -145,8 +144,7 @@ static void check_block_bitmap_checksum(e2fsck_t ctx)
 	blk64_t		blk_itr;
 	errcode_t	retval;
 
-	if (!EXT2_HAS_RO_COMPAT_FEATURE(ctx->fs->super,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (!ext2fs_has_feature_metadata_csum(ctx->fs->super))
 		return;
 
 	/* If bitmap is dirty from being fixed, checksum will be corrected */
diff --git a/e2fsck/quota.c b/e2fsck/quota.c
index 2293aad..4c431f8 100644
--- a/e2fsck/quota.c
+++ b/e2fsck/quota.c
@@ -37,8 +37,7 @@ static void move_quota_inode(ext2_filsys fs, ext2_ino_t from_ino,
 	inode.i_links_count = 1;
 	inode.i_mode = LINUX_S_IFREG | 0600;
 	inode.i_flags = EXT2_IMMUTABLE_FL;
-	if (fs->super->s_feature_incompat &
-			EXT3_FEATURE_INCOMPAT_EXTENTS)
+	if (ext2fs_has_feature_extents(fs->super))
 		inode.i_flags |= EXT4_EXTENTS_FL;
 
 	retval = ext2fs_write_new_inode(fs, to_ino, &inode);
@@ -66,7 +65,7 @@ void e2fsck_hide_quota(e2fsck_t ctx)
 	clear_problem_context(&pctx);
 
 	if ((ctx->options & E2F_OPT_READONLY) ||
-	    !(sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_QUOTA))
+	    !ext2fs_has_feature_quota(sb))
 		return;
 
 	pctx.ino = sb->s_usr_quota_inum;
diff --git a/e2fsck/recovery.c b/e2fsck/recovery.c
index d5244be..41bda03 100644
--- a/e2fsck/recovery.c
+++ b/e2fsck/recovery.c
@@ -342,7 +342,7 @@ static inline unsigned long long read_tag_block(journal_t *journal,
 						journal_block_tag_t *tag)
 {
 	unsigned long long block = ext2fs_be32_to_cpu(tag->t_blocknr);
-	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_64BIT))
+	if (jfs_has_feature_64bit(journal))
 		block |= (u64)ext2fs_be32_to_cpu(tag->t_blocknr_high) << 32;
 	return block;
 }
@@ -411,7 +411,7 @@ static int jbd2_block_tag_csum_verify(journal_t *j, journal_block_tag_t *tag,
 	csum32 = jbd2_chksum(j, j->j_csum_seed, (__u8 *)&seq, sizeof(seq));
 	csum32 = jbd2_chksum(j, csum32, buf, j->j_blocksize);
 
-	if (JFS_HAS_INCOMPAT_FEATURE(j, JFS_FEATURE_INCOMPAT_CSUM_V3))
+	if (jfs_has_feature_csum3(j))
 		return tag3->t_checksum == ext2fs_cpu_to_be32(csum32);
 
 	return tag->t_checksum == ext2fs_cpu_to_be16(csum32);
@@ -535,8 +535,7 @@ static int do_one_pass(journal_t *journal,
 			 * just skip over the blocks it describes. */
 			if (pass != PASS_REPLAY) {
 				if (pass == PASS_SCAN &&
-				    JFS_HAS_COMPAT_FEATURE(journal,
-					    JFS_FEATURE_COMPAT_CHECKSUM) &&
+				    jfs_has_feature_checksum(journal) &&
 				    !info->end_transaction) {
 					if (calc_chksums(journal, bh,
 							&next_log_block,
@@ -691,8 +690,7 @@ static int do_one_pass(journal_t *journal,
 			 * much to do other than move on to the next sequence
 			 * number. */
 			if (pass == PASS_SCAN &&
-			    JFS_HAS_COMPAT_FEATURE(journal,
-				    JFS_FEATURE_COMPAT_CHECKSUM)) {
+			    jfs_has_feature_checksum(journal)) {
 				int chksum_err, chksum_seen;
 				struct commit_header *cbh =
 					(struct commit_header *)bh->b_data;
@@ -732,8 +730,7 @@ static int do_one_pass(journal_t *journal,
 				if (chksum_err) {
 					info->end_transaction = next_commit_ID;
 
-					if (!JFS_HAS_INCOMPAT_FEATURE(journal,
-					   JFS_FEATURE_INCOMPAT_ASYNC_COMMIT)){
+					if (!jfs_has_feature_async_commit(journal)){
 						journal->j_failed_commit =
 							next_commit_ID;
 						brelse(bh);
@@ -747,8 +744,7 @@ static int do_one_pass(journal_t *journal,
 							   bh->b_data)) {
 				info->end_transaction = next_commit_ID;
 
-				if (!JFS_HAS_INCOMPAT_FEATURE(journal,
-				     JFS_FEATURE_INCOMPAT_ASYNC_COMMIT)) {
+				if (!jfs_has_feature_async_commit(journal)) {
 					journal->j_failed_commit =
 						next_commit_ID;
 					brelse(bh);
@@ -856,7 +852,7 @@ static int scan_revoke_records(journal_t *journal, struct buffer_head *bh,
 		return -EINVAL;
 	max = rcount;
 
-	if (JFS_HAS_INCOMPAT_FEATURE(journal, JFS_FEATURE_INCOMPAT_64BIT))
+	if (jfs_has_feature_64bit(journal))
 		record_len = 8;
 
 	while (offset + record_len <= max) {
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index bddbe19..15d3dd9 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -448,8 +448,7 @@ static errcode_t copy_dir_entries(e2fsck_t ctx,
 			ctx->htree_slack_percentage = 20;
 	}
 
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (ext2fs_has_feature_metadata_csum(fs->super))
 		csum_size = sizeof(struct ext2_dir_entry_tail);
 
 	outdir->max = 0;
@@ -544,7 +543,7 @@ static struct ext2_dx_root_info *set_root_node(ext2_filsys fs, char *buf,
 	int				filetype = 0;
 	int				csum_size = 0;
 
-	if (fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_FILETYPE)
+	if (ext2fs_has_feature_filetype(fs->super))
 		filetype = EXT2_FT_DIR;
 
 	memset(buf, 0, fs->blocksize);
@@ -569,8 +568,7 @@ static struct ext2_dx_root_info *set_root_node(ext2_filsys fs, char *buf,
 	root->indirect_levels = 0;
 	root->unused_flags = 0;
 
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (ext2fs_has_feature_metadata_csum(fs->super))
 		csum_size = sizeof(struct ext2_dx_tail);
 
 	limits = (struct ext2_dx_countlimit *) (buf+32);
@@ -593,8 +591,7 @@ static struct ext2_dx_entry *set_int_node(ext2_filsys fs, char *buf)
 	dir->inode = 0;
 	(void) ext2fs_set_rec_len(fs, fs->blocksize, dir);
 
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
+	if (ext2fs_has_feature_metadata_csum(fs->super))
 		csum_size = sizeof(struct ext2_dx_tail);
 
 	limits = (struct ext2_dx_countlimit *) (buf+8);
@@ -800,8 +797,7 @@ errcode_t e2fsck_rehash_dir(e2fsck_t ctx, ext2_ino_t ino,
 	outdir.hashes = 0;
 	e2fsck_read_inode(ctx, ino, &inode, "rehash_dir");
 
-	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-				      EXT4_FEATURE_INCOMPAT_INLINE_DATA) &&
+	if (ext2fs_has_feature_inline_data(fs->super) &&
 	   (inode.i_flags & EXT4_INLINE_DATA_FL))
 		return 0;
 
@@ -825,7 +821,7 @@ errcode_t e2fsck_rehash_dir(e2fsck_t ctx, ext2_ino_t ino,
 	fd.dir_size = 0;
 	fd.compress = 0;
 	fd.dir = ino;
-	if (!(fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_DIR_INDEX) ||
+	if (!ext2fs_has_feature_dir_index(fs->super) ||
 	    (inode.i_size / fs->blocksize) < 2)
 		fd.compress = 1;
 	fd.parent = 0;
diff --git a/e2fsck/super.c b/e2fsck/super.c
index 397ad0f..af6d680 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -330,8 +330,7 @@ void check_resize_inode(e2fsck_t ctx)
 	 * If the resize inode feature isn't set, then
 	 * s_reserved_gdt_blocks must be zero.
 	 */
-	if (!(fs->super->s_feature_compat &
-	      EXT2_FEATURE_COMPAT_RESIZE_INODE)) {
+	if (!ext2fs_has_feature_resize_inode(fs->super)) {
 		if (fs->super->s_reserved_gdt_blocks) {
 			pctx.num = fs->super->s_reserved_gdt_blocks;
 			if (fix_problem(ctx, PR_0_NONZERO_RESERVED_GDT_BLOCKS,
@@ -346,8 +345,7 @@ void check_resize_inode(e2fsck_t ctx)
 	pctx.ino = EXT2_RESIZE_INO;
 	retval = ext2fs_read_inode(fs, EXT2_RESIZE_INO, &inode);
 	if (retval) {
-		if (fs->super->s_feature_compat &
-		    EXT2_FEATURE_COMPAT_RESIZE_INODE)
+		if (ext2fs_has_feature_resize_inode(fs->super))
 			ctx->flags |= E2F_FLAG_RESIZE_INODE;
 		return;
 	}
@@ -356,8 +354,7 @@ void check_resize_inode(e2fsck_t ctx)
 	 * If the resize inode feature isn't set, check to make sure
 	 * the resize inode is cleared; then we're done.
 	 */
-	if (!(fs->super->s_feature_compat &
-	      EXT2_FEATURE_COMPAT_RESIZE_INODE)) {
+	if (!ext2fs_has_feature_resize_inode(fs->super)) {
 		for (i=0; i < EXT2_N_BLOCKS; i++) {
 			if (inode.i_block[i])
 				break;
@@ -444,7 +441,7 @@ static void e2fsck_fix_dirhash_hint(e2fsck_t ctx)
 	char	c;
 
 	if ((ctx->options & E2F_OPT_READONLY) ||
-	    !(sb->s_feature_compat & EXT2_FEATURE_COMPAT_DIR_INDEX) ||
+	    !ext2fs_has_feature_dir_index(sb) ||
 	    (sb->s_flags & (EXT2_FLAGS_SIGNED_HASH|EXT2_FLAGS_UNSIGNED_HASH)))
 		return;
 
@@ -583,43 +580,35 @@ void check_super_block(e2fsck_t ctx)
 	}
 
 	/* Are metadata_csum and uninit_bg both set? */
-	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_METADATA_CSUM) &&
-	    EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
-				       EXT4_FEATURE_RO_COMPAT_GDT_CSUM) &&
+	if (ext2fs_has_feature_metadata_csum(fs->super) &&
+	    ext2fs_has_feature_gdt_csum(fs->super) &&
 	    fix_problem(ctx, PR_0_META_AND_GDT_CSUM_SET, &pctx)) {
-		fs->super->s_feature_ro_compat &=
-			~EXT4_FEATURE_RO_COMPAT_GDT_CSUM;
+		ext2fs_clear_feature_gdt_csum(fs->super);
 		ext2fs_mark_super_dirty(fs);
 		for (i = 0; i < fs->group_desc_count; i++)
 			ext2fs_group_desc_csum_set(fs, i);
 	}
 
 	/* Is 64bit set and extents unset? */
-	if (EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-				      EXT4_FEATURE_INCOMPAT_64BIT) &&
-	    !EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-				       EXT3_FEATURE_INCOMPAT_EXTENTS) &&
+	if (ext2fs_has_feature_64bit(fs->super) &&
+	    !ext2fs_has_feature_extents(fs->super) &&
 	    fix_problem(ctx, PR_0_64BIT_WITHOUT_EXTENTS, &pctx)) {
-		fs->super->s_feature_incompat |=
-			EXT3_FEATURE_INCOMPAT_EXTENTS;
+		ext2fs_set_feature_extents(fs->super);
 		ext2fs_mark_super_dirty(fs);
 	}
 
 	/* Did user ask us to convert files to extents? */
 	if (ctx->options & E2F_OPT_CONVERT_BMAP) {
-		fs->super->s_feature_incompat |=
-			EXT3_FEATURE_INCOMPAT_EXTENTS;
+		ext2fs_set_feature_extents(fs->super);
 		ext2fs_mark_super_dirty(fs);
 	}
 
-	if ((fs->super->s_feature_incompat & EXT2_FEATURE_INCOMPAT_META_BG) &&
+	if (ext2fs_has_feature_meta_bg(fs->super) &&
 	    (fs->super->s_first_meta_bg > fs->desc_blocks)) {
 		pctx.group = fs->desc_blocks;
 		pctx.num = fs->super->s_first_meta_bg;
 		if (fix_problem(ctx, PR_0_FIRST_META_BG_TOO_BIG, &pctx)) {
-			fs->super->s_feature_incompat &=
-				~EXT2_FEATURE_INCOMPAT_META_BG;
+			ext2fs_clear_feature_meta_bg(fs->super);
 			fs->super->s_first_meta_bg = 0;
 			ext2fs_mark_super_dirty(fs);
 		}
@@ -635,8 +624,7 @@ void check_super_block(e2fsck_t ctx)
 	for (i = 0; i < fs->group_desc_count; i++) {
 		pctx.group = i;
 
-		if (!EXT2_HAS_INCOMPAT_FEATURE(fs->super,
-					       EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
+		if (!ext2fs_has_feature_flex_bg(fs->super)) {
 			first_block = ext2fs_group_first_block2(fs, i);
 			last_block = ext2fs_group_last_block2(fs, i);
 		}
@@ -792,11 +780,9 @@ void check_super_block(e2fsck_t ctx)
 	 */
 	if (!(ctx->options & E2F_OPT_READONLY) &&
 	    fs->super->s_creator_os == EXT2_OS_HURD &&
-	    (fs->super->s_feature_incompat &
-	     EXT2_FEATURE_INCOMPAT_FILETYPE)) {
+	    ext2fs_has_feature_filetype(fs->super)) {
 		if (fix_problem(ctx, PR_0_HURD_CLEAR_FILETYPE, &pctx)) {
-			fs->super->s_feature_incompat &=
-				~EXT2_FEATURE_INCOMPAT_FILETYPE;
+			ext2fs_clear_feature_filetype(fs->super);
 			ext2fs_mark_super_dirty(fs);
 			fs->flags &= ~EXT2_FLAG_MASTER_SB_ONLY;
 		}
diff --git a/e2fsck/unix.c b/e2fsck/unix.c
index 9d49a0e..bb25f29 100644
--- a/e2fsck/unix.c
+++ b/e2fsck/unix.c
@@ -1620,7 +1620,7 @@ failure:
 
 	ehandler_init(fs->io);
 
-	if ((fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_MMP) &&
+	if (ext2fs_has_feature_mmp(fs->super) &&
 	    (flags & EXT2_FLAG_SKIP_MMP)) {
 		if (e2fsck_check_mmp(fs, ctx))
 			fatal_error(ctx, 0);
@@ -1654,7 +1654,7 @@ failure:
 	 * Check to see if we need to do ext3-style recovery.  If so,
 	 * do it, and then restart the fsck.
 	 */
-	if (sb->s_feature_incompat & EXT3_FEATURE_INCOMPAT_RECOVER) {
+	if (ext2fs_has_feature_journal_needs_recovery(sb)) {
 		if (ctx->options & E2F_OPT_READONLY) {
 			log_out(ctx, "%s",
 				_("Warning: skipping journal recovery because "
@@ -1776,7 +1776,7 @@ print_unsupp_features:
 	else
 		journal_size = -1;
 
-	if (sb->s_feature_ro_compat & EXT4_FEATURE_RO_COMPAT_QUOTA) {
+	if (ext2fs_has_feature_quota(sb)) {
 		/* Quotas were enabled. Do quota accounting during fsck. */
 		if ((sb->s_usr_quota_inum && sb->s_grp_quota_inum) ||
 		    (!sb->s_usr_quota_inum && !sb->s_grp_quota_inum))
@@ -1796,8 +1796,7 @@ print_unsupp_features:
 			if (journal_size < 1024)
 				journal_size = ext2fs_default_journal_size(ext2fs_blocks_count(fs->super));
 			if (journal_size < 0) {
-				fs->super->s_feature_compat &=
-					~EXT3_FEATURE_COMPAT_HAS_JOURNAL;
+				ext2fs_clear_feature_journal(fs->super);
 				fs->flags &= ~EXT2_FLAG_MASTER_SB_ONLY;
 				log_out(ctx, "%s: Couldn't determine "
 					"journal size\n", ctx->program_name);

