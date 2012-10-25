From: zwu.kernel@gmail.com
Subject: [RFC v4 09/15] vfs,hot_track: register one memory shrinker
Date: Thu, 25 Oct 2012 23:09:01 +0800
Message-ID: <1351177747-19389-10-git-send-email-zwu.kernel@gmail.com>
References: <1351177747-19389-1-git-send-email-zwu.kernel@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, tytso@mit.edu,
	cmm@us.ibm.com, Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1351177747-19389-1-git-send-email-zwu.kernel@gmail.com>
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
 fs/hot_tracking.c            |   61 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/hot_tracking.h |    1 +
 2 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index d931083..7d2c53d 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -678,6 +678,61 @@ err:
 	kmem_cache_destroy(hot_inode_item_cachep);
 }
 
+static int hot_track_prune_map(struct hot_map_head *map_head,
+				bool type, int nr)
+{
+	struct hot_comm_item *node;
+	int i;
+
+	for (i = 0; i < HEAT_MAP_SIZE; i++) {
+		while (!list_empty(&(map_head + i)->node_list)) {
+			if (nr-- <= 0)
+				break;
+
+			node = list_first_entry(&(map_head + i)->node_list,
+					struct hot_comm_item, n_list);
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
+	if (sc->nr_to_scan == 0)
+		return root->hot_map_nr;
+
+	if (!(sc->gfp_mask & __GFP_FS))
+		return -1;
+
+	ret = hot_track_prune_map(root->heat_range_map,
+				false, sc->nr_to_scan);
+	if (ret > 0)
+		ret = hot_track_prune_map(root->heat_inode_map,
+					true, ret);
+	if (ret > 0)
+		root->hot_map_nr -= (sc->nr_to_scan - ret);
+
+	return root->hot_map_nr;
+}
+
 /*
  * Main function to update access frequency from read/writepage(s) hooks
  */
@@ -758,6 +813,11 @@ int hot_track_init(struct super_block *sb)
 	queue_delayed_work(root->update_wq, &root->update_work,
 		msecs_to_jiffies(HEAT_UPDATE_DELAY * MSEC_PER_SEC));
 
+	/* Register a shrinker callback */
+	root->hot_shrink.shrink = hot_track_prune;
+	root->hot_shrink.seeks = DEFAULT_SEEKS;
+	register_shrinker(&root->hot_shrink);
+
 	printk(KERN_INFO "VFS: Turning on hot data tracking\n");
 
 	return 0;
@@ -774,6 +834,7 @@ void hot_track_exit(struct super_block *sb)
 {
 	struct hot_info *root = sb->s_hot_root;
 
+	unregister_shrinker(&root->hot_shrink);
 	cancel_delayed_work_sync(&root->update_work);
 	destroy_workqueue(root->update_wq);
 	hot_map_array_exit(root);
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index 4c5f5f3..446c99e 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -85,6 +85,7 @@ struct hot_info {
 
 	struct workqueue_struct *update_wq;
 	struct delayed_work update_work;
+	struct shrinker hot_shrink;
 };
 
 void __init hot_cache_init(void);
-- 
1.7.6.5
