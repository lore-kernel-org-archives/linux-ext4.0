From: Yuanhan Liu <yliu.null@gmail.com>
Subject: [PATCH 1/2] jbd: rename get_transaction to init_transaction
Date: Mon, 25 Jun 2012 17:06:47 +0800
Message-ID: <1340615207-20548-1-git-send-email-yliu.null@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yuanhan Liu <yliu.null@gmail.com>
To: akpm@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40017 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab2FYJG7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Jun 2012 05:06:59 -0400
Received: by dady13 with SMTP id y13so5053637dad.19
        for <linux-ext4@vger.kernel.org>; Mon, 25 Jun 2012 02:06:59 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

get_transaction() does nothing but initialization. So, rename it and
also fix the comments.

Signed-off-by: Yuanhan Liu <yliu.null@gmail.com>
---
 fs/jbd/transaction.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index febc10d..82f8a7a 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -31,12 +31,12 @@
 static void __journal_temp_unlink_buffer(struct journal_head *jh);
 
 /*
- * get_transaction: obtain a new transaction_t object.
+ * init_transaction: Initialise a new transaction_t object.
  *
- * Simply allocate and initialise a new transaction.  Create it in
- * RUNNING state and add it to the current journal (which should not
- * have an existing running transaction: we only make a new transaction
- * once we have started to commit the old one).
+ * Simply initialise a new transaction. initialise it in RUNNING state
+ * and add it to the current journal (which should not have an existing
+ * running transaction: we only make a new transaction once we have
+ * started to commit the old one).
  *
  * Preconditions:
  *	The journal MUST be locked.  We don't perform atomic mallocs on the
@@ -46,8 +46,7 @@ static void __journal_temp_unlink_buffer(struct journal_head *jh);
  * Called under j_state_lock
  */
 
-static transaction_t *
-get_transaction(journal_t *journal, transaction_t *transaction)
+static void init_transaction(journal_t *journal, transaction_t *transaction)
 {
 	transaction->t_journal = journal;
 	transaction->t_state = T_RUNNING;
@@ -63,8 +62,6 @@ get_transaction(journal_t *journal, transaction_t *transaction)
 
 	J_ASSERT(journal->j_running_transaction == NULL);
 	journal->j_running_transaction = transaction;
