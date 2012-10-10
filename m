From: zwu.kernel@gmail.com
Subject: [RFC v3 02/13] vfs: introduce private radix tree structures
Date: Wed, 10 Oct 2012 18:07:24 +0800
Message-ID: <1349863655-29320-3-git-send-email-zwu.kernel@gmail.com>
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

  One root structure hot_info is defined, is hooked
up in super_block, and will be used to hold radix tree
root, hash list root and some other information, etc.
  Adds hot_inode_tree struct to keep track of
frequently accessed files, and be keyed by {inode, offset}.
Trees contain hot_inode_items representing those files
and ranges.
  Having these trees means that vfs can quickly determine the
temperature of some data by doing some calculations on the
hot_freq_data struct that hangs off of the tree item.
  Define two items hot_inode_item and hot_range_item,
one of them represents one tracked file
to keep track of its access frequency and the tree of
ranges in this file, while the latter represents
a file range of one inode.
  Each of the two structures contains a hot_freq_data
struct with its frequency of access metrics (number of
{reads, writes}, last {read,write} time, frequency of
{reads,writes}).
  Also, each hot_inode_item contains one hot_range_tree
struct which is keyed by {inode, offset, length}
and used to keep track of all the ranges in this file.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/Makefile                  |    2 +-
 fs/hot_tracking.c            |  138 ++++++++++++++++++++++++++++++++++++++++++
 fs/hot_tracking.h            |   26 ++++++++
 include/linux/hot_tracking.h |   74 ++++++++++++++++++++++
 4 files changed, 239 insertions(+), 1 deletions(-)
 create mode 100644 fs/hot_tracking.c
 create mode 100644 fs/hot_tracking.h
 create mode 100644 include/linux/hot_tracking.h

diff --git a/fs/Makefile b/fs/Makefile
index 1d7af79..f966dea 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -11,7 +11,7 @@ obj-y :=	open.o read_write.o file_table.o super.o \
 		attr.o bad_inode.o file.o filesystems.o namespace.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o drop_caches.o splice.o sync.o utimes.o \
