From: sho@tnes.nec.co.jp
Subject: [RFC][PATCH 1/3] Allocate new contiguous blocks
Date: Thu, 9 Nov 2006 20:10:26 +0900
Message-ID: <20061109201026sho@rifu.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Search contiguous free blocks with Alex's mutil-block allocation
and allocate them for the temporary inode.

This patch applies on top of Alex's patches.
"[RFC] extents,mballoc,delalloc for 2.6.16.8"
http://marc.theaimsgroup.com/?l=linux-ext4&m=114669168616780&w=2

Signed-off-by: Takashi Sato <sho@tnes.nec.co.jp>
---
diff -upNr -X linux-2.6.16.8-alex-org/Documentation/dontdiff linux-2.6.16.8-alex-org/fs/ext3/extents.c linux-2.6.16.8-tmp1/fs/ext3/extents.c
--- linux-2.6.16.8-alex-org/fs/ext3/extents.c	2006-11-08 21:20:28.000000000 +0900
+++ linux-2.6.16.8-tmp1/fs/ext3/extents.c	2006-11-08 22:12:19.000000000 +0900
@@ -2341,11 +2341,418 @@ int ext3_ext_ioctl(struct inode *inode, 
 		down(&EXT3_I(inode)->truncate_sem);
 		err = EXT_DEPTH(&tree);
 		up(&EXT3_I(inode)->truncate_sem);
+	} else if (cmd == EXT3_IOC_DEFRAG) {
+		struct ext3_ext_defrag_data defrag;
+
+		if (copy_from_user(&defrag,
+				   (struct ext3_ext_defrag_data __user *)arg,
+				   sizeof(defrag)))
+			return -EFAULT;
+
+		err = ext3_ext_defrag(filp, defrag.start_offset, defrag.defrag_size);
 	}
 
 	return err;
 }
 
