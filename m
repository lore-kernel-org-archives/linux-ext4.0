From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: [RFC][PATCH 1/10] Allocate new contiguous blocks
Date: Thu, 21 Jun 2007 10:51:50 +0900
Message-ID: <20070621105150t-sato@rifu.yk.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:37662 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708AbXFUBvv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 20 Jun 2007 21:51:51 -0400
Received: from mailgate3.nec.co.jp (mailgate53.nec.co.jp [10.7.69.162])
	by tyo202.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id l5L1po2s018932
	for <linux-ext4@vger.kernel.org>; Thu, 21 Jun 2007 10:51:50 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id l5L1poG29460 for linux-ext4@vger.kernel.org; Thu, 21 Jun 2007 10:51:50 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv.nec.co.jp (8.11.7/3.7W-MAILSV-NEC) with ESMTP
	id l5L1pnB14226 for <linux-ext4@vger.kernel.org>; Thu, 21 Jun 2007 10:51:49 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20070621.105148.73401436 for <linux-ext4@vger.kernel.org>
	; Thu, 21 Jun 2007 10:51:48 +0900
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Search contiguous free blocks with Alex's mutil-block allocation
and allocate them for the temporary inode.

This patch applies on top of Alex's patches.
"[RFC] delayed allocation, mballoc, etc"
http://marc.theaimsgroup.com/?l=linux-ext4&m=116493228301966&w=2

Signed-off-by: Takashi Sato <t-sato@yk.jp.nec.com>
Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
diff -Nrup -X linux-2.6.19-rc6-Alex/Documentation/dontdiff linux-2.6.19-rc6-Alex/fs/ext4/extents.c linux-2.6.19-rc6-1-alloc/fs/ext4/extents.c
--- linux-2.6.19-rc6-Alex/fs/ext4/extents.c	2007-06-19 20:50:56.000000000 +0900
+++ linux-2.6.19-rc6-1-alloc/fs/ext4/extents.c	2007-06-20 10:54:11.000000000 +0900
@@ -2335,6 +2335,713 @@ int ext4_ext_calc_metadata_amount(struct
 	return num;
 }
 
