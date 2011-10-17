From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] libext2fs: ext2fs_[set_]file_acl_block needs to check for 64-bit feature flag
Date: Sun, 16 Oct 2011 20:47:25 -0400
Message-ID: <1318812445-3195-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:56113 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab1JQArb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Oct 2011 20:47:31 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The ext2fs_file_acl_block() and ext2fs_set_file_acl_block() needs to
only check i_file_acl_high if the 64-bit flag is set.  This is needed
because otherwise we will run into problems on Hurd systems which
actually use that field for h_i_mode_high.

This involves an ABI change since we need to pass ext2_filsys to these
functions.  Fortunately these functions were first included in the
1.42-WIP series, so it's OK for us to change them now.  (This is why
we have 1.42-WIP releases.  :-)

Addresses-Sourceforge-Bug: #3379227

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 debian/e2fslibs.symbols                 |    1 +
 debugfs/debugfs.c                       |    2 +-
 debugfs/icheck.c                        |    6 ++--
 e2fsck/message.c                        |    2 +-
 e2fsck/pass1.c                          |   25 +++++++++++++---------
 e2fsck/pass1b.c                         |   34 +++++++++++++++---------------
 e2fsck/pass2.c                          |   30 +++++++++++++-------------
 e2fsck/super.c                          |   14 ++++++------
 lib/ext2fs/blknum.c                     |   19 +++++++++--------
 lib/ext2fs/bmove.c                      |    2 +-
 lib/ext2fs/ext2fs.h                     |    8 +++++-
 lib/ext2fs/valid_blk.c                  |    9 ++++++-
 lib/quota/quotaio.c                     |    2 +-
 misc/e2image.c                          |    8 +++---
 misc/tune2fs.c                          |   11 +++++----
 resize/resize2fs.c                      |    9 ++++---
 tests/f_bad_disconnected_inode/expect.1 |    4 +-
 17 files changed, 102 insertions(+), 84 deletions(-)

diff --git a/debian/e2fslibs.symbols b/debian/e2fslibs.symbols
index 06220ef..1cd4246 100644
--- a/debian/e2fslibs.symbols
+++ b/debian/e2fslibs.symbols
@@ -290,6 +290,7 @@ libext2fs.so.2 e2fslibs #MINVER#
  ext2fs_inode_data_blocks2@Base 1.41.99
  ext2fs_inode_data_blocks@Base 1.37
  ext2fs_inode_has_valid_blocks@Base 1.37
+ ext2fs_inode_has_valid_blocks2@Base 1.41.99
  ext2fs_inode_i_blocks@Base 1.41.99
  ext2fs_inode_io_intern2@Base 1.37
  ext2fs_inode_io_intern@Base 1.37
diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index dd1435b..eba3b69 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -1807,7 +1807,7 @@ static void kill_file_by_inode(ext2_ino_t inode)
 	inode_buf.i_dtime = current_fs->now ? current_fs->now : time(0);
 	if (debugfs_write_inode(inode, &inode_buf, 0))
 		return;
