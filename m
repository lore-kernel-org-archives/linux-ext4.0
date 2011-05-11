From: Surbhi Palande <surbhi.palande@canonical.com>
Subject: [PATCH] Adding support to freeze and unfreeze a journal
Date: Wed, 11 May 2011 10:46:09 +0300
Message-ID: <1305099969-4153-1-git-send-email-surbhi.palande@canonical.com>
References: <1744A781-0223-4A21-9322-979A6D2AD461@dilger.ca>
Cc: jack@suse.cz, marco.stornelli@gmail.com,
	toshi.okajima@jp.fujitsu.com, tytso@mit.edu,
	m.mizuma@jp.fujitsu.com, sandeen@redhat.com,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:33662 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697Ab1EKTRg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 11 May 2011 15:17:36 -0400
In-Reply-To: <1744A781-0223-4A21-9322-979A6D2AD461@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The journal should be frozen when a filesystem freezes. What this means is
that until the filesystem is thawed again, no new transactions should be
accepted by the journal. When the filesystem thaws, inturn it should thaw the
journal and this should allow the journal to resume accepting new
transactions. While the the filesystem has frozen the journal, the clients of
the journal on calling jbd2_journal_start() will sleep on a wait queue.
Thawing the journal will wake up the sleeping clients and journalling can
progress normally.

An example of the race condition that can happen without this patch is as
follows:

Say the filesystem is thawed when we begin. Let tx be the time at unit x

P1: Process doing an aio write
t1) ext4_file_write()
  t2) generic_file_aio_write()
    t3) __generic_file_aio_write()
      // filesystem is not frozen, so we do not block in the next check.
      t4) vfs_check_frozen()
      t5) generic_write_checks()
----------------- Prempted------------------

P2: Process that does filesystem freeze

t6) freeze_super()
  t7) sync_filesystem()
  t8) sync_blockdev()
  t9) sb->s_op->freeze_fs() (= ext4_freeze)
    t10) jbd2_journal_lock_updates()
    t11) jbd2_journal_flush()
    // Need to unlock the journal before returning to user space.
    t12) jbd2_journal_unlock_updates()
    // Journal is unlocked and so we can start accepting new transactions now.

// freezing process completes execution. Page cache is now clean and should
// remain clean till the filesystem is frozen.
--------------------------------------------

P1: writing process gets the control back
t13) generic_file_buffered_write()
  t14) generic_perform_write()
    t15) a_ops->write_begin() (= ext4_write_begin)
      t16) ext4_journal_start()
	// New handle is started. We do not block here! Write continues
	// dirtying the page cache while the filesystem is frozen!

Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>
Acked-by: Jan Kara <jack@suse.cz>
Reviewed-by: Andreas Dilger <adilger.kernel@dilger.ca>
---
 fs/ext4/super.c       |   20 ++++++--------------
 fs/jbd2/journal.c     |    1 +
 fs/jbd2/transaction.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/jbd2.h  |    7 +++++++
 4 files changed, 56 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 8553dfb..796aa4c 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4179,23 +4179,15 @@ static int ext4_freeze(struct super_block *sb)
 
 	journal = EXT4_SB(sb)->s_journal;
 
-	/* Now we set up the journal barrier. */
-	jbd2_journal_lock_updates(journal);
-
+	error = jbd2_journal_freeze(journal);
 	/*
-	 * Don't clear the needs_recovery flag if we failed to flush
+	 * Don't clear the needs_recovery flag if we failed to freeze
 	 * the journal.
 	 */
-	error = jbd2_journal_flush(journal);
-	if (error < 0)
-		goto out;
-
-	/* Journal blocked and flushed, clear needs_recovery flag. */
-	EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
-	error = ext4_commit_super(sb, 1);
-out:
-	/* we rely on s_frozen to stop further updates */
-	jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
+	if (error >= 0) {
+		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
+		error = ext4_commit_super(sb, 1);
+	}
 	return error;
 }
 
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index e0ec3db..5e46333 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -842,6 +842,7 @@ static journal_t * journal_init_common (void)
 	init_waitqueue_head(&journal->j_wait_checkpoint);
 	init_waitqueue_head(&journal->j_wait_commit);
 	init_waitqueue_head(&journal->j_wait_updates);
