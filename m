From: Benno Schulenberg <bensberg@justemail.net>
Subject: [PATCH 2/4] e2fsck: make a prompt message translatable by not using fill-in words
Date: Mon,  2 Jun 2014 21:48:42 +0200
Message-ID: <1401738524-11455-2-git-send-email-bensberg@justemail.net>
References: <1401738524-11455-1-git-send-email-bensberg@justemail.net>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:50398 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751960AbaFBTsy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jun 2014 15:48:54 -0400
In-Reply-To: <1401738524-11455-1-git-send-email-bensberg@justemail.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Benno Schulenberg <bensberg@justemail.net>
---
 e2fsck/journal.c |    1 -
 e2fsck/problem.c |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/e2fsck/journal.c b/e2fsck/journal.c
index a7b1150..a3b3967 100644
--- a/e2fsck/journal.c
+++ b/e2fsck/journal.c
@@ -820,7 +820,6 @@ errcode_t e2fsck_check_ext3_journal(e2fsck_t ctx)
 no_has_journal:
 	if (!(sb->s_feature_compat & EXT3_FEATURE_COMPAT_HAS_JOURNAL)) {
 		recover = sb->s_feature_incompat & EXT3_FEATURE_INCOMPAT_RECOVER;
-		pctx.str = "inode";
 		if (fix_problem(ctx, PR_0_JOURNAL_HAS_JOURNAL, &pctx)) {
 			if (recover &&
 			    !fix_problem(ctx, PR_0_JOURNAL_RECOVER_SET, &pctx))
diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 2b564a8..e393417 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -225,7 +225,7 @@ static struct e2fsck_problem problem_table[] = {
 
 	/* Superblock has_journal flag is clear but has a journal */
 	{ PR_0_JOURNAL_HAS_JOURNAL,
-	  N_("@S has_@j flag is clear, but a @j %s is present.\n"),
+	  N_("@S has_@j flag is clear, but a @j @i is present.\n"),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
 	/* Superblock needs_recovery flag is set but not journal is present */
-- 
1.7.0.4

