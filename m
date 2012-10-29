From: zwu.kernel@gmail.com
Subject: [RFC v4+ hot_track 14/19] vfs: add debugfs support
Date: Mon, 29 Oct 2012 12:30:56 +0800
Message-ID: <1351485061-12297-15-git-send-email-zwu.kernel@gmail.com>
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

  Add a /sys/kernel/debug/hot_track/<device_name>/ directory for each
volume that contains two files. The first, `inode_stats', contains the
heat information for inodes that have been brought into the hot data map
structures. The second, `range_stats', contains similar information for
subfile ranges.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            |  484 ++++++++++++++++++++++++++++++++++++++++++
 fs/hot_tracking.h            |    5 +
 include/linux/hot_tracking.h |    1 +
 3 files changed, 490 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 54a8208..376d7fb 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -21,6 +21,7 @@
 #include <linux/blkdev.h>
 #include <linux/types.h>
 #include <linux/list_sort.h>
+#include <linux/debugfs.h>
 #include <linux/limits.h>
 #include "hot_tracking.h"
 
@@ -628,6 +629,477 @@ static void hot_update_worker(struct work_struct *work)
 }
 
 /*
+ * take the inode, find ranges associated with inode
+ * and print each range data struct
+ */
+static struct hot_range_item
+*hot_range_tree_walk(struct hot_inode_item *he,
+			loff_t *pos, u32 start, bool flag)
+{
+	struct hot_range_item *hr_nodes[8];
+	loff_t l = *pos;
+	int i, n;
+
+	/* Walk the hot_range_tree for inode */
+	while (1) {
+		spin_lock(&he->lock);
+		n = radix_tree_gang_lookup(&he->hot_range_tree,
+					   (void **)hr_nodes, start,
+					   ARRAY_SIZE(hr_nodes));
+		if (!n) {
+			spin_unlock(&he->lock);
+			break;
+		}
+		spin_unlock(&he->lock);
+
+		start = hr_nodes[n - 1]->start + 1;
+		for (i = 0; i < n; i++) {
+			if ((!flag && !l--) || (flag)) {
+				if (flag)
+					(*pos)++;
+				kref_get(&hr_nodes[i]->hot_range.refs);
+				return hr_nodes[i];
+			}
+		}
+	}
+
+	return NULL;
+}
+
+static void
+*hot_inode_tree_walk(struct seq_file *seq, loff_t *pos,
+			u64 ino, bool type, bool flag)
+{
+	struct hot_info *root = seq->private;
+	struct hot_inode_item *hi_nodes[8];
+	struct hot_range_item *hr;
+	loff_t l = *pos;
+	int i, n;
+
+	while (1) {
+		spin_lock(&root->lock);
+		n = radix_tree_gang_lookup(&root->hot_inode_tree,
+					(void **)hi_nodes, ino,
+					ARRAY_SIZE(hi_nodes));
+		if (!n) {
+			spin_unlock(&root->lock);
+			break;
+		}
+		spin_unlock(&root->lock);
+
+		ino = hi_nodes[n - 1]->i_ino + 1;
+		for (i = 0; i < n; i++) {
+			if (!type) {
+				hr = hot_range_tree_walk(hi_nodes[i],
+						pos, 0, flag);
+				if (hr)
+					return hr;
+			} else {
+				if ((!flag && !l--) || (flag)) {
+					if (flag)
+						(*pos)++;
+					kref_get(&hi_nodes[i]->hot_inode.refs);
+					return hi_nodes[i];
+				}
+			}
+		}
+	}
+
+	return NULL;
+}
+
+static void *hot_range_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	return hot_inode_tree_walk(seq, pos, 0, false, false);
+}
+
+static void *hot_range_seq_next(struct seq_file *seq,
+				void *v, loff_t *pos)
+{
+	struct hot_range_item *hr_next, *hr = v;
+	u32 start = hr->start + 1;
+
+	/* Walk the hot_range_tree for inode */
+	hr_next = hot_range_tree_walk(hr->hot_inode, pos, start, true);
+	if (hr_next)
+		return hr_next;
+
+	return hot_inode_tree_walk(seq, pos,
+			hr->hot_inode->i_ino + 1, false, true);
+}
+
+static void hot_range_seq_stop(struct seq_file *seq, void *v)
+{
+	struct hot_range_item *hr = v;
+
+	if (hr)
+		hot_range_item_put(hr);
+}
+
+static int hot_range_seq_show(struct seq_file *seq, void *v)
+{
+	struct hot_range_item *hr = v;
+	struct hot_inode_item *he = hr->hot_inode;
+	struct hot_freq_data *freq_data = &hr->hot_range.hot_freq_data;
+
+	/* Always lock hot_inode_item first */
+	spin_lock(&he->hot_inode.lock);
+	spin_lock(&hr->hot_range.lock);
+	seq_printf(seq, "inode #%llu, range start " \
+			"%llu (range len %u) reads %u, writes %u, "
+			"avg read time %llu, avg write time %llu, temp %u\n",
+			he->i_ino,
+			(u64)hr->start * RANGE_SIZE,
+			hr->len,
+			freq_data->nr_reads,
+			freq_data->nr_writes,
+			freq_data->avg_delta_reads / NSEC_PER_MSEC,
+			freq_data->avg_delta_writes / NSEC_PER_MSEC,
+			freq_data->last_temp >> (32 - HEAT_MAP_BITS));
+	spin_unlock(&hr->hot_range.lock);
+	spin_unlock(&he->hot_inode.lock);
+
+	return 0;
+}
+
+static void *hot_inode_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	return hot_inode_tree_walk(seq, pos, 0, true, false);
+}
+
+static void *hot_inode_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct hot_inode_item *he = v;
+	u64 ino = he->i_ino + 1;
+
+	hot_inode_item_put(he);
+
+	return hot_inode_tree_walk(seq, pos, ino, true, true);
+}
+
+static void hot_inode_seq_stop(struct seq_file *seq, void *v)
+{
+	struct hot_inode_item *he = v;
+
+	if (he)
+		hot_inode_item_put(he);
+}
+
+static int hot_inode_seq_show(struct seq_file *seq, void *v)
+{
+	struct hot_inode_item *he = v;
+	struct hot_freq_data *freq_data = &he->hot_inode.hot_freq_data;
+
+	spin_lock(&he->hot_inode.lock);
+	seq_printf(seq, "inode #%llu, reads %u, writes %u, " \
+		"avg read time %llu, avg write time %llu, temp %u\n",
+		he->i_ino,
+		freq_data->nr_reads,
+		freq_data->nr_writes,
+		freq_data->avg_delta_reads / NSEC_PER_MSEC,
+		freq_data->avg_delta_writes / NSEC_PER_MSEC,
+		freq_data->last_temp >> (32 - HEAT_MAP_BITS));
+	spin_unlock(&he->hot_inode.lock);
+
+	return 0;
+}
+
+static void *hot_spot_range_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct hot_info *root = seq->private;
+	struct hot_range_item *hr;
+	struct hot_comm_item *comm_item;
+	struct list_head *n_list;
+	int i;
+
+	for (i = HEAT_MAP_SIZE - 1; i >= 0; i--) {
+		n_list = seq_list_start(
+			&root->heat_range_map[i].node_list, *pos);
+		if (n_list) {
+			comm_item = container_of(n_list,
+				struct hot_comm_item, n_list);
+			hr = container_of(comm_item,
+				struct hot_range_item, hot_range);
+			kref_get(&hr->hot_range.refs);
+			return hr;
+		}
+	}
+
+	return NULL;
+}
+
+static void *hot_spot_range_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct hot_info *root = seq->private;
+	struct hot_range_item *hr_next, *hr = v;
+	struct hot_comm_item *comm_item;
+	struct list_head *n_list;
+	int i =
+	 hr->hot_range.hot_freq_data.last_temp >> (32 - HEAT_MAP_BITS);
+
+	n_list = seq_list_next(&hr->hot_range.n_list,
+		&root->heat_range_map[i].node_list, pos);
+	hot_range_item_put(hr);
+next:
+	if (n_list) {
+		comm_item = container_of(n_list,
+			struct hot_comm_item, n_list);
+		hr_next = container_of(comm_item,
+			struct hot_range_item, hot_range);
+		kref_get(&hr_next->hot_range.refs);
+		return hr_next;
+	} else if (--i >= 0) {
+		n_list = seq_list_next(&root->heat_range_map[i].node_list,
+				&root->heat_range_map[i].node_list, pos);
+		goto next;
+	}
+
+	return NULL;
+}
+
+static void *hot_spot_inode_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct hot_info *root = seq->private;
+	struct hot_inode_item *he;
+	struct hot_comm_item *comm_item;
+	struct list_head *n_list;
+	int i;
+
+	for (i = HEAT_MAP_SIZE - 1; i >= 0; i--) {
+		n_list = seq_list_start(
+			&root->heat_inode_map[i].node_list, *pos);
+		if (n_list) {
+			comm_item = container_of(n_list,
+				struct hot_comm_item, n_list);
+			he = container_of(comm_item,
+				struct hot_inode_item, hot_inode);
+			kref_get(&he->hot_inode.refs);
+			return he;
+		}
+	}
+
+	return NULL;
+}
+
+static void *hot_spot_inode_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct hot_info *root = seq->private;
+	struct hot_inode_item *he_next, *he = v;
+	struct hot_comm_item *comm_item;
+	struct list_head *n_list;
+	int i =
+	 he->hot_inode.hot_freq_data.last_temp >> (32 - HEAT_MAP_BITS);
+
+	n_list = seq_list_next(&he->hot_inode.n_list,
+			&root->heat_inode_map[i].node_list, pos);
+	hot_inode_item_put(he);
+next:
+	if (n_list) {
+		comm_item = container_of(n_list,
+			struct hot_comm_item, n_list);
+		he_next = container_of(comm_item,
+			struct hot_inode_item, hot_inode);
+		kref_get(&he_next->hot_inode.refs);
+		return he_next;
+	} else if (--i >= 0) {
+		n_list = seq_list_next(&root->heat_inode_map[i].node_list,
+				&root->heat_inode_map[i].node_list, pos);
+		goto next;
+	}
+
+	return NULL;
+}
+
+static const struct seq_operations hot_range_seq_ops = {
+	.start = hot_range_seq_start,
+	.next = hot_range_seq_next,
+	.stop = hot_range_seq_stop,
+	.show = hot_range_seq_show
+};
+
+static const struct seq_operations hot_inode_seq_ops = {
+	.start = hot_inode_seq_start,
+	.next = hot_inode_seq_next,
+	.stop = hot_inode_seq_stop,
+	.show = hot_inode_seq_show
+};
+
+static const struct seq_operations hot_spot_range_seq_ops = {
+	.start = hot_spot_range_seq_start,
+	.next = hot_spot_range_seq_next,
+	.stop = hot_range_seq_stop,
+	.show = hot_range_seq_show
+};
+
+static const struct seq_operations hot_spot_inode_seq_ops = {
+	.start = hot_spot_inode_seq_start,
+	.next = hot_spot_inode_seq_next,
+	.stop = hot_inode_seq_stop,
+	.show = hot_inode_seq_show
+};
+
+static int hot_range_seq_open(struct inode *inode, struct file *file)
+{
+	int ret = seq_open_private(file, &hot_range_seq_ops, 0);
+	if (ret == 0) {
+		struct seq_file *seq = file->private_data;
+		seq->private = inode->i_private;
+	}
+	return ret;
+}
+
+static int hot_inode_seq_open(struct inode *inode, struct file *file)
+{
+	int ret = seq_open_private(file, &hot_inode_seq_ops, 0);
+	if (ret == 0) {
+		struct seq_file *seq = file->private_data;
+		seq->private = inode->i_private;
+	}
+	return ret;
+}
+
+static int hot_spot_range_seq_open(struct inode *inode, struct file *file)
+{
+	int ret = seq_open_private(file, &hot_spot_range_seq_ops, 0);
+	if (ret == 0) {
+		struct seq_file *seq = file->private_data;
+		seq->private = inode->i_private;
+	}
+	return ret;
+}
+
+static int hot_spot_inode_seq_open(struct inode *inode, struct file *file)
+{
+	int ret = seq_open_private(file, &hot_spot_inode_seq_ops, 0);
+	if (ret == 0) {
+		struct seq_file *seq = file->private_data;
+		seq->private = inode->i_private;
+	}
+	return ret;
+}
+
+/* fops to override for printing range data */
+static const struct file_operations hot_debugfs_range_fops = {
+	.open = hot_range_seq_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release,
+};
+
+/* fops to override for printing inode data */
+static const struct file_operations hot_debugfs_inode_fops = {
+	.open = hot_inode_seq_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release,
+};
+
+/* fops to override for printing temperature data */
+static const struct file_operations hot_debugfs_spot_range_fops = {
+	.open = hot_spot_range_seq_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release,
+};
+
+static const struct file_operations hot_debugfs_spot_inode_fops = {
+	.open = hot_spot_inode_seq_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = seq_release,
+};
+
+static const struct hot_debugfs hot_debugfs[] = {
+	{
+		.name = "rt_stats_range",
+		.fops  = &hot_debugfs_range_fops,
+	},
+	{
+		.name = "rt_stats_inode",
+		.fops  = &hot_debugfs_inode_fops,
+	},
+	{
+		.name = "hot_spots_range",
+		.fops  = &hot_debugfs_spot_range_fops,
+	},
+	{
+		.name = "hot_spots_inode",
+		.fops  = &hot_debugfs_spot_inode_fops,
+	},
+};
+
+/* initialize debugfs */
+static int hot_debugfs_init(struct super_block *sb)
+{
+	static const char hot_name[] = "hot_track";
+	struct dentry *vol_dentry, *dentry;
+	int i, ret = 0;
+
+	/* Determine if hot debufs root has existed */
+	sb->s_hot_root->debugfs_root =
+			debugfs_get_dentry(hot_name, NULL, strlen(hot_name));
+	if (IS_ERR_OR_NULL(sb->s_hot_root->debugfs_root)
+		|| !sb->s_hot_root->debugfs_root->d_inode) {
+		sb->s_hot_root->debugfs_root =
+			debugfs_create_dir(hot_name, NULL);
+		if (IS_ERR(sb->s_hot_root->debugfs_root)) {
+			ret = PTR_ERR(sb->s_hot_root->debugfs_root);
+			return ret;
+		}
+	}
+
+	if (!S_ISDIR(sb->s_hot_root->debugfs_root->d_inode->i_mode))
+		return -ENOTDIR;
+
+	/* create debugfs folder for this volume by mounted dev name */
+	vol_dentry = debugfs_create_dir(sb->s_id, sb->s_hot_root->debugfs_root);
+	if (IS_ERR(vol_dentry)) {
+		ret = PTR_ERR(vol_dentry);
+		goto err;
+	}
+
+	/* create debugfs hot data files */
+	for (i = 0; i < ARRAY_SIZE(hot_debugfs); i++) {
+		dentry = debugfs_create_file(hot_debugfs[i].name,
+					S_IFREG | S_IRUSR | S_IWUSR,
+					vol_dentry,
+					sb->s_hot_root,
+					hot_debugfs[i].fops);
+		if (IS_ERR(dentry)) {
+			ret = PTR_ERR(dentry);
+			goto err;
+		}
+	}
+
+	return 0;
+
+err:
+	debugfs_remove_recursive(vol_dentry);
+
+	if (list_empty(&sb->s_hot_root->debugfs_root->d_subdirs))
+		debugfs_remove(sb->s_hot_root->debugfs_root);
+
+	return ret;
+}
+
+/* remove dentries for debugsfs */
+static void hot_debugfs_exit(struct super_block *sb)
+{
+	struct dentry *vol_dentry;
+
+	vol_dentry = debugfs_get_dentry(sb->s_id,
+				sb->s_hot_root->debugfs_root, strlen(sb->s_id));
+	/* remove all debugfs entries recursively from the volume root */
+	if (vol_dentry)
+		debugfs_remove_recursive(vol_dentry);
+	else
+		BUG_ON(1);
+
+	if (list_empty(&sb->s_hot_root->debugfs_root->d_subdirs))
+		debugfs_remove(sb->s_hot_root->debugfs_root);
+}
+
+/*
  * Initialize kmem cache for hot_inode_item and hot_range_item.
  */
 void __init hot_cache_init(void)
