From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH] jbd: Fix possible uninitialized memory access when tracing
Date: Wed, 18 Mar 2015 11:33:32 +0100
Message-ID: <1426674812-26883-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45980 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755345AbbCRKdg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Mar 2015 06:33:36 -0400
Received: from int-mx13.intmail.prod.int.phx2.redhat.com (int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 691092932F9
	for <linux-ext4@vger.kernel.org>; Wed, 18 Mar 2015 10:33:36 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently in journal_commit_transaction() if trace point
trace_jbd_end_commit() is enabled, it can access already freed part of
the memory via commit_transaction because it might have already been
freed earlier using __journal_drop_transaction().

Fix it by moving the tracepoint before the point where we can free
commit_transaction and set the commit_transaction to NULL after we free
it to make such cases easier to detect in the future.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 fs/jbd/commit.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index bb217dc..169cf72 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -991,10 +991,12 @@ restart_loop:
 		journal->j_average_commit_time = commit_time;
 
 	spin_unlock(&journal->j_state_lock);
+	trace_jbd_end_commit(journal, commit_transaction);
 
 	if (commit_transaction->t_checkpoint_list == NULL &&
 	    commit_transaction->t_checkpoint_io_list == NULL) {
 		__journal_drop_transaction(journal, commit_transaction);
+		commit_transaction = NULL;
 	} else {
 		if (journal->j_checkpoint_transactions == NULL) {
 			journal->j_checkpoint_transactions = commit_transaction;
@@ -1013,7 +1015,6 @@ restart_loop:
 	}
 	spin_unlock(&journal->j_list_lock);
 
-	trace_jbd_end_commit(journal, commit_transaction);
 	jbd_debug(1, "JBD: commit %d complete, head %d\n",
 		  journal->j_commit_sequence, journal->j_tail_sequence);
 
-- 
1.8.3.1

