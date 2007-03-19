From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 2/2] Add extent related functions
Date: Mon, 19 Mar 2007 15:05:39 +0530
Message-ID: <11742969462194-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <11742969394136-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <11742969422569-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp05.au.ibm.com ([202.81.18.154]:63875 "EHLO
	ausmtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753762AbXCSJfv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Mar 2007 05:35:51 -0400
Received: from sd0208e0.au.ibm.com (d23rh904.au.ibm.com [202.81.18.202])
	by ausmtp05.au.ibm.com (8.13.8/8.13.8) with ESMTP id l2JLaxwx7123146
	for <linux-ext4@vger.kernel.org>; Mon, 19 Mar 2007 20:36:59 -0100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.250.244])
	by sd0208e0.au.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l2J9dJdY125884
	for <linux-ext4@vger.kernel.org>; Mon, 19 Mar 2007 20:39:19 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l2J9ZmuA030640
	for <linux-ext4@vger.kernel.org>; Mon, 19 Mar 2007 20:35:48 +1100
In-Reply-To: <11742969422569-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Message-Id: <104539cadde0898d825a0d1c00bb3df5d47a2cd5.1174296734.git.aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <94a49d2abd02893948f50e49acebb9ade7146d7a.1174296734.git.aneesh.kumar@linux.vnet.ibm.com>
References: <94a49d2abd02893948f50e49acebb9ade7146d7a.1174296734.git.aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

The code is  derived out of the latest ext4 kernel source. I
have tried to keep the code as close as possible to the kernel
sources. This makes sure that any fixes for the tree building
code in kernel should be easily applied to ext4migrate.  The
ext3_ext naming convention instead of ext4_ext found in kernel is to
make sure we are in sync with rest of e2fsprogs source

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 ext4migrate/extents.c |  737 +++++++++++++++++++++++++++++++++++++++++++++++++
 ext4migrate/extents.h |   10 +
 2 files changed, 747 insertions(+), 0 deletions(-)
 create mode 100644 ext4migrate/extents.c
 create mode 100644 ext4migrate/extents.h

