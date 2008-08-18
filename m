From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ENOSPC error returned too late
Date: Mon, 18 Aug 2008 15:00:26 +0530
Message-ID: <20080818093026.GA7808@skywalker>
References: <E1KUhkt-0003yw-Sf@closure.thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:34379 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751780AbYHRJac (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 18 Aug 2008 05:30:32 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp04.in.ibm.com (8.13.1/8.13.1) with ESMTP id m7I9UTuX025173
	for <linux-ext4@vger.kernel.org>; Mon, 18 Aug 2008 15:00:29 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7I9UTN01691890
	for <linux-ext4@vger.kernel.org>; Mon, 18 Aug 2008 15:00:29 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m7I9US2C031427
	for <linux-ext4@vger.kernel.org>; Mon, 18 Aug 2008 15:00:29 +0530
Content-Disposition: inline
In-Reply-To: <E1KUhkt-0003yw-Sf@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Aug 17, 2008 at 08:53:11AM -0400, Theodore Ts'o wrote:
> 
> While trying to track down kernel BZ #11341 (which is really an
> e2fsprogs bug, not a 2.6.26 regression) I created a fresh ext4
> filesystem which was 5GB in length, and then filled it to ENOSPC via:
> 
> dd if=/dev/zero of=/mnt/bigfile bs=1024 count=10485760
> 
> Unfortunately, it sent the ENOSPC few blocks too late, so the following
> appeared in dmesg, and an attempt to umount the filesystem hung in D
> wait.  :-(
> 
> 						- Ted
> 
> 
> [63518.930337] mpage_da_map_blocks block allocation failed for inode 12 at logical offset 1254547 with max blocks 2 with error -28
> [63518.930337] This should not happen.!! Data will be lost

I will look into this. Are we really out of free space or is it that
mballoc is not able to find free space ?. I am not able to reproduce
this here. Will try more.



> [63518.930337] ------------[ cut here ]------------
> [63518.930337] kernel BUG at fs/buffer.c:1858!

This should be fixed by not doing a submit_io when we failed get_block.
The below is an updated ext4_invalidate_pages_when_delalloc_alloc_fail.patch
I also tried another patch (with random failures injected )which did
remove_mapping(mapping, page) after block_invalidate. But I still find
some pages in the radix tree even though we called remove_mapping. End I
found the below patch simple. The shrink_page_list will find the page clean
and should remove the page from the radix tree if everything is correct.

ext4: invalidate pages if delalloc block allocation fails.

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
index fd14d6b..c5e892c 100644
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
+			return;
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
@@ -1880,8 +1941,8 @@ static void mpage_add_bh_to_extent(struct mpage_da_data *mpd,
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
@@ -1923,8 +1984,8 @@ static int __mpage_da_writepage(struct page *page,
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
@@ -2027,8 +2088,8 @@ static int mpage_da_writepages(struct address_space *mapping,
 	 * Handle last extent of pages
 	 */
 	if (!mpd.io_done && mpd.next_page != mpd.first_page) {
-		mpage_da_map_blocks(&mpd);
-		mpage_da_submit_io(&mpd);
+		if (mpage_da_map_blocks(&mpd) == 0)
+			mpage_da_submit_io(&mpd);
 	}
 
 	wbc->nr_to_write = to_write - mpd.pages_written;
