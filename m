From: sho@tnes.nec.co.jp
Subject: [RFC][PATCH 1/3] Allocate new contiguous blocks
Date: Tue, 16 Jan 2007 21:04:29 +0900
Message-ID: <20070116210429sho@rifu.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO200.gate.nec.co.jp ([210.143.35.50]:36558 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbXAPMIt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 16 Jan 2007 07:08:49 -0500
Received: from tyo201.gate.nec.co.jp ([10.7.69.201])
	by tyo200.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l0GC8meW008454
	for <linux-ext4@vger.kernel.org>; Tue, 16 Jan 2007 21:08:48 +0900 (JST)
Received: from mailgate3.nec.co.jp (mailgate54.nec.co.jp [10.7.69.197])
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l0GC4kKq009536
	for <linux-ext4@vger.kernel.org>; Tue, 16 Jan 2007 21:04:46 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l0GC4kG13960 for linux-ext4@vger.kernel.org; Tue, 16 Jan 2007 21:04:46 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv3.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id l0GC4kI06470 for <linux-ext4@vger.kernel.org>; Tue, 16 Jan 2007 21:04:46 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070116.210446.10900436 for <linux-ext4@vger.kernel.org>
	; Tue, 16 Jan 2007 21:04:46 +0900
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Search contiguous free blocks with Alex's mutil-block allocation
and allocate them for the temporary inode.

This patch applies on top of Alex's patches.
"[RFC] delayed allocation, mballoc, etc"
http://marc.theaimsgroup.com/?l=linux-ext4&m=116493228301966&w=2

Signed-off-by: Takashi Sato <sho@tnes.nec.co.jp>
---
diff -Nrup -X linux-2.6.19-rc6-org/Documentation/dontdiff linux-2.6.19-rc6-org/fs/ext4/extents.c linux-2.6.19-rc6-1/fs/ext4/extents.c
--- linux-2.6.19-rc6-org/fs/ext4/extents.c	2007-01-16 11:35:14.000000000 +0900
+++ linux-2.6.19-rc6-1/fs/ext4/extents.c	2007-01-16 09:46:13.000000000 +0900
@@ -2335,6 +2335,657 @@ int ext4_ext_calc_metadata_amount(struct
 	return num;
 }
 
+/*
+ * this structure is used to gather extents from the tree via ioctl
+ */
+struct ext4_extent_buf {
+	unsigned long start;
+	int buflen;
+	void *buffer;
+	void *cur;
+	int err;
+};
+
+/*
+ * this structure is used to collect stats info about the tree
+ */
+struct ext4_extent_tree_stats {
+	int depth;
+	int extents_num;
+	int leaf_num;
+};
+
+static int
+ext4_ext_store_extent_cb(struct inode *inode,
+			struct ext4_ext_path *path,
+			struct ext4_ext_cache *newex,
+			struct ext4_extent_buf *buf)
+{
+
+	if (newex->ec_type != EXT4_EXT_CACHE_EXTENT)
+		return EXT_CONTINUE;
+
+	if (buf->err < 0)
+		return EXT_BREAK;
+	if (buf->cur - buf->buffer + sizeof(*newex) > buf->buflen)
+		return EXT_BREAK;
+
+	if (!copy_to_user(buf->cur, newex, sizeof(*newex))) {
+		buf->err++;
+		buf->cur += sizeof(*newex);
+	} else {
+		buf->err = -EFAULT;
+		return EXT_BREAK;
+	}
+	return EXT_CONTINUE;
+}
+
+static int
+ext4_ext_collect_stats_cb(struct inode *inode,
+			struct ext4_ext_path *path,
+			struct ext4_ext_cache *ex,
+			struct ext4_extent_tree_stats *buf)
+{
+	int depth;
+
+	if (ex->ec_type != EXT4_EXT_CACHE_EXTENT)
+		return EXT_CONTINUE;
+
+	depth = ext_depth(inode);
+	buf->extents_num++;
+	if (path[depth].p_ext == EXT_FIRST_EXTENT(path[depth].p_hdr))
+		buf->leaf_num++;
+	return EXT_CONTINUE;
+}
+
+int ext4_ext_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
+			unsigned long arg)
+{
+	int err = 0;
+	if (cmd != EXT4_IOC_GET_DATA_BLOCK) {
+		if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
+			return -EINVAL;
+	}
+
+	if (cmd == EXT4_IOC_GET_EXTENTS) {
+		struct ext4_extent_buf buf;
+
+		if (copy_from_user(&buf, (void *) arg, sizeof(buf)))
+			return -EFAULT;
+
+		buf.cur = buf.buffer;
+		buf.err = 0;
+		mutex_lock(&EXT4_I(inode)->truncate_mutex);
+		err = ext4_ext_walk_space(inode, buf.start, EXT_MAX_BLOCK,
+				(void *)ext4_ext_store_extent_cb, &buf);
+		mutex_unlock(&EXT4_I(inode)->truncate_mutex);
+		if (err == 0)
+			err = buf.err;
+	} else if (cmd == EXT4_IOC_GET_TREE_STATS) {
+		struct ext4_extent_tree_stats buf;
+
+		mutex_lock(&EXT4_I(inode)->truncate_mutex);
+		buf.depth = ext_depth(inode);
+		buf.extents_num = 0;
+		buf.leaf_num = 0;
+		err = ext4_ext_walk_space(inode, 0, EXT_MAX_BLOCK,
+				(void *)ext4_ext_collect_stats_cb, &buf);
+		mutex_unlock(&EXT4_I(inode)->truncate_mutex);
+		if (!err)
+			err = copy_to_user((void *) arg, &buf, sizeof(buf));
+	} else if (cmd == EXT4_IOC_GET_TREE_DEPTH) {
+		mutex_lock(&EXT4_I(inode)->truncate_mutex);
+		err = ext_depth(inode);
+		mutex_unlock(&EXT4_I(inode)->truncate_mutex);
+        } else if (cmd == EXT4_IOC_GET_DATA_BLOCK) {
+		struct inode *inode = filp->f_dentry->d_inode;
+		struct super_block *sb = inode->i_sb;
+		unsigned long group;
+		int has_super = 0;
+		ext4_fsblk_t group_first_block = 0;
+
+		group = (inode->i_ino - 1) / EXT4_INODES_PER_GROUP(sb);
+		if (ext4_bg_has_super(sb, group))
+				has_super = 1;
+
+		group_first_block = has_super +
+			ext4_group_first_block_no(sb, group);
+
+		if (copy_to_user((ext4_fsblk_t *) arg ,
+			&group_first_block, sizeof(group_first_block)))
+				return -EFAULT;
+
+	} else if (cmd == EXT4_IOC_DEFRAG) {
+		struct ext4_ext_defrag_data defrag;
+
+		if (copy_from_user(&defrag,
+				(struct ext4_ext_defrag_data __user *)arg,
+				sizeof(defrag)))
+			return -EFAULT;
+
+		err = ext4_ext_defrag(filp, defrag.start_offset,
+					defrag.defrag_size, defrag.goal);
+	}
+
+	return err;
+}
+
+/**
+ * ext4_ext_next_extent - search for next extent and set it to "extent"
+ * @inode:	inode of the the original file
+ * @path:	this will obtain data for next extent
+ * @extent:	pointer to next extent we have just gotten
+ *
+ * This function returns 0 or 1(last_entry) if succeeded, otherwise
+ * returns -EIO
+ */
+static int
+ext4_ext_next_extent(struct inode *inode,
+		     struct ext4_ext_path *path,
+		     struct ext4_extent **extent)
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
+				idx_pblock(path[ppos].p_idx);		
+			if (path[ppos+1].p_bh)
+				brelse(path[ppos+1].p_bh);
+			path[ppos+1].p_bh =
+				sb_bread(inode->i_sb, path[ppos].p_block);
+			if (!path[ppos+1].p_bh)
+				return  -EIO;
+			path[ppos+1].p_hdr =
+				ext_block_hdr(path[ppos+1].p_bh);
+
+			/* halfway index block */
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
+					return  -EIO;
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
+	/* last_extent */
+	return 1;
+}
+
+/**
+ * ext4_ext_alloc_blocks - allocate contiguous blocks to temporary inode
+ * @dest_inode   temporary inode for multiple block allocation
+ * @iblock       file related offset
+ * @total_blocks contiguous blocks count
+ * @goal         block offset for allocation
+ *
+ * If succeed, fuction returns count of extent we got,
+ * otherwise returns err.
+ */
+static int ext4_ext_alloc_blocks(struct inode *dest_inode,
+		unsigned long iblock, unsigned long total_blocks,
+		ext4_fsblk_t goal)
+{
+	struct ext4_ext_path *path = NULL;
+	struct ext4_extent newex;
+	struct ext4_extent_header *eh = ext_inode_hdr(dest_inode);
+	struct ext4_allocation_request ar;
+	handle_t *handle = NULL;
+	ext4_fsblk_t newblock = 0;
+	unsigned long rest = total_blocks;
+	unsigned long alloc_total = 0;
+	int depth = ext_depth(dest_inode);
+	int count = 0;
+	int credits = 0;
+	int err = 0;
+	int err2 = 0;
+
+	if (MAX_BLOCKS_LEN > total_blocks)
+		ar.len = total_blocks;
+	else 	
+		ar.len = MAX_BLOCKS_LEN;
+
+	/* If we have already held index blocks, remove them. */
+	if (eh->eh_entries != 0) {
+		handle = ext4_journal_start(dest_inode, depth + 1);
+		if (IS_ERR(handle))
+			return PTR_ERR(handle);
+
+		err2 = ext4_ext_remove_index_blocks(handle, dest_inode,
+					eh, eh->eh_depth);
+		ext4_journal_stop(handle);
+		if (err2 < 0)
+			return err2;
+
+	}
+
+	/* Find first extent. */
+	path = ext4_ext_find_extent(dest_inode, iblock, path);
+	if (IS_ERR(path)) {
+		err = PTR_ERR(path);
+		path = NULL;
+		goto out2;
+	}
+
+	ar.inode = dest_inode;
+	ar.flags = EXT4_MB_HINT_DATA | EXT4_MB_HINT_RESERVED
+		| EXT4_MB_HINT_NOPREALLOC;
+
+	if (goal)
+		ar.goal = goal;
+	else
+		ar.goal = ext4_ext_find_goal(dest_inode, path, iblock);
+	
+	ar.logical = iblock;
+	ar.lleft = 0;
+	ar.pleft = 0;
+	ar.lright = 0;
+	ar.pright = 0;
+
+	handle = ext4_journal_start(dest_inode, credits);
+	if (IS_ERR(handle)) {
+		err = PTR_ERR(handle);
+		goto out2;
+	}
+
+	while (alloc_total != total_blocks) {
+		credits = ext4_ext_calc_credits_for_insert(dest_inode, path);
+		handle = ext4_ext_journal_restart(handle,
+				credits + EXT4_TRANS_META_BLOCKS);
+
+		if (IS_ERR(handle))
+			return PTR_ERR(handle);
+
+		newblock = ext4_mb_new_blocks(handle, &ar, &err);
+		if (!newblock) {
+			ar.len = ar.len / 2;
+			if (ar.len == 1) 
+				goto out;
+			
+		} else {
+			newex.ee_block = cpu_to_le32(alloc_total);
+			ext4_ext_store_pblock(&newex, newblock);
+			newex.ee_len = cpu_to_le16(ar.len);
+
+			alloc_total += ar.len;
+			rest = rest - ar.len;
+			if (rest < ar.len) 
+				ar.len = rest;
+
+			ar.goal = newblock + ar.len;
+
+			err = ext4_ext_insert_extent(handle, dest_inode,
+						path, &newex);
+			if (err)
+				goto out;
+			else
+				count++;
+		}
+	}
+	if (path) {
+		ext4_ext_drop_refs(path);
+		kfree(path);
+	}
+	ext4_journal_stop(handle);
+	return count;
+out:
+	/* We have to remove halfway blocks, if we failed. */
+	if (alloc_total != 0) 
+		err2 = ext4_ext_remove_space(dest_inode, 0);
+
+out2:
+	if (path) {
+		ext4_ext_drop_refs(path);
+		kfree(path);
+	}
+	ext4_journal_stop(handle);
+
+	if (err2 == 0) 
+		return err;
+	else
+		return err2;
+}
+
+/**
+ * ext4_ext_new_extent_tree -  allocate contiguous blocks
+ * @inode:		inode of the original file
+ * @tmp_inode:		inode of the temporary file
+ * @path:		the structure holding some info about
+ *			original extent tree
+ * @tar_start:		starting offset to allocate in blocks
+ * @tar_blocks:		the number of blocks to allocate
+ * @goal:		block offset for allocaton
+ *
+ * This function returns the value as below:
+ * 	0(succeeded)
+ *	1(not improved)
+ *	negative value(error)
+ */
+static int
+ext4_ext_new_extent_tree(struct inode *inode,
+			 struct inode *tmp_inode,
+			 struct ext4_ext_path *path,
+			 unsigned long tar_start,
+			 unsigned long tar_blocks,
+			 ext4_fsblk_t goal)
+{
+	struct ext4_extent *ext = NULL;
+	struct ext4_extent_header *eh = NULL;
+	unsigned long tar_end = tar_start + tar_blocks - 1;
+	int sum_org = 0, sum_tmp = 0;
+	int ret = 0, depth;
+	int last_extent = 0;
+
+	eh = ext_inode_hdr(tmp_inode);
+	eh->eh_depth = 0;
+
+	/* allocate contiguous blocks */
+	if ((sum_tmp = ext4_ext_alloc_blocks(tmp_inode, 0,
+					tar_blocks, goal)) < 0) {
+		ret = sum_tmp;
+		goto ERR;
+	}
+
+	depth = ext_depth(inode);
+	ext = path[depth].p_ext;
+	while (1) {
+		if (!last_extent)
+			++sum_org;
+
+		if (tar_end <= le32_to_cpu(ext->ee_block) +
+			       le32_to_cpu(ext->ee_len) - 1 ||
+			       last_extent) {
+
+			if ((sum_org == sum_tmp) && !goal) {
+				/* not improved */
+				if (!(ret = ext4_ext_remove_space(tmp_inode, 0)))
+					ret = 1;			
+			} else if (sum_org < sum_tmp) {
+				/* fragment increased */
+				if (!(ret = ext4_ext_remove_space(tmp_inode, 0)))
+					ret = -ENOSPC;
+				printk("defrag failed due to no space\n");
+			}
+			break;
+		}
+		if ((last_extent =
+			ext4_ext_next_extent(tmp_inode,
+				path, &ext)) < 0) {
+			ret = last_extent;
+			break;
+		}
+	}
+ERR:
+	return ret;
+}
+
+extern spinlock_t inode_lock;
+
+/**
+ * delete_ext_defrag_inode - delete the temporary inode
+ * @inode pointer to the temporary inode
+ */
+static int
+delete_ext_defrag_inode(struct inode *inode, unsigned long delete_start)
+{
+	int ret=0;
+	struct ext4_extent_header *eh;
+	handle_t *handle;
+	int depth;
+
+	ret = ext4_ext_remove_space(inode, delete_start); 
+	eh = ext_inode_hdr(inode);
+	depth = eh->eh_depth;
+	handle = ext4_journal_start(inode, depth + 1);
+	if (IS_ERR(handle)) {
+		return PTR_ERR(handle);
+	}
+	ret = ext4_ext_remove_index_blocks(handle, inode,
+			eh, depth);
+	ret = ext4_journal_stop(handle);
+
+	spin_lock(&inode_lock);
+	list_del_init(&inode->i_list);
+	list_del_init(&inode->i_sb_list);
+	inodes_stat.nr_inodes--;
+	spin_unlock(&inode_lock);
+	inode->i_sb->s_op->destroy_inode(inode);
+	return ret;
+}
+
+/**
+ * ext4_ext_defrag - defrag whole file
+ * @filp:		pointer to file
+ * @from:		starting offset to defrag in bytes
+ * @defrag_size:	size of defrag in bytes
+ * @goal:		block offset for allocation
+ *
+ * This function returns the number of pages if succeeded, otherwise
+ * returns error value
+ */
+int
+ext4_ext_defrag(struct file *filp, loff_t from, loff_t defrag_size,
+						ext4_fsblk_t goal)
+{
+	struct inode *inode = filp->f_dentry->d_inode, *tmp_inode = NULL;
+	struct ext4_ext_path *path = NULL, *holecheck_path = NULL;
+	struct ext4_extent *ext_prev = NULL, *ext_cur = NULL, *ext_dummy = NULL;
+	handle_t *handle;
+	pgoff_t page_offset = 0;
+	pgoff_t dest_offset = 0;
+	pgoff_t page_start = from >> PAGE_SHIFT;
+	pgoff_t page_end = (from + defrag_size - 1) >> PAGE_SHIFT;
+	pgoff_t seq_end_page = 0;
+	unsigned long block_start = from >> inode->i_blkbits;
+	unsigned long block_end = (from + defrag_size - 1) >> inode->i_blkbits;
+	unsigned long seq_blocks = 0, seq_start = 0;
+	unsigned long add_blocks = 0;
+	int ret = 0, ret2 = 0, depth = 0, last_extent = 0, seq_extents = 0;
+	unsigned long delete_start = 0;
+	tmp_inode = new_inode(inode->i_sb);
+	if (!tmp_inode) {
+		ret = -ENOMEM;
+		goto ERR1;
+	}
+
+	mutex_lock(&inode->i_mutex);
+	handle = ext4_journal_start(tmp_inode, 1);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto ERR2;
+	}
+	ext4_ext_tree_init(handle, tmp_inode);
+	ext4_journal_stop(handle);
+
+	path = ext4_ext_find_extent(inode, block_start, NULL);
+	if (IS_ERR(path)) {
+		ret = PTR_ERR(path);
+		path = NULL;
+		goto ERR2;
+	}
+
+	/* get path structure to check hole */
+	holecheck_path = ext4_ext_find_extent(inode, block_start, NULL);
+	if (IS_ERR(holecheck_path)) {
+		ret = PTR_ERR(holecheck_path);
+		holecheck_path = NULL;
+		goto ERR2;
+	}
+
+	depth = ext_depth(inode);
+	ext_cur = holecheck_path[depth].p_ext;
+
+	/*
+	 * if block_start was within the hole, get proper extent whose ee_block
+	 * is beyond block_start
+	 */
+	if (ext_cur->ee_block + ext_cur->ee_len - 1 < block_start) {
+		if ((last_extent =
+				ext4_ext_next_extent(inode, holecheck_path,
+				&ext_cur)) < 0) {
+			ret = last_extent;
+			goto ERR2;
+		}
+		if ((last_extent =
+				ext4_ext_next_extent(inode, path,
+				&ext_dummy)) < 0) {
+			ret = last_extent;
+			goto ERR2;
+		}
+	}
+	seq_extents = 1;
+	seq_start = ext_cur->ee_block;
+
+	/* no blocks existed within designated range */
+	if (ext_cur->ee_block > block_end) {
+		printk("nothing done due to the lack of contiguous blocks\n");
+		goto ERR2;
+	}
+
+	/* adjust start blocks */
+	add_blocks = min((unsigned long)(ext_cur->ee_block +
+			 ext_cur->ee_len), block_end + 1) -
+		     max((unsigned long)ext_cur->ee_block, block_start);
+
+	while (!last_extent && ext_cur->ee_block <= block_end) {
+		seq_blocks += add_blocks;
+
+		/* adjust tail blocks */
+		if (seq_start + seq_blocks - 1 > block_end) {
+			seq_blocks = block_end - seq_start + 1;
+		}
+
+		ext_prev = ext_cur;
+		if ((last_extent =
+				ext4_ext_next_extent(inode, holecheck_path,
+				&ext_cur)) < 0) {
+			ret = last_extent;
+			break;
+		}
+		if (!last_extent)
+			seq_extents++;
+		add_blocks = ext_cur->ee_len;
+
+		/* found hole or reached the tail of either a designated range
+		 * or the file
+		 */
+		if ((ext_prev->ee_block + ext_prev->ee_len ==
+				ext_cur->ee_block &&
+				block_end >= ext_cur->ee_block &&
+				!last_extent)) {
+			continue;
+		}
+
+		/* found an isolated block */
+		if ((seq_extents == 1) && !goal) {
+			seq_start = ext_cur->ee_block;
+			goto CLEANUP;
+		}
+
+		ret = ext4_ext_new_extent_tree(inode, tmp_inode, path,
+					seq_start, seq_blocks, goal);
+
+		if (ret < 0) {
+			break;
+		} else if ((ret == 1) && !goal) {
+			ret = 0;
+			seq_start = ext_cur->ee_block;
+			goto CLEANUP;
+		}
+
+		delete_start=0;
+		page_offset = seq_start >>
+				(PAGE_CACHE_SHIFT - inode->i_blkbits);
+		seq_end_page = (seq_start + seq_blocks - 1) >>
+				(PAGE_CACHE_SHIFT - inode->i_blkbits);
+
+		dest_offset = 0;
+		seq_start = ext_cur->ee_block;
+
+		/* Discard all preallocations.
+		 * This is provisional solution.
+		 * When true ext4_mb_return_to_preallocation() is
+		 * implemented, this will be removed.
+		 */
+		ext4_mb_discard_inode_preallocations(inode);
+
+		while (page_offset <= seq_end_page) {
+			/* replace original branches for new branches */
+			if ((ret = ext4_ext_defrag_partial(tmp_inode, filp,
+					page_offset, dest_offset,
+					&delete_start)) < 0)
+				goto ERR2;
+
+			page_offset++;
+			dest_offset++;
+		}
+
+		holecheck_path =
+			ext4_ext_find_extent(inode, seq_start, holecheck_path);
+		if (IS_ERR(holecheck_path)) {
+			ret = PTR_ERR(holecheck_path);
+			holecheck_path = NULL;
+			break;
+		}
+CLEANUP:
+		path = ext4_ext_find_extent(inode, seq_start, path);
+		if (IS_ERR(path)) {
+			ret = PTR_ERR(path);
+			path = NULL;
+			break;
+		}
+
+		ext_cur = holecheck_path[depth].p_ext;
+		add_blocks = ext_cur->ee_len;
+		seq_blocks = 0;
+		dest_offset = 0;
+		seq_extents = 1;
+	}
+ERR2:
+	if (path) {
+		ext4_ext_drop_refs(path);
+		kfree(path);
+	}
+	if (holecheck_path) {
+		ext4_ext_drop_refs(holecheck_path);
+		kfree(holecheck_path);
+	}
+
+	mutex_unlock(&inode->i_mutex);
+	ret2 = delete_ext_defrag_inode(tmp_inode, delete_start);
+	if (ret2 < 0) {
+		ret =ret2;
+	}
+ERR1:
+	return (ret ? ret : ((page_end - page_start + 1) << PAGE_SHIFT));
+}
+
 EXPORT_SYMBOL(ext4_mark_inode_dirty);
 EXPORT_SYMBOL(ext4_ext_invalidate_cache);
 EXPORT_SYMBOL(ext4_ext_insert_extent);
