From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 19/39] e2fsck: opportunistically set block_uninit after pass
 5
Date: Sat, 25 Oct 2014 13:58:25 -0700
Message-ID: <20141025205825.532.62162.stgit@birch.djwong.org>
References: <20141025205623.532.12119.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44069 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbaJYU67 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 25 Oct 2014 16:58:59 -0400
In-Reply-To: <20141025205623.532.12119.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

At the end of pass5, set block_uninit on any group that's empty.  For
meta_bg filesystems this might save a small amount of disk accesses at
load time.

Since it's not an error for the flag not to be set even when it could,
don't bother if the fs is mounted and we're not fixing anything else.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass5.c                        |   22 ++++++++++++++++++++++
 e2fsck/problem.c                      |    5 +++++
 e2fsck/problem.h                      |    3 +++
 tests/j_long_trans/expect             |    3 +++
 tests/j_long_trans_mcsum_32bit/expect |    6 ++++++
 tests/j_long_trans_mcsum_64bit/expect |    6 ++++++
 6 files changed, 45 insertions(+)


diff --git a/e2fsck/pass5.c b/e2fsck/pass5.c
index 1a225fb..92ab633 100644
--- a/e2fsck/pass5.c
+++ b/e2fsck/pass5.c
@@ -544,6 +544,28 @@ redo_counts:
 			} else
 				ext2fs_unmark_valid(fs);
 		}
+
+		/*
+		 * Opportunistically set block_uninit if none of the
+		 * blocks are in use.  However, it's not an error if
+		 * the flag could be set but isn't, so don't bother
+		 * the user if the FS is mounted and we haven't fixed
+		 * anything else, to minimize unnecessary reboots.
+		 */
+		if (((ctx->options & E2F_OPT_NO) ||
+		     !(ctx->mount_flags & EXT2_MF_MOUNTED) ||
+		     ext2fs_test_changed(fs)) &&
+		    ext2fs_has_group_desc_csum(fs) &&
+		    !ext2fs_bg_flags_test(fs, g, EXT2_BG_BLOCK_UNINIT) &&
+		    (g != fs->group_desc_count - 1) &&
+		    free_array[g] == fs->super->s_blocks_per_group) {
+			pctx.group = g;
+			if (fix_problem(ctx, PR_5_BLOCK_UNINIT_UNSET, &pctx)) {
+				ext2fs_bg_flags_set(fs, g,
+							EXT2_BG_BLOCK_UNINIT);
+				ext2fs_mark_super_dirty(fs);
+			}
+		}
 	}
 	free_blocks = EXT2FS_C2B(fs, free_blocks);
 	if (free_blocks != ext2fs_free_blocks_count(fs->super)) {
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 9c2b2e6..6a5f814 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1904,6 +1904,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Unused @i count wrong for @g #%g (%i, counted=%j).\n"),
 	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK },
 
+	/* block_uninit flag can be set for group */
+	{ PR_5_BLOCK_UNINIT_UNSET,
+	  N_("BLOCK_UNINIT flag can be set for @g #%g.\n"),
+	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK },
+
 	/* Post-Pass 5 errors */
 
 	/* Recreate journal if E2F_FLAG_JOURNAL_INODE flag is set */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 6a71fc8..345dd0a 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -1142,6 +1142,9 @@ struct problem_context {
 /* Unused inode count for group wrong */
 #define PR_5_UNUSED_INODES_COUNT_GROUP	0x05001C
 
+/* Unused inode count for group wrong */
+#define PR_5_BLOCK_UNINIT_UNSET		0x05001D
+
 /*
  * Post-Pass 5 errors
  */
diff --git a/tests/j_long_trans/expect b/tests/j_long_trans/expect
index 7638ef1..2cc1dab 100644
--- a/tests/j_long_trans/expect
+++ b/tests/j_long_trans/expect
@@ -81,6 +81,9 @@ Fix? yes
 Free blocks count wrong for group #14 (0, counted=8192).
 Fix? yes
 
+BLOCK_UNINIT flag can be set for group #14.
+Fix? yes
+
 Free blocks count wrong (247711, counted=255916).
 Fix? yes
 
diff --git a/tests/j_long_trans_mcsum_32bit/expect b/tests/j_long_trans_mcsum_32bit/expect
index 0d141c1..39b6e6d 100644
--- a/tests/j_long_trans_mcsum_32bit/expect
+++ b/tests/j_long_trans_mcsum_32bit/expect
@@ -117,9 +117,15 @@ Fix? yes
 Free blocks count wrong for group #17 (0, counted=8192).
 Fix? yes
 
+BLOCK_UNINIT flag can be set for group #17.
+Fix? yes
+
 Free blocks count wrong for group #18 (0, counted=8192).
 Fix? yes
 
+BLOCK_UNINIT flag can be set for group #18.
+Fix? yes
+
 Free blocks count wrong (497236, counted=513633).
 Fix? yes
 
diff --git a/tests/j_long_trans_mcsum_64bit/expect b/tests/j_long_trans_mcsum_64bit/expect
index 94e9925..edb7776 100644
--- a/tests/j_long_trans_mcsum_64bit/expect
+++ b/tests/j_long_trans_mcsum_64bit/expect
@@ -116,9 +116,15 @@ Fix? yes
 Free blocks count wrong for group #17 (0, counted=8192).
 Fix? yes
 
+BLOCK_UNINIT flag can be set for group #17.
+Fix? yes
+
 Free blocks count wrong for group #18 (0, counted=8192).
 Fix? yes
 
+BLOCK_UNINIT flag can be set for group #18.
+Fix? yes
+
 Free blocks count wrong (497218, counted=513615).
 Fix? yes
 

