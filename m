From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/3] jbd: Split updating of journal superblock and marking journal empty
Date: Wed, 11 Apr 2012 21:58:36 +0200
Message-ID: <1334174318-11735-2-git-send-email-jack@suse.cz>
References: <1334174318-11735-1-git-send-email-jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57641 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933049Ab2DKT6p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Apr 2012 15:58:45 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id D2DB390182
	for <linux-ext4@vger.kernel.org>; Wed, 11 Apr 2012 21:58:44 +0200 (CEST)
In-Reply-To: <1334174318-11735-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There are three case of updating journal superblock. In the first case, we want
to mark journal as empty (setting s_sequence to 0), in the second case we want
to update log tail, in the third case we want to update s_errno. Split these
cases into separate functions. It makes the code slightly more straightforward
and later patches will make the distinction even more important.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd/checkpoint.c        |    2 +-
 fs/jbd/commit.c            |    2 +-
 fs/jbd/journal.c           |  164 ++++++++++++++++++++++++++------------------
 include/linux/jbd.h        |    2 +-
 include/trace/events/jbd.h |   12 +--
 5 files changed, 104 insertions(+), 78 deletions(-)

diff --git a/fs/jbd/checkpoint.c b/fs/jbd/checkpoint.c
index 05f0754..80c85f3 100644
--- a/fs/jbd/checkpoint.c
+++ b/fs/jbd/checkpoint.c
@@ -540,7 +540,7 @@ int cleanup_journal_tail(journal_t *journal)
 	journal->j_tail = blocknr;
 	spin_unlock(&journal->j_state_lock);
 	if (!(journal->j_flags & JFS_ABORT))
-		journal_update_superblock(journal, 1);
+		journal_update_sb_log_tail(journal);
 	return 0;
 }
 
diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 9d31e6a..dba9cfd 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -308,7 +308,7 @@ void journal_commit_transaction(journal_t *journal)
 	/* Do we need to erase the effects of a prior journal_flush? */
 	if (journal->j_flags & JFS_FLUSHED) {
 		jbd_debug(3, "super block updated\n");
-		journal_update_superblock(journal, 1);
+		journal_update_sb_log_tail(journal);
 	} else {
 		jbd_debug(3, "superblock not updated\n");
 	}
diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 2047fd7..44c104a 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -923,8 +923,22 @@ static int journal_reset(journal_t *journal)
 
 	journal->j_max_transaction_buffers = journal->j_maxlen / 4;
 
-	/* Add the dynamic fields and write it to disk. */
-	journal_update_superblock(journal, 1);
+	/*
+	 * As a special case, if the on-disk copy is already marked as needing
+	 * no recovery (s_start == 0), then we can safely defer the superblock
+	 * update until the next commit by setting JFS_FLUSHED.  This avoids
+	 * attempting a write to a potential-readonly device.
+	 */
+	if (sb->s_start == 0) {
+		jbd_debug(1,"JBD: Skipping superblock update on recovered sb "
+			"(start %u, seq %d, errno %d)\n",
+			journal->j_tail, journal->j_tail_sequence,
+			journal->j_errno);
+		journal->j_flags |= JFS_FLUSHED;
+	} else {
+		/* Add the dynamic fields and write it to disk. */
+		journal_update_sb_log_tail(journal);
+	}
 	return journal_start_thread(journal);
 }
 
@@ -1001,35 +1015,11 @@ int journal_create(journal_t *journal)
 	return journal_reset(journal);
 }
 
