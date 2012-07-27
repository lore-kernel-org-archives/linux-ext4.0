From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 07/15] ext4: Take i_mutex before punching hole
Date: Fri, 27 Jul 2012 10:01:06 +0200
Message-ID: <1343376074-28034-8-git-send-email-lczerner@redhat.com>
References: <1343376074-28034-1-git-send-email-lczerner@redhat.com>
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, hughd@google.com,
	linux-mmc@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab2G0IB6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 27 Jul 2012 04:01:58 -0400
In-Reply-To: <1343376074-28034-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Currently the allocation might happen in the punched range after the
truncation and before the releasing the space of the range. This would
lead to blocks being unallocated under the mapped buffer heads resulting
in nasty bugs.

With this commit we take i_mutex before going to do anything in the
ext4_ext_punch_hole() preventing any write to happen while the hole
punching is in progress. This will also allow us to ditch the writeout
of dirty pages withing the range.

This commit was based on code provided by Zheng Liu, thanks!

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/extents.c |   26 ++++++++++----------------
 1 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 91341ec..2d6a216 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4755,9 +4755,11 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 	loff_t first_page_offset, last_page_offset;
 	int credits, err = 0;
 
+	mutex_lock(&inode->i_mutex);
+
 	/* No need to punch hole beyond i_size */
 	if (offset >= inode->i_size)
-		return 0;
+		goto out1;
 
 	/*
 	 * If the hole extends beyond i_size, set the hole
@@ -4775,18 +4777,6 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
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
@@ -4798,12 +4788,14 @@ int ext4_ext_punch_hole(struct file *file, loff_t offset, loff_t length)
 
 	credits = ext4_writepage_trans_blocks(inode);
 	handle = ext4_journal_start(inode, credits);
-	if (IS_ERR(handle))
-		return PTR_ERR(handle);
+	if (IS_ERR(handle)) {
+		err = PTR_ERR(handle);
+		goto out1;
+	}
 
 	err = ext4_orphan_add(handle, inode);
 	if (err)
-		goto out;
+		goto out1;
 
 	/*
 	 * Now we need to zero out the non-page-aligned data in the
@@ -4893,6 +4885,8 @@ out:
 	inode->i_mtime = inode->i_ctime = ext4_current_time(inode);
 	ext4_mark_inode_dirty(handle, inode);
 	ext4_journal_stop(handle);
+out1:
+	mutex_unlock(&inode->i_mutex);
 	return err;
 }
 int ext4_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
-- 
1.7.7.6

