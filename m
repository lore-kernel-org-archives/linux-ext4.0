From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [RFC PATCH 1/2] bdi: Create a flag to indicate that a backing device
 needs stable page writes
Date: Fri, 26 Oct 2012 18:35:24 -0700
Message-ID: <20121027013524.GA19591@blackbox.djwong.org>
References: <20121026101909.GB19617@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121026101909.GB19617@blackbox.djwong.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This creates BDI_CAP_STABLE_WRITES, which indicates that a device requires
stable page writes.  It also plumbs in a sysfs attribute so that admins can
check the device status.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---

 block/blk-integrity.c       |    8 ++++++++
 include/linux/backing-dev.h |    6 ++++++
 mm/backing-dev.c            |   11 +++++++++++
 3 files changed, 25 insertions(+)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index da2a818..d05d7b3 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -384,6 +384,7 @@ EXPORT_SYMBOL(blk_integrity_is_initialized);
 int blk_integrity_register(struct gendisk *disk, struct blk_integrity *template)
 {
 	struct blk_integrity *bi;
+	struct backing_dev_info *bdi;
 
 	BUG_ON(disk == NULL);
 
@@ -420,6 +421,9 @@ int blk_integrity_register(struct gendisk *disk, struct blk_integrity *template)
 	} else
 		bi->name = bi_unsupported_name;
 
+	bdi = &disk->queue->backing_dev_info;
+	bdi->capabilities |= BDI_CAP_STABLE_WRITES;
+
 	return 0;
 }
 EXPORT_SYMBOL(blk_integrity_register);
@@ -434,10 +438,14 @@ EXPORT_SYMBOL(blk_integrity_register);
 void blk_integrity_unregister(struct gendisk *disk)
 {
 	struct blk_integrity *bi;
+	struct backing_dev_info *bdi;
 
 	if (!disk || !disk->integrity)
 		return;
 
+	bdi = &disk->queue->backing_dev_info;
+	bdi->capabilities &= ~BDI_CAP_STABLE_WRITES;
+
 	bi = disk->integrity;
 
 	kobject_uevent(&bi->kobj, KOBJ_REMOVE);
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 2a9a9ab..b82a8bb 100644
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
 
+static inline bool bdi_cap_stable_writes(struct backing_dev_info *bdi)
+{
+	return bdi->capabilities & BDI_CAP_STABLE_WRITES;
+}
+
 static inline bool bdi_cap_writeback_dirty(struct backing_dev_info *bdi)
 {
 	return !(bdi->capabilities & BDI_CAP_NO_WRITEBACK);
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index d3ca2b3..a2f4c08 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -221,12 +221,23 @@ static ssize_t max_ratio_store(struct device *dev,
 }
 BDI_SHOW(max_ratio, bdi->max_ratio)
 
+static ssize_t stable_page_writes_show(struct device *dev,
+	struct device_attribute *attr, char *page)
+{
+	struct backing_dev_info *bdi = dev_get_drvdata(dev);
+
+	return snprintf(page, PAGE_SIZE-1, "%d\n",
+			bdi->capabilities & BDI_CAP_STABLE_WRITES ? 1 : 0);
+}
+
 #define __ATTR_RW(attr) __ATTR(attr, 0644, attr##_show, attr##_store)
+#define __ATTR_RO(attr) __ATTR(attr, 0444, attr##_show, NULL)
 
 static struct device_attribute bdi_dev_attrs[] = {
 	__ATTR_RW(read_ahead_kb),
 	__ATTR_RW(min_ratio),
 	__ATTR_RW(max_ratio),
+	__ATTR_RO(stable_page_writes),
 	__ATTR_NULL,
 };
 
