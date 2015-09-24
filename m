From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.3-fixes] cgroup, writeback: don't enable
 cgroup writeback on traditional hierarchies
Date: Thu, 24 Sep 2015 16:45:29 -0400
Message-ID: <20150924204529.GF25415@mtj.duckdns.org>
References: <1434495193-31182-1-git-send-email-tj@kernel.org>
 <1434495193-31182-3-git-send-email-tj@kernel.org>
 <20150722035620.GD2944@thunk.org>
 <1443012552.19983.209.camel@gmail.com>
 <20150923180934.GE26647@mtj.duckdns.org>
 <20150923185137.GJ26647@mtj.duckdns.org>
 <20150923210729.GA23180@mtj.duckdns.org>
 <1443082186.19983.234.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org,
	kernel-team-b10kYP2dOMg@public.gmane.org, adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dexuan Cui <decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Artem Bityutskiy <dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1443082186.19983.234.camel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Hello, Artem.

On Thu, Sep 24, 2015 at 11:09:46AM +0300, Artem Bityutskiy wrote:
> On Wed, 2015-09-23 at 17:07 -0400, Tejun Heo wrote:
> > So, this should make the regression go away.  It doesn't fix the
> > underlying bugs but they shouldn't get triggered by people not
> > experimenting with cgroup.
> 
> this hits the nail on the head and makes the problem go away.

Yeah but there still is an underlying problem here.  I've been going
through the sync path today but can't trigger or spot anything wrong.
Can you please apply the patch at the end of this mail, trigger the
failure and report the kernel log?

Thanks a lot.

