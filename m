From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] bdi: Track users that require stable page writes
Date: Wed, 21 Nov 2012 18:33:43 -0800
Message-ID: <20121122023343.GC32202@blackbox.djwong.org>
References: <20121121020027.10225.43206.stgit@blackbox.djwong.org>
 <20121121020034.10225.51692.stgit@blackbox.djwong.org>
 <20121121105624.GA19050@infradead.org>
 <20121121215207.GB32202@blackbox.djwong.org>
 <20121122090643.7c9551dc@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk,
	lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com, tytso@mit.edu,
	rminnich@sandia.gov, viro@zeniv.linux.org.uk,
	martin.petersen@oracle.com, david@fromorbit.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
	v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121122090643.7c9551dc@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

How's this look to everyone?  No more user-writable flag, and most of the
helper functions are gone.

(Are these emails even getting through?)

--D
---
This creates a per-backing-device flag that tracks whether or not pages must be
held immutable during writeout.  Eventually it will be used to waive
wait_for_page_writeback() if nobody requires stable pages.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 Documentation/ABI/testing/sysfs-class-bdi |    5 +++++
 block/blk-integrity.c                     |    4 ++++
 include/linux/backing-dev.h               |    6 ++++++
 mm/backing-dev.c                          |   11 +++++++++++
 4 files changed, 26 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-bdi b/Documentation/ABI/testing/sysfs-class-bdi
index 5f50097..d773d56 100644
--- a/Documentation/ABI/testing/sysfs-class-bdi
+++ b/Documentation/ABI/testing/sysfs-class-bdi
@@ -48,3 +48,8 @@ max_ratio (read-write)
 	most of the write-back cache.  For example in case of an NFS
 	mount that is prone to get stuck, or a FUSE mount which cannot
 	be trusted to play fair.
+
+stable_pages_required (read-only)
+
+	If set, the backing device requires that all pages comprising a write
+	request must not be changed until writeout is complete.
diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index da2a818..dabd221 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -420,6 +420,8 @@ int blk_integrity_register(struct gendisk *disk, struct blk_integrity *template)
 	} else
 		bi->name = bi_unsupported_name;
 
+	disk->queue->backing_dev_info.capabilities |= BDI_CAP_STABLE_WRITES;
+
 	return 0;
 }
 EXPORT_SYMBOL(blk_integrity_register);
@@ -438,6 +440,8 @@ void blk_integrity_unregister(struct gendisk *disk)
 	if (!disk || !disk->integrity)
 		return;
 
+	disk->queue->backing_dev_info.capabilities &= ~BDI_CAP_STABLE_WRITES;
+
 	bi = disk->integrity;
 
 	kobject_uevent(&bi->kobj, KOBJ_REMOVE);
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 2a9a9ab..085501f 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -253,6 +253,7 @@ int bdi_set_max_ratio(struct backing_dev_info *bdi, unsigned int max_ratio);
 #define BDI_CAP_EXEC_MAP	0x00000040
 #define BDI_CAP_NO_ACCT_WB	0x00000080
 #define BDI_CAP_SWAP_BACKED	0x00000100
+#define BDI_CAP_STABLE_WRITES	0x00000200
 
 #define BDI_CAP_VMFLAGS \
 	(BDI_CAP_READ_MAP | BDI_CAP_WRITE_MAP | BDI_CAP_EXEC_MAP)
@@ -307,6 +308,11 @@ long wait_iff_congested(struct zone *zone, int sync, long timeout);
 int pdflush_proc_obsolete(struct ctl_table *table, int write,
 		void __user *buffer, size_t *lenp, loff_t *ppos);
 
+static inline bool bdi_cap_stable_pages_required(struct backing_dev_info *bdi)
+{
+	return bdi->capabilities & BDI_CAP_STABLE_WRITES;
+}
+
 static inline bool bdi_cap_writeback_dirty(struct backing_dev_info *bdi)
 {
 	return !(bdi->capabilities & BDI_CAP_NO_WRITEBACK);
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index d3ca2b3..41733c5 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -221,12 +221,23 @@ static ssize_t max_ratio_store(struct device *dev,
 }
 BDI_SHOW(max_ratio, bdi->max_ratio)
 
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
+	__ATTR_RO(stable_pages_required),
 	__ATTR_NULL,
 };
 