+/**
+ * ext3_ext_next_extent - search for next extent and set it to "extent"
+ * @inode:	inode of the the original file
+ * @path:	this will obtain data for next extent
+ * @extent:	pointer to next extent we have just gotten
+ *
+ * This function returns 0 or 1(last_entry) if succeeded, otherwise
+ * returns -EIO
+ */
+static int
+ext3_ext_next_extent(struct inode *inode,
+		     struct ext3_ext_path *path,
+		     struct ext3_extent **extent)
+{
+	int ppos;
+	int leaf_ppos = path->p_depth;
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
+			path[ppos].p_block =
+				path[ppos].p_idx->ei_leaf;
+			if (path[ppos+1].p_bh)
+				brelse(path[ppos+1].p_bh);
+			path[ppos+1].p_bh =
+				sb_bread(inode->i_sb, path[ppos].p_block);
+			if (!path[ppos+1].p_bh)
+				return  -EIO;
+			path[ppos+1].p_hdr =
+				EXT_BLOCK_HDR(path[ppos+1].p_bh);
+
+			/* halfway index block */
+			while (++cur_ppos < leaf_ppos) {
+				path[cur_ppos].p_idx =
+					EXT_FIRST_INDEX(path[cur_ppos].p_hdr);
+				path[cur_ppos].p_block =
+					path[cur_ppos].p_idx->ei_leaf;
+				if (path[cur_ppos+1].p_bh)
+					brelse(path[cur_ppos+1].p_bh);
+				path[cur_ppos+1].p_bh = sb_bread(inode->i_sb,
+					path[cur_ppos].p_block);
+				if (!path[cur_ppos+1].p_bh)
+					return  -EIO;
+				path[cur_ppos+1].p_hdr =
+					EXT_BLOCK_HDR(path[cur_ppos+1].p_bh);
+			}
+
+			/* leaf block */
+			path[leaf_ppos].p_ext = *extent =
+				EXT_FIRST_EXTENT(path[leaf_ppos].p_hdr);
+			return 0;
+		}
+	}
+	/* last_extent */
+	return 1;
+}
+
+/**
+ * ext3_ext_remove_index_blocks - remove leaf blocks and index blocks
+ * @handle 	handle
+ * @dest_tree	extent tree of temporary inode
+ * @eh		extent header
+ * @depth	depth of extent tree
+ *
+ * This function returns 0 if succeed, otherwise returns error value
+ */
+static int ext3_ext_remove_index_blocks(handle_t *handle,
+			struct ext3_extents_tree *dest_tree,
+			struct ext3_extent_header *eh, int depth)
+{
+	struct ext3_extent_idx *idx;
+	struct buffer_head *bh;
+	int metadata = 1;
+	int count = 0;
+	int i, ret = 0;
+	int freed = 0;
+
+	if (depth == 0) {
+		eh->eh_entries = 0;
+		return 0;
+	}
+
+	idx = EXT_FIRST_INDEX(eh);
+
+	count = eh->eh_entries;
+
+	for (i = 1; i <= count; i++) {
+		if (depth > 1) {
+			bh = sb_bread(dest_tree->inode->i_sb, idx->ei_leaf);
+			if (!bh) {
+				ret = -EIO;
+			} else {
+				ret = ext3_ext_remove_index_blocks(handle,
+					dest_tree, EXT_BLOCK_HDR(bh),
+					depth - 1);
+				brelse(bh);
+			}
+		}
+		ext3_mb_free_blocks(handle, dest_tree->inode,
+				idx->ei_leaf, 1, metadata, &freed);
+		eh->eh_entries--;
+		idx++;
+	}
+	return ret;
+}
+
+/**
+ * ext3_ext_alloc_blocks - allocate contiguous block for temporary inode
+ * @handle       handle
+ * @inode_dest   temporary inode for multiple block allocation
+ * @dest_tree    ext3_extents_tree of inode_dest
+ * @iblock       file related offset
+ * @total_blocks contiguous blocks count
+ *
+ * If succeed, fuction returns extents-count we got,
+ * otherwise returns err.
+ */
+static int ext3_ext_alloc_blocks (handle_t *handle, struct inode *inode_dest,
+			struct ext3_extents_tree *dest_tree,
+			unsigned long iblock, unsigned long total_blocks)
+{
+	struct ext3_ext_path *path = NULL;
+	struct ext3_extent newex;
+	struct ext3_extent_header *eh = EXT_ROOT_HDR(dest_tree);
+	unsigned long newblock = 0;
+	unsigned long rest = total_blocks;
+	unsigned long alloc_total = 0;
+	int count = 0;
+	int goal = 0;
+	int flag = 0;
+	int err = 0;
+	int err2 = 0;
+	int len = MAX_BLOCKS_LEN;
+	flag |= EXT3_MB_HINT_RESERVED;
+
+	if (MAX_BLOCKS_LEN > total_blocks) {
+		len = total_blocks;
+	}
+
+	/* If we have already held index blocks, remove them. */
+	if (eh->eh_entries != 0) {
+		err2 = ext3_ext_remove_index_blocks(handle, dest_tree,
+					eh, eh->eh_depth);
+		if (err2 < 0) {
+			return err2;
+		}
+	}
+
+	/* Find first extent. */
+	path = ext3_ext_find_extent(dest_tree, iblock, path);
+	if (IS_ERR(path)) {
+		err = PTR_ERR(path);
+		path = NULL;
+		goto err;
+	}
+
+	goal = ext3_ext_find_goal(inode_dest, path, iblock);
+
+	while (alloc_total != total_blocks) {
+		/* Get contiguous blocks */
+		newblock = ext3_mb_new_blocks(handle, inode_dest, goal,
+							&len, flag, &err);
+		if (newblock == 0) {
+			len = len / 2;
+			if (len == 1) {
+				goto err;
+			}
+		} else {
+			/* Logical */
+			newex.ee_block = cpu_to_le32(alloc_total);
+			/* Physical start */
+			newex.ee_start = cpu_to_le32(newblock);
+			/* Physical-hi start */
+			newex.ee_start_hi = 0;
+			/* Length */
+			newex.ee_len = cpu_to_le32(len);
+
+			alloc_total += len;
+			rest = rest - len;
+			if (rest < len) {
+				len = rest;
+			}
+
+			goal = newblock + len;
+			err = ext3_ext_insert_extent(handle, dest_tree,
+						path, &newex);
+			if (err) {
+				goto err;
+			} else {
+				count++;
+			}
+		}
+	}
+	if (path) {
+		ext3_ext_drop_refs(path);
+		kfree(path);
+	}
+	return count;
+err:
+	/* We have to remove halfway blocks, if we failed. */
+	if (alloc_total != 0) {
+		err2 = ext3_ext_remove_space(dest_tree, iblock, alloc_total);
+	}
+	if (path) {
+		ext3_ext_drop_refs(path);
+		kfree(path);
+	}
+	if (err2 == 0) {
+		return err;
+	} else {
+		return err2;
+	}
+}
+
+/**
+ * ext3_ext_new_extent_tree -  allocate contiguous blocks
+ * @tmp_inode:		inode of the temporary file
+ * @org_tree:		extent tree of the original inode
+ * @dest_tree:		extent tree of the temporary inode
+ * @path:		the structure holding some info about
+ *			original extent tree
+ * @page_offset:	starting offset to defrag in pages
+ * @nr_to_read:		the number of pages to read
+ *
+ * This function returns 0 if succeeded, otherwise returns error value
+ */
+static int
+ext3_ext_new_extent_tree(struct inode *tmp_inode,
+			 struct ext3_extents_tree *org_tree,
+			 struct ext3_extents_tree *dest_tree,
+			 struct ext3_ext_path *path,
+			 pgoff_t page_offset, pgoff_t nr_to_read)
+{
+	struct ext3_extent *ext = NULL;
+	struct ext3_extent_header *eh = NULL;
+	handle_t *handle;
+	unsigned blocks_per_page = PAGE_SIZE >> tmp_inode->i_blkbits;
+	unsigned long tar_start = page_offset * blocks_per_page;
+	unsigned long tar_end =
+		((page_offset + nr_to_read) * blocks_per_page) - 1;
+	unsigned long seq_blocks = tar_end - tar_start + 1;
+	int sum_org = 0, sum_tmp = 0;
+	unsigned jnum;
+	int ret = 0, err = 0, depth;
+	int last_extent = 0;
+
+	/* (blocks_per_page * count) * (extent_blocks + index_blocks)
+	 * + super_block + block_bitmap + group_descriptor
+	 * jnum = ext3_ext_writepage_trans_blocks(inode, count) + 3;
+	 */
+	/* TODO:
+	 * Need to consider the way of calculating journal blocks
+	 * because j_max_transaction_buffer may exceed 2048
+	 * if we have a deep depth.
+	 */
+	jnum = 2048;
+	eh = EXT_ROOT_HDR(dest_tree);
+	eh->eh_depth = 0;
+	handle = ext3_journal_start(tmp_inode, jnum);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto ERR1;
+	}
+
+	ext3_extent_tree_init(handle, dest_tree);
+
+	/* allocate contiguous blocks */
+	if ((sum_tmp = ext3_ext_alloc_blocks(handle, tmp_inode,
+			dest_tree, 0, seq_blocks)) < 0) {
+		ret = sum_tmp;
+		goto ERR2;
+	}
+	depth = EXT_DEPTH(org_tree);
+	ext = path[depth].p_ext;
+
+	while (1) {
+		if (!last_extent)
+			++sum_org;
+
+		if (tar_end <= le32_to_cpu(ext->ee_block) +
+				le32_to_cpu(ext->ee_len) - 1 ||
+				last_extent) {
+
+			/* fragment decreased */
+			if (sum_org > sum_tmp) {
+				if (tar_end == le32_to_cpu(ext->ee_block) +
+						le32_to_cpu(ext->ee_len) - 1) {
+					/* update path with next extent */
+					if ((last_extent =
+						ext3_ext_next_extent(tmp_inode,
+							path, &ext)) < 0) {
+						ret = last_extent;
+						break;
+					}
+				}
+			} else {
+				/* fragment increased */
+				ret = -ENOSPC;
+			}
+			break;
+		}
+
+		if ((last_extent =
+				ext3_ext_next_extent(tmp_inode,
+					path, &ext)) < 0) {
+			ret = last_extent;
+			break;
+		}
+	}
+
+ERR2:
+	err = ext3_journal_stop(handle);
+	if (ret >= 0)
+		ret = err;
+ERR1:
+	return ret;
+}
+
+/**
+ * ext3_ext_defrag - defrag whole file
+ * @filp:		pointer to file
+ * @from:		starting offset to defrag in bytes
+ * @defrag_size:	size of defrag in bytes
+ *
+ * This function returns the number of pages if succeeded, otherwise
+ * returns error value
+ */
+int
+ext3_ext_defrag(struct file *filp, loff_t from, loff_t defrag_size)
+{
+	struct inode *inode = filp->f_dentry->d_inode, *tmp_inode = NULL;
+	struct ext3_extents_tree org_tree, dest_tree;
+	struct ext3_ext_path *path = NULL;
+	pgoff_t page_offset = from >> PAGE_SHIFT;
+	pgoff_t page_start = page_offset;
+	pgoff_t page_end = (from + defrag_size - 1) >> PAGE_SHIFT;
+	pgoff_t nr_to_read = DEFRAG_PAGES;
+	pgoff_t page_cnt = (defrag_size + PAGE_SIZE -1) >> PAGE_SHIFT;
+	pgoff_t	dest_offset = 0;
+	int ret = 0;
+
+	tmp_inode = new_inode(inode->i_sb);
+	if (!tmp_inode) {
+		ret = -ENOMEM;
+		goto ERR1;
+	}
+
+	mutex_lock(&inode->i_mutex);
+	ext3_init_tree_desc(&org_tree, inode);
+	ext3_init_tree_desc(&dest_tree, tmp_inode);
+
+	path = ext3_ext_find_extent(&org_tree, 0, NULL);
+	if (IS_ERR(path)) {
+		ret = PTR_ERR(path);
+		goto ERR2;
+	}
+
+	if ((ret = ext3_ext_new_extent_tree(tmp_inode, &org_tree,
+		&dest_tree, path, page_start, page_cnt)) < 0) {
+		goto ERR3;
+	}
+
+	while (page_offset <= page_end) {
+		if (nr_to_read > page_end - page_offset + 1)
+			nr_to_read = page_end - page_offset + 1;
+
+		/* replace original branches for new branches */
+		if ((ret = ext3_ext_defrag_partial(filp, &org_tree,
+				&dest_tree, page_offset, dest_offset,
+				nr_to_read)) < 0)
+			break;
+
+		page_offset += nr_to_read;
+		dest_offset += nr_to_read;
+	}
+ERR3:
+	if (path) {
+		ext3_ext_drop_refs(path);
+		kfree(path);
+	}
+ERR2:
+	mutex_unlock(&inode->i_mutex);
+	iput(tmp_inode);
+ERR1:
+	return (ret ? ret : ((page_offset - page_start) << PAGE_SHIFT));
+}
+
 EXPORT_SYMBOL(ext3_init_tree_desc);
 EXPORT_SYMBOL(ext3_mark_inode_dirty);
 EXPORT_SYMBOL(ext3_ext_invalidate_cache);
