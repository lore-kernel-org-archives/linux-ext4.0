From: Jan Kara <jack@suse.cz>
Subject: Ordered mode rewrite for jbd2/ext4
Date: Wed, 4 Jun 2008 17:44:35 +0200
Message-ID: <20080604154435.GE16572@duck.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="tThc/1wpZn/ma/RB"
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:45954 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751549AbYFDPoi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Jun 2008 11:44:38 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

  Hi,

  So I've split and ported ordered mode rewrite for ext4+jbd2.
The core of the rewrite are two patches

jbd2-Implement-data-ordered-mode-handling-via-inode.patch
ext4-Use-new-framework-for-data-ordered-mode-in-JBD.patch

They also need two trivial fixes:
vfs-export-filemap_fdatawrite_range.patch
ext4-Use-new-framework-for-data-ordered-mode-in-JBD.patch

And finally there's a patch removing old ordered mode from jbd2:
jbd2-Remove-data-ordered-mode-support-using-jbd-buf.patch

I've created the patches to be added to the ext4 patch queue just
after inversion of page lock and transaction start.

I have refreshed the following patches in the ext4 queue to apply cleanly
and also fixed some typos in them and added one BUG_ON():

ext4-delalloc-sync-hang-with-journal-lock-inverse-fix.patch
ext4-delalloc-inverse-jbd-and-page-lock-ordering.patch
ext4-inverse-jbd-and-page-locking-order.patch

Finally, I've rewritten checks in writepage so
ext4-Add-validation-to-jbd-lock-inversion-patch-and.patch
should be replaced with
ext4-add-checks-to-writepage

as we spoke about it with Aneesh.

All the patches are attached and I'll also post the new ones separately for
more convenient review. The tests for 4k blocksize run fine for me. The
kernel oopses for 1k blocksize because of a problem in ext4_page_mkwrite()
- I'll post that in a separate mail. If noone objects, patches can be added
to ext4 patch queue.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--tThc/1wpZn/ma/RB
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="series.diff"

diff --git a/series b/series
index f2dcda6..f85400d 100644
--- a/series
+++ b/series
@@ -42,9 +42,16 @@ ext4-mb-add-ext4_has_free_blocks-check.patch
 ext4-page-mkwrite.patch
 
 #page lock and transaction lock reverse series
-ext4-inverse-jbd-and-page-locking-order.patch
 vfs-Move-mark_inode_dirty-from-under-page-lock-in.patch
-ext4-Add-validation-to-jbd-lock-inversion-patch-and.patch
+ext4-inverse-jbd-and-page-locking-order.patch
+ext4-add-checks-to-writepage
+
+# Ordered mode rewrite
+ext4-Set-journal-pointer-to-NULL-when-journal-is-re.patch
+vfs-export-filemap_fdatawrite_range.patch
+jbd2-Implement-data-ordered-mode-handling-via-inode.patch
+ext4-Use-new-framework-for-data-ordered-mode-in-JBD.patch
+jbd2-Remove-data-ordered-mode-support-using-jbd-buf.patch
 
 # New delayed allocation patch
 delalloc-vfs.patch

--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=ext4-add-checks-to-writepage

ext4: Add checks to writepage()

Add checks to writepage() calls to check that all pages are properly
mapped and not delayed.

Signed-off-by: Jan Kara <jack@suse.cz>

Index: linux-2.6-linus/fs/ext4/inode.c
===================================================================
--- linux-2.6-linus.orig/fs/ext4/inode.c
+++ linux-2.6-linus/fs/ext4/inode.c
@@ -1479,6 +1479,11 @@ static int jbd2_journal_dirty_data_fn(ha
 	return 0;
 }
 
+static int ext4_bh_unmapped_or_delay(handle_t *handle, struct buffer_head *bh)
+{
+	return !buffer_mapped(bh) || buffer_delay(bh);
+}
+
 /*
  * Note that we don't need to start a transaction unless we're journaling
  * data because we should have holes filled from ext4_page_mkwrite(). If
@@ -1582,7 +1587,18 @@ out_put:
 static int ext4_ordered_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
+	struct inode *inode = page->mapping->host;
+	loff_t size = i_size_read(inode);
+	loff_t len;
+
 	J_ASSERT(PageLocked(page));
+	J_ASSERT(page_has_buffers(page));
+	if (page->index == size >> PAGE_CACHE_SHIFT)
+		len = size & ~PAGE_CACHE_MASK;
+	else
+		len = PAGE_CACHE_SIZE;
+	BUG_ON(walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
+				 ext4_bh_unmapped_or_delay));
 
 	/*
 	 * We give up here if we're reentered, because it might be for a
@@ -1611,6 +1627,19 @@ static int __ext4_writeback_writepage(st
 static int ext4_writeback_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
+	struct inode *inode = page->mapping->host;
+	loff_t size = i_size_read(inode);
+	loff_t len;
+
+	J_ASSERT(PageLocked(page));
+	J_ASSERT(page_has_buffers(page));
+	if (page->index == size >> PAGE_CACHE_SHIFT)
+		len = size & ~PAGE_CACHE_MASK;
+	else
+		len = PAGE_CACHE_SIZE;
+	BUG_ON(walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
+				 ext4_bh_unmapped_or_delay));
+
 	if (!ext4_journal_current_handle())
 		return __ext4_writeback_writepage(page, wbc);
 
@@ -1671,10 +1700,23 @@ out:
 static int ext4_journalled_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
+	struct inode *inode = page->mapping->host;
+	loff_t size = i_size_read(inode);
+	loff_t len;
+
+	J_ASSERT(PageLocked(page));
+	J_ASSERT(page_has_buffers(page));
+	if (page->index == size >> PAGE_CACHE_SHIFT)
+		len = size & ~PAGE_CACHE_MASK;
+	else
+		len = PAGE_CACHE_SIZE;
+	BUG_ON(walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
+				 ext4_bh_unmapped_or_delay));
+
 	if (ext4_journal_current_handle())
 		goto no_write;
 
-	if (!page_has_buffers(page) || PageChecked(page)) {
+	if (PageChecked(page)) {
 		/*
 		 * It's mmapped pagecache.  Add buffers and journal it.  There
 		 * doesn't seem much point in redirtying the page here.

--tThc/1wpZn/ma/RB
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="ext4-delalloc-inverse-jbd-and-page-lock-ordering.patch"

ext4:  inverse locking ordering of page_lock and transaction start in delalloc

From: Mingming Cao <cmm@us.ibm.com>

Inverse locking ordering of page_lock and transaction start in delalloc

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---

 fs/ext4/inode.c |   96 +++++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 68 insertions(+), 28 deletions(-)


Index: linux-2.6-linus/fs/ext4/inode.c
===================================================================
--- linux-2.6-linus.orig/fs/ext4/inode.c
+++ linux-2.6-linus/fs/ext4/inode.c
@@ -1448,18 +1448,14 @@ static int ext4_da_get_block_prep(struct
 static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
 				   struct buffer_head *bh_result, int create)
 {
-	int ret, needed_blocks = ext4_writepage_trans_blocks(inode);
+	int ret;
 	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
 	loff_t disksize = EXT4_I(inode)->i_disksize;
 	handle_t *handle = NULL;
 
-	if (create) {
-		handle = ext4_journal_start(inode, needed_blocks);
-		if (IS_ERR(handle)) {
-			ret = PTR_ERR(handle);
-			goto out;
-		}
-	}
+	handle = ext4_journal_current_handle();
+	BUG_ON(handle == 0);
+	BUG_ON(create == 0);
 
 	ret = ext4_get_blocks_wrap(handle, inode, iblock, max_blocks,
 				   bh_result, create, 0);
@@ -1494,29 +1490,17 @@ static int ext4_da_get_block_write(struc
 		ret = 0;
 	}
 
-out:
-	if (handle && !IS_ERR(handle))
-		ext4_journal_stop(handle);
-
 	return ret;
 }
 /* FIXME!! only support data=writeback mode */
-static int ext4_da_writepage(struct page *page,
+static int __ext4_da_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
 	struct inode *inode = page->mapping->host;
 	handle_t *handle = NULL;
 	int ret = 0;
-	int err;
 
-	if (ext4_journal_current_handle())
-		goto out_fail;
-
-	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode));
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		goto out_fail;
-	}
+	handle = ext4_journal_current_handle();
 
 	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
 		ret = nobh_writepage(page, ext4_get_block, wbc);
@@ -1528,21 +1512,85 @@ static int ext4_da_writepage(struct page
 		ext4_mark_inode_dirty(handle, inode);
 	}
 
-	err = ext4_journal_stop(handle);
-	if (!ret)
-		ret = err;
 	return ret;
+}
+static int ext4_da_writepage(struct page *page,
+				struct writeback_control *wbc)
+{
+	if (!ext4_journal_current_handle())
+		return __ext4_da_writepage(page, wbc);
 
-out_fail:
 	redirty_page_for_writepage(wbc, page);
 	unlock_page(page);
-	return ret;
+	return 0;
 }
 
+/*
+ * For now just follow the DIO way to estimate the max credits
+ * needed to write out EXT4_MAX_WRITEBACK_PAGES.
+ * todo: need to calculate the max credits need for
+ * extent based files, currently the DIO credits is based on
+ * indirect-blocks mapping way.
+ *
+ * Probably should have a generic way to calculate credits
+ * for DIO, writepages, and truncate
+ */
+#define EXT4_MAX_WRITEBACK_PAGES      DIO_MAX_BLOCKS
+#define EXT4_MAX_WRITEBACK_CREDITS    DIO_CREDITS
+
 static int ext4_da_writepages(struct address_space *mapping,
 				struct writeback_control *wbc)
 {
-	return mpage_da_writepages(mapping, wbc, ext4_da_get_block_write);
+	struct inode *inode = mapping->host;
+	handle_t *handle = NULL;
+	int needed_blocks;
+	int ret = 0;
+	unsigned range_cyclic;
+	long to_write;
+
+	/*
+	 * No pages to write? This is mainly a kludge to avoid starting
+	 * a transaction for special inodes like journal inode on last iput()
+	 * because that could violate lock ordering on umount
+	 */
+	if (!mapping->nrpages)
+		return 0;
+
+	/*
+	 *  Estimate the worse case needed credits to write out
+	 * EXT4_MAX_BUF_BLOCKS pages
+	 */
+	needed_blocks = EXT4_MAX_WRITEBACK_CREDITS;
+
+	to_write = wbc->nr_to_write;
+	range_cyclic = wbc->range_cyclic;
+	wbc->range_cyclic = 1;
+
+	while (!ret && to_write) {
+		/* start a new transaction*/
+		handle = ext4_journal_start(inode, needed_blocks);
+		if (IS_ERR(handle)) {
+			ret = PTR_ERR(handle);
+			goto out_writepages;
+		}
+		/*
+		 * set the max dirty pages could be write at a time
+		 * to fit into the reserved transaction credits
+		 */
+		if (wbc->nr_to_write > EXT4_MAX_WRITEBACK_PAGES)
+			wbc->nr_to_write = EXT4_MAX_WRITEBACK_PAGES;
+		to_write -= wbc->nr_to_write;
+
+		ret = mpage_da_writepages(mapping, wbc,
+						ext4_da_get_block_write);
+		ext4_journal_stop(handle);
+		to_write += wbc->nr_to_write;
+	}
+
+out_writepages:
+	wbc->nr_to_write = to_write;
+	wbc->range_cyclic = range_cyclic;
+	return ret;
 }
 
 static int ext4_da_write_begin(struct file *file, struct address_space *mapping,

--tThc/1wpZn/ma/RB
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="ext4-delalloc-sync-hang-with-journal-lock-inverse-fix.patch"

ext4: Fix delalloc sync hang with journal lock inversion

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---

 fs/ext4/inode.c     |   99 +++++++++++++++++++++++++++++++++++----------------
 fs/mpage.c          |   14 ++++---
 mm/page-writeback.c |    7 +++-
 3 files changed, 80 insertions(+), 40 deletions(-)


Index: linux-2.6-linus/fs/ext4/inode.c
===================================================================
--- linux-2.6-linus.orig/fs/ext4/inode.c
+++ linux-2.6-linus/fs/ext4/inode.c
@@ -1480,50 +1480,74 @@ static int ext4_da_get_block_write(struc
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
+
+		page_bufs = page_buffers(page);
+		if (page->index == size >> PAGE_CACHE_SHIFT)
+			len = size & ~PAGE_CACHE_MASK;
+		else
+			len = PAGE_CACHE_SIZE;
+
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
+	}
 
 	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
-		ret = nobh_writepage(page, ext4_get_block, wbc);
+		ret = nobh_writepage(page, ext4_da_get_block_write, wbc);
 	else
-		ret = block_write_full_page(page, ext4_get_block, wbc);
-
-	if (!ret && inode->i_size > EXT4_I(inode)->i_disksize) {
-		EXT4_I(inode)->i_disksize = inode->i_size;
-		ext4_mark_inode_dirty(handle, inode);
-	}
+		ret = block_write_full_page(page, ext4_da_get_block_write, wbc);
 
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
@@ -1547,6 +1571,7 @@ static int ext4_da_writepages(struct add
 	int ret = 0;
 	unsigned range_cyclic;
 	long to_write;
+	pgoff_t index;
 
 	/*
 	 *  Estimate the worse case needed credits to write out
@@ -1557,6 +1582,15 @@ static int ext4_da_writepages(struct add
 	to_write = wbc->nr_to_write;
 	range_cyclic = wbc->range_cyclic;
 	wbc->range_cyclic = 1;
+	index =  mapping->writeback_index;
+	if (!range_cyclic) {
+		/*
+		 * We force cyclic write out of pages. If the
+		 * caller didn't request for range_cyclic update
+		 * set the writeback_index to what the caller requested.
+		 */
+		mapping->writeback_index = wbc->range_start >> PAGE_CACHE_SHIFT;
+	}
 
 	while (!ret && to_write) {
 		/* start a new transaction*/
@@ -1571,17 +1605,24 @@ static int ext4_da_writepages(struct add
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
+			/* There is no more writeout needed */
+			to_write += wbc->nr_to_write;
+			break;
+		}
+		wbc->nr_to_write = to_write;
 	}
 
 out_writepages:
 	wbc->nr_to_write = to_write;
 	wbc->range_cyclic = range_cyclic;
+	if (!range_cyclic)
+		mapping->writeback_index = index;
 	return ret;
 }
 
