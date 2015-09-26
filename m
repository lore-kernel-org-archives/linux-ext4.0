From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH cgroup/for-4.3-fixes] cgroup, writeback: don't enable
 cgroup writeback on traditional hierarchies
Date: Sat, 26 Sep 2015 18:14:13 -0400
Message-ID: <20150926221413.GI3572@htj.duckdns.org>
References: <1443012552.19983.209.camel@gmail.com>
 <20150923180934.GE26647@mtj.duckdns.org>
 <20150923185137.GJ26647@mtj.duckdns.org>
 <20150923210729.GA23180@mtj.duckdns.org>
 <1443082186.19983.234.camel@gmail.com>
 <20150924204529.GF25415@mtj.duckdns.org>
 <1443163749.19983.254.camel@gmail.com>
 <1443178222.10230.10.camel@gmail.com>
 <20150925154925.GH4449@mtj.duckdns.org>
 <1443254768.16309.46.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, axboe@kernel.dk,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	lizefan@huawei.com, cgroups@vger.kernel.org, hannes@cmpxchg.org,
	kernel-team@fb.com, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, Dexuan Cui <decui@microsoft.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1443254768.16309.46.camel@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello, Artem.

Thanks a lot for the debug dump.  Can you please test whether the
below patch fixes the issue?

