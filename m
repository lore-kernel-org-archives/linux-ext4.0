From: Mingming Cao <cmm@us.ibm.com>
Subject: [RFC]Ext4: journal credits reservation fixes for DIO, fallocate
	and delalloc writepages
Date: Tue, 22 Jul 2008 17:51:51 -0700
Message-ID: <1216774311.6505.4.camel@mingming-laptop>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Shehjar Tikoo <shehjart@cse.unsw.edu.au>,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	tytso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:45366 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223AbYGWAvx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 22 Jul 2008 20:51:53 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6N0pqDX015965
	for <linux-ext4@vger.kernel.org>; Tue, 22 Jul 2008 20:51:52 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6N0pqIH238720
	for <linux-ext4@vger.kernel.org>; Tue, 22 Jul 2008 20:51:52 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6N0pqft015105
	for <linux-ext4@vger.kernel.org>; Tue, 22 Jul 2008 20:51:52 -0400
In-Reply-To: <20080721082010.GC8788@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ext4: journal credits reservation fixes for DIO, fallocate and delalloc writepages

From: Mingming Cao <cmm@us.ibm.com>

With delalloc, at writepages() time, we need to reserve enough credits to start
a new handle, to allow possible multiple segment of block allocations under a
single call mapge_da_writepages(), so that metadata updates could fit into a single
transaction. This patch fixed this by calculating the needed credits for
write-out given number of dirty pages, with the consideration of discontinues
block allocations. It fixed both extent files and non extent files.

This patch also fixed the journal credit reservation for DIO. Currently the
estimated credits for DIO is only based on non extent format file. That credit
is not enough for mballoc a single extent on extent based file. This patch
fixed that.

The fallocate double booking credits for modifying super block etc, this patch
fixed that.

This also fix credit reservation in migration and defrag code.

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/defrag.c  |    4 +-
 fs/ext4/ext4.h    |    4 +-
 fs/ext4/extents.c |   37 ++++++++++++---------
 fs/ext4/inode.c   |   93 ++++++++++++++++++++++++------------------------------
 fs/ext4/migrate.c |    4 +-
 5 files changed, 72 insertions(+), 70 deletions(-)

Index: linux-2.6.26-git6/fs/ext4/ext4.h
===================================================================
--- linux-2.6.26-git6.orig/fs/ext4/ext4.h	2008-07-21 17:35:17.000000000 -0700
+++ linux-2.6.26-git6/fs/ext4/ext4.h	2008-07-21 17:36:17.000000000 -0700
@@ -1149,7 +1149,7 @@ extern void ext4_truncate (struct inode 
 extern void ext4_set_inode_flags(struct inode *);
 extern void ext4_get_inode_flags(struct ext4_inode_info *);
 extern void ext4_set_aops(struct inode *inode);
-extern int ext4_writepage_trans_blocks(struct inode *);
+extern int ext4_writepages_trans_blocks(struct inode *, int num);
 extern int ext4_block_truncate_page(handle_t *handle,
 		struct address_space *mapping, loff_t from);
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page);
@@ -1314,7 +1314,7 @@ extern const struct inode_operations ext
 
 /* extents.c */
 extern int ext4_ext_tree_init(handle_t *handle, struct inode *);
-extern int ext4_ext_writepage_trans_blocks(struct inode *, int);
+extern int ext4_ext_writepages_trans_blocks(struct inode *inode, int);
 extern int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 			ext4_lblk_t iblock,
 			unsigned long max_blocks, struct buffer_head *bh_result,
