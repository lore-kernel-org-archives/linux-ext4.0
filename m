From: Denis Karpov <ext-denis.2.karpov@nokia.com>
Subject: [PATCH 1/4] FS: filesystem corruption notification
Date: Wed,  3 Jun 2009 18:05:15 +0300
Message-ID: <e7005f79dd6b8f25fef78ddbfedcef54f6b40bd5.1244049680.git.ext-denis.2.karpov@nokia.com>
References: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com>
Cc: akpm@linux-foundation.org, hirofumi@mail.parknet.co.jp,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, adrian.hunter@nokia.com,
	artem.bityutskiy@nokia.com
To: axboe@kernel.dk
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:37019 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757361AbZFCPFr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Jun 2009 11:05:47 -0400
In-Reply-To: <1244041518-32229-1-git-send-email-ext-denis.2.karpov@nokia.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Add a generic mechnism to notify the userspace about possible filesystem
corruption through sysfs entry (/sys/block/<bdev>/<part>/fs_unclean)
and uevent (KOBJ_CHANGE, uevent's environment variable FS_UNCLEAN=[0:1]).

To mark fs clean (e.g. after fs was fixed by userspace):

echo 0 > /sys/block/<bdev>/<part>/fs_unclean
(you will still receive uevent KOBJ_CHANGE with env var FS_UNCLEAN=0)

Signed-off-by: Denis Karpov <ext-denis.2.karpov@nokia.com>
---
 fs/partitions/check.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/genhd.h |    2 ++
 2 files changed, 44 insertions(+), 0 deletions(-)

diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 99e33ef..191d89e 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -196,6 +196,24 @@ check_partition(struct gendisk *hd, struct block_device *bdev)
 	return ERR_PTR(res);
 }
 
+void notify_part_fs_unclean(struct device *dev, uint8_t unclean)
+{
+	char event_string[13];
+	char *envp[] = { event_string, NULL };
+
+	if ((unclean != 0 && unclean != 1) ||
+		unclean == dev_to_part(dev)->fs_unclean)
+		return;
+
+	dev_to_part(dev)->fs_unclean = unclean;
+
+	sysfs_notify(&dev->kobj, NULL, "fs_unclean");
+
+	sprintf(event_string, "FS_UNCLEAN=%u", unclean);
+	kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
+}
+EXPORT_SYMBOL(notify_part_fs_unclean);
+
 static ssize_t part_partition_show(struct device *dev,
 				   struct device_attribute *attr, char *buf)
 {
@@ -246,6 +264,26 @@ ssize_t part_stat_show(struct device *dev,
 		jiffies_to_msecs(part_stat_read(p, time_in_queue)));
 }
 
+ssize_t part_fs_unclean_show(struct device *dev,
+		       struct device_attribute *attr, char *buf)
+{
+	struct hd_struct *p = dev_to_part(dev);
+
+	return sprintf(buf, "%d\n", p->fs_unclean);
+}
+
+ssize_t part_fs_unclean_store(struct device *dev,
+			struct device_attribute *attr,
+			const char *buf, size_t count)
+{
+	int i;
+
+	if (count > 0 && sscanf(buf, "%d", &i) > 0)
+		notify_part_fs_unclean(dev, (i == 0) ? 0 : 1);
+
+	return count;
+}
+
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 ssize_t part_fail_show(struct device *dev,
 		       struct device_attribute *attr, char *buf)
@@ -273,6 +311,9 @@ static DEVICE_ATTR(partition, S_IRUGO, part_partition_show, NULL);
 static DEVICE_ATTR(start, S_IRUGO, part_start_show, NULL);
 static DEVICE_ATTR(size, S_IRUGO, part_size_show, NULL);
 static DEVICE_ATTR(stat, S_IRUGO, part_stat_show, NULL);
+static struct device_attribute dev_attr_fs_unclean =
+	__ATTR(fs_unclean, S_IRUGO|S_IWUSR, part_fs_unclean_show,
+		part_fs_unclean_store);
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 static struct device_attribute dev_attr_fail =
 	__ATTR(make-it-fail, S_IRUGO|S_IWUSR, part_fail_show, part_fail_store);
@@ -283,6 +324,7 @@ static struct attribute *part_attrs[] = {
 	&dev_attr_start.attr,
 	&dev_attr_size.attr,
 	&dev_attr_stat.attr,
+	&dev_attr_fs_unclean.attr,
 #ifdef CONFIG_FAIL_MAKE_REQUEST
 	&dev_attr_fail.attr,
 #endif
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index a1a28ca..2e6d42e 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -98,6 +98,7 @@ struct hd_struct {
 #endif
 	unsigned long stamp;
 	int in_flight;
+	int fs_unclean;
 #ifdef	CONFIG_SMP
 	struct disk_stats *dkstats;
 #else
@@ -528,6 +529,7 @@ extern struct hd_struct * __must_check add_partition(struct gendisk *disk,
 						     sector_t len, int flags);
 extern void delete_partition(struct gendisk *, int);
 extern void printk_all_partitions(void);
+extern void notify_part_fs_unclean(struct device *dev, uint8_t unclean);
 
 extern struct gendisk *alloc_disk_node(int minors, int node_id);
 extern struct gendisk *alloc_disk(int minors);
-- 
1.6.3.1

