From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 05/42] ext4: invalidate pages if delalloc block allocation fails.
Date: Thu,  9 Oct 2008 00:05:23 -0400
Message-ID: <1223525160-9887-6-git-send-email-tytso@mit.edu>
References: <1223525160-9887-1-git-send-email-tytso@mit.edu>
 <1223525160-9887-2-git-send-email-tytso@mit.edu>
 <1223525160-9887-3-git-send-email-tytso@mit.edu>
 <1223525160-9887-4-git-send-email-tytso@mit.edu>
 <1223525160-9887-5-git-send-email-tytso@mit.edu>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:54452 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751000AbYJIEGF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Oct 2008 00:06:05 -0400
In-Reply-To: <1223525160-9887-5-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

We are a bit agressive in invalidating all the pages. But
it is ok because we really don't know why the block allocation
failed and it is better to come of the writeback path
so that user can look for more info.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |   85 +++++++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 73 insertions(+), 12 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 89c92c0..b6fa0c4 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1783,6 +1783,39 @@ static inline void __unmap_underlying_blocks(struct inode *inode,
 		unmap_underlying_metadata(bdev, bh->b_blocknr + i);
 }
 
+static void ext4_da_block_invalidatepages(struct mpage_da_data *mpd,
+					sector_t logical, long blk_cnt)
+{
+	int nr_pages, i;
+	pgoff_t index, end;
+	struct pagevec pvec;
+	struct inode *inode = mpd->inode;
+	struct address_space *mapping = inode->i_mapping;
+
+	index = logical >> (PAGE_CACHE_SHIFT - inode->i_blkbits);
+	end   = (logical + blk_cnt - 1) >>
+				(PAGE_CACHE_SHIFT - inode->i_blkbits);
+	while (index <= end) {
+		nr_pages = pagevec_lookup(&pvec, mapping, index, PAGEVEC_SIZE);
+		if (nr_pages == 0)
+			break;
+		for (i = 0; i < nr_pages; i++) {
+			struct page *page = pvec.pages[i];
+			index = page->index;
+			if (index > end)
+				break;
+			index++;
+
+			BUG_ON(!PageLocked(page));
+			BUG_ON(PageWriteback(page));
+			block_invalidatepage(page, 0);
+			ClearPageUptodate(page);
+			unlock_page(page);
+		}
+	}
+	return;
+}
+
 /*
  * mpage_da_map_blocks - go through given space
  *
@@ -1792,7 +1825,7 @@ static inline void __unmap_underlying_blocks(struct inode *inode,
  * The function skips space we know is already mapped to disk blocks.
  *
  */
-static void mpage_da_map_blocks(struct mpage_da_data *mpd)
+static int  mpage_da_map_blocks(struct mpage_da_data *mpd)
 {
 	int err = 0;
 	struct buffer_head *lbh = &mpd->lbh;
@@ -1803,7 +1836,7 @@ static void mpage_da_map_blocks(struct mpage_da_data *mpd)
 	 * We consider only non-mapped and non-allocated blocks
 	 */
 	if (buffer_mapped(lbh) && !buffer_delay(lbh))
-		return;
+		return 0;
 
 	new.b_state = lbh->b_state;
 	new.b_blocknr = 0;
@@ -1814,10 +1847,38 @@ static void mpage_da_map_blocks(struct mpage_da_data *mpd)
 	 * to write simply return
 	 */
 	if (!new.b_size)
-		return;
+		return 0;
 	err = mpd->get_block(mpd->inode, next, &new, 1);
-	if (err)
-		return;
+	if (err) {
+
+		/* If get block returns with error
+		 * we simply return. Later writepage
+		 * will redirty the page and writepages
+		 * will find the dirty page again
+		 */
+		if (err == -EAGAIN)
+			return 0;
+		/*
+		 * get block failure will cause us
+		 * to loop in writepages. Because
+		 * a_ops->writepage won't be able to
+		 * make progress. The page will be redirtied
+		 * by writepage and writepages will again
+		 * try to write the same.
+		 */
+		printk(KERN_EMERG "%s block allocation failed for inode %lu "
+				  "at logical offset %llu with max blocks "
+				  "%zd with error %d\n",
+				  __func__, mpd->inode->i_ino,
+				  (unsigned long long)next,
+				  lbh->b_size >> mpd->inode->i_blkbits, err);
+		printk(KERN_EMERG "This should not happen.!! "
+					"Data will be lost\n");
+		/* invlaidate all the pages */
+		ext4_da_block_invalidatepages(mpd, next,
+				lbh->b_size >> mpd->inode->i_blkbits);
+		return err;
+	}
 	BUG_ON(new.b_size == 0);
 
 	if (buffer_new(&new))
@@ -1830,7 +1891,7 @@ static void mpage_da_map_blocks(struct mpage_da_data *mpd)
 	if (buffer_delay(lbh) || buffer_unwritten(lbh))
 		mpage_put_bnr_to_bhs(mpd, next, &new);
 
-	return;
+	return 0;
 }
 
 #define BH_FLAGS ((1 << BH_Uptodate) | (1 << BH_Mapped) | \
@@ -1899,8 +1960,8 @@ flush_it:
 	 * We couldn't merge the block to our extent, so we
 	 * need to flush current  extent and start new one
 	 */
-	mpage_da_map_blocks(mpd);
-	mpage_da_submit_io(mpd);
+	if (mpage_da_map_blocks(mpd) == 0)
+		mpage_da_submit_io(mpd);
 	mpd->io_done = 1;
 	return;
 }
@@ -1942,8 +2003,8 @@ static int __mpage_da_writepage(struct page *page,
 		 * and start IO on them using writepage()
 		 */
 		if (mpd->next_page != mpd->first_page) {
-			mpage_da_map_blocks(mpd);
-			mpage_da_submit_io(mpd);
+			if (mpage_da_map_blocks(mpd) == 0)
+				mpage_da_submit_io(mpd);
 			/*
 			 * skip rest of the page in the page_vec
 			 */
@@ -2046,8 +2107,8 @@ static int mpage_da_writepages(struct address_space *mapping,
 	 * Handle last extent of pages
 	 */
 	if (!mpd.io_done && mpd.next_page != mpd.first_page) {
-		mpage_da_map_blocks(&mpd);
-		mpage_da_submit_io(&mpd);
+		if (mpage_da_map_blocks(&mpd) == 0)
+			mpage_da_submit_io(&mpd);
 	}
 
 	wbc->nr_to_write = to_write - mpd.pages_written;
-- 
1.5.6.1.205.ge2c7.dirty

