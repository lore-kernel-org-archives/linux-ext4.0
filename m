From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 03/15] ext4: implement invalidatepage_range aop
Date: Fri, 27 Jul 2012 10:01:02 +0200
Message-ID: <1343376074-28034-4-git-send-email-lczerner@redhat.com>
References: <1343376074-28034-1-git-send-email-lczerner@redhat.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, hughd@google.com,
	linux-mmc@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1343376074-28034-1-git-send-email-lczerner@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

mm now supports invalidatepage_range address space operation which is
useful to allow truncating page range which is not aligned to the end of
the page. This will help in punch hole implementation once
truncate_inode_pages_range() is modify to allow this as well.

With this commit ext4 now register only invalidatepage_range. Also
change the respective tracepoint to print length of the range.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/inode.c             |   58 ++++++++++++++++++++++++++++++------------
 include/trace/events/ext4.h |   13 ++++++---
 2 files changed, 49 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 02bc8cb..1b8c317 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -131,7 +131,8 @@ static inline int ext4_begin_ordered_truncate(struct inode *inode,
 						   new_size);
 }
 
-static void ext4_invalidatepage(struct page *page, unsigned long offset);
+static void ext4_invalidatepage_range(struct page *page, unsigned long offset,
+				      unsigned long length);
 static int noalloc_get_block_write(struct inode *inode, sector_t iblock,
 				   struct buffer_head *bh_result, int create);
 static int ext4_set_bh_endio(struct buffer_head *bh, struct inode *inode);
