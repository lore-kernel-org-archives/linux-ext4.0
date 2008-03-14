From: "Theodore Ts'o" <tytso@MIT.EDU>
Subject: [PATCH, E2FSPROGS] e2fsck: Check for fast symlinks that have EXTENTS_FL set
Date: Thu, 13 Mar 2008 23:20:57 -0400
Message-ID: <1205464857-6244-2-git-send-email-tytso@mit.edu>
References: <20080313214731.GE28728@mit.edu>
 <1205464857-6244-1-git-send-email-tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:35206 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751143AbYCNDVQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Mar 2008 23:21:16 -0400
In-Reply-To: <1205464857-6244-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

These shouldn't show up in the wild, but if they do, e2fsck will offer
to clear them.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/pass1.c   |    8 ++++++++
 e2fsck/problem.c |    5 +++++
 e2fsck/problem.h |    3 +++
 3 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index 8638989..50e38e1 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -713,6 +713,14 @@ void e2fsck_pass1(e2fsck_t ctx)
 			}
 		}
 
+		if (extent_fs && (inode->i_flags & EXT4_EXTENTS_FL) &&
+		    LINUX_S_ISLNK(inode->i_mode) &&
+		    !ext2fs_inode_has_valid_blocks(inode) &&
+		    fix_problem(ctx, PR_1_FAST_SYMLINK_EXTENT_FL, &pctx)) {
+			inode->i_flags &= ~EXT4_EXTENTS_FL;
+			e2fsck_write_inode(ctx, ino, inode, "pass1");
+		}
+
 		if (ino == EXT2_BAD_INO) {
 			struct process_block_struct pb;
 			
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index afed4fe..d3e2fd7 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -819,6 +819,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@i %i missing EXTENT_FL, but is in extents format\n"),
 	  PROMPT_FIX, PR_PREEN_OK },
 
+	/* Fast symlink has EXTENTS_FL set */
+	{ PR_1_FAST_SYMLINK_EXTENT_FL,
+	  N_("Fast symlink %i has EXTENT_FL set.  "),
+	  PROMPT_CLEAR, 0 },
+
 	/* Pass 1b errors */
 
 	/* Pass 1B: Rescan for duplicate/bad blocks */
diff --git a/e2fsck/problem.h b/e2fsck/problem.h
index d5d1a78..48a4a2b 100644
--- a/e2fsck/problem.h
+++ b/e2fsck/problem.h
@@ -476,6 +476,9 @@ struct problem_context {
 /* inode missing EXTENTS_FL, but is an extent inode */
 #define PR_1_UNSET_EXTENT_FL		0x01005C
 
+/* Fast symlink has EXTENTS_FL set */
+#define PR_1_FAST_SYMLINK_EXTENT_FL	0x01005D
+
 /*
  * Pass 1b errors
  */
-- 
1.5.4.1.144.gdfee-dirty

