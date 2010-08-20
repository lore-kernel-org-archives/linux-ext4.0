From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 3/3] Add inode table initialization code into Ext4
Date: Fri, 20 Aug 2010 19:51:44 +0200
Message-ID: <1282326704-14838-4-git-send-email-lczerner@redhat.com>
References: <1282326704-14838-1-git-send-email-lczerner@redhat.com>
Cc: rwheeler@redhat.com, sandeen@redhat.com, jack@suse.cz,
	tytso@mit.edu, adilger@dilger.ca, lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370Ab0HTRwN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Aug 2010 13:52:13 -0400
In-Reply-To: <1282326704-14838-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When lazy_itable_init extended option is passed to mke2fs, it
considerably speed up filesystem creation because inode tables are left
uninitialized, thus contains some old data. When this fs is mounted
filesystem code should initialize (zero out) uninitialized inode table.
So far this code was missing for ext4 and this patch adds this feature.

When file system is mounted with "inititable" mount option, new thread
(called itableinitd) is created. This thread walks through allocation
groups searching for the group with not yet initialized inode table.
When such a group is found it write zeroes through whole inode table and
put itself into sleep for defined number of seconds to not disturb other
ongoing I/O. This is repeated until it walks through every allocation group
then the iitableinitd thread is stopped.

When regular inode allocation are going too fast, there is a chance that
it hits the group with uninitialized inode table sooner than the
itableinitd thread. In that case it just initializes the itable for
itself the same way that itableinitd thread would do eventually. To
prevent race conditions, each group is protected by the mutex.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/ext4.h   |   65 +++++++++++++
 fs/ext4/ialloc.c |   75 ++++++++++++++++
 fs/ext4/super.c  |  262 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 402 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index dbd6760..906af5d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1144,6 +1144,9 @@ struct ext4_sb_info {
 
 	/* workqueue for dio unwritten */
 	struct workqueue_struct *dio_unwritten_wq;
+
+	/* Lazy inode table initialization info */
+	struct ext4_li_info *s_li_info;
 };
 
 static inline struct ext4_sb_info *EXT4_SB(struct super_block *sb)
@@ -1467,6 +1470,66 @@ void ext4_get_group_no_and_offset(struct super_block *sb, ext4_fsblk_t blocknr,
 extern struct proc_dir_entry *ext4_proc_root;
 
 /*
+ * Timeout and state flag for lazy initialization inode thread.
+ */
+#define EXT4_LI_DEFAULT_TIMEOUT		5
+#define EXT4_LAZYINIT_QUIT		0x0001
+
+/*
+ * Lazy inode table initialization info
+ */
+struct ext4_li_info {
+	struct super_block	*li_super;
+	struct ext4_sb_info	*li_sbi;
+
+	spinlock_t		li_state_lock;
+	unsigned long		li_state;
+
+	wait_queue_head_t	li_wait_daemon;
+	wait_queue_head_t	li_wait_task;
+
+	unsigned long		li_interval;
+
+	struct timer_list	li_timer;
+	struct task_struct	*li_task;
+
+	struct mutex		*li_mtx;
+};
+
+/* Get pointer to lazyinit thread mutex li_mtx for particular group */
+static inline struct mutex *ext4_li_mutex_ptr(struct super_block *sb,
+						      ext4_group_t group)
+{
+	return &EXT4_SB(sb)->s_li_info->li_mtx[group];
+}
+
+/* Lock lazyinit thread mutex for particular thread */
+static inline void ext4_li_lock(struct super_block *sb,
+					ext4_group_t group)
+{
+	struct mutex *mtx = ext4_li_mutex_ptr(sb, group);
+	mutex_lock(mtx);
+}
+
+/* Unlock lazyinit thread mutex for particular thread */
+static inline void ext4_li_unlock(struct super_block *sb,
+					ext4_group_t group)
+{
+	struct mutex *mtx = ext4_li_mutex_ptr(sb, group);
+	mutex_unlock(mtx);
+}
+
+/*
+ * Inode table initialization is allowed if and only if
+ * s_li_info in ext4_sb_info is initialized
+ */
+static inline int ext4_itable_init_allowed(struct super_block *sb)
+{
+	struct ext4_li_info *eli = EXT4_SB(sb)->s_li_info;
+	return ((NULL == eli) ? 0 : 1);
+}
+
+/*
  * Function prototypes
  */
 
@@ -1539,6 +1602,8 @@ extern unsigned ext4_init_inode_bitmap(struct super_block *sb,
 				       ext4_group_t group,
 				       struct ext4_group_desc *desc);
 extern void mark_bitmap_end(int start_bit, int end_bit, char *bitmap);
+extern int ext4_init_inode_table(struct super_block *sb,
+				 ext4_group_t group);
 
 /* mballoc.c */
 extern long ext4_mb_stats;
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 25c4b31..df10302 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -123,6 +123,11 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 		unlock_buffer(bh);
 		return bh;
 	}
