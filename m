From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [RFC PATCH 1/5] ext4: add two structures delayed extent list nees
Date: Tue, 30 Aug 2011 17:00:17 +0800
Message-ID: <1314694821-17213-2-git-send-email-xiaoqiangnk@gmail.com>
References: <1314694821-17213-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: achender@linux.vnet.ibm.com, adityakali@google.com, tytso@mit.edu,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:38263 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab1H3Jnj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Aug 2011 05:43:39 -0400
Received: by mail-pz0-f42.google.com with SMTP id 37so10017235pzk.1
        for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2011 02:43:39 -0700 (PDT)
In-Reply-To: <1314694821-17213-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds two structures that delayed extent list needs.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/delayed_extents.h |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)
 create mode 100644 fs/ext4/delayed_extents.h

diff --git a/fs/ext4/delayed_extents.h b/fs/ext4/delayed_extents.h
new file mode 100644
index 0000000..b7baaef
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
+struct ext4_delayed_extent {
+	struct list_head de_list;
+	ext4_lblk_t de_start;	/* first block extent covers */
+	ext4_lblk_t de_end;	/* block at which extent ends */
+};
+
+struct ext4_delayed_info {
+	struct list_head de_list;
+	struct ext4_delayed_extent *cache_de;	/* recently accessed extent */
+};
+
+#endif /* _EXT4_DELAYED_EXTENTS_H */
-- 
1.7.5.1

