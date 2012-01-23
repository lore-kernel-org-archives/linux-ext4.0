From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v4 4/8] ext4: account the data request of read operations in buffered io
Date: Tue, 24 Jan 2012 00:50:24 +0800
Message-ID: <1327337428-8266-5-git-send-email-wenqing.lz@taobao.com>
References: <1327337428-8266-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, Jens Axboe <axboe@kernel.dk>,
	Steven Whitehouse <swhiteho@redhat.com>,
	Aditya Kali <adityakali@google.com>,
	Wang Shaoyan <wangshaoyan.pt@taobao.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58382 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785Ab2AWQq6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Jan 2012 11:46:58 -0500
In-Reply-To: <1327337428-8266-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ll_rw_block in ext4_discard_partial_page_buffers_no_lock is replaced with
ext4_submit_bh_read, and ext4_ios_read are called in ext4_readpage and
ext4_readpages in order to account the data request.

CC: Jens Axboe <axboe@kernel.dk>
CC: Steven Whitehouse <swhiteho@redhat.com>
CC: Aditya Kali <adityakali@google.com>
Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/inode.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index b68d129..ff56658 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2665,6 +2665,8 @@ static sector_t ext4_bmap(struct address_space *mapping, sector_t block)
 static int ext4_readpage(struct file *file, struct page *page)
 {
 	trace_ext4_readpage(page);
+	ext4_ios_read(page->mapping->host->i_sb, EXT4_IOS_REGULAR_DATA,
+		      ext4_blocks_per_page(page->mapping->host));
 	return mpage_readpage(page, ext4_get_block);
 }
 
@@ -2672,6 +2674,8 @@ static int
 ext4_readpages(struct file *file, struct address_space *mapping,
 		struct list_head *pages, unsigned nr_pages)
 {
+	ext4_ios_read(mapping->host->i_sb, EXT4_IOS_REGULAR_DATA,
+		      ext4_blocks_per_page(mapping->host));
 	return mpage_readpages(mapping, pages, nr_pages, ext4_get_block);
 }
 
@@ -3268,12 +3272,12 @@ static int ext4_discard_partial_page_buffers_no_lock(handle_t *handle,
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
 
-- 
1.7.4.1

