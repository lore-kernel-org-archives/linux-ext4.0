From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: [PATCH 2/2]ext4: Invalidate donor file page not to refer old blocks
Date: Fri, 02 Oct 2009 17:24:41 +0900
Message-ID: <4AC5B8C9.20507@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
To: Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:53652 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162AbZJBIZS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 Oct 2009 04:25:18 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

ext4: Invalidate donor file page not to refer old blocks

After exchanging blocks between original and donor files in mext_extent_per_page(),
the page cache of donor file still refers to old block(s) on memory.
Therefore we have to invalidate page cache of donor file to avoid wrong reference.
The patch fixes this issue.

Signed-off-by: Akira Fujita <a-fujita@rs.jp.nec.com>
---
 fs/ext4/move_extent.c |   60 ++++++++++++++++++++++++++++++------------------
 1 files changed, 37 insertions(+), 23 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 83f8c9e..6ce8764 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -813,14 +813,15 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 	struct inode *orig_inode = o_filp->f_dentry->d_inode;
 	struct address_space *mapping = orig_inode->i_mapping;
 	struct buffer_head *bh;
-	struct page *page = NULL;
+	struct page *orig_page = NULL;
+	struct page *donor_page = NULL;
 	const struct address_space_operations *a_ops = mapping->a_ops;
 	handle_t *handle;
 	ext4_lblk_t orig_blk_offset;
-	long long offs = orig_page_offset << PAGE_CACHE_SHIFT;
+	long long o_pos;
+	pgoff_t donor_page_offset = orig_page_offset;
 	unsigned long blocksize = orig_inode->i_sb->s_blocksize;
-	unsigned int w_flags = 0;
-	unsigned int tmp_data_size, data_size, replaced_size;
+	unsigned int tmp_data_size, data_size, replaced_size, w_flags = 0;
 	void *fsdata;
 	int i, jblocks;
 	int err2 = 0;
@@ -861,7 +862,7 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 		goto out2;
 	}

-	offs = (long long)orig_blk_offset << orig_inode->i_blkbits;
+	o_pos = (long long)orig_blk_offset << orig_inode->i_blkbits;

 	/* Calculate data_size */
 	if ((orig_blk_offset + block_len_in_page - 1) ==
@@ -882,14 +883,14 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,

 	replaced_size = data_size;

-	*err = a_ops->write_begin(o_filp, mapping, offs, data_size, w_flags,
-				 &page, &fsdata);
+	*err = a_ops->write_begin(o_filp, mapping, o_pos, data_size, w_flags,
+				 &orig_page, &fsdata);
 	if (unlikely(*err < 0))
 		goto out;

-	if (!PageUptodate(page)) {
-		mapping->a_ops->readpage(o_filp, page);
-		lock_page(page);
+	if (!PageUptodate(orig_page)) {
+		mapping->a_ops->readpage(o_filp, orig_page);
+		lock_page(orig_page);
 	}

 	/*
@@ -899,11 +900,11 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 	 * It needs to call wait_on_page_writeback() to wait for the
 	 * writeback of the page.
 	 */
-	if (PageWriteback(page))
-		wait_on_page_writeback(page);
+	if (PageWriteback(orig_page))
+		wait_on_page_writeback(orig_page);

 	/* Release old bh and drop refs */
-	try_to_release_page(page, 0);
+	try_to_release_page(orig_page, 0);

 	replaced_count = mext_replace_branches(handle, orig_inode, donor_inode,
 					orig_blk_offset, block_len_in_page,
@@ -921,10 +922,23 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 	ext4_ext_invalidate_cache(orig_inode);
 	ext4_ext_invalidate_cache(donor_inode);

-	if (!page_has_buffers(page))
-		create_empty_buffers(page, 1 << orig_inode->i_blkbits, 0);
+	donor_page = grab_cache_page(donor_inode->i_mapping,
+						donor_page_offset);
+	if (!donor_page) {
+		*err = -ENOMEM;
+		goto out;
+	}
+	/* Invalidate donor page not to indicate old block on memory */
+	invalidate_mapping_pages(donor_inode->i_mapping, donor_page_offset,
+				donor_page_offset + 1);
+	unlock_page(donor_page);
+	page_cache_release(donor_page);
+	donor_page = NULL;
+
+	if (!page_has_buffers(orig_page))
+		create_empty_buffers(orig_page, 1 << orig_inode->i_blkbits, 0);

-	bh = page_buffers(page);
+	bh = page_buffers(orig_page);
 	for (i = 0; i < data_offset_in_page; i++)
 		bh = bh->b_this_page;

@@ -938,15 +952,15 @@ move_extent_per_page(struct file *o_filp, struct inode *donor_inode,
 			bh = bh->b_this_page;
 	}

-	*err = a_ops->write_end(o_filp, mapping, offs, data_size, replaced_size,
-			       page, fsdata);
-	page = NULL;
+	*err = a_ops->write_end(o_filp, mapping, o_pos, data_size,
+			       replaced_size, orig_page, fsdata);
+	orig_page = NULL;

 out:
-	if (unlikely(page)) {
-		if (PageLocked(page))
-			unlock_page(page);
-		page_cache_release(page);
+	if (unlikely(orig_page)) {
+		if (PageLocked(orig_page))
+			unlock_page(orig_page);
+		page_cache_release(orig_page);
 		ext4_journal_stop(handle);
 	}
 out2:
