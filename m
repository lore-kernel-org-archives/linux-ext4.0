From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v3 6/8] ext4: account the data request of write operations in buffered io
Date: Mon, 28 Nov 2011 20:20:26 +0800
Message-ID: <1322482828-5529-6-git-send-email-wenqing.lz@taobao.com>
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
	with ESMTP id S1753589Ab1K1MSr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Nov 2011 07:18:47 -0500
In-Reply-To: <1322482828-5529-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Zheng Liu <wenqing.lz@taobao.com>

We call ext4_ios_write() function to account the data request of write in
buffered io.

CC: Jens Axboe <axboe@kernel.dk>
CC: Steven Whitehouse <swhiteho@redhat.com>
CC: Aditya Kali <adityakali@google.com>
Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/inode.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e5e9acb..3cd862d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1905,6 +1905,8 @@ static int ext4_writepage(struct page *page,
 	struct inode *inode = page->mapping->host;
 
 	trace_ext4_writepage(page);
+	ext4_ios_write(inode->i_sb, NULL, NULL, EXT4_IOS_REGULAR_DATA,
+			ext4_blocks_per_page(inode));
 	size = i_size_read(inode);
 	if (page->index == size >> PAGE_CACHE_SHIFT)
 		len = size & ~PAGE_CACHE_MASK;
@@ -2079,6 +2081,9 @@ static int write_cache_pages_da(struct address_space *mapping,
 			logical = (sector_t) page->index <<
 				(PAGE_CACHE_SHIFT - inode->i_blkbits);
 
+			ext4_ios_write(inode->i_sb, NULL, NULL,
+					EXT4_IOS_REGULAR_DATA,
+					ext4_blocks_per_page(inode));
 			if (!page_has_buffers(page)) {
 				mpage_add_bh_to_extent(mpd, logical,
 						       PAGE_CACHE_SIZE,
@@ -3449,8 +3454,11 @@ int ext4_block_zero_page_range(handle_t *handle,
 	err = 0;
 	if (ext4_should_journal_data(inode)) {
 		err = ext4_handle_dirty_metadata(handle, inode, bh);
-	} else
+	} else {
+		ext4_ios_write(inode->i_sb, handle, bh,
+				EXT4_IOS_REGULAR_DATA, 1);
 		mark_buffer_dirty(bh);
+	}
 
 unlock:
 	unlock_page(page);
-- 
1.7.4.1

