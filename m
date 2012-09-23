From: zwu.kernel@gmail.com
Subject: [RFC v2 05/10] vfs: introduce one hash table
Date: Sun, 23 Sep 2012 20:56:30 +0800
Message-ID: <1348404995-14372-6-git-send-email-zwu.kernel@gmail.com>
References: <1348404995-14372-1-git-send-email-zwu.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, cmm@us.ibm.com, tytso@mit.edu,
	marco.stornelli@gmail.com, david@fromorbit.com,
	stroetmann@ontolinux.com, diegocg@gmail.com, chris@csamuel.org,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1348404995-14372-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Adds a hash table structure which contains
a lot of hash list and is used to efficiently
look up the data temperature of a file or its
ranges.
  In each hash list of hash table, the hash node
will keep track of temperature info.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            |   77 ++++++++++++++++++++++++++++++++++++++++-
 include/linux/hot_tracking.h |   35 +++++++++++++++++++
 2 files changed, 110 insertions(+), 2 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index fa89f70..5f96442 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <linux/hardirq.h>
+#include <linux/hash.h>
 #include <linux/fs.h>
 #include <linux/blkdev.h>
 #include <linux/types.h>
@@ -24,6 +25,9 @@
 /* kmem_cache pointers for slab caches */
 static struct kmem_cache *hot_inode_item_cache;
 static struct kmem_cache *hot_range_item_cache;
+static struct kmem_cache *hot_hash_node_cache;
+
+static void hot_hash_node_init(void *_node);
 
 /*
  * Initialize the inode tree. Should be called for each new inode
@@ -57,6 +61,10 @@ void hot_rb_inode_item_init(void *_item)
 	memset(he, 0, sizeof(*he));
 	kref_init(&he->refs);
 	spin_lock_init(&he->lock);
+	he->heat_node = kmem_cache_alloc(hot_hash_node_cache,
+					GFP_KERNEL | GFP_NOFS);
+	hot_hash_node_init(he->heat_node);
+	he->heat_node->hot_freq_data = &he->hot_freq_data;
 	he->hot_freq_data.avg_delta_reads = (u64) -1;
 	he->hot_freq_data.avg_delta_writes = (u64) -1;
 	he->hot_freq_data.flags = FREQ_DATA_TYPE_INODE;
@@ -75,6 +83,10 @@ static void hot_rb_range_item_init(void *_item)
 	memset(hr, 0, sizeof(*hr));
 	kref_init(&hr->refs);
 	spin_lock_init(&hr->lock);
+	hr->heat_node = kmem_cache_alloc(hot_hash_node_cache,
+				GFP_KERNEL | GFP_NOFS);
+	hot_hash_node_init(hr->heat_node);
+	hr->heat_node->hot_freq_data = &hr->hot_freq_data;
 	hr->hot_freq_data.avg_delta_reads = (u64) -1;
 	hr->hot_freq_data.avg_delta_writes = (u64) -1;
 	hr->hot_freq_data.flags = FREQ_DATA_TYPE_RANGE;
@@ -105,6 +117,18 @@ inode_err:
 	return -ENOMEM;
 }
 
+static void hot_rb_inode_item_exit(void)
+{
+	if (hot_inode_item_cache)
+		kmem_cache_destroy(hot_inode_item_cache);
+}
+
+static void hot_rb_range_item_exit(void)
+{
+	if (hot_range_item_cache)
+		kmem_cache_destroy(hot_range_item_cache);
+}
+
 /*
  * Drops the reference out on hot_inode_item by one and free the structure
  * if the reference count hits zero
@@ -510,6 +534,48 @@ void hot_rb_update_freqs(struct inode *inode, u64 start,
 }
 
 /*
+ * Initialize hash node.
+ */
+static void hot_hash_node_init(void *_node)
+{
+	struct hot_hash_node *node = _node;
+
+	memset(node, 0, sizeof(*node));
+	INIT_HLIST_NODE(&node->hashnode);
+	node->hot_freq_data = NULL;
+	node->hlist = NULL;
+	spin_lock_init(&node->lock);
+	kref_init(&node->refs);
+}
+
+static int __init hot_hash_node_cache_init(void)
+{
+	hot_hash_node_cache = kmem_cache_create("hot_hash_node",
+				sizeof(struct hot_hash_node),
+				0,
+				SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
+				hot_hash_node_init);
+	if (!hot_hash_node_cache)
+		return -ENOMEM;
+
+	return 0;
+}
+
+/*
+ * Initialize inode/range hash lists.
+ */
+static void hot_hash_table_init(struct hot_info *root)
+{
+	int i;
+	for (i = 0; i < HEAT_HASH_SIZE; i++) {
+		root->heat_inode_hl[i].temperature = i;
+		root->heat_range_hl[i].temperature = i;
+		rwlock_init(&root->heat_inode_hl[i].rwlock);
+		rwlock_init(&root->heat_range_hl[i].rwlock);
+	}
+}
+
+/*
  * Regular mount options parser for -hottrack option.
  * return false if no -hottrack is specified;
  * otherwise return true. And the -hottrack will be
@@ -544,13 +610,18 @@ bool hot_track_parse_options(char *options)
 }
 
 /*
- * Initialize kmem cache for hot_inode_item
- * and hot_range_item
+ * Initialize kmem cache for hot_inode_item,
+ * hot_range_item and hot_hash_node
  */
 void __init hot_track_cache_init(void)
 {
 	if (hot_rb_item_cache_init())
 		return;
+
+	if (hot_hash_node_cache_init()) {
+		hot_rb_inode_item_exit();
+		hot_rb_range_item_exit();
+	}
 }
 
 /*
@@ -560,10 +631,12 @@ void hot_track_init(struct super_block *sb, const char *name)
 {
 	sb->s_hotinfo.mount_opt |= HOT_MOUNT_HOT_TRACK;
 	hot_rb_inode_tree_init(&sb->s_hotinfo.hot_inode_tree);
+	hot_hash_table_init(&sb->s_hotinfo);
 }
 
 void hot_track_exit(struct super_block *sb)
 {
 	sb->s_hotinfo.mount_opt &= ~HOT_MOUNT_HOT_TRACK;
+	hot_hash_table_free(&sb->s_hotinfo);
 	hot_rb_inode_tree_free(&sb->s_hotinfo);
 }
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index bb2a41c..635ffb6 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -20,6 +20,9 @@
 #include <linux/rbtree.h>
 #include <linux/kref.h>
 
+#define HEAT_HASH_BITS 8
+#define HEAT_HASH_SIZE (1 << HEAT_HASH_BITS)
+
 /*
  * Flags for hot data tracking mount options.
  */
