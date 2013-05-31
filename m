From: Jan Kara <jack@suse.cz>
Subject: [PATCH 11/26] ext4: Stop messing with nr_to_write in ext4_da_writepages()
Date: Fri, 31 May 2013 11:42:44 +0200
Message-ID: <1369993379-13017-12-git-send-email-jack@suse.cz>
References: <1369993379-13017-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43000 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab3EaJnM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 May 2013 05:43:12 -0400
In-Reply-To: <1369993379-13017-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Writeback code got better in how it submits IO and now the number of
pages requested to be written is usually higher than original 1024. The
number is now dynamically computed based on observed throughput and is
set to be about 0.5 s worth of writeback. E.g. on ordinary SATA drive
this ends up somewhere around 10000 as my testing shows. So remove the
unnecessary smarts from ext4_da_writepages().

Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c | 96 ---------------------------------------------------------
 1 file changed, 96 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7e60724..3eb7ad6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -423,66 +423,6 @@ static int __check_block_validity(struct inode *inode, const char *func,
 #define check_block_validity(inode, map)	\
 	__check_block_validity((inode), __func__, __LINE__, (map))
 
-/*
- * Return the number of contiguous dirty pages in a given inode
- * starting at page frame idx.
- */
-static pgoff_t ext4_num_dirty_pages(struct inode *inode, pgoff_t idx,
-				    unsigned int max_pages)
-{
-	struct address_space *mapping = inode->i_mapping;
-	pgoff_t	index;
-	struct pagevec pvec;
-	pgoff_t num = 0;
-	int i, nr_pages, done = 0;
-
-	if (max_pages == 0)
-		return 0;
-	pagevec_init(&pvec, 0);
-	while (!done) {
-		index = idx;
-		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
-					      PAGECACHE_TAG_DIRTY,
-					      (pgoff_t)PAGEVEC_SIZE);
-		if (nr_pages == 0)
-			break;
-		for (i = 0; i < nr_pages; i++) {
-			struct page *page = pvec.pages[i];
-			struct buffer_head *bh, *head;
-
-			lock_page(page);
-			if (unlikely(page->mapping != mapping) ||
-			    !PageDirty(page) ||
-			    PageWriteback(page) ||
-			    page->index != idx) {
-				done = 1;
-				unlock_page(page);
-				break;
-			}
-			if (page_has_buffers(page)) {
-				bh = head = page_buffers(page);
-				do {
-					if (!buffer_delay(bh) &&
-					    !buffer_unwritten(bh))
-						done = 1;
-					bh = bh->b_this_page;
-				} while (!done && (bh != head));
-			}
-			unlock_page(page);
-			if (done)
-				break;
-			idx++;
-			num++;
-			if (num >= max_pages) {
-				done = 1;
-				break;
-			}
-		}
-		pagevec_release(&pvec);
-	}
-	return num;
-}
-
 #ifdef ES_AGGRESSIVE_TEST
 static void ext4_map_blocks_es_recheck(handle_t *handle,
 				       struct inode *inode,
@@ -2457,10 +2397,8 @@ static int ext4_da_writepages(struct address_space *mapping,
 	struct mpage_da_data mpd;
 	struct inode *inode = mapping->host;
 	int pages_written = 0;
-	unsigned int max_pages;
 	int range_cyclic, cycled = 1, io_done = 0;
 	int needed_blocks, ret = 0;
-	long desired_nr_to_write, nr_to_writebump = 0;
 	loff_t range_start = wbc->range_start;
 	struct ext4_sb_info *sbi = EXT4_SB(mapping->host->i_sb);
 	pgoff_t done_index = 0;
@@ -2507,39 +2445,6 @@ static int ext4_da_writepages(struct address_space *mapping,
 		end = wbc->range_end >> PAGE_CACHE_SHIFT;
 	}
 
-	/*
-	 * This works around two forms of stupidity.  The first is in
-	 * the writeback code, which caps the maximum number of pages
-	 * written to be 1024 pages.  This is wrong on multiple
-	 * levels; different architectues have a different page size,
-	 * which changes the maximum amount of data which gets
-	 * written.  Secondly, 4 megabytes is way too small.  XFS
-	 * forces this value to be 16 megabytes by multiplying
-	 * nr_to_write parameter by four, and then relies on its
-	 * allocator to allocate larger extents to make them
-	 * contiguous.  Unfortunately this brings us to the second
-	 * stupidity, which is that ext4's mballoc code only allocates
-	 * at most 2048 blocks.  So we force contiguous writes up to
-	 * the number of dirty blocks in the inode, or
-	 * sbi->max_writeback_mb_bump whichever is smaller.
-	 */
-	max_pages = sbi->s_max_writeback_mb_bump << (20 - PAGE_CACHE_SHIFT);
-	if (!range_cyclic && range_whole) {
-		if (wbc->nr_to_write == LONG_MAX)
-			desired_nr_to_write = wbc->nr_to_write;
-		else
-			desired_nr_to_write = wbc->nr_to_write * 8;
-	} else
-		desired_nr_to_write = ext4_num_dirty_pages(inode, index,
-							   max_pages);
-	if (desired_nr_to_write > max_pages)
-		desired_nr_to_write = max_pages;
-
-	if (wbc->nr_to_write < desired_nr_to_write) {
-		nr_to_writebump = desired_nr_to_write - wbc->nr_to_write;
-		wbc->nr_to_write = desired_nr_to_write;
-	}
