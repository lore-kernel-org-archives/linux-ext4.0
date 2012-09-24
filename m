From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 04/10] ext4: completed_io locking cleanup V3
Date: Mon, 24 Sep 2012 15:44:14 +0400
Message-ID: <1348487060-19598-5-git-send-email-dmonakhov@openvz.org>
References: <1348487060-19598-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, lczerner@redhat.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52474 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab2IXLog (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Sep 2012 07:44:36 -0400
Received: by mail-lb0-f174.google.com with SMTP id gj3so6549331lbb.19
        for <linux-ext4@vger.kernel.org>; Mon, 24 Sep 2012 04:44:35 -0700 (PDT)
In-Reply-To: <1348487060-19598-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Current unwritten extent conversion state-machine is very fuzzy.
- By unknown reason it want perform conversion under i_mutex. What for?
  It was initially added by Theodore. Please comment your initial assumption.
  My diagnosis:
  We already protect extent tree with i_data_sem, truncate should
  wait for DIO in flight, so the only data we have to protect io->flags
  modification,  but only flush_completed_IO and work are modified this
  flags and we can serialize them via i_completed_io_lock.

  Currently all this games with mutex_trylock result in following deadlock
   truncate:                          kworker:
    ext4_setattr                       ext4_end_io_work
    mutex_lock(i_mutex)
    inode_dio_wait(inode)  ->BLOCK
                             DEADLOCK<- mutex_trylock()
                                        inode_dio_done()
  #TEST_CASE1_BEGIN
  MNT=/mnt_scrach
  unlink $MNT/file
  fallocate -l $((1024*1024*1024)) $MNT/file
  aio-stress -I 100000 -O -s 100m -n -t 1 -c 10 -o 2 -o 3 $MNT/file
  sleep 2
  truncate -s 0 $MNT/file
  #TEST_CASE1_END

Or use 286's xfstests https://github.com/dmonakhov/xfstests/blob/devel/286

This patch makes state machine simple and clean:
(1) ext4_end_io_work is responsible for handling all pending
    end_io from ei->i_completed_io_list(per inode list)
    NOTE1: i_completed_io_lock is acquired only once
    NOTE2: i_mutex is not required because it does not protect
           any data guarded by i_mutex any more

(2) xxx_end_io schedule end_io context completion simply by pushing it
    to the inode's list.
    NOTE1: because of (1) work should be queued only if
    ->i_completed_io_list was empty at the moment, otherwise it
    work is scheduled already.

(3) No one is able to free inode's blocks while pented io_completion
    exist othervise may result in blocks beyond EOF, this
    stated by the fact that all truncate routines wait for
    all pended unwritten requets in flight

(4) Replace flush_completed_io() with ext4_unwritten_wait(). This
    allow greatly simplify state machine because end_io conext
    will be destroyed only in one place (end_io_work)


- remove EXT4_IO_END_QUEUED and EXT4_IO_END_FSYNC flags because
  end_io is now destroyed from known context
- Improve SMP scalability by removing useless i_mutex which does not
  protect io->flags anymore.
- Reduce lock contention on i_completed_io_lock by optimizing list walk.
- Move open coded logic from various xx_end_xx routines to ext4_add_complete_io()

Changes since V2:
  Fix use-after-free caused by race truncate vs end_io_work

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/ext4.h     |    7 +--
 fs/ext4/extents.c  |    4 +-
 fs/ext4/file.c     |    7 ---
 fs/ext4/fsync.c    |   85 +--------------------------------------
 fs/ext4/indirect.c |    8 +--
 fs/ext4/inode.c    |   25 +-----------
 fs/ext4/page-io.c  |  113 ++++++++++++++++++++++++++++++----------------------
 7 files changed, 76 insertions(+), 173 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 47f0778..cc423cf 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -184,9 +184,7 @@ struct mpage_da_data {
  */
 #define	EXT4_IO_END_UNWRITTEN	0x0001
 #define EXT4_IO_END_ERROR	0x0002
-#define EXT4_IO_END_QUEUED	0x0004
-#define EXT4_IO_END_DIRECT	0x0008
-#define EXT4_IO_END_IN_FSYNC	0x0010
+#define EXT4_IO_END_DIRECT	0x0004
 
 struct ext4_io_page {
 	struct page	*p_page;
@@ -1939,7 +1937,6 @@ extern void ext4_htree_free_dir_info(struct dir_private_info *p);
 
 /* fsync.c */
 extern int ext4_sync_file(struct file *, loff_t, loff_t, int);
-extern int ext4_flush_completed_IO(struct inode *);
 
 /* hash.c */
 extern int ext4fs_dirhash(const char *name, int len, struct
@@ -2411,8 +2408,10 @@ extern int ext4_move_extents(struct file *o_filp, struct file *d_filp,
 
 /* page-io.c */
 extern int __init ext4_init_pageio(void);
+extern void ext4_add_complete_io(ext4_io_end_t *io_end);
 extern void ext4_exit_pageio(void);
 extern void ext4_ioend_wait(struct inode *);
+extern void ext4_unwritten_wait(struct inode *inode);
 extern void ext4_free_io_end(ext4_io_end_t *io);
 extern ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags);
 extern int ext4_end_io_nolock(ext4_io_end_t *io);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 739c21d..6326874 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4293,7 +4293,7 @@ void ext4_ext_truncate(struct inode *inode)
 	 * finish any pending end_io work so we won't run the risk of
 	 * converting any truncated blocks to initialized later
 	 */
-	ext4_flush_completed_IO(inode);
+	ext4_unwritten_wait(inode);
 
 	/*
 	 * probably first extent we're gonna free will be last in block
@@ -4860,7 +4860,7 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 	}
 
 	/* finish any pending end_io work */
-	ext4_flush_completed_IO(inode);
+	ext4_unwritten_wait(inode);
 
 	credits = ext4_writepage_trans_blocks(inode);
 	handle = ext4_journal_start(inode, credits);
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 39335bd..bdafaff 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -55,13 +55,6 @@ static int ext4_release_file(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static void ext4_unwritten_wait(struct inode *inode)
-{
-	wait_queue_head_t *wq = ext4_ioend_wq(inode);
-
-	wait_event(*wq, (atomic_read(&EXT4_I(inode)->i_unwritten) == 0));
-}
-
 /*
  * This tests whether the IO in question is block-aligned or not.
  * Ext4 utilizes unwritten extents when hole-filling during direct IO, and they
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 323eb15..94f5d3e 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -34,87 +34,6 @@
 
 #include <trace/events/ext4.h>
 
-static void dump_completed_IO(struct inode * inode)
-{
-#ifdef	EXT4FS_DEBUG
-	struct list_head *cur, *before, *after;
-	ext4_io_end_t *io, *io0, *io1;
-	unsigned long flags;
-
-	if (list_empty(&EXT4_I(inode)->i_completed_io_list)){
-		ext4_debug("inode %lu completed_io list is empty\n", inode->i_ino);
-		return;
-	}
-
-	ext4_debug("Dump inode %lu completed_io list \n", inode->i_ino);
-	spin_lock_irqsave(&EXT4_I(inode)->i_completed_io_lock, flags);
-	list_for_each_entry(io, &EXT4_I(inode)->i_completed_io_list, list){
-		cur = &io->list;
-		before = cur->prev;
-		io0 = container_of(before, ext4_io_end_t, list);
-		after = cur->next;
-		io1 = container_of(after, ext4_io_end_t, list);
-
-		ext4_debug("io 0x%p from inode %lu,prev 0x%p,next 0x%p\n",
-			    io, inode->i_ino, io0, io1);
-	}
-	spin_unlock_irqrestore(&EXT4_I(inode)->i_completed_io_lock, flags);
-#endif
-}
-
-/*
- * This function is called from ext4_sync_file().
- *
- * When IO is completed, the work to convert unwritten extents to
- * written is queued on workqueue but may not get immediately
- * scheduled. When fsync is called, we need to ensure the
- * conversion is complete before fsync returns.
- * The inode keeps track of a list of pending/completed IO that
- * might needs to do the conversion. This function walks through
- * the list and convert the related unwritten extents for completed IO
- * to written.
- * The function return the number of pending IOs on success.
- */
-int ext4_flush_completed_IO(struct inode *inode)
-{
-	ext4_io_end_t *io;
-	struct ext4_inode_info *ei = EXT4_I(inode);
-	unsigned long flags;
-	int ret = 0;
-	int ret2 = 0;
-
-	dump_completed_IO(inode);
-	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
-	while (!list_empty(&ei->i_completed_io_list)){
-		io = list_entry(ei->i_completed_io_list.next,
-				ext4_io_end_t, list);
-		list_del_init(&io->list);
-		io->flag |= EXT4_IO_END_IN_FSYNC;
-		/*
-		 * Calling ext4_end_io_nolock() to convert completed
-		 * IO to written.
-		 *
-		 * When ext4_sync_file() is called, run_queue() may already
-		 * about to flush the work corresponding to this io structure.
-		 * It will be upset if it founds the io structure related
-		 * to the work-to-be schedule is freed.
-		 *
-		 * Thus we need to keep the io structure still valid here after
-		 * conversion finished. The io structure has a flag to
-		 * avoid double converting from both fsync and background work
-		 * queue work.
-		 */
-		spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
-		ret = ext4_end_io_nolock(io);
-		if (ret < 0)
-			ret2 = ret;
-		spin_lock_irqsave(&ei->i_completed_io_lock, flags);
-		io->flag &= ~EXT4_IO_END_IN_FSYNC;
-	}
-	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
-	return (ret2 < 0) ? ret2 : 0;
-}
-
 /*
  * If we're not journaling and this is a just-created file, we have to
  * sync our parent directory (if it was freshly created) since
@@ -219,9 +138,7 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	if (inode->i_sb->s_flags & MS_RDONLY)
 		goto out;
 
-	ret = ext4_flush_completed_IO(inode);
-	if (ret < 0)
-		goto out;
+	ext4_unwritten_wait(inode);
 
 	if (!journal) {
 		ret = __sync_inode(inode, datasync);
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 830e1b2..251e35f 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -807,11 +807,9 @@ ssize_t ext4_ind_direct_IO(int rw, struct kiocb *iocb,
 
 retry:
 	if (rw == READ && ext4_should_dioread_nolock(inode)) {
-		if (unlikely(!list_empty(&ei->i_completed_io_list))) {
-			mutex_lock(&inode->i_mutex);
-			ext4_flush_completed_IO(inode);
-			mutex_unlock(&inode->i_mutex);
-		}
+		if (unlikely(!list_empty(&ei->i_completed_io_list)))
+			ext4_unwritten_wait(inode);
+
 		ret = __blockdev_direct_IO(rw, iocb, inode,
 				 inode->i_sb->s_bdev, iov,
 				 offset, nr_segs,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 05206ba..05d860e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2882,9 +2882,6 @@ static void ext4_end_io_dio(struct kiocb *iocb, loff_t offset,
 {
 	struct inode *inode = iocb->ki_filp->f_path.dentry->d_inode;
         ext4_io_end_t *io_end = iocb->private;
-	struct workqueue_struct *wq;
-	unsigned long flags;
-	struct ext4_inode_info *ei;
 
 	/* if not async direct IO or dio with 0 bytes write, just return */
 	if (!io_end || !size)
@@ -2913,24 +2910,14 @@ out:
 		io_end->iocb = iocb;
 		io_end->result = ret;
 	}
-	wq = EXT4_SB(io_end->inode->i_sb)->dio_unwritten_wq;
-
-	/* Add the io_end to per-inode completed aio dio list*/
-	ei = EXT4_I(io_end->inode);
-	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
-	list_add_tail(&io_end->list, &ei->i_completed_io_list);
-	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
 
-	/* queue the work to convert unwritten extents to written */
-	queue_work(wq, &io_end->work);
+	ext4_add_complete_io(io_end);
 }
 
 static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate)
 {
 	ext4_io_end_t *io_end = bh->b_private;
-	struct workqueue_struct *wq;
 	struct inode *inode;
-	unsigned long flags;
 
 	if (!test_clear_buffer_uninit(bh) || !io_end)
 		goto out;
@@ -2949,15 +2936,7 @@ static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate)
 	 */
 	inode = io_end->inode;
 	ext4_set_io_unwritten_flag(inode, io_end);
-
-	/* Add the io_end to per-inode completed io list*/
-	spin_lock_irqsave(&EXT4_I(inode)->i_completed_io_lock, flags);
-	list_add_tail(&io_end->list, &EXT4_I(inode)->i_completed_io_list);
-	spin_unlock_irqrestore(&EXT4_I(inode)->i_completed_io_lock, flags);
-
-	wq = EXT4_SB(inode->i_sb)->dio_unwritten_wq;
-	/* queue the work to convert unwritten extents to written */
-	queue_work(wq, &io_end->work);
+	ext4_add_complete_io(io_end);
 out:
 	bh->b_private = NULL;
 	bh->b_end_io = NULL;
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 9970022..fa69bba 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -57,6 +57,29 @@ void ext4_ioend_wait(struct inode *inode)
 	wait_event(*wq, (atomic_read(&EXT4_I(inode)->i_ioend_count) == 0));
 }
 
+void ext4_unwritten_wait(struct inode *inode)
+{
+	wait_queue_head_t *wq = ext4_ioend_wq(inode);
+
+	wait_event(*wq, (atomic_read(&EXT4_I(inode)->i_unwritten) == 0));
+}
+
+/* Add the io_end to per-inode completed aio dio list. */
+void ext4_add_complete_io(ext4_io_end_t *io_end)
+{
+	struct ext4_inode_info *ei = EXT4_I(io_end->inode);
+	struct workqueue_struct *wq;
+	unsigned long flags;
+
+	wq = EXT4_SB(io_end->inode->i_sb)->dio_unwritten_wq;
+
+	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
+	if (list_empty(&ei->i_completed_io_list))
+		queue_work(wq, &io_end->work);
+	list_add_tail(&io_end->list, &ei->i_completed_io_list);
+	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
+}
+
 static void put_io_page(struct ext4_io_page *io_page)
 {
 	if (atomic_dec_and_test(&io_page->p_count)) {
@@ -83,12 +106,7 @@ void ext4_free_io_end(ext4_io_end_t *io)
 	kmem_cache_free(io_end_cachep, io);
 }
 
-/*
- * check a range of space and convert unwritten extents to written.
- *
- * Called with inode->i_mutex; we depend on this when we manipulate
- * io->flag, since we could otherwise race with ext4_flush_completed_IO()
- */
+/* check a range of space and convert unwritten extents to written. */
 int ext4_end_io_nolock(ext4_io_end_t *io)
 {
 	struct inode *inode = io->inode;
@@ -98,6 +116,8 @@ int ext4_end_io_nolock(ext4_io_end_t *io)
 
 	BUG_ON(!(io->flag & EXT4_IO_END_UNWRITTEN));
 
+	BUG_ON(!list_empty(&io->list));
+
 	ext4_debug("ext4_end_io_nolock: io 0x%p from inode %lu,list->next 0x%p,"
 		   "list->prev 0x%p\n",
 		   io, inode->i_ino, io->list.next, io->list.prev);
@@ -122,6 +142,32 @@ int ext4_end_io_nolock(ext4_io_end_t *io)
 	return ret;
 }
 
+static void dump_completed_IO(struct inode * inode)
+{
+#ifdef	EXT4FS_DEBUG
+	struct list_head *cur, *before, *after;
+	ext4_io_end_t *io, *io0, *io1;
+	unsigned long flags;
+
+	if (list_empty(&EXT4_I(inode)->i_completed_io_list)){
+		ext4_debug("inode %lu completed_io list is empty\n", inode->i_ino);
+		return;
+	}
+
+	ext4_debug("Dump inode %lu completed_io list \n", inode->i_ino);
+	list_for_each_entry(io, &EXT4_I(inode)->i_completed_io_list, list){
+		cur = &io->list;
+		before = cur->prev;
+		io0 = container_of(before, ext4_io_end_t, list);
+		after = cur->next;
+		io1 = container_of(after, ext4_io_end_t, list);
+
+		ext4_debug("io 0x%p from inode %lu,prev 0x%p,next 0x%p\n",
+			    io, inode->i_ino, io0, io1);
+	}
+#endif
+}
+
 /*
  * work on completed aio dio IO, to convert unwritten extents to extents
  */
@@ -131,44 +177,24 @@ static void ext4_end_io_work(struct work_struct *work)
 	struct inode		*inode = io->inode;
 	struct ext4_inode_info	*ei = EXT4_I(inode);
 	unsigned long		flags;
+	struct list_head 	complete_list;
 
 	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
-	if (io->flag & EXT4_IO_END_IN_FSYNC)
-		goto requeue;
-	if (list_empty(&io->list)) {
-		spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
-		goto free;
-	}
+	dump_completed_IO(inode);
+	list_replace_init(&ei->i_completed_io_list, &complete_list);
+	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
 
-	if (!mutex_trylock(&inode->i_mutex)) {
-		bool was_queued;
-requeue:
-		was_queued = !!(io->flag & EXT4_IO_END_QUEUED);
-		io->flag |= EXT4_IO_END_QUEUED;
-		spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
-		/*
-		 * Requeue the work instead of waiting so that the work
-		 * items queued after this can be processed.
-		 */
-		queue_work(EXT4_SB(inode->i_sb)->dio_unwritten_wq, &io->work);
-		/*
-		 * To prevent the ext4-dio-unwritten thread from keeping
-		 * requeueing end_io requests and occupying cpu for too long,
-		 * yield the cpu if it sees an end_io request that has already
-		 * been requeued.
-		 */
-		if (was_queued)
-			yield();
-		return;
+	BUG_ON(list_empty(&complete_list));
+
+	while(!list_empty(&complete_list)) {
+		io = list_entry(complete_list.next, ext4_io_end_t, list);
+		list_del_init(&io->list);
+	        ext4_end_io_nolock(io);
+		ext4_free_io_end(io);
 	}
-	list_del_init(&io->list);
-	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
-	(void) ext4_end_io_nolock(io);
-	mutex_unlock(&inode->i_mutex);
-free:
-	ext4_free_io_end(io);
 }
 
+
 ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags)
 {
 	ext4_io_end_t *io = kmem_cache_zalloc(io_end_cachep, flags);
@@ -199,9 +225,7 @@ static void buffer_io_error(struct buffer_head *bh)
 static void ext4_end_bio(struct bio *bio, int error)
 {
 	ext4_io_end_t *io_end = bio->bi_private;
-	struct workqueue_struct *wq;
 	struct inode *inode;
-	unsigned long flags;
 	int i;
 	sector_t bi_sector = bio->bi_sector;
 
@@ -259,14 +283,7 @@ static void ext4_end_bio(struct bio *bio, int error)
 		return;
 	}
 
-	/* Add the io_end to per-inode completed io list*/
-	spin_lock_irqsave(&EXT4_I(inode)->i_completed_io_lock, flags);
-	list_add_tail(&io_end->list, &EXT4_I(inode)->i_completed_io_list);
-	spin_unlock_irqrestore(&EXT4_I(inode)->i_completed_io_lock, flags);
