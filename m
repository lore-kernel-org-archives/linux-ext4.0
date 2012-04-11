From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/3] jbd: Write journal superblock with WRITE_FUA after checkpointing
Date: Wed, 11 Apr 2012 21:58:38 +0200
Message-ID: <1334174318-11735-4-git-send-email-jack@suse.cz>
References: <1334174318-11735-1-git-send-email-jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57640 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933005Ab2DKT6p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Apr 2012 15:58:45 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id C6C388FE2D
	for <linux-ext4@vger.kernel.org>; Wed, 11 Apr 2012 21:58:44 +0200 (CEST)
In-Reply-To: <1334174318-11735-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If journal superblock is written only in disk's caches and other transaction
starts reusing space of the transaction cleaned from the log, it can happen
blocks of a new transaction reach the disk before journal superblock. When
power failure happens in such case, subsequent journal replay would still try
to replay the old transaction but some of it's blocks may be already
overwritten by the new transaction. For this reason we must use WRITE_FUA when
updating log tail and we must first write new log tail to disk and update
in-memory information only after that.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd/checkpoint.c        |   23 +++++++---------
 fs/jbd/commit.c            |    9 ++++++-
 fs/jbd/journal.c           |   60 ++++++++++++++++++++++++++++---------------
 include/linux/jbd.h        |    3 +-
 include/trace/events/jbd.h |    9 ++++--
 5 files changed, 65 insertions(+), 39 deletions(-)

diff --git a/fs/jbd/checkpoint.c b/fs/jbd/checkpoint.c
index 80c85f3..08c0304 100644
--- a/fs/jbd/checkpoint.c
+++ b/fs/jbd/checkpoint.c
@@ -508,20 +508,19 @@ int cleanup_journal_tail(journal_t *journal)
 	/*
 	 * We need to make sure that any blocks that were recently written out
 	 * --- perhaps by log_do_checkpoint() --- are flushed out before we
-	 * drop the transactions from the journal. It's unlikely this will be
-	 * necessary, especially with an appropriately sized journal, but we
-	 * need this to guarantee correctness.  Fortunately
-	 * cleanup_journal_tail() doesn't get called all that often.
+	 * drop the transactions from the journal. Similarly we need to be sure
+	 * superblock makes it to disk before next transaction starts reusing
+	 * freed space (otherwise we could replay some blocks of the new
+	 * transaction thinking they belong to the old one). So we use
+	 * WRITE_FLUSH_FUA. It's unlikely this will be necessary, especially
+	 * with an appropriately sized journal, but we need this to guarantee
+	 * correctness.  Fortunately cleanup_journal_tail() doesn't get called
+	 * all that often.
 	 */
-	if (journal->j_flags & JFS_BARRIER)
-		blkdev_issue_flush(journal->j_fs_dev, GFP_KERNEL, NULL);
+	journal_update_sb_log_tail(journal, first_tid, blocknr,
+				   WRITE_FLUSH_FUA);
 
 	spin_lock(&journal->j_state_lock);
-	if (!tid_gt(first_tid, journal->j_tail_sequence)) {
-		spin_unlock(&journal->j_state_lock);
-		/* Someone else cleaned up journal so return 0 */
-		return 0;
-	}
 	/* OK, update the superblock to recover the freed space.
 	 * Physical blocks come first: have we wrapped beyond the end of
 	 * the log?  */
@@ -539,8 +538,6 @@ int cleanup_journal_tail(journal_t *journal)
 	journal->j_tail_sequence = first_tid;
 	journal->j_tail = blocknr;
 	spin_unlock(&journal->j_state_lock);
-	if (!(journal->j_flags & JFS_ABORT))
-		journal_update_sb_log_tail(journal);
 	return 0;
 }
 
diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index 1b27f46..52c15c7 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -309,7 +309,14 @@ void journal_commit_transaction(journal_t *journal)
 	if (journal->j_flags & JFS_FLUSHED) {
 		jbd_debug(3, "super block updated\n");
 		mutex_lock(&journal->j_checkpoint_mutex);
-		journal_update_sb_log_tail(journal);
+		/*
+		 * We hold j_checkpoint_mutex so tail cannot change under us.
+		 * We don't need any special data guarantees for writing sb
+		 * since journal is empty and it is ok for write to be
+		 * flushed only with transaction commit.
+		 */
+		journal_update_sb_log_tail(journal, journal->j_tail_sequence,
+					   journal->j_tail, WRITE_SYNC);
 		mutex_unlock(&journal->j_checkpoint_mutex);
 	} else {
 		jbd_debug(3, "superblock not updated\n");
diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 0f89174..bf28ae6 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -938,8 +938,16 @@ static int journal_reset(journal_t *journal)
 	} else {
 		/* Lock here to make assertions happy... */
 		mutex_lock(&journal->j_checkpoint_mutex);
-		/* Add the dynamic fields and write it to disk. */
-		journal_update_sb_log_tail(journal);
+		/*
+		 * Update log tail information. We use WRITE_FUA since new
+		 * transaction will start reusing journal space and so we
+		 * must make sure information about current log tail is on
+		 * disk before that.
+		 */
+		journal_update_sb_log_tail(journal,
+					   journal->j_tail_sequence,
+					   journal->j_tail,
+					   WRITE_FUA);
 		mutex_unlock(&journal->j_checkpoint_mutex);
 	}
 	return journal_start_thread(journal);
@@ -1018,11 +1026,15 @@ int journal_create(journal_t *journal)
 	return journal_reset(journal);
 }
 
