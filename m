From: Mingming Cao <cmm@us.ibm.com>
Subject: [RFC]ext4: block reservations to handle delalloc ENOSPC error
Date: Fri, 22 Feb 2008 12:36:55 -0800
Message-ID: <1203712615.3639.56.camel@localhost.localdomain>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org, Alex Tomas <bzzz.tomas@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:34299 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871AbYBVUhG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Feb 2008 15:37:06 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1MKb5LP013570
	for <linux-ext4@vger.kernel.org>; Fri, 22 Feb 2008 15:37:05 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1MKb5RF255228
	for <linux-ext4@vger.kernel.org>; Fri, 22 Feb 2008 15:37:05 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1MKb5UX008637
	for <linux-ext4@vger.kernel.org>; Fri, 22 Feb 2008 15:37:05 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In delayed allocation, blocks to be allocated need to be reserved
before user buffers being copied to memory, otherwise later at
page writeout time we could hit ENOSPC error.

In this patch, blocks(data and metadata) are reserved at da_write_begin()
time, the free blocks counter is updated by then, and the number of reserved
blocks is store in inode structure in memory.

Then later, when new_blocks() is being called, if the caller is already reserved
the blocks for allocation, the free blocks_counter is not being updated, otherwise,
in DIO case, which could call get_blocks() without the blocks being reserved,
proper accounting still need to be done.

At the writepage() time, the unused reserved blocks are returned back.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/balloc.c                |   25 +++++++--
 fs/ext4/dir.c                   |    3 -
 fs/ext4/extents.c               |   78 +++++++++++++++++++++++-------
 fs/ext4/inode.c                 |  102 +++++++++++++++++++++++++++++++++-------
 fs/ext4/mballoc.c               |   11 +++-
 fs/ext4/migrate.c               |    2 
 fs/ext4/super.c                 |    3 +
 fs/ext4/xattr.c                 |    2 
 include/linux/ext4_fs.h         |   17 ++++--
 include/linux/ext4_fs_extents.h |    4 -
 include/linux/ext4_fs_i.h       |    4 +
 11 files changed, 195 insertions(+), 56 deletions(-)

Index: linux-2.6.25-rc2/fs/ext4/super.c
===================================================================
--- linux-2.6.25-rc2.orig/fs/ext4/super.c	2008-02-21 17:30:59.000000000 -0800
+++ linux-2.6.25-rc2/fs/ext4/super.c	2008-02-21 19:47:00.000000000 -0800
@@ -573,6 +573,8 @@ static struct inode *ext4_alloc_inode(st
 	memset(&ei->i_cached_extent, 0, sizeof(struct ext4_ext_cache));
 	INIT_LIST_HEAD(&ei->i_prealloc_list);
 	spin_lock_init(&ei->i_prealloc_lock);
+	ei->i_reserved_data_blocks = 0;
+	ei->i_reserved_meta_blocks = 0;
 	return &ei->vfs_inode;
 }
 
@@ -2190,6 +2192,7 @@ static int ext4_fill_super (struct super
 		err = percpu_counter_init(&sbi->s_dirs_counter,
 				ext4_count_dirs(sb));
 	}
