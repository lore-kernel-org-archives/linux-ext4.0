From: zwu.kernel@gmail.com
Subject: [RFC v2 03/10] vfs: add one new mount option '-o hottrack'
Date: Sun, 23 Sep 2012 20:56:28 +0800
Message-ID: <1348404995-14372-4-git-send-email-zwu.kernel@gmail.com>
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

  Introduce one new mount option '-o hottrack',
and add its parsing support.
  Its usage looks like:
   mount -o hottrack
   mount -o nouser,hottrack
   mount -o nouser,hottrack,loop
   mount -o hottrack,nouser

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c            |   34 ++++++++++++++++++++++++++++++++++
 fs/hot_tracking.h            |    1 +
 fs/super.c                   |    5 +++++
 include/linux/hot_tracking.h |    7 +++++++
 4 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index 52ed926..f97e8a6 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -465,6 +465,40 @@ void hot_rb_update_freqs(struct inode *inode, u64 start,
 }
 
 /*
+ * Regular mount options parser for -hottrack option.
+ * return false if no -hottrack is specified;
+ * otherwise return true. And the -hottrack will be
+ * removed from options.
+ */
+bool hot_track_parse_options(char *options)
+{
+	long len;
+	char *p;
+	static char opts_hot[] = "hottrack";
+
+	if (!options)
+		return false;
+
+	p = strstr(options, opts_hot);
+	if (!p)
+		return false;
+
+	while (p) {
+		len = options + strlen(options) - (p + strlen(opts_hot));
+		if (len == 0) {
+			options[0] = '\0';
+			break;
+		}
+
+		memmove(p, p + strlen(opts_hot) + 1, len);
+		p = strstr(options, opts_hot);
+	}
+
+	printk(KERN_INFO "vfs: turning on hot data tracking\n");
+	return true;
+}
+
+/*
  * Initialize kmem cache for hot_inode_item
  * and hot_range_item
  */
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index 2ba29e4..6bd09eb 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -37,6 +37,7 @@ void hot_rb_free_hot_inode_item(struct hot_inode_item *he);
 void hot_rb_update_freqs(struct inode *inode, u64 start, u64 len,
 			int rw);
 
+bool hot_track_parse_options(char *options);
 void __init hot_track_cache_init(void);
 
 #endif /* __HOT_TRACKING__ */
diff --git a/fs/super.c b/fs/super.c
index 0902cfa..7eb3b0c 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -34,6 +34,7 @@
 #include <linux/cleancache.h>
 #include <linux/fsnotify.h>
 #include <linux/lockdep.h>
+#include "hot_tracking.h"
 #include "internal.h"
 
 
@@ -1125,6 +1126,7 @@ mount_fs(struct file_system_type *type, int flags, const char *name, void *data)
 	struct dentry *root;
 	struct super_block *sb;
 	char *secdata = NULL;
+	bool hottrack = false;
 	int error = -ENOMEM;
 
 	if (data && !(type->fs_flags & FS_BINARY_MOUNTDATA)) {
@@ -1137,6 +1139,9 @@ mount_fs(struct file_system_type *type, int flags, const char *name, void *data)
 			goto out_free_secdata;
 	}
 
+	if (data && hot_track_parse_options(data))
+		hottrack = true;
+
 	root = type->mount(type, flags, name, data);
 	if (IS_ERR(root)) {
 		error = PTR_ERR(root);
diff --git a/include/linux/hot_tracking.h b/include/linux/hot_tracking.h
index a566f91..bb2a41c 100644
--- a/include/linux/hot_tracking.h
+++ b/include/linux/hot_tracking.h
@@ -20,6 +20,11 @@
 #include <linux/rbtree.h>
 #include <linux/kref.h>
 
+/*
+ * Flags for hot data tracking mount options.
+ */
+#define HOT_MOUNT_HOT_TRACK		(1 << 0)
+
 /* A tree that sits on the hot_info */
 struct hot_inode_tree {
 	struct rb_root map;
@@ -89,6 +94,8 @@ struct hot_range_item {
 };
 
 struct hot_info {
+	unsigned long mount_opt;
+
 	/* red-black tree that keeps track of fs-wide hot data */
 	struct hot_inode_tree hot_inode_tree;
 };
-- 
1.7.6.5
