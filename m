From: zwu.kernel@gmail.com
Subject: [RFC v3 03/13] vfs: Initialize and free main data structures
Date: Wed, 10 Oct 2012 18:07:25 +0800
Message-ID: <1349863655-29320-4-git-send-email-zwu.kernel@gmail.com>
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

  Add initialization function to create some
key data structures when hot tracking is enabled;
Clean up them when hot tracking is disabled

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/btrfs/super.c             |    8 +++
 fs/hot_tracking.c            |  118 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h           |    3 +
 include/linux/hot_tracking.h |    4 ++
 4 files changed, 133 insertions(+), 0 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 00be9e3..da4438f 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -294,6 +294,10 @@ static void btrfs_put_super(struct super_block *sb)
 	 * last process that kept it busy.  Or segfault in the aforementioned
 	 * process...  Whom would you report that to?
 	 */
+
+	/* Hot data tracking */
+	if (btrfs_test_opt(btrfs_sb(sb)->tree_root, HOT_TRACK))
+		hot_track_exit(sb);
 }
 
 enum {
@@ -828,6 +832,10 @@ static int btrfs_fill_super(struct super_block *sb,
 		goto fail_close;
 	}
 
+	if (btrfs_test_opt(fs_info->tree_root, HOT_TRACK)) {
+		hot_track_init(sb);
+	}
+
 	save_mount_options(sb, data);
 	cleancache_init_fs(sb);
 	sb->s_flags |= MS_ACTIVE;
diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 634ec03..5fd993e 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -21,6 +21,8 @@
 #include <linux/limits.h>
 #include "hot_tracking.h"
 
+struct hot_info *global_hot_tracking_info;
+
 /* kmem_cache pointers for slab caches */
 static struct kmem_cache *hot_inode_item_cachep;
 static struct kmem_cache *hot_range_item_cachep;
@@ -81,6 +83,97 @@ static void hot_inode_item_init(struct hot_inode_item *he, u64 ino,
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
+ * and free the structure
+ * if the reference count hits zero
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
+ * and free the structure
+ * if the reference count hits zero
+ */
+void hot_inode_item_put(struct hot_inode_item *he)
+{
+	kref_put(&he->hot_inode.refs, hot_inode_item_free);
+}
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
@@ -122,6 +215,7 @@ static inline void hot_cache_exit(void)
  */
 void hot_track_init(struct super_block *sb)
 {
+	struct hot_info *root;
 	int err;
 
 	err = hot_cache_init();
@@ -130,9 +224,33 @@ void hot_track_init(struct super_block *sb)
 				__func__, err);
 		return;
 	}
+
+	root = kmalloc(sizeof(struct hot_info), GFP_NOFS);
+	if (!root) {
+		printk(KERN_ERR "%s: failed to malloc memory for "
+				"global_hot_tracking_info: %d\n",
+				__func__, err);
+		goto failed_root;
+	}
+
+	global_hot_tracking_info = root;
+	sb->hot_flags |= MS_HOT_TRACKING;
+	hot_inode_tree_init(root);
+
+	printk(KERN_INFO "vfs: turning on hot data tracking\n");
+
+	return;
+
+failed_root:
+	hot_cache_exit();
 }
 
 void hot_track_exit(struct super_block *sb)
 {
+	struct hot_info *root = global_hot_tracking_info;
+
+	hot_inode_tree_exit(root);
+	sb->hot_flags &= ~MS_HOT_TRACKING;
 	hot_cache_exit();
+	kfree(root);
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c617ed0..3b1a389 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1582,6 +1582,9 @@ struct super_block {
 
 	/* Being remounted read-only */
 	int s_readonly_remount;
+
+	/* Hot data tracking*/
+	unsigned long hot_flags;
 };
 
 /* superblock cache pruning functions */
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index 78adb0d..13aa54b 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -20,6 +20,8 @@
 #include <linux/kref.h>
 #include <linux/fs.h>
 
+#define MS_HOT_TRACKING	(1<<0)
+
 /*
  * A frequency data struct holds values that are used to
  * determine temperature of files and file ranges. These structs
@@ -68,6 +70,8 @@ struct hot_info {
 	spinlock_t lock; /*protect inode tree */
 };
 
+extern struct hot_info *global_hot_tracking_info;
+
 extern void hot_track_init(struct super_block *sb);
 extern void hot_track_exit(struct super_block *sb);
 
-- 
1.7.6.5