+
 	if (err) {
 		printk(KERN_ERR "EXT4-fs: insufficient memory\n");
 		goto failed_mount3;
Index: linux-2.6.25-rc2/fs/ext4/inode.c
===================================================================
--- linux-2.6.25-rc2.orig/fs/ext4/inode.c	2008-02-21 17:31:03.000000000 -0800
+++ linux-2.6.25-rc2/fs/ext4/inode.c	2008-02-21 19:52:34.000000000 -0800
@@ -36,6 +36,7 @@
 #include <linux/mpage.h>
 #include <linux/uio.h>
 #include <linux/bio.h>
+#include <linux/ext4_fs_extents.h>
 #include "xattr.h"
 #include "acl.h"
 
@@ -508,10 +509,11 @@ static int ext4_blks_to_allocate(Indirec
  *	the indirect blocks(if needed) and the first direct block,
  *	@blks:	on return it will store the total number of allocated
  *		direct blocks
+ *	@reserved: flag if blocks is pre-reserved by delayed allocation
  */
 static int ext4_alloc_blocks(handle_t *handle, struct inode *inode,
 			ext4_fsblk_t goal, int indirect_blks, int blks,
-			ext4_fsblk_t new_blocks[4], int *err)
+			ext4_fsblk_t new_blocks[4], int reserved, int *err)
 {
 	int target, i;
 	unsigned long count = 0;
@@ -532,7 +534,8 @@ static int ext4_alloc_blocks(handle_t *h
 	while (1) {
 		count = target;
 		/* allocating blocks for indirect blocks and direct blocks */
-		current_block = ext4_new_blocks(handle,inode,goal,&count,err);
+		current_block = ext4_new_blocks(handle, inode, goal,
+						&count, reserved, err);
 		if (*err)
 			goto failed_out;
 
@@ -567,6 +570,8 @@ failed_out:
  *	@blks: number of allocated direct blocks
  *	@offsets: offsets (in the blocks) to store the pointers to next.
  *	@branch: place to store the chain in.
+ *	@reserved: flagging if blocks already reserved for allocation
+ *		   avoid doing accounting on free blocks
  *
  *	This function allocates blocks, zeroes out all but the last one,
  *	links them into chain and (if we are synchronous) writes them to disk.
@@ -587,7 +592,7 @@ failed_out:
  */
 static int ext4_alloc_branch(handle_t *handle, struct inode *inode,
 			int indirect_blks, int *blks, ext4_fsblk_t goal,
-			ext4_lblk_t *offsets, Indirect *branch)
+			ext4_lblk_t *offsets, Indirect *branch, int reserved)
 {
 	int blocksize = inode->i_sb->s_blocksize;
 	int i, n = 0;
@@ -598,7 +603,7 @@ static int ext4_alloc_branch(handle_t *h
 	ext4_fsblk_t current_block;
 
 	num = ext4_alloc_blocks(handle, inode, goal, indirect_blks,
-				*blks, new_blocks, &err);
+				*blks, new_blocks, reserved, &err);
 	if (err)
 		return err;
 
@@ -788,7 +793,7 @@ err_out:
 int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
 		ext4_lblk_t iblock, unsigned long maxblocks,
 		struct buffer_head *bh_result,
-		int create, int extend_disksize)
+		int create, int extend_disksize, int reserved)
 {
 	int err = -EIO;
 	ext4_lblk_t offsets[4];
@@ -858,7 +863,7 @@ int ext4_get_blocks_handle(handle_t *han
 	 * Block out ext4_truncate while we alter the tree
 	 */
 	err = ext4_alloc_branch(handle, inode, indirect_blks, &count, goal,
-				offsets + (partial - chain), partial);
+				offsets + (partial - chain), partial, reserved);
 
 	/*
 	 * The ext4_splice_branch call will free and forget any buffers
@@ -932,7 +937,7 @@ out:
  */
 int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
 			unsigned long max_blocks, struct buffer_head *bh,
-			int create, int extend_disksize)
+			int create, int extend_disksize, int reserved)
 {
 	int retval;
 
@@ -945,10 +950,10 @@ int ext4_get_blocks_wrap(handle_t *handl
 	down_read((&EXT4_I(inode)->i_data_sem));
 	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
 		retval =  ext4_ext_get_blocks(handle, inode, block, max_blocks,
-				bh, 0, 0);
+				bh, 0, 0, reserved);
 	} else {
 		retval = ext4_get_blocks_handle(handle,
-				inode, block, max_blocks, bh, 0, 0);
+				inode, block, max_blocks, bh, 0, 0, reserved);
 	}
 	up_read((&EXT4_I(inode)->i_data_sem));
 
@@ -980,10 +985,10 @@ int ext4_get_blocks_wrap(handle_t *handl
 	 */
 	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
 		retval =  ext4_ext_get_blocks(handle, inode, block, max_blocks,
-				bh, create, extend_disksize);
+				bh, create, extend_disksize, reserved);
 	} else {
 		retval = ext4_get_blocks_handle(handle, inode, block,
-				max_blocks, bh, create, extend_disksize);
+			max_blocks, bh, create, extend_disksize, reserved);
 	}
 	up_write((&EXT4_I(inode)->i_data_sem));
 	return retval;
