From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 14/21] e2fsck: clear extents and inline_data flags from
 fifo/socket/device inodes
Date: Mon, 04 Aug 2014 18:06:29 -0700
Message-ID: <20140805010629.2611.91726.stgit@birch.djwong.org>
References: <20140805010457.2611.89813.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40403 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbaHEBGe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2014 21:06:34 -0400
In-Reply-To: <20140805010457.2611.89813.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Since fifo, socket, and device inodes cannot have inline data or
extents, strip off these flags if we find them.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c           |   22 ++++++++++++++++++++++
 e2fsck/problem.c         |    6 ++++++
 e2fsck/problem.h         |    3 +++
 tests/f_extents/expect.1 |    3 +++
 4 files changed, 34 insertions(+)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 8bd08ee..d41b230 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -272,6 +272,24 @@ exit_inline:
 }
 
 /*
+ * If the extents or inlinedata flags are set on the inode, offer to clear 'em.
+ */
+#define BAD_SPECIAL_FLAGS (EXT4_EXTENTS_FL | EXT4_INLINE_DATA_FL)
+static void check_extents_inlinedata(e2fsck_t ctx,
+				     struct problem_context *pctx)
+{
+	if (!(pctx->inode->i_flags & BAD_SPECIAL_FLAGS))
+		return;
+
+	if (!fix_problem(ctx, PR_1_SPECIAL_EXTENTS_IDATA, pctx))
+		return;
+
+	pctx->inode->i_flags &= ~BAD_SPECIAL_FLAGS;
+	e2fsck_write_inode(ctx, pctx->ino, pctx->inode, "pass1");
+}
+#undef BAD_SPECIAL_FLAGS
+
+/*
  * If the immutable (or append-only) flag is set on the inode, offer
  * to clear it.
  */
@@ -1396,11 +1414,13 @@ void e2fsck_pass1(e2fsck_t ctx)
 			ctx->fs_regular_count++;
 		} else if (LINUX_S_ISCHR (inode->i_mode) &&
 			   e2fsck_pass1_check_device_inode(fs, inode)) {
+			check_extents_inlinedata(ctx, &pctx);
 			check_immutable(ctx, &pctx);
 			check_size(ctx, &pctx);
 			ctx->fs_chardev_count++;
 		} else if (LINUX_S_ISBLK (inode->i_mode) &&
 			   e2fsck_pass1_check_device_inode(fs, inode)) {
+			check_extents_inlinedata(ctx, &pctx);
 			check_immutable(ctx, &pctx);
 			check_size(ctx, &pctx);
 			ctx->fs_blockdev_count++;
@@ -1421,11 +1441,13 @@ void e2fsck_pass1(e2fsck_t ctx)
 		}
 		else if (LINUX_S_ISFIFO (inode->i_mode) &&
 			 e2fsck_pass1_check_device_inode(fs, inode)) {
+			check_extents_inlinedata(ctx, &pctx);
 			check_immutable(ctx, &pctx);
 			check_size(ctx, &pctx);
 			ctx->fs_fifo_count++;
 		} else if ((LINUX_S_ISSOCK (inode->i_mode)) &&
 			   e2fsck_pass1_check_device_inode(fs, inode)) {
+			check_extents_inlinedata(ctx, &pctx);
 			check_immutable(ctx, &pctx);
 			check_size(ctx, &pctx);
 			ctx->fs_sockets_count++;
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 9081277..26ee51b 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1050,6 +1050,12 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@i %i has INLINE_DATA_FL flag but @a not found.  "),
 	  PROMPT_TRUNCATE, 0 },
 
+	/* Extents/inlinedata flag set on a device or socket inode */
+	{ PR_1_SPECIAL_EXTENTS_IDATA,
+	  N_("Special (@v/socket/fifo) file (@i %i) has extents\n"
+	     "or inline-data flag set.  "),
+	  PROMPT_CLEAR, PR_PREEN_OK | PR_PREEN_NO | PR_NO_OK },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 1f0be2d..3c5e11a 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -612,6 +612,9 @@ struct problem_context {
 /* Inode has INLINE_DATA_FL flag but extended attribute not found */
 #define PR_1_INLINE_DATA_NO_ATTR	0x010075
 
+/* extents/inlinedata set on fifo/socket/device */
+#define PR_1_SPECIAL_EXTENTS_IDATA	0x010076
+
 /*
  * Pass 1b errors
  */
diff --git a/tests/f_extents/expect.1 b/tests/f_extents/expect.1
index 2abe32e..953162c 100644
--- a/tests/f_extents/expect.1
+++ b/tests/f_extents/expect.1
@@ -22,6 +22,9 @@ Clear inode? yes
 
 Inode 18, i_blocks is 2, should be 0.  Fix? yes
 
+Special (device/socket/fifo) file (inode 19) has extents
+or inline-data flag set.  Clear? yes
+
 Pass 2: Checking directory structure
 Entry 'fbad-flag' in / (2) has deleted/unused inode 18.  Clear? yes
 

