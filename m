From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [PATCH 1/1 v2] ext4: fix xfstests 75, 112, 127 punch hole failure
Date: Thu, 04 Aug 2011 09:24:37 -0700
Message-ID: <4E3AC7C5.8070506@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:43139 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab1HDQYt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Aug 2011 12:24:49 -0400
Received: from d03relay01.boulder.ibm.com (d03relay01.boulder.ibm.com [9.17.195.226])
	by e33.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p74GGuZp010488
	for <linux-ext4@vger.kernel.org>; Thu, 4 Aug 2011 10:16:56 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay01.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p74GOgbq140040
	for <linux-ext4@vger.kernel.org>; Thu, 4 Aug 2011 10:24:43 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p74AOFxi013234
	for <linux-ext4@vger.kernel.org>; Thu, 4 Aug 2011 04:24:15 -0600
Received: from lc4eb0185863151.ibm.com (sig-9-65-48-199.mts.ibm.com [9.65.48.199])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id p74AOEoH013094
	for <linux-ext4@vger.kernel.org>; Thu, 4 Aug 2011 04:24:15 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi All,

This is an earlier version of this patch that was reviewed
internally, before it came to the ext4 list as v3. 
V2 pretty much expands ext4_block_zero_page_range, where
as v3 makes a separate but simple function.  Some of
the feed back for v3 mentioned having one complex function,
so I am resending v2 so we can decide which version people
like better before we go and do a v4.


This patch corrects a punch hole bug found by xfstests
when the block size is set to 1k.  Test 127 runs longer
before it fails, but that appears to be a separate bug.

This bug happens because the punch hole code only zeros
out non block aligned blocks, and then releases the pages
for data that is page aligned.  This means that if the
blocks are smaller than a page, then the blocks contained
in the non page aligned regions (but still block aligned)
are left unzeroed and mapped.

This patch expands the ext4_block_zero_page_range routine
to zero multiple blocks in a page instead of just one.  A
new flag EXT4_BLOCK_ZERO_DISCARD_BUFFER has also been added
that discards buffers for blocks that would have been 
completely zeroed.

Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
---
v1 -> v2 Added EXT4_BLOCK_ZERO_DISCARD_BUFFER flag

:100644 100644 040b3fa... fbde9e17d. M	fs/ext4/ext4.h
:100644 100644 4d73e11... 4b5f82e... M	fs/ext4/extents.c
:100644 100644 8fdc298... 2d3268f... M	fs/ext4/inode.c
 fs/ext4/ext4.h    |    8 +++-
 fs/ext4/extents.c |   27 ++++++----
 fs/ext4/inode.c   |  145 +++++++++++++++++++++++++++++++++++-----------------
 3 files changed, 119 insertions(+), 61 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 040b3fa..fbde9e1 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -492,6 +492,11 @@ struct ext4_new_group_data {
 };
 
 /*
+ * Flags used by ext4_block_zero_page_range
+ */
+#define EXT4_BLOCK_ZERO_DISCARD_BUFFER		0x0001
+
+/*
  * Flags used by ext4_map_blocks()
  */
 	/* Allocate any needed blocks and/or convert an unitialized
@@ -1835,7 +1840,8 @@ extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
 extern int ext4_block_truncate_page(handle_t *handle,
 		struct address_space *mapping, loff_t from);
 extern int ext4_block_zero_page_range(handle_t *handle,
-		struct address_space *mapping, loff_t from, loff_t length);
+		struct address_space *mapping, loff_t from, loff_t length,
+		int flags);
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 extern void ext4_da_update_reserve_space(struct inode *inode,
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 4d73e11..4b5f82e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4157,7 +4157,7 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 	struct address_space *mapping = inode->i_mapping;
 	struct ext4_map_blocks map;
 	handle_t *handle;
-	loff_t first_block_offset, last_block_offset, block_len;
+	loff_t first_block_offset, last_block_offset, page_len;
 	loff_t first_page, last_page, first_page_offset, last_page_offset;
 	int ret, credits, blocks_released, err = 0;
 
@@ -4207,23 +4207,26 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 
 	/*
 	 * Now we need to zero out the un block aligned data.
-	 * If the file is smaller than a block, just
+	 * If the file is smaller than a page, just
 	 * zero out the middle
 	 */
