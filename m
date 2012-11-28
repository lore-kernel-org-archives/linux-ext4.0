From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC PATCH] ext4: Convert unwritten extents during end_io processing
Date: Wed, 28 Nov 2012 00:02:54 -0800
Message-ID: <20121128080254.GB11869@blackbox.djwong.org>
References: <20121123075502.307482760@bombadil.infradead.org>
 <20121123075916.375908616@bombadil.infradead.org>
 <x49a9u3f276.fsf@segfault.boston.devel.redhat.com>
 <20121128002656.GC4321@blackbox.djwong.org>
 <20121128003027.GA14500@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel@vger.kernel.org,
	Jan Kara <jack@suse.cz>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121128003027.GA14500@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Here's a lightly tested (it passed enough of xfstests and an aio+dio+osync
tester on ext4 on x64...) patch that rips out the whole wq mess to convert
unwritten extents from endio processing.  This has the effect that unwritten
extents are now converted as part of writeback, not fsync/truncate/punch_hole.
I have a suspicion that the reason why ext4 had that behavior was to reduce
churn in the extent tree if one writes a bunch of adjacent sections of hole.
Oh well.  I haven't seen any huge regressions yet, but then I'm really just
posting this early to see if anyone spots obvious bugs.

Christoph, was this what you had in mind?

--D
---
When writing into an unwritten part of a file, convert the unwritten extent
while doing the endio processing instead of deferring it to another workqueue.
This enables us to reduce the endio processing to only one workqueue and also
means that writeback doesn't end until the extent conversion is complete.

