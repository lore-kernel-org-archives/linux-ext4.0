From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH -v2 4/6] ext4: inline walk_page_buffers() into mpage_da_submit_io
Date: Sat, 23 Oct 2010 16:40:18 -0400
Message-ID: <1287866420-23762-5-git-send-email-tytso@mit.edu>
References: <1287866420-23762-1-git-send-email-tytso@mit.edu>
Cc: akpm@linux-foundation.org, Theodore Ts'o <tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:46999 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756658Ab0JWUk3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 23 Oct 2010 16:40:29 -0400
In-Reply-To: <1287866420-23762-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Expand the call:

  if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
                        ext4_bh_delay_or_unwritten))
	goto redirty_page

into mpage_da_submit_io().

This will allow us to merge in mpage_put_bnr_to_bhs() in the next
patch.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/inode.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 97a0c35..5da6cfc 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2011,8 +2011,8 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd)
 	struct inode *inode = mpd->inode;
 	struct address_space *mapping = inode->i_mapping;
 	loff_t size = i_size_read(inode);
-	unsigned int len;
-	struct buffer_head *page_bufs = NULL;
+	unsigned int len, block_start;
+	struct buffer_head *bh, *page_bufs = NULL;
 	int journal_data = ext4_should_journal_data(inode);
 
 	BUG_ON(mpd->next_page <= mpd->first_page);
@@ -2064,15 +2064,17 @@ static int mpage_da_submit_io(struct mpage_da_data *mpd)
 				}
 				commit_write = 1;
 			}
-			page_bufs = page_buffers(page);
-			if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
-					      ext4_bh_delay_or_unwritten)) {
-				/*
-				 * We couldn't do block allocation for
-				 * some reason.
-				 */
-				goto redirty_page;
-			}
+
+			bh = page_bufs = page_buffers(page);
+			block_start = 0;
+			do {
+				/* redirty page if block allocation undone */
+				if (!bh || buffer_delay(bh) ||
+				    buffer_unwritten(bh))
+					goto redirty_page;
+				bh = bh->b_this_page;
+				block_start += bh->b_size;
+			} while ((bh != page_bufs) && (block_start < len));
 
 			if (commit_write)
 				/* mark the buffer_heads as dirty & uptodate */
-- 
1.7.1

