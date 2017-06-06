From: Theodore Ts'o <tytso@mit.edu>
Subject: [RFC PATCH 2/2] ext4: fix up ext4_try_to_write_inline_data()
Date: Mon,  5 Jun 2017 20:03:59 -0400
Message-ID: <20170606000359.16794-2-tytso@mit.edu>
References: <20170606000359.16794-1-tytso@mit.edu>
Cc: gnehzuil.liu@gmail.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:46910 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751209AbdFFAEI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 5 Jun 2017 20:04:08 -0400
In-Reply-To: <20170606000359.16794-1-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

There were a number of bugs in ext4_try_to_write_inline_data() and the
ext4_convert_inline_data_to_extent() function (which was only used by
ext4_try_to_write_inline_data).

For ext4_convert_inline_data_to_extent():

* It didn't handle the dioread_nolock case correctly
  * It didn't convert the extent tree entry from unwritten to written.
  * It didn't correctly handle racing DIO reads
* It didn't handle data=journal case correctly -- it doesn't follow
  the block modification correctly by failing to call
  ext4_handle_dirty_metadata() on the data block.

We fix this by eliminating ext4_convert_inline_data_to_extent()
completely, and use reg_convert_inline_data_nolock() since it has been
fixed to be Completely Correct (tm).  :-)

In ext4_try_to_write_inline_data() we need to request write access for
the inode table block before returning a return code of 1, since since
in that case ext4_write_begin() immediately returns and the jbd2 layer
needs to e informed that we might be modifying the inode.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 fs/ext4/inline.c | 183 +++++++++++++++----------------------------------------
 1 file changed, 49 insertions(+), 134 deletions(-)

diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index c9e3a262f27f..a2773da52de2 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -24,6 +24,11 @@
 #define EXT4_INLINE_DOTDOT_OFFSET	2
 #define EXT4_INLINE_DOTDOT_SIZE		4
 
+static int reg_convert_inline_data_nolock(handle_t *handle,
+					  struct inode *inode,
+					  struct page *page,
+					  struct ext4_iloc *iloc);
+
 static int ext4_get_inline_size(struct inode *inode)
 {
 	if (EXT4_I(inode)->i_inline_off)
@@ -531,120 +536,6 @@ int ext4_readpage_inline(struct inode *inode, struct page *page)
 	return ret >= 0 ? 0 : ret;
 }
 
