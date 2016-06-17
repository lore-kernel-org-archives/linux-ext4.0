From: Jan Kara <jack@suse.cz>
Subject: Re: WARNING at fs/ext4/inode.c ext4_evict_inode() triggers on 4.0
Date: Fri, 17 Jun 2016 20:04:34 +0200
Message-ID: <20160617180434.GA427@quack2.suse.cz>
References: <20160615204939.GA52455@calvinowens-mba.dhcp.thefacebook.com>
 <20160616083304.GD22835@quack2.suse.cz>
 <20160617174033.GC72696@calvinowens-mba.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="cNdxnHkX5QqsyA0e"
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
	kernel-team@fb.com
To: Calvin Owens <calvinowens@fb.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37921 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753318AbcFQSEm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Jun 2016 14:04:42 -0400
Content-Disposition: inline
In-Reply-To: <20160617174033.GC72696@calvinowens-mba.dhcp.thefacebook.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri 17-06-16 13:40:33, Calvin Owens wrote:
> On Thursday 06/16 at 10:33 +0200, Jan Kara wrote:
> > Hi Calvin,
> > 
> > On Wed 15-06-16 16:49:39, Calvin Owens wrote:
> > > I'm hitting the following warning on a 4.0 kernel:
> > > 
> > >   WARNING: CPU: 15 PID: 1005611 at fs/ext4/inode.c:233 ext4_evict_inode+0x4be/0x4d0()
> > >   CPU: 15 PID: 1005611 Comm: rocksdb:bg0 Not tainted 4.0.9-60_fbk10_rc1_3974_g796b9b6 #1
> > >   Call Trace: 
> > >   [<ffffffff8176af8e>] dump_stack+0x4d/0x63
> > >   [<ffffffff8106c4dc>] warn_slowpath_common+0x8c/0xd0
> > >   [<ffffffff8106c5da>] warn_slowpath_null+0x1a/0x20
> > >   [<ffffffff81242c0e>] ext4_evict_inode+0x4be/0x4d0
> > >   [<ffffffff811d248b>] evict+0xbb/0x190 
> > >   [<ffffffff811d2d6d>] iput+0x17d/0x1e0
> > >   [<ffffffff811ce0e0>] __dentry_kill+0x190/0x1e0
> > >   [<ffffffff811ce2d1>] dput+0x1a1/0x1f0
> > >   [<ffffffff811b952a>] __fput+0x17a/0x210
> > >   [<ffffffff811b960e>] ____fput+0xe/0x10
> > >   [<ffffffff81086dbf>] task_work_run+0xbf/0x100 
> > >   [<ffffffff81002bcc>] do_notify_resume+0x7c/0x90
> > >   [<ffffffff81771529>] int_signal+0x12/0x17
> > > 
> > > Commit 822dbba ("ext4: fix warning in ext4_evict_inode()") proportedly fixed
> > > this in 3.11. The check was entirely removed in 4.6.
> > 
> > OK, so this is the warning:
> > 
> > WARN_ON(atomic_read(&EXT4_I(inode)->i_ioend_count));
> > 
> > It was removed in 4.6 since we maintained i_ioend_count only to be able to
> > do this check and it didn't trigger for a long time. So it is interesting
> > that it actually triggered for you with 4.0.
> > 
> > > Is it interesting to you that this triggers on 4.0? I can revert 600be30 and
> > > see if I can reproduce it on upstream, but since the check got removed I
> > > was wondering if there was post-4.0 work that makes it obsolete?
> > 
> > It would be great. I'm attaching a revert and an additional debug patch. If
> > you can run with these two on the latest kernel (or even just apply the debug
> > patch on top of 4.0) and reproduce the issue with it, I would be grateful.
> 
> Forgot to attach the patches? Or did my mailserver eat them? :)

Sorry, probably forgot to attach. Here they are.

									Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

--cNdxnHkX5QqsyA0e
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-Revert-ext4-remove-i_ioend_count.patch"

>From 55bde5feb7aa94812b82de615db4effee12bc196 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 16 Jun 2016 10:22:50 +0200
Subject: [PATCH 1/2] Revert "ext4: remove i_ioend_count"

