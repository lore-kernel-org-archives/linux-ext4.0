From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH V6 RESEND 07/15] ext4: add a function which adds several group descriptors
Date: Fri, 30 Dec 2011 19:00:04 +0800
Message-ID: <1325242812-27005-8-git-send-email-xiaoqiangnk@gmail.com>
References: <1325242812-27005-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41000 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab1L3Ols (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Dec 2011 09:41:48 -0500
Received: by mail-iy0-f174.google.com with SMTP id h11so25397943iae.19
        for <linux-ext4@vger.kernel.org>; Fri, 30 Dec 2011 06:41:48 -0800 (PST)
In-Reply-To: <1325242812-27005-1-git-send-email-xiaoqiangnk@gmail.com>
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
index 3024769..d0d0ade 100644
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