+	init_waitqueue_head(&journal->j_wait_frozen);
 	mutex_init(&journal->j_barrier);
 	mutex_init(&journal->j_checkpoint_mutex);
 	spin_lock_init(&journal->j_revoke_lock);
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index 05fa77a..b111642 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -171,6 +171,17 @@ repeat:
 				journal->j_barrier_count == 0);
 		goto repeat;
 	}
+	/* Don't let a new handle start when a journal is frozen.
+	 * jbd2_journal_freeze calls jbd2_journal_unlock_updates() only after
+	 * the j_flags indicate that the journal is frozen. So if the
+	 * j_barrier_count is 0, then check if this was made 0 by the freezing
+	 * process
+	 */
+	if (journal->j_flags & JBD2_FROZEN) {
+		read_unlock(&journal->j_state_lock);
+		wait_event(journal->j_wait_frozen, (journal->j_flags & JBD2_FROZEN));
+		goto repeat;
+	}
 
 	if (!journal->j_running_transaction) {
 		read_unlock(&journal->j_state_lock);
@@ -489,6 +500,37 @@ int jbd2_journal_restart(handle_t *handle, int nblocks)
 }
 EXPORT_SYMBOL(jbd2_journal_restart);
 
+int jbd2_journal_freeze(journal_t *journal)
+{
+	int error = 0;
+	/* Now we set up the journal barrier. */
+	jbd2_journal_lock_updates(journal);
+
+	/*
+	 * Don't clear the needs_recovery flag if we failed to flush
+	 * the journal.
+	 */
+	error = jbd2_journal_flush(journal);
+	if (error >= 0) {
+		write_lock(&journal->j_state_lock);
+		journal->j_flags |= JBD2_FROZEN;
+		write_unlock(&journal->j_state_lock);
+	}
+	jbd2_journal_unlock_updates(journal);
+	return error;
+}
+EXPORT_SYMBOL(jbd2_journal_freeze);
+
+void jbd2_journal_thaw(journal_t * journal)
+{
+	write_lock(&journal->j_state_lock);
+	journal->j_flags &= ~JBD2_FROZEN;
+	write_unlock(&journal->j_state_lock);
+	wake_up(&journal->j_wait_frozen);
+}
+EXPORT_SYMBOL(jbd2_journal_thaw);
+
+
 /**
  * void jbd2_journal_lock_updates () - establish a transaction barrier.
  * @journal:  Journal to establish a barrier on.
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index a32dcae..22b76de 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -718,6 +718,7 @@ jbd2_time_diff(unsigned long start, unsigned long end)
  * @j_wait_checkpoint:  Wait queue to trigger checkpointing
  * @j_wait_commit: Wait queue to trigger commit
  * @j_wait_updates: Wait queue to wait for updates to complete
+ * @j_wait_frozen: Wait queue to wait for journal to thaw
  * @j_checkpoint_mutex: Mutex for locking against concurrent checkpoints
  * @j_head: Journal head - identifies the first unused block in the journal
  * @j_tail: Journal tail - identifies the oldest still-used block in the
@@ -835,6 +836,9 @@ struct journal_s
 	/* Wait queue to wait for updates to complete */
 	wait_queue_head_t	j_wait_updates;
 
+	/* Wait queue to wait for journal to thaw*/
+	wait_queue_head_t	j_wait_frozen;
+
 	/* Semaphore for locking against concurrent checkpoints */
 	struct mutex		j_checkpoint_mutex;
 
@@ -1013,6 +1017,7 @@ struct journal_s
 #define JBD2_ABORT_ON_SYNCDATA_ERR	0x040	/* Abort the journal on file
 						 * data write error in ordered
 						 * mode */
+#define JBD2_FROZEN	0x080 /* Journal thread frozen along with filesystem */
 
 /*
  * Function declarations for the journaling transaction and buffer
@@ -1121,6 +1126,8 @@ extern void	 jbd2_journal_invalidatepage(journal_t *,
 				struct page *, unsigned long);
 extern int	 jbd2_journal_try_to_free_buffers(journal_t *, struct page *, gfp_t);
 extern int	 jbd2_journal_stop(handle_t *);
+extern int	 jbd2_journal_freeze(journal_t *);
+extern void	 jbd2_journal_thaw(journal_t *);
 extern int	 jbd2_journal_flush (journal_t *);
 extern void	 jbd2_journal_lock_updates (journal_t *);
 extern void	 jbd2_journal_unlock_updates (journal_t *);
-- 
1.7.1