@@ -1712,11 +1753,6 @@ static int bput_one(handle_t *handle, st
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
Index: linux-2.6-linus/fs/mpage.c
===================================================================
--- linux-2.6-linus.orig/fs/mpage.c
+++ linux-2.6-linus/fs/mpage.c
@@ -849,13 +849,12 @@ static void mpage_put_bnr_to_bhs(struct
 			do {
 				if (cur_logical >= logical + blocks)
 					break;
-
 				if (buffer_delay(bh)) {
 					bh->b_blocknr = pblock;
 					clear_buffer_delay(bh);
-				} else if (buffer_mapped(bh)) {
+					set_buffer_mapped(bh);
+				} else if (buffer_mapped(bh))
 					BUG_ON(bh->b_blocknr != pblock);
-				}
 
 				cur_logical++;
 				pblock++;
@@ -930,10 +929,10 @@ static void mpage_da_map_blocks(struct m
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
@@ -1052,6 +1051,7 @@ static int __mpage_da_writepage(struct p
 		head = page_buffers(page);
 		bh = head;
 		do {
+
 			BUG_ON(buffer_locked(bh));
 			if (buffer_dirty(bh))
 				mpage_add_bh_to_extent(mpd, logical, bh);
Index: linux-2.6-linus/mm/page-writeback.c
===================================================================
--- linux-2.6-linus.orig/mm/page-writeback.c
+++ linux-2.6-linus/mm/page-writeback.c
@@ -881,7 +881,12 @@ int write_cache_pages(struct address_spa
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index; /* Start from prev offset */
-		end = -1;
+		/*
+		 * write only till the specified range_end even in cyclic mode
+		 */
+		end = wbc->range_end >> PAGE_CACHE_SHIFT;
+		if (!end)
+			end = -1;
 	} else {
 		index = wbc->range_start >> PAGE_CACHE_SHIFT;
 		end = wbc->range_end >> PAGE_CACHE_SHIFT;

--tThc/1wpZn/ma/RB
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="ext4-inverse-jbd-and-page-locking-order.patch"

ext4: Inverse locking order of page_lock and transaction start.

From: Jan Kara <jack@suse.cz>

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---

 fs/ext4/ext4.h    |    4 -
 fs/ext4/extents.c |   15 +--
 fs/ext4/inode.c   |  274 ++++++++++++++++++++++++-----------------------------
 3 files changed, 132 insertions(+), 161 deletions(-)


diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 66cdd5c..e7da2cb 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1063,7 +1063,7 @@ extern void ext4_set_inode_flags(struct inode *);
 extern void ext4_get_inode_flags(struct ext4_inode_info *);
 extern void ext4_set_aops(struct inode *inode);
 extern int ext4_writepage_trans_blocks(struct inode *);
-extern int ext4_block_truncate_page(handle_t *handle, struct page *page,
+extern int ext4_block_truncate_page(handle_t *handle,
 		struct address_space *mapping, loff_t from);
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page);
 
@@ -1222,7 +1222,7 @@ extern int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 			ext4_lblk_t iblock,
 			unsigned long max_blocks, struct buffer_head *bh_result,
 			int create, int extend_disksize);
-extern void ext4_ext_truncate(struct inode *, struct page *);
+extern void ext4_ext_truncate(struct inode *);
 extern void ext4_ext_init(struct super_block *);
 extern void ext4_ext_release(struct super_block *);
 extern long ext4_fallocate(struct inode *inode, int mode, loff_t offset,
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index c58ebd8..1a90a23 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2744,7 +2744,7 @@ int ext4_ext_get_blocks(handle_t *handle, struct inode *inode,
 	return err ? err : allocated;
 }
 
-void ext4_ext_truncate(struct inode * inode, struct page *page)
+void ext4_ext_truncate(struct inode *inode)
 {
 	struct address_space *mapping = inode->i_mapping;
 	struct super_block *sb = inode->i_sb;
@@ -2757,18 +2757,11 @@ void ext4_ext_truncate(struct inode * inode, struct page *page)
 	 */
 	err = ext4_writepage_trans_blocks(inode) + 3;
 	handle = ext4_journal_start(inode, err);
-	if (IS_ERR(handle)) {
-		if (page) {
-			clear_highpage(page);
-			flush_dcache_page(page);
-			unlock_page(page);
-			page_cache_release(page);
-		}
+	if (IS_ERR(handle))
 		return;
-	}
 
-	if (page)
-		ext4_block_truncate_page(handle, page, mapping, inode->i_size);
+	if (inode->i_size & (sb->s_blocksize - 1))
+		ext4_block_truncate_page(handle, mapping, inode->i_size);
 
 	down_write(&EXT4_I(inode)->i_data_sem);
 	ext4_ext_invalidate_cache(inode);
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index bc52ef5..a96c325 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1239,19 +1239,20 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
  	to = from + len;
 
 retry:
- 	page = __grab_cache_page(mapping, index);
- 	if (!page)
- 		return -ENOMEM;
- 	*pagep = page;
-
   	handle = ext4_journal_start(inode, needed_blocks);
   	if (IS_ERR(handle)) {
- 		unlock_page(page);
- 		page_cache_release(page);
   		ret = PTR_ERR(handle);
   		goto out;
 	}
 
+	page = __grab_cache_page(mapping, index);
+	if (!page) {
+		ext4_journal_stop(handle);
+		ret = -ENOMEM;
+		goto out;
+	}
+	*pagep = page;
+
 	ret = block_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
 							ext4_get_block);
 
@@ -1261,8 +1262,8 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
 	}
 
 	if (ret) {
-		ext4_journal_stop(handle);
  		unlock_page(page);
+		ext4_journal_stop(handle);
  		page_cache_release(page);
 	}
 
@@ -1291,29 +1292,6 @@ static int write_end_fn(handle_t *handle, struct buffer_head *bh)
 }
 
 /*
- * Generic write_end handler for ordered and writeback ext4 journal modes.
- * We can't use generic_write_end, because that unlocks the page and we need to
- * unlock the page after ext4_journal_stop, but ext4_journal_stop must run
- * after block_write_end.
- */
-static int ext4_generic_write_end(struct file *file,
-				struct address_space *mapping,
-				loff_t pos, unsigned len, unsigned copied,
-				struct page *page, void *fsdata)
-{
-	struct inode *inode = file->f_mapping->host;
-
-	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
-
-	if (pos+copied > inode->i_size) {
-		i_size_write(inode, pos+copied);
-		mark_inode_dirty(inode);
-	}
-
-	return copied;
-}
-
-/*
  * We need to pick up the new inode size which generic_commit_write gave us
  * `file' can be NULL - eg, when called from page_symlink().
  *
@@ -1326,7 +1304,7 @@ static int ext4_ordered_write_end(struct file *file,
 				struct page *page, void *fsdata)
 {
 	handle_t *handle = ext4_journal_current_handle();
-	struct inode *inode = file->f_mapping->host;
+	struct inode *inode = mapping->host;
 	unsigned from, to;
 	int ret = 0, ret2;
 
@@ -1347,7 +1325,7 @@ static int ext4_ordered_write_end(struct file *file,
 		new_i_size = pos + copied;
 		if (new_i_size > EXT4_I(inode)->i_disksize)
 			EXT4_I(inode)->i_disksize = new_i_size;
-		ret2 = ext4_generic_write_end(file, mapping, pos, len, copied,
+		ret2 = generic_write_end(file, mapping, pos, len, copied,
 							page, fsdata);
 		copied = ret2;
 		if (ret2 < 0)
@@ -1356,8 +1334,6 @@ static int ext4_ordered_write_end(struct file *file,
 	ret2 = ext4_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
-	unlock_page(page);
-	page_cache_release(page);
 
 	return ret ? ret : copied;
 }
@@ -1368,7 +1344,7 @@ static int ext4_writeback_write_end(struct file *file,
 				struct page *page, void *fsdata)
 {
 	handle_t *handle = ext4_journal_current_handle();
-	struct inode *inode = file->f_mapping->host;
+	struct inode *inode = mapping->host;
 	int ret = 0, ret2;
 	loff_t new_i_size;
 
@@ -1376,7 +1352,7 @@ static int ext4_writeback_write_end(struct file *file,
 	if (new_i_size > EXT4_I(inode)->i_disksize)
 		EXT4_I(inode)->i_disksize = new_i_size;
 
-	ret2 = ext4_generic_write_end(file, mapping, pos, len, copied,
+	ret2 = generic_write_end(file, mapping, pos, len, copied,
 							page, fsdata);
 	copied = ret2;
 	if (ret2 < 0)
@@ -1385,8 +1361,6 @@ static int ext4_writeback_write_end(struct file *file,
 	ret2 = ext4_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
-	unlock_page(page);
-	page_cache_release(page);
 
 	return ret ? ret : copied;
 }
@@ -1425,10 +1399,10 @@ static int ext4_journalled_write_end(struct file *file,
 			ret = ret2;
 	}
 
+	unlock_page(page);
 	ret2 = ext4_journal_stop(handle);
 	if (!ret)
 		ret = ret2;
-	unlock_page(page);
 	page_cache_release(page);
 
 	return ret ? ret : copied;
@@ -1506,11 +1480,10 @@ static int jbd2_journal_dirty_data_fn(handle_t *handle, struct buffer_head *bh)
 }
 
 /*
- * Note that we always start a transaction even if we're not journalling
- * data.  This is to preserve ordering: any hole instantiation within
- * __block_write_full_page -> ext4_get_block() should be journalled
- * along with the data so we don't crash and then get metadata which
- * refers to old data.
+ * Note that we don't need to start a transaction unless we're journaling
+ * data because we should have holes filled from ext4_page_mkwrite(). If
+ * we are journaling data, we cannot start transaction directly because
+ * transaction start ranks above page lock so we have to do some magic...
  *
  * In all journalling modes block_write_full_page() will start the I/O.
  *
@@ -1554,10 +1527,8 @@ static int jbd2_journal_dirty_data_fn(handle_t *handle, struct buffer_head *bh)
  * disastrous.  Any write() or metadata operation will sync the fs for
  * us.
  *
- * AKPM2: if all the page's buffers are mapped to disk and !data=journal,
- * we don't need to open a transaction here.
  */
-static int ext4_ordered_writepage(struct page *page,
+static int __ext4_ordered_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
 	struct inode *inode = page->mapping->host;
@@ -1566,22 +1537,6 @@ static int ext4_ordered_writepage(struct page *page,
 	int ret = 0;
 	int err;
 
-	J_ASSERT(PageLocked(page));
-
-	/*
-	 * We give up here if we're reentered, because it might be for a
-	 * different filesystem.
-	 */
-	if (ext4_journal_current_handle())
-		goto out_fail;
-
-	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode));
-
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		goto out_fail;
-	}
-
 	if (!page_has_buffers(page)) {
 		create_empty_buffers(page, inode->i_sb->s_blocksize,
 				(1 << BH_Dirty)|(1 << BH_Uptodate));
@@ -1605,114 +1560,139 @@ static int ext4_ordered_writepage(struct page *page,
 	 * and generally junk.
 	 */
 	if (ret == 0) {
-		err = walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE,
+		handle = ext4_journal_start(inode,
+					ext4_writepage_trans_blocks(inode));
+		if (IS_ERR(handle)) {
+			ret = PTR_ERR(handle);
+			goto out_put;
+		}
+
+		ret = walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE,
 					NULL, jbd2_journal_dirty_data_fn);
+		err = ext4_journal_stop(handle);
 		if (!ret)
 			ret = err;
 	}
-	walk_page_buffers(handle, page_bufs, 0,
-			PAGE_CACHE_SIZE, NULL, bput_one);
-	err = ext4_journal_stop(handle);
-	if (!ret)
-		ret = err;
+out_put:
+	walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE, NULL,
+			  bput_one);
 	return ret;
+}
+
+static int ext4_ordered_writepage(struct page *page,
+				struct writeback_control *wbc)
+{
+	J_ASSERT(PageLocked(page));
+
+	/*
+	 * We give up here if we're reentered, because it might be for a
+	 * different filesystem.
+	 */
+	if (!ext4_journal_current_handle())
+		return __ext4_ordered_writepage(page, wbc);
 
-out_fail:
 	redirty_page_for_writepage(wbc, page);
 	unlock_page(page);
-	return ret;
+	return 0;
 }
 
-static int ext4_writeback_writepage(struct page *page,
+static int __ext4_writeback_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
 	struct inode *inode = page->mapping->host;
+
+	if (test_opt(inode->i_sb, NOBH))
+		return nobh_writepage(page, ext4_get_block, wbc);
+	else
+		return block_write_full_page(page, ext4_get_block, wbc);
+}
+
+
+static int ext4_writeback_writepage(struct page *page,
+				struct writeback_control *wbc)
+{
+	if (!ext4_journal_current_handle())
+		return __ext4_writeback_writepage(page, wbc);
+
+	redirty_page_for_writepage(wbc, page);
+	unlock_page(page);
+	return 0;
+}
+
+static int __ext4_journalled_writepage(struct page *page,
+				struct writeback_control *wbc)
+{
+	struct address_space *mapping = page->mapping;
+	struct inode *inode = mapping->host;
+	struct buffer_head *page_bufs;
 	handle_t *handle = NULL;
 	int ret = 0;
 	int err;
 
-	if (ext4_journal_current_handle())
-		goto out_fail;
+	ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE, ext4_get_block);
+	if (ret != 0)
+		goto out_unlock;
+
+	page_bufs = page_buffers(page);
+	walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE, NULL,
+								bget_one);
+	/* As soon as we unlock the page, it can go away, but we have
+	 * references to buffers so we are safe */
+	unlock_page(page);
 
 	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode));
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
-		goto out_fail;
+		goto out;
 	}
 
