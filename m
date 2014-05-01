From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 11/37] e2fsck: fix the extended attribute checksum error
 message
Date: Thu, 01 May 2014 16:13:34 -0700
Message-ID: <20140501231334.31890.49878.stgit@birch.djwong.org>
References: <20140501231222.31890.82860.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu, darrick.wong@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39033 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbaEAXNq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 May 2014 19:13:46 -0400
In-Reply-To: <20140501231222.31890.82860.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Make the "EA block passes checks but fails checksum" message less
strange.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 e2fsck/problem.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)


diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 0999399..ec20bd1 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -992,19 +992,17 @@ static struct e2fsck_problem problem_table[] = {
 	     "extent\n\t(logical @b %c, @n physical @b %b, len %N)\n"),
 	  PROMPT_FIX, 0 },
 
-	/* Extended attribute block checksum for inode does not match. */
+	/* Extended attribute block checksum does not match. */
 	{ PR_1_EA_BLOCK_CSUM_INVALID,
-	  N_("Extended attribute @a @b %b checksum for @i %i does not "
-	     "match.  "),
+	  N_("@a @b %b checksum for @i %i does not match.  "),
 	  PROMPT_CLEAR, PR_INITIAL_CSUM },
 
 	/*
-	 * Extended attribute block passes checks, but checksum for inode does
-	 * not match.
+	 * Extended attribute block passes checks, but checksum does not
+	 * match.
 	 */
 	{ PR_1_EA_BLOCK_ONLY_CSUM_INVALID,
-	  N_("Extended attribute @a @b %b passes checks, but checksum for "
-	     "@i %i does not match.  "),
+	  N_("@a @b %b passes checks, but checksum does not match.  "),
 	  PROMPT_FIX, 0 },
 
 	/*

