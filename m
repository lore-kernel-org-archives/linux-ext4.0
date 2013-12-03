From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 01/10] e2fsck: use problem_t to suppress some -Wconversion warnings
Date: Tue,  3 Dec 2013 00:10:09 -0500
Message-ID: <1386047418-32431-2-git-send-email-tytso@mit.edu>
References: <20131203002503.GA18601@thunk.org>
 <1386047418-32431-1-git-send-email-tytso@mit.edu>
Cc: Kit Westneat <kwestneat@ddn.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35875 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362Ab3LCFKb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Dec 2013 00:10:31 -0500
In-Reply-To: <1386047418-32431-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

All code which stores a problem code should use the problem_t type.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/pass1.c |  8 ++++----
 e2fsck/pass2.c | 12 ++++++------
 e2fsck/pass5.c |  8 +++++---
 3 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 311706e..3cf4aac 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -276,7 +276,7 @@ static void check_ea_in_inode(e2fsck_t ctx, struct problem_context *pctx)
 	struct ext2_ext_attr_entry *entry;
 	char *start;
 	unsigned int storage_size, remain;
-	int problem = 0;
+	problem_t problem = 0;
 
 	inode = (struct ext2_inode_large *) pctx->inode;
 	storage_size = EXT2_INODE_SIZE(ctx->fs->super) - EXT2_GOOD_OLD_INODE_SIZE -
@@ -950,7 +950,7 @@ void e2fsck_pass1(e2fsck_t ctx)
 							inode_size, "pass1");
 			}
 		} else if (ino < EXT2_FIRST_INODE(fs->super)) {
-			int	problem = 0;
+			problem_t problem = 0;
 
 			ext2fs_mark_inode_bitmap2(ctx->inode_used_map, ino);
 			if (ino == EXT2_BOOT_LOADER_INO) {
@@ -1769,7 +1769,7 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 	e2_blkcnt_t		blockcnt;
 	unsigned int		i;
 	int			is_dir, is_leaf;
-	errcode_t		problem;
+	problem_t		problem;
 	struct ext2_extent_info	info;
 
 	pctx->errcode = ext2fs_extent_get_info(ehandle, &info);
@@ -2255,7 +2255,7 @@ static int process_block(ext2_filsys fs,
 	struct problem_context *pctx;
 	blk64_t	blk = *block_nr;
 	int	ret_code = 0;
-	int	problem = 0;
+	problem_t	problem = 0;
 	e2fsck_t	ctx;
 
 	p = (struct process_block_struct *) priv_data;
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index f2ac2dd..6ef17d3 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -351,9 +351,9 @@ static int check_dot(e2fsck_t ctx,
 {
 	struct ext2_dir_entry *nextdir;
 	unsigned int	rec_len, new_len;
-	int	status = 0;
-	int	created = 0;
-	int	problem = 0;
+	int		status = 0;
+	int		created = 0;
+	problem_t	problem = 0;
 
 	if (!dirent->inode)
 		problem = PR_2_MISSING_DOT;
@@ -410,7 +410,7 @@ static int check_dotdot(e2fsck_t ctx,
 			struct ext2_dir_entry *dirent,
 			ext2_ino_t ino, struct problem_context *pctx)
 {
-	int		problem = 0;
+	problem_t	problem = 0;
 	unsigned int	rec_len;
 
 	if (!dirent->inode)
@@ -727,7 +727,7 @@ static int check_dir_block(ext2_filsys fs,
 	struct check_dir_struct	*cd;
 	char 			*buf;
 	e2fsck_t		ctx;
-	int			problem;
+	problem_t		problem;
 	struct ext2_dx_root_info *root;
 	struct ext2_dx_countlimit *limit;
 	static dict_t de_dict;
@@ -1268,7 +1268,7 @@ extern int e2fsck_process_bad_inode(e2fsck_t ctx, ext2_ino_t dir,
 	int			not_fixed = 0;
 	unsigned char		*frag, *fsize;
 	struct problem_context	pctx;
-	int	problem = 0;
+	problem_t		problem = 0;
 
 	e2fsck_read_inode(ctx, ino, &inode, "process_bad_inode");
 
diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index fce0f6e..feaa83e 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -151,7 +151,7 @@ static void e2fsck_discard_inodes(e2fsck_t ctx, dgrp_t group,
 
 #define NO_BLK ((blk64_t) -1)
 
-static void print_bitmap_problem(e2fsck_t ctx, int problem,
+static void print_bitmap_problem(e2fsck_t ctx, problem_t problem,
 			    struct problem_context *pctx)
 {
 	switch (problem) {
@@ -203,7 +203,8 @@ static void check_block_bitmaps(e2fsck_t ctx)
 	unsigned int	group_free = 0;
 	int	actual, bitmap;
 	struct problem_context	pctx;
-	int	problem, save_problem, fixit, had_problem;
+	problem_t	problem, save_problem;
+	int		fixit, had_problem;
 	errcode_t	retval;
 	int		csum_flag;
 	int		skip_group = 0;
@@ -542,7 +543,8 @@ static void check_inode_bitmaps(e2fsck_t ctx)
 	int		actual, bitmap;
 	errcode_t	retval;
 	struct problem_context	pctx;
-	int		problem, save_problem, fixit, had_problem;
+	problem_t	problem, save_problem;
+	int		fixit, had_problem;
 	int		csum_flag;
 	int		skip_group = 0;
 	int		redo_flag = 0;
-- 
1.8.5.rc3.362.gdf10213