-		stack.o fs_struct.o statfs.o
+		stack.o fs_struct.o statfs.o hot_tracking.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o bio.o block_dev.o direct-io.o mpage.o ioprio.o
diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
new file mode 100644
index 0000000..634ec03
--- /dev/null
+++ b/fs/hot_tracking.c
@@ -0,0 +1,138 @@
+/*
+ * fs/hot_tracking.c
+ *
+ * Copyright (C) 2012 IBM Corp. All rights reserved.
+ * Written by Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ */
+
+#include <linux/list.h>
+#include <linux/err.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/hardirq.h>
+#include <linux/fs.h>
+#include <linux/blkdev.h>
+#include <linux/types.h>
+#include <linux/limits.h>
+#include "hot_tracking.h"
+
+/* kmem_cache pointers for slab caches */
+static struct kmem_cache *hot_inode_item_cachep;
+static struct kmem_cache *hot_range_item_cachep;
+
+/*
+ * Initialize the inode tree. Should be called for each new inode
+ * access or other user of the hot_inode interface.
+ */
+static void hot_inode_tree_init(struct hot_info *root)
+{
+	INIT_RADIX_TREE(&root->hot_inode_tree, GFP_ATOMIC);
+	spin_lock_init(&root->lock);
+}
+
+/*
+ * Initialize the hot range tree. Should be called for each new inode
+ * access or other user of the hot_range interface.
+ */
+void hot_range_tree_init(struct hot_inode_item *he)
+{
+	INIT_RADIX_TREE(&he->hot_range_tree, GFP_ATOMIC);
+	spin_lock_init(&he->lock);
+}
+
+/*
+ * Initialize a new hot_range_item structure. The new structure is
+ * returned with a reference count of one and needs to be
+ * freed using free_range_item()
+ */
+static void hot_range_item_init(struct hot_range_item *hr, u32 start,
+				struct hot_inode_item *he)
+{
+	hr->start = start;
+	hr->len = RANGE_SIZE;
+	hr->hot_inode = he;
+	kref_init(&hr->hot_range.refs);
+	spin_lock_init(&hr->hot_range.lock);
+	hr->hot_range.hot_freq_data.avg_delta_reads = (u64) -1;
+	hr->hot_range.hot_freq_data.avg_delta_writes = (u64) -1;
+	hr->hot_range.hot_freq_data.flags = FREQ_DATA_TYPE_RANGE;
+}
+
+/*
+ * Initialize a new hot_inode_item structure. The new structure is
+ * returned with a reference count of one and needs to be
+ * freed using hot_free_inode_item()
+ */
+static void hot_inode_item_init(struct hot_inode_item *he, u64 ino,
+				struct radix_tree_root *hot_inode_tree)
+{
+	he->i_ino = ino;
+	he->hot_inode_tree = hot_inode_tree;
+	kref_init(&he->hot_inode.refs);
+	spin_lock_init(&he->hot_inode.lock);
+	he->hot_inode.hot_freq_data.avg_delta_reads = (u64) -1;
+	he->hot_inode.hot_freq_data.avg_delta_writes = (u64) -1;
+	he->hot_inode.hot_freq_data.flags = FREQ_DATA_TYPE_INODE;
+	hot_range_tree_init(he);
+}
+
+/*
+ * Initialize kmem cache for hot_inode_item and hot_range_item.
+ */
+static int __init hot_cache_init(void)
+{
+	hot_inode_item_cachep = kmem_cache_create("hot_inode_item",
+			sizeof(struct hot_inode_item), 0,
+			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
+			NULL);
+	if (!hot_inode_item_cachep)
+		goto inode_err;
+
+	hot_range_item_cachep = kmem_cache_create("hot_range_item",
+			sizeof(struct hot_range_item), 0,
+			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
+			NULL);
+	if (!hot_range_item_cachep)
+		goto range_err;
+
+	return 0;
+
+range_err:
+	kmem_cache_destroy(hot_inode_item_cachep);
+inode_err:
+	return -ENOMEM;
+}
+
+static inline void hot_cache_exit(void)
+{
+	if (hot_range_item_cachep)
+		kmem_cache_destroy(hot_range_item_cachep);
+
+	if (hot_inode_item_cachep)
+		kmem_cache_destroy(hot_inode_item_cachep);
+}
+
+/*
+ * Initialize the data structures for hot data tracking.
+ */
+void hot_track_init(struct super_block *sb)
+{
+	int err;
+
+	err = hot_cache_init();
+	if (err) {
+		printk(KERN_ERR "%s: hot_track_cache_init error: %d\n",
+				__func__, err);
+		return;
+	}
+}
+
+void hot_track_exit(struct super_block *sb)
+{
+	hot_cache_exit();
+}
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
new file mode 100644
index 0000000..4e8aa77
--- /dev/null
+++ b/fs/hot_tracking.h
@@ -0,0 +1,26 @@
+/*
+ * fs/hot_tracking.h
+ *
+ * Copyright (C) 2012 IBM Corp. All rights reserved.
+ * Written by Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ */
+
+#ifndef __HOT_TRACKING__
+#define __HOT_TRACKING__
+
+#include <linux/radix-tree.h>
+#include <linux/workqueue.h>
+#include <linux/hot_tracking.h>
+
+/* values for hot_freq_data flags */
+#define FREQ_DATA_TYPE_INODE (1 << 0)
+#define FREQ_DATA_TYPE_RANGE (1 << 1)
+
+void hot_track_init(struct super_block *sb);
+void hot_track_exit(struct super_block *sb);
+
+#endif /* __HOT_TRACKING__ */
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
new file mode 100644
index 0000000..78adb0d
--- /dev/null
+++ b/include/linux/hot_tracking.h
@@ -0,0 +1,74 @@
+/*
+ *  include/linux/hot_tracking.h
+ *
+ * This file has definitions for VFS hot data tracking
+ * structures etc.
+ *
+ * Copyright (C) 2012 IBM Corp. All rights reserved.
+ * Written by Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ */
+
+#ifndef _LINUX_HOTTRACK_H
+#define _LINUX_HOTTRACK_H
+
+#include <linux/types.h>
+#include <linux/rbtree.h>
+#include <linux/kref.h>
+#include <linux/fs.h>
+
+/*
+ * A frequency data struct holds values that are used to
+ * determine temperature of files and file ranges. These structs
+ * are members of hot_inode_item and hot_range_item
+ */
+struct hot_freq_data {
+	struct timespec last_read_time;
+	struct timespec last_write_time;
+	u32 nr_reads;
+	u32 nr_writes;
+	u64 avg_delta_reads;
+	u64 avg_delta_writes;
+	u32 flags;
+	u32 last_temperature;
+};
+
+/* The common info for both following structures */
+struct hot_comm_item {
+	struct hot_freq_data hot_freq_data;  /* frequency data */
+	spinlock_t lock; /* protects object data */
+	struct kref refs;  /* prevents kfree */
+};
+
+/* An item representing an inode and its access frequency */
+struct hot_inode_item {
+	struct hot_comm_item hot_inode; /* node in hot_inode_tree */
+	struct radix_tree_root hot_range_tree; /* tree of ranges */
+	spinlock_t lock; /* protect range tree */
+	struct radix_tree_root *hot_inode_tree;
+	u64 i_ino; /* inode number from inode */
+};
+
+/*
+ * An item representing a range inside of
+ * an inode whose frequency is being tracked
+ */
+struct hot_range_item {
+	struct hot_comm_item hot_range;
+	struct hot_inode_item *hot_inode; /* associated hot_inode_item */
+	u32 start; /* item index in hot_range_tree */
+	u32 len; /* length in bytes */
+};
+
+struct hot_info {
+	struct radix_tree_root hot_inode_tree;
+	spinlock_t lock; /*protect inode tree */
+};
+
+extern void hot_track_init(struct super_block *sb);
+extern void hot_track_exit(struct super_block *sb);
+
+#endif  /* _LINUX_HOTTRACK_H */
-- 
1.7.6.5
