From: scjody@sun.com
Subject: [patch 1/4] [md] Add SKIP_RESYNC ioctl
Date: Thu, 01 Oct 2009 18:39:30 -0400
Message-ID: <20091001224013.254622382@sun.com>
References: <20091001223929.120106893@sun.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; NAME=''md-skip-resync.patch
Content-Transfer-Encoding: 7BIT
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <adilger@sun.com>
To: linux-ext4@vger.kernel.org, linux-raid@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753891AbZJAWkU@vger.kernel.org>
Content-disposition: inline; filename=md-skip-resync.patch
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Add a SKIP_RESYNC ioctl to md allowing resync to be skipped on an MD device
or partition.

Design note: I expect there to be one (unpartitioned MD device) or just a few
(partitioned MD device) skip_list entries, therefore searching a linked list
is not a huge concern.

Index: linux-2.6.18-128.1.6/drivers/md/md.c
===================================================================
--- linux-2.6.18-128.1.6.orig/drivers/md/md.c
+++ linux-2.6.18-128.1.6/drivers/md/md.c
@@ -314,12 +314,13 @@ static inline int mddev_trylock(mddev_t 
 	return mutex_trylock(&mddev->reconfig_mutex);
 }
 
-static inline void mddev_unlock(mddev_t * mddev)
+inline void mddev_unlock(mddev_t * mddev)
 {
 	mutex_unlock(&mddev->reconfig_mutex);
 
 	md_wakeup_thread(mddev->thread);
 }
