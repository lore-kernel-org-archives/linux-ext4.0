From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Fix delalloc sync hang with journal lock inversion
Date: Fri,  6 Jun 2008 23:54:52 +0530
Message-ID: <1212776693-435-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1212776693-435-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1212776693-435-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1212776693-435-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1212776693-435-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1212776693-435-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1212776693-435-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Jan Kara <jack@suse.cz>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:34685 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393AbYFFSZo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 6 Jun 2008 14:25:44 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m56IOvpW025553
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jun 2008 04:24:57 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m56ITr0l283852
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jun 2008 04:29:53 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m56IPgis031859
	for <linux-ext4@vger.kernel.org>; Sat, 7 Jun 2008 04:25:42 +1000
In-Reply-To: <1212776693-435-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/inode.c |  107 ++++++++++++++++++++++++++++++++++++------------------
 fs/mpage.c      |   12 +++----
 2 files changed, 76 insertions(+), 43 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 0f8d071..b5bc627 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1480,50 +1480,74 @@ static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
 			up_write(&EXT4_I(inode)->i_data_sem);
 
 			if (EXT4_I(inode)->i_disksize == disksize) {
-				if (handle == NULL)
-					handle = ext4_journal_start(inode, 1);
-				if (!IS_ERR(handle))
-					ext4_mark_inode_dirty(handle, inode);
+				ret = ext4_mark_inode_dirty(handle, inode);
+				return ret;
 			}
 		}
-
 		ret = 0;
 	}
-
 	return ret;
 }
+
+static int ext4_bh_unmapped_or_delay(handle_t *handle, struct buffer_head *bh)
+{
+	return !buffer_mapped(bh) || buffer_delay(bh);
+}
+
 /* FIXME!! only support data=writeback mode */
-static int __ext4_da_writepage(struct page *page,
+/*
+ * get called vi ext4_da_writepages after taking page lock
+ * We may end up doing block allocation here in case
+ * mpage_da_map_blocks failed to allocate blocks.
+ */
+static int ext4_da_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
-	struct inode *inode = page->mapping->host;
-	handle_t *handle = NULL;
 	int ret = 0;
+	loff_t size;
+	unsigned long len;
+	handle_t *handle = NULL;
+	struct buffer_head *page_bufs;
+	struct inode *inode = page->mapping->host;
 
 	handle = ext4_journal_current_handle();
+	if (!handle) {
+		/*
+		 * This can happen when we aren't called via
+		 * ext4_da_writepages() but directly (shrink_page_list).
+		 * We cannot easily start a transaction here so we just skip
+		 * writing the page in case we would have to do so.
+		 */
+		size = i_size_read(inode);
 
-	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
-		ret = nobh_writepage(page, ext4_get_block, wbc);
-	else
-		ret = block_write_full_page(page, ext4_get_block, wbc);
+		page_bufs = page_buffers(page);
+		if (page->index == size >> PAGE_CACHE_SHIFT)
+			len = size & ~PAGE_CACHE_MASK;
+		else
+			len = PAGE_CACHE_SIZE;
 
-	if (!ret && inode->i_size > EXT4_I(inode)->i_disksize) {
-		EXT4_I(inode)->i_disksize = inode->i_size;
-		ext4_mark_inode_dirty(handle, inode);
+		if (walk_page_buffers(NULL, page_bufs, 0,
+				len, NULL, ext4_bh_unmapped_or_delay)) {
+			/*
+			 * We can't do block allocation under
+			 * page lock without a handle . So redirty
+			 * the page and return
+			 */
+			BUG_ON(wbc->sync_mode != WB_SYNC_NONE);
+			redirty_page_for_writepage(wbc, page);
+			unlock_page(page);
+			return 0;
+		}
 	}
 
+	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
+		ret = nobh_writepage(page, ext4_da_get_block_write, wbc);
+	else
+		ret = block_write_full_page(page, ext4_da_get_block_write, wbc);
+
 	return ret;
 }
-static int ext4_da_writepage(struct page *page,
-				struct writeback_control *wbc)
-{
-	if (!ext4_journal_current_handle())
-		return __ext4_da_writepage(page, wbc);
 
-	redirty_page_for_writepage(wbc, page);
-	unlock_page(page);
-	return 0;
-}
 
 /*
  * For now just follow the DIO way to estimate the max credits
@@ -1545,8 +1569,8 @@ static int ext4_da_writepages(struct address_space *mapping,
 	handle_t *handle = NULL;
 	int needed_blocks;
 	int ret = 0;
-	unsigned range_cyclic;
 	long to_write;
+	loff_t range_start = 0;
 
 	/*
 	 * No pages to write? This is mainly a kludge to avoid starting
@@ -1563,8 +1587,14 @@ static int ext4_da_writepages(struct address_space *mapping,
 	needed_blocks = EXT4_MAX_WRITEBACK_CREDITS;
 
 	to_write = wbc->nr_to_write;
-	range_cyclic = wbc->range_cyclic;
-	wbc->range_cyclic = 1;
+	if (!wbc->range_cyclic) {
+		/*
+		 * If range_cyclic is not set force range_cont
+		 * and save the old writeback_index
+		 */
+		wbc->range_cont = 1;
+		range_start =  wbc->range_start;
+	}
 
 	while (!ret && to_write) {
 		/* start a new transaction*/
@@ -1579,17 +1609,27 @@ static int ext4_da_writepages(struct address_space *mapping,
 		 */
 		if (wbc->nr_to_write > EXT4_MAX_WRITEBACK_PAGES)
 			wbc->nr_to_write = EXT4_MAX_WRITEBACK_PAGES;
-		to_write -= wbc->nr_to_write;
 
+		to_write -= wbc->nr_to_write;
 		ret = mpage_da_writepages(mapping, wbc,
 						ext4_da_get_block_write);
 		ext4_journal_stop(handle);
-		to_write += wbc->nr_to_write;
+		if (wbc->nr_to_write) {
+			/*
+			 * There is no more writeout needed
+			 * or we requested for a noblocking writeout
+			 * and we found the device congested
+			 */
+			to_write += wbc->nr_to_write;
+			break;
+		}
+		wbc->nr_to_write = to_write;
 	}
 
 out_writepages:
 	wbc->nr_to_write = to_write;
-	wbc->range_cyclic = range_cyclic;
+	if (range_start)
+		wbc->range_start = range_start;
 	return ret;
 }
 
