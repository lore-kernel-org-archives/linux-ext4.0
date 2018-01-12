From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [RFC PATCH 2/8] fs/buffer.c: make some functions non-static
Date: Fri, 12 Jan 2018 19:41:23 +0530
Message-ID: <20180112141129.27507-3-chandan@linux.vnet.ibm.com>
References: <20180112141129.27507-1-chandan@linux.vnet.ibm.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org, tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20180112141129.27507-1-chandan@linux.vnet.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

The functions end_buffer_async_read(), block_size_bits() and
create_page_buffers() will be needed by ext4 to implement encryption for
blocksize < pagesize scenario.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/buffer.c                 | 6 +++---
 include/linux/buffer_head.h | 4 ++++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 551b781..4360250 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -256,7 +256,7 @@ __find_get_block_slow(struct block_device *bdev, sector_t block)
  * I/O completion handler for block_read_full_page() - pages
  * which come unlocked at the end of I/O.
  */
-static void end_buffer_async_read(struct buffer_head *bh, int uptodate)
+void end_buffer_async_read(struct buffer_head *bh, int uptodate)
 {
 	unsigned long flags;
 	struct buffer_head *first;
@@ -1642,12 +1642,12 @@ EXPORT_SYMBOL(clean_bdev_aliases);
  * constraints in mind (relevant mostly if some
  * architecture has a slow bit-scan instruction)
  */
-static inline int block_size_bits(unsigned int blocksize)
+int block_size_bits(unsigned int blocksize)
 {
 	return ilog2(blocksize);
 }
 
-static struct buffer_head *create_page_buffers(struct page *page, struct inode *inode, unsigned int b_state)
+struct buffer_head *create_page_buffers(struct page *page, struct inode *inode, unsigned int b_state)
 {
 	BUG_ON(!PageLocked(page));
 
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index f1aed01..c26d16c 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -159,9 +159,13 @@ void set_bh_page(struct buffer_head *bh,
 int try_to_free_buffers(struct page *);
 struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size,
 		bool retry);
+int block_size_bits(unsigned int blocksize);
 void create_empty_buffers(struct page *, unsigned long,
 			unsigned long b_state);
+struct buffer_head *create_page_buffers(struct page *page, struct inode *inode,
+					unsigned int b_state);
 void end_buffer_read_sync(struct buffer_head *bh, int uptodate);
+void end_buffer_async_read(struct buffer_head *bh, int uptodate);
 void end_buffer_write_sync(struct buffer_head *bh, int uptodate);
 void end_buffer_async_write(struct buffer_head *bh, int uptodate);
 
-- 
2.9.5
