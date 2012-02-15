From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/8] jbd2: Split updating of journal superblock and marking journal empty
Date: Wed, 15 Feb 2012 19:34:07 +0100
Message-ID: <1329330854-14237-2-git-send-email-jack@suse.cz>
References: <1329330854-14237-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54092 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253Ab2BOSel (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Feb 2012 13:34:41 -0500
In-Reply-To: <1329330854-14237-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There are three case of updating journal superblock. In the first case, we want
to mark journal as empty (setting s_sequence to 0), in the second case we want
to update log tail, in the third case we want to update s_errno. Split these
cases into separate functions. It makes the code slightly more straightforward
and later patches will make the distinction even more important.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/checkpoint.c |    2 +-
 fs/jbd2/commit.c     |    2 +-
 fs/jbd2/journal.c    |  162 +++++++++++++++++++++++++++++---------------------
 include/linux/jbd2.h |    2 +-
 4 files changed, 98 insertions(+), 70 deletions(-)

diff --git a/fs/jbd2/checkpoint.c b/fs/jbd2/checkpoint.c
index 16a698b..aa09868 100644
--- a/fs/jbd2/checkpoint.c
+++ b/fs/jbd2/checkpoint.c
@@ -550,7 +550,7 @@ int jbd2_cleanup_journal_tail(journal_t *journal)
 	    (journal->j_flags & JBD2_BARRIER))
 		blkdev_issue_flush(journal->j_fs_dev, GFP_KERNEL, NULL);
 	if (!(journal->j_flags & JBD2_ABORT))
-		jbd2_journal_update_superblock(journal, 1);
+		jbd2_journal_update_sb_log_tail(journal);
 	return 0;
 }
 
diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 68d704d..ffdf512 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -340,7 +340,7 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 	/* Do we need to erase the effects of a prior jbd2_journal_flush? */
 	if (journal->j_flags & JBD2_FLUSHED) {
 		jbd_debug(3, "super block updated\n");
-		jbd2_journal_update_superblock(journal, 1);
+		jbd2_journal_update_sb_log_tail(journal);
 	} else {
 		jbd_debug(3, "superblock not updated\n");
 	}
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 0fa0123..ec05900 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1112,39 +1112,28 @@ static int journal_reset(journal_t *journal)
 
 	journal->j_max_transaction_buffers = journal->j_maxlen / 4;
 
