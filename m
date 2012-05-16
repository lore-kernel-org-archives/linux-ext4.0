From: Saugata Das <saugata.das@stericsson.com>
Subject: [RFC 2/3] ext4: Context support
Date: Wed, 16 May 2012 21:00:29 +0530
Message-ID: <1337182230-11839-2-git-send-email-saugata.das@stericsson.com>
References: <1337182230-11839-1-git-send-email-saugata.das@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <arnd.bergmann@linaro.org>, <venkat@linaro.org>,
	<saugata.das@linaro.org>
To: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mmc@vger.kernel.org>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <1337182230-11839-1-git-send-email-saugata.das@stericsson.com>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Saugata Das <saugata.das@linaro.org>

On eMMC and UFS devices there is a new feature of setting context with
each read or write. The idea is to classify the data from different files
and apply the realibility on the complete file instead of individual writes.
On ext4 file system, the inode number of the file is passed as b_context
in the bh structure during write and via the get_context callback function
during read. Since number of MMC contexts is limited, multiple file system
contexts are mapped to single MMC context.

Signed-off-by: Saugata Das <saugata.das@linaro.org>
---
 fs/ext4/inode.c   |   33 +++++++++++++++++++++++++++++++++
 fs/ext4/page-io.c |    1 +
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 754fe77..2667396 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -790,6 +790,21 @@ static int do_journal_get_write_access(handle_t *handle,
 	return ret;
 }
 
+/* Get the context of the buffer within the underlying storage device */
+static int ext4_get_context(struct page *page)
+{
+	if (page && page->mapping && page->mapping->host)
+		return page->mapping->host->i_ino;
+	else
+		return 0;
+}
+
+static int ext4_set_buffer_context(handle_t *handle, struct buffer_head *bh)
+{
+	bh->b_context = ext4_get_context(bh->b_page);
+	return 0;
+}
+
 static int ext4_get_block_write(struct inode *inode, sector_t iblock,
 		   struct buffer_head *bh_result, int create);
 static int ext4_write_begin(struct file *file, struct address_space *mapping,
@@ -843,6 +858,11 @@ retry:
 				from, to, NULL, do_journal_get_write_access);
 	}
 
+	if (!ret && walk_page_buffers(NULL, page_buffers(page),
+				from, to, NULL, ext4_set_buffer_context)) {
+		ext4_warning(inode->i_sb, "Couldn't set context\n");
+	}
+
 	if (ret) {
 		unlock_page(page);
 		page_cache_release(page);
@@ -2394,8 +2414,11 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 	pgoff_t index;
 	struct inode *inode = mapping->host;
 	handle_t *handle;
+	unsigned from, to;
 
 	index = pos >> PAGE_CACHE_SHIFT;
+	from = pos & (PAGE_CACHE_SIZE - 1);
+	to = from + len;
 
 	if (ext4_nonda_switch(inode->i_sb)) {
 		*fsdata = (void *)FALL_BACK_TO_NONDELALLOC;
@@ -2444,6 +2467,12 @@ retry:
 
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
+
+	if (walk_page_buffers(NULL, page_buffers(page),
+			from, to, NULL, ext4_set_buffer_context)) {
+		ext4_warning(inode->i_sb, "Couldn't set context\n");
+	}
+
 out:
 	return ret;
 }
@@ -3040,6 +3069,7 @@ static const struct address_space_operations ext4_ordered_aops = {
 	.migratepage		= buffer_migrate_page,
 	.is_partially_uptodate  = block_is_partially_uptodate,
 	.error_remove_page	= generic_error_remove_page,
+	.get_context		= ext4_get_context,
 };
 
 static const struct address_space_operations ext4_writeback_aops = {
@@ -3055,6 +3085,7 @@ static const struct address_space_operations ext4_writeback_aops = {
 	.migratepage		= buffer_migrate_page,
 	.is_partially_uptodate  = block_is_partially_uptodate,
 	.error_remove_page	= generic_error_remove_page,
+	.get_context		= ext4_get_context,
 };
 
 static const struct address_space_operations ext4_journalled_aops = {
@@ -3070,6 +3101,7 @@ static const struct address_space_operations ext4_journalled_aops = {
 	.direct_IO		= ext4_direct_IO,
 	.is_partially_uptodate  = block_is_partially_uptodate,
 	.error_remove_page	= generic_error_remove_page,
+	.get_context		= ext4_get_context,
 };
 
 static const struct address_space_operations ext4_da_aops = {
@@ -3086,6 +3118,7 @@ static const struct address_space_operations ext4_da_aops = {
 	.migratepage		= buffer_migrate_page,
 	.is_partially_uptodate  = block_is_partially_uptodate,
 	.error_remove_page	= generic_error_remove_page,
+	.get_context		= ext4_get_context,
 };
 
 void ext4_set_aops(struct inode *inode)
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index dcdeef1..bf1381e 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -296,6 +296,7 @@ static int io_submit_init(struct ext4_io_submit *io,
 	bio = bio_alloc(GFP_NOIO, min(nvecs, BIO_MAX_PAGES));
 	bio->bi_sector = bh->b_blocknr * (bh->b_size >> 9);
 	bio->bi_bdev = bh->b_bdev;
+	bio->bi_context = bh->b_context;
 	bio->bi_private = io->io_end = io_end;
 	bio->bi_end_io = ext4_end_bio;
 
-- 
1.7.4.3

