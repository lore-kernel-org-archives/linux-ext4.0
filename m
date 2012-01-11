From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/6] jbd2: Issue cache flush after checkpointing even
 with internal journal
Date: Wed, 11 Jan 2012 13:49:18 +0100
Message-ID: <20120111124918.GD26337@quack.suse.cz>
References: <1326241872-20142-1-git-send-email-jack@suse.cz>
 <1326241872-20142-2-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="pWyiEgJYm5f9v55/"
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55210 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477Ab2AKMtV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jan 2012 07:49:21 -0500
Content-Disposition: inline
In-Reply-To: <1326241872-20142-2-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--pWyiEgJYm5f9v55/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 11-01-12 01:31:07, Jan Kara wrote:
> When we reach jbd2_cleanup_journal_tail(), there is no guarantee that
> checkpointed buffers are on a stable storage - especially if buffers were
> written out by jbd2_log_do_checkpoint(), they are likely to be only in disk's
> caches. Thus when we update journal superblock effectively removing old
> transaction from journal, this write of superblock can get to stable storage
> before those checkpointed buffers which can result in filesystem corruption
> after a crash.
> 
> A similar problem can happen if we replay the journal and wipe it before
> flushing disk's caches.
> 
> Thus we must unconditionally issue a cache flush before we update journal
> superblock in these cases. The fix is slightly complicated by the fact that we
> have to get log tail before we issue cache flush but we can store it in the
> journal superblock only after the cache flush. Otherwise we risk races where
> new tail is written before appropriate cache flush is finished.
  I found two mostly minor issues in the patch. Anyway, attached is a new
version.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--pWyiEgJYm5f9v55/
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-jbd2-Issue-cache-flush-after-checkpointing-even-with.patch"

>From b3c6ad4519ccff9e98ec2f119dc3b5cc59a5f368 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Fri, 25 Nov 2011 00:48:25 +0100
Subject: [PATCH 1/6] jbd2: Issue cache flush after checkpointing even with internal journal

When we reach jbd2_cleanup_journal_tail(), there is no guarantee that
checkpointed buffers are on a stable storage - especially if buffers were
written out by jbd2_log_do_checkpoint(), they are likely to be only in disk's
caches. Thus when we update journal superblock effectively removing old
transaction from journal, this write of superblock can get to stable storage
before those checkpointed buffers which can result in filesystem corruption
after a crash.

A similar problem can happen if we replay the journal and wipe it before
flushing disk's caches.

