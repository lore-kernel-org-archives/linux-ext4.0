From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 6/6] jbd2: minimize region locked by j_list_lock in jbd2_journal_forget()
Date: Sun,  9 Mar 2014 01:05:41 -0500
Message-ID: <1394345141-3471-6-git-send-email-tytso@mit.edu>
References: <1394345141-3471-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38905 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751950AbaCIGFw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 9 Mar 2014 01:05:52 -0500
In-Reply-To: <1394345141-3471-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It's not needed until we start trying to modifying fields in the
journal_head which are protected by j_list_lock.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/jbd2/transaction.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 357f3dc..d999b1f 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1416,7 +1416,6 @@ int jbd2_journal_forget (handle_t *handle, struct buffer_head *bh)
 	BUFFER_TRACE(bh, "entry");
 
 	jbd_lock_bh_state(bh);
-	spin_lock(&journal->j_list_lock);
 
 	if (!buffer_jbd(bh))
 		goto not_jbd;
@@ -1469,6 +1468,7 @@ int jbd2_journal_forget (handle_t *handle, struct buffer_head *bh)
 		 * we know to remove the checkpoint after we commit.
 		 */
 
+		spin_lock(&journal->j_list_lock);
 		if (jh->b_cp_transaction) {
 			__jbd2_journal_temp_unlink_buffer(jh);
 			__jbd2_journal_file_buffer(jh, transaction, BJ_Forget);
@@ -1481,6 +1481,7 @@ int jbd2_journal_forget (handle_t *handle, struct buffer_head *bh)
 				goto drop;
 			}
 		}
+		spin_unlock(&journal->j_list_lock);
 	} else if (jh->b_transaction) {
 		J_ASSERT_JH(jh, (jh->b_transaction ==
 				 journal->j_committing_transaction));
@@ -1492,7 +1493,9 @@ int jbd2_journal_forget (handle_t *handle, struct buffer_head *bh)
 
 		if (jh->b_next_transaction) {
 			J_ASSERT(jh->b_next_transaction == transaction);
+			spin_lock(&journal->j_list_lock);
 			jh->b_next_transaction = NULL;
+			spin_unlock(&journal->j_list_lock);
 
 			/*
 			 * only drop a reference if this transaction modified
@@ -1504,7 +1507,6 @@ int jbd2_journal_forget (handle_t *handle, struct buffer_head *bh)
 	}
 
 not_jbd:
-	spin_unlock(&journal->j_list_lock);
 	jbd_unlock_bh_state(bh);
 	__brelse(bh);
 drop:
-- 
1.9.0

