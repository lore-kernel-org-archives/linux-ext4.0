From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 04/18] e2fsck: fix rule-violating lblk->pblk mappings on
 bigalloc filesystems
Date: Fri, 25 Jul 2014 17:34:04 -0700
Message-ID: <20140726003404.28334.18860.stgit@birch.djwong.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17161 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbaGZAeL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jul 2014 20:34:11 -0400
In-Reply-To: <20140726003339.28334.54447.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As far as I can tell, logical block mappings on a bigalloc filesystem are
supposed to follow a few constraints:

 * The logical cluster offset must match the physical cluster offset.
 * A logical cluster may not map to multiple physical clusters.

Since the multiply-claimed block recovery code can be used to fix these
problems, teach e2fsck to find these transgressions and fix them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c              |   52 +++++++++++
 e2fsck/pass1b.c             |   42 ++++++++-
 e2fsck/problem.c            |    5 +
 e2fsck/problem.h            |    3 +
 tests/f_badcluster/expect   |  198 +++++++++++++++++++++++++++++++++++++++++++
 tests/f_badcluster/image.gz |  Bin
 tests/f_badcluster/name     |    2 
 tests/f_badcluster/script   |   25 +++++
 8 files changed, 320 insertions(+), 7 deletions(-)
 create mode 100644 tests/f_badcluster/expect
 create mode 100644 tests/f_badcluster/image.gz
 create mode 100644 tests/f_badcluster/name
 create mode 100644 tests/f_badcluster/script


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index a6552e5..646ef8a 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1945,6 +1945,40 @@ void e2fsck_clear_inode(e2fsck_t ctx, ext2_ino_t ino,
 	e2fsck_write_inode(ctx, ino, inode, source);
 }
 
+/*
+ * Use the multiple-blocks reclamation code to fix alignment problems in
+ * a bigalloc filesystem.  We want a logical cluster to map to *only* one
+ * physical cluster, and we want the block offsets within that cluster to
+ * line up.
+ */
+static int has_unaligned_cluster_map(e2fsck_t ctx,
+				     blk64_t last_pblk, e2_blkcnt_t last_lblk,
+				     blk64_t pblk, blk64_t lblk)
+{
+	blk64_t cluster_mask;
+
+	if (!ctx->fs->cluster_ratio_bits)
+		return 0;
+	cluster_mask = EXT2FS_CLUSTER_MASK(ctx->fs);
+
+	/*
+	 * If the block in the logical cluster doesn't align with the block in
+	 * the physical cluster...
+	 */
+	if ((lblk & cluster_mask) != (pblk & cluster_mask))
+		return 1;
+
+	/*
+	 * If we cross a physical cluster boundary within a logical cluster...
+	 */
+	if (last_pblk && (lblk & cluster_mask) != 0 &&
+	    EXT2FS_B2C(ctx->fs, lblk) == EXT2FS_B2C(ctx->fs, last_lblk) &&
+	    EXT2FS_B2C(ctx->fs, pblk) != EXT2FS_B2C(ctx->fs, last_pblk))
+		return 1;
+
+	return 0;
+}
+
 static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 			     struct process_block_struct *pb,
 			     blk64_t start_block, blk64_t end_block,
@@ -2249,7 +2283,16 @@ alloc_later:
 				mark_block_used(ctx, blk);
 				pb->num_blocks++;
 			}
-
+			if (has_unaligned_cluster_map(ctx, pb->previous_block,
+						      pb->last_block, blk,
+						      blockcnt)) {
+				pctx->blk = blockcnt;
+				pctx->blk2 = blk;
+				fix_problem(ctx, PR_1_MISALIGNED_CLUSTER, pctx);
+				mark_block_used(ctx, blk);
+				mark_block_used(ctx, blk);
+			}
+			pb->last_block = blockcnt;
 			pb->previous_block = blk;
 
 			if (is_dir) {
@@ -2815,6 +2858,13 @@ static int process_block(ext2_filsys fs,
 		     ((unsigned) blockcnt & EXT2FS_CLUSTER_MASK(ctx->fs)))) {
 		mark_block_used(ctx, blk);
 		p->num_blocks++;
+	} else if (has_unaligned_cluster_map(ctx, p->previous_block,
+					     p->last_block, blk, blockcnt)) {
+		pctx->blk = blockcnt;
+		pctx->blk2 = blk;
+		fix_problem(ctx, PR_1_MISALIGNED_CLUSTER, pctx);
+		mark_block_used(ctx, blk);
+		mark_block_used(ctx, blk);
 	}
 	if (blockcnt >= 0)
 		p->last_block = blockcnt;
