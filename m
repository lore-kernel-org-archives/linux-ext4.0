From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH,RFC 6/7] ext4: move setup of the mpd structure to write_cache_pages_da()
Date: Sat, 12 Feb 2011 19:15:56 -0500
Message-ID: <1297556157-21559-7-git-send-email-tytso@mit.edu>
References: <1297556157-21559-1-git-send-email-tytso@mit.edu>
Cc: Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38182 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373Ab1BMA53 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Feb 2011 19:57:29 -0500
In-Reply-To: <1297556157-21559-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Move the initialization of all of the fields of the mpd structure to
write_cache_pages_da().  This simplifies the code considerably.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |   29 +++++++----------------------
 1 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2ac64e3..235a90e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2714,7 +2714,8 @@ static int ext4_da_writepages_trans_blocks(struct inode *inode)
 /*
  * write_cache_pages_da - walk the list of dirty pages of the given
  * address space and accumulate pages that need writing, and call
- * mpage_da_map_and_submit to map the pages and then write them.
+ * mpage_da_map_and_submit to map a single contiguous memory region
+ * and then write them.
  */
 static int write_cache_pages_da(struct address_space *mapping,
 				struct writeback_control *wbc,
@@ -2722,7 +2723,7 @@ static int write_cache_pages_da(struct address_space *mapping,
 				pgoff_t *done_index)
 {
 	struct buffer_head	*bh, *head;
-	struct inode		*inode = mpd->inode;
+	struct inode		*inode = mapping->host;
 	struct pagevec		pvec;
 	unsigned int		nr_pages;
 	sector_t		logical;
@@ -2730,6 +2731,9 @@ static int write_cache_pages_da(struct address_space *mapping,
 	long			nr_to_write = wbc->nr_to_write;
 	int			i, tag, ret = 0;
 
+	memset(mpd, 0, sizeof(struct mpage_da_data));
+	mpd->wbc = wbc;
+	mpd->inode = inode;
 	pagevec_init(&pvec, 0);
 	index = wbc->range_start >> PAGE_CACHE_SHIFT;
 	end = wbc->range_end >> PAGE_CACHE_SHIFT;
@@ -2794,16 +2798,8 @@ static int write_cache_pages_da(struct address_space *mapping,
 
 			BUG_ON(PageWriteback(page));
 
-			if (mpd->next_page != page->index) {
-				/*
-				 * Start next extent of pages and blocks
-				 */
+			if (mpd->next_page != page->index)
 				mpd->first_page = page->index;
-				mpd->b_size = 0;
-				mpd->b_state = 0;
-				mpd->b_blocknr = 0;
-			}
-
 			mpd->next_page = page->index + 1;
 			logical = (sector_t) page->index <<
 				(PAGE_CACHE_SHIFT - inode->i_blkbits);
@@ -2975,9 +2971,6 @@ static int ext4_da_writepages(struct address_space *mapping,
 		wbc->nr_to_write = desired_nr_to_write;
 	}
 
-	mpd.wbc = wbc;
-	mpd.inode = mapping->host;
