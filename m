From: Jan Kara <jack@suse.cz>
Subject: [PATCH 05/11] ext4: Make sure blocks are properly allocated under mmaped page even when blocksize < pagesize
Date: Wed, 27 May 2009 15:01:02 +0200
Message-ID: <1243429268-3028-6-git-send-email-jack@suse.cz>
References: <1243429268-3028-1-git-send-email-jack@suse.cz>
Cc: npiggin@suse.de, linux-ext4@vger.kernel.org,
	Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47971 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762789AbZE0NBJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 May 2009 09:01:09 -0400
In-Reply-To: <1243429268-3028-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In a situation like:
  truncate(f, 1024);
  a = mmap(f, 0, 4096);
  a[0] = 'a';
  truncate(f, 4096);

we end up with a dirty page which does not have all blocks allocated /
reserved.  Fix the problem by using new VFS infrastructure.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/extents.c |    2 +-
 fs/ext4/inode.c   |   20 ++++++++++++++++++--
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 6b0eeaf..ef587f7 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3082,7 +3082,7 @@ static void ext4_falloc_update_inode(struct inode *inode,
 	 */
 	if (!(mode & FALLOC_FL_KEEP_SIZE)) {
 		if (new_size > i_size_read(inode))
-			i_size_write(inode, new_size);
+			block_extend_i_size(inode, new_size, 0);
 		if (new_size > EXT4_I(inode)->i_disksize)
 			ext4_update_i_disksize(inode, new_size);
 	}
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7fcceb0..6547788 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1436,7 +1436,7 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
  	index = pos >> PAGE_CACHE_SHIFT;
 	from = pos & (PAGE_CACHE_SIZE - 1);
 	to = from + len;
-
+	block_lock_hole_extend(inode, pos);
 retry:
 	handle = ext4_journal_start(inode, needed_blocks);
 	if (IS_ERR(handle)) {
@@ -1480,6 +1480,8 @@ retry:
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
 out:
+	if (ret)
+		block_unlock_hole_extend(inode);
 	return ret;
 }
 
@@ -1622,6 +1624,7 @@ static int ext4_journalled_write_end(struct file *file,
 	if (!ret)
 		ret = ret2;
 	page_cache_release(page);
+	block_unlock_hole_extend(inode);
 
 	return ret ? ret : copied;
 }
@@ -2733,6 +2736,7 @@ static int ext4_da_write_begin(struct file *file, struct address_space *mapping,
 		   "dev %s ino %lu pos %llu len %u flags %u",
 		   inode->i_sb->s_id, inode->i_ino,
 		   (unsigned long long) pos, len, flags);
+	block_lock_hole_extend(inode, pos);
 retry:
 	/*
 	 * With delayed allocation, we don't log the i_disksize update
@@ -2775,6 +2779,8 @@ retry:
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
 out:
+	if (ret)
+		block_unlock_hole_extend(inode);
 	return ret;
 }
 
@@ -3323,7 +3329,7 @@ static ssize_t ext4_direct_IO(int rw, struct kiocb *iocb,
 			loff_t end = offset + ret;
 			if (end > inode->i_size) {
 				ei->i_disksize = end;
-				i_size_write(inode, end);
+				block_extend_i_size(inode, offset, ret);
 				/*
 				 * We're going to return a positive `ret'
 				 * here due to non-zero-length I/O, so there's
@@ -3368,6 +3374,7 @@ static const struct address_space_operations ext4_ordered_aops = {
 	.sync_page		= block_sync_page,
 	.write_begin		= ext4_write_begin,
 	.write_end		= ext4_ordered_write_end,
+	.extend_i_size		= block_extend_i_size,
 	.bmap			= ext4_bmap,
 	.invalidatepage		= ext4_invalidatepage,
 	.releasepage		= ext4_releasepage,
@@ -3383,6 +3390,7 @@ static const struct address_space_operations ext4_writeback_aops = {
 	.sync_page		= block_sync_page,
 	.write_begin		= ext4_write_begin,
 	.write_end		= ext4_writeback_write_end,
+	.extend_i_size		= block_extend_i_size,
 	.bmap			= ext4_bmap,
 	.invalidatepage		= ext4_invalidatepage,
 	.releasepage		= ext4_releasepage,
@@ -3398,6 +3406,7 @@ static const struct address_space_operations ext4_journalled_aops = {
 	.sync_page		= block_sync_page,
 	.write_begin		= ext4_write_begin,
 	.write_end		= ext4_journalled_write_end,
+	.extend_i_size		= block_extend_i_size,
 	.set_page_dirty		= ext4_journalled_set_page_dirty,
 	.bmap			= ext4_bmap,
 	.invalidatepage		= ext4_invalidatepage,
@@ -3413,6 +3422,7 @@ static const struct address_space_operations ext4_da_aops = {
 	.sync_page		= block_sync_page,
 	.write_begin		= ext4_da_write_begin,
 	.write_end		= ext4_da_write_end,
+	.extend_i_size		= block_extend_i_size,
 	.bmap			= ext4_bmap,
 	.invalidatepage		= ext4_da_invalidatepage,
 	.releasepage		= ext4_releasepage,
@@ -5277,6 +5287,12 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 	struct address_space *mapping = inode->i_mapping;
 
 	/*
+	 * Wait for extending of i_size, after this moment, next truncate /
+	 * write can create holes under us but they writeprotect our page so
+	 * we'll be called again to fill the hole.
+	 */
+	block_wait_on_hole_extend(inode, page_offset(page));
+	/*
 	 * Get i_alloc_sem to stop truncates messing with the inode. We cannot
 	 * get i_mutex because we are already holding mmap_sem.
 	 */
-- 
1.6.0.2

