From: zwu.kernel@gmail.com
Subject: [RFC v3 09/13] vfs: add one wq to update map info periodically
Date: Wed, 10 Oct 2012 18:07:31 +0800
Message-ID: <1349863655-29320-10-git-send-email-zwu.kernel@gmail.com>
References: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, dave@jikos.cz,
	tytso@mit.edu, cmm@us.ibm.com,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Add a per-superblock workqueue and a work_struct
 to run periodic work to update map info on each superblock.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            |   94 ++++++++++++++++++++++++++++++++++++++++++
 fs/hot_tracking.h            |    3 +
 include/linux/hot_tracking.h |    2 +
 3 files changed, 99 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index a8dc599..f333c47 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -15,6 +15,8 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/hardirq.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
 #include <linux/fs.h>
 #include <linux/blkdev.h>
 #include <linux/types.h>
@@ -623,6 +625,88 @@ static void hot_map_array_exit(struct hot_info *root)
 }
 
 /*
+ * Update temperatures for each hot inode item and
+ * hot range item for aging purposes
+ */
+static void hot_temperature_update_work(struct work_struct *work)
+{
+	struct hot_update_work *hot_work =
+			container_of(work, struct hot_update_work, work);
+	struct hot_info *root = hot_work->hot_info;
+	struct hot_inode_item *hi_nodes[8];
+	unsigned long delay = HZ * HEAT_UPDATE_DELAY;
+	u64 ino = 0;
+	int i, n;
+
+	do {
+		while (1) {
+			spin_lock(&root->lock);
+			n = radix_tree_gang_lookup(&root->hot_inode_tree,
+					   (void **)hi_nodes, ino,
+					   ARRAY_SIZE(hi_nodes));
+			if (!n) {
+				spin_unlock(&root->lock);
+				break;
+			}
+
+			ino = hi_nodes[n - 1]->i_ino + 1;
+			for (i = 0; i < n; i++) {
+				kref_get(&hi_nodes[i]->hot_inode.refs);
+				hot_map_array_update(
+					&hi_nodes[i]->hot_inode.hot_freq_data, root);
+				hot_range_update(hi_nodes[i], root);
+				hot_inode_item_put(hi_nodes[i]);
+			}
+			spin_unlock(&root->lock);
+		}
+
+		if (unlikely(freezing(current))) {
+			__refrigerator(true);
+		} else {
+			set_current_state(TASK_INTERRUPTIBLE);
+			if (!kthread_should_stop()) {
+				schedule_timeout(delay);
+			}
+			__set_current_state(TASK_RUNNING);
+		}
+	} while (!kthread_should_stop());
+}
+
+static int hot_wq_init(struct hot_info *root)
+{
+	struct hot_update_work *hot_work;
+	int ret = 0;
+
+	root->update_wq = alloc_workqueue(
+		"hot_temperature_update", WQ_MEM_RECLAIM | WQ_UNBOUND, 1);
+	if (!root->update_wq) {
+		printk(KERN_ERR "%s: failed to create "
+			"temperature update workqueue\n",
+			__func__);
+		return 1;
+	}
+
+	hot_work = kmalloc(sizeof(*hot_work), GFP_NOFS);
+	if (hot_work) {
+		hot_work->hot_info = root;
+		INIT_WORK(&hot_work->work, hot_temperature_update_work);
+		queue_work(root->update_wq, &hot_work->work);
+	} else {
+		printk(KERN_ERR "%s: failed to create update work\n",
+				__func__);
+		ret = 1;
+	}
+
+	return ret;
+}
+
+static void hot_wq_exit(struct workqueue_struct *wq)
+{
+	flush_workqueue(wq);
+	destroy_workqueue(wq);
+}
+
+/*
  * Initialize kmem cache for hot_inode_item and hot_range_item.
  */
 static int __init hot_cache_init(void)
@@ -686,10 +770,19 @@ void hot_track_init(struct super_block *sb)
 	hot_inode_tree_init(root);
 	hot_map_array_init(root);
 
+	err = hot_wq_init(root);
+	if (err)
+		goto failed_wq;
+
 	printk(KERN_INFO "vfs: turning on hot data tracking\n");
 
 	return;
 
+failed_wq:
+	hot_map_array_exit(root);
+	hot_inode_tree_exit(root);
+	sb->hot_flags &= ~MS_HOT_TRACKING;
+	kfree(root);
 failed_root:
 	hot_cache_exit();
 }
@@ -698,6 +791,7 @@ void hot_track_exit(struct super_block *sb)
 {
 	struct hot_info *root = global_hot_tracking_info;
 
+	hot_wq_exit(root->update_wq);
 	hot_map_array_exit(root);
 	hot_inode_tree_exit(root);
 	sb->hot_flags &= ~MS_HOT_TRACKING;
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index d19e64a..7a79a6d 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -36,6 +36,9 @@
  */
 #define TIME_TO_KICK 400
 
+/* set how often to update temperatures (seconds) */
+#define HEAT_UPDATE_DELAY 400
+
 /*
  * The following comments explain what exactly comprises a unit of heat.
  *
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index 7114179..b37e0f8 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -84,6 +84,8 @@ struct hot_info {
 
 	/* map of range temperature */
 	struct hot_map_head heat_range_map[HEAT_MAP_SIZE];
+
+	struct workqueue_struct *update_wq;
 };
 
 extern struct hot_info *global_hot_tracking_info;
-- 
1.7.6.5

