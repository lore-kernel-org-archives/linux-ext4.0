From: zwu.kernel@gmail.com
Subject: [RFC v3 12/13] vfs: add debugfs support
Date: Wed, 10 Oct 2012 18:07:34 +0800
Message-ID: <1349863655-29320-13-git-send-email-zwu.kernel@gmail.com>
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

  Add a /sys/kernel/debug/hot_track/<device_name>/ directory for each
volume that contains two files. The first, `inode_data', contains the
heat information for inodes that have been brought into the hot data map
structures. The second, `range_data', contains similar information for
subfile ranges.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c |  462 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/hot_tracking.h |   43 +++++
 2 files changed, 505 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index fcde55e..60e93e6 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -20,6 +20,8 @@
 #include <linux/fs.h>
 #include <linux/blkdev.h>
 #include <linux/types.h>
+#include <linux/debugfs.h> 
+#include <linux/vmalloc.h> 
 #include <linux/limits.h>
 #include "hot_tracking.h"
 
@@ -29,6 +31,13 @@ struct hot_info *global_hot_tracking_info;
 static struct kmem_cache *hot_inode_item_cachep;
 static struct kmem_cache *hot_range_item_cachep;
 
+/* list to keep track of each mounted volumes debugfs_vol_data */
+static struct list_head hot_debugfs_vol_data_list;
+/* lock for debugfs_vol_data_list */
+static spinlock_t hot_debugfs_data_list_lock;
+/* pointer to top level debugfs dentry */
+static struct dentry *hot_debugfs_root_dentry;
+
 /*
  * Initialize the inode tree. Should be called for each new inode
  * access or other user of the hot_inode interface.
@@ -706,6 +715,451 @@ static void hot_wq_exit(struct workqueue_struct *wq)
 	destroy_workqueue(wq);
 }
 
+static int hot_debugfs_copy(struct debugfs_vol_data *data, char *msg, int len)
+{
+	struct lstring *debugfs_log = data->debugfs_log;
+	uint new_log_alloc_size;
+	char *new_log;
+	static char err_msg[] = "No more memory!\n";
+
+	if (len >= data->log_alloc_size - debugfs_log->len) {
+		/*
+		 * Not enough room in the log buffer for the new message.
+		 * Allocate a bigger buffer.
+		 */
+		new_log_alloc_size = data->log_alloc_size + LOG_PAGE_SIZE;
+		new_log = vmalloc(new_log_alloc_size);
+
+		if (new_log) {
+			memcpy(new_log, debugfs_log->str, debugfs_log->len);
+			memset(new_log + debugfs_log->len, 0,
+				new_log_alloc_size - debugfs_log->len);
+			vfree(debugfs_log->str);
+			debugfs_log->str = new_log;
+			data->log_alloc_size = new_log_alloc_size;
+		} else {
+			WARN_ON(1);
+			if (data->log_alloc_size - debugfs_log->len) {
+				strlcpy(debugfs_log->str +
+				debugfs_log->len,
+				err_msg,
+				data->log_alloc_size - debugfs_log->len);
+				debugfs_log->len +=
+				min((typeof(debugfs_log->len))
+				sizeof(err_msg),
+				((typeof(debugfs_log->len))
+				data->log_alloc_size - debugfs_log->len));
+			}
+			return 0;
+		}
+	}
+
+	memcpy(debugfs_log->str + debugfs_log->len, data->log_work_buff, len);
+	debugfs_log->len += (unsigned long) len;
+
+	return len;
+}
+
+/* Returns the number of bytes written to the log. */
+static int hot_debugfs_log(struct debugfs_vol_data *data, const char *fmt, ...)
+{
+	struct lstring *debugfs_log = data->debugfs_log;
+	va_list args;
+	int len;
+	static char trunc_msg[] =
+			"The next message has been truncated.\n";
+
+	if (debugfs_log->str == NULL)
+		return -1;
+
+	spin_lock(&data->log_lock);
+
+	va_start(args, fmt);
+	len = vsnprintf(data->log_work_buff,
+			sizeof(data->log_work_buff), fmt, args);
+	va_end(args);
+
+	if (len >= sizeof(data->log_work_buff)) {
+		hot_debugfs_copy(data, trunc_msg, sizeof(trunc_msg));
+	}
+
+	len = hot_debugfs_copy(data, data->log_work_buff, len);
+	spin_unlock(&data->log_lock);
+
+	return len;
+}
+
+/* initialize a log corresponding to a fs volume */
+static int hot_debugfs_log_init(struct debugfs_vol_data *data)
+{
+	int err = 0;
+	struct lstring *debugfs_log = data->debugfs_log;
+
+	spin_lock(&data->log_lock);
+	debugfs_log->str = vmalloc(INIT_LOG_ALLOC_SIZE);
+	if (debugfs_log->str) {
+		memset(debugfs_log->str, 0, INIT_LOG_ALLOC_SIZE);
+		data->log_alloc_size = INIT_LOG_ALLOC_SIZE;
+	} else {
+		err = -ENOMEM;
+	}
+	spin_unlock(&data->log_lock);
+
+	return err;
+}
+
+/* free a log corresponding to a fs volume */
+static void hot_debugfs_log_exit(struct debugfs_vol_data *data)
+{
+	struct lstring *debugfs_log = data->debugfs_log;
+
+	spin_lock(&data->log_lock);
+	vfree(debugfs_log->str);
+	debugfs_log->str = NULL;
+	debugfs_log->len = 0;
+	spin_unlock(&data->log_lock);
+}
+
+/* debugfs open file override from fops table */
+static int __hot_debugfs_open(struct inode *inode, struct file *file)
+{
+	if (inode->i_private)
+		file->private_data = inode->i_private;
+
+	return 0;
+}
+
+static void __hot_debugfs_print_range_freq_data(
+			struct hot_inode_item *he,
+			struct hot_range_item *hr,
+			struct debugfs_vol_data *data,
+			struct hot_info *root)
+{
+	struct hot_freq_data *freq_data;
+
+	freq_data = &hr->hot_range.hot_freq_data;
+
+	/* Always lock hot_inode_item first */
+	spin_lock(&he->hot_inode.lock);
+	spin_lock(&hr->hot_range.lock);
+	hot_debugfs_log(data, "inode #%lu, range start " \
+			"%llu (range len %llu) reads %u, writes %u, "
+			"avg read time %llu, avg write time %llu, temp %u\n",
+			he->i_ino,
+			hr->start,
+			hr->len,
+			freq_data->nr_reads,
+			freq_data->nr_writes,
+			freq_data->avg_delta_reads,
+			freq_data->avg_delta_writes,
+			freq_data->last_temperature);
+	spin_unlock(&hr->hot_range.lock);
+	spin_unlock(&he->hot_inode.lock);
+}
+
+/*
+ * take the inode, find ranges associated with inode
+ * and print each range data struct
+ */
+static void __hot_debugfs_walk_range_tree(struct hot_inode_item *he,
+				struct debugfs_vol_data *data,
+				struct hot_info *root)
+{
+	struct hot_range_item *hr_nodes[8];
+	u32 start = 0;
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
+
+		start = hr_nodes[n - 1]->start + 1;
+		for (i = 0; i < n; i++) {
+			kref_get(&hr_nodes[i]->hot_range.refs);
+			__hot_debugfs_print_range_freq_data(he,
+						hr_nodes[i], data, root);
+			hot_range_item_put(hr_nodes[i]);
+		}
+		spin_unlock(&he->lock);
+	}
+}
+
+/* Print frequency data for each freq data to log */
+static void __hot_debugfs_print_inode_freq_data(
+				struct hot_inode_item *he,
+				struct debugfs_vol_data *data,
+				struct hot_info *root)
+{
+	struct hot_freq_data *freq_data = &he->hot_inode.hot_freq_data;
+
+	spin_lock(&he->hot_inode.lock);
+	hot_debugfs_log(data, "inode #%lu, reads %u, writes %u, " \
+		"avg read time %llu, avg write time %llu, temp %u\n",
+		he->i_ino,
+		freq_data->nr_reads,
+		freq_data->nr_writes,
+		freq_data->avg_delta_reads,
+		freq_data->avg_delta_writes,
+		freq_data->last_temperature);
+	spin_unlock(&he->hot_inode.lock);
+}
+
+/* debugfs common read file override from fops table */
+static ssize_t __hot_debugfs_comm_read(struct file *file, char __user *user,
+					size_t count, loff_t *ppos,
+					hot_debugfs_walk_t private_walk)
+{
+	int err = 0;
+	struct hot_info *root;
+	struct debugfs_vol_data *data;
+	struct lstring *debugfs_log;
+	struct hot_inode_item *hi_nodes[8];
+	u64 ino = 0;
+	int i, n;
+
+	data = (struct debugfs_vol_data *) file->private_data;
+	root = global_hot_tracking_info;
+
+	if (!data->debugfs_log) {
+		/* initialize debugfs log corresponding to this volume */
+		debugfs_log = kmalloc(sizeof(struct lstring),
+					GFP_KERNEL | GFP_NOFS);
+		debugfs_log->str = NULL,
+		debugfs_log->len = 0;
+		data->debugfs_log = debugfs_log;
+		hot_debugfs_log_init(data);
+	}
+
+	if ((unsigned long) *ppos > 0) {
+		/* caller is continuing a previous read, don't walk tree */
+		if ((unsigned long) *ppos >= data->debugfs_log->len)
+			goto clean_up;
+
+		goto print_to_user;
+	}
+
+	/* walk the inode tree */
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
+		for (i = 0; i < n; i++) {
+			kref_get(&hi_nodes[i]->hot_inode.refs);
+			/* walk ranges, print data to debugfs log */
+			private_walk(hi_nodes[i], data, root);
+			hot_inode_item_put(hi_nodes[i]);
+		}
+		spin_unlock(&root->lock);
+	}
+
+print_to_user:
+	if (data->debugfs_log->len) {
+		err = simple_read_from_buffer(user, count, ppos,
+					data->debugfs_log->str,
+					data->debugfs_log->len);
+	}
+
+	return err;
+
+clean_up:
+	/* reader has finished the file, clean up */
+	hot_debugfs_log_exit(data);
+	kfree(data->debugfs_log);
+	data->debugfs_log = NULL;
+
+	return 0;
+}
+
+/* debugfs read file override from fops table */
+static ssize_t __hot_debugfs_range_read(struct file *file, char __user *user,
+					size_t count, loff_t *ppos)
+{
+	return __hot_debugfs_comm_read(file, user,count, ppos,
+				__hot_debugfs_walk_range_tree);
+}
+
+/* debugfs read file override from fops table */
+static ssize_t __hot_debugfs_inode_read(struct file *file, char __user *user,
+					size_t count, loff_t *ppos)
+{
+	return __hot_debugfs_comm_read(file, user,count, ppos,
+				__hot_debugfs_print_inode_freq_data);
+
+}
+
+/* fops to override for printing range data */
+static const struct file_operations hot_debugfs_range_fops = {
+	.read = __hot_debugfs_range_read,
+	.open = __hot_debugfs_open,
+};
+
+/* fops to override for printing inode data */
+static const struct file_operations hot_debugfs_inode_fops = {
+	.read = __hot_debugfs_inode_read,
+	.open = __hot_debugfs_open,
+};
+
+/*
+ * on each volume mount, initialize the debugfs dentries and associated
+ * structures (debugfs_vol_data and debugfs_log)
+ */
+static int hot_debugfs_volume_init(struct super_block *sb)
+{
+	struct dentry *debugfs_volume_entry = NULL;
+	struct dentry *debugfs_range_entry = NULL;
+	struct dentry *debugfs_inode_entry = NULL;
+	struct debugfs_vol_data *range_data = NULL;
+	struct debugfs_vol_data *inode_data = NULL;
+
+	if (!hot_debugfs_root_dentry)
+		goto debugfs_error;
+
+	/* create debugfs folder for this volume by mounted dev name */
+	debugfs_volume_entry = debugfs_create_dir(sb->s_id, hot_debugfs_root_dentry);
+
+	if (!debugfs_volume_entry)
+		goto debugfs_error;
+
+	/* malloc and initialize debugfs_vol_data for range_data */
+	range_data = kmalloc(sizeof(struct debugfs_vol_data),
+				GFP_KERNEL | GFP_NOFS);
+	memset(range_data, 0, sizeof(struct debugfs_vol_data));
+	range_data->debugfs_log = NULL;
+	range_data->sb = sb;
+	spin_lock_init(&range_data->log_lock);
+	range_data->log_alloc_size = 0;
+
+	/* malloc and initialize debugfs_vol_data for inode_data */
+	inode_data = kmalloc(sizeof(struct debugfs_vol_data),
+				GFP_KERNEL | GFP_NOFS);
+	memset(inode_data, 0, sizeof(struct debugfs_vol_data));
+	inode_data->debugfs_log = NULL;
+	inode_data->sb = sb;
+	spin_lock_init(&inode_data->log_lock);
+	inode_data->log_alloc_size = 0;
+
+	/*
+	 * add debugfs_vol_data for inode data and range data for
+	 * volume to list
+	 */
+	range_data->de = debugfs_volume_entry;
+	inode_data->de = debugfs_volume_entry;
+	spin_lock(&hot_debugfs_data_list_lock);
+	list_add(&range_data->node, &hot_debugfs_vol_data_list);
+	list_add(&inode_data->node, &hot_debugfs_vol_data_list);
+	spin_unlock(&hot_debugfs_data_list_lock);
+
+	/* create debugfs range_data file */
+	debugfs_range_entry = debugfs_create_file("range_data",
+				S_IFREG | S_IRUSR | S_IWUSR | S_IRUGO,
+				debugfs_volume_entry,
+				(void *) range_data,
+				&hot_debugfs_range_fops);
+	if (!debugfs_range_entry)
+		goto debugfs_error;
+
+	/* create debugfs inode_data file */
+	debugfs_inode_entry = debugfs_create_file("inode_data",
+				S_IFREG | S_IRUSR | S_IWUSR | S_IRUGO,
+				debugfs_volume_entry,
+				(void *) inode_data,
+				&hot_debugfs_inode_fops);
+
+	if (!debugfs_inode_entry)
+		goto debugfs_error;
+
+	return 0;
+
+debugfs_error:
+	kfree(range_data);
+	kfree(inode_data);
+
+	return -EIO;
+}
+
+/*
+ * find volume mounted (match by superblock) and remove
+ * debugfs dentry
+ */
+static void hot_debugfs_volume_exit(struct super_block *sb)
+{
+	struct list_head *head;
+	struct list_head *pos;
+	struct debugfs_vol_data *data;
+
+	spin_lock(&hot_debugfs_data_list_lock);
+	head = &hot_debugfs_vol_data_list;
+	/* must clean up memory assicatied with superblock */
+	list_for_each(pos, head)
+	{
+		data = list_entry(pos, struct debugfs_vol_data, node);
+		if (data->sb == sb) {
+			list_del(pos);
+			debugfs_remove_recursive(data->de);
+			kfree(data);
+			data = NULL;
+		}
+	}
+	spin_unlock(&hot_debugfs_data_list_lock);
+}
+
+/* initialize debugfs */
+static int hot_debugfs_init(struct super_block *sb)
+{
+	hot_debugfs_root_dentry = debugfs_create_dir(DEBUGFS_ROOT_NAME, NULL);
+	/*init list of debugfs data list */
+	INIT_LIST_HEAD(&hot_debugfs_vol_data_list);
+	/*init lock to list of debugfs data list */
+	spin_lock_init(&hot_debugfs_data_list_lock);
+	if (!hot_debugfs_root_dentry)
+		goto debugfs_error;
+
+	hot_debugfs_volume_init(sb);
+
+	return 0;
+
+debugfs_error:
+	return -EIO;
+}
+
+/* clean up memory and remove dentries for debugsfs */
+static void hot_debugfs_exit(struct super_block *sb)
+{
+	/* first iterate through debugfs_vol_data_list and free memory */
+	struct list_head *head;
+	struct list_head *pos;
+	struct list_head *cur;
+	struct debugfs_vol_data *data;
+
+	hot_debugfs_volume_exit(sb);
+
+	spin_lock(&hot_debugfs_data_list_lock);
+	head = &hot_debugfs_vol_data_list;
+	list_for_each_safe(pos, cur, head) {
+		data = list_entry(pos, struct debugfs_vol_data, node);
+		if (data && pos != head)
+			kfree(data);
+	}
+	spin_unlock(&hot_debugfs_data_list_lock);
+
+	/* remove all debugfs entries recursively from the root */
+	debugfs_remove_recursive(hot_debugfs_root_dentry);
+}
+
 /*
  * Initialize kmem cache for hot_inode_item and hot_range_item.
  */
