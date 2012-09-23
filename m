From: zwu.kernel@gmail.com
Subject: [RFC v2 01/10] vfs: introduce private rb structures
Date: Sun, 23 Sep 2012 20:56:26 +0800
Message-ID: <1348404995-14372-2-git-send-email-zwu.kernel@gmail.com>
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

  One root structure hot_info is defined, is hooked
up in super_block, and will be used to hold rb trees
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
 fs/dcache.c                  |    2 +
 fs/hot_tracking.c            |  116 ++++++++++++++++++++++++++++++++++++++++++
 fs/hot_tracking.h            |   27 ++++++++++
 include/linux/fs.h           |    4 ++
 include/linux/hot_tracking.h |   96 ++++++++++++++++++++++++++++++++++
 6 files changed, 246 insertions(+), 1 deletions(-)
 create mode 100644 fs/hot_tracking.c
 create mode 100644 fs/hot_tracking.h
 create mode 100644 include/linux/hot_tracking.h

diff --git a/fs/Makefile b/fs/Makefile
index 2fb9779..9d29618 100644
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
diff --git a/fs/dcache.c b/fs/dcache.c
index 8086636..92470a1 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -37,6 +37,7 @@
 #include <linux/rculist_bl.h>
 #include <linux/prefetch.h>
 #include <linux/ratelimit.h>
+#include "hot_tracking.h"
 #include "internal.h"
 #include "mount.h"
 
@@ -3164,6 +3165,7 @@ void __init vfs_caches_init(unsigned long mempages)
 	inode_init();
 	files_init(mempages);
 	mnt_init();
+	hot_track_cache_init();
 	bdev_cache_init();
 	chrdev_init();
 }
diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
new file mode 100644
index 0000000..173054b
--- /dev/null
+++ b/fs/hot_tracking.c
@@ -0,0 +1,116 @@
+/*
+ * fs/hot_tracking.c
+ *
+ * Copyright (C) 2012 IBM Corp. All rights reserved.
+ * Written by Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
+ *            Ben Chociej <bchociej@gmail.com>
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
+#include "hot_tracking.h"
+
+/* kmem_cache pointers for slab caches */
+static struct kmem_cache *hot_inode_item_cache;
+static struct kmem_cache *hot_range_item_cache;
+
+/*
+ * Initialize the inode tree. Should be called for each new inode
+ * access or other user of the hot_inode interface.
+ */
+static void hot_rb_inode_tree_init(struct hot_inode_tree *tree)
+{
+	tree->map = RB_ROOT;
+	rwlock_init(&tree->lock);
+}
+
+/*
+ * Initialize the hot range tree. Should be called for each new inode
+ * access or other user of the hot_range interface.
+ */
+void hot_rb_range_tree_init(struct hot_range_tree *tree)
+{
+	tree->map = RB_ROOT;
+	rwlock_init(&tree->lock);
+}
+
+/*
+ * Initialize a new hot_inode_item structure. The new structure is
+ * returned with a reference count of one and needs to be
+ * freed using free_inode_item()
+ */
+void hot_rb_inode_item_init(void *_item)
+{
+	struct hot_inode_item *he = _item;
+
+	memset(he, 0, sizeof(*he));
+	kref_init(&he->refs);
+	spin_lock_init(&he->lock);
+	he->hot_freq_data.avg_delta_reads = (u64) -1;
+	he->hot_freq_data.avg_delta_writes = (u64) -1;
+	he->hot_freq_data.flags = FREQ_DATA_TYPE_INODE;
+	hot_rb_range_tree_init(&he->hot_range_tree);
+}
+
+/*
+ * Initialize a new hot_range_item structure. The new structure is
+ * returned with a reference count of one and needs to be
+ * freed using free_range_item()
+ */
+static void hot_rb_range_item_init(void *_item)
+{
+	struct hot_range_item *hr = _item;
+
+	memset(hr, 0, sizeof(*hr));
+	kref_init(&hr->refs);
+	spin_lock_init(&hr->lock);
+	hr->hot_freq_data.avg_delta_reads = (u64) -1;
+	hr->hot_freq_data.avg_delta_writes = (u64) -1;
+	hr->hot_freq_data.flags = FREQ_DATA_TYPE_RANGE;
+}
+
+/* init hot_inode_item and hot_range_item kmem cache */
+static int __init hot_rb_item_cache_init(void)
+{
+	hot_inode_item_cache = kmem_cache_create("hot_inode_item",
+			sizeof(struct hot_inode_item), 0,
+			SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
+			hot_rb_inode_item_init);
+	if (!hot_inode_item_cache)
+		goto inode_err;
+
+	hot_range_item_cache = kmem_cache_create("hot_range_item",
+					sizeof(struct hot_range_item), 0,
+					SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD,
+					hot_rb_range_item_init);
+	if (!hot_range_item_cache)
+		goto range_err;
+
+	return 0;
+
+range_err:
+	kmem_cache_destroy(hot_inode_item_cache);
+inode_err:
+	return -ENOMEM;
+}
+
+/*
+ * Initialize kmem cache for hot_inode_item
+ * and hot_range_item
+ */
+void __init hot_track_cache_init(void)
+{
+	if (hot_rb_item_cache_init())
+		return;
+}
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
new file mode 100644
index 0000000..269b67a
--- /dev/null
+++ b/fs/hot_tracking.h
@@ -0,0 +1,27 @@
+/*
+ * fs/hot_tracking.h
+ *
+ * Copyright (C) 2012 IBM Corp. All rights reserved.
+ * Written by Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
+ *            Ben Chociej <bchociej@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ */
+
+#ifndef __HOT_TRACKING__
+#define __HOT_TRACKING__
+
+#include <linux/rbtree.h>
+#include <linux/hot_tracking.h>
+
+/* values for hot_freq_data flags */
+/* freq data struct is for an inode */
+#define FREQ_DATA_TYPE_INODE (1 << 0)
+/* freq data struct is for a range */
+#define FREQ_DATA_TYPE_RANGE (1 << 1)
+
+void __init hot_track_cache_init(void);
+
+#endif /* __HOT_TRACKING__ */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index aa11047..db1a144 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -415,6 +415,7 @@ struct inodes_stat_t {
 #include <linux/migrate_mode.h>
 #include <linux/uidgid.h>
 #include <linux/lockdep.h>
