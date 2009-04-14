From: Chris Mason <chris.mason@oracle.com>
Subject: [PATCH 1/2] Add block_write_full_page_endio for passing endio
 handler
Date: Tue, 14 Apr 2009 16:59:13 -0400
Message-ID: <1239742754.28321.41.camel@think.oraclecorp.com>
References: <1239742633.28321.39.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:44484 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbZDNVA1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Apr 2009 17:00:27 -0400
In-Reply-To: <1239742633.28321.39.camel@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


block_write_full_page doesn't allow the caller to control what happens
when the IO is over.  This adds a new call named block_write_full_page_endio
so the buffer head end_io handler can be provided by the caller.

This will be used by the ext3 data=guarded mode to do i_size updates
in a workqueue based end_io handler.  end_buffer_async_write is also
exported so it can be called to do the dirty work of managing
page writeback for the higher level end_io handler.

Signed-off-by: Chris Mason <chris.mason@oracle.com>

---
 fs/buffer.c                 |   45 ++++++++++++++++++++++++++++++++----------
 include/linux/buffer_head.h |    3 ++
 2 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 13edf7a..308865b 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -360,7 +360,7 @@ still_busy:
  * Completion handler for block_write_full_page() - pages which are unlocked
  * during I/O, and which have PageWriteback cleared upon I/O completion.
  */
-static void end_buffer_async_write(struct buffer_head *bh, int uptodate)
+void end_buffer_async_write(struct buffer_head *bh, int uptodate)
 {
 	char b[BDEVNAME_SIZE];
 	unsigned long flags;
@@ -438,11 +438,17 @@ static void mark_buffer_async_read(struct buffer_head *bh)
 	set_buffer_async_read(bh);
 }
 
-void mark_buffer_async_write(struct buffer_head *bh)
+void mark_buffer_async_write_endio(struct buffer_head *bh,
+				   bh_end_io_t *handler)
 {
-	bh->b_end_io = end_buffer_async_write;
+	bh->b_end_io = handler;
 	set_buffer_async_write(bh);
 }
+
+void mark_buffer_async_write(struct buffer_head *bh)
+{
+	mark_buffer_async_write_endio(bh, end_buffer_async_write);
+}
 EXPORT_SYMBOL(mark_buffer_async_write);
 
 
@@ -1608,7 +1614,8 @@ EXPORT_SYMBOL(unmap_underlying_metadata);
  * unplugging the device queue.
  */
 static int __block_write_full_page(struct inode *inode, struct page *page,
-			get_block_t *get_block, struct writeback_control *wbc)
+			get_block_t *get_block, struct writeback_control *wbc,
+			bh_end_io_t *handler)
 {
 	int err;
 	sector_t block;
@@ -1693,7 +1700,7 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 			continue;
 		}
 		if (test_clear_buffer_dirty(bh)) {
-			mark_buffer_async_write(bh);
+			mark_buffer_async_write_endio(bh, handler);
 		} else {
 			unlock_buffer(bh);
 		}
@@ -1746,7 +1753,7 @@ recover:
 		if (buffer_mapped(bh) && buffer_dirty(bh) &&
 		    !buffer_delay(bh)) {
 			lock_buffer(bh);
-			mark_buffer_async_write(bh);
+			mark_buffer_async_write_endio(bh, handler);
 		} else {
 			/*
 			 * The buffer may have been set dirty during
@@ -2672,7 +2679,8 @@ int nobh_writepage(struct page *page, get_block_t *get_block,
 out:
 	ret = mpage_writepage(page, get_block, wbc);
 	if (ret == -EAGAIN)
-		ret = __block_write_full_page(inode, page, get_block, wbc);
+		ret = __block_write_full_page(inode, page, get_block, wbc,
+					      end_buffer_async_write);
 	return ret;
 }
 EXPORT_SYMBOL(nobh_writepage);
@@ -2830,9 +2838,10 @@ out:
 
 /*
  * The generic ->writepage function for buffer-backed address_spaces
+ * this form passes in the end_io handler used to finish the IO.
  */
-int block_write_full_page(struct page *page, get_block_t *get_block,
-			struct writeback_control *wbc)
+int block_write_full_page_endio(struct page *page, get_block_t *get_block,
+			struct writeback_control *wbc, bh_end_io_t *handler)
 {
 	struct inode * const inode = page->mapping->host;
 	loff_t i_size = i_size_read(inode);
@@ -2841,7 +2850,8 @@ int block_write_full_page(struct page *page, get_block_t *get_block,
 
 	/* Is the page fully inside i_size? */
 	if (page->index < end_index)
-		return __block_write_full_page(inode, page, get_block, wbc);
+		return __block_write_full_page(inode, page, get_block, wbc,
+					       handler);
 
 	/* Is the page fully outside i_size? (truncate in progress) */
 	offset = i_size & (PAGE_CACHE_SIZE-1);
@@ -2864,9 +2874,20 @@ int block_write_full_page(struct page *page, get_block_t *get_block,
 	 * writes to that region are not written out to the file."
 	 */
 	zero_user_segment(page, offset, PAGE_CACHE_SIZE);
-	return __block_write_full_page(inode, page, get_block, wbc);
+	return __block_write_full_page(inode, page, get_block, wbc, handler);
 }
 
+/*
+ * The generic ->writepage function for buffer-backed address_spaces
+ */
+int block_write_full_page(struct page *page, get_block_t *get_block,
+			struct writeback_control *wbc)
+{
+	return block_write_full_page_endio(page, get_block, wbc,
+					   end_buffer_async_write);
+}
+
+
 sector_t generic_block_bmap(struct address_space *mapping, sector_t block,
 			    get_block_t *get_block)
 {
@@ -3335,9 +3356,11 @@ EXPORT_SYMBOL(block_read_full_page);
 EXPORT_SYMBOL(block_sync_page);
 EXPORT_SYMBOL(block_truncate_page);
 EXPORT_SYMBOL(block_write_full_page);
+EXPORT_SYMBOL(block_write_full_page_endio);
 EXPORT_SYMBOL(cont_write_begin);
 EXPORT_SYMBOL(end_buffer_read_sync);
 EXPORT_SYMBOL(end_buffer_write_sync);
+EXPORT_SYMBOL(end_buffer_async_write);
 EXPORT_SYMBOL(file_fsync);
 EXPORT_SYMBOL(generic_block_bmap);
 EXPORT_SYMBOL(generic_cont_expand_simple);
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 7b73bb8..16ed028 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -155,6 +155,7 @@ void create_empty_buffers(struct page *, unsigned long,
 			unsigned long b_state);
 void end_buffer_read_sync(struct buffer_head *bh, int uptodate);
 void end_buffer_write_sync(struct buffer_head *bh, int uptodate);
+void end_buffer_async_write(struct buffer_head *bh, int uptodate);
 
 /* Things to do with buffers at mapping->private_list */
 void mark_buffer_dirty_inode(struct buffer_head *bh, struct inode *inode);
@@ -197,6 +198,8 @@ extern int buffer_heads_over_limit;
 void block_invalidatepage(struct page *page, unsigned long offset);
 int block_write_full_page(struct page *page, get_block_t *get_block,
 				struct writeback_control *wbc);
+int block_write_full_page_endio(struct page *page, get_block_t *get_block,
+			struct writeback_control *wbc, bh_end_io_t *handler);
 int block_read_full_page(struct page*, get_block_t*);
 int block_is_partially_uptodate(struct page *page, read_descriptor_t *desc,
 				unsigned long from);