This patch is intended to be a follow-on to Christoph's "handle O_(D)SYNC for
AIO" patchset.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ext4/ext4.h     |    9 ---
 fs/ext4/extents.c  |   14 ++---
 fs/ext4/fsync.c    |    4 -
 fs/ext4/indirect.c |    6 --
 fs/ext4/inode.c    |   10 +---
 fs/ext4/page-io.c  |  139 ++++------------------------------------------------
 fs/ext4/super.c    |   18 -------
 7 files changed, 23 insertions(+), 177 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 6129dd5..98d2b92 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -904,9 +904,6 @@ struct ext4_inode_info {
 	qsize_t i_reserved_quota;
 #endif
 
-	/* completed IOs that might need unwritten extents handling */
-	struct list_head i_completed_io_list;
-	spinlock_t i_completed_io_lock;
 	atomic_t i_ioend_count;	/* Number of outstanding io_end structs */
 	atomic_t i_unwritten; /* Nr. of inflight conversions pending */
 
@@ -1273,9 +1270,6 @@ struct ext4_sb_info {
 	struct flex_groups *s_flex_groups;
 	ext4_group_t s_flex_groups_allocated;
 
-	/* workqueue for dio unwritten */
-	struct workqueue_struct *dio_unwritten_wq;
-
 	/* timer for periodic error stats printing */
 	struct timer_list s_err_report;
 
@@ -1944,7 +1938,6 @@ extern void ext4_htree_free_dir_info(struct dir_private_info *p);
 
 /* fsync.c */
 extern int ext4_sync_file(struct file *, loff_t, loff_t, int);
-extern int ext4_flush_unwritten_io(struct inode *);
 
 /* hash.c */
 extern int ext4fs_dirhash(const char *name, int len, struct
@@ -2416,7 +2409,7 @@ extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
 
 /* page-io.c */
 extern int __init ext4_init_pageio(void);
-extern void ext4_add_complete_io(ext4_io_end_t *io_end);
+extern void ext4_complete_io(ext4_io_end_t *io_end);
 extern void ext4_exit_pageio(void);
 extern void ext4_ioend_wait(struct inode *);
 extern void ext4_free_io_end(ext4_io_end_t *io);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 7011ac9..f3fec5f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4300,10 +4300,10 @@ void ext4_ext_truncate(struct inode *inode)
 	int err = 0;
 
 	/*
-	 * finish any pending end_io work so we won't run the risk of
-	 * converting any truncated blocks to initialized later
+	 * Wait for pending extent conversion so we won't accidentally
+	 * convert truncated blocks to initialized later.
 	 */
-	ext4_flush_unwritten_io(inode);
+	ext4_unwritten_wait(inode);
 
 	/*
 	 * probably first extent we're gonna free will be last in block
@@ -4464,8 +4464,8 @@ long ext4_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (len <= EXT_UNINIT_MAX_LEN << blkbits)
 		flags |= EXT4_GET_BLOCKS_NO_NORMALIZE;
 
-	/* Prevent race condition between unwritten */
-	ext4_flush_unwritten_io(inode);
+	/* Don't race with unwritten */
+	ext4_unwritten_wait(inode);
 retry:
 	while (ret >= 0 && ret < max_blocks) {
 		map.m_lblk = map.m_lblk + ret;
@@ -4885,9 +4885,7 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 
 	/* Wait all existing dio workers, newcomers will block on i_mutex */
 	ext4_inode_block_unlocked_dio(inode);
-	err = ext4_flush_unwritten_io(inode);
-	if (err)
-		goto out_dio;
+	ext4_unwritten_wait(inode);
 	inode_dio_wait(inode);
 
 	credits = ext4_writepage_trans_blocks(inode);
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index be1d89f..94f5d3e 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -138,9 +138,7 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	if (inode->i_sb->s_flags & MS_RDONLY)
 		goto out;
 
-	ret = ext4_flush_unwritten_io(inode);
-	if (ret < 0)
-		goto out;
+	ext4_unwritten_wait(inode);
 
 	if (!journal) {
 		ret = __sync_inode(inode, datasync);
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 792e388..f4b65f2 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -807,11 +807,7 @@ ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
 
 retry:
 	if (rw == READ && ext4_should_dioread_nolock(inode)) {
-		if (unlikely(atomic_read(&EXT4_I(inode)->i_unwritten))) {
-			mutex_lock(&inode->i_mutex);
-			ext4_flush_unwritten_io(inode);
-			mutex_unlock(&inode->i_mutex);
-		}
+		ext4_unwritten_wait(inode);
 		/*
 		 * Nolock dioread optimization may be dynamically disabled
 		 * via ext4_inode_block_unlocked_dio(). Check inode's state
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0446f28..3c9f6a0 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2891,16 +2891,10 @@ static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
 
 	iocb->private = NULL;
 
-	/* if not aio dio with unwritten extents, just free io and return */
-	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
-		ext4_free_io_end(io_end);
-		return;
-	}
-
 	io_end->offset = offset;
 	io_end->size = size;
 
-	ext4_add_complete_io(io_end);
+	ext4_complete_io(io_end);
 }
 
 static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate)
@@ -2925,7 +2919,7 @@ static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate)
 	 */
 	inode = io_end->inode;
 	ext4_set_io_unwritten_flag(inode, io_end);
-	ext4_add_complete_io(io_end);
+	ext4_complete_io(io_end);
 out:
 	bh->b_private = NULL;
 	bh->b_end_io = NULL;
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index df1d5b7..2adf23f 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -71,7 +71,6 @@ void ext4_free_io_end(ext4_io_end_t *io)
 	int i;
 
 	BUG_ON(!io);
-	BUG_ON(!list_empty(&io->list));
 	BUG_ON(io->flag & EXT4_IO_END_UNWRITTEN);
 
 	if (io->page)
@@ -92,9 +91,8 @@ static int ext4_end_io(ext4_io_end_t *io)
 	ssize_t size = io->size;
 	int ret = 0;
 
-	ext4_debug("ext4_end_io_nolock: io 0x%p from inode %lu,list->next 0x%p,"
-		   "list->prev 0x%p\n",
-		   io, inode->i_ino, io->list.next, io->list.prev);
+	ext4_debug("ext4_end_io_nolock: io 0x%p from inode %lu\n",
+		   io, inode->i_ino);
 
 	ret = ext4_convert_unwritten_extents(inode, offset, size);
 	if (ret < 0) {
@@ -111,125 +109,19 @@ static int ext4_end_io(ext4_io_end_t *io)
 	return ret;
 }
 
-static void dump_completed_IO(struct inode *inode)
-{
-#ifdef	EXT4FS_DEBUG
-	struct list_head *cur, *before, *after;
-	ext4_io_end_t *io, *io0, *io1;
-	unsigned long flags;
-
-	if (list_empty(&EXT4_I(inode)->i_completed_io_list)) {
-		ext4_debug("inode %lu completed_io list is empty\n",
-			   inode->i_ino);
-		return;
-	}
-
-	ext4_debug("Dump inode %lu completed_io list\n", inode->i_ino);
-	list_for_each_entry(io, &EXT4_I(inode)->i_completed_io_list, list) {
-		cur = &io->list;
-		before = cur->prev;
-		io0 = container_of(before, ext4_io_end_t, list);
-		after = cur->next;
-		io1 = container_of(after, ext4_io_end_t, list);
-
-		ext4_debug("io 0x%p from inode %lu,prev 0x%p,next 0x%p\n",
-			    io, inode->i_ino, io0, io1);
-	}
-#endif
-}
-
-/* Add the io_end to per-inode completed end_io list. */
-void ext4_add_complete_io(ext4_io_end_t *io_end)
-{
-	struct ext4_inode_info *ei = EXT4_I(io_end->inode);
-	struct workqueue_struct *wq;
-	unsigned long flags;
-
-	BUG_ON(!(io_end->flag & EXT4_IO_END_UNWRITTEN));
-	wq = EXT4_SB(io_end->inode->i_sb)->dio_unwritten_wq;
-
-	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
-	if (list_empty(&ei->i_completed_io_list)) {
-		io_end->flag |= EXT4_IO_END_QUEUED;
-		queue_work(wq, &io_end->work);
-	}
-	list_add_tail(&io_end->list, &ei->i_completed_io_list);
-	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
-}
-
-static int ext4_do_flush_completed_IO(struct inode *inode,
-				      ext4_io_end_t *work_io)
-{
-	ext4_io_end_t *io;
-	struct list_head unwritten, complete, to_free;
-	unsigned long flags;
-	struct ext4_inode_info *ei = EXT4_I(inode);
-	int err, ret = 0;
-
-	INIT_LIST_HEAD(&complete);
-	INIT_LIST_HEAD(&to_free);
-
-	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
-	dump_completed_IO(inode);
-	list_replace_init(&ei->i_completed_io_list, &unwritten);
-	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
-
-	while (!list_empty(&unwritten)) {
-		io = list_entry(unwritten.next, ext4_io_end_t, list);
-		BUG_ON(!(io->flag & EXT4_IO_END_UNWRITTEN));
-		list_del_init(&io->list);
-
-		err = ext4_end_io(io);
-		if (unlikely(!ret && err))
-			ret = err;
-
-		list_add_tail(&io->list, &complete);
-	}
-	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
-	while (!list_empty(&complete)) {
-		io = list_entry(complete.next, ext4_io_end_t, list);
-		io->flag &= ~EXT4_IO_END_UNWRITTEN;
-		/* end_io context can not be destroyed now because it still
-		 * used by queued worker. Worker thread will destroy it later */
-		if (io->flag & EXT4_IO_END_QUEUED)
-			list_del_init(&io->list);
-		else
-			list_move(&io->list, &to_free);
-	}
-	/* If we are called from worker context, it is time to clear queued
-	 * flag, and destroy it's end_io if it was converted already */
-	if (work_io) {
-		work_io->flag &= ~EXT4_IO_END_QUEUED;
-		if (!(work_io->flag & EXT4_IO_END_UNWRITTEN))
-			list_add_tail(&work_io->list, &to_free);
-	}
-	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
-
-	while (!list_empty(&to_free)) {
-		io = list_entry(to_free.next, ext4_io_end_t, list);
-		list_del_init(&io->list);
-		ext4_free_io_end(io);
-	}
-	return ret;
-}
-
 /*
- * work on completed aio dio IO, to convert unwritten extents to extents
+ * Complete endio processing by converting unwritten extents (if necessary) and
+ * freeing the endio.
  */
-static void ext4_end_io_work(struct work_struct *work)
+void ext4_complete_io(ext4_io_end_t *io_end)
 {
-	ext4_io_end_t *io = container_of(work, ext4_io_end_t, work);
-	ext4_do_flush_completed_IO(io->inode, io);
-}
+	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN))
+		goto out;
 
