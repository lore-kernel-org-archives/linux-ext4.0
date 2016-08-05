From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH 1/1] mm/block: convert rw_page users to bio op use
Date: Thu, 4 Aug 2016 22:30:18 -0500
Message-ID: <57A4084A.6020608@redhat.com>
References: <201608050158.hllBWy4G%fengguang.wu@intel.com>
 <38523086-1436-fdbf-bd89-9f31ad134bed@kernel.dk>
 <20160805021854.GV12670@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
	ross.zwisler@linux.intel.com, linux-ext4@vger.kernel.org,
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	minchan@kernel.org, ngupta@vflare.org, vishal.l.verma@intel.com
To: Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756615AbcHEDaW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Aug 2016 23:30:22 -0400
In-Reply-To: <20160805021854.GV12670@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/04/2016 09:18 PM, Dave Chinner wrote:
> On Thu, Aug 04, 2016 at 01:27:37PM -0600, Jens Axboe wrote:
>> On 08/04/2016 11:50 AM, kbuild test robot wrote:
>>> Hi Mike,
>>>
>>> [auto build test ERROR on linus/master]
>>> [also build test ERROR on next-20160804]
>>> [cannot apply to v4.7]
>>> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>>>
>>> url:    https://github.com/0day-ci/linux/commits/Mike-Christie/mm-block-convert-rw_page-users-to-bio-op-use/20160805-012041
>>> config: i386-tinyconfig (attached as .config)
>>> compiler: gcc-6 (Debian 6.1.1-9) 6.1.1 20160705
>>> reproduce:
>>>        # save the attached .config to linux build tree
>>>        make ARCH=i386
>>>
>>> All errors (new ones prefixed by >>):
>>>
>>>   mm/filemap.c: In function 'page_endio':
>>>>> mm/filemap.c:892:7: error: implicit declaration of function 'op_is_write' [-Werror=implicit-function-declaration]
>>>     if (!op_is_write(op)) {
>>>          ^~~~~~~~~~~
>>
>> Mike, how about moving op_is_write() outside of CONFIG_BLOCK protection
>> in fs.h, and making the REQ_OP_* enum generally available as well? That
>> should fix it.
> 
> Give this is being spread all over the kernel way outside the block
> layer and IO path, shouldn't this have some kind of namespace
> component to the name? i.e "req_op_is_write()"?
> 

I made the patch below to do the suggested rename.

Jens, the patch is made over your for-linus branch. I was not sure if
you wanted it for this kernel or since it is just a rename patch for
4.8.




>From 68bd1b7ebea5c447a4e6e6ac15bb0c4f7783e366 Mon Sep 17 00:00:00 2001
From: Mike Christie <mchristi@redhat.com>
Date: Thu, 4 Aug 2016 22:04:01 -0500
Subject: [PATCH 1/1] block, drivers, mm: rename op_is_write to req_op_is_write

Rename op_is_write to req_op_is_write to prevent future naming conflicts.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 block/blk-core.c                 |  4 ++--
 block/blk-merge.c                |  2 +-
 drivers/ata/libata-scsi.c        |  2 +-
 drivers/block/brd.c              |  4 ++--
 drivers/block/drbd/drbd_req.c    |  2 +-
 drivers/block/loop.c             |  4 ++--
 drivers/block/umem.c             |  2 +-
 drivers/block/zram/zram_drv.c    |  4 ++--
 drivers/md/bcache/io.c           |  2 +-
 drivers/md/bcache/request.c      |  6 +++---
 drivers/md/dm-io.c               |  4 ++--
 drivers/md/dm-kcopyd.c           |  6 +++---
 drivers/md/raid5.c               | 10 +++++-----
 drivers/nvdimm/btt.c             |  6 +++---
 drivers/nvdimm/pmem.c            |  2 +-
 drivers/scsi/osd/osd_initiator.c |  4 ++--
 include/linux/blk-cgroup.h       |  2 +-
 include/linux/blkdev.h           |  2 +-
 include/linux/fs.h               |  4 ++--
 kernel/trace/blktrace.c          |  2 +-
 mm/filemap.c                     |  2 +-
 21 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a687e9c..ec5ed53 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2076,7 +2076,7 @@ blk_qc_t submit_bio(struct bio *bio)
 		else
 			count = bio_sectors(bio);
 
-		if (op_is_write(bio_op(bio))) {
+		if (req_op_is_write(bio_op(bio))) {
 			count_vm_events(PGPGOUT, count);
 		} else {
 			task_io_account_read(bio->bi_iter.bi_size);
@@ -2087,7 +2087,7 @@ blk_qc_t submit_bio(struct bio *bio)
 			char b[BDEVNAME_SIZE];
 			printk(KERN_DEBUG "%s(%d): %s block %Lu on %s (%u sectors)\n",
 			current->comm, task_pid_nr(current),
-				op_is_write(bio_op(bio)) ? "WRITE" : "READ",
+				req_op_is_write(bio_op(bio)) ? "WRITE" : "READ",
 				(unsigned long long)bio->bi_iter.bi_sector,
 				bdevname(bio->bi_bdev, b),
 				count);
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 41cbd48..dcb646f 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -439,7 +439,7 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 	}
 
 	if (q->dma_drain_size && q->dma_drain_needed(rq)) {
-		if (op_is_write(req_op(rq)))
+		if (req_op_is_write(req_op(rq)))
 			memset(q->dma_drain_buffer, 0, q->dma_drain_size);
 
 		sg_unmark_end(sg);
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index e207b33..3401881 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1190,7 +1190,7 @@ static int atapi_drain_needed(struct request *rq)
 	if (likely(rq->cmd_type != REQ_TYPE_BLOCK_PC))
 		return 0;
 
-	if (!blk_rq_bytes(rq) || op_is_write(req_op(rq)))
+	if (!blk_rq_bytes(rq) || req_op_is_write(req_op(rq)))
 		return 0;
 
 	return atapi_cmd_type(rq->cmd[0]) == ATAPI_MISC;
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 3439b28..c2dd622 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -306,14 +306,14 @@ static int brd_do_bvec(struct brd_device *brd, struct page *page,
 	void *mem;
 	int err = 0;
 
-	if (op_is_write(op)) {
+	if (req_op_is_write(op)) {
 		err = copy_to_brd_setup(brd, sector, len);
 		if (err)
 			goto out;
 	}
 
 	mem = kmap_atomic(page);
-	if (!op_is_write(op)) {
+	if (!req_op_is_write(op)) {
 		copy_from_brd(mem + off, brd, sector, len);
 		flush_dcache_page(page);
 	} else {
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 66b8e4b..8b0483a 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -265,7 +265,7 @@ void drbd_req_complete(struct drbd_request *req, struct bio_and_error *m)
 	 * epoch number.  If they match, increase the current_tle_nr,
 	 * and reset the transfer log epoch write_cnt.
 	 */
-	if (op_is_write(bio_op(req->master_bio)) &&
+	if (req_op_is_write(bio_op(req->master_bio)) &&
 	    req->epoch == atomic_read(&first_peer_device(device)->connection->current_tle_nr))
 		start_new_tl_epoch(first_peer_device(device)->connection);
 
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index c9f2107..5edfd91 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -447,7 +447,7 @@ static int lo_req_flush(struct loop_device *lo, struct request *rq)
 
 static inline void handle_partial_read(struct loop_cmd *cmd, long bytes)
 {
-	if (bytes < 0 || op_is_write(req_op(cmd->rq)))
+	if (bytes < 0 || req_op_is_write(req_op(cmd->rq)))
 		return;
 
 	if (unlikely(bytes < blk_rq_bytes(cmd->rq))) {
@@ -1665,7 +1665,7 @@ static int loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 static void loop_handle_cmd(struct loop_cmd *cmd)
 {
-	const bool write = op_is_write(req_op(cmd->rq));
+	const bool write = req_op_is_write(req_op(cmd->rq));
 	struct loop_device *lo = cmd->rq->q->queuedata;
 	int ret = 0;
 
diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index d0a3e6d..3125368 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -460,7 +460,7 @@ static void process_page(unsigned long data)
 				le32_to_cpu(desc->local_addr)>>9,
 				le32_to_cpu(desc->transfer_size));
 			dump_dmastat(card, control);
-		} else if (op_is_write(bio_op(bio)) &&
+		} else if (req_op_is_write(bio_op(bio)) &&
 			   le32_to_cpu(desc->local_addr) >> 9 ==
 				card->init_size) {
 			card->init_size += le32_to_cpu(desc->transfer_size) >> 9;
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index ca29649..b3d5e6e 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -851,7 +851,7 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
 	generic_start_io_acct(op, bvec->bv_len >> SECTOR_SHIFT,
 			&zram->disk->part0);
 
-	if (!op_is_write(op)) {
+	if (!req_op_is_write(op)) {
 		atomic64_inc(&zram->stats.num_reads);
 		ret = zram_bvec_read(zram, bvec, index, offset);
 	} else {
@@ -862,7 +862,7 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
 	generic_end_io_acct(op, &zram->disk->part0, start_time);
 
 	if (unlikely(ret)) {
-		if (!op_is_write(op))
+		if (!req_op_is_write(op))
 			atomic64_inc(&zram->stats.failed_reads);
 		else
 			atomic64_inc(&zram->stats.failed_writes);
diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index e97b0ac..0b3ffe2 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -110,7 +110,7 @@ void bch_bbio_count_io_errors(struct cache_set *c, struct bio *bio,
 	struct bbio *b = container_of(bio, struct bbio, bio);
 	struct cache *ca = PTR_CACHE(c, &b->key, 0);
 
-	unsigned threshold = op_is_write(bio_op(bio))
+	unsigned threshold = req_op_is_write(bio_op(bio))
 		? c->congested_write_threshold_us
 		: c->congested_read_threshold_us;
 
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 69f16f4..ee3f8e6 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -383,7 +383,7 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
 
 	if (mode == CACHE_MODE_NONE ||
 	    (mode == CACHE_MODE_WRITEAROUND &&
-	     op_is_write(bio_op(bio))))
+	     req_op_is_write(bio_op(bio))))
 		goto skip;
 
 	if (bio->bi_iter.bi_sector & (c->sb.block_size - 1) ||
@@ -404,7 +404,7 @@ static bool check_should_bypass(struct cached_dev *dc, struct bio *bio)
 
 	if (!congested &&
 	    mode == CACHE_MODE_WRITEBACK &&
-	    op_is_write(bio_op(bio)) &&
+	    req_op_is_write(bio_op(bio)) &&
 	    (bio->bi_rw & REQ_SYNC))
 		goto rescale;
 
@@ -657,7 +657,7 @@ static inline struct search *search_alloc(struct bio *bio,
 	s->cache_miss		= NULL;
 	s->d			= d;
 	s->recoverable		= 1;
-	s->write		= op_is_write(bio_op(bio));
+	s->write		= req_op_is_write(bio_op(bio));
 	s->read_dirty_data	= 0;
 	s->start_time		= jiffies;
 
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index daa03e4..4ce39dc 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -411,7 +411,7 @@ static int sync_io(struct dm_io_client *client, unsigned int num_regions,
 	struct io *io;
 	struct sync_io sio;
 
-	if (num_regions > 1 && !op_is_write(op)) {
+	if (num_regions > 1 && !req_op_is_write(op)) {
 		WARN_ON(1);
 		return -EIO;
 	}
@@ -444,7 +444,7 @@ static int async_io(struct dm_io_client *client, unsigned int num_regions,
 {
 	struct io *io;
 
-	if (num_regions > 1 && !op_is_write(op)) {
+	if (num_regions > 1 && !req_op_is_write(op)) {
 		WARN_ON(1);
 		fn(1, context);
 		return -EIO;
diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index 9e9d04cb..cd84769 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -465,7 +465,7 @@ static void complete_io(unsigned long error, void *context)
 	io_job_finish(kc->throttle);
 
 	if (error) {
-		if (op_is_write(job->rw))
+		if (req_op_is_write(job->rw))
 			job->write_err |= error;
 		else
 			job->read_err = 1;
@@ -477,7 +477,7 @@ static void complete_io(unsigned long error, void *context)
 		}
 	}
 
-	if (op_is_write(job->rw))
+	if (req_op_is_write(job->rw))
 		push(&kc->complete_jobs, job);
 
 	else {
@@ -551,7 +551,7 @@ static int process_jobs(struct list_head *jobs, struct dm_kcopyd_client *kc,
 
 		if (r < 0) {
 			/* error this rogue job */
-			if (op_is_write(job->rw))
+			if (req_op_is_write(job->rw))
 				job->write_err = (unsigned long) -1L;
 			else
 				job->read_err = 1;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d189e89..5c38378 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -927,7 +927,7 @@ again:
 			rdev = rrdev;
 			rrdev = NULL;
 		}
-		if (op_is_write(op)) {
+		if (req_op_is_write(op)) {
 			if (replace_only)
 				rdev = NULL;
 			if (rdev == rrdev)
@@ -953,7 +953,7 @@ again:
 		 * need to check for writes.  We never accept write errors
 		 * on the replacement, so we don't to check rrdev.
 		 */
-		while (op_is_write(op) && rdev &&
+		while (req_op_is_write(op) && rdev &&
 		       test_bit(WriteErrorSeen, &rdev->flags)) {
 			sector_t first_bad;
 			int bad_sectors;
@@ -996,7 +996,7 @@ again:
 			bio_reset(bi);
 			bi->bi_bdev = rdev->bdev;
 			bio_set_op_attrs(bi, op, op_flags);
-			bi->bi_end_io = op_is_write(op)
+			bi->bi_end_io = req_op_is_write(op)
 				? raid5_end_write_request
 				: raid5_end_read_request;
 			bi->bi_private = sh;
@@ -1048,7 +1048,7 @@ again:
 			bio_reset(rbi);
 			rbi->bi_bdev = rrdev->bdev;
 			bio_set_op_attrs(rbi, op, op_flags);
-			BUG_ON(!op_is_write(op));
+			BUG_ON(!req_op_is_write(op));
 			rbi->bi_end_io = raid5_end_write_request;
 			rbi->bi_private = sh;
 
@@ -1085,7 +1085,7 @@ again:
 			generic_make_request(rbi);
 		}
 		if (!rdev && !rrdev) {
-			if (op_is_write(op))
+			if (req_op_is_write(op))
 				set_bit(STRIPE_DEGRADED, &sh->state);
 			pr_debug("skip op %d on disc %d for sector %llu\n",
 				bi->bi_rw, i, (unsigned long long)sh->sector);
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 7cf3bdf..68954550 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1137,7 +1137,7 @@ static int btt_do_bvec(struct btt *btt, struct bio_integrity_payload *bip,
 {
 	int ret;
 
-	if (!op_is_write(op)) {
+	if (!req_op_is_write(op)) {
 		ret = btt_read_pg(btt, bip, page, off, sector, len);
 		flush_dcache_page(page);
 	} else {
@@ -1184,8 +1184,8 @@ static blk_qc_t btt_make_request(struct request_queue *q, struct bio *bio)
 		if (err) {
 			dev_info(&btt->nd_btt->dev,
 					"io error in %s sector %lld, len %d,\n",
-					(op_is_write(bio_op(bio))) ? "WRITE" :
-					"READ",
+					(req_op_is_write(bio_op(bio))) ?
+					"WRITE" : "READ",
 					(unsigned long long) iter.bi_sector, len);
 			bio->bi_error = err;
 			break;
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index d64d924..7d4e62b 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -79,7 +79,7 @@ static int pmem_do_bvec(struct pmem_device *pmem, struct page *page,
 	if (unlikely(is_bad_pmem(&pmem->bb, sector, len)))
 		bad_pmem = true;
 
-	if (!op_is_write(op)) {
+	if (!req_op_is_write(op)) {
 		if (unlikely(bad_pmem))
 			rc = -EIO;
 		else {
diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 2f2a991..0685df0 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -824,7 +824,7 @@ void osd_req_write(struct osd_request *or,
 {
 	_osd_req_encode_common(or, OSD_ACT_WRITE, obj, offset, len);
 	WARN_ON(or->out.bio || or->out.total_bytes);
-	WARN_ON(!op_is_write(bio_op(bio)));
+	WARN_ON(!req_op_is_write(bio_op(bio)));
 	or->out.bio = bio;
 	or->out.total_bytes = len;
 }
@@ -875,7 +875,7 @@ void osd_req_read(struct osd_request *or,
 {
 	_osd_req_encode_common(or, OSD_ACT_READ, obj, offset, len);
 	WARN_ON(or->in.bio || or->in.total_bytes);
-	WARN_ON(op_is_write(bio_op(bio)));
+	WARN_ON(req_op_is_write(bio_op(bio)));
 	or->in.bio = bio;
 	or->in.total_bytes = len;
 }
diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index f77150a..6fc5316 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -602,7 +602,7 @@ static inline void blkg_rwstat_add(struct blkg_rwstat *rwstat,
 {
 	struct percpu_counter *cnt;
 
-	if (op_is_write(op))
+	if (req_op_is_write(op))
 		cnt = &rwstat->cpu_cnt[BLKG_RWSTAT_WRITE];
 	else
 		cnt = &rwstat->cpu_cnt[BLKG_RWSTAT_READ];
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ccd68c0..bfc3cea 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -611,7 +611,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 
 #define list_entry_rq(ptr)	list_entry((ptr), struct request, queuelist)
 
-#define rq_data_dir(rq)		(op_is_write(req_op(rq)) ? WRITE : READ)
+#define rq_data_dir(rq)		(req_op_is_write(req_op(rq)) ? WRITE : READ)
 
 /*
  * Driver can handle struct request, if it either has an old style
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 498255e..aebba9e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2480,7 +2480,7 @@ extern void init_special_inode(struct inode *, umode_t, dev_t);
 extern void make_bad_inode(struct inode *);
 extern bool is_bad_inode(struct inode *);
 
-static inline bool op_is_write(unsigned int op)
+static inline bool req_op_is_write(unsigned int op)
 {
 	return op == REQ_OP_READ ? false : true;
 }
@@ -2492,7 +2492,7 @@ static inline bool op_is_write(unsigned int op)
  */
 static inline int bio_data_dir(struct bio *bio)
 {
-	return op_is_write(bio_op(bio)) ? WRITE : READ;
+	return req_op_is_write(bio_op(bio)) ? WRITE : READ;
 }
 
 extern void check_disk_size_change(struct gendisk *disk,
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index fb345cd..434ee6d 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -217,7 +217,7 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 	if (unlikely(bt->trace_state != Blktrace_running && !blk_tracer))
 		return;
 
-	what |= ddir_act[op_is_write(op) ? WRITE : READ];
+	what |= ddir_act[req_op_is_write(op) ? WRITE : READ];
 	what |= MASK_TC_BIT(op_flags, SYNC);
 	what |= MASK_TC_BIT(op_flags, RAHEAD);
 	what |= MASK_TC_BIT(op_flags, META);
diff --git a/mm/filemap.c b/mm/filemap.c
index daef091..d891795 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -889,7 +889,7 @@ EXPORT_SYMBOL(end_page_writeback);
  */
 void page_endio(struct page *page, int op, int err)
 {
-	if (!op_is_write(op)) {
+	if (!req_op_is_write(op)) {
 		if (!err) {
 			SetPageUptodate(page);
 		} else {
-- 
2.7.2



