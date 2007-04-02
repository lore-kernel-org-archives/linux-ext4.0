From: akpm@linux-foundation.org
Subject: [patch 07/12] revert "retries in ext4_prepare_write() violate ordering requirements"
Date: Sun, 01 Apr 2007 23:49:44 -0700
Message-ID: <200704020649.l326niVR026539@shell0.pdx.osdl.net>
Cc: akpm@linux-foundation.org, dev@openvz.org, dmonakhov@openvz.org,
	kenneth.w.chen@intel.com, linux-ext4@vger.kernel.org,
	mingo@elte.hu, saw@sw.ru, stable@kernel.org
To: torvalds@linux-foundation.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41212 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933963AbXDBGvm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 Apr 2007 02:51:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

Revert b46be05004abb419e303e66e143eed9f8a6e9f3f.  Same reasoning as for ext3.

Cc: Kirill Korotaev <dev@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ken Chen <kenneth.w.chen@intel.com>
Cc: Andrey Savochkin <saw@sw.ru>
Cc: <linux-ext4@vger.kernel.org>
Cc: Dmitriy Monakhov <dmonakhov@openvz.org>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/inode.c |   85 +++++-----------------------------------------
 1 file changed, 10 insertions(+), 75 deletions(-)

diff -puN fs/ext4/inode.c~revert-retries-in-ext4_prepare_write-violate-ordering-requirements fs/ext4/inode.c
--- a/fs/ext4/inode.c~revert-retries-in-ext4_prepare_write-violate-ordering-requirements
+++ a/fs/ext4/inode.c
@@ -1147,102 +1147,37 @@ static int do_journal_get_write_access(h
 	return ext4_journal_get_write_access(handle, bh);
 }
 
-/*
- * The idea of this helper function is following:
- * if prepare_write has allocated some blocks, but not all of them, the
- * transaction must include the content of the newly allocated blocks.
- * This content is expected to be set to zeroes by block_prepare_write().
- * 2006/10/14  SAW
- */
-static int ext4_prepare_failure(struct file *file, struct page *page,
-				unsigned from, unsigned to)
-{
-	struct address_space *mapping;
-	struct buffer_head *bh, *head, *next;
-	unsigned block_start, block_end;
-	unsigned blocksize;
-	int ret;
-	handle_t *handle = ext4_journal_current_handle();
-
-	mapping = page->mapping;
-	if (ext4_should_writeback_data(mapping->host)) {
-		/* optimization: no constraints about data */
-skip:
-		return ext4_journal_stop(handle);
-	}
-
-	head = page_buffers(page);
-	blocksize = head->b_size;
-	for (	bh = head, block_start = 0;
-		bh != head || !block_start;
-	    	block_start = block_end, bh = next)
-	{
-		next = bh->b_this_page;
-		block_end = block_start + blocksize;
-		if (block_end <= from)
-			continue;
-		if (block_start >= to) {
-			block_start = to;
-			break;
-		}
-		if (!buffer_mapped(bh))
-		/* prepare_write failed on this bh */
-			break;
-		if (ext4_should_journal_data(mapping->host)) {
-			ret = do_journal_get_write_access(handle, bh);
-			if (ret) {
-				ext4_journal_stop(handle);
-				return ret;
-			}
-		}
-	/*
-	 * block_start here becomes the first block where the current iteration
-	 * of prepare_write failed.
-	 */
-	}
-	if (block_start <= from)
-		goto skip;
-
-	/* commit allocated and zeroed buffers */
-	return mapping->a_ops->commit_write(file, page, from, block_start);
-}
-
 static int ext4_prepare_write(struct file *file, struct page *page,
 			      unsigned from, unsigned to)
 {
 	struct inode *inode = page->mapping->host;
-	int ret, ret2;
-	int needed_blocks = ext4_writepage_trans_blocks(inode);
+	int ret, needed_blocks = ext4_writepage_trans_blocks(inode);
 	handle_t *handle;
 	int retries = 0;
 
 retry:
 	handle = ext4_journal_start(inode, needed_blocks);
-	if (IS_ERR(handle))
-		return PTR_ERR(handle);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out;
+	}
 	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
 		ret = nobh_prepare_write(page, from, to, ext4_get_block);
 	else
 		ret = block_prepare_write(page, from, to, ext4_get_block);
 	if (ret)
-		goto failure;
+		goto prepare_write_failed;
 
 	if (ext4_should_journal_data(inode)) {
 		ret = walk_page_buffers(handle, page_buffers(page),
 				from, to, NULL, do_journal_get_write_access);
-		if (ret)
-			/* fatal error, just put the handle and return */
-			ext4_journal_stop(handle);
 	}
-	return ret;
-
-failure:
-	ret2 = ext4_prepare_failure(file, page, from, to);
-	if (ret2 < 0)
-		return ret2;
+prepare_write_failed:
+	if (ret)
+		ext4_journal_stop(handle);
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
-	/* retry number exceeded, or other error like -EDQUOT */
+out:
 	return ret;
 }
 
_
