From: <gregkh@suse.de>
Subject: patch revert-retries-in-ext4_prepare_write-violate-ordering-requirements.patch queued to -stable tree
Date: Wed, 11 Apr 2007 14:32:07 -0700
Message-ID: <20070411213239.63A37BC9966@imap.suse.de>
References: <200704020649.l326niVR026539@shell0.pdx.osdl.net>
Cc: <stable@kernel.org>
To: akpm@linux-foundation.org, dev@openvz.org, dmonakhov@openvz.org,
	gregkh@suse.de, kenneth.w.chen@intel.com,
	linux-ext4@vger.kernel.org, mingo@elte.hu, saw@sw.ru
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50070 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965194AbXDKVco (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Apr 2007 17:32:44 -0400
In-Reply-To: <200704020649.l326niVR026539@shell0.pdx.osdl.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


This is a note to let you know that we have just queued up the patch titled

     Subject: revert "retries in ext4_prepare_write() violate ordering requirements"

to the 2.6.20-stable tree.  Its filename is

     revert-retries-in-ext4_prepare_write-violate-ordering-requirements.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org Sun Apr  1 23:51:19 2007
From: Andrew Morton <akpm@linux-foundation.org>
Date: Sun, 01 Apr 2007 23:49:44 -0700
Subject: revert "retries in ext4_prepare_write() violate ordering requirements"
To: torvalds@linux-foundation.org
Cc: dev@openvz.org, stable@kernel.org, kenneth.w.chen@intel.com, saw@sw.ru, dmonakhov@openvz.org, akpm@linux-foundation.org, linux-ext4@vger.kernel.org, mingo@elte.hu
Message-ID: <200704020649.l326niVR026539@shell0.pdx.osdl.net>


From: Andrew Morton <akpm@linux-foundation.org>

Revert b46be05004abb419e303e66e143eed9f8a6e9f3f.  Same reasoning as for ext3.

Cc: Kirill Korotaev <dev@openvz.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ken Chen <kenneth.w.chen@intel.com>
Cc: Andrey Savochkin <saw@sw.ru>
Cc: <linux-ext4@vger.kernel.org>
Cc: Dmitriy Monakhov <dmonakhov@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

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

_______________________________________________
stable mailing list
stable@linux.kernel.org
http://linux.kernel.org/mailman/listinfo/stable


Patches currently in stable-queue which might be from akpm@linux-foundation.org are
