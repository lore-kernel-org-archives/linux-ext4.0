From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 07/13] ext4: add a function which adds several group descriptors
Date: Thu, 11 Aug 2011 11:28:22 +0800
Message-ID: <1313033308-882-8-git-send-email-xiaoqiangnk@gmail.com>
References: <1313033308-882-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: aedilger@gmail.com, tytso@mit.edu,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:48649 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab1HKDfk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Aug 2011 23:35:40 -0400
Received: by mail-pz0-f42.google.com with SMTP id 37so2947235pzk.1
        for <linux-ext4@vger.kernel.org>; Wed, 10 Aug 2011 20:35:40 -0700 (PDT)
In-Reply-To: <1313033308-882-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds a functon named ext4_add_new_descs() which adds
several  group descriptors each time.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/resize.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 4acf7a8..7e91d58 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1083,6 +1083,31 @@ out:
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

