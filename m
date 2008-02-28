From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC][PATCH] ext4: Convert uninitialized extent to initialized extent in case of file system full
Date: Thu, 28 Feb 2008 23:35:10 +0530
Message-ID: <1204221911-9753-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1204221911-9753-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1204221911-9753-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:59496 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880AbYB1SFW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 28 Feb 2008 13:05:22 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m1SI58BL009617
	for <linux-ext4@vger.kernel.org>; Fri, 29 Feb 2008 05:05:08 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1SI5Lqk4657340
	for <linux-ext4@vger.kernel.org>; Fri, 29 Feb 2008 05:05:21 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1SI5Kuw012573
	for <linux-ext4@vger.kernel.org>; Fri, 29 Feb 2008 05:05:20 +1100
In-Reply-To: <1204221911-9753-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

A write to prealloc area cause the split of unititalized extent into a initialized
and uninitialized extent. If we don't have space to add new extent information instead
of returning error convert the existing uninitialized extent to initialized one. We
need to zero out the blocks corresponding to the extent to prevent wrong data reaching
userspace.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c |  164 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 157 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index d315cc1..39a8beb 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2136,6 +2136,137 @@ void ext4_ext_release(struct super_block *sb)
 #endif
 }
 
+static int extend_credit_for_zeroout(handle_t *handle, struct inode *inode)
+{
+	int retval = 0, needed;
+
+	if (handle->h_buffer_credits > EXT4_RESERVE_TRANS_BLOCKS)
+		return 0;
+
+	/* number of filesytem blocks in one page */
+	needed = 1 << (PAGE_CACHE_SHIFT - inode->i_blkbits);
+
+	if (ext4_journal_extend(handle, needed) != 0)
+		retval = ext4_journal_restart(handle, needed);
+
+	return retval;
+}
+
+/* FIXME!! we need to try to merge to left or right after zerout  */
+static int ext4_ext_zeroout(handle_t *handle, struct inode *inode,
+				ext4_lblk_t iblock, struct ext4_extent *ex)
+{
+	ext4_lblk_t ee_block;
+	unsigned int ee_len, blkcount, blocksize;
+	loff_t pos;
+	pgoff_t index, skip_index;
+	unsigned long offset;
+	struct page *page;
+	struct address_space *mapping = inode->i_mapping;
+	struct buffer_head *head, *bh;
+	int err = 0;
+
+	ee_block = le32_to_cpu(ex->ee_block);
+	ee_len = blkcount = ext4_ext_get_actual_len(ex);
+	blocksize = inode->i_sb->s_blocksize;
+
+	/*
+	 * find the skip index. We can't call __grab_cache_page for this
+	 * because we are in the writeout of this page and we already have
+	 * taken the lock on this page
+	 */
+	pos = iblock <<  inode->i_blkbits;
+	skip_index = pos >> PAGE_CACHE_SHIFT;
+
+	while (blkcount) {
+		pos = (ee_block  + ee_len - blkcount) << inode->i_blkbits;
+		index = pos >> PAGE_CACHE_SHIFT;
+		offset = (pos & (PAGE_CACHE_SIZE - 1));
+		if (index == skip_index) {
+			/* Page will already be locked via
+			 * write_begin or writepage
+			 */
+			read_lock_irq(&mapping->tree_lock);
+			page = radix_tree_lookup(&mapping->page_tree, index);
+			read_unlock_irq(&mapping->tree_lock);
+			if (page)
+				page_cache_get(page);
+			else
+				return -ENOMEM;
+		} else {
+			page = __grab_cache_page(mapping, index);
+			if (!page)
+				return -ENOMEM;
+		}
+
+		if (!page_has_buffers(page))
+			create_empty_buffers(page, blocksize, 0);
+
+		/* extent the credit in the journal */
+		extend_credit_for_zeroout(handle, inode);
+
+		head = page_buffers(page);
+		/* Look for the buffer_head which map the block */
+		bh = head;
+		while (offset > 0) {
+			bh = bh->b_this_page;
+			offset -= blocksize;
+		}
+		offset = (pos & (PAGE_CACHE_SIZE - 1));
+
+		/* Now write all the buffer_heads in the page */
+		do {
+			if (ext4_should_journal_data(inode)) {
+				err = ext4_journal_get_write_access(handle, bh);
+				if (err)
+					goto err_out;
+			}
+			if (buffer_new(bh)) {
+				unmap_underlying_metadata(bh->b_bdev,
+								bh->b_blocknr);
+				if (!PageUptodate(page))
+					zero_user(page, offset, blocksize);
+				clear_buffer_new(bh);
+			}
+			/* Now mark the buffer uptodate. since we
+			 * have zero out the buffer
+			 */
+			set_buffer_uptodate(bh);
+			offset += blocksize;
+			if (ext4_should_journal_data(inode)) {
+				err = ext4_journal_dirty_metadata(handle, bh);
+				if (err)
+					goto err_out;
+			} else {
+				if (ext4_should_order_data(inode)) {
+					err = ext4_journal_dirty_data(handle,
+									bh);
+					if (err)
+						goto err_out;
+				}
+				mark_buffer_dirty(bh);
+			}
+
+			bh = bh->b_this_page;
+			blkcount--;
+		} while ((bh != head) && (blkcount > 0));
+		/* Now that we zeroed the non uptodate
+		 * page mark the pge uptodate
+		 */
+		SetPageUptodate(page);
+		/* only unlock if we have locked */
+		if (index != skip_index)
+			unlock_page(page);
+		page_cache_release(page);
+	}
+
+	return 0;
+err_out:
+	unlock_page(page);
+	page_cache_release(page);
+	return err;
+}
+
 /*
  * This function is called by ext4_ext_get_blocks() if someone tries to write
  * to an uninitialized extent. It may result in splitting the uninitialized
@@ -2202,14 +2333,20 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 		ex3->ee_len = cpu_to_le16(allocated - max_blocks);
 		ext4_ext_mark_uninitialized(ex3);
 		err = ext4_ext_insert_extent(handle, inode, path, ex3);
-		if (err) {
+		if (err == -ENOSPC) {
+			err =  ext4_ext_zeroout(handle, inode,
+							iblock, &orig_ex);
+			if (err)
+				goto fix_extent_len;
+			/* update the extent length and mark as initialized */
 			ex->ee_block = orig_ex.ee_block;
 			ex->ee_len   = orig_ex.ee_len;
 			ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
