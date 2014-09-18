From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/3] ext4: fold ext4_sync_fs_nojournal() into ext4_sync_fs()
Date: Thu, 18 Sep 2014 16:26:27 -0400
Message-ID: <1411071989-4974-1-git-send-email-tytso@mit.edu>
Cc: Dexuan Cui <decui@microsoft.com>, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36312 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756139AbaIRU0k (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Sep 2014 16:26:40 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This allows us to eliminate duplicate code, and eventually allow us to
also fold ext4_sops and ext4_nojournal_sops together.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/super.c | 36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 115e27d..4770c98 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -70,7 +70,6 @@ static void ext4_mark_recovery_complete(struct super_block *sb,
 static void ext4_clear_journal_err(struct super_block *sb,
 				   struct ext4_super_block *es);
 static int ext4_sync_fs(struct super_block *sb, int wait);
-static int ext4_sync_fs_nojournal(struct super_block *sb, int wait);
 static int ext4_remount(struct super_block *sb, int *flags, char *data);
 static int ext4_statfs(struct dentry *dentry, struct kstatfs *buf);
 static int ext4_unfreeze(struct super_block *sb);
@@ -1131,7 +1130,7 @@ static const struct super_operations ext4_nojournal_sops = {
 	.dirty_inode	= ext4_dirty_inode,
 	.drop_inode	= ext4_drop_inode,
 	.evict_inode	= ext4_evict_inode,
-	.sync_fs	= ext4_sync_fs_nojournal,
+	.sync_fs	= ext4_sync_fs,
 	.put_super	= ext4_put_super,
 	.statfs		= ext4_statfs,
 	.remount_fs	= ext4_remount,
@@ -4718,15 +4717,19 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
 	 * being sent at the end of the function. But we can skip it if
 	 * transaction_commit will do it for us.
 	 */
-	target = jbd2_get_latest_transaction(sbi->s_journal);
-	if (wait && sbi->s_journal->j_flags & JBD2_BARRIER &&
-	    !jbd2_trans_will_send_data_barrier(sbi->s_journal, target))
+	if (sbi->s_journal) {
+		target = jbd2_get_latest_transaction(sbi->s_journal);
+		if (wait && sbi->s_journal->j_flags & JBD2_BARRIER &&
+		    !jbd2_trans_will_send_data_barrier(sbi->s_journal, target))
+			needs_barrier = true;
+
+		if (jbd2_journal_start_commit(sbi->s_journal, &target)) {
+			if (wait)
+				ret = jbd2_log_wait_commit(sbi->s_journal,
+							   target);
+		}
+	} else if (wait && test_opt(sb, BARRIER))
 		needs_barrier = true;
-
-	if (jbd2_journal_start_commit(sbi->s_journal, &target)) {
-		if (wait)
-			ret = jbd2_log_wait_commit(sbi->s_journal, target);
-	}
 	if (needs_barrier) {
 		int err;
 		err = blkdev_issue_flush(sb->s_bdev, GFP_KERNEL, NULL);
@@ -4737,19 +4740,6 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
 	return ret;
 }
 
-static int ext4_sync_fs_nojournal(struct super_block *sb, int wait)
-{
-	int ret = 0;
-
-	trace_ext4_sync_fs(sb, wait);
-	flush_workqueue(EXT4_SB(sb)->rsv_conversion_wq);
-	dquot_writeback_dquots(sb, -1);
-	if (wait && test_opt(sb, BARRIER))
-		ret = blkdev_issue_flush(sb->s_bdev, GFP_KERNEL, NULL);
-
-	return ret;
-}
