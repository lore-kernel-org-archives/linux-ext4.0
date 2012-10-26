From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 1/8 v3] ext4: add two structures supporting extent status tree
Date: Fri, 26 Oct 2012 21:23:38 +0800
Message-ID: <1351257825-3701-2-git-send-email-wenqing.lz@taobao.com>
References: <1351257825-3701-1-git-send-email-wenqing.lz@taobao.com>
Cc: tytso@mit.edu, hughd@google.com, xiaoqiangnk@gmail.com,
	achender@linux.vnet.ibm.com, lczerner@redhat.com,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-ext4@vger.kernel.org, jeff.liu@oracle.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52319 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab2JZNMq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Oct 2012 09:12:46 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so1922583pad.19
        for <linux-ext4@vger.kernel.org>; Fri, 26 Oct 2012 06:12:46 -0700 (PDT)
In-Reply-To: <1351257825-3701-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

This patch adds two structures that supports extent status tree, extent_status
and ext4_es_tree.  Currently extent_status is used to track a delay extent for
an inode, which record the start block and the length of the delay extent.
ext4_es_tree is used to store all extent_status for an inode in memory.

CC: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
v3 <- v2:
 - add i_es_lock to protect extent status tree

 fs/ext4/ext4.h           |  6 ++++++
 fs/ext4/extents_status.h | 25 +++++++++++++++++++++++++
 2 files changed, 31 insertions(+)
 create mode 100644 fs/ext4/extents_status.h

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3c20de1..bcc634b 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -811,6 +811,8 @@ struct ext4_ext_cache {
 	__u32		ec_len; /* must be 32bit to return holes */
 };
 
+#include "extents_status.h"
+
 /*
  * fourth extended file system inode data in memory
  */
@@ -888,6 +890,10 @@ struct ext4_inode_info {
 	struct list_head i_prealloc_list;
 	spinlock_t i_prealloc_lock;
 
+	/* extents status tree */
+	struct ext4_es_tree i_es_tree;
+	rwlock_t i_es_lock;
+
 	/* ialloc */
 	ext4_group_t	i_last_alloc_group;
 
diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
new file mode 100644
index 0000000..8be2ab9
--- /dev/null
+++ b/fs/ext4/extents_status.h
@@ -0,0 +1,25 @@
+/*
+ *  fs/ext4/extents_status.h
+ *
+ * Written by Yongqiang Yang <xiaoqiangnk@gmail.com>
+ * Modified by
+ *	Allison Henderson <achender@linux.vnet.ibm.com>
+ *	Zheng Liu <wenqing.lz@taobao.com>
+ *
+ */
+
+#ifndef _EXT4_EXTENTS_STATUS_H
+#define _EXT4_EXTENTS_STATUS_H
+
+struct extent_status {
+	struct rb_node rb_node;
+	ext4_lblk_t start;	/* first block extent covers */
+	ext4_lblk_t len;	/* length of extent in block */
+};
+
+struct ext4_es_tree {
+	struct rb_root root;
+	struct extent_status *cache_es;	/* recently accessed extent */
+};
+
+#endif /* _EXT4_EXTENTS_STATUS_H */
-- 
1.7.12.rc2.18.g61b472e

