From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: Performance testing of various barrier reduction patches [was:
	Re: [RFC v4] ext4: Coordinate fsync requests]
Date: Mon, 18 Oct 2010 15:49:36 -0700
Message-ID: <20101018224936.GI25624@tux1.beaverton.ibm.com>
References: <20100806070424.GD2109@tux1.beaverton.ibm.com> <20100809195324.GG2109@tux1.beaverton.ibm.com> <4D5AEB7F-32E2-481A-A6C8-7E7E0BD3CE98@dilger.ca> <20100809233805.GH2109@tux1.beaverton.ibm.com> <20100819021441.GM2109@tux1.beaverton.ibm.com> <20100823183119.GA28105@tux1.beaverton.ibm.com> <20100923232527.GB25624@tux1.beaverton.ibm.com> <B0A8EB94-E2F7-4268-AE99-C4A7402E880D@dilger.ca> <20100927230111.GV25555@tux1.beaverton.ibm.com> <20101008212606.GE25624@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Ted Ts'o" <tytso@mit.edu>, Mingming Cao <cmm@us.ibm.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Keith Mannthey <kmannth@us.ibm.com>,
	Mingming Cao <mcao@us.ibm.com>, Tejun Heo <tj@kernel.org>,
	hch@lst.de
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60101 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754823Ab0JRWtf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Oct 2010 18:49:35 -0400
Content-Disposition: inline
In-Reply-To: <20101008212606.GE25624@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

I've updated the spreadsheet at http://bit.ly/ahdhyk to include a new set of
flush time figures.  There are two main columns to the "flush_times_in_ms"
sheet.  block_flush_rtt_avg is the average amount of time that it takes the
same flush to be processed by the block layer, the lower level device driver
(lldd) which is usually SCSI, and the hardware.  lldd_flush_rtt_avg is the
average amount of time that it takes for a flush command to be processed by the
lldd and the hardware.

Through this table, I'm looking for a performance characteristic that typifies
storage with a battery-backed write cache (BBWC).  As we can see from
lldd_flush_rtt_avg, the BBWC storage features a very low flush time, about 1ms
or less.  Everything else, including SSDs, are over that amount.  The other odd
result I see is that it takes a significant amount of time to get a flush
command from the top of the block layer to the LLDD, though I suspect some of
that might be waiting for the device to process earlier writes.  Christoph has
a patch that looks like it streamlines that, but it triggered various BUG_ONs
when I booted with it, so I took the patch out.

I measured the amount of time it takes to get through the fsync coordination
setup.  It doesn't take more than about 2us, even on the old hardware.

The hackish patch I use to collect flush times is attached below, if anyone
wants to run their own tests.  I'm not an expert on how the block layer works,
so apologies if it makes your eyes bleed.

I'm wondering how to proceed from here.  Right now we seem to want to pick a
fsync coordination strategy based on measured flush times.  Assuming that a
fixed version of hch's patch (or anyone else's) doesn't eliminate this want, is
it better for the block layer to export flush time data and let each filesystem
figure things out for itself?  Or is the block layer smarter, and hence it
should do the coordination instead of the filesystem?

--D
---

block: Measure flush round-trip times.

This hacky patch adds some more plumbing to the block layer to measure round
trip times of flush requests.  I've tried to write this patch in such a way
that it is compatible with both bio- and request-based LLDDs.  It probably
needs some cleanup before we can use it to decide on a flush coordination
strategy.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 block/blk-core.c          |   26 ++++++++++++++++++++++++++
 block/genhd.c             |   35 +++++++++++++++++++++++++++++++++++
 drivers/md/dm.c           |   21 +++++++++++++++++++++
 drivers/md/md.c           |   19 +++++++++++++++++++
 fs/bio.c                  |   20 ++++++++++++++++++++
 include/linux/blk_types.h |    2 ++
 include/linux/blkdev.h    |    2 ++
 include/linux/genhd.h     |    3 +++
 8 files changed, 128 insertions(+), 0 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 1f75c13..96d5a9f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1523,6 +1523,9 @@ static inline void __generic_make_request(struct bio *bio)
 
 		trace_block_bio_queue(q, bio);
 
+		if (bio->bi_rw & REQ_FLUSH)
+			bio->flush_start_time_ns = ktime_to_ns(ktime_get());
+
 		ret = q->make_request_fn(q, bio);
 	} while (ret);
 
@@ -1936,6 +1939,11 @@ void blk_start_request(struct request *req)
 		req->next_rq->resid_len = blk_rq_bytes(req->next_rq);
 
 	blk_add_timer(req);
