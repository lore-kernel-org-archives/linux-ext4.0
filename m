From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] ext3: remove unneeded check in ext3_ordered_writepage()
Date: Fri, 21 Feb 2014 11:58:54 +0300
Message-ID: <20140221085854.GC13185@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27998 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbaBUI7C (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Feb 2014 03:59:02 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

We already know "ret" is zero so there is no need to do:

		if (!ret)
			ret = err;

We can just assign ret directly instead.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 384b6ebb655f..491f022c476a 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1673,12 +1673,9 @@ static int ext3_ordered_writepage(struct page *page,
 	 * block_write_full_page() succeeded.  Otherwise they are unmapped,
 	 * and generally junk.
 	 */
-	if (ret == 0) {
-		err = walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE,
+	if (ret == 0)
+		ret = walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE,
 					NULL, journal_dirty_data_fn);
-		if (!ret)
-			ret = err;
-	}
 	walk_page_buffers(handle, page_bufs, 0,
 			PAGE_CACHE_SIZE, NULL, bput_one);
 	err = ext3_journal_stop(handle);
