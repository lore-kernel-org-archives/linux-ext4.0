From: Jan Kara <jack@suse.cz>
Subject: [PATCH] e2fsck: Fix last mount time and last write time in preen mode
Date: Tue, 20 May 2014 16:29:46 +0200
Message-ID: <1400596186-4228-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55157 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219AbaETO3x (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 May 2014 10:29:53 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Fixing last mount time and last write time is safe - there's no risk of
loosing any important information or making corruption significantly
worse even if we get it wrong. So let's just fix these times in preen
mode. This allows initrd to automatically check and mount root
filesystem in case system clock is wrong without having to manually set
broken_system_clock variable (openSUSE uses broken_system_clock by default
to avoid these problems during boot but this disables time-based checks
even on systems where clock is fine so that's not ideal either).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 e2fsck/problem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Ted, what do you think about this change?

diff --git a/e2fsck/problem.c b/e2fsck/problem.c
index 2b564a83c801..a347f1905e44 100644
--- a/e2fsck/problem.c
+++ b/e2fsck/problem.c
@@ -338,12 +338,12 @@ static struct e2fsck_problem problem_table[] = {
 	/* Last mount time is in the future */
 	{ PR_0_FUTURE_SB_LAST_MOUNT,
 	  N_("@S last mount time (%t,\n\tnow = %T) is in the future.\n"),
-	  PROMPT_FIX, PR_NO_OK },
+	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK },
 
 	/* Last write time is in the future */
 	{ PR_0_FUTURE_SB_LAST_WRITE,
 	  N_("@S last write time (%t,\n\tnow = %T) is in the future.\n"),
-	  PROMPT_FIX, PR_NO_OK },
+	  PROMPT_FIX, PR_PREEN_OK | PR_NO_OK },
 
 	{ PR_0_EXTERNAL_JOURNAL_HINT,
 	  N_("@S hint for external superblock @s %X.  "),
-- 
1.8.1.4