@@ -1010,7 +1015,7 @@ static int ext4_get_block(struct inode *
 	}
 
 	ret = ext4_get_blocks_wrap(handle, inode, iblock,
-					max_blocks, bh_result, create, 0);
+					max_blocks, bh_result, create, 0, 0);
 	if (ret > 0) {
 		bh_result->b_size = (ret << inode->i_blkbits);
 		ret = 0;
@@ -1036,7 +1041,7 @@ struct buffer_head *ext4_getblk(handle_t
 	dummy.b_blocknr = -1000;
 	buffer_trace_init(&dummy.b_history);
 	err = ext4_get_blocks_wrap(handle, inode, block, 1,
-					&dummy, create, 1);
+					&dummy, create, 1, 0);
 	/*
 	 * ext4_get_blocks_handle() returns number of blocks
 	 * mapped. 0 in case of a HOLE.
@@ -1385,6 +1390,61 @@ static int ext4_journalled_write_end(str
 	return ret ? ret : copied;
 }
 
+static int ext4_da_reserve_space(struct inode *inode, int nrblocks)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	int md_needed, mdblocks, total = 0;
+
+	/*
+	 * calculate the amount of metadata blocks to reserve
+	 * in order to allocate nrblocks
+	 * worse case is one extent per block
+	 */
+	total = EXT4_I(inode)->i_reserved_data_blocks + nrblocks;
+	mdblocks = ext4_ext_calc_metadata_amount(inode, total);
+	BUG_ON(mdblocks < EXT4_I(inode)->i_reserved_meta_blocks);
+
+	md_needed = mdblocks - EXT4_I(inode)->i_reserved_meta_blocks;
+	total = md_needed + nrblocks;
+	if (percpu_counter_read(&sbi->s_freeblocks_counter) < total)
+		return -ENOSPC;
+
+	/* reduce fs reserved blocks */
+	percpu_counter_sub(&sbi->s_freeblocks_counter, total);
+
+	EXT4_I(inode)->i_reserved_data_blocks += nrblocks;
+	EXT4_I(inode)->i_reserved_meta_blocks += md_needed;
+
+	return 0;	/* success */
+}
+
+
+static void ext4_da_release_space(struct inode *inode, int used)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	int total, mdb, release;
+
+	/* calculate the number of metablocks still need to be reserved */
+	total = EXT4_I(inode)->i_reserved_data_blocks - used;
+	mdb = ext4_ext_calc_metadata_amount(inode, total);
+
+	/* figure out how many metablocks to release */
+	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
+	mdb = EXT4_I(inode)->i_reserved_meta_blocks - mdb;
+
+	release = mdb + used;
+
+	/* release fs reserved blocks */
+	percpu_counter_add(&sbi->s_freeblocks_counter, release);
+
+	/* update per-inode reservations */
+	BUG_ON(used > EXT4_I(inode)->i_reserved_data_blocks);
+	EXT4_I(inode)->i_reserved_data_blocks -= used;
+
+	BUG_ON(mdb > EXT4_I(inode)->i_reserved_meta_blocks);
+	EXT4_I(inode)->i_reserved_meta_blocks -= mdb;
+}
+
 /*
  * this is a special callback for ->prepare_write() only
  * it's intention is to return mapped block or reserve space
@@ -1400,14 +1460,17 @@ static int ext4_da_get_block_prep(struct
 	/* first, we need to know whether the block is allocated already
 	 * XXX: when the filesystem has a lot of free blocks, we could
 	 * reserve even allocated blocks to save this lookup */
