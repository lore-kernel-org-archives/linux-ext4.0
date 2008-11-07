From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 1/2] ext4: Fix the delalloc writepages to allocate blocks at the right offset.
Date: Fri,  7 Nov 2008 15:12:27 +0530
Message-ID: <1226050948-32221-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	vallesroc@gmail.com, Solofo.Ramangalahy@bull.net,
	cryptooctoploid@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:56464 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbYKGJn4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Nov 2008 04:43:56 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id mA79ghrf000789
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 20:42:43 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA79gft92805954
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 20:42:41 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mA79gZUD028042
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 20:42:36 +1100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When iterating through the pages with all mapped buffer_heads
we failed to update the b_state value. This result in allocating
blocks at logical offset 0.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |   56 ++++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 39 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d42f748..95d0d12 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1644,35 +1644,39 @@ static void ext4_da_page_release_reservation(struct page *page,
  */
 static int mpage_da_submit_io(struct mpage_da_data *mpd)
 {
-	struct address_space *mapping = mpd->inode->i_mapping;
-	int ret = 0, err, nr_pages, i;
-	unsigned long index, end;
-	struct pagevec pvec;
 	long pages_skipped;
+	struct pagevec pvec;
+	unsigned long index, end;
+	int ret = 0, err, nr_pages, i;
+	struct inode *inode = mpd->inode;
+	struct address_space *mapping = inode->i_mapping;
 
 	BUG_ON(mpd->next_page <= mpd->first_page);
-	pagevec_init(&pvec, 0);
+	/*
+	 * we need to start from the first_page to the next_page - 1
+	 * That is to make sure we also write the mapped dirty
+	 * buffer_heads. If we look at mpd->lbh.b_blocknr we
+	 * would only be looking at currently mapped buffer_heads.
+	 */
 	index = mpd->first_page;
 	end = mpd->next_page - 1;
 
+	pagevec_init(&pvec, 0);
 	while (index <= end) {
-		/*
-		 * We can use PAGECACHE_TAG_DIRTY lookup here because
-		 * even though we have cleared the dirty flag on the page
-		 * We still keep the page in the radix tree with tag
-		 * PAGECACHE_TAG_DIRTY. See clear_page_dirty_for_io.
-		 * The PAGECACHE_TAG_DIRTY is cleared in set_page_writeback
-		 * which is called via the below writepage callback.
-		 */
-		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
-					PAGECACHE_TAG_DIRTY,
-					min(end - index,
-					(pgoff_t)PAGEVEC_SIZE-1) + 1);
+		nr_pages = pagevec_lookup(&pvec, mapping, index, PAGEVEC_SIZE);
 		if (nr_pages == 0)
 			break;
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
 
+			index = page->index;
+			if (index > end)
+				break;
+			index++;
+
+			BUG_ON(!PageLocked(page));
+			BUG_ON(PageWriteback(page));
+
 			pages_skipped = mpd->wbc->pages_skipped;
 			err = mapping->a_ops->writepage(page, mpd->wbc);
 			if (!err && (pages_skipped == mpd->wbc->pages_skipped))
@@ -2086,11 +2090,29 @@ static int __mpage_da_writepage(struct page *page,
 		bh = head;
 		do {
 			BUG_ON(buffer_locked(bh));
+			/*
+			 * We need to try to allocte
+			 * unmapped blocks in the same page.
+			 * Otherwise we won't make progress
+			 * with the page in ext4_da_writepage
+			 */
 			if (buffer_dirty(bh) &&
 				(!buffer_mapped(bh) || buffer_delay(bh))) {
 				mpage_add_bh_to_extent(mpd, logical, bh);
 				if (mpd->io_done)
 					return MPAGE_DA_EXTENT_TAIL;
+			} else if (buffer_dirty(bh) && (buffer_mapped(bh))) {
+				/*
+				 * mapped dirty buffer. We need to update
+				 * the b_state because we look at
+				 * b_state in mpage_da_map_blocks. We don't
+				 * update b_size because if we find an
+				 * unmapped buffer_head later we need to
+				 * use the b_state flag of that buffer_head.
+				 */
+				if (mpd->lbh.b_size == 0)
+					mpd->lbh.b_state =
+						bh->b_state & BH_FLAGS;
 			}
 			logical++;
 		} while ((bh = bh->b_this_page) != head);
-- 
1.6.0.3.640.g6331a

