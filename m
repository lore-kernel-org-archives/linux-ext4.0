From: Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH v2 1/7] Adding support to freeze and unfreeze a journal
Date: Thu,  8 Dec 2011 10:04:31 -0800
Message-ID: <1323367477-21685-2-git-send-email-kamal@canonical.com>
References: <1323367477-21685-1-git-send-email-kamal@canonical.com>
Cc: linux-doc@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Surbhi Palande <csurbhi@gmail.com>,
	Valerie Aurora <val@vaaconsulting.com>,
	Kamal Mostafa <kamal@canonical.com>,
	Christopher Chaltain <christopher.chaltain@canonical.com>,
	"Peter M. Petrakis" <peter.petrakis@canonical.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Surbhi Palande <surbhi.palande@canonical.com>
To: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Matthew Wilcox <matthew@wil.cx>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Theodore Tso <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1323367477-21685-1-git-send-email-kamal@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Surbhi Palande <surbhi.palande@canonical.com>

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

BugLink: https://bugs.launchpad.net/bugs/897421
Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>
Acked-by: Jan Kara <jack@suse.cz>
Reviewed-by: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Kamal Mostafa <kamal@canonical.com>
Tested-by: Peter M. Petrakis <peter.petrakis@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/jbd2/journal.c     |    1 +
 fs/jbd2/transaction.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/jbd2.h  |    7 +++++++
 3 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 0fa0123..f0170cc 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -894,6 +894,7 @@ static journal_t * journal_init_common (void)
 	init_waitqueue_head(&journal->j_wait_checkpoint);
 	init_waitqueue_head(&journal->j_wait_commit);
 	init_waitqueue_head(&journal->j_wait_updates);
+	init_waitqueue_head(&journal->j_wait_frozen);
 	mutex_init(&journal->j_barrier);
 	mutex_init(&journal->j_checkpoint_mutex);
 	spin_lock_init(&journal->j_revoke_lock);
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index a0e41a4..340ee35 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -173,6 +173,17 @@ repeat:
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
@@ -492,6 +503,37 @@ int jbd2_journal_restart(handle_t *handle, int nblocks)
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
index 2092ea2..bfa0752 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -658,6 +658,7 @@ jbd2_time_diff(unsigned long start, unsigned long end)
  * @j_wait_checkpoint:  Wait queue to trigger checkpointing
  * @j_wait_commit: Wait queue to trigger commit
  * @j_wait_updates: Wait queue to wait for updates to complete
+ * @j_wait_frozen: Wait queue to wait for journal to thaw
  * @j_checkpoint_mutex: Mutex for locking against concurrent checkpoints
  * @j_head: Journal head - identifies the first unused block in the journal
  * @j_tail: Journal tail - identifies the oldest still-used block in the
@@ -775,6 +776,9 @@ struct journal_s
 	/* Wait queue to wait for updates to complete */
 	wait_queue_head_t	j_wait_updates;
 
+	/* Wait queue to wait for journal to thaw*/
+	wait_queue_head_t	j_wait_frozen;
+
 	/* Semaphore for locking against concurrent checkpoints */
 	struct mutex		j_checkpoint_mutex;
 
@@ -953,6 +957,7 @@ struct journal_s
 #define JBD2_ABORT_ON_SYNCDATA_ERR	0x040	/* Abort the journal on file
 						 * data write error in ordered
 						 * mode */
+#define JBD2_FROZEN	0x080 /* Journal thread frozen along with filesystem */
 
 /*
  * Function declarations for the journaling transaction and buffer
@@ -1060,6 +1065,8 @@ extern void	 jbd2_journal_invalidatepage(journal_t *,
 				struct page *, unsigned long);
 extern int	 jbd2_journal_try_to_free_buffers(journal_t *, struct page *, gfp_t);
 extern int	 jbd2_journal_stop(handle_t *);
+extern int	 jbd2_journal_freeze(journal_t *);
+extern void	 jbd2_journal_thaw(journal_t *);
 extern int	 jbd2_journal_flush (journal_t *);
 extern void	 jbd2_journal_lock_updates (journal_t *);
 extern void	 jbd2_journal_unlock_updates (journal_t *);
-- 
1.7.5.4
