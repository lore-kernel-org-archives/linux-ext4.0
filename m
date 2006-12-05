From: sho@tnes.nec.co.jp
Subject: [RFC][PATCH 1/2] Allocate new contiguous blocks
Date: Tue, 5 Dec 2006 20:19:39 +0900
Message-ID: <20061205201939sho@rifu.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:59600 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759956AbWLELTj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Dec 2006 06:19:39 -0500
Received: from mailgate3.nec.co.jp (mailgate54.nec.co.jp [10.7.69.197])
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id kB5BJcVv004898
	for <linux-ext4@vger.kernel.org>; Tue, 5 Dec 2006 20:19:38 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id kB5BJcw09067 for linux-ext4@vger.kernel.org; Tue, 5 Dec 2006 20:19:38 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv5.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id kB5BJci20711 for <linux-ext4@vger.kernel.org>; Tue, 5 Dec 2006 20:19:38 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20061205.202508.84301556 for <linux-ext4@vger.kernel.org>
	; Tue, 5 Dec 2006 20:25:08 +0900
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Search contiguous free blocks with Alex's mutil-block allocation
and allocate them for the temporary inode.

This patch applies on top of Alex's patches.
"[RFC] extents,mballoc,delalloc for 2.6.16.8"
http://marc.theaimsgroup.com/?l=linux-ext4&m=114669168616780&w=2

Signed-off-by: Takashi Sato <sho@tnes.nec.co.jp>
---
diff -Nrup -X linux-2.6.16.8/Documentation/dontdiff linux-2.6.16.8/fs/ext3/extents.c linux-2.6.16.8-rev1/fs/ext3/extents.c
--- linux-2.6.16.8/fs/ext3/extents.c	2006-12-05 18:07:35.000000000 +0900
+++ linux-2.6.16.8-rev1/fs/ext3/extents.c	2006-12-05 17:54:39.000000000 +0900
@@ -43,6 +43,11 @@
 #include <linux/ext3_extents.h>
 #include <asm/uaccess.h>
 
