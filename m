From: Benno Schulenberg <bensberg@justemail.net>
Subject: [PATCH 3/4] e2fsck: make two comments match the messages
Date: Mon,  2 Jun 2014 21:48:43 +0200
Message-ID: <1401738524-11455-3-git-send-email-bensberg@justemail.net>
References: <1401738524-11455-1-git-send-email-bensberg@justemail.net>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:59289 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751926AbaFBTs7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2014 15:48:59 -0400
In-Reply-To: <1401738524-11455-1-git-send-email-bensberg@justemail.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Benno Schulenberg <bensberg@justemail.net>
---
 e2fsck/problem.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index e393417..3a00cd0 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -461,11 +461,11 @@ static struct e2fsck_problem problem_table[] = {
 	  N_("Pass 1: Checking @is, @bs, and sizes\n"),
 	  PROMPT_NONE, 0 },
 
-	/* Root directory is not an inode */
+	/* Root inode is not a directory */
 	{ PR_1_ROOT_NO_DIR, N_("@r is not a @d.  "),
 	  PROMPT_CLEAR, 0 },
 
-	/* Root directory has dtime set */
+	/* Root inode has dtime set */
 	{ PR_1_ROOT_DTIME,
 	  N_("@r has dtime set (probably due to old mke2fs).  "),
 	  PROMPT_FIX, PR_PREEN_OK },
-- 
1.7.0.4