-	/* Add the dynamic fields and write it to disk. */
-	jbd2_journal_update_superblock(journal, 1);
-	return jbd2_journal_start_thread(journal);
-}
-
-/**
- * void jbd2_journal_update_superblock() - Update journal sb on disk.
- * @journal: The journal to update.
- * @wait: Set to '0' if you don't want to wait for IO completion.
- *
- * Update a journal's dynamic superblock fields and write it to disk,
- * optionally waiting for the IO to complete.
- */
-void jbd2_journal_update_superblock(journal_t *journal, int wait)
-{
-	journal_superblock_t *sb = journal->j_superblock;
-	struct buffer_head *bh = journal->j_sb_buffer;
-
 	/*
 	 * As a special case, if the on-disk copy is already marked as needing
-	 * no recovery (s_start == 0) and there are no outstanding transactions
-	 * in the filesystem, then we can safely defer the superblock update
-	 * until the next commit by setting JBD2_FLUSHED.  This avoids
+	 * no recovery (s_start == 0), then we can safely defer the superblock
+	 * update until the next commit by setting JBD2_FLUSHED.  This avoids
 	 * attempting a write to a potential-readonly device.
 	 */
-	if (sb->s_start == 0 && journal->j_tail_sequence ==
-				journal->j_transaction_sequence) {
+	if (sb->s_start == 0) {
 		jbd_debug(1, "JBD2: Skipping superblock update on recovered sb "
 			"(start %ld, seq %d, errno %d)\n",
 			journal->j_tail, journal->j_tail_sequence,
 			journal->j_errno);
-		goto out;
+		journal->j_flags |= JBD2_FLUSHED;
+	} else {
+		/* Add the dynamic fields and write it to disk. */
+		jbd2_journal_update_sb_log_tail(journal);
 	}
+	return jbd2_journal_start_thread(journal);
+}
+
+static void jbd2_write_superblock(journal_t *journal)
+{
+	struct buffer_head *bh = journal->j_sb_buffer;
 
 	if (buffer_write_io_error(bh)) {
 		/*
@@ -1162,47 +1151,98 @@ void jbd2_journal_update_superblock(journal_t *journal, int wait)
 		set_buffer_uptodate(bh);
 	}
 
+	BUFFER_TRACE(bh, "marking dirty");
+	mark_buffer_dirty(bh);
+	sync_dirty_buffer(bh);
+	if (buffer_write_io_error(bh)) {
+		printk(KERN_ERR "JBD2: I/O error detected "
+		       "when updating journal superblock for %s.\n",
+		       journal->j_devname);
+		clear_buffer_write_io_error(bh);
+		set_buffer_uptodate(bh);
+	}
+}
+
+/**
+ * jbd2_journal_update_sb_log_tail() - Update log tail in journal sb on disk.
+ * @journal: The journal to update.
+ *
+ * Update a journal's superblock information about log tail and write it to
+ * disk, waiting for the IO to complete.
+ */
+void jbd2_journal_update_sb_log_tail(journal_t *journal)
+{
+	journal_superblock_t *sb = journal->j_superblock;
+
 	read_lock(&journal->j_state_lock);
-	jbd_debug(1, "JBD2: updating superblock (start %ld, seq %d, errno %d)\n",
-		  journal->j_tail, journal->j_tail_sequence, journal->j_errno);
+	jbd_debug(1, "JBD2: updating superblock (start %ld, seq %d)\n",
+		  journal->j_tail, journal->j_tail_sequence);
 
 	sb->s_sequence = cpu_to_be32(journal->j_tail_sequence);
 	sb->s_start    = cpu_to_be32(journal->j_tail);
-	sb->s_errno    = cpu_to_be32(journal->j_errno);
 	read_unlock(&journal->j_state_lock);
 
-	BUFFER_TRACE(bh, "marking dirty");
-	mark_buffer_dirty(bh);
-	if (wait) {
-		sync_dirty_buffer(bh);
-		if (buffer_write_io_error(bh)) {
-			printk(KERN_ERR "JBD2: I/O error detected "
-			       "when updating journal superblock for %s.\n",
-			       journal->j_devname);
-			clear_buffer_write_io_error(bh);
-			set_buffer_uptodate(bh);
-		}
-	} else
-		write_dirty_buffer(bh, WRITE);
+	jbd2_write_superblock(journal);
 
-out:
-	/* If we have just flushed the log (by marking s_start==0), then
-	 * any future commit will have to be careful to update the
-	 * superblock again to re-record the true start of the log. */
+	/* Log is no longer empty */
+	write_lock(&journal->j_state_lock);
+	WARN_ON(!sb->s_sequence);
+	journal->j_flags &= ~JBD2_FLUSHED;
+	write_unlock(&journal->j_state_lock);
+}
+
+/**
+ * jbd2_mark_journal_empty() - Mark on disk journal as empty.
+ * @journal: The journal to update.
+ *
+ * Update a journal's dynamic superblock fields to show that journal is empty.
+ * Write updated superblock to disk waiting for IO to complete.
+ */
+static void jbd2_mark_journal_empty(journal_t *journal)
+{
+	journal_superblock_t *sb = journal->j_superblock;
+
+	read_lock(&journal->j_state_lock);
+	jbd_debug(1, "JBD2: Marking journal as empty (seq %d)\n",
+		  journal->j_tail_sequence);
+
+	sb->s_sequence = cpu_to_be32(journal->j_tail_sequence);
+	sb->s_start    = cpu_to_be32(0);
+	read_unlock(&journal->j_state_lock);
+
+	jbd2_write_superblock(journal);
 
+	/* Log is no longer empty */
 	write_lock(&journal->j_state_lock);
-	if (sb->s_start)
-		journal->j_flags &= ~JBD2_FLUSHED;
-	else
-		journal->j_flags |= JBD2_FLUSHED;
+	journal->j_flags |= JBD2_FLUSHED;
 	write_unlock(&journal->j_state_lock);
 }
 
+
+/**
+ * jbd2_journal_update_sb_errno() - Update error in the journal.
+ * @journal: The journal to update.
+ *
+ * Update a journal's errno.  Write updated superblock to disk waiting for IO
+ * to complete.
+ */
+static void jbd2_journal_update_sb_errno(journal_t *journal)
+{
+	journal_superblock_t *sb = journal->j_superblock;
+
+	read_lock(&journal->j_state_lock);
+	jbd_debug(1, "JBD2: updating superblock error (errno %d)\n",
+		  journal->j_errno);
+	sb->s_errno    = cpu_to_be32(journal->j_errno);
+	read_unlock(&journal->j_state_lock);
+
+	jbd2_write_superblock(journal);
+}
+
 /*
  * Read the superblock for a given journal, performing initial
  * validation of the format.
  */
-
 static int journal_get_superblock(journal_t *journal)
 {
 	struct buffer_head *bh;
@@ -1395,15 +1435,10 @@ int jbd2_journal_destroy(journal_t *journal)
 	spin_unlock(&journal->j_list_lock);
 
 	if (journal->j_sb_buffer) {
-		if (!is_journal_aborted(journal)) {
-			/* We can now mark the journal as empty. */
-			journal->j_tail = 0;
-			journal->j_tail_sequence =
-				++journal->j_transaction_sequence;
-			jbd2_journal_update_superblock(journal, 1);
-		} else {
+		if (!is_journal_aborted(journal))
+			jbd2_mark_journal_empty(journal);
+		else
 			err = -EIO;
-		}
 		brelse(journal->j_sb_buffer);
 	}
 
@@ -1617,7 +1652,6 @@ int jbd2_journal_flush(journal_t *journal)
 {
 	int err = 0;
 	transaction_t *transaction = NULL;
-	unsigned long old_tail;
 
 	write_lock(&journal->j_state_lock);
 
@@ -1659,14 +1693,8 @@ int jbd2_journal_flush(journal_t *journal)
 	 * the magic code for a fully-recovered superblock.  Any future
 	 * commits of data to the journal will restore the current
 	 * s_start value. */
+	jbd2_mark_journal_empty(journal);
 	write_lock(&journal->j_state_lock);
-	old_tail = journal->j_tail;
-	journal->j_tail = 0;
-	write_unlock(&journal->j_state_lock);
-	jbd2_journal_update_superblock(journal, 1);
-	write_lock(&journal->j_state_lock);
-	journal->j_tail = old_tail;
-
 	J_ASSERT(!journal->j_running_transaction);
 	J_ASSERT(!journal->j_committing_transaction);
 	J_ASSERT(!journal->j_checkpoint_transactions);
@@ -1707,7 +1735,7 @@ int jbd2_journal_wipe(journal_t *journal, int write)
 
 	err = jbd2_journal_skip_recovery(journal);
 	if (write)
-		jbd2_journal_update_superblock(journal, 1);
+		jbd2_mark_journal_empty(journal);
 
  no_recovery:
 	return err;
@@ -1757,7 +1785,7 @@ static void __journal_abort_soft (journal_t *journal, int errno)
 	__jbd2_journal_abort_hard(journal);
 
 	if (errno)
-		jbd2_journal_update_superblock(journal, 1);
+		jbd2_journal_update_sb_errno(journal);
 }
 
 /**
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 2092ea2..78da912 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1082,7 +1082,7 @@ extern int	   jbd2_journal_destroy    (journal_t *);
 extern int	   jbd2_journal_recover    (journal_t *journal);
 extern int	   jbd2_journal_wipe       (journal_t *, int);
 extern int	   jbd2_journal_skip_recovery	(journal_t *);
-extern void	   jbd2_journal_update_superblock	(journal_t *, int);
+extern void	   jbd2_journal_update_sb_log_tail	(journal_t *);
 extern void	   __jbd2_journal_abort_hard	(journal_t *);
 extern void	   jbd2_journal_abort      (journal_t *, int);
 extern int	   jbd2_journal_errno      (journal_t *);
-- 
1.7.1