+/* 
+ * at present, extent can't cross block group: 
+ * bitmap + group desc + sb + inode 
+ */
+#define EXT3_TRANS_META_BLOCKS	4
 
 static inline int ext3_ext_check_header(struct ext3_extent_header *eh)
 {
@@ -2341,11 +2346,485 @@ int ext3_ext_ioctl(struct inode *inode, 
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
+static int ext3_ext_alloc_blocks(struct inode *inode_dest,
+			struct ext3_extents_tree *dest_tree,
+			unsigned long iblock, unsigned long total_blocks)
+{
+	struct ext3_ext_path *path = NULL;
+	struct ext3_extent newex;
+	struct ext3_extent_header *eh = EXT_ROOT_HDR(dest_tree);
+	handle_t *handle;
+	unsigned long newblock = 0;
+	unsigned long rest = total_blocks;
+	unsigned long alloc_total = 0;
+	int depth = EXT_DEPTH(dest_tree);
+	int count = 0;
+	/* at present, extent can't cross block group: */
+	/* leaf + bitmap + group desc + sb + inode */
+	int credits = 0;
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
+		handle = ext3_journal_start(inode_dest, depth + 1);
+		if (IS_ERR(handle))
+			return PTR_ERR(handle);
+
+		err2 = ext3_ext_remove_index_blocks(handle, dest_tree,
+					eh, eh->eh_depth);
+		ext3_journal_stop(handle);
+		if (err2 < 0) {
+			return err2;
+		}
+	}
+
+	handle = ext3_journal_start(inode_dest, credits);
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
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
+		credits = ext3_ext_calc_credits_for_insert(dest_tree, path);
+		handle = ext3_ext_journal_restart(handle,
+				credits + EXT3_TRANS_META_BLOCKS);
+
+		if (IS_ERR(handle)) {
+			return PTR_ERR(handle);
+		}
+
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
+	ext3_journal_stop(handle);
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
+	ext3_journal_stop(handle);
+	if (err2 == 0) {
+		return err;
+	} else {
+		return err2;
+	}
+}
+
+static int
+ext3_ext_new_extent_tree(struct inode *tmp_inode,
+			 struct ext3_extents_tree *org_tree,
+			 struct ext3_extents_tree *dest_tree,
+			 struct ext3_ext_path *path,
+			 unsigned long tar_start,
+			 unsigned long tar_blocks)
+{
+	struct ext3_extent *ext = NULL;
+	struct ext3_extent_header *eh = NULL;
+	unsigned long tar_end = tar_start + tar_blocks - 1;
+	int sum_org = 0, sum_tmp = 0;
+	int ret = 0, depth;
+	int last_extent = 0;
+
+	eh = EXT_ROOT_HDR(dest_tree);
+	eh->eh_depth = 0;
+
+	/* allocate contiguous blocks */
+	if ((sum_tmp = ext3_ext_alloc_blocks(tmp_inode,
+			dest_tree, 0, tar_blocks)) < 0) {
+		ret = sum_tmp;
+		goto ERR;
+	}
+
+	depth = EXT_DEPTH(org_tree);
+	ext = path[depth].p_ext;
+	while (1) {
+		if (!last_extent)
+			++sum_org;
+
+		if (tar_end <= le32_to_cpu(ext->ee_block) +
+			       le32_to_cpu(ext->ee_len) - 1 ||
+			       last_extent) {
+
+			/* fragment decreased */
+			if (sum_org > sum_tmp) {
+				if (tar_end == le32_to_cpu(ext->ee_block) +
+					       le32_to_cpu(ext->ee_len) - 1) {
+					/* update path with next extent */
+					if ((last_extent =
+						ext3_ext_next_extent(tmp_inode,
+						path, &ext)) < 0) {
+							ret = last_extent;
+							break;
+					}
+				}
+			} else if (sum_org == sum_tmp) {
+				/* not improved */
+				if ((ret = ext3_ext_remove_space(dest_tree, 0,
+								 tar_blocks)) < 0)
+					break;
+				ret = 1;
+			} else {
+				/* fragment increased */
+				ret = -ENOSPC;
+			}
+			break;
+		}
+		if ((last_extent =
+				ext3_ext_next_extent(tmp_inode,
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
+	struct ext3_ext_path *path = NULL, *holecheck_path = NULL;
+	struct ext3_extent *ext_prev = NULL, *ext_cur = NULL, *ext_dummy = NULL;
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
+	int ret = 0, depth = 0, last_extent = 0, seq_extents = 0;
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
+	handle = ext3_journal_start(tmp_inode, 1);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto ERR2;
+	}
+	ext3_extent_tree_init(handle, &dest_tree);
+	ext3_journal_stop(handle);
+
+	path = ext3_ext_find_extent(&org_tree, block_start, NULL);
+	if (IS_ERR(path)) {
+		ret = PTR_ERR(path);
+		goto ERR2;
+	}
+
+	/* get path structure to check hole */
+	holecheck_path = ext3_ext_find_extent(&org_tree, block_start, NULL);
+	if (IS_ERR(holecheck_path)) {
+		ret = PTR_ERR(holecheck_path);
+		goto ERR2;
+	}
+
+	depth = EXT_DEPTH(&org_tree);
+	ext_cur = holecheck_path[depth].p_ext;
+
+	/*
+	 * if block_start was within the hole, get proper extent whose ee_block
+	 * is beyond block_start
+	 */
+	if (ext_cur->ee_block + ext_cur->ee_len - 1 < block_start) {
+		if ((last_extent =
+				ext3_ext_next_extent(inode, holecheck_path,
+				&ext_cur)) < 0) {
+			ret = last_extent;
+			goto ERR2;
+		}
+		if ((last_extent =
+				ext3_ext_next_extent(inode, path,
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
+				ext3_ext_next_extent(inode, holecheck_path,
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
+		if (seq_extents == 1) {
+			seq_start = ext_cur->ee_block;
+			goto CLEANUP;
+		}
+
+		ret = ext3_ext_new_extent_tree(tmp_inode,
+				&org_tree, &dest_tree, path,
+				seq_start, seq_blocks);
+
+		if (ret < 0) {
+			break;
+		} else if (ret == 1) {
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
+		while (page_offset <= seq_end_page) {
+			/* replace original branches for new branches */
+			if ((ret = ext3_ext_defrag_partial(filp,
+					&org_tree, &dest_tree,
+					page_offset, dest_offset
+					)) < 0)
+				goto ERR2;
+
+			page_offset++;
+			dest_offset++;
+		}
+
+		holecheck_path =
+			ext3_ext_find_extent(&org_tree, seq_start, holecheck_path);
+		if (IS_ERR(holecheck_path)) {
+			ret = PTR_ERR(holecheck_path);
+			break;
+		}
+CLEANUP:
+		path = ext3_ext_find_extent(&org_tree, seq_start, path);
+		if (IS_ERR(path)) {
+			ret = PTR_ERR(path);
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
+		ext3_ext_drop_refs(path);
+		kfree(path);
+	}
+	if (holecheck_path) {
+		ext3_ext_drop_refs(holecheck_path);
+		kfree(holecheck_path);
+	}
+
+	mutex_unlock(&inode->i_mutex);
+	iput(tmp_inode);
+ERR1:
+	return (ret ? ret : ((page_end - page_start + 1) << PAGE_SHIFT));
+}
+
 EXPORT_SYMBOL(ext3_init_tree_desc);
 EXPORT_SYMBOL(ext3_mark_inode_dirty);
 EXPORT_SYMBOL(ext3_ext_invalidate_cache);
diff -Nrup -X linux-2.6.16.8/Documentation/dontdiff linux-2.6.16.8/fs/ext3/ioctl.c linux-2.6.16.8-rev1/fs/ext3/ioctl.c
--- linux-2.6.16.8/fs/ext3/ioctl.c	2006-12-05 18:07:35.000000000 +0900
+++ linux-2.6.16.8-rev1/fs/ext3/ioctl.c	2006-12-05 17:52:03.000000000 +0900
@@ -103,6 +103,7 @@ flags_err:
 	case EXT3_IOC_GET_EXTENTS:
 	case EXT3_IOC_GET_TREE_STATS:
 	case EXT3_IOC_GET_TREE_DEPTH:
+	case EXT3_IOC_DEFRAG:
 		return ext3_ext_ioctl(inode, filp, cmd, arg);
 	case EXT3_IOC_GETVERSION:
 	case EXT3_IOC_GETVERSION_OLD:
diff -Nrup -X linux-2.6.16.8/Documentation/dontdiff linux-2.6.16.8/include/linux/ext3_fs.h linux-2.6.16.8-rev1/include/linux/ext3_fs.h
--- linux-2.6.16.8/include/linux/ext3_fs.h	2006-12-05 18:07:35.000000000 +0900
+++ linux-2.6.16.8-rev1/include/linux/ext3_fs.h	2006-12-05 17:52:03.000000000 +0900
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
diff -Nrup -X linux-2.6.16.8/Documentation/dontdiff linux-2.6.16.8/include/linux/mm.h linux-2.6.16.8-rev1/include/linux/mm.h
--- linux-2.6.16.8/include/linux/mm.h	2006-04-19 06:32:07.000000000 +0900
+++ linux-2.6.16.8-rev1/include/linux/mm.h	2006-12-05 17:52:03.000000000 +0900
@@ -970,6 +970,8 @@ unsigned long page_cache_readahead(struc
 void handle_ra_miss(struct address_space *mapping, 
 		    struct file_ra_state *ra, pgoff_t offset);
 unsigned long max_sane_readahead(unsigned long nr);
+int do_page_cache_readahead(struct address_space *mapping, struct file *filp,
+			    pgoff_t offset, unsigned long nr_to_read);
 
 /* Do stack extension */
 extern int expand_stack(struct vm_area_struct *vma, unsigned long address);
