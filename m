From: amir73il@users.sourceforge.net
Subject: [PATCH v1 02/36] ext4: snapshot debugging support
Date: Tue,  7 Jun 2011 18:07:29 +0300
Message-ID: <1307459283-22130-3-git-send-email-amir73il@users.sourceforge.net>
References: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, lczerner@redhat.com,
	Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60303 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab1FGPJB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 7 Jun 2011 11:09:01 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so3629480wya.19
        for <linux-ext4@vger.kernel.org>; Tue, 07 Jun 2011 08:09:00 -0700 (PDT)
In-Reply-To: <1307459283-22130-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Amir Goldstein <amir73il@users.sf.net>

Control snapshot debug level via debugfs entry /ext4/snapshot-debug
and induce delay tests via debugfs entries /ext4/test-XXX-delay-msec.


Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/Makefile         |    1 +
 fs/ext4/mballoc.c        |    3 +
 fs/ext4/snapshot.h       |    9 ++++
 fs/ext4/snapshot_debug.c |  100 +++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/snapshot_debug.h |  105 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 218 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index a471c2e..1d947ef 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -13,3 +13,4 @@ ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+= acl.o
 ext4-$(CONFIG_EXT4_FS_SECURITY)		+= xattr_security.o
 ext4-$(CONFIG_EXT4_FS_SNAPSHOT)		+= snapshot.o snapshot_ctl.o
 ext4-$(CONFIG_EXT4_FS_SNAPSHOT)		+= snapshot_inode.o snapshot_buffer.o
+ext4-$(CONFIG_EXT4_FS_SNAPSHOT)		+= snapshot_debug.o
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 5a930d6..54ea8c8 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2658,10 +2658,13 @@ static void __init ext4_create_debugfs_entry(void)
 						  S_IRUGO | S_IWUSR,
 						  debugfs_dir,
 						  &mb_enable_debug);
+	if (debugfs_dir)
+		ext4_snapshot_create_debugfs_entry(debugfs_dir);
 }
 
 static void ext4_remove_debugfs_entry(void)
 {
+	ext4_snapshot_remove_debugfs_entry();
 	debugfs_remove(debugfs_debug);
 	debugfs_remove(debugfs_dir);
 }
diff --git a/fs/ext4/snapshot.h b/fs/ext4/snapshot.h
index 8a60ae1..d0c985b 100644
--- a/fs/ext4/snapshot.h
+++ b/fs/ext4/snapshot.h
@@ -18,6 +18,7 @@
 #include <linux/version.h>
 #include <linux/delay.h>
 #include "ext4.h"
+#include "snapshot_debug.h"
 
 
 /*
@@ -109,6 +110,14 @@
 static inline void snapshot_size_extend(struct inode *inode,
 			ext4_fsblk_t blocks)
 {
+#ifdef CONFIG_EXT4_DEBUG
+	ext4_fsblk_t old_blocks = SNAPSHOT_PROGRESS(inode);
+	ext4_fsblk_t max_blocks = SNAPSHOT_BLOCKS(inode);
+
+	/* sleep total of tunable delay unit over 100% progress */
+	snapshot_test_delay_progress(SNAPTEST_DELETE,
+			old_blocks, blocks, max_blocks);
+#endif
 	i_size_write((inode), (loff_t)(blocks) << SNAPSHOT_BLOCK_SIZE_BITS);
 }
 
