From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 3/6] Add inode table initialization code for Ext4
Date: Wed, 15 Sep 2010 18:36:05 +0200
Message-ID: <1284568568-13637-4-git-send-email-lczerner@redhat.com>
References: <1284568568-13637-1-git-send-email-lczerner@redhat.com>
Cc: tytso@mit.edu, rwheeler@redhat.com, sandeen@redhat.com,
	adilger@dilger.ca, lczerner@redhat.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab0IOQg2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Sep 2010 12:36:28 -0400
In-Reply-To: <1284568568-13637-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When lazy_itable_init extended option is passed to mke2fs, it
considerably speed up filesystem creation because inode tables are
not zeroed out, thus contains some old data. When this fs is mounted
filesystem code should initialize (zero out) inode tables.
So far this code was missing for ext4 and this patch adds this feature.

For purpose of zeroing inode tables it introduces new kernel thread
called ext4lazyinit, which is created on demand and destroyed, when it
is no longer needed. There is only one thread for all ext4
filesystems in the system. When the first filesystem with inititable
mount option is mounted, ext4lazyinit thread is created, then the
filesystem can register its request in the request list.

This thread then walks through the list of requests picking up scheduled
requests and invoking ext4_init_inode_table(). Next schedule time for
the request is computed by multiplying the time it took to zero out last
inode table with wait multiplier, which can be set with the
(inititable=n) mount option (default is 10). We are doing this so we do
not take the whole I/O bandwidth. When the thread is no longer
necessary (request list is empty) it frees the appropriate structures and
exits (and can be created later later by another filesystem).

We do not disturb regular inode allocations in any way, it just do not
care whether the inode table is, or is not zeroed. But when zeroing, we
have to skip used inodes, obviously. Also we should prevent new inode
allocations from the group, while zeroing is on the way. For that we
take write alloc_sem lock in ext4_init_inode_table() and read alloc_sem
in the ext4_claim_inode, so when we are unlucky and allocator hits the
group which is currently being zeroed, it just has to wait.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/ext4.h   |   38 +++++
 fs/ext4/ialloc.c |  116 +++++++++++++++
 fs/ext4/super.c  |  418 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 569 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index dbd6760..0df3977 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1144,6 +1144,11 @@ struct ext4_sb_info {
 
 	/* workqueue for dio unwritten */
 	struct workqueue_struct *dio_unwritten_wq;
+
+	/* Lazy inode table initialization info */
+	struct ext4_li_request *s_li_request;
+	/* Wait multiplier for lazy initialization thread */
+	unsigned int s_li_wait_mult;
 };
 
 static inline struct ext4_sb_info *EXT4_SB(struct super_block *sb)
@@ -1467,6 +1472,37 @@ void ext4_get_group_no_and_offset(struct super_block *sb, ext4_fsblk_t blocknr,
 extern struct proc_dir_entry *ext4_proc_root;
 
 /*
+ * Timeout and state flag for lazy initialization inode thread.
+ */
+#define EXT4_DEF_LI_WAIT_MULT			10
+#define EXT4_DEF_LI_MAX_START_DELAY		5
+#define EXT4_LAZYINIT_QUIT			0x0001
+#define EXT4_LAZYINIT_RUNNING			0x0002
+
+/*
+ * Lazy inode table initialization info
+ */
+struct ext4_lazy_init {
+	unsigned long		li_state;
+
+	wait_queue_head_t	li_wait_daemon;
+	wait_queue_head_t	li_wait_task;
+	struct timer_list	li_timer;
+	struct task_struct	*li_task;
+
+	struct list_head	li_request_list;
+	struct mutex		li_list_mtx;
+};
+
+struct ext4_li_request {
+	struct super_block	*lr_super;
+	struct ext4_sb_info	*lr_sbi;
+	ext4_group_t		lr_next_group;
+	struct list_head	lr_request;
+	unsigned long		lr_next_sched;
+};
+
+/*
  * Function prototypes
  */
 
@@ -1539,6 +1575,8 @@ extern unsigned ext4_init_inode_bitmap(struct super_block *sb,
 				       ext4_group_t group,
 				       struct ext4_group_desc *desc);
 extern void mark_bitmap_end(int start_bit, int end_bit, char *bitmap);
+extern int ext4_init_inode_table(struct super_block *sb,
+				 ext4_group_t group);
 
 /* mballoc.c */
 extern long ext4_mb_stats;
diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
index 25c4b31..08d2df3 100644
--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -107,6 +107,7 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 	desc = ext4_get_group_desc(sb, block_group, NULL);
 	if (!desc)
 		return NULL;
+
 	bitmap_blk = ext4_inode_bitmap(sb, desc);
 	bh = sb_getblk(sb, bitmap_blk);
 	if (unlikely(!bh)) {
@@ -123,6 +124,7 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 		unlock_buffer(bh);
 		return bh;
 	}
+
 	ext4_lock_group(sb, block_group);
 	if (desc->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)) {
 		ext4_init_inode_bitmap(sb, bh, block_group, desc);
@@ -133,6 +135,7 @@ ext4_read_inode_bitmap(struct super_block *sb, ext4_group_t block_group)
 		return bh;
 	}
 	ext4_unlock_group(sb, block_group);
