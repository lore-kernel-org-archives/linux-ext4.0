From: Tao Ma <tm@tao.ma>
Subject: [PATCH V1 06/17] ext4: Add delalloc support for inline data.
Date: Wed, 26 Oct 2011 15:34:17 +0800
Message-ID: <1319614468-11227-6-git-send-email-tm@tao.ma>
References: <4EA7B788.3040503@tao.ma>
 <1319614468-11227-1-git-send-email-tm@tao.ma>
Cc: tytso@mit.edu, linux-kernel@vger.kernel.org, adilger@dilger.ca
To: linux-ext4@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1319614468-11227-1-git-send-email-tm@tao.ma>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

For delayed allocation mode, we write to inline data if the file
is small enough. And in case of we write to some offset larger
than the inline size, the 1st page is dirtied, so that
ext4_da_writepages can handle the conversion. When the 1st page
is initialized with blocks, the inline part is removed.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 fs/ext4/inode.c |  204 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 198 insertions(+), 6 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index bbd4b3c..a7da980 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2121,7 +2121,8 @@ static int ext4_da_writepages_trans_blocks(struct inode *inode)
  * mpage_da_map_and_submit to map a single contiguous memory region
  * and then write them.
  */
-static int write_cache_pages_da(struct address_space *mapping,
+static int write_cache_pages_da(handle_t *handle,
+				struct address_space *mapping,
 				struct writeback_control *wbc,
 				struct mpage_da_data *mpd,
 				pgoff_t *done_index)
@@ -2200,6 +2201,14 @@ static int write_cache_pages_da(struct address_space *mapping,
 			wait_on_page_writeback(page);
 			BUG_ON(PageWriteback(page));
 
+			/*
+			 * If we have inline data and arrive here, it means that
+			 * we will soon create the block for the 1st page, so
+			 * we'd better clear the inline data here.
+			 */
+			if (!page->index && ext4_has_inline_data(inode))
+				ext4_destroy_inline_data(handle, inode);
+
 			if (mpd->next_page != page->index)
 				mpd->first_page = page->index;
 			mpd->next_page = page->index + 1;
@@ -2403,7 +2412,8 @@ retry:
 		 * contiguous region of logical blocks that need
 		 * blocks to be allocated by ext4 and submit them.
 		 */
-		ret = write_cache_pages_da(mapping, wbc, &mpd, &done_index);
+		ret = write_cache_pages_da(handle, mapping,
+					   wbc, &mpd, &done_index);
 		/*
 		 * If we have a contiguous extent of pages and we
 		 * haven't done the I/O yet, map the blocks and submit
@@ -2466,6 +2476,7 @@ out_writepages:
 }
 
 #define FALL_BACK_TO_NONDELALLOC 1
+#define CONVERT_INLINE_DATA	 2
 static int ext4_nonda_switch(struct super_block *sb)
 {
 	s64 free_blocks, dirty_blocks;
@@ -2499,6 +2510,135 @@ static int ext4_nonda_switch(struct super_block *sb)
 	return 0;
 }
 
+/*
+ * Try to make the page cache and handle ready for the inline data case.
+ * We can call this function in 2 cases:
+ * 1. The inode is created and the first write exceeds inine size. We can
+ *    clear the inode state safely.
+ * 2. The inode has inline data, then we need to read the data, make it
+ *    update and dirty so that ext4_da_writepages can handle it. We don't
+ *    need to start the journal since the file's metatdata isn't changed now.
+ */
+static int ext4_da_convert_inline_data_to_extent(struct address_space *mapping,
+						 struct inode *inode,
+						 unsigned flags,
+						 void **fsdata)
+{
+	int ret, inline_size;
+	struct page *page;
+
+	if (!ext4_has_inline_data(inode)) {
+		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+		return 0;
+	}
+
+	inline_size = ext4_get_max_inline_size(inode);
+
+	page = grab_cache_page_write_begin(mapping, 0, flags);
+	if (!page)
+		return -ENOMEM;
+
+	if (!PageUptodate(page)) {
+		ret = ext4_read_inline_page(inode, page);
+		if (ret)
+			goto out;
+	}
+
+	ret = __block_write_begin(page, 0, inline_size,
+				  ext4_da_get_block_prep);
+	if (ret) {
+		ext4_truncate_failed_write(inode);
+		goto out;
+	}
+
+	SetPageDirty(page);
+	SetPageUptodate(page);
+	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+	*fsdata = (void *)CONVERT_INLINE_DATA;
+
+out:
+	unlock_page(page);
+	page_cache_release(page);
+	return ret;
+}
+/*
+ * Prepare the write for the inline data.
+ * If the the data can be written into the inode, we just read
+ * the page and make it uptodate, and start the journal.
+ * Otherwise read the page, makes it dirty so that it can be
+ * handle in writepages(the i_disksize update is left to the
+ * normal ext4_da_write_end.
+ */
+static int ext4_da_write_inline_data_begin(struct address_space *mapping,
+					   struct inode *inode,
+					   loff_t pos, unsigned len,
+					   unsigned flags,
+					   struct page **pagep,
+					   void **fsdata)
+{
+	int ret, inline_size;
+	handle_t *handle;
+	struct page *page;
+	struct ext4_iloc iloc;
+
+	ret = ext4_get_inode_loc(inode, &iloc);
+	if (ret)
+		return ret;
+
+	inline_size = ext4_get_max_inline_size(inode);
+
+	if (pos + len > inline_size)
+		return ext4_da_convert_inline_data_to_extent(mapping,
+							     inode, flags,
+							     fsdata);
+
+	handle = ext4_journal_start(inode, 1);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		handle = NULL;
+		goto out;
+	}
+
+	if (!ext4_has_inline_data(inode)) {
+		ret = ext4_init_inline_data(handle, inode, &iloc);
+		if (ret && ret != -ENOSPC)
+			goto out;
+
+		if (ret == -ENOSPC) {
+			ret = 0;
+			goto out;
+		}
+	}
+
+	/*
+	 * We cannot recurse into the filesystem as the transaction
+	 * is already started.
+	 */
+	flags |= AOP_FLAG_NOFS;
+
+	page = grab_cache_page_write_begin(mapping, 0, flags);
+	if (!page) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	*pagep = page;
+
+	if (!PageUptodate(page)) {
+		ret = ext4_read_inline_page(inode, page);
+		if (ret)
+			goto out;
+	}
+
+	ret = 1;
+	handle = NULL;
+out:
+	if (handle)
+		ext4_journal_stop(handle);
+	brelse(iloc.bh);
+	return ret;
+}
+
 static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 			       loff_t pos, unsigned len, unsigned flags,
 			       struct page **pagep, void **fsdata)
