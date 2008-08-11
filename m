From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: invalidate pages if delalloc block allocation fails.
Date: Mon, 11 Aug 2008 15:31:50 +0530
Message-ID: <1218448910-9008-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1218448910-9008-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1218448910-9008-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:43868 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbYHKKCF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Aug 2008 06:02:05 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m7BA1Mog026754
	for <linux-ext4@vger.kernel.org>; Mon, 11 Aug 2008 20:01:22 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7BA23ng289048
	for <linux-ext4@vger.kernel.org>; Mon, 11 Aug 2008 20:02:03 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7BA225N015670
	for <linux-ext4@vger.kernel.org>; Mon, 11 Aug 2008 20:02:03 +1000
In-Reply-To: <1218448910-9008-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We are a bit agressive in invalidating all the pages. But
it is ok because we really don't know why the block allocation
failed and it is better to come of the writeback path
so that user can look for more info.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |   88 +++++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 67 insertions(+), 21 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ea1a8db..e437a5b 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1612,7 +1612,7 @@ static void ext4_da_page_release_reservation(struct page *page,
 
 /*
  * mpage_da_submit_io - walks through extent of pages and try to write
- * them with __mpage_writepage()
+ * them with writepage() call back
  *
  * @mpd->inode: inode
  * @mpd->first_page: first page of the extent
@@ -1632,7 +1632,6 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd)
 	struct pagevec pvec;
 
 	BUG_ON(mpd->next_page <= mpd->first_page);
-
 	pagevec_init(&pvec, 0);
 	index = mpd->first_page;
 	end = mpd->next_page - 1;
@@ -1653,7 +1652,6 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd)
 			err = mapping->a_ops->writepage(page, mpd->wbc);
 			if (!err)
 				mpd->pages_written++;
-
 			/*
 			 * In error case, we have to continue because
 			 * remaining pages are still locked
@@ -1664,7 +1662,6 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd)
 		}
 		pagevec_release(&pvec);
 	}
-
 	return ret;
 }
 
@@ -1687,7 +1684,7 @@ static void mpage_put_bnr_to_bhs(struct mpage_da_data *mpd, sector_t logical,
 	int blocks = exbh->b_size >> inode->i_blkbits;
 	sector_t pblock = exbh->b_blocknr, cur_logical;
 	struct buffer_head *head, *bh;
-	unsigned long index, end;
+	pgoff_t index, end;
 	struct pagevec pvec;
 	int nr_pages, i;
 
@@ -1764,6 +1761,39 @@ static inline void __unmap_underlying_blocks(struct inode *inode,
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
@@ -1772,8 +1802,6 @@ static inline void __unmap_underlying_blocks(struct inode *inode,
  *
  * The function skips space we know is already mapped to disk blocks.
  *
- * The function ignores errors ->get_block() returns, thus real
- * error handling is postponed to __mpage_writepage()
  */
 static void mpage_da_map_blocks(struct mpage_da_data *mpd)
 {
@@ -1799,8 +1827,36 @@ static void mpage_da_map_blocks(struct mpage_da_data *mpd)
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
+		printk(KERN_EMERG "This should not happen.!! "
+					"Data will be lost\n");
+		/* invlaidate all the pages */
+		ext4_da_block_invalidatepages(mpd, next,
+				lbh->b_size >> mpd->inode->i_blkbits);
 		return;
+	}
 	BUG_ON(new.b_size == 0);
 
 	if (buffer_new(&new))
@@ -1898,7 +1954,7 @@ static int __mpage_da_writepage(struct page *page,
 	if (mpd->next_page != page->index) {
 		/*
 		 * Nope, we can't. So, we map non-allocated blocks
-		 * and start IO on them using __mpage_writepage()
+		 * and start IO on them using writepage()
 		 */
 		if (mpd->next_page != mpd->first_page) {
 			mpage_da_map_blocks(mpd);
@@ -1974,16 +2030,6 @@ static int __mpage_da_writepage(struct page *page,
  *
  * This is a library function, which implements the writepages()
  * address_space_operation.
- *
- * In order to avoid duplication of logic that deals with partial pages,
- * multiple bio per page, etc, we find non-allocated blocks, allocate
- * them with minimal calls to ->get_block() and re-use __mpage_writepage()
- *
- * It's important that we call __mpage_writepage() only once for each
- * involved page, otherwise we'd have to implement more complicated logic
- * to deal with pages w/o PG_lock or w/ PG_writeback and so on.
- *
- * See comments to mpage_writepages()
  */
 static int mpage_da_writepages(struct address_space *mapping,
 			       struct writeback_control *wbc,
@@ -2268,8 +2314,8 @@ static int ext4_da_writepages(struct address_space *mapping,
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