+
 	if (buffer_uptodate(bh)) {
 		/*
 		 * if not uninit if bh is uptodate,
@@ -712,8 +715,17 @@ static int ext4_claim_inode(struct super_block *sb,
 {
 	int free = 0, retval = 0, count;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_group_info *grp = ext4_get_group_info(sb, group);
 	struct ext4_group_desc *gdp = ext4_get_group_desc(sb, group, NULL);
 
+	/*
+	 * We have to be sure that new inode allocation does not race with
+	 * inode table initialization, because otherwise we may end up
+	 * allocating and writing new inode right before sb_issue_zeroout
+	 * takes place and overwriting our new inode with zeroes. So we
+	 * take alloc_sem to prevent it.
+	 */
+	down_read(&grp->alloc_sem);
 	ext4_lock_group(sb, group);
 	if (ext4_set_bit(ino, inode_bitmap_bh->b_data)) {
 		/* not a free inode */
@@ -724,6 +736,7 @@ static int ext4_claim_inode(struct super_block *sb,
 	if ((group == 0 && ino < EXT4_FIRST_INO(sb)) ||
 			ino > EXT4_INODES_PER_GROUP(sb)) {
 		ext4_unlock_group(sb, group);
+		up_read(&grp->alloc_sem);
 		ext4_error(sb, "reserved inode or inode > inodes count - "
 			   "block_group = %u, inode=%lu", group,
 			   ino + group * EXT4_INODES_PER_GROUP(sb));
@@ -772,6 +785,7 @@ static int ext4_claim_inode(struct super_block *sb,
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, group, gdp);
 err_ret:
 	ext4_unlock_group(sb, group);
+	up_read(&grp->alloc_sem);
 	return retval;
 }
 
@@ -1205,3 +1219,105 @@ unsigned long ext4_count_dirs(struct super_block * sb)
 	}
 	return count;
 }
+
+/*
+ * Zeroes not yet zeroed inode table - just write zeroes through the whole
+ * inode table. Must be called without any spinlock held. The only place
+ * where it is called from on active part of filesystem is ext4lazyinit
+ * thread, so we do not need any special locks, however we have to prevent
+ * inode allocation from the current group, so we take alloc_sem lock, to
+ * block ext4_claim_inode until we are finished.
+ */
+extern int ext4_init_inode_table(struct super_block *sb, ext4_group_t group)
+{
+	struct ext4_group_info *grp = ext4_get_group_info(sb, group);
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_group_desc *gdp = NULL;
+	struct buffer_head *group_desc_bh;
+	handle_t *handle;
+	ext4_fsblk_t blk;
+	int num, ret = 0, used_blks = 0;
+
+	/* This should not happen, but just to be sure check this */
+	if (sb->s_flags & MS_RDONLY) {
+		ret = 1;
+		goto out;
+	}
+
+	gdp = ext4_get_group_desc(sb, group, &group_desc_bh);
+	if (!gdp)
+		goto out;
+
+	/*
+	 * We do not need to lock this, because we are the only one
+	 * handling this flag.
+	 */
+	if (gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_ZEROED))
+		goto out;
+
+	handle = ext4_journal_start_sb(sb, 1);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out;
+	}
+
+	down_write(&grp->alloc_sem);
+	/*
+	 * If inode bitmap was already initialized there may be some
+	 * used inodes so we need to skip blocks with used inodes in
+	 * inode table.
+	 */
+	if (!(gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_UNINIT)))
+		used_blks = DIV_ROUND_UP((EXT4_INODES_PER_GROUP(sb) -
+			    ext4_itable_unused_count(sb, gdp)),
+			    sbi->s_inodes_per_block);
+
+	blk = ext4_inode_table(sb, gdp) + used_blks;
+	num = sbi->s_itb_per_group - used_blks;
+
+	BUFFER_TRACE(group_desc_bh, "get_write_access");
+	ret = ext4_journal_get_write_access(handle,
+					    group_desc_bh);
+	if (ret)
+		goto err_out;
+
+	if (unlikely(num > EXT4_INODES_PER_GROUP(sb))) {
+		ext4_error(sb, "Something is wrong with group %u\n"
+			   "Used itable blocks: %d"
+			   "Itable blocks per group: %lu\n",
+			   group, used_blks, sbi->s_itb_per_group);
+		ret = 1;
+		goto err_out;
+	}
+
+	/*
+	 * Skip zeroout if the inode table is full. But we set the ZEROED
+	 * flag anyway, because obviously, when it is full it does not need
+	 * further zeroing.
+	 */
+	if (unlikely(num == 0))
+		goto skip_zeroout;
+
+	ext4_debug("going to zero out inode table in group %d\n",
+		   group);
+	ret = sb_issue_zeroout(sb, blk, num);
+	if (ret < 0)
+		goto err_out;
+
+skip_zeroout:
+	ext4_lock_group(sb, group);
+	gdp->bg_flags |= cpu_to_le16(EXT4_BG_INODE_ZEROED);
+	gdp->bg_checksum = ext4_group_desc_csum(sbi, group, gdp);
+	ext4_unlock_group(sb, group);
+
+	BUFFER_TRACE(group_desc_bh,
+		     "call ext4_handle_dirty_metadata");
+	ret = ext4_handle_dirty_metadata(handle, NULL,
+					 group_desc_bh);
+
+err_out:
+	up_write(&grp->alloc_sem);
+	ext4_journal_stop(handle);
+out:
+	return ret;
+}
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3dbae36..3e285eb 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -41,6 +41,9 @@
 #include <linux/crc16.h>
 #include <asm/uaccess.h>
 
