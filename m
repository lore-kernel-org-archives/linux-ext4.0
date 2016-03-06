From: Li Xi <pkuelelixi@gmail.com>
Subject: [v4 1/6] Always read full inode structure
Date: Sun,  6 Mar 2016 13:14:51 +0900
Message-ID: <1457237696-13770-2-git-send-email-lixi@ddn.com>
References: <1457237696-13770-1-git-send-email-lixi@ddn.com>
To: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger@dilger.ca,
	jack@suse.cz, viro@zeniv.linux.org.uk, hch@infradead.org,
	dmonakhov@openvz.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36107 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbcCFEPH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 5 Mar 2016 23:15:07 -0500
Received: by mail-pa0-f49.google.com with SMTP id fi3so56177697pac.3
        for <linux-ext4@vger.kernel.org>; Sat, 05 Mar 2016 20:15:06 -0800 (PST)
In-Reply-To: <1457237696-13770-1-git-send-email-lixi@ddn.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Project quota need use some extra field of inode for computing quota
accounting, this patch tries to use ext2fs_get_next_inode_full()
everywhere to read full inode into memeory.

It also fixes a bug that only copy small inode in the function.

Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 debugfs/icheck.c       |   26 ++++++++++++++++++--------
 debugfs/lsdel.c        |   30 +++++++++++++++++++-----------
 debugfs/ncheck.c       |   20 ++++++++++++++------
 e2fsck/iscan.c         |   12 ++++++++++--
 e2fsck/pass1.c         |   12 +++++++-----
 e2fsck/pass1b.c        |   27 +++++++++++++++++++--------
 e2fsck/scantest.c      |   26 ++++++++++++++++++--------
 lib/ext2fs/bmove.c     |   37 +++++++++++++++++++++++++------------
 lib/ext2fs/tst_iscan.c |   17 ++++++++++++++---
 lib/support/mkquota.c  |   27 ++++++++++++++++++---------
 misc/e2image.c         |   41 ++++++++++++++++++++++++++---------------
 misc/tune2fs.c         |   28 ++++++++++++++++++----------
 resize/resize2fs.c     |    3 ++-
 13 files changed, 208 insertions(+), 98 deletions(-)

diff --git a/debugfs/icheck.c b/debugfs/icheck.c
index 3b9bd14..9f36d27 100644
--- a/debugfs/icheck.c
+++ b/debugfs/icheck.c
@@ -60,8 +60,9 @@ void do_icheck(int argc, char **argv)
 	int			i;
 	ext2_inode_scan		scan = 0;
 	ext2_ino_t		ino;
-	struct ext2_inode	inode;
 	errcode_t		retval;
