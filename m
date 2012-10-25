From: zwu.kernel@gmail.com
Subject: [RFC v4 08/15] vfs,hot_track: add one work queue
Date: Thu, 25 Oct 2012 23:09:00 +0800
Message-ID: <1351177747-19389-9-git-send-email-zwu.kernel@gmail.com>
References: <1351177747-19389-1-git-send-email-zwu.kernel@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, tytso@mit.edu,
	cmm@us.ibm.com, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:39961 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935697Ab2JYPSO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Oct 2012 11:18:14 -0400
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Thu, 25 Oct 2012 09:18:13 -0600
In-Reply-To: <1351177747-19389-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Add a per-superblock workqueue and a work_struct
to run periodic work to update map info on each superblock.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            |   85 ++++++++++++++++++++++++++++++++++++++++++
 fs/hot_tracking.h            |    3 +
 include/linux/hot_tracking.h |    3 +
 3 files changed, 91 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 575cd3a..d931083 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -15,9 +15,12 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/hardirq.h>
+#include <linux/kthread.h>
+#include <linux/freezer.h>
 #include <linux/fs.h>
 #include <linux/blkdev.h>
 #include <linux/types.h>
+#include <linux/list_sort.h>
 #include <linux/limits.h>
 #include "hot_tracking.h"
 
@@ -589,6 +592,67 @@ static void hot_map_array_exit(struct hot_info *root)
 	}
 }
 
+/* Temperature compare function*/
+static int hot_temp_cmp(void *priv, struct list_head *a,
+				struct list_head *b)
+{
+	struct hot_comm_item *ap =
+			container_of(a, struct hot_comm_item, n_list);
+	struct hot_comm_item *bp =
+			container_of(b, struct hot_comm_item, n_list);
+
+	int diff = ap->hot_freq_data.last_temp
+				- bp->hot_freq_data.last_temp;
+	if (diff > 0)
+		return -1;
+	if (diff < 0)
+		return 1;
+	return 0;
+}
+
+/*
+ * Every sync period we update temperatures for
+ * each hot inode item and hot range item for aging
+ * purposes.
+ */
+static void hot_update_worker(struct work_struct *work)
+{
+	struct hot_info *root = container_of(to_delayed_work(work),
+					struct hot_info, update_work);
+	struct hot_inode_item *hi_nodes[8];
+	u64 ino = 0;
+	int i, n;
+
+	while (1) {
+		n = radix_tree_gang_lookup(&root->hot_inode_tree,
+				   (void **)hi_nodes, ino,
+				   ARRAY_SIZE(hi_nodes));
+		if (!n)
+			break;
+
+		ino = hi_nodes[n - 1]->i_ino + 1;
+		for (i = 0; i < n; i++) {
+			kref_get(&hi_nodes[i]->hot_inode.refs);
+			hot_map_array_update(
+				&hi_nodes[i]->hot_inode.hot_freq_data, root);
+			hot_range_update(hi_nodes[i], root);
+			hot_inode_item_put(hi_nodes[i]);
+		}
+	}
+
+	/* Sort temperature map info */
+	for (i = 0; i < HEAT_MAP_SIZE; i++) {
+		list_sort(NULL, &root->heat_inode_map[i].node_list,
+			hot_temp_cmp);
+		list_sort(NULL, &root->heat_range_map[i].node_list,
+			hot_temp_cmp);
+	}
+
+	/* Instert next delayed work */
+	queue_delayed_work(root->update_wq, &root->update_work,
+		msecs_to_jiffies(HEAT_UPDATE_DELAY * MSEC_PER_SEC));
+}
+
 /*
  * Initialize kmem cache for hot_inode_item and hot_range_item.
  */
@@ -681,9 +745,28 @@ int hot_track_init(struct super_block *sb)
 	hot_inode_tree_init(root);
 	hot_map_array_init(root);
 
+	root->update_wq = alloc_workqueue(
+		"hot_update_wq", WQ_NON_REENTRANT, 0);
+	if (!root->update_wq) {
+		printk(KERN_ERR "%s: Failed to create "
+				"hot update workqueue\n", __func__);
+		goto failed_wq;
+	}
+
+	/* Initialize hot tracking wq and arm one delayed work */
+	INIT_DELAYED_WORK(&root->update_work, hot_update_worker);
+	queue_delayed_work(root->update_wq, &root->update_work,
+		msecs_to_jiffies(HEAT_UPDATE_DELAY * MSEC_PER_SEC));
+
 	printk(KERN_INFO "VFS: Turning on hot data tracking\n");
 
 	return 0;
+
+failed_wq:
+	hot_map_array_exit(root);
+	hot_inode_tree_exit(root);
+	kfree(root);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(hot_track_init);
 
@@ -691,6 +774,8 @@ void hot_track_exit(struct super_block *sb)
 {
 	struct hot_info *root = sb->s_hot_root;
 
+	cancel_delayed_work_sync(&root->update_work);
+	destroy_workqueue(root->update_wq);
 	hot_map_array_exit(root);
 	hot_inode_tree_exit(root);
 	kfree(root);
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index 67c6fb6..b9d9717 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -31,6 +31,9 @@
  */
 #define TIME_TO_KICK 300
 
+/* set how often to update temperatures (seconds) */
+#define HEAT_UPDATE_DELAY 300
+
 /*
  * The following comments explain what exactly comprises a unit of heat.
  *
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index 0ce2ef8..4c5f5f3 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -82,6 +82,9 @@ struct hot_info {
 	/* map of range temperature */
 	struct hot_map_head heat_range_map[HEAT_MAP_SIZE];
 	unsigned int hot_map_nr;
+
+	struct workqueue_struct *update_wq;
+	struct delayed_work update_work;
 };
 
 void __init hot_cache_init(void);
-- 
1.7.6.5