+#include <linux/kthread.h>
+#include <linux/freezer.h>
+
 #include "ext4.h"
 #include "ext4_jbd2.h"
 #include "xattr.h"
@@ -52,6 +55,8 @@
 
 struct proc_dir_entry *ext4_proc_root;
 static struct kset *ext4_kset;
+struct ext4_lazy_init *ext4_li_info;
+struct mutex ext4_li_mtx;
 
 static int ext4_load_journal(struct super_block *, struct ext4_super_block *,
 			     unsigned long journal_devnum);
@@ -70,6 +75,8 @@ static void ext4_write_super(struct super_block *sb);
 static int ext4_freeze(struct super_block *sb);
 static int ext4_get_sb(struct file_system_type *fs_type, int flags,
 		       const char *dev_name, void *data, struct vfsmount *mnt);
+static void ext4_destroy_lazyinit_thread(void);
+static void ext4_unregister_li_request(struct super_block *sb);
 
 #if !defined(CONFIG_EXT3_FS) && !defined(CONFIG_EXT3_FS_MODULE) && defined(CONFIG_EXT4_USE_FOR_EXT23)
 static struct file_system_type ext3_fs_type = {
@@ -664,6 +671,7 @@ static void ext4_put_super(struct super_block *sb)
 				   "Couldn't clean up the journal");
 	}
 
+	ext4_unregister_li_request(sb);
 	ext4_release_system_zone(sb);
 	ext4_mb_release(sb);
 	ext4_ext_release(sb);
