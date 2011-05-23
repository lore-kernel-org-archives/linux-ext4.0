From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 2/2 v2] jbd: Add fixed tracepoints
Date: Mon, 23 May 2011 18:33:02 +0200
Message-ID: <1306168382-29280-2-git-send-email-lczerner@redhat.com>
References: <1306168382-29280-1-git-send-email-lczerner@redhat.com>
Cc: Lukas Czerner <lczerner@redhat.com>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008Ab1EWQdT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 May 2011 12:33:19 -0400
In-Reply-To: <1306168382-29280-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This commit adds fixed tracepoint for jbd. It has been based on fixed
tracepoints for jbd2, however there are missing those for collecting
statistics, since I think that it will require more intrusive patch so I
should have its own commit, if someone decide that it is needed. Also
there are new tracepoints in __journal_drop_transaction() and
journal_update_superblock().

The list of jbd tracepoints:

jbd_checkpoint
jbd_start_commit
jbd_commit_locking
jbd_commit_flushing
jbd_commit_logging
jbd_drop_transaction
jbd_end_commit
jbd_do_submit_data
jbd_cleanup_journal_tail
jbd_update_superblock_end

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Cc: Jan Kara <jack@suse.cz>
---
(v2: nothing has changed)
 fs/jbd/checkpoint.c        |    4 +
 fs/jbd/commit.c            |   11 +++
 fs/jbd/journal.c           |    4 +
 include/trace/events/jbd.h |  203 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 222 insertions(+), 0 deletions(-)
 create mode 100644 include/trace/events/jbd.h

diff --git a/fs/jbd/checkpoint.c b/fs/jbd/checkpoint.c
index e4b87bc..dea7503 100644
--- a/fs/jbd/checkpoint.c
+++ b/fs/jbd/checkpoint.c
@@ -22,6 +22,7 @@
 #include <linux/jbd.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
+#include <trace/events/jbd.h>
 
 /*
  * Unlink a buffer from a transaction checkpoint list.
@@ -358,6 +359,7 @@ int log_do_checkpoint(journal_t *journal)
 	 * journal straight away.
 	 */
 	result = cleanup_journal_tail(journal);
+	trace_jbd_checkpoint(journal, result);
 	jbd_debug(1, "cleanup_journal_tail returned %d\n", result);
 	if (result <= 0)
 		return result;
@@ -503,6 +505,7 @@ int cleanup_journal_tail(journal_t *journal)
 	if (blocknr < journal->j_tail)
 		freed = freed + journal->j_last - journal->j_first;
 
+	trace_jbd_cleanup_journal_tail(journal, first_tid, blocknr, freed);
 	jbd_debug(1,
 		  "Cleaning journal tail from %d to %d (offset %u), "
 		  "freeing %u\n",
@@ -752,6 +755,7 @@ void __journal_drop_transaction(journal_t *journal, transaction_t *transaction)
 	J_ASSERT(journal->j_committing_transaction != transaction);
 	J_ASSERT(journal->j_running_transaction != transaction);
 
+	trace_jbd_drop_transaction(journal, transaction);
 	jbd_debug(1, "Dropping transaction %d, all done\n", transaction->t_tid);
 	kfree(transaction);
 }
diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 69b1804..0f27f67 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -21,6 +21,7 @@
 #include <linux/pagemap.h>
 #include <linux/bio.h>
 #include <linux/blkdev.h>
+#include <trace/events/jbd.h>
 
 /*
  * Default IO end handler for temporary BJ_IO buffer_heads.
@@ -204,6 +205,8 @@ write_out_data:
 			if (!trylock_buffer(bh)) {
 				BUFFER_TRACE(bh, "needs blocking lock");
 				spin_unlock(&journal->j_list_lock);
+				trace_jbd_do_submit_data(journal,
+						     commit_transaction);
 				/* Write out all data to prevent deadlocks */
 				journal_do_submit_data(wbuf, bufs, write_op);
 				bufs = 0;
