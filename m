From: akpm@osdl.org
Subject: [patch 209/354] retries in ext3_prepare_write() violate ordering requirements
Date: Wed, 06 Dec 2006 20:37:34 -0800
Message-ID: <200612070437.kB74bZgV029705@shell0.pdx.osdl.net>
Cc: akpm@osdl.org, saw@sw.ru, dev@openvz.org, kenneth.w.chen@intel.com,
	linux-ext4@vger.kernel.org, mingo@elte.hu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:47034 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968748AbWLGEiR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Dec 2006 23:38:17 -0500
To: torvalds@osdl.org
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

From: Andrey Savochkin <saw@sw.ru>

In journal=ordered or journal=data mode retry in ext3_prepare_write()
breaks the requirements of journaling of data with respect to metadata. 
The fix is to call commit_write to commit allocated zero blocks before
retry.

Signed-off-by: Kirill Korotaev <dev@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ken Chen <kenneth.w.chen@intel.com>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext3/inode.c |   85 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 75 insertions(+), 10 deletions(-)

diff -puN fs/ext3/inode.c~retries-in-ext3_prepare_write-violate-ordering-requirements fs/ext3/inode.c
--- a/fs/ext3/inode.c~retries-in-ext3_prepare_write-violate-ordering-requirements
+++ a/fs/ext3/inode.c
@@ -1148,37 +1148,102 @@ static int do_journal_get_write_access(h
 	return ext3_journal_get_write_access(handle, bh);
 }
 
+/*
+ * The idea of this helper function is following:
+ * if prepare_write has allocated some blocks, but not all of them, the
+ * transaction must include the content of the newly allocated blocks.
+ * This content is expected to be set to zeroes by block_prepare_write().
+ * 2006/10/14  SAW
+ */
+static int ext3_prepare_failure(struct file *file, struct page *page,
+				unsigned from, unsigned to)
+{
+	struct address_space *mapping;
+	struct buffer_head *bh, *head, *next;
+	unsigned block_start, block_end;
+	unsigned blocksize;
+	int ret;
+	handle_t *handle = ext3_journal_current_handle();
+
+	mapping = page->mapping;
+	if (ext3_should_writeback_data(mapping->host)) {
+		/* optimization: no constraints about data */
+skip:
+		return ext3_journal_stop(handle);
+	}
+
+	head = page_buffers(page);
+	blocksize = head->b_size;
+	for (	bh = head, block_start = 0;
+		bh != head || !block_start;
+	    	block_start = block_end, bh = next)
+	{
+		next = bh->b_this_page;
+		block_end = block_start + blocksize;
+		if (block_end <= from)
+			continue;
+		if (block_start >= to) {
+			block_start = to;
+			break;
+		}
+		if (!buffer_mapped(bh))
+		/* prepare_write failed on this bh */
+			break;
+		if (ext3_should_journal_data(mapping->host)) {
+			ret = do_journal_get_write_access(handle, bh);
+			if (ret) {
+				ext3_journal_stop(handle);
+				return ret;
+			}
+		}
+	/*
+	 * block_start here becomes the first block where the current iteration
+	 * of prepare_write failed.
+	 */
+	}
+	if (block_start <= from)
+		goto skip;
+
+	/* commit allocated and zeroed buffers */
+	return mapping->a_ops->commit_write(file, page, from, block_start);
+}
+
 static int ext3_prepare_write(struct file *file, struct page *page,
 			      unsigned from, unsigned to)
 {
 	struct inode *inode = page->mapping->host;
-	int ret, needed_blocks = ext3_writepage_trans_blocks(inode);
+	int ret, ret2;
+	int needed_blocks = ext3_writepage_trans_blocks(inode);
 	handle_t *handle;
 	int retries = 0;
 
 retry:
 	handle = ext3_journal_start(inode, needed_blocks);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		goto out;
-	}
+	if (IS_ERR(handle))
+		return PTR_ERR(handle);
 	if (test_opt(inode->i_sb, NOBH) && ext3_should_writeback_data(inode))
 		ret = nobh_prepare_write(page, from, to, ext3_get_block);
 	else
 		ret = block_prepare_write(page, from, to, ext3_get_block);
 	if (ret)
-		goto prepare_write_failed;
+		goto failure;
 
 	if (ext3_should_journal_data(inode)) {
 		ret = walk_page_buffers(handle, page_buffers(page),
 				from, to, NULL, do_journal_get_write_access);
+		if (ret)
+			/* fatal error, just put the handle and return */
+			journal_stop(handle);
 	}
-prepare_write_failed:
-	if (ret)
-		ext3_journal_stop(handle);
+	return ret;
+
+failure:
+	ret2 = ext3_prepare_failure(file, page, from, to);
+	if (ret2 < 0)
+		return ret2;
 	if (ret == -ENOSPC && ext3_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
-out:
+	/* retry number exceeded, or other error like -EDQUOT */
 	return ret;
 }
 
_
