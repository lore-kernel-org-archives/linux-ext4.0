From: zwu.kernel@gmail.com
Subject: [RFC v3 10/13] vfs: register one memory shrinker
Date: Wed, 10 Oct 2012 18:07:32 +0800
Message-ID: <1349863655-29320-11-git-send-email-zwu.kernel@gmail.com>
References: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, dave@jikos.cz,
	tytso@mit.edu, cmm@us.ibm.com,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Register a shrinker to control the amount of
memory that is used in tracking hot regions - if we are throwing
inodes out of memory due to memory pressure, we most definitely are
going to need to reduce the amount of memory the tracking code is
using, even if it means losing useful information (i.e. the shrinker
accelerates the aging process).

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            |   59 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/hot_tracking.h |    1 +
 2 files changed, 60 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index f333c47..fcde55e 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -742,6 +742,59 @@ static inline void hot_cache_exit(void)
 		kmem_cache_destroy(hot_inode_item_cachep);
 }
 
+static int hot_track_comm_prune(struct hot_map_head *map_head,
+				bool type, unsigned long nr)
+{
+	struct list_head *pos, *next;
+	struct hot_comm_item *node;
+	int i;
+
+	for (i = 0; i < HEAT_MAP_SIZE; i++) {
+		list_for_each_safe(pos, next, &(map_head + i)->node_list) {
+			if (nr == 0)
+				break;
+			nr--;
+			node = list_entry(pos, struct hot_comm_item, n_list);
+			if (type) {
+				struct hot_inode_item *hot_inode =
+					container_of(node,
+					struct hot_inode_item, hot_inode);
+				hot_inode_item_put(hot_inode);
+			} else {
+				struct hot_range_item *hot_range =
+					container_of(node,
+					struct hot_range_item, hot_range);
+				hot_range_item_put(hot_range);
+			}
+		}
+
+		if (nr == 0)
+			break;
+	}
+
+	return nr;
+}
+
+/* The shrinker callback function */
+static int hot_track_prune(struct shrinker *shrink,
+			struct shrink_control *sc)
+{
+	struct hot_info *root =
+		container_of(shrink, struct hot_info, hot_shrink);
+	int ret;
+
+	if ((sc->gfp_mask & GFP_KERNEL) != GFP_KERNEL)
+		return (sc->nr_to_scan == 0) ? 0 : -1;
+
+	ret = hot_track_comm_prune(root->heat_range_map,
+				false, sc->nr_to_scan);
+	if (ret > 0)
+		ret = hot_track_comm_prune(root->heat_inode_map,
+					true, ret);
+
+	return ret;
+}
+
 /*
  * Initialize the data structures for hot data tracking.
  */
@@ -774,6 +827,11 @@ void hot_track_init(struct super_block *sb)
 	if (err)
 		goto failed_wq;
 
+	/* Register a shrinker callback */
+	root->hot_shrink.shrink = hot_track_prune;
+	root->hot_shrink.seeks = DEFAULT_SEEKS;
+	register_shrinker(&root->hot_shrink);
+
 	printk(KERN_INFO "vfs: turning on hot data tracking\n");
 
 	return;
@@ -791,6 +849,7 @@ void hot_track_exit(struct super_block *sb)
 {
 	struct hot_info *root = global_hot_tracking_info;
 
+	unregister_shrinker(&root->hot_shrink);
 	hot_wq_exit(root->update_wq);
 	hot_map_array_exit(root);
 	hot_inode_tree_exit(root);
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index b37e0f8..6f31090 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -86,6 +86,7 @@ struct hot_info {
 	struct hot_map_head heat_range_map[HEAT_MAP_SIZE];
 
 	struct workqueue_struct *update_wq;
+	struct shrinker hot_shrink;
 };
 
 extern struct hot_info *global_hot_tracking_info;
-- 
1.7.6.5
