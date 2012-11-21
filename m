From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/4] bdi: Track users that require stable page writes
Date: Tue, 20 Nov 2012 18:00:34 -0800
Message-ID: <20121121020034.10225.51692.stgit@blackbox.djwong.org>
References: <20121121020027.10225.43206.stgit@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
To: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
	tytso@mit.edu, rminnich@sandia.gov, viro@zeniv.linux.org.uk
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121121020027.10225.43206.stgit@blackbox.djwong.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This creates a per-backing-device counter that tracks the number of users which
require pages to be held immutable during writeout.  Eventually it will be used
to waive wait_for_page_writeback() if nobody requires stable pages.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 Documentation/ABI/testing/sysfs-class-bdi |    7 ++++++
 block/blk-integrity.c                     |    4 +++
 include/linux/backing-dev.h               |   16 +++++++++++++
 include/linux/blkdev.h                    |   15 ++++++++++++
 mm/backing-dev.c                          |   36 +++++++++++++++++++++++++++++
 5 files changed, 78 insertions(+)


diff --git a/Documentation/ABI/testing/sysfs-class-bdi b/Documentation/ABI/testing/sysfs-class-bdi
index 5f50097..218a618 100644
--- a/Documentation/ABI/testing/sysfs-class-bdi
+++ b/Documentation/ABI/testing/sysfs-class-bdi
@@ -48,3 +48,10 @@ max_ratio (read-write)
 	most of the write-back cache.  For example in case of an NFS
 	mount that is prone to get stuck, or a FUSE mount which cannot
 	be trusted to play fair.
+
+stable_pages_required (read-write)
+
+	If set, the backing device requires that all pages comprising a write
+	request must not be changed until writeout is complete.  The system
+	administrator can turn this on if the hardware does not do so already.
+	However, once enabled, this flag cannot be disabled.
diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index da2a818..cf2dd95 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -420,6 +420,8 @@ int blk_integrity_register(struct gendisk *disk, struct blk_integrity *template)
 	} else
 		bi->name = bi_unsupported_name;
 
+	queue_require_stable_pages(disk->queue);
+
 	return 0;
 }
 EXPORT_SYMBOL(blk_integrity_register);
@@ -438,6 +440,8 @@ void blk_integrity_unregister(struct gendisk *disk)
 	if (!disk || !disk->integrity)
 		return;
 
+	queue_unrequire_stable_pages(disk->queue);
+
 	bi = disk->integrity;
 
 	kobject_uevent(&bi->kobj, KOBJ_REMOVE);
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 2a9a9ab..af19704 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -253,6 +253,7 @@ int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned int max_ratio);
 #define BDI_CAP_EXEC_MAP	0x00000040
 #define BDI_CAP_NO_ACCT_WB	0x00000080
 #define BDI_CAP_SWAP_BACKED	0x00000100
+#define BDI_CAP_STABLE_WRITES	0x00000200
 
 #define BDI_CAP_VMFLAGS \
 	(BDI_CAP_READ_MAP | BDI_CAP_WRITE_MAP | BDI_CAP_EXEC_MAP)
@@ -307,6 +308,21 @@ long wait_iff_congested(struct zone *zone, int sync, long timeout);
 int pdflush_proc_obsolete(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp, loff_t *ppos);
 
+static inline void bdi_require_stable_pages(struct backing_dev_info *bdi)
+{
+	bdi->capabilities |= BDI_CAP_STABLE_WRITES;
+}
+
+static inline void bdi_unrequire_stable_pages(struct backing_dev_info *bdi)
+{
+	bdi->capabilities &= ~BDI_CAP_STABLE_WRITES;
+}
+
+static inline bool bdi_cap_stable_pages_required(struct backing_dev_info *bdi)
+{
+	return bdi->capabilities & BDI_CAP_STABLE_WRITES;
+}
+
 static inline bool bdi_cap_writeback_dirty(struct backing_dev_info *bdi)
 {
 	return !(bdi->capabilities & BDI_CAP_NO_WRITEBACK);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1756001..a1c6e91 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -458,6 +458,21 @@ struct request_queue {
 				 (1 << QUEUE_FLAG_SAME_COMP)	|	\
 				 (1 << QUEUE_FLAG_ADD_RANDOM))
 
+static inline void queue_require_stable_pages(struct request_queue *q)
+{
+	bdi_require_stable_pages(&q->backing_dev_info);
+}
+
+static inline void queue_unrequire_stable_pages(struct request_queue *q)
+{
+	bdi_unrequire_stable_pages(&q->backing_dev_info);
+}
+
+static inline int queue_requires_stable_pages(struct request_queue *q)
+{
+	return bdi_cap_stable_pages_required(&q->backing_dev_info);
+}
+
 static inline void queue_lockdep_assert_held(struct request_queue *q)
 {
 	if (q->queue_lock)
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index d3ca2b3..fd6e5b5 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -221,12 +221,48 @@ static ssize_t max_ratio_store(struct device *dev,
 }
 BDI_SHOW(max_ratio, bdi->max_ratio)
 
+static ssize_t stable_pages_required_store(struct device *dev,
+					   struct device_attribute *attr,
+					   const char *buf, size_t count)
+{
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+	unsigned int spw;
+	ssize_t ret;
+
+	ret = kstrtouint(buf, 10, &spw);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * SPW could be enabled due to hw requirement, so don't
+	 * let users disable it.
+	 */
+	if (bdi_cap_stable_pages_required(bdi) && spw == 0)
+		return -EINVAL;
+
+	if (spw != 0)
+		bdi_require_stable_pages(bdi);
+
+	return count;
+}
+
+static ssize_t stable_pages_required_show(struct device *dev,
+					  struct device_attribute *attr,
+					  char *page)
+{
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+
+	return snprintf(page, PAGE_SIZE-1, "%d\n",
+			bdi_cap_stable_pages_required(bdi) ? 1 : 0);
+}
+
 #define __ATTR_RW(attr) __ATTR(attr, 0644, attr##_show, attr##_store)
 
 static struct device_attribute bdi_dev_attrs[] = {
 	__ATTR_RW(read_ahead_kb),
 	__ATTR_RW(min_ratio),
 	__ATTR_RW(max_ratio),
+	__ATTR_RW(stable_pages_required),
 	__ATTR_NULL,
 };
 
