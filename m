From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Introduce ext4_inoblk_t
Date: Tue,  9 Oct 2007 21:36:12 +0530
Message-ID: <1191945972-11403-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:57684 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbXJIQGU (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 9 Oct 2007 12:06:20 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id l99G6GGo017823
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2007 02:06:16 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l99G6GhH4431968
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2007 02:06:16 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l99G6GEB001655
	for <linux-ext4@vger.kernel.org>; Wed, 10 Oct 2007 02:06:16 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This patch adds a new data type ext4_inoblk_t to represent
the logical file blocks.

This is the preparatory patch to support large files in ext4
The follow up patch with convert the ext4_inode i_blocks to
represent the number of blocks in file system block size. This
changes makes it possible to have a block number 2**32 -1 which
will result in overflow if the block number is represented by
signed long. This patch convert all the block number to type
ext4_inoblk_t which is typedef to __u32

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c               |  170 ++++++++------------------------------
 fs/ext4/inode.c                 |   25 +++---
 fs/ext4/mballoc.c               |   29 +++----
 fs/ext4/migrate.c               |   24 +++---
 include/linux/ext4_fs.h         |   20 +++--
 include/linux/ext4_fs_extents.h |   25 ++-----
 include/linux/ext4_fs_i.h       |    5 +-
 7 files changed, 96 insertions(+), 202 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 0ea6122..c83c2ff 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -144,7 +144,7 @@ static int ext4_ext_dirty(handle_t *handle, struct inode *inode,
 
 static ext4_fsblk_t ext4_ext_find_goal(struct inode *inode,
 			      struct ext4_ext_path *path,
-			      ext4_fsblk_t block)
+			      ext4_inoblk_t block)
 {
 	struct ext4_inode_info *ei = EXT4_I(inode);
 	ext4_fsblk_t bg_start;
@@ -367,13 +367,14 @@ static void ext4_ext_drop_refs(struct ext4_ext_path *path)
  * the header must be checked before calling this
  */
 static void
-ext4_ext_binsearch_idx(struct inode *inode, struct ext4_ext_path *path, int block)
+ext4_ext_binsearch_idx(struct inode *inode,
+			struct ext4_ext_path *path, ext4_inoblk_t block)
 {
 	struct ext4_extent_header *eh = path->p_hdr;
 	struct ext4_extent_idx *r, *l, *m;
 
 
-	ext_debug("binsearch for %d(idx):  ", block);
+	ext_debug("binsearch for %lu(idx):  ", (unsigned long)block);
 
 	l = EXT_FIRST_INDEX(eh) + 1;
 	r = EXT_LAST_INDEX(eh);
@@ -425,7 +426,8 @@ ext4_ext_binsearch_idx(struct inode *inode, struct ext4_ext_path *path, int bloc
  * the header must be checked before calling this
  */
 static void
-ext4_ext_binsearch(struct inode *inode, struct ext4_ext_path *path, int block)
+ext4_ext_binsearch(struct inode *inode,
+		struct ext4_ext_path *path, ext4_inoblk_t block)
 {
 	struct ext4_extent_header *eh = path->p_hdr;
 	struct ext4_extent *r, *l, *m;
@@ -438,7 +440,7 @@ ext4_ext_binsearch(struct inode *inode, struct ext4_ext_path *path, int block)
 		return;
 	}
 
-	ext_debug("binsearch for %d:  ", block);
+	ext_debug("binsearch for %lu:  ", (unsigned long)block);
 
 	l = EXT_FIRST_EXTENT(eh) + 1;
 	r = EXT_LAST_EXTENT(eh);
@@ -494,7 +496,8 @@ int ext4_ext_tree_init(handle_t *handle, struct inode *inode)
 }
 
 struct ext4_ext_path *
-ext4_ext_find_extent(struct inode *inode, int block, struct ext4_ext_path *path)
+ext4_ext_find_extent(struct inode *inode, ext4_inoblk_t block,
+					struct ext4_ext_path *path)
 {
 	struct ext4_extent_header *eh;
 	struct buffer_head *bh;
@@ -979,8 +982,8 @@ repeat:
 		/* refill path */
 		ext4_ext_drop_refs(path);
 		path = ext4_ext_find_extent(inode,
-					    le32_to_cpu(newext->ee_block),
-					    path);
+				    (ext4_inoblk_t )le32_to_cpu(newext->ee_block),
+				    path);
 		if (IS_ERR(path))
 			err = PTR_ERR(path);
 	} else {
@@ -992,8 +995,8 @@ repeat:
 		/* refill path */
 		ext4_ext_drop_refs(path);
 		path = ext4_ext_find_extent(inode,
-					    le32_to_cpu(newext->ee_block),
-					    path);
+				   (ext4_inoblk_t)le32_to_cpu(newext->ee_block),
+				    path);
 		if (IS_ERR(path)) {
 			err = PTR_ERR(path);
 			goto out;
@@ -1023,7 +1026,7 @@ out:
  */
 int
 ext4_ext_search_left(struct inode *inode, struct ext4_ext_path *path,
-			ext4_fsblk_t *logical, ext4_fsblk_t *phys)
+			ext4_inoblk_t *logical, ext4_fsblk_t *phys)
 {
 	struct ext4_extent_idx *ix;
 	struct ext4_extent *ex;
@@ -1066,7 +1069,7 @@ ext4_ext_search_left(struct inode *inode, struct ext4_ext_path *path,
  */
 int
 ext4_ext_search_right(struct inode *inode, struct ext4_ext_path *path,
-			ext4_fsblk_t *logical, ext4_fsblk_t *phys)
+			ext4_inoblk_t *logical, ext4_fsblk_t *phys)
 {
 	struct buffer_head *bh = NULL;
 	struct ext4_extent_header *eh;
@@ -1196,7 +1199,7 @@ ext4_ext_next_allocated_block(struct ext4_ext_path *path)
  * ext4_ext_next_leaf_block:
  * returns first allocated block from next leaf or EXT_MAX_BLOCK
  */
-static unsigned ext4_ext_next_leaf_block(struct inode *inode,
+static ext4_inoblk_t ext4_ext_next_leaf_block(struct inode *inode,
 					struct ext4_ext_path *path)
 {
 	int depth;
@@ -1214,7 +1217,7 @@ static unsigned ext4_ext_next_leaf_block(struct inode *inode,
 	while (depth >= 0) {
 		if (path[depth].p_idx !=
 				EXT_LAST_INDEX(path[depth].p_hdr))
-		  return le32_to_cpu(path[depth].p_idx[1].ei_block);
+		  return (ext4_inoblk_t)le32_to_cpu(path[depth].p_idx[1].ei_block);
 		depth--;
 	}
 
@@ -1432,7 +1435,8 @@ int ext4_ext_insert_extent(handle_t *handle, struct inode *inode,
 	struct ext4_extent *ex, *fex;
 	struct ext4_extent *nearex; /* nearest extent */
 	struct ext4_ext_path *npath = NULL;
-	int depth, len, err, next;
+	int depth, len, err;
+	ext4_inoblk_t next;
 	unsigned uninitialized = 0;
 
 	BUG_ON(ext4_ext_get_actual_len(newext) == 0);
@@ -1577,114 +1581,8 @@ cleanup:
 	return err;
 }
 
-int ext4_ext_walk_space(struct inode *inode, unsigned long block,
-			unsigned long num, ext_prepare_callback func,
-			void *cbdata)
-{
-	struct ext4_ext_path *path = NULL;
-	struct ext4_ext_cache cbex;
-	struct ext4_extent *ex;
-	unsigned long next, start = 0, end = 0;
-	unsigned long last = block + num;
-	int depth, exists, err = 0;
-
-	BUG_ON(func == NULL);
-	BUG_ON(inode == NULL);
-
-	while (block < last && block != EXT_MAX_BLOCK) {
-		num = last - block;
-		/* find extent for this block */
-		path = ext4_ext_find_extent(inode, block, path);
-		if (IS_ERR(path)) {
-			err = PTR_ERR(path);
-			path = NULL;
-			break;
-		}
-
-		depth = ext_depth(inode);
-		BUG_ON(path[depth].p_hdr == NULL);
-		ex = path[depth].p_ext;
-		next = ext4_ext_next_allocated_block(path);
-
-		exists = 0;
-		if (!ex) {
-			/* there is no extent yet, so try to allocate
-			 * all requested space */
-			start = block;
-			end = block + num;
-		} else if (le32_to_cpu(ex->ee_block) > block) {
-			/* need to allocate space before found extent */
-			start = block;
-			end = le32_to_cpu(ex->ee_block);
-			if (block + num < end)
-				end = block + num;
-		} else if (block >= le32_to_cpu(ex->ee_block)
-					+ ext4_ext_get_actual_len(ex)) {
-			/* need to allocate space after found extent */
-			start = block;
-			end = block + num;
-			if (end >= next)
-				end = next;
-		} else if (block >= le32_to_cpu(ex->ee_block)) {
-			/*
-			 * some part of requested space is covered
-			 * by found extent
-			 */
-			start = block;
-			end = le32_to_cpu(ex->ee_block)
-				+ ext4_ext_get_actual_len(ex);
-			if (block + num < end)
-				end = block + num;
-			exists = 1;
-		} else {
-			BUG();
-		}
-		BUG_ON(end <= start);
-
-		if (!exists) {
-			cbex.ec_block = start;
-			cbex.ec_len = end - start;
-			cbex.ec_start = 0;
-			cbex.ec_type = EXT4_EXT_CACHE_GAP;
-		} else {
-			cbex.ec_block = le32_to_cpu(ex->ee_block);
-			cbex.ec_len = ext4_ext_get_actual_len(ex);
-			cbex.ec_start = ext_pblock(ex);
-			cbex.ec_type = EXT4_EXT_CACHE_EXTENT;
-		}
-
-		BUG_ON(cbex.ec_len == 0);
-		err = func(inode, path, &cbex, cbdata);
-		ext4_ext_drop_refs(path);
-
-		if (err < 0)
-			break;
-		if (err == EXT_REPEAT)
-			continue;
-		else if (err == EXT_BREAK) {
-			err = 0;
-			break;
-		}
-
-		if (ext_depth(inode) != depth) {
-			/* depth was changed. we have to realloc path */
-			kfree(path);
-			path = NULL;
-		}
-
-		block = cbex.ec_block + cbex.ec_len;
-	}
-
-	if (path) {
-		ext4_ext_drop_refs(path);
-		kfree(path);
-	}
-
-	return err;
-}
-
 static void
-ext4_ext_put_in_cache(struct inode *inode, __u32 block,
+ext4_ext_put_in_cache(struct inode *inode, ext4_inoblk_t block,
 			__u32 len, ext4_fsblk_t start, int type)
 {
 	struct ext4_ext_cache *cex;
@@ -1703,10 +1601,11 @@ ext4_ext_put_in_cache(struct inode *inode, __u32 block,
  */
 static void
 ext4_ext_put_gap_in_cache(struct inode *inode, struct ext4_ext_path *path,
-				unsigned long block)
+				ext4_inoblk_t block)
 {
 	int depth = ext_depth(inode);
-	unsigned long lblock, len;
+	unsigned long len;
+	ext4_inoblk_t lblock;
 	struct ext4_extent *ex;
 
 	ex = path[depth].p_ext;
@@ -1743,7 +1642,7 @@ ext4_ext_put_gap_in_cache(struct inode *inode, struct ext4_ext_path *path,
 }
 
 static int
-ext4_ext_in_cache(struct inode *inode, unsigned long block,
+ext4_ext_in_cache(struct inode *inode, ext4_inoblk_t block,
 			struct ext4_extent *ex)
 {
 	struct ext4_ext_cache *cex;
@@ -2238,9 +2137,9 @@ void ext4_ext_release(struct super_block *sb)
  *   b> Splits in two extents: Write is happening at either end of the extent
  *   c> Splits in three extents: Somone is writing in middle of the extent
  */
-int ext4_ext_convert_to_initialized(handle_t *handle, struct inode *inode,
+static int ext4_ext_convert_to_initialized(handle_t *handle, struct inode *inode,
 					struct ext4_ext_path *path,
-					ext4_fsblk_t iblock,
+					ext4_inoblk_t iblock,
 					unsigned long max_blocks)
 {
 	struct ext4_extent *ex, newex;
@@ -2374,7 +2273,7 @@ out:
  * mutex_lock(&EXT4_I(inode)->truncate_mutex);
  */
 int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
-			ext4_fsblk_t iblock,
+			ext4_inoblk_t iblock,
 			unsigned long max_blocks, struct buffer_head *bh_result,
 			int create, int extend_disksize)
 {
@@ -2387,8 +2286,9 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	struct ext4_allocation_request ar;
 
 	__clear_bit(BH_New, &bh_result->b_state);
-	ext_debug("blocks %d/%lu requested for inode %u\n", (int) iblock,
-			max_blocks, (unsigned) inode->i_ino);
+	ext_debug("blocks %lu/%lu requested for inode %u\n",
+			(unsigned long )iblock, max_blocks,
+			(unsigned) inode->i_ino);
 
 	/* check in cache */
 	goal = ext4_ext_in_cache(inode, iblock, &newex);
@@ -2436,7 +2336,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 
 	ex = path[depth].p_ext;
 	if (ex) {
-		unsigned long ee_block = le32_to_cpu(ex->ee_block);
+		ext4_inoblk_t ee_block = le32_to_cpu(ex->ee_block);
 		ext4_fsblk_t ee_start = ext_pblock(ex);
 		unsigned short ee_len;
 
@@ -2686,7 +2586,8 @@ int ext4_ext_writepage_trans_blocks(struct inode *inode, int num)
 long ext4_fallocate(struct inode *inode, int mode, loff_t offset, loff_t len)
 {
 	handle_t *handle;
-	ext4_fsblk_t block, max_blocks;
+	ext4_inoblk_t block;
+	unsigned long max_blocks;
 	ext4_fsblk_t nblocks = 0;
 	int ret = 0;
 	int ret2 = 0;
@@ -2731,8 +2632,9 @@ retry:
 		if (!ret) {
 			ext4_error(inode->i_sb, "ext4_fallocate",
 				   "ext4_ext_get_blocks returned 0! inode#%lu"
-				   ", block=%llu, max_blocks=%llu",
-				   inode->i_ino, block, max_blocks);
+				   ", block=%lu, max_blocks=%lu",
+				   inode->i_ino, (unsigned long)block,
+				   (unsigned long)max_blocks);
 			ret = -EIO;
 			ext4_mark_inode_dirty(handle, inode);
 			ret2 = ext4_journal_stop(handle);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index de5619f..635b5dc 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -277,7 +277,8 @@ static inline void add_chain(Indirect *p, struct buffer_head *bh, __le32 *v)
  */
 
 static int ext4_block_to_path(struct inode *inode,
-			long i_block, int offsets[4], int *boundary)
+			ext4_inoblk_t i_block,
+			ext4_inoblk_t offsets[4], int *boundary)
 {
 	int ptrs = EXT4_ADDR_PER_BLOCK(inode->i_sb);
 	int ptrs_bits = EXT4_ADDR_PER_BLOCK_BITS(inode->i_sb);
@@ -345,7 +346,8 @@ static int ext4_block_to_path(struct inode *inode,
  *      Need to be called with
  *      mutex_lock(&EXT4_I(inode)->truncate_mutex)
  */
-static Indirect *ext4_get_branch(struct inode *inode, int depth, int *offsets,
+static Indirect *ext4_get_branch(struct inode *inode, int depth,
+				 ext4_inoblk_t  *offsets,
 				 Indirect chain[4], int *err)
 {
 	struct super_block *sb = inode->i_sb;
@@ -434,7 +436,7 @@ static ext4_fsblk_t ext4_find_near(struct inode *inode, Indirect *ind)
  *	stores it in *@goal and returns zero.
  */
 
-static ext4_fsblk_t ext4_find_goal(struct inode *inode, long block,
+static ext4_fsblk_t ext4_find_goal(struct inode *inode, ext4_inoblk_t block,
 		Indirect chain[4], Indirect *partial)
 {
 	struct ext4_block_alloc_info *block_i;
@@ -579,7 +581,7 @@ failed_out:
  */
 static int ext4_alloc_branch(handle_t *handle, struct inode *inode,
 			int indirect_blks, int *blks, ext4_fsblk_t goal,
-			int *offsets, Indirect *branch)
+			ext4_inoblk_t *offsets, Indirect *branch)
 {
 	int blocksize = inode->i_sb->s_blocksize;
 	int i, n = 0;
@@ -669,7 +671,7 @@ failed:
  * chain to new block and return 0.
  */
 static int ext4_splice_branch(handle_t *handle, struct inode *inode,
-			long block, Indirect *where, int num, int blks)
+			ext4_inoblk_t block, Indirect *where, int num, int blks)
 {
 	int i;
 	int err = 0;
@@ -777,12 +779,12 @@ err_out:
  * mutex_lock(&EXT4_I(inode)->truncate_mutex)
  */
 int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
-		sector_t iblock, unsigned long maxblocks,
+		ext4_inoblk_t iblock, unsigned long maxblocks,
 		struct buffer_head *bh_result,
 		int create, int extend_disksize)
 {
 	int err = -EIO;
-	int offsets[4];
+	ext4_inoblk_t offsets[4];
 	Indirect chain[4];
 	Indirect *partial;
 	ext4_fsblk_t goal;
@@ -796,7 +798,8 @@ int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
 
 	J_ASSERT(!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL));
 	J_ASSERT(handle != NULL || create == 0);
-	depth = ext4_block_to_path(inode,iblock,offsets,&blocks_to_boundary);
+	depth = ext4_block_to_path(inode, iblock, offsets,
+					&blocks_to_boundary);
 
 	if (depth == 0)
 		goto out;
@@ -2005,7 +2008,7 @@ static inline int all_zeroes(__le32 *p, __le32 *q)
  *			(no partially truncated stuff there).  */
 
 static Indirect *ext4_find_shared(struct inode *inode, int depth,
-			int offsets[4], Indirect chain[4], __le32 *top)
+			ext4_inoblk_t offsets[4], Indirect chain[4], __le32 *top)
 {
 	Indirect *partial, *p;
 	int k, err;
@@ -2330,12 +2333,12 @@ void ext4_truncate(struct inode *inode)
 	__le32 *i_data = ei->i_data;
 	int addr_per_block = EXT4_ADDR_PER_BLOCK(inode->i_sb);
 	struct address_space *mapping = inode->i_mapping;
-	int offsets[4];
+	ext4_inoblk_t offsets[4];
 	Indirect chain[4];
 	Indirect *partial;
 	__le32 nr = 0;
 	int n;
-	long last_block;
+	ext4_inoblk_t last_block;
 	unsigned blocksize = inode->i_sb->s_blocksize;
 	struct page *page;
 
diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 79a3530..f95e667 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -349,7 +349,7 @@ struct ext4_prealloc_space {
 	atomic_t		pa_count;
 	unsigned		pa_deleted;
 	ext4_fsblk_t		pa_pstart;	/* phys. block */
-	unsigned long		pa_lstart;	/* log. block */
+	ext4_inoblk_t		pa_lstart;	/* log. block */
 	unsigned short		pa_len;		/* len of preallocated chunk */
 	unsigned short		pa_free;	/* how many blocks are free */
 	unsigned short		pa_linear;	/* consumed in one direction
@@ -360,7 +360,7 @@ struct ext4_prealloc_space {
 
 
 struct ext4_free_extent {
-	unsigned long fe_logical;
+	ext4_inoblk_t fe_logical;
 	ext4_grpblk_t fe_start;
 	unsigned long fe_group;
 	unsigned long fe_len;
@@ -2058,13 +2058,13 @@ static int ext4_mb_seq_history_show(struct seq_file *seq, void *v)
 			"%-5u %-5s %-5u %-6u\n";
 		sprintf(buf2, "%lu/%d/%lu@%lu", hs->result.fe_group,
 			hs->result.fe_start, hs->result.fe_len,
-			hs->result.fe_logical);
+			(unsigned long)hs->result.fe_logical);
 		sprintf(buf, "%lu/%d/%lu@%lu", hs->orig.fe_group,
 			hs->orig.fe_start, hs->orig.fe_len,
-			hs->orig.fe_logical);
+			(unsigned long)hs->orig.fe_logical);
 		sprintf(buf3, "%lu/%d/%lu@%lu", hs->goal.fe_group,
 			hs->goal.fe_start, hs->goal.fe_len,
-			hs->goal.fe_logical);
+			(unsigned long)hs->goal.fe_logical);
 		seq_printf(seq, fmt, hs->pid, hs->ino, buf, buf3, buf2,
 				hs->found, hs->groups, hs->cr, hs->flags,
 				hs->merged ? "M" : "", hs->tail,
@@ -2073,10 +2073,10 @@ static int ext4_mb_seq_history_show(struct seq_file *seq, void *v)
 		fmt = "%-5u %-8u %-23s %-23s %-23s\n";
 		sprintf(buf2, "%lu/%d/%lu@%lu", hs->result.fe_group,
 			hs->result.fe_start, hs->result.fe_len,
-			hs->result.fe_logical);
+			(unsigned long)hs->result.fe_logical);
 		sprintf(buf, "%lu/%d/%lu@%lu", hs->orig.fe_group,
 			hs->orig.fe_start, hs->orig.fe_len,
-			hs->orig.fe_logical);
+			(unsigned long)hs->orig.fe_logical);
 		seq_printf(seq, fmt, hs->pid, hs->ino, buf, "", buf2);
 	} else if (hs->op == EXT4_MB_HISTORY_DISCARD) {
 		sprintf(buf2, "%lu/%d/%lu", hs->result.fe_group,
@@ -3067,17 +3067,14 @@ static void ext4_mb_normalize_group_request(struct ext4_allocation_context *ac)
 static void ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 				struct ext4_allocation_request *ar)
 {
+	unsigned long wind;
+	int bsbits, i;
+	ext4_inoblk_t end;
+	struct list_head *cur;
+	loff_t size, orig_size;
+	ext4_inoblk_t start, orig_start;
 	struct ext4_inode_info *ei = EXT4_I(ac->ac_inode);
 	struct ext4_sb_info *sbi = EXT4_SB(ac->ac_sb);
-	loff_t start;
-	loff_t end;
-	loff_t size;
-	loff_t orig_size;
-	loff_t orig_start;
-	loff_t wind;
-	struct list_head *cur;
-	int bsbits;
-	int i;
 
 	/* do normalize only data requests, metadata requests
 	   do not need preallocation */
diff --git a/fs/ext4/migrate.c b/fs/ext4/migrate.c
index 3a306b8..ec1b2ee 100644
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -17,7 +17,7 @@
 #include <linux/ext4_fs_extents.h>
 
 struct list_blocks_struct {
-	int first_block, last_block;
+	ext4_inoblk_t first_block, last_block;
 	ext4_fsblk_t first_pblock, last_pblock;
 };
 
@@ -85,7 +85,7 @@ err_out:
 	return retval;
 }
 static int update_extent_range(handle_t *handle, struct inode *inode,
-				ext4_fsblk_t pblock, int blk_num,
+				ext4_fsblk_t pblock, ext4_inoblk_t blk_num,
 				struct list_blocks_struct *lb)
 {
 	int retval;
@@ -112,13 +112,13 @@ static int update_extent_range(handle_t *handle, struct inode *inode,
 }
 
 static int update_ind_extent_range(handle_t *handle, struct inode *inode,
-					ext4_fsblk_t pblock, int *blk_nump,
-					struct list_blocks_struct *lb)
+				   ext4_fsblk_t pblock, ext4_inoblk_t *blk_nump,
+				   struct list_blocks_struct *lb)
 {
 	struct buffer_head *bh;
 	__le32 *i_data;
 	int i, retval = 0;
-	int blk_count = *blk_nump;
+	ext4_inoblk_t blk_count = *blk_nump;
 	unsigned long max_entries = inode->i_sb->s_blocksize >> 2;
 
 	if (!pblock) {
@@ -150,13 +150,13 @@ static int update_ind_extent_range(handle_t *handle, struct inode *inode,
 
 }
 static int update_dind_extent_range(handle_t *handle, struct inode *inode,
-					ext4_fsblk_t pblock, int *blk_nump,
-					struct list_blocks_struct *lb)
+				    ext4_fsblk_t pblock, ext4_inoblk_t *blk_nump,
+				    struct list_blocks_struct *lb)
 {
 	struct buffer_head *bh;
 	__le32 *i_data;
 	int i, retval = 0;
-	int blk_count = *blk_nump;
+	ext4_inoblk_t blk_count = *blk_nump;
 	unsigned long max_entries = inode->i_sb->s_blocksize >> 2;
 
 	if (!pblock) {
@@ -191,13 +191,13 @@ static int update_dind_extent_range(handle_t *handle, struct inode *inode,
 
 }
 static int update_tind_extent_range(handle_t *handle, struct inode *inode,
-					ext4_fsblk_t pblock, int *blk_nump,
-					struct list_blocks_struct *lb)
+				     ext4_fsblk_t pblock, ext4_inoblk_t *blk_nump,
+				     struct list_blocks_struct *lb)
 {
 	struct buffer_head *bh;
 	__le32 *i_data;
 	int i, retval = 0;
-	int blk_count = *blk_nump;
+	ext4_inoblk_t blk_count = *blk_nump;
 	unsigned long max_entries = inode->i_sb->s_blocksize >> 2;
 
 	if (!pblock) {
@@ -445,7 +445,7 @@ int ext4_ext_migrate(struct inode * inode, struct file * filp,
 	handle_t *handle;
 	int retval = 0, i;
 	__le32 *i_data;
-	int blk_count = 0;
+	ext4_inoblk_t blk_count = 0;
 	struct ext4_inode_info *ei;
 	struct inode *tmp_inode = NULL;
 	struct list_blocks_struct lb;
diff --git a/include/linux/ext4_fs.h b/include/linux/ext4_fs.h
index 6a0909f..74a5def 100644
--- a/include/linux/ext4_fs.h
+++ b/include/linux/ext4_fs.h
@@ -68,11 +68,11 @@
 
 struct ext4_allocation_request {
 	struct inode *inode;	/* target inode for block we're allocating */
-	ext4_fsblk_t logical;	/* logical block in target inode */
+	ext4_inoblk_t logical;	/* logical block in target inode */
 	ext4_fsblk_t goal;	/* phys. target (a hint) */
-	ext4_fsblk_t lleft;	/* the closest logical allocated block to the left */
+	ext4_inoblk_t lleft;	/* the closest logical allocated block to the left */
 	ext4_fsblk_t pleft;	/* phys. block for ^^^ */
-	ext4_fsblk_t lright;	/* the closest logical allocated block to the right */
+	ext4_inoblk_t lright;	/* the closest logical allocated block to the right */
 	ext4_fsblk_t pright;	/* phys. block for ^^^ */
 	unsigned long len;	/* how many blocks we want to allocate */
 	unsigned long flags;	/* flags. see above EXT4_MB_HINT_* */
@@ -966,7 +966,7 @@ int ext4_forget(handle_t *handle, int is_metadata, struct inode *inode,
 struct buffer_head * ext4_getblk (handle_t *, struct inode *, long, int, int *);
 struct buffer_head * ext4_bread (handle_t *, struct inode *, int, int, int *);
 int ext4_get_blocks_handle(handle_t *handle, struct inode *inode,
-	sector_t iblock, unsigned long maxblocks, struct buffer_head *bh_result,
+	ext4_inoblk_t iblock, unsigned long maxblocks, struct buffer_head *bh_result,
 	int create, int extend_disksize);
 
 extern void ext4_read_inode (struct inode *);
@@ -1099,7 +1099,7 @@ extern const struct inode_operations ext4_fast_symlink_inode_operations;
 extern int ext4_ext_tree_init(handle_t *handle, struct inode *);
 extern int ext4_ext_writepage_trans_blocks(struct inode *, int);
 extern int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
-			ext4_fsblk_t iblock,
+			ext4_inoblk_t iblock,
 			unsigned long max_blocks, struct buffer_head *bh_result,
 			int create, int extend_disksize);
 extern void ext4_ext_truncate(struct inode *, struct page *);
@@ -1115,11 +1115,13 @@ ext4_get_blocks_wrap(handle_t *handle, struct inode *inode, sector_t block,
 	int retval;
 	mutex_lock(&EXT4_I(inode)->truncate_mutex);
 	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
-		retval = ext4_ext_get_blocks(handle, inode, block, max_blocks,
-					bh, create, extend_disksize);
+		retval = ext4_ext_get_blocks(handle, inode,
+						(ext4_inoblk_t)block, max_blocks,
+						bh, create, extend_disksize);
 	} else {
-		retval = ext4_get_blocks_handle(handle, inode, block, max_blocks,
-					bh, create, extend_disksize);
+		retval = ext4_get_blocks_handle(handle, inode,
+						(ext4_inoblk_t)block, max_blocks,
+						bh, create, extend_disksize);
 	}
 	mutex_unlock(&EXT4_I(inode)->truncate_mutex);
 
diff --git a/include/linux/ext4_fs_extents.h b/include/linux/ext4_fs_extents.h
index 149fd4b..9c9cf10 100644
--- a/include/linux/ext4_fs_extents.h
+++ b/include/linux/ext4_fs_extents.h
@@ -124,20 +124,6 @@ struct ext4_ext_path {
 #define EXT4_EXT_CACHE_GAP	1
 #define EXT4_EXT_CACHE_EXTENT	2
 
-/*
- * to be called by ext4_ext_walk_space()
- * negative retcode - error
- * positive retcode - signal for ext4_ext_walk_space(), see below
- * callback must return valid extent (passed or newly created)
- */
-typedef int (*ext_prepare_callback)(struct inode *, struct ext4_ext_path *,
-					struct ext4_ext_cache *,
-					void *);
-
-#define EXT_CONTINUE	0
-#define EXT_BREAK	1
-#define EXT_REPEAT	2
-
 
 #define EXT_MAX_BLOCK	0xffffffff
 
@@ -233,10 +219,11 @@ extern int ext4_ext_try_to_merge(struct inode *inode,
 				 struct ext4_extent *);
 extern unsigned int ext4_ext_check_overlap(struct inode *, struct ext4_extent *, struct ext4_ext_path *);
 extern int ext4_ext_insert_extent(handle_t *, struct inode *, struct ext4_ext_path *, struct ext4_extent *);
-extern int ext4_ext_walk_space(struct inode *, unsigned long, unsigned long, ext_prepare_callback, void *);
-extern struct ext4_ext_path * ext4_ext_find_extent(struct inode *, int, struct ext4_ext_path *);
-
-extern int ext4_ext_search_left(struct inode *, struct ext4_ext_path *, ext4_fsblk_t *, ext4_fsblk_t *);
-extern int ext4_ext_search_right(struct inode *, struct ext4_ext_path *, ext4_fsblk_t *, ext4_fsblk_t *);
+extern struct ext4_ext_path * ext4_ext_find_extent(struct inode *, ext4_inoblk_t,
+							struct ext4_ext_path *);
+extern int ext4_ext_search_left(struct inode *, struct ext4_ext_path *,
+					ext4_inoblk_t *, ext4_fsblk_t *);
+extern int ext4_ext_search_right(struct inode *, struct ext4_ext_path *,
+					ext4_inoblk_t *, ext4_fsblk_t *);
 #endif /* _LINUX_EXT4_EXTENTS */
 
diff --git a/include/linux/ext4_fs_i.h b/include/linux/ext4_fs_i.h
index 2317242..5f136ba 100644
--- a/include/linux/ext4_fs_i.h
+++ b/include/linux/ext4_fs_i.h
@@ -27,6 +27,9 @@ typedef int ext4_grpblk_t;
 /* data type for filesystem-wide blocks number */
 typedef unsigned long long ext4_fsblk_t;
 
+/* data type for inode block number */
+typedef __u32 ext4_inoblk_t;
+
 struct ext4_reserve_window {
 	ext4_fsblk_t	_rsv_start;	/* First byte reserved */
 	ext4_fsblk_t	_rsv_end;	/* Last byte reserved or 0 */
@@ -67,7 +70,7 @@ struct ext4_block_alloc_info {
  */
 struct ext4_ext_cache {
 	ext4_fsblk_t	ec_start;
-	__u32		ec_block;
+	ext4_inoblk_t	ec_block;
 	__u32		ec_len; /* must be 32bit to return holes */
 	__u32		ec_type;
 };
-- 
1.5.3.4.206.g58ba4-dirty
