From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH 3/3] ext4: Add EXT4_IOC_TRANSFER_BLOCK_RANGE ioctl
Date: Sun, 23 Jun 2013 15:07:59 +0900
Message-ID: <1371967679-3218-1-git-send-email-linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, a.sangwan@samsung.com,
	Namjae Jeon <linkinjeon@gmail.com>,
	Namjae Jeon <namjae.jeon@samsung.com>
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

The EXT4_IOC_TRANSFER_BLOCK_RANGE ioctl transfers the data blocks lying
between [start, "start + length") form source file and append them
to destination file (represented by dest_fd).
This operation leaves a hole in the source file from where data blocks
are transfrered.
If there is any fallocated area beyond isize of destination it will
be truncated.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 fs/ext4/ext4.h    |   10 +-
 fs/ext4/extents.c |  471 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/ioctl.c   |   47 ++++++
 3 files changed, 527 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 246a03a..8f01855 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -591,6 +591,7 @@ enum {
 #define EXT4_IOC_RESIZE_FS		_IOW('f', 16, __u64)
 #define EXT4_IOC_SWAP_BOOT		_IO('f', 17)
 #define EXT4_IOC_TRUNCATE_BLOCK_RANGE	_IOW('f', 18, struct truncate_range)
+#define EXT4_IOC_TRANSFER_BLOCK_RANGE	_IOW('f', 19, struct transfer_range)
 
 #if defined(__KERNEL__) && defined(CONFIG_COMPAT)
 /*
@@ -688,6 +689,12 @@ struct truncate_range {
 	__u32 length;
 };
 
+struct transfer_range {
+	__u32 dest_fd;
+	__u32 start_block;
+	__u32 length;
+};
+
 #define EXT4_EPOCH_BITS 2
 #define EXT4_EPOCH_MASK ((1 << EXT4_EPOCH_BITS) - 1)
 #define EXT4_NSEC_MASK  (~0UL << EXT4_EPOCH_BITS)
@@ -2700,7 +2707,8 @@ extern int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 			__u64 start, __u64 len);
 extern int ext4_ext_truncate_range(struct inode *inode, ext4_lblk_t start,
 				   ext4_lblk_t end, ext4_lblk_t last_block);
-
+extern int ext4_ext_transfer_range(struct inode *sinode, struct inode *dinode,
+				   __u32 start_block, __u32 end_block);
 
 /* move_extent.c */
 extern void ext4_double_down_write_data_sem(struct inode *first,
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ed85e34..f95d43f 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5002,3 +5002,474 @@ out:
 	return ret;
 }
 
+/**
+ * ext4_ext_prepare_extent_transfer
+ *
+ * If start lies between extent, extent is split such that start
+ * is the first block of new extent.
+ * If start lies in a hole, start is adjusted to point to the starting
+ * block of next extent.
+ * If end lies between extent, extent is split such that end is the
+ * last block of old extent.
+ *
+ * @inode: The inode of the file from which extents are to be removed
+ * @start: The starting block for removing extent
+ * @orig_end : The end block for removing extent
+ * @handle: journal handle
+ *
+ * Returns 0 on success, 1 if no transfer is needed, error otherwise
+ */
+int ext4_ext_prepare_extent_transfer(struct inode *inode, ext4_lblk_t *start,
+				     ext4_lblk_t orig_end, handle_t *handle)
+{
+	int err, depth;
+	struct ext4_ext_path *path = NULL;
+	struct ext4_extent *ex;
+	ext4_lblk_t orig_start = *start;
+
+	err = get_ext_path(inode, orig_start, &path);
+	if (err)
+		return err;
+
+	depth = ext_depth(inode);
+	ex = path[depth].p_ext;
+
+	/* if start lies between extent, split the extent */
+	if (orig_start > le32_to_cpu(ex->ee_block) && orig_start <=
+	    le32_to_cpu(ex->ee_block) + ext4_ext_get_actual_len(ex) - 1) {
+		int split_flag = 0;
+		if (ext4_ext_is_uninitialized(ex))
+			split_flag = EXT4_EXT_MARK_UNINIT1 |
+				     EXT4_EXT_MARK_UNINIT2;
+		err = ext4_split_extent_at(handle, inode, path, orig_start,
+				split_flag, EXT4_GET_BLOCKS_METADATA_NOFAIL |
+				EXT4_GET_BLOCKS_PRE_IO);
+		if (err < 0)
+			goto out;
+	} else if (le32_to_cpu(ex->ee_block) +
+		   ext4_ext_get_actual_len(ex) - 1 < orig_start) {
+		/*
+		 * start lies in a hole, adjust start to point to
+		 * the start of next extent
+		 */
+		err = mext_next_extent(inode, path, &ex);
+		if (err < 0 || err == 1)
+			goto out;
+		*start = le32_to_cpu(ex->ee_block);
+	} else
+		/* start lies in a hole which is at the begining of block */
+		*start = le32_to_cpu(ex->ee_block);
+
+	/* Both start and end lies in same hole */
+	if (orig_end < *start) {
+		err = 1;
+		goto out;
+	}
+
+	ext4_ext_drop_refs(path);
+	kfree(path);
+	path = NULL;
+
+	err = get_ext_path(inode, orig_end, &path);
+	if (err)
+		return err;
+
+	depth = ext_depth(inode);
+	ex = path[depth].p_ext;
+	if (orig_end >= le32_to_cpu(ex->ee_block) && orig_end <
+	    le32_to_cpu(ex->ee_block) + ext4_ext_get_actual_len(ex) - 1) {
+		int split_flag = 0;
+
+		if (ext4_ext_is_uninitialized(ex))
+			split_flag = EXT4_EXT_MARK_UNINIT1 |
+					EXT4_EXT_MARK_UNINIT2;
+		/*
+		 * Split the extent in two so that 'end' is the last
+		 * block in the first new extent
+		 */
+		err = ext4_split_extent_at(handle, inode, path,
+					   orig_end + 1, split_flag,
+					   EXT4_GET_BLOCKS_PRE_IO |
+					   EXT4_GET_BLOCKS_METADATA_NOFAIL);
+		if (err < 0)
+			goto out;
+	}
+
+out:
+	ext4_ext_drop_refs(path);
+	kfree(path);
+	return err;
+}
+
+/*
+ * ext4_ext_transfer_extents
+ *
+ * Function to transfer extents from source inode to destination inode
+ * which lies between start and end. Unlike truncate, which start
+ * removing extents from end, we transfer from start.
+ *
+ * @sinode: The source inode for extent transfer
+ * @dinode: The destination inode for extent transfer
+ * @start: The starting block number for extent transfer. start should be
+ * be the first block in an extent.
+ * @end: The ending block number for extent transfer. end could lie inside
+ * hole or it sholud be the last block in an extent.
+ *
+ * Returns number of blocks successfully transfered or error
+ */
+loff_t ext4_ext_transfer_extents(struct inode *sinode, struct inode *dinode,
+			      ext4_lblk_t start, ext4_lblk_t  end,
+			      handle_t *handle)
+{
+	int i, depth = ext_depth(sinode), err, erase_index = 0;
+	struct ext4_extent *ex, *last_ex;
+	struct ext4_ext_path *path = NULL, *d_path = NULL;
+	ext4_lblk_t move_index;
+	loff_t blocks_moved = 0;
+	struct ext4_extent_header *hdr = ext_inode_hdr(sinode);
+
+	move_index = dinode->i_size >> dinode->i_blkbits;
+	err = get_ext_path(sinode, start, &path);
+	if (err)
+		return err;
+	i = depth;
+	ex = path[i].p_ext;
+
+	while (i >= 0 && err == 0) {
+		if (i == depth) {
+			int extent_count = 0;
+			hdr = path[i].p_hdr;
+			if (!ex)
+				ex = EXT_FIRST_EXTENT(hdr);
+			last_ex =  EXT_LAST_EXTENT(hdr);
+			err = ext4_trange_dirty_path(handle, sinode, path + i,
+						     1, dinode);
+			if (err)
+				goto out;
+
+			while (ex != NULL &&
+			       (le32_to_cpu(ex->ee_block) <= end)) {
+				int ext_length = ext4_ext_get_actual_len(ex);
+
+				d_path = ext4_ext_find_extent(dinode,
+							      move_index,
+							      NULL);
+				if (IS_ERR(d_path)) {
+					err = PTR_ERR(d_path);
+					goto out;
+				}
+				ex->ee_block = cpu_to_le32(move_index);
+				err = ext4_ext_insert_extent(handle, dinode,
+							     d_path, ex, 0);
+				if (err)
+					goto out;
+
+				extent_count++;
+				blocks_moved += ext_length;
+				move_index += ext_length;
+				memset(ex, 0, sizeof(struct ext4_extent));
+				le16_add_cpu(&(hdr->eh_entries), -1);
+				ext4_ext_drop_refs(d_path);
+				kfree(d_path);
+				d_path = NULL;
+
+				/* Check if all the extents in this block have
+				 * transfered
+				 */
+				if (++ex > last_ex)
+					ex = NULL;
+			}
+
+			ext4_ext_dirty(handle, sinode, path + i);
+
+			if (!ex) {
+				brelse(path[i].p_bh);
+				path[i].p_bh = NULL;
+				/*move level down */
+				i--;
+				if (!le16_to_cpu(hdr->eh_entries))
+					erase_index = 1;
+				else
+					erase_index = 0;
+				continue;
+			} else {
+				/* All the required extents are transfered */
+				last_ex++;
+				if (extent_count) {
+					memmove(ex - extent_count, ex,
+						(last_ex - ex) *
+						sizeof(struct ext4_extent));
+					memset(last_ex - extent_count, 0,
+						extent_count *
+						sizeof(struct ext4_extent));
+					ext4_ext_dirty(handle, sinode,
+						       path + i);
+					path[i].p_ext = EXT_FIRST_EXTENT(hdr);
+					err = ext4_ext_correct_indexes(handle,
+								sinode, path);
+				}
+				break;
+			}
+		}
+
+		/* Now we are at leaf node */
+		if (erase_index) {
+			struct ext4_extent_idx *idx = path[i].p_idx;
+			struct ext4_extent_idx *last_idx =
+						EXT_LAST_INDEX(path[i].p_hdr);
+			int k = i - 1;
+			ext4_fsblk_t leaf;
+
+			leaf = ext4_idx_pblock(path[i].p_idx);
+			err = ext4_trange_dirty_path(handle, sinode, path + i,
+						     1, dinode);
+			if (err)
+				goto out;
+
+			if (idx != last_idx)
+				memmove(idx, idx + 1, (last_idx - idx) *
+					   sizeof(struct ext4_extent_idx));
+
+			memset(last_idx, 0, sizeof(struct ext4_extent_idx));
+			le16_add_cpu(&(path[i].p_hdr->eh_entries), -1);
+			ext4_ext_dirty(handle, sinode, path + i);
+
+			ext4_free_blocks(handle, sinode, NULL, leaf, 1,
+					 EXT4_FREE_BLOCKS_METADATA |
+					 EXT4_FREE_BLOCKS_FORGET);
+			erase_index = 0;
+			/* Adjust all the indexes to the top */
+			if (path[i].p_hdr->eh_entries &&
+			    idx == EXT_FIRST_INDEX(path[i].p_hdr))
+				while (k >= 0) {
+					if (path[k].p_idx !=
+						EXT_FIRST_INDEX(path[k].p_hdr))
+						break;
+					err = ext4_ext_get_access(handle,
+							sinode, path + k);
+					if (err)
+						break;
+					path[k].p_idx->ei_block = idx->ei_block;
+					err = ext4_ext_dirty(handle, sinode,
+							     path + k);
+					if (err)
+						break;
+					k--;
+				}
+		} else {
+			if (!path[i].p_idx)
+				path[i].p_idx = EXT_FIRST_INDEX(path[i].p_hdr);
+			else
+				path[i].p_idx++;
+		   }
+
+		if (path[i].p_idx <= EXT_LAST_INDEX(path[i].p_hdr)) {
+			struct buffer_head *bh = NULL;
+
+			memset(path + i + 1, 0, sizeof(struct ext4_ext_path));
+			bh = sb_bread(sinode->i_sb,
+				      ext4_idx_pblock(path[i].p_idx));
+			if (!bh) {
+				err = -EIO;
+				goto out;
+			}
+			if (ext4_ext_check(sinode, ext_block_hdr(bh),
+			    depth - i - 1)) {
+				err = -EIO;
+				put_bh(bh);
+				goto out;
+			}
+			path[i + 1].p_bh = bh;
+			path[i + 1].p_hdr = ext_block_hdr(path[i+1].p_bh);
+			i++;
+		} else {
+			erase_index = 0;
+			if (!le16_to_cpu(path[i].p_hdr->eh_entries)) {
+				erase_index = 1;
+				path[i].p_hdr->eh_depth = 0;
+			}
+
+			brelse(path[i].p_bh);
+			path[i].p_bh = NULL;
+			i--;
+		}
+	}
+out:
+	ext4_ext_drop_refs(path);
+	kfree(path);
+
+	if (d_path)
+		ext4_ext_drop_refs(d_path);
+	kfree(d_path);
+	if (err)
+		return err;
+	else
+		return blocks_moved;
+}
+
+/*
+ * ext4_ext_can_transfer_range: Check if transfer range
+ * can be performed
+ *
+ * @sinode: Source file inode
+ * @dinode: Destination file inode
+ *
+ * This function returns 0 on success, error otherwise
+ */
+static int ext4_ext_can_transfer_range(struct inode *sinode,
+				       struct inode *dinode)
+{
+	/* source file could not be empty */
+	if (!i_size_read(sinode))
+		return -EINVAL;
+
+	/* source and destination inode should be from same fs */
+	if (sinode->i_sb != dinode->i_sb)
+		return -EINVAL;
+
+	/* source and destination should be different inodes */
+	if (sinode == dinode)
+		return -EINVAL;
+
+	/* Regular file check */
+	if (!S_ISREG(sinode->i_mode) || !S_ISREG(dinode->i_mode))
+		return -EINVAL;
+
+	/* cannot move blocks for immutable files */
+	if (IS_IMMUTABLE(sinode) || IS_APPEND(dinode))
+		return -EPERM;
+
+	/* Ignore swap files */
+	if (IS_SWAPFILE(sinode) || IS_SWAPFILE(dinode))
+		return -EINVAL;
+
+	/* Ext4 move block range supports only extent based file */
+	if (!(ext4_test_inode_flag(sinode, EXT4_INODE_EXTENTS)) ||
+	    !(ext4_test_inode_flag(dinode, EXT4_INODE_EXTENTS)))
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+/**
+ * ext4_ext_transfer_range
+ *
+ * @sinode: source inode from which blocks are to be moved
+ * @dinode: destination inode to which blocks are added
+ * @start_block: The starting block number from which the
+ * block movement starts
+ * @end_block: The last block number which is to be moved
+ *
+ * This function returns 0 on success or error otherwise
+ */
+int ext4_ext_transfer_range(struct inode *sinode, struct inode *dinode,
+			    __u32 start_block, __u32 end_block)
+{
+	ext4_lblk_t s_last_block;
+	int ret, credits, blkbits = EXT4_BLOCK_SIZE_BITS(sinode->i_sb);
+	handle_t *handle;
+	struct address_space *mapping = sinode->i_mapping;
+	loff_t daligned_size, blocks_moved;
+	loff_t first_page_offset, last_page_offset;
+
+	ret = ext4_ext_can_transfer_range(sinode, dinode);
+	if (ret)
+		return ret;
+
+	ext4_inode_double_lock(sinode, dinode);
+	ext4_inode_block_unlocked_dio(sinode);
+	ext4_inode_block_unlocked_dio(dinode);
+	inode_dio_wait(sinode);
+	inode_dio_wait(dinode);
+
+	s_last_block = ((round_up(sinode->i_size,
+			 EXT4_BLOCK_SIZE(sinode->i_sb))) >> blkbits) - 1;
+
+	/* start_block cannot be greater than source end_block or last_block */
+	if (start_block > end_block || start_block > s_last_block) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	/* If end_block is greater than source last_block, adjust it */
+	if (end_block > s_last_block)
+		end_block = s_last_block;
+
+	/* sync dirty pages for transfer */
+	if (mapping->nrpages && mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
+		ret = filemap_write_and_wait_range(mapping,
+				(loff_t)start_block << blkbits,
+				((loff_t)(end_block + 1) << blkbits) - 1);
+		if (ret)
+			goto out;
+	}
+
+	first_page_offset = round_down((loff_t)start_block << blkbits,
+				       PAGE_SIZE);
+	last_page_offset = round_up((loff_t)end_block << blkbits, PAGE_SIZE);
+	truncate_pagecache_range(sinode, first_page_offset,
+				 last_page_offset - 1);
+
+	/* Protect extent tree against block allocations via delalloc */
+	down_write(&EXT4_I(sinode)->i_data_sem);
+
+	/* we need to update 2 inodes */
+	credits = ext4_writepage_trans_blocks(sinode) +
+		  ext4_writepage_trans_blocks(dinode);
+	handle = ext4_journal_start(sinode, EXT4_HT_TRUNCATE, credits);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out2;
+	}
+
+	ret = ext4_ext_prepare_extent_transfer(sinode, &start_block,
+					       end_block, handle);
+	if (ret != 0) {
+		if (ret == 1)
+			/* No need to move blocks */
+			ret = 0;
+		goto stop_journal;
+	}
+
+	daligned_size = (loff_t)(round_up(dinode->i_size,
+					  EXT4_BLOCK_SIZE(dinode->i_sb)));
+	/* if dest inode isize is not block aligned, make it block aligned */
+	if (dinode->i_size != daligned_size)
+		i_size_write(dinode, daligned_size);
+
+	/* Discard any falloacted area beyond i_size for dest inode */
+	ext4_truncate(dinode);
+
+	down_write(&EXT4_I(dinode)->i_data_sem);
+	blocks_moved = ext4_ext_transfer_extents(sinode, dinode, start_block,
+						 end_block, handle);
+	if (blocks_moved <= 0) {
+		ret = blocks_moved;
+		goto out3;
+	}
+
+	/* Update size and disksize here */
+	i_size_write(dinode,
+		     (dinode->i_size + (blocks_moved << blkbits)));
+	EXT4_I(dinode)->i_disksize += (blocks_moved << blkbits);
+	sinode->i_blocks -= (blocks_moved << (blkbits - 9));
+	dinode->i_blocks += (blocks_moved << (blkbits - 9));
+
+	sinode->i_mtime = sinode->i_ctime = ext4_current_time(sinode);
+	ext4_mark_inode_dirty(handle, sinode);
+
+	dinode->i_mtime = dinode->i_ctime = ext4_current_time(dinode);
+	ext4_mark_inode_dirty(handle, dinode);
+out3:
+	up_write(&EXT4_I(dinode)->i_data_sem);
+stop_journal:
+	ext4_journal_stop(handle);
+out2:
+	up_write(&EXT4_I(sinode)->i_data_sem);
+out:
+	ext4_inode_resume_unlocked_dio(sinode);
+	ext4_inode_resume_unlocked_dio(dinode);
+	ext4_inode_double_unlock(sinode, dinode);
+
+	return ret;
+}
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 0530daf..f2240f6 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -685,6 +685,53 @@ resizefs_out:
 		return error;
 	}
 
