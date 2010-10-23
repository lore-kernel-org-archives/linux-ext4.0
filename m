From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH -v2 2/6] ext4: simplify ext4_writepage()
Date: Sat, 23 Oct 2010 16:40:16 -0400
Message-ID: <1287866420-23762-3-git-send-email-tytso@mit.edu>
References: <1287866420-23762-1-git-send-email-tytso@mit.edu>
Cc: akpm@linux-foundation.org, Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:47000 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451Ab0JWUk3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Oct 2010 16:40:29 -0400
In-Reply-To: <1287866420-23762-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The actual code in ext4_writepage() is unnecessarily convoluted.
Simplify it so it is easier to understand, but otherwise logically
equivalent.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |   73 +++++++++++++++++++------------------------------------
 1 files changed, 25 insertions(+), 48 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 55961ff..a08ec79 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2704,7 +2704,7 @@ static void ext4_end_io_buffer_write(struct buffer_head *bh, int uptodate);
 static int ext4_writepage(struct page *page,
 			  struct writeback_control *wbc)
 {
-	int ret = 0;
+	int ret = 0, commit_write = 0;
 	loff_t size;
 	unsigned int len;
 	struct buffer_head *page_bufs = NULL;
@@ -2717,60 +2717,37 @@ static int ext4_writepage(struct page *page,
 	else
 		len = PAGE_CACHE_SIZE;
 
-	if (page_has_buffers(page)) {
-		page_bufs = page_buffers(page);
-		if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
-					ext4_bh_delay_or_unwritten)) {
-			/*
-			 * We don't want to do  block allocation
-			 * So redirty the page and return
-			 * We may reach here when we do a journal commit
-			 * via journal_submit_inode_data_buffers.
-			 * If we don't have mapping block we just ignore
-			 * them. We can also reach here via shrink_page_list
-			 */
+	/*
+	 * If the page does not have buffers (for whatever reason),
+	 * try to create them using block_prepare_write.  If this
+	 * fails, redirty the page and move on.
+	 */
+	if (!page_buffers(page)) {
+		if (block_prepare_write(page, 0, len,
+					noalloc_get_block_write)) {
+		redirty_page:
 			redirty_page_for_writepage(wbc, page);
 			unlock_page(page);
 			return 0;
 		}
-	} else {
+		commit_write = 1;
+	}
+	page_bufs = page_buffers(page);
+	if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
+			      ext4_bh_delay_or_unwritten)) {
 		/*
-		 * The test for page_has_buffers() is subtle:
-		 * We know the page is dirty but it lost buffers. That means
-		 * that at some moment in time after write_begin()/write_end()
-		 * has been called all buffers have been clean and thus they
-		 * must have been written at least once. So they are all
-		 * mapped and we can happily proceed with mapping them
-		 * and writing the page.
-		 *
-		 * Try to initialize the buffer_heads and check whether
-		 * all are mapped and non delay. We don't want to
-		 * do block allocation here.
+		 * We don't want to do block allocation So redirty the
+		 * page and return We may reach here when we do a
+		 * journal commit via
+		 * journal_submit_inode_data_buffers.  If we don't
+		 * have mapping block we just ignore them. We can also
+		 * reach here via shrink_page_list
 		 */
-		ret = block_prepare_write(page, 0, len,
-					  noalloc_get_block_write);
-		if (!ret) {
-			page_bufs = page_buffers(page);
-			/* check whether all are mapped and non delay */
-			if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
-						ext4_bh_delay_or_unwritten)) {
-				redirty_page_for_writepage(wbc, page);
-				unlock_page(page);
-				return 0;
-			}
-		} else {
-			/*
-			 * We can't do block allocation here
-			 * so just redity the page and unlock
-			 * and return
-			 */
-			redirty_page_for_writepage(wbc, page);
-			unlock_page(page);
-			return 0;
-		}
+		goto redirty_page;
+	}
+	if (commit_write)
 		/* now mark the buffer_heads as dirty and uptodate */
 		block_commit_write(page, 0, len);
-	}
 
 	if (PageChecked(page) && ext4_should_journal_data(inode)) {
 		/*
@@ -2781,7 +2758,7 @@ static int ext4_writepage(struct page *page,
 		return __ext4_journalled_writepage(page, len);
 	}
 
-	if (page_bufs && buffer_uninit(page_bufs)) {
+	if (buffer_uninit(page_bufs)) {
 		ext4_set_bh_endio(page_bufs, inode);
 		ret = block_write_full_page_endio(page, noalloc_get_block_write,
 					    wbc, ext4_end_io_buffer_write);
-- 
1.7.1

