From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 1/1 v3] ext4: fix xfstests 75, 112, 127 punch hole failure
Date: Wed, 03 Aug 2011 08:20:36 -0700
Message-ID: <4E396744.2030003@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:48004 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205Ab1HCPVD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Aug 2011 11:21:03 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p73FEgnU013844
	for <linux-ext4@vger.kernel.org>; Wed, 3 Aug 2011 09:14:42 -0600
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id p73FKiTf085024
	for <linux-ext4@vger.kernel.org>; Wed, 3 Aug 2011 09:20:45 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p739Kgjg018984
	for <linux-ext4@vger.kernel.org>; Wed, 3 Aug 2011 03:20:42 -0600
Received: from lc4eb0185863151.ibm.com (sig-9-65-222-248.mts.ibm.com [9.65.222.248])
	by d03av04.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id p739KbEe018236
	for <linux-ext4@vger.kernel.org>; Wed, 3 Aug 2011 03:20:38 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch corrects a punch hole bug found by xfstests
when the block size is set to 1k.  Test 127 runs longer
before it fails, but that appears to be a separate bug.

This bug happens because the punch hole code only zeros
out non block aligned blocks, and then releases the pages
for data that is page aligned.  This means that if the
blocks are smaller than a page, then the blocks contained
in the non page aligned regions (but still block aligned)
are left unzeroed and mapped.

This patch adds a new ext4_unmap_page_range routine
that unmapps the block aligned buffers in a page that are
contained in a specified range.

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
v1 -> v2
Added EXT4_BLOCK_ZERO_DISCARD_BUFFER flag

v2 -> v3
Moved code out of ext4_zero_block_page_range and in
to new ext4_unmap_page_range function

:100644 100644 040b3fa... 5730d1e... M	fs/ext4/ext4.h
:100644 100644 4d73e11... b5734f5... M	fs/ext4/extents.c
:100644 100644 8fdc298... 1c3bd8f... M	fs/ext4/inode.c
 fs/ext4/ext4.h    |    2 +
 fs/ext4/extents.c |   24 ++++++++++-
 fs/ext4/inode.c   |  122 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 147 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 040b3fa..5730d1e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1836,6 +1836,8 @@ extern int ext4_block_truncate_page(handle_t *handle,
 		struct address_space *mapping, loff_t from);
 extern int ext4_block_zero_page_range(handle_t *handle,
 		struct address_space *mapping, loff_t from, loff_t length);
+extern int ext4_unmap_page_range(handle_t *handle,
+		struct address_space *mapping, loff_t from, loff_t length);
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 extern void ext4_da_update_reserve_space(struct inode *inode,
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 4d73e11..b5734f5 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4157,7 +4157,7 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 	struct address_space *mapping = inode->i_mapping;
 	struct ext4_map_blocks map;
 	handle_t *handle;
-	loff_t first_block_offset, last_block_offset, block_len;
+	loff_t first_block_offset, last_block_offset, block_len, page_len;
 	loff_t first_page, last_page, first_page_offset, last_page_offset;
 	int ret, credits, blocks_released, err = 0;
 
@@ -4227,6 +4227,28 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 		}
 	}
 
+	/*
+	 * Now we need to unmap the un page aligned buffers.
+	 * If the file is smaller than a page, just
+	 * unmap the middle
+	 */
+	if (first_page > last_page)
+		ext4_unmap_page_range(handle, mapping, offset, length);
+	else {
+		/* unmap page buffers before the first aligned page */
+		page_len = first_page_offset - offset;
+		if (page_len > 0)
+			ext4_unmap_page_range(handle, mapping,
+				offset, page_len);
+
+		/* unmap the page buffers after the last aligned page */
+		page_len = offset + length - last_page_offset;
+		if (page_len > 0) {
+			ext4_unmap_page_range(handle, mapping,
+				last_page_offset, page_len);
+		}
+	}
+
 	/* If there are no blocks to remove, return now */
 	if (first_block >= last_block)
 		goto out;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8fdc298..1c3bd8f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3034,6 +3034,128 @@ unlock:
 	return err;
 }
 