+	case EXT4_IOC_TRANSFER_BLOCK_RANGE:
+	{
+		struct transfer_range tr;
+		struct fd dest_fd;
+		int err;
+		ext4_lblk_t end_block;
+
+		if (!(filp->f_mode & FMODE_WRITE))
+			return -EBADF;
+
+		if (EXT4_HAS_RO_COMPAT_FEATURE(sb,
+			EXT4_FEATURE_RO_COMPAT_BIGALLOC)) {
+			ext4_msg(sb, KERN_ERR,
+			    "Move block range not supported with bigalloc");
+			return -EOPNOTSUPP;
+		}
+
+		if (copy_from_user(&tr, (struct transfer_range __user *)arg,
+				   sizeof(tr)))
+			return -EFAULT;
+
+		if (tr.length == 0)
+			return -EINVAL;
+		end_block = tr.start_block + tr.length - 1;
+
+		dest_fd = fdget(tr.dest_fd);
+		if (!dest_fd.file)
+			return -EBADF;
+
+		if (!(dest_fd.file->f_mode & FMODE_WRITE)) {
+			err = -EBADF;
+			goto fput_out;
+		}
+
+		err = mnt_want_write_file(filp);
+		if (err)
+			goto fput_out;
+
+		err = ext4_ext_transfer_range(inode, file_inode(dest_fd.file),
+					      tr.start_block, end_block);
+		mnt_drop_write_file(filp);
+
+fput_out:
+		fdput(dest_fd);
+		return err;
+	}
+
 	default:
 		return -ENOTTY;
 	}
-- 
1.7.9.5
