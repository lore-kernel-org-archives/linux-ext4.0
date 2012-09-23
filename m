From: zwu.kernel@gmail.com
Subject: [RFC v2 09/10] vfs: add debugfs support
Date: Sun, 23 Sep 2012 20:56:34 +0800
Message-ID: <1348404995-14372-10-git-send-email-zwu.kernel@gmail.com>
References: <1348404995-14372-1-git-send-email-zwu.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, cmm@us.ibm.com, tytso@mit.edu,
	marco.stornelli@gmail.com, david@fromorbit.com,
	stroetmann@ontolinux.com, diegocg@gmail.com, chris@csamuel.org,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1348404995-14372-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Add a /sys/kernel/debug/hot_track/<device_name>/ directory for each
volume that contains two files. The first, `inode_data', contains the
heat information for inodes that have been brought into the hot data map
structures. The second, `range_data', contains similar information for
subfile ranges.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c |  466 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/hot_tracking.h |   40 +++++
 fs/namespace.c    |    6 +
 3 files changed, 512 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index fd11695..6aeabad 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -22,6 +22,9 @@
 #include <linux/fs.h>
 #include <linux/blkdev.h>
 #include <linux/types.h>
+#include <linux/debugfs.h>
+#include <linux/vmalloc.h>
+#include <linux/limits.h>
 #include "hot_tracking.h"
 
 /* kmem_cache pointers for slab caches */
@@ -29,6 +32,13 @@ static struct kmem_cache *hot_inode_item_cache;
 static struct kmem_cache *hot_range_item_cache;
 static struct kmem_cache *hot_hash_node_cache;
 
+/* list to keep track of each mounted volumes debugfs_vol_data */
+static struct list_head hot_debugfs_vol_data_list;
+/* lock for debugfs_vol_data_list */
+static spinlock_t hot_debugfs_data_list_lock;
+/* pointer to top level debugfs dentry */
+static struct dentry *hot_debugfs_root_dentry;
+
 static struct task_struct *hot_track_temperature_update_kthread;
 
 static void hot_hash_node_init(void *_node);
@@ -1004,6 +1014,460 @@ static int hot_hash_temperature_update_kthread(void *arg)
 	return 0;
 }
 
