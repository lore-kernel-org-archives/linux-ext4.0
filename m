From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC PATCH 1/1] add a jbd option to force an unclean journal	state
Date: Wed, 05 Mar 2008 00:34:19 -0700
Message-ID: <20080305073418.GG3616@webber.adilger.int>
References: <200803041339.42544.jbacik@redhat.com>
 <20080304190109.GD24335@duck.suse.cz>
 <20080304155801.6f48bf08.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Jan Kara <jack@suse.cz>, jbacik@redhat.com,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:37619 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbYCEHet (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 5 Mar 2008 02:34:49 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m257Ykpb011592
	for <linux-ext4@vger.kernel.org>; Tue, 4 Mar 2008 23:34:47 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JX800E01Y9T0S00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 04 Mar 2008 23:34:46 -0800 (PST)
In-reply-to: <20080304155801.6f48bf08.akpm@linux-foundation.org>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 04, 2008  15:58 -0800, Andrew Morton wrote:
> - mount the filesystem with `-o ro_after=100'
> 
> - the fs arms a timer to go off in 100 seconds
> 
> - now you start running some filesystem stress test
> 
> - the timer goes off.  At timer-interrupt time, flags are set which cause
>   the low-level driver layer to start silently ignoring all writes to the
>   device which backs the filesystem.
> 
>   This simulates a crash or poweroff.
> 
> - Now up in userspace we
> 
>   - kill off the stresstest
>   - unmount the fs
>   - mount the fs (to run recovery)
>   - unmount the fs
>   - fsck it
>   - mount the fs
>     - check the data content of the files which the stresstest was writing:
>       look for uninitialised blocks, incorrect data, etc.
>   - unmount the fs
> 
> - start it all again.
> 
> 
> So it's 100% scriptable and can be left running overnight, etc.  It found
> quite a few problems with ext3/jbd recovery which I doubt could be found by
> other means.  This was 6-7 years ago and I'd expect that new recovery bugs
> have crept in since then which it can expose.
> 
> I think we should implement this in a formal, mergeable fashion, as there
> are numerous filesystems which could and should use this sort of testing
> infrastructure.

We use a patch which is a distant ancestor of Andrew's original patch to
do very similar testing for Lustre + ext3, allowing us to simulate node
crashes.  This patch is against 2.6.22, but the relevant code doesn't
appear significantly changed in newer kernels.  YMMV.

The major difference between this code and Andrew's original code is
that this allows multiple devices to be turned read-only at one time
(e.g. ext3 filesystem + external journal), while the original code wasn't
very robust in that area.

There is no mechanism to enable this from userspace or the filesystem,
since there is Lustre code in the kernel that calls dev_set_rdonly()
on one or more devices when we hit a failure trigger, but adding the
timer code or a /proc or /sys entry for this would be easy.

The device is reset only when the last reference to it is removed in
kill_bdev() so that there isn't a race with re-enabling writes to the
device while there are still dirty buffers outstanding, and certainly
corrupting the filesystem.  That's why dev_clear_rdonly() is not exported.

Signed-off-by: Andreas Dilger <adilger@clusterfs.com>

Index: linux-2.6.22.5/block/ll_rw_blk.c
===================================================================
--- linux-2.6.22.5.orig/block/ll_rw_blk.c	2007-08-22 17:23:54.000000000 -0600
+++ linux-2.6.22.5/block/ll_rw_blk.c	2008-02-21 01:07:16.000000000 -0700
@@ -3101,6 +3101,8 @@
 
 #endif /* CONFIG_FAIL_MAKE_REQUEST */
 
+int dev_check_rdonly(struct block_device *bdev);
+
 /**
  * generic_make_request: hand a buffer to its device driver for I/O
  * @bio:  The bio describing the location in memory and on the device.
@@ -3185,6 +3187,12 @@ static inline void __generic_make_request
 
 		if (unlikely(test_bit(QUEUE_FLAG_DEAD, &q->queue_flags)))
 			goto end_io;
+
+		if (unlikely(bio->bi_rw == WRITE &&
+		             dev_check_rdonly(bio->bi_bdev))) {
+			bio_endio(bio, bio->bi_size, 0);
+			break;
+		}
 
 		if (should_fail_request(bio))
 			goto end_io;
@@ -3850,6 +3858,100 @@ void swap_io_context(struct io_context
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
+	while (cur) {
+		if (bdev->bd_dev == cur->dev) {
+			spin_unlock(&devlock);
+			return 1;
+		}
+		cur = cur->next;
+	}
+	spin_unlock(&devlock);
+
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
+	while (cur) {
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
+
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
Index: linux-2.6.22.5/fs/block_dev.c
===================================================================
--- linux-2.6.22.5.orig/fs/block_dev.c	2007-08-22 17:23:54.000000000 -0600
+++ linux-2.6.22.5/fs/block_dev.c	2008-02-21 01:07:16.000000000 -0700
@@ -63,6 +63,7 @@ static void kill_bdev(struct block_device *bdev)
 		return;
 	invalidate_bh_lrus();
 	truncate_inode_pages(bdev->bd_inode->i_mapping, 0);
+	dev_clear_rdonly(bdev);
 }	
 
 int set_blocksize(struct block_device *bdev, int size)
Index: linux-2.6.22.5/include/linux/fs.h
===================================================================
--- linux-2.6.22.5.orig/include/linux/fs.h	2008-02-21 00:58:18.000000000 -0700
+++ linux-2.6.22.5/include/linux/fs.h	2008-02-21 01:07:16.000000000 -0700
@@ -1744,6 +1744,10 @@
 extern void submit_bio(int, struct bio *);
 extern int bdev_read_only(struct block_device *);
 #endif
+#define HAVE_CLEAR_RDONLY_ON_PUT
+extern void dev_set_rdonly(struct block_device *bdev);
+extern int dev_check_rdonly(struct block_device *bdev);
+extern void dev_clear_rdonly(struct block_device *bdev);
 extern int set_blocksize(struct block_device *, int);
 extern int sb_set_blocksize(struct super_block *, int);
 extern int sb_min_blocksize(struct super_block *, int);

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

