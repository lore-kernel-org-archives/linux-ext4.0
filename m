From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH v4 03/15] ext4: add a function which sets up a new group desc
Date: Sat, 19 Nov 2011 17:57:09 +0800
Message-ID: <1321696641-14437-4-git-send-email-xiaoqiangnk@gmail.com>
References: <1321696641-14437-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: adilger@dilger.ca, linux-ext4@vger.kernel.org,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37586 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab1KSMbJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Nov 2011 07:31:09 -0500
Received: by ghbz2 with SMTP id z2so1450020ghb.19
        for <linux-ext4@vger.kernel.org>; Sat, 19 Nov 2011 04:31:08 -0800 (PST)
In-Reply-To: <1321696641-14437-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Yongqiang Yang <xiaoqiangnk@gmail.com>

This patch adds a function named ext4_setup_new_desc() which sets
up a new group descriptor and whose code is sopied from ext4_group_add().

The function will be used by new resize implementation.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/resize.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 9a5486e..a50eab3 100644
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

