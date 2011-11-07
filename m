From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH V3 03/15] ext4: add a function which sets up a new group desc
Date: Tue,  8 Nov 2011 07:13:16 +0800
Message-ID: <1320707608-14246-4-git-send-email-xiaoqiangnk@gmail.com>
References: <1320707608-14246-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65327 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab1KHB2V (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Nov 2011 20:28:21 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so6468027iag.19
        for <linux-ext4@vger.kernel.org>; Mon, 07 Nov 2011 17:28:20 -0800 (PST)
In-Reply-To: <1320707608-14246-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds a function named ext4_setup_new_desc() which sets
up a new group descriptor and whose code is sopied from ext4_group_add().

The function will be used by new resize implementation.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/resize.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 7e8cd6e..0bc7a08 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -777,6 +777,61 @@ out:
 	return err;
 }
 
+/*
+ * ext4_setup_new_desc() sets up group descriptors specified by @input.
+ *
+ * @handle: journal handle
+ * @sb: super block
+ */
+static int ext4_setup_new_desc(handle_t *handle, struct super_block *sb,
+			       struct ext4_new_group_data *input)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	ext4_group_t group;
+	struct ext4_group_desc *gdp;
+	struct buffer_head *gdb_bh;
+	int gdb_off, gdb_num, err = 0;
+
+	group = input->group;
+
+	gdb_off = group % EXT4_DESC_PER_BLOCK(sb);
+	gdb_num = group / EXT4_DESC_PER_BLOCK(sb);
+
+	/*
+	 * get_write_access() has been called on gdb_bh by ext4_add_new_desc().
+	 */
+	gdb_bh = sbi->s_group_desc[gdb_num];
+	/* Update group descriptor block for new group */
+	gdp = (struct ext4_group_desc *)((char *)gdb_bh->b_data +
+				 gdb_off * EXT4_DESC_SIZE(sb));
+
+	memset(gdp, 0, EXT4_DESC_SIZE(sb));
+	 /* LV FIXME */
+	memset(gdp, 0, EXT4_DESC_SIZE(sb));
+	ext4_block_bitmap_set(sb, gdp, input->block_bitmap); /* LV FIXME */
+	ext4_inode_bitmap_set(sb, gdp, input->inode_bitmap); /* LV FIXME */
+	ext4_inode_table_set(sb, gdp, input->inode_table); /* LV FIXME */
+	ext4_free_group_clusters_set(sb, gdp,
+				     EXT4_B2C(sbi, input->free_blocks_count));
+	ext4_free_inodes_set(sb, gdp, EXT4_INODES_PER_GROUP(sb));
+	gdp->bg_flags = cpu_to_le16(EXT4_BG_INODE_ZEROED);
+	gdp->bg_checksum = ext4_group_desc_csum(sbi, input->group, gdp);
+
+	err = ext4_handle_dirty_metadata(handle, NULL, gdb_bh);
+	if (unlikely(err)) {
+		ext4_std_error(sb, err);
+		return err;
+	}
+
+	/*
+	 * We can allocate memory for mb_alloc based on the new group
+	 * descriptor
+	 */
+	err = ext4_mb_add_groupinfo(sb, group, gdp);
+
+	return err;
+}
+
 /* Add group descriptor data to an existing or new group descriptor block.
  * Ensure we handle all possible error conditions _before_ we start modifying
  * the filesystem, because we cannot abort the transaction and not have it
-- 
1.7.5.1

