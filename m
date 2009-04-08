From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [GIT PULL] Ext3 latency fixes
Date: Wed, 08 Apr 2009 19:40:05 -0400
Message-ID: <E1LrhNF-0002zd-BG@closure.thunk.org>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: torvalds@linuxfoundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:55097 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155AbZDHXkN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 8 Apr 2009 19:40:13 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Linus,

Please pull from: 

git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git ext3-latency-fixes

One of these patches fixes a performance regression caused by a64c8610,
which unplugged the write queue after every page write.  Now that Jens
added WRITE_SYNC_PLUG.the patch causes us to use it instead of
WRITE_SYNC, to avoid the implicit unplugging.  These patches also seem
to further improbve ext3 latency, especially during the "sync" command
in Linus's write-big-file-and-sync workload.

In addition, I have a patch from Jan that avoids starting a transaction
unnecessarily for the data=writepage case.

						- Ted

Jan Kara (1):
      ext3: Try to avoid starting a transaction in writepage for data=writepage

Theodore Ts'o (1):
      block_write_full_page: switch synchronous writes to use WRITE_SYNC_PLUG

 fs/buffer.c     |   13 ++++++++++++-
 fs/ext3/inode.c |   23 ++++++++++++++++++-----
 2 files changed, 30 insertions(+), 6 deletions(-)


commit 430db323fae7665da721768949ade6304811c648
Author: Jan Kara <jack@suse.cz>
Date:   Tue Apr 7 18:25:01 2009 -0400

    ext3: Try to avoid starting a transaction in writepage for data=writepage
    
    This does the same as commit 9e80d407736161d9b8b0c5a0d44f786e44c322ea
    (avoid starting a transaction when no block allocation is needed)
    but for data=writeback mode of ext3. We also cleanup the data=ordered
    case a bit to stick to coding style...
    
    Signed-off-by: Jan Kara <jack@suse.cz>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 466a332..fcfa243 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -1521,12 +1521,16 @@ static int ext3_ordered_writepage(struct page *page,
 	if (!page_has_buffers(page)) {
 		create_empty_buffers(page, inode->i_sb->s_blocksize,
 				(1 << BH_Dirty)|(1 << BH_Uptodate));
-	} else if (!walk_page_buffers(NULL, page_buffers(page), 0, PAGE_CACHE_SIZE, NULL, buffer_unmapped)) {
-		/* Provide NULL instead of get_block so that we catch bugs if buffers weren't really mapped */
-		return block_write_full_page(page, NULL, wbc);
+		page_bufs = page_buffers(page);
+	} else {
+		page_bufs = page_buffers(page);
+		if (!walk_page_buffers(NULL, page_bufs, 0, PAGE_CACHE_SIZE,
+				       NULL, buffer_unmapped)) {
+			/* Provide NULL get_block() to catch bugs if buffers
+			 * weren't really mapped */
+			return block_write_full_page(page, NULL, wbc);
+		}
 	}
-	page_bufs = page_buffers(page);
-
 	handle = ext3_journal_start(inode, ext3_writepage_trans_blocks(inode));
 
 	if (IS_ERR(handle)) {
@@ -1581,6 +1585,15 @@ static int ext3_writeback_writepage(struct page *page,
 	if (ext3_journal_current_handle())
 		goto out_fail;
 
+	if (page_has_buffers(page)) {
+		if (!walk_page_buffers(NULL, page_buffers(page), 0,
+				      PAGE_CACHE_SIZE, NULL, buffer_unmapped)) {
+			/* Provide NULL get_block() to catch bugs if buffers
+			 * weren't really mapped */
+			return block_write_full_page(page, NULL, wbc);
+		}
+	}
+
 	handle = ext3_journal_start(inode, ext3_writepage_trans_blocks(inode));
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);

commit 6e34eeddf7deec1444bbddab533f03f520d8458c
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Tue Apr 7 18:12:43 2009 -0400

    block_write_full_page: switch synchronous writes to use WRITE_SYNC_PLUG
    
    Now that we have a distinction between WRITE_SYNC and WRITE_SYNC_PLUG,
    use WRITE_SYNC_PLUG in __block_write_full_page() to avoid unplugging
    the block device I/O queue between each page that gets flushed out.
    
    Otherwise, when we run sync() or fsync() and we need to write out a
    large number of pages, the block device queue will get unplugged
    between for every page that is flushed out, which will be a pretty
    serious performance regression caused by commit a64c8610.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/buffer.c b/fs/buffer.c
index 6e35762..13edf7a 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1596,6 +1596,16 @@ EXPORT_SYMBOL(unmap_underlying_metadata);
  * locked buffer.   This only can happen if someone has written the buffer
  * directly, with submit_bh().  At the address_space level PageWriteback
  * prevents this contention from occurring.
+ *
+ * If block_write_full_page() is called with wbc->sync_mode ==
+ * WB_SYNC_ALL, the writes are posted using WRITE_SYNC_PLUG; this
+ * causes the writes to be flagged as synchronous writes, but the
+ * block device queue will NOT be unplugged, since usually many pages
+ * will be pushed to the out before the higher-level caller actually
+ * waits for the writes to be completed.  The various wait functions,
+ * such as wait_on_writeback_range() will ultimately call sync_page()
+ * which will ultimately call blk_run_backing_dev(), which will end up
+ * unplugging the device queue.
  */
 static int __block_write_full_page(struct inode *inode, struct page *page,
 			get_block_t *get_block, struct writeback_control *wbc)
@@ -1606,7 +1616,8 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 	struct buffer_head *bh, *head;
 	const unsigned blocksize = 1 << inode->i_blkbits;
 	int nr_underway = 0;
-	int write_op = (wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE);
+	int write_op = (wbc->sync_mode == WB_SYNC_ALL ?
+			WRITE_SYNC_PLUG : WRITE);
 
 	BUG_ON(!PageLocked(page));
 