@@ -832,6 +1286,13 @@ void hot_track_init(struct super_block *sb)
 	root->hot_shrink.seeks = DEFAULT_SEEKS;
 	register_shrinker(&root->hot_shrink);
 
+	err = hot_debugfs_init(sb);
+	if (err) {
+		printk(KERN_ERR "%s: hot_debugfs_init error: %d\n",
+				__func__, err);
+		return;
+	}
+
 	printk(KERN_INFO "vfs: turning on hot data tracking\n");
 
 	return;
@@ -855,5 +1316,6 @@ void hot_track_exit(struct super_block *sb)
 	hot_inode_tree_exit(root);
 	sb->hot_flags &= ~MS_HOT_TRACKING;
 	hot_cache_exit();
+	hot_debugfs_exit(sb);
 	kfree(root);
 }
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index 7a79a6d..76d7469 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -92,6 +92,49 @@
 #define AVW_DIVIDER_POWER 40
 #define AVW_COEFF_POWER 0
 
+/* size of log to vmalloc */
+#define INIT_LOG_ALLOC_SIZE (PAGE_SIZE * 10)
+#define LOG_PAGE_SIZE (PAGE_SIZE * 10)
+
+/*
+ * number of chars of device name of chop off
+ * for making debugfs folder e.g. /dev/sda -> sda
+ */
+#define DEV_NAME_CHOP 5
+
+/*
+ * Name for VFS data in debugfs directory
+ * e.g. /sys/kernel/debug/hot_track
+ */
+#define DEBUGFS_ROOT_NAME "hot_track"
+
+/* log to output to userspace in debugfs files */
+struct lstring {
+	char *str;
+	unsigned long len;
+};
+
+/*
+ * debugfs_vol_data is a struct of items
+ * that is passed to the debugfs
+ */
+struct debugfs_vol_data {
+	/* protected by hot_debugfs_data_list_lock */
+	struct list_head node;
+	struct lstring *debugfs_log;
+	struct super_block *sb;
+	struct dentry *de;
+	/* protects debugfs_log */
+	spinlock_t log_lock;
+	char log_work_buff[1024];
+	uint log_alloc_size;
+};
+
+typedef void (*hot_debugfs_walk_t)(
+			struct hot_inode_item *hot_inode,
+			struct debugfs_vol_data *data,
+			struct hot_info *root);
+
 struct hot_update_work {
 	struct work_struct work;
 	struct hot_info *hot_info;
-- 
1.7.6.5

