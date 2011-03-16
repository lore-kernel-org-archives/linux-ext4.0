From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/2] ext4: Redirty page which could not be added to current extent in __mpage_da_writepage()
Date: Wed, 16 Mar 2011 21:52:54 +0100
Message-ID: <1300308774-14140-3-git-send-email-jack@suse.cz>
References: <1300308774-14140-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:53439 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101Ab1CPUxG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Mar 2011 16:53:06 -0400
In-Reply-To: <1300308774-14140-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When a page cannot be added to current extent in __mpage_da_writepage() we
map current extent and send it for IO. Currently, mpage_da_submit_io() also
redirtied and unlocked this page but it's not clear whether this is just a
lucky accident or a well hidden intent. Actually, we get this wrong in the case
when ext4_map_blocks() fails because of EIO and thus mpage_da_submit_io()
doesn't get called and the page is left locked leading to deadlocks.

Fix the issue by explicitely redirtying and unlocking the page in
__mpage_da_writepage() whenever we see the page could not be added to the
current extent.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 337d9ca..aea9963 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2465,6 +2465,7 @@ static int __mpage_da_writepage(struct page *page,
 		 */
 		if (mpd->next_page != mpd->first_page) {
 			mpage_da_map_and_submit(mpd);
+redirty_page:
 			/*
 			 * skip rest of the page in the page_vec
 			 */
@@ -2477,6 +2478,7 @@ static int __mpage_da_writepage(struct page *page,
 		 * Start next extent of pages ...
 		 */
 		mpd->first_page = page->index;
+		mpd->next_page = page->index + 1;
 
 		/*
 		 * ... and blocks
@@ -2486,7 +2488,6 @@ static int __mpage_da_writepage(struct page *page,
 		mpd->b_blocknr = 0;
 	}
 
-	mpd->next_page = page->index + 1;
 	logical = (sector_t) page->index <<
 		  (PAGE_CACHE_SHIFT - inode->i_blkbits);
 
@@ -2494,7 +2495,7 @@ static int __mpage_da_writepage(struct page *page,
 		mpage_add_bh_to_extent(mpd, logical, PAGE_CACHE_SIZE,
 				       (1 << BH_Dirty) | (1 << BH_Uptodate));
 		if (mpd->io_done)
-			return MPAGE_DA_EXTENT_TAIL;
+			goto redirty_page;
 	} else {
 		/*
 		 * Page with regular buffer heads, just add all dirty ones
@@ -2514,7 +2515,7 @@ static int __mpage_da_writepage(struct page *page,
 						       bh->b_size,
 						       bh->b_state);
 				if (mpd->io_done)
-					return MPAGE_DA_EXTENT_TAIL;
+					goto redirty_page;
 			} else if (buffer_dirty(bh) && (buffer_mapped(bh))) {
 				/*
 				 * mapped dirty buffer. We need to update
@@ -2530,6 +2531,7 @@ static int __mpage_da_writepage(struct page *page,
 			logical++;
 		} while ((bh = bh->b_this_page) != head);
 	}
+	mpd->next_page = page->index + 1;
 
 	return 0;
 }
-- 
1.7.1

