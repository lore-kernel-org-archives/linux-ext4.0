From: Jan Kara <jack@suse.cz>
Subject: [PATCH 21/29] ext4: Split extent conversion lists to reserved & unreserved parts
Date: Mon,  8 Apr 2013 23:32:26 +0200
Message-ID: <1365456754-29373-22-git-send-email-jack@suse.cz>
References: <1365456754-29373-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53397 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936345Ab3DHVdH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Apr 2013 17:33:07 -0400
In-Reply-To: <1365456754-29373-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Now that we have extent conversions with reserved transaction, we have
to prevent extent conversions without reserved transaction (from DIO
code) to block these (as that would effectively void any transaction
reservation we did). So split lists, work items, and work queues to
reserved and unreserved parts.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h    |   25 +++++++++++++++++-----
 fs/ext4/page-io.c |   59 ++++++++++++++++++++++++++++++++++------------------
 fs/ext4/super.c   |   38 ++++++++++++++++++++++++---------
 3 files changed, 84 insertions(+), 38 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 65adf0d..a594a94 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -889,12 +889,22 @@ struct ext4_inode_info {
 	qsize_t i_reserved_quota;
 #endif
 
-	/* completed IOs that might need unwritten extents handling */
-	struct list_head i_completed_io_list;
+	/* Lock protecting lists below */
 	spinlock_t i_completed_io_lock;
+	/*
+	 * Completed IOs that need unwritten extents handling and have
+	 * transaction reserved
+	 */
+	struct list_head i_rsv_conversion_list;
+	/*
+	 * Completed IOs that need unwritten extents handling and don't have
+	 * transaction reserved
+	 */
+	struct list_head i_unrsv_conversion_list;
 	atomic_t i_ioend_count;	/* Number of outstanding io_end structs */
 	atomic_t i_unwritten; /* Nr. of inflight conversions pending */
-	struct work_struct i_unwritten_work;	/* deferred extent conversion */
+	struct work_struct i_rsv_conversion_work;
+	struct work_struct i_unrsv_conversion_work;
 
 	spinlock_t i_block_reservation_lock;
 
@@ -1257,8 +1267,10 @@ struct ext4_sb_info {
 	struct flex_groups *s_flex_groups;
 	ext4_group_t s_flex_groups_allocated;
 
-	/* workqueue for dio unwritten */
-	struct workqueue_struct *dio_unwritten_wq;
+	/* workqueue for unreserved extent convertions (dio) */
+	struct workqueue_struct *unrsv_conversion_wq;
+	/* workqueue for reserved extent conversions (buffered io) */
+	struct workqueue_struct *rsv_conversion_wq;
 
 	/* timer for periodic error stats printing */
 	struct timer_list s_err_report;
@@ -2599,7 +2611,8 @@ extern int ext4_put_io_end(ext4_io_end_t *io_end);
 extern void ext4_put_io_end_defer(ext4_io_end_t *io_end);
 extern void ext4_io_submit_init(struct ext4_io_submit *io,
 				struct writeback_control *wbc);
-extern void ext4_end_io_work(struct work_struct *work);
+extern void ext4_end_io_rsv_work(struct work_struct *work);
+extern void ext4_end_io_unrsv_work(struct work_struct *work);
 extern void ext4_io_submit(struct ext4_io_submit *io);
 extern int ext4_bio_write_page(struct ext4_io_submit *io,
 			       struct page *page,
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index e8ee4da..8bff3b3 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -103,20 +103,17 @@ static int ext4_end_io(ext4_io_end_t *io)
 	return ret;
 }
 
-static void dump_completed_IO(struct inode *inode)
+static void dump_completed_IO(struct inode *inode, struct list_head *head)
 {
 #ifdef	EXT4FS_DEBUG
 	struct list_head *cur, *before, *after;
 	ext4_io_end_t *io, *io0, *io1;
 
-	if (list_empty(&EXT4_I(inode)->i_completed_io_list)) {
-		ext4_debug("inode %lu completed_io list is empty\n",
-			   inode->i_ino);
+	if (list_empty(head))
 		return;
-	}
 
-	ext4_debug("Dump inode %lu completed_io list\n", inode->i_ino);
-	list_for_each_entry(io, &EXT4_I(inode)->i_completed_io_list, list) {
+	ext4_debug("Dump inode %lu completed io list\n", inode->i_ino);
+	list_for_each_entry(io, head, list) {
 		cur = &io->list;
 		before = cur->prev;
 		io0 = container_of(before, ext4_io_end_t, list);
@@ -137,16 +134,23 @@ static void ext4_add_complete_io(ext4_io_end_t *io_end)
 	unsigned long flags;
 
 	BUG_ON(!(io_end->flag & EXT4_IO_END_UNWRITTEN));
-	wq = EXT4_SB(io_end->inode->i_sb)->dio_unwritten_wq;
-
 	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
-	if (list_empty(&ei->i_completed_io_list))
-		queue_work(wq, &ei->i_unwritten_work);
-	list_add_tail(&io_end->list, &ei->i_completed_io_list);
+	if (io_end->handle) {
+		wq = EXT4_SB(io_end->inode->i_sb)->rsv_conversion_wq;
+		if (list_empty(&ei->i_rsv_conversion_list))
+			queue_work(wq, &ei->i_rsv_conversion_work);
+		list_add_tail(&io_end->list, &ei->i_rsv_conversion_list);
+	} else {
+		wq = EXT4_SB(io_end->inode->i_sb)->unrsv_conversion_wq;
+		if (list_empty(&ei->i_unrsv_conversion_list))
+			queue_work(wq, &ei->i_unrsv_conversion_work);
+		list_add_tail(&io_end->list, &ei->i_unrsv_conversion_list);
+	}
 	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
 }
 
-static int ext4_do_flush_completed_IO(struct inode *inode)
+static int ext4_do_flush_completed_IO(struct inode *inode,
+				      struct list_head *head)
 {
 	ext4_io_end_t *io;
 	struct list_head unwritten;
@@ -155,8 +159,8 @@ static int ext4_do_flush_completed_IO(struct inode *inode)
 	int err, ret = 0;
 
 	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
-	dump_completed_IO(inode);
-	list_replace_init(&ei->i_completed_io_list, &unwritten);
+	dump_completed_IO(inode, head);
+	list_replace_init(head, &unwritten);
 	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
 
 	while (!list_empty(&unwritten)) {
@@ -172,21 +176,34 @@ static int ext4_do_flush_completed_IO(struct inode *inode)
 }
 
 /*
- * work on completed aio dio IO, to convert unwritten extents to extents
+ * work on completed IO, to convert unwritten extents to extents
  */
-void ext4_end_io_work(struct work_struct *work)
+void ext4_end_io_rsv_work(struct work_struct *work)
 {
 	struct ext4_inode_info *ei = container_of(work, struct ext4_inode_info,
-						  i_unwritten_work);
-	ext4_do_flush_completed_IO(&ei->vfs_inode);
+						  i_rsv_conversion_work);
+	ext4_do_flush_completed_IO(&ei->vfs_inode, &ei->i_rsv_conversion_list);
+}
+
+void ext4_end_io_unrsv_work(struct work_struct *work)
+{
+	struct ext4_inode_info *ei = container_of(work, struct ext4_inode_info,
+						  i_unrsv_conversion_work);
+	ext4_do_flush_completed_IO(&ei->vfs_inode, &ei->i_unrsv_conversion_list);
 }
 
 int ext4_flush_unwritten_io(struct inode *inode)
 {
-	int ret;
+	int ret, err;
+
 	WARN_ON_ONCE(!mutex_is_locked(&inode->i_mutex) &&
 		     !(inode->i_state & I_FREEING));
-	ret = ext4_do_flush_completed_IO(inode);
+	ret = ext4_do_flush_completed_IO(inode,
+					 &EXT4_I(inode)->i_rsv_conversion_list);
+	err = ext4_do_flush_completed_IO(inode,
+					 &EXT4_I(inode)->i_unrsv_conversion_list);
+	if (!ret)
+		ret = err;
 	ext4_unwritten_wait(inode);
 	return ret;
 }
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 09ff724..916c4fb 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -747,8 +747,10 @@ static void ext4_put_super(struct super_block *sb)
 	ext4_unregister_li_request(sb);
 	dquot_disable(sb, -1, DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED);
 
-	flush_workqueue(sbi->dio_unwritten_wq);
-	destroy_workqueue(sbi->dio_unwritten_wq);
+	flush_workqueue(sbi->unrsv_conversion_wq);
+	flush_workqueue(sbi->rsv_conversion_wq);
+	destroy_workqueue(sbi->unrsv_conversion_wq);
+	destroy_workqueue(sbi->rsv_conversion_wq);
 
 	if (sbi->s_journal) {
 		err = jbd2_journal_destroy(sbi->s_journal);
@@ -856,13 +858,15 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	ei->i_reserved_quota = 0;
 #endif
 	ei->jinode = NULL;
-	INIT_LIST_HEAD(&ei->i_completed_io_list);
+	INIT_LIST_HEAD(&ei->i_rsv_conversion_list);
+	INIT_LIST_HEAD(&ei->i_unrsv_conversion_list);
 	spin_lock_init(&ei->i_completed_io_lock);
 	ei->i_sync_tid = 0;
 	ei->i_datasync_tid = 0;
 	atomic_set(&ei->i_ioend_count, 0);
 	atomic_set(&ei->i_unwritten, 0);
-	INIT_WORK(&ei->i_unwritten_work, ext4_end_io_work);
+	INIT_WORK(&ei->i_rsv_conversion_work, ext4_end_io_rsv_work);
+	INIT_WORK(&ei->i_unrsv_conversion_work, ext4_end_io_unrsv_work);
 
 	return &ei->vfs_inode;
 }
@@ -3867,12 +3871,20 @@ no_journal:
 	 * The maximum number of concurrent works can be high and
 	 * concurrency isn't really necessary.  Limit it to 1.
 	 */
-	EXT4_SB(sb)->dio_unwritten_wq =
-		alloc_workqueue("ext4-dio-unwritten", WQ_MEM_RECLAIM | WQ_UNBOUND, 1);
-	if (!EXT4_SB(sb)->dio_unwritten_wq) {
-		printk(KERN_ERR "EXT4-fs: failed to create DIO workqueue\n");
+	EXT4_SB(sb)->rsv_conversion_wq =
+		alloc_workqueue("ext4-rsv-conversion", WQ_MEM_RECLAIM | WQ_UNBOUND, 1);
+	if (!EXT4_SB(sb)->rsv_conversion_wq) {
+		printk(KERN_ERR "EXT4-fs: failed to create workqueue\n");
 		ret = -ENOMEM;
-		goto failed_mount_wq;
+		goto failed_mount4;
+	}
+
+	EXT4_SB(sb)->unrsv_conversion_wq =
+		alloc_workqueue("ext4-unrsv-conversion", WQ_MEM_RECLAIM | WQ_UNBOUND, 1);
+	if (!EXT4_SB(sb)->unrsv_conversion_wq) {
+		printk(KERN_ERR "EXT4-fs: failed to create workqueue\n");
+		ret = -ENOMEM;
+		goto failed_mount4;
 	}
 
 	/*
@@ -4019,7 +4031,10 @@ failed_mount4a:
 	sb->s_root = NULL;
 failed_mount4:
 	ext4_msg(sb, KERN_ERR, "mount failed");
-	destroy_workqueue(EXT4_SB(sb)->dio_unwritten_wq);
+	if (EXT4_SB(sb)->rsv_conversion_wq)
+		destroy_workqueue(EXT4_SB(sb)->rsv_conversion_wq);
+	if (EXT4_SB(sb)->unrsv_conversion_wq)
+		destroy_workqueue(EXT4_SB(sb)->unrsv_conversion_wq);
 failed_mount_wq:
 	if (sbi->s_journal) {
 		jbd2_journal_destroy(sbi->s_journal);
@@ -4464,7 +4479,8 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
 	trace_ext4_sync_fs(sb, wait);
-	flush_workqueue(sbi->dio_unwritten_wq);
+	flush_workqueue(sbi->rsv_conversion_wq);
+	flush_workqueue(sbi->unrsv_conversion_wq);
 	/*
 	 * Writeback quota in non-journalled quota case - journalled quota has
 	 * no dirty dquots
-- 
1.7.1