-	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
-		ret = nobh_writepage(page, ext4_get_block, wbc);
-	else
-		ret = block_write_full_page(page, ext4_get_block, wbc);
+	ret = walk_page_buffers(handle, page_bufs, 0,
+			PAGE_CACHE_SIZE, NULL, do_journal_get_write_access);
 
+	err = walk_page_buffers(handle, page_bufs, 0,
+				PAGE_CACHE_SIZE, NULL, write_end_fn);
+	if (ret == 0)
+		ret = err;
 	err = ext4_journal_stop(handle);
 	if (!ret)
 		ret = err;
-	return ret;
 
-out_fail:
-	redirty_page_for_writepage(wbc, page);
+	walk_page_buffers(handle, page_bufs, 0,
+				PAGE_CACHE_SIZE, NULL, bput_one);
+	EXT4_I(inode)->i_state |= EXT4_STATE_JDATA;
+	goto out;
+
+out_unlock:
 	unlock_page(page);
+out:
 	return ret;
 }
 
 static int ext4_journalled_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
-	struct inode *inode = page->mapping->host;
-	handle_t *handle = NULL;
-	int ret = 0;
-	int err;
-
 	if (ext4_journal_current_handle())
 		goto no_write;
 
-	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode));
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		goto no_write;
-	}
-
 	if (!page_has_buffers(page) || PageChecked(page)) {
 		/*
 		 * It's mmapped pagecache.  Add buffers and journal it.  There
 		 * doesn't seem much point in redirtying the page here.
 		 */
 		ClearPageChecked(page);
-		ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE,
-					ext4_get_block);
-		if (ret != 0) {
-			ext4_journal_stop(handle);
-			goto out_unlock;
-		}
-		ret = walk_page_buffers(handle, page_buffers(page), 0,
-			PAGE_CACHE_SIZE, NULL, do_journal_get_write_access);
-
-		err = walk_page_buffers(handle, page_buffers(page), 0,
-				PAGE_CACHE_SIZE, NULL, write_end_fn);
-		if (ret == 0)
-			ret = err;
-		EXT4_I(inode)->i_state |= EXT4_STATE_JDATA;
-		unlock_page(page);
+		return __ext4_journalled_writepage(page, wbc);
 	} else {
 		/*
 		 * It may be a page full of checkpoint-mode buffers.  We don't
 		 * really know unless we go poke around in the buffer_heads.
 		 * But block_write_full_page will do the right thing.
 		 */
-		ret = block_write_full_page(page, ext4_get_block, wbc);
+		return block_write_full_page(page, ext4_get_block, wbc);
 	}
-	err = ext4_journal_stop(handle);
-	if (!ret)
-		ret = err;
-out:
-	return ret;
-
 no_write:
 	redirty_page_for_writepage(wbc, page);
-out_unlock:
 	unlock_page(page);
-	goto out;
+	return 0;
 }
 
 static int ext4_readpage(struct file *file, struct page *page)
@@ -1922,7 +1902,7 @@ void ext4_set_aops(struct inode *inode)
  * This required during truncate. We need to physically zero the tail end
  * of that block so it doesn't yield old data if the file is later grown.
  */
-int ext4_block_truncate_page(handle_t *handle, struct page *page,
+int ext4_block_truncate_page(handle_t *handle,
 		struct address_space *mapping, loff_t from)
 {
 	ext4_fsblk_t index = from >> PAGE_CACHE_SHIFT;
@@ -1931,8 +1911,13 @@ int ext4_block_truncate_page(handle_t *handle, struct page *page,
 	ext4_lblk_t iblock;
 	struct inode *inode = mapping->host;
 	struct buffer_head *bh;
+	struct page *page;
 	int err = 0;
 
+	page = grab_cache_page(mapping, from >> PAGE_CACHE_SHIFT);
+	if (!page)
+		return -EINVAL;
+
 	blocksize = inode->i_sb->s_blocksize;
 	length = blocksize - (offset & (blocksize - 1));
 	iblock = index << (PAGE_CACHE_SHIFT - inode->i_sb->s_blocksize_bits);
@@ -2396,7 +2381,6 @@ void ext4_truncate(struct inode *inode)
 	int n;
 	ext4_lblk_t last_block;
 	unsigned blocksize = inode->i_sb->s_blocksize;
-	struct page *page;
 
 	if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
 	    S_ISLNK(inode->i_mode)))
@@ -2406,41 +2390,21 @@ void ext4_truncate(struct inode *inode)
 	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
 		return;
 
-	/*
-	 * We have to lock the EOF page here, because lock_page() nests
-	 * outside jbd2_journal_start().
-	 */
-	if ((inode->i_size & (blocksize - 1)) == 0) {
-		/* Block boundary? Nothing to do */
-		page = NULL;
-	} else {
-		page = grab_cache_page(mapping,
-				inode->i_size >> PAGE_CACHE_SHIFT);
-		if (!page)
-			return;
-	}
-
 	if (EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) {
-		ext4_ext_truncate(inode, page);
+		ext4_ext_truncate(inode);
 		return;
 	}
 
 	handle = start_transaction(inode);
-	if (IS_ERR(handle)) {
-		if (page) {
-			clear_highpage(page);
-			flush_dcache_page(page);
-			unlock_page(page);
-			page_cache_release(page);
-		}
+	if (IS_ERR(handle))
 		return;		/* AKPM: return what? */
-	}
 
 	last_block = (inode->i_size + blocksize-1)
 					>> EXT4_BLOCK_SIZE_BITS(inode->i_sb);
 
-	if (page)
-		ext4_block_truncate_page(handle, page, mapping, inode->i_size);
+	if (inode->i_size & (blocksize - 1))
+		if (ext4_block_truncate_page(handle, mapping, inode->i_size))
+			goto out_stop;
 
 	n = ext4_block_to_path(inode, last_block, offsets, NULL);
 	if (n == 0)
@@ -3577,7 +3541,8 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 {
 	loff_t size;
 	unsigned long len;
-	int ret = -EINVAL;
+	int err, ret = -EINVAL;
+	handle_t *handle;
 	struct file *file = vma->vm_file;
 	struct inode *inode = file->f_path.dentry->d_inode;
 	struct address_space *mapping = inode->i_mapping;
@@ -3622,11 +3587,24 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page)
 	 * have inode_mutex and that allow parallel write_begin, write_end call.
 	 * (lock_page prevent this from happening on the same page though)
 	 */
+	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode));
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out_unlock;
+	}
 	lock_page(page);
 	wbc.range_start = page_offset(page);
 	wbc.range_end = page_offset(page) + len;
-	ret = mapping->a_ops->writepage(page, &wbc);
-	/* writepage unlocks the page */
+	if (ext4_should_writeback_data(inode))
+		ret = __ext4_writeback_writepage(page, &wbc);
+	else if (ext4_should_order_data(inode))
+		ret = __ext4_ordered_writepage(page, &wbc);
+	else
+		ret = __ext4_journalled_writepage(page, &wbc);
+	/* Page got unlocked in writepage */
+	err = ext4_journal_stop(handle);
+	if (!ret)
+		ret = err;
 out_unlock:
 	up_read(&inode->i_alloc_sem);
 	return ret;

--tThc/1wpZn/ma/RB
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="ext4-Set-journal-pointer-to-NULL-when-journal-is-re.patch"

From: Jan Kara <jack@suse.cz>
Date: Wed, 21 May 2008 17:01:22 +0200
Subject: [PATCH] ext4: Set journal pointer to NULL when journal is released

Set sbi->s_journal to NULL after we call journal_destroy(). This
will be later needed because after journal_destroy() is called,
ext4_clear_inode() can still be called for some inodes (e.g. root
inode) and we'll need to detect there that journal doesn't exists
anymore.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