Index: linux-2.6.26-git6/fs/ext4/extents.c
===================================================================
--- linux-2.6.26-git6.orig/fs/ext4/extents.c	2008-07-21 17:35:17.000000000 -0700
+++ linux-2.6.26-git6/fs/ext4/extents.c	2008-07-21 17:36:17.000000000 -0700
@@ -1887,11 +1887,12 @@ static int ext4_ext_rm_idx(handle_t *han
 
 /*
  * ext4_ext_calc_credits_for_insert:
- * This routine returns max. credits that the extent tree can consume.
+ * This routine returns max. credits that needed to insert an extent
+ * to the extent tree.
  * It should be OK for low-performance paths like ->writepage()
  * To allow many writing processes to fit into a single transaction,
- * the caller should calculate credits under i_data_sem and
- * pass the actual path.
+ * When pass the actual path, the caller should calculate credits
+ * under i_data_sem.
  */
 int ext4_ext_calc_credits_for_insert(struct inode *inode,
 						struct ext4_ext_path *path)
@@ -1930,9 +1931,6 @@ int ext4_ext_calc_credits_for_insert(str
 	 */
 	needed += (depth * 2) + (depth * 2);
 
-	/* any allocation modifies superblock */
-	needed += 1;
-
 	return needed;
 }
 
@@ -2940,8 +2938,8 @@ void ext4_ext_truncate(struct inode *ino
 	/*
 	 * probably first extent we're gonna free will be last in block
 	 */
-	err = ext4_writepage_trans_blocks(inode) + 3;
-	handle = ext4_journal_start(inode, err);
+	handle = ext4_journal_start(inode,
+				    ext4_writepages_trans_blocks(inode, 1) + 3);
 	if (IS_ERR(handle))
 		return;
 
@@ -2994,18 +2992,28 @@ out_stop:
 }
 
 /*
- * ext4_ext_writepage_trans_blocks:
+ * ext4_ext_writepages_trans_blocks:
  * calculate max number of blocks we could modify
  * in order to allocate new block for an inode
  */
-int ext4_ext_writepage_trans_blocks(struct inode *inode, int num)
+int ext4_ext_writepages_trans_blocks(struct inode *inode, int num)
 {
 	int needed;
 
+	/* cost of adding a single extent:
+	 * index blocks, leafs, bitmaps,
+	 * groupdescp
+	 */
 	needed = ext4_ext_calc_credits_for_insert(inode, NULL);
 
-	/* caller wants to allocate num blocks, but note it includes sb */
-	needed = needed * num - (num - 1);
+	/*
+	 * For data=journalled mode need to account for the data blocks
+	 * Also need to add super block and inode block
+	 */
+	if (ext4_should_journal_data(inode))
+		needed = num * (needed + 1)  + 2;
+	else
+		needed = num * needed  + 2;
 
 #ifdef CONFIG_QUOTA
 	needed += 2 * EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb);
@@ -3074,10 +3082,9 @@ long ext4_fallocate(struct inode *inode,
 	max_blocks = (EXT4_BLOCK_ALIGN(len + offset, blkbits) >> blkbits)
 							- block;
 	/*
-	 * credits to insert 1 extent into extent tree + buffers to be able to
-	 * modify 1 super block, 1 block bitmap and 1 group descriptor.
+	 * credits to insert 1 extent into extent tree
 	 */
-	credits = EXT4_DATA_TRANS_BLOCKS(inode->i_sb) + 3;
+	credits =  EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
 	mutex_lock(&inode->i_mutex);
 retry:
 	while (ret >= 0 && ret < max_blocks) {
Index: linux-2.6.26-git6/fs/ext4/inode.c
===================================================================
--- linux-2.6.26-git6.orig/fs/ext4/inode.c	2008-07-21 17:35:17.000000000 -0700
+++ linux-2.6.26-git6/fs/ext4/inode.c	2008-07-21 17:44:45.000000000 -0700
@@ -1015,15 +1015,6 @@ static void ext4_da_update_reserve_space
 
 /* Maximum number of blocks we map for direct IO at once. */
 #define DIO_MAX_BLOCKS 4096
-/*
- * Number of credits we need for writing DIO_MAX_BLOCKS:
- * We need sb + group descriptor + bitmap + inode -> 4
- * For B blocks with A block pointers per block we need:
- * 1 (triple ind.) + (B/A/A + 2) (doubly ind.) + (B/A + 2) (indirect).
- * If we plug in 4096 for B and 256 for A (for 1KB block size), we get 25.
- */
-#define DIO_CREDITS 25
-
 
 /*
  *
@@ -1142,13 +1133,13 @@ int ext4_get_block(struct inode *inode, 
 	handle_t *handle = ext4_journal_current_handle();
 	int ret = 0, started = 0;
 	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
+	int dio_credits = EXT4_DATA_TRANS_BLOCKS(inode->i_sb);
 
 	if (create && !handle) {
 		/* Direct IO write... */
 		if (max_blocks > DIO_MAX_BLOCKS)
 			max_blocks = DIO_MAX_BLOCKS;
-		handle = ext4_journal_start(inode, DIO_CREDITS +
-			      2 * EXT4_QUOTA_TRANS_BLOCKS(inode->i_sb));
+		handle = ext4_journal_start(inode, dio_credits);
 		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
 			goto out;
@@ -1327,7 +1318,7 @@ static int ext4_write_begin(struct file 
 				struct page **pagep, void **fsdata)
 {
  	struct inode *inode = mapping->host;
-	int ret, needed_blocks = ext4_writepage_trans_blocks(inode);
+	int ret, needed_blocks = ext4_writepages_trans_blocks(inode, 1);
 	handle_t *handle;
 	int retries = 0;
  	struct page *page;
@@ -2179,18 +2170,7 @@ static int ext4_da_writepage(struct page
 	return ret;
 }
 
-/*
- * For now just follow the DIO way to estimate the max credits
- * needed to write out EXT4_MAX_WRITEBACK_PAGES.
- * todo: need to calculate the max credits need for
- * extent based files, currently the DIO credits is based on
- * indirect-blocks mapping way.
- *
- * Probably should have a generic way to calculate credits
- * for DIO, writepages, and truncate
- */
 #define EXT4_MAX_WRITEBACK_PAGES      DIO_MAX_BLOCKS
-#define EXT4_MAX_WRITEBACK_CREDITS    DIO_CREDITS
 
 static int ext4_da_writepages(struct address_space *mapping,
 				struct writeback_control *wbc)
@@ -2210,13 +2190,8 @@ static int ext4_da_writepages(struct add
 	if (!mapping->nrpages)
 		return 0;
 
-	/*
-	 * Estimate the worse case needed credits to write out
-	 * EXT4_MAX_BUF_BLOCKS pages
-	 */
-	needed_blocks = EXT4_MAX_WRITEBACK_CREDITS;
-
 	to_write = wbc->nr_to_write;
+
 	if (!wbc->range_cyclic) {
 		/*
 		 * If range_cyclic is not set force range_cont
@@ -2227,6 +2202,20 @@ static int ext4_da_writepages(struct add
 	}
 
 	while (!ret && to_write) {
+		/*
+		 * set the max dirty pages could be write at a time
+		 * to fit into the reserved transaction credits
+		 */
+		if (wbc->nr_to_write > EXT4_MAX_WRITEBACK_PAGES)
+			wbc->nr_to_write = EXT4_MAX_WRITEBACK_PAGES;
+
+		/*
+		 * Estimate the worse case needed credits to write out
+		 * to_write pages
+		 */
+		needed_blocks = ext4_writepages_trans_blocks(inode,
+							     wbc->nr_to_write);
+
 		/* start a new transaction*/
 		handle = ext4_journal_start(inode, needed_blocks);
 		if (IS_ERR(handle)) {
@@ -2246,12 +2235,6 @@ static int ext4_da_writepages(struct add
 			}
 
 		}
-		/*
-		 * set the max dirty pages could be write at a time
-		 * to fit into the reserved transaction credits
-		 */
-		if (wbc->nr_to_write > EXT4_MAX_WRITEBACK_PAGES)
-			wbc->nr_to_write = EXT4_MAX_WRITEBACK_PAGES;
 
 		to_write -= wbc->nr_to_write;
 		ret = mpage_da_writepages(mapping, wbc,
@@ -2612,7 +2595,8 @@ static int __ext4_journalled_writepage(s
 	 * references to buffers so we are safe */
 	unlock_page(page);
 
-	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode));
+	handle = ext4_journal_start(inode,
+				    ext4_writepages_trans_blocks(inode, 1));
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
 		goto out;
@@ -4286,20 +4270,20 @@ int ext4_getattr(struct vfsmount *mnt, s
 /*
  * How many blocks doth make a writepage()?
  *
- * With N blocks per page, it may be:
- * N data blocks
+ * With N blocks per page,  and P pages, it may be:
+ * N*P data blocks
  * 2 indirect block
  * 2 dindirect
  * 1 tindirect
- * N+5 bitmap blocks (from the above)
- * N+5 group descriptor summary blocks
+ * N*P+5 bitmap blocks (from the above)
+ * N*P+5 group descriptor summary blocks
  * 1 inode block
  * 1 superblock.
  * 2 * EXT4_SINGLEDATA_TRANS_BLOCKS for the quote files
  *
- * 3 * (N + 5) + 2 + 2 * EXT4_SINGLEDATA_TRANS_BLOCKS
+ * 3 * (N*P + 5) + 2 + 2 * EXT4_SINGLEDATA_TRANS_BLOCKS
  *
- * With ordered or writeback data it's the same, less the N data blocks.
+ * With ordered or writeback data it's the same, less the N*P data blocks.
  *
  * If the inode's direct blocks can hold an integral number of pages then a
  * page cannot straddle two indirect blocks, and we can only touch one indirect
@@ -4310,19 +4294,15 @@ int ext4_getattr(struct vfsmount *mnt, s
  * block and work out the exact number of indirects which are touched.  Pah.
  */
 
-int ext4_writepage_trans_blocks(struct inode *inode)
+static int ext4_writepages_trans_blocks_old(struct inode *inode, int num)
 {
-	int bpp = ext4_journal_blocks_per_page(inode);
-	int indirects = (EXT4_NDIR_BLOCKS % bpp) ? 5 : 3;
+	int indirects = (EXT4_NDIR_BLOCKS % num) ? 5 : 3;
 	int ret;
 
-	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)
-		return ext4_ext_writepage_trans_blocks(inode, bpp);
-
 	if (ext4_should_journal_data(inode))
-		ret = 3 * (bpp + indirects) + 2;
+		ret = 3 * (num + indirects) + 2;
 	else
-		ret = 2 * (bpp + indirects) + 2;
+		ret = 2 * (num + indirects) + 2;
 
 #ifdef CONFIG_QUOTA
 	/* We know that structure was already allocated during DQUOT_INIT so
@@ -4334,6 +4314,19 @@ int ext4_writepage_trans_blocks(struct i
 }
 
 /*
+ * Calulate the total number of credits to reserve to fit
+ * the modification of @num pages into a single transaction
+ */
+int ext4_writepages_trans_blocks(struct inode *inode, int num)
+{
+	int bpp = ext4_journal_blocks_per_page(inode);
+	int nrblocks = num * bpp;
+
+	if (!EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)
+		return ext4_writepages_trans_blocks_old(inode, nrblocks);
+	return ext4_ext_writepages_trans_blocks(inode, nrblocks);
+}
+/*
  * The caller must have previously called ext4_reserve_inode_write().
  * Give this, we know that the caller already has write access to iloc->bh.
  */
Index: linux-2.6.26-git6/fs/ext4/defrag.c
===================================================================
--- linux-2.6.26-git6.orig/fs/ext4/defrag.c	2008-07-21 17:43:27.000000000 -0700
+++ linux-2.6.26-git6/fs/ext4/defrag.c	2008-07-22 17:44:08.000000000 -0700
@@ -1385,7 +1385,7 @@ ext4_defrag_alloc_blocks(handle_t *handl
 	struct buffer_head *bh = NULL;
 	int err, i, credits = 0;
 
-	credits = ext4_ext_calc_credits_for_insert(dest_inode, dest_path);
+	credits = ext4_ext_calc_credits_for_insert(dest_inode, dest_path) + 4;
 	err = ext4_ext_journal_restart(handle,
 				credits + EXT4_TRANS_META_BLOCKS);
 	if (err)
@@ -1494,7 +1494,7 @@ ext4_defrag_partial(struct inode *tmp_in
 	 * It needs twice the amount of ordinary journal buffers because
 	 * inode and tmp_inode may change each different metadata blocks.
 	 */
-	jblocks = ext4_writepage_trans_blocks(org_inode) * 2;
+	jblocks = ext4_writepages_trans_blocks(org_inode, 1) * 2;
 	handle = ext4_journal_start(org_inode, jblocks);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
Index: linux-2.6.26-git6/fs/ext4/migrate.c
===================================================================
--- linux-2.6.26-git6.orig/fs/ext4/migrate.c	2008-07-22 17:41:59.000000000 -0700
+++ linux-2.6.26-git6/fs/ext4/migrate.c	2008-07-22 17:43:43.000000000 -0700
@@ -52,8 +52,10 @@ static int finish_range(handle_t *handle
 	 * Since we are doing this in loop we may accumalate extra
 	 * credit. But below we try to not accumalate too much
 	 * of them by restarting the journal.
+	 *
+	 * extra 4 credits for: 1 superblock, 1 inode block, 2 quotas
 	 */
-	needed = ext4_ext_calc_credits_for_insert(inode, path);
+	needed = ext4_ext_calc_credits_for_insert(inode, path) + 4;
 
 	/*
 	 * Make sure the credit we accumalated is not really high


