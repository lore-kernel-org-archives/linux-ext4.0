From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [Ext4 punch hole 2/5] Ext4 Punch Hole Support: Clear Hole
Date: Mon, 28 Feb 2011 20:08:34 -0700
Message-ID: <4D6C6332.3080101@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44230 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332Ab1CADIf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Feb 2011 22:08:35 -0500
Received: from d01dlp01.pok.ibm.com (d01dlp01.pok.ibm.com [9.56.224.56])
	by e3.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p212mY73017256
	for <linux-ext4@vger.kernel.org>; Mon, 28 Feb 2011 21:48:34 -0500
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 7C22138C8038
	for <linux-ext4@vger.kernel.org>; Mon, 28 Feb 2011 22:08:33 -0500 (EST)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p2138XLm2326730
	for <linux-ext4@vger.kernel.org>; Mon, 28 Feb 2011 22:08:33 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p2138Xja007268
	for <linux-ext4@vger.kernel.org>; Mon, 28 Feb 2011 22:08:33 -0500
Received: from [127.0.0.1] (sig-9-48-100-125.mts.ibm.com [9.48.100.125])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id p2138WR3007234
	for <linux-ext4@vger.kernel.org>; Mon, 28 Feb 2011 22:08:33 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds routines needed to zero out the hole
unblock aligned data of the hole.

The existing ext4_block_truncate_page routine that
is used to zero out unblock aligned data from truncate
has been modified to accept a length parameter, and
renamed to ext4_block_zero_page_range.

The function can now be used to zero out the
head of a block, the tail of a block, or the middle
of a block.  The existing ext4_block_truncate_page
has now become a wrapper to this function

Signed-off-by: Allison Henderson <achender@us.ibm.com>
---
:100644 100644 3aa0b72... 43a5772... M	fs/ext4/ext4.h
:100644 100644 9f7f9e4... 28c9137... M	fs/ext4/inode.c
 fs/ext4/ext4.h  |    2 ++
 fs/ext4/inode.c |   33 +++++++++++++++++++++++++++++++--
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3aa0b72..43a5772 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1738,6 +1738,8 @@ extern int ext4_writepage_trans_blocks(struct inode *);
 extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
 extern int ext4_block_truncate_page(handle_t *handle,
 		struct address_space *mapping, loff_t from);
+extern int ext4_block_zero_page_range(handle_t *handle,
+                struct address_space *mapping, loff_t from, loff_t length);
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 extern void ext4_da_update_reserve_space(struct inode *inode,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9f7f9e4..28c9137 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3988,9 +3988,30 @@ void ext4_set_aops(struct inode *inode)
 int ext4_block_truncate_page(handle_t *handle,
 		struct address_space *mapping, loff_t from)
 {
+	unsigned offset = from & (PAGE_CACHE_SIZE-1);
+	unsigned length;
+	unsigned blocksize;
+	struct inode *inode = mapping->host;
+
+	blocksize = inode->i_sb->s_blocksize;
+	length = blocksize - (offset & (blocksize - 1));
+
+	return ext4_block_zero_page_range(handle, mapping, from, length);
+}
+
+/*
+ * ext4_block_zero_page_range() zeros out a mapping of length 'length' 
+ * starting from file offset 'from'.  The range to be zero'd must 
+ * be contained with in one block.  If the specified range exceeds
+ * the end of the block it will be shortened to end of the block
+ * that cooresponds to 'from'
+ */
+int ext4_block_zero_page_range(handle_t *handle,
+                struct address_space *mapping, loff_t from, loff_t length)
+{ 
 	ext4_fsblk_t index = from >> PAGE_CACHE_SHIFT;
 	unsigned offset = from & (PAGE_CACHE_SIZE-1);
-	unsigned blocksize, length, pos;
+	unsigned blocksize, max, pos;
 	ext4_lblk_t iblock;
 	struct inode *inode = mapping->host;
 	struct buffer_head *bh;
@@ -4003,7 +4024,15 @@ int ext4_block_truncate_page(handle_t *handle,
 		return -EINVAL;
 
 	blocksize = inode->i_sb->s_blocksize;
-	length = blocksize - (offset & (blocksize - 1));
+	max = blocksize - (offset & (blocksize - 1));
+
+	/*
+ 	 * correct length if it does not fall between 
+ 	 * 'from' and the end of the block 
+ 	 */
+	if(length > max || length < 0)
+		length = max;
+
 	iblock = index << (PAGE_CACHE_SHIFT - inode->i_sb->s_blocksize_bits);
 
 	if (!page_has_buffers(page))
-- 
1.7.1