diff --git a/fs/ext4/snapshot_debug.c b/fs/ext4/snapshot_debug.c
index e69de29..35f552a 100644
--- a/fs/ext4/snapshot_debug.c
+++ b/fs/ext4/snapshot_debug.c
@@ -0,0 +1,100 @@
+/*
+ * linux/fs/ext4/snapshot_debug.c
+ *
+ * Written by Amir Goldstein <amir73il@users.sf.net>, 2008
+ *
+ * Copyright (C) 2008-2011 CTERA Networks
+ *
+ * This file is part of the Linux kernel and is made available under
+ * the terms of the GNU General Public License, version 2, or at your
+ * option, any later version, incorporated herein by reference.
+ *
+ * Ext4 snapshot debugging.
+ */
+
+
+#include <linux/module.h>
+#include <linux/proc_fs.h>
+#include <linux/debugfs.h>
+#include "snapshot.h"
+
+#if defined(CONFIG_EXT4_FS_SNAPSHOT) && defined(CONFIG_EXT4_DEBUG)
+/*
+ * debugfs tunables
+ */
+
+const char *snapshot_indent = SNAPSHOT_INDENT_STR + SNAPSHOT_INDENT_MAX;
+
+/*
+ * Tunable delay values per snapshot operation for testing of
+ * COW race conditions and master snapshot_mutex lock
+ */
+static const char *snapshot_test_names[SNAPSHOT_TESTS_NUM] = {
+	/* delay completion of snapshot create|take */
+	"test-take-delay-msec",
+	/* delay completion of snapshot shrink|cleanup */
+	"test-delete-delay-msec",
+	/* delay completion of COW operation */
+	"test-cow-delay-msec",
+	/* delay submission of tracked read */
+	"test-read-delay-msec",
+	/* delay completion of COW bitmap operation */
+	"test-bitmap-delay-msec",
+};
+
+#define SNAPSHOT_TEST_NAMES (sizeof(snapshot_test_names) / \
+			     sizeof(snapshot_test_names[0]))
+
+u16 snapshot_enable_test[SNAPSHOT_TESTS_NUM] __read_mostly = {0};
+u8 snapshot_enable_debug __read_mostly = 1;
+
+static struct dentry *snapshot_debug;
+static struct dentry *snapshot_version;
+static struct dentry *snapshot_test[SNAPSHOT_TESTS_NUM];
+
+static char snapshot_version_str[] = EXT4_SNAPSHOT_VERSION;
+static struct debugfs_blob_wrapper snapshot_version_blob = {
+	.data = snapshot_version_str,
+	.size = sizeof(snapshot_version_str)
+};
+
+
+/*
+ * ext4_snapshot_create_debugfs_entry - register ext4 snapshot debug hooks
+ * Void function doesn't return error if debug hooks are not registered.
+ */
+void ext4_snapshot_create_debugfs_entry(struct dentry *debugfs_dir)
+{
+	int i;
+
+	BUG_ON(!debugfs_dir);
+	snapshot_debug = debugfs_create_u8("snapshot-debug", S_IRUGO|S_IWUSR,
+					   debugfs_dir,
+					   &snapshot_enable_debug);
+	snapshot_version = debugfs_create_blob("snapshot-version", S_IRUGO,
+					       debugfs_dir,
+					       &snapshot_version_blob);
+	for (i = 0; i < SNAPSHOT_TESTS_NUM && i < SNAPSHOT_TEST_NAMES; i++)
+		snapshot_test[i] = debugfs_create_u16(snapshot_test_names[i],
+					      S_IRUGO|S_IWUSR,
+					      debugfs_dir,
+					      &snapshot_enable_test[i]);
+}
+
+/*
+ * ext4_snapshot_remove_debugfs_entry - unregister ext4 snapshot debug hooks
+ * checks if the hooks have been registered before unregistering them.
+ */
+void ext4_snapshot_remove_debugfs_entry(void)
+{
+	int i;
+
+	for (i = 0; i < SNAPSHOT_TESTS_NUM && i < SNAPSHOT_TEST_NAMES; i++)
+		if (snapshot_test[i])
+			debugfs_remove(snapshot_test[i]);
+	if (snapshot_version)
+		debugfs_remove(snapshot_version);
+	if (snapshot_debug)
+		debugfs_remove(snapshot_debug);
+}
+#endif
diff --git a/fs/ext4/snapshot_debug.h b/fs/ext4/snapshot_debug.h
index e69de29..f893eb1 100644
--- a/fs/ext4/snapshot_debug.h
+++ b/fs/ext4/snapshot_debug.h
@@ -0,0 +1,105 @@
+/*
+ * linux/fs/ext4/snapshot_debug.h
+ *
+ * Written by Amir Goldstein <amir73il@users.sf.net>, 2008
+ *
+ * Copyright (C) 2008-2011 CTERA Networks
+ *
+ * This file is part of the Linux kernel and is made available under
+ * the terms of the GNU General Public License, version 2, or at your
+ * option, any later version, incorporated herein by reference.
+ *
+ * Ext4 snapshot debugging.
+ */
+
+#ifndef _LINUX_EXT4_SNAPSHOT_DEBUG_H
+#define _LINUX_EXT4_SNAPSHOT_DEBUG_H
+
+#if defined(CONFIG_EXT4_FS_SNAPSHOT) && defined(CONFIG_EXT4_DEBUG)
+#include <linux/delay.h>
+
+#define SNAPSHOT_INDENT_MAX 4
+#define SNAPSHOT_INDENT_STR "\t\t\t\t"
+
+#define SNAPTEST_TAKE	0
+#define SNAPTEST_DELETE	1
+#define SNAPTEST_COW	2
+#define SNAPTEST_READ	3
+#define SNAPTEST_BITMAP	4
+#define SNAPSHOT_TESTS_NUM	5
+
+extern const char *snapshot_indent;
+extern u8 snapshot_enable_debug;
+extern u16 snapshot_enable_test[SNAPSHOT_TESTS_NUM];
+extern u8 cow_cache_enabled;
+
+#define snapshot_test_delay(i)		     \
+	do {							       \
+		if (snapshot_enable_test[i])			       \
+			msleep_interruptible(snapshot_enable_test[i]); \
+	} while (0)
+
+/*
+ * Sleep 1ms every 'blocks_per_ms', amounting to the total test delay
+ * over 100% of progress (when 'to' reaches 'max').
+ * snapshot_enable_test[i] (msec) is limited to 64K and max (blocks_count)
+ * is likely much more than 64K, so 'blocks_per_ms' is likely non zero.
+ */
+#define snapshot_test_delay_progress(i, from, to, max)			\
+	do {								\
+		if (snapshot_enable_test[i] &&				\
+				(max) > snapshot_enable_test[i] &&	\
+				(from) <= (to) && (to) <= (max)) {	\
+			unsigned long blocks_per_ms =			\
+				do_div((max), snapshot_enable_test[i]);	\
+			unsigned long x = do_div((from), blocks_per_ms);\
+			unsigned long y = do_div((to), blocks_per_ms);	\
+			if (y > x)					\
+				msleep_interruptible(y - x);		\
+		}							\
+	} while (0)
+
+#define snapshot_debug_l(n, l, f, a...)					\
+	do {								\
+		if ((n) <= snapshot_enable_debug &&			\
+		    (l) <= SNAPSHOT_INDENT_MAX) {			\
+			printk(KERN_DEBUG "snapshot: %s" f,		\
+			       snapshot_indent - (l),			\
+				   ## a);				\
+		}							\
+	} while (0)
+
+#define snapshot_debug(n, f, a...)	snapshot_debug_l(n, 0, f, ## a)
+
+#define snapshot_debug_once(n, f, a...)					\
+	do {								\
+		static bool __once;					\
+		if (!__once) {						\
+			snapshot_debug(n, f, ## a);			\
+			__once = true;					\
+		}							\
+	} while (0)
+
+extern void ext4_snapshot_create_debugfs_entry(struct dentry *debugfs_dir);
+extern void ext4_snapshot_remove_debugfs_entry(void);
+
+#else
+#define snapshot_enable_debug (0)
+#define snapshot_test_delay(i)
+#define snapshot_test_delay_progress(i, from, to, max)
+#define snapshot_debug(n, f, a...)
+#define snapshot_debug_l(n, l, f, a...)
+#define snapshot_debug_once(n, f, a...)
+#define ext4_snapshot_create_debugfs_entry(d)
+#define ext4_snapshot_remove_debugfs_entry()
+#endif
+
+
+/* debug levels */
+#define SNAP_ERR	1 /* errors and summary */
+#define SNAP_WARN	2 /* warnings */
+#define SNAP_INFO	3 /* info */
+#define SNAP_DEBUG	4 /* debug */
+#define SNAP_DUMP	5 /* dump snapshot file */
+
+#endif	/* _LINUX_EXT4_SNAPSHOT_DEBUG_H */
-- 
1.7.4.1

