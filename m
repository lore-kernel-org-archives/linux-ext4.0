From: Tao Ma <tm@tao.ma>
Subject: [PATCH] ext4: Remove the obsolete broken EXT4_IOC32_WAIT_FOR_READONLY.
Date: Fri,  7 Oct 2011 23:30:27 +0800
Message-ID: <1318001428-3108-2-git-send-email-tm@tao.ma>
References: <1318001428-3108-1-git-send-email-tm@tao.ma>
Cc: "Theodore Ts'o" <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:36710 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753044Ab1JGPcm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Oct 2011 11:32:42 -0400
In-Reply-To: <1318001428-3108-1-git-send-email-tm@tao.ma>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

There are no user of EXT4_IOC32_WAIT_FOR_READONLY and also it is
broken. No one set the set_ro_timer, no one wake up us and our
state is set to TASK_INTERRUPTIBLE not RUNNING. So remove it.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/ext4.h  |    7 -------
 fs/ext4/inode.c |    2 +-
 fs/ext4/ioctl.c |   29 -----------------------------
 3 files changed, 1 insertions(+), 37 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b7d7bd0..4cb030c 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -563,9 +563,6 @@ struct ext4_new_group_data {
 #define EXT4_IOC32_SETRSVSZ		_IOW('f', 6, int)
 #define EXT4_IOC32_GROUP_EXTEND		_IOW('f', 7, unsigned int)
 #define EXT4_IOC32_GROUP_ADD		_IOW('f', 8, struct compat_ext4_new_group_input)
-#ifdef CONFIG_JBD2_DEBUG
-#define EXT4_IOC32_WAIT_FOR_READONLY	_IOR('f', 99, int)
-#endif
 #define EXT4_IOC32_GETVERSION_OLD	FS_IOC32_GETVERSION
 #define EXT4_IOC32_SETVERSION_OLD	FS_IOC32_SETVERSION
 #endif
@@ -1136,10 +1133,6 @@ struct ext4_sb_info {
 	u32 s_max_batch_time;
 	u32 s_min_batch_time;
 	struct block_device *journal_bdev;
-#ifdef CONFIG_JBD2_DEBUG
-	struct timer_list turn_ro_timer;	/* For turning read-only (crash simulation) */
-	wait_queue_head_t ro_wait_queue;	/* For people waiting for the fs to go read-only */
-#endif
 #ifdef CONFIG_QUOTA
 	char *s_qf_names[MAXQUOTAS];		/* Names of quota files with journalled quota */
 	int s_jquota_fmt;			/* Format of quota to use */
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 986e238..0e2c0d1 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -416,7 +416,7 @@ static pgoff_t ext4_num_dirty_pages(struct inode *inode, pgoff_t idx,
  * the buffer head is mapped.
  *
  * It returns 0 if plain look up failed (blocks have not been allocated), in
- * that casem, buffer head is unmapped
+ * that case, buffer head is unmapped
  *
  * It returns the error in case of allocation failure.
  */
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index f18bfe3..1d065d3 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -173,30 +173,6 @@ setversion_out:
 		mnt_drop_write(filp->f_path.mnt);
 		return err;
 	}
-#ifdef CONFIG_JBD2_DEBUG
-	case EXT4_IOC_WAIT_FOR_READONLY:
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
-			add_wait_queue(&EXT4_SB(sb)->ro_wait_queue, &wait);
-			if (timer_pending(&EXT4_SB(sb)->turn_ro_timer)) {
-				schedule();
-				ret = 1;
-			}
-			remove_wait_queue(&EXT4_SB(sb)->ro_wait_queue, &wait);
-			return ret;
-		}
-#endif
 	case EXT4_IOC_GROUP_EXTEND: {
 		ext4_fsblk_t n_blocks_count;
 		struct super_block *sb = inode->i_sb;
@@ -396,11 +372,6 @@ long ext4_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case EXT4_IOC32_SETVERSION_OLD:
 		cmd = EXT4_IOC_SETVERSION_OLD;
 		break;
-#ifdef CONFIG_JBD2_DEBUG
-	case EXT4_IOC32_WAIT_FOR_READONLY:
-		cmd = EXT4_IOC_WAIT_FOR_READONLY;
-		break;
-#endif
 	case EXT4_IOC32_GETRSVSZ:
 		cmd = EXT4_IOC_GETRSVSZ;
 		break;
-- 
1.7.1