-static int ext4_convert_inline_data_to_extent(struct address_space *mapping,
-					      struct inode *inode,
-					      unsigned flags)
-{
-	int ret, needed_blocks, no_expand;
-	handle_t *handle = NULL;
-	int retries = 0, sem_held = 0;
-	struct page *page = NULL;
-	unsigned from, to;
-	struct ext4_iloc iloc;
-
-	if (!ext4_has_inline_data(inode)) {
-		/*
-		 * clear the flag so that no new write
-		 * will trap here again.
-		 */
-		ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
-		return 0;
-	}
-
-	needed_blocks = ext4_writepage_trans_blocks(inode);
-
-	ret = ext4_get_inode_loc(inode, &iloc);
-	if (ret)
-		return ret;
-
-retry:
-	handle = ext4_journal_start(inode, EXT4_HT_WRITE_PAGE, needed_blocks);
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		handle = NULL;
-		goto out;
-	}
-
-	/* We cannot recurse into the filesystem as the transaction is already
-	 * started */
-	flags |= AOP_FLAG_NOFS;
-
-	page = grab_cache_page_write_begin(mapping, 0, flags);
-	if (!page) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	ext4_write_lock_xattr(inode, &no_expand);
-	sem_held = 1;
-	/* If some one has already done this for us, just exit. */
-	if (!ext4_has_inline_data(inode)) {
-		ret = 0;
-		goto out;
-	}
-
-	from = 0;
-	to = ext4_get_inline_size(inode);
-	if (!PageUptodate(page)) {
-		ret = ext4_read_inline_page(inode, page);
-		if (ret < 0)
-			goto out;
-	}
-
-	ret = ext4_destroy_inline_data_nolock(handle, inode);
-	if (ret)
-		goto out;
-
-	if (ext4_should_dioread_nolock(inode)) {
-		ret = __block_write_begin(page, from, to,
-					  ext4_get_block_unwritten);
-	} else
-		ret = __block_write_begin(page, from, to, ext4_get_block);
-
-	if (!ret && ext4_should_journal_data(inode)) {
-		ret = ext4_walk_page_buffers(handle, page_buffers(page),
-					     from, to, NULL,
-					     do_journal_get_write_access);
-	}
-
-	if (ret) {
-		unlock_page(page);
-		put_page(page);
-		page = NULL;
-		ext4_orphan_add(handle, inode);
-		ext4_write_unlock_xattr(inode, &no_expand);
-		sem_held = 0;
-		ext4_journal_stop(handle);
-		handle = NULL;
-		ext4_truncate_failed_write(inode);
-		/*
-		 * If truncate failed early the inode might
-		 * still be on the orphan list; we need to
-		 * make sure the inode is removed from the
-		 * orphan list in that case.
-		 */
-		if (inode->i_nlink)
-			ext4_orphan_del(NULL, inode);
-	}
-
-	if (ret == -ENOSPC && ext4_should_retry_alloc(inode->i_sb, &retries))
-		goto retry;
-
-	if (page)
-		block_commit_write(page, from, to);
-out:
-	if (page) {
-		unlock_page(page);
-		put_page(page);
-	}
-	if (sem_held)
-		ext4_write_unlock_xattr(inode, &no_expand);
-	if (handle)
-		ext4_journal_stop(handle);
-	brelse(iloc.bh);
-	return ret;
-}
-
 /*
  * Try to write data in the inode.
  * If the inode has inline data, check whether the new write can be
@@ -662,13 +553,19 @@ int ext4_try_to_write_inline_data(struct address_space *mapping,
 	struct page *page;
 	struct ext4_iloc iloc;
 
-	if (pos + len > ext4_get_max_inline_size(inode))
-		goto convert;
-
 	ret = ext4_get_inode_loc(inode, &iloc);
 	if (ret)
 		return ret;
 
+	page = grab_cache_page_write_begin(mapping, 0, flags);
+	if (!page) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (pos + len > ext4_get_max_inline_size(inode))
+		goto convert;
+
 	/*
 	 * The possible write could happen in the inode,
 	 * so try to reserve the space in inode first.
@@ -686,25 +583,38 @@ int ext4_try_to_write_inline_data(struct address_space *mapping,
 
 	/* We don't have space in inline inode, so convert it to extent. */
 	if (ret == -ENOSPC) {
-		ext4_journal_stop(handle);
-		brelse(iloc.bh);
-		goto convert;
-	}
+		int no_expand;
 
-	flags |= AOP_FLAG_NOFS;
+		ext4_journal_stop(handle);
+		handle = NULL;
+	convert:
+		if (!ext4_has_inline_data(inode)) {
+			/*
+			 * clear the flag so that no new write
+			 * will trap here again.
+			 */
+			ext4_clear_inode_state(inode,
+					       EXT4_STATE_MAY_INLINE_DATA);
+			ret = 0;
+			goto out;
+		}
+		handle = ext4_journal_start(inode, EXT4_HT_WRITE_PAGE,
+					    ext4_writepage_trans_blocks(inode));
+		if (IS_ERR(handle)) {
+			ret = PTR_ERR(handle);
+			goto out;
+		}
 
-	page = grab_cache_page_write_begin(mapping, 0, flags);
-	if (!page) {
-		ret = -ENOMEM;
+		ext4_write_lock_xattr(inode, &no_expand);
+		ret = reg_convert_inline_data_nolock(handle, inode,
+						     page, &iloc);
+		ext4_write_unlock_xattr(inode, &no_expand);
 		goto out;
 	}
 
-	*pagep = page;
 	down_read(&EXT4_I(inode)->xattr_sem);
 	if (!ext4_has_inline_data(inode)) {
 		ret = 0;
-		unlock_page(page);
-		put_page(page);
 		goto out_up_read;
 	}
 
@@ -713,19 +623,24 @@ int ext4_try_to_write_inline_data(struct address_space *mapping,
 		if (ret < 0)
 			goto out_up_read;
 	}
-
-	ret = 1;
-	handle = NULL;
+	*pagep = page;
+	page = NULL;
+	ret = ext4_journal_get_write_access(handle, iloc.bh);
+	if (ret == 0) {
+		ret = 1;
+		handle = NULL;
+	}
 out_up_read:
 	up_read(&EXT4_I(inode)->xattr_sem);
 out:
 	if (handle)
 		ext4_journal_stop(handle);
+	if (page) {
+		unlock_page(page);
+		put_page(page);
+	}
 	brelse(iloc.bh);
 	return ret;
-convert:
-	return ext4_convert_inline_data_to_extent(mapping,
-						  inode, flags);
 }
 
 int ext4_write_inline_data_end(struct inode *inode, loff_t pos, unsigned len,
-- 
2.11.0.rc0.7.gbe5a750
