From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/3] e2fsck: fix incorrect interior node logical start values
Date: Thu, 20 Dec 2012 18:43:41 -0500
Message-ID: <1356047023-28367-1-git-send-email-tytso@mit.edu>
References: <20121220234229.GA22476@thunk.org>
Cc: forrestl@synology.com, Eric Sandeen <sandeen@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:39637 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814Ab2LTXnr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Dec 2012 18:43:47 -0500
In-Reply-To: <20121220234229.GA22476@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Eric Sandeen <sandeen@redhat.com>

An index node's logical start (ei_block) should
match the logical start of the first node (index
or leaf) below it.  If we find a node whose start
does not match its parent, fix all of its parents
accordingly.

If it finds such a problem, we'll see:

Pass 1: Checking inodes, blocks, and sizes
Interior extent node level 0 of inode 274258:
Logical start 3666 does not match logical start 4093 at next level.  Fix<y>?

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/pass1.c      | 17 ++++++++++++++++-
 e2fsck/problem.c    |  8 ++++++++
 e2fsck/problem.h    |  4 +++-
 lib/ext2fs/ext2fs.h |  1 +
 lib/ext2fs/extent.c |  2 +-
 5 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index cc00e0f..2acbb53 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1797,7 +1797,7 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 			problem = PR_1_EXTENT_ENDS_BEYOND;
 
 		if (problem) {
-		report_problem:
+report_problem:
 			pctx->blk = extent.e_pblk;
 			pctx->blk2 = extent.e_lblk;
 			pctx->num = extent.e_len;
@@ -1822,7 +1822,10 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 		}
 
 		if (!is_leaf) {
+			blk64_t lblk;
+
 			blk = extent.e_pblk;
+			lblk = extent.e_lblk;
 			pctx->errcode = ext2fs_extent_get(ehandle,
 						  EXT2_EXTENT_DOWN, &extent);
 			if (pctx->errcode) {
@@ -1832,6 +1835,18 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 					goto report_problem;
 				return;
 			}
+			/* The next extent should match this index's logical start */
+			if (extent.e_lblk != lblk) {
+				struct ext2_extent_info info;
+
+				ext2fs_extent_get_info(ehandle, &info);
+				pctx->blk = lblk;
+				pctx->blk2 = extent.e_lblk;
+				pctx->num = info.curr_level - 1;
+				problem = PR_1_EXTENT_INDEX_START_INVALID;
+				if (fix_problem(ctx, problem, pctx))
+					ext2fs_extent_fix_parents(ehandle);
+			}
 			scan_extent_node(ctx, pctx, pb, extent.e_lblk, ehandle);
 			if (pctx->errcode)
 				return;
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 977a4c8..ab67cff 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -946,6 +946,14 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@i %i has zero length extent\n\t(@n logical @b %c, physical @b %b)\n"),
 	  PROMPT_CLEAR, 0 },
 
+	/*
+	 * Interior extent node logical offset doesn't match first node below it
+	 */
+	{ PR_1_EXTENT_INDEX_START_INVALID,
+	  N_("Interior @x node level %N of @i %i:\n"
+	     "Logical start %b does not match logical start %c at next level.  "),
+	  PROMPT_FIX, 0 },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 1b5815b..aed524d 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -558,6 +558,9 @@ struct problem_context {
 /* Extent has zero length */
 #define PR_1_EXTENT_LENGTH_ZERO		0x010066
 
+/* Index start doesn't match start of next extent down */
+#define PR_1_EXTENT_INDEX_START_INVALID	0x01006D
+
 /*
  * Pass 1b errors
  */
@@ -586,7 +589,6 @@ struct problem_context {
 /* Error adjusting EA refcount */
 #define PR_1B_ADJ_EA_REFCOUNT	0x011007
 
-
 /* Pass 1C: Scan directories for inodes with dup blocks. */
 #define PR_1C_PASS_HEADER	0x012000
 
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 7a14f40..1b35ff7 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1082,6 +1082,7 @@ extern errcode_t ext2fs_extent_get_info(ext2_extent_handle_t handle,
 					struct ext2_extent_info *info);
 extern errcode_t ext2fs_extent_goto(ext2_extent_handle_t handle,
 				    blk64_t blk);
+extern errcode_t ext2fs_extent_fix_parents(ext2_extent_handle_t handle);
 
 /* fileio.c */
 extern errcode_t ext2fs_file_open2(ext2_filsys fs, ext2_ino_t ino,
diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index 8828764..95a0a86 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -706,7 +706,7 @@ errcode_t ext2fs_extent_goto(ext2_extent_handle_t handle,
  * Safe to call for any position in node; if not at the first entry,
  * will  simply return.
  */
-static errcode_t ext2fs_extent_fix_parents(ext2_extent_handle_t handle)
+errcode_t ext2fs_extent_fix_parents(ext2_extent_handle_t handle)
 {
 	int				retval = 0;
 	blk64_t				start;
-- 
1.7.12.rc0.22.gcdd159b

