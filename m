From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/2] e2fsck: fix handling of duplicate blocks with bigalloc file systems
Date: Mon, 28 Nov 2011 12:15:43 -0500
Message-ID: <1322500544-21022-1-git-send-email-tytso@mit.edu>
References: <20111128170225.GA4348@thunk.org>
Cc: hao.bigrat@gmail.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54245 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259Ab1K1RPq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Nov 2011 12:15:46 -0500
In-Reply-To: <20111128170225.GA4348@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We need to do an accounting of duplicate clusters on a per-cluster
instead of a per-block basis so we know when we've correctly accounted
for all of the multiply claimed blocks in a particular inode.

Thanks to Robin Dong for reporting this bug.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/pass1b.c |   55 ++++++++++++++++++++++++-------------------------------
 1 files changed, 24 insertions(+), 31 deletions(-)

diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index d5585dd..f7ce8e4 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -259,6 +259,7 @@ struct process_block_struct {
 	e2fsck_t	ctx;
 	ext2_ino_t	ino;
 	int		dup_blocks;
+	blk64_t		cur_cluster;
 	struct ext2_inode *inode;
 	struct problem_context *pctx;
 };
@@ -310,6 +311,7 @@ static void pass1b(e2fsck_t ctx, char *block_buf)
 		pb.ino = ino;
 		pb.dup_blocks = 0;
 		pb.inode = &inode;
+		pb.cur_cluster = ~0;
 
 		if (ext2fs_inode_has_valid_blocks2(fs, &inode) ||
 		    (ino == EXT2_BAD_INO))
@@ -339,21 +341,23 @@ static void pass1b(e2fsck_t ctx, char *block_buf)
 
 static int process_pass1b_block(ext2_filsys fs EXT2FS_ATTR((unused)),
 				blk64_t	*block_nr,
-				e2_blkcnt_t blockcnt EXT2FS_ATTR((unused)),
+				e2_blkcnt_t blockcnt,
 				blk64_t ref_blk EXT2FS_ATTR((unused)),
 				int ref_offset EXT2FS_ATTR((unused)),
 				void *priv_data)
 {
 	struct process_block_struct *p;
 	e2fsck_t ctx;
+	blk64_t	lc;
 
 	if (HOLE_BLKADDR(*block_nr))
 		return 0;
 	p = (struct process_block_struct *) priv_data;
 	ctx = p->ctx;
+	lc = EXT2FS_B2C(fs, blockcnt);
 
 	if (!ext2fs_test_block_bitmap2(ctx->block_dup_map, *block_nr))
-		return 0;
+		goto finish;
 
 	/* OK, this is a duplicate block */
 	if (p->ino != EXT2_BAD_INO) {
@@ -363,8 +367,11 @@ static int process_pass1b_block(ext2_filsys fs EXT2FS_ATTR((unused)),
 	p->dup_blocks++;
 	ext2fs_mark_inode_bitmap2(inode_dup_map, p->ino);
 
-	add_dupe(ctx, p->ino, EXT2FS_B2C(fs, *block_nr), p->inode);
+	if (lc != p->cur_cluster)
+		add_dupe(ctx, p->ino, EXT2FS_B2C(fs, *block_nr), p->inode);
 
+finish:
+	p->cur_cluster = lc;
 	return 0;
 }
 
@@ -571,7 +578,7 @@ static void decrement_badcount(e2fsck_t ctx, blk64_t block,
 
 static int delete_file_block(ext2_filsys fs,
 			     blk64_t	*block_nr,
-			     e2_blkcnt_t blockcnt EXT2FS_ATTR((unused)),
+			     e2_blkcnt_t blockcnt,
 			     blk64_t ref_block EXT2FS_ATTR((unused)),
 			     int ref_offset EXT2FS_ATTR((unused)),
 			     void *priv_data)
@@ -580,7 +587,7 @@ static int delete_file_block(ext2_filsys fs,
 	struct dup_cluster *p;
 	dnode_t	*n;
 	e2fsck_t ctx;
-	blk64_t c;
+	blk64_t c, lc;
 
 	pb = (struct process_block_struct *) priv_data;
 	ctx = pb->ctx;
@@ -589,11 +596,13 @@ static int delete_file_block(ext2_filsys fs,
 		return 0;
 
 	c = EXT2FS_B2C(fs, *block_nr);
+	lc = EXT2FS_B2C(fs, blockcnt);
 	if (ext2fs_test_block_bitmap2(ctx->block_dup_map, *block_nr)) {
 		n = dict_lookup(&clstr_dict, INT_TO_VOIDPTR(c));
 		if (n) {
 			p = (struct dup_cluster *) dnode_get(n);
-			decrement_badcount(ctx, *block_nr, p);
+			if (lc != pb->cur_cluster)
+				decrement_badcount(ctx, *block_nr, p);
 		} else
 			com_err("delete_file_block", 0,
 			    _("internal error: can't find dup_blk for %llu\n"),
@@ -603,6 +612,7 @@ static int delete_file_block(ext2_filsys fs,
 		ext2fs_block_alloc_stats2(fs, *block_nr, -1);
 		pb->dup_blocks++;
 	}
+	pb->cur_cluster = lc;
 
 	return 0;
 }
@@ -621,6 +631,7 @@ static void delete_file(e2fsck_t ctx, ext2_ino_t ino,
 	pb.dup_blocks = 0;
 	pb.ctx = ctx;
 	pctx.str = "delete_file";
+	pb.cur_cluster = ~0;
 
 	e2fsck_read_inode(ctx, ino, &inode, "delete_file");
 	if (ext2fs_inode_has_valid_blocks2(fs, &inode))
@@ -703,8 +714,12 @@ static int clone_file_block(ext2_filsys fs,
 	if (check_if_fs_cluster(ctx, EXT2FS_B2C(fs, *block_nr)))
 		is_meta = 1;
 
-	if (((blockcnt > 0) && c == cs->dup_cluster) ||
-	    ext2fs_test_block_bitmap2(ctx->block_dup_map, *block_nr)) {
+	if (c == cs->dup_cluster && cs->alloc_block) {
+		new_block = cs->alloc_block;
+		goto got_block;
+	}
+
+	if (ext2fs_test_block_bitmap2(ctx->block_dup_map, *block_nr)) {
 		n = dict_lookup(&clstr_dict,
 				INT_TO_VOIDPTR(EXT2FS_B2C(fs, *block_nr)));
 		if (!n) {
@@ -718,28 +733,6 @@ static int clone_file_block(ext2_filsys fs,
 		if (!is_meta)
 			decrement_badcount(ctx, *block_nr, p);
 
-		if (p->num_bad == 0 && !is_meta) {
-			/*
-			 * Normally num_bad never gets to zero; but in
-			 * the case of bigalloc file systems, we don't
-			 * how many blocks might be in use by a
-			 * particular inode.  So we may end up
-			 * relocating the cluster even though this
-			 * inode is the last user of the cluster.  In
-			 * that case, since we've already moved some
-			 * of the blocks of that cluster, we'll
-			 * complete the relocation and free the
-			 * original cluster here.
-			 */
-			ext2fs_unmark_block_bitmap2(ctx->block_found_map,
-						    *block_nr);
-			ext2fs_block_alloc_stats2(fs, *block_nr, -1);
-		}
