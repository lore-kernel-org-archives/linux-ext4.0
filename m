From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: data=journal busted
Date: Fri, 16 Feb 2007 16:31:09 -0700
Message-ID: <20070216233108.GY10715@schatzie.adilger.int>
References: <20070215204445.411d2760.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:53085 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946285AbXBPXbO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 16 Feb 2007 18:31:14 -0500
Content-Disposition: inline
In-Reply-To: <20070215204445.411d2760.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Feb 15, 2007  20:44 -0800, Andrew Morton wrote:
> I have a report from a google person who just did some basic
> power-it-off-during-a-write testing on 2.6.20's ext3.  ordered-data is OK,
> but data=journal came back with crap in the file data.

Ouch.

> I suspect we should resurrect and formalise my old
> make-the-disk-stop-accepting-writes-when-a-timer-goes-off thing.  It was
> very useful for stress-testing recovery.

We have a patch that we use for Lustre testing which allows you to set a
block device readonly (silently discarding all writes), without the
filesystem immediately keeling over dead like set_disk_ro.  The readonly
state persists until the the last reference on the block device is dropped,
so there are no races w.r.t. VFS cleanup of inodes and flushing buffers
after the filesystem is unmounted.

We call this conditionally inside Lustre to simulate a crash of the node
at critical points without actually having to do lengthy reboots or have
power control.

================== dev_set_rdonly-2.6.18-vanilla.patch ==================
Index: linux-2.6/fs/block_dev.c
===================================================================
--- linux-2.6.orig/fs/block_dev.c	2006-07-06 23:41:48.000000000 +0800
+++ linux-2.6/fs/block_dev.c	2006-07-15 16:20:25.000000000 +0800
@@ -1118,6 +1118,7 @@ static int __blkdev_put(struct block_dev
 	}
 	unlock_kernel();
 	mutex_unlock(&bdev->bd_mutex);
+	dev_clear_rdonly(bdev);
 	bdput(bdev);
 	return ret;
 }
Index: linux-2.6/block/ll_rw_blk.c
===================================================================
--- linux-2.6.orig/block/ll_rw_blk.c	2006-07-10 22:30:08.000000000 +0800
+++ linux-2.6/block/ll_rw_blk.c	2006-07-15 16:15:14.000000000 +0800
@@ -2993,6 +2993,8 @@ static void handle_bad_sector(struct bio
 	set_bit(BIO_EOF, &bio->bi_flags);
 }
 
+int dev_check_rdonly(struct block_device *bdev);
+
 /**
  * generic_make_request: hand a buffer to its device driver for I/O
  * @bio:  The bio describing the location in memory and on the device.
@@ -3076,6 +3078,11 @@ end_io:
 
 		if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)))
 			goto end_io;
+		/* this is cfs's dev_rdonly check */
+		if (bio->bi_rw == WRITE && dev_check_rdonly(bio->bi_bdev)) {
+			bio_endio(bio, bio->bi_size, 0);
+			break;
+		}
 
 		/*
 		 * If this device has partitions, remap block n
@@ -3673,6 +3681,98 @@ void swap_io_context(struct io_context *
 	*ioc2 = temp;
 }
 EXPORT_SYMBOL(swap_io_context);
+
+ /*
+ * Debug code for turning block devices "read-only" (will discard writes
+ * silently).  This is for filesystem crash/recovery testing.
+ */
+struct deventry {
+	dev_t dev;
+	struct deventry *next;
+};
+
+static struct deventry *devlist = NULL;
+static spinlock_t devlock = SPIN_LOCK_UNLOCKED;
+
+int dev_check_rdonly(struct block_device *bdev)
+{
+	struct deventry *cur;
+
+	if (!bdev)
+		return 0;
+
+	spin_lock(&devlock);
+	cur = devlist;
+	while(cur) {
+		if (bdev->bd_dev == cur->dev) {
+			spin_unlock(&devlock);
+			return 1;
+		}
+		cur = cur->next;
+	}
+	spin_unlock(&devlock);
+	return 0;
+}
+
+void dev_set_rdonly(struct block_device *bdev)
+{
+	struct deventry *newdev, *cur;
+
+	if (!bdev)
+		return;
+
+	newdev = kmalloc(sizeof(struct deventry), GFP_KERNEL);
+	if (!newdev)
+		return;
+
+	spin_lock(&devlock);
+	cur = devlist;
+	while(cur) {
+		if (bdev->bd_dev == cur->dev) {
+			spin_unlock(&devlock);
+			kfree(newdev);
+			return;
+		}
+		cur = cur->next;
+	}
+	newdev->dev = bdev->bd_dev;
+	newdev->next = devlist;
+	devlist = newdev;
+	spin_unlock(&devlock);
+	printk(KERN_WARNING "Turning device %s (%#x) read-only\n",
+	       bdev->bd_disk ? bdev->bd_disk->disk_name : "", bdev->bd_dev);
+}
+
+void dev_clear_rdonly(struct block_device *bdev)
+{
+	struct deventry *cur, *last = NULL;
+
+	if (!bdev)
+		return;
+
+	spin_lock(&devlock);
+	cur = devlist;
+	while (cur) {
+		if (bdev->bd_dev == cur->dev) {
+			if (last)
+				last->next = cur->next;
+			else
+				devlist = cur->next;
+			spin_unlock(&devlock);
+			kfree(cur);
+			printk(KERN_WARNING "Removing read-only on %s (%#x)\n",
+			       bdev->bd_disk ? bdev->bd_disk->disk_name :
+					       "unknown block", bdev->bd_dev);
+			return;
+		}
+		last = cur;
+		cur = cur->next;
+	}
+	spin_unlock(&devlock);
+}
+
+EXPORT_SYMBOL(dev_set_rdonly);
+EXPORT_SYMBOL(dev_check_rdonly);
 
 /*
  * sysfs parts below
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2006-07-15 16:14:58.000000000 +0800
+++ linux-2.6/include/linux/fs.h	2006-07-15 16:15:14.000000000 +0800
@@ -1648,6 +1648,9 @@ extern void file_kill(struct file *f);
 struct bio;
 extern void submit_bio(int, struct bio *);
 extern int bdev_read_only(struct block_device *);
+#define HAVE_CLEAR_RDONLY_ON_PUT
+void dev_set_rdonly(struct block_device *bdev);
+int dev_check_rdonly(struct block_device *bdev);
+void dev_clear_rdonly(struct block_device *bdev);
 extern int set_blocksize(struct block_device *, int);
 extern int sb_set_blocksize(struct super_block *, int);
 extern int sb_min_blocksize(struct super_block *, int);

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
