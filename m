From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 06/10] ext4: punch_hole should wait for DIO writers V2
Date: Mon, 24 Sep 2012 15:44:16 +0400
Message-ID: <1348487060-19598-7-git-send-email-dmonakhov@openvz.org>
References: <1348487060-19598-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, lczerner@redhat.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54781 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab2IXLoi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Sep 2012 07:44:38 -0400
Received: by mail-lb0-f174.google.com with SMTP id gj3so6549370lbb.19
        for <linux-ext4@vger.kernel.org>; Mon, 24 Sep 2012 04:44:38 -0700 (PDT)
In-Reply-To: <1348487060-19598-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

punch_hole are the places where we have to wait for all existing writers
(writeback, aio, dio), but currently we simply flush pended end_io request
which is not sufficient. Even more i_mutex is not holded while punch_hole
which obviously result in dangerous data corruption due to
write-after-free.

This patch performs following changes:
- Guard punch_hole with i_mutex
- Recheck inode flags under i_mutex
- Block all new dio readers in order to prevent information leak caused by
  read-after-free pattern.
- punch_hole now wait for all writers in flight
  NOTE: XXX write-after-free race is still possible because
  truncate_pagecache_range()  is not completely reliable and where
  is no easy way to stop writeback while punch_hole is in progress.

Changes from V1:
  Add flag checks once we hold i_mutex

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |   48 ++++++++++++++++++++++++++++++++----------------
 1 files changed, 32 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 6326874..2d58f4c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4821,9 +4821,29 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 	loff_t first_page_offset, last_page_offset;
 	int credits, err = 0;
 
+	/*
+	 * Write out all dirty pages to avoid race conditions
+	 * Then release them.
+	 */
+	if (mapping->nrpages && mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
+		err = filemap_write_and_wait_range(mapping,
+			offset, offset + length - 1);
+
+		if (err)
+			return err;
+	}
+
+	mutex_lock(&inode->i_mutex);
+	/* Need recheck file flags under mutex */
+	/* It's not possible punch hole on append only file */
+	if (IS_APPEND(inode) || IS_IMMUTABLE(inode))
+		return -EPERM;
+	if (IS_SWAPFILE(inode))
+		return -ETXTBSY;
+
 	/* No need to punch hole beyond i_size */
 	if (offset >= inode->i_size)
-		return 0;
+		goto out_mutex;
 
 	/*
 	 * If the hole extends beyond i_size, set the hole
@@ -4841,31 +4861,23 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 	first_page_offset = first_page << PAGE_CACHE_SHIFT;
 	last_page_offset = last_page << PAGE_CACHE_SHIFT;
 
-	/*
-	 * Write out all dirty pages to avoid race conditions
-	 * Then release them.
-	 */
-	if (mapping->nrpages && mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
-		err = filemap_write_and_wait_range(mapping,
-			offset, offset + length - 1);
-
-		if (err)
-			return err;
-	}
-
 	/* Now release the pages */
 	if (last_page_offset > first_page_offset) {
 		truncate_pagecache_range(inode, first_page_offset,
 					 last_page_offset - 1);
 	}
 
-	/* finish any pending end_io work */
+	/* Wait all existing dio workers, newcomers will block on i_mutex */
+	ext4_inode_block_unlocked_dio(inode);
+	inode_dio_wait(inode);
 	ext4_unwritten_wait(inode);
 
 	credits = ext4_writepage_trans_blocks(inode);
 	handle = ext4_journal_start(inode, credits);
-	if (IS_ERR(handle))
-		return PTR_ERR(handle);
+	if (IS_ERR(handle)) {
+		err = PTR_ERR(handle);
+		goto out_dio;
+	}
 
 
 	/*
@@ -4955,6 +4967,10 @@ out:
 	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
 	ext4_mark_inode_dirty(handle, inode);
 	ext4_journal_stop(handle);
+out_dio:
+	ext4_inode_resume_unlocked_dio(inode);
+out_mutex:
+	mutex_unlock(&inode->i_mutex);
 	return err;
 }
 int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
-- 
1.7.7.6

