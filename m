From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: ext4 assertion failure from delalllc-ext4-lock-reverse.patch
Date: Wed, 23 Apr 2008 15:51:24 -0700
Message-ID: <1208991084.3600.29.camel@localhost.localdomain>
References: <E1JoVCC-0002AA-Dt@closure.thunk.org>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33040 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbYDWWvt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Apr 2008 18:51:49 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m3NMplB2008785
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 18:51:47 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m3NMplqW1090010
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 18:51:47 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m3NMpbdf001981
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 18:51:37 -0400
In-Reply-To: <E1JoVCC-0002AA-Dt@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 2008-04-22 at 22:58 -0400, Theodore Ts'o wrote:
> I just got a kernel bug in EXT4 using 2.6.25 with the ext4 patch queue.
> 
> The oops is here, in ext4_da_get_block_write, and the patch involved is
> delalloc-ext4-lock-reverse.patch:
> 
Thanks for catching this!

> static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
> 				   struct buffer_head *bh_result, int create)
> {
> 	int ret;
> 	unsigned max_blocks = bh_result->b_size >> inode->i_blkbits;
> 	loff_t disksize = EXT4_I(inode)->i_disksize;
> 	handle_t *handle = NULL;
> 
> 	J_ASSERT(handle != NULL || create == 0);

Oops that is a typo, the intention is checking if create is 1 or not,
with J_ASSERT, the condition should be write as create == 1, unlike
BUG_ON. (My head was also confused initially)


> 	handle = ext4_journal_current_handle();
> 
> Note that checking for handle != NULL *before* calling
> ext4_journal_current_handle() seems kinda of pointless, since handle is
> guaranteed to be NULL at this point.

Yes you are correct.

>    But it does mean that we know the
> problem has to be caused by create being 0.
> 

> Grubbing around fs/mpage.c, it's not hard to find some paths where a
> passed in get_blocks() function is called with create==0, so this is
> clearly a bug.  ext4_da_get_block_write() needs to be able to gracefully
> handle the case where create is set to 0.  
> 

In the read case, readpage function calls get_block() with create == 0,
indicating that just a plain lookup. But in the write case, it should
passing create ==1 all the time: at write_begin() and writepage(s).

In current ext4 delayed allocation implementation,
ext4_da_get_block_write() is only used in ext4_da_writepages() time, as
it is alwas expecting the create flag set to be 1, to asking for block
allocations.

I have updated the patch queue, updated delalloc-ext4-lock-reverse.patch
is attached.


Regards,
Mingming

Signed-off-by: Mingming Cao <cmm@us.ibm.com>

---
 fs/ext4/inode.c     |   94 ++++++++++++++++++++++++++++++++++++----------------
 mm/page-writeback.c |    2 -
 2 files changed, 67 insertions(+), 29 deletions(-)

Index: linux-2.6.25/fs/ext4/inode.c
===================================================================
--- linux-2.6.25.orig/fs/ext4/inode.c	2008-04-23 15:37:02.000000000 -0700
+++ linux-2.6.25/fs/ext4/inode.c	2008-04-23 15:46:51.000000000 -0700
@@ -1412,18 +1412,14 @@ static int ext4_da_get_block_prep(struct
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
@@ -1458,29 +1454,17 @@ static int ext4_da_get_block_write(struc
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
-
-	if (ext4_journal_current_handle())
-		goto out_fail;
 
-	handle = ext4_journal_start(inode, ext4_writepage_trans_blocks(inode));
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		goto out_fail;
-	}
+	handle = ext4_journal_current_handle();
 
 	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
 		ret = nobh_writepage(page, ext4_get_block, wbc);
@@ -1492,21 +1476,76 @@ static int ext4_da_writepage(struct page
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
+		ret = mpage_da_writepages(mapping, wbc, ext4_da_get_block_write);
+		ext4_journal_stop(handle);
+		to_write +=wbc->nr_to_write;
+	}
+
+out_writepages:
+	wbc->nr_to_write = to_write;
+	wbc->range_cyclic = range_cyclic;
+	return ret;
 }
 
 static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
Index: linux-2.6.25/mm/page-writeback.c
===================================================================
--- linux-2.6.25.orig/mm/page-writeback.c	2008-04-16 19:49:44.000000000 -0700
+++ linux-2.6.25/mm/page-writeback.c	2008-04-23 15:37:02.000000000 -0700
@@ -816,7 +816,7 @@ int write_cache_pages(struct address_spa
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index; /* Start from prev offset */
-		end = -1;
+		end = wbc->range_end >> PAGE_CACHE_SHIFT;
 	} else {
 		index = wbc->range_start >> PAGE_CACHE_SHIFT;
 		end = wbc->range_end >> PAGE_CACHE_SHIFT;



