From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] e2fsck: Check for cases where EOFBLOCKS_FL is unnecessarily set
Date: Tue, 11 May 2010 16:31:18 -0400
Message-ID: <1273609878-22746-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:53017 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014Ab0EKUbW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 May 2010 16:31:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Some kernels will crash if EOFBLOCKS_FL is set when it is it not
needed, and this if it is left set when it isn't needed, it is a sign
of a kernel bug.

Addresses-Google-Bug: #2604224

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/pass1.c                          |   13 +++++++++++++
 e2fsck/problem.c                        |    5 +++++
 e2fsck/problem.h                        |    3 +++
 tests/f_bad_disconnected_inode/expect.1 |    9 +++++++++
 4 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index bb5604b..a0249ff 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -2000,6 +2000,19 @@ static void check_blocks(e2fsck_t ctx, struct problem_context *pctx,
 			 ((1ULL << (32 + EXT2_BLOCK_SIZE_BITS(fs->super))) - 1))
 			/* too big for an extent-based file - 32bit ee_block */
 			bad_size = 6;
+
+		/*
+		 * Check to see if the EOFBLOCKS flag is set where it
+		 * doesn't need to be.
+		 */
+		if ((inode->i_flags & EXT4_EOFBLOCKS_FL) &&
+		    (size <= (((__u64)pb.last_block + 1) * fs->blocksize))) {
+			pctx->blkcount = pb.last_block;
+			if (fix_problem(ctx, PR_1_EOFBLOCKS_FL_SET, pctx)) {
+				inode->i_flags &= ~EXT4_EOFBLOCKS_FL;
+				dirty_inode++;
+			}
+		}
 	}
 	/* i_size for symlinks is checked elsewhere */
 	if (bad_size && !LINUX_S_ISLNK(inode->i_mode)) {
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 9043281..ceb2ae9 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -885,6 +885,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@i %i has an invalid extent node (blk %b, lblk %c)\n"),
 	  PROMPT_CLEAR, 0 },
 
+	{ PR_1_EOFBLOCKS_FL_SET,
+	  N_("@i %i should not have EOFBLOCKS_FL set "
+	     "(size %Is, lblk %r)\n"),
+	  PROMPT_CLEAR, PR_PREEN_OK },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index f3969e0..b1bc97f 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -517,6 +517,9 @@ struct problem_context {
 /* Extent node header invalid */
 #define PR_1_EXTENT_HEADER_INVALID	0x01005F
 
+/* EOFBLOCKS flag set when not necessary */
+#define PR_1_EOFBLOCKS_FL_SET		0x010060
+
 /*
  * Pass 1b errors
  */
diff --git a/tests/f_bad_disconnected_inode/expect.1 b/tests/f_bad_disconnected_inode/expect.1
index 11862f6..d3920e3 100644
--- a/tests/f_bad_disconnected_inode/expect.1
+++ b/tests/f_bad_disconnected_inode/expect.1
@@ -2,12 +2,21 @@ Pass 1: Checking inodes, blocks, and sizes
 Inode 1 has EXTENTS_FL flag set on filesystem without extents support.
 Clear? yes
 
+Inode 9 should not have EOFBLOCKS_FL set (size 0, lblk -1)
+Clear? yes
+
+Inode 10 should not have EOFBLOCKS_FL set (size 0, lblk -1)
+Clear? yes
+
 Inode 15 has EXTENTS_FL flag set on filesystem without extents support.
 Clear? yes
 
 Inode 16 has EXTENTS_FL flag set on filesystem without extents support.
 Clear? yes
 
+Inode 13 should not have EOFBLOCKS_FL set (size 0, lblk -1)
+Clear? yes
+
 Pass 2: Checking directory structure
 Pass 3: Checking directory connectivity
 /lost+found not found.  Create? yes
-- 
1.6.6.1.1.g974db.dirty

