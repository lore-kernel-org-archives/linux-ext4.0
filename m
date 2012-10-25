From: zwu.kernel@gmail.com
Subject: [RFC v4 12/15] vfs,hot_track: turn some Micro into be tunable
Date: Thu, 25 Oct 2012 23:09:04 +0800
Message-ID: <1351177747-19389-13-git-send-email-zwu.kernel@gmail.com>
References: <1351177747-19389-1-git-send-email-zwu.kernel@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, tytso@mit.edu,
	cmm@us.ibm.com, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:50172 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932177Ab2JYPNl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Oct 2012 11:13:41 -0400
Received: from /spool/local
	by e2.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Thu, 25 Oct 2012 11:13:35 -0400
In-Reply-To: <1351177747-19389-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Turn TIME_TO_KICK and HEAT_UPDATE_DELAY
into be tunable via /proc/sys/fs/hot-kick-time and
/proc/sys/fs/hot-update-delay.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            |   12 +++++++++---
 fs/hot_tracking.h            |    9 ---------
 include/linux/hot_tracking.h |    7 +++++++
 kernel/sysctl.c              |   14 ++++++++++++++
 4 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 18a64ee..15ed407 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -25,6 +25,12 @@
 #include <linux/limits.h>
 #include "hot_tracking.h"
 
+int sysctl_hot_kick_time __read_mostly = 300;
+EXPORT_SYMBOL_GPL(sysctl_hot_kick_time);
+
+int sysctl_hot_update_delay __read_mostly = 300;
+EXPORT_SYMBOL_GPL(sysctl_hot_update_delay);
+
 static struct hot_info *hot_root;
 
 /* kmem_cache pointers for slab caches */
@@ -345,7 +351,7 @@ static bool hot_freq_data_is_obsolete(struct hot_freq_data *freq_data)
 		(cur_time - timespec_to_ns(&freq_data->last_read_time));
 	u64 last_write_ns =
 		(cur_time - timespec_to_ns(&freq_data->last_write_time));
-	u64 kick_ns =  TIME_TO_KICK * NSEC_PER_SEC;
+	u64 kick_ns =  sysctl_hot_kick_time * NSEC_PER_SEC;
 
 	if ((last_read_ns > kick_ns) && (last_write_ns > kick_ns))
 		ret = 1;
@@ -651,7 +657,7 @@ static void hot_update_worker(struct work_struct *work)
 
 	/* Instert next delayed work */
 	queue_delayed_work(root->update_wq, &root->update_work,
-		msecs_to_jiffies(HEAT_UPDATE_DELAY * MSEC_PER_SEC));
+		msecs_to_jiffies(sysctl_hot_update_delay * MSEC_PER_SEC));
 }
 
 /*
@@ -1257,7 +1263,7 @@ int hot_track_init(struct super_block *sb)
 	/* Initialize hot tracking wq and arm one delayed work */
 	INIT_DELAYED_WORK(&root->update_work, hot_update_worker);
 	queue_delayed_work(root->update_wq, &root->update_work,
-		msecs_to_jiffies(HEAT_UPDATE_DELAY * MSEC_PER_SEC));
+		msecs_to_jiffies(sysctl_hot_update_delay * MSEC_PER_SEC));
 
 	/* Register a shrinker callback */
 	root->hot_shrink.shrink = hot_track_prune;
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index 6eb024f..d6d9161 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -26,15 +26,6 @@
 #define FREQ_POWER 4
 
 /*
- * time to quit keeping track of
- * tracking data (seconds)
- */
-#define TIME_TO_KICK 300
-
-/* set how often to update temperatures (seconds) */
-#define HEAT_UPDATE_DELAY 300
-
-/*
  * The following comments explain what exactly comprises a unit of heat.
  *
  * Each of six values of heat are calculated and combined in order to form an
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index 7107cfa..ea59f33 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -101,6 +101,13 @@ struct hot_info {
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

