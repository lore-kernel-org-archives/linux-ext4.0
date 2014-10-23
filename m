From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: move_extent explicitly invalidate page buffers
Date: Thu, 23 Oct 2014 15:48:58 +0400
Message-ID: <1414064938-2496-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, wangxg.fnst@cn.fujitsu.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:3421 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624AbaJWLtQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Oct 2014 07:49:16 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In hard core test-cases such as ext4/301, ext4/302 some bh may
becomes dirty so try_to_release_page() will fail and result in
false positive EBUSY failures. We can easily fix that by
explicit ->invalidatepage() after we holds page which is locked
and uptodate.

Tested-by: Xiaoguang Wang<wangxg.fnst@cn.fujitsu.com>
Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/move_extent.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index c2b2b02..76c45b6 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -348,8 +348,9 @@ again:
 		     !try_to_release_page(pagep[0], 0)) ||
 		    (page_has_private(pagep[1]) &&
 		     !try_to_release_page(pagep[1], 0))) {
-			*err = -EBUSY;
-			goto drop_data_sem;
+			/* One of buffers is busy, fall back data copy */
+			ext4_double_up_write_data_sem(orig_inode, donor_inode);
+			goto data_copy;
 		}
 		replaced_count = ext4_swap_extents(handle, orig_inode,
 						   donor_inode, orig_blk_offset,
@@ -360,12 +361,15 @@ again:
 		goto unlock_pages;
 	}
 data_copy:
-	*err = mext_page_mkuptodate(pagep[0], from, from + replaced_size);
+	/* In order to drop all buffers we have to make page fully uptodate */
+	*err = mext_page_mkuptodate(pagep[0], 0, PAGE_CACHE_SIZE);
 	if (*err)
 		goto unlock_pages;
 
 	/* At this point all buffers in range are uptodate, old mapping layout
 	 * is no longer required, try to drop it now. */
+	do_invalidatepage(pagep[0], 0, PAGE_CACHE_SIZE);
+	do_invalidatepage(pagep[1], 0, PAGE_CACHE_SIZE);
 	if ((page_has_private(pagep[0]) && !try_to_release_page(pagep[0], 0)) ||
 	    (page_has_private(pagep[1]) && !try_to_release_page(pagep[1], 0))) {
 		*err = -EBUSY;
-- 
1.7.1

