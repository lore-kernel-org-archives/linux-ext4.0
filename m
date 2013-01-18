From: Jan Kara <jack@suse.cz>
Subject: [PATCH 06/12] ext4: Move work from io_end to inode
Date: Fri, 18 Jan 2013 13:00:40 +0100
Message-ID: <1358510446-19174-7-git-send-email-jack@suse.cz>
References: <1358510446-19174-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35015 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846Ab3ARMA6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 18 Jan 2013 07:00:58 -0500
In-Reply-To: <1358510446-19174-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It does not make much sense to have struct work in ext4_io_end_t because we
always use it for only one ext4_io_end_t per inode (the first one in the
i_completed_io list). So just move the structure to inode itself.  This also
allows for a small simplification in processing io_end structures.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h    |    6 +++---
 fs/ext4/page-io.c |   33 +++++++++------------------------
 fs/ext4/super.c   |    1 +
 3 files changed, 13 insertions(+), 27 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index fb40ee2..7bbb53f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -194,8 +194,7 @@ struct mpage_da_data {
  */
 #define	EXT4_IO_END_UNWRITTEN	0x0001
 #define EXT4_IO_END_ERROR	0x0002
-#define EXT4_IO_END_QUEUED	0x0004
-#define EXT4_IO_END_DIRECT	0x0008
+#define EXT4_IO_END_DIRECT	0x0004
 
 struct ext4_io_page {
 	struct page	*p_page;
@@ -217,7 +216,6 @@ typedef struct ext4_io_end {
 	unsigned int		flag;		/* unwritten or not */
 	loff_t			offset;		/* offset in the file */
 	ssize_t			size;		/* size of the extent */
-	struct work_struct	work;		/* data work queue */
 	struct kiocb		*iocb;		/* iocb struct for AIO */
 	int			result;		/* error value for AIO */
 	int			num_io_pages;   /* for writepages() */
@@ -929,6 +927,7 @@ struct ext4_inode_info {
 	spinlock_t i_completed_io_lock;
 	atomic_t i_ioend_count;	/* Number of outstanding io_end structs */
 	atomic_t i_unwritten; /* Nr. of inflight conversions pending */
+	struct work_struct i_unwritten_work;	/* deferred extent conversion */
 
 	spinlock_t i_block_reservation_lock;
 
@@ -2535,6 +2534,7 @@ extern void ext4_exit_pageio(void);
 extern void ext4_ioend_wait(struct inode *);
 extern void ext4_free_io_end(ext4_io_end_t *io);
 extern ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags);
+extern void ext4_end_io_work(struct work_struct *work);
 extern void ext4_io_submit(struct ext4_io_submit *io);
 extern int ext4_bio_write_page(struct ext4_io_submit *io,
 			       struct page *page,
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 05795f1..a029017 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -151,16 +151,13 @@ void ext4_add_complete_io(ext4_io_end_t *io_end)
 	wq = EXT4_SB(io_end->inode->i_sb)->dio_unwritten_wq;
 
 	spin_lock_irqsave(&ei->i_completed_io_lock, flags);
-	if (list_empty(&ei->i_completed_io_list)) {
-		io_end->flag |= EXT4_IO_END_QUEUED;
-		queue_work(wq, &io_end->work);
-	}
+	if (list_empty(&ei->i_completed_io_list))
+		queue_work(wq, &ei->i_unwritten_work);
 	list_add_tail(&io_end->list, &ei->i_completed_io_list);
 	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
 }
 
-static int ext4_do_flush_completed_IO(struct inode *inode,
-				      ext4_io_end_t *work_io)
+static int ext4_do_flush_completed_IO(struct inode *inode)
 {
 	ext4_io_end_t *io;
 	struct list_head unwritten, complete, to_free;
@@ -191,19 +188,7 @@ static int ext4_do_flush_completed_IO(struct inode *inode,
 	while (!list_empty(&complete)) {
 		io = list_entry(complete.next, ext4_io_end_t, list);
 		io->flag &= ~EXT4_IO_END_UNWRITTEN;
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
+		list_move(&io->list, &to_free);
 	}
 	spin_unlock_irqrestore(&ei->i_completed_io_lock, flags);
 
@@ -218,10 +203,11 @@ static int ext4_do_flush_completed_IO(struct inode *inode,
 /*
  * work on completed aio dio IO, to convert unwritten extents to extents
  */
-static void ext4_end_io_work(struct work_struct *work)
+void ext4_end_io_work(struct work_struct *work)
 {
-	ext4_io_end_t *io = container_of(work, ext4_io_end_t, work);
-	ext4_do_flush_completed_IO(io->inode, io);
+	struct ext4_inode_info *ei = container_of(work, struct ext4_inode_info,
+						  i_unwritten_work);
+	ext4_do_flush_completed_IO(&ei->vfs_inode);
 }
 
 int ext4_flush_unwritten_io(struct inode *inode)
@@ -229,7 +215,7 @@ int ext4_flush_unwritten_io(struct inode *inode)
 	int ret;
 	WARN_ON_ONCE(!mutex_is_locked(&inode->i_mutex) &&
 		     !(inode->i_state & I_FREEING));
-	ret = ext4_do_flush_completed_IO(inode, NULL);
+	ret = ext4_do_flush_completed_IO(inode);
 	ext4_unwritten_wait(inode);
 	return ret;
 }
@@ -240,7 +226,6 @@ ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags)
 	if (io) {
 		atomic_inc(&EXT4_I(inode)->i_ioend_count);
 		io->inode = inode;
-		INIT_WORK(&io->work, ext4_end_io_work);
 		INIT_LIST_HEAD(&io->list);
 	}
 	return io;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index afbe974..060fa38 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -960,6 +960,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	ei->i_datasync_tid = 0;
 	atomic_set(&ei->i_ioend_count, 0);
 	atomic_set(&ei->i_unwritten, 0);
+	INIT_WORK(&ei->i_unwritten_work, ext4_end_io_work);
 
 	return &ei->vfs_inode;
 }
-- 
1.7.1