-/**
- * void journal_update_superblock() - Update journal sb on disk.
- * @journal: The journal to update.
- * @wait: Set to '0' if you don't want to wait for IO completion.
- *
- * Update a journal's dynamic superblock fields and write it to disk,
- * optionally waiting for the IO to complete.
- */
-void journal_update_superblock(journal_t *journal, int wait)
+static void journal_write_superblock(journal_t *journal)
 {
-	journal_superblock_t *sb = journal->j_superblock;
 	struct buffer_head *bh = journal->j_sb_buffer;
 
-	/*
-	 * As a special case, if the on-disk copy is already marked as needing
-	 * no recovery (s_start == 0) and there are no outstanding transactions
-	 * in the filesystem, then we can safely defer the superblock update
-	 * until the next commit by setting JFS_FLUSHED.  This avoids
-	 * attempting a write to a potential-readonly device.
-	 */
-	if (sb->s_start == 0 && journal->j_tail_sequence ==
-				journal->j_transaction_sequence) {
-		jbd_debug(1,"JBD: Skipping superblock update on recovered sb "
-			"(start %u, seq %d, errno %d)\n",
-			journal->j_tail, journal->j_tail_sequence,
-			journal->j_errno);
-		goto out;
-	}
-
+	trace_journal_write_superblock(journal);
 	if (buffer_write_io_error(bh)) {
 		char b[BDEVNAME_SIZE];
 		/*
@@ -1047,44 +1037,94 @@ void journal_update_superblock(journal_t *journal, int wait)
 		set_buffer_uptodate(bh);
 	}
 
+	BUFFER_TRACE(bh, "marking dirty");
+	mark_buffer_dirty(bh);
+	sync_dirty_buffer(bh);
+	if (buffer_write_io_error(bh)) {
+		char b[BDEVNAME_SIZE];
+		printk(KERN_ERR "JBD: I/O error detected "
+		       "when updating journal superblock for %s.\n",
+		       journal_dev_name(journal, b));
+		clear_buffer_write_io_error(bh);
+		set_buffer_uptodate(bh);
+	}
+}
+
+/**
+ * journal_update_sb_log_tail() - Update log tail in journal sb on disk.
+ * @journal: The journal to update.
+ *
+ * Update a journal's superblock information about log tail and write it to
+ * disk, waiting for the IO to complete.
+ */
+void journal_update_sb_log_tail(journal_t *journal)
+{
+	journal_superblock_t *sb = journal->j_superblock;
+
 	spin_lock(&journal->j_state_lock);
 	jbd_debug(1,"JBD: updating superblock (start %u, seq %d, errno %d)\n",
 		  journal->j_tail, journal->j_tail_sequence, journal->j_errno);
 
 	sb->s_sequence = cpu_to_be32(journal->j_tail_sequence);
 	sb->s_start    = cpu_to_be32(journal->j_tail);
-	sb->s_errno    = cpu_to_be32(journal->j_errno);
 	spin_unlock(&journal->j_state_lock);
 
-	BUFFER_TRACE(bh, "marking dirty");
-	mark_buffer_dirty(bh);
-	if (wait) {
-		sync_dirty_buffer(bh);
-		if (buffer_write_io_error(bh)) {
-			char b[BDEVNAME_SIZE];
-			printk(KERN_ERR "JBD: I/O error detected "
-			       "when updating journal superblock for %s.\n",
-			       journal_dev_name(journal, b));
-			clear_buffer_write_io_error(bh);
-			set_buffer_uptodate(bh);
-		}
-	} else
-		write_dirty_buffer(bh, WRITE);
+	journal_write_superblock(journal);
 
-	trace_jbd_update_superblock_end(journal, wait);
-out:
-	/* If we have just flushed the log (by marking s_start==0), then
-	 * any future commit will have to be careful to update the
-	 * superblock again to re-record the true start of the log. */
+	/* Log is no longer empty */
+	spin_lock(&journal->j_state_lock);
+	WARN_ON(!sb->s_sequence);
+	journal->j_flags &= ~JFS_FLUSHED;
+	spin_unlock(&journal->j_state_lock);
+}
+
+/**
+ * mark_journal_empty() - Mark on disk journal as empty.
+ * @journal: The journal to update.
+ *
+ * Update a journal's dynamic superblock fields to show that journal is empty.
+ * Write updated superblock to disk waiting for IO to complete.
+ */
+static void mark_journal_empty(journal_t *journal)
+{
+	journal_superblock_t *sb = journal->j_superblock;
 
 	spin_lock(&journal->j_state_lock);
-	if (sb->s_start)
-		journal->j_flags &= ~JFS_FLUSHED;
-	else
-		journal->j_flags |= JFS_FLUSHED;
+	jbd_debug(1, "JBD: Marking journal as empty (seq %d)\n",
+        	  journal->j_tail_sequence);
+
+	sb->s_sequence = cpu_to_be32(journal->j_tail_sequence);
+	sb->s_start    = cpu_to_be32(0);
+	spin_unlock(&journal->j_state_lock);
+
+	journal_write_superblock(journal);
+
+	spin_lock(&journal->j_state_lock);
+	/* Log is empty */
+	journal->j_flags |= JFS_FLUSHED;
 	spin_unlock(&journal->j_state_lock);
 }
 
+/**
+ * journal_update_sb_errno() - Update error in the journal.
+ * @journal: The journal to update.
+ *
+ * Update a journal's errno.  Write updated superblock to disk waiting for IO
+ * to complete.
+ */
+static void journal_update_sb_errno(journal_t *journal)
+{
+	journal_superblock_t *sb = journal->j_superblock;
+
+	spin_lock(&journal->j_state_lock);
+	jbd_debug(1, "JBD: updating superblock error (errno %d)\n",
+        	  journal->j_errno);
+	sb->s_errno = cpu_to_be32(journal->j_errno);
+	spin_unlock(&journal->j_state_lock);
+
+	journal_write_superblock(journal);
+}
+
 /*
  * Read the superblock for a given journal, performing initial
  * validation of the format.
@@ -1268,14 +1308,11 @@ int journal_destroy(journal_t *journal)
 
 	if (journal->j_sb_buffer) {
 		if (!is_journal_aborted(journal)) {
-			/* We can now mark the journal as empty. */
-			journal->j_tail = 0;
 			journal->j_tail_sequence =
 				++journal->j_transaction_sequence;
-			journal_update_superblock(journal, 1);
-		} else {
+			mark_journal_empty(journal);
+		} else
 			err = -EIO;
-		}
 		brelse(journal->j_sb_buffer);
 	}
 