Thus we must unconditionally issue a cache flush before we update journal
superblock in these cases. The fix is slightly complicated by the fact that we
have to get log tail before we issue cache flush but we can store it in the
journal superblock only after the cache flush. Otherwise we risk races where
new tail is written before appropriate cache flush is finished.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/checkpoint.c        |   74 +++++++-----------------------------------
 fs/jbd2/journal.c           |   71 +++++++++++++++++++++++++++++++++++++++++
 fs/jbd2/recovery.c          |    4 ++
 include/linux/jbd2.h        |    3 ++
 include/trace/events/jbd2.h |    2 +-
 5 files changed, 92 insertions(+), 62 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 16a698b..db50592 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -478,77 +478,29 @@ out:
 
 int jbd2_cleanup_journal_tail(journal_t *journal)
 {
-	transaction_t * transaction;
 	tid_t		first_tid;
-	unsigned long	blocknr, freed;
+	unsigned long	blocknr;
 
 	if (is_journal_aborted(journal))
 		return 1;
 
-	/* OK, work out the oldest transaction remaining in the log, and
-	 * the log block it starts at.
-	 *
-	 * If the log is now empty, we need to work out which is the
-	 * next transaction ID we will write, and where it will
-	 * start. */
-
-	write_lock(&journal->j_state_lock);
-	spin_lock(&journal->j_list_lock);
-	transaction = journal->j_checkpoint_transactions;
-	if (transaction) {
-		first_tid = transaction->t_tid;
-		blocknr = transaction->t_log_start;
-	} else if ((transaction = journal->j_committing_transaction) != NULL) {
-		first_tid = transaction->t_tid;
-		blocknr = transaction->t_log_start;
-	} else if ((transaction = journal->j_running_transaction) != NULL) {
-		first_tid = transaction->t_tid;
-		blocknr = journal->j_head;
-	} else {
-		first_tid = journal->j_transaction_sequence;
-		blocknr = journal->j_head;
-	}
-	spin_unlock(&journal->j_list_lock);
-	J_ASSERT(blocknr != 0);
-
-	/* If the oldest pinned transaction is at the tail of the log
-           already then there's not much we can do right now. */
-	if (journal->j_tail_sequence == first_tid) {
-		write_unlock(&journal->j_state_lock);
+	if (!jbd2_journal_get_log_tail(journal, &first_tid, &blocknr))
 		return 1;
-	}
-
-	/* OK, update the superblock to recover the freed space.
-	 * Physical blocks come first: have we wrapped beyond the end of
-	 * the log?  */
-	freed = blocknr - journal->j_tail;
-	if (blocknr < journal->j_tail)
-		freed = freed + journal->j_last - journal->j_first;
-
-	trace_jbd2_cleanup_journal_tail(journal, first_tid, blocknr, freed);
-	jbd_debug(1,
-		  "Cleaning journal tail from %d to %d (offset %lu), "
-		  "freeing %lu\n",
-		  journal->j_tail_sequence, first_tid, blocknr, freed);
-
-	journal->j_free += freed;
-	journal->j_tail_sequence = first_tid;
-	journal->j_tail = blocknr;
-	write_unlock(&journal->j_state_lock);
+	J_ASSERT(blocknr != 0);
 
 	/*
-	 * If there is an external journal, we need to make sure that
-	 * any data blocks that were recently written out --- perhaps
-	 * by jbd2_log_do_checkpoint() --- are flushed out before we
-	 * drop the transactions from the external journal.  It's
-	 * unlikely this will be necessary, especially with a
-	 * appropriately sized journal, but we need this to guarantee
-	 * correctness.  Fortunately jbd2_cleanup_journal_tail()
-	 * doesn't get called all that often.
+	 * We need to make sure that any blocks that were recently written out
+	 * --- perhaps by jbd2_log_do_checkpoint() --- are flushed out before
+	 * we drop the transactions from the journal. It's unlikely this will
+	 * be necessary, especially with an appropriately sized journal, but we
+	 * need this to guarantee correctness.  Fortunately
+	 * jbd2_cleanup_journal_tail() doesn't get called all that often.
 	 */
-	if ((journal->j_fs_dev != journal->j_dev) &&
-	    (journal->j_flags & JBD2_BARRIER))
+	if (journal->j_flags & JBD2_BARRIER)
 		blkdev_issue_flush(journal->j_fs_dev, GFP_KERNEL, NULL);
+	
+	if (!jbd2_update_log_tail(journal, first_tid, blocknr))
+		return 0;	/* Some transaction was cleaned so return 0 */
 	if (!(journal->j_flags & JBD2_ABORT))
 		jbd2_journal_update_superblock(journal, 1);
 	return 0;
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 0fa0123..baf172d 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -744,6 +744,77 @@ struct journal_head *jbd2_journal_get_descriptor_buffer(journal_t *journal)
 	return jbd2_journal_add_journal_head(bh);
 }
 
