From: amir73il@users.sourceforge.net
Subject: [PATCH RFC 02/30] ext4: snapshot debugging support
Date: Mon,  9 May 2011 19:41:20 +0300
Message-ID: <1304959308-11122-3-git-send-email-amir73il@users.sourceforge.net>
References: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
Cc: tytso@mit.edu, Amir Goldstein <amir73il@users.sf.net>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33538 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab1EIQmo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 May 2011 12:42:44 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so4026020wya.19
        for <linux-ext4@vger.kernel.org>; Mon, 09 May 2011 09:42:44 -0700 (PDT)
In-Reply-To: <1304959308-11122-1-git-send-email-amir73il@users.sourceforge.net>
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
 fs/ext4/snapshot_debug.h |  105 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 118 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index 16a779d..9981306 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -21,3 +21,4 @@ ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+= acl.o
 ext4-$(CONFIG_EXT4_FS_SECURITY)		+= xattr_security.o
 ext4-$(CONFIG_EXT4_FS_SNAPSHOT)		+= snapshot.o snapshot_ctl.o
 ext4-$(CONFIG_EXT4_FS_SNAPSHOT)		+= snapshot_inode.o snapshot_buffer.o
+ext4-$(CONFIG_EXT4_FS_SNAPSHOT)		+= snapshot_debug.o
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 4952b7b..42961bf 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2657,10 +2657,13 @@ static void __init ext4_create_debugfs_entry(void)
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
index a927090..52bfa52 100644
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
1.7.0.4

