From: Surbhi Palande <surbhi.palande@canonical.com>
Subject: [PATCH v2] Adding support to freeze and unfreeze a journal
Date: Sat,  7 May 2011 23:04:22 +0300
Message-ID: <1304798662-3884-1-git-send-email-surbhi.palande@canonical.com>
References: <AA6B40F6-33A1-4C0B-8F80-71509FFF106E@dilger.ca>
Cc: jack@suse.cz, toshi.okajima@jp.fujitsu.com, tytso@mit.edu,
	m.mizuma@jp.fujitsu.com, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, sandeen@redhat.com
To: adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:35680 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050Ab1EGUEc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 7 May 2011 16:04:32 -0400
In-Reply-To: <AA6B40F6-33A1-4C0B-8F80-71509FFF106E@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On freezing the F.S, the journal should be frozen as well. This implies not
being able to start any new transactions on a frozen journal. Similarly,
thawing a F.S should thaw a journal and this should conversely start accepting
new transactions. While the F.S is frozen any request to start a new
handle should end up on a wait queue till the F.S is thawed back again.

Adding support to freeze and thaw a journal and leveraging this support in
freezing and thawing ext4.

Signed-off-by: Surbhi Palande <surbhi.palande@canonical.com>
---
Changes since v1:
* Check for the j_flag and if frozen release the j_state_lock before sleeping
   on wait queue
* Export the freeze, thaw routines
* Added a barrier after setting the j_flags = JBD2_FROZEN

 fs/ext4/super.c       |   20 ++++++--------------
 fs/jbd2/journal.c     |    1 +
 fs/jbd2/transaction.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/jbd2.h  |    9 +++++++++
 4 files changed, 59 insertions(+), 14 deletions(-)

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
index 05fa77a..3283c77 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -171,6 +171,17 @@ repeat:
 				journal->j_barrier_count == 0);
 		goto repeat;
 	}
+	/* dont let a new handle start when a journal is frozen.
+	 * jbd2_journal_freeze calls jbd2_journal_unlock_updates() only after
+	 * the jflags indicate that the journal is frozen. So if the
+	 * j_barrier_count is 0, then check if this was made 0 by the freezing
+	 * process
+	 */
+	if (journal->j_flags & JBD2_FROZEN) {
+		read_unlock(&journal->j_state_lock);
+		jbd2_check_frozen(journal);
+		goto repeat;
+	}
 
 	if (!journal->j_running_transaction) {
 		read_unlock(&journal->j_state_lock);
@@ -489,6 +500,38 @@ int jbd2_journal_restart(handle_t *handle, int nblocks)
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
+		journal->j_flags = journal->j_flags | JBD2_FROZEN;
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
+	journal->j_flags = journal->j_flags &= ~JBD2_FROZEN;
+	write_unlock(&journal->j_state_lock);
+	smp_wmb();
+	wake_up(&journal->j_wait_frozen);
+}
+EXPORT_SYMBOL(jbd2_journal_thaw);
+
+
 /**
  * void jbd2_journal_lock_updates () - establish a transaction barrier.
  * @journal:  Journal to establish a barrier on.
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index a32dcae..31d6c23 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -835,6 +835,9 @@ struct journal_s
 	/* Wait queue to wait for updates to complete */
 	wait_queue_head_t	j_wait_updates;
 
+	/* Wait queue to wait for journal to thaw*/
+	wait_queue_head_t	j_wait_frozen;
+
 	/* Semaphore for locking against concurrent checkpoints */
 	struct mutex		j_checkpoint_mutex;
 
@@ -1013,7 +1016,11 @@ struct journal_s
 #define JBD2_ABORT_ON_SYNCDATA_ERR	0x040	/* Abort the journal on file
 						 * data write error in ordered
 						 * mode */
+#define JBD2_FROZEN	0x080   /* Journal thread is frozen as the filesystem is frozen */
+
 
+#define jbd2_check_frozen(journal)	\
+		wait_event(journal->j_wait_frozen, ((journal->j_flags & JBD2_FROZEN) != JBD2_FROZEN))
 /*
  * Function declarations for the journaling transaction and buffer
  * management
@@ -1121,6 +1128,8 @@ extern void	 jbd2_journal_invalidatepage(journal_t *,
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

