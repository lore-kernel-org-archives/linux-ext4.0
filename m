From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,RFC 7/7] ext4: move ext4_journal_start/stop to mpage_da_map_and_submit()
Date: Sat, 12 Feb 2011 19:15:57 -0500
Message-ID: <1297556157-21559-8-git-send-email-tytso@mit.edu>
References: <1297556157-21559-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38174 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323Ab1BMA5Y (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Feb 2011 19:57:24 -0500
In-Reply-To: <1297556157-21559-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Previously, ext4_da_writepages() was responsible for calling
ext4_journal_start() and ext4_journal_stop().  If the blocks had
already been allocated (we don't support journal=data in
ext4_da_writepages), then there's no need to start a new journal
handle.

By moving ext4_journal_start/stop calls to mpage_da_map_and_submit()
we should significantly reduce the cpu usage (and cache line bouncing)
if the journal is enabled.  This should (hopefully!) be especially
noticeable on large SMP systems.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h  |    3 +-
 fs/ext4/inode.c |  125 ++++++++++++++++++++++++-------------------------------
 2 files changed, 56 insertions(+), 72 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3aa0b72..be5c9e7 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -164,7 +164,8 @@ struct mpage_da_data {
 	unsigned long b_state;		/* state of the extent */
 	unsigned long first_page, next_page;	/* extent of pages */
 	struct writeback_control *wbc;
-	int io_done;
+	int io_done:1;
+	int stop_writepages:1;
 	int pages_written;
 	int retval;
 };
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 235a90e..ad1dc38 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2225,12 +2225,13 @@ static void ext4_print_free_blocks(struct inode *inode)
  */
 static void mpage_da_map_and_submit(struct mpage_da_data *mpd)
 {
-	int err, blks, get_blocks_flags;
+	int err, blks, get_blocks_flags, needed_blocks;
 	struct ext4_map_blocks map, *mapp = NULL;
 	sector_t next = mpd->b_blocknr;
 	unsigned max_blocks = mpd->b_size >> mpd->inode->i_blkbits;
 	loff_t disksize = EXT4_I(mpd->inode)->i_disksize;
-	handle_t *handle = NULL;
+	struct inode *inode = mpd->inode;
+	handle_t *handle;
 
 	/*
 	 * If the blocks are mapped already, or we couldn't accumulate
@@ -2242,8 +2243,28 @@ static void mpage_da_map_and_submit(struct mpage_da_data *mpd)
 	     !(mpd->b_state & (1 << BH_Unwritten))))
 		goto submit_io;
 
-	handle = ext4_journal_current_handle();
-	BUG_ON(!handle);
+	/*
+	 * Calculate the number of journal credits needed.  In the
+	 * non-extent case, the journal credits needed to insert
+	 * nrblocks contiguous blocks is dependent on number of
+	 * contiguous blocks. So we will limit this value to a sane
+	 * value.
+	 */
+	needed_blocks = EXT4_I(inode)->i_reserved_data_blocks;
+	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) &&
+	    (needed_blocks > EXT4_MAX_TRANS_DATA))
+		needed_blocks = EXT4_MAX_TRANS_DATA;
+	needed_blocks = ext4_chunk_trans_blocks(inode, needed_blocks);
+
+	/* start a new transaction */
+	handle = ext4_journal_start(inode, needed_blocks);
+	if (IS_ERR(handle)) {
+		ext4_msg(inode->i_sb, KERN_CRIT, "%s: jbd2_start: "
+			 "%ld pages, ino %lu; err %ld", __func__,
+			 mpd->wbc->nr_to_write, inode->i_ino, PTR_ERR(handle));
+		mpd->stop_writepages = 1;
+		goto submit_io;
+	}
 
 	/*
 	 * Call ext4_map_blocks() to allocate any delayed allocation
@@ -2266,15 +2287,16 @@ static void mpage_da_map_and_submit(struct mpage_da_data *mpd)
 	map.m_lblk = next;
 	map.m_len = max_blocks;
 	get_blocks_flags = EXT4_GET_BLOCKS_CREATE;
-	if (ext4_should_dioread_nolock(mpd->inode))
+	if (ext4_should_dioread_nolock(inode))
 		get_blocks_flags |= EXT4_GET_BLOCKS_IO_CREATE_EXT;
 	if (mpd->b_state & (1 << BH_Delay))
 		get_blocks_flags |= EXT4_GET_BLOCKS_DELALLOC_RESERVE;
 
-	blks = ext4_map_blocks(handle, mpd->inode, &map, get_blocks_flags);
+	blks = ext4_map_blocks(handle, inode, &map, get_blocks_flags);
 	if (blks < 0) {
-		struct super_block *sb = mpd->inode->i_sb;
+		struct super_block *sb = inode->i_sb;
 
+		ext4_journal_stop(handle);
 		err = blks;
 		/*
 		 * If get block returns EAGAIN or ENOSPC and there
@@ -2301,32 +2323,32 @@ static void mpage_da_map_and_submit(struct mpage_da_data *mpd)
 			ext4_msg(sb, KERN_CRIT,
 				 "delayed block allocation failed for inode %lu "
 				 "at logical offset %llu with max blocks %zd "
-				 "with error %d", mpd->inode->i_ino,
+				 "with error %d", inode->i_ino,
 				 (unsigned long long) next,
-				 mpd->b_size >> mpd->inode->i_blkbits, err);
+				 mpd->b_size >> inode->i_blkbits, err);
 			ext4_msg(sb, KERN_CRIT,
 				"This should not happen!! Data will be lost\n");
 			if (err == -ENOSPC)
-				ext4_print_free_blocks(mpd->inode);
+				ext4_print_free_blocks(inode);
 		}
 		/* invalidate all the pages */
 		ext4_da_block_invalidatepages(mpd, next,
-				mpd->b_size >> mpd->inode->i_blkbits);
+				mpd->b_size >> inode->i_blkbits);
 		return;
 	}
 	BUG_ON(blks == 0);
 
 	mapp = &map;
 	if (map.m_flags & EXT4_MAP_NEW) {
-		struct block_device *bdev = mpd->inode->i_sb->s_bdev;
+		struct block_device *bdev = inode->i_sb->s_bdev;
 		int i;
 
 		for (i = 0; i < map.m_len; i++)
 			unmap_underlying_metadata(bdev, map.m_pblk + i);
 	}
 
