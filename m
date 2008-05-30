From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4:  inverse locking ordering of page_lock and transaction start in delalloc
Date: Fri, 30 May 2008 19:09:28 +0530
Message-ID: <1212154769-16486-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1212154769-16486-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1212154769-16486-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1212154769-16486-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1212154769-16486-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1212154769-16486-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, jack@suse.cz
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:51197 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbYE3Nkh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 May 2008 09:40:37 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m4UDe2nc007145
	for <linux-ext4@vger.kernel.org>; Fri, 30 May 2008 23:40:02 +1000
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4UDikDI279004
	for <linux-ext4@vger.kernel.org>; Fri, 30 May 2008 23:44:46 +1000
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4UDeYA2024469
	for <linux-ext4@vger.kernel.org>; Fri, 30 May 2008 23:40:35 +1000
In-Reply-To: <1212154769-16486-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Mingming Cao <cmm@us.ibm.com>

Inverse locking ordering of page_lock and transaction start in delalloc

Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/inode.c |   96 +++++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 68 insertions(+), 28 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 62b38b6..65e02a3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1448,18 +1448,14 @@ static int ext4_da_get_block_prep(struct inode *inode, sector_t iblock,
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
@@ -1494,29 +1490,17 @@ static int ext4_da_get_block_write(struct inode *inode, sector_t iblock,
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
@@ -1528,21 +1512,77 @@ static int ext4_da_writepage(struct page *page,
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
-- 
1.5.5.1.357.g1af8b.dirty

