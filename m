From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [Ext4 punch hole 2/5 v6]
Date: Tue, 03 May 2011 09:47:55 -0700
Message-ID: <4DC031BB.2020005@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:56310 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab1ECQsB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 May 2011 12:48:01 -0400
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com [9.17.195.228])
	by e34.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p43GZcNI012115
	for <linux-ext4@vger.kernel.org>; Tue, 3 May 2011 10:35:38 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p43GluXc088074
	for <linux-ext4@vger.kernel.org>; Tue, 3 May 2011 10:47:56 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p43GluID027683
	for <linux-ext4@vger.kernel.org>; Tue, 3 May 2011 10:47:56 -0600
Received: from [9.65.15.245] (sig-9-65-15-245.mts.ibm.com [9.65.15.245])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id p43GltOE027628
	for <linux-ext4@vger.kernel.org>; Tue, 3 May 2011 10:47:55 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch adds routines needed to zero out the
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
:100644 100644 5639fdf... 45136d8... M	fs/ext4/ext4.h
:100644 100644 a04128f... dc45631... M	fs/ext4/inode.c
 fs/ext4/ext4.h  |    2 ++
 fs/ext4/inode.c |   33 +++++++++++++++++++++++++++++++--
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 5639fdf..45136d8 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1743,6 +1743,8 @@ extern int ext4_writepage_trans_blocks(struct inode *);
 extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
 extern int ext4_block_truncate_page(handle_t *handle,
 		struct address_space *mapping, loff_t from);
+extern int ext4_block_zero_page_range(handle_t *handle,
+		struct address_space *mapping, loff_t from, loff_t length);
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 extern void ext4_da_update_reserve_space(struct inode *inode,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index a04128f..dc45631 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3915,9 +3915,30 @@ void ext4_set_aops(struct inode *inode)
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
+		struct address_space *mapping, loff_t from, loff_t length)
+{
 	ext4_fsblk_t index = from >> PAGE_CACHE_SHIFT;
 	unsigned offset = from & (PAGE_CACHE_SIZE-1);
-	unsigned blocksize, length, pos;
+	unsigned blocksize, max, pos;
 	ext4_lblk_t iblock;
 	struct inode *inode = mapping->host;
 	struct buffer_head *bh;
@@ -3930,7 +3951,15 @@ int ext4_block_truncate_page(handle_t *handle,
 		return -EINVAL;
 
 	blocksize = inode->i_sb->s_blocksize;
-	length = blocksize - (offset & (blocksize - 1));
+	max = blocksize - (offset & (blocksize - 1));
+
+	/*
+	 * correct length if it does not fall between
+	 * 'from' and the end of the block
+	 */
+	if (length > max || length < 0)
+		length = max;
+
 	iblock = index << (PAGE_CACHE_SHIFT - inode->i_sb->s_blocksize_bits);
 
 	if (!page_has_buffers(page))
-- 
1.7.1

