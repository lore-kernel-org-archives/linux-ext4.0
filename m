From: Yuanhan Liu <yliu.null@gmail.com>
Subject: [PATCH 2/2] jbd2: retname jbd2_get_transaction to jbd2_init_transaction
Date: Mon, 25 Jun 2012 17:08:08 +0800
Message-ID: <1340615288-24016-1-git-send-email-yliu.null@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yuanhan Liu <yliu.null@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58107 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab2FYJIP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Jun 2012 05:08:15 -0400
Received: by dady13 with SMTP id y13so5055097dad.19
        for <linux-ext4@vger.kernel.org>; Mon, 25 Jun 2012 02:08:15 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

jbd2_get_transaction() does nothing but initialization. So, rename it
and also fix the comments.

Signed-off-by: Yuanhan Liu <yliu.null@gmail.com>
---
 fs/jbd2/transaction.c |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index fb1ab953..4f8b1a0 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -63,12 +63,12 @@ void jbd2_journal_free_transaction(transaction_t *transaction)
 }
 
 /*
- * jbd2_get_transaction: obtain a new transaction_t object.
+ * jbd2_init_transaction: Initialize a new transaction_t object.
  *
- * Simply allocate and initialise a new transaction.  Create it in
- * RUNNING state and add it to the current journal (which should not
- * have an existing running transaction: we only make a new transaction
- * once we have started to commit the old one).
+ * Simply initialise a new transaction.  Initialize it in RUNNING state
+ * and add it to the current journal (which should not have an existing
+ * running transaction: we only make a new transaction once we have
+ * started to commit the old one).
  *
  * Preconditions:
  *	The journal MUST be locked.  We don't perform atomic mallocs on the
@@ -77,8 +77,8 @@ void jbd2_journal_free_transaction(transaction_t *transaction)
  *
  */
 
-static transaction_t *
-jbd2_get_transaction(journal_t *journal, transaction_t *transaction)
+static void
+jbd2_init_transaction(journal_t *journal, transaction_t *transaction)
 {
 	transaction->t_journal = journal;
 	transaction->t_state = T_RUNNING;
@@ -100,8 +100,6 @@ jbd2_get_transaction(journal_t *journal, transaction_t *transaction)
 	journal->j_running_transaction = transaction;
 	transaction->t_max_wait = 0;
 	transaction->t_start = jiffies;
