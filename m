From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 1/6] Rename de patch1 from de to se scheme
Date: Fri,  9 Mar 2012 21:41:20 -0700
Message-ID: <1331354485-18515-2-git-send-email-achender@linux.vnet.ibm.com>
References: <1331354485-18515-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org, xiaoqiangnk@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:56866 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460Ab2CJElS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 9 Mar 2012 23:41:18 -0500
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <achender@linux.vnet.ibm.com>;
	Fri, 9 Mar 2012 21:41:18 -0700
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 9DB45C90057
	for <linux-ext4@vger.kernel.org>; Fri,  9 Mar 2012 23:40:50 -0500 (EST)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q2A4eoUp265822
	for <linux-ext4@vger.kernel.org>; Fri, 9 Mar 2012 23:40:50 -0500
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q2A4enP5030470
	for <linux-ext4@vger.kernel.org>; Fri, 9 Mar 2012 21:40:49 -0700
In-Reply-To: <1331354485-18515-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch renames changes introduced by patch
"[PATCH_V3_1_6]ext4_add_two_structures_supporting_delayed_extent_tree"

All code referencing "delayed extents" or "de" are changed to
"status extents" or "se"

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100644 000000 cfd122e... 0000000... D	fs/ext4/delayed_extents.h
:100644 100644 f908208... 896f2fb... M	fs/ext4/ext4.h
:000000 100644 0000000... cbf96ed... A	fs/ext4/status_extents.h
 fs/ext4/delayed_extents.h |   40 ----------------------------------------
 fs/ext4/ext4.h            |    4 ++--
 fs/ext4/status_extents.h  |   22 ++++++++++++++++++++++
 3 files changed, 24 insertions(+), 42 deletions(-)

diff --git a/fs/ext4/delayed_extents.h b/fs/ext4/delayed_extents.h
deleted file mode 100644
index cfd122e..0000000
--- a/fs/ext4/delayed_extents.h
+++ /dev/null
@@ -1,40 +0,0 @@
-/*
- *  fs/ext4/delayed_extents.h
- *
- * Written by Yongqiang Yang <xiaoqiangnk@gmail.com>
- *
- */
-
-#ifndef _EXT4_DELAYED_EXTENTS_H
-#define _EXT4_DELAYED_EXTENTS_H
-
-#define DE_DEBUG
-#ifdef DE_DEBUG
-#define de_debug(a...)		printk(a)
-#else
-#define de_debug(a...)
-#endif
-
-struct delayed_extent {
-	struct rb_node rb_node;
-	ext4_lblk_t start;	/* first block extent covers */
-	ext4_lblk_t len;	/* length of extent in block */
-};
-
-struct ext4_de_tree {
-	struct rb_root root;
-	struct delayed_extent *cache_de;	/* recently accessed extent */
-};
-
-extern int __init ext4_init_de(void);
-extern void ext4_exit_de(void);
-extern void ext4_de_init_tree(struct ext4_de_tree *tree);
-
-extern int ext4_de_add_space(struct inode *inode, ext4_lblk_t start,
-				ext4_lblk_t len);
-extern int ext4_de_remove_space(struct inode *inode, ext4_lblk_t start,
-				ext4_lblk_t len);
-extern ext4_lblk_t ext4_de_find_extent(struct inode *inode,
-				struct delayed_extent *de);
-
-#endif /* _EXT4_DELAYED_EXTENTS_H */
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index f908208..896f2fb 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -782,7 +782,7 @@ struct ext4_ext_cache {
 	__u32		ec_len; /* must be 32bit to return holes */
 };
 
-#include "delayed_extents.h"
+#include "status_extents.h"
 
 /*
  * fourth extended file system inode data in memory
@@ -862,7 +862,7 @@ struct ext4_inode_info {
 	spinlock_t i_prealloc_lock;
 
 	/* delayed extents */
-	struct ext4_de_tree i_de_tree;
+	struct ext4_se_tree i_se_tree;
 
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