@@ -851,10 +1323,21 @@ int hot_track_init(struct super_block *sb)
 	root->hot_shrink.seeks = DEFAULT_SEEKS;
 	register_shrinker(&root->hot_shrink);
 
+	ret = hot_debugfs_init(sb);
+	if (ret) {
+		printk(KERN_ERR "%s: hot_debugfs_init error: %d\n",
+				__func__, ret);
+		goto failed_debugfs;
+	}
+
 	printk(KERN_INFO "VFS: Turning on hot data tracking\n");
 
 	return 0;
 
+failed_debugfs:
+	unregister_shrinker(&root->hot_shrink);
+	cancel_delayed_work_sync(&root->update_work);
+	destroy_workqueue(root->update_wq);
 failed_wq:
 	hot_map_array_exit(root);
 	hot_inode_tree_exit(root);
@@ -872,6 +1355,7 @@ void hot_track_exit(struct super_block *sb)
 	destroy_workqueue(root->update_wq);
 	hot_map_array_exit(root);
 	hot_inode_tree_exit(root);
+	hot_debugfs_exit(sb);
 	kfree(root);
 }
 EXPORT_SYMBOL_GPL(hot_track_exit);
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index 92e31fb..f5ba2d6 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -56,6 +56,11 @@
 #define AVW_DIVIDER_POWER 40 /* AVW - average delta between recent writes(ns) */
 #define AVW_COEFF_POWER 0
 
+struct hot_debugfs {
+	const char *name;
+	const struct file_operations *fops;
+};
+
 void hot_inode_item_put(struct hot_inode_item *he);
 struct hot_inode_item *hot_inode_item_find(struct hot_info *root, u64 ino);
 
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index b3ed251..a16217f 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -119,6 +119,7 @@ struct hot_info {
 	struct delayed_work update_work;
 	struct hot_func_type *hot_func_type;
 	struct shrinker hot_shrink;
+	struct dentry *debugfs_root;
 };
 
 /*
-- 
1.7.6.5