+
+	if (!(desc->bg_flags & cpu_to_le16(EXT4_BG_INODE_ZEROED)) &&
+	      ext4_itable_init_allowed(sb))
+		ext4_init_inode_table(sb, block_group);
+
 	ext4_lock_group(sb, block_group);
 	if (desc->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
 		ext4_init_inode_bitmap(sb, bh, block_group, desc);
@@ -1205,3 +1210,73 @@ unsigned long ext4_count_dirs(struct super_block * sb)
 	}
 	return count;
 }
+
+/*
+ * Initializes an uninitialized inode table - just write zeroes through
+ * the whole inode table. Must be called without group spinlock. Since
+ * this is called from itableinitd thread as well as from ext4_new_inode
+ * there are mutexes in s_li_info to prevent race conditions. Do not call
+ * this withou s_li_info uninitialized. It s_li_info is not initialized
+ * user does not want to init inode tables, or they are already zeroed.
+ */
+extern int ext4_init_inode_table(struct super_block *sb, ext4_group_t group)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_group_desc *gdp = NULL;
+	struct buffer_head *group_desc_bh;
+	handle_t *handle;
+	ext4_fsblk_t blk;
+	int num, ret = 0;
+
+	BUG_ON(NULL == sbi->s_li_info);
+
+	if (sb->s_flags & MS_RDONLY) {
+		ext4_warning(sb, "Filesystem mounter read only. "
+				 "Lazy itable initialization aborted!");
+		ret = 1;
+		return ret;
+	}
+
+	handle = ext4_journal_start_sb(sb, 1);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		return ret;
+	}
+
+	gdp = ext4_get_group_desc(sb, group, &group_desc_bh);
+	if (!gdp)
+		return ret;
+
+	blk = ext4_inode_table(sb, gdp);
+	num = sbi->s_itb_per_group - 1;
+
+	ext4_li_lock(sb, group);
+	ext4_lock_group(sb, group);
+
+	if (!(gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_ZEROED))) {
+		BUFFER_TRACE(group_desc_bh, "get_write_access");
+		ret = ext4_journal_get_write_access(handle,
+						    group_desc_bh);
+		if (ret)
+			goto err_out;
+
+		ext4_unlock_group(sb, group);
+		ret = sb_issue_zeroout(sb, blk, num);
+		ext4_lock_group(sb, group);
+		gdp->bg_flags |= cpu_to_le16(EXT4_BG_INODE_ZEROED);
+
+		gdp->bg_checksum = ext4_group_desc_csum(sbi, group, gdp);
+		BUFFER_TRACE(group_desc_bh,
+			     "call ext4_handle_dirty_metadata");
+		ret = ext4_handle_dirty_metadata(handle, NULL,
+						 group_desc_bh);
+		ext4_debug("zero out inode table in group %d\n", group);
+	}
+
+err_out:
+	ext4_unlock_group(sb, group);
+	ext4_li_unlock(sb, group);
+	ext4_journal_stop(handle);
+
+	return ret;
+}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 515e306..84a5993 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -41,6 +41,10 @@
 #include <linux/crc16.h>
 #include <asm/uaccess.h>
 
+
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+
 #include "ext4.h"
 #include "ext4_jbd2.h"
 #include "xattr.h"
@@ -70,6 +74,7 @@ static void ext4_write_super(struct super_block *sb);
 static int ext4_freeze(struct super_block *sb);
 static int ext4_get_sb(struct file_system_type *fs_type, int flags,
 		       const char *dev_name, void *data, struct vfsmount *mnt);
+static void ext4_destroy_lazyinit_thread(struct super_block *sb);
 
 #if !defined(CONFIG_EXT3_FS) && !defined(CONFIG_EXT3_FS_MODULE) && defined(CONFIG_EXT4_USE_FOR_EXT23)
 static struct file_system_type ext3_fs_type = {
@@ -664,6 +669,7 @@ static void ext4_put_super(struct super_block *sb)
 				   "Couldn't clean up the journal");
 	}
 
+	ext4_destroy_lazyinit_thread(sb);
 	ext4_release_system_zone(sb);
 	ext4_mb_release(sb);
 	ext4_ext_release(sb);
