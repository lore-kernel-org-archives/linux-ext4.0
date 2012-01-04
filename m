From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH V7 05/12] ext4: add a function which sets up a block group descriptors of a flex bg
Date: Wed,  4 Jan 2012 00:07:27 -0500
Message-ID: <1325653654-10478-6-git-send-email-tytso@mit.edu>
References: <1325653654-10478-1-git-send-email-tytso@mit.edu>
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50273 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab2ADFHf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jan 2012 00:07:35 -0500
In-Reply-To: <1325653654-10478-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Yongqiang Yang <xiaoqiangnk@gmail.com>

This patch adds a function named ext4_setup_new_descs which sets up the
block group descriptors of a flex bg.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/resize.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index e8ccb2f..098bdb8 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1086,6 +1086,62 @@ static int ext4_add_new_descs(handle_t *handle, struct super_block *sb,
 	return err;
 }
 
+/*
+ * ext4_setup_new_descs() will set up the group descriptor descriptors of a flex bg
+ */
+static int ext4_setup_new_descs(handle_t *handle, struct super_block *sb,
+				struct ext4_new_flex_group_data *flex_gd)
+{
+	struct ext4_new_group_data	*group_data = flex_gd->groups;
+	struct ext4_group_desc		*gdp;
+	struct ext4_sb_info		*sbi = EXT4_SB(sb);
+	struct buffer_head		*gdb_bh;
+	ext4_group_t			group;
+	__u16				*bg_flags = flex_gd->bg_flags;
+	int				i, gdb_off, gdb_num, err = 0;
+	
+
+	for (i = 0; i < flex_gd->count; i++, group_data++, bg_flags++) {
+		group = group_data->group;
+
+		gdb_off = group % EXT4_DESC_PER_BLOCK(sb);
+		gdb_num = group / EXT4_DESC_PER_BLOCK(sb);
+
+		/*
+		 * get_write_access() has been called on gdb_bh by ext4_add_new_desc().
+		 */
+		gdb_bh = sbi->s_group_desc[gdb_num];
+		/* Update group descriptor block for new group */
+		gdp = (struct ext4_group_desc *)((char *)gdb_bh->b_data +
+						 gdb_off * EXT4_DESC_SIZE(sb));
+
+		memset(gdp, 0, EXT4_DESC_SIZE(sb));
+		ext4_block_bitmap_set(sb, gdp, group_data->block_bitmap);
+		ext4_inode_bitmap_set(sb, gdp, group_data->inode_bitmap);
+		ext4_inode_table_set(sb, gdp, group_data->inode_table);
+		ext4_free_group_clusters_set(sb, gdp,
+					     EXT4_B2C(sbi, group_data->free_blocks_count));
+		ext4_free_inodes_set(sb, gdp, EXT4_INODES_PER_GROUP(sb));
+		gdp->bg_flags = cpu_to_le16(*bg_flags);
+		gdp->bg_checksum = ext4_group_desc_csum(sbi, group, gdp);
+
+		err = ext4_handle_dirty_metadata(handle, NULL, gdb_bh);
+		if (unlikely(err)) {
+			ext4_std_error(sb, err);
+			break;
+		}
+
+		/*
+		 * We can allocate memory for mb_alloc based on the new group
+		 * descriptor
+		 */
+		err = ext4_mb_add_groupinfo(sb, group, gdp);
+		if (err)
+			break;
+	}
+	return err;
+}
+
 /* Add group descriptor data to an existing or new group descriptor block.
  * Ensure we handle all possible error conditions _before_ we start modifying
  * the filesystem, because we cannot abort the transaction and not have it
-- 
1.7.8.11.gefc1f.dirty

