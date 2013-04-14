From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 3/5] ext4: fix data integrity for ext4_sync_fs
Date: Sun, 14 Apr 2013 23:01:35 +0400
Message-ID: <1365966097-8968-3-git-send-email-dmonakhov@openvz.org>
References: <1365966097-8968-1-git-send-email-dmonakhov@openvz.org>
Cc: jack@suse.cz, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:32818 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753364Ab3DNTCm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Apr 2013 15:02:42 -0400
In-Reply-To: <1365966097-8968-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Inode's data or non journaled quota may be written w/o jounral so we must
send a barrier at the end of ext4_sync_fs. But it can be skipped if journal
commit will do it for us.

Also fix data integrity for nojournal mode.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/fsync.c      |    2 +-
 fs/ext4/super.c      |   34 +++++++++++++++++++++++++++++++++-
 fs/jbd2/journal.c    |   18 +++++++++++++++++-
 include/linux/jbd2.h |    2 +-
 4 files changed, 52 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index e0ba8a4..8a0dee8 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -164,7 +164,7 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 
 	commit_tid = datasync ? ei->i_datasync_tid : ei->i_sync_tid;
 	if (journal->j_flags & JBD2_BARRIER &&
-	    !jbd2_trans_will_send_data_barrier(journal, commit_tid))
+	    !jbd2_trans_will_send_data_barrier(journal, &commit_tid))
 		needs_barrier = true;
 	ret = jbd2_complete_transaction(journal, commit_tid);
 	if (needs_barrier) {
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index f355c28..f241644 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -69,6 +69,7 @@ static void ext4_mark_recovery_complete(struct super_block *sb,
 static void ext4_clear_journal_err(struct super_block *sb,
 				   struct ext4_super_block *es);
 static int ext4_sync_fs(struct super_block *sb, int wait);
+static int ext4_sync_fs_nojournal(struct super_block *sb, int wait);
 static int ext4_remount(struct super_block *sb, int *flags, char *data);
 static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf);
 static int ext4_unfreeze(struct super_block *sb);
@@ -1096,6 +1097,7 @@ static const struct super_operations ext4_nojournal_sops = {
 	.dirty_inode	= ext4_dirty_inode,
 	.drop_inode	= ext4_drop_inode,
 	.evict_inode	= ext4_evict_inode,
+	.sync_fs	= ext4_sync_fs_nojournal,
 	.put_super	= ext4_put_super,
 	.statfs		= ext4_statfs,
 	.remount_fs	= ext4_remount,
@@ -4529,6 +4531,7 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
 {
 	int ret = 0;
 	tid_t target;
+	bool needs_barrier = false;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
 	trace_ext4_sync_fs(sb, wait);
@@ -4538,10 +4541,39 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
 	 * no dirty dquots
 	 */
 	dquot_writeback_dquots(sb, -1);
+	/*
+	 * Data writeback is possible w/o journal transaction, so barrier must
+	 * being sent at the end of the function. But we can skip it if
+	 * transaction_commit will do it for us.
+	 */
+	if (sbi->s_journal->j_flags & JBD2_BARRIER &&
+	    !jbd2_trans_will_send_data_barrier(sbi->s_journal, NULL))
+		needs_barrier = true;
+
 	if (jbd2_journal_start_commit(sbi->s_journal, &target)) {
 		if (wait)
-			jbd2_log_wait_commit(sbi->s_journal, target);
+			ret = jbd2_log_wait_commit(sbi->s_journal, target);
+	}
+	if (needs_barrier) {
+		int err;
+		err = blkdev_issue_flush(sb->s_bdev, GFP_KERNEL, NULL);
+		if (!ret)
+			ret = err;
 	}
+
+	return ret;
+}
+
+static int ext4_sync_fs_nojournal(struct super_block *sb, int wait)
+{
+	int ret = 0;
+
+	trace_ext4_sync_fs(sb, wait);
+	flush_workqueue(EXT4_SB(sb)->dio_unwritten_wq);
+	dquot_writeback_dquots(sb, -1);
+	if (test_opt(sb, BARRIER))
+		ret = blkdev_issue_flush(sb->s_bdev, GFP_KERNEL, NULL);
+
 	return ret;
 }
 
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index cfe0aca..35de8a0 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -668,14 +668,30 @@ int jbd2_journal_start_commit(journal_t *journal, tid_t *ptid)
  * may or may not have sent the barrier. Used to avoid sending barrier
  * twice in common cases.
  */
-int jbd2_trans_will_send_data_barrier(journal_t *journal, tid_t tid)
+int jbd2_trans_will_send_data_barrier(journal_t *journal, tid_t *wait_tid)
 {
 	int ret = 0;
 	transaction_t *commit_trans;
+	tid_t tid;
 
 	if (!(journal->j_flags & JBD2_BARRIER))
 		return 0;
 	read_lock(&journal->j_state_lock);
+
+	/* Caller want to wait some specific transaction? */
+	if (wait_tid)
+		tid = *wait_tid;
+	else  {
+		/* Most recent uncommitted transaction */
+		if (journal->j_running_transaction) {
+			ret = 1;
+			goto out;
+		}
+		if (!journal->j_commit_sequence) {
+			goto out;
+		}
+		tid = journal->j_commit_sequence;
+	}
 	/* Transaction already committed? */
 	if (tid_geq(journal->j_commit_sequence, tid))
 		goto out;
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 7b38517..8d77790 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1203,7 +1203,7 @@ int jbd2_journal_start_commit(journal_t *journal, tid_t *tid);
 int jbd2_log_wait_commit(journal_t *journal, tid_t tid);
 int jbd2_complete_transaction(journal_t *journal, tid_t tid);
 int jbd2_log_do_checkpoint(journal_t *journal);
-int jbd2_trans_will_send_data_barrier(journal_t *journal, tid_t tid);
+int jbd2_trans_will_send_data_barrier(journal_t *journal, tid_t *tid);
 
 void __jbd2_log_wait_for_space(journal_t *journal);
 extern void __jbd2_journal_drop_transaction(journal_t *, transaction_t *);
-- 
1.7.1