@@ -2443,6 +2449,244 @@ static int ext4_feature_set_ok(struct super_block *sb, int readonly)
 	return 1;
 }
 
+static void ext4_lazyinode_timeout(unsigned long data)
+{
+	struct task_struct *p = (struct task_struct *)data;
+	wake_up_process(p);
+}
+
+/*
+ * This is called from itableinitd thread. Its purpose in life is to
+ * initialize (zero out) uninitialized inode tables. It walks through
+ * allocation groups searching for uninitialized inode table. When such
+ * a group is found it calls ext4_init_table and then puts itself into
+ * sleep for defined number seconds so it does not disturb other ongoing
+ * IO.
+ */
+static int ext4_lazyinit_thread(void *arg)
+{
+	struct ext4_li_info *eli = (struct ext4_li_info *)arg;
+	ext4_group_t group, ngroups;
+	struct ext4_group_desc *gdp = NULL;
+	struct super_block *sb;
+	int timeout = 0, ret;
+
+	BUG_ON(NULL == eli);
+
+	sb = eli->li_super;
+	ngroups = EXT4_SB(sb)->s_groups_count;
+	eli->li_timer.data = (unsigned long)current;
+	eli->li_timer.function = ext4_lazyinode_timeout;
+
+	eli->li_task = current;
+	wake_up(&eli->li_wait_task);
+
+	ext4_msg(sb, KERN_INFO,
+		"itableinitd starting. Wakeup interval = %lu seconds.",
+		eli->li_interval / HZ);
+
+	spin_lock(&eli->li_state_lock);
+	for (group = 0; group < ngroups; group++) {
+
+		if (eli->li_state & EXT4_LAZYINIT_QUIT)
+			break;
+
+		gdp = ext4_get_group_desc(sb, group, NULL);
+		if (!gdp)
+			continue;
+
+		if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_ZEROED))
+			continue;
+
+		ret = ext4_init_inode_table(sb, group);
+		if (ret)
+			goto exit_thread;
+
+		eli->li_timer.expires = jiffies + eli->li_interval;
+		add_timer(&eli->li_timer);
+
+		if (freezing(current)) {
+			spin_unlock(&eli->li_state_lock);
+			refrigerator();
+			spin_lock(&eli->li_state_lock);
+		} else {
+			DEFINE_WAIT(wait);
+
+			prepare_to_wait(&eli->li_wait_daemon, &wait,
+					TASK_INTERRUPTIBLE);
+
+			spin_unlock(&eli->li_state_lock);
+			schedule();
+			spin_lock(&eli->li_state_lock);
+
+			finish_wait(&eli->li_wait_daemon, &wait);
+			timeout = time_after_eq(jiffies, eli->li_timer.expires);
+		}
+	}
+
+exit_thread:
+	spin_unlock(&eli->li_state_lock);
+
+	eli->li_task = NULL;
+	wake_up(&eli->li_wait_task);
+	return 0;
+}
+
+static int ext4_lazyinit_start_thread(struct ext4_li_info *eli)
+{
+	struct task_struct *t;
+
+	t = kthread_run(ext4_lazyinit_thread, eli, "itableinitd");
+	if (IS_ERR(t)) {
+		int err = PTR_ERR(t);
+
+		printk(KERN_CRIT "EXT4: error %d creating inode table "
+				 "initialization thread\n",
+		       err);
+		return err;
+	}
+	wait_event(eli->li_wait_task, eli->li_task != NULL);
+	return 0;
+}
+
+/*
+ * Initialize new ext4_li_info structure */
+static struct ext4_li_info *ext4_lazyinit_new(struct super_block *sb)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	ext4_group_t i, ngroups = sbi->s_groups_count;
+	struct ext4_li_info *eli;
+
+	eli = kzalloc(sizeof(*eli), GFP_KERNEL);
+	if (!eli)
+		return NULL;
+
+	eli->li_mtx = kzalloc(ngroups * sizeof(struct mutex),
+				       GFP_KERNEL);
+	if (!eli->li_mtx)
+		goto free_eli;
+
+	for (i = 0; i < ngroups; i++)
+		mutex_init(&eli->li_mtx[i]);
+
+	eli->li_sbi = sbi;
+	eli->li_super = sb;
+
+	init_waitqueue_head(&eli->li_wait_daemon);
+	init_waitqueue_head(&eli->li_wait_task);
+	spin_lock_init(&eli->li_state_lock);
+	init_timer(&eli->li_timer);
+
+	eli->li_interval = HZ * EXT4_LI_DEFAULT_TIMEOUT;
+
+	return eli;
+
+free_eli:
+	kfree(eli);
+	return NULL;
+}
+
+/*
+ * Check whether it make sense to run itableinitd or not.
+ * If there is at least one uninitialized inode table, return 1,
+ * else return 0.
+ */
+static int ext4_has_uninit_itable(struct super_block *sb)
+{
+	ext4_group_t i, ngroups = EXT4_SB(sb)->s_groups_count;
+	struct ext4_group_desc *gdp = NULL;
+	int ret = 1;
+
+	for (i = 0; i < ngroups; i++) {
+		gdp = ext4_get_group_desc(sb, i, NULL);
+		if (!gdp)
+			continue;
+
+		if (!(gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_ZEROED)))
+			goto has_uinit_itb;
+	}
+	ret = 0;
+
+has_uinit_itb:
+	return ret;
+}
+
+static int ext4_create_lazyinit_thread(struct super_block *sb)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	int ret = 0;
+
+	if ((sb->s_flags & MS_RDONLY) ||
+	     !test_opt(sb, INIT_INODE_TABLE) ||
+	     sbi->s_li_info ||
+	     !ext4_has_uninit_itable(sb)) {
+		sbi->s_li_info = NULL;
+		goto out;
+	}
+
+	sbi->s_li_info = ext4_lazyinit_new(sb);
+	if (!sbi->s_li_info) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = ext4_lazyinit_start_thread(sbi->s_li_info);
+	if (ret) {
+		kfree(sbi->s_li_info);
+		sbi->s_li_info = NULL;
+	}
+out:
+	return ret;
+}
+
+static void ext4_stop_lazyinit_thread(struct ext4_li_info *eli)
+{
+	eli->li_state |= EXT4_LAZYINIT_QUIT;
+
+	while (eli->li_task) {
+		wake_up(&eli->li_wait_daemon);
+		spin_unlock(&eli->li_state_lock);
+		wait_event(eli->li_wait_task, eli->li_task == NULL);
+		spin_lock(&eli->li_state_lock);
+	}
+}
+
+static void ext4_destroy_lazyinit_thread(struct super_block *sb)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_li_info *eli = sbi->s_li_info;
+	ext4_group_t i, ngroups = sbi->s_groups_count;
+
+	/*
+	 * If itableinitd thread exited earlier
+	 * there's nothing to be done.
+	 */
+	if (!eli)
+		return;
+
+	spin_lock(&eli->li_state_lock);
+	ext4_stop_lazyinit_thread(eli);
+	spin_unlock(&eli->li_state_lock);
+
+	del_timer_sync(&eli->li_timer);
+
+	/*
+	 * Acquire all semaphores, detach s_li_info from ext4_sb_info,
+	 * drop all semaphores (because of lockdep) and then we can safely
+	 * free the ext4_li_info structure.
+	 */
+	for (i = 0; i < ngroups; i++)
+		mutex_lock(&eli->li_mtx[i]);
+
+	sbi->s_li_info = NULL;
+
+	for (i = 0; i < ngroups; i++)
+		mutex_unlock(&eli->li_mtx[i]);
+
+	kfree(eli->li_mtx);
+	kfree(eli);
+}
+
 static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 				__releases(kernel_lock)
 				__acquires(kernel_lock)
@@ -3037,6 +3281,11 @@ no_journal:
 		goto failed_mount4;
 	};
 
+	err = ext4_create_lazyinit_thread(sb);
+	if (err)
+		ext4_msg(sb, KERN_ERR, "failed to initalize itableinitd (%d)",
+			 err);
+
 	EXT4_SB(sb)->s_mount_state |= EXT4_ORPHAN_FS;
 	ext4_orphan_cleanup(sb, es);
 	EXT4_SB(sb)->s_mount_state &= ~EXT4_ORPHAN_FS;
@@ -3723,6 +3972,19 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 			enable_quota = 1;
 		}
 	}
+
+	/*
+	 * Reinitialize lazy itable initialization thread based on
+	 * current settings
+	 */
+	ext4_destroy_lazyinit_thread(sb);
+	err = ext4_create_lazyinit_thread(sb);
+	if (err) {
+		ext4_msg(sb, KERN_ERR,
+			"failed to initalize itableinitd (%d)",
+			 err);
+	}
+
 	ext4_setup_system_zone(sb);
 	if (sbi->s_journal == NULL)
 		ext4_commit_super(sb, 1);
-- 
1.7.2.1