-	if (ext4_should_order_data(mpd->inode)) {
-		err = ext4_jbd2_file_inode(handle, mpd->inode);
+	if (ext4_should_order_data(inode)) {
+		err = ext4_jbd2_file_inode(handle, inode);
 		if (err)
 			/* This only happens if the journal is aborted */
 			return;
@@ -2335,19 +2357,24 @@ static void mpage_da_map_and_submit(struct mpage_da_data *mpd)
 	/*
 	 * Update on-disk size along with block allocation.
 	 */
-	disksize = ((loff_t) next + blks) << mpd->inode->i_blkbits;
-	if (disksize > i_size_read(mpd->inode))
-		disksize = i_size_read(mpd->inode);
-	if (disksize > EXT4_I(mpd->inode)->i_disksize) {
-		ext4_update_i_disksize(mpd->inode, disksize);
-		err = ext4_mark_inode_dirty(handle, mpd->inode);
+	disksize = ((loff_t) next + blks) << inode->i_blkbits;
+	if (disksize > i_size_read(inode))
+		disksize = i_size_read(inode);
+	if (disksize > EXT4_I(inode)->i_disksize) {
+		ext4_update_i_disksize(inode, disksize);
+		err = ext4_mark_inode_dirty(handle, inode);
 		if (err)
-			ext4_error(mpd->inode->i_sb,
+			ext4_error(inode->i_sb,
 				   "Failed to mark inode %lu dirty",
-				   mpd->inode->i_ino);
+				   inode->i_ino);
 	}
+	ext4_journal_stop(handle);
 
 submit_io:
+	/*
+	 * This also doubles as the the way we unlock all of the pages
+	 * in case of an error.  Hacky, but it works...
+	 */
 	mpage_da_submit_io(mpd, mapp);
 	mpd->io_done = 1;
 }
@@ -2687,31 +2714,6 @@ static int ext4_writepage(struct page *page,
 }
 
 /*
- * This is called via ext4_da_writepages() to
- * calulate the total number of credits to reserve to fit
- * a single extent allocation into a single transaction,
- * ext4_da_writpeages() will loop calling this before
- * the block allocation.
- */
-
-static int ext4_da_writepages_trans_blocks(struct inode *inode)
-{
-	int max_blocks = EXT4_I(inode)->i_reserved_data_blocks;
-
-	/*
-	 * With non-extent format the journal credit needed to
-	 * insert nrblocks contiguous block is dependent on
-	 * number of contiguous block. So we will limit
-	 * number of contiguous block to a sane value
-	 */
-	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)) &&
-	    (max_blocks > EXT4_MAX_TRANS_DATA))
-		max_blocks = EXT4_MAX_TRANS_DATA;
-
-	return ext4_chunk_trans_blocks(inode, max_blocks);
-}
-
-/*
  * write_cache_pages_da - walk the list of dirty pages of the given
  * address space and accumulate pages that need writing, and call
  * mpage_da_map_and_submit to map a single contiguous memory region
@@ -2885,13 +2887,12 @@ static int ext4_da_writepages(struct address_space *mapping,
 {
 	pgoff_t	index;
 	int range_whole = 0;
-	handle_t *handle = NULL;
 	struct mpage_da_data mpd;
 	struct inode *inode = mapping->host;
 	int pages_written = 0;
 	unsigned int max_pages;
 	int range_cyclic, cycled = 1, io_done = 0;
-	int needed_blocks, ret = 0;
+	int ret = 0;
 	long desired_nr_to_write, nr_to_writebump = 0;
 	loff_t range_start = wbc->range_start;
 	struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
@@ -2899,6 +2900,7 @@ static int ext4_da_writepages(struct address_space *mapping,
 	pgoff_t end;
 
 	trace_ext4_da_writepages(inode, wbc);
+	BUG_ON(ext4_should_journal_data(inode));
 
 	/*
 	 * No pages to write? This is mainly a kludge to avoid starting
@@ -2976,28 +2978,8 @@ retry:
 		tag_pages_for_writeback(mapping, index, end);
 
 	while (!ret && wbc->nr_to_write > 0) {
-
 		/*
-		 * we  insert one extent at a time. So we need
-		 * credit needed for single extent allocation.
-		 * journalled mode is currently not supported
-		 * by delalloc
-		 */
-		BUG_ON(ext4_should_journal_data(inode));
-		needed_blocks = ext4_da_writepages_trans_blocks(inode);
-
-		/* start a new transaction*/
-		handle = ext4_journal_start(inode, needed_blocks);
-		if (IS_ERR(handle)) {
-			ret = PTR_ERR(handle);
-			ext4_msg(inode->i_sb, KERN_CRIT, "%s: jbd2_start: "
-			       "%ld pages, ino %lu; err %d", __func__,
-				wbc->nr_to_write, inode->i_ino, ret);
-			goto out_writepages;
-		}
