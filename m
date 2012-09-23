From: zwu.kernel@gmail.com
Subject: [RFC v2 04/10] vfs: add init and exit support
Date: Sun, 23 Sep 2012 20:56:29 +0800
Message-ID: <1348404995-14372-5-git-send-email-zwu.kernel@gmail.com>
References: <1348404995-14372-1-git-send-email-zwu.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, linuxram@linux.vnet.ibm.com,
	viro@zeniv.linux.org.uk, cmm@us.ibm.com, tytso@mit.edu,
	marco.stornelli@gmail.com, david@fromorbit.com,
	stroetmann@ontolinux.com, diegocg@gmail.com, chris@csamuel.org,
	Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:54634 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab2IWM5V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 23 Sep 2012 08:57:21 -0400
Received: from /spool/local
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <zwu.kernel@gmail.com>;
	Sun, 23 Sep 2012 06:57:20 -0600
In-Reply-To: <1348404995-14372-1-git-send-email-zwu.kernel@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

  Add initialization function to create some
key data structures when hot tracking is enabled;
Clean up them when hot tracking is disabled

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 fs/hot_tracking.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/hot_tracking.h |    2 +
 fs/namespace.c    |    4 +++
 fs/super.c        |    6 +++++
 4 files changed, 72 insertions(+), 0 deletions(-)

diff --git a/fs/hot_tracking.c b/fs/hot_tracking.c
index f97e8a6..fa89f70 100644
--- a/fs/hot_tracking.c
+++ b/fs/hot_tracking.c
@@ -135,6 +135,51 @@ static void hot_rb_free_hot_range_item(struct hot_range_item *hr)
 	}
 }
 
+static int hot_rb_remove_hot_inode_item(struct hot_inode_tree *tree,
+                                struct hot_inode_item *he)
+{
+        int ret = 0;
+        rb_erase(&he->rb_node, &tree->map);
+        he->in_tree = 0;
+        return ret;
+}
+
+static int hot_rb_remove_hot_range_item(struct hot_range_tree *tree,
+                                struct hot_range_item *hr)
+{
+        int ret = 0;
+        rb_erase(&hr->rb_node, &tree->map);
+        hr->in_tree = 0;
+        return ret;
+}
+
+/* Frees the entire hot_inode_tree. */
+static void hot_rb_inode_tree_free(struct hot_info *root)
+{
+	struct rb_node *node, *node2;
+	struct hot_inode_item *he;
+	struct hot_range_item *hr;
+
+	/* Free hot inode and range trees on fs root */
+	node = rb_first(&root->hot_inode_tree.map);
+
+	while (node) {
+		he = rb_entry(node, struct hot_inode_item, rb_node);
+
+		node2 = rb_first(&he->hot_range_tree.map);
+		while (node2) {
+			hr = rb_entry(node2, struct hot_range_item, rb_node);
+			hot_rb_remove_hot_range_item(&he->hot_range_tree, hr);
+			hot_rb_free_hot_range_item(hr);
+			node2 = rb_first(&he->hot_range_tree.map);
+		}
+
+		hot_rb_remove_hot_inode_item(&root->hot_inode_tree, he);
+		hot_rb_free_hot_inode_item(he);
+		node = rb_first(&root->hot_inode_tree.map);
+	}
+}
+
 static struct rb_node *hot_rb_insert_hot_inode_item(struct rb_root *root,
 						unsigned long inode_num,
 						struct rb_node *node)
@@ -507,3 +552,18 @@ void __init hot_track_cache_init(void)
 	if (hot_rb_item_cache_init())
 		return;
 }
+
+/*
+ * Initialize the data structures for hot data tracking.
+ */
+void hot_track_init(struct super_block *sb, const char *name)
+{
+	sb->s_hotinfo.mount_opt |= HOT_MOUNT_HOT_TRACK;
+	hot_rb_inode_tree_init(&sb->s_hotinfo.hot_inode_tree);
+}
+
+void hot_track_exit(struct super_block *sb)
+{
+	sb->s_hotinfo.mount_opt &= ~HOT_MOUNT_HOT_TRACK;
+	hot_rb_inode_tree_free(&sb->s_hotinfo);
+}
diff --git a/fs/hot_tracking.h b/fs/hot_tracking.h
index 6bd09eb..3a8d398 100644
--- a/fs/hot_tracking.h
+++ b/fs/hot_tracking.h
@@ -39,5 +39,7 @@ void hot_rb_update_freqs(struct inode *inode, u64 start, u64 len,
 
 bool hot_track_parse_options(char *options);
 void __init hot_track_cache_init(void);
+void hot_track_init(struct super_block *sb, const char *name);
+void hot_track_exit(struct super_block *sb);
 
 #endif /* __HOT_TRACKING__ */
diff --git a/fs/namespace.c b/fs/namespace.c
index 4d31f73..55006c8 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -20,6 +20,7 @@
 #include <linux/fs_struct.h>	/* get_fs_root et.al. */
 #include <linux/fsnotify.h>	/* fsnotify_vfsmount_delete */
 #include <linux/uaccess.h>
+#include "hot_tracking.h"
 #include "pnode.h"
 #include "internal.h"
 
@@ -1215,6 +1216,9 @@ static int do_umount(struct mount *mnt, int flags)
 		return retval;
 	}
 
+	if (sb->s_hotinfo.mount_opt & HOT_MOUNT_HOT_TRACK)
+		hot_track_exit(sb);
+
 	down_write(&namespace_sem);
 	br_write_lock(&vfsmount_lock);
 	event++;
diff --git a/fs/super.c b/fs/super.c
index 7eb3b0c..0999d5c 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1153,6 +1153,9 @@ mount_fs(struct file_system_type *type, int flags, const char *name, void *data)
 	WARN_ON(sb->s_bdi == &default_backing_dev_info);
 	sb->s_flags |= MS_BORN;
 
+	if (hottrack)
+		hot_track_init(sb, name);
+
 	error = security_sb_kern_mount(sb, flags, secdata);
 	if (error)
 		goto out_sb;
@@ -1170,6 +1173,9 @@ mount_fs(struct file_system_type *type, int flags, const char *name, void *data)
 	free_secdata(secdata);
 	return root;
 out_sb:
+	if (hottrack)
+		hot_track_exit(sb);
+
 	dput(root);
 	deactivate_locked_super(sb);
 out_free_secdata:
-- 
1.7.6.5