+	struct ext2_inode	*inode;
+	int			inode_size;
 	char			*block_buf;
 
 	if (argc < 2) {
@@ -71,8 +72,14 @@ void do_icheck(int argc, char **argv)
 	if (check_fs_open(argv[0]))
 		return;
 
+	inode_size = EXT2_INODE_SIZE(current_fs->super);
+	retval = ext2fs_get_mem(inode_size, &inode);
+	if (retval)
+		return;
+
 	bw.barray = malloc(sizeof(struct block_info) * argc);
 	if (!bw.barray) {
+		ext2fs_free_mem(&inode);
 		com_err("icheck", ENOMEM,
 			"while allocating inode info array");
 		return;
@@ -99,7 +106,8 @@ void do_icheck(int argc, char **argv)
 	}
 
 	do {
-		retval = ext2fs_get_next_inode(scan, &ino, &inode);
+		retval = ext2fs_get_next_inode_full(scan, &ino,
+						    inode, inode_size);
 	} while (retval == EXT2_ET_BAD_BLOCK_IN_INODE_TABLE);
 	if (retval) {
 		com_err("icheck", retval, "while starting inode scan");
@@ -109,27 +117,27 @@ void do_icheck(int argc, char **argv)
 	while (ino) {
 		blk64_t blk;
 
-		if (!inode.i_links_count)
+		if (!inode->i_links_count)
 			goto next;
 
 		bw.inode = ino;
 
-		blk = ext2fs_file_acl_block(current_fs, &inode);
+		blk = ext2fs_file_acl_block(current_fs, inode);
 		if (blk) {
 			icheck_proc(current_fs, &blk, 0,
 				    0, 0, &bw);
 			if (bw.blocks_left == 0)
 				break;
-			ext2fs_file_acl_block_set(current_fs, &inode, blk);
+			ext2fs_file_acl_block_set(current_fs, inode, blk);
 		}
 
-		if (!ext2fs_inode_has_valid_blocks2(current_fs, &inode))
+		if (!ext2fs_inode_has_valid_blocks2(current_fs, inode))
 			goto next;
 		/*
 		 * To handle filesystems touched by 0.3c extfs; can be
 		 * removed later.
 		 */
-		if (inode.i_dtime)
+		if (inode->i_dtime)
 			goto next;
 
 		retval = ext2fs_block_iterate3(current_fs, ino,
@@ -146,7 +154,8 @@ void do_icheck(int argc, char **argv)
 
 	next:
 		do {
-			retval = ext2fs_get_next_inode(scan, &ino, &inode);
+			retval = ext2fs_get_next_inode_full(scan, &ino,
+							    inode, inode_size);
 		} while (retval == EXT2_ET_BAD_BLOCK_IN_INODE_TABLE);
 		if (retval) {
 			com_err("icheck", retval,
@@ -165,6 +174,7 @@ void do_icheck(int argc, char **argv)
 	}
 
 error_out:
+	ext2fs_free_mem(&inode);
 	free(bw.barray);
 	free(block_buf);
 	if (scan)
diff --git a/debugfs/lsdel.c b/debugfs/lsdel.c
index 7d5e7d8..6d11e3b 100644
--- a/debugfs/lsdel.c
+++ b/debugfs/lsdel.c
@@ -78,7 +78,8 @@ void do_lsdel(int argc, char **argv)
 	int			num_delarray, max_delarray;
 	ext2_inode_scan		scan = 0;
 	ext2_ino_t		ino;
-	struct ext2_inode	inode;
+	struct ext2_inode	*inode;
+	int			inode_size;
 	errcode_t		retval;
 	char			*block_buf;
 	int			i;
@@ -121,9 +122,14 @@ void do_lsdel(int argc, char **argv)
 			"while opening inode scan");
 		goto error_out;
 	}
+	inode_size = EXT2_INODE_SIZE(current_fs->super);
+	retval = ext2fs_get_mem(inode_size, &inode);
+	if (retval)
+		goto error_out;
 
 	do {
-		retval = ext2fs_get_next_inode(scan, &ino, &inode);
+		retval = ext2fs_get_next_inode_full(scan, &ino,
+						    inode, inode_size);
 	} while (retval == EXT2_ET_BAD_BLOCK_IN_INODE_TABLE);
 	if (retval) {
 		com_err("ls_deleted_inodes", retval,
@@ -132,8 +138,8 @@ void do_lsdel(int argc, char **argv)
 	}
 
 	while (ino) {
-		if ((inode.i_dtime == 0) ||
-		    (secs && ((unsigned) abs(now - secs) > inode.i_dtime)))
+		if ((inode->i_dtime == 0) ||
+		    (secs && ((unsigned) abs(now - secs) > inode->i_dtime)))
 			goto next;
 
 		lsd.inode = ino;
@@ -141,7 +147,7 @@ void do_lsdel(int argc, char **argv)
 		lsd.free_blocks = 0;
 		lsd.bad_blocks = 0;
 
-		if (ext2fs_inode_has_valid_blocks2(current_fs, &inode)) {
+		if (ext2fs_inode_has_valid_blocks2(current_fs, inode)) {
 			retval = ext2fs_block_iterate3(current_fs, ino,
 						       BLOCK_FLAG_READ_ONLY,
 						       block_buf,
@@ -153,7 +159,7 @@ void do_lsdel(int argc, char **argv)
 			}
 		}
 		if ((lsd.free_blocks && !lsd.bad_blocks) ||
-		    inode.i_flags & EXT4_INLINE_DATA_FL) {
+		    inode->i_flags & EXT4_INLINE_DATA_FL) {
 			if (num_delarray >= max_delarray) {
 				max_delarray += 50;
 				delarray = realloc(delarray,
@@ -167,10 +173,10 @@ void do_lsdel(int argc, char **argv)
 			}
 
 			delarray[num_delarray].ino = ino;
-			delarray[num_delarray].mode = inode.i_mode;
-			delarray[num_delarray].uid = inode_uid(inode);
-			delarray[num_delarray].size = EXT2_I_SIZE(&inode);
-			delarray[num_delarray].dtime = (__s32) inode.i_dtime;
+			delarray[num_delarray].mode = inode->i_mode;
+			delarray[num_delarray].uid = inode_uid(*inode);
+			delarray[num_delarray].size = EXT2_I_SIZE(inode);
+			delarray[num_delarray].dtime = (__s32) inode->i_dtime;
 			delarray[num_delarray].num_blocks = lsd.num_blocks;
 			delarray[num_delarray].free_blocks = lsd.free_blocks;
 			num_delarray++;
@@ -178,7 +184,8 @@ void do_lsdel(int argc, char **argv)
 
 	next:
 		do {
-			retval = ext2fs_get_next_inode(scan, &ino, &inode);
+			retval = ext2fs_get_next_inode_full(scan, &ino,
+							inode, inode_size);
 		} while (retval == EXT2_ET_BAD_BLOCK_IN_INODE_TABLE);
 		if (retval) {
 			com_err("ls_deleted_inodes", retval,
@@ -205,6 +212,7 @@ void do_lsdel(int argc, char **argv)
 	close_pager(out);
 
 error_out:
+	ext2fs_free_mem(&inode);
 	free(block_buf);
 	free(delarray);
 	if (scan)
diff --git a/debugfs/ncheck.c b/debugfs/ncheck.c
index 5d9b5d2..3becd59 100644
--- a/debugfs/ncheck.c
+++ b/debugfs/ncheck.c
@@ -95,7 +95,8 @@ void do_ncheck(int argc, char **argv)
 	int			c, i;
 	ext2_inode_scan		scan = 0;
 	ext2_ino_t		ino;
-	struct ext2_inode	inode;
+	struct ext2_inode	*inode;
+	int			inode_size;
 	errcode_t		retval;
 	char			*tmp;
 
@@ -145,9 +146,14 @@ void do_ncheck(int argc, char **argv)
 		com_err("ncheck", retval, "while opening inode scan");
 		goto error_out;
 	}
+	inode_size = EXT2_INODE_SIZE(current_fs->super);
+	retval = ext2fs_get_mem(inode_size, &inode);
+	if (retval)
+		goto error_out;
 
 	do {
-		retval = ext2fs_get_next_inode(scan, &ino, &inode);
+		retval = ext2fs_get_next_inode_full(scan, &ino,
+						inode, inode_size);
 	} while (retval == EXT2_ET_BAD_BLOCK_IN_INODE_TABLE);
 	if (retval) {
 		com_err("ncheck", retval, "while starting inode scan");
@@ -156,16 +162,16 @@ void do_ncheck(int argc, char **argv)
 
 	printf("Inode\tPathname\n");
 	while (ino) {
-		if (!inode.i_links_count)
+		if (!inode->i_links_count)
 			goto next;
 		/*
 		 * To handle filesystems touched by 0.3c extfs; can be
 		 * removed later.
 		 */
-		if (inode.i_dtime)
+		if (inode->i_dtime)
 			goto next;
 		/* Ignore anything that isn't a directory */
-		if (!LINUX_S_ISDIR(inode.i_mode))
+		if (!LINUX_S_ISDIR(inode->i_mode))
 			goto next;
 
 		iw.position = 0;
@@ -187,7 +193,8 @@ void do_ncheck(int argc, char **argv)
 
 	next:
 		do {
-			retval = ext2fs_get_next_inode(scan, &ino, &inode);
+			retval = ext2fs_get_next_inode_full(scan, &ino,
+							inode, inode_size);
 		} while (retval == EXT2_ET_BAD_BLOCK_IN_INODE_TABLE);
 
 		if (retval) {
@@ -198,6 +205,7 @@ void do_ncheck(int argc, char **argv)
 	}
 
 error_out:
+	ext2fs_free_mem(inode);
 	free(iw.iarray);
 	if (scan)
 		ext2fs_close_inode_scan(scan);
diff --git a/e2fsck/iscan.c b/e2fsck/iscan.c
index 52cad11..6ea9e11 100644
--- a/e2fsck/iscan.c
+++ b/e2fsck/iscan.c
@@ -97,7 +97,8 @@ int main (int argc, char *argv[])
 	ext2_filsys	fs;
 	ext2_ino_t	ino;
 	__u32	num_inodes = 0;
-	struct ext2_inode inode;
+	struct ext2_inode *inode;
+	int		inode_size;
 	ext2_inode_scan	scan;
 
 	init_resource_track(&global_rtrack);
@@ -120,8 +121,14 @@ int main (int argc, char *argv[])
 		exit(1);
 	}
 
+	inode_size = EXT2_INODE_SIZE(current_fs->super);
+	retval = ext2fs_get_mem(inode_size, &inode);
+	if (retval)
+		exit(1);
+
 	while (1) {
-		retval = ext2fs_get_next_inode(scan, &ino, &inode);
+		retval = ext2fs_get_next_inode_full(scan, &ino,
+						inode, inode_size);
 		if (retval) {
 			com_err(program_name, retval,
 				_("while getting next inode"));
@@ -132,6 +139,7 @@ int main (int argc, char *argv[])
 		num_inodes++;
 	}
 
+	ext2fs_free_mem(&inode);
 	print_resource_track(NULL, &global_rtrack);
 	printf(_("%u inodes scanned.\n"), num_inodes);
 
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 5a8d4a1..48aa302 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -102,7 +102,7 @@ struct process_block_struct {
 
 struct process_inode_block {
 	ext2_ino_t ino;
-	struct ext2_inode inode;
+	struct ext2_inode_large inode;
 };
 
 struct scan_callback_struct {
@@ -1741,7 +1741,8 @@ void e2fsck_pass1(e2fsck_t ctx)
 		     inode->i_block[EXT2_TIND_BLOCK] ||
 		     ext2fs_file_acl_block(fs, inode))) {
 			inodes_to_process[process_inode_count].ino = ino;
-			inodes_to_process[process_inode_count].inode = *inode;
+			inodes_to_process[process_inode_count].inode =
+							*((struct ext2_inode_large *)inode);
 			process_inode_count++;
 		} else
 			check_blocks(ctx, &pctx, block_buf);
@@ -1904,7 +1905,8 @@ static void process_inodes(e2fsck_t ctx, char *block_buf)
 		      sizeof(struct process_inode_block), process_inode_cmp);
 	clear_problem_context(&pctx);
 	for (i=0; i < process_inode_count; i++) {
-		pctx.inode = ctx->stashed_inode = &inodes_to_process[i].inode;
+		pctx.inode = ctx->stashed_inode =
+				(struct ext2_inode *)&inodes_to_process[i].inode;
 		pctx.ino = ctx->stashed_ino = inodes_to_process[i].ino;
 
 #if 0
@@ -1942,8 +1944,8 @@ static EXT2_QSORT_TYPE process_inode_cmp(const void *a, const void *b)
 		 * inodes, so it's OK to pass NULL to
 		 * ext2fs_file_acl_block() here.
 		 */
-		ret = ext2fs_file_acl_block(0, &(ib_a->inode)) -
-			ext2fs_file_acl_block(0, &(ib_b->inode));
+		ret = ext2fs_file_acl_block(0, (struct ext2_inode *)&(ib_a->inode)) -
+			ext2fs_file_acl_block(0, (struct ext2_inode *)&(ib_b->inode));
 	if (ret == 0)
 		ret = ib_a->ino - ib_b->ino;
 	return ret;
diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index 2cbf82a..20e0d02 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -271,7 +271,8 @@ static void pass1b(e2fsck_t ctx, char *block_buf)
 {
 	ext2_filsys fs = ctx->fs;
 	ext2_ino_t ino = 0;
-	struct ext2_inode inode;
+	struct ext2_inode *inode;
+	int inode_size;
 	ext2_inode_scan	scan;
 	struct process_block_struct pb;
 	struct problem_context pctx;
@@ -288,7 +289,15 @@ static void pass1b(e2fsck_t ctx, char *block_buf)
 		ctx->flags |= E2F_FLAG_ABORT;
 		return;
 	}
-	ctx->stashed_inode = &inode;
+	inode_size = EXT2_INODE_SIZE(fs->super);
+	pctx.errcode = ext2fs_get_mem(inode_size, &inode);
+	if (pctx.errcode) {
+		ext2fs_close_inode_scan(scan);
+		ctx->flags |= E2F_FLAG_ABORT;
+		return;
+	}
+
+	ctx->stashed_inode = inode;
 	pb.ctx = ctx;
 	pb.pctx = &pctx;
 	pctx.str = "pass1b";
@@ -297,7 +306,8 @@ static void pass1b(e2fsck_t ctx, char *block_buf)
 			if (e2fsck_mmp_update(fs))
 				fatal_error(ctx, 0);
 		}
-		pctx.errcode = ext2fs_get_next_inode(scan, &ino, &inode);
+		pctx.errcode = ext2fs_get_next_inode_full(scan, &ino,
+						     inode, inode_size);
 		if (pctx.errcode == EXT2_ET_BAD_BLOCK_IN_INODE_TABLE)
 			continue;
 		if (pctx.errcode) {
@@ -315,24 +325,24 @@ static void pass1b(e2fsck_t ctx, char *block_buf)
 
 		pb.ino = ino;
 		pb.dup_blocks = 0;
-		pb.inode = &inode;
+		pb.inode = inode;
 		pb.cur_cluster = ~0;
 		pb.phys_cluster = ~0;
 		pb.last_blk = 0;
 		pb.pctx->blk = pb.pctx->blk2 = 0;
 
-		if (ext2fs_inode_has_valid_blocks2(fs, &inode) ||
+		if (ext2fs_inode_has_valid_blocks2(fs, inode) ||
 		    (ino == EXT2_BAD_INO))
 			pctx.errcode = ext2fs_block_iterate3(fs, ino,
 					     BLOCK_FLAG_READ_ONLY, block_buf,
 					     process_pass1b_block, &pb);
 		/* If the feature is not set, attrs will be cleared later anyway */
 		if (ext2fs_has_feature_xattr(fs->super) &&
-		    ext2fs_file_acl_block(fs, &inode)) {
-			blk64_t blk = ext2fs_file_acl_block(fs, &inode);
+		    ext2fs_file_acl_block(fs, inode)) {
+			blk64_t blk = ext2fs_file_acl_block(fs, inode);
 			process_pass1b_block(fs, &blk,
 					     BLOCK_COUNT_EXTATTR, 0, 0, &pb);
-			ext2fs_file_acl_block_set(fs, &inode, blk);
+			ext2fs_file_acl_block_set(fs, inode, blk);
 		}
 		if (pb.dup_blocks) {
 			if (ino != EXT2_BAD_INO) {
@@ -348,6 +358,7 @@ static void pass1b(e2fsck_t ctx, char *block_buf)
 		if (pctx.errcode)
 			fix_problem(ctx, PR_1B_BLOCK_ITERATE, &pctx);
 	}
+	ext2fs_free_mem(&inode);
 	ext2fs_close_inode_scan(scan);
 	e2fsck_use_inode_shortcuts(ctx, 0);
 }
diff --git a/e2fsck/scantest.c b/e2fsck/scantest.c
index 6131141..87a5b97 100644
--- a/e2fsck/scantest.c
+++ b/e2fsck/scantest.c
@@ -88,12 +88,12 @@ static void print_resource_track(struct resource_track *track)
 int main (int argc, char *argv[])
 {
 	errcode_t	retval = 0;
-	int		exit_value = 0;
 	int		i;
 	ext2_filsys	fs;
 	ext2_inode_scan	scan;
 	ext2_ino_t	ino;
-	struct ext2_inode inode;
+	struct ext2_inode *inode;
+	int inode_size;
 
 	printf(_("size of inode=%d\n"), sizeof(inode));
 
@@ -114,17 +114,27 @@ int main (int argc, char *argv[])
 		com_err(argv[0], retval, _("while opening inode scan"));
 		exit(1);
 	}
-	retval = ext2fs_get_next_inode(scan, &ino, &inode);
+
+	inode_size = EXT2_INODE_SIZE(fs->super);
+	retval = ext2fs_get_mem(inode_size, &inode);
+	if (retval) {
+		com_err(argv[0], retval, _("while allocating inode memory"));
+		exit(1);
+	}
+
+	retval = ext2fs_get_next_inode_full(scan, &ino,
+					inode, inode_size);
 	if (retval) {
 		com_err(argv[0], retval, _("while starting inode scan"));
 		exit(1);
 	}
 	while (ino) {
-		if (!inode.i_links_count)
+		if (!inode->i_links_count)
 			goto next;
-		printf("%lu\n", inode.i_blocks);
+		printf("%lu\n", inode->i_blocks);
 	next:
-		retval = ext2fs_get_next_inode(scan, &ino, &inode);
+		retval = ext2fs_get_next_inode_full(scan, &ino,
+					inode, inode_size);
 		if (retval) {
 			com_err(argv[0], retval,
 				_("while doing inode scan"));
@@ -133,9 +143,9 @@ int main (int argc, char *argv[])
 	}
 
 
+	ext2fs_free_mem(&inode);
 	ext2fs_close_free(&fs);
 
 	print_resource_track(&global_rtrack);
-
-	return exit_value;
+	return 0;
 }
diff --git a/lib/ext2fs/bmove.c b/lib/ext2fs/bmove.c
index e2ea405..93f6ebd 100644
--- a/lib/ext2fs/bmove.c
+++ b/lib/ext2fs/bmove.c
@@ -100,11 +100,17 @@ errcode_t ext2fs_move_blocks(ext2_filsys fs,
 			     int flags)
 {
 	ext2_ino_t	ino;
-	struct ext2_inode inode;
+	struct ext2_inode *inode;
+	int inode_size;
 	errcode_t	retval;
 	struct process_block_struct pb;
 	ext2_inode_scan	scan;
-	char		*block_buf;
+	char		*block_buf = NULL;
+
+	inode_size = EXT2_INODE_SIZE(fs->super);
+	retval = ext2fs_get_mem(inode_size, &inode);
+	if (retval)
+		return retval;
 
 	retval = ext2fs_open_inode_scan(fs, 0, &scan);
 	if (retval)
@@ -132,20 +138,21 @@ errcode_t ext2fs_move_blocks(ext2_filsys fs,
 		}
 		retval = ext2fs_init_dblist(fs, 0);
 		if (retval)
-			return retval;
+			goto error;
 	}
 
-	retval = ext2fs_get_next_inode(scan, &ino, &inode);
+	retval = ext2fs_get_next_inode_full(scan, &ino,
+					    inode, inode_size);
 	if (retval)
-		return retval;
+		goto error;
 
 	while (ino) {
-		if ((inode.i_links_count == 0) ||
-		    !ext2fs_inode_has_valid_blocks2(fs, &inode))
+		if ((inode->i_links_count == 0) ||
+		    !ext2fs_inode_has_valid_blocks2(fs, inode))
 			goto next;
 
 		pb.ino = ino;
-		pb.inode = &inode;
+		pb.inode = inode;
 
 		pb.add_dir = (LINUX_S_ISDIR(inode.i_mode) &&
 			      flags & EXT2_BMOVE_GET_DBLIST);
@@ -153,15 +160,21 @@ errcode_t ext2fs_move_blocks(ext2_filsys fs,
 		retval = ext2fs_block_iterate3(fs, ino, 0, block_buf,
 					       process_block, &pb);
 		if (retval)
-			return retval;
-		if (pb.error)
-			return pb.error;
+			goto error;
+		if (pb.error) {
+			retval = pb.error;
+			goto error;
+		}
 
 	next:
-		retval = ext2fs_get_next_inode(scan, &ino, &inode);
+		retval = ext2fs_get_next_inode_full(scan, &ino,
+						inode, inode_size);
 		if (retval == EXT2_ET_BAD_BLOCK_IN_INODE_TABLE)
 			goto next;
 	}
+error:
+	ext2fs_free_mem(&inode);
+	ext2fs_free_mem(&block_buf);
 	return 0;
 }
 
diff --git a/lib/ext2fs/tst_iscan.c b/lib/ext2fs/tst_iscan.c
index 70bfbec..6e72c9d 100644
--- a/lib/ext2fs/tst_iscan.c
+++ b/lib/ext2fs/tst_iscan.c
@@ -140,7 +140,8 @@ static void setup(void)
  */
 static void iterate(void)
 {
-	struct ext2_inode inode;
+	struct ext2_inode *inode;
+	int inode_size;
 	ext2_inode_scan	scan;
 	errcode_t	retval;
 	ext2_ino_t	ino;
@@ -150,14 +151,23 @@ static void iterate(void)
 		com_err("iterate", retval, "While opening inode scan");
 		exit(1);
 	}
+
+	inode_size = EXT2_INODE_SIZE(test_fs->super);
+	retval = ext2fs_get_mem(inode_size, &inode);
+	if (retval) {
+		com_err("iterate", retval, "while allocating inode mem");
+		exit(1);
+	}
 	printf("Reading blocks: ");
-	retval = ext2fs_get_next_inode(scan, &ino, &inode);
+	retval = ext2fs_get_next_inode_full(scan, &ino,
+				       inode, inode_size);
 	if (retval) {
 		com_err("iterate", retval, "while reading first inode");
 		exit(1);
 	}
 	while (ino) {
-		retval = ext2fs_get_next_inode(scan, &ino, &inode);
+		retval = ext2fs_get_next_inode_full(scan, &ino,
+					       inode, inode_size);
 		if (retval == EXT2_ET_BAD_BLOCK_IN_INODE_TABLE) {
 			ext2fs_mark_inode_bitmap2(bad_inode_map, ino);
 			continue;
@@ -169,6 +179,7 @@ static void iterate(void)
 		}
 	}
 	printf("\n");
+	ext2fs_free_mem(&inode);
 	ext2fs_close_inode_scan(scan);
 }
 
diff --git a/lib/support/mkquota.c b/lib/support/mkquota.c
index 00e96f8..dc458d7 100644
--- a/lib/support/mkquota.c
+++ b/lib/support/mkquota.c
@@ -420,41 +420,50 @@ errcode_t quota_compute_usage(quota_ctx_t qctx)
 	ext2_filsys fs;
 	ext2_ino_t ino;
 	errcode_t ret;
-	struct ext2_inode inode;
+	struct ext2_inode* inode;
+	int inode_size;
 	qsize_t space;
 	ext2_inode_scan scan;
 
 	if (!qctx)
 		return 0;
 
+	inode_size = EXT2_INODE_SIZE(qctx->fs->super);
+	ret = ext2fs_get_mem(inode_size, &inode);
+	if (ret)
+		return ret;
+
 	fs = qctx->fs;
 	ret = ext2fs_open_inode_scan(fs, 0, &scan);
 	if (ret) {
+		free(inode);
 		log_err("while opening inode scan. ret=%ld", ret);
 		return ret;
 	}
 
 	while (1) {
-		ret = ext2fs_get_next_inode(scan, &ino, &inode);
+		ret = ext2fs_get_next_inode_full(scan, &ino, inode,
+						 inode_size);
 		if (ret) {
 			log_err("while getting next inode. ret=%ld", ret);
-			ext2fs_close_inode_scan(scan);
-			return ret;
+			goto err;
 		}
 		if (ino == 0)
 			break;
-		if (inode.i_links_count &&
+		if (inode->i_links_count &&
 		    (ino == EXT2_ROOT_INO ||
 		     ino >= EXT2_FIRST_INODE(fs->super))) {
-			space = ext2fs_inode_i_blocks(fs, &inode) << 9;
-			quota_data_add(qctx, &inode, ino, space);
-			quota_data_inodes(qctx, &inode, ino, +1);
+			space = ext2fs_inode_i_blocks(fs, inode) << 9;
+			quota_data_add(qctx, inode, ino, space);
+			quota_data_inodes(qctx, inode, ino, +1);
 		}
 	}
 
+err:
 	ext2fs_close_inode_scan(scan);
+	free(inode);
 
-	return 0;
+	return ret;
 }
 
 struct scan_dquots_data {
diff --git a/misc/e2image.c b/misc/e2image.c
index e9b4ae2..cf9e597 100644
--- a/misc/e2image.c
+++ b/misc/e2image.c
@@ -1258,7 +1258,8 @@ static void output_qcow2_meta_data_blocks(ext2_filsys fs, int fd)
 static void write_raw_image_file(ext2_filsys fs, int fd, int type, int flags)
 {
 	struct process_block_struct	pb;
-	struct ext2_inode		inode;
+	struct ext2_inode		*inode;
+	int				inode_size;
 	ext2_inode_scan			scan;
 	ext2_ino_t			ino;
 	errcode_t			retval;
@@ -1301,10 +1302,19 @@ static void write_raw_image_file(ext2_filsys fs, int fd, int type, int flags)
 		exit(1);
 	}
 
+	inode_size = EXT2_INODE_SIZE(fs->super);
+	retval = ext2fs_get_mem(inode_size, &inode);
+	if (retval) {
+		com_err(program_name, retval,
+			_("while allocating inode memory"));
+		exit(1);
+	}
+
 	use_inode_shortcuts(fs, 1);
-	stashed_inode = &inode;
+	stashed_inode = inode;
 	while (1) {
-		retval = ext2fs_get_next_inode(scan, &ino, &inode);
+		retval = ext2fs_get_next_inode_full(scan, &ino,
+						inode, inode_size);
 		if (retval == EXT2_ET_BAD_BLOCK_IN_INODE_TABLE)
 			continue;
 		if (retval) {
@@ -1314,22 +1324,22 @@ static void write_raw_image_file(ext2_filsys fs, int fd, int type, int flags)
 		}
 		if (ino == 0)
 			break;
-		if (!inode.i_links_count)
+		if (!inode->i_links_count)
 			continue;
-		if (ext2fs_file_acl_block(fs, &inode)) {
+		if (ext2fs_file_acl_block(fs, inode)) {
 			ext2fs_mark_block_bitmap2(meta_block_map,
-					ext2fs_file_acl_block(fs, &inode));
+					ext2fs_file_acl_block(fs, inode));
 			meta_blocks_count++;
 		}
-		if (!ext2fs_inode_has_valid_blocks2(fs, &inode))
+		if (!ext2fs_inode_has_valid_blocks2(fs, inode))
 			continue;
 
 		stashed_ino = ino;
 		pb.ino = ino;
-		pb.is_dir = LINUX_S_ISDIR(inode.i_mode);
-		if (LINUX_S_ISDIR(inode.i_mode) ||
-		    (LINUX_S_ISLNK(inode.i_mode) &&
-		     ext2fs_inode_has_valid_blocks2(fs, &inode)) ||
+		pb.is_dir = LINUX_S_ISDIR(inode->i_mode);
+		if (LINUX_S_ISDIR(inode->i_mode) ||
+		    (LINUX_S_ISLNK(inode->i_mode) &&
+		     ext2fs_inode_has_valid_blocks2(fs, inode)) ||
 		    ino == fs->super->s_journal_inum) {
 			retval = ext2fs_block_iterate3(fs, ino,
 					BLOCK_FLAG_READ_ONLY, block_buf,
@@ -1341,10 +1351,10 @@ static void write_raw_image_file(ext2_filsys fs, int fd, int type, int flags)
 				exit(1);
 			}
 		} else {
-			if ((inode.i_flags & EXT4_EXTENTS_FL) ||
-			    inode.i_block[EXT2_IND_BLOCK] ||
-			    inode.i_block[EXT2_DIND_BLOCK] ||
-			    inode.i_block[EXT2_TIND_BLOCK] || all_data) {
+			if ((inode->i_flags & EXT4_EXTENTS_FL) ||
+			    inode->i_block[EXT2_IND_BLOCK] ||
+			    inode->i_block[EXT2_DIND_BLOCK] ||
+			    inode->i_block[EXT2_TIND_BLOCK] || all_data) {
 				retval = ext2fs_block_iterate3(fs,
 				       ino, BLOCK_FLAG_READ_ONLY, block_buf,
 				       process_file_block, &pb);
@@ -1363,6 +1373,7 @@ static void write_raw_image_file(ext2_filsys fs, int fd, int type, int flags)
 	else
 		output_meta_data_blocks(fs, fd, flags);
 
+	ext2fs_free_mem(&inode);
 	ext2fs_free_mem(&block_buf);
 	ext2fs_close_inode_scan(scan);
 	ext2fs_free_block_bitmap(meta_block_map);
diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 4d57399..b072ab9 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -2164,26 +2164,33 @@ static int inode_scan_and_fix(ext2_filsys fs, ext2fs_block_bitmap bmap)
 	ext2_ino_t ino;
 	blk64_t blk;
 	char *block_buf = 0;
-	struct ext2_inode inode;
+	struct ext2_inode *inode;
+	int inode_size;
 	ext2_inode_scan	scan = NULL;
 
-	retval = ext2fs_get_mem(fs->blocksize * 3, &block_buf);
+	inode_size = EXT2_INODE_SIZE(fs->super);
+	retval = ext2fs_get_mem(inode_size, &inode);
 	if (retval)
 		return retval;
 
+	retval = ext2fs_get_mem(fs->blocksize * 3, &block_buf);
+	if (retval)
+		goto err_out;
+
 	retval = ext2fs_open_inode_scan(fs, 0, &scan);
 	if (retval)
 		goto err_out;
 
 	while (1) {
-		retval = ext2fs_get_next_inode(scan, &ino, &inode);
+		retval = ext2fs_get_next_inode_full(scan, &ino,
+						    inode, inode_size);
 		if (retval)
 			goto err_out;
 
 		if (!ino)
 			break;
 
-		if (inode.i_links_count == 0)
+		if (inode->i_links_count == 0)
 			continue; /* inode not in use */
 
 		/* FIXME!!
@@ -2193,26 +2200,26 @@ static int inode_scan_and_fix(ext2_filsys fs, ext2fs_block_bitmap bmap)
 		 * Do we need to fix this ??
 		 */
 
-		if (ext2fs_file_acl_block(fs, &inode) &&
+		if (ext2fs_file_acl_block(fs, inode) &&
 		    ext2fs_test_block_bitmap2(bmap,
-					ext2fs_file_acl_block(fs, &inode))) {
+					ext2fs_file_acl_block(fs, inode))) {
 			blk = translate_block(ext2fs_file_acl_block(fs,
-								    &inode));
+								    inode));
 			if (!blk)
 				continue;
 
-			ext2fs_file_acl_block_set(fs, &inode, blk);
+			ext2fs_file_acl_block_set(fs, inode, blk);
 
 			/*
 			 * Write the inode to disk so that inode table
 			 * resizing can work
 			 */
-			retval = ext2fs_write_inode(fs, ino, &inode);
+			retval = ext2fs_write_inode(fs, ino, inode);
 			if (retval)
 				goto err_out;
 		}
 
-		if (!ext2fs_inode_has_valid_blocks2(fs, &inode))
+		if (!ext2fs_inode_has_valid_blocks2(fs, inode))
 			continue;
 
 		retval = ext2fs_block_iterate3(fs, ino, 0, block_buf,
@@ -2223,6 +2230,7 @@ static int inode_scan_and_fix(ext2_filsys fs, ext2fs_block_bitmap bmap)
 	}
 
 err_out:
+	ext2fs_free_mem(&inode);
 	ext2fs_free_mem(&block_buf);
 	ext2fs_close_inode_scan(scan);
 
diff --git a/resize/resize2fs.c b/resize/resize2fs.c
index f8df679..e516073 100644
--- a/resize/resize2fs.c
+++ b/resize/resize2fs.c
@@ -2118,7 +2118,8 @@ errout:
 		ext2fs_close_inode_scan(scan);
 	if (block_buf)
 		ext2fs_free_mem(&block_buf);
-	free(inode);
+	if (inode)
+		ext2fs_free_mem(&inode);
 	return retval;
 }
 
-- 
1.7.1