@@ -1904,7 +1912,8 @@ int ext4_group_desc_csum_verify(struct ext4_sb_info *sbi, __u32 block_group,
 }
 
 /* Called at mount-time, super-block is locked */
-static int ext4_check_descriptors(struct super_block *sb)
+static int ext4_check_descriptors(struct super_block *sb,
+				  ext4_group_t *first_not_zeroed)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	ext4_fsblk_t first_block = le32_to_cpu(sbi->s_es->s_first_data_block);
@@ -1913,7 +1922,7 @@ static int ext4_check_descriptors(struct super_block *sb)
 	ext4_fsblk_t inode_bitmap;
 	ext4_fsblk_t inode_table;
 	int flexbg_flag = 0;
-	ext4_group_t i;
+	ext4_group_t i, grp = sbi->s_groups_count;
 
 	if (EXT4_HAS_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_FLEX_BG))
 		flexbg_flag = 1;
@@ -1929,6 +1938,10 @@ static int ext4_check_descriptors(struct super_block *sb)
 			last_block = first_block +
 				(EXT4_BLOCKS_PER_GROUP(sb) - 1);
 
+		if ((grp == sbi->s_groups_count) &&
+		   !(gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_ZEROED)))
+			grp = i;
+
 		block_bitmap = ext4_block_bitmap(sb, gdp);
 		if (block_bitmap < first_block || block_bitmap > last_block) {
 			ext4_msg(sb, KERN_ERR, "ext4_check_descriptors: "
@@ -1966,6 +1979,8 @@ static int ext4_check_descriptors(struct super_block *sb)
 		if (!flexbg_flag)
 			first_block += EXT4_BLOCKS_PER_GROUP(sb);
 	}
+	if (NULL != first_not_zeroed)
+		*first_not_zeroed = grp;
 
 	ext4_free_blocks_count_set(sbi->s_es, ext4_count_free_blocks(sb));
 	sbi->s_es->s_free_inodes_count =cpu_to_le32(ext4_count_free_inodes(sb));
@@ -2453,6 +2468,381 @@ static int ext4_feature_set_ok(struct super_block *sb, int readonly)
 	return 1;
 }
 
