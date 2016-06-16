From: Wang Shilong <wangshilong1991@gmail.com>
Subject: [PATCH] jbd2: wake up j_wait_done_commit before commit callback
Date: Thu, 16 Jun 2016 12:45:28 +0900
Message-ID: <1466048728-4325-1-git-send-email-wangshilong1991@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33582 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932456AbcFPDpd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Jun 2016 23:45:33 -0400
Received: by mail-pf0-f193.google.com with SMTP id c74so3031658pfb.0
        for <linux-ext4@vger.kernel.org>; Wed, 15 Jun 2016 20:45:33 -0700 (PDT)
Received: from localhost.localdomain (fs276ec80e.tkyc203.ap.nuro.jp. [39.110.200.14])
        by smtp.gmail.com with ESMTPSA id ez6sm56347360pab.12.2016.06.15.20.45.30
        for <linux-ext4@vger.kernel.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 15 Jun 2016 20:45:31 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Wang Shilong <wshilong@ddn.com>

Lustre register some callbacks in ext4 to keep data consistency,
we see millons callbacks possibility on MDS for metadata operations.

If there are many commit callbacks which might take some cpu
time, we can mark commit done before we call commit callback.
this can relax some thread waiting for commit finished, for example
transaction throttle in end transaction.

Signed-off-by: Wang Shilong <wshilong@ddn.com>
---
 fs/jbd2/commit.c |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 7007809..a9cf5a4 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -379,6 +379,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	tid_t first_tid;
 	int update_tail;
 	int csum_size = 0;
+	int need_free = 0;
 	LIST_HEAD(io_bufs);
 	LIST_HEAD(log_bufs);
 
@@ -1100,9 +1101,6 @@ restart_loop:
 
 	write_unlock(&journal->j_state_lock);
 
-	if (journal->j_commit_callback)
-		journal->j_commit_callback(journal, commit_transaction);
-
 	trace_jbd2_end_commit(journal, commit_transaction);
 	jbd_debug(1, "JBD2: commit %d complete, head %d\n",
 		  journal->j_commit_sequence, journal->j_tail_sequence);
@@ -1114,12 +1112,18 @@ restart_loop:
 	if (commit_transaction->t_checkpoint_list == NULL &&
 	    commit_transaction->t_checkpoint_io_list == NULL) {
 		__jbd2_journal_drop_transaction(journal, commit_transaction);
-		jbd2_journal_free_transaction(commit_transaction);
+		need_free = 1;
 	}
 	spin_unlock(&journal->j_list_lock);
 	write_unlock(&journal->j_state_lock);
 	wake_up(&journal->j_wait_done_commit);
 
+	if (journal->j_commit_callback)
+		journal->j_commit_callback(journal, commit_transaction);
+
+	if (need_free)
+		jbd2_journal_free_transaction(commit_transaction);
+
 	/*
 	 * Calculate overall stats
 	 */
-- 
1.7.1

