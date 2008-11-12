From: Valerie Aurora Henson <vaurora@redhat.com>
Subject: [RFC PATCH 13/17] Support 48-bit file acl blocks
Date: Tue, 11 Nov 2008 19:43:06 -0800
Message-ID: <1226461390-5502-14-git-send-email-vaurora@redhat.com>
References: <1226461390-5502-1-git-send-email-vaurora@redhat.com>
 <1226461390-5502-2-git-send-email-vaurora@redhat.com>
 <1226461390-5502-3-git-send-email-vaurora@redhat.com>
 <1226461390-5502-4-git-send-email-vaurora@redhat.com>
 <1226461390-5502-5-git-send-email-vaurora@redhat.com>
 <1226461390-5502-6-git-send-email-vaurora@redhat.com>
 <1226461390-5502-7-git-send-email-vaurora@redhat.com>
 <1226461390-5502-8-git-send-email-vaurora@redhat.com>
 <1226461390-5502-9-git-send-email-vaurora@redhat.com>
 <1226461390-5502-10-git-send-email-vaurora@redhat.com>
 <1226461390-5502-11-git-send-email-vaurora@redhat.com>
 <1226461390-5502-12-git-send-email-vaurora@redhat.com>
 <1226461390-5502-13-git-send-email-vaurora@redhat.com>
Cc: Valerie Aurora Henson <vaurora@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:42474 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbYKLDoE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Nov 2008 22:44:04 -0500
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id mAC3i3sG007467
	for <linux-ext4@vger.kernel.org>; Tue, 11 Nov 2008 22:44:03 -0500
In-Reply-To: <1226461390-5502-13-git-send-email-vaurora@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Valerie Aurora Henson <vaurora@redhat.com>
---
 e2fsck/message.c                        |    2 +-
 e2fsck/pass1.c                          |   14 ++++---
 e2fsck/pass1b.c                         |   62 ++++++++++++++++++-------------
 e2fsck/pass2.c                          |   24 ++++++------
 e2fsck/super.c                          |   10 +++--
 lib/ext2fs/blknum.c                     |   23 +++++++++++
 lib/ext2fs/ext2_fs.h                    |    6 +-
 lib/ext2fs/ext2fs.h                     |    2 +
 lib/ext2fs/valid_blk.c                  |    2 +-
 tests/f_bad_disconnected_inode/expect.1 |    4 +-
 10 files changed, 94 insertions(+), 55 deletions(-)

diff --git a/e2fsck/message.c b/e2fsck/message.c
index f79b73c..be84d89 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -304,7 +304,7 @@ static _INLINE_ void expand_inode_expression(char ch,
 		printf("%u", inode->i_faddr);
 		break;
 	case 'f':
-		printf("%u", inode->i_file_acl);
+		printf("%llu", ext2fs_file_acl_block(inode));
 		break;
 	case 'd':
 		printf("%u", (LINUX_S_ISDIR(inode->i_mode) ?
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 605c474..ee658d5 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1022,7 +1022,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 		    (inode->i_block[EXT2_IND_BLOCK] ||
 		     inode->i_block[EXT2_DIND_BLOCK] ||
 		     inode->i_block[EXT2_TIND_BLOCK] ||
-		     inode->i_file_acl)) {
+		     ext2fs_file_acl_block(inode))) {
 			inodes_to_process[process_inode_count].ino = ino;
 			inodes_to_process[process_inode_count].inode = *inode;
 			process_inode_count++;
@@ -1205,7 +1205,8 @@ static EXT2_QSORT_TYPE process_inode_cmp(const void *a, const void *b)
 	ret = (ib_a->inode.i_block[EXT2_IND_BLOCK] -
 	       ib_b->inode.i_block[EXT2_IND_BLOCK]);
 	if (ret == 0)
-		ret = ib_a->inode.i_file_acl - ib_b->inode.i_file_acl;
+		ret = ext2fs_file_acl_block(&(ib_a->inode)) -
+			ext2fs_file_acl_block(&ib_b->inode);
 	return ret;
 }
 
@@ -1367,7 +1368,7 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 	int		count;
 	region_t	region = 0;
 
-	blk = inode->i_file_acl;
+	blk = ext2fs_file_acl_block(inode);
 	if (blk == 0)
 		return 0;
 
@@ -1442,7 +1443,7 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 	if (pctx->errcode && fix_problem(ctx, PR_1_READ_EA_BLOCK, pctx))
 		goto clear_extattr;
 	header = (struct ext2_ext_attr_header *) block_buf;
-	pctx->blk = inode->i_file_acl;
+	pctx->blk = ext2fs_file_acl_block(inode);
 	if (((ctx->ext_attr_ver == 1) &&
 	     (header->h_magic != EXT2_EXT_ATTR_MAGIC_v1)) ||
 	    ((ctx->ext_attr_ver == 2) &&
@@ -1530,7 +1531,7 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 clear_extattr:
 	if (region)
 		region_free(region);
-	inode->i_file_acl = 0;
+	ext2fs_file_acl_block_set(inode, 0);
 	e2fsck_write_inode(ctx, ino, inode, "check_ext_attr");
 	return 0;
 }
@@ -1824,7 +1825,8 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		}
 	}
 