+static void ext4_lazyinode_timeout(unsigned long data)
+{
+	struct task_struct *p = (struct task_struct *)data;
+	wake_up_process(p);
+}
+
+/* Find next suitable group adn run ext4_init_inode_table */
+static int ext4_run_li_request(struct ext4_li_request *elr)
+{
+	struct ext4_group_desc *gdp = NULL;
+	ext4_group_t group, ngroups;
+	struct super_block *sb;
+	int ret = 0;
+
+	sb = elr->lr_super;
+	ngroups = EXT4_SB(sb)->s_groups_count;
+
+	printk(KERN_CRIT "next is -%d\n", elr->lr_next_group+1);
+	for (group = elr->lr_next_group; group < ngroups; group++) {
+		gdp = ext4_get_group_desc(sb, group, NULL);
+		if (!gdp) {
+			ret = 1;
+			break;
+		}
+
+		if (!(gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_ZEROED)))
+			break;
+	}
+
+	if (group == ngroups)
+		ret = 1;
+	
+	printk(KERN_CRIT "Going to zeroout group %d next is %d\n",group, elr->lr_next_group+1);
+	if (!ret) {
+		ret = ext4_init_inode_table(sb, group);
+		elr->lr_next_group = group + 1;
+	}
+
+	return ret;
+}
+
+/*
+ * Remove lr_request from the list_request and free the
+ * request tructure. Should be called with li_list_mtx held
+ */
+static void ext4_remove_li_request(struct ext4_li_request *elr)
+{
+	struct ext4_sb_info *sbi;
+
+	if (!elr)
+		return;
+
+	sbi = elr->lr_sbi;
+
+	list_del(&elr->lr_request);
+	sbi->s_li_request = NULL;
+	kfree(elr);
+}
+
+static void ext4_unregister_li_request(struct super_block *sb)
+{
+	struct ext4_li_request *elr = EXT4_SB(sb)->s_li_request;
+
+	if (!ext4_li_info)
+		return;
+
+	mutex_lock(&ext4_li_info->li_list_mtx);
+	ext4_remove_li_request(elr);
+	mutex_unlock(&ext4_li_info->li_list_mtx);
+}
+
+/*
+ * This is the function where ext4lazyinit thread lives. It walks
+ * through the request list searching for next scheduled filesystem.
+ * When such a fs is found, run the lazy initialization request
+ * (ext4_rn_li_request) and keep track of the time spend in this
+ * function. Based on that time we compute next schedule time of
+ * the request. When walking through the list is complete, compute
+ * next waking time and put itself into sleep.
+ */
+static int ext4_lazyinit_thread(void *arg)
+{
+	struct ext4_lazy_init *eli = (struct ext4_lazy_init *)arg;
+	struct list_head *pos, *n;
+	struct ext4_li_request *elr;
+	struct ext4_sb_info *sbi;
+	unsigned long next_wakeup;
+	unsigned long timeout = 0;
+	int ret;
+
+	BUG_ON(NULL == eli);
+
+	eli->li_timer.data = (unsigned long)current;
+	eli->li_timer.function = ext4_lazyinode_timeout;
+
+	eli->li_task = current;
+	wake_up(&eli->li_wait_task);
+
+cont_thread:
+	while (true) {
+		next_wakeup = ULONG_MAX;
+
+		mutex_lock(&eli->li_list_mtx);
+		if (list_empty(&eli->li_request_list)) {
+			mutex_unlock(&eli->li_list_mtx);
+			goto exit_thread;
+		}
+
+		list_for_each_safe(pos, n, &eli->li_request_list) {
+			elr = list_entry(pos, struct ext4_li_request,
+					 lr_request);
+
+			if (time_before_eq(jiffies, elr->lr_next_sched))
+				continue;
+			sbi = elr->lr_sbi;
+
+			timeout = jiffies;
+			ret = ext4_run_li_request(elr);
+			timeout = (jiffies - timeout) * sbi->s_li_wait_mult;
+
+			if (ret) {
+				ext4_remove_li_request(elr);
+				continue;
+			}
+
+			elr->lr_next_sched = jiffies + timeout;
+			if (elr->lr_next_sched < next_wakeup)
+				next_wakeup = elr->lr_next_sched;
+		}
+		mutex_unlock(&eli->li_list_mtx);
+
+		/*
+		 * We need to check this otherwise we may end up sleeping
+		 * for very long time.
+		 */
+		if (jiffies >= next_wakeup) {
+			cond_resched();
+			continue;
+		}
+
+		eli->li_timer.expires = next_wakeup;
+		add_timer(&eli->li_timer);
+
+		if (freezing(current)) {
+			refrigerator();
+		} else {
+			DEFINE_WAIT(wait);
+			prepare_to_wait(&eli->li_wait_daemon, &wait,
+					TASK_INTERRUPTIBLE);
+			schedule();
+			finish_wait(&eli->li_wait_daemon, &wait);
+		}
+	}
+
+exit_thread:
+	/*
+	 * It looks like the request list is empty, but we need
+	 * to check it under the li_list_mtx lock, to prevent any
+	 * additions into it, and of course we should lock ext4_li_mtx
+	 * to atomically free the list and ext4_li_info, because at
+	 * this point another ext4 filesystem could be registering
+	 * new one.
+	 */
+	mutex_lock(&ext4_li_mtx);
+	mutex_lock(&eli->li_list_mtx);
+	if (!list_empty(&eli->li_request_list)) {
+		mutex_unlock(&eli->li_list_mtx);
+		mutex_unlock(&ext4_li_mtx);
+		goto cont_thread;
+	}
+	mutex_unlock(&eli->li_list_mtx);
+	del_timer_sync(&ext4_li_info->li_timer);
+	eli->li_task = NULL;
+	wake_up(&eli->li_wait_task);
+
+	kfree(ext4_li_info);
+	ext4_li_info = NULL;
+	mutex_unlock(&ext4_li_mtx);
+
+	printk(KERN_CRIT "Thread exiting\n");
+	return 0;
+}
+
+static void ext4_clear_request_list(void)
+{
+	struct list_head *pos, *n;
+	struct ext4_li_request *elr;
+
+	mutex_lock(&ext4_li_info->li_list_mtx);
+	if (list_empty(&ext4_li_info->li_request_list))
+		return;
+
+	list_for_each_safe(pos, n, &ext4_li_info->li_request_list) {
+		elr = list_entry(pos, struct ext4_li_request,
+				 lr_request);
+		ext4_remove_li_request(elr);
+	}
+	mutex_unlock(&ext4_li_info->li_list_mtx);
+}
+
+static int ext4_run_lazyinit_thread(void)
+{
+	struct task_struct *t;
+
+	t = kthread_run(ext4_lazyinit_thread, ext4_li_info, "ext4lazyinit");
+	if (IS_ERR(t)) {
+		int err = PTR_ERR(t);
+		ext4_clear_request_list();
+		del_timer_sync(&ext4_li_info->li_timer);
+		kfree(ext4_li_info);
+		ext4_li_info = NULL;
+		printk(KERN_CRIT "EXT4: error %d creating inode table "
+				 "initialization thread\n",
+				 err);
+		return err;
+	}
+	ext4_li_info->li_state |= EXT4_LAZYINIT_RUNNING;
+
+	wait_event(ext4_li_info->li_wait_task, ext4_li_info->li_task != NULL);
+	return 0;
+}
+
+/*
+ * Check whether it make sense to run itable init. thread or not.
+ * If there is at least one uninitialized inode table, return
+ * corresponding group number, else the loop goes through all
+ * groups and return total number of groups.
+ */
+static ext4_group_t ext4_has_uninit_itable(struct super_block *sb)
+{
+	ext4_group_t group, ngroups = EXT4_SB(sb)->s_groups_count;
+	struct ext4_group_desc *gdp = NULL;
+
+	for (group = 0; group < ngroups; group++) {
+		gdp = ext4_get_group_desc(sb, group, NULL);
+		if (!gdp)
+			continue;
+
+		if (!(gdp->bg_flags & cpu_to_le16(EXT4_BG_INODE_ZEROED)))
+			break;
+	}
+
+	return group;
+}
+
+static int ext4_li_info_new(void)
+{
+	struct ext4_lazy_init *eli = NULL;
+
+	eli = kzalloc(sizeof(*eli), GFP_KERNEL);
+	if (!eli)
+		return -ENOMEM;
+
+	eli->li_task = NULL;
+	INIT_LIST_HEAD(&eli->li_request_list);
+	mutex_init(&eli->li_list_mtx);
+
+	init_waitqueue_head(&eli->li_wait_daemon);
+	init_waitqueue_head(&eli->li_wait_task);
+	init_timer(&eli->li_timer);
+	eli->li_state |= EXT4_LAZYINIT_QUIT;
+
+	ext4_li_info = eli;
+
+	return 0;
+}
+
+static struct ext4_li_request *ext4_li_request_new(struct super_block *sb,
+					    ext4_group_t start)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_li_request *elr;
+	unsigned long rnd;
+
+	elr = kzalloc(sizeof(*elr), GFP_KERNEL);
+	if (!elr)
+		return NULL;
+
+	elr->lr_super = sb;
+	elr->lr_sbi = sbi;
+	elr->lr_next_group = start;
+
+	/*
+	 * Randomize first schedule time of the request to
+	 * spread the inode table initialization requests
+	 * better.
+	 */
+	get_random_bytes(&rnd, sizeof(rnd));
+	elr->lr_next_sched = jiffies + (unsigned long)rnd %
+			     (EXT4_DEF_LI_MAX_START_DELAY * HZ);
+
+	return elr;
+}
+
+static int ext4_register_li_request(struct super_block *sb,
+				    ext4_group_t first_not_zeroed)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_li_request *elr;
+	ext4_group_t ngroups = EXT4_SB(sb)->s_groups_count;
+	int ret = 0;
+
+	if (sbi->s_li_request != NULL)
+		goto out;
+
+	if (first_not_zeroed == ngroups ||
+	    (sb->s_flags & MS_RDONLY) ||
+	    !test_opt(sb, INIT_INODE_TABLE)) {
+		sbi->s_li_request = NULL;
+		goto out;
+	}
+
+	if (first_not_zeroed == ngroups) {
+		sbi->s_li_request = NULL;
+		goto out;
+	}
+	
+	elr = ext4_li_request_new(sb, first_not_zeroed);
+	if (!elr) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	mutex_lock(&ext4_li_mtx);
+
+	if (NULL == ext4_li_info) {
+		ret = ext4_li_info_new();
+		if (ret)
+			goto out;
+	}
+
+	mutex_lock(&ext4_li_info->li_list_mtx);
+	list_add(&elr->lr_request, &ext4_li_info->li_request_list);
+	mutex_unlock(&ext4_li_info->li_list_mtx);
+
+	sbi->s_li_request = elr;
+
+	if (!(ext4_li_info->li_state & EXT4_LAZYINIT_RUNNING)) {
+		ret = ext4_run_lazyinit_thread();
+		if (ret)
+			goto out;
+	}
+
+	mutex_unlock(&ext4_li_mtx);
+
+out:
+	if (ret) {
+		mutex_unlock(&ext4_li_mtx);
+		kfree(elr);
+	}
+	return ret;
+}
+
+/*
+ * We do not need to lock anything since this is called on
+ * module unload.
+ */
+static void ext4_destroy_lazyinit_thread(void)
+{
+	/*
+	 * If thread exited earlier
+	 * there's nothing to be done.
+	 */
+	if (!ext4_li_info)
+		return;
+	
+	ext4_clear_request_list();
+
+	while (ext4_li_info->li_task) {
+		wake_up(&ext4_li_info->li_wait_daemon);
+		wait_event(ext4_li_info->li_wait_task,
+			   ext4_li_info->li_task == NULL);
+	}
+}
+
 static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 				__releases(kernel_lock)
 				__acquires(kernel_lock)