+/*
+ * this structure is used to gather extents from the tree via ioctl
+ */
+struct ext4_extent_buf {
+	ext4_fsblk_t start;
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
+int ext4_ext_ioctl(struct inode *inode, struct file *filp, unsigned int cmd,
+			unsigned long arg)
+{
+	int err = 0;
+	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
+			return -EINVAL;
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
+	} else if (cmd == EXT4_IOC_FIBMAP) {
+		ext4_fsblk_t __user *p = (ext4_fsblk_t __user *)arg;
+		ext4_fsblk_t block = 0;
+		struct address_space *mapping = filp->f_mapping;
+
+		if (copy_from_user(&block, (ext4_fsblk_t __user *)arg,
+					sizeof(block)))
+			return -EFAULT;
+
+		lock_kernel();
+		block = ext4_bmap(mapping, block);
+		unlock_kernel();
+
+		return put_user(block, p);
+	} else if (cmd == EXT4_IOC_DEFRAG) {
+		struct ext4_ext_defrag_data defrag;
+
+		if (copy_from_user(&defrag,
+			(struct ext4_ext_defrag_data __user *)arg,
+			sizeof(defrag)))
+			return -EFAULT;
+		err = ext4_ext_defrag(filp, defrag.start_offset,
+				defrag.defrag_size, defrag.goal, defrag.flag,
+				&defrag.ext);
+	}
+
+	return err;
+}
+
+/**
+ * ext4_ext_alloc_blocks - allocate contiguous blocks to temporary inode
+ * @dest_inode   temporary inode for multiple block allocation
+ * @org_inode    original inode
+ * @iblock       file related offset
+ * @total_blocks contiguous blocks count
+ * @goal	 block offset for allocation
+ * @phase        phase of create free space mode
+ *
+ * If succeed, fuction returns count of extent we got,
+ * otherwise returns err.
+ */
+static int ext4_ext_alloc_blocks(struct inode *dest_inode,
+		struct inode *org_inode, ext4_fsblk_t iblock,
+		ext4_fsblk_t total_blocks, ext4_fsblk_t goal, int phase)
+{
+	handle_t *handle = NULL;
+	struct ext4_ext_path *dest_path = NULL;
+	struct ext4_ext_path *org_path = NULL;
+	struct ext4_extent newex;
+	struct ext4_allocation_request ar;
+	ext4_fsblk_t newblock = 0;
+	ext4_fsblk_t rest = total_blocks;
+	ext4_fsblk_t alloc_total = 0;
+	unsigned long dest_grp_no, org_grp_no, org_len, goal_grp_no;
+	ext4_grpblk_t dest_blk_off, org_blk_off, goal_blk_off;
+	int org_depth = ext_depth(org_inode);
+	int metadata = 1;
+	int count = 0;
+	int credits = 0;
+	int err = 0;
+	int err2 = 0;
+
+	ar.len = total_blocks;
+	org_len = ar.len;
+
+	/* Calculate group nubmer of org_inode block */
+	if (phase == DEFRAG_RESERVE_BLOCKS_SECOND) {
+		org_path = ext4_ext_find_extent(org_inode, iblock, org_path);
+		if (IS_ERR(org_path)) {
+			err = PTR_ERR(org_path);
+			org_path = NULL;
+			goto out2;
+		}
+		ext4_get_group_no_and_offset(org_inode->i_sb,
+				ext_pblock(org_path[org_depth].p_ext),
+				&org_grp_no, &org_blk_off);
+		ar.excepted_group = org_grp_no;
+	} else {
+		ar.excepted_group = -1;
+	}
+
+	/* Find first extent. */
+	dest_path = ext4_ext_find_extent(dest_inode, iblock, dest_path);
+	if (IS_ERR(dest_path)) {
+		err = PTR_ERR(dest_path);
+		dest_path = NULL;
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
+		ar.goal = ext4_ext_find_goal(dest_inode, dest_path, iblock);
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
+		credits = ext4_ext_calc_credits_for_insert(dest_inode,
+							dest_path);
+		handle = ext4_ext_journal_restart(handle,
+				credits + EXT4_TRANS_META_BLOCKS);
+
+		if (IS_ERR(handle))
+			return PTR_ERR(handle);
+
+		newblock = ext4_mb_new_blocks(handle, &ar, &err);
+
+		if (err) {
+			/* Faild to get contiguous blocks*/
+			goto out;
+		} else if ((ar.len != org_len) &&
+				(phase == DEFRAG_RESERVE_BLOCKS_FIRST)) {
+			ext4_free_blocks(handle, org_inode, newblock,
+						ar.len, metadata);
+			err = -ENOSPC;
+			goto out;
+		} else {
+			alloc_total += ar.len;
+			ext4_get_group_no_and_offset(dest_inode->i_sb,
+				goal, &goal_grp_no, &goal_blk_off);
+			ext4_get_group_no_and_offset(dest_inode->i_sb,
+				newblock, &dest_grp_no, &dest_blk_off);
+			/* We can't allocate at same block group */
+			switch (phase) {
+			case DEFRAG_RESERVE_BLOCKS_SECOND:
+				if (dest_grp_no == org_grp_no) {
+					printk(KERN_ERR "defrag: Can't allocate"
+					" in same block group\n");
+					ext4_free_blocks(handle, org_inode,
+						newblock, ar.len, metadata);
+					err = -ENOSPC;
+					goto out;
+				}
+				break;
+			case DEFRAG_FIXED_BLOCKS_MODE:
+				if (dest_grp_no != goal_grp_no
+					|| alloc_total != total_blocks) {
+					printk(KERN_ERR "defrag: Already used"
+						" the specified blocks\n");
+					ext4_free_blocks(handle, org_inode,
+						newblock, ar.len, metadata);
+					err = -EIO;
+					goto out;
+				}
+				break;
+			}
+
+			newex.ee_block = cpu_to_le32(alloc_total -ar.len);
+			ext4_ext_store_pblock(&newex, newblock);
+			newex.ee_len = cpu_to_le16(ar.len);
+
+			if (!phase)
+				ar.goal = newblock + ar.len;
+			rest = rest - ar.len;
+			ar.len = rest;
+
+			err = ext4_ext_insert_extent(handle, dest_inode,
+						dest_path, &newex);
+			if (!err) {
+				count++;
+			} else {
+				ext4_free_blocks(handle, org_inode,
+					newblock, ar.len, metadata);
+				goto out;
+			}
+		}
+	}
+
+out:
+	/* Faild case: We have to remove halfway blocks */
+	if (err) {
+		err2 = ext4_ext_remove_space(dest_inode, 0);
+		ext4_release_blocks(dest_inode->i_sb, org_len);
+	}
+
+	/* Successful case: return extents count */
+	if (dest_path) {
+		ext4_ext_drop_refs(dest_path);
+		kfree(dest_path);
+	}
+	if (org_path) {
+		ext4_ext_drop_refs(org_path);
+		kfree(org_path);
+	}
+out2:
+	ext4_journal_stop(handle);
+
+	if (!err && !err2)
+		return count;
+	else if (!err2)
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
+ * @iblock:		file related offset
+ * @goal:		block offset for allocaton
+ * @flag:               phase of create free space mode
+ *
+ * This function returns the value as below:
+ * 	0(succeeded)
+ *	1(not improved)
+ *	negative value(error)
+ */
+static int
+ext4_ext_new_extent_tree(struct inode *inode, struct inode *tmp_inode,
+			struct ext4_ext_path *path, ext4_fsblk_t tar_start,
+			ext4_fsblk_t tar_blocks, ext4_fsblk_t iblock,
+			ext4_fsblk_t goal, int flag)
+{
+	struct ext4_extent *ext = NULL;
+	struct ext4_extent_header *eh = NULL;
+	ext4_fsblk_t tar_end = tar_start + tar_blocks - 1;
+	int sum_org = 0, sum_tmp = 0;
+	int ret = 0, depth;
+	int last_extent = 0;
+
+	eh = ext_inode_hdr(tmp_inode);
+	eh->eh_depth = 0;
+
+	/* allocate contiguous blocks */
+	if ((sum_tmp = ext4_ext_alloc_blocks(tmp_inode, inode, iblock,
+					tar_blocks, goal, flag)) < 0) {
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
+				if (!(ret =
+					ext4_ext_remove_space(tmp_inode, 0)))
+					ret = 1;
+			} else if (sum_org < sum_tmp &&
+					flag != DEFRAG_RESERVE_BLOCKS_SECOND) {
+				/* fragment increased */
+				if (!(ret =
+					ext4_ext_remove_space(tmp_inode, 0)))
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
+/**
+ * ext4_ext_defrag - defrag whole file
+ * @filp:            pointer to file
+ * @from:            starting offset to defrag in blocks
+ * @defrag_size:     size of defrag in blocks
+ * @goal:            block offset for allocation
+ * @flag:            phase of create free space mode
+ * @ext:             extent to move(only -f)
+ *
+ * This function returns the number of blocks if succeeded, otherwise
+ * returns error value
+ */
+int
+ext4_ext_defrag(struct file *filp, ext4_fsblk_t block_start,
+		ext4_fsblk_t defrag_size, ext4_fsblk_t goal,
+		int flag, struct ext4_extent_data *ext)
+{
+	struct inode *inode = filp->f_dentry->d_inode, *tmp_inode = NULL;
+	struct ext4_super_block *es = EXT4_SB(inode->i_sb)->s_es;
+	struct ext4_ext_path *path = NULL, *holecheck_path = NULL;
+	struct ext4_extent *ext_prev = NULL, *ext_cur = NULL, *ext_dummy = NULL;
+	handle_t *handle;
+	ext4_fsblk_t block_end = block_start + defrag_size - 1;
+	ext4_fsblk_t seq_blocks = 0, seq_start = 0;
+	ext4_fsblk_t add_blocks = 0;
+	ext4_fsblk_t file_end = (inode->i_size - 1) >> inode->i_blkbits;
+	pgoff_t page_offset = 0;
+	pgoff_t dest_offset = 0;
+	pgoff_t seq_end_page = 0;
+	int ret = 0, depth = 0, last_extent = 0, seq_extents = 0;
+
+	/* check goal offset */
+	if (((0 < goal) && (ext4_blocks_count(es) < goal)) && (goal != -1)) {
+		printk(KERN_ERR "defrag: incorrect goal number %llu, "
+			"you can set goal until %llu\n", goal,
+			ext4_blocks_count(es));
+		ret = -EINVAL;
+		goto ERR1;
+	}
+
+	/* Setup for fixed blocks mode */
+	if (ext->len) {
+		if (ext->len < defrag_size) {
+			printk("Cannot defrag due to the insufficient"
+			" specified free blocks\n");
+			return -EINVAL;
+		}
+		flag = DEFRAG_FIXED_BLOCKS_MODE;
+		goal = ext->start;
+	}
+
+	if (file_end < block_end)
+		defrag_size -= block_end - file_end;
+
+	mutex_lock(&inode->i_mutex);
+	mutex_lock(&EXT4_I(inode)->truncate_mutex);
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
+	if (ext_cur == NULL)
+		goto ERR2;
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
+	add_blocks = min((ext4_fsblk_t)(ext_cur->ee_block +
+			 ext_cur->ee_len), block_end + 1) -
+		     max((ext4_fsblk_t)ext_cur->ee_block, block_start);
+
+	while (!last_extent && ext_cur->ee_block <= block_end) {
+		seq_blocks += add_blocks;
+
+		handle = ext4_journal_start(inode,
+			EXT4_DATA_TRANS_BLOCKS(inode->i_sb) +
+			EXT4_INDEX_EXTRA_TRANS_BLOCKS + 3 +
+			2 * EXT4_QUOTA_INIT_BLOCKS(inode->i_sb) + 1);
+		if (IS_ERR(handle)) {
+			ret = PTR_ERR(handle);
+			goto ERR1;
+		}
+		tmp_inode = ext4_new_inode(handle,
+			inode->i_sb->s_root->d_inode, S_IFREG);
+		if (IS_ERR(tmp_inode)) {
+			ret = -ENOMEM;
+			ext4_journal_stop(handle);
+			tmp_inode = NULL;
+			goto ERR1;
+		}
+
+		i_size_write(tmp_inode, i_size_read(inode));
+		tmp_inode->i_nlink = 0;
+		ext4_ext_tree_init(handle, tmp_inode);
+		ext4_orphan_add(handle, tmp_inode);
+		ext4_journal_stop(handle);
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
+			if (tmp_inode) {
+				iput(tmp_inode);
+				tmp_inode = NULL;
+			}
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
+			seq_start, seq_blocks, block_start, goal, flag);
+
+		if (ret < 0) {
+			break;
+		} else if ((ret == 1) && (!goal || (goal && !flag))) {
+			ret = 0;
+			seq_start = ext_cur->ee_block;
+			goto CLEANUP;
+		}
+
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
+					page_offset, dest_offset, flag)) < 0)
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
+		depth = holecheck_path->p_depth;
+
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
+
+		if (tmp_inode) {
+			iput(tmp_inode);
+			tmp_inode = NULL;
+		}
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
+ERR1:
+	mutex_unlock(&EXT4_I(inode)->truncate_mutex);
+	mutex_unlock(&inode->i_mutex);
+
+	if (tmp_inode)
+		iput(tmp_inode);
+
+	return (ret ? ret : defrag_size);
+}
+
 EXPORT_SYMBOL(ext4_mark_inode_dirty);
 EXPORT_SYMBOL(ext4_ext_invalidate_cache);
 EXPORT_SYMBOL(ext4_ext_insert_extent);
