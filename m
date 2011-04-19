From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: [Ext4 punch hole 3/6 v5] Ext4 Punch Hole Support: Clear Hole
Date: Tue, 19 Apr 2011 00:42:43 -0700
Message-ID: <4DAD3CF3.1030309@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:38761 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979Ab1DSHms (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 19 Apr 2011 03:42:48 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e3.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p3J7LbLX010423
	for <linux-ext4@vger.kernel.org>; Tue, 19 Apr 2011 03:21:37 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p3J7glKs2535642
	for <linux-ext4@vger.kernel.org>; Tue, 19 Apr 2011 03:42:47 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p3J7glDP026906
	for <linux-ext4@vger.kernel.org>; Tue, 19 Apr 2011 03:42:47 -0400
Received: from [9.48.114.155] (sig-9-48-114-155.mts.ibm.com [9.48.114.155])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVin) with ESMTP id p3J7gkn2026855
	for <linux-ext4@vger.kernel.org>; Tue, 19 Apr 2011 03:42:46 -0400
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
:100644 100644 a256ba3... 6b64a79... M	fs/ext4/ext4.h
:100644 100644 ec890fd... 09fc53b... M	fs/ext4/inode.c
  fs/ext4/ext4.h  |    2 ++
  fs/ext4/inode.c |   33 +++++++++++++++++++++++++++++++--
  2 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index a256ba3..6b64a79 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1753,6 +1753,8 @@ extern int ext4_writepage_trans_blocks(struct 
inode *);
  extern int ext4_chunk_trans_blocks(struct inode *, int nrblocks);
  extern int ext4_block_truncate_page(handle_t *handle,
  		struct address_space *mapping, loff_t from);
+extern int ext4_block_zero_page_range(handle_t *handle,
+		struct address_space *mapping, loff_t from, loff_t length);
  extern int ext4_page_mkwrite(struct vm_area_struct *vma, struct 
vm_fault *vmf);
  extern qsize_t *ext4_get_reserved_space(struct inode *inode);
  extern void ext4_da_update_reserve_space(struct inode *inode,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index ec890fd..09fc53b 100644
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