@@ -2518,6 +2658,19 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 	}
 	*fsdata = (void *)0;
 	trace_ext4_da_write_begin(inode, pos, len, flags);
+
+	if (ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA)) {
+		ret = ext4_da_write_inline_data_begin(mapping, inode,
+						      pos, len, flags,
+						      pagep, fsdata);
+		if (ret < 0)
+			goto out;
+		if (ret == 1) {
+			ret = 0;
+			goto out;
+		}
+	}
+
 retry:
 	/*
 	 * With delayed allocation, we don't log the i_disksize update
@@ -2585,6 +2738,41 @@ static int ext4_da_should_update_i_disksize(struct page *page,
 	return 1;
 }
 
+static int ext4_da_write_inline_data_end(struct inode *inode, loff_t pos,
+					 unsigned len, unsigned copied,
+					 struct page *page)
+{
+	int i_size_changed = 0;
+
+	copied = ext4_write_inline_data_end(inode, pos, len, copied, page);
+
+	/*
+	 * No need to use i_size_read() here, the i_size
+	 * cannot change under us because we hold i_mutex.
+	 *
+	 * But it's important to update i_size while still holding page lock:
+	 * page writeout could otherwise come in and zero beyond i_size.
+	 */
+	if (pos+copied > inode->i_size) {
+		i_size_write(inode, pos+copied);
+		i_size_changed = 1;
+	}
+
+	unlock_page(page);
+	page_cache_release(page);
+
+	/*
+	 * Don't mark the inode dirty under page lock. First, it unnecessarily
+	 * makes the holding time of page lock longer. Second, it forces lock
+	 * ordering of page lock and transaction start for journaling
+	 * filesystems.
+	 */
+	if (i_size_changed)
+		mark_inode_dirty(inode);
+
+	return copied;
+}
+
 static int ext4_da_write_end(struct file *file,
 			     struct address_space *mapping,
 			     loff_t pos, unsigned len, unsigned copied,
@@ -2618,10 +2806,10 @@ static int ext4_da_write_end(struct file *file,
 	 * changes.  So let's piggyback the i_disksize mark_inode_dirty
 	 * into that.
 	 */
-
 	new_i_size = pos + copied;
 	if (new_i_size > EXT4_I(inode)->i_disksize) {
-		if (ext4_da_should_update_i_disksize(page, end)) {
+		if (ext4_has_inline_data(inode) ||
+		    ext4_da_should_update_i_disksize(page, end)) {
 			down_write(&EXT4_I(inode)->i_data_sem);
 			if (new_i_size > EXT4_I(inode)->i_disksize) {
 				/*
@@ -2642,8 +2830,12 @@ static int ext4_da_write_end(struct file *file,
 			ext4_mark_inode_dirty(handle, inode);
 		}
 	}
-	ret2 = generic_write_end(file, mapping, pos, len, copied,
-							page, fsdata);
+	if (write_mode != CONVERT_INLINE_DATA && ext4_has_inline_data(inode))
+		ret2 = ext4_da_write_inline_data_end(inode, pos, len, copied,
+						     page);
+	else
+		ret2 = generic_write_end(file, mapping, pos, len, copied,
+					 page, fsdata);
 	copied = ret2;
 	if (ret2 < 0)
 		ret = ret2;
-- 
1.7.0.4