-	if (inode->i_file_acl && check_ext_attr(ctx, pctx, block_buf)) {
+	if (ext2fs_file_acl_block(inode) &&
+	    check_ext_attr(ctx, pctx, block_buf)) {
 		if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
 			goto out;
 		pb.num_blocks++;
diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index 922cbcf..fc2bb7e 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -82,8 +82,8 @@ struct dup_inode {
 	struct block_el		*block_list;
 };
 
-static int process_pass1b_block(ext2_filsys fs, blk_t	*blocknr,
-				e2_blkcnt_t blockcnt, blk_t ref_blk,
+static int process_pass1b_block(ext2_filsys fs, blk64_t	*blocknr,
+				e2_blkcnt_t blockcnt, blk64_t ref_blk,
 				int ref_offset, void *priv_data);
 static void delete_file(e2fsck_t ctx, ext2_ino_t ino,
 			struct dup_inode *dp, char *block_buf);
@@ -293,12 +293,15 @@ static void pass1b(e2fsck_t ctx, char *block_buf)
 
 		if (ext2fs_inode_has_valid_blocks(&inode) ||
 		    (ino == EXT2_BAD_INO))
-			pctx.errcode = ext2fs_block_iterate2(fs, ino,
+			pctx.errcode = ext2fs_block_iterate3(fs, ino,
 					     BLOCK_FLAG_READ_ONLY, block_buf,
 					     process_pass1b_block, &pb);
-		if (inode.i_file_acl)
-			process_pass1b_block(fs, &inode.i_file_acl,
+		if (ext2fs_file_acl_block(&inode)) {
+			blk64_t blk = ext2fs_file_acl_block(&inode);
+			process_pass1b_block(fs, &blk,
 					     BLOCK_COUNT_EXTATTR, 0, 0, &pb);
+			ext2fs_file_acl_block_set(&inode, blk);
+			}
 		if (pb.dup_blocks) {
 			end_problem_latch(ctx, PR_LATCH_DBLOCK);
 			if (ino >= EXT2_FIRST_INODE(fs->super) ||
@@ -313,9 +316,9 @@ static void pass1b(e2fsck_t ctx, char *block_buf)
 }
 
 static int process_pass1b_block(ext2_filsys fs EXT2FS_ATTR((unused)),
-				blk_t	*block_nr,
+				blk64_t	*block_nr,
 				e2_blkcnt_t blockcnt EXT2FS_ATTR((unused)),
-				blk_t ref_blk EXT2FS_ATTR((unused)),
+				blk64_t ref_blk EXT2FS_ATTR((unused)),
 				int ref_offset EXT2FS_ATTR((unused)),
 				void *priv_data)
 {
@@ -540,9 +543,9 @@ static void decrement_badcount(e2fsck_t ctx, blk_t block, struct dup_block *p)
 }
 
 static int delete_file_block(ext2_filsys fs,
-			     blk_t	*block_nr,
+			     blk64_t	*block_nr,
 			     e2_blkcnt_t blockcnt EXT2FS_ATTR((unused)),
-			     blk_t ref_block EXT2FS_ATTR((unused)),
+			     blk64_t ref_block EXT2FS_ATTR((unused)),
 			     int ref_offset EXT2FS_ATTR((unused)),
 			     void *priv_data)
 {
@@ -564,7 +567,7 @@ static int delete_file_block(ext2_filsys fs,
 			decrement_badcount(ctx, *block_nr, p);
 		} else
 			com_err("delete_file_block", 0,
-			    _("internal error: can't find dup_blk for %u\n"),
+			    _("internal error: can't find dup_blk for %llu\n"),
 				*block_nr);
 	} else {
 		ext2fs_unmark_block_bitmap2(ctx->block_found_map, *block_nr);
@@ -591,7 +594,7 @@ static void delete_file(e2fsck_t ctx, ext2_ino_t ino,
 
 	e2fsck_read_inode(ctx, ino, &inode, "delete_file");
 	if (ext2fs_inode_has_valid_blocks(&inode))
-		pctx.errcode = ext2fs_block_iterate2(fs, ino, BLOCK_FLAG_READ_ONLY,
+		pctx.errcode = ext2fs_block_iterate3(fs, ino, BLOCK_FLAG_READ_ONLY,
 						     block_buf, delete_file_block, &pb);
 	if (pctx.errcode)
 		fix_problem(ctx, PR_1B_BLOCK_ITERATE, &pctx);
@@ -602,17 +605,18 @@ static void delete_file(e2fsck_t ctx, ext2_ino_t ino,
 	/* Inode may have changed by block_iterate, so reread it */
 	e2fsck_read_inode(ctx, ino, &inode, "delete_file");
 	e2fsck_clear_inode(ctx, ino, &inode, 0, "delete_file");
-	if (inode.i_file_acl &&
+	if (ext2fs_file_acl_block(&inode) &&
 	    (fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR)) {
 		count = 1;
-		pctx.errcode = ext2fs_adjust_ea_refcount(fs, inode.i_file_acl,
+		pctx.errcode = ext2fs_adjust_ea_refcount(fs,
+						   ext2fs_file_acl_block(&inode),
 						   block_buf, -1, &count);
 		if (pctx.errcode == EXT2_ET_BAD_EA_BLOCK_NUM) {
 			pctx.errcode = 0;
 			count = 1;
 		}
 		if (pctx.errcode) {
-			pctx.blk = inode.i_file_acl;
+			pctx.blk = ext2fs_file_acl_block(&inode);
 			fix_problem(ctx, PR_1B_ADJ_EA_REFCOUNT, &pctx);
 		}
 		/*
@@ -623,9 +627,12 @@ static void delete_file(e2fsck_t ctx, ext2_ino_t ino,
 		 */
 		if ((count == 0) ||
 		    ext2fs_test_block_bitmap2(ctx->block_dup_map,
-					     inode.i_file_acl))
-			delete_file_block(fs, &inode.i_file_acl,
+					      ext2fs_file_acl_block(&inode))) {
+			blk64_t blk = ext2fs_file_acl_block(&inode);
+			delete_file_block(fs, &blk,
 					  BLOCK_COUNT_EXTATTR, 0, 0, &pb);
+			ext2fs_file_acl_block_set(&inode, blk);
+		}
 	}
 }
 
@@ -637,9 +644,9 @@ struct clone_struct {
 };
 
 static int clone_file_block(ext2_filsys fs,
-			    blk_t	*block_nr,
+			    blk64_t	*block_nr,
 			    e2_blkcnt_t blockcnt,
-			    blk_t ref_block EXT2FS_ATTR((unused)),
+			    blk64_t ref_block EXT2FS_ATTR((unused)),
 			    int ref_offset EXT2FS_ATTR((unused)),
 			    void *priv_data)
 {
@@ -697,7 +704,7 @@ static int clone_file_block(ext2_filsys fs,
 			return BLOCK_CHANGED;
 		} else
 			com_err("clone_file_block", 0,
-			    _("internal error: can't find dup_blk for %u\n"),
+			    _("internal error: can't find dup_blk for %llu\n"),
 				*block_nr);
 	}
 	return 0;
@@ -710,7 +717,7 @@ static int clone_file(e2fsck_t ctx, ext2_ino_t ino,
 	errcode_t	retval;
 	struct clone_struct cs;
 	struct problem_context	pctx;
-	blk_t		blk;
+	blk64_t		blk, new_blk;
 	dnode_t		*n;
 	struct inode_el	*ino_el;
 	struct dup_block	*db;
@@ -730,7 +737,7 @@ static int clone_file(e2fsck_t ctx, ext2_ino_t ino,
 	pctx.ino = ino;
 	pctx.str = "clone_file";
 	if (ext2fs_inode_has_valid_blocks(&dp->inode))
-		pctx.errcode = ext2fs_block_iterate2(fs, ino, 0, block_buf,
+		pctx.errcode = ext2fs_block_iterate3(fs, ino, 0, block_buf,
 						     clone_file_block, &cs);
 	ext2fs_mark_bb_dirty(fs);
 	if (pctx.errcode) {
@@ -746,10 +753,12 @@ static int clone_file(e2fsck_t ctx, ext2_ino_t ino,
 	}
 	/* The inode may have changed on disk, so we have to re-read it */
 	e2fsck_read_inode(ctx, ino, &dp->inode, "clone file EA");
-	blk = dp->inode.i_file_acl;
-	if (blk && (clone_file_block(fs, &dp->inode.i_file_acl,
+	blk = ext2fs_file_acl_block(&dp->inode);
+	new_blk = blk;
+	if (blk && (clone_file_block(fs, &new_blk,
 				     BLOCK_COUNT_EXTATTR, 0, 0, &cs) ==
 		    BLOCK_CHANGED)) {
+		ext2fs_file_acl_block_set(&dp->inode, new_blk);
 		e2fsck_write_inode(ctx, ino, &dp->inode, "clone file EA");
 		/*
 		 * If we cloned the EA block, find all other inodes
@@ -760,7 +769,7 @@ static int clone_file(e2fsck_t ctx, ext2_ino_t ino,
 		if (!n) {
 			com_err("clone_file", 0,
 				_("internal error: couldn't lookup EA "
-				  "block record for %u"), blk);
+				  "block record for %llu"), blk);
 			retval = 0; /* OK to stumble on... */
 			goto errout;
 		}
@@ -778,8 +787,9 @@ static int clone_file(e2fsck_t ctx, ext2_ino_t ino,
 				goto errout;
 			}
 			di = (struct dup_inode *) dnode_get(n);
-			if (di->inode.i_file_acl == blk) {
-				di->inode.i_file_acl = dp->inode.i_file_acl;
+			if (ext2fs_file_acl_block(&di->inode) == blk) {
+				ext2fs_file_acl_block_set(&di->inode,
+					  ext2fs_file_acl_block(&dp->inode));
 				e2fsck_write_inode(ctx, ino_el->inode,
 					   &di->inode, "clone file EA");
 				decrement_badcount(ctx, blk, db);
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index afe4be9..2ee000e 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1196,26 +1196,26 @@ static void deallocate_inode(e2fsck_t ctx, ext2_ino_t ino, char* block_buf)
 	e2fsck_read_bitmaps(ctx);
 	ext2fs_inode_alloc_stats2(fs, ino, -1, LINUX_S_ISDIR(inode.i_mode));
 
-	if (inode.i_file_acl &&
+	if (ext2fs_file_acl_block(&inode) &&
 	    (fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR)) {
-		pctx.errcode = ext2fs_adjust_ea_refcount(fs, inode.i_file_acl,
+		pctx.errcode = ext2fs_adjust_ea_refcount(fs, ext2fs_file_acl_block(&inode),
 						   block_buf, -1, &count);
 		if (pctx.errcode == EXT2_ET_BAD_EA_BLOCK_NUM) {
 			pctx.errcode = 0;
 			count = 1;
 		}
 		if (pctx.errcode) {
-			pctx.blk = inode.i_file_acl;
+			pctx.blk = ext2fs_file_acl_block(&inode);
 			fix_problem(ctx, PR_2_ADJ_EA_REFCOUNT, &pctx);
 			ctx->flags |= E2F_FLAG_ABORT;
 			return;
 		}
 		if (count == 0) {
 			ext2fs_unmark_block_bitmap2(ctx->block_found_map,
-						   inode.i_file_acl);
-			ext2fs_block_alloc_stats(fs, inode.i_file_acl, -1);
+						   ext2fs_file_acl_block(&inode));
+			ext2fs_block_alloc_stats(fs, ext2fs_file_acl_block(&inode), -1);
 		}
-		inode.i_file_acl = 0;
+		ext2fs_file_acl_block_set(&inode, 0);
 	}
 
 	if (!ext2fs_inode_has_valid_blocks(&inode))
@@ -1267,10 +1267,10 @@ extern int e2fsck_process_bad_inode(e2fsck_t ctx, ext2_ino_t dir,
 	pctx.dir = dir;
 	pctx.inode = &inode;
 
-	if (inode.i_file_acl &&
+	if (ext2fs_file_acl_block(&inode) &&
 	    !(fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR)) {
 		if (fix_problem(ctx, PR_2_FILE_ACL_ZERO, &pctx)) {
-			inode.i_file_acl = 0;
+			ext2fs_file_acl_block_set(&inode, 0);
 			inode_modified++;
 		} else
 			not_fixed++;
@@ -1355,11 +1355,11 @@ extern int e2fsck_process_bad_inode(e2fsck_t ctx, ext2_ino_t dir,
 		}
 	}
 
-	if (inode.i_file_acl &&
-	    ((inode.i_file_acl < fs->super->s_first_data_block) ||
-	     (inode.i_file_acl >= fs->super->s_blocks_count))) {
+	if (ext2fs_file_acl_block(&inode) &&
+	    ((ext2fs_file_acl_block(&inode) < fs->super->s_first_data_block) ||
+	     (ext2fs_file_acl_block(&inode) >= fs->super->s_blocks_count))) {
 		if (fix_problem(ctx, PR_2_FILE_ACL_BAD, &pctx)) {
-			inode.i_file_acl = 0;
+			ext2fs_file_acl_block_set(&inode, 0);
 			inode_modified++;
 		} else
 			not_fixed++;
diff --git a/e2fsck/super.c b/e2fsck/super.c
index 0b55809..40a5882 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -197,8 +197,8 @@ static int release_inode_blocks(e2fsck_t ctx, ext2_ino_t ino,
 	if (pb.truncated_blocks)
 		ext2fs_iblk_sub_blocks(fs, inode, pb.truncated_blocks);
 
-	if (inode->i_file_acl) {
-		retval = ext2fs_adjust_ea_refcount(fs, inode->i_file_acl,
+	if (ext2fs_file_acl_block(inode)) {
+		retval = ext2fs_adjust_ea_refcount(fs, ext2fs_file_acl_block(inode),
 						   block_buf, -1, &count);
 		if (retval == EXT2_ET_BAD_EA_BLOCK_NUM) {
 			retval = 0;
@@ -211,8 +211,10 @@ static int release_inode_blocks(e2fsck_t ctx, ext2_ino_t ino,
 			return 1;
 		}
 		if (count == 0)
-			ext2fs_block_alloc_stats(fs, inode->i_file_acl, -1);
-		inode->i_file_acl = 0;
+			ext2fs_block_alloc_stats(fs,
+						 ext2fs_file_acl_block(inode),
+						 -1);
+		ext2fs_file_acl_block_set(inode, 0);
 	}
 	return 0;
 }
diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
index 8c8057d..dc264a1 100644
--- a/lib/ext2fs/blknum.c
+++ b/lib/ext2fs/blknum.c
@@ -242,3 +242,26 @@ void ext2fs_inode_table_loc_set(ext2_filsys fs, dgrp_t group, blk64_t blk)
 	} else
 		fs->group_desc[group].bg_inode_table = blk;
 }
+
+/*
+ * Get the acl block of a file
+ *
+ * XXX Ignoring 64-bit file system flag - most places where this is
+ * called don't have access to the fs struct, and the high bits should
+ * be 0 in the non-64-bit case anyway.
+ */
+blk64_t ext2fs_file_acl_block(const struct ext2_inode *inode)
+{
+	return (inode->i_file_acl |
+		(__u64) inode->osd2.linux2.l_i_file_acl_high << 32);
+}
+
+/*
+ * Set the acl block of a file
+ */
+void ext2fs_file_acl_block_set(struct ext2_inode *inode, blk64_t blk)
+{
+	inode->i_file_acl = blk;
+	inode->osd2.linux2.l_i_file_acl_high = (__u64) blk >> 32;
+}
+
diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index d7d7bdb..3fa7555 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -343,7 +343,7 @@ struct ext2_inode {
 	__u32	i_block[EXT2_N_BLOCKS];/* Pointers to blocks */
 	__u32	i_generation;	/* File version (for NFS) */
 	__u32	i_file_acl;	/* File ACL */
-	__u32	i_dir_acl;	/* Directory ACL */
+	__u32	i_size_high;	/* Formerly i_dir_acl, directory ACL */
 	__u32	i_faddr;	/* Fragment address */
 	union {
 		struct {
@@ -390,7 +390,7 @@ struct ext2_inode_large {
 	__u32	i_block[EXT2_N_BLOCKS];/* Pointers to blocks */
 	__u32	i_generation;	/* File version (for NFS) */
 	__u32	i_file_acl;	/* File ACL */
-	__u32	i_dir_acl;	/* Directory ACL */
+	__u32	i_size_high;	/* Formerly i_dir_acl, directory ACL */
 	__u32	i_faddr;	/* Fragment address */
 	union {
 		struct {
@@ -419,7 +419,7 @@ struct ext2_inode_large {
 	__u32	i_version_hi;	/* high 32 bits for 64-bit version */
 };
 
-#define i_size_high	i_dir_acl
+#define i_dir_acl	i_size_high
 
 #if defined(__KERNEL__) || defined(__linux__)
 #define i_reserved1	osd1.linux1.l_i_reserved1
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index cb44186..bfa162a 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -748,6 +748,8 @@ extern void ext2fs_inode_bitmap_loc_set(ext2_filsys fs, dgrp_t group,
 extern blk64_t ext2fs_inode_table_loc(ext2_filsys fs, dgrp_t group);
 extern void ext2fs_inode_table_loc_set(ext2_filsys fs, dgrp_t group,
 				       blk64_t blk);
+extern blk64_t ext2fs_file_acl_block(const struct ext2_inode *inode);
+extern void ext2fs_file_acl_block_set(struct ext2_inode *inode, blk64_t blk);
 
 /* block.c */
 extern errcode_t ext2fs_block_iterate(ext2_filsys fs,
diff --git a/lib/ext2fs/valid_blk.c b/lib/ext2fs/valid_blk.c
index d0367e7..6a2aa47 100644
--- a/lib/ext2fs/valid_blk.c
+++ b/lib/ext2fs/valid_blk.c
@@ -39,7 +39,7 @@ int ext2fs_inode_has_valid_blocks(struct ext2_inode *inode)
 	 * target is stored in the block entries.
 	 */
 	if (LINUX_S_ISLNK (inode->i_mode)) {
-		if (inode->i_file_acl == 0) {
+		if (ext2fs_file_acl_block(inode) == 0) {
 			/* With no EA block, we can rely on i_blocks */
 			if (inode->i_blocks == 0)
 				return 0;
diff --git a/tests/f_bad_disconnected_inode/expect.1 b/tests/f_bad_disconnected_inode/expect.1
index 11862f6..1b233e7 100644
--- a/tests/f_bad_disconnected_inode/expect.1
+++ b/tests/f_bad_disconnected_inode/expect.1
@@ -15,13 +15,13 @@ Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Inode 2 ref count is 4, should be 3.  Fix? yes
 
-i_file_acl for inode 13 (...) is 4218798225, should be zero.
+i_file_acl for inode 13 (...) is 239964041625745, should be zero.
 Clear? yes
 
 Inode 13 (...) has invalid mode (0117003).
 Clear? yes
 
-i_file_acl for inode 14 (...) is 2892851642, should be zero.
+i_file_acl for inode 14 (...) is 178759431711162, should be zero.
 Clear? yes
 
 Inode 14 (...) has invalid mode (0154247).
-- 
1.5.6.5

