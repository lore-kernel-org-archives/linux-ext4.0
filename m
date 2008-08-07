From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH] ext4: invalidate pages if delalloc block allocation fails.
Date: Thu,  7 Aug 2008 23:07:39 +0530
Message-ID: <1218130659-7829-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:37744 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911AbYHGRhv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Aug 2008 13:37:51 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m77Hajfw006743
	for <linux-ext4@vger.kernel.org>; Fri, 8 Aug 2008 03:36:46 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m77HbnQM251238
	for <linux-ext4@vger.kernel.org>; Fri, 8 Aug 2008 03:37:49 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m77Hbmhb013237
	for <linux-ext4@vger.kernel.org>; Fri, 8 Aug 2008 03:37:49 +1000
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch is for review only. I will redo this and the last
da_writepages patch splitting it into three patches later as below.

a) handle unwritten extent
b) redo da_writepages
c) handle block allocation failure.

We are a bit agressive in invalidating all the pages. But
it is ok because we really don't know why the block allocation
failed and it is better to come of the writeback path
so that user can look for more info.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |   80 ++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 73 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 368ec6b..14dc9b0 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1629,7 +1629,12 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd)
 	int ret = 0, err, nr_pages, i;
 	unsigned long index, end;
 	struct pagevec pvec;
-
+	struct mpage_data mpd_pp = {
+		.bio = NULL,
+		.last_block_in_bio = 0,
+		.get_block = mpd->get_block,
+		.use_writepage = 1,
+	};
 	BUG_ON(mpd->next_page <= mpd->first_page);
 
 	pagevec_init(&pvec, 0);
@@ -1649,10 +1654,9 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd)
 				break;
 			index++;
 
-			err = mapping->a_ops->writepage(page, mpd->wbc);
+			err = __mpage_writepage(page, mpd->wbc, &mpd_pp);
 			if (!err)
 				mpd->pages_written++;
-
 			/*
 			 * In error case, we have to continue because
 			 * remaining pages are still locked
@@ -1663,6 +1667,8 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd)
 		}
 		pagevec_release(&pvec);
 	}
+	if (mpd_pp.bio)
+		mpage_bio_submit(WRITE, mpd_pp.bio);
 
 	return ret;
 }
@@ -1686,7 +1692,7 @@ static void mpage_put_bnr_to_bhs(struct mpage_da_data *mpd, sector_t logical,
 	int blocks = exbh->b_size >> inode->i_blkbits;
 	sector_t pblock = exbh->b_blocknr, cur_logical;
 	struct buffer_head *head, *bh;
-	unsigned long index, end;
+	pgoff_t index, end;
 	struct pagevec pvec;
 	int nr_pages, i;
 
@@ -1763,6 +1769,39 @@ static inline void __unmap_underlying_blocks(struct inode *inode,
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
@@ -1798,8 +1837,35 @@ static void mpage_da_map_blocks(struct mpage_da_data *mpd)
 	if (!new.b_size)
 		return;
 	err = mpd->get_block(mpd->inode, next, &new, 1);
-	if (err)
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
+
+		/* invlaidate all the pages */
+		ext4_da_block_invalidatepages(mpd, next,
+				lbh->b_size >> mpd->inode->i_blkbits);
 		return;
+	}
 	BUG_ON(new.b_size == 0);
 
 	if (buffer_new(&new))
@@ -2267,8 +2333,8 @@ static int ext4_da_writepages(struct address_space *mapping,
 		handle = ext4_journal_start(inode, needed_blocks);
 		if (IS_ERR(handle)) {
 			ret = PTR_ERR(handle);
-			printk(KERN_EMERG "ext4_da_writepages: jbd2_start: "
-			       "%ld pages, ino %lu; err %d\n",
+			printk(KERN_EMERG "%s: jbd2_start: "
+			       "%ld pages, ino %lu; err %d\n", __func__,
 			       wbc->nr_to_write, inode->i_ino, ret);
 			dump_stack();
 			goto out_writepages;
-- 
1.6.0.rc0.42.g186458.dirty

