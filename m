From: zwu.kernel@gmail.com
Subject: [RFC v4+ hot_track 15/19] sysfs: add two hot_track proc files
Date: Mon, 29 Oct 2012 12:30:57 +0800
Message-ID: <1351485061-12297-16-git-send-email-zwu.kernel@gmail.com>
References: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, tytso@mit.edu,
	cmm@us.ibm.com, wuzhy@linux.vnet.ibm.com, wenqing.lz@taobao.com
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1351485061-12297-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Add two proc files hot-kick-time and hot-update-delay
under the dir /proc/sys/fs/ in order to turn
TIME_TO_KICK and HEAT_UPDATE_DELAY into be tunable.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            |   12 +++++++++---
 fs/hot_tracking.h            |    9 ---------
 include/linux/hot_tracking.h |    7 +++++++
 kernel/sysctl.c              |   14 ++++++++++++++
 4 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 376d7fb..02ac4a2 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -28,6 +28,12 @@
 static DEFINE_SPINLOCK(hot_func_list_lock);
 static LIST_HEAD(hot_func_list);
 
+int sysctl_hot_kick_time __read_mostly = 300;
+EXPORT_SYMBOL_GPL(sysctl_hot_kick_time);
+
+int sysctl_hot_update_delay __read_mostly = 300;
+EXPORT_SYMBOL_GPL(sysctl_hot_update_delay);
+
 /* kmem_cache pointers for slab caches */
 static struct kmem_cache *hot_inode_item_cachep __read_mostly;
 static struct kmem_cache *hot_range_item_cachep __read_mostly;
@@ -417,7 +423,7 @@ static bool hot_is_obsolete(struct hot_freq_data *freq_data)
 		(cur_time - timespec_to_ns(&freq_data->last_read_time));
 	u64 last_write_ns =
 		(cur_time - timespec_to_ns(&freq_data->last_write_time));
-	u64 kick_ns =  TIME_TO_KICK * NSEC_PER_SEC;
+	u64 kick_ns =  sysctl_hot_kick_time * NSEC_PER_SEC;
 
 	if ((last_read_ns > kick_ns) && (last_write_ns > kick_ns))
 		ret = 1;
@@ -625,7 +631,7 @@ static void hot_update_worker(struct work_struct *work)
 
 	/* Instert next delayed work */
 	queue_delayed_work(root->update_wq, &root->update_work,
-		msecs_to_jiffies(HEAT_UPDATE_DELAY * MSEC_PER_SEC));
+		msecs_to_jiffies(sysctl_hot_update_delay * MSEC_PER_SEC));
 }
 
 /*
@@ -1316,7 +1322,7 @@ int hot_track_init(struct super_block *sb)
 	/* Initialize hot tracking wq and arm one delayed work */
 	INIT_DELAYED_WORK(&root->update_work, hot_update_worker);
 	queue_delayed_work(root->update_wq, &root->update_work,
-		msecs_to_jiffies(HEAT_UPDATE_DELAY * MSEC_PER_SEC));
+		msecs_to_jiffies(sysctl_hot_update_delay * MSEC_PER_SEC));
 
 	/* Register a shrinker callback */
 	root->hot_shrink.shrink = hot_track_prune;
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index f5ba2d6..095eab0 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -26,15 +26,6 @@
 
 #define FREQ_POWER 4
 
-/*
- * time to quit keeping track of
- * tracking data (seconds)
- */
-#define TIME_TO_KICK 300
-
-/* set how often to update temperatures (seconds) */
-#define HEAT_UPDATE_DELAY 300
-
 /* NRR/NRW heat unit = 2^X accesses */
 #define NRR_MULTIPLIER_POWER 20 /* NRR - number of reads since mount */
 #define NRR_COEFF_POWER 0
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index a16217f..416c988 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -123,6 +123,13 @@ struct hot_info {
 };
 
 /*
+ * Two variables have meanings as below:
+ * 1. time to quit keeping track of tracking data (seconds)
+ * 2. set how often to update temperatures (seconds)
+ */
+extern int sysctl_hot_kick_time, sysctl_hot_update_delay;
+
+/*
  * Hot data tracking ioctls:
  *
  * HOT_INFO - retrieve info on frequency of access
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 26f65ea..37624fb 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1545,6 +1545,20 @@ static struct ctl_table fs_table[] = {
 		.proc_handler	= &pipe_proc_fn,
 		.extra1		= &pipe_min_size,
 	},
+	{
+		.procname	= "hot-kick-time",
+		.data		= &sysctl_hot_kick_time,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+	{
+		.procname	= "hot-update-delay",
+		.data		= &sysctl_hot_update_delay,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 	{ }
 };
 
-- 
1.7.6.5