+
+#if 1
+	if (req->cmd_flags & REQ_FLUSH)
+		req->flush_start_time_ns = ktime_to_ns(ktime_get());
+#endif
 }
 EXPORT_SYMBOL(blk_start_request);
 
@@ -2164,6 +2172,24 @@ EXPORT_SYMBOL_GPL(blk_unprep_request);
  */
 static void blk_finish_request(struct request *req, int error)
 {
+#if 1
+#define NR_FLUSH_SAMPLES 256
+	if (!error && req->cmd_flags & REQ_FLUSH) {
+		u64 delta;
+
+		delta = ktime_to_ns(ktime_get()) - req->flush_start_time_ns;
+//		if (req->rq_disk->flush_samples < NR_FLUSH_SAMPLES)
+			req->rq_disk->flush_samples++;
+		if (!req->rq_disk->avg_flush_time_ns)
+			req->rq_disk->avg_flush_time_ns = delta;
+		else {
+			req->rq_disk->avg_flush_time_ns *= (NR_FLUSH_SAMPLES - 1);
+			req->rq_disk->avg_flush_time_ns += delta;
+			req->rq_disk->avg_flush_time_ns /= NR_FLUSH_SAMPLES;
+		}
+	}
+#endif
+
 	if (blk_rq_tagged(req))
 		blk_queue_end_tag(req->q, req);
 
diff --git a/block/genhd.c b/block/genhd.c
index 59a2db6..195fc06 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -540,6 +540,8 @@ void add_disk(struct gendisk *disk)
 	 */
 	disk->major = MAJOR(devt);
 	disk->first_minor = MINOR(devt);
+	disk->avg_flush_time_ns = 0;
+	disk->flush_samples = 0;
 
 	blk_register_region(disk_devt(disk), disk->minors, NULL,
 			    exact_match, exact_lock, disk);
@@ -820,6 +822,35 @@ static ssize_t disk_range_show(struct device *dev,
 	return sprintf(buf, "%d\n", disk->minors);
 }
 
+static ssize_t disk_flush_samples_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+
+	return sprintf(buf, "%llu\n", disk->flush_samples);
+}
+
+static ssize_t disk_avg_flush_time_ns_show(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+
+	return sprintf(buf, "%llu\n", disk->avg_flush_time_ns);
+}
+
+static ssize_t disk_avg_flush_time_ns_store(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf, size_t count)
+{
+	struct gendisk *disk = dev_to_disk(dev);
+
+	disk->avg_flush_time_ns = 0;
+	disk->flush_samples = 0;
+
+	return count;
+}
+
+
 static ssize_t disk_ext_range_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
@@ -872,6 +903,8 @@ static ssize_t disk_discard_alignment_show(struct device *dev,
 }
 
 static DEVICE_ATTR(range, S_IRUGO, disk_range_show, NULL);
+static DEVICE_ATTR(avg_flush_time_ns, S_IRUGO | S_IWUSR, disk_avg_flush_time_ns_show, disk_avg_flush_time_ns_store);
+static DEVICE_ATTR(flush_samples, S_IRUGO, disk_flush_samples_show, NULL);
 static DEVICE_ATTR(ext_range, S_IRUGO, disk_ext_range_show, NULL);
 static DEVICE_ATTR(removable, S_IRUGO, disk_removable_show, NULL);
 static DEVICE_ATTR(ro, S_IRUGO, disk_ro_show, NULL);
@@ -894,6 +927,8 @@ static struct device_attribute dev_attr_fail_timeout =
 
 static struct attribute *disk_attrs[] = {
 	&dev_attr_range.attr,
+	&dev_attr_avg_flush_time_ns.attr,
+	&dev_attr_flush_samples.attr,
 	&dev_attr_ext_range.attr,
 	&dev_attr_removable.attr,
 	&dev_attr_ro.attr,
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 61be47f..2b654c0 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2406,6 +2406,25 @@ static int dm_wait_for_completion(struct mapped_device *md, int interruptible)
 	return r;
 }
 
+static void measure_flushes(struct mapped_device *md)
+{
+	struct dm_table *t;
+	struct dm_dev_internal *dd;
+	struct list_head *devices;
+	u64 max = 0;
+
+	t = dm_get_live_table(md);
+	devices = dm_table_get_devices(t);
+	list_for_each_entry(dd, devices, list) {
+		if (dd->dm_dev.bdev->bd_disk->avg_flush_time_ns > max) {
+			max = dd->dm_dev.bdev->bd_disk->avg_flush_time_ns;
+			md->disk->avg_flush_time_ns = dd->dm_dev.bdev->bd_disk->avg_flush_time_ns;
+			md->disk->flush_samples = dd->dm_dev.bdev->bd_disk->flush_samples;
+		}
+	}
+	dm_table_put(t);
+}
+
 static void process_flush(struct mapped_device *md, struct bio *bio)
 {
 	md->flush_error = 0;
@@ -2431,6 +2450,8 @@ static void process_flush(struct mapped_device *md, struct bio *bio)
 		return;
 	}
 
