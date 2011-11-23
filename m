From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH 2/2] ext4: let ext4_discard_partial_buffers handle pages without buffers correctly
Date: Wed, 23 Nov 2011 17:15:26 +0800
Message-ID: <1322039726-3587-2-git-send-email-xiaoqiangnk@gmail.com>
References: <1322039726-3587-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: achender@linux.vnet.ibm.com, tytso@mit.edu,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54225 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab1KWLse (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Nov 2011 06:48:34 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so1471959iag.19
        for <linux-ext4@vger.kernel.org>; Wed, 23 Nov 2011 03:48:33 -0800 (PST)
In-Reply-To: <1322039726-3587-1-git-send-email-xiaoqiangnk@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

If a page has been read to memory and never been written, it has no buffers,
but we should handle the page in truncate or punch hole.

Vfs code of writing operations has handled holes correctly, so this patch removes
the code handling hole in writing operations.

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/inode.c |   41 ++---------------------------------------
 1 files changed, 2 insertions(+), 39 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 20a1d17..bd793d6 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2385,7 +2385,6 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 	pgoff_t index;
 	struct inode *inode = mapping->host;
 	handle_t *handle;
-	loff_t page_len;
 
 	index = pos >> PAGE_CACHE_SHIFT;
 
@@ -2432,13 +2431,6 @@ retry:
 		 */
 		if (pos + len > inode->i_size)
 			ext4_truncate_failed_write(inode);
-	} else {
-		page_len = pos & (PAGE_CACHE_SIZE - 1);
-		if (page_len > 0) {
-			ret = ext4_discard_partial_page_buffers_no_lock(handle,
-				inode, page, pos - page_len, page_len,
-				EXT4_DISCARD_PARTIAL_PG_ZERO_UNMAPPED);
-		}
 	}
 
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
@@ -2481,7 +2473,6 @@ static int ext4_da_write_end(struct file *file,
 	loff_t new_i_size;
 	unsigned long start, end;
 	int write_mode = (int)(unsigned long)fsdata;
-	loff_t page_len;
 
 	if (write_mode == FALL_BACK_TO_NONDELALLOC) {
 		if (ext4_should_order_data(inode)) {
@@ -2530,16 +2521,6 @@ static int ext4_da_write_end(struct file *file,
 	}
 	ret2 = generic_write_end(file, mapping, pos, len, copied,
 							page, fsdata);
-
-	page_len = PAGE_CACHE_SIZE -
-			((pos + copied - 1) & (PAGE_CACHE_SIZE - 1));
-
-	if (page_len > 0) {
-		ret = ext4_discard_partial_page_buffers_no_lock(handle,
-			inode, page, pos + copied - 1, page_len,
-			EXT4_DISCARD_PARTIAL_PG_ZERO_UNMAPPED);
-	}
-
 	copied = ret2;
 	if (ret2 < 0)
 		ret = ret2;
@@ -3201,26 +3182,8 @@ int ext4_discard_partial_page_buffers_no_lock(handle_t *handle,
 
 	iblock = index << (PAGE_CACHE_SHIFT - inode->i_sb->s_blocksize_bits);
 
-	if (!page_has_buffers(page)) {
-		/*
-		 * If the range to be discarded covers a partial block
-		 * we need to get the page buffers.  This is because
-		 * partial blocks cannot be released and the page needs
-		 * to be updated with the contents of the block before
-		 * we write the zeros on top of it.
-		 */
-		if ((from & (blocksize - 1)) ||
-		    ((from + length) & (blocksize - 1))) {
-			create_empty_buffers(page, blocksize, 0);
-		} else {
-			/*
-			 * If there are no partial blocks,
-			 * there is nothing to update,
-			 * so we can return now
-			 */
-			return 0;
-		}
-	}
+	if (!page_has_buffers(page))
+		create_empty_buffers(page, blocksize, 0);
 
 	/* Find the buffer that contains "offset" */
 	bh = page_buffers(page);
-- 
1.7.5.1

