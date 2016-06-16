From: Jan Kara <jack@suse.cz>
Subject: [PATCH 4/4] jbd2: Track more dependencies on transaction commit
Date: Thu, 16 Jun 2016 12:42:16 +0200
Message-ID: <1466073736-30447-5-git-send-email-jack@suse.cz>
References: <1466073736-30447-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Eryu Guan <eguan@redhat.com>,
	Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43328 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbcFPKmX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 Jun 2016 06:42:23 -0400
In-Reply-To: <1466073736-30447-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

So far we were tracking only dependency on transaction commit due to
starting a new handle (which may require commit to start a new
transaction). Now add tracking also for other cases where we wait for
transaction commit. This way lockdep can catch deadlocks e. g. because we
call jbd2_journal_stop() for a synchronous handle with some locks held
which rank below transaction start.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/journal.c     | 1 +
 fs/jbd2/transaction.c | 4 ++++
 include/linux/jbd2.h  | 6 ++++++
 3 files changed, 11 insertions(+)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 208e4058040b..fc1d7a39b082 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -691,6 +691,7 @@ int jbd2_log_wait_commit(journal_t *journal, tid_t tid)
 {
 	int err = 0;
 
+	jbd2_might_wait_for_commit(journal);
 	read_lock(&journal->j_state_lock);
 #ifdef CONFIG_JBD2_DEBUG
 	if (!tid_geq(journal->j_commit_request, tid)) {
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index c0065040c5be..b5bc3e249163 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -182,6 +182,8 @@ static int add_transaction_credits(journal_t *journal, int blocks,
 	int needed;
 	int total = blocks + rsv_blocks;
 
+	jbd2_might_wait_for_commit(journal);
+
 	/*
 	 * If the current transaction is locked down for commit, wait
 	 * for the lock to be released.
@@ -695,6 +697,8 @@ void jbd2_journal_lock_updates(journal_t *journal)
 {
 	DEFINE_WAIT(wait);
 
+	jbd2_might_wait_for_commit(journal);
+
 	write_lock(&journal->j_state_lock);
 	++journal->j_barrier_count;
 
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index f6232b28eadc..64f8b594dd5a 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1045,6 +1045,12 @@ struct journal_s
 #endif
 };
 
+#define jbd2_might_wait_for_commit(j) \
+	do { \
+		rwsem_acquire(&j->j_trans_commit_map, 0, 0, _THIS_IP_); \
+		rwsem_release(&j->j_trans_commit_map, 1, _THIS_IP_); \
+	} while (0)
+
 /* journal feature predicate functions */
 #define JBD2_FEATURE_COMPAT_FUNCS(name, flagname) \
 static inline bool jbd2_has_feature_##name(journal_t *j) \
-- 
2.6.6