Index: linux-2.6-linus/fs/ext4/super.c
===================================================================
--- linux-2.6-linus.orig/fs/ext4/super.c
+++ linux-2.6-linus/fs/ext4/super.c
@@ -506,6 +506,7 @@ static void ext4_put_super (struct super
 	ext4_ext_release(sb);
 	ext4_xattr_put_super(sb);
 	jbd2_journal_destroy(sbi->s_journal);
+	sbi->s_journal = NULL;
 	if (!(sb->s_flags & MS_RDONLY)) {
 		EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
 		es->s_state = cpu_to_le16(sbi->s_mount_state);
@@ -2398,6 +2399,7 @@ cantfind_ext4:
 
 failed_mount4:
 	jbd2_journal_destroy(sbi->s_journal);
+	sbi->s_journal = NULL;
 failed_mount3:
 	percpu_counter_destroy(&sbi->s_freeblocks_counter);
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);

--tThc/1wpZn/ma/RB
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="ext4-Use-new-framework-for-data-ordered-mode-in-JBD.patch"

From: Jan Kara <jack@suse.cz>
Date: Thu, 22 May 2008 00:51:17 +0200
Subject: [PATCH] ext4: Use new framework for data=ordered mode in JBD2

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/ext4_i.h    |    1 +
 fs/ext4/ext4_jbd2.h |    7 ++-
 fs/ext4/ialloc.c    |    1 +
 fs/ext4/inode.c     |  160 ++++++++++++++++++---------------------------------
 fs/ext4/super.c     |    4 +-
 5 files changed, 67 insertions(+), 106 deletions(-)

Index: linux-2.6-linus/fs/ext4/ext4_i.h
===================================================================
--- linux-2.6-linus.orig/fs/ext4/ext4_i.h
+++ linux-2.6-linus/fs/ext4/ext4_i.h
@@ -150,6 +150,7 @@ struct ext4_inode_info {
 	 */
 	struct rw_semaphore i_data_sem;
 	struct inode vfs_inode;
+	struct jbd2_inode jinode;
 
 	unsigned long i_ext_generation;
 	struct ext4_ext_cache i_cached_extent;
Index: linux-2.6-linus/fs/ext4/ext4_jbd2.h
===================================================================
--- linux-2.6-linus.orig/fs/ext4/ext4_jbd2.h
+++ linux-2.6-linus/fs/ext4/ext4_jbd2.h
@@ -154,8 +154,6 @@ int __ext4_journal_dirty_metadata(const
 #define ext4_journal_forget(handle, bh) \
 	__ext4_journal_forget(__FUNCTION__, (handle), (bh))
 
-int ext4_journal_dirty_data(handle_t *handle, struct buffer_head *bh);
-
 handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks);
 int __ext4_journal_stop(const char *where, handle_t *handle);
 
@@ -192,6 +190,11 @@ static inline int ext4_journal_force_com
 	return jbd2_journal_force_commit(journal);
 }
 
+static inline int ext4_jbd2_file_inode(handle_t *handle, struct inode *inode)
+{
+	return jbd2_journal_file_inode(handle, &EXT4_I(inode)->jinode);
+}
+
 /* super.c */
 int ext4_force_commit(struct super_block *sb);
 
Index: linux-2.6-linus/fs/ext4/ialloc.c
===================================================================
--- linux-2.6-linus.orig/fs/ext4/ialloc.c
+++ linux-2.6-linus/fs/ext4/ialloc.c
@@ -820,6 +820,7 @@ got:
 	ei->i_state = EXT4_STATE_NEW;
 
 	ei->i_extra_isize = EXT4_SB(sb)->s_want_extra_isize;
+	jbd2_journal_init_jbd_inode(&ei->jinode, inode);
 
 	ret = inode;
 	if(DQUOT_ALLOC_INODE(inode)) {
Index: linux-2.6-linus/fs/ext4/inode.c
===================================================================
--- linux-2.6-linus.orig/fs/ext4/inode.c
+++ linux-2.6-linus/fs/ext4/inode.c
@@ -39,6 +39,13 @@
 #include "xattr.h"
 #include "acl.h"
 
+static inline int ext4_begin_ordered_truncate(struct inode *inode,
+					      loff_t new_size)
+{
+	return jbd2_journal_begin_ordered_truncate(&EXT4_I(inode)->jinode,
+						   new_size);
+}
+
 /*
  * Test whether an inode is a fast symlink.
  */
@@ -181,6 +188,8 @@ void ext4_delete_inode (struct inode * i
 {
 	handle_t *handle;
 
+	if (ext4_should_order_data(inode))
+		ext4_begin_ordered_truncate(inode, 0);
 	truncate_inode_pages(&inode->i_data, 0);
 
 	if (is_bad_inode(inode))
@@ -1273,15 +1282,6 @@ out:
 	return ret;
 }
 
-int ext4_journal_dirty_data(handle_t *handle, struct buffer_head *bh)
-{
-	int err = jbd2_journal_dirty_data(handle, bh);
-	if (err)
-		ext4_journal_abort_handle(__func__, __func__,
-						bh, handle, err);
-	return err;
-}
-
 /* For write_end() in data=journal mode */
 static int write_end_fn(handle_t *handle, struct buffer_head *bh)
 {
@@ -1311,8 +1311,7 @@ static int ext4_ordered_write_end(struct
 	from = pos & (PAGE_CACHE_SIZE - 1);
 	to = from + len;
 
-	ret = walk_page_buffers(handle, page_buffers(page),
-		from, to, NULL, ext4_journal_dirty_data);
+	ret = ext4_jbd2_file_inode(handle, inode);
 
 	if (ret == 0) {
 		/*
@@ -1472,25 +1471,22 @@ static int bput_one(handle_t *handle, st
 	return 0;
 }
 
-static int jbd2_journal_dirty_data_fn(handle_t *handle, struct buffer_head *bh)
-{
-	if (buffer_mapped(bh))
-		return ext4_journal_dirty_data(handle, bh);
-	return 0;
-}
-
 static int ext4_bh_unmapped_or_delay(handle_t *handle, struct buffer_head *bh)
 {
 	return !buffer_mapped(bh) || buffer_delay(bh);
 }
 
 /*
- * Note that we don't need to start a transaction unless we're journaling
- * data because we should have holes filled from ext4_page_mkwrite(). If
- * we are journaling data, we cannot start transaction directly because
- * transaction start ranks above page lock so we have to do some magic...
+ * Note that we don't need to start a transaction unless we're journaling data
+ * because we should have holes filled from ext4_page_mkwrite(). We even don't
+ * need to file the inode to the transaction's list in ordered mode because if
+ * we are writing back data added by write(), the inode is already there and if
+ * we are writing back data modified via mmap(), noone guarantees in which
+ * transaction the data will hit the disk. In case we are journaling data, we
+ * cannot start transaction directly because transaction start ranks above page
+ * lock so we have to do some magic.
  *
- * In all journalling modes block_write_full_page() will start the I/O.
+ * In all journaling modes block_write_full_page() will start the I/O.
  *
  * Problem:
  *
@@ -1533,86 +1529,7 @@ static int ext4_bh_unmapped_or_delay(han
  * us.
  *
  */
-static int __ext4_ordered_writepage(struct page *page,
-				struct writeback_control *wbc)
-{
-	struct inode *inode = page->mapping->host;
-	struct buffer_head *page_bufs;
-	handle_t *handle = NULL;
-	int ret = 0;
-	int err;
-
-	if (!page_has_buffers(page)) {
-		create_empty_buffers(page, inode->i_sb->s_blocksize,
-				(1 << BH_Dirty)|(1 << BH_Uptodate));
-	}
-	page_bufs = page_buffers(page);
-	walk_page_buffers(handle, page_bufs, 0,
-			PAGE_CACHE_SIZE, NULL, bget_one);
-
-	ret = block_write_full_page(page, ext4_get_block, wbc);
-
-	/*
-	 * The page can become unlocked at any point now, and
-	 * truncate can then come in and change things.  So we
-	 * can't touch *page from now on.  But *page_bufs is
-	 * safe due to elevated refcount.
-	 */
-
-	/*
-	 * And attach them to the current transaction.  But only if
-	 * block_write_full_page() succeeded.  Otherwise they are unmapped,
-	 * and generally junk.
-	 */
-	if (ret == 0) {
-		handle = ext4_journal_start(inode,
-					ext4_writepage_trans_blocks(inode));
-		if (IS_ERR(handle)) {
-			ret = PTR_ERR(handle);
-			goto out_put;
-		}
-
-		ret = walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE,
-					NULL, jbd2_journal_dirty_data_fn);
-		err = ext4_journal_stop(handle);
-		if (!ret)
-			ret = err;
-	}
-out_put:
-	walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE, NULL,
-			  bput_one);
-	return ret;
-}
-
-static int ext4_ordered_writepage(struct page *page,
-				struct writeback_control *wbc)
-{
-	struct inode *inode = page->mapping->host;
-	loff_t size = i_size_read(inode);
-	loff_t len;
-
-	J_ASSERT(PageLocked(page));
-	J_ASSERT(page_has_buffers(page));
-	if (page->index == size >> PAGE_CACHE_SHIFT)
-		len = size & ~PAGE_CACHE_MASK;
-	else
-		len = PAGE_CACHE_SIZE;
-	BUG_ON(walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
-				 ext4_bh_unmapped_or_delay));
-
-	/*
-	 * We give up here if we're reentered, because it might be for a
-	 * different filesystem.
-	 */
-	if (!ext4_journal_current_handle())
-		return __ext4_ordered_writepage(page, wbc);
-
-	redirty_page_for_writepage(wbc, page);
-	unlock_page(page);
-	return 0;
-}
-
-static int __ext4_writeback_writepage(struct page *page,
+static int __ext4_normal_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
 	struct inode *inode = page->mapping->host;
@@ -1624,7 +1541,7 @@ static int __ext4_writeback_writepage(st
 }
 
 
-static int ext4_writeback_writepage(struct page *page,
+static int ext4_normal_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
 	struct inode *inode = page->mapping->host;
@@ -1641,7 +1558,7 @@ static int ext4_writeback_writepage(stru
 				 ext4_bh_unmapped_or_delay));
 
 	if (!ext4_journal_current_handle())
-		return __ext4_writeback_writepage(page, wbc);
+		return __ext4_normal_writepage(page, wbc);
 
 	redirty_page_for_writepage(wbc, page);
 	unlock_page(page);
@@ -1877,7 +1794,7 @@ static int ext4_journalled_set_page_dirt
 static const struct address_space_operations ext4_ordered_aops = {
 	.readpage	= ext4_readpage,
 	.readpages	= ext4_readpages,
-	.writepage	= ext4_ordered_writepage,
+	.writepage	= ext4_normal_writepage,
 	.sync_page	= block_sync_page,
 	.write_begin	= ext4_write_begin,
 	.write_end	= ext4_ordered_write_end,
@@ -1891,7 +1808,7 @@ static const struct address_space_operat
 static const struct address_space_operations ext4_writeback_aops = {
 	.readpage	= ext4_readpage,
 	.readpages	= ext4_readpages,
-	.writepage	= ext4_writeback_writepage,
+	.writepage	= ext4_normal_writepage,
 	.sync_page	= block_sync_page,
 	.write_begin	= ext4_write_begin,
 	.write_end	= ext4_writeback_write_end,
@@ -2019,7 +1936,7 @@ int ext4_block_truncate_page(handle_t *h
 		err = ext4_journal_dirty_metadata(handle, bh);
 	} else {
 		if (ext4_should_order_data(inode))
-			err = ext4_journal_dirty_data(handle, bh);
+			err = ext4_jbd2_file_inode(handle, inode);
 		mark_buffer_dirty(bh);
 	}
 
@@ -2787,6 +2704,7 @@ struct inode *ext4_iget(struct super_blo
 	ei->i_default_acl = EXT4_ACL_NOT_CACHED;
 #endif
 	ei->i_block_alloc_info = NULL;
+	jbd2_journal_init_jbd_inode(&ei->jinode, inode);
 
 	ret = __ext4_get_inode_loc(inode, &iloc, 0);
 	if (ret < 0)
@@ -3149,7 +3067,14 @@ int ext4_write_inode(struct inode *inode
  * be freed, so we have a strong guarantee that no future commit will
  * leave these blocks visible to the user.)
  *
- * Called with inode->sem down.
+ * Another thing we have to assure is that if we are in ordered mode
+ * and inode is still attached to the committing transaction, we must
+ * we start writeout of all the dirty pages which are being truncated.
+ * This way we are sure that all the data written in the previous
+ * transaction are already on disk (truncate waits for pages under
+ * writeback).
+ *
+ * Called with inode->i_mutex down.
  */
 int ext4_setattr(struct dentry *dentry, struct iattr *attr)
 {
@@ -3215,6 +3140,22 @@ int ext4_setattr(struct dentry *dentry,
 		if (!error)
 			error = rc;
 		ext4_journal_stop(handle);
+
+		if (ext4_should_order_data(inode)) {
+			error = ext4_begin_ordered_truncate(inode,
+							    attr->ia_size);
+			if (error) {
+				/* Do as much error cleanup as possible */
+				handle = ext4_journal_start(inode, 3);
+				if (IS_ERR(handle)) {
+					ext4_orphan_del(NULL, inode);
+					goto err_out;
+				}
+				ext4_orphan_del(handle, inode);
+				ext4_journal_stop(handle);
+				goto err_out;
+			}
+		}
 	}
 
 	rc = inode_setattr(inode, attr);
@@ -3624,12 +3565,13 @@ int ext4_page_mkwrite(struct vm_area_str
 	lock_page(page);
 	wbc.range_start = page_offset(page);
 	wbc.range_end = page_offset(page) + len;
-	if (ext4_should_writeback_data(inode))
-		ret = __ext4_writeback_writepage(page, &wbc);
-	else if (ext4_should_order_data(inode))
-		ret = __ext4_ordered_writepage(page, &wbc);
-	else
+	if (!ext4_should_journal_data(inode)) {
+		ret = __ext4_normal_writepage(page, &wbc);
+		if (!ret && ext4_should_order_data(inode))
+			ret = ext4_jbd2_file_inode(handle, inode);
+	} else {
 		ret = __ext4_journalled_writepage(page, &wbc);
+	}
 	/* Page got unlocked in writepage */
 	err = ext4_journal_stop(handle);
 	if (!ret)
Index: linux-2.6-linus/fs/ext4/super.c
===================================================================
--- linux-2.6-linus.orig/fs/ext4/super.c
+++ linux-2.6-linus/fs/ext4/super.c
@@ -637,6 +637,8 @@ static void ext4_clear_inode(struct inod
 	EXT4_I(inode)->i_block_alloc_info = NULL;
 	if (unlikely(rsv))
 		kfree(rsv);
+	jbd2_journal_release_jbd_inode(EXT4_SB(inode->i_sb)->s_journal,
+				       &EXT4_I(inode)->jinode);
 }
 
 static inline void ext4_show_quota_options(struct seq_file *seq, struct super_block *sb)
@@ -3353,7 +3355,7 @@ static ssize_t ext4_quota_write(struct s
 			err = ext4_journal_dirty_metadata(handle, bh);
 		else {
 			/* Always do at least ordered writes for quotas */
-			err = ext4_journal_dirty_data(handle, bh);
+			err = ext4_jbd2_file_inode(handle, inode);
 			mark_buffer_dirty(bh);
 		}
 		brelse(bh);
Index: linux-2.6-linus/fs/ext4/mballoc.c
===================================================================
--- linux-2.6-linus.orig/fs/ext4/mballoc.c
+++ linux-2.6-linus/fs/ext4/mballoc.c
@@ -2255,6 +2255,8 @@ static int ext4_mb_init_backend(struct s
 		printk(KERN_ERR "EXT4-fs: can't get new inode\n");
 		goto err_freesgi;
 	}
+	jbd2_journal_init_jbd_inode(&EXT4_I(sbi->s_buddy_cache)->jinode,
+				    sbi->s_buddy_cache);
 	EXT4_I(sbi->s_buddy_cache)->i_disksize = 0;
 
 	metalen = sizeof(*meta_group_info) << EXT4_DESC_PER_BLOCK_BITS(sb);

--tThc/1wpZn/ma/RB
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="jbd2-Implement-data-ordered-mode-handling-via-inode.patch"

From: Jan Kara <jack@suse.cz>
Date: Wed, 21 May 2008 17:48:42 +0200
Subject: [PATCH] jbd2: Implement data=ordered mode handling via inodes

This patch adds necessary framework into JBD2 to be able to track inodes
with each transaction and write-out their dirty data during transaction
commit time.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/commit.c      |   90 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/jbd2/journal.c     |   52 ++++++++++++++++++++++++++++
 fs/jbd2/transaction.c |   86 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/jbd2.h  |   42 +++++++++++++++++++++++
 4 files changed, 270 insertions(+), 0 deletions(-)

Index: linux-2.6-linus/fs/jbd2/commit.c
===================================================================
--- linux-2.6-linus.orig/fs/jbd2/commit.c
+++ linux-2.6-linus/fs/jbd2/commit.c
@@ -354,6 +354,81 @@ write_out_data:
 	journal_do_submit_data(wbuf, bufs);
 }
 
+/*
+ * Submit all the data buffers of inode associated with the transaction to
+ * disk.
+ *
+ * We are in a committing transaction. Therefore no new inode can be added to
+ * our inode list. We use JI_COMMIT_RUNNING flag to protect inode we currently
+ * operate on from being released while we write out pages.
+ */
+static int journal_submit_inode_data_buffers(journal_t *journal,
+		transaction_t *commit_transaction)
+{
+	struct jbd2_inode *jinode;
+	int err, ret = 0;
+	struct address_space *mapping;
+
+	spin_lock(&journal->j_list_lock);
+	list_for_each_entry(jinode, &commit_transaction->t_inode_list, i_list) {
+		mapping = jinode->i_vfs_inode->i_mapping;
+		jinode->i_flags |= JI_COMMIT_RUNNING;
+		spin_unlock(&journal->j_list_lock);
+		err = filemap_fdatawrite_range(mapping, 0,
+					i_size_read(jinode->i_vfs_inode));
+		if (!ret)
+			ret = err;
+		spin_lock(&journal->j_list_lock);
+		J_ASSERT(jinode->i_transaction == commit_transaction);
+		jinode->i_flags &= ~JI_COMMIT_RUNNING;
+		wake_up_bit(&jinode->i_flags, __JI_COMMIT_RUNNING);
+	}
+	spin_unlock(&journal->j_list_lock);
+	return ret;
+}
+
+/*
+ * Wait for data submitted for writeout, refile inodes to proper
+ * transaction if needed.
+ *
+ */
+static int journal_finish_inode_data_buffers(journal_t *journal,
+		transaction_t *commit_transaction)
+{
+	struct jbd2_inode *jinode, *next_i;
+	int err, ret = 0;
+
+	/* For locking, see the comment in journal_submit_inode_data_buffers() */
+	spin_lock(&journal->j_list_lock);
+	list_for_each_entry(jinode, &commit_transaction->t_inode_list, i_list) {
+		jinode->i_flags |= JI_COMMIT_RUNNING;
+		spin_unlock(&journal->j_list_lock);
+		err = filemap_fdatawait(jinode->i_vfs_inode->i_mapping);
+		if (!ret)
+			ret = err;
+		spin_lock(&journal->j_list_lock);
+		jinode->i_flags &= ~JI_COMMIT_RUNNING;
+		wake_up_bit(&jinode->i_flags, __JI_COMMIT_RUNNING);
+	}
+
+	/* Now refile inode to proper lists */
+	list_for_each_entry_safe(jinode, next_i,
+				 &commit_transaction->t_inode_list, i_list) {
+		list_del(&jinode->i_list);
+		if (jinode->i_next_transaction) {
+			jinode->i_transaction = jinode->i_next_transaction;
+			jinode->i_next_transaction = NULL;
+			list_add(&jinode->i_list,
+				&jinode->i_transaction->t_inode_list);
+		} else {
+			jinode->i_transaction = NULL;
+		}
+	}
+	spin_unlock(&journal->j_list_lock);
+
+	return ret;
+}
+
 static __u32 jbd2_checksum_data(__u32 crc32_sum, struct buffer_head *bh)
 {
 	struct page *page = bh->b_page;
@@ -528,6 +603,9 @@ void jbd2_journal_commit_transaction(jou
 	 */
 	err = 0;
 	journal_submit_data_buffers(journal, commit_transaction);
+	err = journal_submit_inode_data_buffers(journal, commit_transaction);
+	if (err)
+		jbd2_journal_abort(journal, err);
 
 	/*
 	 * Wait for all previously submitted IO to complete if commit
@@ -759,6 +837,17 @@ start_journal_io:
 			__jbd2_journal_abort_hard(journal);
 	}
 
+	/*
+	 * This is the right place to wait for data buffers both for ASYNC
+	 * and !ASYNC commit. If commit is ASYNC, we need to wait only after
+	 * the commit block went to disk (which happens above). If commit is
+	 * SYNC, we need to wait for data buffers before we start writing
+	 * commit block, which happens below in such setting.
+	 */
+	err = journal_finish_inode_data_buffers(journal, commit_transaction);
+	if (err)
+		jbd2_journal_abort(journal, err);
+
 	/* Lo and behold: we have just managed to send a transaction to
            the log.  Before we can commit it, wait for the IO so far to
            complete.  Control buffers being written are on the
@@ -879,6 +968,7 @@ wait_for_iobuf:
 	jbd_debug(3, "JBD: commit phase 7\n");
 
 	J_ASSERT(commit_transaction->t_sync_datalist == NULL);
+	J_ASSERT(list_empty(&commit_transaction->t_inode_list));
 	J_ASSERT(commit_transaction->t_buffers == NULL);
 	J_ASSERT(commit_transaction->t_checkpoint_list == NULL);
 	J_ASSERT(commit_transaction->t_iobuf_list == NULL);
Index: linux-2.6-linus/fs/jbd2/journal.c
===================================================================
--- linux-2.6-linus.orig/fs/jbd2/journal.c
+++ linux-2.6-linus/fs/jbd2/journal.c
@@ -82,6 +82,10 @@ EXPORT_SYMBOL(jbd2_journal_blocks_per_pa
 EXPORT_SYMBOL(jbd2_journal_invalidatepage);
 EXPORT_SYMBOL(jbd2_journal_try_to_free_buffers);
 EXPORT_SYMBOL(jbd2_journal_force_commit);
+EXPORT_SYMBOL(jbd2_journal_file_inode);
+EXPORT_SYMBOL(jbd2_journal_init_jbd_inode);
+EXPORT_SYMBOL(jbd2_journal_release_jbd_inode);
+EXPORT_SYMBOL(jbd2_journal_begin_ordered_truncate);
 
 static int journal_convert_superblock_v1(journal_t *, journal_superblock_t *);
 static void __journal_abort_soft (journal_t *journal, int errno);
@@ -2195,6 +2199,54 @@ void jbd2_journal_put_journal_head(struc
 }
 
 /*
+ * Initialize jbd inode head
+ */
+void jbd2_journal_init_jbd_inode(struct jbd2_inode *jinode, struct inode *inode)
+{
+	jinode->i_transaction = NULL;
+	jinode->i_next_transaction = NULL;
+	jinode->i_vfs_inode = inode;
+	jinode->i_flags = 0;
+	INIT_LIST_HEAD(&jinode->i_list);
+}
+
+/*
+ * Function to be called before we start removing inode from memory (i.e.,
+ * clear_inode() is a fine place to be called from). It removes inode from
+ * transaction's lists.
+ */
+void jbd2_journal_release_jbd_inode(journal_t *journal,
+				    struct jbd2_inode *jinode)
+{
+	int writeout = 0;
+
+	if (!journal)
+		return;
+restart:
+	spin_lock(&journal->j_list_lock);
+	/* Is commit writing out inode - we have to wait */
+	if (jinode->i_flags & JI_COMMIT_RUNNING) {
+		wait_queue_head_t *wq;
+		DEFINE_WAIT_BIT(wait, &jinode->i_flags, __JI_COMMIT_RUNNING);
+		wq = bit_waitqueue(&jinode->i_flags, __JI_COMMIT_RUNNING);
+		prepare_to_wait(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
+		spin_unlock(&journal->j_list_lock);
+		schedule();
+		finish_wait(wq, &wait.wait);
+		goto restart;
+	}
+
+	/* Do we need to wait for data writeback? */
+	if (journal->j_committing_transaction == jinode->i_transaction)
+		writeout = 1;
+	if (jinode->i_transaction) {
+		list_del(&jinode->i_list);
+		jinode->i_transaction = NULL;
+	}
+	spin_unlock(&journal->j_list_lock);
+}
+
+/*
  * debugfs tunables
  */
 #ifdef CONFIG_JBD2_DEBUG
Index: linux-2.6-linus/fs/jbd2/transaction.c
===================================================================
--- linux-2.6-linus.orig/fs/jbd2/transaction.c
+++ linux-2.6-linus/fs/jbd2/transaction.c
@@ -51,6 +51,7 @@ jbd2_get_transaction(journal_t *journal,
 	transaction->t_tid = journal->j_transaction_sequence++;
 	transaction->t_expires = jiffies + journal->j_commit_interval;
 	spin_lock_init(&transaction->t_handle_lock);
+	INIT_LIST_HEAD(&transaction->t_inode_list);
 
 	/* Set up the commit timer for the new transaction. */
 	journal->j_commit_timer.expires = round_jiffies(transaction->t_expires);
@@ -2195,3 +2196,88 @@ void jbd2_journal_refile_buffer(journal_
 	spin_unlock(&journal->j_list_lock);
 	__brelse(bh);
 }
+
+/*
+ * File inode in the inode list of the handle's transaction
+ */
+int jbd2_journal_file_inode(handle_t *handle, struct jbd2_inode *jinode)
+{
+	transaction_t *transaction = handle->h_transaction;
+	journal_t *journal = transaction->t_journal;
+
+	if (is_handle_aborted(handle))
+		return -EIO;
+
+	jbd_debug(4, "Adding inode %lu, tid:%d\n", jinode->i_vfs_inode->i_ino,
+			transaction->t_tid);
+
+	/*
+	 * First check whether inode isn't already on the transaction's
+	 * lists without taking the lock. Note that this check is safe
+	 * without the lock as we cannot race with somebody removing inode
+	 * from the transaction. The reason is that we remove inode from the
+	 * transaction only in journal_release_jbd_inode() and when we commit
+	 * the transaction. We are guarded from the first case by holding
+	 * a reference to the inode. We are safe against the second case
+	 * because if jinode->i_transaction == transaction, commit code
+	 * cannot touch the transaction because we hold reference to it,
+	 * and if jinode->i_next_transaction == transaction, commit code
+	 * will only file the inode where we want it.
+	 */
+	if (jinode->i_transaction == transaction ||
+	    jinode->i_next_transaction == transaction)
+		return 0;
+
+	spin_lock(&journal->j_list_lock);
+
+	if (jinode->i_transaction == transaction ||
+	    jinode->i_next_transaction == transaction)
+		goto done;
+
+	/* On some different transaction's list - should be
+	 * the committing one */
+	if (jinode->i_transaction) {
+		J_ASSERT(jinode->i_next_transaction == NULL);
+		J_ASSERT(jinode->i_transaction ==
+					journal->j_committing_transaction);
+		jinode->i_next_transaction = transaction;
+		goto done;
+	}
+	/* Not on any transaction list... */
+	J_ASSERT(!jinode->i_next_transaction);
+	jinode->i_transaction = transaction;
+	list_add(&jinode->i_list, &transaction->t_inode_list);
+done:
+	spin_unlock(&journal->j_list_lock);
+
+	return 0;
+}
+
+/*
+ * This function must be called when inode is journaled in ordered mode
+ * before truncation happens. It starts writeout of truncated part in
+ * case it is in the committing transaction so that we stand to ordered
+ * mode consistency guarantees.
+ */
+int jbd2_journal_begin_ordered_truncate(struct jbd2_inode *inode,
+					loff_t new_size)
+{
+	journal_t *journal;
+	transaction_t *commit_trans;
+	int ret = 0;
+
+	if (!inode->i_transaction && !inode->i_next_transaction)
+		goto out;
+	journal = inode->i_transaction->t_journal;
+	spin_lock(&journal->j_state_lock);
+	commit_trans = journal->j_committing_transaction;
+	spin_unlock(&journal->j_state_lock);
+	if (inode->i_transaction == commit_trans) {
+		ret = filemap_fdatawrite_range(inode->i_vfs_inode->i_mapping,
+			new_size, LLONG_MAX);
+		if (ret)
+			jbd2_journal_abort(journal, ret);
+	}
+out:
+	return ret;
+}
Index: linux-2.6-linus/include/linux/jbd2.h
===================================================================
--- linux-2.6-linus.orig/include/linux/jbd2.h
+++ linux-2.6-linus/include/linux/jbd2.h
@@ -381,6 +381,38 @@ static inline void jbd_unlock_bh_journal
 	bit_spin_unlock(BH_JournalHead, &bh->b_state);
 }
 
+/* Flags in jbd_inode->i_flags */
+#define __JI_COMMIT_RUNNING 0
+/* Commit of the inode data in progress. We use this flag to protect us from
+ * concurrent deletion of inode. We cannot use reference to inode for this
+ * since we cannot afford doing last iput() on behalf of kjournald
+ */
+#define JI_COMMIT_RUNNING (1 << __JI_COMMIT_RUNNING)
+
+/**
+ * struct jbd_inode is the structure linking inodes in ordered mode
+ *   present in a transaction so that we can sync them during commit.
+ */
+struct jbd2_inode {
+	/* Which transaction does this inode belong to? Either the running
+	 * transaction or the committing one. [j_list_lock] */
+	transaction_t *i_transaction;
+
+	/* Pointer to the running transaction modifying inode's data in case
+	 * there is already a committing transaction touching it. [j_list_lock] */
+	transaction_t *i_next_transaction;
+
+	/* List of inodes in the i_transaction [j_list_lock] */
+	struct list_head i_list;
+
+	/* VFS inode this inode belongs to [constant during the lifetime
+	 * of the structure] */
+	struct inode *i_vfs_inode;
+
+	/* Flags of inode [j_list_lock] */
+	unsigned int i_flags;
+};
+
 struct jbd2_revoke_table_s;
 
 /**
@@ -567,6 +599,12 @@ struct transaction_s
 	struct journal_head	*t_log_list;
 
 	/*
+	 * List of inodes whose data we've modified in data=ordered mode.
+	 * [j_list_lock]
+	 */
+	struct list_head	t_inode_list;
+
+	/*
 	 * Protects info related to handles
 	 */
 	spinlock_t		t_handle_lock;
@@ -1043,6 +1081,10 @@ extern void	   jbd2_journal_ack_err    (
 extern int	   jbd2_journal_clear_err  (journal_t *);
 extern int	   jbd2_journal_bmap(journal_t *, unsigned long, unsigned long long *);
 extern int	   jbd2_journal_force_commit(journal_t *);
+extern int	   jbd2_journal_file_inode(handle_t *handle, struct jbd2_inode *inode);
+extern int	   jbd2_journal_begin_ordered_truncate(struct jbd2_inode *inode, loff_t new_size);
+extern void	   jbd2_journal_init_jbd_inode(struct jbd2_inode *jinode, struct inode *inode);
+extern void	   jbd2_journal_release_jbd_inode(journal_t *journal, struct jbd2_inode *jinode);
 
 /*
  * journal_head management

--tThc/1wpZn/ma/RB
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="jbd2-Remove-data-ordered-mode-support-using-jbd-buf.patch"

>From c0b315ae14dd43e6684edeb47912077bf480e59c Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Thu, 22 May 2008 01:28:16 +0200
Subject: [PATCH] jbd2: Remove data=ordered mode support using jbd buffer heads

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/jbd2/checkpoint.c  |    1 -
 fs/jbd2/commit.c      |  230 ++-----------------------------------------------
 fs/jbd2/journal.c     |    1 -
 fs/jbd2/transaction.c |  217 ++---------------------------------------------
 include/linux/jbd2.h  |   29 ++-----
 5 files changed, 21 insertions(+), 457 deletions(-)

Index: linux-2.6-linus/fs/jbd2/checkpoint.c
===================================================================
--- linux-2.6-linus.orig/fs/jbd2/checkpoint.c
+++ linux-2.6-linus/fs/jbd2/checkpoint.c
@@ -688,7 +688,6 @@ void __jbd2_journal_drop_transaction(jou
 
 	J_ASSERT(transaction->t_state == T_FINISHED);
 	J_ASSERT(transaction->t_buffers == NULL);
-	J_ASSERT(transaction->t_sync_datalist == NULL);
 	J_ASSERT(transaction->t_forget == NULL);
 	J_ASSERT(transaction->t_iobuf_list == NULL);
 	J_ASSERT(transaction->t_shadow_list == NULL);
Index: linux-2.6-linus/fs/jbd2/commit.c
===================================================================
--- linux-2.6-linus.orig/fs/jbd2/commit.c
+++ linux-2.6-linus/fs/jbd2/commit.c
@@ -37,8 +37,8 @@ static void journal_end_buffer_io_sync(s
 }
 
 /*
- * When an ext3-ordered file is truncated, it is possible that many pages are
- * not sucessfully freed, because they are attached to a committing transaction.
+ * When an ext4 file is truncated, it is possible that some pages are not
+ * successfully freed, because they are attached to a committing transaction.
  * After the transaction commits, these pages are left on the LRU, with no
  * ->mapping, and with attached buffers.  These pages are trivially reclaimable
  * by the VM, but their apparent absence upsets the VM accounting, and it makes
@@ -80,21 +80,6 @@ nope:
 }
 
 /*
- * Try to acquire jbd_lock_bh_state() against the buffer, when j_list_lock is
- * held.  For ranking reasons we must trylock.  If we lose, schedule away and
- * return 0.  j_list_lock is dropped in this case.
- */
-static int inverted_lock(journal_t *journal, struct buffer_head *bh)
-{
-	if (!jbd_trylock_bh_state(bh)) {
-		spin_unlock(&journal->j_list_lock);
-		schedule();
-		return 0;
-	}
-	return 1;
-}
-
-/*
  * Done it all: now submit the commit record.  We should have
  * cleaned up our previous buffers by now, so if we are in abort
  * mode we can now just skip the rest of the journal write
@@ -199,162 +184,6 @@ static int journal_wait_on_commit_record
 }
 
 /*
- * Wait for all submitted IO to complete.
- */
-static int journal_wait_on_locked_list(journal_t *journal,
-				       transaction_t *commit_transaction)
-{
-	int ret = 0;
-	struct journal_head *jh;
-
-	while (commit_transaction->t_locked_list) {
-		struct buffer_head *bh;
-
-		jh = commit_transaction->t_locked_list->b_tprev;
-		bh = jh2bh(jh);
-		get_bh(bh);
-		if (buffer_locked(bh)) {
-			spin_unlock(&journal->j_list_lock);
-			wait_on_buffer(bh);
-			if (unlikely(!buffer_uptodate(bh)))
-				ret = -EIO;
-			spin_lock(&journal->j_list_lock);
-		}
-		if (!inverted_lock(journal, bh)) {
-			put_bh(bh);
-			spin_lock(&journal->j_list_lock);
-			continue;
-		}
-		if (buffer_jbd(bh) && jh->b_jlist == BJ_Locked) {
-			__jbd2_journal_unfile_buffer(jh);
-			jbd_unlock_bh_state(bh);
-			jbd2_journal_remove_journal_head(bh);
-			put_bh(bh);
-		} else {
-			jbd_unlock_bh_state(bh);
-		}
-		put_bh(bh);
-		cond_resched_lock(&journal->j_list_lock);
-	}
-	return ret;
-  }
-
-static void journal_do_submit_data(struct buffer_head **wbuf, int bufs)
-{
-	int i;
-
-	for (i = 0; i < bufs; i++) {
-		wbuf[i]->b_end_io = end_buffer_write_sync;
-		/* We use-up our safety reference in submit_bh() */
-		submit_bh(WRITE, wbuf[i]);
-	}
-}
-
-/*
- *  Submit all the data buffers to disk
- */
-static void journal_submit_data_buffers(journal_t *journal,
-				transaction_t *commit_transaction)
-{
-	struct journal_head *jh;
-	struct buffer_head *bh;
-	int locked;
-	int bufs = 0;
-	struct buffer_head **wbuf = journal->j_wbuf;
-
-	/*
-	 * Whenever we unlock the journal and sleep, things can get added
-	 * onto ->t_sync_datalist, so we have to keep looping back to
-	 * write_out_data until we *know* that the list is empty.
-	 *
-	 * Cleanup any flushed data buffers from the data list.  Even in
-	 * abort mode, we want to flush this out as soon as possible.
-	 */
-write_out_data:
-	cond_resched();
-	spin_lock(&journal->j_list_lock);
-
-	while (commit_transaction->t_sync_datalist) {
-		jh = commit_transaction->t_sync_datalist;
-		bh = jh2bh(jh);
-		locked = 0;
-
-		/* Get reference just to make sure buffer does not disappear
-		 * when we are forced to drop various locks */
-		get_bh(bh);
-		/* If the buffer is dirty, we need to submit IO and hence
-		 * we need the buffer lock. We try to lock the buffer without
-		 * blocking. If we fail, we need to drop j_list_lock and do
-		 * blocking lock_buffer().
-		 */
-		if (buffer_dirty(bh)) {
-			if (test_set_buffer_locked(bh)) {
-				BUFFER_TRACE(bh, "needs blocking lock");
-				spin_unlock(&journal->j_list_lock);
-				/* Write out all data to prevent deadlocks */
-				journal_do_submit_data(wbuf, bufs);
-				bufs = 0;
-				lock_buffer(bh);
-				spin_lock(&journal->j_list_lock);
-			}
-			locked = 1;
-		}
-		/* We have to get bh_state lock. Again out of order, sigh. */
-		if (!inverted_lock(journal, bh)) {
-			jbd_lock_bh_state(bh);
-			spin_lock(&journal->j_list_lock);
-		}
-		/* Someone already cleaned up the buffer? */
-		if (!buffer_jbd(bh)
-			|| jh->b_transaction != commit_transaction
-			|| jh->b_jlist != BJ_SyncData) {
-			jbd_unlock_bh_state(bh);
-			if (locked)
-				unlock_buffer(bh);
-			BUFFER_TRACE(bh, "already cleaned up");
-			put_bh(bh);
-			continue;
-		}
-		if (locked && test_clear_buffer_dirty(bh)) {
-			BUFFER_TRACE(bh, "needs writeout, adding to array");
-			wbuf[bufs++] = bh;
-			__jbd2_journal_file_buffer(jh, commit_transaction,
-						BJ_Locked);
-			jbd_unlock_bh_state(bh);
-			if (bufs == journal->j_wbufsize) {
-				spin_unlock(&journal->j_list_lock);
-				journal_do_submit_data(wbuf, bufs);
-				bufs = 0;
-				goto write_out_data;
-			}
-		} else if (!locked && buffer_locked(bh)) {
-			__jbd2_journal_file_buffer(jh, commit_transaction,
-						BJ_Locked);
-			jbd_unlock_bh_state(bh);
-			put_bh(bh);
-		} else {
-			BUFFER_TRACE(bh, "writeout complete: unfile");
-			__jbd2_journal_unfile_buffer(jh);
-			jbd_unlock_bh_state(bh);
-			if (locked)
-				unlock_buffer(bh);
-			jbd2_journal_remove_journal_head(bh);
-			/* Once for our safety reference, once for
-			 * jbd2_journal_remove_journal_head() */
-			put_bh(bh);
-			put_bh(bh);
-		}
-
-		if (need_resched() || spin_needbreak(&journal->j_list_lock)) {
-			spin_unlock(&journal->j_list_lock);
-			goto write_out_data;
-		}
-	}
-	spin_unlock(&journal->j_list_lock);
-	journal_do_submit_data(wbuf, bufs);
-}
-
-/*
  * Submit all the data buffers of inode associated with the transaction to
  * disk.
  *
@@ -601,42 +430,15 @@ void jbd2_journal_commit_transaction(jou
 	 * Now start flushing things to disk, in the order they appear
 	 * on the transaction lists.  Data blocks go first.
 	 */
-	err = 0;
-	journal_submit_data_buffers(journal, commit_transaction);
 	err = journal_submit_inode_data_buffers(journal, commit_transaction);
 	if (err)
 		jbd2_journal_abort(journal, err);
 
-	/*
-	 * Wait for all previously submitted IO to complete if commit
-	 * record is to be written synchronously.
-	 */
-	spin_lock(&journal->j_list_lock);
-	if (!JBD2_HAS_INCOMPAT_FEATURE(journal,
-		JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT))
-		err = journal_wait_on_locked_list(journal,
-						commit_transaction);
-
-	spin_unlock(&journal->j_list_lock);
-
-	if (err)
-		jbd2_journal_abort(journal, err);
-
 	jbd2_journal_write_revoke_records(journal, commit_transaction);
 
 	jbd_debug(3, "JBD: commit phase 2\n");
 
 	/*
-	 * If we found any dirty or locked buffers, then we should have
-	 * looped back up to the write_out_data label.  If there weren't
-	 * any then journal_clean_data_list should have wiped the list
-	 * clean by now, so check that it is in fact empty.
-	 */
-	J_ASSERT (commit_transaction->t_sync_datalist == NULL);
-
-	jbd_debug (3, "JBD: commit phase 3\n");
-
-	/*
 	 * Way to go: we have now written out all of the data for a
 	 * transaction!  Now comes the tricky part: we need to write out
 	 * metadata.  Loop over the transaction's entire buffer list:
@@ -654,6 +456,7 @@ void jbd2_journal_commit_transaction(jou
 	J_ASSERT(commit_transaction->t_nr_buffers <=
 		 commit_transaction->t_outstanding_credits);
 
+	err = 0;
 	descriptor = NULL;
 	bufs = 0;
 	while (commit_transaction->t_buffers) {
@@ -828,13 +631,6 @@ start_journal_io:
 						 &cbh, crc32_sum);
 		if (err)
 			__jbd2_journal_abort_hard(journal);
-
-		spin_lock(&journal->j_list_lock);
-		err = journal_wait_on_locked_list(journal,
-						commit_transaction);
-		spin_unlock(&journal->j_list_lock);
-		if (err)
-			__jbd2_journal_abort_hard(journal);
 	}
 
 	/*
@@ -859,7 +655,7 @@ start_journal_io:
 	   so we incur less scheduling load.
 	*/
 
-	jbd_debug(3, "JBD: commit phase 4\n");
+	jbd_debug(3, "JBD: commit phase 3\n");
 
 	/*
 	 * akpm: these are BJ_IO, and j_list_lock is not needed.
@@ -918,7 +714,7 @@ wait_for_iobuf:
 
 	J_ASSERT (commit_transaction->t_shadow_list == NULL);
 
-	jbd_debug(3, "JBD: commit phase 5\n");
+	jbd_debug(3, "JBD: commit phase 4\n");
 
 	/* Here we wait for the revoke record and descriptor record buffers */
  wait_for_ctlbuf:
@@ -945,7 +741,7 @@ wait_for_iobuf:
 		/* AKPM: bforget here */
 	}
 
-	jbd_debug(3, "JBD: commit phase 6\n");
+	jbd_debug(3, "JBD: commit phase 5\n");
 
 	if (!JBD2_HAS_INCOMPAT_FEATURE(journal,
 		JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)) {
@@ -965,9 +761,8 @@ wait_for_iobuf:
            transaction can be removed from any checkpoint list it was on
            before. */
 
-	jbd_debug(3, "JBD: commit phase 7\n");
+	jbd_debug(3, "JBD: commit phase 6\n");
 
-	J_ASSERT(commit_transaction->t_sync_datalist == NULL);
 	J_ASSERT(list_empty(&commit_transaction->t_inode_list));
 	J_ASSERT(commit_transaction->t_buffers == NULL);
 	J_ASSERT(commit_transaction->t_checkpoint_list == NULL);
@@ -1089,7 +884,7 @@ restart_loop:
 
 	/* Done with this transaction! */
 
-	jbd_debug(3, "JBD: commit phase 8\n");
+	jbd_debug(3, "JBD: commit phase 7\n");
 
 	J_ASSERT(commit_transaction->t_state == T_COMMIT);
 
Index: linux-2.6-linus/fs/jbd2/journal.c
===================================================================
--- linux-2.6-linus.orig/fs/jbd2/journal.c
+++ linux-2.6-linus/fs/jbd2/journal.c
@@ -50,7 +50,6 @@ EXPORT_SYMBOL(jbd2_journal_unlock_update
 EXPORT_SYMBOL(jbd2_journal_get_write_access);
 EXPORT_SYMBOL(jbd2_journal_get_create_access);
 EXPORT_SYMBOL(jbd2_journal_get_undo_access);
-EXPORT_SYMBOL(jbd2_journal_dirty_data);
 EXPORT_SYMBOL(jbd2_journal_dirty_metadata);
 EXPORT_SYMBOL(jbd2_journal_release_buffer);
 EXPORT_SYMBOL(jbd2_journal_forget);
Index: linux-2.6-linus/fs/jbd2/transaction.c
===================================================================
--- linux-2.6-linus.orig/fs/jbd2/transaction.c
+++ linux-2.6-linus/fs/jbd2/transaction.c
@@ -943,183 +943,6 @@ out:
 }
 
 /**
- * int jbd2_journal_dirty_data() -  mark a buffer as containing dirty data which
- *                             needs to be flushed before we can commit the
- *                             current transaction.
- * @handle: transaction
- * @bh: bufferhead to mark
- *
- * The buffer is placed on the transaction's data list and is marked as
- * belonging to the transaction.
- *
- * Returns error number or 0 on success.
- *
- * jbd2_journal_dirty_data() can be called via page_launder->ext3_writepage
- * by kswapd.
- */
-int jbd2_journal_dirty_data(handle_t *handle, struct buffer_head *bh)
-{
-	journal_t *journal = handle->h_transaction->t_journal;
-	int need_brelse = 0;
-	struct journal_head *jh;
-
-	if (is_handle_aborted(handle))
-		return 0;
-
-	jh = jbd2_journal_add_journal_head(bh);
-	JBUFFER_TRACE(jh, "entry");
-
-	/*
-	 * The buffer could *already* be dirty.  Writeout can start
-	 * at any time.
-	 */
-	jbd_debug(4, "jh: %p, tid:%d\n", jh, handle->h_transaction->t_tid);
-
-	/*
-	 * What if the buffer is already part of a running transaction?
-	 *
-	 * There are two cases:
-	 * 1) It is part of the current running transaction.  Refile it,
-	 *    just in case we have allocated it as metadata, deallocated
-	 *    it, then reallocated it as data.
-	 * 2) It is part of the previous, still-committing transaction.
-	 *    If all we want to do is to guarantee that the buffer will be
-	 *    written to disk before this new transaction commits, then
-	 *    being sure that the *previous* transaction has this same
-	 *    property is sufficient for us!  Just leave it on its old
-	 *    transaction.
-	 *
-	 * In case (2), the buffer must not already exist as metadata
-	 * --- that would violate write ordering (a transaction is free
-	 * to write its data at any point, even before the previous
-	 * committing transaction has committed).  The caller must
-	 * never, ever allow this to happen: there's nothing we can do
-	 * about it in this layer.
-	 */
-	jbd_lock_bh_state(bh);
-	spin_lock(&journal->j_list_lock);
-
-	/* Now that we have bh_state locked, are we really still mapped? */
-	if (!buffer_mapped(bh)) {
-		JBUFFER_TRACE(jh, "unmapped buffer, bailing out");
-		goto no_journal;
-	}
-
-	if (jh->b_transaction) {
-		JBUFFER_TRACE(jh, "has transaction");
-		if (jh->b_transaction != handle->h_transaction) {
-			JBUFFER_TRACE(jh, "belongs to older transaction");
-			J_ASSERT_JH(jh, jh->b_transaction ==
-					journal->j_committing_transaction);
-
-			/* @@@ IS THIS TRUE  ? */
-			/*
-			 * Not any more.  Scenario: someone does a write()
-			 * in data=journal mode.  The buffer's transaction has
-			 * moved into commit.  Then someone does another
-			 * write() to the file.  We do the frozen data copyout
-			 * and set b_next_transaction to point to j_running_t.
-			 * And while we're in that state, someone does a
-			 * writepage() in an attempt to pageout the same area
-			 * of the file via a shared mapping.  At present that
-			 * calls jbd2_journal_dirty_data(), and we get right here.
-			 * It may be too late to journal the data.  Simply
-			 * falling through to the next test will suffice: the
-			 * data will be dirty and wil be checkpointed.  The
-			 * ordering comments in the next comment block still
-			 * apply.
-			 */
-			//J_ASSERT_JH(jh, jh->b_next_transaction == NULL);
-
-			/*
-			 * If we're journalling data, and this buffer was
-			 * subject to a write(), it could be metadata, forget
-			 * or shadow against the committing transaction.  Now,
-			 * someone has dirtied the same darn page via a mapping
-			 * and it is being writepage()'d.
-			 * We *could* just steal the page from commit, with some
-			 * fancy locking there.  Instead, we just skip it -
-			 * don't tie the page's buffers to the new transaction
-			 * at all.
-			 * Implication: if we crash before the writepage() data
-			 * is written into the filesystem, recovery will replay
-			 * the write() data.
-			 */
-			if (jh->b_jlist != BJ_None &&
-					jh->b_jlist != BJ_SyncData &&
-					jh->b_jlist != BJ_Locked) {
-				JBUFFER_TRACE(jh, "Not stealing");
-				goto no_journal;
-			}
-
-			/*
-			 * This buffer may be undergoing writeout in commit.  We
-			 * can't return from here and let the caller dirty it
-			 * again because that can cause the write-out loop in
-			 * commit to never terminate.
-			 */
-			if (buffer_dirty(bh)) {
-				get_bh(bh);
-				spin_unlock(&journal->j_list_lock);
-				jbd_unlock_bh_state(bh);
-				need_brelse = 1;
-				sync_dirty_buffer(bh);
-				jbd_lock_bh_state(bh);
-				spin_lock(&journal->j_list_lock);
-				/* Since we dropped the lock... */
-				if (!buffer_mapped(bh)) {
-					JBUFFER_TRACE(jh, "buffer got unmapped");
-					goto no_journal;
-				}
-				/* The buffer may become locked again at any
-				   time if it is redirtied */
-			}
-
-			/* journal_clean_data_list() may have got there first */
-			if (jh->b_transaction != NULL) {
-				JBUFFER_TRACE(jh, "unfile from commit");
-				__jbd2_journal_temp_unlink_buffer(jh);
-				/* It still points to the committing
-				 * transaction; move it to this one so
-				 * that the refile assert checks are
-				 * happy. */
-				jh->b_transaction = handle->h_transaction;
-			}
-			/* The buffer will be refiled below */
-
-		}
-		/*
-		 * Special case --- the buffer might actually have been
-		 * allocated and then immediately deallocated in the previous,
-		 * committing transaction, so might still be left on that
-		 * transaction's metadata lists.
-		 */
-		if (jh->b_jlist != BJ_SyncData && jh->b_jlist != BJ_Locked) {
-			JBUFFER_TRACE(jh, "not on correct data list: unfile");
-			J_ASSERT_JH(jh, jh->b_jlist != BJ_Shadow);
-			__jbd2_journal_temp_unlink_buffer(jh);
-			jh->b_transaction = handle->h_transaction;
-			JBUFFER_TRACE(jh, "file as data");
-			__jbd2_journal_file_buffer(jh, handle->h_transaction,
-						BJ_SyncData);
-		}
-	} else {
-		JBUFFER_TRACE(jh, "not on a transaction");
-		__jbd2_journal_file_buffer(jh, handle->h_transaction, BJ_SyncData);
-	}
-no_journal:
-	spin_unlock(&journal->j_list_lock);
-	jbd_unlock_bh_state(bh);
-	if (need_brelse) {
-		BUFFER_TRACE(bh, "brelse");
-		__brelse(bh);
-	}
-	JBUFFER_TRACE(jh, "exit");
-	jbd2_journal_put_journal_head(jh);
-	return 0;
-}
-
-/**
  * int jbd2_journal_dirty_metadata() -  mark a buffer as containing dirty metadata
  * @handle: transaction to add buffer to.
  * @bh: buffer to mark
@@ -1541,10 +1364,10 @@ __blist_del_buffer(struct journal_head *
  * Remove a buffer from the appropriate transaction list.
  *
  * Note that this function can *change* the value of
- * bh->b_transaction->t_sync_datalist, t_buffers, t_forget,
- * t_iobuf_list, t_shadow_list, t_log_list or t_reserved_list.  If the caller
- * is holding onto a copy of one of thee pointers, it could go bad.
- * Generally the caller needs to re-read the pointer from the transaction_t.
+ * bh->b_transaction->t_buffers, t_forget, t_iobuf_list, t_shadow_list,
+ * t_log_list or t_reserved_list.  If the caller is holding onto a copy of one
+ * of these pointers, it could go bad.  Generally the caller needs to re-read
+ * the pointer from the transaction_t.
  *
  * Called under j_list_lock.  The journal may not be locked.
  */
@@ -1566,9 +1389,6 @@ void __jbd2_journal_temp_unlink_buffer(s
 	switch (jh->b_jlist) {
 	case BJ_None:
 		return;
-	case BJ_SyncData:
-		list = &transaction->t_sync_datalist;
-		break;
 	case BJ_Metadata:
 		transaction->t_nr_buffers--;
 		J_ASSERT_JH(jh, transaction->t_nr_buffers >= 0);
@@ -1589,9 +1409,6 @@ void __jbd2_journal_temp_unlink_buffer(s
 	case BJ_Reserved:
 		list = &transaction->t_reserved_list;
 		break;
-	case BJ_Locked:
-		list = &transaction->t_locked_list;
-		break;
 	}
 
 	__blist_del_buffer(list, jh);
@@ -1634,15 +1451,7 @@ __journal_try_to_free_buffer(journal_t *
 		goto out;
 
 	spin_lock(&journal->j_list_lock);
-	if (jh->b_transaction != NULL && jh->b_cp_transaction == NULL) {
-		if (jh->b_jlist == BJ_SyncData || jh->b_jlist == BJ_Locked) {
-			/* A written-back ordered data buffer */
-			JBUFFER_TRACE(jh, "release data");
-			__jbd2_journal_unfile_buffer(jh);
-			jbd2_journal_remove_journal_head(bh);
-			__brelse(bh);
-		}
-	} else if (jh->b_cp_transaction != NULL && jh->b_transaction == NULL) {
+	if (jh->b_cp_transaction != NULL && jh->b_transaction == NULL) {
 		/* written-back checkpointed metadata buffer */
 		if (jh->b_jlist == BJ_None) {
 			JBUFFER_TRACE(jh, "remove from checkpoint list");
@@ -1878,6 +1687,7 @@ static int journal_unmap_buffer(journal_
 	if (!buffer_jbd(bh))
 		goto zap_buffer_unlocked;
 
+	/* OK, we have data buffer in journaled mode */
 	spin_lock(&journal->j_state_lock);
 	jbd_lock_bh_state(bh);
 	spin_lock(&journal->j_list_lock);
@@ -1941,15 +1751,6 @@ static int journal_unmap_buffer(journal_
 		}
 	} else if (transaction == journal->j_committing_transaction) {
 		JBUFFER_TRACE(jh, "on committing transaction");
-		if (jh->b_jlist == BJ_Locked) {
-			/*
-			 * The buffer is on the committing transaction's locked
-			 * list.  We have the buffer locked, so I/O has
-			 * completed.  So we can nail the buffer now.
-			 */
-			may_free = __dispose_buffer(jh, transaction);
-			goto zap_buffer;
-		}
 		/*
 		 * If it is committing, we simply cannot touch it.  We
 		 * can remove it's next_transaction pointer from the
@@ -2082,9 +1883,6 @@ void __jbd2_journal_file_buffer(struct j
 		J_ASSERT_JH(jh, !jh->b_committed_data);
 		J_ASSERT_JH(jh, !jh->b_frozen_data);
 		return;
-	case BJ_SyncData:
-		list = &transaction->t_sync_datalist;
-		break;
 	case BJ_Metadata:
 		transaction->t_nr_buffers++;
 		list = &transaction->t_buffers;
@@ -2104,9 +1902,6 @@ void __jbd2_journal_file_buffer(struct j
 	case BJ_Reserved:
 		list = &transaction->t_reserved_list;
 		break;
-	case BJ_Locked:
-		list =  &transaction->t_locked_list;
-		break;
 	}
 
 	__blist_add_buffer(list, jh);
Index: linux-2.6-linus/include/linux/jbd2.h
===================================================================
--- linux-2.6-linus.orig/include/linux/jbd2.h
+++ linux-2.6-linus/include/linux/jbd2.h
@@ -543,24 +543,12 @@ struct transaction_s
 	struct journal_head	*t_reserved_list;
 
 	/*
-	 * Doubly-linked circular list of all buffers under writeout during
-	 * commit [j_list_lock]
-	 */
-	struct journal_head	*t_locked_list;
-
-	/*
 	 * Doubly-linked circular list of all metadata buffers owned by this
 	 * transaction [j_list_lock]
 	 */
 	struct journal_head	*t_buffers;
 
 	/*
-	 * Doubly-linked circular list of all data buffers still to be
-	 * flushed before this transaction can be committed [j_list_lock]
-	 */
-	struct journal_head	*t_sync_datalist;
-
-	/*
 	 * Doubly-linked circular list of all forget buffers (superseded
 	 * buffers which we can un-checkpoint once this transaction commits)
 	 * [j_list_lock]
@@ -1041,7 +1029,6 @@ extern int	 jbd2_journal_extend (handle_
 extern int	 jbd2_journal_get_write_access(handle_t *, struct buffer_head *);
 extern int	 jbd2_journal_get_create_access (handle_t *, struct buffer_head *);
 extern int	 jbd2_journal_get_undo_access(handle_t *, struct buffer_head *);
-extern int	 jbd2_journal_dirty_data (handle_t *, struct buffer_head *);
 extern int	 jbd2_journal_dirty_metadata (handle_t *, struct buffer_head *);
 extern void	 jbd2_journal_release_buffer (handle_t *, struct buffer_head *);
 extern int	 jbd2_journal_forget (handle_t *, struct buffer_head *);
@@ -1220,15 +1207,13 @@ static inline int jbd_space_needed(journ
 
 /* journaling buffer types */
 #define BJ_None		0	/* Not journaled */
-#define BJ_SyncData	1	/* Normal data: flush before commit */
-#define BJ_Metadata	2	/* Normal journaled metadata */
-#define BJ_Forget	3	/* Buffer superseded by this transaction */
-#define BJ_IO		4	/* Buffer is for temporary IO use */
-#define BJ_Shadow	5	/* Buffer contents being shadowed to the log */
-#define BJ_LogCtl	6	/* Buffer contains log descriptors */
-#define BJ_Reserved	7	/* Buffer is reserved for access by journal */
-#define BJ_Locked	8	/* Locked for I/O during commit */
-#define BJ_Types	9
+#define BJ_Metadata	1	/* Normal journaled metadata */
+#define BJ_Forget	2	/* Buffer superseded by this transaction */
+#define BJ_IO		3	/* Buffer is for temporary IO use */
+#define BJ_Shadow	4	/* Buffer contents being shadowed to the log */
+#define BJ_LogCtl	5	/* Buffer contains log descriptors */
+#define BJ_Reserved	6	/* Buffer is reserved for access by journal */
+#define BJ_Types	7
 
 extern int jbd_blocks_per_page(struct inode *inode);
 

--tThc/1wpZn/ma/RB
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="vfs-export-filemap_fdatawrite_range.patch"

From: Jan Kara <jack@suse.cz>
Date: Wed, 21 May 2008 17:05:23 +0200
Subject: [PATCH] vfs: export filemap_fdatawrite_range()

Make filemap_fdatawrite_range() function public, so that it can later
be used in ordered mode rewrite by JBD/JBD2.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/fs.h |    2 ++
 mm/filemap.c       |    3 ++-
 2 files changed, 4 insertions(+), 1 deletions(-)

Index: linux-2.6-linus/include/linux/fs.h
===================================================================
--- linux-2.6-linus.orig/include/linux/fs.h
+++ linux-2.6-linus/include/linux/fs.h
@@ -1741,6 +1741,8 @@ extern int wait_on_page_writeback_range(
 				pgoff_t start, pgoff_t end);
 extern int __filemap_fdatawrite_range(struct address_space *mapping,
 				loff_t start, loff_t end, int sync_mode);
+extern int filemap_fdatawrite_range(struct address_space *mapping,
+				loff_t start, loff_t end);
 
 extern long do_fsync(struct file *file, int datasync);
 extern void sync_supers(void);
Index: linux-2.6-linus/mm/filemap.c
===================================================================
--- linux-2.6-linus.orig/mm/filemap.c
+++ linux-2.6-linus/mm/filemap.c
@@ -236,11 +236,12 @@ int filemap_fdatawrite(struct address_sp
 }
 EXPORT_SYMBOL(filemap_fdatawrite);
 
-static int filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
+int filemap_fdatawrite_range(struct address_space *mapping, loff_t start,
 				loff_t end)
 {
 	return __filemap_fdatawrite_range(mapping, start, end, WB_SYNC_ALL);
 }
+EXPORT_SYMBOL(filemap_fdatawrite_range);
 
 /**
  * filemap_flush - mostly a non-blocking flush

--tThc/1wpZn/ma/RB--
