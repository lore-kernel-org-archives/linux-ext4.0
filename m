From: Theodore Tso <tytso@MIT.EDU>
Subject: [PATCH 4 of 4] e2fsck: Check the all of journal blocks for validity
Date: Thu, 21 Jun 2007 13:00:11 -0400
Message-ID: <f0da9dbdd0751be62a0e.1182445211@candygram.thunk.org>
References: <patchbomb.1182445207@candygram.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: kalpak@clusterfs.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:55953 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063AbXFURBr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 21 Jun 2007 13:01:47 -0400
In-Reply-To: <patchbomb.1182445207@candygram.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

1 file changed, 42 insertions(+), 16 deletions(-)
e2fsck/journal.c |   58 +++++++++++++++++++++++++++++++++++++++---------------


# HG changeset patch
# User tytso@mit.edu
# Date 1182441546 14400
# Node ID f0da9dbdd0751be62a0e3b3afeec85ab27a13d20
# Parent  7a1859d26e58056688629ee2faf2f2ee619a1bf1
e2fsck: Check the all of journal blocks for validity

The original code only checked the direct blocks to make sure the
journal inode was sane.  Unfortunately, if some or all of the indirect
or doubly indirect blocks were corrupted, this would not be caught.
Thanks to Andreas Dilger and Kalpak Shah for noticing this problem.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff -r 7a1859d26e58 -r f0da9dbdd075 e2fsck/journal.c
--- a/e2fsck/journal.c	Thu Jun 21 11:59:06 2007 -0400
+++ b/e2fsck/journal.c	Thu Jun 21 11:59:06 2007 -0400
@@ -189,8 +189,37 @@ static void e2fsck_clear_recover(e2fsck_
 	ext2fs_mark_super_dirty(ctx->fs);
 }
 
+/*
+ * This is a helper function to check the validity of the journal.
+ */
+struct process_block_struct {
+	e2_blkcnt_t	last_block;
+};
+
+static int process_journal_block(ext2_filsys fs,
+				 blk_t	*block_nr,
+				 e2_blkcnt_t blockcnt,
+				 blk_t ref_block EXT2FS_ATTR((unused)),
+				 int ref_offset EXT2FS_ATTR((unused)),
+				 void *priv_data)
+{
+	struct process_block_struct *p;
+	blk_t	blk = *block_nr;
+
+	p = (struct process_block_struct *) priv_data;
+
+	if (blk < fs->super->s_first_data_block ||
+	    blk >= fs->super->s_blocks_count)
+		return BLOCK_ABORT;
+
+	if (blockcnt >= 0)
+		p->last_block = blockcnt;
+	return 0;
+}
+
 static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
 {
+	struct process_block_struct pb;
 	struct ext2_super_block *sb = ctx->fs->super;
 	struct ext2_super_block jsuper;
 	struct problem_context	pctx;
@@ -202,10 +231,8 @@ static errcode_t e2fsck_get_journal(e2fs
 	errcode_t		retval = 0;
 	io_manager		io_ptr = 0;
 	unsigned long		start = 0;
-	blk_t			blk;
 	int			ext_journal = 0;
 	int			tried_backup_jnl = 0;
-	int			i;
 
 	clear_problem_context(&pctx);
 
@@ -258,6 +285,9 @@ static errcode_t e2fsck_get_journal(e2fs
 			j_inode->i_ext2.i_size = sb->s_jnl_blocks[16];
 			j_inode->i_ext2.i_links_count = 1;
 			j_inode->i_ext2.i_mode = LINUX_S_IFREG | 0600;
+			e2fsck_use_inode_shortcuts(ctx, 1);
+			ctx->stashed_ino = j_inode->i_ino;
+			ctx->stashed_inode = &j_inode->i_ext2;
 			tried_backup_jnl++;
 		}
 		if (!j_inode->i_ext2.i_links_count ||
@@ -270,20 +300,14 @@ static errcode_t e2fsck_get_journal(e2fs
 			retval = EXT2_ET_JOURNAL_TOO_SMALL;
 			goto try_backup_journal;
 		}
-		for (i=0; i < EXT2_N_BLOCKS; i++) {
-			blk = j_inode->i_ext2.i_block[i];
-			if (!blk) {
-				if (i < EXT2_NDIR_BLOCKS) {
-					retval = EXT2_ET_JOURNAL_TOO_SMALL;
-					goto try_backup_journal;
-				}
-				continue;
-			}
-			if (blk < sb->s_first_data_block ||
-			    blk >= sb->s_blocks_count) {
-				retval = EXT2_ET_BAD_BLOCK_NUM;
-				goto try_backup_journal;
-			}
+		pb.last_block = -1;
+		retval = ext2fs_block_iterate2(ctx->fs, j_inode->i_ino,
+					       BLOCK_FLAG_HOLE, 0, 
+					       process_journal_block, &pb);
+		if ((pb.last_block+1) * ctx->fs->blocksize < 
+		    j_inode->i_ext2.i_size) {
+			retval = EXT2_ET_JOURNAL_TOO_SMALL;
+			goto try_backup_journal;
 		}
 		if (tried_backup_jnl && !(ctx->options & E2F_OPT_READONLY)) {
 			retval = ext2fs_write_inode(ctx->fs, sb->s_journal_inum,
@@ -397,9 +421,11 @@ static errcode_t e2fsck_get_journal(e2fs
 #endif
 
 	*ret_journal = journal;
+	e2fsck_use_inode_shortcuts(ctx, 0);
 	return 0;
 
 errout:
+	e2fsck_use_inode_shortcuts(ctx, 0);
 	if (dev_fs)
 		ext2fs_free_mem(&dev_fs);
 	if (j_inode)
