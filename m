From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2 4/8] ext4: Count data request of read operations in buffered io
Date: Thu, 10 Nov 2011 18:34:50 +0800
Message-ID: <1320921294-30321-5-git-send-email-wenqing.lz@taobao.com>
References: <1320921294-30321-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>,
	Wang Shaoyan <wangshaoyan.pt@taobao.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65483 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab1KJKdy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Nov 2011 05:33:54 -0500
In-Reply-To: <1320921294-30321-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

Call ext4_ios_read*() and __ext4_io_stat() functions to count the data of
buffered io in ext4. In ext4_readpage() and ext4_readpages(), we call
__ext4_io_stat() directly because these functions don't use buffer_head.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
---
 fs/ext4/inode.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d4f9da3..5a1fca0 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2680,6 +2680,8 @@ static sector_t ext4_bmap(struct address_space *mapping, sector_t block)
 static int ext4_readpage(struct file *file, struct page *page)
 {
 	trace_ext4_readpage(page);
+	__ext4_io_stat(READ, EXT4_IOS_REGULAR_DATA,
+		       ext4_blocks_per_page(page->mapping->host));
 	return mpage_readpage(page, ext4_get_block);
 }
 
@@ -2687,6 +2689,8 @@ static int
 ext4_readpages(struct file *file, struct address_space *mapping,
 		struct list_head *pages, unsigned nr_pages)
 {
+	__ext4_io_stat(READ, EXT4_IOS_REGULAR_DATA,
+		       nr_pages * ext4_blocks_per_page(mapping->host));
 	return mpage_readpages(mapping, pages, nr_pages, ext4_get_block);
 }
 
@@ -3305,6 +3309,8 @@ int ext4_discard_partial_page_buffers_no_lock(handle_t *handle,
 			err = -EIO;
 			ll_rw_block(READ, 1, &bh);
 			wait_on_buffer(bh);
+			ext4_ios_read(bh, EXT4_IOS_REGULAR_DATA,
+				      ext4_blocks_per_page(inode));
 			/* Uhhuh. Read error. Complain and punt.*/
 			if (!buffer_uptodate(bh))
 				goto next;
-- 
1.7.4.1

