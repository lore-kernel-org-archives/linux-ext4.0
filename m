From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 21/49] e2fsck: print runs of duplicate blocks instead of all
 of them
Date: Mon, 10 Mar 2014 23:56:12 -0700
Message-ID: <20140311065612.30585.47051.stgit@birch.djwong.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21644 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbaCKG4Q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 11 Mar 2014 02:56:16 -0400
In-Reply-To: <20140311065356.30585.47192.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When pass1 finds blocks that are mapped to multiple files, it will
print every duplicated block.  If there are long sequences of
duplicate blocks (e.g. the e_pblk field is wrong in an extent), this
can cause a gigantic flood of output when a range could convey the
same information.  Therefore, teach pass1b to print ranges when
possible.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1b.c             |   23 +++++++++++++++++++++--
 e2fsck/problem.c            |    5 +++++
 e2fsck/problem.h            |    3 +++
 tests/f_bbfile/expect.1     |    4 ++--
 tests/f_dup/expect.1        |    4 ++--
 tests/f_dup2/expect.1       |    6 +++---
 tests/f_dup_ba/expect.1     |   12 ++++++------
 tests/f_dup_resize/expect.1 |    4 ++--
 tests/f_dupfsblks/expect.1  |    4 ++--
 tests/f_dupsuper/expect.1   |    2 +-
 10 files changed, 47 insertions(+), 20 deletions(-)


diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index 41a82cf..d7c5e55 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -262,6 +262,7 @@ struct process_block_struct {
 	ext2_ino_t	ino;
 	int		dup_blocks;
 	blk64_t		cur_cluster;
+	blk64_t		last_blk;
 	struct ext2_inode *inode;
 	struct problem_context *pctx;
 };
@@ -274,6 +275,7 @@ static void pass1b(e2fsck_t ctx, char *block_buf)
 	ext2_inode_scan	scan;
 	struct process_block_struct pb;
 	struct problem_context pctx;
+	problem_t op;
 
 	clear_problem_context(&pctx);
 
@@ -314,6 +316,8 @@ static void pass1b(e2fsck_t ctx, char *block_buf)
 		pb.dup_blocks = 0;
 		pb.inode = &inode;
 		pb.cur_cluster = ~0;
+		pb.last_blk = 0;
+		pb.pctx->blk = pb.pctx->blk2 = 0;
 
 		if (ext2fs_inode_has_valid_blocks2(fs, &inode) ||
 		    (ino == EXT2_BAD_INO))