+	measure_flushes(md);
+
 	/* issue data + REQ_FUA */
 	bio->bi_rw &= ~REQ_FLUSH;
 	__split_and_process_bio(md, bio);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index ed075d1..28cabce 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -290,6 +290,24 @@ EXPORT_SYMBOL(mddev_congested);
  * Generic flush handling for md
  */
 
+static void measure_flushes(mddev_t *mddev)
+{
+	mdk_rdev_t *rdev;
+	u64 max = 0;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(rdev, &mddev->disks, same_set)
+		if (rdev->raid_disk >= 0 &&
+		    !test_bit(Faulty, &rdev->flags)) {
+			if (rdev->bdev->bd_disk->avg_flush_time_ns > max) {
+				max = rdev->bdev->bd_disk->avg_flush_time_ns;
+				mddev->gendisk->avg_flush_time_ns = rdev->bdev->bd_disk->avg_flush_time_ns;
+				mddev->gendisk->flush_samples = rdev->bdev->bd_disk->flush_samples;
+			}
+		}
+	rcu_read_unlock();
+}
+
 static void md_end_flush(struct bio *bio, int err)
 {
 	mdk_rdev_t *rdev = bio->bi_private;
@@ -298,6 +316,7 @@ static void md_end_flush(struct bio *bio, int err)
 	rdev_dec_pending(rdev, mddev);
 
 	if (atomic_dec_and_test(&mddev->flush_pending)) {
+		measure_flushes(mddev);
 		/* The pre-request flush has finished */
 		schedule_work(&mddev->flush_work);
 	}
diff --git a/fs/bio.c b/fs/bio.c
index 8abb2df..1a002c6 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1423,11 +1423,31 @@ EXPORT_SYMBOL(bio_flush_dcache_pages);
  **/
 void bio_endio(struct bio *bio, int error)
 {
+	struct request_queue *q = NULL;
+
 	if (error)
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
 	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
 		error = -EIO;
 
+#define NR_FLUSH_SAMPLES 256
+	if (bio->bi_bdev)
+		q = bdev_get_queue(bio->bi_bdev);
+	if (!(q && q->prep_rq_fn) && !error && bio->bi_rw & REQ_FLUSH) {
+		u64 delta;
+
+		delta = ktime_to_ns(ktime_get()) - bio->flush_start_time_ns;
+//		if (bio->bi_bdev->bd_disk->flush_samples < NR_FLUSH_SAMPLES)
+			bio->bi_bdev->bd_disk->flush_samples++;
+		if (!bio->bi_bdev->bd_disk->avg_flush_time_ns)
+			bio->bi_bdev->bd_disk->avg_flush_time_ns = delta;
+		else {
+			bio->bi_bdev->bd_disk->avg_flush_time_ns *= (NR_FLUSH_SAMPLES - 1);
+			bio->bi_bdev->bd_disk->avg_flush_time_ns += delta;
+			bio->bi_bdev->bd_disk->avg_flush_time_ns /= NR_FLUSH_SAMPLES;
+		}
+	}
+
 	if (bio->bi_end_io)
 		bio->bi_end_io(bio, error);
 }
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 1797994..d68ecc7 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -74,6 +74,8 @@ struct bio {
 
 	bio_destructor_t	*bi_destructor;	/* destructor */
 
+	u64			flush_start_time_ns;
+
 	/*
 	 * We can inline a number of vecs at the end of the bio, to avoid
 	 * double allocations for a small number of bio_vecs. This member
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 5cba7fe..e6dc1e2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -160,6 +160,8 @@ struct request {
 
 	/* for bidi */
 	struct request *next_rq;
+
+	uint64_t flush_start_time_ns;
 };
 
 static inline unsigned short req_get_ioprio(struct request *req)
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 5f2f4c4..e9c5f8f 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -168,6 +168,9 @@ struct gendisk {
 	struct blk_integrity *integrity;
 #endif
 	int node_id;
+
+	u64 avg_flush_time_ns;
+	u64 flush_samples;
 };
 
 static inline struct gendisk *part_to_disk(struct hd_struct *part)
