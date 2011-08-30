From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH v2 07/15] ext4: add a function which adds several group descriptors
Date: Tue, 30 Aug 2011 16:10:17 +0800
Message-ID: <1314691825-12295-8-git-send-email-xiaoqiangnk@gmail.com>
References: <1314691825-12295-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: adilger@dilger.ca, linux-ext4@vger.kernel.org,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:51065 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180Ab1H3IyA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Aug 2011 04:54:00 -0400
Received: by mail-pz0-f42.google.com with SMTP id 37so9952724pzk.1
        for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2011 01:54:00 -0700 (PDT)
In-Reply-To: <1314691825-12295-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds a functon named ext4_add_new_descs() which adds
several  group descriptors each time.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/resize.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 7b1b8ac..53412bf 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1082,6 +1082,31 @@ out:
 }
 
 /*
+ * ext4_add_new_descs() adds @count group descriptor of groups
+ * starting at @group
+ *
+ * @handle: journal handle
+ * @sb; super block
+ * @group: the group no. of the first group desc to be added
+ * @resize_inode: the resize inode
+ * @count: number of group descriptors to be added
+ */
+static int ext4_add_new_descs(handle_t *handle, struct super_block *sb,
+			ext4_group_t group, struct inode *resize_inode,
+			ext4_group_t count)
+{
+	int i, err = 0;
+
+	for (i = 0; i < count; i++) {
+		err = ext4_add_new_desc(handle, sb, group + i, resize_inode);
+		if (err)
+			return err;
+	}
+
+	return err;
+}
+
+/*
  * ext4_setup_new_desc() sets up group descriptors specified by @input.
  *
  * @handle: journal handle
-- 
1.7.5.1