-static void journal_write_superblock(journal_t *journal)
+static void journal_write_superblock(journal_t *journal, int write_op)
 {
 	struct buffer_head *bh = journal->j_sb_buffer;
+	int ret;
 
-	trace_journal_write_superblock(journal);
+	trace_journal_write_superblock(journal, write_op);
+	if (!(journal->j_flags & JFS_BARRIER))
+		write_op &= ~(REQ_FUA | REQ_FLUSH);
+	lock_buffer(bh);
 	if (buffer_write_io_error(bh)) {
 		char b[BDEVNAME_SIZE];
 		/*
@@ -1040,40 +1052,46 @@ static void journal_write_superblock(journal_t *journal)
 		set_buffer_uptodate(bh);
 	}
 
-	BUFFER_TRACE(bh, "marking dirty");
-	mark_buffer_dirty(bh);
-	sync_dirty_buffer(bh);
+	get_bh(bh);
+	bh->b_end_io = end_buffer_write_sync;
+	ret = submit_bh(write_op, bh);
+	wait_on_buffer(bh);
 	if (buffer_write_io_error(bh)) {
-		char b[BDEVNAME_SIZE];
-		printk(KERN_ERR "JBD: I/O error detected "
-		       "when updating journal superblock for %s.\n",
-		       journal_dev_name(journal, b));
 		clear_buffer_write_io_error(bh);
 		set_buffer_uptodate(bh);
+		ret = -EIO;
+	}
+	if (ret) {
+		char b[BDEVNAME_SIZE];
+		printk(KERN_ERR "JBD: Error %d detected "
+		       "when updating journal superblock for %s.\n",
+		       ret, journal_dev_name(journal, b));
 	}
 }
 
 /**
  * journal_update_sb_log_tail() - Update log tail in journal sb on disk.
  * @journal: The journal to update.
+ * @tail_tid: TID of the new transaction at the tail of the log
+ * @tail_block: The first block of the transaction at the tail of the log
+ * @write_op: With which operation should we write the journal sb
  *
  * Update a journal's superblock information about log tail and write it to
  * disk, waiting for the IO to complete.
  */
-void journal_update_sb_log_tail(journal_t *journal)
+void journal_update_sb_log_tail(journal_t *journal, tid_t tail_tid,
+				unsigned int tail_block, int write_op)
 {
 	journal_superblock_t *sb = journal->j_superblock;
 
 	BUG_ON(!mutex_is_locked(&journal->j_checkpoint_mutex));
-	spin_lock(&journal->j_state_lock);
-	jbd_debug(1,"JBD: updating superblock (start %u, seq %d, errno %d)\n",
-		  journal->j_tail, journal->j_tail_sequence, journal->j_errno);
+	jbd_debug(1,"JBD: updating superblock (start %u, seq %u)\n",
+		  tail_block, tail_tid);
 
-	sb->s_sequence = cpu_to_be32(journal->j_tail_sequence);
-	sb->s_start    = cpu_to_be32(journal->j_tail);
-	spin_unlock(&journal->j_state_lock);
+	sb->s_sequence = cpu_to_be32(tail_tid);
+	sb->s_start    = cpu_to_be32(tail_block);
 
-	journal_write_superblock(journal);
+	journal_write_superblock(journal, write_op);
 
 	/* Log is no longer empty */
 	spin_lock(&journal->j_state_lock);
@@ -1102,7 +1120,7 @@ static void mark_journal_empty(journal_t *journal)
 	sb->s_start    = cpu_to_be32(0);
 	spin_unlock(&journal->j_state_lock);
 
-	journal_write_superblock(journal);
+	journal_write_superblock(journal, WRITE_FUA);
 
 	spin_lock(&journal->j_state_lock);
 	/* Log is empty */
@@ -1127,7 +1145,7 @@ static void journal_update_sb_errno(journal_t *journal)
 	sb->s_errno = cpu_to_be32(journal->j_errno);
 	spin_unlock(&journal->j_state_lock);
 
-	journal_write_superblock(journal);
+	journal_write_superblock(journal, WRITE_SYNC);
 }
 
 /*
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index 9716d37..c8f3297 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -864,7 +864,8 @@ extern int	   journal_destroy    (journal_t *);
 extern int	   journal_recover    (journal_t *journal);
 extern int	   journal_wipe       (journal_t *, int);
 extern int	   journal_skip_recovery	(journal_t *);
-extern void	   journal_update_sb_log_tail	(journal_t *);
+extern void	   journal_update_sb_log_tail	(journal_t *, tid_t, unsigned int,
+						 int);
 extern void	   journal_abort      (journal_t *, int);
 extern int	   journal_errno      (journal_t *);
 extern void	   journal_ack_err    (journal_t *);
diff --git a/include/trace/events/jbd.h b/include/trace/events/jbd.h
index d9658a9..da6f259 100644
--- a/include/trace/events/jbd.h
+++ b/include/trace/events/jbd.h
@@ -170,19 +170,22 @@ TRACE_EVENT(jbd_cleanup_journal_tail,
 );
 
 TRACE_EVENT(journal_write_superblock,
-	TP_PROTO(journal_t *journal),
+	TP_PROTO(journal_t *journal, int write_op),
 
-	TP_ARGS(journal),
+	TP_ARGS(journal, write_op),
 
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
+		__field(	int,	write_op		)
 	),
 
 	TP_fast_assign(
 		__entry->dev		= journal->j_fs_dev->bd_dev;
+		__entry->write_op	= write_op;
 	),
 
-	TP_printk("dev %d,%d", MAJOR(__entry->dev), MINOR(__entry->dev))
+	TP_printk("dev %d,%d write_op %x", MAJOR(__entry->dev),
+		  MINOR(__entry->dev), __entry->write_op)
 );
 
 #endif /* _TRACE_JBD_H */
-- 
1.7.1