+#include <linux/hot_tracking.h>
 
 #include <asm/byteorder.h>
 
@@ -1578,6 +1579,9 @@ struct super_block {
 
 	/* Being remounted read-only */
 	int s_readonly_remount;
+
+	/* Hot data tracking info*/
+	struct hot_info s_hotinfo;
 };
 
 /* superblock cache pruning functions */
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
new file mode 100644
index 0000000..a566f91
--- /dev/null
+++ b/include/linux/hot_tracking.h
@@ -0,0 +1,96 @@
+/*
+ *  include/linux/hot_tracking.h
+ *
+ * This file has definitions for VFS hot data tracking
+ * structures etc.
+ *
+ * Copyright (C) 2012 IBM Corp. All rights reserved.
+ * Written by Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
+ *            Ben Chociej <bchociej@gmail.com>
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
+
+/* A tree that sits on the hot_info */
+struct hot_inode_tree {
+	struct rb_root map;
+	rwlock_t lock;
+};
+
+/* A tree of ranges for each inode in the hot_inode_tree */
+struct hot_range_tree {
+	struct rb_root map;
+	rwlock_t lock;
+};
+
+/* A frequency data struct holds values that are used to
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
+	u8 flags;
+	u32 last_temperature;
+};
+
+/* An item representing an inode and its access frequency */
+struct hot_inode_item {
+	/* node for hot_inode_tree rb_tree */
+	struct rb_node rb_node;
+	/* tree of ranges in this inode */
+	struct hot_range_tree hot_range_tree;
+	/* frequency data for this inode */
+	struct hot_freq_data hot_freq_data;
+	/* inode number, copied from inode */
+	unsigned long i_ino;
+	/* used to check for errors in ref counting */
+	u8 in_tree;
+	/* protects hot_freq_data, i_no, in_tree */
+	spinlock_t lock;
+	/* prevents kfree */
+	struct kref refs;
+};
+
+/*
+ * An item representing a range inside of an inode whose frequency
+ * is being tracked
+ */
+struct hot_range_item {
+	/* node for hot_range_tree rb_tree */
+	struct rb_node rb_node;
+	/* frequency data for this range */
+	struct hot_freq_data hot_freq_data;
+	/* the hot_inode_item associated with this hot_range_item */
+	struct hot_inode_item *hot_inode;
+	/* starting offset of this range */
+	u64 start;
+	/* length of this range */
+	u64 len;
+	/* used to check for errors in ref counting */
+	u8 in_tree;
+	/* protects hot_freq_data, start, len, and in_tree */
+	spinlock_t lock;
+	/* prevents kfree */
+	struct kref refs;
+};
+
+struct hot_info {
+	/* red-black tree that keeps track of fs-wide hot data */
+	struct hot_inode_tree hot_inode_tree;
+};
+
+#endif  /* _LINUX_HOTTRACK_H */
-- 
1.7.6.5

