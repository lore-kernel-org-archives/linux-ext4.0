From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Add EXT4_IOC_MIGRATE ioctl
Date: Tue, 12 Jun 2007 12:17:57 +0530
Message-ID: <20070612064757.GA12991@skywalker.home.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: aneesh.kumar@linux.vnet.ibm.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:38713 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827AbXFLGuZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jun 2007 02:50:25 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id l5C7BNmI266732
	for <linux-ext4@vger.kernel.org>; Tue, 12 Jun 2007 17:11:36 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.250.243])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5C6r8Uf035618
	for <linux-ext4@vger.kernel.org>; Tue, 12 Jun 2007 16:53:31 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5C6mpH4013248
	for <linux-ext4@vger.kernel.org>; Tue, 12 Jun 2007 16:48:53 +1000
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The below patch add ioctl for migrating ext3 indirect block mapped inode
to ext4 extent mapped inode.

The patch is work in progress and have the below FIXME!!

1)Make sure the locking is correct with respect to 
	a) Already open references attempting a read on the file
	b) mmap
	c) direct I/O

2) Credit value needed for journalling.

The patch is on top of 585a2858b970cb6e2e5ca4877eefd18b4dba8ed4


-aneesh

diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index ae6e7e5..d5fd80b 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -6,7 +6,7 @@ obj-$(CONFIG_EXT4DEV_FS) += ext4dev.o
 
 ext4dev-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o \
 		   ioctl.o namei.o super.o symlink.o hash.o resize.o extents.o \
-		   ext4_jbd2.o
+		   ext4_jbd2.o migrate.o
 
 ext4dev-$(CONFIG_EXT4DEV_FS_XATTR)	+= xattr.o xattr_user.o xattr_trusted.o
 ext4dev-$(CONFIG_EXT4DEV_FS_POSIX_ACL)	+= acl.o
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 500567d..6a6d72b 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -248,6 +248,9 @@ flags_err:
 		return err;
 	}
 