+static int hot_debugfs_copy(struct debugfs_vol_data *data, char *msg, int len)
+{
+	struct lstring *debugfs_log = data->debugfs_log;
+	uint new_log_alloc_size;
+	char *new_log;
+	static char err_msg[] = "No more memory!\n";
+
+	if (len >= data->log_alloc_size - debugfs_log->len) {
+		/* Not enough room in the log buffer for the new message. */
+		/* Allocate a bigger buffer. */
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
+			struct hot_inode_item *hot_inode,
+			struct hot_range_item *hot_range,
+			struct debugfs_vol_data *data,
+			struct hot_info *root)
+{
+	struct hot_freq_data *freq_data;
+	u64 start;
+	u64 len;
+
+	freq_data = &hot_range->hot_freq_data;
+
+	spin_lock(&hot_range->lock);
+	start = hot_range->start;
+	len = hot_range->len;
+	spin_unlock(&hot_range->lock);
+
+	/* Always lock hot_inode_item first */
+	spin_lock(&hot_inode->lock);
+	spin_lock(&hot_range->lock);
+	hot_debugfs_log(data, "inode #%lu, range start " \
+			"%llu (range len %llu) reads %u, writes %u, "
+			"avg read time %llu, avg write time %llu, temp %u\n",
+			hot_inode->i_ino,
+			hot_range->start,
+			hot_range->len,
+			freq_data->nr_reads,
+			freq_data->nr_writes,
+			freq_data->avg_delta_reads,
+			freq_data->avg_delta_writes,
+			freq_data->last_temperature);
+	spin_unlock(&hot_range->lock);
+	spin_unlock(&hot_inode->lock);
+}
+
+/*
+ * take the inode, find ranges associated with inode
+ * and print each range data struct
+ */
+static void __hot_debugfs_walk_range_tree(struct hot_inode_item *hot_inode,
+				struct debugfs_vol_data *data,
+				struct hot_info *root)
+{
+	struct hot_range_tree *inode_range_tree;
+	struct rb_node *node;
+	struct hot_range_item *current_range;
+
+	inode_range_tree = &hot_inode->hot_range_tree;
+	read_lock(&inode_range_tree->lock);
+	node = rb_first(&inode_range_tree->map);
+
+	/* Walk the hot_range_tree for inode */
+	while (node) {
+		current_range = rb_entry(node, struct hot_range_item, rb_node);
+		__hot_debugfs_print_range_freq_data(hot_inode,
+						current_range, data, root);
+		node = rb_next(node);
+	}
+	read_unlock(&inode_range_tree->lock);
+}
+
+/* Print frequency data for each freq data to log */
+static void __hot_debugfs_print_inode_freq_data(
+				struct hot_inode_item *hot_inode,
+				struct debugfs_vol_data *data,
+				struct hot_info *root)
+{
+	struct hot_freq_data *freq_data = &hot_inode->hot_freq_data;
+
+	spin_lock(&hot_inode->lock);
+	hot_debugfs_log(data, "inode #%lu, reads %u, writes %u, " \
+		"avg read time %llu, avg write time %llu, temp %u\n",
+		hot_inode->i_ino,
+		freq_data->nr_reads,
+		freq_data->nr_writes,
+		freq_data->avg_delta_reads,
+		freq_data->avg_delta_writes,
+		freq_data->last_temperature);
+	spin_unlock(&hot_inode->lock);
+}
+
+/* debugfs read file override from fops table */
+static ssize_t __hot_debugfs_range_read(struct file *file, char __user *user,
+					size_t count, loff_t *ppos)
+{
+	int err = 0;
+	struct hot_info *root;
+	struct hot_inode_item *current_hot_inode;
+	struct debugfs_vol_data *data;
+	struct lstring *debugfs_log;
+	unsigned long inode_num;
+
+	data = (struct debugfs_vol_data *) file->private_data;
+	root = &(data->sb->s_hotinfo);
+
+	if (!data->debugfs_log) {
+		/* initialize debugfs log corresponding to this volume*/
+		debugfs_log = kmalloc(sizeof(struct lstring),
+				GFP_KERNEL | GFP_NOFS);
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
+	current_hot_inode = hot_rb_find_next_hot_inode(root, 0);
+
+	while (current_hot_inode) {
+		/* walk ranges, print data to debugfs log */
+		__hot_debugfs_walk_range_tree(current_hot_inode, data, root);
+		inode_num = current_hot_inode->i_ino;
+		hot_rb_free_hot_inode_item(current_hot_inode);
+		current_hot_inode = hot_rb_find_next_hot_inode(root,
+							inode_num + 1);
+	}
+
+print_to_user:
+	if (data->debugfs_log->len) {
+		err = simple_read_from_buffer(user, count, ppos,
+						data->debugfs_log->str,
+						data->debugfs_log->len);
+	}
+
+	return err;
+
+clean_up:
+	/* Reader has finished the file, clean up */
+	hot_debugfs_log_exit(data);
+	kfree(data->debugfs_log);
+	data->debugfs_log = NULL;
+
+	return 0;
+}
+
+/* debugfs read file override from fops table */
+static ssize_t __hot_debugfs_inode_read(struct file *file, char __user *user,
+					size_t count, loff_t *ppos)
+{
+	int err = 0;
+	struct hot_info *root;
+	struct hot_inode_item *current_hot_inode;
+	struct debugfs_vol_data *data;
+	struct lstring *debugfs_log;
+	unsigned long inode_num;
+
+	data = (struct debugfs_vol_data *) file->private_data;
+	root = &(data->sb->s_hotinfo);
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
+	current_hot_inode = hot_rb_find_next_hot_inode(root, 0);
+
+	while (current_hot_inode) {
+		/* walk ranges, print data to debugfs log */
+		__hot_debugfs_print_inode_freq_data(current_hot_inode,
+							data, root);
+		inode_num = current_hot_inode->i_ino;
+		hot_rb_free_hot_inode_item(current_hot_inode);
+		current_hot_inode = hot_rb_find_next_hot_inode(root,
+								inode_num + 1);
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
+/* initialize debugfs at module init */
+int hot_debugfs_init(void)
+{
+	hot_debugfs_root_dentry = debugfs_create_dir(DEBUGFS_ROOT_NAME, NULL);
+	/*init list of debugfs data list */
+	INIT_LIST_HEAD(&hot_debugfs_vol_data_list);
+	/*init lock to list of debugfs data list */
+	spin_lock_init(&hot_debugfs_data_list_lock);
+	if (!hot_debugfs_root_dentry)
+		goto debugfs_error;
+
+	return 0;
+
+debugfs_error:
+	return -EIO;
+}
+
+/*
+ * on each volume mount, initialize the debugfs dentries and associated
+ * structures (debugfs_vol_data and debugfs_log)
+ */
+static int hot_debugfs_volume_init(const char *uuid, struct super_block *sb)
+{
+	struct dentry *debugfs_volume_entry = NULL;
+	struct dentry *debugfs_range_entry = NULL;
+	struct dentry *debugfs_inode_entry = NULL;
+	struct debugfs_vol_data *range_data = NULL;
+	struct debugfs_vol_data *inode_data = NULL;
+	size_t dev_name_length = strlen(uuid);
+	char dev[NAME_MAX];
+
+	if (!hot_debugfs_root_dentry)
+		goto debugfs_error;
+
+	/* create debugfs folder for this volume by mounted dev name */
+	memcpy(dev, uuid + DEV_NAME_CHOP, dev_name_length - DEV_NAME_CHOP + 1);
+	debugfs_volume_entry = debugfs_create_dir(dev, hot_debugfs_root_dentry);
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
 /*
  * Regular mount options parser for -hottrack option.
  * return false if no -hottrack is specified;
@@ -1086,6 +1550,7 @@ void hot_track_init(struct super_block *sb, const char *name)
 	hot_rb_inode_tree_init(&sb->s_hotinfo.hot_inode_tree);
 	hot_hash_table_init(&sb->s_hotinfo);
 	hot_track_fork_temperature_update_kthread();
+	hot_debugfs_volume_init(name, sb);
 }
 
 void hot_track_exit(struct super_block *sb)
@@ -1094,4 +1559,5 @@ void hot_track_exit(struct super_block *sb)
 	hot_track_stop_temperature_update_kthread();
 	hot_hash_table_free(&sb->s_hotinfo);
 	hot_rb_inode_tree_free(&sb->s_hotinfo);
+	hot_debugfs_volume_exit(sb);
 }
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index 1b6c694..fa1eb9b 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -97,9 +97,47 @@
         ((struct hot_range_item *) container_of(x, \
         struct hot_range_item, hot_freq_data))
 
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
 struct hot_info;
 struct inode;
 
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
 struct hot_inode_item
 *hot_rb_lookup_hot_inode_item(struct hot_inode_tree *tree,
 				unsigned long inode_num);
@@ -115,6 +153,8 @@ void hot_rb_update_freqs(struct inode *inode, u64 start, u64 len,
  */
 int hot_hash_calc_temperature(struct hot_freq_data *freq_data);
 
+int hot_debugfs_init(void);
+
 bool hot_track_parse_options(char *options);
 void __init hot_track_cache_init(void);
 void hot_track_init(struct super_block *sb, const char *name);
diff --git a/fs/namespace.c b/fs/namespace.c
index 55006c8..6cea6c0 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2629,6 +2629,12 @@ void __init mnt_init(void)
 	fs_kobj = kobject_create_and_add("fs", NULL);
 	if (!fs_kobj)
 		printk(KERN_WARNING "%s: kobj create error\n", __func__);
+
+	err = hot_debugfs_init();
+	if (err)
+		printk(KERN_WARNING "%s: sysfs_init error: %d\n",
+			__func__, err);
+
 	init_rootfs();
 	init_mount_tree();
 }
-- 
1.7.6.5
