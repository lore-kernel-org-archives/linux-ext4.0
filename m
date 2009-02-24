From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH, RFC] ext4: Simplify delalloc code by removing mpage_da_writepages()
Date: Tue, 24 Feb 2009 00:05:49 -0500
Message-ID: <1235451952-2726-4-git-send-email-tytso@mit.edu>
References: <1235451952-2726-1-git-send-email-tytso@mit.edu>
 <1235451952-2726-2-git-send-email-tytso@mit.edu>
 <1235451952-2726-3-git-send-email-tytso@mit.edu>
Cc: aneesh.kumar@linux.vnet.ibm.com, Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:40274 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbZBXFGE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Feb 2009 00:06:04 -0500
In-Reply-To: <1235451952-2726-3-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The mpage_da_writepages() function is only used in one place, so
inline it to simplify the call stack and make the code easier to
understand.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |   74 +++++++++++++++++++++++-------------------------------
 1 files changed, 32 insertions(+), 42 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 407aa85..1216fb9 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2212,47 +2212,6 @@ static int __mpage_da_writepage(struct page *page,
 }
 
 /*
- * mpage_da_writepages - walk the list of dirty pages of the given
- * address space, allocates non-allocated blocks, maps newly-allocated
- * blocks to existing bhs and issue IO them
- *
- * @mapping: address space structure to write
- * @wbc: subtract the number of written pages from *@wbc->nr_to_write
- *
- * This is a library function, which implements the writepages()
- * address_space_operation.
- */
-static int mpage_da_writepages(struct address_space *mapping,
-			       struct writeback_control *wbc,
-			       struct mpage_da_data *mpd)
-{
-	int ret;
-
-	mpd->b_size = 0;
-	mpd->b_state = 0;
-	mpd->b_blocknr = 0;
-	mpd->first_page = 0;
-	mpd->next_page = 0;
-	mpd->io_done = 0;
-	mpd->pages_written = 0;
-	mpd->retval = 0;
-
-	ret = write_cache_pages(mapping, wbc, __mpage_da_writepage, mpd);
-	/*
-	 * Handle last extent of pages
-	 */
-	if (!mpd->io_done && mpd->next_page != mpd->first_page) {
-		if (mpage_da_map_blocks(mpd) == 0)
-			mpage_da_submit_io(mpd);
-
-		mpd->io_done = 1;
-		ret = MPAGE_DA_EXTENT_TAIL;
-	}
-	wbc->nr_to_write -= mpd->pages_written;
-	return ret;
-}
-
-/*
  * this is a special callback for ->write_begin() only
  * it's intention is to return mapped block or reserve space
  */
@@ -2541,7 +2500,38 @@ retry:
 			dump_stack();
 			goto out_writepages;
 		}
-		ret = mpage_da_writepages(mapping, wbc, &mpd);
+
+		/*
+		 * Now call __mpage_da_writepage to find the next
+		 * contiguous region of logical blocks that need
+		 * blocks to be allocated by ext4.  We don't actually
+		 * submit the blocks for I/O here, even though
+		 * write_cache_pages thinks it will, and will set the
+		 * pages as clean for write before calling
+		 * __mpage_da_writepage().
+		 */
+		mpd.b_size = 0;
+		mpd.b_state = 0;
+		mpd.b_blocknr = 0;
+		mpd.first_page = 0;
+		mpd.next_page = 0;
+		mpd.io_done = 0;
+		mpd.pages_written = 0;
+		mpd.retval = 0;
+		ret = write_cache_pages(mapping, wbc, __mpage_da_writepage,
+					&mpd);
+		/*
+		 * If we have a contigous extent of pages and we
+		 * haven't done the I/O yet, map the blocks and submit
+		 * them for I/O.
+		 */
+		if (!mpd.io_done && mpd.next_page != mpd.first_page) {
+			if (mpage_da_map_blocks(&mpd) == 0)
+				mpage_da_submit_io(&mpd);
+			mpd.io_done = 1;
+			ret = MPAGE_DA_EXTENT_TAIL;
+		}
+		wbc->nr_to_write -= mpd.pages_written;
 
 		ext4_journal_stop(handle);
 
-- 
1.5.6.3

