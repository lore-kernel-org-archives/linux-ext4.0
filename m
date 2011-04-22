From: Curt Wohlgemuth <curtw@google.com>
Subject: [PATCH] ext4: Don't set PageUptodate in ext4_end_bio()
Date: Fri, 22 Apr 2011 10:51:58 -0700
Message-ID: <1303494718-13444-1-git-send-email-curtw@google.com>
Cc: jim@meyering.net, cmm@us.ibm.com,
	Curt Wohlgemuth <curtw@google.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:11371 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236Ab1DVRwS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Apr 2011 13:52:18 -0400
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

Signed-off-by: Curt Wohlgemuth <curtw@google.com>
Reported-by: Jim Meyering <jim@meyering.net>
Reported-by: Hugh Dickins <hughd@google.com>
Cc: Mingming Cao <cmm@us.ibm.com>
---
 fs/ext4/page-io.c |   41 +++++------------------------------------
 1 files changed, 5 insertions(+), 36 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index b6dbd05..76bbe6a 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -202,47 +202,16 @@ static void ext4_end_bio(struct bio *bio, int error)
 
 	for (i = 0; i < io_end->num_io_pages; i++) {
 		struct page *page = io_end->pages[i]->p_page;
-		struct buffer_head *bh, *head;
-		int partial_write = 0;
+		struct buffer_head *head;
 
 		head = page_buffers(page);
-		if (error)
-			SetPageError(page);
 		BUG_ON(!head);
-		if (head->b_size != PAGE_CACHE_SIZE) {
-			loff_t offset;
-			loff_t io_end_offset = io_end->offset + io_end->size;
-
-			offset = (sector_t) page->index << PAGE_CACHE_SHIFT;
-			bh = head;
-			do {
-				if ((offset >= io_end->offset) &&
-				    (offset+bh->b_size <= io_end_offset)) {
-					if (error)
-						buffer_io_error(bh);
-
-				}
-				if (buffer_delay(bh))
-					partial_write = 1;
-				else if (!buffer_mapped(bh))
-					clear_buffer_dirty(bh);
-				else if (buffer_dirty(bh))
-					partial_write = 1;
-				offset += bh->b_size;
-				bh = bh->b_this_page;
-			} while (bh != head);
+		if (error) {
+			SetPageError(page);
+			buffer_io_error(head);
+			set_bit(AS_EIO, &page->mapping->flags);
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
