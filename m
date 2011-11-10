From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2 6/8] ext4: Count data request of write operations in buffered io
Date: Thu, 10 Nov 2011 18:34:52 +0800
Message-ID: <1320921294-30321-7-git-send-email-wenqing.lz@taobao.com>
References: <1320921294-30321-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>,
	Wang Shaoyan <wangshaoyan.pt@taobao.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41237 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab1KJKeB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Nov 2011 05:34:01 -0500
In-Reply-To: <1320921294-30321-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

'Issue' flag in buffer_head doesn't be used.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
---
 fs/ext4/inode.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c584f89..e552fb2 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1907,6 +1907,8 @@ static int ext4_writepage(struct page *page,
 	struct inode *inode = page->mapping->host;
 
 	trace_ext4_writepage(page);
+	__ext4_io_stat(WRITE, EXT4_IOS_REGULAR_DATA,
+		       ext4_blocks_per_page(inode));
 	size = i_size_read(inode);
 	if (page->index == size >> PAGE_CACHE_SHIFT)
 		len = size & ~PAGE_CACHE_MASK;
@@ -2081,6 +2083,8 @@ static int write_cache_pages_da(struct address_space *mapping,
 			logical = (sector_t) page->index <<
 				(PAGE_CACHE_SHIFT - inode->i_blkbits);
 
+			__ext4_io_stat(WRITE, EXT4_IOS_REGULAR_DATA,
+				       ext4_blocks_per_page(inode));
 			if (!page_has_buffers(page)) {
 				mpage_add_bh_to_extent(mpd, logical,
 						       PAGE_CACHE_SIZE,
@@ -3454,8 +3458,10 @@ int ext4_block_zero_page_range(handle_t *handle,
 	err = 0;
 	if (ext4_should_journal_data(inode)) {
 		err = ext4_handle_dirty_metadata(handle, inode, bh);
-	} else
+	} else {
+		ext4_ios_write_one(handle, bh, EXT4_IOS_REGULAR_DATA);
 		mark_buffer_dirty(bh);
+	}
 
 unlock:
 	unlock_page(page);
-- 
1.7.4.1

