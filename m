From: scjody@sun.com
Subject: [patch 2/4] [md] Add RESYNC_RANGE ioctl
Date: Thu, 01 Oct 2009 18:39:31 -0400
Message-ID: <20091001224016.013217204@sun.com>
References: <20091001223929.120106893@sun.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; NAME=''md-resync-range.patch
Content-Transfer-Encoding: 7BIT
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <adilger@sun.com>
To: linux-ext4@vger.kernel.org, linux-raid@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753917AbZJAWkj@vger.kernel.org>
Content-disposition: inline; filename=md-resync-range.patch
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Add the RESYNC_RANGE ioctl and implement it for RAID 4/5/6.  This causes an
immediate resync of the requested sectors if the device is under resync.

TODO: In raid456 (and probably in any other personality that implements
this), there should be some concept of the last blocks that were resynced
since the personality can resync more data than requested which will result
in multiple resyncs of the same data with this implementation.

Index: linux-2.6.18-128.1.6/drivers/md/md.c
===================================================================
--- linux-2.6.18-128.1.6.orig/drivers/md/md.c
+++ linux-2.6.18-128.1.6/drivers/md/md.c
@@ -4512,6 +4512,71 @@ static int md_ioctl(struct inode *inode,
 			goto done_unlock;
 		}
 
+		case RESYNC_RANGE:
+		{
+			mdu_range_t range;
+			struct hd_struct *part = inode->i_bdev->bd_part;
+			int ret;
+
+			if (!arg) {
+				err = -EINVAL;
+				goto abort_unlock;
+			}
+
+			ret = copy_from_user(&range, argp, sizeof(range));
+			if (ret) {
+				err = -EFAULT;
+				goto abort_unlock;
+			}
+
+			if (range.start > range.end) {
+				err = -EINVAL;
+				goto abort_unlock;
+			}
+
+			if (part) {
+				sector_t part_end;
+
+				range.start += part->start_sect;
+				range.end += part->start_sect;
+
+				part_end = part->start_sect + part->nr_sects - 1;
+
+				if (range.end > part_end) {
+					err = -EINVAL;
+					goto abort_unlock;
+				}
+			}
+
+			if (range.end >= mddev->array_size<<1) {
+				err = -EINVAL;
+				goto abort_unlock;
+			}
+
+			if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
+				/* We are already in sync; return success */
+				err = 0;
+				goto abort_unlock;
+			}
+
+			if (!test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
+				/* Something is running but not a resync. */
+				err = -EBUSY;
+				goto abort_unlock;
+			}
+
+			if (mddev->pers->resync_range == NULL) {
+				err = -EINVAL;
+				goto abort_unlock;
+			}
+
+
+			err = mddev->pers->resync_range(mddev, range.start,
+							range.end);
+
+			goto done_unlock;
+		}
+
 		default:
 			err = -EINVAL;
 			goto abort_unlock;
