From: Jan Kara <jack@suse.cz>
Subject: [PATCH 8/8] jbd2: Cleanup journal tail after transaction commit
Date: Wed, 15 Feb 2012 19:34:14 +0100
Message-ID: <1329330854-14237-9-git-send-email-jack@suse.cz>
References: <1329330854-14237-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54106 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175Ab2BOSem (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Feb 2012 13:34:42 -0500
In-Reply-To: <1329330854-14237-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Normally, we have to issue a cache flush before we can update journal tail in
journal superblock, effectively wiping out old transactions from the journal.
So use the fact that during transaction commit we issue cache flush anyway and
opportunistically push journal tail as far as we can. Since update of journal
superblock is still costly (we have to use WRITE_FUA), we update log tail only
if we can free significant amount of space.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/commit.c     |   32 ++++++++++++++++++++++++++++++++
 fs/jbd2/journal.c    |   13 +++++++++++++
 include/linux/jbd2.h |    1 +
 3 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index f37b783..245201c 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -331,6 +331,10 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	struct buffer_head *cbh = NULL; /* For transactional checksums */
 	__u32 crc32_sum = ~0;
 	struct blk_plug plug;
+	/* Tail of the journal */
+	unsigned long first_block;
+	tid_t first_tid;
+	int update_tail;
 
 	/*
 	 * First job: lock down the current transaction and wait for
@@ -682,10 +686,30 @@ start_journal_io:
 		err = 0;
 	}
 
+	/*
+	 * Get current oldest transaction in the log before we issue flush
+	 * to the filesystem device. After the flush we can be sure that
+	 * blocks of all older transactions are checkpointed to persistent
+	 * storage and we will be safe to update journal start in the
+	 * superblock with the numbers we get here.
+	 */
+	update_tail =
+		jbd2_journal_get_log_tail(journal, &first_tid, &first_block);
+
 	write_lock(&journal->j_state_lock);
+	if (update_tail) {
+		long freed = first_block - journal->j_tail;
+
+		if (first_block < journal->j_tail)
+			freed += journal->j_last - journal->j_first;
+		/* Update tail only if we free significant amount of space */
+		if (freed < journal->j_maxlen / 4)
+			update_tail = 0;
+	}
 	J_ASSERT(commit_transaction->t_state == T_COMMIT);
 	commit_transaction->t_state = T_COMMIT_DFLUSH;
 	write_unlock(&journal->j_state_lock);
+
 	/* 
 	 * If the journal is not located on the file system device,
 	 * then we must flush the file system device before we issue
@@ -836,6 +860,14 @@ wait_for_iobuf:
 	if (err)
 		jbd2_journal_abort(journal, err);
 
+	/*
+	 * Now disk caches for filesystem device are flushed so we are safe to
+	 * erase checkpointed transactions from the log by updating journal
+	 * superblock.
+	 */
+	if (update_tail)
+		jbd2_update_log_tail(journal, first_tid, first_block);
+
 	/* End of a transaction!  Finally, we can do checkpoint
            processing: any buffers committed as a result of this
            transaction can be removed from any checkpoint list it was on
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 192558f..be304b9 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -823,6 +823,19 @@ void __jbd2_update_log_tail(journal_t *journal, tid_t tid, unsigned long block)
 	write_unlock(&journal->j_state_lock);
 }
 
+/*
+ * This is a variaon of __jbd2_update_log_tail which checks for validity of
+ * provided log tail and locks j_checkpoint_mutex. So it is safe against races
+ * with other threads updating log tail.
+ */
+void jbd2_update_log_tail(journal_t *journal, tid_t tid, unsigned long block)
+{
+	mutex_lock(&journal->j_checkpoint_mutex);
+	if (tid_gt(tid, journal->j_tail_sequence))
+		__jbd2_update_log_tail(journal, tid, block);
+	mutex_unlock(&journal->j_checkpoint_mutex);
+}
+
 struct jbd2_stats_proc_session {
 	journal_t *journal;
 	struct transaction_stats_s *stats;
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 1b10c2a..8dccaaa 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -974,6 +974,7 @@ int jbd2_journal_next_log_block(journal_t *, unsigned long long *);
 int jbd2_journal_get_log_tail(journal_t *journal, tid_t *tid,
 			      unsigned long *block);
 void __jbd2_update_log_tail(journal_t *journal, tid_t tid, unsigned long block);
+void jbd2_update_log_tail(journal_t *journal, tid_t tid, unsigned long block);
 
 /* Commit management */
 extern void jbd2_journal_commit_transaction(journal_t *);
-- 
1.7.1

