From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 5/6] jbd2: minimize region locked by j_list_lock in journal_get_create_access()
Date: Sun,  9 Mar 2014 01:05:40 -0500
Message-ID: <1394345141-3471-5-git-send-email-tytso@mit.edu>
References: <1394345141-3471-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38895 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbaCIGFt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 9 Mar 2014 01:05:49 -0500
In-Reply-To: <1394345141-3471-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It's not needed until we start trying to modifying fields in the
journal_head which are protected by j_list_lock.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/jbd2/transaction.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 78900a1..357f3dc 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1073,7 +1073,6 @@ int jbd2_journal_get_create_access(handle_t *handle, struct buffer_head *bh)
 	 * reused here.
 	 */
 	jbd_lock_bh_state(bh);
-	spin_lock(&journal->j_list_lock);
 	J_ASSERT_JH(jh, (jh->b_transaction == transaction ||
 		jh->b_transaction == NULL ||
 		(jh->b_transaction == journal->j_committing_transaction &&
@@ -1096,12 +1095,14 @@ int jbd2_journal_get_create_access(handle_t *handle, struct buffer_head *bh)
 		jh->b_modified = 0;
 
 		JBUFFER_TRACE(jh, "file as BJ_Reserved");
+		spin_lock(&journal->j_list_lock);
 		__jbd2_journal_file_buffer(jh, transaction, BJ_Reserved);
 	} else if (jh->b_transaction == journal->j_committing_transaction) {
 		/* first access by this transaction */
 		jh->b_modified = 0;
 
 		JBUFFER_TRACE(jh, "set next transaction");
+		spin_lock(&journal->j_list_lock);
 		jh->b_next_transaction = transaction;
 	}
 	spin_unlock(&journal->j_list_lock);
-- 
1.9.0

