From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 4/6] jbd2: check jh->b_transaction without taking j_list_lock
Date: Sun,  9 Mar 2014 01:05:39 -0500
Message-ID: <1394345141-3471-4-git-send-email-tytso@mit.edu>
References: <1394345141-3471-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38901 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbaCIGFw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 9 Mar 2014 01:05:52 -0500
In-Reply-To: <1394345141-3471-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

jh->b_transaction is adequately protected for reading by the
jbd_lock_bh_state(bh), so we don't need to take j_list_lock in
__journal_try_to_free_buffer().

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/jbd2/transaction.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 60bb365..78900a1 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1821,11 +1821,11 @@ __journal_try_to_free_buffer(journal_t *journal, struct buffer_head *bh)
 	if (buffer_locked(bh) || buffer_dirty(bh))
 		goto out;
 
-	if (jh->b_next_transaction != NULL)
+	if (jh->b_next_transaction != NULL || jh->b_transaction != NULL)
 		goto out;
 
 	spin_lock(&journal->j_list_lock);
-	if (jh->b_cp_transaction != NULL && jh->b_transaction == NULL) {
+	if (jh->b_cp_transaction != NULL) {
 		/* written-back checkpointed metadata buffer */
 		JBUFFER_TRACE(jh, "remove from checkpoint list");
 		__jbd2_journal_remove_checkpoint(jh);
-- 
1.9.0

