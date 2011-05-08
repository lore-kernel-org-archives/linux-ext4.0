From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH] jbd2: only print the debugging information for tid wraparound once
Date: Sun,  8 May 2011 19:38:35 -0400
Message-ID: <1304897915-8538-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37308 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab1EHXih (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 May 2011 19:38:37 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If we somehow wrap, we don't want to keep printing the warning message
over and over again.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/jbd2/journal.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 8c10004..cd2d341 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -500,10 +500,11 @@ int __jbd2_log_start_commit(journal_t *journal, tid_t target)
 		/* This should never happen, but if it does, preserve
 		   the evidence before kjournald goes into a loop and
 		   increments j_commit_sequence beyond all recognition. */
-		WARN(1, "jbd: bad log_start_commit: %u %u %u %u\n",
-		     journal->j_commit_request, journal->j_commit_sequence,
-		     target, journal->j_running_transaction ? 
-		     journal->j_running_transaction->t_tid : 0);
+		WARN_ONCE(1, "jbd: bad log_start_commit: %u %u %u %u\n",
+			  journal->j_commit_request,
+			  journal->j_commit_sequence,
+			  target, journal->j_running_transaction ? 
+			  journal->j_running_transaction->t_tid : 0);
 	return 0;
 }
 
-- 
1.7.3.1