diff -Nrup -X linux-2.6.19-rc6-Alex/Documentation/dontdiff linux-2.6.19-rc6-Alex/fs/ext4/inode.c linux-2.6.19-rc6-1-alloc/fs/ext4/inode.c
--- linux-2.6.19-rc6-Alex/fs/ext4/inode.c	2007-06-19 20:50:56.000000000 +0900
+++ linux-2.6.19-rc6-1-alloc/fs/ext4/inode.c	2007-06-19 20:10:13.000000000 +0900
@@ -1305,7 +1305,7 @@ static int ext4_journalled_commit_write(
  * So, if we see any bmap calls here on a modified, data-journaled file,
  * take extra steps to flush any blocks which might be in the cache.
  */
-static sector_t ext4_bmap(struct address_space *mapping, sector_t block)
+sector_t ext4_bmap(struct address_space *mapping, sector_t block)
 {
 	struct inode *inode = mapping->host;
 	journal_t *journal;
diff -Nrup -X linux-2.6.19-rc6-Alex/Documentation/dontdiff linux-2.6.19-rc6-Alex/fs/ext4/ioctl.c linux-2.6.19-rc6-1-alloc/fs/ext4/ioctl.c
--- linux-2.6.19-rc6-Alex/fs/ext4/ioctl.c	2007-06-19 20:50:56.000000000 +0900
+++ linux-2.6.19-rc6-1-alloc/fs/ext4/ioctl.c	2007-06-19 20:10:13.000000000 +0900
@@ -249,6 +249,19 @@ flags_err:
 
 		return err;
 	}
+	case EXT4_IOC_GET_EXTENTS:
+	case EXT4_IOC_GET_TREE_STATS:
+	case EXT4_IOC_GET_TREE_DEPTH:
+	case EXT4_IOC_FIBMAP:
+	case EXT4_IOC_DEFRAG:
+	case EXT4_IOC_GROUP_INFO:
+	case EXT4_IOC_FREE_BLOCKS_INFO:
+	case EXT4_IOC_EXTENTS_INFO:
+	case EXT4_IOC_RESERVE_BLOCK:
+	case EXT4_IOC_MOVE_VICTIM:
+	case EXT4_IOC_BLOCK_RELEASE: {
+		return ext4_ext_ioctl(inode, filp, cmd, arg);
+	}
 	case EXT4_IOC_GET_BUDDY: {
 		unsigned char *buddy = NULL, *bitmap = NULL;
 		struct super_block *sb = inode->i_sb;
diff -Nrup -X linux-2.6.19-rc6-Alex/Documentation/dontdiff linux-2.6.19-rc6-Alex/fs/ext4/mballoc.c linux-2.6.19-rc6-1-alloc/fs/ext4/mballoc.c
--- linux-2.6.19-rc6-Alex/fs/ext4/mballoc.c	2007-06-19 20:50:56.000000000 +0900
+++ linux-2.6.19-rc6-1-alloc/fs/ext4/mballoc.c	2007-06-20 07:28:34.000000000 +0900
@@ -252,6 +252,7 @@ struct ext4_allocation_context {
 	struct page *ac_bitmap_page;
 	struct page *ac_buddy_page;
 	struct ext4_prealloc_space *ac_pa;
+	long long ac_excepted_group;
 };
 
 #define AC_STATUS_CONTINUE	1
@@ -1581,6 +1582,11 @@ repeat:
 			if (group == EXT4_SB(sb)->s_groups_count)
 				group = 0;
 
+			if (ac->ac_excepted_group != -1 &&
+			    group == ac->ac_excepted_group) {
+				continue;
+			}
+
 			/* quick check to skip empty groups */
 			grp = EXT4_GROUP_INFO(ac->ac_sb, group);
 			if (grp->bb_free == 0)
@@ -3630,6 +3636,7 @@ int ext4_mb_initialize_context(struct ex
 	ac->ac_pa = NULL;
 	ac->ac_bitmap_page = NULL;
 	ac->ac_buddy_page = NULL;
+	ac->ac_excepted_group = ar->excepted_group;
 
 	if (len == 1 && sbi->s_stripe) {
 		/* looks like a metadata, let's use a dirty hack for raid5
diff -Nrup -X linux-2.6.19-rc6-Alex/Documentation/dontdiff linux-2.6.19-rc6-Alex/include/linux/ext4_fs.h linux-2.6.19-rc6-1-alloc/include/linux/ext4_fs.h
--- linux-2.6.19-rc6-Alex/include/linux/ext4_fs.h	2007-06-19 20:50:56.000000000 +0900
+++ linux-2.6.19-rc6-1-alloc/include/linux/ext4_fs.h	2007-06-20 07:54:58.000000000 +0900
@@ -83,6 +83,7 @@ struct ext4_allocation_request {
 	ext4_fsblk_t pright;	/* phys. block for ^^^ */
 	unsigned long len;	/* how many blocks we want to allocate */
 	unsigned long flags;	/* flags. see above EXT4_MB_HINT_* */
+	long long excepted_group;
 };
 
 /*
@@ -279,6 +280,11 @@ struct ext4_get_buddy_request {
 #define EXT4_IOC_GETRSVSZ		_IOR('f', 5, long)
 #define EXT4_IOC_SETRSVSZ		_IOW('f', 6, long)
 #define EXT4_IOC_GET_BUDDY		_IOR('f', 98, struct ext4_get_buddy_request)
+#define EXT4_IOC_GET_EXTENTS		_IOR('f', 7, long)
+#define EXT4_IOC_GET_TREE_DEPTH		_IOR('f', 8, long)
+#define EXT4_IOC_GET_TREE_STATS		_IOR('f', 9, long)
+#define EXT4_IOC_FIBMAP			_IOW('f', 9, ext4_fsblk_t)
+#define EXT4_IOC_DEFRAG			_IOW('f', 10, struct ext4_ext_defrag_data)
 
 /*
  * ioctl commands in 32 bit emulation
@@ -296,6 +302,23 @@ struct ext4_get_buddy_request {
 #define EXT4_IOC32_GETVERSION_OLD	FS_IOC32_GETVERSION
 #define EXT4_IOC32_SETVERSION_OLD	FS_IOC32_SETVERSION
 
+/* Used for defrag */
+
+struct ext4_extent_data {
+	unsigned long long block;	/* start logical block number */
+	ext4_fsblk_t start;		/* start physical block number */
+	int len;			/* blocks count */
+};
+
+struct ext4_ext_defrag_data {
+	ext4_fsblk_t start_offset;      /* start offset to defrag in blocks */
+	ext4_fsblk_t defrag_size;       /* size of defrag in blocks */
+	ext4_fsblk_t goal;		/* block offset for allocation */
+	int flag;			/* free space mode flag */
+	struct ext4_extent_data ext;
+};
+
+#define EXT4_TRANS_META_BLOCKS	4 /* bitmap + group desc + sb + inode */
 
 /*
  *  Mount options
@@ -930,6 +953,7 @@ struct buffer_head * ext4_bread (handle_
 int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
 	sector_t iblock, unsigned long maxblocks, struct buffer_head *bh_result,
 	int create, int extend_disksize);
+sector_t ext4_bmap(struct address_space *mapping, sector_t block);
 
 extern void ext4_read_inode (struct inode *);
 extern int  ext4_write_inode (struct inode *, int);
@@ -951,6 +975,8 @@ extern int ext4_block_truncate_page(hand
 extern int ext4_ioctl (struct inode *, struct file *, unsigned int,
 		       unsigned long);
 extern long ext4_compat_ioctl (struct file *, unsigned int, unsigned long);
+extern int ext4_ext_defrag(struct file *, ext4_fsblk_t, ext4_fsblk_t,
+			ext4_fsblk_t, int, struct ext4_extent_data *);
 
 /* namei.c */
 extern int ext4_orphan_add(handle_t *, struct inode *);
@@ -1063,6 +1089,8 @@ extern int ext4_ext_get_blocks(handle_t 
 extern void ext4_ext_truncate(struct inode *, struct page *);
 extern void ext4_ext_init(struct super_block *);
 extern void ext4_ext_release(struct super_block *);
+extern int ext4_ext_ioctl(struct inode *, struct file *, unsigned int,
+				unsigned long);
 static inline int
 ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
 			unsigned long max_blocks, struct buffer_head *bh,
