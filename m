From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH V3 05/15] ext4: add a structure which will be used by 64bit-resize interface
Date: Tue,  8 Nov 2011 07:13:18 +0800
Message-ID: <1320707608-14246-6-git-send-email-xiaoqiangnk@gmail.com>
References: <1320707608-14246-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65327 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab1KHB2Z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Nov 2011 20:28:25 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so6468027iag.19
        for <linux-ext4@vger.kernel.org>; Mon, 07 Nov 2011 17:28:25 -0800 (PST)
In-Reply-To: <1320707608-14246-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds a structure which will be used by 64bit-resize interface.
Two functions which allocate and destroy the structure respectively are
added.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/resize.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index e87aaa1..edef104 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -134,6 +134,61 @@ static int verify_group_input(struct super_block *sb,
 	return err;
 }
 
+/*
+ * ext4_new_flex_group_data is used by 64bit-resize interface to add a flex
+ * group each time.
+ */
+struct ext4_new_flex_group_data {
+	struct ext4_new_group_data *groups;	/* new_group_data for groups
+						   in the flex group */
+	__u16 *bg_flags;			/* block group flags of groups
+						   in @groups */
+	ext4_group_t count;			/* number of groups in @groups
+						 */
+};
+
+/*
+ * alloc_flex_gd() allocates a ext4_new_flex_group_data with size of
+ * @flexbg_size.
+ *
+ * Returns NULL on failure otherwise address of the allocated structure.
+ */
+static struct ext4_new_flex_group_data *alloc_flex_gd(unsigned long flexbg_size)
+{
+	struct ext4_new_flex_group_data *flex_gd;
+
+	flex_gd = kmalloc(sizeof(*flex_gd), GFP_NOFS);
+	if (flex_gd == NULL)
+		goto out3;
+
+	flex_gd->count = flexbg_size;
+
+	flex_gd->groups = kmalloc(sizeof(struct ext4_new_group_data) *
+				  flexbg_size, GFP_NOFS);
+	if (flex_gd->groups == NULL)
+		goto out2;
+
+	flex_gd->bg_flags = kmalloc(flexbg_size * sizeof(__u16), GFP_NOFS);
+	if (flex_gd->bg_flags == NULL)
+		goto out1;
+
+	return flex_gd;
+
+out1:
+	kfree(flex_gd->groups);
+out2:
+	kfree(flex_gd);
+out3:
+	return NULL;
+}
+
+void free_flex_gd(struct ext4_new_flex_group_data *flex_gd)
+{
+	kfree(flex_gd->bg_flags);
+	kfree(flex_gd->groups);
+	kfree(flex_gd);
+}
+
 static struct buffer_head *bclean(handle_t *handle, struct super_block *sb,
 				  ext4_fsblk_t blk)
 {
-- 
1.7.5.1