+/*
+ * Return tid of the oldest transaction in the journal and block in the journal
+ * where the transaction starts.
+ *
+ * If the journal is now empty, return which will be the next transaction ID
+ * we will write and where will that transaction start.
+ *
+ * The return value is 0 if journal tail cannot be pushed any further, 1 if
+ * it can.
+ */
+int jbd2_journal_get_log_tail(journal_t *journal, tid_t *tid,
+			      unsigned long *block)
+{
+	transaction_t *transaction;
+	int ret;
+
+	read_lock(&journal->j_state_lock);
+	spin_lock(&journal->j_list_lock);
+	transaction = journal->j_checkpoint_transactions;
+	if (transaction) {
+		*tid = transaction->t_tid;
+		*block = transaction->t_log_start;
+	} else if ((transaction = journal->j_committing_transaction) != NULL) {
+		*tid = transaction->t_tid;
+		*block = transaction->t_log_start;
+	} else if ((transaction = journal->j_running_transaction) != NULL) {
+		*tid = transaction->t_tid;
+		*block = journal->j_head;
+	} else {
+		*tid = journal->j_transaction_sequence;
+		*block = journal->j_head;
+	}
+	ret = tid_gt(*tid, journal->j_tail_sequence);
+	spin_unlock(&journal->j_list_lock);
+	read_unlock(&journal->j_state_lock);
+
+	return ret;
+}
+
+/*
+ * Update information in journal about log tail. The function returns 1 if
+ * tail was updated, 0 otherwise. If 1 is returned, caller *must* write
+ * journal superblock before next transaction commit is started.
+ */
+int jbd2_update_log_tail(journal_t *journal, tid_t tid, unsigned long block)
+{
+	unsigned long freed;
+
+	write_lock(&journal->j_state_lock);
+	/* Are there transactions to erase? */
+	if (tid_gt(tid, journal->j_tail_sequence)) {
+		freed = block - journal->j_tail;
+		if (block < journal->j_tail)
+			freed += journal->j_last - journal->j_first;
+
+		trace_jbd2_update_log_tail(journal, tid, block, freed);
+		jbd_debug(1,
+			  "Cleaning journal tail from %d to %d (offset %lu), "
+			  "freeing %lu\n",
+			  journal->j_tail_sequence, tid, block, freed);
+
+		journal->j_free += freed;
+		journal->j_tail_sequence = tid;
+		journal->j_tail = block;
+		write_unlock(&journal->j_state_lock);
+		return 1;
+	}
+	write_unlock(&journal->j_state_lock);
+	return 0;
+}
+
 struct jbd2_stats_proc_session {
 	journal_t *journal;
 	struct transaction_stats_s *stats;
diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index da6d7ba..d9172d0 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -21,6 +21,7 @@
 #include <linux/jbd2.h>
 #include <linux/errno.h>
 #include <linux/crc32.h>
+#include <linux/blkdev.h>
 #endif
 
 /*
@@ -265,6 +266,9 @@ int jbd2_journal_recover(journal_t *journal)
 	err2 = sync_blockdev(journal->j_fs_dev);
 	if (!err)
 		err = err2;
+	/* Flush disk caches to get replayed data on the permanent storage */
+	if (journal->j_flags & JBD2_BARRIER)
+		blkdev_issue_flush(journal->j_fs_dev, GFP_KERNEL, NULL);
 
 	return err;
 }
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 2092ea2..89039f5 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -971,6 +971,9 @@ extern void __journal_clean_data_list(transaction_t *transaction);
 /* Log buffer allocation */
 extern struct journal_head * jbd2_journal_get_descriptor_buffer(journal_t *);
 int jbd2_journal_next_log_block(journal_t *, unsigned long long *);
+int jbd2_journal_get_log_tail(journal_t *journal, tid_t *tid,
+			      unsigned long *block);
+int jbd2_update_log_tail(journal_t *journal, tid_t tid, unsigned long block);
 
 /* Commit management */
 extern void jbd2_journal_commit_transaction(journal_t *);
diff --git a/include/trace/events/jbd2.h b/include/trace/events/jbd2.h
index 7596441..5c74007 100644
--- a/include/trace/events/jbd2.h
+++ b/include/trace/events/jbd2.h
@@ -200,7 +200,7 @@ TRACE_EVENT(jbd2_checkpoint_stats,
 		  __entry->forced_to_close, __entry->written, __entry->dropped)
 );
 
-TRACE_EVENT(jbd2_cleanup_journal_tail,
+TRACE_EVENT(jbd2_update_log_tail,
 
 	TP_PROTO(journal_t *journal, tid_t first_tid,
 		 unsigned long block_nr, unsigned long freed),
-- 
1.7.1


--pWyiEgJYm5f9v55/--
