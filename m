From: Theodore Ts'o <tytso@mit.edu>
Subject: [RFC PATCH 1/2] ext4: add a version of convert_inline_data_nolock() for regular files
Date: Mon,  5 Jun 2017 20:03:58 -0400
Message-ID: <20170606000359.16794-1-tytso@mit.edu>
Cc: gnehzuil.liu@gmail.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46904 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751209AbdFFAEG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 5 Jun 2017 20:04:06 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The current version of ext4_convert_inline_data_nolock() should not be
used for regular files, since it does the conversion via using jbd2,
and this if we are not using data journalling, this is unsafe.  If the
data block is updated after the inode is converted from using inline
data to using a data block, when the journal is replayed, the new
version of the data block can get overwritten by the old version of
the data block.

The ext4_convert_inline_data_nolock() also doesn't handle races with
Direct I/O correctly.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/inline.c | 110 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 107 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index 8d141c0c8ff9..c9e3a262f27f 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -1259,6 +1259,79 @@ static int ext4_convert_inline_data_nolock(handle_t *handle,
 }
 
 /*
+ * Only used for regular files, not directories!
+ *
+ * The inode and page must be locked when this function is called.
+ */
+static int reg_convert_inline_data_nolock(handle_t *handle,
+					  struct inode *inode,
+					  struct page *page,
+					  struct ext4_iloc *iloc)
+{
+	int error;
+	struct buffer_head *data_bh = NULL;
+	int inline_size = ext4_get_inline_size(inode);
+
+	if (!(inode->i_state & (I_NEW|I_FREEING)))
+		WARN_ON(!inode_is_locked(inode));
+
+	/* If some one has already done this for us, just exit. */
+	if (!ext4_has_inline_data(inode))
+		return 0;
+
+	if (!PageUptodate(page)) {
+		error = ext4_read_inline_page(inode, page);
+		if (error < 0)
+			return error;
+	}
+
+	/* Avoid races with DIO */
+	ext4_inode_block_unlocked_dio(inode);
+	inode_dio_wait(inode);
+
+	error = ext4_destroy_inline_data_nolock(handle, inode);
+	if (error)
+		return error;
+
+	error = __block_write_begin(page, 0, inline_size, ext4_get_block);
+	if (error)
+		goto out_restore;
+
+	data_bh = page_buffers(page);
+	BUG_ON(data_bh == NULL);
+
+	if (ext4_should_journal_data(inode)) {
+		lock_buffer(data_bh);
+		error = ext4_journal_get_create_access(handle, data_bh);
+		if (error) {
+			unlock_buffer(data_bh);
+			error = -EIO;
+			goto out_restore;
+		}
+		error = ext4_handle_dirty_metadata(handle, inode, data_bh);
+		unlock_buffer(data_bh);
+	} else {
+		__set_page_dirty_buffers(page);
+		if (ext4_should_order_data(inode))
+			error = ext4_jbd2_inode_add_write(handle, inode);
+	}
+
+out_restore:
+	if (error) {
+		void *kaddr = kmap_atomic(page);
+
+		if (data_bh)
+			ext4_free_blocks(handle, inode, data_bh, 0, 1, 0);
+		ext4_create_inline_data(handle, inode, inline_size);
+		ext4_write_inline_data(inode, iloc, kaddr, 0, inline_size);
+		ext4_set_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+		kunmap_atomic(kaddr);
+	}
+	ext4_inode_resume_unlocked_dio(inode);
+	return error;
+}
+
+/*
  * Try to add the new entry to the inline data.
  * If succeeds, return 0. If not, extended the inline dir and copied data to
  * the new created block.
@@ -1898,7 +1971,21 @@ int ext4_try_to_evict_inline_data(handle_t *handle,
 		goto out;
 	}
 
-	error = ext4_convert_inline_data_nolock(handle, inode, &iloc);
+	if (S_ISREG(inode->i_mode)) {
+		struct page *page;
+
+		page = grab_cache_page_write_begin(inode->i_mapping, 0,
+						   AOP_FLAG_NOFS);
+		if (!page) {
+			error = -ENOMEM;
+			goto out;
+		}
+		error = reg_convert_inline_data_nolock(handle, inode,
+						       page, &iloc);
+		unlock_page(page);
+		put_page(page);
+	} else
+		error = ext4_convert_inline_data_nolock(handle, inode, &iloc);
 out:
 	brelse(iloc.bh);
 	return error;
@@ -2007,6 +2094,7 @@ int ext4_convert_inline_data(struct inode *inode)
 	int error, needed_blocks, no_expand;
 	handle_t *handle;
 	struct ext4_iloc iloc;
+	struct page *page = NULL;
 
 	if (!ext4_has_inline_data(inode)) {
 		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
@@ -2020,6 +2108,12 @@ int ext4_convert_inline_data(struct inode *inode)
 	if (error)
 		return error;
 
+	if (S_ISREG(inode->i_mode)) {
+		page = grab_cache_page_write_begin(inode->i_mapping, 0, 0);
+		if (!page)
+			return -ENOMEM;
+	}
+
 	handle = ext4_journal_start(inode, EXT4_HT_WRITE_PAGE, needed_blocks);
 	if (IS_ERR(handle)) {
 		error = PTR_ERR(handle);
@@ -2027,11 +2121,21 @@ int ext4_convert_inline_data(struct inode *inode)
 	}
 
 	ext4_write_lock_xattr(inode, &no_expand);
-	if (ext4_has_inline_data(inode))
-		error = ext4_convert_inline_data_nolock(handle, inode, &iloc);
+	if (ext4_has_inline_data(inode)) {
+		if (page)
+			error = reg_convert_inline_data_nolock(handle,
+							inode, page, &iloc);
+		else
+			error = ext4_convert_inline_data_nolock(handle, inode,
+								&iloc);
+	}
 	ext4_write_unlock_xattr(inode, &no_expand);
 	ext4_journal_stop(handle);
 out_free:
+	if (page) {
+		unlock_page(page);
+		put_page(page);
+	}
 	brelse(iloc.bh);
 	return error;
 }
-- 
2.11.0.rc0.7.gbe5a750
