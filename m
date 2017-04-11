From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/3] ext4: Don't allocate io_end for writeback from ext4_writepage()
Date: Tue, 11 Apr 2017 15:54:17 +0200
Message-ID: <20170411135418.9638-3-jack@suse.cz>
References: <20170411135418.9638-1-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47945 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752485AbdDKNy1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 11 Apr 2017 09:54:27 -0400
In-Reply-To: <20170411135418.9638-1-jack@suse.cz>
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
index 4247d8d25687..baa87e7d1426 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2107,16 +2107,8 @@ static int ext4_writepage(struct page *page,
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