@@ -329,6 +333,11 @@ static void pass1b(e2fsck_t ctx, char *block_buf)
 			ext2fs_file_acl_block_set(fs, &inode, blk);
 		}
 		if (pb.dup_blocks) {
+			if (ino != EXT2_BAD_INO) {
+				op = pctx.blk == pctx.blk2 ?
+					PR_1B_DUP_BLOCK : PR_1B_DUP_RANGE;
+				fix_problem(ctx, op, pb.pctx);
+			}
 			end_problem_latch(ctx, PR_LATCH_DBLOCK);
 			if (ino >= EXT2_FIRST_INODE(fs->super) ||
 			    ino == EXT2_ROOT_INO)
@@ -351,6 +360,7 @@ static int process_pass1b_block(ext2_filsys fs EXT2FS_ATTR((unused)),
 	struct process_block_struct *p;
 	e2fsck_t ctx;
 	blk64_t	lc;
+	problem_t op;
 
 	if (HOLE_BLKADDR(*block_nr))
 		return 0;
@@ -363,8 +373,17 @@ static int process_pass1b_block(ext2_filsys fs EXT2FS_ATTR((unused)),
 
 	/* OK, this is a duplicate block */
 	if (p->ino != EXT2_BAD_INO) {
-		p->pctx->blk = *block_nr;
-		fix_problem(ctx, PR_1B_DUP_BLOCK, p->pctx);
+		if (p->last_blk + 1 != *block_nr) {
+			if (p->last_blk) {
+				op = p->pctx->blk == p->pctx->blk2 ?
+						PR_1B_DUP_BLOCK :
+						PR_1B_DUP_RANGE;
+				fix_problem(ctx, op, p->pctx);
+			}
+			p->pctx->blk = *block_nr;
+		}
+		p->pctx->blk2 = *block_nr;
+		p->last_blk = *block_nr;
 	}
 	p->dup_blocks++;
 	ext2fs_mark_inode_bitmap2(inode_dup_map, p->ino);
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 1282858..7f0ad6c 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1073,6 +1073,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Error adjusting refcount for @a @b %b (@i %i): %m\n"),
 	  PROMPT_NONE, 0 },
 
+	/* Duplicate/bad block range in inode */
+	{ PR_1B_DUP_RANGE,
+	  " %b--%c",
+	  PROMPT_NONE, PR_LATCH_DBLOCK | PR_PREEN_NOHDR },
+
 	/* Pass 1C: Scan directories for inodes with multiply-claimed blocks. */
 	{ PR_1C_PASS_HEADER,
 	  N_("Pass 1C: Scanning directories for @is with @m @bs\n"),
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 61cbbef..bc9fa9c 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -628,6 +628,9 @@ struct problem_context {
 /* Error adjusting EA refcount */
 #define PR_1B_ADJ_EA_REFCOUNT	0x011007
 
+/* Duplicate/bad block range in inode */
+#define PR_1B_DUP_RANGE		0x011008
+
 /* Pass 1C: Scan directories for inodes with dup blocks. */
 #define PR_1C_PASS_HEADER	0x012000
 
diff --git a/tests/f_bbfile/expect.1 b/tests/f_bbfile/expect.1
index 1d639f6..ec1a36e 100644
--- a/tests/f_bbfile/expect.1
+++ b/tests/f_bbfile/expect.1
@@ -8,8 +8,8 @@ Relocating group 0's inode bitmap from 4 to 43...
 Running additional passes to resolve blocks claimed by more than one inode...
 Pass 1B: Rescanning for multiply-claimed blocks
 Multiply-claimed block(s) in inode 2: 21
-Multiply-claimed block(s) in inode 11: 9 10 11 12 13 14 15 16 17 18 19 20
-Multiply-claimed block(s) in inode 12: 25 26
+Multiply-claimed block(s) in inode 11: 9--20
+Multiply-claimed block(s) in inode 12: 25--26
 Pass 1C: Scanning directories for inodes with multiply-claimed blocks
 Pass 1D: Reconciling multiply-claimed blocks
 (There are 3 inodes containing multiply-claimed blocks.)
diff --git a/tests/f_dup/expect.1 b/tests/f_dup/expect.1
index e7128f3..075e62c 100644
--- a/tests/f_dup/expect.1
+++ b/tests/f_dup/expect.1
@@ -4,8 +4,8 @@ Pass 1: Checking inodes, blocks, and sizes
 
 Running additional passes to resolve blocks claimed by more than one inode...
 Pass 1B: Rescanning for multiply-claimed blocks
-Multiply-claimed block(s) in inode 12: 25 26
-Multiply-claimed block(s) in inode 13: 25 26
+Multiply-claimed block(s) in inode 12: 25--26
+Multiply-claimed block(s) in inode 13: 25--26
 Pass 1C: Scanning directories for inodes with multiply-claimed blocks
 Pass 1D: Reconciling multiply-claimed blocks
 (There are 2 inodes containing multiply-claimed blocks.)
diff --git a/tests/f_dup2/expect.1 b/tests/f_dup2/expect.1
index 0476005..69aa21b 100644
--- a/tests/f_dup2/expect.1
+++ b/tests/f_dup2/expect.1
@@ -4,9 +4,9 @@ Pass 1: Checking inodes, blocks, and sizes
 
 Running additional passes to resolve blocks claimed by more than one inode...
 Pass 1B: Rescanning for multiply-claimed blocks
-Multiply-claimed block(s) in inode 12: 25 26
-Multiply-claimed block(s) in inode 13: 25 26 57 58
-Multiply-claimed block(s) in inode 14: 57 58
+Multiply-claimed block(s) in inode 12: 25--26
+Multiply-claimed block(s) in inode 13: 25--26 57--58
+Multiply-claimed block(s) in inode 14: 57--58
 Pass 1C: Scanning directories for inodes with multiply-claimed blocks
 Pass 1D: Reconciling multiply-claimed blocks
 (There are 3 inodes containing multiply-claimed blocks.)
diff --git a/tests/f_dup_ba/expect.1 b/tests/f_dup_ba/expect.1
index f0ad457..f4581c4 100644
--- a/tests/f_dup_ba/expect.1
+++ b/tests/f_dup_ba/expect.1
@@ -6,12 +6,12 @@ Inode 16, i_blocks is 128, should be 896.  Fix? yes
 
 Running additional passes to resolve blocks claimed by more than one inode...
 Pass 1B: Rescanning for multiply-claimed blocks
-Multiply-claimed block(s) in inode 16: 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 176 177 178 179 180 181 182 183 184 185 186 187 188 189 190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239
-Multiply-claimed block(s) in inode 17: 160 161
-Multiply-claimed block(s) in inode 18: 176 177
-Multiply-claimed block(s) in inode 19: 192 193
-Multiply-claimed block(s) in inode 20: 208 209
-Multiply-claimed block(s) in inode 21: 224 225
+Multiply-claimed block(s) in inode 16: 160--239
+Multiply-claimed block(s) in inode 17: 160--161
+Multiply-claimed block(s) in inode 18: 176--177
+Multiply-claimed block(s) in inode 19: 192--193
+Multiply-claimed block(s) in inode 20: 208--209
+Multiply-claimed block(s) in inode 21: 224--225
 Pass 1C: Scanning directories for inodes with multiply-claimed blocks
 Pass 1D: Reconciling multiply-claimed blocks
 (There are 6 inodes containing multiply-claimed blocks.)
diff --git a/tests/f_dup_resize/expect.1 b/tests/f_dup_resize/expect.1
index dd8fe05..aaf7769 100644
--- a/tests/f_dup_resize/expect.1
+++ b/tests/f_dup_resize/expect.1
@@ -4,8 +4,8 @@ Pass 1: Checking inodes, blocks, and sizes
 
 Running additional passes to resolve blocks claimed by more than one inode...
 Pass 1B: Rescanning for multiply-claimed blocks
-Multiply-claimed block(s) in inode 7: 4 5 6 7
-Multiply-claimed block(s) in inode 12: 4 5 6 7
+Multiply-claimed block(s) in inode 7: 4--7
+Multiply-claimed block(s) in inode 12: 4--7
 Pass 1C: Scanning directories for inodes with multiply-claimed blocks
 Pass 1D: Reconciling multiply-claimed blocks
 (There are 1 inodes containing multiply-claimed blocks.)
diff --git a/tests/f_dupfsblks/expect.1 b/tests/f_dupfsblks/expect.1
index 3f70109..6751986 100644
--- a/tests/f_dupfsblks/expect.1
+++ b/tests/f_dupfsblks/expect.1
@@ -8,8 +8,8 @@ Inode 13, i_size is 0, should be 2048.  Fix? yes
 
 Running additional passes to resolve blocks claimed by more than one inode...
 Pass 1B: Rescanning for multiply-claimed blocks
-Multiply-claimed block(s) in inode 12: 3 4 6 1
-Multiply-claimed block(s) in inode 13: 2 3
+Multiply-claimed block(s) in inode 12: 3--4 6 1
+Multiply-claimed block(s) in inode 13: 2--3
 Multiply-claimed block(s) in inode 14: 2
 Pass 1C: Scanning directories for inodes with multiply-claimed blocks
 Pass 1D: Reconciling multiply-claimed blocks
diff --git a/tests/f_dupsuper/expect.1 b/tests/f_dupsuper/expect.1
index 830370a..2107e2d 100644
--- a/tests/f_dupsuper/expect.1
+++ b/tests/f_dupsuper/expect.1
@@ -4,7 +4,7 @@ Pass 1: Checking inodes, blocks, and sizes
 
 Running additional passes to resolve blocks claimed by more than one inode...
 Pass 1B: Rescanning for multiply-claimed blocks
-Multiply-claimed block(s) in inode 12: 2 3 1
+Multiply-claimed block(s) in inode 12: 2--3 1
 Pass 1C: Scanning directories for inodes with multiply-claimed blocks
 Pass 1D: Reconciling multiply-claimed blocks
 (There are 1 inodes containing multiply-claimed blocks.)