@@ -2353,3 +2760,5 @@ EXPORT_SYMBOL(ext3_ext_insert_extent);
 EXPORT_SYMBOL(ext3_ext_walk_space);
 EXPORT_SYMBOL(ext3_ext_find_goal);
 EXPORT_SYMBOL(ext3_ext_calc_credits_for_insert);
+
+
diff -upNr -X linux-2.6.16.8-alex-org/Documentation/dontdiff linux-2.6.16.8-alex-org/fs/ext3/ioctl.c linux-2.6.16.8-tmp1/fs/ext3/ioctl.c
--- linux-2.6.16.8-alex-org/fs/ext3/ioctl.c	2006-11-08 21:20:26.000000000 +0900
+++ linux-2.6.16.8-tmp1/fs/ext3/ioctl.c	2006-11-08 21:21:41.000000000 +0900
@@ -103,6 +103,7 @@ flags_err:
 	case EXT3_IOC_GET_EXTENTS:
 	case EXT3_IOC_GET_TREE_STATS:
 	case EXT3_IOC_GET_TREE_DEPTH:
+	case EXT3_IOC_DEFRAG:
 		return ext3_ext_ioctl(inode, filp, cmd, arg);
 	case EXT3_IOC_GETVERSION:
 	case EXT3_IOC_GETVERSION_OLD:
