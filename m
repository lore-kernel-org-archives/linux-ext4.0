From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH V6 08/15] ext4: add a function which sets up a flex groups each time
Date: Fri, 30 Dec 2011 18:53:50 +0800
Message-ID: <1325242437-26934-9-git-send-email-xiaoqiangnk@gmail.com>
References: <1325242437-26934-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45478 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab1L3OhU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Dec 2011 09:37:20 -0500
Received: by mail-iy0-f174.google.com with SMTP id h11so25392161iae.19
        for <linux-ext4@vger.kernel.org>; Fri, 30 Dec 2011 06:37:20 -0800 (PST)
In-Reply-To: <1325242437-26934-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Yongqiang Yang <xiaoqiangnk@gmail.com>

This patch adds a function named ext4_setup_new_descs() which sets up
a flex groups each time.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/resize.c |   25 +++++++++++++++++++++++--
 1 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index d0d0ade..f82cbee 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1114,7 +1114,8 @@ static int ext4_add_new_descs(handle_t *handle, struct super_block *sb,
  * @sb: super block
  */
 static int ext4_setup_new_desc(handle_t *handle, struct super_block *sb,
-			       struct ext4_new_group_data *input)
+			       struct ext4_new_group_data *input,
+			       __u16 bg_flags)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	ext4_group_t group;
@@ -1144,7 +1145,7 @@ static int ext4_setup_new_desc(handle_t *handle, struct super_block *sb,
 	ext4_free_group_clusters_set(sb, gdp,
 				     EXT4_B2C(sbi, input->free_blocks_count));
 	ext4_free_inodes_set(sb, gdp, EXT4_INODES_PER_GROUP(sb));
-	gdp->bg_flags = cpu_to_le16(EXT4_BG_INODE_ZEROED);
+	gdp->bg_flags = cpu_to_le16(bg_flags);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, input->group, gdp);
 
 	err = ext4_handle_dirty_metadata(handle, NULL, gdb_bh);
@@ -1163,6 +1164,26 @@ static int ext4_setup_new_desc(handle_t *handle, struct super_block *sb,
 }
 
 /*
+ * ext4_setup_new_descs setups group descriptors of a flex groups
+ */
+static int ext4_setup_new_descs(handle_t *handle, struct super_block *sb,
+				struct ext4_new_flex_group_data *flex_gd)
+{
+	struct ext4_new_group_data *group_data = flex_gd->groups;
+	__u16 *bg_flags = flex_gd->bg_flags;
+	int i, err = 0;
+
+	for (i = 0; i < flex_gd->count; i++) {
+		err = ext4_setup_new_desc(handle, sb, group_data + i,
+					  bg_flags[i]);
+		if (err)
+			return err;
+	}
+
+	return err;
+}
+
+/*
  * ext4_update_super() updates super so that new the added group can be seen
  *   by the filesystem.
  *
-- 
1.7.5.1

