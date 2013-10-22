From: Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH] e2fsck: fix problem comments to match actual message
Date: Mon, 21 Oct 2013 21:54:07 -0600
Message-ID: <1382414047-93725-1-git-send-email-andreas.dilger@intel.com>
Cc: linux-ext4@vger.kernel.org,
	Andreas Dilger <andreas.dilger@intel.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:43379 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974Ab3JVDyU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Oct 2013 23:54:20 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fix the e2fsck problem comments to match the actual message printed,
so that it is possible to find the problem code when searching by
the message.

Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 e2fsck/problem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index b0a6e19..2a6c937 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1118,12 +1118,12 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("@n @i number for '.' in @d @i %i.\n"),
 	  PROMPT_FIX, 0 },
 
-	/* Directory entry has bad inode number */
+	/* Entry 'xxxx' in /a/b/c has bad inode number.*/
 	{ PR_2_BAD_INO,
 	  N_("@E has @n @i #: %Di.\n"),
 	  PROMPT_CLEAR, 0 },
 
-	/* Directory entry has deleted or unused inode */
+	/* Entry 'xxxx' in /a/b/c has deleted/unused inode nnnnn.*/
 	{ PR_2_UNUSED_INODE,
 	  N_("@E has @D/unused @i %Di.  "),
 	  PROMPT_CLEAR, PR_PREEN_OK },
-- 
1.7.11.5