---
 fs/fs-writeback.c           |  154 ++++++++++++++++++++++++++++++++++++++++++--
 fs/inode.c                  |    1 
 include/linux/backing-dev.h |   20 +++++
 include/linux/fs.h          |    2 
 mm/backing-dev.c            |    2 
 5 files changed, 171 insertions(+), 8 deletions(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -101,7 +101,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(wbc_writepa
 
 static bool wb_io_lists_populated(struct bdi_writeback *wb)
 {
-	if (wb_has_dirty_io(wb)) {
+	if (test_bit(WB_has_dirty_io, &wb->state)) {
 		return false;
 	} else {
 		set_bit(WB_has_dirty_io, &wb->state);
@@ -763,6 +763,15 @@ static long wb_split_bdi_pages(struct bd
 		return DIV_ROUND_UP_ULL((u64)nr_pages * this_bw, tot_bw);
 }
 
+extern spinlock_t cgwb_lock;
+
+struct split_work_dbg {
+	DECLARE_BITMAP(all_wbs, 8192);
+	DECLARE_BITMAP(iterated_wbs, 8192);
+	DECLARE_BITMAP(written_wbs, 8192);
+	DECLARE_BITMAP(sync_wbs, 8192);
+};
+
 /**
  * bdi_split_work_to_wbs - split a wb_writeback_work to all wb's of a bdi
  * @bdi: target backing_dev_info
@@ -776,11 +785,25 @@ static long wb_split_bdi_pages(struct bd
  */
 static void bdi_split_work_to_wbs(struct backing_dev_info *bdi,
 				  struct wb_writeback_work *base_work,
-				  bool skip_if_busy)
+				  bool skip_if_busy, struct split_work_dbg *dbg)
 {
 	int next_memcg_id = 0;
 	struct bdi_writeback *wb;
 	struct wb_iter iter;
+	struct radix_tree_iter riter;
+	void **slot;
+
+	if (dbg) {
+		spin_lock_irq(&cgwb_lock);
+		set_bit(bdi->wb.memcg_css->id, dbg->all_wbs);
+		bdi->wb.last_comp_gen = bdi->wb.comp_gen;
+		radix_tree_for_each_slot(slot, &bdi->cgwb_tree, &riter, 0) {
+			wb = *slot;
+			set_bit(wb->memcg_css->id, dbg->all_wbs);
+			wb->last_comp_gen = wb->comp_gen;
+		}
+		spin_unlock_irq(&cgwb_lock);
+	}
 
 	might_sleep();
 restart:
@@ -791,6 +814,9 @@ restart:
 		struct wb_writeback_work *work;
 		long nr_pages;
 
+		if (dbg)
+			set_bit(wb->memcg_css->id, dbg->iterated_wbs);
+
 		/* SYNC_ALL writes out I_DIRTY_TIME too */
 		if (!wb_has_dirty_io(wb) &&
 		    (base_work->sync_mode == WB_SYNC_NONE ||
@@ -799,6 +825,9 @@ restart:
 		if (skip_if_busy && writeback_in_progress(wb))
 			continue;
 
+		if (dbg)
+			set_bit(wb->memcg_css->id, dbg->written_wbs);
+
 		nr_pages = wb_split_bdi_pages(wb, base_work->nr_pages);
 
 		work = kmalloc(sizeof(*work), GFP_ATOMIC);
@@ -817,6 +846,8 @@ restart:
 		work->auto_free = 0;
 		work->done = &fallback_work_done;
 
+		if (dbg)
+			set_bit(wb->memcg_css->id, dbg->sync_wbs);
 		wb_queue_work(wb, work);
 
 		next_memcg_id = wb->memcg_css->id + 1;
@@ -1425,6 +1456,9 @@ static long writeback_sb_inodes(struct s
 			break;
 		}
 
+		inode->i_dbg_marker = 0;
+		inode->i_dbg_marker2 = 0;
+
 		/*
 		 * Don't bother with new inodes or inodes being freed, first
 		 * kind does not need periodic writeout yet, and for the latter
@@ -1515,6 +1549,7 @@ static long writeback_sb_inodes(struct s
 				break;
 		}
 	}
+
 	return wrote;
 }
 
@@ -1574,6 +1609,28 @@ static long writeback_inodes_wb(struct b
 	return nr_pages - work.nr_pages;
 }
 
+static int inode_which_wb_io_list(struct inode *inode, struct backing_dev_info *bdi)
+{
+	struct bdi_writeback *wb = inode->i_wb ?: &bdi->wb;
+	struct inode *pos;
+
+	if (list_empty(&inode->i_io_list))
+		return 0;
+	list_for_each_entry(pos, &wb->b_dirty, i_io_list)
+		if (pos == inode)
+			return 1;
+	list_for_each_entry(pos, &wb->b_io, i_io_list)
+		if (pos == inode)
+			return 2;
+	list_for_each_entry(pos, &wb->b_more_io, i_io_list)
+		if (pos == inode)
+			return 3;
+	list_for_each_entry(pos, &wb->b_dirty_time, i_io_list)
+		if (pos == inode)
+			return 4;
+	return 5;
+}
+
 /*
  * Explicit flushing or periodic writeback of "old" data.
  *
@@ -1604,6 +1661,16 @@ static long wb_writeback(struct bdi_writ
 
 	blk_start_plug(&plug);
 	spin_lock(&wb->list_lock);
+
+	list_for_each_entry(inode, &wb->b_dirty, i_io_list)
+		inode->i_dbg_marker2 = 1;
+	list_for_each_entry(inode, &wb->b_io, i_io_list)
+		inode->i_dbg_marker2 = 2;
+	list_for_each_entry(inode, &wb->b_more_io, i_io_list)
+		inode->i_dbg_marker2 = 3;
+	list_for_each_entry(inode, &wb->b_dirty_time, i_io_list)
+		inode->i_dbg_marker2 = 4;
+
 	for (;;) {
 		/*
 		 * Stop writeback when nr_pages has been consumed
@@ -1681,6 +1748,24 @@ static long wb_writeback(struct bdi_writ
 			spin_lock(&wb->list_lock);
 		}
 	}
+
+	if (work->sync_mode == WB_SYNC_ALL) {
+		list_for_each_entry(inode, &wb->b_dirty, i_io_list)
+			if (inode->i_dbg_marker2)
+				printk("XXX wb_writeback: inode %lu marker2=%d on b_dirty\n",
+				       inode->i_ino, inode->i_dbg_marker2);
+		list_for_each_entry(inode, &wb->b_io, i_io_list)
+			printk("XXX wb_writeback: inode %lu marker2=%d on b_io\n",
+			       inode->i_ino, inode->i_dbg_marker2);
+		list_for_each_entry(inode, &wb->b_more_io, i_io_list)
+			printk("XXX wb_writeback: inode %lu marker2=%d on b_more_io\n",
+			       inode->i_ino, inode->i_dbg_marker2);
+		list_for_each_entry(inode, &wb->b_dirty_time, i_io_list)
+			if (inode->i_dbg_marker2)
+				printk("XXX wb_writeback: inode %lu marker2=%d on b_dirty_time\n",
+				       inode->i_ino, inode->i_dbg_marker2);
+	}
+
 	spin_unlock(&wb->list_lock);
 	blk_finish_plug(&plug);
 
@@ -1785,8 +1870,11 @@ static long wb_do_writeback(struct bdi_w
 
 		if (work->auto_free)
 			kfree(work);
-		if (done && atomic_dec_and_test(&done->cnt))
-			wake_up_all(&wb->bdi->wb_waitq);
+		if (done) {
+			wb->comp_gen++;
+			if (atomic_dec_and_test(&done->cnt))
+				wake_up_all(&wb->bdi->wb_waitq);
+		}
 	}
 
 	/*
@@ -1976,6 +2064,9 @@ void __mark_inode_dirty(struct inode *in
 
 	trace_writeback_mark_inode_dirty(inode, flags);
 
+	WARN_ON_ONCE(!(sb->s_flags & MS_LAZYTIME) &&
+		     !list_empty(&inode_to_bdi(inode)->wb.b_dirty_time));
+
 	/*
 	 * Don't do this for I_DIRTY_PAGES - that doesn't actually
 	 * dirty the inode itself
@@ -2165,7 +2256,7 @@ static void __writeback_inodes_sb_nr(str
 		return;
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	bdi_split_work_to_wbs(sb->s_bdi, &work, skip_if_busy);
+	bdi_split_work_to_wbs(sb->s_bdi, &work, skip_if_busy, NULL);
 	wb_wait_for_completion(bdi, &done);
 }
 
@@ -2257,6 +2348,10 @@ void sync_inodes_sb(struct super_block *
 		.for_sync	= 1,
 	};
 	struct backing_dev_info *bdi = sb->s_bdi;
+	static DEFINE_MUTEX(dbg_mutex);
+	static struct split_work_dbg dbg;
+	static DECLARE_BITMAP(tmp_bitmap, 8192);
+	struct inode *inode;
 
 	/*
 	 * Can't skip on !bdi_has_dirty() because we should wait for !dirty
@@ -2267,9 +2362,56 @@ void sync_inodes_sb(struct super_block *
 		return;
 	WARN_ON(!rwsem_is_locked(&sb->s_umount));
 
-	bdi_split_work_to_wbs(bdi, &work, false);
+	mutex_lock(&dbg_mutex);
+
+	printk("XXX SYNCING %d:%d\n", MAJOR(sb->s_dev), MINOR(sb->s_dev));
+
+	bitmap_zero(dbg.all_wbs, 8192);
+	bitmap_zero(dbg.iterated_wbs, 8192);
+	bitmap_zero(dbg.written_wbs, 8192);
+	bitmap_zero(dbg.sync_wbs, 8192);
+
+	spin_lock(&sb->s_inode_list_lock);
+	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+		spin_lock(&inode->i_lock);
+		inode->i_dbg_marker = inode_which_wb_io_list(inode, bdi);
+		spin_unlock(&inode->i_lock);
+	}
+	spin_unlock(&sb->s_inode_list_lock);
+
+	bdi_split_work_to_wbs(bdi, &work, false, &dbg);
 	wb_wait_for_completion(bdi, &done);
 
+	spin_lock(&sb->s_inode_list_lock);
+	list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
+		struct bdi_writeback *wb = inode->i_wb ?: &bdi->wb;
+
+		if (!inode->i_dbg_marker)
+			continue;
+
+		spin_lock_irq(&wb->list_lock);
+		if (inode->i_state & I_DIRTY_ALL)
+			printk("XXX sync_inodes_sb(%d:%d): dirty inode %lu skipped, wb=%d comp_gen=%d->%d which=%d->%d i_state=0x%lx\n",
+			       MAJOR(sb->s_dev), MINOR(sb->s_dev), inode->i_ino,
+			       wb->memcg_css->id, wb->last_comp_gen, wb->comp_gen,
+			       inode->i_dbg_marker, inode_which_wb_io_list(inode, bdi),
+			       inode->i_state);
+		spin_unlock_irq(&wb->list_lock);
+	}
+	spin_unlock(&sb->s_inode_list_lock);
+
+	bitmap_andnot(tmp_bitmap, dbg.all_wbs, dbg.iterated_wbs, 8192);
+	if (!bitmap_empty(tmp_bitmap, 8192))
+		printk("XXX sync_inodes_sb(%d:%d): iteration skipped %8192pbl\n",
+		       MAJOR(sb->s_dev), MINOR(sb->s_dev), tmp_bitmap);
+
+	printk("XXX all_wbs      = %8192pbl\n", dbg.all_wbs);
+	printk("XXX iterated_wbs = %8192pbl\n", dbg.iterated_wbs);
+	printk("XXX written_wbs  = %8192pbl\n", dbg.written_wbs);
+	printk("XXX sync_wbs     = %8192pbl\n", dbg.sync_wbs);
+
+	mutex_unlock(&dbg_mutex);
+
 	wait_sb_inodes(sb);
 }
 EXPORT_SYMBOL(sync_inodes_sb);
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -183,6 +183,7 @@ int inode_init_always(struct super_block
 #endif
 	inode->i_flctx = NULL;
 	this_cpu_inc(nr_inodes);
+	inode->i_dbg_marker = 0;
 
 	return 0;
 out:
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -38,7 +38,25 @@ extern struct workqueue_struct *bdi_wq;
 
 static inline bool wb_has_dirty_io(struct bdi_writeback *wb)
 {
-	return test_bit(WB_has_dirty_io, &wb->state);
+	bool ret = test_bit(WB_has_dirty_io, &wb->state);
+	long tot_write_bw = atomic_long_read(&wb->bdi->tot_write_bandwidth);
+
+	if (!ret && (!list_empty(&wb->b_dirty) || !list_empty(&wb->b_io) ||
+		     !list_empty(&wb->b_more_io))) {
+		const char *name = wb->bdi->dev ? dev_name(wb->bdi->dev) : "UNK";
+
+		pr_err("wb_has_dirty_io: ERR %s has_dirty=%d b_dirty=%d b_io=%d b_more_io=%d\n",
+		       name, ret, !list_empty(&wb->b_dirty), !list_empty(&wb->b_io), !list_empty(&wb->b_more_io));
+		WARN_ON(1);
+	}
+	if (ret && !tot_write_bw) {
+		const char *name = wb->bdi->dev ? dev_name(wb->bdi->dev) : "UNK";
+
+		pr_err("wb_has_dirty_io: ERR %s has_dirty=%d but tot_write_bw=%ld\n",
+		       name, ret, tot_write_bw);
+		WARN_ON(1);
+	}
+	return ret;
 }
 
 static inline bool bdi_has_dirty_io(struct backing_dev_info *bdi)
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -677,6 +677,8 @@ struct inode {
 #endif
 
 	void			*i_private; /* fs or device private pointer */
+	unsigned		i_dbg_marker;
+	unsigned		i_dbg_marker2;
 };
 
 static inline int inode_unhashed(struct inode *inode)
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -382,7 +382,7 @@ static void wb_exit(struct bdi_writeback
  * protected.  cgwb_release_wait is used to wait for the completion of cgwb
  * releases from bdi destruction path.
  */
-static DEFINE_SPINLOCK(cgwb_lock);
+DEFINE_SPINLOCK(cgwb_lock);
 static DECLARE_WAIT_QUEUE_HEAD(cgwb_release_wait);
 
 /**