@@ -236,6 +239,8 @@ write_out_data:
 			jbd_unlock_bh_state(bh);
 			if (bufs == journal->j_wbufsize) {
 				spin_unlock(&journal->j_list_lock);
+				trace_jbd_do_submit_data(journal,
+						     commit_transaction);
 				journal_do_submit_data(wbuf, bufs, write_op);
 				bufs = 0;
 				goto write_out_data;
@@ -266,6 +271,7 @@ write_out_data:
 		}
 	}
 	spin_unlock(&journal->j_list_lock);
+	trace_jbd_do_submit_data(journal, commit_transaction);
 	journal_do_submit_data(wbuf, bufs, write_op);
 
 	return err;
@@ -322,12 +328,14 @@ void journal_commit_transaction(journal_t *journal)
 	commit_transaction = journal->j_running_transaction;
 	J_ASSERT(commit_transaction->t_state == T_RUNNING);
 
+	trace_jbd_start_commit(journal, commit_transaction);
 	jbd_debug(1, "JBD: starting commit of transaction %d\n",
 			commit_transaction->t_tid);
 
 	spin_lock(&journal->j_state_lock);
 	commit_transaction->t_state = T_LOCKED;
 
+	trace_jbd_commit_locking(journal, commit_transaction);
 	spin_lock(&commit_transaction->t_handle_lock);
 	while (commit_transaction->t_updates) {
 		DEFINE_WAIT(wait);
@@ -398,6 +406,7 @@ void journal_commit_transaction(journal_t *journal)
 	 */
 	journal_switch_revoke_table(journal);
 
+	trace_jbd_commit_flushing(journal, commit_transaction);
 	commit_transaction->t_state = T_FLUSH;
 	journal->j_committing_transaction = commit_transaction;
 	journal->j_running_transaction = NULL;
@@ -499,6 +508,7 @@ void journal_commit_transaction(journal_t *journal)
 	commit_transaction->t_state = T_COMMIT;
 	spin_unlock(&journal->j_state_lock);
 
+	trace_jbd_commit_logging(journal, commit_transaction);
 	J_ASSERT(commit_transaction->t_nr_buffers <=
 		 commit_transaction->t_outstanding_credits);
 
@@ -947,6 +957,7 @@ restart_loop:
 	}
 	spin_unlock(&journal->j_list_lock);
 
+	trace_jbd_end_commit(journal, commit_transaction);
 	jbd_debug(1, "JBD: commit %d complete, head %d\n",
 		  journal->j_commit_sequence, journal->j_tail_sequence);
 
diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index b3713af..6fa89b9 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -38,6 +38,9 @@
 #include <linux/debugfs.h>
 #include <linux/ratelimit.h>
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/jbd.h>
+
 #include <asm/uaccess.h>
 #include <asm/page.h>
 
@@ -1055,6 +1058,7 @@ void journal_update_superblock(journal_t *journal, int wait)
 	} else
 		write_dirty_buffer(bh, WRITE);
 
