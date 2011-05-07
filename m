From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [Ext4 punch hole 2/5 v7] Ext4 Punch Hole Support: Clear Hole
Date: Sat, 07 May 2011 16:54:02 -0700
Message-ID: <4DC5DB9A.3030001@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57483 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756389Ab1EGXyJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 7 May 2011 19:54:09 -0400
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by e6.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p47NTuWr032296
	for <linux-ext4@vger.kernel.org>; Sat, 7 May 2011 19:29:56 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p47Ns8Rm106074
	for <linux-ext4@vger.kernel.org>; Sat, 7 May 2011 19:54:08 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p47Ns8xs020791
	for <linux-ext4@vger.kernel.org>; Sat, 7 May 2011 19:54:08 -0400
Received: from [9.48.112.215] (sig-9-48-112-215.mts.ibm.com [9.48.112.215])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id p47Ns7Pg020787
	for <linux-ext4@vger.kernel.org>; Sat, 7 May 2011 19:54:07 -0400
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
:100644 100644 3ba6c31... 95efb4e... M	fs/ext4/ext4.h
:100644 100644 f92c58b... 8ce382d... M	fs/ext4/inode.c
 fs/ext4/ext4.h  |    2 ++
 fs/ext4/inode.c |   33 +++++++++++++++++++++++++++++++--
 2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 3ba6c31..95efb4e 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1758,6 +1758,8 @@ extern int ext4_writepage_trans_blocks(struct inode *);
 extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
 extern int ext4_block_truncate_page(handle_t *handle,
 		struct address_space *mapping, loff_t from);
+extern int ext4_block_zero_page_range(handle_t *handle,
+		struct address_space *mapping, loff_t from, loff_t length);
 extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf);
 extern qsize_t *ext4_get_reserved_space(struct inode *inode);
 extern void ext4_da_update_reserve_space(struct inode *inode,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index f92c58b..8ce382d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3916,9 +3916,30 @@ void ext4_set_aops(struct inode *inode)
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
@@ -3931,7 +3952,15 @@ int ext4_block_truncate_page(handle_t *handle,
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

