From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH updated] ext4: Handle page without buffers in ext4_*_writepage()
Date: Mon, 30 Jun 2008 15:36:14 +0530
Message-ID: <1214820374-5464-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:49653 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753800AbYF3KGv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Jun 2008 06:06:51 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id m5UA6GxK017981
	for <linux-ext4@vger.kernel.org>; Mon, 30 Jun 2008 15:36:16 +0530
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5UA54Es774294
	for <linux-ext4@vger.kernel.org>; Mon, 30 Jun 2008 15:35:05 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.13.1/8.13.3) with ESMTP id m5UA6EJ8011456
	for <linux-ext4@vger.kernel.org>; Mon, 30 Jun 2008 15:36:15 +0530
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>

It can happen that buffers are removed from the page before it gets
marked dirty and then is passed to writepage(). In writepage()
we just initialize the buffers and check whether they are mapped and non
delay. If they are mapped and non delay we write the page. Otherwise we
mark then dirty. With this change we don't do block allocation at all in
ext4_*_write_page.

writepage() get called under many condition and with a locking order
of journal_start -> lock_page we shouldnot try to allocate blocks in
writepage() which get called after taking page lock. writepage can get
called via shrink_page_list even with a journal handle which was created
for doing inode update. For example when doing ext4_da_write_begin we
create a journal handle with credit 1 expecting a i_disksize update for
the inode. But ext4_da_write_begin can cause shrink_page_list via
_grab_page_cache. So having a valid handle via ext4_journal_current_handle
is not a guarantee that we can use the handle for block allocation in
writepage. We should not be using credits which are taken for other updates.
That would result in we running out of credits when we update inodes.


Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |  169 ++++++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 124 insertions(+), 45 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index cd5c165..18af94a 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1591,11 +1591,15 @@ static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
 	handle_t *handle = NULL;
 
 	handle = ext4_journal_current_handle();
-	BUG_ON(handle == NULL);
-	BUG_ON(create == 0);
-
-	ret = ext4_get_blocks_wrap(handle, inode, iblock, max_blocks,
+	if (!handle) {
+		ret = ext4_get_blocks_wrap(handle, inode, iblock, max_blocks,
+				   bh_result, 0, 0, 0);
+		BUG_ON(!ret);
+	} else {
+		ret = ext4_get_blocks_wrap(handle, inode, iblock, max_blocks,
 				   bh_result, create, 0, EXT4_DELALLOC_RSVED);
+	}
+
 	if (ret > 0) {
 		bh_result->b_size = (ret << inode->i_blkbits);
 
@@ -1633,15 +1637,37 @@ static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
 
 static int ext4_bh_unmapped_or_delay(handle_t *handle, struct buffer_head *bh)
 {
-	return !buffer_mapped(bh) || buffer_delay(bh);
+	/*
+	 * unmapped buffer is possible for holes.
+	 * delay buffer is possible with delayed allocation
+	 */
+	return ((!buffer_mapped(bh) || buffer_delay(bh)) && buffer_dirty(bh));
+}
+
+static int ext4_normal_get_block_write(struct inode *inode, sector_t iblock,
+				   struct buffer_head *bh_result, int create)
+{
+	int ret = 0;
+	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
+
+	/*
+	 * we don't want to do block allocation in writepage
+	 * so call get_block_wrap with create = 0
+	 */
+	ret = ext4_get_blocks_wrap(NULL, inode, iblock, max_blocks,
+				   bh_result, 0, 0, 0);
+	if (ret > 0) {
+		bh_result->b_size = (ret << inode->i_blkbits);
+		ret = 0;
+	}
+	return ret;
 }
 
 /*
- * get called vi ext4_da_writepages after taking page lock
- * We may end up doing block allocation here in case
- * mpage_da_map_blocks failed to allocate blocks.
- *
- * We also get called via journal_submit_inode_data_buffers
+ * get called vi ext4_da_writepages after taking page lock (have journal handle)
+ * get called via journal_submit_inode_data_buffers (no journal handle)
+ * get called via shrink_page_list via pdflush (no journal handle)
+ * or grab_page_cache when doing write_begin (have journal handle)
  */
 static int ext4_da_writepage(struct page *page,
 				struct writeback_control *wbc)
@@ -1649,37 +1675,61 @@ static int ext4_da_writepage(struct page *page,
 	int ret = 0;
 	loff_t size;
 	unsigned long len;
-	handle_t *handle = NULL;
 	struct buffer_head *page_bufs;
 	struct inode *inode = page->mapping->host;
 
-	handle = ext4_journal_current_handle();
-	if (!handle) {
-		/*
-		 * This can happen when we aren't called via
-		 * ext4_da_writepages() but directly (shrink_page_list).
-		 * We cannot easily start a transaction here so we just skip
-		 * writing the page in case we would have to do so.
-		 * We reach here also via journal_submit_inode_data_buffers
-		 */
-		size = i_size_read(inode);
+	size = i_size_read(inode);
+	if (page->index == size >> PAGE_CACHE_SHIFT)
+		len = size & ~PAGE_CACHE_MASK;
+	else
+		len = PAGE_CACHE_SIZE;
 
+	if (page_has_buffers(page)) {
 		page_bufs = page_buffers(page);
-		if (page->index == size >> PAGE_CACHE_SHIFT)
-			len = size & ~PAGE_CACHE_MASK;
-		else
-			len = PAGE_CACHE_SIZE;
-
-		if (walk_page_buffers(NULL, page_bufs, 0,
-				len, NULL, ext4_bh_unmapped_or_delay)) {
+		if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
+					ext4_bh_unmapped_or_delay)) {
 			/*
-			 * We can't do block allocation under
-			 * page lock without a handle . So redirty
-			 * the page and return
+			 * We don't want to do  block allocation
+			 * So redirty the page and return
 			 * We may reach here when we do a journal commit
 			 * via journal_submit_inode_data_buffers.
 			 * If we don't have mapping block we just ignore
-			 * them
+			 * them. We can also reach here via shrink_page_list
+			 */
+			redirty_page_for_writepage(wbc, page);
+			unlock_page(page);
+			return 0;
+		}
+	} else {
+		/*
+		 * The test for page_has_buffers() is subtle:
+		 * We know the page is dirty but it lost buffers. That means
+		 * that at some moment in time after write_begin()/write_end()
+		 * has been called all buffers have been clean and thus they
+		 * must have been written at least once. So they are all
+		 * mapped and we can happily proceed with mapping them
+		 * and writing the page.
+		 *
+		 * Try to initialize the buffer_heads and check whether
+		 * all are mapped and non delay. We don't want to
+		 * do block allocation here.
+		 */
+		ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE,
+						ext4_normal_get_block_write);
+		if (!ret) {
+			page_bufs = page_buffers(page);
+			/* check whether all are mapped and non delay */
+			if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
+						ext4_bh_unmapped_or_delay)) {
+				redirty_page_for_writepage(wbc, page);
+				unlock_page(page);
+				return 0;
+			}
+		} else {
+			/*
+			 * We can't do block allocation here
+			 * so just redity the page and unlock
+			 * and return
 			 */
 			redirty_page_for_writepage(wbc, page);
 			unlock_page(page);
@@ -1688,9 +1738,11 @@ static int ext4_da_writepage(struct page *page,
 	}
 
 	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
-		ret = nobh_writepage(page, ext4_da_get_block_write, wbc);
+		ret = nobh_writepage(page, ext4_normal_get_block_write, wbc);
 	else
-		ret = block_write_full_page(page, ext4_da_get_block_write, wbc);
+		ret = block_write_full_page(page,
+						ext4_normal_get_block_write,
+						wbc);
 
 	return ret;
 }
@@ -2031,12 +2083,14 @@ static int __ext4_normal_writepage(struct page *page,
 	struct inode *inode = page->mapping->host;
 
 	if (test_opt(inode->i_sb, NOBH))
-		return nobh_writepage(page, ext4_get_block, wbc);
+		return nobh_writepage(page,
+					ext4_normal_get_block_write, wbc);
 	else
-		return block_write_full_page(page, ext4_get_block, wbc);
+		return block_write_full_page(page,
+						ext4_normal_get_block_write,
+						wbc);
 }
 
-
 static int ext4_normal_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
@@ -2045,13 +2099,24 @@ static int ext4_normal_writepage(struct page *page,
 	loff_t len;
 
 	J_ASSERT(PageLocked(page));
-	J_ASSERT(page_has_buffers(page));
 	if (page->index == size >> PAGE_CACHE_SHIFT)
 		len = size & ~PAGE_CACHE_MASK;
 	else
 		len = PAGE_CACHE_SIZE;
-	BUG_ON(walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
-				 ext4_bh_unmapped_or_delay));
+
+	if (page_has_buffers(page)) {
+		/* if page has buffers it should all be mapped
+		 * and allocated. If there are not buffers attached
+		 * to the page we know the page is dirty but it lost
+		 * buffers. That means that at some moment in time
+		 * after write_begin() / write_end() has been called
+		 * all buffers have been clean and thus they must have been
+		 * written at least once. So they are all mapped and we can
+		 * happily proceed with mapping them and writing the page.
+		 */
+		BUG_ON(walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
+					ext4_bh_unmapped_or_delay));
+	}
 
 	if (!ext4_journal_current_handle())
 		return __ext4_normal_writepage(page, wbc);
