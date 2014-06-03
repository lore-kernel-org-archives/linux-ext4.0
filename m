From: Benno Schulenberg <bensberg@justemail.net>
Subject: [2/4 v2] e2fsck: make a prompt message simpler and thus translatable
Date: Tue,  3 Jun 2014 22:35:22 +0200
Message-ID: <1401827722-13286-1-git-send-email-bensberg@justemail.net>
References: <20140602234001.GJ30598@thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:54009 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752612AbaFCUfc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jun 2014 16:35:32 -0400
In-Reply-To: <20140602234001.GJ30598@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It can be made simpler because there is no need to differentiate between
having an internal journal inode and having an external journal device.

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
+	  N_("@S has_@j flag is clear, but a @j is present.\n"),
 	  PROMPT_CLEAR, PR_PREEN_OK },
 
 	/* Superblock needs_recovery flag is set but not journal is present */