+/*
+ * ext4_unmap_page_range() unmaps a page range of length 'length'
+ * starting from file offset 'from'.  The range to be unmaped must
+ * be contained with in one page.  If the specified range exceeds
+ * the end of the page it will be shortened to end of the page
+ * that cooresponds to 'from'.  Only block aligned buffers will
+ * be unmapped and unblock aligned buffers are skipped
+ */
+int ext4_unmap_page_range(handle_t *handle,
+		struct address_space *mapping, loff_t from, loff_t length)
+{
+	ext4_fsblk_t index = from >> PAGE_CACHE_SHIFT;
+	unsigned int offset = from & (PAGE_CACHE_SIZE-1);
+	unsigned int blocksize, max, pos;
+	unsigned int end_of_block, range_to_unmap;
+	ext4_lblk_t iblock;
+	struct inode *inode = mapping->host;
+	struct buffer_head *bh;
+	struct page *page;
+	int err = 0;
+
+	page = find_or_create_page(mapping, from >> PAGE_CACHE_SHIFT,
+				   mapping_gfp_mask(mapping) & ~__GFP_FS);
+	if (!page)
+		return -EINVAL;
+
+	blocksize = inode->i_sb->s_blocksize;
+	max = PAGE_CACHE_SIZE - offset;
+
+	/*
+	 * correct length if it does not fall between
+	 * 'from' and the end of the page
+	 */
+	if (length > max || length < 0)
+		length = max;
+
+	iblock = index << (PAGE_CACHE_SHIFT - inode->i_sb->s_blocksize_bits);
+
+	if (!page_has_buffers(page))
+		create_empty_buffers(page, blocksize, 0);
+
+	/* Find the buffer that contains "offset" */
+	bh = page_buffers(page);
+	pos = blocksize;
+	while (offset >= pos) {
+		bh = bh->b_this_page;
+		iblock++;
+		pos += blocksize;
+	}
+
+	pos = offset;
+	while (pos < offset + length) {
+		err = 0;
+
+		/* The length of space left to zero */
+		range_to_unmap = offset + length - pos;
+
+		/* The length of space until the end of the block */
+		end_of_block = blocksize - (pos & (blocksize-1));
+
+		/* Do not unmap past end of block */
+		if (range_to_unmap > end_of_block)
+			range_to_unmap = end_of_block;
+
+		if (buffer_freed(bh)) {
+			BUFFER_TRACE(bh, "freed: skip");
+			goto next;
+		}
+
+		if (!buffer_mapped(bh)) {
+			BUFFER_TRACE(bh, "unmapped");
+			ext4_get_block(inode, iblock, bh, 0);
+			/* unmapped? It's a hole - nothing to do */
+			if (!buffer_mapped(bh)) {
+				BUFFER_TRACE(bh, "still unmapped");
+				goto next;
+			}
+		}
+
+		/* If the range is not block aligned, skip */
+		if (range_to_unmap != blocksize)
+			goto next;
+
+		if (ext4_should_journal_data(inode)) {
+			BUFFER_TRACE(bh, "get write access");
+			err = ext4_journal_get_write_access(handle, bh);
+			if (err)
+				goto unlock;
+		}
+
+		clear_buffer_dirty(bh);
+		bh->b_bdev = NULL;
+		clear_buffer_mapped(bh);
+		clear_buffer_req(bh);
+		clear_buffer_new(bh);
+		clear_buffer_delay(bh);
+		clear_buffer_unwritten(bh);
+		clear_buffer_uptodate(bh);
+		ClearPageUptodate(page);
+
+		BUFFER_TRACE(bh, "buffer unmapped");
+
+		if (ext4_should_journal_data(inode)) {
+			err = ext4_handle_dirty_metadata(handle, inode, bh);
+		} else {
+			if (ext4_should_order_data(inode) &&
+			    EXT4_I(inode)->jinode)
+				err = ext4_jbd2_file_inode(handle, inode);
+		}
+
+next:
+		bh = bh->b_this_page;
+		iblock++;
+		pos += range_to_unmap;
+	}
+unlock:
+	unlock_page(page);
+	page_cache_release(page);
+	return err;
+}
+
+
 int ext4_can_truncate(struct inode *inode)
 {
 	if (S_ISREG(inode->i_mode))
-- 
1.7.1