This reverts commit 600be30a8bc1d405f791e01dbef84679e14529b8.
---
 fs/ext4/ext4.h    | 7 ++++++-
 fs/ext4/inode.c   | 3 +++
 fs/ext4/page-io.c | 4 ++++
 fs/ext4/super.c   | 1 +
 4 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index b84aa1ca480a..d64fc259590f 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1063,8 +1063,13 @@ struct ext4_inode_info {
 	 * transaction reserved
 	 */
 	struct list_head i_rsv_conversion_list;
-	struct work_struct i_rsv_conversion_work;
+	/*
+	 * Completed IOs that need unwritten extents handling and don't have
+	 * transaction reserved
+	 */
+	atomic_t i_ioend_count;	/* Number of outstanding io_end structs */
 	atomic_t i_unwritten; /* Nr. of inflight conversions pending */
+	struct work_struct i_rsv_conversion_work;
 
 	spinlock_t i_block_reservation_lock;
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f7140ca66e3b..cb00e5949bc3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -216,6 +216,7 @@ void ext4_evict_inode(struct inode *inode)
 		}
 		truncate_inode_pages_final(&inode->i_data);
 
+		WARN_ON(atomic_read(&EXT4_I(inode)->i_ioend_count));
 		goto no_delete;
 	}
 
@@ -227,6 +228,8 @@ void ext4_evict_inode(struct inode *inode)
 		ext4_begin_ordered_truncate(inode, 0);
 	truncate_inode_pages_final(&inode->i_data);
 