-	if (!ext2fs_inode_has_valid_blocks(&inode_buf))
+	if (!ext2fs_inode_has_valid_blocks2(current_fs, &inode_buf))
 		return;
 
 	ext2fs_block_iterate3(current_fs, inode, BLOCK_FLAG_READ_ONLY, NULL,
diff --git a/debugfs/icheck.c b/debugfs/icheck.c
index c7f1597..48f432a 100644
--- a/debugfs/icheck.c
+++ b/debugfs/icheck.c
@@ -114,16 +114,16 @@ void do_icheck(int argc, char **argv)
 
 		bw.inode = ino;
 
-		blk = ext2fs_file_acl_block(&inode);
+		blk = ext2fs_file_acl_block(current_fs, &inode);
 		if (blk) {
 			icheck_proc(current_fs, &blk, 0,
 				    0, 0, &bw);
 			if (bw.blocks_left == 0)
 				break;
-			ext2fs_file_acl_block_set(&inode, blk);
+			ext2fs_file_acl_block_set(current_fs, &inode, blk);
 		}
 
-		if (!ext2fs_inode_has_valid_blocks(&inode))
+		if (!ext2fs_inode_has_valid_blocks2(current_fs, &inode))
 			goto next;
 		/*
 		 * To handle filesystems touched by 0.3c extfs; can be
diff --git a/e2fsck/message.c b/e2fsck/message.c
index 25fe72e..4dab1a4 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -315,7 +315,7 @@ static _INLINE_ void expand_inode_expression(ext2_filsys fs, char ch,
 		printf("%u", inode->i_faddr);
 		break;
 	case 'f':
-		printf("%llu", ext2fs_file_acl_block(inode));
+		printf("%llu", ext2fs_file_acl_block(fs, inode));
 		break;
 	case 'd':
 		printf("%u", (LINUX_S_ISDIR(inode->i_mode) ?
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 7ce6697..532e132 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1064,12 +1064,12 @@ void e2fsck_pass1(e2fsck_t ctx)
 		check_is_really_dir(ctx, &pctx, block_buf);
 
 		/*
-		 * ext2fs_inode_has_valid_blocks does not actually look
+		 * ext2fs_inode_has_valid_blocks2 does not actually look
 		 * at i_block[] values, so not endian-sensitive here.
 		 */
 		if (extent_fs && (inode->i_flags & EXT4_EXTENTS_FL) &&
 		    LINUX_S_ISLNK(inode->i_mode) &&
-		    !ext2fs_inode_has_valid_blocks(inode) &&
+		    !ext2fs_inode_has_valid_blocks2(fs, inode) &&
 		    fix_problem(ctx, PR_1_FAST_SYMLINK_EXTENT_FL, &pctx)) {
 			inode->i_flags &= ~EXT4_EXTENTS_FL;
 			e2fsck_write_inode(ctx, ino, inode, "pass1");
@@ -1127,7 +1127,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 		    (inode->i_block[EXT2_IND_BLOCK] ||
 		     inode->i_block[EXT2_DIND_BLOCK] ||
 		     inode->i_block[EXT2_TIND_BLOCK] ||
-		     ext2fs_file_acl_block(inode))) {
+		     ext2fs_file_acl_block(fs, inode))) {
 			inodes_to_process[process_inode_count].ino = ino;
 			inodes_to_process[process_inode_count].inode = *inode;
 			process_inode_count++;
@@ -1309,8 +1309,13 @@ static EXT2_QSORT_TYPE process_inode_cmp(const void *a, const void *b)
 	ret = (ib_a->inode.i_block[EXT2_IND_BLOCK] -
 	       ib_b->inode.i_block[EXT2_IND_BLOCK]);
 	if (ret == 0)
-		ret = ext2fs_file_acl_block(&(ib_a->inode)) -
-			ext2fs_file_acl_block(&ib_b->inode);
+		/*
+		 * We only call process_inodes() for non-extent
+		 * inodes, so it's OK to pass NULL to
+		 * ext2fs_file_acl_block() here.
+		 */
+		ret = ext2fs_file_acl_block(0, &(ib_a->inode)) -
+			ext2fs_file_acl_block(0, &(ib_b->inode));
 	if (ret == 0)
 		ret = ib_a->ino - ib_b->ino;
 	return ret;
@@ -1475,7 +1480,7 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 	int		count;
 	region_t	region = 0;
 
-	blk = ext2fs_file_acl_block(inode);
+	blk = ext2fs_file_acl_block(fs, inode);
 	if (blk == 0)
 		return 0;
 
@@ -1550,7 +1555,7 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 	if (pctx->errcode && fix_problem(ctx, PR_1_READ_EA_BLOCK, pctx))
 		goto clear_extattr;
 	header = (struct ext2_ext_attr_header *) block_buf;
-	pctx->blk = ext2fs_file_acl_block(inode);
+	pctx->blk = ext2fs_file_acl_block(fs, inode);
 	if (((ctx->ext_attr_ver == 1) &&
 	     (header->h_magic != EXT2_EXT_ATTR_MAGIC_v1)) ||
 	    ((ctx->ext_attr_ver == 2) &&
@@ -1638,7 +1643,7 @@ static int check_ext_attr(e2fsck_t ctx, struct problem_context *pctx,
 clear_extattr:
 	if (region)
 		region_free(region);
-	ext2fs_file_acl_block_set(inode, 0);
+	ext2fs_file_acl_block_set(fs, inode, 0);
 	e2fsck_write_inode(ctx, ino, inode, "check_ext_attr");
 	return 0;
 }
@@ -1973,14 +1978,14 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		}
 	}
 
-	if (ext2fs_file_acl_block(inode) &&
+	if (ext2fs_file_acl_block(fs, inode) &&
 	    check_ext_attr(ctx, pctx, block_buf)) {
 		if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
 			goto out;
 		pb.num_blocks++;
 	}
 
-	if (ext2fs_inode_has_valid_blocks(inode)) {
+	if (ext2fs_inode_has_valid_blocks2(fs, inode)) {
 		if (extent_fs && (inode->i_flags & EXT4_EXTENTS_FL))
 			check_blocks_extents(ctx, pctx, &pb);
 		else
diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index 5ff92c2..d5585dd 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -311,18 +311,18 @@ static void pass1b(e2fsck_t ctx, char *block_buf)
 		pb.dup_blocks = 0;
 		pb.inode = &inode;
 
-		if (ext2fs_inode_has_valid_blocks(&inode) ||
+		if (ext2fs_inode_has_valid_blocks2(fs, &inode) ||
 		    (ino == EXT2_BAD_INO))
 			pctx.errcode = ext2fs_block_iterate3(fs, ino,
 					     BLOCK_FLAG_READ_ONLY, block_buf,
 					     process_pass1b_block, &pb);
 		/* If the feature is not set, attrs will be cleared later anyway */
 		if ((fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR) &&
-		    ext2fs_file_acl_block(&inode)) {
-			blk64_t blk = ext2fs_file_acl_block(&inode);
+		    ext2fs_file_acl_block(fs, &inode)) {
+			blk64_t blk = ext2fs_file_acl_block(fs, &inode);
 			process_pass1b_block(fs, &blk,
 					     BLOCK_COUNT_EXTATTR, 0, 0, &pb);
-			ext2fs_file_acl_block_set(&inode, blk);
+			ext2fs_file_acl_block_set(fs, &inode, blk);
 		}
 		if (pb.dup_blocks) {
 			end_problem_latch(ctx, PR_LATCH_DBLOCK);
@@ -623,7 +623,7 @@ static void delete_file(e2fsck_t ctx, ext2_ino_t ino,
 	pctx.str = "delete_file";
 
 	e2fsck_read_inode(ctx, ino, &inode, "delete_file");
-	if (ext2fs_inode_has_valid_blocks(&inode))
+	if (ext2fs_inode_has_valid_blocks2(fs, &inode))
 		pctx.errcode = ext2fs_block_iterate3(fs, ino, BLOCK_FLAG_READ_ONLY,
 						     block_buf, delete_file_block, &pb);
 	if (pctx.errcode)
@@ -637,18 +637,18 @@ static void delete_file(e2fsck_t ctx, ext2_ino_t ino,
 	/* Inode may have changed by block_iterate, so reread it */
 	e2fsck_read_inode(ctx, ino, &inode, "delete_file");
 	e2fsck_clear_inode(ctx, ino, &inode, 0, "delete_file");
-	if (ext2fs_file_acl_block(&inode) &&
+	if (ext2fs_file_acl_block(fs, &inode) &&
 	    (fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR)) {
 		count = 1;
 		pctx.errcode = ext2fs_adjust_ea_refcount2(fs,
-						   ext2fs_file_acl_block(&inode),
+					ext2fs_file_acl_block(fs, &inode),
 						   block_buf, -1, &count);
 		if (pctx.errcode == EXT2_ET_BAD_EA_BLOCK_NUM) {
 			pctx.errcode = 0;
 			count = 1;
 		}
 		if (pctx.errcode) {
-			pctx.blk = ext2fs_file_acl_block(&inode);
+			pctx.blk = ext2fs_file_acl_block(fs, &inode);
 			fix_problem(ctx, PR_1B_ADJ_EA_REFCOUNT, &pctx);
 		}
 		/*
@@ -659,11 +659,11 @@ static void delete_file(e2fsck_t ctx, ext2_ino_t ino,
 		 */
 		if ((count == 0) ||
 		    ext2fs_test_block_bitmap2(ctx->block_dup_map,
-					      ext2fs_file_acl_block(&inode))) {
-			blk64_t blk = ext2fs_file_acl_block(&inode);
+					ext2fs_file_acl_block(fs, &inode))) {
+			blk64_t blk = ext2fs_file_acl_block(fs, &inode);
 			delete_file_block(fs, &blk,
 					  BLOCK_COUNT_EXTATTR, 0, 0, &pb);
-			ext2fs_file_acl_block_set(&inode, blk);
+			ext2fs_file_acl_block_set(fs, &inode, blk);
 			quota_data_sub(ctx->qctx, &inode, ino, fs->blocksize);
 		}
 	}
@@ -811,7 +811,7 @@ static int clone_file(e2fsck_t ctx, ext2_ino_t ino,
 
 	pctx.ino = ino;
 	pctx.str = "clone_file";
-	if (ext2fs_inode_has_valid_blocks(&dp->inode))
+	if (ext2fs_inode_has_valid_blocks2(fs, &dp->inode))
 		pctx.errcode = ext2fs_block_iterate3(fs, ino, 0, block_buf,
 						     clone_file_block, &cs);
 	ext2fs_mark_bb_dirty(fs);
@@ -828,12 +828,12 @@ static int clone_file(e2fsck_t ctx, ext2_ino_t ino,
 	}
 	/* The inode may have changed on disk, so we have to re-read it */
 	e2fsck_read_inode(ctx, ino, &dp->inode, "clone file EA");
-	blk = ext2fs_file_acl_block(&dp->inode);
+	blk = ext2fs_file_acl_block(fs, &dp->inode);
 	new_blk = blk;
 	if (blk && (clone_file_block(fs, &new_blk,
 				     BLOCK_COUNT_EXTATTR, 0, 0, &cs) ==
 		    BLOCK_CHANGED)) {
-		ext2fs_file_acl_block_set(&dp->inode, new_blk);
+		ext2fs_file_acl_block_set(fs, &dp->inode, new_blk);
 		e2fsck_write_inode(ctx, ino, &dp->inode, "clone file EA");
 		/*
 		 * If we cloned the EA block, find all other inodes
@@ -863,9 +863,9 @@ static int clone_file(e2fsck_t ctx, ext2_ino_t ino,
 				goto errout;
 			}
 			di = (struct dup_inode *) dnode_get(n);
-			if (ext2fs_file_acl_block(&di->inode) == blk) {
-				ext2fs_file_acl_block_set(&di->inode,
-					  ext2fs_file_acl_block(&dp->inode));
+			if (ext2fs_file_acl_block(fs, &di->inode) == blk) {
+				ext2fs_file_acl_block_set(fs, &di->inode,
+					ext2fs_file_acl_block(fs, &dp->inode));
 				e2fsck_write_inode(ctx, ino_el->inode,
 					   &di->inode, "clone file EA");
 				decrement_badcount(ctx, blk, dc);
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 0ba2957..103b155 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1194,31 +1194,31 @@ static void deallocate_inode(e2fsck_t ctx, ext2_ino_t ino, char* block_buf)
 	e2fsck_read_bitmaps(ctx);
 	ext2fs_inode_alloc_stats2(fs, ino, -1, LINUX_S_ISDIR(inode.i_mode));
 
-	if (ext2fs_file_acl_block(&inode) &&
+	if (ext2fs_file_acl_block(fs, &inode) &&
 	    (fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR)) {
-		pctx.errcode = ext2fs_adjust_ea_refcount2(fs, ext2fs_file_acl_block(&inode),
-						   block_buf, -1, &count);
+		pctx.errcode = ext2fs_adjust_ea_refcount2(fs,
+					ext2fs_file_acl_block(fs, &inode),
+					block_buf, -1, &count);
 		if (pctx.errcode == EXT2_ET_BAD_EA_BLOCK_NUM) {
 			pctx.errcode = 0;
 			count = 1;
 		}
 		if (pctx.errcode) {
-			pctx.blk = ext2fs_file_acl_block(&inode);
+			pctx.blk = ext2fs_file_acl_block(fs, &inode);
 			fix_problem(ctx, PR_2_ADJ_EA_REFCOUNT, &pctx);
 			ctx->flags |= E2F_FLAG_ABORT;
 			return;
 		}
 		if (count == 0) {
 			ext2fs_unmark_block_bitmap2(ctx->block_found_map,
-						ext2fs_file_acl_block(&inode));
+					ext2fs_file_acl_block(fs, &inode));
 			ext2fs_block_alloc_stats2(fs,
-					        ext2fs_file_acl_block(&inode),
-					        -1);
+				  ext2fs_file_acl_block(fs, &inode), -1);
 		}
-		ext2fs_file_acl_block_set(&inode, 0);
+		ext2fs_file_acl_block_set(fs, &inode, 0);
 	}
 
-	if (!ext2fs_inode_has_valid_blocks(&inode))
+	if (!ext2fs_inode_has_valid_blocks2(fs, &inode))
 		return;
 
 	if (LINUX_S_ISREG(inode.i_mode) && EXT2_I_SIZE(&inode) >= 0x80000000UL)
@@ -1269,10 +1269,10 @@ extern int e2fsck_process_bad_inode(e2fsck_t ctx, ext2_ino_t dir,
 	pctx.dir = dir;
 	pctx.inode = &inode;
 
-	if (ext2fs_file_acl_block(&inode) &&
+	if (ext2fs_file_acl_block(fs, &inode) &&
 	    !(fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR)) {
 		if (fix_problem(ctx, PR_2_FILE_ACL_ZERO, &pctx)) {
-			ext2fs_file_acl_block_set(&inode, 0);
+			ext2fs_file_acl_block_set(fs, &inode, 0);
 			inode_modified++;
 		} else
 			not_fixed++;
@@ -1368,11 +1368,11 @@ extern int e2fsck_process_bad_inode(e2fsck_t ctx, ext2_ino_t dir,
 			not_fixed++;
 	}
 
-	if (ext2fs_file_acl_block(&inode) &&
-	    ((ext2fs_file_acl_block(&inode) < fs->super->s_first_data_block) ||
-	     (ext2fs_file_acl_block(&inode) >= ext2fs_blocks_count(fs->super)))) {
+	if (ext2fs_file_acl_block(fs, &inode) &&
+	    ((ext2fs_file_acl_block(fs, &inode) < fs->super->s_first_data_block) ||
+	     (ext2fs_file_acl_block(fs, &inode) >= ext2fs_blocks_count(fs->super)))) {
 		if (fix_problem(ctx, PR_2_FILE_ACL_BAD, &pctx)) {
-			ext2fs_file_acl_block_set(&inode, 0);
+			ext2fs_file_acl_block_set(fs, &inode, 0);
 			inode_modified++;
 		} else
 			not_fixed++;
diff --git a/e2fsck/super.c b/e2fsck/super.c
index abf8081..afec4b4 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -160,7 +160,7 @@ static int release_inode_blocks(e2fsck_t ctx, ext2_ino_t ino,
 	errcode_t			retval;
 	__u32				count;
 
-	if (!ext2fs_inode_has_valid_blocks(inode))
+	if (!ext2fs_inode_has_valid_blocks2(fs, inode))
 		return 0;
 
 	pb.buf = block_buf + 3 * ctx->fs->blocksize;
@@ -197,9 +197,10 @@ static int release_inode_blocks(e2fsck_t ctx, ext2_ino_t ino,
 	if (pb.truncated_blocks)
 		ext2fs_iblk_sub_blocks(fs, inode, pb.truncated_blocks);
 
-	if (ext2fs_file_acl_block(inode)) {
-		retval = ext2fs_adjust_ea_refcount2(fs, ext2fs_file_acl_block(inode),
-						   block_buf, -1, &count);
+	if (ext2fs_file_acl_block(fs, inode)) {
+		retval = ext2fs_adjust_ea_refcount2(fs,
+					ext2fs_file_acl_block(fs, inode),
+					block_buf, -1, &count);
 		if (retval == EXT2_ET_BAD_EA_BLOCK_NUM) {
 			retval = 0;
 			count = 1;
@@ -212,9 +213,8 @@ static int release_inode_blocks(e2fsck_t ctx, ext2_ino_t ino,
 		}
 		if (count == 0)
 			ext2fs_block_alloc_stats2(fs,
-						 ext2fs_file_acl_block(inode),
-						 -1);
-		ext2fs_file_acl_block_set(inode, 0);
+					ext2fs_file_acl_block(fs, inode), -1);
+		ext2fs_file_acl_block_set(fs, inode, 0);
 	}
 	return 0;
 }
diff --git a/lib/ext2fs/blknum.c b/lib/ext2fs/blknum.c
index fd203b4..33da7d6 100644
--- a/lib/ext2fs/blknum.c
+++ b/lib/ext2fs/blknum.c
@@ -475,23 +475,24 @@ void ext2fs_bg_checksum_set(ext2_filsys fs, dgrp_t group, __u16 checksum)
 
 /*
  * Get the acl block of a file
- *
- * XXX Ignoring 64-bit file system flag - most places where this is
- * called don't have access to the fs struct, and the high bits should
- * be 0 in the non-64-bit case anyway.
  */
-blk64_t ext2fs_file_acl_block(const struct ext2_inode *inode)
+blk64_t ext2fs_file_acl_block(ext2_filsys fs, const struct ext2_inode *inode)
 {
-	return (inode->i_file_acl |
-		(__u64) inode->osd2.linux2.l_i_file_acl_high << 32);
+	blk64_t	blk = inode->i_file_acl;
+
+	if (fs && fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+		blk |= ((__u64) inode->osd2.linux2.l_i_file_acl_high) << 32;
+	return blk;
 }
 
 /*
  * Set the acl block of a file
  */
-void ext2fs_file_acl_block_set(struct ext2_inode *inode, blk64_t blk)
+void ext2fs_file_acl_block_set(ext2_filsys fs, struct ext2_inode *inode,
+			       blk64_t blk)
 {
 	inode->i_file_acl = blk;
-	inode->osd2.linux2.l_i_file_acl_high = (__u64) blk >> 32;
+	if (fs && fs->super->s_feature_incompat & EXT4_FEATURE_INCOMPAT_64BIT)
+		inode->osd2.linux2.l_i_file_acl_high = (__u64) blk >> 32;
 }
 
diff --git a/lib/ext2fs/bmove.c b/lib/ext2fs/bmove.c
index d057998..e2ea405 100644
--- a/lib/ext2fs/bmove.c
+++ b/lib/ext2fs/bmove.c
@@ -141,7 +141,7 @@ errcode_t ext2fs_move_blocks(ext2_filsys fs,
 
 	while (ino) {
 		if ((inode.i_links_count == 0) ||
-		    !ext2fs_inode_has_valid_blocks(&inode))
+		    !ext2fs_inode_has_valid_blocks2(fs, &inode))
 			goto next;
 
 		pb.ino = ino;
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 411a383..57c5bfa 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -841,8 +841,10 @@ extern void ext2fs_bg_flags_set(ext2_filsys fs, dgrp_t group, __u16 bg_flags);
 extern void ext2fs_bg_flags_clear(ext2_filsys fs, dgrp_t group, __u16 bg_flags);
 extern __u16 ext2fs_bg_checksum(ext2_filsys fs, dgrp_t group);
 extern void ext2fs_bg_checksum_set(ext2_filsys fs, dgrp_t group, __u16 checksum);
-extern blk64_t ext2fs_file_acl_block(const struct ext2_inode *inode);
-extern void ext2fs_file_acl_block_set(struct ext2_inode *inode, blk64_t blk);
+extern blk64_t ext2fs_file_acl_block(ext2_filsys fs,
+				     const struct ext2_inode *inode);
+extern void ext2fs_file_acl_block_set(ext2_filsys fs,
+				      struct ext2_inode *inode, blk64_t blk);
 
 /* block.c */
 extern errcode_t ext2fs_block_iterate(ext2_filsys fs,
@@ -1396,6 +1398,8 @@ extern void ext2fs_swap_mmp(struct mmp_struct *mmp);
 
 /* valid_blk.c */
 extern int ext2fs_inode_has_valid_blocks(struct ext2_inode *inode);
+extern int ext2fs_inode_has_valid_blocks2(ext2_filsys fs,
+					  struct ext2_inode *inode);
 
 /* version.c */
 extern int ext2fs_parse_version_string(const char *ver_string);
diff --git a/lib/ext2fs/valid_blk.c b/lib/ext2fs/valid_blk.c
index 9047f41..895e36e 100644
--- a/lib/ext2fs/valid_blk.c
+++ b/lib/ext2fs/valid_blk.c
@@ -24,7 +24,7 @@
  * This function returns 1 if the inode's block entries actually
  * contain block entries.
  */
-int ext2fs_inode_has_valid_blocks(struct ext2_inode *inode)
+int ext2fs_inode_has_valid_blocks2(ext2_filsys fs, struct ext2_inode *inode)
 {
 	/*
 	 * Only directories, regular files, and some symbolic links
@@ -39,7 +39,7 @@ int ext2fs_inode_has_valid_blocks(struct ext2_inode *inode)
 	 * target is stored in the block entries.
 	 */
 	if (LINUX_S_ISLNK (inode->i_mode)) {
-		if (ext2fs_file_acl_block(inode) == 0) {
+		if (ext2fs_file_acl_block(fs, inode) == 0) {
 			/* With no EA block, we can rely on i_blocks */
 			if (inode->i_blocks == 0)
 				return 0;
@@ -54,3 +54,8 @@ int ext2fs_inode_has_valid_blocks(struct ext2_inode *inode)
 	}
 	return 1;
 }
+
+int ext2fs_inode_has_valid_blocks(struct ext2_inode *inode)
+{
+	return ext2fs_inode_has_valid_blocks2(NULL, inode);
+}
diff --git a/lib/quota/quotaio.c b/lib/quota/quotaio.c
index 0457886..8430db1 100644
--- a/lib/quota/quotaio.c
+++ b/lib/quota/quotaio.c
@@ -110,7 +110,7 @@ void truncate_quota_inode(ext2_filsys fs, ext2_ino_t ino)
 		return;
 
 	inode.i_dtime = fs->now ? fs->now : time(0);
-	if (!ext2fs_inode_has_valid_blocks(&inode))
+	if (!ext2fs_inode_has_valid_blocks2(fs, &inode))
 		return;
 
 	ext2fs_block_iterate3(fs, ino, BLOCK_FLAG_READ_ONLY, NULL,
diff --git a/misc/e2image.c b/misc/e2image.c
index 23a4df2..d888e5a 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -1087,12 +1087,12 @@ static void write_raw_image_file(ext2_filsys fs, int fd, int type, int flags)
 			break;
 		if (!inode.i_links_count)
 			continue;
-		if (ext2fs_file_acl_block(&inode)) {
+		if (ext2fs_file_acl_block(fs, &inode)) {
 			ext2fs_mark_block_bitmap2(meta_block_map,
-						 ext2fs_file_acl_block(&inode));
+					ext2fs_file_acl_block(fs, &inode));
 			meta_blocks_count++;
 		}
-		if (!ext2fs_inode_has_valid_blocks(&inode))
+		if (!ext2fs_inode_has_valid_blocks2(fs, &inode))
 			continue;
 
 		stashed_ino = ino;
@@ -1100,7 +1100,7 @@ static void write_raw_image_file(ext2_filsys fs, int fd, int type, int flags)
 		pb.is_dir = LINUX_S_ISDIR(inode.i_mode);
 		if (LINUX_S_ISDIR(inode.i_mode) ||
 		    (LINUX_S_ISLNK(inode.i_mode) &&
-		     ext2fs_inode_has_valid_blocks(&inode)) ||
+		     ext2fs_inode_has_valid_blocks2(fs, &inode)) ||
 		    ino == fs->super->s_journal_inum) {
 			retval = ext2fs_block_iterate3(fs, ino,
 					BLOCK_FLAG_READ_ONLY, block_buf,
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 5c44607..ccb27a8 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -1486,14 +1486,15 @@ static int inode_scan_and_fix(ext2_filsys fs, ext2fs_block_bitmap bmap)
 		 * Do we need to fix this ??
 		 */
 
-		if (ext2fs_file_acl_block(&inode) &&
+		if (ext2fs_file_acl_block(fs, &inode) &&
 		    ext2fs_test_block_bitmap2(bmap,
-					      ext2fs_file_acl_block(&inode))) {
-			blk = translate_block(ext2fs_file_acl_block(&inode));
+					ext2fs_file_acl_block(fs, &inode))) {
+			blk = translate_block(ext2fs_file_acl_block(fs,
+								    &inode));
 			if (!blk)
 				continue;
 
-			ext2fs_file_acl_block_set(&inode, blk);
+			ext2fs_file_acl_block_set(fs, &inode, blk);
 
 			/*
 			 * Write the inode to disk so that inode table
@@ -1504,7 +1505,7 @@ static int inode_scan_and_fix(ext2_filsys fs, ext2fs_block_bitmap bmap)
 				goto err_out;
 		}
 
-		if (!ext2fs_inode_has_valid_blocks(&inode))
+		if (!ext2fs_inode_has_valid_blocks2(fs, &inode))
 			continue;
 
 		retval = ext2fs_block_iterate3(fs, ino, 0, block_buf,
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index a957850..06ce73e 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -1371,18 +1371,19 @@ static errcode_t inode_scan_and_fix(ext2_resize_t rfs)
 		pb.is_dir = LINUX_S_ISDIR(inode->i_mode);
 		pb.changed = 0;
 
-		if (ext2fs_file_acl_block(inode) && rfs->bmap) {
+		if (ext2fs_file_acl_block(rfs->old_fs, inode) && rfs->bmap) {
 			new_block = ext2fs_extent_translate(rfs->bmap,
-							    ext2fs_file_acl_block(inode));
+				ext2fs_file_acl_block(rfs->old_fs, inode));
 			if (new_block) {
-				ext2fs_file_acl_block_set(inode, new_block);
+				ext2fs_file_acl_block_set(rfs->old_fs, inode,
+							  new_block);
 				retval = ext2fs_write_inode_full(rfs->old_fs,
 							    ino, inode, inode_size);
 				if (retval) goto errout;
 			}
 		}
 
-		if (ext2fs_inode_has_valid_blocks(inode) &&
+		if (ext2fs_inode_has_valid_blocks2(rfs->old_fs, inode) &&
 		    (rfs->bmap || pb.is_dir)) {
 			pb.ino = ino;
 			retval = ext2fs_block_iterate3(rfs->old_fs,
diff --git a/tests/f_bad_disconnected_inode/expect.1 b/tests/f_bad_disconnected_inode/expect.1
index b1bfca5..d3920e3 100644
--- a/tests/f_bad_disconnected_inode/expect.1
+++ b/tests/f_bad_disconnected_inode/expect.1
@@ -24,13 +24,13 @@ Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Inode 2 ref count is 4, should be 3.  Fix? yes
 
-i_file_acl for inode 13 (...) is 239964041625745, should be zero.
+i_file_acl for inode 13 (...) is 4218798225, should be zero.
 Clear? yes
 
 Inode 13 (...) has invalid mode (0117003).
 Clear? yes
 
-i_file_acl for inode 14 (...) is 178759431711162, should be zero.
+i_file_acl for inode 14 (...) is 2892851642, should be zero.
 Clear? yes
 
 Inode 14 (...) has invalid mode (0154247).
-- 
1.7.4.1.22.gec8e1.dirty

