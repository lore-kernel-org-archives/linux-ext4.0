From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 01/34] e2fsck: offer to clear overlapping extents
Date: Sat, 13 Sep 2014 15:11:19 -0700
Message-ID: <20140913221119.13646.11019.stgit@birch.djwong.org>
References: <20140913221112.13646.3873.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:32105 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbaIMWLZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 13 Sep 2014 18:11:25 -0400
In-Reply-To: <20140913221112.13646.3873.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If in the course of iterating extents we find that an otherwise
valid-seeming second extent maps the same logical blocks as a
previously examined first extent, offer to clear the duplicate
mapping.

The test for this is already in f_extents.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/e2fsck.h          |    2 +-
 e2fsck/pass1.c           |   15 +++++++++++++++
 e2fsck/problem.c         |   12 +++++++++++-
 e2fsck/problem.h         |    6 ++++++
 tests/f_extents/expect.1 |   14 ++++++++++----
 tests/f_extents/expect.2 |    2 +-
 6 files changed, 44 insertions(+), 7 deletions(-)


diff --git a/e2fsck/e2fsck.h b/e2fsck/e2fsck.h
index 8f16218..6ca3a6a 100644
--- a/e2fsck/e2fsck.h
+++ b/e2fsck/e2fsck.h
@@ -381,7 +381,7 @@ struct e2fsck_struct {
 };
 
 /* Used by the region allocation code */
-typedef __u32 region_addr_t;
+typedef __u64 region_addr_t;
 typedef struct region_struct *region_t;
 
 #ifndef HAVE_STRNLEN
diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 7175c77..aaeb70a 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -94,6 +94,7 @@ struct process_block_struct {
 	ext2fs_block_bitmap fs_meta_blocks;
 	e2fsck_t	ctx;
 	blk64_t		bad_ref;
+	region_t	region;
 };
 
 struct process_inode_block {
@@ -2395,6 +2396,10 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 			  (1 << (21 - ctx->fs->super->s_log_block_size))))
 			problem = PR_1_TOOBIG_DIR;
 
+		if (is_leaf && problem == 0 && extent.e_len > 0 &&
+		    region_allocate(pb->region, extent.e_lblk, extent.e_len))
+			problem = PR_1_EXTENT_COLLISION;
+
 		/*
 		 * Uninitialized blocks in a directory?  Clear the flag and
 		 * we'll interpret the blocks later.
@@ -2695,6 +2700,14 @@ static void check_blocks_extents(e2fsck_t ctx, struct problem_context *pctx,
 		ctx->extent_depth_count[info.max_depth]++;
 	}
 
+	pb->region = region_create(0, info.max_lblk);
+	if (!pb->region) {
+		ext2fs_extent_free(ehandle);
+		fix_problem(ctx, PR_1_EXTENT_ALLOC_REGION_ABORT, pctx);
+		ctx->flags |= E2F_FLAG_ABORT;
+		return;
+	}
+
 	eof_lblk = ((EXT2_I_SIZE(inode) + fs->blocksize - 1) >>
 		EXT2_BLOCK_SIZE_BITS(fs->super)) - 1;
 	scan_extent_node(ctx, pctx, pb, 0, 0, eof_lblk, ehandle, 1);
@@ -2706,6 +2719,8 @@ static void check_blocks_extents(e2fsck_t ctx, struct problem_context *pctx,
 				   "check_blocks_extents");
 		pctx->errcode = 0;
 	}
+	region_free(pb->region);
+	pb->region = NULL;
 	ext2fs_extent_free(ehandle);
 }
 
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 9818539..174f45a 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -784,7 +784,7 @@ static struct e2fsck_problem problem_table[] = {
 
 	/* Error allocating EA region allocation structure */
 	{ PR_1_EA_ALLOC_REGION_ABORT,
-	  N_("@A @a @b %b.  "),
+	  N_("@A @a region allocation structure.  "),
 	  PROMPT_NONE, PR_FATAL},
 
 	/* Error EA allocation collision */
@@ -1091,6 +1091,16 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Bad block list says the bad block list @i is bad.  "),
 	  PROMPT_CLEAR_INODE, 0 },
 
+	/* Error allocating extent region allocation structure */
+	{ PR_1_EXTENT_ALLOC_REGION_ABORT,
+	  N_("@A @x region allocation structure.  "),
+	  PROMPT_NONE, PR_FATAL},
+
+	/* Inode has a duplicate extent mapping */
+	{ PR_1_EXTENT_COLLISION,
+	  N_("@i %i has a duplicate @x mapping\n\t(logical @b %c, @n physical @b %b, len %N)\n"),
+	  PROMPT_CLEAR, 0 },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 5b32aeb..3c28166 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -635,6 +635,12 @@ struct problem_context {
 /* badblocks is in badblocks */
 #define PR_1_BADBLOCKS_IN_BADBLOCKS		0x01007B
 
+/* can't allocate extent region */
+#define PR_1_EXTENT_ALLOC_REGION_ABORT		0x01007C
+
+/* leaf extent collision */
+#define PR_1_EXTENT_COLLISION			0x01007D
+
 /*
  * Pass 1b errors
  */
diff --git a/tests/f_extents/expect.1 b/tests/f_extents/expect.1
index 953162c..aeebc7b 100644
--- a/tests/f_extents/expect.1
+++ b/tests/f_extents/expect.1
@@ -11,6 +11,12 @@ Inode 12, i_blocks is 34, should be 0.  Fix? yes
 Inode 13 missing EXTENT_FL, but is in extents format
 Fix? yes
 
+Inode 16 has a duplicate extent mapping
+	(logical block 3, invalid physical block 4613, len 2)
+Clear? yes
+
+Inode 16, i_blocks is 16, should be 12.  Fix? yes
+
 Inode 17 has an invalid extent
 	(logical block 0, invalid physical block 22011707397135, len 15)
 Clear? yes
@@ -31,13 +37,13 @@ Entry 'fbad-flag' in / (2) has deleted/unused inode 18.  Clear? yes
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-Block bitmap differences:  -1081 +4611 -(5121--5142)
+Block bitmap differences:  -1081 +4611 -(4613--4614) -(5121--5142)
 Fix? yes
 
-Free blocks count wrong for group #0 (7081, counted=7098).
+Free blocks count wrong for group #0 (7081, counted=7100).
 Fix? yes
 
-Free blocks count wrong (7081, counted=7098).
+Free blocks count wrong (7081, counted=7100).
 Fix? yes
 
 Inode bitmap differences:  -18
@@ -51,5 +57,5 @@ Fix? yes
 
 
 test_filesys: ***** FILE SYSTEM WAS MODIFIED *****
-test_filesys: 18/256 files (0.0% non-contiguous), 1094/8192 blocks
+test_filesys: 18/256 files (5.6% non-contiguous), 1092/8192 blocks
 Exit status is 1
diff --git a/tests/f_extents/expect.2 b/tests/f_extents/expect.2
index 6162cdf..5c9d6a6 100644
--- a/tests/f_extents/expect.2
+++ b/tests/f_extents/expect.2
@@ -3,5 +3,5 @@ Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_filesys: 18/256 files (0.0% non-contiguous), 1094/8192 blocks
+test_filesys: 18/256 files (5.6% non-contiguous), 1092/8192 blocks
 Exit status is 0

