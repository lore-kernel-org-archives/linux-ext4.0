From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH v5 07/15] ext4: add a function which adds several group descriptors
Date: Fri, 23 Dec 2011 16:14:57 +0800
Message-ID: <1324628105-32559-8-git-send-email-xiaoqiangnk@gmail.com>
References: <1324628105-32559-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: tytso@mit.edu, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:47472 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756760Ab1LWLxL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Dec 2011 06:53:11 -0500
Received: by obcwo16 with SMTP id wo16so4941593obc.19
        for <linux-ext4@vger.kernel.org>; Fri, 23 Dec 2011 03:53:11 -0800 (PST)
In-Reply-To: <1324628105-32559-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Yongqiang Yang <xiaoqiangnk@gmail.com>

This patch adds a functon named ext4_add_new_descs() which adds
several group descriptors each time.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/resize.c |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index cdefa36..bae5b4c 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1051,6 +1051,31 @@ out:
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

