From: Curt Wohlgemuth <curtw@google.com>
Subject: [PATCH] ext4: Don't set PageUptodate in ext4_end_bio()
Date: Mon, 25 Apr 2011 08:38:22 -0700
Message-ID: <1303745902-9010-1-git-send-email-curtw@google.com>
Cc: jim@meyering.net, cmm@us.ibm.com, hughd@google.com,
	Curt Wohlgemuth <curtw@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:30501 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab1DYPii (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 25 Apr 2011 11:38:38 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In the bio completion routine, we should not be setting
PageUptodate at all -- it's set at sys_write() time, and is
unaffected by success/failure of the write to disk.

This can cause a page corruption bug when

    block size < page size

if we have only written a single block -- we might end up
setting the entire PageUptodate, which will cause subsequent
reads to get bad data.

This commit also fixes ext4_end_bio() to set AS_EIO in the
page->mapping->flags on error, which was left out by
mistake.

Signed-off-by: Curt Wohlgemuth <curtw@google.com>
Reported-by: Jim Meyering <jim@meyering.net>
Reported-by: Hugh Dickins <hughd@google.com>
Cc: Mingming Cao <cmm@us.ibm.com>
---
Changlog since v1:
- Added commit message text about setting AS_EIO for the
  page on error.
- Continue to loop over all BHs in a page and emit unique
  errors for each of them.
---
 fs/ext4/page-io.c |   22 ++++------------------
 1 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index b6dbd05..fb681cf 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -203,11 +203,12 @@ static void ext4_end_bio(struct bio *bio, int error)
 	for (i = 0; i < io_end->num_io_pages; i++) {
 		struct page *page = io_end->pages[i]->p_page;
 		struct buffer_head *bh, *head;
-		int partial_write = 0;
 
 		head = page_buffers(page);
-		if (error)
+		if (error) {
 			SetPageError(page);
+			set_bit(AS_EIO, &page->mapping->flags);
+		}
 		BUG_ON(!head);
 		if (head->b_size != PAGE_CACHE_SIZE) {
 			loff_t offset;
@@ -220,29 +221,14 @@ static void ext4_end_bio(struct bio *bio, int error)
 				    (offset+bh->b_size <= io_end_offset)) {
 					if (error)
 						buffer_io_error(bh);
-
 				}
-				if (buffer_delay(bh))
-					partial_write = 1;
-				else if (!buffer_mapped(bh))
+				if (!buffer_mapped(bh))
 					clear_buffer_dirty(bh);
-				else if (buffer_dirty(bh))
-					partial_write = 1;
 				offset += bh->b_size;
 				bh = bh->b_this_page;
 			} while (bh != head);
 		}
 
-		/*
-		 * If this is a partial write which happened to make
-		 * all buffers uptodate then we can optimize away a
-		 * bogus readpage() for the next read(). Here we
-		 * 'discover' whether the page went uptodate as a
-		 * result of this (potentially partial) write.
-		 */
-		if (!partial_write)
-			SetPageUptodate(page);
