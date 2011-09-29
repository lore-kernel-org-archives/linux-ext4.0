From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [RFC PATCH V2 1/6] ext4: add two structures supporting delayed extent tree
Date: Thu, 29 Sep 2011 13:08:41 +0800
Message-ID: <1317272926-13303-2-git-send-email-xiaoqiangnk@gmail.com>
References: <1317272926-13303-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: jack@suse.cz, jeff.liu@oracle.com, achender@linux.vnet.ibm.com,
	adityakali@google.com, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61452 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597Ab1I2Gl3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 29 Sep 2011 02:41:29 -0400
Received: by yxl31 with SMTP id 31so323102yxl.19
        for <linux-ext4@vger.kernel.org>; Wed, 28 Sep 2011 23:41:29 -0700 (PDT)
In-Reply-To: <1317272926-13303-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds two structures that supports delayed extent tree.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/delayed_extents.h |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)
 create mode 100644 fs/ext4/delayed_extents.h

diff --git a/fs/ext4/delayed_extents.h b/fs/ext4/delayed_extents.h
new file mode 100644
index 0000000..66d6390
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
+	ext4_lblk_t len;	/* length of extent ib block */
+};
+
+struct ext4_de_tree {
+	struct rb_root root;
+	struct delayed_extent *cache_de;	/* recently accessed extent */
+};
+
+#endif /* _EXT4_DELAYED_EXTENTS_H */
-- 
1.7.5.1

