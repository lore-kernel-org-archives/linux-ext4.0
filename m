From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/3] ext4: nonda_switch prevent deadlock
Date: Tue, 28 Aug 2012 20:21:41 +0400
Message-ID: <1346170903-7563-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, a-fujita@rs.jp.nec.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:65408 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753117Ab2H1QWB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 28 Aug 2012 12:22:01 -0400
Received: by lagy9 with SMTP id y9so3410021lag.19
        for <linux-ext4@vger.kernel.org>; Tue, 28 Aug 2012 09:22:00 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently ext4_da_write_begin may deadlock if called with opened journal
transaction. Real life example:
->move_extent_per_page()
  ->ext4_journal_start()-> hold journal transaction
  ->write_begin()
    ->ext4_da_write_begin()
      ->ext4_nonda_switch()
        ->writeback_inodes_sb_if_idle()  --> will wait for journal_stop()

This bug may be easily fixed by code reordering,
But in some cases it should be possible to call write_begin()
while holding journal's transaction, in this case caller may avoid
recoursion by passing AOP_FLAG_NOFS flag.
---
 fs/ext4/inode.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 6324f74..d12d30e 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -889,6 +889,11 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
 	struct page *page;
 	pgoff_t index;
 	unsigned from, to;
+	int nofs = flags & AOP_FLAG_NOFS;
+
+	/* We cannot recurse into the filesystem if the transaction is already
+	 * started */
+	BUG_ON(!nofs && journal_current_handle());
 
 	trace_ext4_write_begin(inode, pos, len, flags);
 	/*
@@ -906,9 +911,6 @@ retry:
 		ret = PTR_ERR(handle);
 		goto out;
 	}
-
-	/* We cannot recurse into the filesystem as the transaction is already
-	 * started */
 	flags |= AOP_FLAG_NOFS;
 
 	page = grab_cache_page_write_begin(mapping, index, flags);
@@ -957,7 +959,8 @@ retry:
 		}
 	}
 
-	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
+	if (!nofs && ret == -ENOSPC &&
+	    ext4_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
 out:
 	return ret;
@@ -2447,7 +2450,7 @@ out_writepages:
 }
 
 #define FALL_BACK_TO_NONDELALLOC 1
-static int ext4_nonda_switch(struct super_block *sb)
+static int ext4_nonda_switch(struct super_block *sb, int writeback_allowed)
 {
 	s64 free_blocks, dirty_blocks;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -2475,7 +2478,7 @@ static int ext4_nonda_switch(struct super_block *sb)
 	 * Even if we don't switch but are nearing capacity,
 	 * start pushing delalloc when 1/2 of free blocks are dirty.
 	 */
-	if (free_blocks < 2 * dirty_blocks)
+	if (writeback_allowed && free_blocks < 2 * dirty_blocks)
 		writeback_inodes_sb_if_idle(sb, WB_REASON_FS_FREE_SPACE);
 
 	return 0;
@@ -2490,10 +2493,14 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 	pgoff_t index;
 	struct inode *inode = mapping->host;
 	handle_t *handle;
+	int nofs = flags & AOP_FLAG_NOFS;
 
 	index = pos >> PAGE_CACHE_SHIFT;
+	/* We cannot recurse into the filesystem if the transaction is already
+	 * started */
+	BUG_ON(!nofs && journal_current_handle());
 
-	if (ext4_nonda_switch(inode->i_sb)) {
+	if (ext4_nonda_switch(inode->i_sb, !nofs)) {
 		*fsdata = (void *)FALL_BACK_TO_NONDELALLOC;
 		return ext4_write_begin(file, mapping, pos,
 					len, flags, pagep, fsdata);
@@ -2512,8 +2519,6 @@ retry:
 		ret = PTR_ERR(handle);
 		goto out;
 	}
-	/* We cannot recurse into the filesystem as the transaction is already
-	 * started */
 	flags |= AOP_FLAG_NOFS;
 
 	page = grab_cache_page_write_begin(mapping, index, flags);
@@ -2538,7 +2543,8 @@ retry:
 			ext4_truncate_failed_write(inode);
 	}
 
-	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
+	if (!nofs && ret == -ENOSPC &&
+	    ext4_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
 out:
 	return ret;
@@ -4791,7 +4797,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	/* Delalloc case is easy... */
 	if (test_opt(inode->i_sb, DELALLOC) &&
 	    !ext4_should_journal_data(inode) &&
-	    !ext4_nonda_switch(inode->i_sb)) {
+	    !ext4_nonda_switch(inode->i_sb, 1)) {
 		do {
 			ret = __block_page_mkwrite(vma, vmf,
 						   ext4_da_get_block_prep);
-- 
1.7.7.6

