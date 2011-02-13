From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,RFC 2/7] ext4: simple cleanups to write_cache_pages_da()
Date: Sat, 12 Feb 2011 19:15:52 -0500
Message-ID: <1297556157-21559-3-git-send-email-tytso@mit.edu>
References: <1297556157-21559-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38177 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312Ab1BMA52 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Feb 2011 19:57:28 -0500
In-Reply-To: <1297556157-21559-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eliminate duplicate code, unneeded variables, etc., to make it easier
to understand the code.  No behavioral changes were made in this patch.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |  115 +++++++++++++++++++++++--------------------------------
 1 files changed, 48 insertions(+), 67 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 627729f..e230f4f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2723,17 +2723,14 @@ static int write_cache_pages_da(struct address_space *mapping,
 				struct mpage_da_data *mpd,
 				pgoff_t *done_index)
 {
-	struct inode *inode = mpd->inode;
-	struct buffer_head *bh, *head;
-	sector_t logical;
-	int ret = 0;
-	int done = 0;
-	struct pagevec pvec;
-	unsigned nr_pages;
-	pgoff_t index;
-	pgoff_t end;		/* Inclusive */
-	long nr_to_write = wbc->nr_to_write;
-	int tag;
+	struct buffer_head	*bh, *head;
+	struct inode		*inode = mpd->inode;
+	struct pagevec		pvec;
+	unsigned int		nr_pages;
+	sector_t		logical;
+	pgoff_t			index, end;
+	long			nr_to_write = wbc->nr_to_write;
+	int			i, tag, ret = 0;
 
 	pagevec_init(&pvec, 0);
 	index = wbc->range_start >> PAGE_CACHE_SHIFT;
@@ -2745,13 +2742,11 @@ static int write_cache_pages_da(struct address_space *mapping,
 		tag = PAGECACHE_TAG_DIRTY;
 
 	*done_index = index;
-	while (!done && (index <= end)) {
-		int i;
-
+	while (index <= end) {
 		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index, tag,
 			      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
 		if (nr_pages == 0)
-			break;
+			return 0;
 
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
@@ -2763,47 +2758,37 @@ static int write_cache_pages_da(struct address_space *mapping,
 			 * mapping. However, page->index will not change
 			 * because we have a reference on the page.
 			 */
-			if (page->index > end) {
-				done = 1;
-				break;
-			}
+			if (page->index > end)
+				goto out;
 
 			*done_index = page->index + 1;
 
 			lock_page(page);
 
 			/*
-			 * Page truncated or invalidated. We can freely skip it
-			 * then, even for data integrity operations: the page
-			 * has disappeared concurrently, so there could be no
-			 * real expectation of this data interity operation
-			 * even if there is now a new, dirty page at the same
-			 * pagecache address.
+			 * If the page is no longer dirty, or its
+			 * mapping no longer corresponds to inode we
+			 * are writing (which means it has been
+			 * truncated or invalidated), or the page is
+			 * already under writeback and we are not
+			 * doing a data integrity writeback, skip the page
 			 */
-			if (unlikely(page->mapping != mapping)) {
-continue_unlock:
+			if (!PageDirty(page) ||
+			    (PageWriteback(page) &&
+			     (wbc->sync_mode == WB_SYNC_NONE)) ||
+			    unlikely(page->mapping != mapping)) {
+			continue_unlock:
 				unlock_page(page);
 				continue;
 			}
 
-			if (!PageDirty(page)) {
-				/* someone wrote it for us */
-				goto continue_unlock;
-			}
-
-			if (PageWriteback(page)) {
-				if (wbc->sync_mode != WB_SYNC_NONE)
-					wait_on_page_writeback(page);
-				else
-					goto continue_unlock;
-			}
+			if (PageWriteback(page))
+				wait_on_page_writeback(page);
 
 			BUG_ON(PageWriteback(page));
 			if (!clear_page_dirty_for_io(page))
 				goto continue_unlock;
 
-			/* BEGIN __mpage_da_writepage */
-
 			/*
 			 * Can we merge this page to current extent?
 			 */
@@ -2820,8 +2805,7 @@ continue_unlock:
 					 */
 					redirty_page_for_writepage(wbc, page);
 					unlock_page(page);
-					ret = MPAGE_DA_EXTENT_TAIL;
-					goto out;
+					goto ret_extent_tail;
 				}
 
 				/*
@@ -2838,15 +2822,15 @@ continue_unlock:
 				(PAGE_CACHE_SHIFT - inode->i_blkbits);
 
 			if (!page_has_buffers(page)) {
-				mpage_add_bh_to_extent(mpd, logical, PAGE_CACHE_SIZE,
+				mpage_add_bh_to_extent(mpd, logical,
+						       PAGE_CACHE_SIZE,
 						       (1 << BH_Dirty) | (1 << BH_Uptodate));
-				if (mpd->io_done) {
-					ret = MPAGE_DA_EXTENT_TAIL;
-					goto out;
-				}
+				if (mpd->io_done)
+					goto ret_extent_tail;
 			} else {
 				/*
-				 * Page with regular buffer heads, just add all dirty ones
+				 * Page with regular buffer heads,
+				 * just add all dirty ones
 				 */
 				head = page_buffers(page);
 				bh = head;
@@ -2862,18 +2846,19 @@ continue_unlock:
 						mpage_add_bh_to_extent(mpd, logical,
 								       bh->b_size,
 								       bh->b_state);
-						if (mpd->io_done) {
-							ret = MPAGE_DA_EXTENT_TAIL;
-							goto out;
-						}
+						if (mpd->io_done)
+							goto ret_extent_tail;
 					} else if (buffer_dirty(bh) && (buffer_mapped(bh))) {
 						/*
-						 * mapped dirty buffer. We need to update
-						 * the b_state because we look at
-						 * b_state in mpage_da_map_blocks. We don't
-						 * update b_size because if we find an
-						 * unmapped buffer_head later we need to
-						 * use the b_state flag of that buffer_head.
+						 * mapped dirty buffer. We need
+						 * to update the b_state
+						 * because we look at b_state
+						 * in mpage_da_map_blocks.  We
+						 * don't update b_size because
+						 * if we find an unmapped
+						 * buffer_head later we need to
+						 * use the b_state flag of that
+						 * buffer_head.
 						 */
 						if (mpd->b_size == 0)
 							mpd->b_state = bh->b_state & BH_FLAGS;
@@ -2882,14 +2867,10 @@ continue_unlock:
 				} while ((bh = bh->b_this_page) != head);
 			}
 
-			ret = 0;
-
-			/* END __mpage_da_writepage */
-
 			if (nr_to_write > 0) {
 				nr_to_write--;
 				if (nr_to_write == 0 &&
-				    wbc->sync_mode == WB_SYNC_NONE) {
+				    wbc->sync_mode == WB_SYNC_NONE)
 					/*
 					 * We stop writing back only if we are
 					 * not doing integrity sync. In case of
@@ -2900,15 +2881,15 @@ continue_unlock:
 					 * pages, but have not synced all of the
 					 * old dirty pages.
 					 */
-					done = 1;
-					break;
-				}
+					goto out;
 			}
 		}
 		pagevec_release(&pvec);
 		cond_resched();
 	}
-	return ret;
+	return 0;
+ret_extent_tail:
+	ret = MPAGE_DA_EXTENT_TAIL;
 out:
 	pagevec_release(&pvec);
 	cond_resched();
-- 
1.7.3.1

