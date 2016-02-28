From: Daeho Jeong <daeho.jeong@samsung.com>
Subject: [PATCH v2 2/3] ext4: fix races between changing inode journal mode and
 ext4_writepages
Date: Mon, 29 Feb 2016 08:48:51 +0900
Message-ID: <1456703332-12852-2-git-send-email-daeho.jeong@samsung.com>
References: <1456703332-12852-1-git-send-email-daeho.jeong@samsung.com>
Cc: Daeho Jeong <daeho.jeong@samsung.com>
To: tytso@mit.edu, jack@suse.cz, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:56474 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582AbcB1Xsv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 28 Feb 2016 18:48:51 -0500
Received: from epcpsbgr5.samsung.com
 (u145.gpu120.samsung.co.kr [203.254.230.145])
 by mailout2.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0O3A02V3L7HDYA10@mailout2.samsung.com> for
 linux-ext4@vger.kernel.org; Mon, 29 Feb 2016 08:48:49 +0900 (KST)
In-reply-to: <1456703332-12852-1-git-send-email-daeho.jeong@samsung.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Now, in ext4, there is a race condition between changing inode journal
mode and ext4_writepages(). While ext4_writepages() is executed on
a non-journalled mode inode, the inode's journal mode could be enabled
by ioctl() and then, some pages dirtied after switching the journal
mode will be still exposed to ext4_writepages() in non-journaled mode.
To resolve this problem, we use fs-wide per-cpu rw semaphore by
Jan Kara's suggestion because we don't want to waste ext4_inode_info's
space for this extra rare case.

Signed-off-by: Daeho Jeong <daeho.jeong@samsung.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h  |    4 ++++
 fs/ext4/inode.c |    7 +++++++
 fs/ext4/super.c |    4 ++++
 3 files changed, 15 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 157b458..c757a3d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -33,6 +33,7 @@
 #include <linux/ratelimit.h>
 #include <crypto/hash.h>
 #include <linux/falloc.h>
+#include <linux/percpu-rwsem.h>
 #ifdef __KERNEL__
 #include <linux/compat.h>
 #endif
@@ -1475,6 +1476,9 @@ struct ext4_sb_info {
 	struct ratelimit_state s_err_ratelimit_state;
 	struct ratelimit_state s_warning_ratelimit_state;
 	struct ratelimit_state s_msg_ratelimit_state;
+
+	/* Barrier between changing inodes' journal flags and writepages ops. */
+	struct percpu_rw_semaphore s_journal_flag_rwsem;
 };
 
 static inline struct ext4_sb_info *EXT4_SB(struct super_block *sb)
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9ecfb76..1176142 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2476,6 +2476,7 @@ static int ext4_writepages(struct address_space *mapping,
 	struct blk_plug plug;
 	bool give_up_on_write = false;
 
+	percpu_down_read(&sbi->s_journal_flag_rwsem);
 	trace_ext4_writepages(inode, wbc);
 
 	/*
@@ -2646,6 +2647,7 @@ retry:
 out_writepages:
 	trace_ext4_writepages_result(inode, wbc, ret,
 				     nr_to_write - wbc->nr_to_write);
+	percpu_up_read(&sbi->s_journal_flag_rwsem);
 	return ret;
 }
 
@@ -5362,6 +5364,7 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 	journal_t *journal;
 	handle_t *handle;
 	int err;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 
 	/*
 	 * We have to be very careful here: changing a data block's
@@ -5401,6 +5404,7 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 		}
 	}
 
+	percpu_down_write(&sbi->s_journal_flag_rwsem);
 	jbd2_journal_lock_updates(journal);
 
 	/*
@@ -5417,6 +5421,7 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 		err = jbd2_journal_flush(journal);
 		if (err < 0) {
 			jbd2_journal_unlock_updates(journal);
+			percpu_up_write(&sbi->s_journal_flag_rwsem);
 			ext4_inode_resume_unlocked_dio(inode);
 			return err;
 		}
@@ -5425,6 +5430,8 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
 	ext4_set_aops(inode);
 
 	jbd2_journal_unlock_updates(journal);
+	percpu_up_write(&sbi->s_journal_flag_rwsem);
+
 	if (val)
 		up_write(&EXT4_I(inode)->i_mmap_sem);
 	ext4_inode_resume_unlocked_dio(inode);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3ed01ec..a12950d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -861,6 +861,7 @@ static void ext4_put_super(struct super_block *sb)
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
 	percpu_counter_destroy(&sbi->s_dirtyclusters_counter);
+	percpu_free_rwsem(&sbi->s_journal_flag_rwsem);
 	brelse(sbi->s_sbh);
 #ifdef CONFIG_QUOTA
 	for (i = 0; i < EXT4_MAXQUOTAS; i++)
@@ -3926,6 +3927,9 @@ no_journal:
 	if (!err)
 		err = percpu_counter_init(&sbi->s_dirtyclusters_counter, 0,
 					  GFP_KERNEL);
+	if (!err)
+		err = percpu_init_rwsem(&sbi->s_journal_flag_rwsem);
+
 	if (err) {
 		ext4_msg(sb, KERN_ERR, "insufficient memory");
 		goto failed_mount6;
-- 
1.7.9.5

