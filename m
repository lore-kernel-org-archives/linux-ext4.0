From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 18/24] e2fsck: collapse holes in extent-based directories
Date: Fri, 18 Jul 2014 15:54:30 -0700
Message-ID: <20140718225430.31374.42289.stgit@birch.djwong.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35888 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762157AbaGRWyg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Jul 2014 18:54:36 -0400
In-Reply-To: <20140718225200.31374.85411.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we notice a hole in the block map of an extent-based directory,
offer to collapse the hole by decreasing the logical block # of the
extent.  This saves us from pass 3's inefficient strategy, which fills
the holes by mapping in a lot of empty directory blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c            |   39 +++++++++++++++++++++++++++++++++++++++
 e2fsck/problem.c          |    5 +++++
 e2fsck/problem.h          |    3 +++
 tests/f_holedir2/expect.1 |    8 +++-----
 tests/f_holedir3/expect.1 |   13 +++++++++++++
 tests/f_holedir3/expect.2 |    7 +++++++
 tests/f_holedir3/image.gz |  Bin
 tests/f_holedir3/name     |    2 ++
 8 files changed, 72 insertions(+), 5 deletions(-)
 create mode 100644 tests/f_holedir3/expect.1
 create mode 100644 tests/f_holedir3/expect.2
 create mode 100644 tests/f_holedir3/image.gz
 create mode 100644 tests/f_holedir3/name


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 5d93feb..756e3bb 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2160,6 +2160,45 @@ fix_problem_now:
 			}
 			pb->fragmented = 1;
 		}
+		/*
+		 * If we notice a gap in the logical block mappings of an
+		 * extent-mapped directory, offer to close the hole by
+		 * moving the logical block down, otherwise we'll go mad in
+		 * pass 3 allocating empty directory blocks to fill the hole.
+		 */
+		if (try_repairs && is_dir &&
+		    pb->last_block + 1 < (e2_blkcnt_t)extent.e_lblk) {
+			blk64_t new_lblk;
+
+			new_lblk = pb->last_block + 1;
+			if (EXT2FS_CLUSTER_RATIO(ctx->fs) > 1)
+				new_lblk = ((new_lblk +
+					     EXT2FS_CLUSTER_RATIO(ctx->fs)) &
+					    EXT2FS_CLUSTER_MASK(ctx->fs)) |
+					   (extent.e_lblk &
+					    EXT2FS_CLUSTER_MASK(ctx->fs));
+			pctx->blk = extent.e_lblk;
+			pctx->blk2 = new_lblk;
+			if (fix_problem(ctx, PR_1_COLLAPSE_DBLOCK, pctx)) {
+				extent.e_lblk = new_lblk;
+				pb->inode_modified = 1;
+				pctx->errcode = ext2fs_extent_replace(ehandle,
+								0, &extent);
+				if (pctx->errcode) {
+					pctx->errcode = 0;
+					goto alloc_later;
+				}
+				pctx->errcode = ext2fs_extent_fix_parents(ehandle);
+				if (pctx->errcode)
+					goto failed_add_dir_block;
+				pctx->errcode = ext2fs_extent_goto(ehandle,
+								extent.e_lblk);
+				if (pctx->errcode)
+					goto failed_add_dir_block;
+				last_lblk = extent.e_lblk + extent.e_len - 1;
+			}
+		}
+alloc_later:
 		while (is_dir && (++pb->last_db_block <
 				  (e2_blkcnt_t) extent.e_lblk)) {
 			pctx->errcode = ext2fs_add_dir_block2(ctx->fs->dblist,
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 18d8025..a1986c6 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1038,6 +1038,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@i %i block %b conflicts with critical metadata, skipping block checks.\n"),
 	  PROMPT_NONE, 0 },
 
+	/* Directory inode block <block> should be at block <otherblock> */
+	{ PR_1_COLLAPSE_DBLOCK,
+	  N_("@d @i %i @b %b should be at @b %c.  "),
+	  PROMPT_FIX, 0 },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 9001ef4..c349286 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -603,6 +603,9 @@ struct problem_context {
 /* file metadata collides with critical metadata */
 #define PR_1_CRITICAL_METADATA_COLLISION	0x010071
 
+/* Directory inode has a missing block (hole) */
+#define PR_1_COLLAPSE_DBLOCK		0x010072
+
 /*
  * Pass 1b errors
  */
diff --git a/tests/f_holedir2/expect.1 b/tests/f_holedir2/expect.1
index 5124f61..455f4b0 100644
--- a/tests/f_holedir2/expect.1
+++ b/tests/f_holedir2/expect.1
@@ -1,21 +1,19 @@
 Pass 1: Checking inodes, blocks, and sizes
 Inode 12, i_size is 0, should be 5120.  Fix? yes
 
-Inode 13, i_size is 4096, should be 5120.  Fix? yes
+Directory inode 13 block 2 should be at block 1.  Fix? yes
 
 Pass 2: Checking directory structure
 Directory inode 12 has an unallocated block #3.  Allocate? yes
 
-Directory inode 13 has an unallocated block #1.  Allocate? yes
-
 Pass 3: Checking directory connectivity
 Pass 3A: Optimizing directories
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-Free blocks count wrong for group #0 (79, counted=77).
+Free blocks count wrong for group #0 (78, counted=77).
 Fix? yes
 
-Free blocks count wrong (79, counted=77).
+Free blocks count wrong (78, counted=77).
 Fix? yes
 
 
diff --git a/tests/f_holedir3/expect.1 b/tests/f_holedir3/expect.1
new file mode 100644
index 0000000..074ca6c
--- /dev/null
+++ b/tests/f_holedir3/expect.1
@@ -0,0 +1,13 @@
+Pass 1: Checking inodes, blocks, and sizes
+Directory inode 12 block 5 should be at block 2.  Fix? yes
+
+Inode 12, i_size is 6144, should be 3072.  Fix? yes
+
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+
+test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
+test_filesys: 17/128 files (5.9% non-contiguous), 1093/2048 blocks
+Exit status is 1
diff --git a/tests/f_holedir3/expect.2 b/tests/f_holedir3/expect.2
new file mode 100644
index 0000000..b675e6d
--- /dev/null
+++ b/tests/f_holedir3/expect.2
@@ -0,0 +1,7 @@
+Pass 1: Checking inodes, blocks, and sizes
+Pass 2: Checking directory structure
+Pass 3: Checking directory connectivity
+Pass 4: Checking reference counts
+Pass 5: Checking group summary information
+test_filesys: 17/128 files (5.9% non-contiguous), 1093/2048 blocks
+Exit status is 0
diff --git a/tests/f_holedir3/image.gz b/tests/f_holedir3/image.gz
new file mode 100644
index 0000000000000000000000000000000000000000..c5eeb37d2029fdf7d98d86548ebea0024f082b4e
GIT binary patch
literal 3700
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
FKLDc*@#_Ep

literal 0
HcmV?d00001

diff --git a/tests/f_holedir3/name b/tests/f_holedir3/name
new file mode 100644
index 0000000..a526787
--- /dev/null
+++ b/tests/f_holedir3/name
@@ -0,0 +1,2 @@
+real directories with holes and zero i_size
+