-	if (first_block > last_block)
-		ext4_block_zero_page_range(handle, mapping, offset, length);
+	if (first_page > last_page)
+		ext4_block_zero_page_range(handle, mapping, offset, length,
+			EXT4_BLOCK_ZERO_DISCARD_BUFFER);
 	else {
-		/* zero out the head of the hole before the first block */
-		block_len  = first_block_offset - offset;
-		if (block_len > 0)
+		/* zero out the head of the hole before the first page */
+		page_len  = first_page_offset - offset;
+		if (page_len > 0)
 			ext4_block_zero_page_range(handle, mapping,
-						   offset, block_len);
+				offset, page_len,
+				EXT4_BLOCK_ZERO_DISCARD_BUFFER);
 
-		/* zero out the tail of the hole after the last block */
-		block_len = offset + length - last_block_offset;
-		if (block_len > 0) {
+		/* zero out the tail of the hole after the last page */
+		page_len = offset + length - last_page_offset;
+		if (page_len > 0) {
 			ext4_block_zero_page_range(handle, mapping,
-					last_block_offset, block_len);
+				last_page_offset, page_len,
+				EXT4_BLOCK_ZERO_DISCARD_BUFFER);
 		}
 	}
 
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 8fdc298..2d3268f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2928,22 +2928,26 @@ int ext4_block_truncate_page(handle_t *handle,
 	blocksize = inode->i_sb->s_blocksize;
 	length = blocksize - (offset & (blocksize - 1));
 
-	return ext4_block_zero_page_range(handle, mapping, from, length);
+	return ext4_block_zero_page_range(handle, mapping, from, length, 0);
 }
 
 /*
  * ext4_block_zero_page_range() zeros out a mapping of length 'length'
  * starting from file offset 'from'.  The range to be zero'd must
- * be contained with in one block.  If the specified range exceeds
- * the end of the block it will be shortened to end of the block
- * that cooresponds to 'from'
+ * be contained with in one page.  If the specified range exceeds
+ * the end of the page it will be shortened to end of the page
+ * that cooresponds to 'from'.  If the EXT4_BLOCK_ZERO_DISCARD_BUFFER
+ * flag is specified, blocks that are completely zeroed will have
+ * their buffers discarded
  */
 int ext4_block_zero_page_range(handle_t *handle,
-		struct address_space *mapping, loff_t from, loff_t length)
+		struct address_space *mapping, loff_t from, loff_t length,
+		int flags)
 {
 	ext4_fsblk_t index = from >> PAGE_CACHE_SHIFT;
-	unsigned offset = from & (PAGE_CACHE_SIZE-1);
-	unsigned blocksize, max, pos;
+	unsigned int offset = from & (PAGE_CACHE_SIZE-1);
+	unsigned int blocksize, max, pos;
+	unsigned int end_of_block, range_to_zero, discard_buffer;
 	ext4_lblk_t iblock;
 	struct inode *inode = mapping->host;
 	struct buffer_head *bh;
@@ -2956,11 +2960,11 @@ int ext4_block_zero_page_range(handle_t *handle,
 		return -EINVAL;
 
 	blocksize = inode->i_sb->s_blocksize;
-	max = blocksize - (offset & (blocksize - 1));
+	max = PAGE_CACHE_SIZE - offset;
 
 	/*
 	 * correct length if it does not fall between
-	 * 'from' and the end of the block
+	 * 'from' and the end of the page
 	 */
 	if (length > max || length < 0)
 		length = max;
@@ -2979,55 +2983,100 @@ int ext4_block_zero_page_range(handle_t *handle,
 		pos += blocksize;
 	}
 
-	err = 0;
-	if (buffer_freed(bh)) {
-		BUFFER_TRACE(bh, "freed: skip");
-		goto unlock;
-	}
+	pos = offset;
+	while (pos < offset + length) {
+		err = 0;
+
+		/* The length of space left to zero */
+		range_to_zero = offset + length - pos;
+
+		/* The length of space until the end of the block */
+		end_of_block = blocksize - (pos & (blocksize-1));
+
+		/* Do not zero past end of block */
+		if (range_to_zero > end_of_block)
+			range_to_zero = end_of_block;
+
+		/*
+		 * If the block is completely contained in the range,
+		 * and the discard flag is on, then the buffer
+		 * should be discarded instead of zeroed
+		 */
+		discard_buffer = range_to_zero == blocksize &&
+				flags & EXT4_BLOCK_ZERO_DISCARD_BUFFER;
+
+		if (buffer_freed(bh)) {
+			BUFFER_TRACE(bh, "freed: skip");
+			goto next;
+		}
 
-	if (!buffer_mapped(bh)) {
-		BUFFER_TRACE(bh, "unmapped");
-		ext4_get_block(inode, iblock, bh, 0);
-		/* unmapped? It's a hole - nothing to do */
 		if (!buffer_mapped(bh)) {
-			BUFFER_TRACE(bh, "still unmapped");
-			goto unlock;
+			BUFFER_TRACE(bh, "unmapped");
+			ext4_get_block(inode, iblock, bh, 0);
+			/* unmapped? It's a hole - nothing to do */
+			if (!buffer_mapped(bh)) {
+				BUFFER_TRACE(bh, "still unmapped");
+				goto next;
+			}
 		}
-	}
 
-	/* Ok, it's mapped. Make sure it's up-to-date */
-	if (PageUptodate(page))
-		set_buffer_uptodate(bh);
+		/* Ok, it's mapped. Make sure it's up-to-date */
+		if (PageUptodate(page))
+			set_buffer_uptodate(bh);
 
-	if (!buffer_uptodate(bh)) {
-		err = -EIO;
-		ll_rw_block(READ, 1, &bh);
-		wait_on_buffer(bh);
-		/* Uhhuh. Read error. Complain and punt. */
-		if (!buffer_uptodate(bh))
-			goto unlock;
-	}
+		if (!buffer_uptodate(bh) && !discard_buffer) {
+			err = -EIO;
+			ll_rw_block(READ, 1, &bh);
+			wait_on_buffer(bh);
+			/* Uhhuh. Read error. Complain and punt. */
+			if (!buffer_uptodate(bh))
+				goto unlock;
+		}
 
-	if (ext4_should_journal_data(inode)) {
-		BUFFER_TRACE(bh, "get write access");
-		err = ext4_journal_get_write_access(handle, bh);
-		if (err)
-			goto unlock;
-	}
+		if (ext4_should_journal_data(inode)) {
+			BUFFER_TRACE(bh, "get write access");
+			err = ext4_journal_get_write_access(handle, bh);
+			if (err)
+				goto unlock;
+		}
+
+		/*
+		 * If the block was completely zeroed,
+		 * release the buffer if needed
+		 */
+		if (range_to_zero == blocksize &&
+			flags & EXT4_BLOCK_ZERO_DISCARD_BUFFER) {
+
+			clear_buffer_dirty(bh);
+			bh->b_bdev = NULL;
+			clear_buffer_mapped(bh);
+			clear_buffer_req(bh);
+			clear_buffer_new(bh);
+			clear_buffer_delay(bh);
+			clear_buffer_unwritten(bh);
+			clear_buffer_uptodate(bh);
+			ClearPageUptodate(page);
+		} else {
+			zero_user(page, pos, range_to_zero);
+		}
 
-	zero_user(page, offset, length);
+		BUFFER_TRACE(bh, "zeroed end of block");
 
-	BUFFER_TRACE(bh, "zeroed end of block");
+		err = 0;
+		if (ext4_should_journal_data(inode)) {
+			err = ext4_handle_dirty_metadata(handle, inode, bh);
+		} else {
+			if (ext4_should_order_data(inode) &&
+			    EXT4_I(inode)->jinode)
+				err = ext4_jbd2_file_inode(handle, inode);
+			mark_buffer_dirty(bh);
+		}
 
-	err = 0;
-	if (ext4_should_journal_data(inode)) {
-		err = ext4_handle_dirty_metadata(handle, inode, bh);
-	} else {
-		if (ext4_should_order_data(inode) && EXT4_I(inode)->jinode)
-			err = ext4_jbd2_file_inode(handle, inode);
-		mark_buffer_dirty(bh);
+next:
+		bh = bh->b_this_page;
+		iblock++;
+		pos += range_to_zero;
 	}
