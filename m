From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v3 4/8] ext4: account the data request of read operations in buffered io
Date: Mon, 28 Nov 2011 20:20:24 +0800
Message-ID: <1322482828-5529-4-git-send-email-wenqing.lz@taobao.com>
References: <1322482392-5346-1-git-send-email-wenqing.lz@taobao.com>
 <1322482828-5529-1-git-send-email-wenqing.lz@taobao.com>
Cc: Jens Axboe <axboe@kernel.dk>,
	Steven Whitehouse <swhiteho@redhat.com>,
	Aditya Kali <adityakali@google.com>,
	Wang Shaoyan <wangshaoyan.pt@taobao.com>,
	Zheng Liu <wenqing.lz@taobao.com>
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53709 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455Ab1K1MSj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Nov 2011 07:18:39 -0500
In-Reply-To: <1322482828-5529-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

ll_rw_block in ext4_discard_partial_page_buffers_no_lock and
ext4_block_zero_page_range are replaced with ext4_ll_rw_block, and
ext4_ios_read are called in ext4_readpage and ext4_readpages in order to
account the data request.

CC: Jens Axboe <axboe@kernel.dk>
CC: Steven Whitehouse <swhiteho@redhat.com>
CC: Aditya Kali <adityakali@google.com>
Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/inode.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 52fcaab..426ac55 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2679,6 +2679,8 @@ static sector_t ext4_bmap(struct address_space *mapping, sector_t block)
 static int ext4_readpage(struct file *file, struct page *page)
 {
 	trace_ext4_readpage(page);
+	ext4_ios_read(page->mapping->host->i_sb, EXT4_IOS_REGULAR_DATA,
+		      ext4_blocks_per_page(page->mapping->host));
 	return mpage_readpage(page, ext4_get_block);
 }
 
@@ -2686,6 +2688,8 @@ static int
 ext4_readpages(struct file *file, struct address_space *mapping,
 		struct list_head *pages, unsigned nr_pages)
 {
+	ext4_ios_read(mapping->host->i_sb, EXT4_IOS_REGULAR_DATA,
+		      ext4_blocks_per_page(mapping->host));
 	return mpage_readpages(mapping, pages, nr_pages, ext4_get_block);
 }
 
@@ -3300,12 +3304,12 @@ int ext4_discard_partial_page_buffers_no_lock(handle_t *handle,
 		if (PageUptodate(page))
 			set_buffer_uptodate(bh);
 
-		if (!buffer_uptodate(bh)) {
-			err = -EIO;
-			ll_rw_block(READ, 1, &bh);
-			wait_on_buffer(bh);
+		if (!bh_uptodate_or_lock(bh)) {
+			err = ext4_submit_bh_read(READ, bh, inode->i_sb,
+						  EXT4_IOS_REGULAR_DATA,
+						  ext4_blocks_per_page(inode));
 			/* Uhhuh. Read error. Complain and punt.*/
-			if (!buffer_uptodate(bh))
+			if (err)
 				goto next;
 		}
 
@@ -3422,12 +3426,11 @@ int ext4_block_zero_page_range(handle_t *handle,
 	if (PageUptodate(page))
 		set_buffer_uptodate(bh);
 
-	if (!buffer_uptodate(bh)) {
-		err = -EIO;
-		ll_rw_block(READ, 1, &bh);
-		wait_on_buffer(bh);
+	if (!bh_uptodate_or_lock(bh)) {
+		err = ext4_submit_bh_read(READ, bh, inode->i_sb,
+					  EXT4_IOS_REGULAR_DATA, 1);
 		/* Uhhuh. Read error. Complain and punt. */
-		if (!buffer_uptodate(bh))
+		if (err)
 			goto unlock;
 	}
 
-- 
1.7.4.1