-int ext4_flush_unwritten_io(struct inode *inode)
-{
-	int ret;
-	WARN_ON_ONCE(!mutex_is_locked(&inode->i_mutex) &&
-		     !(inode->i_state & I_FREEING));
-	ret = ext4_do_flush_completed_IO(inode, NULL);
-	ext4_unwritten_wait(inode);
-	return ret;
+	ext4_end_io(io_end);
+	io_end->flag &= ~EXT4_IO_END_UNWRITTEN;
+out:
+	ext4_free_io_end(io_end);
 }
 
 ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags)
@@ -238,8 +130,6 @@ ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags)
 	if (io) {
 		atomic_inc(&EXT4_I(inode)->i_ioend_count);
 		io->inode = inode;
-		INIT_WORK(&io->work, ext4_end_io_work);
-		INIT_LIST_HEAD(&io->list);
 	}
 	return io;
 }
@@ -315,12 +205,7 @@ static void ext4_end_bio(struct bio *bio, int error)
 			     bi_sector >> (inode->i_blkbits - 9));
 	}
 
-	if (!(io_end->flag & EXT4_IO_END_UNWRITTEN)) {
-		ext4_free_io_end(io_end);
-		return;
-	}
-
-	ext4_add_complete_io(io_end);
+	ext4_complete_io(io_end);
 }
 
 void ext4_io_submit(struct ext4_io_submit *io)
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 80928f7..1691209 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -848,9 +848,6 @@ static void ext4_put_super(struct super_block *sb)
 	ext4_unregister_li_request(sb);
 	dquot_disable(sb, -1, DQUOT_USAGE_ENABLED | DQUOT_LIMITS_ENABLED);
 
