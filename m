From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 2/6] ext4: fix data integrity for ext4_sync_fs
Date: Tue, 28 May 2013 13:18:57 +0400
Message-ID: <1369732741-26070-3-git-send-email-dmonakhov@openvz.org>
References: <1369732741-26070-1-git-send-email-dmonakhov@openvz.org>
Cc: jack@suse.cz, Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:44525 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933697Ab3E1JTN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 May 2013 05:19:13 -0400
In-Reply-To: <1369732741-26070-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Inode's data or non journaled quota may be written w/o jounral so we _must_
send a barrier at the end of ext4_sync_fs. But it can be skipped if journal
commit will do it for us.

Also fix data integrity for nojournal mode.
changes from v1:
 skip barrier for async mode

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/super.c      |   35 ++++++++++++++++++++++++++++++++++-
 include/linux/jbd2.h |   15 +++++++++++++++
 2 files changed, 49 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index dbc7c09..edc716d 100644
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
@@ -4520,6 +4522,7 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
 {
 	int ret = 0;
 	tid_t target;
+	bool needs_barrier = false;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
 	trace_ext4_sync_fs(sb, wait);
@@ -4529,10 +4532,40 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
 	 * no dirty dquots
 	 */
 	dquot_writeback_dquots(sb, -1);
+	/*
+	 * Data writeback is possible w/o journal transaction, so barrier must
+	 * being sent at the end of the function. But we can skip it if
+	 * transaction_commit will do it for us.
+	 */
+	target = jbd2_get_latest_transaction(sbi->s_journal);
+	if (wait && sbi->s_journal->j_flags & JBD2_BARRIER &&
+	    !jbd2_trans_will_send_data_barrier(sbi->s_journal, target))
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
+	if (wait && test_opt(sb, BARRIER))
+		ret = blkdev_issue_flush(sb->s_bdev, GFP_KERNEL, NULL);
+
 	return ret;
 }
 
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index c9e1ab6..ed974fd 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1319,6 +1319,21 @@ static inline u32 jbd2_chksum(journal_t *journal, u32 crc,
 	return *(u32 *)desc.ctx;
 }
 
+/* Return most recent uncommitted transaction */
+static inline tid_t  jbd2_get_latest_transaction(journal_t *journal)
+{
+	tid_t tid;
+
+	read_lock(&journal->j_state_lock);
+	tid = journal->j_commit_request;
+	if (journal->j_running_transaction) {
+		tid = journal->j_running_transaction->t_tid;
+	} else if (!journal->j_commit_sequence)
+		tid = journal->j_commit_sequence;
+	read_unlock(&journal->j_state_lock);
+	return tid;
+}
+
 #ifdef __KERNEL__
 
 #define buffer_trace_init(bh)	do {} while (0)
-- 
1.7.1

