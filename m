From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/3] e2fsck: fix gcc -Wall nits
Date: Mon, 20 May 2013 09:58:59 -0400
Message-ID: <1369058339-1925-3-git-send-email-tytso@mit.edu>
References: <1369058339-1925-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49961 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756952Ab3ETN7G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 May 2013 09:59:06 -0400
In-Reply-To: <1369058339-1925-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Perhaps the most serious fix up is a type-punning warning which could
result in miscompilation with overly enthusiastic compilers.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/journal.c    |  2 +-
 e2fsck/message.c    |  3 +--
 e2fsck/pass1.c      | 15 ++++++++-------
 e2fsck/pass1b.c     | 35 ++++++++++++++++++-----------------
 e2fsck/pass2.c      |  2 +-
 e2fsck/recovery.c   | 16 ++++++++++------
 e2fsck/rehash.c     |  9 ++++-----
 e2fsck/sigcatcher.c |  3 ++-
 e2fsck/super.c      |  2 +-
 9 files changed, 46 insertions(+), 41 deletions(-)

diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index 69771da..6908aec 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -314,7 +314,7 @@ static errcode_t e2fsck_get_journal(e2fsck_t ctx, journal_t **ret_journal)
 					       BLOCK_FLAG_HOLE, 0,
 					       process_journal_block, &pb);
 		if ((pb.last_block + 1) * ctx->fs->blocksize <
-		    EXT2_I_SIZE(&j_inode->i_ext2)) {
+		    (int) EXT2_I_SIZE(&j_inode->i_ext2)) {
 			retval = EXT2_ET_JOURNAL_TOO_SMALL;
 			goto try_backup_journal;
 		}
diff --git a/e2fsck/message.c b/e2fsck/message.c
index b79b895..b99473d 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -361,8 +361,7 @@ static _INLINE_ void expand_dirent_expression(FILE *f, ext2_filsys fs, char ch,
 					      struct problem_context *ctx)
 {
 	struct ext2_dir_entry	*dirent;
-	unsigned int rec_len;
-	int	len;
+	unsigned int rec_len, len;
 
 	if (!ctx || !ctx->dirent)
 		goto no_dirent;
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 4095703..de00638 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1837,12 +1837,12 @@ report_problem:
 			}
 			/* The next extent should match this index's logical start */
 			if (extent.e_lblk != lblk) {
-				struct ext2_extent_info info;
+				struct ext2_extent_info e_info;
 
-				ext2fs_extent_get_info(ehandle, &info);
+				ext2fs_extent_get_info(ehandle, &e_info);
 				pctx->blk = lblk;
 				pctx->blk2 = extent.e_lblk;
-				pctx->num = info.curr_level - 1;
+				pctx->num = e_info.curr_level - 1;
 				problem = PR_1_EXTENT_INDEX_START_INVALID;
 				if (fix_problem(ctx, problem, pctx))
 					ext2fs_extent_fix_parents(ehandle);
@@ -1882,7 +1882,8 @@ report_problem:
 			}
 			pb->fragmented = 1;
 		}
-		while (is_dir && ++pb->last_db_block < extent.e_lblk) {
+		while (is_dir && (++pb->last_db_block <
+				  (e2_blkcnt_t) extent.e_lblk)) {
 			pctx->errcode = ext2fs_add_dir_block2(ctx->fs->dblist,
 							      pb->ino, 0,
 							      pb->last_db_block);
@@ -1904,7 +1905,7 @@ report_problem:
 			      (EXT2FS_B2C(ctx->fs, blk) ==
 			       EXT2FS_B2C(ctx->fs, pb->previous_block)) &&
 			      (blk & EXT2FS_CLUSTER_MASK(ctx->fs)) ==
-			      (blockcnt & EXT2FS_CLUSTER_MASK(ctx->fs)))) {
+			      ((unsigned) blockcnt & EXT2FS_CLUSTER_MASK(ctx->fs)))) {
 				mark_block_used(ctx, blk);
 				pb->num_blocks++;
 			}
@@ -2353,7 +2354,7 @@ static int process_block(ext2_filsys fs,
 		     (EXT2FS_B2C(ctx->fs, blk) ==
 		      EXT2FS_B2C(ctx->fs, p->previous_block)) &&
 		     (blk & EXT2FS_CLUSTER_MASK(ctx->fs)) ==
-		     (blockcnt & EXT2FS_CLUSTER_MASK(ctx->fs)))) {
+		     ((unsigned) blockcnt & EXT2FS_CLUSTER_MASK(ctx->fs)))) {
 		mark_block_used(ctx, blk);
 		p->num_blocks++;
 	}
@@ -2684,7 +2685,7 @@ static void mark_table_blocks(e2fsck_t ctx)
 	ext2_filsys fs = ctx->fs;
 	blk64_t	b;
 	dgrp_t	i;