+	case EXT4_IOC_MIGRATE:
+		return ext4_ext_migrate(inode, filp, cmd, arg);
+
 	default:
 		return -ENOTTY;
 	}
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
new file mode 100644
index 0000000..a07b71e
--- /dev/null
+++ b/fs/ext4/migrate.c
@@ -0,0 +1,501 @@
+/*
+ * Copyright IBM Corporation, 2007
+ * Author Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2.1 of the GNU Lesser General Public License
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/ext4_jbd2.h>
+#include <linux/ext4_fs_extents.h>
+
+struct list_blocks_struct {
+	int first_block, last_block;
+	ext4_fsblk_t first_pblock, last_pblock;
+};
+
+
+static int finish_range(handle_t *handle, struct inode *inode,
+				struct list_blocks_struct *lb)
+
+{
+	int retval = 0;
+	struct ext4_extent newext;
+	struct ext4_ext_path *path;
+	if (lb->first_pblock == 0)
+		return 0;
+
+	/* Add the extent to temp inode*/
+	newext.ee_block = cpu_to_le32(lb->first_block);
+	newext.ee_len   = cpu_to_le16(lb->last_block - lb->first_block +1);
+	/* ext4_ext_store_pblock(&newext, lb->first_pblock); */
+	newext.ee_start = cpu_to_le32((unsigned long) (lb->first_pblock &
+							0xffffffff));
+	newext.ee_start_hi = cpu_to_le16((unsigned long) ((lb->first_pblock >>
+							31) >> 1) & 0xffff);
+
+	path = ext4_ext_find_extent(inode, lb->first_block, NULL);
+
+	if (IS_ERR(path)) {
+		retval = PTR_ERR(path);
+		goto err_out;
+	}
+
+	retval = ext4_ext_insert_extent(handle, inode, path, &newext);
+
+err_out:
+	lb->first_pblock = 0;
+	return retval;
+}
+static int update_extent_range(handle_t *handle, struct inode *inode,
+				ext4_fsblk_t pblock, int blk_num,
+				struct list_blocks_struct *lb)
+{
+	int retval;
+
+	/*
+	 * See if we can add on to the existing range (if it exists)
+	 */
+	if (lb->first_pblock &&
+		(lb->last_pblock+1 == pblock) &&
+		(lb->last_block+1 == blk_num)) {
+		lb->last_pblock = pblock;
+		lb->last_block = blk_num;
+		return 0;
+	}
+	/*
+	 * Start a new range.
+	 */
+	retval = finish_range(handle, inode, lb);
+	lb->first_pblock = lb->last_pblock = pblock;
+	lb->first_block = lb->last_block = blk_num;
+
+	return retval;
+
+}
+
+static int update_ind_extent_range(handle_t *handle, struct inode *inode,
+					ext4_fsblk_t pblock, int *blk_nump,
+					struct list_blocks_struct *lb)
+{
+	struct buffer_head *bh;
+	__le32 *i_data;
+	int i, retval = 0;
+	int blk_count = *blk_nump;
+	unsigned long max_entries = inode->i_sb->s_blocksize >> 2;
+
+	if (!pblock) {
+		/* Only update the file block number */
+		*blk_nump += max_entries;
+		return 0;
+	}
+
+	bh = sb_bread(inode->i_sb, pblock);
+	if (!bh)
+		return -EIO;
+
+	i_data = (__le32 *)bh->b_data;
+
+	for (i = 0; i < max_entries; i++, blk_count++) {
+		if (i_data[i]) {
+			retval = update_extent_range(handle, inode,
+						le32_to_cpu(i_data[i]),
+						blk_count, lb);
+			if (retval)
+				break;
+		}
+	}
+
+	/* Update the file block number */
+	*blk_nump = blk_count;
+	brelse(bh);
+	return retval;
+
+}
+static int update_dind_extent_range(handle_t *handle, struct inode *inode,
+					ext4_fsblk_t pblock, int *blk_nump,
+					struct list_blocks_struct *lb)
+{
+	struct buffer_head *bh;
+	__le32 *i_data;
+	int i, retval = 0;
+	int blk_count = *blk_nump;
+	unsigned long max_entries = inode->i_sb->s_blocksize >> 2;
+
+	if (!pblock) {
+		/* Only update the file block number */
+		*blk_nump += max_entries * max_entries;
+		return 0;
+	}
+
+	bh = sb_bread(inode->i_sb, pblock);
+	if (!bh)
+		return -EIO;
+
+	i_data = (__le32 *)bh->b_data;
+
+	for (i = 0; i < max_entries; i++) {
+		if (i_data[i]) {
+			retval = update_ind_extent_range(handle, inode,
+						le32_to_cpu(i_data[i]),
+						&blk_count, lb);
+			if (retval)
+				break;
+		} else {
+			/* Only update the file block number */
+			blk_count += max_entries;
+		}
+	}
+
+	/* Update the file block number */
+	*blk_nump = blk_count;
+	brelse(bh);
+	return retval;
+
+}
+static int update_tind_extent_range(handle_t *handle, struct inode *inode,
+					ext4_fsblk_t pblock, int *blk_nump,
+					struct list_blocks_struct *lb)
+{
+	struct buffer_head *bh;
+	__le32 *i_data;
+	int i, retval = 0;
+	int blk_count = *blk_nump;
+	unsigned long max_entries = inode->i_sb->s_blocksize >> 2;
+
+	if (!pblock) {
+		/* Only update the file block number */
+		*blk_nump += max_entries * max_entries * max_entries;
+		return 0;
+	}
+
+	bh = sb_bread(inode->i_sb, pblock);
+	if (!bh)
+		return -EIO;
+
+	i_data = (__le32 *)bh->b_data;
+
+	for (i = 0; i < max_entries; i++) {
+		if (i_data[i]) {
+			retval = update_dind_extent_range(handle, inode,
+						le32_to_cpu(i_data[i]),
+						&blk_count, lb);
+			if (retval)
+				break;
+		} else {
+			/* Only update the file block number */
+			blk_count += max_entries * max_entries;
+		}
+	}
+
+	/* Update the file block number */
+	*blk_nump = blk_count;
+	brelse(bh);
+	return retval;
+
+}
+
+
+static int free_dind_blocks(handle_t *handle,
+				struct inode *inode, __le32 i_data)
+{
+	int i;
+	__le32 *tmp_idata;
+	struct buffer_head *bh;
+	unsigned long max_entries = inode->i_sb->s_blocksize >> 2;
+
+	bh = sb_bread(inode->i_sb, le32_to_cpu(i_data));
+	if (!bh)
+		return -EIO;
+
+	tmp_idata = (__le32 *)bh->b_data;
+	for (i = 0; i < max_entries; i++) {
+		if (tmp_idata[i]) {
+			ext4_free_blocks(handle, inode,
+					le32_to_cpu(tmp_idata[i]), 1);
+		}
+	}
+	ext4_free_blocks(handle, inode, le32_to_cpu(i_data), 1);
+	brelse(bh);
+
+	return 0;
+
+
+}
+
+static int free_tind_blocks(handle_t *handle,
+				struct inode *inode, __le32 i_data)
+{
+	int i, retval = 0;
+	__le32 *tmp_idata;
+	struct buffer_head *bh;
+	unsigned long max_entries = inode->i_sb->s_blocksize >> 2;
+
+	bh = sb_bread(inode->i_sb, le32_to_cpu(i_data));
+	if (!bh)
+		return -EIO;
+
+	tmp_idata = (__le32 *)bh->b_data;
+
+	for (i = 0; i < max_entries; i++) {
+		if (tmp_idata[i]) {
+			retval = free_dind_blocks(handle,
+					inode, tmp_idata[i]);
+			if (retval) {
+				brelse(bh);
+				return retval;
+			}
+		}
+	}
+	ext4_free_blocks(handle, inode, le32_to_cpu(i_data), 1);
+	brelse(bh);
+
+	return 0;
+
+
+}
+
+static int free_ind_block(handle_t *handle, struct inode *inode)
+{
+	int retval;
+	struct ext4_inode_info *ei = EXT4_I(inode);
+
+	if (ei->i_data[EXT4_IND_BLOCK]) {
+
+		ext4_free_blocks(handle, inode,
+				le32_to_cpu(ei->i_data[EXT4_IND_BLOCK]), 1);
+
+	}
+
+	if (ei->i_data[EXT4_DIND_BLOCK]) {
+		retval = free_dind_blocks(handle, inode,
+						ei->i_data[EXT4_DIND_BLOCK]);
+		if (retval)
+			return retval;
+	}
+
+	if (ei->i_data[EXT4_TIND_BLOCK]) {
+		retval = free_tind_blocks(handle, inode,
+						ei->i_data[EXT4_TIND_BLOCK]);
+		if (retval)
+			return retval;
+	}
+
+
+	return 0;
+}
+static int ext4_ext_swap_inode_data(handle_t *handle, struct inode *inode,
+				struct inode *tmp_inode, int retval)
+{
+	struct ext4_inode_info *ei = EXT4_I(inode);
+	struct ext4_inode_info *tmp_ei = EXT4_I(tmp_inode);
+
+	if (retval) {
+		/*
+		 * FIXME!!
+		 * Failure case delete the extent information with the
+		 * tmp_inode
+		 */
+		goto err_out;
+	}
+
+
+	retval = free_ind_block(handle, inode);
+	if (retval)
+		goto err_out;
+
+	/*
+	 * We have the extent map build with the tmp inode.
+	 * Now copy the i_data across
+	 */
+	ei->i_flags |= EXT4_EXTENTS_FL;
+	memcpy(ei->i_data, tmp_ei->i_data, sizeof(ei->i_data));
+
+	/*
+	 * Update i_blocks with the new blocks that got
+	 * allocated while adding extents for extent index
+	 * blocks.
+	 *
+	 * While converting to extents we need not
+	 * update the orignal inode i_blocks for extent blocks
+	 * via quota APIs. The quota update happened via tmp_inode already.
+	 */
+	spin_lock(&inode->i_lock);
+	inode->i_blocks += tmp_inode->i_blocks;
+	spin_unlock(&inode->i_lock);
+
+	ext4_mark_inode_dirty(handle, inode);
+
+err_out:
+	/*
+	 * Mark the tmp_inode as of size zero
+	 */
+	i_size_write(tmp_inode, 0);
+
+
+	/*
+	 * set the  i_blocks count to zero
+	 * so that the ext4_delete_inode does the
+	 * right job
+	 */
+	spin_lock(&tmp_inode->i_lock);
+	tmp_inode->i_blocks = 0;
+	spin_unlock(&tmp_inode->i_lock);
+
+	/* Reset the extent details */
+	ext4_ext_tree_init(handle, tmp_inode);
+
+	/*
+	 * Set the i_nlink to zero so that
+	 * generic_drop_inode really deletes the
+	 * inode
+	 */
+	tmp_inode->i_nlink = 0;
+
+
+	return retval;
+}
+int ext4_ext_migrate(struct inode * inode, struct file * filp,
+				unsigned int cmd, unsigned long arg)
+{
+	handle_t *handle;
+	int retval = 0, i;
+	__le32 *i_data;
+	int blk_count = 0;
+	struct ext4_inode_info *ei;
+	struct inode *tmp_inode = NULL;
+	struct list_blocks_struct lb;
+	unsigned long max_entries;
+
+
+	if (!test_opt(inode->i_sb, EXTENTS)) {
+		/*
+		 * if mounted with noextents
+		 * we don't allow the migrate
+		 */
+		return -EINVAL;
+	}
+
+	if ((EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
+		return -EINVAL;
+
+	/* Locking FIXME!! */
+	mutex_lock(&inode->i_mutex);
+	down_write(&(inode->i_alloc_sem));
+	mutex_lock(&EXT4_I(inode)->truncate_mutex);
+
+
+	/* FIXME!! */
+	handle = ext4_journal_start(inode,
+					EXT4_DATA_TRANS_BLOCKS(inode->i_sb) +
+					EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
+					2 * EXT4_QUOTA_INIT_BLOCKS(inode->i_sb)
+					+ 1);
+	if (IS_ERR(handle)) {
+		retval = PTR_ERR(handle);
+		goto err_out;
+	}
+
+	tmp_inode = ext4_new_inode(handle,
+				inode->i_sb->s_root->d_inode,
+				S_IFREG);
+
+	if (IS_ERR(tmp_inode)) {
+		retval = -ENOMEM;
+		ext4_journal_stop(handle);
+		tmp_inode = NULL;
+		goto err_out;
+	}
+
+	i_size_write(tmp_inode, i_size_read(inode));
+	/*
+	 * We don't want the inode to be reclaimed
+	 * if we got interrupted in between. We have
+	 * this tmp inode carrying reference to the
+	 * data blocks of the original file. We set
+	 * the i_nlink to zero at the last stage after
+	 * switching the original file to extent format
+	 */
+	tmp_inode->i_nlink = 1;
+
+	ext4_ext_tree_init(handle, tmp_inode);
+	ext4_orphan_add(handle, tmp_inode);
+	ext4_journal_stop(handle);
+
+	ei = EXT4_I(inode);
+        i_data = ei->i_data;
+	memset(&lb, 0, sizeof(lb));
+
+	/* 32 bit block address 4 bytes */
+	max_entries = inode->i_sb->s_blocksize >> 2;
+
+	/* FIXME!! */
+	handle = ext4_journal_start(inode, EXT4_MAX_TRANS_DATA);
+	for (i = 0; i < EXT4_NDIR_BLOCKS; i++, blk_count++) {
+
+		if (i_data[i]) {
+			retval = update_extent_range(handle, tmp_inode,
+						le32_to_cpu(i_data[i]),
+						blk_count, &lb);
+			if (retval)
+				goto err_out;
+		}
+	}
+
+	if (i_data[EXT4_IND_BLOCK]) {
+		retval = update_ind_extent_range(handle, tmp_inode,
+					le32_to_cpu(i_data[EXT4_IND_BLOCK]),
+					&blk_count, &lb);
+			if (retval)
+				goto err_out;
+	} else {
+		blk_count +=  max_entries;
+	}
+
+	if (i_data[EXT4_DIND_BLOCK]) {
+		retval = update_dind_extent_range(handle, tmp_inode,
+					le32_to_cpu(i_data[EXT4_DIND_BLOCK]),
+					&blk_count, &lb);
+			if (retval)
+				goto err_out;
+	} else {
+		blk_count += max_entries * max_entries;
+	}
+
+
+	if (i_data[EXT4_TIND_BLOCK]) {
+		retval = update_tind_extent_range(handle, tmp_inode,
+					le32_to_cpu(i_data[EXT4_TIND_BLOCK]),
+					&blk_count, &lb);
+			if (retval)
+				goto err_out;
+	}
+
+	/*
+	 * Build the last extent
+	 */
+	retval = finish_range(handle, tmp_inode, &lb);
+
+err_out:
+	retval = ext4_ext_swap_inode_data(handle, inode,
+						tmp_inode, retval);
+	ext4_journal_stop(handle);
+
+	/* Locking FIXME!! */
+	mutex_unlock(&EXT4_I(inode)->truncate_mutex);
+	up_write(&(inode->i_alloc_sem));
+	mutex_unlock(&inode->i_mutex);
+
+	if (tmp_inode)
+		iput(tmp_inode);
+
+
+	return retval;
+}
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 54c576d..e8b5f96 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -242,6 +242,7 @@ struct ext4_new_group_data {
 #endif
 #define EXT4_IOC_GETRSVSZ		_IOR('f', 5, long)
 #define EXT4_IOC_SETRSVSZ		_IOW('f', 6, long)
+#define EXT4_IOC_MIGRATE		_IO('f', 7)
 
 /*
  * ioctl commands in 32 bit emulation