diff -upNr -X linux-2.6.16.8-alex-org/Documentation/dontdiff linux-2.6.16.8-alex-org/include/linux/ext3_fs.h linux-2.6.16.8-tmp1/include/linux/ext3_fs.h
--- linux-2.6.16.8-alex-org/include/linux/ext3_fs.h	2006-11-08 21:20:31.000000000 +0900
+++ linux-2.6.16.8-tmp1/include/linux/ext3_fs.h	2006-11-08 21:21:52.000000000 +0900
@@ -229,6 +229,14 @@ struct ext3_new_group_data {
 	__u32 free_blocks_count;
 };
 
+/* Used for defrag */
+struct ext3_ext_defrag_data {
+	loff_t start_offset; /* start offset to defrag in byte */
+	loff_t defrag_size;  /* size of defrag in bytes */
+};
+
+#define	DEFRAG_PAGES	128  /* the number of pages to defrag at one time */
+#define MAX_BLOCKS_LEN	16384 /* Maximum length of contiguous blocks */
 
 /*
  * ioctl commands
@@ -249,6 +257,7 @@ struct ext3_new_group_data {
 #define EXT3_IOC_GET_EXTENTS		_IOR('f', 7, long)
 #define EXT3_IOC_GET_TREE_DEPTH		_IOR('f', 8, long)
 #define EXT3_IOC_GET_TREE_STATS		_IOR('f', 9, long)
+#define EXT3_IOC_DEFRAG			_IOW('f', 10, struct ext3_ext_defrag_data)
 
 /*
  *  Mount options
@@ -812,6 +821,7 @@ extern void ext3_set_aops(struct inode *
 /* ioctl.c */
 extern int ext3_ioctl (struct inode *, struct file *, unsigned int,
 		       unsigned long);
+extern int ext3_ext_defrag(struct file *, loff_t, loff_t);
 
 /* namei.c */
 extern int ext3_orphan_add(handle_t *, struct inode *);
@@ -882,6 +892,9 @@ extern int ext3_mb_reserve_blocks(struct
 extern void ext3_mb_release_blocks(struct super_block *, int);
 int __init init_ext3_proc(void);
 void exit_ext3_proc(void);
+extern void ext3_mb_free_blocks(handle_t *handle, struct inode *inode,
+			unsigned long block, unsigned long count,
+			int metadata, int *freed);
 
 /* writeback.c */
 extern int ext3_wb_writepages(struct address_space *, struct writeback_control *);

