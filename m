From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v4 6/8] ext4: account the data request of write operations in buffered io
Date: Tue, 24 Jan 2012 00:50:26 +0800
Message-ID: <1327337428-8266-7-git-send-email-wenqing.lz@taobao.com>
References: <1327337428-8266-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, Jens Axboe <axboe@kernel.dk>,
	Steven Whitehouse <swhiteho@redhat.com>,
	Aditya Kali <adityakali@google.com>,
	Wang Shaoyan <wangshaoyan.pt@taobao.com>
To: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1327337428-8266-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

We call ext4_ios_write() function to account the data request of write in
buffered io.

CC: Jens Axboe <axboe@kernel.dk>
CC: Steven Whitehouse <swhiteho@redhat.com>
CC: Aditya Kali <adityakali@google.com>
Signed-off-by: Wang Shaoyan <wangshaoyan.pt@taobao.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 fs/ext4/inode.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 176977a..cfebc6d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1910,6 +1910,8 @@ static int ext4_writepage(struct page *page,
 	struct inode *inode = page->mapping->host;
 
 	trace_ext4_writepage(page);
+	ext4_ios_write(inode->i_sb, NULL, NULL, EXT4_IOS_REGULAR_DATA,
+			ext4_blocks_per_page(inode));
 	size = i_size_read(inode);
 	if (page->index == size >> PAGE_CACHE_SHIFT)
 		len = size & ~PAGE_CACHE_MASK;
@@ -2084,6 +2086,9 @@ static int write_cache_pages_da(struct address_space *mapping,
 			logical = (sector_t) page->index <<
 				(PAGE_CACHE_SHIFT - inode->i_blkbits);
 
+			ext4_ios_write(inode->i_sb, NULL, NULL,
+					EXT4_IOS_REGULAR_DATA,
+					ext4_blocks_per_page(inode));
 			if (!page_has_buffers(page)) {
 				mpage_add_bh_to_extent(mpd, logical,
 						       PAGE_CACHE_SIZE,
-- 
1.7.4.1

