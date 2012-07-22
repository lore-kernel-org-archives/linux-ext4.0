From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC][PATCH 01/10 v1][RESEND] ext4: add two structures supporting extent status tree
Date: Sun, 22 Jul 2012 15:59:37 +0800
Message-ID: <1342943986-12413-2-git-send-email-wenqing.lz@taobao.com>
References: <1342943986-12413-1-git-send-email-wenqing.lz@taobao.com>
Cc: xiaoqiangnk@gmail.com, achender@linux.vnet.ibm.com,
	wenqing.lz@taobao.com
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34290 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab2GVHvT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 22 Jul 2012 03:51:19 -0400
In-Reply-To: <1342943986-12413-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

This patch adds two structures that supports status extent tree and
status_extent_info to inode_info.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/ext4.h           |    5 +++++
 fs/ext4/extents_status.h |   22 ++++++++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)
 create mode 100644 fs/ext4/extents_status.h

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index cfc4e01..c0fe23e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -810,6 +810,8 @@ struct ext4_ext_cache {
 	__u32		ec_len; /* must be 32bit to return holes */
 };
 
+#include "extents_status.h"
+
 /*
  * fourth extended file system inode data in memory
  */
@@ -887,6 +889,9 @@ struct ext4_inode_info {
 	struct list_head i_prealloc_list;
 	spinlock_t i_prealloc_lock;
 
+	/* extents status tree */
+	struct ext4_es_tree i_es_tree;
+
 	/* ialloc */
 	ext4_group_t	i_last_alloc_group;
 
diff --git a/fs/ext4/extents_status.h b/fs/ext4/extents_status.h
new file mode 100644
index 0000000..d87fd71
--- /dev/null
+++ b/fs/ext4/extents_status.h
@@ -0,0 +1,22 @@
+/*
+ *  fs/ext4/extents_status.h
+ *
+ * Written by Yongqiang Yang <xiaoqiangnk@gmail.com>
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
1.7.4.1

