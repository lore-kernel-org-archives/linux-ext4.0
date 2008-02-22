From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH] ext4: Convert uninitialized extent to initialized extent in case of file system full
Date: Fri, 22 Feb 2008 20:09:18 +0530
Message-ID: <1203691158-6788-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1203691158-6788-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1203691158-6788-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: cmm@us.ibm.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:54572 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbYBVOjd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Feb 2008 09:39:33 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m1MEdAVw031517
	for <linux-ext4@vger.kernel.org>; Sat, 23 Feb 2008 01:39:10 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1MEdWrq3203200
	for <linux-ext4@vger.kernel.org>; Sat, 23 Feb 2008 01:39:32 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1MEdVYV024492
	for <linux-ext4@vger.kernel.org>; Sat, 23 Feb 2008 01:39:32 +1100
In-Reply-To: <1203691158-6788-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

A write to prealloc area cause the split of unititalized extent into a initialized
and uninitialized extent. If we don't have space to add new extent information instead
of returning error convert the existing uninitialized extent to initialized one. We
need to zero out the blocks corresponding to the extent to prevent wrong data reaching
userspace.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/ext4/extents.c |  151 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 144 insertions(+), 7 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index d315cc1..cdc7dca 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -2136,6 +2136,124 @@ void ext4_ext_release(struct super_block *sb)
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
+			set_buffer_uptodate(bh);
+			if (ext4_should_journal_data(inode)) {
+				err = ext4_journal_get_write_access(handle, bh);
+				if (err)
+					goto err_out;
+			}
+			zero_user(page, offset, blocksize);
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
@@ -2202,14 +2320,20 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
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
@@ -2295,15 +2419,28 @@ static int ext4_ext_convert_to_initialized(handle_t *handle,
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
1.5.4.1.97.g40aab-dirty
