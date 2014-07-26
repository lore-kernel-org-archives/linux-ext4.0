From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 08/18] e2fsck: fix the various checksum error messages
Date: Fri, 25 Jul 2014 17:34:28 -0700
Message-ID: <20140726003428.28334.68886.stgit@birch.djwong.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31847 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbaGZAed (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Jul 2014 20:34:33 -0400
In-Reply-To: <20140726003339.28334.54447.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Make the "EA block passes checks but fails checksum" message less
strange, and make the other checksum error messages actually print a
period at the end of the sentence.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/problem.c |   26 ++++++++++++--------------
 1 file changed, 12 insertions(+), 14 deletions(-)


diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index a56511a..8440052 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -992,19 +992,17 @@ static struct e2fsck_problem problem_table[] = {
 	     "extent\n\t(logical @b %c, @n physical @b %b, len %N)\n"),
 	  PROMPT_FIX, 0 },
 
-	/* Extended attribute block checksum for inode does not match. */
+	/* Inode extended attribute block checksum does not match block. */
 	{ PR_1_EA_BLOCK_CSUM_INVALID,
-	  N_("Extended attribute @a @b %b checksum for @i %i does not "
-	     "match.  "),
+	  N_("@i %i @a @b %b checksum does not match block.  "),
 	  PROMPT_CLEAR, PR_INITIAL_CSUM },
 
 	/*
-	 * Extended attribute block passes checks, but checksum for inode does
-	 * not match.
+	 * Inode extended attribute block passes checks, but checksum does not
+	 * match block.
 	 */
 	{ PR_1_EA_BLOCK_ONLY_CSUM_INVALID,
-	  N_("Extended attribute @a @b %b passes checks, but checksum for "
-	     "@i %i does not match.  "),
+	  N_("@i %i @a @b %b passes checks, but checksum does not match block.  "),
 	  PROMPT_FIX, 0 },
 
 	/*
@@ -1482,27 +1480,27 @@ static struct e2fsck_problem problem_table[] = {
 
 	/* htree root node fails checksum */
 	{ PR_2_HTREE_ROOT_CSUM_INVALID,
-	  N_("@p @h %d: root node fails checksum\n"),
+	  N_("@p @h %d: root node fails checksum.\n"),
 	  PROMPT_CLEAR_HTREE, PR_PREEN_OK },
 
 	/* htree internal node fails checksum */
 	{ PR_2_HTREE_NODE_CSUM_INVALID,
-	  N_("@p @h %d: internal node fails checksum\n"),
+	  N_("@p @h %d: internal node fails checksum.\n"),
 	  PROMPT_CLEAR_HTREE, PR_PREEN_OK },
 
 	/* leaf node fails checksum */
 	{ PR_2_LEAF_NODE_CSUM_INVALID,
-	  N_("@d @i %i, %B, offset %N: @d fails checksum\n"),
+	  N_("@d @i %i, %B, offset %N: @d fails checksum.\n"),
 	  PROMPT_SALVAGE, PR_PREEN_OK | PR_INITIAL_CSUM },
 
 	/* leaf node has no checksum */
 	{ PR_2_LEAF_NODE_MISSING_CSUM,
-	  N_("@d @i %i, %B, offset %N: @d has no checksum\n"),
+	  N_("@d @i %i, %B, offset %N: @d has no checksum.\n"),
 	  PROMPT_FIX, PR_PREEN_OK },
 
 	/* leaf node passes checks but fails checksum */
 	{ PR_2_LEAF_NODE_ONLY_CSUM_INVALID,
-	  N_("@d @i %i, %B, offset %N: @d passes checks but fails checksum\n"),
+	  N_("@d @i %i, %B, offset %N: @d passes checks but fails checksum.\n"),
 	  PROMPT_FIX, PR_PREEN_OK },
 
 	/* Pass 3 errors */
@@ -1828,12 +1826,12 @@ static struct e2fsck_problem problem_table[] = {
 
 	/* Group N inode bitmap does not match checksum */
 	{ PR_5_INODE_BITMAP_CSUM_INVALID,
-	  N_("@g %g @i bitmap does not match checksum\n"),
+	  N_("@g %g @i bitmap does not match checksum.\n"),
 	  PROMPT_FIX, PR_LATCH_IBITMAP | PR_PREEN_OK },
 
 	/* Group N block bitmap does not match checksum */
 	{ PR_5_BLOCK_BITMAP_CSUM_INVALID,
-	  N_("@g %g @b bitmap does not match checksum\n"),
+	  N_("@g %g @b bitmap does not match checksum.\n"),
 	  PROMPT_FIX, PR_LATCH_BBITMAP | PR_PREEN_OK },
 
 	/* Post-Pass 5 errors */