+	trace_jbd_update_superblock_end(journal, wait);
 out:
 	/* If we have just flushed the log (by marking s_start==0), then
 	 * any future commit will have to be careful to update the
diff --git a/include/trace/events/jbd.h b/include/trace/events/jbd.h
new file mode 100644
index 0000000..aff64d8
--- /dev/null
+++ b/include/trace/events/jbd.h
@@ -0,0 +1,203 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM jbd
+
+#if !defined(_TRACE_JBD_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_JBD_H
+
+#include <linux/jbd.h>
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(jbd_checkpoint,
+
+	TP_PROTO(journal_t *journal, int result),
+
+	TP_ARGS(journal, result),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	int,	result			)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= journal->j_fs_dev->bd_dev;
+		__entry->result		= result;
+	),
+
+	TP_printk("dev %d,%d result %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->result)
+);
+
+DECLARE_EVENT_CLASS(jbd_commit,
+
+	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
+
+	TP_ARGS(journal, commit_transaction),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	char,	sync_commit		)
+		__field(	int,	transaction		)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= journal->j_fs_dev->bd_dev;
+		__entry->sync_commit = commit_transaction->t_synchronous_commit;
+		__entry->transaction	= commit_transaction->t_tid;
+	),
+
+	TP_printk("dev %d,%d transaction %d sync %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->transaction, __entry->sync_commit)
+);
+
+DEFINE_EVENT(jbd_commit, jbd_start_commit,
+
+	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
+
+	TP_ARGS(journal, commit_transaction)
+);
+
+DEFINE_EVENT(jbd_commit, jbd_commit_locking,
+
+	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
+
+	TP_ARGS(journal, commit_transaction)
+);
+
+DEFINE_EVENT(jbd_commit, jbd_commit_flushing,
+
+	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
+
+	TP_ARGS(journal, commit_transaction)
+);
+
+DEFINE_EVENT(jbd_commit, jbd_commit_logging,
+
+	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
+
+	TP_ARGS(journal, commit_transaction)
+);
+
+TRACE_EVENT(jbd_drop_transaction,
+
+	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
+
+	TP_ARGS(journal, commit_transaction),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	char,	sync_commit		)
+		__field(	int,	transaction		)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= journal->j_fs_dev->bd_dev;
+		__entry->sync_commit = commit_transaction->t_synchronous_commit;
+		__entry->transaction	= commit_transaction->t_tid;
+	),
+
+	TP_printk("dev %d,%d transaction %d sync %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->transaction, __entry->sync_commit)
+);
+
+TRACE_EVENT(jbd_end_commit,
+	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
+
+	TP_ARGS(journal, commit_transaction),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	char,	sync_commit		)
+		__field(	int,	transaction		)
+		__field(	int,	head			)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= journal->j_fs_dev->bd_dev;
+		__entry->sync_commit = commit_transaction->t_synchronous_commit;
+		__entry->transaction	= commit_transaction->t_tid;
+		__entry->head		= journal->j_tail_sequence;
+	),
+
+	TP_printk("dev %d,%d transaction %d sync %d head %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->transaction, __entry->sync_commit, __entry->head)
+);
+
+TRACE_EVENT(jbd_do_submit_data,
+	TP_PROTO(journal_t *journal, transaction_t *commit_transaction),
+
+	TP_ARGS(journal, commit_transaction),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	char,	sync_commit		)
+		__field(	int,	transaction		)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= journal->j_fs_dev->bd_dev;
+		__entry->sync_commit = commit_transaction->t_synchronous_commit;
+		__entry->transaction	= commit_transaction->t_tid;
+	),
+
+	TP_printk("dev %d,%d transaction %d sync %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		   __entry->transaction, __entry->sync_commit)
+);
+
+TRACE_EVENT(jbd_cleanup_journal_tail,
+
+	TP_PROTO(journal_t *journal, tid_t first_tid,
+		 unsigned long block_nr, unsigned long freed),
+
+	TP_ARGS(journal, first_tid, block_nr, freed),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	tid_t,	tail_sequence		)
+		__field(	tid_t,	first_tid		)
+		__field(unsigned long,	block_nr		)
+		__field(unsigned long,	freed			)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= journal->j_fs_dev->bd_dev;
+		__entry->tail_sequence	= journal->j_tail_sequence;
+		__entry->first_tid	= first_tid;
+		__entry->block_nr	= block_nr;
+		__entry->freed		= freed;
+	),
+
+	TP_printk("dev %d,%d from %u to %u offset %lu freed %lu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->tail_sequence, __entry->first_tid,
+		  __entry->block_nr, __entry->freed)
+);
+
+TRACE_EVENT(jbd_update_superblock_end,
+	TP_PROTO(journal_t *journal, int wait),
+
+	TP_ARGS(journal, wait),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	int,	wait			)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= journal->j_fs_dev->bd_dev;
+		__entry->wait		= wait;
+	),
+
+	TP_printk("dev %d,%d wait %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		   __entry->wait)
+);
+
+#endif /* _TRACE_JBD_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.4.4