@@ -2071,7 +2136,8 @@ static int __ext4_journalled_writepage(struct page *page,
 	int ret = 0;
 	int err;
 
-	ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE, ext4_get_block);
+	ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE,
+					ext4_normal_get_block_write);
 	if (ret != 0)
 		goto out_unlock;
 
@@ -2118,13 +2184,24 @@ static int ext4_journalled_writepage(struct page *page,
 	loff_t len;
 
 	J_ASSERT(PageLocked(page));
-	J_ASSERT(page_has_buffers(page));
 	if (page->index == size >> PAGE_CACHE_SHIFT)
 		len = size & ~PAGE_CACHE_MASK;
 	else
 		len = PAGE_CACHE_SIZE;
-	BUG_ON(walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
-				 ext4_bh_unmapped_or_delay));
+
+	if (page_has_buffers(page)) {
+		/* if page has buffers it should all be mapped
+		 * and allocated. If there are not buffers attached
+		 * to the page we know the page is dirty but it lost
+		 * buffers. That means that at some moment in time
+		 * after write_begin() / write_end() has been called
+		 * all buffers have been clean and thus they must have been
+		 * written at least once. So they are all mapped and we can
+		 * happily proceed with mapping them and writing the page.
+		 */
+		BUG_ON(walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
+					ext4_bh_unmapped_or_delay));
+	}
 
 	if (ext4_journal_current_handle())
 		goto no_write;
@@ -2142,7 +2219,9 @@ static int ext4_journalled_writepage(struct page *page,
 		 * really know unless we go poke around in the buffer_heads.
 		 * But block_write_full_page will do the right thing.
 		 */
-		return block_write_full_page(page, ext4_get_block, wbc);
+		return block_write_full_page(page,
+						ext4_normal_get_block_write,
+						wbc);
 	}
 no_write:
 	redirty_page_for_writepage(wbc, page);
-- 
1.5.6.1.102.g8e69d.dirty