diff --git a/e2fsck/pass1b.c b/e2fsck/pass1b.c
index 8d42d10..c0bfa07 100644
--- a/e2fsck/pass1b.c
+++ b/e2fsck/pass1b.c
@@ -261,7 +261,7 @@ struct process_block_struct {
 	e2fsck_t	ctx;
 	ext2_ino_t	ino;
 	int		dup_blocks;
-	blk64_t		cur_cluster;
+	blk64_t		cur_cluster, phys_cluster;
 	blk64_t		last_blk;
 	struct ext2_inode *inode;
 	struct problem_context *pctx;
@@ -317,6 +317,7 @@ static void pass1b(e2fsck_t ctx, char *block_buf)
 		pb.dup_blocks = 0;
 		pb.inode = &inode;
 		pb.cur_cluster = ~0;
+		pb.phys_cluster = ~0;
 		pb.last_blk = 0;
 		pb.pctx->blk = pb.pctx->blk2 = 0;
 
@@ -360,7 +361,7 @@ static int process_pass1b_block(ext2_filsys fs EXT2FS_ATTR((unused)),
 {
 	struct process_block_struct *p;
 	e2fsck_t ctx;
-	blk64_t	lc;
+	blk64_t	lc, pc;
 	problem_t op;
 
 	if (HOLE_BLKADDR(*block_nr))
@@ -368,6 +369,7 @@ static int process_pass1b_block(ext2_filsys fs EXT2FS_ATTR((unused)),
 	p = (struct process_block_struct *) priv_data;
 	ctx = p->ctx;
 	lc = EXT2FS_B2C(fs, blockcnt);
+	pc = EXT2FS_B2C(fs, *block_nr);
 
 	if (!ext2fs_test_block_bitmap2(ctx->block_dup_map, *block_nr))
 		goto finish;
@@ -389,11 +391,19 @@ static int process_pass1b_block(ext2_filsys fs EXT2FS_ATTR((unused)),
 	p->dup_blocks++;
 	ext2fs_mark_inode_bitmap2(inode_dup_map, p->ino);
 
-	if (blockcnt < 0 || lc != p->cur_cluster)
+	/*
+	 * Qualifications for submitting a block for duplicate processing:
+	 * It's an extent/indirect block (and has a negative logical offset);
+	 * we've crossed a logical cluster boundary; or the physical cluster
+	 * suddenly changed, which indicates that blocks in a logical cluster
+	 * are mapped to multiple physical clusters.
+	 */
+	if (blockcnt < 0 || lc != p->cur_cluster || pc != p->phys_cluster)
 		add_dupe(ctx, p->ino, EXT2FS_B2C(fs, *block_nr), p->inode);
 
 finish:
 	p->cur_cluster = lc;
+	p->phys_cluster = pc;
 	return 0;
 }
 
@@ -563,7 +573,11 @@ static void pass1d(e2fsck_t ctx, char *block_buf)
 			pctx.dir = t->dir;
 			fix_problem(ctx, PR_1D_DUP_FILE_LIST, &pctx);
 		}
-		if (file_ok) {
+		/*
+		 * Even if the file shares blocks with itself, we still need to
+		 * clone the blocks.
+		 */
+		if (file_ok && (meta_data ? shared_len+1 : shared_len) != 0) {
 			fix_problem(ctx, PR_1D_DUP_BLOCKS_DEALT, &pctx);
 			continue;
 		}
@@ -706,9 +720,10 @@ struct clone_struct {
 	errcode_t	errcode;
 	blk64_t		dup_cluster;
 	blk64_t		alloc_block;
-	ext2_ino_t	dir;
+	ext2_ino_t	dir, ino;
 	char	*buf;
 	e2fsck_t ctx;
+	struct ext2_inode	*inode;
 };
 
 static int clone_file_block(ext2_filsys fs,
@@ -756,13 +771,26 @@ static int clone_file_block(ext2_filsys fs,
 			decrement_badcount(ctx, *block_nr, p);
 
 		cs->dup_cluster = c;
-
+		/*
+		 * Let's try an implied cluster allocation.  If we get the same
+		 * cluster back, then we need to find a new block; otherwise,
+		 * we're merely fixing the problem of one logical cluster being
+		 * mapped to multiple physical clusters.
+		 */
+		new_block = 0;
+		retval = ext2fs_map_cluster_block(fs, cs->ino, cs->inode,
+						  blockcnt, &new_block);
+		if (retval == 0 && new_block != 0 &&
+		    EXT2FS_B2C(ctx->fs, new_block) !=
+		    EXT2FS_B2C(ctx->fs, *block_nr))
+			goto cluster_alloc_ok;
 		retval = ext2fs_new_block2(fs, 0, ctx->block_found_map,
 					   &new_block);
 		if (retval) {
 			cs->errcode = retval;
 			return BLOCK_ABORT;
 		}
+cluster_alloc_ok:
 		cs->alloc_block = new_block;
 
 	got_block:
@@ -817,6 +845,8 @@ static errcode_t clone_file(e2fsck_t ctx, ext2_ino_t ino,
 	cs.dup_cluster = ~0;
 	cs.alloc_block = 0;
 	cs.ctx = ctx;
+	cs.ino = ino;
+	cs.inode = &dp->inode;
 	retval = ext2fs_get_mem(fs->blocksize, &cs.buf);
 	if (retval)
 		return retval;
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 60c02af..4da8ba8 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1048,6 +1048,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@d @i %i has @x marked uninitialized at @b %c.  "),
 	  PROMPT_FIX, PR_PREEN_OK },
 
+	/* Inode logical block (physical block ) is misaligned. */
+	{ PR_1_MISALIGNED_CLUSTER,
+	  N_("@i %i logical @b %b (physical @b %c) violates cluster allocation rules.\nWill fix in pass 1B.\n"),
+	  PROMPT_NONE, 0 },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 6cd3d50..80ef4a2 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -609,6 +609,9 @@ struct problem_context {
 /* uninit directory block */
 #define PR_1_UNINIT_DBLOCK		0x010073
 
+/* Inode logical block is misaligned */
+#define PR_1_MISALIGNED_CLUSTER		0x010074
+
 /*
  * Pass 1b errors
  */
diff --git a/tests/f_badcluster/expect b/tests/f_badcluster/expect
new file mode 100644
index 0000000..eb3bcf0
--- /dev/null
+++ b/tests/f_badcluster/expect
@@ -0,0 +1,198 @@
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12 logical block 2 (physical block 1154) violates cluster allocation rules.
+Will fix in pass 1B.
+Inode 12, i_blocks is 32, should be 64.  Fix? yes
+
+Inode 16 logical block 5 (physical block 1173) violates cluster allocation rules.
+Will fix in pass 1B.
+Inode 16, i_size is 3072, should be 6144.  Fix? yes
+
+Inode 16, i_blocks is 32, should be 64.  Fix? yes
+
+Inode 17 logical block 0 (physical block 1186) violates cluster allocation rules.
+Will fix in pass 1B.
+Inode 17 logical block 2 (physical block 1184) violates cluster allocation rules.
+Will fix in pass 1B.
+Inode 17, i_blocks is 32, should be 64.  Fix? yes
+
+Inode 18 logical block 3 (physical block 1201) violates cluster allocation rules.
+Will fix in pass 1B.
+Inode 18, i_blocks is 32, should be 64.  Fix? yes
+
+
+Running additional passes to resolve blocks claimed by more than one inode...
+Pass 1B: Rescanning for multiply-claimed blocks
+Multiply-claimed block(s) in inode 12: 1154
+Multiply-claimed block(s) in inode 13: 1152--1154
+Multiply-claimed block(s) in inode 14: 1648--1650
+Multiply-claimed block(s) in inode 15: 1650
+Multiply-claimed block(s) in inode 16: 1173
+Multiply-claimed block(s) in inode 17: 1186 1185 1184
+Multiply-claimed block(s) in inode 18: 1201
+Pass 1C: Scanning directories for inodes with multiply-claimed blocks
+Pass 1D: Reconciling multiply-claimed blocks
+(There are 7 inodes containing multiply-claimed blocks.)
+
+File /a (inode #12, mod time Tue Jun 17 08:00:50 2014) 
+  has 1 multiply-claimed block(s), shared with 1 file(s):
+	/b (inode #13, mod time Tue Jun 17 08:00:50 2014)
+Clone multiply-claimed blocks? yes
+
+File /b (inode #13, mod time Tue Jun 17 08:00:50 2014) 
+  has 1 multiply-claimed block(s), shared with 1 file(s):
+	/a (inode #12, mod time Tue Jun 17 08:00:50 2014)
+Multiply-claimed blocks already reassigned or cloned.
+
+File /c (inode #14, mod time Tue Jun 17 08:00:50 2014) 
+  has 1 multiply-claimed block(s), shared with 1 file(s):
+	/d (inode #15, mod time Tue Jun 17 08:00:50 2014)
+Clone multiply-claimed blocks? yes
+
+File /d (inode #15, mod time Tue Jun 17 08:00:50 2014) 
+  has 1 multiply-claimed block(s), shared with 1 file(s):
+	/c (inode #14, mod time Tue Jun 17 08:00:50 2014)
+Multiply-claimed blocks already reassigned or cloned.
+
+File /e (inode #16, mod time Tue Jun 17 08:00:50 2014) 
+  has 1 multiply-claimed block(s), shared with 0 file(s):
+Clone multiply-claimed blocks? yes
+
+File /f (inode #17, mod time Tue Jun 17 08:00:50 2014) 
+  has 1 multiply-claimed block(s), shared with 0 file(s):
+Clone multiply-claimed blocks? yes
+
+File /g (inode #18, mod time Tue Jun 17 08:00:50 2014) 
+  has 1 multiply-claimed block(s), shared with 0 file(s):
+Clone multiply-claimed blocks? yes
+
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Free blocks count wrong for group #0 (50, counted=47).
+Fix? yes
+
+Free blocks count wrong (800, counted=752).
+Fix? yes
+
+
+test_fs: ***** FILE SYSTEM WAS MODIFIED *****
+test_fs: 18/128 files (22.2% non-contiguous), 1296/2048 blocks
+Pass 1: Checking inodes, blocks, and sizes
+Inode 12, i_blocks is 64, should be 32.  Fix? yes
+
+Inode 16, i_blocks is 64, should be 32.  Fix? yes
+
+Inode 17, i_blocks is 64, should be 32.  Fix? yes
+
+Inode 18, i_blocks is 64, should be 32.  Fix? yes
+
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+Block bitmap differences:  -(1168--1200)
+Fix? yes
+
+Free blocks count wrong for group #0 (47, counted=50).
+Fix? yes
+
+Free blocks count wrong (752, counted=800).
+Fix? yes
+
+
+test_fs: ***** FILE SYSTEM WAS MODIFIED *****
+test_fs: 18/128 files (5.6% non-contiguous), 1248/2048 blocks
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_fs: 18/128 files (5.6% non-contiguous), 1248/2048 blocks
+debugfs:  stat /a
+Inode: 12   Type: regular    Mode:  0644   Flags: 0x80000
+Generation: 1117152157    Version: 0x00000001
+User:     0   Group:     0   Size: 3072
+File ACL: 0    Directory ACL: 0
+Links: 1   Blockcount: 32
+Fragment:  Address: 0    Number: 0    Size: 0
+ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
+atime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
+mtime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
+EXTENTS:
+(0-1):1136-1137, (2):1138
+debugfs:  stat /b
+Inode: 13   Type: regular    Mode:  0644   Flags: 0x80000
+Generation: 1117152158    Version: 0x00000001
+User:     0   Group:     0   Size: 3072
+File ACL: 0    Directory ACL: 0
+Links: 1   Blockcount: 32
+Fragment:  Address: 0    Number: 0    Size: 0
+ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
+atime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
+mtime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
+EXTENTS:
+(0-2):1152-1154
+debugfs:  stat /c
+Inode: 14   Type: regular    Mode:  0644   Flags: 0x80000
+Generation: 1117152159    Version: 0x00000001
+User:     0   Group:     0   Size: 3072
+File ACL: 0    Directory ACL: 0
+Links: 1   Blockcount: 32
+Fragment:  Address: 0    Number: 0    Size: 0
+ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
+atime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
+mtime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
+EXTENTS:
+(0-1):1216-1217, (2):1218
+debugfs:  stat /d
+Inode: 15   Type: regular    Mode:  0644   Flags: 0x0
+Generation: 1117152160    Version: 0x00000001
+User:     0   Group:     0   Size: 3072
+File ACL: 0    Directory ACL: 0
+Links: 1   Blockcount: 32
+Fragment:  Address: 0    Number: 0    Size: 0
+ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
+atime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
+mtime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
+BLOCKS:
+(TIND):1650
+TOTAL: 1
+
+debugfs:  stat /e
+Inode: 16   Type: regular    Mode:  0644   Flags: 0x80000
+Generation: 1117152161    Version: 0x00000001
+User:     0   Group:     0   Size: 6144
+File ACL: 0    Directory ACL: 0
+Links: 1   Blockcount: 32
+Fragment:  Address: 0    Number: 0    Size: 0
+ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
+atime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
+mtime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
+EXTENTS:
+(0-2):1664-1666, (5):1669
+debugfs:  stat /f
+Inode: 17   Type: regular    Mode:  0644   Flags: 0x80000
+Generation: 1117152162    Version: 0x00000001
+User:     0   Group:     0   Size: 3072
+File ACL: 0    Directory ACL: 0
+Links: 1   Blockcount: 32
+Fragment:  Address: 0    Number: 0    Size: 0
+ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
+atime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
+mtime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
+EXTENTS:
+(0):1232, (1):1233, (2):1234
+debugfs:  stat /g
+Inode: 18   Type: regular    Mode:  0644   Flags: 0x80000
+Generation: 1117152163    Version: 0x00000001
+User:     0   Group:     0   Size: 3072
+File ACL: 0    Directory ACL: 0
+Links: 1   Blockcount: 32
+Fragment:  Address: 0    Number: 0    Size: 0
+ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
+atime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
+mtime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
+EXTENTS:
+(0-2):1680-1682, (3):1683
+debugfs:  
\ No newline at end of file
diff --git a/tests/f_badcluster/image.gz b/tests/f_badcluster/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..e02ee1866868361e6e82bfbe29982365b2e3aa55
GIT binary patch
literal 3131
zcmeH`eNfVO9LF)YGArHAl6flRwbV_eOvC0A4VPY_dFBj}kaU;3`An&ypmc4h9VhIf
zG;+!qGBs1@gsG+2gU*y0Y50JcUV;y)D1xAjhu^x}b(h}$+@E~@_&j|7`F=jH&*u%L
z*?=Z=?ARUF%2(nv2aF3y#X5Z+g%u<)LiS(y@}tx>cPz)&G0Qe&A*OK@Raq{8^q_F-
zbB{#>iF|Dz=b)|E490O%W`;sOzn*Dtd$W+q>f!h2aWn3xA)rK!kjYY12Cz2VS^ia?
zJKzn{oZ*j8$vKNhzKW^O#IziXdU8FzD*|<eD@NYnUd~^Sa_N2j2lXf(hj_l!WF(Xz
z^@k=+XFN;5_JiKlfolqV3uj7S$m~OhGOU?ARvy2Z3xiBLmvwf9s?~oQZlIxv;1!zu
zbzM+@IZwGj2G3`h`BuLoys*(veF#j!uuCmX7XnXQP{(9>l8|3~Qb0L3W_@O8Bou2S
z#LwPyeSHU4SGh|_3O@<jVw-ulMAQSCYtw-BmUoczrKImN`3b_5sj-MBHFstycPr9Q
zyDc_LT!%)FD#_s5hLIl5UXnDPD@{u}7ViyT0SH2%u*0u$j#2PSivDR6be36cLR7JI
z>P9Io$LN#}Hy;+P)k<}%cC(5=1%>EC`mJ`K9DhLsMXNnTY7b5%xHS-GMy*X>nRI$s
zn4{EJv>{B*zOB8Z6U4SCeQg`RoRS%(Z&ez2MRsCB5pII*p9!eO5eo6@SX?5Fv~;uk
zMYgdE|JNdavOxx(M+a9JGE#v?A50YtD7>vh#2-d%9rOK)Okcl?dlmE3Udha-PBwlx
zw<*_LcZb-D6dfZP2dfe{<%37d#Ki?z2z!rK7Yx~>r3c$JM1<s%-6TO8VzA^PvIA2p
zr@^=X@pVnNrWr5+)70e+;E{U_fA>jX*E;3D-245!%MWU2YQwru2>?*S{bGVA^+1FB
z8-;3y!|ILos18QJB|+U;YN8OP0+aw@s+)wy9IvNaJ!a&tRX-rM!{|#hNL**Yt+QAN
zJh9_Kysv$_Bh~mb8`5JR&ddJMoa1}#T#i6&vzy$;rqF-rzqsGWd$8<0N-IB0;jPp~
z22J;hV9a6Hf&ScQfGR<EF*<B2wZ4daZ;nx^i0)Iqacq`d{&rb6l&4^4_yVusv+Swi
z1ak*`wtFPmFfS9Bu<1ZooEm+61;F<$9g=?5M=jQYQ<c*bH6}vQ?^dJ9a3$sY-ekEM
zucY8tA{+GF>N<>h`Nd1)Ci8h@bC`iSpmOlA7MwV}^GPJS^lC&^e~*O6GRb2rQ1h+d
zB*q7XIxlAAlVK8>hUhH`Qg4!ZahPpe$wQ2fuN{FV4;STob=J3cl1ux;sphvTO-et5
za=9(yX3Y%vwwp~zE$z|267_p4(cyK{(@S=d<tY<GLiz(@c9y?d_xCfA^QuQ;p;6U-
zgkHj3QM@#;1&o%EeQo}R%l?CeiQ{1XPRZF1iUXvrAI<|wei)IyMDNH*+K}a%dA%B_
zeZmRAs#0yds@p(lDKZT^e7?L|o5?bXMz^W(-3eHtg@A>Cg@A>Cg@A>?|4(4iWQ{Gq
K#Rh>6g8l&!3vo*T

literal 0
HcmV?d00001

diff --git a/tests/f_badcluster/name b/tests/f_badcluster/name
new file mode 100644
index 0000000..266f81c
--- /dev/null
+++ b/tests/f_badcluster/name
@@ -0,0 +1,2 @@
+test alignment problems with bigalloc clusters
+
diff --git a/tests/f_badcluster/script b/tests/f_badcluster/script
new file mode 100644
index 0000000..ba6b248
--- /dev/null
+++ b/tests/f_badcluster/script
@@ -0,0 +1,25 @@
+if test -x $DEBUGFS_EXE; then
+	IMAGE=$test_dir/../f_badcluster/image.gz
+	OUT=$test_name.log
+	EXP=$test_dir/expect
+	gzip -d < $IMAGE > $TMPFILE
+	../misc/tune2fs -L test_fs $TMPFILE
+	../e2fsck/e2fsck -fy $TMPFILE > $OUT
+	../e2fsck/e2fsck -fy $TMPFILE >> $OUT
+	../e2fsck/e2fsck -fy $TMPFILE >> $OUT
+	for i in a b c d e f g; do echo "stat /$i"; done | $DEBUGFS_EXE $TMPFILE >> $OUT
+
+	cmp -s $OUT $EXP
+	status=$?
+
+	if [ "$status" = 0 ]; then
+		echo "$test_name: $test_description: ok"
+		touch $test_name.ok
+	else
+		echo "$test_name: $test_description: failed"
+		diff $DIFF_OPTS $EXP $OUT > $test_name.failed
+		rm -f $test_name.tmp
+	fi
+else
+	echo "$test_name: skipped"
+fi

