From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 1/6] ext4: add two structures supporting status extent tree
Date: Wed, 18 Apr 2012 00:07:13 -0700
Message-ID: <1334732838-25102-2-git-send-email-achender@linux.vnet.ibm.com>
References: <1334732838-25102-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:57028 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab2DRHHP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 18 Apr 2012 03:07:15 -0400
Received: from /spool/local
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Wed, 18 Apr 2012 01:07:13 -0600
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 8B7793E4004F
	for <linux-ext4@vger.kernel.org>; Wed, 18 Apr 2012 01:06:06 -0600 (MDT)
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q3I766VG166864
	for <linux-ext4@vger.kernel.org>; Wed, 18 Apr 2012 01:06:06 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q3I76bQg005385
	for <linux-ext4@vger.kernel.org>; Wed, 18 Apr 2012 01:06:38 -0600
In-Reply-To: <1334732838-25102-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds two structures that supports status extent tree and
status_extent_info to inode_info.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100644 100644 1bbd2ca... 704021e... M	fs/ext4/ext4.h
:000000 100644 0000000... cbf96ed... A	fs/ext4/status_extents.h
 fs/ext4/ext4.h           |    5 +++++
 fs/ext4/status_extents.h |   22 ++++++++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1bbd2ca..704021e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -782,6 +782,8 @@ struct ext4_ext_cache {
 	__u32		ec_len; /* must be 32bit to return holes */
 };
 
+#include "status_extents.h"
+
 /*
  * fourth extended file system inode data in memory
  */
@@ -859,6 +861,9 @@ struct ext4_inode_info {
 	struct list_head i_prealloc_list;
 	spinlock_t i_prealloc_lock;
 
+	/* delayed extents */
+	struct ext4_se_tree i_se_tree;
+
 	/* ialloc */
 	ext4_group_t	i_last_alloc_group;
 
diff --git a/fs/ext4/status_extents.h b/fs/ext4/status_extents.h
new file mode 100644
index 0000000..cbf96ed
--- /dev/null
+++ b/fs/ext4/status_extents.h
@@ -0,0 +1,22 @@
+/*
+ *  fs/ext4/status_extents.h
+ *
+ * Written by Yongqiang Yang <xiaoqiangnk@gmail.com>
+ *
+ */
+
+#ifndef _EXT4_STATUS_EXTENTS_H
+#define _EXT4_STATUS_EXTENTS_H
+
+struct status_extent {
+	struct rb_node rb_node;
+	ext4_lblk_t start;	/* first block extent covers */
+	ext4_lblk_t len;	/* length of extent in block */
+};
+
+struct ext4_se_tree {
+	struct rb_root root;
+	struct status_extent *cache_se;	/* recently accessed extent */
+};
+
+#endif /* _EXT4_STATUS_EXTENTS_H */
-- 
1.7.1

