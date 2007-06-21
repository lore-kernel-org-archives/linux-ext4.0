From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: [RFC][PATCH 6/10] Move files from target block group to other block group
Date: Thu, 21 Jun 2007 10:54:43 +0900
Message-ID: <20070621105443t-sato@rifu.yk.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

- To make contiguous free blocks, move files from the target block group
  to other block group. 

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
diff -X Online-Defrag_linux-2.6.19-rc6-git/Documentation/dontdiff -upNr Online-Defrag_linux-2.6.19-rc6-git-MOVE_VICTIM/fs/ext4/extents.c Online-Defrag_linux-2.6.19-rc6-git-RESERVE_BLOCK/fs/ext4/extents.c
--- Online-Defrag_linux-2.6.19-rc6-git-MOVE_VICTIM/fs/ext4/extents.c	2007-06-20 08:27:44.000000000 +0900
+++ Online-Defrag_linux-2.6.19-rc6-git-RESERVE_BLOCK/fs/ext4/extents.c	2007-06-19 21:40:55.000000000 +0900
@@ -1279,20 +1279,20 @@ ext4_can_extents_be_merged(struct inode 
 }
 
 /*
- * ext4_ext_insert_extent:
- * tries to merge requsted extent into the existing extent or
- * inserts requested extent as new one into the tree,
- * creating new leaf in the no-space case.
+ * ext4_ext_insert_extent_defrag:
+ * The difference from ext4_ext_insert_extent is to use the first block
+ * in newext as the goal of the new index block.
  */
-int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
+int ext4_ext_insert_extent_defrag(handle_t *handle, struct inode *inode,
 				struct ext4_ext_path *path,
-				struct ext4_extent *newext)
+				struct ext4_extent *newext, int defrag)
 {
 	struct ext4_extent_header * eh;
 	struct ext4_extent *ex, *fex;
 	struct ext4_extent *nearex; /* nearest extent */
 	struct ext4_ext_path *npath = NULL;
 	int depth, len, err, next;
+	ext4_fsblk_t defrag_goal;
 
 	BUG_ON(newext->ee_len == 0);
 	depth = ext_depth(inode);
@@ -1342,11 +1342,17 @@ repeat:
 			  le16_to_cpu(eh->eh_entries), le16_to_cpu(eh->eh_max));
 	}
 
+	if (defrag) {
+		defrag_goal = ext_pblock(newext);
+	} else {
+		defrag_goal = 0;
+	}
 	/*
 	 * There is no free space in the found leaf.
 	 * We're gonna add a new leaf in the tree.
 	 */
-	err = ext4_ext_create_new_leaf(handle, inode, path, newext);
+	err = ext4_ext_create_new_leaf(handle, inode, path,
+						newext, defrag_goal);
 	if (err)
 		goto cleanup;
 	depth = ext_depth(inode);
@@ -1438,6 +1444,19 @@ cleanup:
 	return err;
 }
 
+/*
+ * ext4_ext_insert_extent:
+ * tries to merge requsted extent into the existing extent or
+ * inserts requested extent as new one into the tree,
+ * creating new leaf in the no-space case.
+ */
+int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
+				struct ext4_ext_path *path,
+				struct ext4_extent *newext)
+{
+	return ext4_ext_insert_extent_defrag(handle, inode, path, newext, 0);
+}
+
 int ext4_ext_walk_space(struct inode *inode, unsigned long block,
 			unsigned long num, ext_prepare_callback func,
 			void *cbdata)
@@ -2600,6 +2619,70 @@ out:
 }
 
 /**
+ * ext4_ext_defrag_victim - Create free space for defrag
+ * @filp      target file
+ * @ex_info   target extents array to move
+ *
+ * This function returns 0 if succeeded, otherwise
+ * returns error value
+ */
+static int ext4_ext_defrag_victim(struct file *target_filp,
+			struct ext4_extents_info *ex_info)
+{
+	struct inode *target_inode = target_filp->f_dentry->d_inode;
+	struct super_block *sb = target_inode->i_sb;
+	struct file victim_file;
+	struct dentry victim_dent;
+	struct inode *victim_inode;
+	ext4_fsblk_t goal = ex_info->goal;
+	int ret = 0;
+	int i = 0;
+	int flag = DEFRAG_RESERVE_BLOCKS_SECOND;
+	struct ext4_extent_data ext;
+	unsigned long group;
+	ext4_grpblk_t grp_off;
+
+	/* Setup dummy entent data */
+	ext.len = 0;
+
+	/* Get the inode of the victim file */
+	victim_inode = iget(sb, ex_info->ino);
+	if (!victim_inode)
+		return -EACCES;
+
+	/* Setup file for the victim file */
+	victim_dent.d_inode = victim_inode;
+	victim_file.f_dentry = &victim_dent;
+
+	/* Set the goal appropriate offset */
+	if (goal == -1) {
+		ext4_get_group_no_and_offset(victim_inode->i_sb,
+				ex_info->ext[0].start, &group, &grp_off);
+		goal = ext4_group_first_block_no(sb, group + 1);
+	}
+
+	for (i = 0; i < ex_info->entries; i++ ) {
+		/* Move original blocks to another block group */
+		if ((ret = ext4_ext_defrag(&victim_file, ex_info->ext[i].block,
+			ex_info->ext[i].len, goal, flag, &ext)) < 0)
+			goto ERR;
+
+		/* Sync journal blocks before reservation */
+		if (do_fsync(target_filp, 0))
+			goto ERR;
+	}
+
+	iput(victim_inode);
+	return 0;
+ERR:
+	mutex_lock(&EXT4_I(target_inode)->truncate_mutex);
+	ext4_discard_reservation(target_inode);
+	mutex_unlock(&EXT4_I(target_inode)->truncate_mutex);
+	iput(victim_inode);
+	return ret;
+}
+
+/**
  * ext4_ext_fblocks_distribution - Search free block distribution
  * @filp      target file
  * @ex_info   ext4_extents_info
@@ -2788,6 +2871,16 @@ int ext4_ext_ioctl(struct inode *inode, 
 				&ext_info, sizeof(ext_info)))
 				return -EFAULT;
 		}
+	} else if (cmd == EXT4_IOC_MOVE_VICTIM) {
+		struct ext4_extents_info ext_info;
+
+		if (copy_from_user(&ext_info,
+			(struct ext4_extents_info __user *)arg,
+			sizeof(ext_info)))
+			return -EFAULT;
+
+		err = ext4_ext_defrag_victim(filp, &ext_info);
+
 	} else if (cmd == EXT4_IOC_DEFRAG) {
 		struct ext4_ext_defrag_data defrag;
 


