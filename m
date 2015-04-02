From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 07/35] e2fsck: convert block-mapped files to extents on
 bigalloc fs
Date: Wed, 01 Apr 2015 19:34:46 -0700
Message-ID: <20150402023446.25243.17421.stgit@birch.djwong.org>
References: <20150402023359.25243.79782.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48229 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715AbbDBCeu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Apr 2015 22:34:50 -0400
In-Reply-To: <20150402023359.25243.79782.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As of v4.0, the Linux kernel won't add blocks to a block-mapped file
on a bigalloc filesystem.  Therefore, convert any such files or
directories we find, to prevent fs errors later on.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c            |   17 +++++++++++++++++
 e2fsck/problem.c          |    5 +++++
 e2fsck/problem.h          |    3 +++
 tests/f_badcluster/expect |   26 +++++++++++++-------------
 4 files changed, 38 insertions(+), 13 deletions(-)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 524314f..308a95a 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -3203,6 +3203,23 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		pctx->num = 0;
 	}
 
+	/*
+	 * The kernel gets mad if we ask it to allocate bigalloc clusters to
+	 * a block mapped file, so rebuild it as an extent file.  We can skip
+	 * symlinks because they're never rewritten.
+	 */
+	if (EXT2_HAS_RO_COMPAT_FEATURE(fs->super,
+			EXT4_FEATURE_RO_COMPAT_BIGALLOC) &&
+	    (LINUX_S_ISREG(inode->i_mode) || LINUX_S_ISDIR(inode->i_mode)) &&
+	    ext2fs_inode_data_blocks2(fs, inode) > 0 &&
+	    (ino == EXT2_ROOT_INO || ino >= EXT2_FIRST_INO(fs->super)) &&
+	    !(inode->i_flags & (EXT4_EXTENTS_FL | EXT4_INLINE_DATA_FL)) &&
+	    fix_problem(ctx, PR_1_NO_BIGALLOC_BLOCKMAP_FILES, pctx)) {
+		pctx->errcode = e2fsck_rebuild_extents_later(ctx, ino);
+		if (pctx->errcode)
+			goto out;
+	}
+
 	if (ctx->dirs_to_hash && pb.is_dir &&
 	    !(ctx->lost_and_found && ctx->lost_and_found == ino) &&
 	    !(inode->i_flags & EXT2_INDEX_FL) &&
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 7af0b76..df919da 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1111,6 +1111,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@i %i @x tree could be more shallow (%b; could be <= %c)\n"),
 	  PROMPT_FIX, PR_NO_OK | PR_PREEN_NO | PR_PREEN_OK },
 
+	/* Inode extent tree could be more shallow */
+	{ PR_1_NO_BIGALLOC_BLOCKMAP_FILES,
+	  N_("@i %i on bigalloc @f cannot be @b mapped.  "),
+	  PROMPT_FIX, 0 },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index ace8d2f..dc0c18a 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -648,6 +648,9 @@ struct problem_context {
 /* extent tree max depth too big */
 #define PR_1_EXTENT_BAD_MAX_DEPTH		0x01007F
 
+/* bigalloc fs cannot have blockmap files */
+#define PR_1_NO_BIGALLOC_BLOCKMAP_FILES		0x010080
+
 /*
  * Pass 1b errors
  */
diff --git a/tests/f_badcluster/expect b/tests/f_badcluster/expect
index b8ce19d..65a1641 100644
--- a/tests/f_badcluster/expect
+++ b/tests/f_badcluster/expect
@@ -19,6 +19,8 @@ Inode 18 logical block 3 (physical block 1201) violates cluster allocation rules
 Will fix in pass 1B.
 Inode 18, i_blocks is 32, should be 64.  Fix? yes
 
+Inode 15 on bigalloc filesystem cannot be block mapped.  Fix? yes
+
 
 Running additional passes to resolve blocks claimed by more than one inode...
 Pass 1B: Rescanning for multiply-claimed blocks
@@ -65,19 +67,20 @@ File /g (inode #18, mod time Tue Jun 17 08:00:50 2014)
   has 1 multiply-claimed block(s), shared with 0 file(s):
 Clone multiply-claimed blocks? yes
 
+Pass 1E: Optimizing extent trees
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-Free blocks count wrong for group #0 (50, counted=47).
+Free blocks count wrong for group #0 (51, counted=48).
 Fix? yes
 
-Free blocks count wrong (800, counted=752).
+Free blocks count wrong (816, counted=768).
 Fix? yes
 
 
 test_fs: ***** FILE SYSTEM WAS MODIFIED *****
-test_fs: 18/128 files (22.2% non-contiguous), 1296/2048 blocks
+test_fs: 18/128 files (22.2% non-contiguous), 1280/2048 blocks
 Pass 1: Checking inodes, blocks, and sizes
 Inode 12, i_blocks is 64, should be 32.  Fix? yes
 
@@ -94,21 +97,21 @@ Pass 5: Checking group summary information
 Block bitmap differences:  -(1168--1200)
 Fix? yes
 
-Free blocks count wrong for group #0 (47, counted=50).
+Free blocks count wrong for group #0 (48, counted=51).
 Fix? yes
 
-Free blocks count wrong (752, counted=800).
+Free blocks count wrong (768, counted=816).
 Fix? yes
 
 
 test_fs: ***** FILE SYSTEM WAS MODIFIED *****
-test_fs: 18/128 files (5.6% non-contiguous), 1248/2048 blocks
+test_fs: 18/128 files (5.6% non-contiguous), 1232/2048 blocks
 Pass 1: Checking inodes, blocks, and sizes
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 Pass 4: Checking reference counts
 Pass 5: Checking group summary information
-test_fs: 18/128 files (5.6% non-contiguous), 1248/2048 blocks
+test_fs: 18/128 files (5.6% non-contiguous), 1232/2048 blocks
 debugfs: stat /a
 Inode: 12   Type: regular    Mode:  0644   Flags: 0x80000
 Generation: 1117152157    Version: 0x00000001
@@ -146,19 +149,16 @@ mtime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
 EXTENTS:
 (0-1):1216-1217, (2):1218
 debugfs: stat /d
-Inode: 15   Type: regular    Mode:  0644   Flags: 0x0
+Inode: 15   Type: regular    Mode:  0644   Flags: 0x80000
 Generation: 1117152160    Version: 0x00000001
 User:     0   Group:     0   Size: 3072
 File ACL: 0    Directory ACL: 0
-Links: 1   Blockcount: 32
+Links: 1   Blockcount: 0
 Fragment:  Address: 0    Number: 0    Size: 0
 ctime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
 atime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
 mtime: 0x539ff5b2 -- Tue Jun 17 08:00:50 2014
-BLOCKS:
-(TIND):1650
-TOTAL: 1