Index: work/mm/page-writeback.c
===================================================================
--- work.orig/mm/page-writeback.c
+++ work/mm/page-writeback.c
@@ -1956,7 +1956,6 @@ void laptop_mode_timer_fn(unsigned long
 	int nr_pages = global_page_state(NR_FILE_DIRTY) +
 		global_page_state(NR_UNSTABLE_NFS);
 	struct bdi_writeback *wb;
-	struct wb_iter iter;
 
 	/*
 	 * We want to write everything out, not just down to the dirty
@@ -1965,10 +1964,12 @@ void laptop_mode_timer_fn(unsigned long
 	if (!bdi_has_dirty_io(&q->backing_dev_info))
 		return;
 
-	bdi_for_each_wb(wb, &q->backing_dev_info, &iter, 0)
+	rcu_read_lock();
+	list_for_each_entry_rcu(wb, &q->backing_dev_info.wb_list, bdi_node)
 		if (wb_has_dirty_io(wb))
 			wb_start_writeback(wb, nr_pages, true,
 					   WB_REASON_LAPTOP_TIMER);
+	rcu_read_unlock();
 }
 
 /*
Index: work/fs/fs-writeback.c
===================================================================
--- work.orig/fs/fs-writeback.c
+++ work/fs/fs-writeback.c
@@ -778,19 +778,24 @@ static void bdi_split_work_to_wbs(struct
 				  struct wb_writeback_work *base_work,
 				  bool skip_if_busy)
 {
-	int next_memcg_id = 0;
-	struct bdi_writeback *wb;
-	struct wb_iter iter;
+	struct bdi_writeback *last_wb = NULL;
+	struct bdi_writeback *wb = list_entry_rcu(&bdi->wb_list,
+						struct bdi_writeback, bdi_node);
 
 	might_sleep();
 restart:
 	rcu_read_lock();
-	bdi_for_each_wb(wb, bdi, &iter, next_memcg_id) {
+	list_for_each_entry_continue_rcu(wb, &bdi->wb_list, bdi_node) {
 		DEFINE_WB_COMPLETION_ONSTACK(fallback_work_done);
 		struct wb_writeback_work fallback_work;
 		struct wb_writeback_work *work;
 		long nr_pages;
 
+		if (last_wb) {
+			wb_put(last_wb);
+			last_wb = NULL;
+		}
+
 		/* SYNC_ALL writes out I_DIRTY_TIME too */
 		if (!wb_has_dirty_io(wb) &&
 		    (base_work->sync_mode == WB_SYNC_NONE ||
@@ -819,7 +824,14 @@ restart:
 
 		wb_queue_work(wb, work);
 
-		next_memcg_id = wb->memcg_css->id + 1;
+		/*
+		 * Pin @wb so that it stays on @bdi->wb_list.  This allows
+		 * continuing iteration from @wb after dropping regrabbing
+		 * rcu read lock.
+		 */
+		wb_get(wb);
+		last_wb = wb;
+
 		rcu_read_unlock();
 		wb_wait_for_completion(bdi, &fallback_work_done);
 		goto restart;
@@ -1857,12 +1869,11 @@ void wakeup_flusher_threads(long nr_page
 	rcu_read_lock();
 	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list) {
 		struct bdi_writeback *wb;
-		struct wb_iter iter;
 
 		if (!bdi_has_dirty_io(bdi))
 			continue;
 
-		bdi_for_each_wb(wb, bdi, &iter, 0)
+		list_for_each_entry_rcu(wb, &bdi->wb_list, bdi_node)
 			wb_start_writeback(wb, wb_split_bdi_pages(wb, nr_pages),
 					   false, reason);
 	}
@@ -1894,11 +1905,10 @@ static void wakeup_dirtytime_writeback(s
 	rcu_read_lock();
 	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list) {
 		struct bdi_writeback *wb;
-		struct wb_iter iter;
 
-		bdi_for_each_wb(wb, bdi, &iter, 0)
-			if (!list_empty(&bdi->wb.b_dirty_time))
-				wb_wakeup(&bdi->wb);
+		list_for_each_entry_rcu(wb, &bdi->wb_list, bdi_node)
+			if (!list_empty(&wb->b_dirty_time))
+				wb_wakeup(wb);
 	}
 	rcu_read_unlock();
 	schedule_delayed_work(&dirtytime_work, dirtytime_expire_interval * HZ);
Index: work/include/linux/backing-dev-defs.h
===================================================================
--- work.orig/include/linux/backing-dev-defs.h
+++ work/include/linux/backing-dev-defs.h
@@ -116,6 +116,8 @@ struct bdi_writeback {
 	struct list_head work_list;
 	struct delayed_work dwork;	/* work item used for writeback */
 
+	struct list_head bdi_node;	/* anchored at bdi->wb_list */
+
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct percpu_ref refcnt;	/* used only for !root wb's */
 	struct fprop_local_percpu memcg_completions;
@@ -150,6 +152,7 @@ struct backing_dev_info {
 	atomic_long_t tot_write_bandwidth;
 
 	struct bdi_writeback wb;  /* the root writeback info for this bdi */
+	struct list_head wb_list; /* list of all wbs */
 #ifdef CONFIG_CGROUP_WRITEBACK
 	struct radix_tree_root cgwb_tree; /* radix tree of active cgroup wbs */
 	struct rb_root cgwb_congested_tree; /* their congested states */
Index: work/include/linux/backing-dev.h
===================================================================
--- work.orig/include/linux/backing-dev.h
+++ work/include/linux/backing-dev.h
@@ -401,61 +401,6 @@ static inline void unlocked_inode_to_wb_
 	rcu_read_unlock();
 }
 
-struct wb_iter {
-	int			start_memcg_id;
-	struct radix_tree_iter	tree_iter;
-	void			**slot;
-};
-
-static inline struct bdi_writeback *__wb_iter_next(struct wb_iter *iter,
-						   struct backing_dev_info *bdi)
-{
-	struct radix_tree_iter *titer = &iter->tree_iter;
-
-	WARN_ON_ONCE(!rcu_read_lock_held());
-
-	if (iter->start_memcg_id >= 0) {
-		iter->slot = radix_tree_iter_init(titer, iter->start_memcg_id);
-		iter->start_memcg_id = -1;
-	} else {
-		iter->slot = radix_tree_next_slot(iter->slot, titer, 0);
-	}
-
-	if (!iter->slot)
-		iter->slot = radix_tree_next_chunk(&bdi->cgwb_tree, titer, 0);
-	if (iter->slot)
-		return *iter->slot;
-	return NULL;
-}
-
-static inline struct bdi_writeback *__wb_iter_init(struct wb_iter *iter,
-						   struct backing_dev_info *bdi,
-						   int start_memcg_id)
-{
-	iter->start_memcg_id = start_memcg_id;
-
-	if (start_memcg_id)
-		return __wb_iter_next(iter, bdi);
-	else
-		return &bdi->wb;
-}
-
-/**
- * bdi_for_each_wb - walk all wb's of a bdi in ascending memcg ID order
- * @wb_cur: cursor struct bdi_writeback pointer
- * @bdi: bdi to walk wb's of
- * @iter: pointer to struct wb_iter to be used as iteration buffer
- * @start_memcg_id: memcg ID to start iteration from
- *
- * Iterate @wb_cur through the wb's (bdi_writeback's) of @bdi in ascending
- * memcg ID order starting from @start_memcg_id.  @iter is struct wb_iter
- * to be used as temp storage during iteration.  rcu_read_lock() must be
- * held throughout iteration.
- */
-#define bdi_for_each_wb(wb_cur, bdi, iter, start_memcg_id)		\
-	for ((wb_cur) = __wb_iter_init(iter, bdi, start_memcg_id);	\
-	     (wb_cur); (wb_cur) = __wb_iter_next(iter, bdi))
-
 #else	/* CONFIG_CGROUP_WRITEBACK */
 
 static inline bool inode_cgwb_enabled(struct inode *inode)
@@ -515,14 +460,6 @@ static inline void wb_blkcg_offline(stru
 {
 }
 
-struct wb_iter {
-	int		next_id;
-};
-
-#define bdi_for_each_wb(wb_cur, bdi, iter, start_blkcg_id)		\
-	for ((iter)->next_id = (start_blkcg_id);			\
-	     ({	(wb_cur) = !(iter)->next_id++ ? &(bdi)->wb : NULL; }); )
-
 static inline int inode_congested(struct inode *inode, int cong_bits)
 {
 	return wb_congested(&inode_to_bdi(inode)->wb, cong_bits);
Index: work/mm/backing-dev.c
===================================================================
--- work.orig/mm/backing-dev.c
+++ work/mm/backing-dev.c
@@ -480,6 +480,10 @@ static void cgwb_release_workfn(struct w
 						release_work);
 	struct backing_dev_info *bdi = wb->bdi;
 
+	spin_lock_irq(&cgwb_lock);
+	list_del_rcu(&wb->bdi_node);
+	spin_unlock_irq(&cgwb_lock);
+
 	wb_shutdown(wb);
 
 	css_put(wb->memcg_css);
@@ -575,6 +579,7 @@ static int cgwb_create(struct backing_de
 		ret = radix_tree_insert(&bdi->cgwb_tree, memcg_css->id, wb);
 		if (!ret) {
 			atomic_inc(&bdi->usage_cnt);
+			list_add_tail_rcu(&wb->bdi_node, &bdi->wb_list);
 			list_add(&wb->memcg_node, memcg_cgwb_list);
 			list_add(&wb->blkcg_node, blkcg_cgwb_list);
 			css_get(memcg_css);
@@ -669,6 +674,7 @@ static int cgwb_bdi_init(struct backing_
 	if (!ret) {
 		bdi->wb.memcg_css = mem_cgroup_root_css;
 		bdi->wb.blkcg_css = blkcg_root_css;
+		list_add_tail_rcu(&bdi->wb.bdi_node, &bdi->wb_list);
 	}
 	return ret;
 }
@@ -686,6 +692,9 @@ static void cgwb_bdi_destroy(struct back
 	radix_tree_for_each_slot(slot, &bdi->cgwb_tree, &iter, 0)
 		cgwb_kill(*slot);
 
+	/* release of wb's may happen after @bdi is freed, sever list head */
+	list_del(&bdi->wb_list);
+
 	rbtree_postorder_for_each_entry_safe(congested, congested_n,
 					&bdi->cgwb_congested_tree, rb_node) {
 		rb_erase(&congested->rb_node, &bdi->cgwb_congested_tree);
@@ -755,6 +764,9 @@ static int cgwb_bdi_init(struct backing_
 		kfree(bdi->wb_congested);
 		return err;
 	}
+
+	list_add_tail_rcu(&bdi->wb.bdi_node, &bdi->wb_list);
+
 	return 0;
 }
 
@@ -770,6 +782,7 @@ int bdi_init(struct backing_dev_info *bd
 	bdi->max_ratio = 100;
 	bdi->max_prop_frac = FPROP_FRAC_BASE;
 	INIT_LIST_HEAD(&bdi->bdi_list);
+	INIT_LIST_HEAD(&bdi->wb_list);
 	init_waitqueue_head(&bdi->wb_waitq);
 
 	return cgwb_bdi_init(bdi);
