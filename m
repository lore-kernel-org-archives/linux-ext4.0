From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH V3 1/6] ext4: add two structures supporting delayed extent tree
Date: Mon, 31 Oct 2011 08:55:42 +0800
Message-ID: <1320022547-2284-2-git-send-email-xiaoqiangnk@gmail.com>
References: <1320022547-2284-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58444 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab1JaDAA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 30 Oct 2011 23:00:00 -0400
Received: by mail-iy0-f174.google.com with SMTP id y12so6677937iab.19
        for <linux-ext4@vger.kernel.org>; Sun, 30 Oct 2011 20:00:00 -0700 (PDT)
In-Reply-To: <1320022547-2284-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds two structures that supports delayed extent tree and
delayed_extent_info to inode_info.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/delayed_extents.h |   22 ++++++++++++++++++++++
 fs/ext4/ext4.h            |    5 +++++
 2 files changed, 27 insertions(+), 0 deletions(-)
 create mode 100644 fs/ext4/delayed_extents.h

diff --git a/fs/ext4/delayed_extents.h b/fs/ext4/delayed_extents.h
new file mode 100644
index 0000000..5436cad
--- /dev/null
+++ b/fs/ext4/delayed_extents.h
@@ -0,0 +1,22 @@
+/*
+ *  fs/ext4/delayed_extents.h
+ *
+ * Written by Yongqiang Yang <xiaoqiangnk@gmail.com>
+ *
+ */
+
+#ifndef _EXT4_DELAYED_EXTENTS_H
+#define _EXT4_DELAYED_EXTENTS_H
+
+struct delayed_extent {
+	struct rb_node rb_node;
+	ext4_lblk_t start;	/* first block extent covers */
+	ext4_lblk_t len;	/* length of extent in block */
+};
+
+struct ext4_de_tree {
+	struct rb_root root;
+	struct delayed_extent *cache_de;	/* recently accessed extent */
+};
+
+#endif /* _EXT4_DELAYED_EXTENTS_H */
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 657e826..72c6b1e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -778,6 +778,8 @@ struct ext4_ext_cache {
 	__u32		ec_len; /* must be 32bit to return holes */
 };
 
+#include "delayed_extents.h"
+
 /*
  * fourth extended file system inode data in memory
  */
@@ -855,6 +857,9 @@ struct ext4_inode_info {
 	struct list_head i_prealloc_list;
 	spinlock_t i_prealloc_lock;
 
+	/* delayed extents */
+	struct ext4_de_tree i_de_tree;
+
 	/* ialloc */
 	ext4_group_t	i_last_alloc_group;
 
-- 
1.7.5.1

