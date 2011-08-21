From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 1/6 v5] ext4: Add new ext4_discard_partial_page_buffers routines
Date: Sat, 20 Aug 2011 19:29:42 -0700
Message-ID: <1313893787-25460-2-git-send-email-achender@linux.vnet.ibm.com>
References: <1313893787-25460-1-git-send-email-achender@linux.vnet.ibm.com>
Cc: Allison Henderson <achender@linux.vnet.ibm.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:58600 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532Ab1HUC0l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 20 Aug 2011 22:26:41 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e9.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p7L1r24e005252
	for <linux-ext4@vger.kernel.org>; Sat, 20 Aug 2011 21:53:02 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p7L2QeeL231688
	for <linux-ext4@vger.kernel.org>; Sat, 20 Aug 2011 22:26:40 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7L2QeAv008777
	for <linux-ext4@vger.kernel.org>; Sat, 20 Aug 2011 22:26:40 -0400
In-Reply-To: <1313893787-25460-1-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds two new routines: ext4_discard_partial_page_buffers
and ext4_discard_partial_page_buffers_no_lock.

The ext4_discard_partial_page_buffers routine is a wrapper
function to ext4_discard_partial_page_buffers_no_lock.
The wrapper function locks the page and passes it to
ext4_discard_partial_page_buffers_no_lock.
Calling functions that already have the page locked can call
ext4_discard_partial_page_buffers_no_lock directly.

The ext4_discard_partial_page_buffers_no_lock function
zeros a specified range in a page, and unmaps the
corresponding buffer heads.  This function is meant to
be used to update a page and its buffer heads to be zeroed
and unmaped when the corresponding blocks have been released
or will be released.

This routine is used in the following scenarios:
* A hole is punched and the non page aligned regions
  of the head and tail of the hole need to be discarded

* The file is truncated and the partial page beyond EOF needs
  to be discarded

* The end of a hole is in the same page as EOF.  After the
  page is flushed, the partial page beyond EOF needs to be
  discarded.

* A write operation begins or ends inside a hole and the partial
  page appearing before or after the write needs to be discarded

* A write operation extends EOF and the partial page beyond EOF
  needs to be discarded