diff --git a/ext4migrate/extents.c b/ext4migrate/extents.c
new file mode 100644
index 0000000..a21b883
--- /dev/null
+++ b/ext4migrate/extents.c
@@ -0,0 +1,737 @@
+#include <stdio.h>
+#include <stdlib.h>
+
+#include "migrate.h"
+#include "extents.h"
+
+struct ext4_ext_path {
+	ext4_fsblk_t			p_block;
+	__u16				p_depth;
+	struct ext3_extent		*p_ext;
+	struct ext3_extent_idx		*p_idx;
+	struct ext3_extent_header	*p_hdr;
+};
+
+/*
+ * ext_pblock:
+ * combine low and high parts of physical block number into ext4_fsblk_t
+ */
+ext4_fsblk_t ext_pblock(struct ext3_extent *ex)
+{
+	ext4_fsblk_t block;
+
+	block = ex->ee_start;
+	block |= ((ext4_fsblk_t) ex->ee_start_hi << 31) << 1;
+	return block;
+}
+
+/*
+ * idx_pblock:
+ * combine low and high parts of a leaf physical block number into ext4_fsblk_t
+ */
+ext4_fsblk_t idx_pblock(struct ext3_extent_idx *ix)
+{
+	ext4_fsblk_t block;
+
+	block = ix->ei_leaf;
+	block |= ((ext4_fsblk_t) ix->ei_leaf_hi << 31) << 1;
+	return block;
+}
+
+/*
+ * ext3_ext_store_pblock:
+ * stores a large physical block number into an extent struct,
+ * breaking it into parts
+ */
+void ext3_ext_store_pblock(struct ext3_extent *ex, ext4_fsblk_t pb)
+{
+	ex->ee_start = (unsigned long) (pb & 0xffffffff);
+	ex->ee_start_hi = (unsigned long) ((pb >> 31) >> 1) & 0xffff;
+}
+
+/*
+ * ext3_idx_store_pblock:
+ * stores a large physical block number into an index struct,
+ * breaking it into parts
+ */
+static void ext3_idx_store_pblock(struct ext3_extent_idx *ix, ext4_fsblk_t pb)
+{
+	ix->ei_leaf = (unsigned long) (pb & 0xffffffff);
+	ix->ei_leaf_hi = (unsigned long) ((pb >> 31) >> 1) & 0xffff;
+}
+
+static int ext3_ext_space_block(ext2_filsys filesys)
+{
+	int size;
+
+	size = (filesys->blocksize - sizeof(struct ext3_extent_header))
+			/ sizeof(struct ext3_extent);
+	return size;
+}
+
+static int ext3_ext_space_block_idx(ext2_filsys filesys)
+{
+	int size;
+
+	size = (filesys->blocksize - sizeof(struct ext3_extent_header))
+			/ sizeof(struct ext3_extent_idx);
+	return size;
+}
+
+int ext3_ext_space_root(void)
+{
+	int size;
+
+	size = EXT2_N_BLOCKS*sizeof(blk_t);
+	size -= sizeof(struct ext3_extent_header);
+	size /= sizeof(struct ext3_extent);
+	return size;
+}
+
+static int ext3_ext_space_root_idx(void)
+{
+	int size;
+
+	size = EXT2_N_BLOCKS*sizeof(blk_t);
+	size -= sizeof(struct ext3_extent_header);
+	size /= sizeof(struct ext3_extent_idx);
+	return size;
+}
+static void ext3_ext_binsearch_idx(struct ext2_inode *file_inode_struct,
+				struct ext4_ext_path *path, blk_t logical_blk)
+{
+	struct ext3_extent_header *eh = path->p_hdr;
+	struct ext3_extent_idx *r, *l, *m;
+	(void) file_inode_struct;
+
+	l = EXT_FIRST_INDEX(eh) + 1;
+	r = EXT_FIRST_INDEX(eh) + eh->eh_entries - 1;
+	while (l <= r) {
+		m = l + (r - l) / 2;
+		if (logical_blk < m->ei_block)
+			r = m - 1;
+		else
+			l = m + 1;
+	}
+	path->p_idx = l - 1;
+}
+
+static void ext3_ext_binsearch(struct ext2_inode *file_inode_struct,
+				struct ext4_ext_path *path, blk_t logical_blk)
+{
+	struct ext3_extent_header *eh = path->p_hdr;
+	struct ext3_extent *r, *l, *m;
+	(void) file_inode_struct;
+
+	if (eh->eh_entries == 0) {
+		/*
+		 * this leaf is empty:
+		 * we get such a leaf in split/add case
+		 */
+		return;
+	}
+
+	l = EXT_FIRST_EXTENT(eh) + 1;
+	r = EXT_FIRST_EXTENT(eh) + eh->eh_entries - 1;
+
+	while (l <= r) {
+		m = l + (r - l) / 2;
+		if (logical_blk < m->ee_block)
+			r = m - 1;
+		else
+			l = m + 1;
+	}
+
+	path->p_ext = l - 1;
+}
+
+/*
+ * ext3_ext_insert_index:
+ * insert new index [@logical;@ptr] into the block at @curp;
+ * check where to insert: before @curp or after @curp
+ */
+static int ext3_ext_insert_index(struct ext4_ext_path *curp,
+				int logical, ext4_fsblk_t ptr)
+{
+	struct ext3_extent_idx *ix;
+	int len, err = 0;
+
+	len = EXT_MAX_INDEX(curp->p_hdr) - curp->p_idx;
+	if (logical > curp->p_idx->ei_block) {
+		/* insert after */
+		if (curp->p_idx != EXT_LAST_INDEX(curp->p_hdr)) {
+			len = (len - 1) * sizeof(struct ext3_extent_idx);
+			len = len < 0 ? 0 : len;
+			memmove(curp->p_idx + 2, curp->p_idx + 1, len);
+		}
+		ix = curp->p_idx + 1;
+	} else {
+		/* insert before */
+		len = len * sizeof(struct ext3_extent_idx);
+		len = len < 0 ? 0 : len;
+		memmove(curp->p_idx + 1, curp->p_idx, len);
+		ix = curp->p_idx;
+	}
+
+	ix->ei_block = logical;
+	ext3_idx_store_pblock(ix, ptr);
+	curp->p_hdr->eh_entries = curp->p_hdr->eh_entries+1;
+
+	return err;
+}
+/*
+ * ext3_ext_split:
+ * inserts new subtree into the path, using free index entry
+ * at depth @at:
+ * - allocates all needed blocks (new leaf and all intermediate index blocks)
+ * - makes decision where to split
+ * - moves remaining extents and index entries (right to the split point)
+ *   into the newly allocated blocks
+ * - initializes subtree
+ */
+static int ext3_ext_split(ext2_filsys filesys, struct ext2_inode *file_inode_struct,
+				struct ext3_extent_header *eh, struct ext4_ext_path *path,
+				struct ext3_extent *newext, int at)
+{
+	int depth = eh->eh_depth;
+	struct ext3_extent_header *neh;
+	struct ext3_extent_idx *fidx;
+	struct ext3_extent *ex;
+	struct blk_cache *blkc;
+	int i = at, k, m, a;
+	ext4_fsblk_t newblock, oldblock;
+	int border;
+	ext4_fsblk_t *ablocks = NULL; /* array of allocated blocks */
+	int err = 0;
+	(void) file_inode_struct;
+
+	/* make decision: where to split? */
+	/* FIXME: now decision is simplest: at current extent */
+
+	/* if current leaf will be split, then we should use
+	 * border from split point */
+	if (path[depth].p_ext != EXT_MAX_EXTENT(path[depth].p_hdr)) {
+		border = path[depth].p_ext[1].ee_block;
+	} else {
+		border = newext->ee_block;
+	}
+
+	/*
+	 * If error occurs, then we break processing
+	 * and mark filesystem read-only. index won't
+	 * be inserted and tree will be in consistent
+	 * state. Next mount will repair buffers too.
+	 */
+
+	/*
+	 * Get array to track all allocated blocks.
+	 * We need this to handle errors and free blocks
+	 * upon them.
+	 */
+	ablocks = malloc(sizeof(ext4_fsblk_t) * depth);
+	if (!ablocks)
+		return -1;
+
+	memset(ablocks, 0, sizeof(ext4_fsblk_t) * depth);
+
+	/* allocate all needed blocks */
+	for (a = 0; a < depth - at; a++) {
+		blkc = get_block(filesys, 0);
+		if (!blkc) {
+			err =  EXT2_ET_BLOCK_ALLOC_FAIL;
+			goto cleanup;
+		}
+		newblock = blkc->pblock;
+		if (newblock == 0)
+			goto cleanup;
+		ablocks[a] = newblock;
+	}
+
+	/* initialize new leaf */
+	newblock = ablocks[--a];
+
+	neh = (struct ext3_extent_header *)(unsigned long)newblock;
+	neh->eh_entries = 0;
+	neh->eh_max = ext3_ext_space_block(filesys);
+	neh->eh_magic = EXT4_EXT_MAGIC;
+	neh->eh_depth = 0;
+	ex = EXT_FIRST_EXTENT(neh);
+
+	/* move remainder of path[depth] to the new leaf */
+	/* start copy from next extent */
+	/* TODO: we could do it by single memmove */
+	m = 0;
+	path[depth].p_ext++;
+	while (path[depth].p_ext <=
+			EXT_MAX_EXTENT(path[depth].p_hdr)) {
+		/*memmove(ex++, path[depth].p_ext++,
+				sizeof(struct ext4_extent));
+		neh->eh_entries++;*/
+		path[depth].p_ext++;
+		m++;
+	}
+
+	/*
+	 * move the part of the old extent to the new allocated one
+	 */
+	if (m) {
+		memmove(ex, path[depth].p_ext-m, sizeof(struct ext3_extent)*m);
+		neh->eh_entries = neh->eh_entries+m;
+	}
+
+	/* correct old leaf */
+	if (m) {
+		path[depth].p_hdr->eh_entries = path[depth].p_hdr->eh_entries-m;
+
+	}
+
+	/* create intermediate indexes */
+	k = depth - at - 1;
+
+	/*create intermediate indices */
+	/* insert new index into current index block */
+	/* current depth stored in i var */
+	i = depth - 1;
+	while (k--) {
+		oldblock = newblock;
+		newblock = ablocks[--a];
+
+		neh =  (struct ext3_extent_header *)(unsigned long)newblock;
+		neh->eh_entries = 1;
+		neh->eh_magic = EXT4_EXT_MAGIC;
+		neh->eh_max = ext3_ext_space_block_idx(filesys);
+		neh->eh_depth = depth - i;
+		fidx = EXT_FIRST_INDEX(neh);
+		fidx->ei_block = border;
+		ext3_idx_store_pblock(fidx, oldblock);
+
+		/* copy indexes */
+		m = 0;
+		path[i].p_idx++;
+
+		while (path[i].p_idx <= EXT_MAX_INDEX(path[i].p_hdr)) {
+			/*memmove(++fidx, path[i].p_idx++,
+					sizeof(struct ext4_extent_idx));
+			neh->eh_entries++;
+			BUG_ON(neh->eh_entries > neh->eh_max);*/
+			path[i].p_idx++;
+			m++;
+		}
+		if (m) {
+			memmove(++fidx, path[i].p_idx - m,
+				sizeof(struct ext3_extent_idx) * m);
+			neh->eh_entries = neh->eh_entries + m;
+		}
+
+
+		/* correct old index */
+		if (m) {
+			path[i].p_hdr->eh_entries = path[i].p_hdr->eh_entries-m;
+		}
+
+		i--;
+	}
+
+	/* insert new index */
+	err = ext3_ext_insert_index(path + at, border, newblock);
+
+cleanup:
+
+	free(ablocks);
+
+	return err;
+}
+
+/*
+ * ext3_ext_grow_indepth:
+ * implements tree growing procedure:
+ * - allocates new block
+ * - moves top-level data (index block or leaf) into the new block
+ * - initializes new top-level, creating index that points to the
+ *   just created block
+ */
+static int ext3_ext_grow_indepth(ext2_filsys filesys, struct ext2_inode *file_inode_struct,
+					struct ext3_extent_header *eh, struct ext4_ext_path *path)
+{
+	struct ext4_ext_path *curp = path;
+	struct ext3_extent_header *neh;
+	struct blk_cache *blkc;
+	ext4_fsblk_t newblock;
+	void *addr;
+
+	blkc = get_block(filesys, 0);
+	if (!blkc) {
+		return  EXT2_ET_BLOCK_ALLOC_FAIL;
+
+	}
+	addr = blkc->block_mem_addr;
+	newblock = blkc->pblock;
+
+	/* move top-level index/leaf into new block */
+	memmove(addr, curp->p_hdr, sizeof(file_inode_struct->i_block));
+
+	/* set size of new block */
+	neh =  (struct ext3_extent_header *)addr;
+	/* old root could have indexes or leaves
+	 * so calculate e_max right way */
+	if (eh->eh_depth) {
+		neh->eh_max = ext3_ext_space_block_idx(filesys);
+	} else {
+		neh->eh_max = ext3_ext_space_block(filesys);
+	}
+
+	neh->eh_magic = EXT4_EXT_MAGIC;
+
+	/* create index in new top-level index: num,max,pointer */
+
+	curp->p_hdr->eh_magic = EXT4_EXT_MAGIC;
+	curp->p_hdr->eh_max = ext3_ext_space_root_idx();
+	curp->p_hdr->eh_entries = 1;
+	curp->p_idx = EXT_FIRST_INDEX(curp->p_hdr);
+	/* FIXME: it works, but actually path[0] can be index */
+	curp->p_idx->ei_block = EXT_FIRST_EXTENT(path[0].p_hdr)->ee_block;
+	ext3_idx_store_pblock(curp->p_idx, newblock);
+
+	neh = eh;
+	//fidx = EXT_FIRST_INDEX(neh);
+
+	neh->eh_depth = path->p_depth + 1;
+
+	return 0;
+}
+struct ext4_ext_path * ext3_ext_find_extent(ext2_filsys filesys, struct ext2_inode *file_inode_struct,
+		struct ext3_extent_header *eh, blk_t logical_blk, struct ext4_ext_path *path)
+{
+
+	struct blk_cache *blkc;
+	short int depth, i, ppos = 0;
+	int alloc = 0;
+
+	i = depth =  eh->eh_depth;
+
+	if (!path) {
+		/*
+		 * We may be called to rebuild the path while growing the 
+		 * depth of the tree
+		 */
+		path = malloc(sizeof(struct ext4_ext_path)* (depth+2));
+		if (!path)
+			return NULL;
+
+		alloc = 1;
+		memset(path, 0, sizeof(struct ext4_ext_path)* (depth+2));
+	}
+
+
+	path[0].p_hdr = eh;
+
+	while (i) {
+
+		ext3_ext_binsearch_idx(file_inode_struct, path, logical_blk);
+
+		path[ppos].p_block = idx_pblock(path[ppos].p_idx);
+		path[ppos].p_depth = i;
+		path[ppos].p_ext = NULL;
+
+		blkc = get_block(filesys, path[ppos].p_block);
+
+		if (!blkc) {
+			if (alloc)
+				free(path);
+			return NULL;
+		}
+
+		eh = blkc->block_mem_addr;
+		if (!eh) {
+			if (alloc)
+				free(path);
+			return NULL;
+		}
+		if (eh->eh_max == 0) {
+			if (alloc)
+				free(path);
+			return NULL;
+		}
+		ppos++;
+		path[ppos].p_hdr = eh;
+		i--;
+	}
+	path[ppos].p_depth = i;
+	path[ppos].p_hdr = eh;
+	path[ppos].p_ext = NULL;
+	path[ppos].p_idx = NULL;
+
+	ext3_ext_binsearch(file_inode_struct, path + ppos, logical_blk);
+
+	return path;
+}
+
+static int ext3_ext_create_new_leaf(ext2_filsys filesys, struct ext2_inode *file_inode_struct,
+					struct ext3_extent_header *eh,
+					struct ext4_ext_path *path, struct ext3_extent *newext)
+{
+
+	struct ext4_ext_path *curp;
+	int depth, i, err = 0;
+
+repeat:
+	i = depth = eh->eh_depth;
+
+	/* walk up to the tree and look for free index entry */
+	curp = path + depth;
+	while (i > 0 && !EXT_HAS_FREE_INDEX(curp)) {
+		i--;
+		curp--;
+	}
+
+	if (EXT_HAS_FREE_INDEX(curp)) {
+
+		/* if we found index with free entry, then use that
+		 * entry: create all needed subtree and add new leaf */
+		err = ext3_ext_split(filesys, file_inode_struct, eh, path, newext, i);
+		if (err)
+			goto err_out;
+
+		/* recalculate the path since grow inode would have changed it */
+		path = ext3_ext_find_extent(filesys, file_inode_struct, eh, newext->ee_block, path);
+		if (!path) {
+			err = EXT2_ET_BLOCK_ALLOC_FAIL;
+			goto err_out;
+		}
+
+	} else {
+
+		/* tree is full, time to grow in depth */
+		err = ext3_ext_grow_indepth(filesys, file_inode_struct, eh, path);
+		if (err)
+			goto err_out;
+
+		/* recalculate the path since grow inode would have changed it */
+		path = ext3_ext_find_extent(filesys, file_inode_struct, eh, newext->ee_block, path);
+		if (!path) {
+			err = EXT2_ET_BLOCK_ALLOC_FAIL;
+			goto err_out;
+		}
+
+
+		/*
+		 * only first (depth 0 -> 1) produces free space;
+		 * in all other cases we have to split the grown tree
+		 */
+		depth = eh->eh_depth;
+		if (path[depth].p_hdr->eh_entries == path[depth].p_hdr->eh_max) {
+			/* now we need to split */
+			goto repeat;
+		}
+
+	}
+
+err_out:
+
+	return err;
+}
+
+static int ext3_can_extents_be_merged(struct ext3_extent *ex1, struct ext3_extent *ex2)
+{
+	if (ex1->ee_block + ex1->ee_len != ex2->ee_block)
+		return 0;
+
+
+	if (ext_pblock(ex1) + ex1->ee_len == ext_pblock(ex2))
+		return 1;
+	return 0;
+}
+
+
+/*
+ * ext3_ext_next_leaf_block:
+ * returns first allocated block from next leaf or EXT_MAX_BLOCK
+ */
+static unsigned ext3_ext_next_leaf_block(struct ext4_ext_path *path)
+{
+	int depth;
+
+	depth = path->p_depth;
+
+	/* zero-tree has no leaf blocks at all */
+	if (depth == 0)
+		return EXT_MAX_BLOCK;
+
+	/* go to index block */
+	depth--;
+
+	while (depth >= 0) {
+		if (path[depth].p_idx != EXT_LAST_INDEX(path[depth].p_hdr)) {
+			return path[depth].p_idx[1].ei_block;
+		}
+		depth--;
+	}
+
+	return EXT_MAX_BLOCK;
+}
+
+/*
+ * ext3_ext_correct_indexes:
+ * if leaf gets modified and modified extent is first in the leaf,
+ * then we have to correct all indexes above.
+ * TODO: do we need to correct tree in all cases?
+ */
+static void ext3_ext_correct_indexes(struct ext2_inode *file_inode_struct,
+			struct ext3_extent_header *eh, struct ext4_ext_path *path)
+{
+	int depth = eh->eh_depth;
+	struct ext3_extent *ex;
+	int border;
+	int k;
+
+	(void) file_inode_struct;
+
+	eh = path[depth].p_hdr;
+	ex = path[depth].p_ext;
+
+	if (depth == 0) {
+		/* there is no tree at all */
+		return;
+	}
+
+	if (ex != EXT_FIRST_EXTENT(eh)) {
+		/* we correct tree if first leaf got modified only */
+		return;
+	}
+
+	/*
+	 * TODO: we need correction if border is smaller than current one
+	 */
+	k = depth - 1;
+	border = path[depth].p_ext->ee_block;
+	path[k].p_idx->ei_block = border;
+
+	while (k--) {
+		/* change all left-side indexes */
+		if (path[k+1].p_idx != EXT_FIRST_INDEX(path[k+1].p_hdr))
+			break;
+		path[k].p_idx->ei_block = border;
+	}
+
+	return;
+}
+
+int ext3_ext_insert_extent(ext2_filsys filesys, struct ext2_inode *file_inode_struct, struct ext3_extent_header *eh,
+				struct ext4_ext_path *path, struct ext3_extent *newext)
+{
+
+	struct ext3_extent *ex, *fex;
+	struct ext3_extent *nearex; /* nearest extent */
+	struct ext4_ext_path *npath = NULL;
+	int depth, len, err = 0, next;
+	struct ext3_extent_header *save_eh = eh;
+
+	depth = eh->eh_depth;
+	ex = path[depth].p_ext;
+
+	/* try to insert block into found extent and return */
+	if (ex && ext3_can_extents_be_merged(ex, newext)) {
+		ex->ee_len = ex->ee_len + newext->ee_len;
+		eh = path[depth].p_hdr;
+		nearex = ex;
+		goto merge;
+	}
+
+repeat:
+	/* recalculate depth here */
+	depth=save_eh->eh_depth;
+
+	eh = path[depth].p_hdr;
+	if (eh->eh_entries < eh->eh_max)
+		goto has_space;
+
+	/* probably next leaf has space for us? */
+	fex = EXT_LAST_EXTENT(eh);
+	next = ext3_ext_next_leaf_block(path);
+
+	if (newext->ee_block > fex->ee_block && next != EXT_MAX_BLOCK) {
+
+		npath = ext3_ext_find_extent(filesys, file_inode_struct, save_eh, next, NULL);
+		if (!npath) {
+			return EXT2_ET_BLOCK_ALLOC_FAIL;
+		}
+
+		eh = npath[depth].p_hdr;
+		if (eh->eh_entries < eh->eh_max) {
+			path = npath;
+			goto repeat;
+		}
+	}
+
+	/*
+	 * There is no free space in the found leaf.
+	 * We're gonna add a new leaf in the tree.
+	 */
+	err = ext3_ext_create_new_leaf(filesys, file_inode_struct, save_eh, path, newext);
+	if (err)
+		goto cleanup;
+
+	/* recalculate depth here */
+	depth=save_eh->eh_depth;
+	eh = path[depth].p_hdr;
+
+has_space:
+
+	nearex = path[depth].p_ext;
+
+	if (!nearex) {
+		/* there is no extent in this leaf, create first one */
+		path[depth].p_ext = EXT_FIRST_EXTENT(eh);
+
+	} else if (newext->ee_block > nearex->ee_block) {
+
+		if (nearex != EXT_LAST_EXTENT(eh)) {
+			len = EXT_MAX_EXTENT(eh) - nearex;
+			len = (len - 1) * sizeof(struct ext3_extent);
+			len = len < 0 ? 0 : len;
+			memmove(nearex + 2, nearex + 1, len);
+		}
+		path[depth].p_ext = nearex + 1;
+	} else {
+		len = (EXT_MAX_EXTENT(eh) - nearex) * sizeof(struct ext3_extent);
+		len = len < 0 ? 0 : len;
+		memmove(nearex + 1, nearex, len);
+		path[depth].p_ext = nearex;
+	}
+
+	eh->eh_entries = eh->eh_entries+1;
+	nearex = path[depth].p_ext;
+	nearex->ee_block = newext->ee_block;
+	nearex->ee_start = newext->ee_start;
+	nearex->ee_start_hi = newext->ee_start_hi;
+	nearex->ee_len = newext->ee_len;
+
+merge:
+	/* try to merge extents to the right */
+	while (nearex < EXT_LAST_EXTENT(eh)) {
+		if (!ext3_can_extents_be_merged(nearex, nearex + 1))
+			break;
+		/* merge with next extent! */
+		nearex->ee_len = nearex->ee_len + nearex[1].ee_len;
+
+		if (nearex + 1 < EXT_LAST_EXTENT(eh)) {
+			len = (EXT_LAST_EXTENT(eh) - nearex - 1)
+					* sizeof(struct ext3_extent);
+			memmove(nearex + 1, nearex + 2, len);
+		}
+		eh->eh_entries = eh->eh_entries-1;
+	}
+
+	/* try to merge extents to the left */
+
+	/* time to correct all indexes above */
+	ext3_ext_correct_indexes(file_inode_struct, save_eh, path);
+
+cleanup:
+	if (npath) {
+		free(npath);
+	}
+
+	return err;
+}
+
diff --git a/ext4migrate/extents.h b/ext4migrate/extents.h
new file mode 100644
index 0000000..1cde4f6
--- /dev/null
+++ b/ext4migrate/extents.h
@@ -0,0 +1,10 @@
+
+struct ext4_ext_path * ext3_ext_find_extent(ext2_filsys, struct ext2_inode *,
+		struct ext3_extent_header *, blk_t , struct ext4_ext_path *);
+struct blk_cache * get_block(ext2_filsys, ext4_fsblk_t);
+int ext3_ext_space_root(void);
+ext4_fsblk_t ext_pblock(struct ext3_extent *);
+ext4_fsblk_t idx_pblock(struct ext3_extent_idx *);
+void ext3_ext_store_pblock(struct ext3_extent *, ext4_fsblk_t );
+int ext3_ext_insert_extent(ext2_filsys, struct ext2_inode *, struct ext3_extent_header *,
+				struct ext4_ext_path *, struct ext3_extent *);
-- 
1.5.0.4.402.g8035-dirty