-			ext4_ext_mark_uninitialized(ex);
 			ext4_ext_dirty(handle, inode, path + depth);
-			goto out;
-		}
+			return le16_to_cpu(ex->ee_len);
+
+		} else if (err)
+			goto fix_extent_len;
 		/*
 		 * The depth, and hence eh & ex might change
 		 * as part of the insert above.
@@ -2295,15 +2432,28 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
 	goto out;
 insert:
 	err = ext4_ext_insert_extent(handle, inode, path, &newex);
-	if (err) {
+	if (err == -ENOSPC) {
+		err =  ext4_ext_zeroout(handle, inode, iblock, &orig_ex);
+		if (err)
+			goto fix_extent_len;
+		/* update the extent length and mark as initialized */
 		ex->ee_block = orig_ex.ee_block;
 		ex->ee_len   = orig_ex.ee_len;
 		ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
-		ext4_ext_mark_uninitialized(ex);
 		ext4_ext_dirty(handle, inode, path + depth);
-	}
+		return le16_to_cpu(ex->ee_len);
+	} else if (err)
+		goto fix_extent_len;
 out:
 	return err ? err : allocated;
+
+fix_extent_len:
+	ex->ee_block = orig_ex.ee_block;
+	ex->ee_len   = orig_ex.ee_len;
+	ext4_ext_store_pblock(ex, ext_pblock(&orig_ex));
+	ext4_ext_mark_uninitialized(ex);
+	ext4_ext_dirty(handle, inode, path + depth);
+	return err;
 }
 
 /*
-- 
1.5.4.3.325.g6d216.dirty