+EXPORT_SYMBOL_GPL(mddev_unlock);
 
 static mdk_rdev_t * find_rdev_nr(mddev_t *mddev, int nr)
 {
@@ -4484,6 +4485,33 @@ static int md_ioctl(struct inode *inode,
 			err = set_bitmap_file(mddev, (int)arg);
 			goto done_unlock;
 
+		case SKIP_RESYNC:
+		{
+			struct hd_struct *part = inode->i_bdev->bd_part;
+			sector_t start, end;
+
+			if (mddev->pers == NULL) {
+				err = -ENODEV;
+				goto abort_unlock;
+			}
+
+			if (mddev->pers->skip_resync == NULL) {
+				err = -EINVAL;
+				goto abort_unlock;
+			}
+
+			if (part) {
+				start = part->start_sect;
+				end = part->start_sect + part->nr_sects - 1;
+			} else {
+				start = 0;
+				end = (mddev->array_size<<1) - 1;
+			}
+
+			err = mddev->pers->skip_resync(mddev, start, end);
+			goto done_unlock;
+		}
+
 		default:
 			err = -EINVAL;
 			goto abort_unlock;
Index: linux-2.6.18-128.1.6/include/linux/raid/md_u.h
===================================================================
--- linux-2.6.18-128.1.6.orig/include/linux/raid/md_u.h
+++ linux-2.6.18-128.1.6/include/linux/raid/md_u.h
@@ -45,6 +45,7 @@
 #define STOP_ARRAY		_IO (MD_MAJOR, 0x32)
 #define STOP_ARRAY_RO		_IO (MD_MAJOR, 0x33)
 #define RESTART_ARRAY_RW	_IO (MD_MAJOR, 0x34)
+#define SKIP_RESYNC		_IO (MD_MAJOR, 0x40)
 
 typedef struct mdu_version_s {
 	int major;
Index: linux-2.6.18-128.1.6/include/linux/raid/md_k.h
===================================================================
--- linux-2.6.18-128.1.6.orig/include/linux/raid/md_k.h
+++ linux-2.6.18-128.1.6/include/linux/raid/md_k.h
@@ -283,6 +283,7 @@ struct mdk_personality
 	 * others - reserved
 	 */
 	void (*quiesce) (mddev_t *mddev, int state);
+	int (*skip_resync) (mddev_t *mddev, sector_t start, sector_t end);
 };
 
 
Index: linux-2.6.18-128.1.6/drivers/md/raid5.c
===================================================================
--- linux-2.6.18-128.1.6.orig/drivers/md/raid5.c
+++ linux-2.6.18-128.1.6/drivers/md/raid5.c
@@ -2827,6 +2827,72 @@ static inline int raid5_redo_bio(raid5_c
 	return redo;
 }
 
+/*
+ * Mark the range of sectors start-end to be skipped during the current
+ * resync.  If no resync is in progress, this will be ignored.
+ */
+static int skip_resync(mddev_t *mddev, sector_t start, sector_t end)
+{
+	struct skip_entry *new;
+	raid5_conf_t *conf = (raid5_conf_t *) mddev->private;
+	unsigned int dd_idx, pd_idx, disks, data_disks;
+
+	if (!test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
+		return 0;
+
+	new = kmalloc(sizeof(*new), GFP_KERNEL);
+	if (new == NULL)
+		return -ENOMEM;
+
+	disks = conf->raid_disks;
+	data_disks = disks - conf->max_degraded;
+
+	new->start = raid5_compute_sector(start, disks, data_disks,
+					  &dd_idx, &pd_idx, conf);
+	new->end = raid5_compute_sector(end, disks, data_disks,
+					&dd_idx, &pd_idx, conf);
+	spin_lock_irq(&conf->device_lock);
+	list_add(&new->skip_list, &conf->skip_list);
+	spin_unlock_irq(&conf->device_lock);
+
+	return 0;
+}
+
+/*
+ * Check to see if this sector should be skipped.  If so, return the number
+ * of sectors to skip.
+ */
+static sector_t check_skip_list(raid5_conf_t *conf, sector_t sector_nr)
+{
+	struct skip_entry *e;
+
+	list_for_each_entry(e, &conf->skip_list, skip_list) {
+		if (sector_nr >= e->start && sector_nr <= e->end)
+			return (e->end - sector_nr + 1);
+	}
+
+	return 0;
+}
+
+/* Clear the skip list and free associated memory. */
+static void clear_skip_list(raid5_conf_t *conf)
+{
+	struct list_head free_list;
+
+	INIT_LIST_HEAD(&free_list);
+	spin_lock_irq(&conf->device_lock);
+	list_splice_init(&conf->skip_list, &free_list);
+	spin_unlock_irq(&conf->device_lock);
+
+	while (!list_empty(&free_list)) {
+		struct list_head *l = free_list.next;
+		struct skip_entry *e = list_entry(l, struct skip_entry,
+						  skip_list);
+		list_del_init(l);
+		kfree(e);
+	}
+}
+
 static int make_request(request_queue_t *q, struct bio * bi)
 {
 	mddev_t *mddev = q->queuedata;
@@ -3154,6 +3220,7 @@ static inline sector_t sync_request(mdde
 	int sync_blocks;
 	int still_degraded = 0;
 	int i;
+	sector_t skip_sectors;
 
 	if (sector_nr >= max_sector) {
 		/* just being told to finish up .. nothing much to do */
@@ -3169,6 +3236,7 @@ static inline sector_t sync_request(mdde
 		else /* completed sync */
 			conf->fullsync = 0;
 		bitmap_close_sync(mddev->bitmap);
+		clear_skip_list(conf);
 
 		return 0;
 	}
@@ -3194,6 +3262,13 @@ static inline sector_t sync_request(mdde
 		*skipped = 1;
 		return sync_blocks * STRIPE_SECTORS; /* keep things rounded to whole stripes */
 	}
+	spin_lock_irq(&conf->device_lock);
+	skip_sectors = check_skip_list(conf, sector_nr);
+	spin_unlock_irq(&conf->device_lock);
+	if (skip_sectors) {
+		*skipped = 1;
+		return skip_sectors;
+	}
 
 	pd_idx = stripe_to_pdidx(sector_nr, conf, raid_disks);
 	sh = get_active_stripe(conf, sector_nr, raid_disks, pd_idx, 1);
@@ -3449,6 +3524,7 @@ static int run(mddev_t *mddev)
 	INIT_LIST_HEAD(&conf->delayed_list);
 	INIT_LIST_HEAD(&conf->bitmap_list);
 	INIT_LIST_HEAD(&conf->inactive_list);
+	INIT_LIST_HEAD(&conf->skip_list);
 	atomic_set(&conf->active_stripes, 0);
 	atomic_set(&conf->preread_active_stripes, 0);
 
@@ -4029,6 +4105,7 @@ static struct mdk_personality raid6_pers
 	.sync_request	= sync_request,
 	.resize		= raid5_resize,
 	.quiesce	= raid5_quiesce,
+	.skip_resync	= skip_resync,
 };
 static struct mdk_personality raid5_personality =
 {
@@ -4050,6 +4127,7 @@ static struct mdk_personality raid5_pers
 	.start_reshape  = raid5_start_reshape,
 #endif
 	.quiesce	= raid5_quiesce,
+	.skip_resync	= skip_resync,
 };
 
 static struct mdk_personality raid4_personality =
@@ -4068,6 +4146,7 @@ static struct mdk_personality raid4_pers
 	.sync_request	= sync_request,
 	.resize		= raid5_resize,
 	.quiesce	= raid5_quiesce,
+	.skip_resync	= skip_resync,
 };
 
 static int __init raid5_init(void)
Index: linux-2.6.18-128.1.6/include/linux/raid/raid5.h
===================================================================
--- linux-2.6.18-128.1.6.orig/include/linux/raid/raid5.h
+++ linux-2.6.18-128.1.6/include/linux/raid/raid5.h
@@ -260,6 +260,7 @@ struct raid5_private_data {
 	int			pool_size; /* number of disks in stripeheads in pool */
 	spinlock_t		device_lock;
 	struct disk_info	*disks;
+	struct list_head	skip_list;	/* used to skip resync on certain blocks */
 
 	/*
 	 * Stats
@@ -294,4 +295,11 @@ typedef struct raid5_private_data raid5_
 #define ALGORITHM_LEFT_SYMMETRIC	2
 #define ALGORITHM_RIGHT_SYMMETRIC	3
 
+struct skip_entry {
+	struct list_head	skip_list;
+
+	sector_t		start;
+	sector_t		end;
+};
+
 #endif
Index: linux-2.6.18-128.1.6/include/linux/raid/md.h
===================================================================
--- linux-2.6.18-128.1.6.orig/include/linux/raid/md.h
+++ linux-2.6.18-128.1.6/include/linux/raid/md.h
@@ -95,5 +95,7 @@ extern void md_new_event(mddev_t *mddev)
 
 extern void md_update_sb(mddev_t * mddev);
 
+extern void mddev_unlock(mddev_t * mddev);
+
 #endif 
 

-- 
