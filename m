From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 07/32] e2fsck: fix inline_data flag errors in pass1
Date: Sat, 01 Mar 2014 23:17:23 -0800
Message-ID: <20140302071723.28217.12676.stgit@birch.djwong.org>
References: <20140302071639.28217.57302.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44205 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaCBHR2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Mar 2014 02:17:28 -0500
In-Reply-To: <20140302071639.28217.57302.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In pass1, check for a file with inline_data set on a filesystem that
doesn't support it.

If we decide to clear the inline_data flag on the inode and the inode
doesn't use extents, write the inode out to disk so that
block_iterate3 doesn't see the inline_data flag when it re-reads the
inode, thereby aborting e2fsck.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/pass1.c                          |   14 ++++++++++++++
 e2fsck/problem.c                        |    4 ++++
 e2fsck/problem.h                        |    4 ++++
 tests/f_bad_disconnected_inode/expect.1 |    9 +++++++++
 4 files changed, 31 insertions(+)


diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 7554f4e..cf84db6 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2163,6 +2163,16 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		}
 	}
 
+	if (inode->i_flags & EXT4_INLINE_DATA_FL) {
+		if (!(fs->super->s_feature_incompat &
+		      EXT4_FEATURE_INCOMPAT_INLINE_DATA)) {
+			if (fix_problem(ctx, PR_1_INLINE_DATA_SET, pctx)) {
+				inode->i_flags &= ~EXT4_INLINE_DATA_FL;
+				dirty_inode++;
+			}
+		}
+	}
+
 	if (ext2fs_file_acl_block(fs, inode) &&
 	    check_ext_attr(ctx, pctx, block_buf)) {
 		if (ctx->flags & E2F_FLAG_SIGNAL_MASK)
@@ -2174,6 +2184,10 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 		if (extent_fs && (inode->i_flags & EXT4_EXTENTS_FL))
 			check_blocks_extents(ctx, pctx, &pb);
 		else {
+			if (dirty_inode)
+				e2fsck_write_inode(ctx, ino, inode,
+						   "check_blocks");
+			dirty_inode = 0;
 			pctx->errcode = ext2fs_block_iterate3(fs, ino,
 						pb.is_dir ? BLOCK_FLAG_HOLE : 0,
 						block_buf, process_block, &pb);
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index be9d3ec..7d9cfd6 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1020,6 +1020,10 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@i %i, end of extent exceeds allowed value\n\t(logical @b %c, physical @b %b, len %N)\n"),
 	  PROMPT_CLEAR, 0 },
 
+	/* Inline data flag set on filesystem without inline data support */
+	{ PR_1_INLINE_DATA_SET,
+	  N_("@i %i has inline data flag set on @f without inline data support.\n"),
+	  PROMPT_CLEAR, 0 },
 
 	/* Pass 1b errors */
 
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index 8999a64..3304caa 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -593,6 +593,10 @@ struct problem_context {
 #define PR_1_EXTENT_INDEX_START_INVALID	0x01006D
 
 #define PR_1_EXTENT_END_OUT_OF_BOUNDS	0x01006E
+
+/* Inline data flag set on filesystem without inline data support */
+#define PR_1_INLINE_DATA_SET		0x01006F
+
 /*
  * Pass 1b errors
  */
diff --git a/tests/f_bad_disconnected_inode/expect.1 b/tests/f_bad_disconnected_inode/expect.1
index 11862f6..dec22e1 100644
--- a/tests/f_bad_disconnected_inode/expect.1
+++ b/tests/f_bad_disconnected_inode/expect.1
@@ -2,12 +2,21 @@ Pass 1: Checking inodes, blocks, and sizes
 Inode 1 has EXTENTS_FL flag set on filesystem without extents support.
 Clear? yes
 
+Inode 9 has inline data flag set on filesystem without inline data support.
+Clear? yes
+
+Inode 10 has inline data flag set on filesystem without inline data support.
+Clear? yes
+
 Inode 15 has EXTENTS_FL flag set on filesystem without extents support.
 Clear? yes
 
 Inode 16 has EXTENTS_FL flag set on filesystem without extents support.
 Clear? yes
 
+Inode 14 has inline data flag set on filesystem without inline data support.
+Clear? yes
+
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 /lost+found not found.  Create? yes