-	ret = ext4_get_blocks_wrap(NULL, inode, iblock, 1,  bh_result, 0, 0);
-	if (ret == 0) {
+	ret = ext4_get_blocks_wrap(NULL, inode, iblock, 1,  bh_result, 0, 0, 0);
+	if ((ret == 0) && !buffer_delay(bh_result)) {
 		/* the block isn't allocated yet, let's reserve space */
-		/* XXX: call reservation here */
 		/*
 		 * XXX: __block_prepare_write() unmaps passed block,
 		 * is it OK?
 		 */
+		ret = ext4_da_reserve_space(inode, 1);
+		if (ret)
+			/* not enough space to reserve */
+			return ret;
 		map_bh(bh_result, inode->i_sb, 0);
 		set_buffer_new(bh_result);
 		set_buffer_delay(bh_result);
@@ -1435,11 +1498,16 @@ static int ext4_da_get_block_write(struc
 		}
 	}
 
+	/* When we get here, we already reserved blocks for allocation */
+
 	ret = ext4_get_blocks_wrap(handle, inode, iblock, max_blocks,
-				   bh_result, create, 0);
+				   bh_result, create, 0, 1);
 	if (ret > 0) {
 		bh_result->b_size = (ret << inode->i_blkbits);
 
+		/* release unused reserved blocks for delalloc */
+		ext4_da_release_space(inode, ret);
+
 		/*
 		 * Update on-disk size along with block allocation
 		 * we don't use 'extend_disksize' as size may change
Index: linux-2.6.25-rc2/include/linux/ext4_fs_i.h
===================================================================
--- linux-2.6.25-rc2.orig/include/linux/ext4_fs_i.h	2008-02-21 17:29:29.000000000 -0800
+++ linux-2.6.25-rc2/include/linux/ext4_fs_i.h	2008-02-21 17:42:16.000000000 -0800
@@ -100,6 +100,10 @@ struct ext4_inode_info {
 	/* block reservation info */
 	struct ext4_block_alloc_info *i_block_alloc_info;
 
+	/* allocation reservation info for delalloc */
+	unsigned long i_reserved_data_blocks;
+	unsigned long i_reserved_meta_blocks;
+
 	ext4_lblk_t		i_dir_start_lookup;
 #ifdef CONFIG_EXT4DEV_FS_XATTR
 	/*
Index: linux-2.6.25-rc2/fs/ext4/extents.c
===================================================================
--- linux-2.6.25-rc2.orig/fs/ext4/extents.c	2008-02-21 17:30:57.000000000 -0800
+++ linux-2.6.25-rc2/fs/ext4/extents.c	2008-02-21 18:01:55.000000000 -0800
@@ -183,12 +183,12 @@ static ext4_fsblk_t ext4_ext_find_goal(s
 static ext4_fsblk_t
 ext4_ext_new_block(handle_t *handle, struct inode *inode,
 			struct ext4_ext_path *path,
-			struct ext4_extent *ex, int *err)
+			struct ext4_extent *ex, int reserved, int *err)
 {
 	ext4_fsblk_t goal, newblock;
 
 	goal = ext4_ext_find_goal(inode, path, le32_to_cpu(ex->ee_block));
-	newblock = ext4_new_block(handle, inode, goal, err);
+	newblock = ext4_new_block(handle, inode, goal, reserved, err);
 	return newblock;
 }
 
@@ -246,6 +246,36 @@ static int ext4_ext_space_root_idx(struc
 	return size;
 }
 
+/*
+ * Calculate the number of metadata blocks needed
+ * to allocate @blocks
+ * Worse case is one block per extent
+ */
+int ext4_ext_calc_metadata_amount(struct inode *inode, int blocks)
+{
+	int lcap, icap, rcap, leafs, idxs, num;
+	int newextents = blocks;
+
+	rcap = ext4_ext_space_root_idx(inode);
+	lcap = ext4_ext_space_block(inode);
+	icap = ext4_ext_space_block_idx(inode);
+
+	/* number of new leaf blocks needed */
+	num = leafs = (newextents + lcap - 1) / lcap;
+
+	/*
+	 * Worse case, we need separate index block(s)
+	 * to link all new leaf blocks
+	 */
+	idxs = (leafs + icap - 1) / icap;
+	do {
+		num += idxs;
+		idxs = (idxs + icap - 1) / icap;
+	} while (idxs > rcap);
+
+	return num;
+}
+
 static int
 ext4_ext_max_entries(struct inode *inode, int depth)
 {
@@ -638,7 +668,8 @@ static int ext4_ext_insert_index(handle_
  */
 static int ext4_ext_split(handle_t *handle, struct inode *inode,
 				struct ext4_ext_path *path,
-				struct ext4_extent *newext, int at)
+				struct ext4_extent *newext, int reserved,
+				int at)
 {
 	struct buffer_head *bh = NULL;
 	int depth = ext_depth(inode);
@@ -688,7 +719,8 @@ static int ext4_ext_split(handle_t *hand
 	/* allocate all needed blocks */
 	ext_debug("allocate %d blocks for indexes/leaf\n", depth - at);
 	for (a = 0; a < depth - at; a++) {
-		newblock = ext4_ext_new_block(handle, inode, path, newext, &err);
+		newblock = ext4_ext_new_block(handle, inode, path, newext,
+					reserved, &err);
 		if (newblock == 0)
 			goto cleanup;
 		ablocks[a] = newblock;
@@ -875,7 +907,8 @@ cleanup:
  */
 static int ext4_ext_grow_indepth(handle_t *handle, struct inode *inode,
 					struct ext4_ext_path *path,
-					struct ext4_extent *newext)
+					struct ext4_extent *newext,
+					int reserved)
 {
 	struct ext4_ext_path *curp = path;
 	struct ext4_extent_header *neh;
@@ -884,7 +917,8 @@ static int ext4_ext_grow_indepth(handle_
 	ext4_fsblk_t newblock;
 	int err = 0;
 
-	newblock = ext4_ext_new_block(handle, inode, path, newext, &err);
+	newblock = ext4_ext_new_block(handle, inode, path, newext,
+				reserved, &err);
 	if (newblock == 0)
 		return err;
 
@@ -960,7 +994,8 @@ out:
  */
 static int ext4_ext_create_new_leaf(handle_t *handle, struct inode *inode,
 					struct ext4_ext_path *path,
-					struct ext4_extent *newext)
+					struct ext4_extent *newext,
+					int reserved)
 {
 	struct ext4_ext_path *curp;
 	int depth, i, err = 0;
@@ -980,7 +1015,7 @@ repeat:
 	if (EXT_HAS_FREE_INDEX(curp)) {
 		/* if we found index with free entry, then use that
 		 * entry: create all needed subtree and add new leaf */
-		err = ext4_ext_split(handle, inode, path, newext, i);
+		err = ext4_ext_split(handle, inode, path, newext, reserved, i);
 
 		/* refill path */
 		ext4_ext_drop_refs(path);
@@ -991,7 +1026,8 @@ repeat:
 			err = PTR_ERR(path);
 	} else {
 		/* tree is full, time to grow in depth */
-		err = ext4_ext_grow_indepth(handle, inode, path, newext);
+		err = ext4_ext_grow_indepth(handle, inode, path, newext,
+					reserved);
 		if (err)
 			goto out;
 
@@ -1435,7 +1471,8 @@ out:
  */
 int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 				struct ext4_ext_path *path,
-				struct ext4_extent *newext)
+				struct ext4_extent *newext,
+				int reserved)
 {
 	struct ext4_extent_header * eh;
 	struct ext4_extent *ex, *fex;
@@ -1508,7 +1545,7 @@ repeat:
 	 * There is no free space in the found leaf.
 	 * We're gonna add a new leaf in the tree.
 	 */
-	err = ext4_ext_create_new_leaf(handle, inode, path, newext);
+	err = ext4_ext_create_new_leaf(handle, inode, path, newext, reserved);
 	if (err)
 		goto cleanup;
 	depth = ext_depth(inode);
@@ -2150,7 +2187,8 @@ static int ext4_ext_convert_to_initializ
 						struct inode *inode,
 						struct ext4_ext_path *path,
 						ext4_lblk_t iblock,
-						unsigned long max_blocks)
+						unsigned long max_blocks,
+						int reserved)
 {
 	struct ext4_extent *ex, newex;
 	struct ext4_extent *ex1 = NULL;
@@ -2198,7 +2236,8 @@ static int ext4_ext_convert_to_initializ
 		ext4_ext_store_pblock(ex3, newblock + max_blocks);
 		ex3->ee_len = cpu_to_le16(allocated - max_blocks);
 		ext4_ext_mark_uninitialized(ex3);
-		err = ext4_ext_insert_extent(handle, inode, path, ex3);
+		err = ext4_ext_insert_extent(handle, inode, path, ex3,
+						reserved);
 		if (err)
 			goto out;
 		/*
@@ -2279,7 +2318,7 @@ static int ext4_ext_convert_to_initializ
 	err = ext4_ext_dirty(handle, inode, path + depth);
 	goto out;
 insert:
-	err = ext4_ext_insert_extent(handle, inode, path, &newex);
+	err = ext4_ext_insert_extent(handle, inode, path, &newex, reserved);
 out:
 	return err ? err : allocated;
 }
@@ -2305,7 +2344,7 @@ out:
 int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 			ext4_lblk_t iblock,
 			unsigned long max_blocks, struct buffer_head *bh_result,
-			int create, int extend_disksize)
+			int create, int reserved, int extend_disksize)
 {
 	struct ext4_ext_path *path = NULL;
 	struct ext4_extent_header *eh;
@@ -2395,8 +2434,7 @@ int ext4_ext_get_blocks(handle_t *handle
 				goto out2;
 
 			ret = ext4_ext_convert_to_initialized(handle, inode,
-								path, iblock,
-								max_blocks);
+					path, iblock, max_blocks, reserved);
 			if (ret <= 0) {
 				err = ret;
 				goto out2;
@@ -2462,6 +2500,8 @@ int ext4_ext_get_blocks(handle_t *handle
 	ar.goal = ext4_ext_find_goal(inode, path, iblock);
 	ar.logical = iblock;
 	ar.len = allocated;
+	if (reserved)
+		ar.flags |= EXT4_MB_DELALLOC_RESERVED;
 	if (S_ISREG(inode->i_mode))
 		ar.flags = EXT4_MB_HINT_DATA;
 	else
@@ -2478,7 +2518,7 @@ int ext4_ext_get_blocks(handle_t *handle
 	newex.ee_len = cpu_to_le16(ar.len);
 	if (create == EXT4_CREATE_UNINITIALIZED_EXT)  /* Mark uninitialized */
 		ext4_ext_mark_uninitialized(&newex);
-	err = ext4_ext_insert_extent(handle, inode, path, &newex);
+	err = ext4_ext_insert_extent(handle, inode, path, &newex, reserved);
 	if (err) {
 		/* free data blocks we just allocated */
 		/* not a good idea to call discard here directly,
@@ -2658,7 +2698,7 @@ retry:
 
 		ret = ext4_get_blocks_wrap(handle, inode, block,
 					  max_blocks, &map_bh,
-					  EXT4_CREATE_UNINITIALIZED_EXT, 0);
+					  EXT4_CREATE_UNINITIALIZED_EXT, 0, 0);
 		if (ret <= 0) {
 #ifdef EXT4FS_DEBUG
 			WARN_ON(ret <= 0);
Index: linux-2.6.25-rc2/include/linux/ext4_fs_extents.h
===================================================================
--- linux-2.6.25-rc2.orig/include/linux/ext4_fs_extents.h	2008-02-21 17:30:58.000000000 -0800
+++ linux-2.6.25-rc2/include/linux/ext4_fs_extents.h	2008-02-21 18:03:07.000000000 -0800
@@ -211,7 +211,7 @@ static inline int ext4_ext_get_actual_le
 		le16_to_cpu(ext->ee_len) :
 		(le16_to_cpu(ext->ee_len) - EXT_INIT_MAX_LEN));
 }
-
+extern int ext4_ext_calc_metadata_amount(struct inode *inode, int blocks);
 extern ext4_fsblk_t idx_pblock(struct ext4_extent_idx *);
 extern void ext4_ext_store_pblock(struct ext4_extent *, ext4_fsblk_t);
 extern int ext4_extent_tree_init(handle_t *, struct inode *);
@@ -220,7 +220,7 @@ extern int ext4_ext_try_to_merge(struct 
 				 struct ext4_ext_path *path,
 				 struct ext4_extent *);
 extern unsigned int ext4_ext_check_overlap(struct inode *, struct ext4_extent *, struct ext4_ext_path *);
-extern int ext4_ext_insert_extent(handle_t *, struct inode *, struct ext4_ext_path *, struct ext4_extent *);
+extern int ext4_ext_insert_extent(handle_t *, struct inode *, struct ext4_ext_path *, struct ext4_extent *, int);
 extern struct ext4_ext_path *ext4_ext_find_extent(struct inode *, ext4_lblk_t,
 							struct ext4_ext_path *);
 extern int ext4_ext_search_left(struct inode *, struct ext4_ext_path *,
Index: linux-2.6.25-rc2/fs/ext4/balloc.c
===================================================================
--- linux-2.6.25-rc2.orig/fs/ext4/balloc.c	2008-02-21 17:30:57.000000000 -0800
+++ linux-2.6.25-rc2/fs/ext4/balloc.c	2008-02-21 19:53:06.000000000 -0800
@@ -1609,7 +1609,8 @@ int ext4_should_retry_alloc(struct super
  *
  */
 ext4_fsblk_t ext4_new_blocks_old(handle_t *handle, struct inode *inode,
-			ext4_fsblk_t goal, unsigned long *count, int *errp)
+			ext4_fsblk_t goal, unsigned long *count, int reserved,
+			int *errp)
 {
 	struct buffer_head *bitmap_bh = NULL;
 	struct buffer_head *gdp_bh;
@@ -1662,7 +1663,11 @@ ext4_fsblk_t ext4_new_blocks_old(handle_
 	if (block_i && ((windowsz = block_i->rsv_window_node.rsv_goal_size) > 0))
 		my_rsv = &block_i->rsv_window_node;
 
-	if (!ext4_has_free_blocks(sbi)) {
+	if (reserved)
+		BUG_ON(EXT4_I(inode)->i_reserved_data_blocks +
+			EXT4_I(inode)->i_reserved_meta_blocks < num);
+
+	if (!reserved && !ext4_has_free_blocks(sbi)) {
 		*errp = -ENOSPC;
 		goto out;
 	}
@@ -1833,7 +1838,8 @@ allocated:
 	le16_add_cpu(&gdp->bg_free_blocks_count, -num);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, group_no, gdp);
 	spin_unlock(sb_bgl_lock(sbi, group_no));
-	percpu_counter_sub(&sbi->s_freeblocks_counter, num);
+	if (!reserved)
+		percpu_counter_sub(&sbi->s_freeblocks_counter, num);
 
 	if (sbi->s_log_groups_per_flex) {
 		ext4_group_t flex_group = ext4_flex_group(sbi, group_no);
@@ -1874,14 +1880,15 @@ out:
 }
 
 ext4_fsblk_t ext4_new_block(handle_t *handle, struct inode *inode,
-		ext4_fsblk_t goal, int *errp)
+		ext4_fsblk_t goal, int reserved, int *errp)
 {
 	struct ext4_allocation_request ar;
 	ext4_fsblk_t ret;
 
 	if (!test_opt(inode->i_sb, MBALLOC)) {
 		unsigned long count = 1;
-		ret = ext4_new_blocks_old(handle, inode, goal, &count, errp);
+		ret = ext4_new_blocks_old(handle, inode, goal, &count,
+			reserved, errp);
 		return ret;
 	}
 
@@ -1889,18 +1896,21 @@ ext4_fsblk_t ext4_new_block(handle_t *ha
 	ar.inode = inode;
 	ar.goal = goal;
 	ar.len = 1;
+	ar.flags |= EXT4_MB_DELALLOC_RESERVED;
 	ret = ext4_mb_new_blocks(handle, &ar, errp);
 	return ret;
 }
 
 ext4_fsblk_t ext4_new_blocks(handle_t *handle, struct inode *inode,
-		ext4_fsblk_t goal, unsigned long *count, int *errp)
+		ext4_fsblk_t goal, unsigned long *count, int reserved,
+		int *errp)
 {
 	struct ext4_allocation_request ar;
 	ext4_fsblk_t ret;
 
 	if (!test_opt(inode->i_sb, MBALLOC)) {
-		ret = ext4_new_blocks_old(handle, inode, goal, count, errp);
+		ret = ext4_new_blocks_old(handle, inode, goal, count,
+						reserved, errp);
 		return ret;
 	}
 
@@ -1908,6 +1918,7 @@ ext4_fsblk_t ext4_new_blocks(handle_t *h
 	ar.inode = inode;
 	ar.goal = goal;
 	ar.len = *count;
+	ar.flags |= EXT4_MB_DELALLOC_RESERVED;
 	ret = ext4_mb_new_blocks(handle, &ar, errp);
 	*count = ar.len;
 	return ret;
Index: linux-2.6.25-rc2/fs/ext4/mballoc.c
===================================================================
--- linux-2.6.25-rc2.orig/fs/ext4/mballoc.c	2008-02-21 17:30:57.000000000 -0800
+++ linux-2.6.25-rc2/fs/ext4/mballoc.c	2008-02-21 18:06:06.000000000 -0800
@@ -3106,7 +3106,9 @@ ext4_mb_mark_diskspace_used(struct ext4_
 	le16_add_cpu(&gdp->bg_free_blocks_count, -ac->ac_b_ex.fe_len);
 	gdp->bg_checksum = ext4_group_desc_csum(sbi, ac->ac_b_ex.fe_group, gdp);
 	spin_unlock(sb_bgl_lock(sbi, ac->ac_b_ex.fe_group));
-	percpu_counter_sub(&sbi->s_freeblocks_counter, ac->ac_b_ex.fe_len);
+	if (!ac->ac_flags & EXT4_MB_DELALLOC_RESERVED)
+		percpu_counter_sub(&sbi->s_freeblocks_counter,
+						ac->ac_b_ex.fe_len);
 
 	err = ext4_journal_dirty_metadata(handle, bitmap_bh);
 	if (err)
@@ -3328,6 +3330,9 @@ ext4_mb_normalize_request(struct ext4_al
 		ac->ac_flags |= EXT4_MB_HINT_TRY_GOAL;
 	}
 
+	if (ar->flags & EXT4_MB_DELALLOC_RESERVED)
+		ac->ac_flags |= EXT4_MB_DELALLOC_RESERVED;
+
 	mb_debug("goal: %u(was %u) blocks at %u\n", (unsigned) size,
 		(unsigned) orig_size, (unsigned) start);
 }
@@ -4292,13 +4297,15 @@ ext4_fsblk_t ext4_mb_new_blocks(handle_t
 	ext4_fsblk_t block = 0;
 	int freed;
 	int inquota;
+	int res_flag = 0;
 
 	sb = ar->inode->i_sb;
 	sbi = EXT4_SB(sb);
 
+	res_flag = ar->flags & EXT4_MB_HINT_NOPREALLOC;
 	if (!test_opt(sb, MBALLOC)) {
 		block = ext4_new_blocks_old(handle, ar->inode, ar->goal,
-					    &(ar->len), errp);
+					    &(ar->len), res_flag, errp);
 		return block;
 	}
 
Index: linux-2.6.25-rc2/include/linux/ext4_fs.h
===================================================================
--- linux-2.6.25-rc2.orig/include/linux/ext4_fs.h	2008-02-21 17:30:58.000000000 -0800
+++ linux-2.6.25-rc2/include/linux/ext4_fs.h	2008-02-21 17:56:04.000000000 -0800
@@ -75,6 +75,8 @@
 #define EXT4_MB_HINT_GOAL_ONLY		256
 /* goal is meaningful */
 #define EXT4_MB_HINT_TRY_GOAL		512
+/* blocks already pre-reserved by delayed allocation */
+#define EXT4_MB_DELALLOC_RESERVED	1024
 
 struct ext4_allocation_request {
 	/* target inode for block we're allocating */
@@ -973,11 +975,13 @@ extern int ext4_bg_has_super(struct supe
 extern unsigned long ext4_bg_num_gdb(struct super_block *sb,
 			ext4_group_t group);
 extern ext4_fsblk_t ext4_new_block (handle_t *handle, struct inode *inode,
-			ext4_fsblk_t goal, int *errp);
+			ext4_fsblk_t goal, int reserved, int *errp);
 extern ext4_fsblk_t ext4_new_blocks (handle_t *handle, struct inode *inode,
-			ext4_fsblk_t goal, unsigned long *count, int *errp);
+			ext4_fsblk_t goal, unsigned long *count,
+			int reserved, int *errp);
 extern ext4_fsblk_t ext4_new_blocks_old(handle_t *handle, struct inode *inode,
-			ext4_fsblk_t goal, unsigned long *count, int *errp);
+			ext4_fsblk_t goal, unsigned long *count,
+			int reserved, int *errp);
 extern void ext4_free_blocks (handle_t *handle, struct inode *inode,
 			ext4_fsblk_t block, unsigned long count, int metadata);
 extern void ext4_free_blocks_sb (handle_t *handle, struct super_block *sb,
@@ -1042,7 +1046,8 @@ struct buffer_head *ext4_bread(handle_t 
 int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
 				ext4_lblk_t iblock, unsigned long maxblocks,
 				struct buffer_head *bh_result,
-				int create, int extend_disksize);
+				int create, int extend_disksize,
+				int reserved);
 
 extern struct inode *ext4_iget(struct super_block *, unsigned long);
 extern int  ext4_write_inode (struct inode *, int);
@@ -1216,7 +1221,7 @@ extern int ext4_ext_writepage_trans_bloc
 extern int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 			ext4_lblk_t iblock,
 			unsigned long max_blocks, struct buffer_head *bh_result,
-			int create, int extend_disksize);
+			int create, int extend_disksize, int reserved);
 extern void ext4_ext_truncate(struct inode *, struct page *);
 extern void ext4_ext_init(struct super_block *);
 extern void ext4_ext_release(struct super_block *);
@@ -1225,7 +1230,7 @@ extern long ext4_fallocate(struct inode 
 extern int ext4_get_blocks_wrap(handle_t *handle, struct inode *inode,
 			sector_t block, unsigned long max_blocks,
 			struct buffer_head *bh, int create,
-			int extend_disksize);
+			int extend_disksize, int reserved);
 #endif	/* __KERNEL__ */
 
 #endif	/* _LINUX_EXT4_FS_H */
Index: linux-2.6.25-rc2/fs/ext4/dir.c
===================================================================
--- linux-2.6.25-rc2.orig/fs/ext4/dir.c	2008-02-21 17:48:22.000000000 -0800
+++ linux-2.6.25-rc2/fs/ext4/dir.c	2008-02-21 17:49:05.000000000 -0800
@@ -129,7 +129,8 @@ static int ext4_readdir(struct file * fi
 		struct buffer_head *bh = NULL;
 
 		map_bh.b_state = 0;
-		err = ext4_get_blocks_wrap(NULL, inode, blk, 1, &map_bh, 0, 0);
+		err = ext4_get_blocks_wrap(NULL, inode, blk, 1, &map_bh,
+					0, 0, 0);
 		if (err > 0) {
 			pgoff_t index = map_bh.b_blocknr >>
 					(PAGE_CACHE_SHIFT - inode->i_blkbits);
Index: linux-2.6.25-rc2/fs/ext4/migrate.c
===================================================================
--- linux-2.6.25-rc2.orig/fs/ext4/migrate.c	2008-02-21 18:04:17.000000000 -0800
+++ linux-2.6.25-rc2/fs/ext4/migrate.c	2008-02-21 18:04:38.000000000 -0800
@@ -73,7 +73,7 @@ static int finish_range(handle_t *handle
 				goto err_out;
 		}
 	}
-	retval = ext4_ext_insert_extent(handle, inode, path, &newext);
+	retval = ext4_ext_insert_extent(handle, inode, path, &newext, 0);
 err_out:
 	if (path) {
 		ext4_ext_drop_refs(path);
Index: linux-2.6.25-rc2/fs/ext4/xattr.c
===================================================================
--- linux-2.6.25-rc2.orig/fs/ext4/xattr.c	2008-02-21 18:03:38.000000000 -0800
+++ linux-2.6.25-rc2/fs/ext4/xattr.c	2008-02-21 18:03:58.000000000 -0800
@@ -809,7 +809,7 @@ inserted:
 			ext4_fsblk_t goal = ext4_group_first_block_no(sb,
 						EXT4_I(inode)->i_block_group);
 			ext4_fsblk_t block = ext4_new_block(handle, inode,
-							goal, &error);
+							goal, 0, &error);
 			if (error)
 				goto cleanup;
 			ea_idebug(inode, "creating block %d", block);
