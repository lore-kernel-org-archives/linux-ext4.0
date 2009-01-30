From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [RFC][PATCH 1/3] ext4: Add EXT4_IOC_DEFRAG ioctl and basic defrag
 functions
Date: Fri, 30 Jan 2009 15:12:07 +0900
Message-ID: <49829A37.8050701@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:39878 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbZA3GMq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Jan 2009 01:12:46 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: online defrag -- Add EXT4_IOC_DEFRAG ioctl and basic defrag functions.

From: Akira Fujita <a-fujita@rs.jp.nec.com>

The EXT4_IOC_DEFRAG exchanges the blocks between org_fd and dest_fd,
then write the file data of org_fd to dest_fd.
ext4_defrag() is the main fucntion of ext4 online defrag,
this patch includes it and defrag basic functions.


Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
---
 fs/ext4/Makefile       |   13 ++
 fs/ext4/defrag.c       |  477 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/ext4.h         |   18 ++-
 fs/ext4/ext4_extents.h |    4 +
 fs/ext4/extents.c      |    4 +-
 fs/ext4/ioctl.c        |   44 ++++-
 6 files changed, 544 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/Makefile b/fs/ext4/Makefile
index a8ff003..e7fd8ba 100644
--- a/fs/ext4/Makefile
+++ b/fs/ext4/Makefile
@@ -6,7 +6,7 @@ obj-$(CONFIG_EXT4_FS) += ext4.o

 ext4-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o \
 		   ioctl.o namei.o super.o symlink.o hash.o resize.o extents.o \
-		   ext4_jbd2.o migrate.o mballoc.o
+		   ext4_jbd2.o migrate.o mballoc.o defrag.o

 ext4-$(CONFIG_EXT4_FS_XATTR)		+= xattr.o xattr_user.o xattr_trusted.o
 ext4-$(CONFIG_EXT4_FS_POSIX_ACL)	+= acl.o
