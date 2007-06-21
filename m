From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: [RFC][PATCH 5/10] Get all extents information of specified inode number
Date: Thu, 21 Jun 2007 10:54:09 +0900
Message-ID: <20070621105409t-sato@rifu.yk.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

- Get all extents information of specified inode number to calculate
  the combination of extents which should be moved to other block group.

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
diff -X Online-Defrag_linux-2.6.19-rc6-git/Documentation/dontdiff -upNr Online-Defrag_linux-2.6.19-rc6-git-EXTENTS_INFO/fs/ext4/extents.c Online-Defrag_linux-2.6.19-rc6-git-MOVE_VICTIM/fs/ext4/extents.c
--- Online-Defrag_linux-2.6.19-rc6-git-EXTENTS_INFO/fs/ext4/extents.c	2007-06-20 08:50:57.000000000 +0900
+++ Online-Defrag_linux-2.6.19-rc6-git-MOVE_VICTIM/fs/ext4/extents.c	2007-06-20 08:27:44.000000000 +0900
@@ -43,6 +43,12 @@
 #include <linux/ext4_fs_extents.h>
 #include <asm/uaccess.h>
 
+#define DIO_CREDITS (EXT4_RESERVE_TRANS_BLOCKS + 32)
+#define EXT_SET_EXTENT_DATA(src, dest)  do {\
+		dest.block = le32_to_cpu(src->ee_block);\
+		dest.start = ext_pblock(src);\
+		dest.len = le16_to_cpu(src->ee_len);\
+					} while (0)
 /*
  * ext_pblock:
  * combine low and high parts of physical block number into ext4_fsblk_t
@@ -2479,6 +2485,121 @@ ext4_ext_next_extent(struct inode *inode
 }
 
 /**
+ * ext4_ext_extents_info() - get extents information
+ *
+ * @ext_info:                   pointer to ext4_extents_info
+ *  @ext_info->ino              describe an inode which is used to get extent
+ *                              information
+ *  @ext_info->max_entries:     defined by DEFRAG_MAX_ENT
+ *  @ext_info->entries:	        amount of extents (output)
+ *  @ext_info->ext[]:           array of extent (output)
+ *  @ext_info->offset:          starting block offset of targeted extent
+ *                              (file relative)
+ *
+ * @sb:                         for iget()
+ *
+ * This function returns 0 if next extent(s) exists,
+ * or returns 1 if next extent doesn't exist, otherwise returns error value.
+ * Called under truncate_mutex lock.
+ */
+static int ext4_ext_extents_info(struct ext4_extents_info *ext_info,
+				struct super_block *sb)
+{
+	struct ext4_ext_path *path = NULL;
+	struct ext4_extent *ext = NULL;
+	struct inode *inode = NULL;
+	unsigned long offset = ext_info->offset;
+	int max = ext_info->max_entries;
+	int is_last_extent = 0;
+	int depth = 0;
+	int entries = 0;
+	int err = 0;
+
+	inode = iget(sb, ext_info->ino);
+	if (!inode)
+		return -EACCES;
+
+	mutex_lock(&EXT4_I(inode)->truncate_mutex);
+
+	/* if a file doesn't exist*/
+	if ((!inode->i_nlink) || (inode->i_ino < 12) ||
+			!S_ISREG(inode->i_mode)) {
+		ext_info->entries = 0;
+		err = -ENOENT;
+		goto out;
+	}
+
+	path = ext4_ext_find_extent(inode, offset, NULL);
+	if (IS_ERR(path)) {
+		err = PTR_ERR(path);
+		path = NULL;
+ 		goto out;
+	}
+	depth = ext_depth(inode);
+	ext = path[depth].p_ext;
+	EXT_SET_EXTENT_DATA(ext, ext_info->ext[entries]);
+	entries = 1;
+
+	/*
+	 * The ioctl can return 'max' ext4_extent_data per a call,
+	 * so if @inode has > 'max' extents, we must get away here.
+	 */
+	while (entries < max) {
+		is_last_extent = ext4_ext_next_extent(inode, path, &ext);
+		/* found next extent (not the last one)*/
+		if (is_last_extent == 0) {
+			EXT_SET_EXTENT_DATA(ext, ext_info->ext[entries]);
+			entries++;
+
+			/*
+			 * If @inode has > 'max' extents,
+			 * this function should be called again,
+			 * (per a call, it can resolve only 'max' extents)
+			 * next time we have to start from 'max*n+1'th extent.
+			 */
+			if (entries == max) {
+				ext_info->offset =
+						le32_to_cpu(ext->ee_block) +
+						le32_to_cpu(ext->ee_len);
+				/* check the extent is the last one or not*/
+				is_last_extent =
+					ext4_ext_next_extent(inode, path, &ext);
+				if (is_last_extent) {
+					is_last_extent = 1;
+					err = is_last_extent;
+				} else if (is_last_extent < 0) {
+					/*ERR*/
+					err = is_last_extent;
+					goto out;
+				}
+				break;
+			}
+
+		/* the extent is the last one */
+		} else if (is_last_extent == 1) {
+			ext_info->offset = 0;
+			err = is_last_extent;
+			break;
+		} else {
+			/* ERR */
+			err = is_last_extent;
+			goto out;
+		}
+	}
+
+	ext_info->entries = entries;
+
+out:
+	if (path) {
+		ext4_ext_drop_refs(path);
+		kfree(path);
+	}
+	mutex_unlock(&EXT4_I(inode)->truncate_mutex);
+	iput(inode);
+	return err;
+}
+
+/**
  * ext4_ext_fblocks_distribution - Search free block distribution
  * @filp      target file
  * @ex_info   ext4_extents_info
@@ -2653,6 +2774,20 @@ int ext4_ext_ioctl(struct inode *inode, 
 		if (!err)
 			err = copy_to_user((struct ext4_extents_info*)arg,
 				&ext_info, sizeof(ext_info));
+	} else if (cmd == EXT4_IOC_EXTENTS_INFO) {
+		struct ext4_extents_info ext_info;
+
+		if (copy_from_user(&ext_info,
+				(struct ext4_extents_info __user *)arg,
+				sizeof(ext_info)))
+			return -EFAULT;
+
+		err = ext4_ext_extents_info(&ext_info, inode->i_sb);
+		if (err >= 0) {
+			if (copy_to_user((struct ext4_extents_info __user *)arg,
+				&ext_info, sizeof(ext_info)))
+				return -EFAULT;
+		}
 	} else if (cmd == EXT4_IOC_DEFRAG) {
 		struct ext4_ext_defrag_data defrag;
 

