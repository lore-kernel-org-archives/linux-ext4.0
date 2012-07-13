From: Aditya Kali <adityakali@google.com>
Subject: [PATCH 3/4] e2fsck/quota: mark FS invalid if quotas are not fixed
Date: Fri, 13 Jul 2012 15:25:08 -0700
Message-ID: <1342218309-25983-3-git-send-email-adityakali@google.com>
References: <1342218309-25983-1-git-send-email-adityakali@google.com>
Cc: Aditya Kali <adityakali@google.com>
To: tytso@mit.edu, johann@whamcloud.com, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f202.google.com ([209.85.217.202]:49799 "EHLO
	mail-lb0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab2GMWZO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Jul 2012 18:25:14 -0400
Received: by lbbgp10 with SMTP id gp10so223722lbb.1
        for <linux-ext4@vger.kernel.org>; Fri, 13 Jul 2012 15:25:13 -0700 (PDT)
In-Reply-To: <1342218309-25983-1-git-send-email-adityakali@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If user chooses to not fix quota info, then the FS should be
marked as having errors. PR_NO_OK prevented this from happening.

Signed-off-by: Aditya Kali <adityakali@google.com>
---
 e2fsck/problem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 0948bdb..6a7b6fc 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -1694,7 +1694,7 @@ static struct e2fsck_problem problem_table[] = {
 	/* Update quota information if it is inconsistent */
 	{ PR_6_UPDATE_QUOTAS,
 	  N_("Update quota info for quota type %N"),
-	  PROMPT_NULL, PR_PREEN_OK | PR_NO_OK },
+	  PROMPT_NULL, PR_PREEN_OK },
 
 	{ 0 }
 };
-- 
1.7.7.3