@@ -52,6 +55,28 @@ struct hot_freq_data {
 	u32 last_temperature;
 };
 
+/* Hash list heads for hot hash table */
+struct hot_hash_head {
+	struct hlist_head hashhead;
+	rwlock_t rwlock;
+	u32 temperature;
+};
+
+/* Nodes stored in each hash list of hash table */
+struct hot_hash_node {
+	struct hlist_node hashnode;
+	struct list_head node;
+	struct hot_freq_data *hot_freq_data;
+	struct hot_hash_head *hlist;
+	spinlock_t lock; /* protects hlist */
+
+	/*
+	 * number of references to this node
+	 * equals 1 (hashlist entry)
+	 */
+	struct kref refs;
+};
+
 /* An item representing an inode and its access frequency */
 struct hot_inode_item {
 	/* node for hot_inode_tree rb_tree */
@@ -68,6 +93,8 @@ struct hot_inode_item {
 	spinlock_t lock;
 	/* prevents kfree */
 	struct kref refs;
+	/* hashlist node for this inode */
+	struct hot_hash_node *heat_node;
 };
 
 /*
@@ -91,6 +118,8 @@ struct hot_range_item {
 	spinlock_t lock;
 	/* prevents kfree */
 	struct kref refs;
+	/* hashlist node for this range */
+	struct hot_hash_node *heat_node;
 };
 
 struct hot_info {
@@ -98,6 +127,12 @@ struct hot_info {
 
 	/* red-black tree that keeps track of fs-wide hot data */
 	struct hot_inode_tree hot_inode_tree;
+
+	/* hash map of inode temperature */
+	struct hot_hash_head heat_inode_hl[HEAT_HASH_SIZE];
+
+	/* hash map of range temperature */
+	struct hot_hash_head heat_range_hl[HEAT_HASH_SIZE];
 };
 
 #endif  /* _LINUX_HOTTRACK_H */
-- 
1.7.6.5