@@ -2478,6 +2868,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	__u64 blocks_count;
 	int err;
 	unsigned int journal_ioprio = DEFAULT_JOURNAL_IOPRIO;
+	ext4_group_t first_not_zeroed;
 
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
@@ -2805,7 +3196,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 			goto failed_mount2;
 		}
 	}
-	if (!ext4_check_descriptors(sb)) {
+	if (!ext4_check_descriptors(sb, &first_not_zeroed)) {
 		ext4_msg(sb, KERN_ERR, "group descriptors corrupted!");
 		goto failed_mount2;
 	}
@@ -3037,6 +3428,10 @@ no_journal:
 		goto failed_mount4;
 	}
 
+	err = ext4_register_li_request(sb, first_not_zeroed);
+	if (err)
+		goto failed_mount4;
+
 	sbi->s_kobj.kset = ext4_kset;
 	init_completion(&sbi->s_kobj_unregister);
 	err = kobject_init_and_add(&sbi->s_kobj, &ext4_ktype, NULL,
@@ -3733,6 +4128,19 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 			enable_quota = 1;
 		}
 	}
+
+	/*
+	 * Reinitialize lazy itable initialization thread based on
+	 * current settings
+	 */
+	if ((sb->s_flags & MS_RDONLY) || !test_opt(sb, INIT_INODE_TABLE))
+		ext4_unregister_li_request(sb);
+	else {
+		ext4_group_t first_not_zeroed;
+		first_not_zeroed = ext4_has_uninit_itable(sb);
+		ext4_register_li_request(sb, first_not_zeroed);
+	}
+
 	ext4_setup_system_zone(sb);
 	if (sbi->s_journal == NULL)
 		ext4_commit_super(sb, 1);
@@ -4200,6 +4608,9 @@ static int __init init_ext4_fs(void)
 	err = register_filesystem(&ext4_fs_type);
 	if (err)
 		goto out;
+
+	ext4_li_info = NULL;
+	mutex_init(&ext4_li_mtx);
 	return 0;
 out:
 	unregister_as_ext2();
@@ -4219,6 +4630,7 @@ out4:
 
 static void __exit exit_ext4_fs(void)
 {
+	ext4_destroy_lazyinit_thread();
 	unregister_as_ext2();
 	unregister_as_ext3();
 	unregister_filesystem(&ext4_fs_type);
-- 
1.7.2.2

