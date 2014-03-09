From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/6] jbd2: don't hold j_state_lock while calling wake_up()
Date: Sun,  9 Mar 2014 01:05:36 -0500
Message-ID: <1394345141-3471-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38903 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846AbaCIGFw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 9 Mar 2014 01:05:52 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The j_state_lock is one of the hottest locks in the jbd2 layer and
thus one of its scalability bottlenecks.

We don't need to be holding the j_state_lock while we are calling
wake_up(&journal->j_wait_commit), so release the lock a little bit
earlier.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/jbd2/journal.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 244b6f6..67b8e30 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -302,8 +302,8 @@ static void journal_kill_thread(journal_t *journal)
 	journal->j_flags |= JBD2_UNMOUNT;
 
 	while (journal->j_task) {
-		wake_up(&journal->j_wait_commit);
 		write_unlock(&journal->j_state_lock);
+		wake_up(&journal->j_wait_commit);
 		wait_event(journal->j_wait_done_commit, journal->j_task == NULL);
 		write_lock(&journal->j_state_lock);
 	}
@@ -710,8 +710,8 @@ int jbd2_log_wait_commit(journal_t *journal, tid_t tid)
 	while (tid_gt(tid, journal->j_commit_sequence)) {
 		jbd_debug(1, "JBD2: want %d, j_commit_sequence=%d\n",
 				  tid, journal->j_commit_sequence);
-		wake_up(&journal->j_wait_commit);
 		read_unlock(&journal->j_state_lock);
+		wake_up(&journal->j_wait_commit);
 		wait_event(journal->j_wait_done_commit,
 				!tid_gt(tid, journal->j_commit_sequence));
 		read_lock(&journal->j_state_lock);
-- 
1.9.0

