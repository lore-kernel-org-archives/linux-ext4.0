From: zwu.kernel@gmail.com
Subject: [RFC v4+ hot_track 04/19] vfs: add two map arrays
Date: Mon, 29 Oct 2012 12:30:46 +0800
Message-ID: <1351485061-12297-5-git-send-email-zwu.kernel@gmail.com>
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

  Adds two map arrays which contains
a lot of list and is used to efficiently
look up the data temperature of a file or its
ranges.
  In each list of map arrays, the array node
will keep track of temperature info.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            |   60 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/hot_tracking.h |   16 +++++++++++
 2 files changed, 76 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 0a7d9a3..0a603a1 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -58,6 +58,7 @@ static void hot_range_item_init(struct hot_range_item *hr, u32 start,
 	hr->hot_inode = he;
 	kref_init(&hr->hot_range.refs);
 	spin_lock_init(&hr->hot_range.lock);
+	INIT_LIST_HEAD(&hr->hot_range.n_list);
 	hr->hot_range.hot_freq_data.avg_delta_reads = (u64) -1;
 	hr->hot_range.hot_freq_data.avg_delta_writes = (u64) -1;
 	hr->hot_range.hot_freq_data.flags = FREQ_DATA_TYPE_RANGE;
@@ -88,6 +89,16 @@ static void hot_range_item_free(struct kref *kref)
 		struct hot_comm_item, refs);
 	struct hot_range_item *hr = container_of(comm_item,
 		struct hot_range_item, hot_range);
+	struct hot_info *root = container_of(
+			hr->hot_inode->hot_inode_tree,
+		struct hot_info, hot_inode_tree);
+
+	spin_lock(&hr->hot_range.lock);
+	if (!list_empty(&hr->hot_range.n_list)) {
+		list_del_init(&hr->hot_range.n_list);
+		root->hot_map_nr--;
+	}
+	spin_unlock(&hr->hot_range.lock);
 
 	radix_tree_delete(&hr->hot_inode->hot_range_tree, hr->start);
 	kmem_cache_free(hot_range_item_cachep, hr);
@@ -132,6 +143,15 @@ static void hot_inode_item_free(struct kref *kref)
 			struct hot_comm_item, refs);
 	struct hot_inode_item *he = container_of(comm_item,
 			struct hot_inode_item, hot_inode);
+	struct hot_info *root = container_of(he->hot_inode_tree,
+		struct hot_info, hot_inode_tree);
+
+	spin_lock(&he->hot_inode.lock);
+	if (!list_empty(&he->hot_inode.n_list)) {
+		list_del_init(&he->hot_inode.n_list);
+		root->hot_map_nr--;
+	}
+	spin_unlock(&he->hot_inode.lock);
 
 	hot_range_tree_free(he);
 	radix_tree_delete(he->hot_inode_tree, he->i_ino);
@@ -304,6 +324,44 @@ static void hot_freq_data_update(struct hot_freq_data *freq_data, bool write)
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
+		root->heat_inode_map[i].temp = i;
+		root->heat_range_map[i].temp = i;
+	}
+}
+
+static void hot_map_list_free(struct list_head *node_list,
+				struct hot_info *root)
+{
+	struct list_head *pos, *next;
+	struct hot_comm_item *node;
+
+	list_for_each_safe(pos, next, node_list) {
+		node = list_entry(pos, struct hot_comm_item, n_list);
+		list_del_init(&node->n_list);
+		root->hot_map_nr--;
+	}
+
+}
+
+/* Free inode and range map arrays */
+static void hot_map_array_exit(struct hot_info *root)
+{
+	int i;
+	for (i = 0; i < HEAT_MAP_SIZE; i++) {
+		hot_map_list_free(&root->heat_inode_map[i].node_list, root);
+		hot_map_list_free(&root->heat_range_map[i].node_list, root);
+	}
+}
+
+/*
  * Initialize kmem cache for hot_inode_item and hot_range_item.
  */
 void __init hot_cache_init(void)
@@ -394,6 +452,7 @@ int hot_track_init(struct super_block *sb)
 
 	sb->s_hot_root = root;
 	hot_inode_tree_init(root);
+	hot_map_array_init(root);
 
 	printk(KERN_INFO "VFS: Turning on hot data tracking\n");
 
@@ -405,6 +464,7 @@ void hot_track_exit(struct super_block *sb)
 {
 	struct hot_info *root = sb->s_hot_root;
 
+	hot_map_array_exit(root);
 	hot_inode_tree_exit(root);
 	kfree(root);
 }
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index e2d6028..4f92947 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -20,6 +20,9 @@
 #include <linux/kref.h>
 #include <linux/fs.h>
 
+#define HEAT_MAP_BITS 8
+#define HEAT_MAP_SIZE (1 << HEAT_MAP_BITS)
+
 /*
  * A frequency data struct holds values that are used to
  * determine temperature of files and file ranges. These structs
@@ -36,11 +39,18 @@ struct hot_freq_data {
 	u32 last_temp;
 };
 
+/* List heads in hot map array */
+struct hot_map_head {
+	struct list_head node_list;
+	u8 temp;
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
@@ -66,6 +76,12 @@ struct hot_range_item {
 struct hot_info {
 	struct radix_tree_root hot_inode_tree;
 	spinlock_t lock; /*protect inode tree */
+
+	/* map of inode temperature */
+	struct hot_map_head heat_inode_map[HEAT_MAP_SIZE];
+	/* map of range temperature */
+	struct hot_map_head heat_range_map[HEAT_MAP_SIZE];
+	unsigned int hot_map_nr;
 };
 
 extern void __init hot_cache_init(void);
-- 
1.7.6.5