-	flush_workqueue(sbi->dio_unwritten_wq);
-	destroy_workqueue(sbi->dio_unwritten_wq);
-
 	if (sbi->s_journal) {
 		err = jbd2_journal_destroy(sbi->s_journal);
 		sbi->s_journal = NULL;
@@ -953,8 +950,6 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	ei->i_reserved_quota = 0;
 #endif
 	ei->jinode = NULL;
-	INIT_LIST_HEAD(&ei->i_completed_io_list);
-	spin_lock_init(&ei->i_completed_io_lock);
 	ei->i_sync_tid = 0;
 	ei->i_datasync_tid = 0;
 	atomic_set(&ei->i_ioend_count, 0);
@@ -3903,17 +3898,6 @@ no_journal:
 	}
 
 	/*
-	 * The maximum number of concurrent works can be high and
-	 * concurrency isn't really necessary.  Limit it to 1.
-	 */
-	EXT4_SB(sb)->dio_unwritten_wq =
-		alloc_workqueue("ext4-dio-unwritten", WQ_MEM_RECLAIM | WQ_UNBOUND, 1);
-	if (!EXT4_SB(sb)->dio_unwritten_wq) {
-		printk(KERN_ERR "EXT4-fs: failed to create DIO workqueue\n");
-		goto failed_mount_wq;
-	}
-
-	/*
 	 * The jbd2_journal_load will have done any necessary log recovery,
 	 * so we can safely mount the rest of the filesystem now.
 	 */
@@ -4045,7 +4029,6 @@ failed_mount4a:
 	sb->s_root = NULL;
 failed_mount4:
 	ext4_msg(sb, KERN_ERR, "mount failed");
-	destroy_workqueue(EXT4_SB(sb)->dio_unwritten_wq);
 failed_mount_wq:
 	if (sbi->s_journal) {
 		jbd2_journal_destroy(sbi->s_journal);
@@ -4493,7 +4476,6 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
 	trace_ext4_sync_fs(sb, wait);
-	flush_workqueue(sbi->dio_unwritten_wq);
 	/*
 	 * Writeback quota in non-journalled quota case - journalled quota has
 	 * no dirty dquots
