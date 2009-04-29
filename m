From: Jan Kara <jack@suse.cz>
Subject: [PATCH 3/4] ext4: Make sure blocks are properly allocated under mmaped page even when blocksize < pagesize
Date: Wed, 29 Apr 2009 12:02:49 +0200
Message-ID: <1240999370-27502-4-git-send-email-jack@suse.cz>
References: <1240999370-27502-1-git-send-email-jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, npiggin@suse.de,
	Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:55077 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309AbZD2KCw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Apr 2009 06:02:52 -0400
In-Reply-To: <1240999370-27502-1-git-send-email-jack@suse.cz>
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
 fs/ext4/inode.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c6bd6ce..8f51219 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3363,6 +3363,7 @@ static const struct address_space_operations ext4_ordered_aops = {
 	.sync_page		= block_sync_page,
 	.write_begin		= ext4_write_begin,
 	.write_end		= ext4_ordered_write_end,
+	.extend_i_size		= block_extend_i_size,
 	.bmap			= ext4_bmap,
 	.invalidatepage		= ext4_invalidatepage,
 	.releasepage		= ext4_releasepage,
@@ -3378,6 +3379,7 @@ static const struct address_space_operations ext4_writeback_aops = {
 	.sync_page		= block_sync_page,
 	.write_begin		= ext4_write_begin,
 	.write_end		= ext4_writeback_write_end,
+	.extend_i_size		= block_extend_i_size,
 	.bmap			= ext4_bmap,
 	.invalidatepage		= ext4_invalidatepage,
 	.releasepage		= ext4_releasepage,
@@ -3393,6 +3395,7 @@ static const struct address_space_operations ext4_journalled_aops = {
 	.sync_page		= block_sync_page,
 	.write_begin		= ext4_write_begin,
 	.write_end		= ext4_journalled_write_end,
+	.extend_i_size		= block_extend_i_size,
 	.set_page_dirty		= ext4_journalled_set_page_dirty,
 	.bmap			= ext4_bmap,
 	.invalidatepage		= ext4_invalidatepage,
@@ -3408,6 +3411,7 @@ static const struct address_space_operations ext4_da_aops = {
 	.sync_page		= block_sync_page,
 	.write_begin		= ext4_da_write_begin,
 	.write_end		= ext4_da_write_end,
+	.extend_i_size		= block_extend_i_size,
 	.bmap			= ext4_bmap,
 	.invalidatepage		= ext4_da_invalidatepage,
 	.releasepage		= ext4_releasepage,
@@ -5260,6 +5264,12 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
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

