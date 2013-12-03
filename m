From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 09/10] e2fsck: use dgrp_t for block group numbers
Date: Tue,  3 Dec 2013 00:10:17 -0500
Message-ID: <1386047418-32431-10-git-send-email-tytso@mit.edu>
References: <20131203002503.GA18601@thunk.org>
 <1386047418-32431-1-git-send-email-tytso@mit.edu>
Cc: Kit Westneat <kwestneat@ddn.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35856 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab3LCFK1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Dec 2013 00:10:27 -0500
In-Reply-To: <1386047418-32431-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Make e2fsck consistently use dgrp_t for bloc group numbers to avoid
-Wconveresion noise.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/journal.c |  3 ++-
 e2fsck/message.c |  2 +-
 e2fsck/pass1.c   |  8 +++++---
 e2fsck/pass2.c   |  2 +-
 e2fsck/pass4.c   |  2 +-
 e2fsck/pass5.c   | 16 ++++++++--------
 e2fsck/problem.h |  2 +-
 7 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index bd2c9a1..eb891ca 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -945,7 +945,8 @@ void e2fsck_move_ext3_journal(e2fsck_t ctx)
 	ext2_ino_t		ino;
 	errcode_t		retval;
 	const char * const *	cpp;
-	int			group, mount_flags;
+	dgrp_t			group;
+	int			mount_flags;
 
 	clear_problem_context(&pctx);
 
diff --git a/e2fsck/message.c b/e2fsck/message.c
index 80af1af..7b2cb62 100644
--- a/e2fsck/message.c
+++ b/e2fsck/message.c
@@ -450,7 +450,7 @@ static _INLINE_ void expand_percent_expression(FILE *f, ext2_filsys fs,
 		fprintf(f, "%*u", width, ctx->dir);
 		break;
 	case 'g':
-		fprintf(f, "%*d", width, ctx->group);
+		fprintf(f, "%*u", width, ctx->group);
 		break;
 	case 'i':
 		fprintf(f, "%*u", width, ctx->ino);
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 3cf4aac..a853413 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2004,7 +2004,7 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 	struct process_block_struct pb;
 	ext2_ino_t	ino = pctx->ino;
 	struct ext2_inode *inode = pctx->inode;
-	int		bad_size = 0;
+	unsigned	bad_size = 0;
 	int		dirty_inode = 0;
 	int		extent_fs;
 	__u64		size;
@@ -2566,14 +2566,16 @@ static int process_bad_block(ext2_filsys fs,
 	return 0;
 }
 
-static void new_table_block(e2fsck_t ctx, blk64_t first_block, int group,
+static void new_table_block(e2fsck_t ctx, blk64_t first_block, dgrp_t group,
 			    const char *name, int num, blk64_t *new_block)
 {
 	ext2_filsys fs = ctx->fs;
 	dgrp_t		last_grp;
 	blk64_t		old_block = *new_block;
 	blk64_t		last_block;
-	int		i, is_flexbg, flexbg, flexbg_size;
+	dgrp_t		flexbg;
+	unsigned	flexbg_size;
+	int		i, is_flexbg;
 	char		*buf;
 	struct problem_context	pctx;
 
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 6ef17d3..65d8de4 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -844,7 +844,7 @@ out_htree:
 	dict_init(&de_dict, DICTCOUNT_T_MAX, dict_de_cmp);
 	prev = 0;
 	do {
-		int group;
+		dgrp_t group;
 		ext2_ino_t first_unused_inode;
 
 		problem = 0;
diff --git a/e2fsck/pass4.c b/e2fsck/pass4.c
index 2d55180..21d93f0 100644
--- a/e2fsck/pass4.c
+++ b/e2fsck/pass4.c
@@ -99,7 +99,7 @@ void e2fsck_pass4(e2fsck_t ctx)
 	struct problem_context	pctx;
 	__u16	link_count, link_counted;
 	char	*buf = 0;
-	int	group, maxgroup;
+	dgrp_t	group, maxgroup;
 
 	init_resource_track(&rtrack, ctx->fs->io);
 
diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index feaa83e..d4bdbd8 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -196,7 +196,7 @@ static void check_block_bitmaps(e2fsck_t ctx)
 	ext2_filsys fs = ctx->fs;
 	blk64_t	i;
 	unsigned int	*free_array;
-	int	group = 0;
+	dgrp_t		g, group = 0;
 	unsigned int	blocks = 0;
 	blk64_t	free_blocks = 0;
 	blk64_t first_free = ext2fs_blocks_count(fs->super);
@@ -498,15 +498,15 @@ redo_counts:
 	} else if (fixit == 0)
 		ext2fs_unmark_valid(fs);
 
-	for (i = 0; i < fs->group_desc_count; i++) {
-		if (free_array[i] != ext2fs_bg_free_blocks_count(fs, i)) {
-			pctx.group = i;
-			pctx.blk = ext2fs_bg_free_blocks_count(fs, i);
-			pctx.blk2 = free_array[i];
+	for (g = 0; g < fs->group_desc_count; g++) {
+		if (free_array[g] != ext2fs_bg_free_blocks_count(fs, g)) {
+			pctx.group = g;
+			pctx.blk = ext2fs_bg_free_blocks_count(fs, g);
+			pctx.blk2 = free_array[g];
 
 			if (fix_problem(ctx, PR_5_FREE_BLOCK_COUNT_GROUP,
 					&pctx)) {
-				ext2fs_bg_free_blocks_count_set(fs, i, free_array[i]);
+				ext2fs_bg_free_blocks_count_set(fs, g, free_array[g]);
 				ext2fs_mark_super_dirty(fs);
 			} else
 				ext2fs_unmark_valid(fs);
@@ -536,7 +536,7 @@ static void check_inode_bitmaps(e2fsck_t ctx)
 	unsigned int	free_inodes = 0;
 	int		group_free = 0;
 	int		dirs_count = 0;
-	int		group = 0;
+	dgrp_t		group = 0;
 	unsigned int	inodes = 0;
 	ext2_ino_t	*free_array;
 	ext2_ino_t	*dir_array;
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 4e7c9cd..6cb09cf 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -18,7 +18,7 @@ struct problem_context {
 	struct ext2_dir_entry *dirent;
 	blk64_t	blk, blk2;
 	e2_blkcnt_t	blkcount;
-	int		group;
+	dgrp_t		group;
 	__u32		csum1, csum2;
 	__u64	num;
 	const char *str;
-- 
1.8.5.rc3.362.gdf10213

