From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH -v2 3/6] ext4: inline ext4_writepage() into mpage_da_submit_io()
Date: Sat, 23 Oct 2010 16:40:17 -0400
Message-ID: <1287866420-23762-4-git-send-email-tytso@mit.edu>
References: <1287866420-23762-1-git-send-email-tytso@mit.edu>
Cc: akpm@linux-foundation.org, Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46997 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756585Ab0JWUk3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Oct 2010 16:40:29 -0400
In-Reply-To: <1287866420-23762-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

As a prepratory step to switching to bio_submit, inline
ext4_writepage() into mpage_da_submit() and then simplify things a
bit.  This makes it clearer what mpage_da_submit needs to do.

Also, move the ClearPageChecked(page) call into
__ext4_journalled_writepage(), as a minor bit of cleanup refactoring.

This also allows us to pull i_size_read() and
ext4_should_journal_data() out of the loop, which should be a very
minor CPU savings.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |   70 ++++++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 59 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a08ec79..97a0c35 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -60,7 +60,12 @@ static inline int ext4_begin_ordered_truncate(struct inode *inode,
 }
 
 static void ext4_invalidatepage(struct page *page, unsigned long offset);
-static int ext4_writepage(struct page *page, struct writeback_control *wbc);
+static int noalloc_get_block_write(struct inode *inode, sector_t iblock,
+				   struct buffer_head *bh_result, int create);
+static int ext4_set_bh_endio(struct buffer_head *bh, struct inode *inode);
+static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate);
+static int __ext4_journalled_writepage(struct page *page, unsigned int len);
+static int ext4_bh_delay_or_unwritten(handle_t *handle, struct buffer_head *bh);
 
 /*
  * Test whether an inode is a fast symlink.
@@ -2000,12 +2005,15 @@ static void ext4_da_page_release_reservation(struct page *page,
  */
 static int mpage_da_submit_io(struct mpage_da_data *mpd)
 {
-	long pages_skipped;
 	struct pagevec pvec;
 	unsigned long index, end;
 	int ret = 0, err, nr_pages, i;
 	struct inode *inode = mpd->inode;
 	struct address_space *mapping = inode->i_mapping;
+	loff_t size = i_size_read(inode);
+	unsigned int len;
+	struct buffer_head *page_bufs = NULL;
+	int journal_data = ext4_should_journal_data(inode);
 
 	BUG_ON(mpd->next_page <= mpd->first_page);
 	/*
@@ -2023,28 +2031,69 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd)
 		if (nr_pages == 0)
 			break;
 		for (i = 0; i < nr_pages; i++) {
+			int commit_write = 0;
 			struct page *page = pvec.pages[i];
 
 			index = page->index;
 			if (index > end)
 				break;
+
+			if (index == size >> PAGE_CACHE_SHIFT)
+				len = size & ~PAGE_CACHE_MASK;
+			else
+				len = PAGE_CACHE_SIZE;
 			index++;
 
 			BUG_ON(!PageLocked(page));
 			BUG_ON(PageWriteback(page));
 
-			pages_skipped = mpd->wbc->pages_skipped;
-			err = ext4_writepage(page, mpd->wbc);
-			if (!err && (pages_skipped == mpd->wbc->pages_skipped))
+			/*
+			 * If the page does not have buffers (for
+			 * whatever reason), try to create them using
+			 * block_prepare_write.  If this fails,
+			 * redirty the page and move on.
+			 */
+			if (!page_has_buffers(page)) {
+				if (block_prepare_write(page, 0, len,
+						noalloc_get_block_write)) {
+				redirty_page:
+					redirty_page_for_writepage(mpd->wbc,
+								   page);
+					unlock_page(page);
+					continue;
+				}
+				commit_write = 1;
+			}
+			page_bufs = page_buffers(page);
+			if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
+					      ext4_bh_delay_or_unwritten)) {
 				/*
-				 * have successfully written the page
-				 * without skipping the same
+				 * We couldn't do block allocation for
+				 * some reason.
 				 */
+				goto redirty_page;
+			}
+
+			if (commit_write)
+				/* mark the buffer_heads as dirty & uptodate */
+				block_commit_write(page, 0, len);
+
+			if (journal_data && PageChecked(page))
+				err = __ext4_journalled_writepage(page, len);
+			else if (buffer_uninit(page_bufs)) {
+				ext4_set_bh_endio(page_bufs, inode);
+				err = block_write_full_page_endio(page,
+					noalloc_get_block_write,
+					mpd->wbc, ext4_end_io_buffer_write);
+			} else
+				err = block_write_full_page(page,
+					    noalloc_get_block_write, mpd->wbc);
+
+			if (!err)
 				mpd->pages_written++;
 			/*
 			 * In error case, we have to continue because
 			 * remaining pages are still locked
-			 * XXX: unlock and re-dirty them?
 			 */
 			if (ret == 0)
 				ret = err;
@@ -2627,6 +2676,7 @@ static int __ext4_journalled_writepage(struct page *page,
 	int ret = 0;
 	int err;
 
+	ClearPageChecked(page);
 	page_bufs = page_buffers(page);
 	BUG_ON(!page_bufs);
 	walk_page_buffers(handle, page_bufs, 0, len, NULL, bget_one);
@@ -2749,14 +2799,12 @@ static int ext4_writepage(struct page *page,
 		/* now mark the buffer_heads as dirty and uptodate */
 		block_commit_write(page, 0, len);
 
-	if (PageChecked(page) && ext4_should_journal_data(inode)) {
+	if (PageChecked(page) && ext4_should_journal_data(inode))
 		/*
 		 * It's mmapped pagecache.  Add buffers and journal it.  There
 		 * doesn't seem much point in redirtying the page here.
 		 */
-		ClearPageChecked(page);
 		return __ext4_journalled_writepage(page, len);
-	}
 
 	if (buffer_uninit(page_bufs)) {
 		ext4_set_bh_endio(page_bufs, inode);
-- 
1.7.1

