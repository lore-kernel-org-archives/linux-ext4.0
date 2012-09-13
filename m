From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 4/9] ext4: punch_hole should wait for DIO writers
Date: Thu, 13 Sep 2012 19:01:09 +0400
Message-ID: <1347548474-31897-5-git-send-email-dmonakhov@openvz.org>
References: <1347548474-31897-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, wenqing.lz@taobao.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:44132 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757842Ab2IMPB0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 13 Sep 2012 11:01:26 -0400
Received: by lagy9 with SMTP id y9so1991567lag.19
        for <linux-ext4@vger.kernel.org>; Thu, 13 Sep 2012 08:01:24 -0700 (PDT)
In-Reply-To: <1347548474-31897-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

punch_hole are the places where we have to wait for all existing writers
(writeback, aio, dio), but currently we simply flush pended end_io request
which is not sufficient. Even more i_mutex is not holded while punch_hole
which obviously result in dangerous data corruption due to
access-after-free issue.

This patch performs following changes:
- Guard punch_hole with i_mutex
- Block all new dio readers in order to prevent information leak caused by
  read-after-free pattern.
- punch_hole now wait for all writers in flight
  NOTE: XXX write-after-free race is still possible because there is
        no easy way to stop writeback while punch_hole is in progress.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |   41 +++++++++++++++++++++++++----------------
 1 files changed, 25 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 44e33b0..0e94485 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4814,9 +4814,22 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
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
 	/* No need to punch hole beyond i_size */
 	if (offset >= inode->i_size)
-		return 0;
+		goto out_mutex;
 
 	/*
 	 * If the hole extends beyond i_size, set the hole
@@ -4834,31 +4847,23 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
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
 	ext4_flush_completed_IO(inode);
 
 	credits = ext4_writepage_trans_blocks(inode);
 	handle = ext4_journal_start(inode, credits);
-	if (IS_ERR(handle))
-		return PTR_ERR(handle);
+	if (IS_ERR(handle)) {
+		err = PTR_ERR(handle);
+		goto out_dio;
+	}
 
 	err = ext4_orphan_add(handle, inode);
 	if (err)
@@ -4952,6 +4957,10 @@ out:
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

