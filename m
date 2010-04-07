From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch,rfc v2] ext3/4: enhance fsync performance when using cfq
Date: Wed, 07 Apr 2010 17:18:12 -0400
Message-ID: <x49ochv7yi3.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vivek Goyal <vgoyal@redhat.com>, jens.axboe@oracle.com,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab0DGVSU (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Apr 2010 17:18:20 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi again,

So, here's another stab at fixing this.  This patch is very much an RFC,
so do not pull it into anything bound for Linus.  ;-)  For those new to
this topic, here is the original posting:  http://lkml.org/lkml/2010/4/1/344

The basic problem is that, when running iozone on smallish files (up to
8MB in size) and including fsync in the timings, deadline outperforms
CFQ by a factor of about 5 for 64KB files, and by about 10% for 8MB
files.  From examining the blktrace data, it appears that iozone will
issue an fsync() call, and will have to wait until it's CFQ timeslice
has expired before the journal thread can run to actually commit data to
disk.

The approach below puts an explicit call into the filesystem-specific
fsync code to yield the disk so that the jbd[2] process has a chance to
issue I/O.  This bring performance of CFQ in line with deadline.

There is one outstanding issue with the patch that Vivek pointed out.
Basically, this could starve out the sync-noidle workload if there is a
lot of fsync-ing going on.  I'll address that in a follow-on patch.  For
now, I wanted to get the idea out there for others to comment on.

Thanks a ton to Vivek for spotting the problem with the initial
approach, and for his continued review.

Cheers,
Jeff

# git diff --stat
 block/blk-core.c            |   15 +++++++++++++++
 block/cfq-iosched.c         |   38 +++++++++++++++++++++++++++++++++++++-
 block/elevator.c            |    8 ++++++++
 fs/ext3/fsync.c             |    5 ++++-
 fs/ext4/fsync.c             |    6 +++++-
 include/linux/backing-dev.h |   13 +++++++++++++
 include/linux/blkdev.h      |    1 +
 include/linux/elevator.h    |    3 +++
 8 files changed, 86 insertions(+), 3 deletions(-)


diff --git a/block/blk-core.c b/block/blk-core.c
index 9fe174d..1be9413 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -323,6 +323,19 @@ void blk_unplug(struct request_queue *q)
 }
 EXPORT_SYMBOL(blk_unplug);
 
+void blk_backing_dev_yield(struct backing_dev_info *bdi)
+{
+	struct request_queue *q = bdi->yield_data;
+
+	blk_yield(q);
+}
+
+void blk_yield(struct request_queue *q)
+{
+	elv_yield(q);
+}
+EXPORT_SYMBOL(blk_yield);
+
 /**
  * blk_start_queue - restart a previously stopped queue
  * @q:    The &struct request_queue in question
@@ -498,6 +511,8 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 
 	q->backing_dev_info.unplug_io_fn = blk_backing_dev_unplug;
 	q->backing_dev_info.unplug_io_data = q;
+	q->backing_dev_info.yield_fn = blk_backing_dev_yield;
+	q->backing_dev_info.yield_data = q;
 	q->backing_dev_info.ra_pages =
 			(VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
 	q->backing_dev_info.state = 0;
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index dee9d93..a76ccd1 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2065,7 +2065,7 @@ static void cfq_choose_cfqg(struct cfq_data *cfqd)
 	cfqd->serving_group = cfqg;
 
 	/* Restore the workload type data */
-	if (cfqg->saved_workload_slice) {
+	if (cfqg && cfqg->saved_workload_slice) {
 		cfqd->workload_expires = jiffies + cfqg->saved_workload_slice;
 		cfqd->serving_type = cfqg->saved_workload;
 		cfqd->serving_prio = cfqg->saved_serving_prio;
@@ -2163,6 +2163,41 @@ keep_queue:
 	return cfqq;
 }
 
+static void cfq_yield(struct request_queue *q)
+{
+	struct cfq_data *cfqd = q->elevator->elevator_data;
+	struct cfq_io_context *cic;
+	struct cfq_queue *cfqq;
+	unsigned long flags;
+
+	cic = cfq_cic_lookup(cfqd, current->io_context);
+	if (!cic)
+		return;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+
+	/*
+	 * This is primarily called to ensure that the long synchronous
+	 * time slice does not prevent other I/O happenning (like journal
+	 * commits) while we idle waiting for it.  Thus, check to see if the
+	 * current cfqq is the sync cfqq for this process.
+	 */
+	cfqq = cic_to_cfqq(cic, 1);
+	if (!cfqq)
+		goto out_unlock;
+
+	if (cfqd->active_queue != cfqq)
+		goto out_unlock;
+
+	cfq_log_cfqq(cfqd, cfqq, "yielding queue");
+
+	__cfq_slice_expired(cfqd, cfqq, 1);
+	__blk_run_queue(cfqd->queue);
+
+out_unlock:
+	spin_unlock_irqrestore(q->queue_lock, flags);
+}
+
 static int __cfq_forced_dispatch_cfqq(struct cfq_queue *cfqq)
 {
 	int dispatched = 0;
@@ -3854,6 +3889,7 @@ static struct elevator_type iosched_cfq = {
 		.elevator_deactivate_req_fn =	cfq_deactivate_request,
 		.elevator_queue_empty_fn =	cfq_queue_empty,
 		.elevator_completed_req_fn =	cfq_completed_request,
+		.elevator_yield_fn =		cfq_yield,
 		.elevator_former_req_fn =	elv_rb_former_request,
 		.elevator_latter_req_fn =	elv_rb_latter_request,
 		.elevator_set_req_fn =		cfq_set_request,
diff --git a/block/elevator.c b/block/elevator.c
index df75676..2cf6f89 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -855,6 +855,14 @@ void elv_completed_request(struct request_queue *q, struct request *rq)
 	}
 }
 
+void elv_yield(struct request_queue *q)
+{
+	struct elevator_queue *e = q->elevator;
+
+	if (e && e->ops->elevator_yield_fn)
+		e->ops->elevator_yield_fn(q);
+}
+
 #define to_elv(atr) container_of((atr), struct elv_fs_entry, attr)
 
 static ssize_t
diff --git a/fs/ext3/fsync.c b/fs/ext3/fsync.c
index 8209f26..44f9db0 100644
--- a/fs/ext3/fsync.c
+++ b/fs/ext3/fsync.c
@@ -50,6 +50,7 @@ int ext3_sync_file(struct file * file, struct dentry *dentry, int datasync)
 	journal_t *journal = EXT3_SB(inode->i_sb)->s_journal;
 	int ret = 0;
 	tid_t commit_tid;
+	int new_commit;
 
 	if (inode->i_sb->s_flags & MS_RDONLY)
 		return 0;
@@ -80,7 +81,9 @@ int ext3_sync_file(struct file * file, struct dentry *dentry, int datasync)
 	else
 		commit_tid = atomic_read(&ei->i_sync_tid);
 
-	if (log_start_commit(journal, commit_tid)) {
+	new_commit = log_start_commit(journal, commit_tid);
+	blk_yield_backing_dev(inode->i_sb->s_bdi);
+	if (new_commit) {
 		log_wait_commit(journal, commit_tid);
 		goto out;
 	}
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 0d0c323..1630c68 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -55,6 +55,7 @@ int ext4_sync_file(struct file *file, struct dentry *dentry, int datasync)
 	journal_t *journal = EXT4_SB(inode->i_sb)->s_journal;
 	int ret;
 	tid_t commit_tid;
+	int new_commit;
 
 	J_ASSERT(ext4_journal_current_handle() == NULL);
 
@@ -88,7 +89,10 @@ int ext4_sync_file(struct file *file, struct dentry *dentry, int datasync)
 		return ext4_force_commit(inode->i_sb);
 
 	commit_tid = datasync ? ei->i_datasync_tid : ei->i_sync_tid;
-	if (jbd2_log_start_commit(journal, commit_tid)) {
+	new_commit = jbd2_log_start_commit(journal, commit_tid);
+	blk_yield_backing_dev(inode->i_sb->s_bdi);
+
+	if (new_commit) {
 		/*
 		 * When the journal is on a different device than the
 		 * fs data disk, we need to issue the barrier in
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index fcbc26a..5bb6c3f 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -67,6 +67,8 @@ struct backing_dev_info {
 	void *congested_data;	/* Pointer to aux data for congested func */
 	void (*unplug_io_fn)(struct backing_dev_info *, struct page *);
 	void *unplug_io_data;
+	void (*yield_fn)(struct backing_dev_info *);
+	void *yield_data;
 
 	char *name;
 
@@ -344,4 +346,15 @@ static inline void blk_run_address_space(struct address_space *mapping)
 		blk_run_backing_dev(mapping->backing_dev_info, NULL);
 }
 
+static inline void blk_yield_backing_dev(struct backing_dev_info *bdi)
+{
+	if (bdi && bdi->yield_fn)
+		bdi->yield_fn(bdi);
+}
+static inline void blk_yield_address_space(struct address_space *mapping)
+{
+	if (mapping)
+		blk_yield_backing_dev(mapping->backing_dev_info);
+}
+
 #endif		/* _LINUX_BACKING_DEV_H */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ebd22db..83c06d4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -832,6 +832,7 @@ extern int blk_execute_rq(struct request_queue *, struct gendisk *,
 extern void blk_execute_rq_nowait(struct request_queue *, struct gendisk *,
 				  struct request *, int, rq_end_io_fn *);
 extern void blk_unplug(struct request_queue *q);
+extern void blk_yield(struct request_queue *q);
 
 static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
 {
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 1cb3372..9b4e2e9 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -20,6 +20,7 @@ typedef void (elevator_add_req_fn) (struct request_queue *, struct request *);
 typedef int (elevator_queue_empty_fn) (struct request_queue *);
 typedef struct request *(elevator_request_list_fn) (struct request_queue *, struct request *);
 typedef void (elevator_completed_req_fn) (struct request_queue *, struct request *);
+typedef void (elevator_yield_fn) (struct request_queue *);
 typedef int (elevator_may_queue_fn) (struct request_queue *, int);
 
 typedef int (elevator_set_req_fn) (struct request_queue *, struct request *, gfp_t);
@@ -44,6 +45,7 @@ struct elevator_ops
 
 	elevator_queue_empty_fn *elevator_queue_empty_fn;
 	elevator_completed_req_fn *elevator_completed_req_fn;
+	elevator_yield_fn *elevator_yield_fn;
 
 	elevator_request_list_fn *elevator_former_req_fn;
 	elevator_request_list_fn *elevator_latter_req_fn;
@@ -105,6 +107,7 @@ extern void elv_merge_requests(struct request_queue *, struct request *,
 extern void elv_merged_request(struct request_queue *, struct request *, int);
 extern void elv_requeue_request(struct request_queue *, struct request *);
 extern int elv_queue_empty(struct request_queue *);
+extern void elv_yield(struct request_queue *);
 extern struct request *elv_former_request(struct request_queue *, struct request *);
 extern struct request *elv_latter_request(struct request_queue *, struct request *);
 extern int elv_register_queue(struct request_queue *q);