@@ -1720,11 +1760,6 @@ static int bput_one(handle_t *handle, struct buffer_head *bh)
 	return 0;
 }
 
-static int ext4_bh_unmapped_or_delay(handle_t *handle, struct buffer_head *bh)
-{
-	return !buffer_mapped(bh) || buffer_delay(bh);
-}
-
 /*
  * Note that we don't need to start a transaction unless we're journaling data
  * because we should have holes filled from ext4_page_mkwrite(). We even don't
diff --git a/fs/mpage.c b/fs/mpage.c
index cde7f11..c4376ec 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -849,13 +849,11 @@ static void mpage_put_bnr_to_bhs(struct mpage_da_data *mpd, sector_t logical,
 			do {
 				if (cur_logical >= logical + blocks)
 					break;
-
 				if (buffer_delay(bh)) {
 					bh->b_blocknr = pblock;
 					clear_buffer_delay(bh);
-				} else if (buffer_mapped(bh)) {
+				} else if (buffer_mapped(bh))
 					BUG_ON(bh->b_blocknr != pblock);
-				}
 
 				cur_logical++;
 				pblock++;
@@ -930,10 +928,10 @@ static void mpage_da_map_blocks(struct mpage_da_data *mpd)
 		if (buffer_delay(lbh))
 			mpage_put_bnr_to_bhs(mpd, next, &new);
 
-			/* go for the remaining blocks */
-			next += new.b_size >> mpd->inode->i_blkbits;
-			remain -= new.b_size;
-		}
+		/* go for the remaining blocks */
+		next += new.b_size >> mpd->inode->i_blkbits;
+		remain -= new.b_size;
+	}
 }
 
 #define BH_FLAGS ((1 << BH_Uptodate) | (1 << BH_Mapped) | (1 << BH_Delay))
-- 
1.5.5.1.357.g1af8b.dirty

