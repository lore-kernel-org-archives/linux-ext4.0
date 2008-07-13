From: akpm@linux-foundation.org
Subject: [patch 3/4] jbd2-fix-race-between-jbd2_journal_try_to_free_buffers-and-jbd2-commit-transaction-cleanup
Date: Sat, 12 Jul 2008 23:26:21 -0700
Message-ID: <200807130626.m6D6QL7E007913@imap1.linux-foundation.org>
Cc: cmm@us.ibm.com, linux-ext4@vger.kernel.org,
	akpm@linux-foundation.org, pbadari@us.ibm.com
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34509 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752404AbYGMG0r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Jul 2008 02:26:47 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Andrew Morton <akpm@linux-foundation.org>

unneeded initialisation.

Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jbd2/transaction.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/jbd2/transaction.c~jbd2-fix-race-between-jbd2_journal_try_to_free_buffers-and-jbd2-commit-transaction-cleanup fs/jbd2/transaction.c
--- a/fs/jbd2/transaction.c~jbd2-fix-race-between-jbd2_journal_try_to_free_buffers-and-jbd2-commit-transaction-cleanup
+++ a/fs/jbd2/transaction.c
@@ -1479,7 +1479,7 @@ out:
  */
 static void jbd2_journal_wait_for_transaction_sync_data(journal_t *journal)
 {
-	transaction_t *transaction = NULL;
+	transaction_t *transaction;
 	tid_t tid;
 
 	spin_lock(&journal->j_state_lock);
_
