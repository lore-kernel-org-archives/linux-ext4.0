From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] e2fsck: Fix incorrect interior node logical start values
Date: Thu, 15 Nov 2012 13:47:36 -0600
Message-ID: <50A546D8.3020500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1768435Ab2KOTri (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Nov 2012 14:47:38 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qAFJlcWn001138
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 15 Nov 2012 14:47:38 -0500
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id qAFJlaxd005993
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 15 Nov 2012 14:47:37 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

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
---

p.s. this works for me, but I am emphatically not an e2fsck
guru.  Please do review.  :)

I'm not sure if this should trigger re-traversal of the
entire extent tree after the fixup?

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index a4bd956..7ff4021 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -1901,7 +1901,7 @@ static void scan_extent_node(e2fsck_t ctx, struct problem_context *pctx,
 		}
 
 		if (problem) {
-		report_problem:
+report_problem:
 			pctx->blk = extent.e_pblk;
 			pctx->blk2 = extent.e_lblk;
 			pctx->num = extent.e_len;
@@ -1927,7 +1927,10 @@ fix_problem_now:
 		}
 
 		if (!is_leaf) {
+			blk64_t lblk;
+
 			blk = extent.e_pblk;
+			lblk = extent.e_lblk;
 			pctx->errcode = ext2fs_extent_get(ehandle,
 						  EXT2_EXTENT_DOWN, &extent);
 			if (pctx->errcode) {
@@ -1940,6 +1943,18 @@ fix_problem_now:
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
index 78b05bb..9d4cd5f 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1000,6 +1000,14 @@ static struct e2fsck_problem problem_table[] = {
 	     "@i %i does not match.  "),
 	  PROMPT_FIX, 0 },
 
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
index 5caade4..a57b104 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -586,6 +586,8 @@ struct problem_context {
 /* ea block passes checks, but checksum invalid */
 #define PR_1_EA_BLOCK_ONLY_CSUM_INVALID        0x01006C
 
+/* Index start doesn't match start of next extent down */
+#define PR_1_EXTENT_INDEX_START_INVALID	0x01006D
 
 /*
  * Pass 1b errors
diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
index 9148d4e..ccd0936 100644
--- a/lib/ext2fs/ext2fs.h
+++ b/lib/ext2fs/ext2fs.h
@@ -1157,6 +1157,7 @@ extern errcode_t ext2fs_extent_get_info(ext2_extent_handle_t handle,
 					struct ext2_extent_info *info);
 extern errcode_t ext2fs_extent_goto(ext2_extent_handle_t handle,
 				    blk64_t blk);
+extern errcode_t ext2fs_extent_fix_parents(ext2_extent_handle_t handle);
 
 /* fileio.c */
 extern errcode_t ext2fs_file_open2(ext2_filsys fs, ext2_ino_t ino,
diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index da82a2a..8c3b7b9 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -722,7 +722,7 @@ errcode_t ext2fs_extent_goto(ext2_extent_handle_t handle,
  * Safe to call for any position in node; if not at the first entry,
  * will  simply return.
  */
-static errcode_t ext2fs_extent_fix_parents(ext2_extent_handle_t handle)
+errcode_t ext2fs_extent_fix_parents(ext2_extent_handle_t handle)
 {
 	int				retval = 0;
 	blk64_t				start;