diff --git a/fs/ext4/defrag.c b/fs/ext4/defrag.c
new file mode 100644
index 0000000..c9f903e
--- /dev/null
+++ b/fs/ext4/defrag.c
@@ -0,0 +1,477 @@
+/*
+ * Copyright (c) 2009, NEC Software Tohoku, Ltd.
+ * Written by Takashi Sato <t-sato@yk.jp.nec.com>
+ *            Akira Fujita <a-fujita@rs.jp.nec.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2.1 of the GNU Lesser General Public License
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+/* Online defragmentation for EXT4 */
+
+#include <linux/fs.h>
+#include <linux/quotaops.h>
+#include "ext4_jbd2.h"
+#include "ext4_extents.h"
+#include "group.h"
+
+/**
+ * ext4_defrag_next_extent - Search for the next extent and set it to "extent"
+ *
+ * @inode:	inode which is searched
+ * @path:	this will obtain data for the next extent
+ * @extent:	pointer to the next extent we have just gotten
+ *
+ * Search the next extent in the array of ext4_ext_path structure (@org_path)
+ * and set it to ext4_extent structure (@extent). In addition, the member of
+ * @org_path (->p_ext) also points the next extent. Return 0 on success, 1 if
+ * ext4_ext_path structure refers to the last extent, or a negative error
+ * value on failure.
+ */
+static int
+ext4_defrag_next_extent(struct inode *inode, struct ext4_ext_path *path,
+			struct ext4_extent **extent)
+{
+	int ppos, leaf_ppos = path->p_depth;
+
+	ppos = leaf_ppos;
+	if (EXT_LAST_EXTENT(path[ppos].p_hdr) > path[ppos].p_ext) {
+		/* leaf block */
+		*extent = ++path[ppos].p_ext;
+		return 0;
+	}
+
+	while (--ppos >= 0) {
+		if (EXT_LAST_INDEX(path[ppos].p_hdr) >
+		    path[ppos].p_idx) {
+			int cur_ppos = ppos;
+
+			/* index block */
+			path[ppos].p_idx++;
+			path[ppos].p_block = idx_pblock(path[ppos].p_idx);
+			if (path[ppos+1].p_bh)
+				brelse(path[ppos+1].p_bh);
+			path[ppos+1].p_bh =
+				sb_bread(inode->i_sb, path[ppos].p_block);
+			if (!path[ppos+1].p_bh)
+				goto err;
+			path[ppos+1].p_hdr =
+				ext_block_hdr(path[ppos+1].p_bh);
+
+			/* Halfway index block */
+			while (++cur_ppos < leaf_ppos) {
+				path[cur_ppos].p_idx =
+					EXT_FIRST_INDEX(path[cur_ppos].p_hdr);
+				path[cur_ppos].p_block =
+					idx_pblock(path[cur_ppos].p_idx);
+				if (path[cur_ppos+1].p_bh)
+					brelse(path[cur_ppos+1].p_bh);
+				path[cur_ppos+1].p_bh = sb_bread(inode->i_sb,
+					path[cur_ppos].p_block);
+				if (!path[cur_ppos+1].p_bh)
+					goto err;
+				path[cur_ppos+1].p_hdr =
+					ext_block_hdr(path[cur_ppos+1].p_bh);
+			}
+
+			/* leaf block */
+			path[leaf_ppos].p_ext = *extent =
+				EXT_FIRST_EXTENT(path[leaf_ppos].p_hdr);
+			return 0;
+		}
+	}
+	/* We found the last extent */
+	return 1;
+err:
+	if (path)
+		ext4_ext_drop_refs(path);
+	return -EIO;
+}
+
+static int
+ext4_defrag_partial(struct file *o_filp, struct inode *dest_inode,
+			pgoff_t org_page_offset, int data_offset_in_page,
+			int block_len_in_page)
+{
+	return 0;
+}
+
+/**
+ * ext4_defrag_check - Check the environment whether a defrag can be done
+ *
+ * @org_inode:		original inode
+ * @dest_inode:		destination inode
+ * @start:		defrag start offset in blocks
+ * @len:		defrag size in blocks
+ *
+ * Check the arguments of ext4_defrag() whether the files can do defrag.
+ * Return 0 on success, or a negative error value on failure.
+ */
+static int
+ext4_defrag_check_arguments(struct inode *org_inode, struct inode *dest_inode,
+			ext4_lblk_t start, ext4_lblk_t len)
+{
+	if (!S_ISREG(org_inode->i_mode) || !S_ISREG(dest_inode->i_mode)) {
+		printk(KERN_ERR "ext4 defrag: "
+			"The argument files should be regular file\n");
+		return -EINVAL;
+	}
+
+	if (org_inode->i_rdev != dest_inode->i_rdev) {
+		printk(KERN_ERR "ext4 defrag: "
+			"The argument files should be in same filesystem \n");
+		return -EINVAL;
+	}
+
+	if (org_inode->i_ino == dest_inode->i_ino) {
+		printk(KERN_ERR "ext4 defrag: "
+			"The argument files should not be same\n");
+		return -EINVAL;
+	}
+
+	/* Ext4 online defrag supports only extent based file */
+	if (!(EXT4_I(org_inode)->i_flags & EXT4_EXTENTS_FL)) {
+		printk(KERN_ERR "ext4 defrag: ino[%lu] is not extents "
+					"based file\n", org_inode->i_ino);
+		return -EOPNOTSUPP;
+	}
+	if (!(EXT4_I(dest_inode)->i_flags & EXT4_EXTENTS_FL)) {
+		printk(KERN_ERR "ext4 defrag: ino[%lu] is not extents "
+					"based file\n", dest_inode->i_ino);
+		return -EOPNOTSUPP;
+	}
+
+	if (i_size_read(org_inode) > i_size_read(dest_inode)) {
+		if (start >= i_size_read(dest_inode)) {
+			printk(KERN_ERR "ext4 defrag: Start offset[%u] is "
+				"larger than destination file size\n",
+				start);
+			return -EINVAL;
+		}
+
+		if (start + len > i_size_read(dest_inode)) {
+			printk(KERN_ERR "ext4 defrag: Adjust defrag length "
+				"because it[%u] is larger than destination "
+				"file size\n", len);
+			len = i_size_read(dest_inode) - start;
+		}
+	} else {
+		if (start >= i_size_read(org_inode)) {
+			printk(KERN_ERR "ext4 defrag: Start offset[%u] is "
+				"larger than original file size\n", start);
+			return -EINVAL;
+		}
+
+		if (start + len > i_size_read(org_inode)) {
+			printk(KERN_ERR "ext4 defrag: Adjust defrag length "
+				" because it[%u] is larger than original "
+				"file size\n", len);
+			len = i_size_read(org_inode) - start;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * ext4_defrag_lock_two - acquire two inodes' lock
+ *
+ * @first:		inode structure to be locked first
+ * @second:		inode structure to be locked second
+ *
+ * Lock mutex and semaphore of the two inodes (@first and @second). First
+ * @first is locked and then @second is locked. Note that we *must* set
+ * arguments in order of small address.
+ */
+static void ext4_defrag_lock_two(struct inode *first, struct inode *second)
+{
+	mutex_lock(&first->i_mutex);
+	down_write(&EXT4_I(first)->i_data_sem);
+
+	mutex_lock(&second->i_mutex);
+	down_write(&EXT4_I(second)->i_data_sem);
+
+	return;
+}
+
+/**
+ * ext4_defrag_unlock_two - release two inodes' lock
+ *
+ * @first:		inode structure to be released its lock first
+ * @second:		inode structure to be released its lock second
+ *
+ * Release mutex and semaphore of two inodes (@first and @second). First
+ * @first's lock is released and then @second's lock is released. Note that
+ * we *must* set arguments in order of big address.
+ */
+static void ext4_defrag_unlock_two(struct inode *first, struct inode *second)
+{
+	mutex_unlock(&first->i_mutex);
+	up_write(&EXT4_I(first)->i_data_sem);
+
+	mutex_unlock(&second->i_mutex);
+	up_write(&EXT4_I(second)->i_data_sem);
+
+	return;
+}
+
+/**
+ * ext4_defrag - Defrag the specified range of a file
+ *
+ * If no-option is specified, ext4_defrag() proceeds the following order.
+ * 1.ext4_defrag() calculates the block number where defrag terminates
+ *   by the start block number (start) and the size of defraged data
+ *   (len) specified as arguments.
+ *   If the defrag_start points a hole, the extent's start offset pointed by
+ *   ext_cur (current extent), holecheck_path, org_path are set after
+ *   hole behind.
+ * 2.Continue step 3 to step 5, until the holecheck_path points to last_extent
+ *   or the ext_cur exceeds the block_end which is last logical block number.
+ * 3.To get a length of continues area, call ext4_defrag_next_extent()
+ *   specified with the ext_cur (initial value is holecheck_path) re-cursive,
+ *   until find un-continuous extent, the start logical block number exceeds
+ *   the block_end or the extent points to the last extent.
+ * 4.Exchange the original inode data with destination inode data
+ *   from org_page_offset to seq_end_page.
+ *   The start indexes of data are specified as arguments.
+ *   That of the original inode is org_page_offset,
+ *   and that of the destination inode is dest_block_offset
+ *   (To easily handle blocksize != pagesize case, the offset for the
+ *   destination inode is block unit).
+ * 5.Update holecheck_path and org_path to points a next proceeding extent,
+ *   then returns to step 2.
+ * 6.Release holecheck_path, org_path,
+ *   and returns the len which is the size of defraged data.
+ *   The len is used for the command to calculate the file offset
+ *   where a next defrag processing start.
+ *   (Since the defrag command calls defrag_ioctl() by 64MB unit,
+ *   a file bigger than 64MB calls defrag_ioctl multiple times.)
+ *
+ * @o_filp: file structure of the original file
+ * @d_filp: file structure of the destination file
+ * @start: defrag start offset in block
+ * @len: defrag length in block
+ *
+ * This function returns the number of blocks if succeed, otherwise
+ * returns error value.
+ *
+ * Note that the extents of target file(@o_filp) are always converted
+ * from "uninitialized" to "initialized" after swapping the blocks
+ * between the original file and the destination one(@d_filp).
+ * In the next version, this behavior will be fixed not to change extents'
+ * initializing status.
+ */
+int
+ext4_defrag(struct file *o_filp, struct file *d_filp,
+		ext4_lblk_t block_start, ext4_lblk_t len)
+{
+	struct inode *org_inode = o_filp->f_dentry->d_inode;
+	struct inode *dest_inode = d_filp->f_dentry->d_inode;
+	struct inode *ip = org_inode, *tip = dest_inode;
+	struct ext4_ext_path *org_path = NULL, *holecheck_path = NULL;
+	struct ext4_extent *ext_prev, *ext_cur, *ext_dummy;
+	ext4_lblk_t block_end, seq_start, add_blocks, file_end, seq_blocks = 0;
+	ext4_lblk_t rest_blocks;
+	pgoff_t org_page_offset, seq_end_page;
+	int ret, depth, last_extent = 0;
+	int blocks_per_page;
+	int data_offset_in_page;
+	int block_len_in_page;
+
+	/* Check the filesystem environment whether defrag can be done */
+	ret = ext4_defrag_check_arguments(org_inode, dest_inode,
+						block_start, len);
+	if (ret < 0)
+		return ret;
+
+	blocks_per_page = PAGE_CACHE_SIZE >> org_inode->i_blkbits;
+	file_end = (i_size_read(org_inode) - 1) >> org_inode->i_blkbits;
+	block_end = block_start + len - 1;
+	if (file_end < block_end)
+		len -= block_end - file_end;
+
+	/* Lock the lower address inode first */
+	if (ip > tip) {
+		ip = dest_inode;
+		tip = org_inode;
+	}
+	ext4_defrag_lock_two(ip, tip);
+
+	org_path = ext4_ext_find_extent(org_inode, block_start, NULL);
+	if (IS_ERR(org_path)) {
+		ret = PTR_ERR(org_path);
+		org_path = NULL;
+		goto out;
+	}
+
+	/* Get path structure to check the hole */
+	holecheck_path = ext4_ext_find_extent(org_inode, block_start, NULL);
+	if (IS_ERR(holecheck_path)) {
+		ret = PTR_ERR(holecheck_path);
+		holecheck_path = NULL;
+		goto out;
+	}
+
+	depth = ext_depth(org_inode);
+	ext_cur = holecheck_path[depth].p_ext;
+	if (ext_cur == NULL)
+		goto out;
+
+	/*
+	 * Get proper extent whose ee_block is beyond block_start
+	 * if block_start was within the hole.
+	 */
+	if (le32_to_cpu(ext_cur->ee_block) +
+		ext4_ext_get_actual_len(ext_cur) - 1 < block_start) {
+		last_extent = ext4_defrag_next_extent(org_inode,
+					holecheck_path, &ext_cur);
+		if (last_extent < 0) {
+			ret = last_extent;
+			goto out;
+		}
+		last_extent = ext4_defrag_next_extent(org_inode, org_path,
+							&ext_dummy);
+		if (last_extent < 0) {
+			ret = last_extent;
+			goto out;
+		}
+	}
+	seq_start = le32_to_cpu(ext_cur->ee_block);
+
+	/* No blocks within the specified range. */
+	if (le32_to_cpu(ext_cur->ee_block) > block_end) {
+		printk(KERN_INFO "ext4 defrag: The specified range of file"
+				" may be the hole\n");
+		goto out;
+	}
+
+	/* Adjust start blocks */
+	add_blocks = min(le32_to_cpu(ext_cur->ee_block) +
+			 ext4_ext_get_actual_len(ext_cur), block_end + 1) -
+		     max(le32_to_cpu(ext_cur->ee_block), block_start);
+
+	while (!last_extent && le32_to_cpu(ext_cur->ee_block) <= block_end) {
+		seq_blocks += add_blocks;
+
+		/* Adjust tail blocks */
+		if (seq_start + seq_blocks - 1 > block_end)
+			seq_blocks = block_end - seq_start + 1;
+
+		ext_prev = ext_cur;
+		last_extent = ext4_defrag_next_extent(org_inode,
+					holecheck_path, &ext_cur);
+		if (last_extent < 0) {
+			ret = last_extent;
+			break;
+		}
+		add_blocks = ext4_ext_get_actual_len(ext_cur);
+
+		/*
+		 * Extend the length of contiguous block (seq_blocks)
+		 * if extents are contiguous.
+		 */
+		if (le32_to_cpu(ext_prev->ee_block) +
+				ext4_ext_get_actual_len(ext_prev) ==
+				le32_to_cpu(ext_cur->ee_block) &&
+				block_end >= le32_to_cpu(ext_cur->ee_block) &&
+				!last_extent) {
+			continue;
+		}
+
+		data_offset_in_page = seq_start % blocks_per_page;
+
+		/*
+		 * Calculate data blocks count that should be swapped
+		 * at the first page.
+		 */
+		if (data_offset_in_page + seq_blocks > blocks_per_page) {
+			/* Swapped blocks are across pages */
+			block_len_in_page =
+					blocks_per_page - data_offset_in_page;
+		} else {
+			/* Swapped blocks are in a page */
+			block_len_in_page = seq_blocks;
+		}
+
+		org_page_offset = seq_start >>
+				(PAGE_CACHE_SHIFT - org_inode->i_blkbits);
+		seq_end_page = (seq_start + seq_blocks - 1) >>
+				(PAGE_CACHE_SHIFT - org_inode->i_blkbits);
+		seq_start = le32_to_cpu(ext_cur->ee_block);
+		rest_blocks = seq_blocks;
+
+		/*
+		 * Discard all preallocations.
+		 * This is provisional solution.
+		 * When true ext4_mb_return_to_preallocation() is
+		 * implemented, this will be removed.
+		 */
+		ext4_discard_preallocations(org_inode);
+		ext4_discard_preallocations(dest_inode);
+
+		while (org_page_offset <= seq_end_page) {
+
+			/* Swap original branches with new branches */
+			ret = ext4_defrag_partial(o_filp, dest_inode,
+				org_page_offset, data_offset_in_page,
+				block_len_in_page);
+			if (ret < 0)
+				goto out;
+
+			org_page_offset++;
+
+			data_offset_in_page = 0;
+			rest_blocks -= block_len_in_page;
+			if (rest_blocks > blocks_per_page)
+				block_len_in_page = blocks_per_page;
+			else
+				block_len_in_page = rest_blocks;
+		}
+
+		/* Decrease buffer counter */
+		if (holecheck_path)
+			ext4_ext_drop_refs(holecheck_path);
+		holecheck_path = ext4_ext_find_extent(org_inode,
+						seq_start, holecheck_path);
+		if (IS_ERR(holecheck_path)) {
+			ret = PTR_ERR(holecheck_path);
+			holecheck_path = NULL;
+			break;
+		}
+		depth = holecheck_path->p_depth;
+
+		/* Decrease buffer counter */
+		if (org_path)
+			ext4_ext_drop_refs(org_path);
+		org_path = ext4_ext_find_extent(org_inode, seq_start, org_path);
+		if (IS_ERR(org_path)) {
+			ret = PTR_ERR(org_path);
+			org_path = NULL;
+			break;
+		}
+
+		ext_cur = holecheck_path[depth].p_ext;
+		add_blocks = ext4_ext_get_actual_len(ext_cur);
+		seq_blocks = 0;
+
+	}
+out:
+	if (org_path) {
+		ext4_ext_drop_refs(org_path);
+		kfree(org_path);
+	}
+	if (holecheck_path) {
+		ext4_ext_drop_refs(holecheck_path);
+		kfree(holecheck_path);
+	}
+
+	ext4_defrag_unlock_two(tip, ip);
+
+	return ret ? ret : len;
+}
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index a1c5caa..35071f4 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -293,6 +293,7 @@ struct ext4_new_group_data {
 #define EXT4_IOC_GROUP_ADD		_IOW('f', 8, struct ext4_new_group_input)
 #define EXT4_IOC_MIGRATE		_IO('f', 9)
  /* note ioctl 11 reserved for filesystem-independent FIEMAP ioctl */
+#define EXT4_IOC_DEFRAG                 _IOW('f', 15, struct move_extent)

 /*
  * ioctl commands in 32 bit emulation
@@ -313,6 +314,13 @@ struct ext4_new_group_data {

 #define EXT4_IOC_DEBUG_DELALLOC		_IO('f', 42)

+struct move_extent {
+	int org_fd;		/* original file descriptor */
+	int dest_fd;		/* destination file descriptor */
+	ext4_lblk_t start;	/* logical offset of org_fd and dest_fd*/
+	ext4_lblk_t len;	/* exchange block length */
+};
+
 /*
  *  Mount options
  */
@@ -1016,6 +1024,10 @@ extern struct ext4_group_desc * ext4_get_group_desc(struct super_block * sb,
 						    struct buffer_head ** bh);
 extern int ext4_should_retry_alloc(struct super_block *sb, int *retries);

+/* defrag.c */
+extern int ext4_defrag(struct file *o_filp, struct file *d_filp,
+			ext4_lblk_t start, ext4_lblk_t len);
+
 /* dir.c */
 extern int ext4_check_dir_entry(const char *, struct inode *,
 				struct ext4_dir_entry_2 *,
diff --git a/fs/ext4/ext4_extents.h b/fs/ext4/ext4_extents.h
index 18cb67b..49a4614 100644
--- a/fs/ext4/ext4_extents.h
+++ b/fs/ext4/ext4_extents.h
@@ -221,12 +221,16 @@ static inline int ext4_ext_get_actual_len(struct ext4_extent *ext)
 }

 extern int ext4_ext_calc_metadata_amount(struct inode *inode, int blocks);
+extern ext4_fsblk_t ext_pblock(struct ext4_extent *ex);
 extern ext4_fsblk_t idx_pblock(struct ext4_extent_idx *);
 extern void ext4_ext_store_pblock(struct ext4_extent *, ext4_fsblk_t);
 extern int ext4_extent_tree_init(handle_t *, struct inode *);
 extern int ext4_ext_calc_credits_for_single_extent(struct inode *inode,
 						   int num,
 						   struct ext4_ext_path *path);
+extern int ext4_can_extents_be_merged(struct inode *inode,
+				      struct ext4_extent *ex1,
+				      struct ext4_extent *ex2);
 extern int ext4_ext_try_to_merge(struct inode *inode,
 				 struct ext4_ext_path *path,
 				 struct ext4_extent *);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 54bf062..a64c706 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -49,7 +49,7 @@
  * ext_pblock:
  * combine low and high parts of physical block number into ext4_fsblk_t
  */
-static ext4_fsblk_t ext_pblock(struct ext4_extent *ex)
+ext4_fsblk_t ext_pblock(struct ext4_extent *ex)
 {
 	ext4_fsblk_t block;

@@ -1328,7 +1328,7 @@ static int ext4_ext_correct_indexes(handle_t *handle, struct inode *inode,
 	return err;
 }

-static int
+int
 ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
 				struct ext4_extent *ex2)
 {
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 353d949..e1dde89 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -14,6 +14,7 @@
 #include <linux/compat.h>
 #include <linux/smp_lock.h>
 #include <linux/mount.h>
+#include <linux/file.h>
 #include <asm/uaccess.h>
 #include "ext4_jbd2.h"
 #include "ext4.h"
@@ -225,6 +226,38 @@ setversion_out:

 		return err;
 	}
+
+	case EXT4_IOC_DEFRAG: {
+		struct move_extent me;
+		struct file *d_filp;
+		int fput_needed;
+		int err;
+
+		if (copy_from_user(&me,
+			(struct move_extent __user *)arg, sizeof(me)))
+			return -EFAULT;
+
+
+		d_filp = fget_light(me.dest_fd, &fput_needed);
+		if (!d_filp)
+			return -EBADF;
+
+		if (!capable(CAP_DAC_OVERRIDE)) {
+			if ((current->real_cred->fsuid != inode->i_uid) ||
+			    !(inode->i_mode & S_IRUSR) ||
+			    !(d_filp->f_dentry->d_inode->i_mode & S_IRUSR)) {
+				fput_light(d_filp, fput_needed);
+				return -EACCES;
+			}
+		}
+
+		err = ext4_defrag(filp, d_filp, me.start, me.len);
+
+		fput_light(d_filp, fput_needed);
+
+		return err;
+	}
+
 	case EXT4_IOC_GROUP_ADD: {
 		struct ext4_new_group_data input;
 		struct super_block *sb = inode->i_sb;
