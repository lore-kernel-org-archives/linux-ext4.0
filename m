From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH v4] ext4:Let ext4_ext_fiemap_cb() handle blocks before request range correctly.
Date: Mon, 23 May 2011 15:02:58 +0800
Message-ID: <1306134178-9883-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: linux-ext4@vger.kernel.org, lczerner@redhat.com,
	amir73il@gmail.com, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52365 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab1EWHCm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 May 2011 03:02:42 -0400
Received: by pvg12 with SMTP id 12so2453048pvg.19
        for <linux-ext4@vger.kernel.org>; Mon, 23 May 2011 00:02:42 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

To get delayed-extent information, ext4_ext_fiemap_cb() looks up
pagecache, it thus collects information starting from a page's
head block.

If blocksize < pagesize, the beginning blocks of a page may lies
before the request range. So ext4_ext_fiemap_cb() should proceed
ignoring them, because they has been handled before. If no mapped
buffer in the range is found in the 1st page, we need to look up
the 2nd page, otherwise delayed-extents after a hole will be ignored.

Without this patch, xfstests 225 will hung on ext4 with 1K block.

Reported-by: Amir Goldstein <amir73il@users.sourceforge.net>
Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
v3->v4:
 Add Reported-by line and how to repoduce the bug.
 fs/ext4/extents.c |   51 ++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 36 insertions(+), 15 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e363f21..474eaad 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3680,6 +3680,7 @@ static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
 		pgoff_t		last_offset;
 		pgoff_t		offset;
 		pgoff_t		index;
+		pgoff_t		start_index = 0;
 		struct page	**pages = NULL;
 		struct buffer_head *bh = NULL;
 		struct buffer_head *head = NULL;
@@ -3706,39 +3707,57 @@ out:
 				kfree(pages);
 				return EXT_CONTINUE;
 			}
+			index = 0;
 
+next_page:
 			/* Try to find the 1st mapped buffer. */
-			end = ((__u64)pages[0]->index << PAGE_SHIFT) >>
+			end = ((__u64)pages[index]->index << PAGE_SHIFT) >>
 				  blksize_bits;
-			if (!page_has_buffers(pages[0]))
+			if (!page_has_buffers(pages[index]))
 				goto out;
-			head = page_buffers(pages[0]);
+			head = page_buffers(pages[index]);
 			if (!head)
 				goto out;
-
+		
+			index++;
 			bh = head;
 			do {
-				if (buffer_mapped(bh)) {
+				if (end >= newex->ec_block +
+					newex->ec_len)
+					/* The buffer is out of
+					 * the request range.
+					 */
+					goto out;
+
+				if (buffer_mapped(bh) &&
+				    end >= newex->ec_block) {
+					start_index = index - 1;
 					/* get the 1st mapped buffer. */
-					if (end > newex->ec_block +
-						newex->ec_len)
-						/* The buffer is out of
-						 * the request range.
-						 */
-						goto out;
 					goto found_mapped_buffer;
 				}
+
 				bh = bh->b_this_page;
 				end++;
 			} while (bh != head);
 
-			/* No mapped buffer found. */
-			goto out;
+			/* No mapped buffer in the range found in this page,
+			 * We need to look up next page.
+			 */
+			if (index >= ret) {
+				/* There is no page left, but we need to limit
+				 * newex->ec_len.
+				 */
+				newex->ec_len = end - newex->ec_block;
+				goto out;
+			}
+			goto next_page;
 		} else {
 			/*Find contiguous delayed buffers. */
 			if (ret > 0 && pages[0]->index == last_offset)
 				head = page_buffers(pages[0]);
 			bh = head;
+			index = 1;
+			start_index = 0;
 		}
 
 found_mapped_buffer:
@@ -3761,7 +3780,7 @@ found_mapped_buffer:
 				end++;
 			} while (bh != head);
 
-			for (index = 1; index < ret; index++) {
+			for (; index < ret; index++) {
 				if (!page_has_buffers(pages[index])) {
 					bh = NULL;
 					break;
@@ -3771,8 +3790,10 @@ found_mapped_buffer:
 					bh = NULL;
 					break;
 				}
+				
 				if (pages[index]->index !=
-					pages[0]->index + index) {
+				    pages[start_index]->index + index
+				    - start_index) {
 					/* Blocks are not contiguous. */
 					bh = NULL;
 					break;
-- 
1.7.5.1