This function takes a flag EXT4_DSCRD_PARTIAL_PG_ZERO_UNMAPED
which is used when a write operation begins or ends in a hole.
When the EXT4_DSCRD_PARTIAL_PG_ZERO_UNMAPED flag is used, only
buffer heads that are already unmapped will have the corresponding
regions of the page zeroed.

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
:100644 100644 040b3fa... c386f8d... M	fs/ext4/ext4.h
:100644 100644 8fdc298... c1b42cb... M	fs/ext4/inode.c
 fs/ext4/ext4.h  |   11 ++++
 fs/ext4/inode.c |  159 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 170 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 040b3fa..c386f8d 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -529,6 +529,11 @@ struct ext4_new_group_data {
 #define EXT4_FREE_BLOCKS_NO_QUOT_UPDATE	0x0008
 
 /*
+ * Flags used by ext4_discard_partial_page_buffers
+ */
+#define EXT4_DSCRD_PARTIAL_PG_ZERO_UNMAPED	0x0001
+
+/*
  * ioctl commands
  */
 #define	EXT4_IOC_GETFLAGS		FS_IOC_GETFLAGS
@@ -1836,6 +1841,12 @@ extern int ext4_block_truncate_page(handle_t *handle,
 		struct address_space *mapping, loff_t from);
 extern int ext4_block_zero_page_range(handle_t *handle,
 		struct address_space *mapping, loff_t from, loff_t length);
+extern int ext4_discard_partial_page_buffers(handle_t *handle,
+		struct address_space *mapping, loff_t from,
+		loff_t length, int flags);
+extern int ext4_discard_partial_page_buffers_no_lock(handle_t *handle,
+		struct inode *inode, struct page *page, loff_t from,
+		loff_t length, int flags);
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 extern void ext4_da_update_reserve_space(struct inode *inode,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8fdc298..c1b42cb 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2911,6 +2911,165 @@ void ext4_set_aops(struct inode *inode)
 		inode->i_mapping->a_ops = &ext4_journalled_aops;
 }
 
+
+/*
+ * ext4_discard_partial_page_buffers()
+ * Wrapper function for ext4_discard_partial_page_buffers_no_lock.
+ * This function finds and locks the page containing the offset
+ * "from" and passes it to ext4_discard_partial_page_buffers_no_lock.
+ * Calling functions that already have the page locked should call
+ * ext4_discard_partial_page_buffers_no_lock directly.
+ */
+int ext4_discard_partial_page_buffers(handle_t *handle,
+		struct address_space *mapping, loff_t from,
+		loff_t length, int flags)
+{
+	struct inode *inode = mapping->host;
+	struct page *page;
+	int err = 0;
+
+	page = find_or_create_page(mapping, from >> PAGE_CACHE_SHIFT,
+				   mapping_gfp_mask(mapping) & ~__GFP_FS);
+	if (!page)
+		return -EINVAL;
+
+	err = ext4_discard_partial_page_buffers_no_lock(handle, inode, page,
+		from, length, flags);
+
+	unlock_page(page);
+	page_cache_release(page);
+	return err;
+}
+
+/*
+ * ext4_discard_partial_page_buffers_no_lock()
+ * Zeros a page range of length 'length' starting from offset 'from'
+ * and unmaps the buffer heads that correspond to the block aligned
+ * regions of the page that were fully zeroed.  This function assumes
+ * that page has already been locked.  The range to be discarded
+ * must be contained with in the given page.  If the specified range
+ * exceeds the end of the page it will be shortened to the end
+ * of the page that corresponds to 'from'.  This function is appropriate
+ * for updateing a page and it buffer heads to be unmaped and zeroed
+ * for blocks that have been either released, or are going to be released.
+ *
+ * handle: The journal handle
+ * inode:  The files inode
+ * page:   A locked page that contains the offset "from"
+ * from:   The starting byte offset (from the begining of the file)
+ *         to begin discarding
+ * len:    The length of bytes to discard
+ * flags:  Optional flags that may be used:
+ *
+ *         EXT4_DSCRD_PARTIAL_PG_ZERO_UNMAPED
+ *         Only zero the regions of the page whose buffer heads
+ *         have already been unmapped.  This flag is appropriate
+ *         for updateing the contents of a page whose blocks may
+ *         have already been released, and we only want to zero
+ *         out the regions that correspond to those released blocks.
+ *
+ * Returns zero on sucess or negative on failure.
+ */
+int ext4_discard_partial_page_buffers_no_lock(handle_t *handle,
+		struct inode *inode, struct page *page, loff_t from,
+		loff_t length, int flags)
+{
+	ext4_fsblk_t index = from >> PAGE_CACHE_SHIFT;
+	unsigned int offset = from & (PAGE_CACHE_SIZE-1);
+	unsigned int blocksize, max, pos;
+	unsigned int end_of_block, range_to_discard;
+	ext4_lblk_t iblock;
+	struct buffer_head *bh;
+	int err = 0;
+
+	blocksize = inode->i_sb->s_blocksize;
+	max = PAGE_CACHE_SIZE - offset;
+
+	if (index != page->index)
+		return -EINVAL;
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
+		return 0;
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
+		/* The length of space left to zero and unmap */
+		range_to_discard = offset + length - pos;
+
+		/* The length of space until the end of the block */
+		end_of_block = blocksize - (pos & (blocksize-1));
+
+		/* Do not unmap or zero past end of block */
+		if (range_to_discard > end_of_block)
+			range_to_discard = end_of_block;
+
+
+		if (flags & EXT4_DSCRD_PARTIAL_PG_ZERO_UNMAPED &&
+			buffer_mapped(bh))
+				goto next;
+
+		if (ext4_should_journal_data(inode)) {
+			BUFFER_TRACE(bh, "get write access");
+			err = ext4_journal_get_write_access(handle, bh);
+			if (err)
+				goto unmap;
+		}
+
+		zero_user(page, pos, range_to_discard);
+
+		BUFFER_TRACE(bh, "buffer discarded");
+
+		err = 0;
+		if (ext4_should_journal_data(inode)) {
+			err = ext4_handle_dirty_metadata(handle, inode, bh);
+		} else {
+			if (ext4_should_order_data(inode) &&
+			    EXT4_I(inode)->jinode)
+				err = ext4_jbd2_file_inode(handle, inode);
+		}
+unmap:
+
+		/* If the range is block aligned, unmap */
+		if (range_to_discard == blocksize) {
+			clear_buffer_dirty(bh);
+			bh->b_bdev = NULL;
+			clear_buffer_mapped(bh);
+			clear_buffer_req(bh);
+			clear_buffer_new(bh);
+			clear_buffer_delay(bh);
+			clear_buffer_unwritten(bh);
+			clear_buffer_uptodate(bh);
+			ClearPageUptodate(page);
+		}
+next:
+		bh = bh->b_this_page;
+		iblock++;
+		pos += range_to_discard;
+	}
+
+	return err;
+}
+
 /*
  * ext4_block_truncate_page() zeroes out a mapping from file offset `from'
  * up to the end of the block which corresponds to `from'.
-- 
1.7.1