@@ -1457,7 +1494,6 @@ int journal_flush(journal_t *journal)
 {
 	int err = 0;
 	transaction_t *transaction = NULL;
-	unsigned int old_tail;
 
 	spin_lock(&journal->j_state_lock);
 
@@ -1499,14 +1535,8 @@ int journal_flush(journal_t *journal)
 	 * the magic code for a fully-recovered superblock.  Any future
 	 * commits of data to the journal will restore the current
 	 * s_start value. */
+	mark_journal_empty(journal);
 	spin_lock(&journal->j_state_lock);
-	old_tail = journal->j_tail;
-	journal->j_tail = 0;
-	spin_unlock(&journal->j_state_lock);
-	journal_update_superblock(journal, 1);
-	spin_lock(&journal->j_state_lock);
-	journal->j_tail = old_tail;
-
 	J_ASSERT(!journal->j_running_transaction);
 	J_ASSERT(!journal->j_committing_transaction);
 	J_ASSERT(!journal->j_checkpoint_transactions);
@@ -1547,7 +1577,7 @@ int journal_wipe(journal_t *journal, int write)
 
 	err = journal_skip_recovery(journal);
 	if (write)
-		journal_update_superblock(journal, 1);
+		mark_journal_empty(journal);
 
  no_recovery:
 	return err;
@@ -1615,7 +1645,7 @@ static void __journal_abort_soft (journal_t *journal, int errno)
 	__journal_abort_hard(journal);
 
 	if (errno)
-		journal_update_superblock(journal, 1);
+		journal_update_sb_errno(journal);
 }
 
 /**
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index f265682..9716d37 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -864,7 +864,7 @@ extern int	   journal_destroy    (journal_t *);
 extern int	   journal_recover    (journal_t *journal);
 extern int	   journal_wipe       (journal_t *, int);
 extern int	   journal_skip_recovery	(journal_t *);
-extern void	   journal_update_superblock	(journal_t *, int);
+extern void	   journal_update_sb_log_tail	(journal_t *);
 extern void	   journal_abort      (journal_t *, int);
 extern int	   journal_errno      (journal_t *);
 extern void	   journal_ack_err    (journal_t *);
diff --git a/include/trace/events/jbd.h b/include/trace/events/jbd.h
index 9305e1b..d9658a9 100644
--- a/include/trace/events/jbd.h
+++ b/include/trace/events/jbd.h
@@ -169,24 +169,20 @@ TRACE_EVENT(jbd_cleanup_journal_tail,
 		  __entry->block_nr, __entry->freed)
 );
 
-TRACE_EVENT(jbd_update_superblock_end,
-	TP_PROTO(journal_t *journal, int wait),
+TRACE_EVENT(journal_write_superblock,
+	TP_PROTO(journal_t *journal),
 
-	TP_ARGS(journal, wait),
+	TP_ARGS(journal),
 
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
-		__field(	int,	wait			)
 	),
 
 	TP_fast_assign(
 		__entry->dev		= journal->j_fs_dev->bd_dev;
-		__entry->wait		= wait;
 	),
 
-	TP_printk("dev %d,%d wait %d",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		   __entry->wait)
+	TP_printk("dev %d,%d", MAJOR(__entry->dev), MINOR(__entry->dev))
 );
 
 #endif /* _TRACE_JBD_H */
-- 
1.7.1

