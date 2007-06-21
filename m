From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: [RFC][PATCH 7/10] Reserve freed blocks
Date: Thu, 21 Jun 2007 10:55:11 +0900
Message-ID: <20070621105511t-sato@rifu.yk.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

- Reserve the free blocks in the target area, not to be
  used by other process.

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
diff -X Online-Defrag_linux-2.6.19-rc6-git/Documentation/dontdiff -upNr Online-Defrag_linux-2.6.19-rc6-git-RESERVE_BLOCK/fs/ext4/extents.c Online-Defrag_linux-2.6.19-rc6-git-BLOCK_RELEASE/fs/ext4/extents.c
--- Online-Defrag_linux-2.6.19-rc6-git-RESERVE_BLOCK/fs/ext4/extents.c	2007-06-19 21:40:55.000000000 +0900
+++ Online-Defrag_linux-2.6.19-rc6-git-BLOCK_RELEASE/fs/ext4/extents.c	2007-06-19 20:19:14.000000000 +0900
@@ -2619,6 +2619,182 @@ out:
 }
 
 /**
+ * ext4_ext_defrag_reserve - reserve blocks for defrag
+ * @inode	target inode
+ * @goal	block reservation goal
+ * @len		blocks count to reserve
+ *
+ * This function returns 0 if succeeded, otherwise
+ * returns error value
+ */
+
+int ext4_ext_defrag_reserve(struct inode * inode, ext4_fsblk_t goal, int len)
+{
+	struct super_block *sb = NULL;
+	handle_t *handle = NULL;
+	struct buffer_head *bitmap_bh = NULL;
+	struct ext4_block_alloc_info *block_i;
+	struct ext4_reserve_window_node * my_rsv = NULL;
+	unsigned short windowsz = 0;
+	unsigned long group_no;
+	ext4_grpblk_t grp_target_blk;
+	int err = 0;
+
+	mutex_lock(&EXT4_I(inode)->truncate_mutex);
+
+	handle = ext4_journal_start(inode, EXT4_RESERVE_TRANS_BLOCKS);
+	if (IS_ERR(handle)) {
+		err = PTR_ERR(handle);
+		handle = NULL;
+		goto out;
+	}
+
+	if (S_ISREG(inode->i_mode) && (!EXT4_I(inode)->i_block_alloc_info)) {
+		ext4_init_block_alloc_info(inode);
+	} else if (!S_ISREG(inode->i_mode)) {
+		printk(KERN_ERR "ext4_ext_defrag_reserve:"
+				 " incorrect file type\n");
+		err = -1;
+		goto out;
+	}
+
+	sb = inode->i_sb;
+	if (!sb) {
+		printk("ext4_ext_defrag_reserve: nonexistent device\n");
+		err = -ENXIO;
+		goto out;
+	}
+	ext4_get_group_no_and_offset(sb, goal, &group_no,
+				&grp_target_blk);
+
+	block_i = EXT4_I(inode)->i_block_alloc_info;
+
+	if (!block_i || ((windowsz =
+			block_i->rsv_window_node.rsv_goal_size) == 0)) {
+		printk("ex4_ext_defrag_reserve: unable to reserve\n");
+		err = -1;
+		goto out;
+	}
+
+	my_rsv = &block_i->rsv_window_node;
+
+	bitmap_bh = read_block_bitmap(sb, group_no);
+	if (!bitmap_bh) {
+		err = -ENOSPC;
+		goto out;
+	}
+
+	BUFFER_TRACE(bitmap_bh, "get undo access for new block");
+	err = ext4_journal_get_undo_access(handle, bitmap_bh);
+	if (err)
+		goto out;
+
+	err = alloc_new_reservation(my_rsv, grp_target_blk, sb,
+						group_no, bitmap_bh);
+	if (err < 0) {
+		printk(KERN_ERR "defrag: reservation faild\n");
+		ext4_discard_reservation(inode);
+		goto out;
+	} else {
+		if (len > EXT4_DEFAULT_RESERVE_BLOCKS) {
+			try_to_extend_reservation(my_rsv, sb,
+				len - EXT4_DEFAULT_RESERVE_BLOCKS);
+	 	}
+	}
+
+out:
+	mutex_unlock(&EXT4_I(inode)->truncate_mutex);
+	ext4_journal_release_buffer(handle, bitmap_bh);
+	brelse(bitmap_bh);
+
+	if (handle)
+		ext4_journal_stop(handle);
+
+	return err;
+}
+
+int goal_in_my_reservation(struct ext4_reserve_window *, ext4_grpblk_t,
+			unsigned int, struct super_block *);
+int rsv_is_empty(struct ext4_reserve_window *);
+
+/**
+ * ext4_ext_block_within_rsv - Is target extent reserved ?
+ * @ inode       inode of target file
+ * @ ex_start    start physical block number of the extent
+ *               which already moved
+ * @ ex_len      block length of the extent which already moved
+ *
+ * This function returns 0 if succeeded, otherwise
+ * returns error value
+ */
+static int ext4_ext_block_within_rsv(struct inode *inode,
+				ext4_fsblk_t ex_start, int ex_len)
+{
+	struct super_block *sb = inode->i_sb;
+	struct ext4_block_alloc_info *block_i;
+	unsigned long group_no;
+	ext4_grpblk_t grp_blk;
+	struct ext4_reserve_window_node *rsv;
+
+	block_i = EXT4_I(inode)->i_block_alloc_info;
+	if (block_i && block_i->rsv_window_node.rsv_goal_size > 0) {
+		rsv = &block_i->rsv_window_node;
+		if (rsv_is_empty(&rsv->rsv_window)) {
+			printk("defrag: Can't defrag due to"
+				" the empty reservation\n");
+			return -1;
+		}
+	} else {
+		printk("defrag: No i_block_alloc_info\n");
+		return -1;
+	}
+
+	ext4_get_group_no_and_offset(sb, ex_start, &group_no, &grp_blk);
+
+	if (goal_in_my_reservation(&rsv->rsv_window, grp_blk, group_no,	sb)
+	    && goal_in_my_reservation(&rsv->rsv_window, grp_blk + ex_len -1,
+		group_no, sb))
+		return 0;
+	return -1;
+}
+
+/*
+ * ext4_ext_fblocks_reserve() -
+ *	reserve free blocks by ext4_ext_defrag_reserve()
+ * @inode:		To get a block group number
+ * @ext_info:		freeblocks distribution which stored extent-like style
+ *  @ext_info->ext[]    an array of struct ext4_extents_data
+ */
+int ext4_ext_fblocks_reserve(struct inode *inode,
+			struct ext4_extents_info *ext_info)
+{
+	ext4_fsblk_t ex_start = 0;
+	int i;
+	int ret = 0;
+	int len = 0;
+
+	for (i = 0; i < ext_info->entries; i++) {
+		ex_start = ext_info->ext[i].start;
+		len = ext_info->ext[i].len;
+
+		ret = ext4_ext_defrag_reserve(inode, ex_start, len);
+		if (ret < 0)
+			goto ERR;
+
+		ret = ext4_ext_block_within_rsv(inode, ex_start, len);
+		if (ret < 0)
+			goto ERR;
+	}
+	return ret;
+
+ERR:
+	mutex_lock(&EXT4_I(inode)->truncate_mutex);
+	ext4_discard_reservation(inode);
+	mutex_unlock(&EXT4_I(inode)->truncate_mutex);
+	return ret;
+}
+
+/**
  * ext4_ext_defrag_victim - Create free space for defrag
  * @filp      target file
  * @ex_info   target extents array to move
@@ -2871,6 +3047,15 @@ int ext4_ext_ioctl(struct inode *inode, 
 				&ext_info, sizeof(ext_info)))
 				return -EFAULT;
 		}
+	} else if (cmd == EXT4_IOC_RESERVE_BLOCK) {
+		struct ext4_extents_info ext_info;
+
+		if (copy_from_user(&ext_info,
+				(struct ext4_extents_info __user *)arg,
+				sizeof(ext_info)))
+			return -EFAULT;
+
+		err = ext4_ext_fblocks_reserve(inode, &ext_info);
 	} else if (cmd == EXT4_IOC_MOVE_VICTIM) {
 		struct ext4_extents_info ext_info;
 