@@ -1262,20 +1263,28 @@ static void ext4_da_release_space(struct inode *inode, int to_free)
 }
 
 static void ext4_da_page_release_reservation(struct page *page,
-					     unsigned long offset)
+					     unsigned long offset,
+					     unsigned long length)
 {
 	int to_release = 0;
 	struct buffer_head *head, *bh;
 	unsigned int curr_off = 0;
 	struct inode *inode = page->mapping->host;
 	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	unsigned long stop = offset + length;
 	int num_clusters;
 
+	if (stop < length)
+		stop = PAGE_CACHE_SIZE;
+
 	head = page_buffers(page);
 	bh = head;
 	do {
 		unsigned int next_off = curr_off + bh->b_size;
 
+		if (next_off > stop)
+			break;
+
 		if ((offset <= curr_off) && (buffer_delay(bh))) {
 			to_release++;
 			clear_buffer_delay(bh);
@@ -2608,7 +2617,9 @@ static int ext4_da_write_end(struct file *file,
 	return ret ? ret : copied;
 }
 
-static void ext4_da_invalidatepage(struct page *page, unsigned long offset)
+static void ext4_da_invalidatepage_range(struct page *page,
+					 unsigned long offset,
+					 unsigned long length)
 {
 	/*
 	 * Drop reserved blocks
@@ -2617,10 +2628,10 @@ static void ext4_da_invalidatepage(struct page *page, unsigned long offset)
 	if (!page_has_buffers(page))
 		goto out;
 
-	ext4_da_page_release_reservation(page, offset);
+	ext4_da_page_release_reservation(page, offset, length);
 
 out:
-	ext4_invalidatepage(page, offset);
+	ext4_invalidatepage_range(page, offset, length);
 
 	return;
 }
@@ -2746,47 +2757,60 @@ ext4_readpages(struct file *file, struct address_space *mapping,
 	return mpage_readpages(mapping, pages, nr_pages, ext4_get_block);
 }
 
-static void ext4_invalidatepage_free_endio(struct page *page, unsigned long offset)
+static void ext4_invalidatepage_free_endio(struct page *page,
+					   unsigned long offset,
+					   unsigned long length)
 {
 	struct buffer_head *head, *bh;
 	unsigned int curr_off = 0;
+	unsigned long stop = offset + length;
 
 	if (!page_has_buffers(page))
 		return;
+	if (stop < length)
+		stop = PAGE_CACHE_SIZE;
+
 	head = bh = page_buffers(page);
 	do {
+		unsigned int next_off = curr_off + bh->b_size;
+
+		if (next_off > stop)
+			return;
+
 		if (offset <= curr_off && test_clear_buffer_uninit(bh)
 					&& bh->b_private) {
 			ext4_free_io_end(bh->b_private);
 			bh->b_private = NULL;
 			bh->b_end_io = NULL;
 		}
-		curr_off = curr_off + bh->b_size;
+		curr_off = next_off;
 		bh = bh->b_this_page;
 	} while (bh != head);
 }
 
-static void ext4_invalidatepage(struct page *page, unsigned long offset)
+static void ext4_invalidatepage_range(struct page *page, unsigned long offset,
+				      unsigned long length)
 {
 	journal_t *journal = EXT4_JOURNAL(page->mapping->host);
 
-	trace_ext4_invalidatepage(page, offset);
+	trace_ext4_invalidatepage_range(page, offset, length);
 
 	/*
 	 * free any io_end structure allocated for buffers to be discarded
 	 */
 	if (ext4_should_dioread_nolock(page->mapping->host))
-		ext4_invalidatepage_free_endio(page, offset);
+		ext4_invalidatepage_free_endio(page, offset, length);
 	/*
 	 * If it's a full truncate we just forget about the pending dirtying
 	 */
-	if (offset == 0)
+	if (offset == 0 && length >= PAGE_CACHE_SIZE)
 		ClearPageChecked(page);
 
 	if (journal)
-		jbd2_journal_invalidatepage(journal, page, offset);
+		jbd2_journal_invalidatepage_range(journal, page,
+						  offset, length);
 	else
-		block_invalidatepage(page, offset);
+		block_invalidatepage_range(page, offset, length);
 }
 
 static int ext4_releasepage(struct page *page, gfp_t wait)
@@ -3101,7 +3125,7 @@ static const struct address_space_operations ext4_ordered_aops = {
 	.write_begin		= ext4_write_begin,
 	.write_end		= ext4_ordered_write_end,
 	.bmap			= ext4_bmap,
-	.invalidatepage		= ext4_invalidatepage,
+	.invalidatepage_range	= ext4_invalidatepage_range,
 	.releasepage		= ext4_releasepage,
 	.direct_IO		= ext4_direct_IO,
 	.migratepage		= buffer_migrate_page,
@@ -3116,7 +3140,7 @@ static const struct address_space_operations ext4_writeback_aops = {
 	.write_begin		= ext4_write_begin,
 	.write_end		= ext4_writeback_write_end,
 	.bmap			= ext4_bmap,
-	.invalidatepage		= ext4_invalidatepage,
+	.invalidatepage_range	= ext4_invalidatepage_range,
 	.releasepage		= ext4_releasepage,
 	.direct_IO		= ext4_direct_IO,
 	.migratepage		= buffer_migrate_page,
@@ -3132,7 +3156,7 @@ static const struct address_space_operations ext4_journalled_aops = {
 	.write_end		= ext4_journalled_write_end,
 	.set_page_dirty		= ext4_journalled_set_page_dirty,
 	.bmap			= ext4_bmap,
-	.invalidatepage		= ext4_invalidatepage,
+	.invalidatepage_range	= ext4_invalidatepage_range,
 	.releasepage		= ext4_releasepage,
 	.direct_IO		= ext4_direct_IO,
 	.is_partially_uptodate  = block_is_partially_uptodate,
@@ -3147,7 +3171,7 @@ static const struct address_space_operations ext4_da_aops = {
 	.write_begin		= ext4_da_write_begin,
 	.write_end		= ext4_da_write_end,
 	.bmap			= ext4_bmap,
-	.invalidatepage		= ext4_da_invalidatepage,
+	.invalidatepage_range	= ext4_da_invalidatepage_range,
 	.releasepage		= ext4_releasepage,
 	.direct_IO		= ext4_direct_IO,
 	.migratepage		= buffer_migrate_page,
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 69d8a69..30bae72 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -450,14 +450,15 @@ DEFINE_EVENT(ext4__page_op, ext4_releasepage,
 	TP_ARGS(page)
 );
 
-TRACE_EVENT(ext4_invalidatepage,
-	TP_PROTO(struct page *page, unsigned long offset),
+TRACE_EVENT(ext4_invalidatepage_range,
+	TP_PROTO(struct page *page, unsigned long offset, unsigned long length),
 
-	TP_ARGS(page, offset),
+	TP_ARGS(page, offset, length),
 
 	TP_STRUCT__entry(
 		__field(	pgoff_t, index			)
 		__field(	unsigned long, offset		)
+		__field(	unsigned long, length		)
 		__field(	ino_t,	ino			)
 		__field(	dev_t,	dev			)
 
@@ -466,14 +467,16 @@ TRACE_EVENT(ext4_invalidatepage,
 	TP_fast_assign(
 		__entry->index	= page->index;
 		__entry->offset	= offset;
+		__entry->length	= length;
 		__entry->ino	= page->mapping->host->i_ino;
 		__entry->dev	= page->mapping->host->i_sb->s_dev;
 	),
 
-	TP_printk("dev %d,%d ino %lu page_index %lu offset %lu",
+	TP_printk("dev %d,%d ino %lu page_index %lu offset %lu length %lu",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  (unsigned long) __entry->ino,
-		  (unsigned long) __entry->index, __entry->offset)
+		  (unsigned long) __entry->index,
+		  __entry->offset, __entry->length)
 );
 
 TRACE_EVENT(ext4_discard_blocks,
-- 
1.7.7.6

