From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext3: Remove the obsolete broken EXT3_IOC32_WAIT_FOR_READONLY.
Date: Fri,  7 Oct 2011 23:21:18 +0800
Message-ID: <1318000878-2928-1-git-send-email-tm@tao.ma>
Cc: Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:60253 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753001Ab1JGPXb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Oct 2011 11:23:31 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

There are no user of EXT3_IOC32_WAIT_FOR_READONLY and also it is
broken. No one set the set_ro_timer, no one wake up us and our
state is set to TASK_INTERRUPTIBLE not RUNNING. So remove it.

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext3/ioctl.c            |   24 ------------------------
 include/linux/ext3_fs_sb.h |    4 ----
 2 files changed, 0 insertions(+), 28 deletions(-)

diff --git a/fs/ext3/ioctl.c b/fs/ext3/ioctl.c
index c7f4394..ba1b54e 100644
--- a/fs/ext3/ioctl.c
+++ b/fs/ext3/ioctl.c
@@ -150,30 +150,6 @@ setversion_out:
 		mnt_drop_write(filp->f_path.mnt);
 		return err;
 	}
-#ifdef CONFIG_JBD_DEBUG
-	case EXT3_IOC_WAIT_FOR_READONLY:
-		/*
-		 * This is racy - by the time we're woken up and running,
-		 * the superblock could be released.  And the module could
-		 * have been unloaded.  So sue me.
-		 *
-		 * Returns 1 if it slept, else zero.
-		 */
-		{
-			struct super_block *sb = inode->i_sb;
-			DECLARE_WAITQUEUE(wait, current);
-			int ret = 0;
-
-			set_current_state(TASK_INTERRUPTIBLE);
-			add_wait_queue(&EXT3_SB(sb)->ro_wait_queue, &wait);
-			if (timer_pending(&EXT3_SB(sb)->turn_ro_timer)) {
-				schedule();
-				ret = 1;
-			}
-			remove_wait_queue(&EXT3_SB(sb)->ro_wait_queue, &wait);
-			return ret;
-		}
-#endif
 	case EXT3_IOC_GETRSVSZ:
 		if (test_opt(inode->i_sb, RESERVATION)
 			&& S_ISREG(inode->i_mode)
diff --git a/include/linux/ext3_fs_sb.h b/include/linux/ext3_fs_sb.h
index 258088a..6436525 100644
--- a/include/linux/ext3_fs_sb.h
+++ b/include/linux/ext3_fs_sb.h
@@ -76,10 +76,6 @@ struct ext3_sb_info {
 	struct mutex s_resize_lock;
 	unsigned long s_commit_interval;
 	struct block_device *journal_bdev;
-#ifdef CONFIG_JBD_DEBUG
-	struct timer_list turn_ro_timer;	/* For turning read-only (crash simulation) */
-	wait_queue_head_t ro_wait_queue;	/* For people waiting for the fs to go read-only */
-#endif
 #ifdef CONFIG_QUOTA
 	char *s_qf_names[MAXQUOTAS];		/* Names of quota files with journalled quota */
 	int s_jquota_fmt;			/* Format of quota to use */
-- 
1.7.1

