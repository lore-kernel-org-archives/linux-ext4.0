From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH, RFC] Don't do page stablization if !CONFIG_BLKDEV_INTEGRITY
Date: Wed, 07 Mar 2012 22:45:06 -0500
Message-ID: <yq1zkbrhi2l.fsf@sermon.lab.mkp.net>
References: <E1S5QTU-0005Cc-Kl@tytso-glaptop.cam.corp.google.com>
	<4F57FC14.5090207@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "Theodore Ts'o" <tytso@mit.edu>, <linux-fsdevel@vger.kernel.org>,
	<linux-ext4@vger.kernel.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:51457 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748Ab2CHDpO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Mar 2012 22:45:14 -0500
In-Reply-To: <4F57FC14.5090207@panasas.com> (Boaz Harrosh's message of "Wed, 7
	Mar 2012 16:23:48 -0800")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:

Boaz> As I stated many times before, the device should have a property
Boaz> that says if it needs stable pages or not. The candidates for
Boaz> stable pages are:

Boaz> 	- DIF/DIX enabled devices
Boaz> 	- RAID-1/4/5/6 devices
Boaz> 	- iscsi devices with data digest signature
Boaz> 	- Any other checksum enabled block device.

Boaz> A fedora distro will have CONFIG_BLKDEV_INTEGRITY set then you are
Boaz> always out of luck, even with devices that can care less.

Boaz> Please submit a proper patch, even a temporary mount option. But
Boaz> this is ABI. The best is to find where to export it as part of the
Boaz> device's properties sysfs dir.

We could do something like this:

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 5680b91..442a0df 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -125,6 +125,7 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->io_opt = 0;
 	lim->misaligned = 0;
 	lim->cluster = 1;
+	lim->needs_stable_pages = false;
 }
 EXPORT_SYMBOL(blk_set_default_limits);
 
@@ -571,6 +572,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	t->cluster &= b->cluster;
 	t->discard_zeroes_data &= b->discard_zeroes_data;
 
+	t->needs_stable_pages &= b->needs_stable_pages;
+
 	/* Physical block size a multiple of the logical block size? */
 	if (t->physical_block_size & (t->logical_block_size - 1)) {
 		t->physical_block_size = t->logical_block_size;
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 5b85d91..d464aca 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -161,6 +161,11 @@ static ssize_t queue_discard_zeroes_data_show(struct request_queue *q, char *pag
 	return queue_var_show(queue_discard_zeroes_data(q), page);
 }
 
+static ssize_t queue_needs_stable_pages_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(q->limits.needs_stable_pages, page);
+}
+
 static ssize_t queue_write_same_max_show(struct request_queue *q, char *page)
 {
 	return sprintf(page, "%llu\n",
@@ -364,6 +369,11 @@ static struct queue_sysfs_entry queue_discard_zeroes_data_entry = {
 	.show = queue_discard_zeroes_data_show,
 };
 
+static struct queue_sysfs_entry queue_needs_stable_pages_entry = {
+	.attr = {.name = "needs_stable_pages", .mode = S_IRUGO },
+	.show = queue_needs_stable_pages_show,
+};
+
 static struct queue_sysfs_entry queue_write_same_max_entry = {
 	.attr = {.name = "write_same_max_bytes", .mode = S_IRUGO },
 	.show = queue_write_same_max_show,
@@ -416,6 +426,7 @@ static struct attribute *default_attrs[] = {
 	&queue_discard_granularity_entry.attr,
 	&queue_discard_max_entry.attr,
 	&queue_discard_zeroes_data_entry.attr,
+	&queue_needs_stable_pages_entry.attr,
 	&queue_write_same_max_entry.attr,
 	&queue_nonrot_entry.attr,
 	&queue_nomerges_entry.attr,
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 26eff46..146bed4 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1752,10 +1752,11 @@ static void sd_read_protection_type(struct scsi_disk *sdkp, unsigned char *buffe
 		return;
 	}
 
-	if (scsi_host_dif_capable(sdp->host, type))
+	if (scsi_host_dif_capable(sdp->host, type)) {
 		sd_printk(KERN_NOTICE, sdkp,
 			  "Enabling DIF Type %u protection\n", type);
-	else
+		sdkp->disk->queue->limits.needs_stable_pages = true;
+	} else
 		sd_printk(KERN_NOTICE, sdkp,
 			  "Disabling DIF Type %u protection\n", type);
 }
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 0cb39ff..9dc330c 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -338,6 +338,8 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
 	sd_printk(KERN_NOTICE, sdkp,
 		  "Enabling DIX %s protection\n", disk->integrity->name);
 
+	disk->queue->limits.needs_stable_pages = true;
+
 	/* Signal to block layer that we support sector tagging */
 	if (dif && type && sdkp->ATO) {
 		if (type == SD_DIF_TYPE3_PROTECTION)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 92956b7..a5a33db 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -266,6 +266,8 @@ struct queue_limits {
 	unsigned char		discard_misaligned;
 	unsigned char		cluster;
 	unsigned char		discard_zeroes_data;
+
+	bool			needs_stable_pages;
 };
 
 struct request_queue {
