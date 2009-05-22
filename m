From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12624] umount hangs after fsstress with data=journal
Date: Fri, 22 May 2009 06:51:43 GMT
Message-ID: <200905220651.n4M6ph5X017461@demeter.kernel.org>
References: <bug-12624-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59342 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbZEVGvm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 May 2009 02:51:42 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4M6piqS017462
	for <linux-ext4@vger.kernel.org>; Fri, 22 May 2009 06:51:44 GMT
In-Reply-To: <bug-12624-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12624





--- Comment #3 from Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>  2009-05-22 06:51:43 ---
I guess we would need this patch. But i am still hitting the BUG_ON.
Will try to debug further later today.

-aneesh

commit 85ddb1581222bac63035c16a6536b0a5a2cd60a0
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Thu May 21 23:58:17 2009 +0530

    ext4: Don't look at buffer_heads outside i_size.


    Buffer heads outside i_size will be unmapped. So when we
    are doing "walk_page_buffers" limit ourself to i_size.

    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6e5caa7..ebf7bb3 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2514,7 +2514,7 @@ static int ext4_da_writepage(struct page *page,
          * all are mapped and non delay. We don't want to
          * do block allocation here.
          */
-        ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE,
+        ret = block_prepare_write(page, 0, len,
                       noalloc_get_block_write);
         if (!ret) {
             page_bufs = page_buffers(page);
@@ -2536,7 +2536,7 @@ static int ext4_da_writepage(struct page *page,
             return 0;
         }
         /* now mark the buffer_heads as dirty and uptodate */
-        block_commit_write(page, 0, PAGE_CACHE_SIZE);
+        block_commit_write(page, 0, len);
     }

     if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
@@ -3210,6 +3210,8 @@ static int ext4_normal_writepage(struct page *page,
 static int __ext4_journalled_writepage(struct page *page,
                 struct writeback_control *wbc)
 {
+    loff_t size;
+    unsigned int len;
     struct address_space *mapping = page->mapping;
     struct inode *inode = mapping->host;
     struct buffer_head *page_bufs;
@@ -3217,14 +3219,19 @@ static int __ext4_journalled_writepage(struct page
*page,
     int ret = 0;
     int err;

-    ret = block_prepare_write(page, 0, PAGE_CACHE_SIZE,
+    size = i_size_read(inode);
+    if (page->index == size >> PAGE_CACHE_SHIFT)
+        len = size & ~PAGE_CACHE_MASK;
+    else
+        len = PAGE_CACHE_SIZE;
+
+    ret = block_prepare_write(page, 0, len,
                   noalloc_get_block_write);
     if (ret != 0)
         goto out_unlock;

     page_bufs = page_buffers(page);
-    walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE, NULL,
-                                bget_one);
+    walk_page_buffers(handle, page_bufs, 0, len, NULL, bget_one);
     /* As soon as we unlock the page, it can go away, but we have
      * references to buffers so we are safe */
     unlock_page(page);
@@ -3235,19 +3242,19 @@ static int __ext4_journalled_writepage(struct page
*page,
         goto out;
     }

-    ret = walk_page_buffers(handle, page_bufs, 0,
-            PAGE_CACHE_SIZE, NULL, do_journal_get_write_access);
+    ret = walk_page_buffers(handle, page_bufs, 0, len,
+                NULL, do_journal_get_write_access);

-    err = walk_page_buffers(handle, page_bufs, 0,
-                PAGE_CACHE_SIZE, NULL, write_end_fn);
+    err = walk_page_buffers(handle, page_bufs, 0, len,
+                NULL, write_end_fn);
     if (ret == 0)
         ret = err;
     err = ext4_journal_stop(handle);
     if (!ret)
         ret = err;

-    walk_page_buffers(handle, page_bufs, 0,
-                PAGE_CACHE_SIZE, NULL, bput_one);
+    walk_page_buffers(handle, page_bufs, 0, len,
+                NULL, bput_one);
     EXT4_I(inode)->i_state |= EXT4_STATE_JDATA;
     goto out;

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
