From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 3/5] e2fsck: print a notice when we've started suppressing a problem code
Date: Sun, 18 Mar 2012 15:52:46 -0400
Message-ID: <1332100368-2683-4-git-send-email-tytso@mit.edu>
References: <1332100368-2683-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40344 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756125Ab2CRTwr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Mar 2012 15:52:47 -0400
In-Reply-To: <1332100368-2683-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 e2fsck/problem.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 53e8e11..7d5b10d 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1868,6 +1868,11 @@ int fix_problem(e2fsck_t ctx, problem_t code, struct problem_context *pctx)
 		if ((ptr->flags & PR_LATCH_MASK) &&
 		    (ldesc->flags & (PRL_YES | PRL_NO)))
 			suppress++;
+		if (ptr->count == ptr->max_count + 1) {
+			printf("...problem 0x%06x suppressed\n",
+			       ptr->e2p_code);
+			fflush(stdout);
+		}
 	}
 	if (!suppress) {
 		message = ptr->e2p_description;
-- 
1.7.9.107.g97f9a

