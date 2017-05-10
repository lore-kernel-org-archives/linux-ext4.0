From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/4] ext4: Don't allocate io_end for writeback from ext4_writepage()
Date: Wed, 10 May 2017 09:41:46 +0200
Message-ID: <20170510074147.26743-4-jack@suse.cz>
References: <20170510074147.26743-1-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45368 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751858AbdEJHro (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 10 May 2017 03:47:44 -0400
In-Reply-To: <20170510074147.26743-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4_writepage() writes out only mapped buffers with allocated
underlying blocks. Thus there's no need for io_end structure
and we can avoid allocating it.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 5834c4d76be8..6bce4520d569 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2108,16 +2108,8 @@ static int ext4_writepage(struct page *page,
 		return __ext4_journalled_writepage(page, len);
 
 	ext4_io_submit_init(&io_submit, wbc);
-	io_submit.io_end = ext4_init_io_end(inode, GFP_NOFS);
-	if (!io_submit.io_end) {
-		redirty_page_for_writepage(wbc, page);
-		unlock_page(page);
-		return -ENOMEM;
-	}
 	ret = ext4_bio_write_page(&io_submit, page, len, wbc, keep_towrite);
 	ext4_io_submit(&io_submit);
-	/* Drop io_end reference we got from init */
-	ext4_put_io_end_defer(io_submit.io_end);
 	return ret;
 }
 
-- 
2.12.0
