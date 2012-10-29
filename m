From: zwu.kernel@gmail.com
Subject: [RFC v4+ hot_track 02/19] vfs: initialize and free data structures
Date: Mon, 29 Oct 2012 12:30:44 +0800
Message-ID: <1351485061-12297-3-git-send-email-zwu.kernel@gmail.com>
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

  Add initialization function to create some
key data structures when hot tracking is enabled;
Clean up them when hot tracking is disabled

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            |  124 ++++++++++++++++++++++++++++++++++++++++++
 fs/hot_tracking.h            |    2 +
 include/linux/fs.h           |    4 ++
 include/linux/hot_tracking.h |    2 +
 4 files changed, 132 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index badf47d..68591f0 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -75,12 +75,103 @@ static void hot_inode_item_init(struct hot_inode_item *he, u64 ino,
 	he->hot_inode_tree = hot_inode_tree;
 	kref_init(&he->hot_inode.refs);
 	spin_lock_init(&he->hot_inode.lock);
+	INIT_LIST_HEAD(&he->hot_inode.n_list);
 	he->hot_inode.hot_freq_data.avg_delta_reads = (u64) -1;
 	he->hot_inode.hot_freq_data.avg_delta_writes = (u64) -1;
 	he->hot_inode.hot_freq_data.flags = FREQ_DATA_TYPE_INODE;
 	hot_range_tree_init(he);
 }
 
+static void hot_range_item_free(struct kref *kref)
+{
+	struct hot_comm_item *comm_item = container_of(kref,
+		struct hot_comm_item, refs);
+	struct hot_range_item *hr = container_of(comm_item,
+		struct hot_range_item, hot_range);
+
+	radix_tree_delete(&hr->hot_inode->hot_range_tree, hr->start);
+	kmem_cache_free(hot_range_item_cachep, hr);
+}
+
+/*
+ * Drops the reference out on hot_range_item by one
+ * and free the structure if the reference count hits zero
+ */
+static void hot_range_item_put(struct hot_range_item *hr)
+{
+	kref_put(&hr->hot_range.refs, hot_range_item_free);
+}
+
+/* Frees the entire hot_range_tree. */
+static void hot_range_tree_free(struct hot_inode_item *he)
+{
+	struct hot_range_item *hr_nodes[8];
+	u32 start = 0;
+	int i, n;
+
+	while (1) {
+		spin_lock(&he->lock);
+		n = radix_tree_gang_lookup(&he->hot_range_tree,
+					(void **)hr_nodes, start,
+					ARRAY_SIZE(hr_nodes));
+		if (!n) {
+			spin_unlock(&he->lock);
+			break;
+		}
+
+		start = hr_nodes[n - 1]->start + 1;
+		for (i = 0; i < n; i++)
+			hot_range_item_put(hr_nodes[i]);
+		spin_unlock(&he->lock);
+	}
+}
+
+static void hot_inode_item_free(struct kref *kref)
+{
+	struct hot_comm_item *comm_item = container_of(kref,
+			struct hot_comm_item, refs);
+	struct hot_inode_item *he = container_of(comm_item,
+			struct hot_inode_item, hot_inode);
+
+	hot_range_tree_free(he);
+	radix_tree_delete(he->hot_inode_tree, he->i_ino);
+	kmem_cache_free(hot_inode_item_cachep, he);
+}
+
+/*
+ * Drops the reference out on hot_inode_item by one
+ * and free the structure if the reference count hits zero
+ */
+void hot_inode_item_put(struct hot_inode_item *he)
+{
+	kref_put(&he->hot_inode.refs, hot_inode_item_free);
+}
+EXPORT_SYMBOL_GPL(hot_inode_item_put);
+
+/* Frees the entire hot_inode_tree. */
+static void hot_inode_tree_exit(struct hot_info *root)
+{
+	struct hot_inode_item *hi_nodes[8];
+	u64 ino = 0;
+	int i, n;
+
+	while (1) {
+		spin_lock(&root->lock);
+		n = radix_tree_gang_lookup(&root->hot_inode_tree,
+					   (void **)hi_nodes, ino,
+					   ARRAY_SIZE(hi_nodes));
+		if (!n) {
+			spin_unlock(&root->lock);
+			break;
+		}
+
+		ino = hi_nodes[n - 1]->i_ino + 1;
+		for (i = 0; i < n; i++)
+			hot_inode_item_put(hi_nodes[i]);
+		spin_unlock(&root->lock);
+	}
+}
+
 /*
  * Initialize kmem cache for hot_inode_item and hot_range_item.
  */
@@ -106,3 +197,36 @@ err:
 	kmem_cache_destroy(hot_inode_item_cachep);
 }
 EXPORT_SYMBOL_GPL(hot_cache_init);
+
+/*
+ * Initialize the data structures for hot data tracking.
+ */
+int hot_track_init(struct super_block *sb)
+{
+	struct hot_info *root;
+	int ret = -ENOMEM;
+
+	root = kzalloc(sizeof(struct hot_info), GFP_NOFS);
+	if (!root) {
+		printk(KERN_ERR "%s: Failed to malloc memory for "
+				"hot_info\n", __func__);
+		return ret;
+	}
+
+	sb->s_hot_root = root;
+	hot_inode_tree_init(root);
+
+	printk(KERN_INFO "VFS: Turning on hot data tracking\n");
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(hot_track_init);
+
+void hot_track_exit(struct super_block *sb)
+{
+	struct hot_info *root = sb->s_hot_root;
+
+	hot_inode_tree_exit(root);
+	kfree(root);
+}
+EXPORT_SYMBOL_GPL(hot_track_exit);
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index febf699..e7ba121 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -20,4 +20,6 @@
 #define FREQ_DATA_TYPE_INODE (1 << 0)
 #define FREQ_DATA_TYPE_RANGE (1 << 1)
 
+void hot_inode_item_put(struct hot_inode_item *he);
+
 #endif /* __HOT_TRACKING__ */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b33cfc9..c541ae7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -27,6 +27,7 @@
 #include <linux/lockdep.h>
 #include <linux/percpu-rwsem.h>
 #include <linux/blk_types.h>
+#include <linux/hot_tracking.h>
 
 #include <asm/byteorder.h>
 #include <uapi/linux/fs.h>
@@ -1321,6 +1322,9 @@ struct super_block {
 
 	/* Being remounted read-only */
 	int s_readonly_remount;
+
+	/* Hot data tracking*/
+	struct hot_info *s_hot_root;
 };
 
 /* superblock cache pruning functions */
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index 1cec0aa..4233207 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -69,5 +69,7 @@ struct hot_info {
 };
 
 extern void __init hot_cache_init(void);
+extern int hot_track_init(struct super_block *sb);
+extern void hot_track_exit(struct super_block *sb);
 
 #endif  /* _LINUX_HOTTRACK_H */
-- 
1.7.6.5
