From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH -v2 6/9] ext4: Call journal commit callback without holding j_list_lock
Date: Mon,  3 Nov 2008 23:06:06 +0530
Message-ID: <1225733769-23734-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1225733769-23734-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225733769-23734-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225733769-23734-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225733769-23734-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1225733769-23734-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:45055 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbYKCRgg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 3 Nov 2008 12:36:36 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id mA3HZoIM006793
	for <linux-ext4@vger.kernel.org>; Tue, 4 Nov 2008 04:35:50 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA3HabQm4722754
	for <linux-ext4@vger.kernel.org>; Tue, 4 Nov 2008 04:36:37 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mA3HaYmg013878
	for <linux-ext4@vger.kernel.org>; Tue, 4 Nov 2008 04:36:35 +1100
In-Reply-To: <1225733769-23734-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/jbd2/checkpoint.c |    2 +-
 fs/jbd2/commit.c     |   13 ++++++++-----
 include/linux/jbd2.h |    4 ++--
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 9203c33..e0c34ae 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -668,6 +668,7 @@ int __jbd2_journal_remove_checkpoint(struct journal_head *jh)
 	   safely remove this transaction from the log */
 
 	__jbd2_journal_drop_transaction(journal, transaction);
+	kfree(transaction);
 
 	/* Just in case anybody was waiting for more transactions to be
            checkpointed... */
@@ -742,5 +743,4 @@ void __jbd2_journal_drop_transaction(journal_t *journal, transaction_t *transact
 	J_ASSERT(journal->j_running_transaction != transaction);
 
 	jbd_debug(1, "Dropping transaction %d, all done\n", transaction->t_tid);
-	kfree(transaction);
 }
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index ebc667b..4ed9437 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -338,7 +338,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	int space_left = 0;
 	int first_tag = 0;
 	int tag_flag;
-	int i;
+	int i, to_free = 0;
 	int tag_bytes = journal_tag_bytes(journal);
 	struct buffer_head *cbh = NULL; /* For transactional checksums */
 	__u32 crc32_sum = ~0;
@@ -974,12 +974,10 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	journal->j_committing_transaction = NULL;
 	spin_unlock(&journal->j_state_lock);
 
-	if (journal->j_commit_callback)
-		journal->j_commit_callback(journal, commit_transaction);
-
 	if (commit_transaction->t_checkpoint_list == NULL &&
 	    commit_transaction->t_checkpoint_io_list == NULL) {
 		__jbd2_journal_drop_transaction(journal, commit_transaction);
+		to_free = 1;
 	} else {
 		if (journal->j_checkpoint_transactions == NULL) {
 			journal->j_checkpoint_transactions = commit_transaction;
@@ -998,11 +996,16 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	}
 	spin_unlock(&journal->j_list_lock);
 
+	if (journal->j_commit_callback)
+		journal->j_commit_callback(journal, commit_transaction);
+
 	trace_mark(jbd2_end_commit, "dev %s transaction %d head %d",
-		   journal->j_devname, journal->j_commit_sequence,
+		   journal->j_devname, commit_transaction->t_tid,
 		   journal->j_tail_sequence);
 	jbd_debug(1, "JBD: commit %d complete, head %d\n",
 		  journal->j_commit_sequence, journal->j_tail_sequence);
+	if (to_free)
+		kfree(commit_transaction);
 
 	wake_up(&journal->j_wait_done_commit);
 }
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 973db89..b890ed7 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1146,8 +1146,8 @@ int jbd2_log_wait_commit(journal_t *journal, tid_t tid);
 int jbd2_log_do_checkpoint(journal_t *journal);
 
 void __jbd2_log_wait_for_space(journal_t *journal);
-extern void	__jbd2_journal_drop_transaction(journal_t *, transaction_t *);
-extern int	jbd2_cleanup_journal_tail(journal_t *);
+extern void __jbd2_journal_drop_transaction(journal_t *, transaction_t *);
+extern int jbd2_cleanup_journal_tail(journal_t *);
 
 /* Debugging code only: */
 
-- 
1.6.0.3.514.g2f91b