@@ -4865,6 +4930,7 @@ static int md_seq_show(struct seq_file *
 	mdk_rdev_t *rdev;
 	struct mdstat_info *mi = seq->private;
 	struct bitmap *bitmap;
+	unsigned long resync;
 
 	if (v == (void*)1) {
 		struct mdk_personality *pers;
@@ -4883,6 +4949,8 @@ static int md_seq_show(struct seq_file *
 		return 0;
 	}
 
+	resync = (mddev->curr_resync - atomic_read(&mddev->recovery_active))/2;
+ 
 	if (mddev_lock(mddev) < 0)
 		return -EINTR;
 
Index: linux-2.6.18-128.1.6/include/linux/raid/md_u.h
===================================================================
--- linux-2.6.18-128.1.6.orig/include/linux/raid/md_u.h
+++ linux-2.6.18-128.1.6/include/linux/raid/md_u.h
@@ -46,6 +46,7 @@
 #define STOP_ARRAY_RO		_IO (MD_MAJOR, 0x33)
 #define RESTART_ARRAY_RW	_IO (MD_MAJOR, 0x34)
 #define SKIP_RESYNC		_IO (MD_MAJOR, 0x40)
+#define RESYNC_RANGE		_IO (MD_MAJOR, 0x41)
 
 typedef struct mdu_version_s {
 	int major;
@@ -121,5 +122,11 @@ typedef struct mdu_param_s
 	int			max_fault;	/* unused for now */
 } mdu_param_t;
 
+typedef struct mdu_range_s
+{
+	__u64           start;          /* starting sector */
+	__u64           end;            /* ending sector */
+} mdu_range_t;
+
 #endif 
 
Index: linux-2.6.18-128.1.6/drivers/md/raid5.c
===================================================================
--- linux-2.6.18-128.1.6.orig/drivers/md/raid5.c
+++ linux-2.6.18-128.1.6/drivers/md/raid5.c
@@ -1698,8 +1698,10 @@ static void handle_stripe5(struct stripe
 		}
 	}
 	if (failed > 1 && syncing) {
-		md_done_sync(conf->mddev, STRIPE_SECTORS,0);
+		if (!test_bit(STRIPE_RESYNC_RANGE, &sh->state))
+			md_done_sync(conf->mddev, STRIPE_SECTORS,0);
 		clear_bit(STRIPE_SYNCING, &sh->state);
+		clear_bit(STRIPE_RESYNC_RANGE, &sh->state);
 		syncing = 0;
 	}
 
@@ -1932,8 +1934,10 @@ static void handle_stripe5(struct stripe
 		}
 	}
 	if (syncing && locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
-		md_done_sync(conf->mddev, STRIPE_SECTORS,1);
+		if (!test_bit(STRIPE_RESYNC_RANGE, &sh->state))
+			md_done_sync(conf->mddev, STRIPE_SECTORS,1);
 		clear_bit(STRIPE_SYNCING, &sh->state);
+		clear_bit(STRIPE_RESYNC_RANGE, &sh->state);
 	}
 
 	/* If the failed drive is just a ReadError, then we might need to progress
@@ -2275,8 +2279,10 @@ static void handle_stripe6(struct stripe
 		}
 	}
 	if (failed > 2 && syncing) {
-		md_done_sync(conf->mddev, STRIPE_SECTORS,0);
+		if (!test_bit(STRIPE_RESYNC_RANGE, &sh->state))
+			md_done_sync(conf->mddev, STRIPE_SECTORS,0);
 		clear_bit(STRIPE_SYNCING, &sh->state);
+		clear_bit(STRIPE_RESYNC_RANGE, &sh->state);
 		syncing = 0;
 	}
 
@@ -2571,8 +2577,10 @@ static void handle_stripe6(struct stripe
 	}
 
 	if (syncing && locked == 0 && test_bit(STRIPE_INSYNC, &sh->state)) {
-		md_done_sync(conf->mddev, STRIPE_SECTORS,1);
+		if (!test_bit(STRIPE_RESYNC_RANGE, &sh->state))
+			md_done_sync(conf->mddev, STRIPE_SECTORS,1);
 		clear_bit(STRIPE_SYNCING, &sh->state);
+		clear_bit(STRIPE_RESYNC_RANGE, &sh->state);
 	}
 
 	/* If the failed drives are just a ReadError, then we might need
@@ -3300,6 +3308,52 @@ static inline sector_t sync_request(mdde
 	return STRIPE_SECTORS;
 }
 
+/* Perform an immediate resync of the requested range. */
+static int resync_range(mddev_t *mddev, sector_t start, sector_t end)
+{
+	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
+	sector_t j, sync_end;
+	unsigned int dd_idx, pd_idx, disks, data_disks;
+
+	printk("resync_range, sectors %llu - %llu\n", (unsigned long long)start,
+	       (unsigned long long)end);
+
+	disks = conf->raid_disks;
+	data_disks = disks - conf->max_degraded;
+
+	j = raid5_compute_sector(start, disks, data_disks,
+				 &dd_idx, &pd_idx, conf);
+	sync_end = raid5_compute_sector(end, disks, data_disks,
+					&dd_idx, &pd_idx, conf);
+
+	while (j <= sync_end) {
+		struct stripe_head *sh;
+
+		pd_idx = stripe_to_pdidx(j, conf, disks);
+		sh = get_active_stripe(conf, j, disks, pd_idx, 1);
+		if (sh == NULL) {
+			sh = get_active_stripe(conf, j, disks, pd_idx, 0);
+			/* make sure we don't swamp the stripe cache if someone
+			 * else is trying to get access
+			 */
+			schedule_timeout_uninterruptible(1);
+		}
+
+		spin_lock(&sh->lock);
+		set_bit(STRIPE_SYNCING, &sh->state);
+		set_bit(STRIPE_RESYNC_RANGE, &sh->state);
+		clear_bit(STRIPE_INSYNC, &sh->state);
+		spin_unlock(&sh->lock);
+
+		handle_stripe(sh, NULL, NULL);
+		release_stripe(sh);
+
+		j += STRIPE_SECTORS;
+	}
+
+	return 0;
+}
+
 /*
  * This is our raid5 kernel thread.
  *
@@ -4106,6 +4160,7 @@ static struct mdk_personality raid6_pers
 	.resize		= raid5_resize,
 	.quiesce	= raid5_quiesce,
 	.skip_resync	= skip_resync,
+	.resync_range	= resync_range,
 };
 static struct mdk_personality raid5_personality =
 {
@@ -4128,6 +4183,7 @@ static struct mdk_personality raid5_pers
 #endif
 	.quiesce	= raid5_quiesce,
 	.skip_resync	= skip_resync,
+	.resync_range	= resync_range,
 };
 
 static struct mdk_personality raid4_personality =
@@ -4147,6 +4203,7 @@ static struct mdk_personality raid4_pers
 	.resize		= raid5_resize,
 	.quiesce	= raid5_quiesce,
 	.skip_resync	= skip_resync,
+	.resync_range	= resync_range,
 };
 
 static int __init raid5_init(void)
Index: linux-2.6.18-128.1.6/include/linux/raid/md_k.h
===================================================================
--- linux-2.6.18-128.1.6.orig/include/linux/raid/md_k.h
+++ linux-2.6.18-128.1.6/include/linux/raid/md_k.h
@@ -284,6 +284,7 @@ struct mdk_personality
 	 */
 	void (*quiesce) (mddev_t *mddev, int state);
 	int (*skip_resync) (mddev_t *mddev, sector_t start, sector_t end);
+	int (*resync_range) (mddev_t *mddev, sector_t start, sector_t end);
 };
 
 
Index: linux-2.6.18-128.1.6/include/linux/raid/raid5.h
===================================================================
--- linux-2.6.18-128.1.6.orig/include/linux/raid/raid5.h
+++ linux-2.6.18-128.1.6/include/linux/raid/raid5.h
@@ -180,6 +180,8 @@ struct stripe_head {
 #define	STRIPE_EXPANDING	9
 #define	STRIPE_EXPAND_SOURCE	10
 #define	STRIPE_EXPAND_READY	11
+#define	STRIPE_RESYNC_RANGE	12
+
 /*
  * Plugging:
  *

-- 