-	int	j;
+	unsigned int	j;
 	struct problem_context pctx;
 
 	clear_problem_context(&pctx);
diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index 93fb630..cd6c883 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -624,7 +624,6 @@ static void delete_file(e2fsck_t ctx, ext2_ino_t ino,
 {
 	ext2_filsys fs = ctx->fs;
 	struct process_block_struct pb;
-	struct ext2_inode	inode;
 	struct problem_context	pctx;
 	unsigned int		count;
 
@@ -635,33 +634,35 @@ static void delete_file(e2fsck_t ctx, ext2_ino_t ino,
 	pctx.str = "delete_file";
 	pb.cur_cluster = ~0;
 
-	e2fsck_read_inode(ctx, ino, &inode, "delete_file");
-	if (ext2fs_inode_has_valid_blocks2(fs, &inode))
-		pctx.errcode = ext2fs_block_iterate3(fs, ino, BLOCK_FLAG_READ_ONLY,
-						     block_buf, delete_file_block, &pb);
+	if (ext2fs_inode_has_valid_blocks2(fs, &dp->inode))
+		pctx.errcode = ext2fs_block_iterate3(fs, ino,
+						     BLOCK_FLAG_READ_ONLY,
+						     block_buf,
+						     delete_file_block, &pb);
 	if (pctx.errcode)
 		fix_problem(ctx, PR_1B_BLOCK_ITERATE, &pctx);
 	if (ctx->inode_bad_map)
 		ext2fs_unmark_inode_bitmap2(ctx->inode_bad_map, ino);
-	ext2fs_inode_alloc_stats2(fs, ino, -1, LINUX_S_ISDIR(inode.i_mode));
-	quota_data_sub(ctx->qctx, &inode, ino, pb.dup_blocks * fs->blocksize);
-	quota_data_inodes(ctx->qctx, &inode, ino, -1);
+	ext2fs_inode_alloc_stats2(fs, ino, -1, LINUX_S_ISDIR(dp->inode.i_mode));
+	quota_data_sub(ctx->qctx, &dp->inode, ino,
+		       pb.dup_blocks * fs->blocksize);
+	quota_data_inodes(ctx->qctx, &dp->inode, ino, -1);
 
 	/* Inode may have changed by block_iterate, so reread it */
-	e2fsck_read_inode(ctx, ino, &inode, "delete_file");
-	e2fsck_clear_inode(ctx, ino, &inode, 0, "delete_file");
-	if (ext2fs_file_acl_block(fs, &inode) &&
+	e2fsck_read_inode(ctx, ino, &dp->inode, "delete_file");
+	e2fsck_clear_inode(ctx, ino, &dp->inode, 0, "delete_file");
+	if (ext2fs_file_acl_block(fs, &dp->inode) &&
 	    (fs->super->s_feature_compat & EXT2_FEATURE_COMPAT_EXT_ATTR)) {
 		count = 1;
 		pctx.errcode = ext2fs_adjust_ea_refcount2(fs,
-					ext2fs_file_acl_block(fs, &inode),
+					ext2fs_file_acl_block(fs, &dp->inode),
 						   block_buf, -1, &count);
 		if (pctx.errcode == EXT2_ET_BAD_EA_BLOCK_NUM) {
 			pctx.errcode = 0;
 			count = 1;
 		}
 		if (pctx.errcode) {
-			pctx.blk = ext2fs_file_acl_block(fs, &inode);
+			pctx.blk = ext2fs_file_acl_block(fs, &dp->inode);
 			fix_problem(ctx, PR_1B_ADJ_EA_REFCOUNT, &pctx);
 		}
 		/*
@@ -672,12 +673,12 @@ static void delete_file(e2fsck_t ctx, ext2_ino_t ino,
 		 */
 		if ((count == 0) ||
 		    ext2fs_test_block_bitmap2(ctx->block_dup_map,
-					ext2fs_file_acl_block(fs, &inode))) {
-			blk64_t blk = ext2fs_file_acl_block(fs, &inode);
+					ext2fs_file_acl_block(fs, &dp->inode))) {
+			blk64_t blk = ext2fs_file_acl_block(fs, &dp->inode);
 			delete_file_block(fs, &blk,
 					  BLOCK_COUNT_EXTATTR, 0, 0, &pb);
-			ext2fs_file_acl_block_set(fs, &inode, blk);
-			quota_data_sub(ctx->qctx, &inode, ino, fs->blocksize);
+			ext2fs_file_acl_block_set(fs, &dp->inode, blk);
+			quota_data_sub(ctx->qctx, &dp->inode, ino, fs->blocksize);
 		}
 	}
 }
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 882950d..749d264 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -668,7 +668,7 @@ static void salvage_directory(ext2_filsys fs,
 	 */
 	if ((left < 0) &&
 	    ((int) rec_len + left > 8) &&
-	    (name_len + 8 <= (int) rec_len + left) &&
+	    ((int) name_len + 8 <= (int) rec_len + left) &&
 	    dirent->inode <= fs->super->s_inodes_count &&
 	    strnlen(dirent->name, name_len) == name_len) {
 		(void) ext2fs_set_rec_len(fs, (int) rec_len + left, dirent);
diff --git a/e2fsck/recovery.c b/e2fsck/recovery.c
index bdfcd19..e4e5ae1 100644
--- a/e2fsck/recovery.c
+++ b/e2fsck/recovery.c
@@ -729,12 +729,16 @@ static int scan_revoke_records(journal_t *journal, struct buffer_head *bh,
 		unsigned long long blocknr;
 		int err;
 
-		if (record_len == 4)
-			blocknr = ext2fs_be32_to_cpu(*((__be32 *)(bh->b_data +
-								  offset)));
-		else
-			blocknr = ext2fs_be64_to_cpu(*((__be64 *)(bh->b_data +
-								  offset)));
+		if (record_len == 4) {
+			__be32 b;
+			memcpy(&b, bh->b_data + offset, sizeof(__be32));
+			blocknr = ext2fs_be32_to_cpu(b);
+		} else {
+			__be64 b;
+			memcpy(&b, bh->b_data + offset, sizeof(__be64));
+			blocknr = ext2fs_be64_to_cpu(b);
+		}
+
 		offset += record_len;
 		err = journal_set_revoke(journal, blocknr, sequence);
 		if (err)
diff --git a/e2fsck/rehash.c b/e2fsck/rehash.c
index 1f0a0b8..3d509ad 100644
--- a/e2fsck/rehash.c
+++ b/e2fsck/rehash.c
@@ -59,7 +59,7 @@ struct fill_dir_struct {
 	e2fsck_t ctx;
 	struct hash_entry *harray;
 	int max_array, num_array;
-	int dir_size;
+	unsigned int dir_size;
 	int compress;
 	ino_t parent;
 };
@@ -122,7 +122,7 @@ static int fill_dir_block(ext2_filsys fs,
 		if (((dir_offset + rec_len) > fs->blocksize) ||
 		    (rec_len < 8) ||
 		    ((rec_len % 4) != 0) ||
-		    (((dirent->name_len & 0xFF)+8) > rec_len)) {
+		    (((dirent->name_len & 0xFF)+8U) > rec_len)) {
 			fd->err = EXT2_ET_DIR_CORRUPTED;
 			return BLOCK_ABORT;
 		}
@@ -404,10 +404,9 @@ static errcode_t copy_dir_entries(e2fsck_t ctx,
 	char			*block_start;
 	struct hash_entry 	*ent;
 	struct ext2_dir_entry	*dirent;
-	unsigned int		rec_len, prev_rec_len;
-	int			i, left;
+	unsigned int		rec_len, prev_rec_len, left, slack, offset;
+	int			i;
 	ext2_dirhash_t		prev_hash;
-	int			offset, slack;
 
 	if (ctx->htree_slack_percentage == 255) {
 		profile_get_uint(ctx->profile, "options",
diff --git a/e2fsck/sigcatcher.c b/e2fsck/sigcatcher.c
index faafb57..13b9bcc 100644
--- a/e2fsck/sigcatcher.c
+++ b/e2fsck/sigcatcher.c
@@ -331,7 +331,8 @@ static const char *lookup_table_fallback(int num, struct str_table *table)
 	return buf;
 }
 
-static void die_signal_handler(int signum, siginfo_t *siginfo, void *context)
+static void die_signal_handler(int signum, siginfo_t *siginfo,
+			       void *context EXT2FS_ATTR((unused)))
 {
        void *stack_syms[32];
        int frames;
diff --git a/e2fsck/super.c b/e2fsck/super.c
index b9870f7..07f5fe5 100644
--- a/e2fsck/super.c
+++ b/e2fsck/super.c
@@ -465,11 +465,11 @@ void check_super_block(e2fsck_t ctx)
 	ext2_filsys fs = ctx->fs;
 	blk64_t	first_block, last_block;
 	struct ext2_super_block *sb = fs->super;
+	unsigned int	ipg_max;
 	problem_t	problem;
 	blk64_t	blocks_per_group = fs->super->s_blocks_per_group;
 	__u32	bpg_max, cpg_max;
 	int	inodes_per_block;
-	int	ipg_max;
 	int	inode_size;
 	int	accept_time_fudge;
 	int	broken_system_clock;
-- 
1.7.12.rc0.22.gcdd159b

