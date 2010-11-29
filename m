From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 1/4] block: Measure flush round-trip times and report average
	value
Date: Mon, 29 Nov 2010 14:05:43 -0800
Message-ID: <20101129220543.12401.69279.stgit@elm3b57.beaverton.ibm.com>
References: <20101129220536.12401.16581.stgit@elm3b57.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-raid@vger.kernel.org, Keith Mannthey <kmannth@us.ibm.com>,
	dm-devel@redhat.com, Mingming Cao <cmm@us.ibm.com>,
	Tejun Heo <tj@kernel.org>, linux-ext4@vger.kernel.org,
	Ric Wheeler <rwheeler@redhat.com>,
	Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, "Theodore Ts'o" <tytso@mit.edu>,
	Neil Brown <neilb@suse.de>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Alasdair G Kergon <agk@redhat.com>,
	"Darrick J.
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e39.co.us.ibm.com ([32.97.110.160]:41524 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365Ab0K2WFw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Nov 2010 17:05:52 -0500
In-Reply-To: <20101129220536.12401.16581.stgit@elm3b57.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds to the block layer the ability to intercept flush requests for
the purpose of measuring the round-trip times of the write-cache flush command
on whatever hardware sits underneath the block layer.  The eventual intent of
this patch is for higher-level clients (filesystems) to be able to measure
flush times to tune their use of them.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 block/blk-core.c          |   13 +++++++++++++
 block/genhd.c             |   39 +++++++++++++++++++++++++++++++++++++++
 fs/bio.c                  |   11 +++++++++++
 include/linux/blk_types.h |    2 ++
 include/linux/blkdev.h    |    2 ++
 include/linux/genhd.h     |   23 +++++++++++++++++++++++
 6 files changed, 90 insertions(+), 0 deletions(-)


diff --git a/block/blk-core.c b/block/blk-core.c
index 4ce953f..233573a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1540,6 +1540,9 @@ static inline void __generic_make_request(struct bio *bio)
 
 		trace_block_bio_queue(q, bio);
 
+		if (bio->bi_rw & REQ_FLUSH)
+			bio->flush_start_time_ns = ktime_to_ns(ktime_get());
+
 		ret = q->make_request_fn(q, bio);
 	} while (ret);
 
@@ -1954,6 +1957,9 @@ void blk_start_request(struct request *req)
 		req->next_rq->resid_len = blk_rq_bytes(req->next_rq);
 
 	blk_add_timer(req);
+
+	if (req->cmd_flags & REQ_FLUSH)
+		req->flush_start_time_ns = ktime_to_ns(ktime_get());
 }
 EXPORT_SYMBOL(blk_start_request);
 
@@ -2182,6 +2188,13 @@ EXPORT_SYMBOL_GPL(blk_unprep_request);
  */
 static void blk_finish_request(struct request *req, int error)
 {
+	if (!error && req->cmd_flags & REQ_FLUSH) {
+		u64 delta;
+
+		delta = ktime_to_ns(ktime_get()) - req->flush_start_time_ns;
+		update_flush_times(req->rq_disk, delta);
+	}
+
 	if (blk_rq_tagged(req))
 		blk_queue_end_tag(req->q, req);
 
diff --git a/block/genhd.c b/block/genhd.c
index 5fa2b44..465bd00 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -538,6 +538,9 @@ void add_disk(struct gendisk *disk)
 	 */
 	disk->major = MAJOR(devt);
 	disk->first_minor = MINOR(devt);
+	spin_lock_init(&disk->flush_time_lock);
+	disk->avg_flush_time_ns = 0;
+	disk->flush_samples = 0;
 
 	/* Register BDI before referencing it from bdev */ 
 	bdi = &disk->queue->backing_dev_info;
@@ -824,6 +827,37 @@ static ssize_t disk_range_show(struct device *dev,
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
+	spin_lock(&disk->flush_time_lock);
+	disk->avg_flush_time_ns = 0;
+	disk->flush_samples = 0;
+	spin_unlock(&disk->flush_time_lock);
+
+	return count;
+}
+
+
 static ssize_t disk_ext_range_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
@@ -876,6 +910,9 @@ static ssize_t disk_discard_alignment_show(struct device *dev,
 }
 
 static DEVICE_ATTR(range, S_IRUGO, disk_range_show, NULL);
+static DEVICE_ATTR(avg_flush_time_ns, S_IRUGO | S_IWUSR,
+		   disk_avg_flush_time_ns_show, disk_avg_flush_time_ns_store);
+static DEVICE_ATTR(flush_samples, S_IRUGO, disk_flush_samples_show, NULL);
 static DEVICE_ATTR(ext_range, S_IRUGO, disk_ext_range_show, NULL);
 static DEVICE_ATTR(removable, S_IRUGO, disk_removable_show, NULL);
 static DEVICE_ATTR(ro, S_IRUGO, disk_ro_show, NULL);
@@ -898,6 +935,8 @@ static struct device_attribute dev_attr_fail_timeout =
 
 static struct attribute *disk_attrs[] = {
 	&dev_attr_range.attr,
+	&dev_attr_avg_flush_time_ns.attr,
+	&dev_attr_flush_samples.attr,
 	&dev_attr_ext_range.attr,
 	&dev_attr_removable.attr,
 	&dev_attr_ro.attr,
diff --git a/fs/bio.c b/fs/bio.c
index 4bd454f..aab5f27 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1442,11 +1442,22 @@ EXPORT_SYMBOL(bio_flush_dcache_pages);
  **/
 void bio_endio(struct bio *bio, int error)
 {
+	struct request_queue *q = NULL;
+
 	if (error)
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
 	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
 		error = -EIO;
 
+	if (bio->bi_bdev)
+		q = bdev_get_queue(bio->bi_bdev);
+	if (!(q && q->prep_rq_fn) && !error && bio->bi_rw & REQ_FLUSH) {
+		u64 delta;
+
+		delta = ktime_to_ns(ktime_get()) - bio->flush_start_time_ns;
+		update_flush_times(bio->bi_bdev->bd_disk, delta);
+	}
+
 	if (bio->bi_end_io)
 		bio->bi_end_io(bio, error);
 }
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 46ad519..e8c29b9 100644
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
index aae86fd..357d669 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -163,6 +163,8 @@ struct request {
 
 	/* for bidi */
 	struct request *next_rq;
+
+	u64 flush_start_time_ns;
 };
 
 static inline unsigned short req_get_ioprio(struct request *req)
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 7a7b9c1..7097396 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -178,8 +178,31 @@ struct gendisk {
 	struct blk_integrity *integrity;
 #endif
 	int node_id;
+
+	spinlock_t flush_time_lock;
+	u64 avg_flush_time_ns;
+	u64 flush_samples;
 };
 
+static inline void update_flush_times(struct gendisk *disk, u64 delta)
+{
+	u64 data;
+
+	spin_lock(&disk->flush_time_lock);
+	if (disk->flush_samples < 256)
+		disk->flush_samples++;
+	if (!disk->avg_flush_time_ns)
+		disk->avg_flush_time_ns = delta;
+	else {
+		data = disk->avg_flush_time_ns;
+		data *= 255;
+		data += delta;
+		data /= 256;
+		disk->avg_flush_time_ns = data;
+	}
+	spin_unlock(&disk->flush_time_lock);
+}
+
 static inline struct gendisk *part_to_disk(struct hd_struct *part)
 {
 	if (likely(part)) {

