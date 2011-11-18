From: Robin Dong <hao.bigrat@gmail.com>
Subject: [PATCH 5/9 v2 bigalloc] ext4: zero out extra pages when users write one page
Date: Fri, 18 Nov 2011 18:43:00 +0800
Message-ID: <1321612984-10228-6-git-send-email-hao.bigrat@gmail.com>
References: <1321612984-10228-1-git-send-email-hao.bigrat@gmail.com>
Cc: Robin Dong <sanbai@taobao.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62580 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab1KRKnZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 18 Nov 2011 05:43:25 -0500
Received: by mail-iy0-f174.google.com with SMTP id e36so3428378iag.19
        for <linux-ext4@vger.kernel.org>; Fri, 18 Nov 2011 02:43:25 -0800 (PST)
In-Reply-To: <1321612984-10228-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Robin Dong <sanbai@taobao.com>

When users write one page which in the middle of a cluster, we need to zero the
anthor pages around it.

Signed-off-by: Robin Dong <sanbai@taobao.com>
---
 fs/ext4/ext4.h  |   18 ++++
 fs/ext4/inode.c |  295 ++++++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 297 insertions(+), 16 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 1dea3e8..90ae8a2 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -675,6 +675,15 @@ struct move_extent {
 #define EXT4_EPOCH_MASK ((1 << EXT4_EPOCH_BITS) - 1)
 #define EXT4_NSEC_MASK  (~0UL << EXT4_EPOCH_BITS)
 
+#define EXT4_MAX_CLUSTERSIZE 1048576
+#define EXT4_MAX_CTXT_PAGES (EXT4_MAX_CLUSTERSIZE / PAGE_CACHE_SIZE)
+
+/* tracking cluster write pages */
+struct ext4_write_cluster_ctxt {
+	unsigned long	w_num_pages;
+	struct page	*w_pages[EXT4_MAX_CTXT_PAGES];
+};
+
 /*
  * Extended fields will fit into an inode if the filesystem was formatted
  * with large inodes (-I 256 or larger) and there are not currently any EAs
@@ -1849,6 +1858,15 @@ extern int ext4_group_add_blocks(handle_t *handle, struct super_block *sb,
 extern int ext4_trim_fs(struct super_block *, struct fstrim_range *);
 
 /* inode.c */
+int walk_page_buffers(handle_t *handle, struct buffer_head *head,
+		unsigned from, unsigned to, int *partial,
+		int (*fn)(handle_t *handle, struct buffer_head *bh));
+int do_journal_get_write_access(handle_t *handle, struct buffer_head *bh);
+struct ext4_write_cluster_ctxt *ext4_alloc_write_cluster_ctxt(void);
+void ext4_free_write_cluster_ctxt(struct ext4_write_cluster_ctxt *ewcc);
+int ext4_zero_cluster_page(struct inode *inode, int index,
+		struct ext4_write_cluster_ctxt *ewcc, unsigned flags);
+
 struct buffer_head *ext4_getblk(handle_t *, struct inode *,
 						ext4_lblk_t, int, int *);
 struct buffer_head *ext4_bread(handle_t *, struct inode *,
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 9b83c3c..f1c332d 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -38,6 +38,7 @@
 #include <linux/printk.h>
 #include <linux/slab.h>
 #include <linux/ratelimit.h>
+#include <linux/swap.h>
 
 #include "ext4_jbd2.h"
 #include "xattr.h"
@@ -49,6 +50,31 @@
 
 #define MPAGE_DA_EXTENT_TAIL 0x01
 
+static void ext4_write_cluster_add_page(struct ext4_write_cluster_ctxt *ewcc,
+		struct page *page)
+{
+	ewcc->w_pages[ewcc->w_num_pages] = page;
+	ewcc->w_num_pages++;
+}
+
+struct ext4_write_cluster_ctxt *ext4_alloc_write_cluster_ctxt(void)
+{
+	return kzalloc(sizeof(struct ext4_write_cluster_ctxt), GFP_NOFS);
+}
+
+void ext4_free_write_cluster_ctxt(struct ext4_write_cluster_ctxt *ewcc)
+{
+	int i;
+	for (i = 0; i < ewcc->w_num_pages; i++) {
+		if (ewcc->w_pages[i]) {
+			unlock_page(ewcc->w_pages[i]);
+			mark_page_accessed(ewcc->w_pages[i]);
+			page_cache_release(ewcc->w_pages[i]);
+		}
+	}
+	kfree(ewcc);
+}
+
 static inline int ext4_begin_ordered_truncate(struct inode *inode,
 					      loff_t new_size)
 {
@@ -656,7 +682,7 @@ struct buffer_head *ext4_bread(handle_t *handle, struct inode *inode,
 	return NULL;
 }
 
-static int walk_page_buffers(handle_t *handle,
+int walk_page_buffers(handle_t *handle,
 			     struct buffer_head *head,
 			     unsigned from,
 			     unsigned to,
@@ -712,7 +738,7 @@ static int walk_page_buffers(handle_t *handle,
  * is elevated.  We'll still have enough credits for the tiny quotafile
  * write.
  */
-static int do_journal_get_write_access(handle_t *handle,
+int do_journal_get_write_access(handle_t *handle,
 				       struct buffer_head *bh)
 {
 	int dirty = buffer_dirty(bh);
@@ -738,15 +764,176 @@ static int do_journal_get_write_access(handle_t *handle,
 
 static int ext4_get_block_write(struct inode *inode, sector_t iblock,
 		   struct buffer_head *bh_result, int create);
+
+int ext4_cluster_write_begin(struct page *page, loff_t pos, unsigned len,
+		get_block_t *get_block)
+{
+	unsigned from = pos & (PAGE_CACHE_SIZE - 1);
+	unsigned to = from + len;
+	struct inode *inode = page->mapping->host;
+	unsigned block_start, block_end;
+	sector_t block;
+	int err = 0;
+	unsigned blocksize, bbits;
+	struct buffer_head *bh, *head, *wait[2], **wait_bh = wait;
+
+	BUG_ON(!PageLocked(page));
+	BUG_ON(from > PAGE_CACHE_SIZE);
+	BUG_ON(to > PAGE_CACHE_SIZE);
+	BUG_ON(from > to);
+
+	blocksize = 1 << inode->i_blkbits;
+	if (!page_has_buffers(page))
+		create_empty_buffers(page, blocksize, 0);
+	head = page_buffers(page);
+
+	bbits = inode->i_blkbits;
+	block = (sector_t)page->index << (PAGE_CACHE_SHIFT - bbits);
+
+	for (bh = head, block_start = 0; bh != head || !block_start;
+	    block++, block_start = block_end, bh = bh->b_this_page) {
+		block_end = block_start + blocksize;
+		if (block_end <= from || block_start >= to) {
+			if (PageUptodate(page)) {
+				if (!buffer_uptodate(bh))
+					set_buffer_uptodate(bh);
+			}
+			continue;
+		}
+		if (buffer_new(bh))
+			clear_buffer_new(bh);
+		if (!buffer_mapped(bh)) {
+			WARN_ON(bh->b_size != blocksize);
+			err = get_block(inode, block, bh, 1);
+			if (err)
+				break;
+			unmap_underlying_metadata(bh->b_bdev,
+						bh->b_blocknr);
+			if (PageUptodate(page)) {
+				clear_buffer_new(bh);
+				set_buffer_uptodate(bh);
+				mark_buffer_dirty(bh);
+				continue;
+			}
+			if (block_end > to || block_start < from)
+				zero_user_segments(page,
+					to, block_end,
+					block_start, from);
+			continue;
+		}
+		if (PageUptodate(page)) {
+			if (!buffer_uptodate(bh))
+				set_buffer_uptodate(bh);
+			continue;
+		}
+		if (!buffer_uptodate(bh) && !buffer_delay(bh) &&
+		    !buffer_unwritten(bh) &&
+		     (block_start < from || block_end > to)) {
+			ll_rw_block(READ, 1, &bh);
+			*wait_bh++ = bh;
+		}
+	}
+	/*
+	 * If we issued read requests - let them complete.
+	 */
+	while (wait_bh > wait) {
+		wait_on_buffer(*--wait_bh);
+		if (!buffer_uptodate(*wait_bh))
+			err = -EIO;
+	}
+	if (unlikely(err))
+		page_zero_new_buffers(page, from, to);
+	return err;
+}
+
+int ext4_zero_cluster_page(struct inode *inode, int index,
+		struct ext4_write_cluster_ctxt *ewcc, unsigned flags)
+{
+	int ret = 0;
+	struct page *page;
+
+	page = grab_cache_page_write_begin(inode->i_mapping, index, flags);
+	if (!page) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ext4_write_cluster_add_page(ewcc, page);
+
+	/* if page is already uptodate and has buffers, don't get_block again
+	 */
+	if (PageUptodate(page) && PagePrivate(page))
+		goto out;
+
+	zero_user_segment(page, 0, PAGE_CACHE_SIZE);
+	SetPageUptodate(page);
+	if (ext4_should_dioread_nolock(inode))
+		ret = ext4_cluster_write_begin(page, index << PAGE_CACHE_SHIFT,
+				PAGE_CACHE_SIZE, ext4_get_block_write);
+	else
+		ret = ext4_cluster_write_begin(page, index << PAGE_CACHE_SHIFT,
+				PAGE_CACHE_SIZE, ext4_get_block);
+
+out:
+	return ret;
+}
+
+int ext4_prepare_cluster_left_pages(struct inode *inode, int index,
+		struct ext4_write_cluster_ctxt *ewcc, unsigned flags)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	int ret = 0;
+	int block;
+	sector_t left_offset = index & (sbi->s_cluster_ratio - 1);
+	sector_t begin;
+
+	if (left_offset) {
+		begin = index - left_offset;
+		for (block = begin; block < index; block++) {
+			ret = ext4_zero_cluster_page(inode, block, ewcc, flags);
+			if (ret)
+				goto out;
+		}
+	}
+
+out:
+	return ret;
+}
+
+int ext4_prepare_cluster_right_pages(struct inode *inode, int index,
+		struct ext4_write_cluster_ctxt *ewcc, unsigned flags)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	int ret = 0;
+	int block;
+	sector_t left_offset = index & (sbi->s_cluster_ratio - 1);
+	sector_t right_offset = sbi->s_cluster_ratio - left_offset - 1;
+	sector_t begin;
+
+	if (right_offset) {
+		begin = index + 1;
+		for (block = begin; block < index + right_offset + 1; block++) {
+			ret = ext4_zero_cluster_page(inode, block, ewcc, flags);
+			if (ret)
+				goto out;
+		}
+	}
+
+out:
+	return ret;
+}
+
 static int ext4_write_begin(struct file *file, struct address_space *mapping,
 			    loff_t pos, unsigned len, unsigned flags,
 			    struct page **pagep, void **fsdata)
 {
 	struct inode *inode = mapping->host;
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	int ret, needed_blocks;
 	handle_t *handle;
-	int retries = 0;
-	struct page *page;
+	int retries = 0, uninit = 0;
+	struct page *page = NULL;
+	struct ext4_write_cluster_ctxt *ewcc;
 	pgoff_t index;
 	unsigned from, to;
 
@@ -761,6 +948,12 @@ static int ext4_write_begin(struct file *file, struct address_space *mapping,
 	to = from + len;
 
 retry:
+	ewcc = ext4_alloc_write_cluster_ctxt();
+	if (!ewcc) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	handle = ext4_journal_start(inode, needed_blocks);
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
@@ -771,27 +964,78 @@ retry:
 	 * started */
 	flags |= AOP_FLAG_NOFS;
 
+	if (sbi->s_cluster_ratio > 1) {
+		/* We need to know whether the block is allocated already
+		 */
+		struct ext4_map_blocks map;
+		map.m_lblk = index;
+		map.m_len = 1;
+		ret = ext4_map_blocks(handle, inode, &map, 0);
+		uninit = map.m_flags & EXT4_MAP_UNWRITTEN;
+		if (ret <= 0 || uninit) {
+			ret = ext4_prepare_cluster_left_pages(inode, index,
+					ewcc, flags);
+			if (ret)
+				goto err_out;
+		}
+	}
+
 	page = grab_cache_page_write_begin(mapping, index, flags);
 	if (!page) {
-		ext4_journal_stop(handle);
 		ret = -ENOMEM;
-		goto out;
+		goto err_out;
 	}
+
 	*pagep = page;
 
-	if (ext4_should_dioread_nolock(inode))
-		ret = __block_write_begin(page, pos, len, ext4_get_block_write);
-	else
-		ret = __block_write_begin(page, pos, len, ext4_get_block);
+	ext4_write_cluster_add_page(ewcc, page);
+
+	/* if the block is already allocated by cluster, we should use
+	 * ext4_cluster_write_begin (it will not read buffer again)
+	 */
+	if (sbi->s_cluster_ratio > 1 && (pos >> inode->i_blkbits) >
+			((inode->i_size + inode->i_sb->s_blocksize - 1) >>
+			 inode->i_blkbits) - 1) {
+		if (ext4_should_dioread_nolock(inode))
+			ret = ext4_cluster_write_begin(page, pos, len,
+					ext4_get_block_write);
+		else
+			ret = ext4_cluster_write_begin(page, pos, len,
+					ext4_get_block);
+	} else {
+		if (ext4_should_dioread_nolock(inode))
+			ret = __block_write_begin(page, pos, len,
+					ext4_get_block_write);
+		else
+			ret = __block_write_begin(page, pos, len,
+					ext4_get_block);
+	}
+
+	if (sbi->s_cluster_ratio > 1 && uninit) {
+		ret = ext4_prepare_cluster_right_pages(inode, index,
+				ewcc, flags);
+		if (ret)
+			goto err_out;
+	}
 
 	if (!ret && ext4_should_journal_data(inode)) {
-		ret = walk_page_buffers(handle, page_buffers(page),
+		int i;
+		unsigned long from, to;
+		for (i = 0; i < ewcc->w_num_pages; i++) {
+			page = ewcc->w_pages[i];
+			if (!page || !page_buffers(page))
+				continue;
+			from = page->index << PAGE_CACHE_SHIFT;
+			to = from + PAGE_CACHE_SIZE;
+			ret = walk_page_buffers(handle, page_buffers(page),
 				from, to, NULL, do_journal_get_write_access);
+			if (ret)
+				break;
+		}
 	}
 
 	if (ret) {
-		unlock_page(page);
-		page_cache_release(page);
+		ext4_free_write_cluster_ctxt(ewcc);
 		/*
 		 * __block_write_begin may have instantiated a few blocks
 		 * outside i_size.  Trim these off again. Don't need
@@ -819,8 +1063,15 @@ retry:
 
 	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
 		goto retry;
+
+	*fsdata = ewcc;
 out:
 	return ret;
+
+err_out:
+	ext4_free_write_cluster_ctxt(ewcc);
+	ext4_journal_stop(handle);
+	return ret;
 }
 
 /* For write_end() in data=journal mode */
@@ -837,11 +1088,24 @@ static int ext4_generic_write_end(struct file *file,
 				  loff_t pos, unsigned len, unsigned copied,
 				  struct page *page, void *fsdata)
 {
-	int i_size_changed = 0;
+	int i_size_changed = 0, i;
 	struct inode *inode = mapping->host;
+	struct ext4_write_cluster_ctxt *ewcc = fsdata;
 	handle_t *handle = ext4_journal_current_handle();
 
 	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
+	for (i = 0; i < ewcc->w_num_pages; i++) {
+		unsigned long pos;
+		struct page *cluster_page;
+		cluster_page = ewcc->w_pages[i];
+		if (!cluster_page)
+			break;
+		if (cluster_page == page)
+			continue;
+		pos = cluster_page->index << PAGE_CACHE_SHIFT;
+		block_write_end(file, mapping, pos, PAGE_CACHE_SIZE,
+				PAGE_CACHE_SIZE, cluster_page, fsdata);
+	}
 
 	/*
 	 * No need to use i_size_read() here, the i_size
@@ -863,8 +1127,7 @@ static int ext4_generic_write_end(struct file *file,
 		ext4_update_i_disksize(inode, (pos + copied));
 		i_size_changed = 1;
 	}
-	unlock_page(page);
-	page_cache_release(page);
+	ext4_free_write_cluster_ctxt(ewcc);
 
 	/*
 	 * Don't mark the inode dirty under page lock. First, it unnecessarily
-- 
1.7.3.2

