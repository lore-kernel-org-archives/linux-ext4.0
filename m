From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] e2fsck: Change PR_3_CREATE_LPF_ERROR to be a non-fatal problem
Date: Thu, 22 Jan 2009 16:33:04 -0500
Message-ID: <1232659984-10183-4-git-send-email-tytso@mit.edu>
References: <20090122211224.GJ14966@mit.edu>
 <1232659984-10183-1-git-send-email-tytso@mit.edu>
 <1232659984-10183-2-git-send-email-tytso@mit.edu>
 <1232659984-10183-3-git-send-email-tytso@mit.edu>
Cc: Eric Sesterhenn <snakebyte@gmx.de>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44599 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbZAVVdH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Jan 2009 16:33:07 -0500
In-Reply-To: <1232659984-10183-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The other problem codes associated with failing to create the
lost+found directory are non-fatal, and this one should be non-fatal
as well.  The two places which call e2fsck_get_lost_and_found()
already deal with a failure to create the directory, so there's no
point making this be a fatal error.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/problem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 9d193c3..3f53350 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1386,7 +1386,7 @@ static struct e2fsck_problem problem_table[] = {
 	/* Error creating lost and found directory */
 	{ PR_3_CREATE_LPF_ERROR,
 	  N_("Error creating /@l @d (%s): %m\n"),
-	  PROMPT_NONE, PR_FATAL },
+	  PROMPT_NONE, 0 },
 
 	/* Root inode is not directory; aborting */
 	{ PR_3_ROOT_NOT_DIR_ABORT,
-- 
1.6.0.4.8.g36f27.dirty