diff -Nrup -X linux-2.6.19-rc6-org/Documentation/dontdiff linux-2.6.19-rc6-org/fs/ext4/ioctl.c linux-2.6.19-rc6-1/fs/ext4/ioctl.c
--- linux-2.6.19-rc6-org/fs/ext4/ioctl.c	2006-11-16 13:03:40.000000000 +0900
+++ linux-2.6.19-rc6-1/fs/ext4/ioctl.c	2007-01-16 09:38:48.000000000 +0900
@@ -246,6 +246,13 @@ flags_err:
 		jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
 
 		return err;
+	} 
+	case EXT4_IOC_GET_EXTENTS:
+	case EXT4_IOC_GET_TREE_STATS:
+	case EXT4_IOC_GET_TREE_DEPTH:
+	case EXT4_IOC_GET_DATA_BLOCK:
+	case EXT4_IOC_DEFRAG: {
+		return ext4_ext_ioctl(inode, filp, cmd, arg);
 	}
 
 	default:
diff -Nrup -X linux-2.6.19-rc6-org/Documentation/dontdiff linux-2.6.19-rc6-org/include/linux/ext4_fs.h linux-2.6.19-rc6-1/include/linux/ext4_fs.h
--- linux-2.6.19-rc6-org/include/linux/ext4_fs.h	2007-01-16 11:35:14.000000000 +0900
+++ linux-2.6.19-rc6-1/include/linux/ext4_fs.h	2007-01-16 09:38:48.000000000 +0900
@@ -255,6 +255,15 @@ struct ext4_new_group_data {
 	__u32 free_blocks_count;
 };
 
