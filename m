From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,RFC 3/7] ext4: clear the dirty bit for a page in writeback at the last minute
Date: Sat, 12 Feb 2011 19:15:53 -0500
Message-ID: <1297556157-21559-4-git-send-email-tytso@mit.edu>
References: <1297556157-21559-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38179 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363Ab1BMA52 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Feb 2011 19:57:28 -0500
In-Reply-To: <1297556157-21559-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Move when we call clear_page_dirty_for_io() to just before we actually
write the page.  This simplifies the code somewhat, and avoids marking
pages as clean and then needing to remark them as dirty later.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |   28 +++++++++++-----------------
 1 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e230f4f..3eca465 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2060,7 +2060,7 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd,
 		if (nr_pages == 0)
 			break;
 		for (i = 0; i < nr_pages; i++) {
-			int commit_write = 0, redirty_page = 0;
+			int commit_write = 0, skip_page = 0;
 			struct page *page = pvec.pages[i];
 
 			index = page->index;
@@ -2086,14 +2086,12 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd,
 			 * If the page does not have buffers (for
 			 * whatever reason), try to create them using
 			 * __block_write_begin.  If this fails,
-			 * redirty the page and move on.
+			 * skip the page and move on.
 			 */
 			if (!page_has_buffers(page)) {
 				if (__block_write_begin(page, 0, len,
 						noalloc_get_block_write)) {
-				redirty_page:
-					redirty_page_for_writepage(mpd->wbc,
-								   page);
+				skip_page:
 					unlock_page(page);
 					continue;
 				}
@@ -2104,7 +2102,7 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd,
 			block_start = 0;
 			do {
 				if (!bh)
-					goto redirty_page;
+					goto skip_page;
 				if (map && (cur_logical >= map->m_lblk) &&
 				    (cur_logical <= (map->m_lblk +
 						     (map->m_len - 1)))) {
@@ -2120,22 +2118,23 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd,
 					clear_buffer_unwritten(bh);
 				}
 
-				/* redirty page if block allocation undone */
+				/* skip page if block allocation undone */
 				if (buffer_delay(bh) || buffer_unwritten(bh))
-					redirty_page = 1;
+					skip_page = 1;
 				bh = bh->b_this_page;
 				block_start += bh->b_size;
 				cur_logical++;
 				pblock++;
 			} while (bh != page_bufs);
 
-			if (redirty_page)
-				goto redirty_page;
+			if (skip_page)
+				goto skip_page;
 
 			if (commit_write)
 				/* mark the buffer_heads as dirty & uptodate */
 				block_commit_write(page, 0, len);
 
+			clear_page_dirty_for_io(page);
 			/*
 			 * Delalloc doesn't support data journalling,
 			 * but eventually maybe we'll lift this
@@ -2279,9 +2278,8 @@ static void mpage_da_map_and_submit(struct mpage_da_data *mpd)
 		err = blks;
 		/*
 		 * If get block returns EAGAIN or ENOSPC and there
-		 * appears to be free blocks we will call
-		 * ext4_writepage() for all of the pages which will
-		 * just redirty the pages.
+		 * appears to be free blocks we will just let
+		 * mpage_da_submit_io() unlock all of the pages.
 		 */
 		if (err == -EAGAIN)
 			goto submit_io;
@@ -2777,7 +2775,6 @@ static int write_cache_pages_da(struct address_space *mapping,
 			    (PageWriteback(page) &&
 			     (wbc->sync_mode == WB_SYNC_NONE)) ||
 			    unlikely(page->mapping != mapping)) {
-			continue_unlock:
 				unlock_page(page);
 				continue;
 			}
@@ -2786,8 +2783,6 @@ static int write_cache_pages_da(struct address_space *mapping,
 				wait_on_page_writeback(page);
 
 			BUG_ON(PageWriteback(page));
-			if (!clear_page_dirty_for_io(page))
-				goto continue_unlock;
 
 			/*
 			 * Can we merge this page to current extent?
@@ -2803,7 +2798,6 @@ static int write_cache_pages_da(struct address_space *mapping,
 					/*
 					 * skip rest of the page in the page_vec
 					 */
-					redirty_page_for_writepage(wbc, page);
 					unlock_page(page);
 					goto ret_extent_tail;
 				}
-- 
1.7.3.1

