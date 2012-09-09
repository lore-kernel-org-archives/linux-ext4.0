From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 4/7] ext4: fsync should wait for DIO writers
Date: Sun,  9 Sep 2012 21:27:11 +0400
Message-ID: <1347211634-11509-5-git-send-email-dmonakhov@openvz.org>
References: <1347211634-11509-1-git-send-email-dmonakhov@openvz.org>
Cc: tytso@mit.edu, jack@suse.cz, wenqing.lz@taobao.com,
	Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:41324 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab2IIR11 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 9 Sep 2012 13:27:27 -0400
Received: by lbbgj3 with SMTP id gj3so743883lbb.19
        for <linux-ext4@vger.kernel.org>; Sun, 09 Sep 2012 10:27:25 -0700 (PDT)
In-Reply-To: <1347211634-11509-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

fsync and punch_hole are the places where we have to wait for all
existing writers (writeback, aio, dio), but currently we simply
flush pended end_io request which is not sufficient.
Even more i_mutex is not holded while punch_hole which obviously
result in dangerous data corruption due to write-after-free.

This patch performs following changes:

- Guard punch_hole with i_mutex
- fsync and punch_hole now wait for all writers in flight
  NOTE: XXX write-after-free race is still possible because
  truncate_pagecache_range() is not completely reliable and where
  is no easy way to stop writeback while punch_hole is in progress.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/extents.c |   10 ++++++++--
 fs/ext4/fsync.c   |    1 +
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index e993879..8252651 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4845,6 +4845,7 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 			return err;
 	}
 
+	mutex_lock(&inode->i_mutex);
 	/* Now release the pages */
 	if (last_page_offset > first_page_offset) {
 		truncate_pagecache_range(inode, first_page_offset,
@@ -4852,12 +4853,15 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 	}
 
 	/* finish any pending end_io work */
+	inode_dio_wait(inode);
 	ext4_flush_completed_IO(inode);
 
 	credits = ext4_writepage_trans_blocks(inode);
 	handle = ext4_journal_start(inode, credits);
-	if (IS_ERR(handle))
-		return PTR_ERR(handle);
+	if (IS_ERR(handle)) {
+		err = PTR_ERR(handle);
+		goto out_mutex;
+	}
 
 	err = ext4_orphan_add(handle, inode);
 	if (err)
@@ -4951,6 +4955,8 @@ out:
 	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
 	ext4_mark_inode_dirty(handle, inode);
 	ext4_journal_stop(handle);
+out_mutex:
+	mutex_unlock(&inode->i_mutex);
 	return err;
 }
 int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
diff --git a/fs/ext4/fsync.c b/fs/ext4/fsync.c
index 24f3719..290c5cf 100644
--- a/fs/ext4/fsync.c
+++ b/fs/ext4/fsync.c
@@ -204,6 +204,7 @@ int ext4_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 	if (inode->i_sb->s_flags & MS_RDONLY)
 		goto out;
 
+	inode_dio_wait(inode);
 	ret = ext4_flush_completed_IO(inode);
 	if (ret < 0)
 		goto out;
-- 
1.7.7.6

