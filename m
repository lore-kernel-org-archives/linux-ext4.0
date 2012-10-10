From: zwu.kernel@gmail.com
Subject: [RFC v3 05/13] vfs: add two map arrays
Date: Wed, 10 Oct 2012 18:07:27 +0800
Message-ID: <1349863655-29320-6-git-send-email-zwu.kernel@gmail.com>
References: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, david@fromorbit.com, dave@jikos.cz,
	tytso@mit.edu, cmm@us.ibm.com,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1349863655-29320-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Adds two map arrays which contains
a lot of list and is used to efficiently
look up the data temperature of a file or its
ranges.
  In each list of map arrays, the array node
will keep track of temperature info.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            |   50 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/hot_tracking.h |   16 +++++++++++++
 2 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 86c87c7..08c42c5 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -60,6 +60,7 @@ static void hot_range_item_init(struct hot_range_item *hr, u32 start,
 	hr->hot_inode = he;
 	kref_init(&hr->hot_range.refs);
 	spin_lock_init(&hr->hot_range.lock);
+	INIT_LIST_HEAD(&hr->hot_range.n_list);
 	hr->hot_range.hot_freq_data.avg_delta_reads = (u64) -1;
 	hr->hot_range.hot_freq_data.avg_delta_writes = (u64) -1;
 	hr->hot_range.hot_freq_data.flags = FREQ_DATA_TYPE_RANGE;
@@ -77,6 +78,7 @@ static void hot_inode_item_init(struct hot_inode_item *he, u64 ino,
 	he->hot_inode_tree = hot_inode_tree;
 	kref_init(&he->hot_inode.refs);
 	spin_lock_init(&he->hot_inode.lock);
+	INIT_LIST_HEAD(&he->hot_inode.n_list);
 	he->hot_inode.hot_freq_data.avg_delta_reads = (u64) -1;
 	he->hot_inode.hot_freq_data.avg_delta_writes = (u64) -1;
 	he->hot_inode.hot_freq_data.flags = FREQ_DATA_TYPE_INODE;
@@ -90,6 +92,11 @@ static void hot_range_item_free(struct kref *kref)
 	struct hot_range_item *hr = container_of(comm_item,
 		struct hot_range_item, hot_range);
 
+	spin_lock(&hr->hot_range.lock);
+	if (!list_empty(&hr->hot_range.n_list))
+		list_del_init(&hr->hot_range.n_list);
+	spin_unlock(&hr->hot_range.lock);
+
 	radix_tree_delete(&hr->hot_inode->hot_range_tree, hr->start);
 	kmem_cache_free(hot_range_item_cachep, hr);
 }
@@ -135,6 +142,11 @@ static void hot_inode_item_free(struct kref *kref)
 	struct hot_inode_item *he = container_of(comm_item,
 			struct hot_inode_item, hot_inode);
 
+	spin_lock(&he->hot_inode.lock);
+	if (!list_empty(&he->hot_inode.n_list))
+		list_del_init(&he->hot_inode.n_list);
+	spin_unlock(&he->hot_inode.lock);
+
 	hot_range_tree_free(he);
 	radix_tree_delete(he->hot_inode_tree, he->i_ino);
 	kmem_cache_free(hot_inode_item_cachep, he);
@@ -365,6 +377,42 @@ inline void hot_update_freqs(struct hot_info *root,
 }
 
 /*
+ * Initialize inode and range map arrays.
+ */
+static void hot_map_array_init(struct hot_info *root)
+{
+	int i;
+	for (i = 0; i < HEAT_MAP_SIZE; i++) {
+		INIT_LIST_HEAD(&root->heat_inode_map[i].node_list);
+		INIT_LIST_HEAD(&root->heat_range_map[i].node_list);
+		root->heat_inode_map[i].temperature = i;
+		root->heat_range_map[i].temperature = i;
+	}
+}
+
+static void hot_map_list_free(struct list_head *node_list)
+{
+	struct list_head *pos, *next;
+	struct hot_comm_item *node;
+
+	list_for_each_safe(pos, next, node_list) {
+		node = list_entry(pos, struct hot_comm_item, n_list);
+		list_del_init(&node->n_list);
+	}
+
+}
+
+/* Free inode and range map arrays */
+static void hot_map_array_exit(struct hot_info *root)
+{
+	int i;
+	for (i = 0; i < HEAT_MAP_SIZE; i++) {
+		hot_map_list_free(&root->heat_inode_map[i].node_list);
+		hot_map_list_free(&root->heat_range_map[i].node_list);
+	}
+}
+
+/*
  * Initialize kmem cache for hot_inode_item and hot_range_item.
  */
 static int __init hot_cache_init(void)
@@ -426,6 +474,7 @@ void hot_track_init(struct super_block *sb)
 	global_hot_tracking_info = root;
 	sb->hot_flags |= MS_HOT_TRACKING;
 	hot_inode_tree_init(root);
+	hot_map_array_init(root);
 
 	printk(KERN_INFO "vfs: turning on hot data tracking\n");
 
@@ -439,6 +488,7 @@ void hot_track_exit(struct super_block *sb)
 {
 	struct hot_info *root = global_hot_tracking_info;
 
+	hot_map_array_exit(root);
 	hot_inode_tree_exit(root);
 	sb->hot_flags &= ~MS_HOT_TRACKING;
 	hot_cache_exit();
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index 1e0aed5..7114179 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -22,6 +22,9 @@
 
 #define MS_HOT_TRACKING	(1<<0)
 
+#define HEAT_MAP_BITS 8
+#define HEAT_MAP_SIZE (1 << HEAT_MAP_BITS)
+
 /*
  * A frequency data struct holds values that are used to
  * determine temperature of files and file ranges. These structs
@@ -38,11 +41,18 @@ struct hot_freq_data {
 	u32 last_temperature;
 };
 
+/* List heads in hot map array */
+struct hot_map_head {
+	struct list_head node_list;
+	u32 temperature;
+};
+
 /* The common info for both following structures */
 struct hot_comm_item {
 	struct hot_freq_data hot_freq_data;  /* frequency data */
 	spinlock_t lock; /* protects object data */
 	struct kref refs;  /* prevents kfree */
+	struct list_head n_list; /* list node index */
 };
 
 /* An item representing an inode and its access frequency */
@@ -68,6 +78,12 @@ struct hot_range_item {
 struct hot_info {
 	struct radix_tree_root hot_inode_tree;
 	spinlock_t lock; /*protect inode tree */
+
+	/* map of inode temperature */
+	struct hot_map_head heat_inode_map[HEAT_MAP_SIZE];
+
+	/* map of range temperature */
+	struct hot_map_head heat_range_map[HEAT_MAP_SIZE];
 };
 
 extern struct hot_info *global_hot_tracking_info;
-- 
1.7.6.5