+	WARN_ON(atomic_read(&EXT4_I(inode)->i_ioend_count));
+
 	/*
 	 * Protect us against freezing - iput() caller didn't have to have any
 	 * protection against it
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 2a01df9cc1c3..cc5f529e328e 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -129,6 +129,9 @@ static void ext4_release_io_end(ext4_io_end_t *io_end)
 	BUG_ON(io_end->flag & EXT4_IO_END_UNWRITTEN);
 	WARN_ON(io_end->handle);
 
+	if (atomic_dec_and_test(&EXT4_I(io_end->inode)->i_ioend_count))
+		wake_up_all(ext4_ioend_wq(io_end->inode));
+
 	for (bio = io_end->bio; bio; bio = next_bio) {
 		next_bio = bio->bi_private;
 		ext4_finish_bio(bio);
@@ -253,6 +256,7 @@ ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags)
 {
 	ext4_io_end_t *io = kmem_cache_zalloc(io_end_cachep, flags);
 	if (io) {
+		atomic_inc(&EXT4_I(inode)->i_ioend_count);
 		io->inode = inode;
 		INIT_LIST_HEAD(&io->list);
 		atomic_set(&io->count, 1);
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3822a5aedc61..221ec29afde6 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -943,6 +943,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 	spin_lock_init(&ei->i_completed_io_lock);
 	ei->i_sync_tid = 0;
 	ei->i_datasync_tid = 0;
+	atomic_set(&ei->i_ioend_count, 0);
 	atomic_set(&ei->i_unwritten, 0);
 	INIT_WORK(&ei->i_rsv_conversion_work, ext4_end_io_rsv_work);
 #ifdef CONFIG_EXT4_FS_ENCRYPTION
-- 
2.6.6


--cNdxnHkX5QqsyA0e
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0002-ext4-Debug-outstanding-io_ends.patch"

>From 51f4400d9c0c7d3be9be84ed8ebadd8ea27490ec Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 16 Oct 2013 20:32:58 +0200
Subject: [PATCH 2/2] ext4: Debug outstanding io_ends

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4.h    |  3 +++
 fs/ext4/inode.c   | 24 ++++++++++++++++++++++--
 fs/ext4/page-io.c | 11 +++++++++++
 3 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index d64fc259590f..9b56f6981b0a 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -189,6 +189,7 @@ struct ext4_map_blocks {
  */
 typedef struct ext4_io_end {
 	struct list_head	list;		/* per-file finished IO list */
+	struct list_head	full_list;
 	handle_t		*handle;	/* handle reserved for extent
 						 * conversion */
 	struct inode		*inode;		/* file being written to */
@@ -198,6 +199,7 @@ typedef struct ext4_io_end {
 	atomic_t		count;		/* reference counter */
 	loff_t			offset;		/* offset in the file */
 	ssize_t			size;		/* size of the extent */
+	unsigned long		created_at;
 } ext4_io_end_t;
 
 struct ext4_io_submit {
@@ -1063,6 +1065,7 @@ struct ext4_inode_info {
 	 * transaction reserved
 	 */
 	struct list_head i_rsv_conversion_list;
+	struct list_head i_ioend_list;
 	/*
 	 * Completed IOs that need unwritten extents handling and don't have
 	 * transaction reserved
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cb00e5949bc3..187d63b5a1eb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -176,6 +176,20 @@ int ext4_truncate_restart_trans(handle_t *handle, struct inode *inode,
 	return ret;
 }
 
+static void dump_ioends(struct inode *inode, struct list_head *head)
+{
+	ext4_io_end_t *io;
+	unsigned long flags;
+
+	spin_lock_irqsave(&EXT4_I(inode)->i_completed_io_lock, flags);
+	list_for_each_entry(io, head, full_list) {
+		printk("ioend %p, created at 0x%lx: handle=%p, bio=%p, flag=%u, offset=%lu, len=%u, count=%d\n",
+			io, io->created_at, io->handle, io->bio, io->flag, (unsigned long)io->offset,
+			(unsigned)io->size, (int)atomic_read(&io->count));
+	}
+	spin_unlock_irqrestore(&EXT4_I(inode)->i_completed_io_lock, flags);
+}
+
 /*
  * Called at the last iput() if i_nlink is zero.
  */
@@ -216,7 +230,10 @@ void ext4_evict_inode(struct inode *inode)
 		}
 		truncate_inode_pages_final(&inode->i_data);
 
-		WARN_ON(atomic_read(&EXT4_I(inode)->i_ioend_count));
+		if (WARN_ON(atomic_read(&EXT4_I(inode)->i_ioend_count))) {
+			printk("ioend_count=%d, i_unwritten=%d\n", (int)atomic_read(&EXT4_I(inode)->i_ioend_count), (int)atomic_read(&EXT4_I(inode)->i_unwritten));
+			dump_ioends(inode, &EXT4_I(inode)->i_ioend_list);
+		}
 		goto no_delete;
 	}
 
@@ -228,7 +245,10 @@ void ext4_evict_inode(struct inode *inode)
 		ext4_begin_ordered_truncate(inode, 0);
 	truncate_inode_pages_final(&inode->i_data);
 
-	WARN_ON(atomic_read(&EXT4_I(inode)->i_ioend_count));
+	if (WARN_ON(atomic_read(&EXT4_I(inode)->i_ioend_count))) {
+		printk("ioend_count=%d, i_unwritten=%d\n", (int)atomic_read(&EXT4_I(inode)->i_ioend_count), (int)atomic_read(&EXT4_I(inode)->i_unwritten));
+		dump_ioends(inode, &EXT4_I(inode)->i_ioend_list);
+	}
 
 	/*
 	 * Protect us against freezing - iput() caller didn't have to have any
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index cc5f529e328e..9a90dedc8e7b 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -124,6 +124,7 @@ static void ext4_finish_bio(struct bio *bio)
 static void ext4_release_io_end(ext4_io_end_t *io_end)
 {
 	struct bio *bio, *next_bio;
+	unsigned long flags;
 
 	BUG_ON(!list_empty(&io_end->list));
 	BUG_ON(io_end->flag & EXT4_IO_END_UNWRITTEN);
@@ -132,6 +133,10 @@ static void ext4_release_io_end(ext4_io_end_t *io_end)
 	if (atomic_dec_and_test(&EXT4_I(io_end->inode)->i_ioend_count))
 		wake_up_all(ext4_ioend_wq(io_end->inode));
 
+	spin_lock_irqsave(&EXT4_I(io_end->inode)->i_completed_io_lock, flags);
+	list_del(&io_end->full_list);
+	spin_unlock_irqrestore(&EXT4_I(io_end->inode)->i_completed_io_lock, flags);
+
 	for (bio = io_end->bio; bio; bio = next_bio) {
 		next_bio = bio->bi_private;
 		ext4_finish_bio(bio);
@@ -256,10 +261,16 @@ ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags)
 {
 	ext4_io_end_t *io = kmem_cache_zalloc(io_end_cachep, flags);
 	if (io) {
+		unsigned long flags;
+
+		spin_lock_irqsave(&EXT4_I(inode)->i_completed_io_lock, flags);
+		list_add(&io->full_list, &EXT4_I(inode)->i_ioend_list);
+		spin_unlock_irqrestore(&EXT4_I(inode)->i_completed_io_lock, flags);
 		atomic_inc(&EXT4_I(inode)->i_ioend_count);
 		io->inode = inode;
 		INIT_LIST_HEAD(&io->list);
 		atomic_set(&io->count, 1);
+		io->created_at = _RET_IP_;
 	}
 	return io;
 }
-- 
2.6.6


--cNdxnHkX5QqsyA0e--