+/* Used for defrag */
+struct ext4_ext_defrag_data {
+	loff_t start_offset; /* start offset to defrag in byte */
+	loff_t defrag_size;  /* size of defrag in bytes */
+	ext4_fsblk_t goal;   /* block offset for allocation */
+};
+
+#define MAX_BLOCKS_LEN  16384 /* Maximum length of contiguous blocks */
+#define EXT4_TRANS_META_BLOCKS	4 /* bitmap + group desc + sb + inode */
 
 /*
  * ioctl commands
@@ -272,6 +281,11 @@ struct ext4_new_group_data {
 #endif
 #define EXT4_IOC_GETRSVSZ		_IOR('f', 5, long)
 #define EXT4_IOC_SETRSVSZ		_IOW('f', 6, long)
+#define EXT4_IOC_GET_EXTENTS		_IOR('f', 7, long)
+#define EXT4_IOC_GET_TREE_DEPTH		_IOR('f', 8, long)
+#define EXT4_IOC_GET_TREE_STATS		_IOR('f', 9, long)
+#define EXT4_IOC_GET_DATA_BLOCK		_IOW('f', 9, ext4_fsblk_t)
+#define EXT4_IOC_DEFRAG			_IOW('f', 10, struct ext4_ext_defrag_data)
 
 /*
  * ioctl commands in 32 bit emulation
@@ -944,6 +958,7 @@ extern int ext4_block_truncate_page(hand
 extern int ext4_ioctl (struct inode *, struct file *, unsigned int,
 		       unsigned long);
 extern long ext4_compat_ioctl (struct file *, unsigned int, unsigned long);
+extern int ext4_ext_defrag(struct file *, loff_t, loff_t, ext4_fsblk_t);
 
 /* namei.c */
 extern int ext4_orphan_add(handle_t *, struct inode *);
@@ -1056,6 +1071,8 @@ extern int ext4_ext_get_blocks(handle_t 
 extern void ext4_ext_truncate(struct inode *, struct page *);
 extern void ext4_ext_init(struct super_block *);
 extern void ext4_ext_release(struct super_block *);
+extern int ext4_ext_ioctl(struct inode *, struct file *, unsigned int,
+				unsigned long);
 static inline int
 ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
 			unsigned long max_blocks, struct buffer_head *bh,
