From: Jan Kara <jack@suse.cz>
Subject: [RFC] JBD ordered mode rewrite
Date: Thu, 6 Mar 2008 18:42:09 +0100
Message-ID: <20080306174209.GA14193@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:51940 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757988AbYCFRmM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 6 Mar 2008 12:42:12 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

  Below is my rewrite of ordered mode in JBD. Now we don't have a list of
data buffers that need syncing on transaction commit but a list of inodes
that need writeout during commit. This brings all sorts of advantages such
as possibility to get rid of journal heads and buffer heads for data
buffers in ordered mode, better ordering of writes on transaction commit,
simplification of some JBD code, no more anonymous pages when truncate of
data being committed happens. The patch has survived some light testing
but it still has some potential of eating your data so beware :) I've run
dbench to see whether we didn't decrease performance by different handling
of truncate and the throughput I'm getting on my machine is the same (OK,
is lower by 0.5%) if I disable the code in truncate waiting for commit to
finish... Also the throughput of dbench is about 2% better with my patch
than with current JBD.
  Any comments or testing most welcome.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
---

Signed-off-by: Jan Kara <jack@suse.cz>

diff --git a/fs/buffer.c b/fs/buffer.c
index 897cd74..bd6aefd 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1675,7 +1675,8 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 			 */
 			clear_buffer_dirty(bh);
 			set_buffer_uptodate(bh);
-		} else if (!buffer_mapped(bh) && buffer_dirty(bh)) {
+		} else if (!buffer_mapped(bh) && buffer_dirty(bh)
+			   && !wbc->skip_unmapped) {
 			WARN_ON(bh->b_size != blocksize);
 			err = get_block(inode, block, bh, 1);
 			if (err)
diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index 4f4020c..8530e5d 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -588,6 +588,7 @@ got:
 	ei->i_extra_isize =
 		(EXT3_INODE_SIZE(inode->i_sb) > EXT3_GOOD_OLD_INODE_SIZE) ?
 		sizeof(struct ext3_inode) - EXT3_GOOD_OLD_INODE_SIZE : 0;
+	journal_init_jbd_inode(&ei->jinode, inode);
 
 	ret = inode;
 	if(DQUOT_ALLOC_INODE(inode)) {
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index eb95670..b3d933b 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -40,6 +40,7 @@
 #include "acl.h"
 
 static int ext3_writepage_trans_blocks(struct inode *inode);
+static int ext3_begin_ordered_truncate(struct inode *inode, loff_t new_size);
 
 /*
  * Test whether an inode is a fast symlink.
@@ -183,6 +184,8 @@ void ext3_delete_inode (struct inode * inode)
 {
 	handle_t *handle;
 
+	if (ext3_should_order_data(inode))
+		ext3_begin_ordered_truncate(inode, 0);
 	truncate_inode_pages(&inode->i_data, 0);
 
 	if (is_bad_inode(inode))
@@ -1185,14 +1188,9 @@ out:
 	return ret;
 }
 
-
-int ext3_journal_dirty_data(handle_t *handle, struct buffer_head *bh)
+static int ext3_file_inode(handle_t *handle, struct inode *inode)
 {
-	int err = journal_dirty_data(handle, bh);
-	if (err)
-		ext3_journal_abort_handle(__FUNCTION__, __FUNCTION__,
-						bh, handle, err);
-	return err;
+	return journal_file_inode(handle, &EXT3_I(inode)->jinode);
 }
 
 /* For write_end() in data=journal mode */
@@ -1247,8 +1245,8 @@ static int ext3_ordered_write_end(struct file *file,
 	from = pos & (PAGE_CACHE_SIZE - 1);
 	to = from + len;
 
-	ret = walk_page_buffers(handle, page_buffers(page),
-		from, to, NULL, ext3_journal_dirty_data);
+	if (ext3_should_order_data(inode))
+		ret = ext3_file_inode(handle, inode);
 
 	if (ret == 0) {
 		/*
@@ -1398,25 +1396,6 @@ static sector_t ext3_bmap(struct address_space *mapping, sector_t block)
 	return generic_block_bmap(mapping,block,ext3_get_block);
 }
 
-static int bget_one(handle_t *handle, struct buffer_head *bh)
-{
-	get_bh(bh);
-	return 0;
-}
-
-static int bput_one(handle_t *handle, struct buffer_head *bh)
-{
-	put_bh(bh);
-	return 0;
-}
-
-static int journal_dirty_data_fn(handle_t *handle, struct buffer_head *bh)
-{
-	if (buffer_mapped(bh))
-		return ext3_journal_dirty_data(handle, bh);
-	return 0;
-}
-
 /*
  * Note that we always start a transaction even if we're not journalling
  * data.  This is to preserve ordering: any hole instantiation within
@@ -1465,15 +1444,11 @@ static int journal_dirty_data_fn(handle_t *handle, struct buffer_head *bh)
  * We don't honour synchronous mounts for writepage().  That would be
  * disastrous.  Any write() or metadata operation will sync the fs for
  * us.
- *
- * AKPM2: if all the page's buffers are mapped to disk and !data=journal,
- * we don't need to open a transaction here.
  */
 static int ext3_ordered_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
 	struct inode *inode = page->mapping->host;
-	struct buffer_head *page_bufs;
 	handle_t *handle = NULL;
 	int ret = 0;
 	int err;
@@ -1487,46 +1462,49 @@ static int ext3_ordered_writepage(struct page *page,
 	if (ext3_journal_current_handle())
 		goto out_fail;
 
-	handle = ext3_journal_start(inode, ext3_writepage_trans_blocks(inode));
-
-	if (IS_ERR(handle)) {
-		ret = PTR_ERR(handle);
-		goto out_fail;
+	/*
+	 * Now there are two different reasons why we can be called:
+	 *   1) write out during commit
+	 *   2) fsync / writeout to free memory
+	 *
+	 * In the first case, we just need to write the buffer to disk, in the
+	 * second case we may need to do hole filling and attach the inode to
+	 * the transaction. Note that even in the first case, we may get an
+	 * unmapped buffer (hole fill with data via mmap) but we don't have to
+	 * write it - actually, we can't because from a transaction commit we
+	 * cannot start a new transaction or we could deadlock.
+	 */
+	if (!wbc->skip_unmapped) {
+		handle = ext3_journal_start(inode,
+				ext3_writepage_trans_blocks(inode));
+		if (IS_ERR(handle)) {
+			ret = PTR_ERR(handle);
+			goto out_fail;
+		}
 	}
+	else if (!PageMappedToDisk(page))
+		goto out_fail;
 
+	/* This can go as soon as someone cares about that ;) */
 	if (!page_has_buffers(page)) {
 		create_empty_buffers(page, inode->i_sb->s_blocksize,
 				(1 << BH_Dirty)|(1 << BH_Uptodate));
 	}
-	page_bufs = page_buffers(page);
-	walk_page_buffers(handle, page_bufs, 0,
-			PAGE_CACHE_SIZE, NULL, bget_one);
 
 	ret = block_write_full_page(page, ext3_get_block, wbc);
 
 	/*
-	 * The page can become unlocked at any point now, and
-	 * truncate can then come in and change things.  So we
-	 * can't touch *page from now on.  But *page_bufs is
-	 * safe due to elevated refcount.
-	 */
-
-	/*
-	 * And attach them to the current transaction.  But only if
-	 * block_write_full_page() succeeded.  Otherwise they are unmapped,
-	 * and generally junk.
+	 * The page can become unlocked at any point now, and truncate can then
+	 * come in and change things.
+	 * FIXME: Can we get up to delete? If so we should prevent that...
 	 */
-	if (ret == 0) {
-		err = walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE,
-					NULL, journal_dirty_data_fn);
+	if (ret == 0 && handle)
+		ret = ext3_file_inode(handle, inode);
+	if (handle) {
+		err = ext3_journal_stop(handle);
 		if (!ret)
 			ret = err;
 	}
-	walk_page_buffers(handle, page_bufs, 0,
-			PAGE_CACHE_SIZE, NULL, bput_one);
-	err = ext3_journal_stop(handle);
-	if (!ret)
-		ret = err;
 	return ret;
 
 out_fail:
@@ -1902,7 +1880,7 @@ static int ext3_block_truncate_page(handle_t *handle, struct page *page,
 		err = ext3_journal_dirty_metadata(handle, bh);
 	} else {
 		if (ext3_should_order_data(inode))
-			err = ext3_journal_dirty_data(handle, bh);
+			err = ext3_file_inode(handle, inode);
 		mark_buffer_dirty(bh);
 	}
 
@@ -2676,6 +2654,7 @@ struct inode *ext3_iget(struct super_block *sb, unsigned long ino)
 	ei->i_default_acl = EXT3_ACL_NOT_CACHED;
 #endif
 	ei->i_block_alloc_info = NULL;
+	journal_init_jbd_inode(&ei->jinode, inode);
 
 	ret = __ext3_get_inode_loc(inode, &iloc, 0);
 	if (ret < 0)
@@ -2974,6 +2953,11 @@ int ext3_write_inode(struct inode *inode, int wait)
 	return ext3_force_commit(inode->i_sb);
 }
 
+static int ext3_begin_ordered_truncate(struct inode *inode, loff_t new_size)
+{
+	return journal_begin_ordered_truncate(&EXT3_I(inode)->jinode, new_size);
+}
+
 /*
  * ext3_setattr()
  *
@@ -2989,7 +2973,14 @@ int ext3_write_inode(struct inode *inode, int wait)
  * be freed, so we have a strong guarantee that no future commit will
  * leave these blocks visible to the user.)
  *
- * Called with inode->sem down.
+ * Another thing we have to asure is that if we are in ordered mode
+ * and inode is still attached to the committing transaction, we must
+ * we start writeout of all the dirty buffers which are being truncated.
+ * This way we are sure that all the data written in the previous
+ * transaction are already on disk (truncate waits for pages under
+ * writeback).
+ *
+ * Called with inode->i_mutex down.
  */
 int ext3_setattr(struct dentry *dentry, struct iattr *attr)
 {
@@ -3032,6 +3023,13 @@ int ext3_setattr(struct dentry *dentry, struct iattr *attr)
 	    attr->ia_valid & ATTR_SIZE && attr->ia_size < inode->i_size) {
 		handle_t *handle;
 
+		if (ext3_should_order_data(inode)) {
+			error = ext3_begin_ordered_truncate(inode,
+					attr->ia_size);
+			if (error)
+				goto err_out;
+		}
+
 		handle = ext3_journal_start(inode, 3);
 		if (IS_ERR(handle)) {
 			error = PTR_ERR(handle);
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 18769cc..bd7eae6 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -520,6 +520,8 @@ static void ext3_clear_inode(struct inode *inode)
 	EXT3_I(inode)->i_block_alloc_info = NULL;
 	if (unlikely(rsv))
 		kfree(rsv);
+	journal_release_jbd_inode(EXT3_SB(inode->i_sb)->s_journal,
+		&EXT3_I(inode)->jinode);
 }
 
 static inline void ext3_show_quota_options(struct seq_file *seq, struct super_block *sb)
diff --git a/fs/jbd/checkpoint.c b/fs/jbd/checkpoint.c
index a5432bb..9ef048a 100644
--- a/fs/jbd/checkpoint.c
+++ b/fs/jbd/checkpoint.c
@@ -682,7 +682,6 @@ void __journal_drop_transaction(journal_t *journal, transaction_t *transaction)
 
 	J_ASSERT(transaction->t_state == T_FINISHED);
 	J_ASSERT(transaction->t_buffers == NULL);
-	J_ASSERT(transaction->t_sync_datalist == NULL);
 	J_ASSERT(transaction->t_forget == NULL);
 	J_ASSERT(transaction->t_iobuf_list == NULL);
 	J_ASSERT(transaction->t_shadow_list == NULL);
diff --git a/fs/jbd/commit.c b/fs/jbd/commit.c
index a38c718..0553df2 100644
--- a/fs/jbd/commit.c
+++ b/fs/jbd/commit.c
@@ -20,6 +20,8 @@
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/pagemap.h>
+#include <linux/writeback.h>
+#include <linux/backing-dev.h>
 
 /*
  * Default IO end handler for temporary BJ_IO buffer_heads.
@@ -35,8 +37,8 @@ static void journal_end_buffer_io_sync(struct buffer_head *bh, int uptodate)
 }
 
 /*
- * When an ext3-ordered file is truncated, it is possible that many pages are
- * not sucessfully freed, because they are attached to a committing transaction.
+ * When an ext3 file is truncated, it is possible that some pages are not
+ * sucessfully freed, because they are attached to a committing transaction.
  * After the transaction commits, these pages are left on the LRU, with no
  * ->mapping, and with attached buffers.  These pages are trivially reclaimable
  * by the VM, but their apparent absence upsets the VM accounting, and it makes
@@ -77,21 +79,6 @@ nope:
 	__brelse(bh);
 }
 
-/*
- * Try to acquire jbd_lock_bh_state() against the buffer, when j_list_lock is
- * held.  For ranking reasons we must trylock.  If we lose, schedule away and
- * return 0.  j_list_lock is dropped in this case.
- */
-static int inverted_lock(journal_t *journal, struct buffer_head *bh)
-{
-	if (!jbd_trylock_bh_state(bh)) {
-		spin_unlock(&journal->j_list_lock);
-		schedule();
-		return 0;
-	}
-	return 1;
-}
-
 /* Done it all: now write the commit record.  We should have
  * cleaned up our previous buffers by now, so if we are in abort
  * mode we can now just skip the rest of the journal write
@@ -158,119 +145,88 @@ static int journal_write_commit_record(journal_t *journal,
 	return (ret == -EIO);
 }
 
-static void journal_do_submit_data(struct buffer_head **wbuf, int bufs)
+/*
+ * Submit all the data buffers of inode associated with the
+ * transaction to disk.
+ */
+static int journal_submit_data_buffers(journal_t *journal,
+		transaction_t *commit_transaction)
 {
-	int i;
+	struct jbd_inode *jinode;
+	int err, ret = 0;
+	struct address_space *mapping;
+	struct writeback_control wbc = {
+		.range_start = 0,
+		.range_end = LLONG_MAX,
+		.sync_mode = WB_SYNC_NONE,
+		.skip_unmapped = 1,
+	};
 
-	for (i = 0; i < bufs; i++) {
-		wbuf[i]->b_end_io = end_buffer_write_sync;
-		/* We use-up our safety reference in submit_bh() */
-		submit_bh(WRITE, wbuf[i]);
+	/*
+	 * We are in a committing transaction. Therefore no new inode
+	 * can be added to our inode list. We use JI_COMMIT_RUNNING
+	 * flag to protect inode we currently operate on from being
+	 * released while we write out pages.
+	 */
+	spin_lock(&journal->j_list_lock);
+	list_for_each_entry(jinode, &commit_transaction->t_inode_list, i_list) {
+		mapping = jinode->i_vfs_inode->i_mapping;
+		if (!mapping_cap_writeback_dirty(mapping))
+			continue;
+		wbc.nr_to_write = mapping->nrpages * 2;
+		jinode->i_flags |= JI_COMMIT_RUNNING;
+		spin_unlock(&journal->j_list_lock);
+		err = do_writepages(jinode->i_vfs_inode->i_mapping, &wbc);
+		if (!ret)
+			ret = err;
+		spin_lock(&journal->j_list_lock);
+		jinode->i_flags &= ~JI_COMMIT_RUNNING;
+		wake_up_bit(&jinode->i_flags, __JI_COMMIT_RUNNING);
 	}
+	spin_unlock(&journal->j_list_lock);
+	return ret;
 }
 
 /*
- *  Submit all the data buffers to disk
+ * Wait for data submitted for writeout, refile inodes to proper
+ * transaction if needed.
+ *
  */
-static void journal_submit_data_buffers(journal_t *journal,
-				transaction_t *commit_transaction)
+static int journal_finish_data_buffers(journal_t *journal,
+		transaction_t *commit_transaction)
 {
-	struct journal_head *jh;
-	struct buffer_head *bh;
-	int locked;
-	int bufs = 0;
-	struct buffer_head **wbuf = journal->j_wbuf;
+	struct jbd_inode *jinode, *next_i;
+	int err, ret = 0;
 
-	/*
-	 * Whenever we unlock the journal and sleep, things can get added
-	 * onto ->t_sync_datalist, so we have to keep looping back to
-	 * write_out_data until we *know* that the list is empty.
-	 *
-	 * Cleanup any flushed data buffers from the data list.  Even in
-	 * abort mode, we want to flush this out as soon as possible.
-	 */
-write_out_data:
-	cond_resched();
+	/* For locking, see the comment in journal_submit_data_buffers() */
 	spin_lock(&journal->j_list_lock);
+	list_for_each_entry(jinode, &commit_transaction->t_inode_list, i_list) {
+		jinode->i_flags |= JI_COMMIT_RUNNING;
+		spin_unlock(&journal->j_list_lock);
+		err = filemap_fdatawait(jinode->i_vfs_inode->i_mapping);
+		if (!ret)
+			ret = err;
+		spin_lock(&journal->j_list_lock);
+		jinode->i_flags &= ~JI_COMMIT_RUNNING;
+		wake_up_bit(&jinode->i_flags, __JI_COMMIT_RUNNING);
+	}
 
-	while (commit_transaction->t_sync_datalist) {
-		jh = commit_transaction->t_sync_datalist;
-		bh = jh2bh(jh);
-		locked = 0;
-
-		/* Get reference just to make sure buffer does not disappear
-		 * when we are forced to drop various locks */
-		get_bh(bh);
-		/* If the buffer is dirty, we need to submit IO and hence
-		 * we need the buffer lock. We try to lock the buffer without
-		 * blocking. If we fail, we need to drop j_list_lock and do
-		 * blocking lock_buffer().
-		 */
-		if (buffer_dirty(bh)) {
-			if (test_set_buffer_locked(bh)) {
-				BUFFER_TRACE(bh, "needs blocking lock");
-				spin_unlock(&journal->j_list_lock);
-				/* Write out all data to prevent deadlocks */
-				journal_do_submit_data(wbuf, bufs);
-				bufs = 0;
-				lock_buffer(bh);
-				spin_lock(&journal->j_list_lock);
-			}
-			locked = 1;
-		}
-		/* We have to get bh_state lock. Again out of order, sigh. */
-		if (!inverted_lock(journal, bh)) {
-			jbd_lock_bh_state(bh);
-			spin_lock(&journal->j_list_lock);
-		}
-		/* Someone already cleaned up the buffer? */
-		if (!buffer_jbd(bh)
-			|| jh->b_transaction != commit_transaction
-			|| jh->b_jlist != BJ_SyncData) {
-			jbd_unlock_bh_state(bh);
-			if (locked)
-				unlock_buffer(bh);
-			BUFFER_TRACE(bh, "already cleaned up");
-			put_bh(bh);
-			continue;
-		}
-		if (locked && test_clear_buffer_dirty(bh)) {
-			BUFFER_TRACE(bh, "needs writeout, adding to array");
-			wbuf[bufs++] = bh;
-			__journal_file_buffer(jh, commit_transaction,
-						BJ_Locked);
-			jbd_unlock_bh_state(bh);
-			if (bufs == journal->j_wbufsize) {
-				spin_unlock(&journal->j_list_lock);
-				journal_do_submit_data(wbuf, bufs);
-				bufs = 0;
-				goto write_out_data;
-			}
-		} else if (!locked && buffer_locked(bh)) {
-			__journal_file_buffer(jh, commit_transaction,
-						BJ_Locked);
-			jbd_unlock_bh_state(bh);
-			put_bh(bh);
-		} else {
-			BUFFER_TRACE(bh, "writeout complete: unfile");
-			__journal_unfile_buffer(jh);
-			jbd_unlock_bh_state(bh);
-			if (locked)
-				unlock_buffer(bh);
-			journal_remove_journal_head(bh);
-			/* Once for our safety reference, once for
-			 * journal_remove_journal_head() */
-			put_bh(bh);
-			put_bh(bh);
-		}
-
-		if (need_resched() || spin_needbreak(&journal->j_list_lock)) {
-			spin_unlock(&journal->j_list_lock);
-			goto write_out_data;
+	/* Now refile inode to proper lists */
+	list_for_each_entry_safe(jinode, next_i,
+			&commit_transaction->t_inode_list, i_list) {
+		list_del(&jinode->i_list);
+		if (jinode->i_next_transaction) {
+			jinode->i_transaction = jinode->i_next_transaction;
+			jinode->i_next_transaction = NULL;
+			list_add(&jinode->i_list,
+				&jinode->i_transaction->t_inode_list);
 		}
+		else
+			jinode->i_transaction = NULL;
 	}
 	spin_unlock(&journal->j_list_lock);
-	journal_do_submit_data(wbuf, bufs);
+
+	return ret;
 }
 
 /*
@@ -426,44 +382,7 @@ void journal_commit_transaction(journal_t *journal)
 	 * Now start flushing things to disk, in the order they appear
 	 * on the transaction lists.  Data blocks go first.
 	 */
-	err = 0;
-	journal_submit_data_buffers(journal, commit_transaction);
-
-	/*
-	 * Wait for all previously submitted IO to complete.
-	 */
-	spin_lock(&journal->j_list_lock);
-	while (commit_transaction->t_locked_list) {
-		struct buffer_head *bh;
-
-		jh = commit_transaction->t_locked_list->b_tprev;
-		bh = jh2bh(jh);
-		get_bh(bh);
-		if (buffer_locked(bh)) {
-			spin_unlock(&journal->j_list_lock);
-			wait_on_buffer(bh);
-			if (unlikely(!buffer_uptodate(bh)))
-				err = -EIO;
-			spin_lock(&journal->j_list_lock);
-		}
-		if (!inverted_lock(journal, bh)) {
-			put_bh(bh);
-			spin_lock(&journal->j_list_lock);
-			continue;
-		}
-		if (buffer_jbd(bh) && jh->b_jlist == BJ_Locked) {
-			__journal_unfile_buffer(jh);
-			jbd_unlock_bh_state(bh);
-			journal_remove_journal_head(bh);
-			put_bh(bh);
-		} else {
-			jbd_unlock_bh_state(bh);
-		}
-		put_bh(bh);
-		cond_resched_lock(&journal->j_list_lock);
-	}
-	spin_unlock(&journal->j_list_lock);
-
+	err = journal_submit_data_buffers(journal, commit_transaction);
 	if (err)
 		journal_abort(journal, err);
 
@@ -472,22 +391,13 @@ void journal_commit_transaction(journal_t *journal)
 	jbd_debug(3, "JBD: commit phase 2\n");
 
 	/*
-	 * If we found any dirty or locked buffers, then we should have
-	 * looped back up to the write_out_data label.  If there weren't
-	 * any then journal_clean_data_list should have wiped the list
-	 * clean by now, so check that it is in fact empty.
-	 */
-	J_ASSERT (commit_transaction->t_sync_datalist == NULL);
-
-	jbd_debug (3, "JBD: commit phase 3\n");
-
-	/*
 	 * Way to go: we have now written out all of the data for a
 	 * transaction!  Now comes the tricky part: we need to write out
 	 * metadata.  Loop over the transaction's entire buffer list:
 	 */
 	commit_transaction->t_state = T_COMMIT;
 
+	err = 0;
 	descriptor = NULL;
 	bufs = 0;
 	while (commit_transaction->t_buffers) {
@@ -655,7 +565,14 @@ start_journal_io:
 	   so we incur less scheduling load.
 	*/
 
-	jbd_debug(3, "JBD: commit phase 4\n");
+	jbd_debug(3, "JBD: commit phase 3\n");
+
+	/*
+	 * First wait for data buffers.
+	 */
+	err = journal_finish_data_buffers(journal, commit_transaction);
+	if (err)
+		journal_abort(journal, err);
 
 	/*
 	 * akpm: these are BJ_IO, and j_list_lock is not needed.
@@ -714,7 +631,7 @@ wait_for_iobuf:
 
 	J_ASSERT (commit_transaction->t_shadow_list == NULL);
 
-	jbd_debug(3, "JBD: commit phase 5\n");
+	jbd_debug(3, "JBD: commit phase 4\n");
 
 	/* Here we wait for the revoke record and descriptor record buffers */
  wait_for_ctlbuf:
@@ -741,7 +658,7 @@ wait_for_iobuf:
 		/* AKPM: bforget here */
 	}
 
-	jbd_debug(3, "JBD: commit phase 6\n");
+	jbd_debug(3, "JBD: commit phase 5\n");
 
 	if (journal_write_commit_record(journal, commit_transaction))
 		err = -EIO;
@@ -754,9 +671,9 @@ wait_for_iobuf:
            transaction can be removed from any checkpoint list it was on
            before. */
 
-	jbd_debug(3, "JBD: commit phase 7\n");
+	jbd_debug(3, "JBD: commit phase 6\n");
 
-	J_ASSERT(commit_transaction->t_sync_datalist == NULL);
+	J_ASSERT(list_empty(&commit_transaction->t_inode_list));
 	J_ASSERT(commit_transaction->t_buffers == NULL);
 	J_ASSERT(commit_transaction->t_checkpoint_list == NULL);
 	J_ASSERT(commit_transaction->t_iobuf_list == NULL);
@@ -876,7 +793,7 @@ restart_loop:
 
 	/* Done with this transaction! */
 
-	jbd_debug(3, "JBD: commit phase 8\n");
+	jbd_debug(3, "JBD: commit phase 7\n");
 
 	J_ASSERT(commit_transaction->t_state == T_COMMIT);
 
diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 3943a89..6723f9e 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -1852,6 +1852,51 @@ void journal_put_journal_head(struct journal_head *jh)
 }
 
 /*
+ * Initialize jbd inode head
+ */
+void journal_init_jbd_inode(struct jbd_inode *jinode, struct inode *inode)
+{
+	jinode->i_transaction = NULL;
+	jinode->i_next_transaction = NULL;
+	jinode->i_vfs_inode = inode;
+	jinode->i_flags = 0;
+	INIT_LIST_HEAD(&jinode->i_list);
+}
+
+/*
+ * Function to be called before we start removing inode from memory (i.e.,
+ * clear_inode() is a fine place to be called from). It removes inode from
+ * transaction's lists.
+ */
+void journal_release_jbd_inode(journal_t *journal, struct jbd_inode *jinode)
+{
+	int writeout = 0;
+
+restart:
+	spin_lock(&journal->j_list_lock);
+	/* Is commit writing out inode - we have to wait */
+	if (jinode->i_flags & JI_COMMIT_RUNNING) {
+		wait_queue_head_t *wq;
+		DEFINE_WAIT_BIT(wait, &jinode->i_flags, __JI_COMMIT_RUNNING);
+		wq = bit_waitqueue(&jinode->i_flags, __JI_COMMIT_RUNNING);
+		prepare_to_wait(wq, &wait.wait, TASK_UNINTERRUPTIBLE);
+		spin_unlock(&journal->j_list_lock);
+		schedule();
+		finish_wait(wq, &wait.wait);
+		goto restart;
+	}
+
+	/* Do we need to wait for data writeback? */
+	if (journal->j_committing_transaction == jinode->i_transaction)
+		writeout = 1;
+	if (jinode->i_transaction) {
+		list_del(&jinode->i_list);
+		jinode->i_transaction = NULL;
+	}
+	spin_unlock(&journal->j_list_lock);
+}
+
+/*
  * debugfs tunables
  */
 #ifdef CONFIG_JBD_DEBUG
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index c6cbb6c..930d5af 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -25,6 +25,7 @@
 #include <linux/timer.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
+#include <linux/writeback.h> /* For WB_SYNC_ALL :( */
 
 static void __journal_temp_unlink_buffer(struct journal_head *jh);
 
@@ -52,6 +53,7 @@ get_transaction(journal_t *journal, transaction_t *transaction)
 	transaction->t_tid = journal->j_transaction_sequence++;
 	transaction->t_expires = jiffies + journal->j_commit_interval;
 	spin_lock_init(&transaction->t_handle_lock);
+	INIT_LIST_HEAD(&transaction->t_inode_list);
 
 	/* Set up the commit timer for the new transaction. */
 	journal->j_commit_timer.expires = round_jiffies(transaction->t_expires);
@@ -920,185 +922,6 @@ out:
 }
 
 /**
- * int journal_dirty_data() - mark a buffer as containing dirty data to be flushed
- * @handle: transaction
- * @bh: bufferhead to mark
- *
- * Description:
- * Mark a buffer as containing dirty data which needs to be flushed before
- * we can commit the current transaction.
- *
- * The buffer is placed on the transaction's data list and is marked as
- * belonging to the transaction.
- *
- * Returns error number or 0 on success.
- *
- * journal_dirty_data() can be called via page_launder->ext3_writepage
- * by kswapd.
- */
-int journal_dirty_data(handle_t *handle, struct buffer_head *bh)
-{
-	journal_t *journal = handle->h_transaction->t_journal;
-	int need_brelse = 0;
-	struct journal_head *jh;
-
-	if (is_handle_aborted(handle))
-		return 0;
-
-	jh = journal_add_journal_head(bh);
-	JBUFFER_TRACE(jh, "entry");
-
-	/*
-	 * The buffer could *already* be dirty.  Writeout can start
-	 * at any time.
-	 */
-	jbd_debug(4, "jh: %p, tid:%d\n", jh, handle->h_transaction->t_tid);
-
-	/*
-	 * What if the buffer is already part of a running transaction?
-	 *
-	 * There are two cases:
-	 * 1) It is part of the current running transaction.  Refile it,
-	 *    just in case we have allocated it as metadata, deallocated
-	 *    it, then reallocated it as data.
-	 * 2) It is part of the previous, still-committing transaction.
-	 *    If all we want to do is to guarantee that the buffer will be
-	 *    written to disk before this new transaction commits, then
-	 *    being sure that the *previous* transaction has this same
-	 *    property is sufficient for us!  Just leave it on its old
-	 *    transaction.
-	 *
-	 * In case (2), the buffer must not already exist as metadata
-	 * --- that would violate write ordering (a transaction is free
-	 * to write its data at any point, even before the previous
-	 * committing transaction has committed).  The caller must
-	 * never, ever allow this to happen: there's nothing we can do
-	 * about it in this layer.
-	 */
-	jbd_lock_bh_state(bh);
-	spin_lock(&journal->j_list_lock);
-
-	/* Now that we have bh_state locked, are we really still mapped? */
-	if (!buffer_mapped(bh)) {
-		JBUFFER_TRACE(jh, "unmapped buffer, bailing out");
-		goto no_journal;
-	}
-
-	if (jh->b_transaction) {
-		JBUFFER_TRACE(jh, "has transaction");
-		if (jh->b_transaction != handle->h_transaction) {
-			JBUFFER_TRACE(jh, "belongs to older transaction");
-			J_ASSERT_JH(jh, jh->b_transaction ==
-					journal->j_committing_transaction);
-
-			/* @@@ IS THIS TRUE  ? */
-			/*
-			 * Not any more.  Scenario: someone does a write()
-			 * in data=journal mode.  The buffer's transaction has
-			 * moved into commit.  Then someone does another
-			 * write() to the file.  We do the frozen data copyout
-			 * and set b_next_transaction to point to j_running_t.
-			 * And while we're in that state, someone does a
-			 * writepage() in an attempt to pageout the same area
-			 * of the file via a shared mapping.  At present that
-			 * calls journal_dirty_data(), and we get right here.
-			 * It may be too late to journal the data.  Simply
-			 * falling through to the next test will suffice: the
-			 * data will be dirty and wil be checkpointed.  The
-			 * ordering comments in the next comment block still
-			 * apply.
-			 */
-			//J_ASSERT_JH(jh, jh->b_next_transaction == NULL);
-
-			/*
-			 * If we're journalling data, and this buffer was
-			 * subject to a write(), it could be metadata, forget
-			 * or shadow against the committing transaction.  Now,
-			 * someone has dirtied the same darn page via a mapping
-			 * and it is being writepage()'d.
-			 * We *could* just steal the page from commit, with some
-			 * fancy locking there.  Instead, we just skip it -
-			 * don't tie the page's buffers to the new transaction
-			 * at all.
-			 * Implication: if we crash before the writepage() data
-			 * is written into the filesystem, recovery will replay
-			 * the write() data.
-			 */
-			if (jh->b_jlist != BJ_None &&
-					jh->b_jlist != BJ_SyncData &&
-					jh->b_jlist != BJ_Locked) {
-				JBUFFER_TRACE(jh, "Not stealing");
-				goto no_journal;
-			}
-
-			/*
-			 * This buffer may be undergoing writeout in commit.  We
-			 * can't return from here and let the caller dirty it
-			 * again because that can cause the write-out loop in
-			 * commit to never terminate.
-			 */
-			if (buffer_dirty(bh)) {
-				get_bh(bh);
-				spin_unlock(&journal->j_list_lock);
-				jbd_unlock_bh_state(bh);
-				need_brelse = 1;
-				sync_dirty_buffer(bh);
-				jbd_lock_bh_state(bh);
-				spin_lock(&journal->j_list_lock);
-				/* Since we dropped the lock... */
-				if (!buffer_mapped(bh)) {
-					JBUFFER_TRACE(jh, "buffer got unmapped");
-					goto no_journal;
-				}
-				/* The buffer may become locked again at any
-				   time if it is redirtied */
-			}
-
-			/* journal_clean_data_list() may have got there first */
-			if (jh->b_transaction != NULL) {
-				JBUFFER_TRACE(jh, "unfile from commit");
-				__journal_temp_unlink_buffer(jh);
-				/* It still points to the committing
-				 * transaction; move it to this one so
-				 * that the refile assert checks are
-				 * happy. */
-				jh->b_transaction = handle->h_transaction;
-			}
-			/* The buffer will be refiled below */
-
-		}
-		/*
-		 * Special case --- the buffer might actually have been
-		 * allocated and then immediately deallocated in the previous,
-		 * committing transaction, so might still be left on that
-		 * transaction's metadata lists.
-		 */
-		if (jh->b_jlist != BJ_SyncData && jh->b_jlist != BJ_Locked) {
-			JBUFFER_TRACE(jh, "not on correct data list: unfile");
-			J_ASSERT_JH(jh, jh->b_jlist != BJ_Shadow);
-			__journal_temp_unlink_buffer(jh);
-			jh->b_transaction = handle->h_transaction;
-			JBUFFER_TRACE(jh, "file as data");
-			__journal_file_buffer(jh, handle->h_transaction,
-						BJ_SyncData);
-		}
-	} else {
-		JBUFFER_TRACE(jh, "not on a transaction");
-		__journal_file_buffer(jh, handle->h_transaction, BJ_SyncData);
-	}
-no_journal:
-	spin_unlock(&journal->j_list_lock);
-	jbd_unlock_bh_state(bh);
-	if (need_brelse) {
-		BUFFER_TRACE(bh, "brelse");
-		__brelse(bh);
-	}
-	JBUFFER_TRACE(jh, "exit");
-	journal_put_journal_head(jh);
-	return 0;
-}
-
-/**
  * int journal_dirty_metadata() - mark a buffer as containing dirty metadata
  * @handle: transaction to add buffer to.
  * @bh: buffer to mark
@@ -1504,10 +1327,10 @@ __blist_del_buffer(struct journal_head **list, struct journal_head *jh)
  * Remove a buffer from the appropriate transaction list.
  *
  * Note that this function can *change* the value of
- * bh->b_transaction->t_sync_datalist, t_buffers, t_forget,
- * t_iobuf_list, t_shadow_list, t_log_list or t_reserved_list.  If the caller
- * is holding onto a copy of one of thee pointers, it could go bad.
- * Generally the caller needs to re-read the pointer from the transaction_t.
+ * bh->b_transaction->t_buffers, t_forget, t_iobuf_list, t_shadow_list,
+ * t_log_list or t_reserved_list.  If the caller is holding onto a copy of one
+ * of thee pointers, it could go bad.  Generally the caller needs to re-read
+ * the pointer from the transaction_t.
  *
  * Called under j_list_lock.  The journal may not be locked.
  */
@@ -1529,9 +1352,6 @@ static void __journal_temp_unlink_buffer(struct journal_head *jh)
 	switch (jh->b_jlist) {
 	case BJ_None:
 		return;
-	case BJ_SyncData:
-		list = &transaction->t_sync_datalist;
-		break;
 	case BJ_Metadata:
 		transaction->t_nr_buffers--;
 		J_ASSERT_JH(jh, transaction->t_nr_buffers >= 0);
@@ -1552,9 +1372,6 @@ static void __journal_temp_unlink_buffer(struct journal_head *jh)
 	case BJ_Reserved:
 		list = &transaction->t_reserved_list;
 		break;
-	case BJ_Locked:
-		list = &transaction->t_locked_list;
-		break;
 	}
 
 	__blist_del_buffer(list, jh);
@@ -1597,15 +1414,7 @@ __journal_try_to_free_buffer(journal_t *journal, struct buffer_head *bh)
 		goto out;
 
 	spin_lock(&journal->j_list_lock);
-	if (jh->b_transaction != NULL && jh->b_cp_transaction == NULL) {
-		if (jh->b_jlist == BJ_SyncData || jh->b_jlist == BJ_Locked) {
-			/* A written-back ordered data buffer */
-			JBUFFER_TRACE(jh, "release data");
-			__journal_unfile_buffer(jh);
-			journal_remove_journal_head(bh);
-			__brelse(bh);
-		}
-	} else if (jh->b_cp_transaction != NULL && jh->b_transaction == NULL) {
+	if (jh->b_cp_transaction != NULL && jh->b_transaction == NULL) {
 		/* written-back checkpointed metadata buffer */
 		if (jh->b_jlist == BJ_None) {
 			JBUFFER_TRACE(jh, "remove from checkpoint list");
@@ -1786,6 +1595,7 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh)
 	if (!buffer_jbd(bh))
 		goto zap_buffer_unlocked;
 
+	/* OK, we have data buffer in journaled mode */
 	spin_lock(&journal->j_state_lock);
 	jbd_lock_bh_state(bh);
 	spin_lock(&journal->j_list_lock);
@@ -1849,15 +1659,6 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh)
 		}
 	} else if (transaction == journal->j_committing_transaction) {
 		JBUFFER_TRACE(jh, "on committing transaction");
-		if (jh->b_jlist == BJ_Locked) {
-			/*
-			 * The buffer is on the committing transaction's locked
-			 * list.  We have the buffer locked, so I/O has
-			 * completed.  So we can nail the buffer now.
-			 */
-			may_free = __dispose_buffer(jh, transaction);
-			goto zap_buffer;
-		}
 		/*
 		 * If it is committing, we simply cannot touch it.  We
 		 * can remove it's next_transaction pointer from the
@@ -1990,9 +1791,6 @@ void __journal_file_buffer(struct journal_head *jh,
 		J_ASSERT_JH(jh, !jh->b_committed_data);
 		J_ASSERT_JH(jh, !jh->b_frozen_data);
 		return;
-	case BJ_SyncData:
-		list = &transaction->t_sync_datalist;
-		break;
 	case BJ_Metadata:
 		transaction->t_nr_buffers++;
 		list = &transaction->t_buffers;
@@ -2012,9 +1810,6 @@ void __journal_file_buffer(struct journal_head *jh,
 	case BJ_Reserved:
 		list = &transaction->t_reserved_list;
 		break;
-	case BJ_Locked:
-		list =  &transaction->t_locked_list;
-		break;
 	}
 
 	__blist_add_buffer(list, jh);
@@ -2104,3 +1899,70 @@ void journal_refile_buffer(journal_t *journal, struct journal_head *jh)
 	spin_unlock(&journal->j_list_lock);
 	__brelse(bh);
 }
+
+/*
+ * File inode in the inode list of the handle's transaction
+ */
+int journal_file_inode(handle_t *handle, struct jbd_inode *jinode)
+{
+	transaction_t *transaction = handle->h_transaction;
+	journal_t *journal = transaction->t_journal;
+
+	if (is_handle_aborted(handle))
+		return 0;
+
+	jbd_debug(4, "Adding inode %lu, tid:%d\n", jinode->i_vfs_inode->i_ino,
+			transaction->t_tid);
+
+	spin_lock(&journal->j_list_lock);
+
+	if (jinode->i_transaction == transaction ||
+	    jinode->i_next_transaction == transaction)
+		goto done;
+
+	/* On some different transaction's list - should be
+	 * the committing one */
+	if (jinode->i_transaction) {
+		J_ASSERT(jinode->i_next_transaction == NULL);
+		J_ASSERT(jinode->i_transaction ==
+					journal->j_committing_transaction);
+		jinode->i_next_transaction = transaction;
+		goto done;
+	}
+	/* Not on any transaction list... */
+	J_ASSERT(!jinode->i_next_transaction);
+	jinode->i_transaction = transaction;
+	list_add(&jinode->i_list, &transaction->t_inode_list);
+done:
+	spin_unlock(&journal->j_list_lock);
+
+	return 0;
+}
+
+/*
+ * This function must be called when inode is journaled in ordered mode
+ * before truncation happens. It starts writeout of truncated part in
+ * case it is in the committing transaction so that we stand to ordered
+ * mode consistency guarantees.
+ */
+int journal_begin_ordered_truncate(struct jbd_inode *inode, loff_t new_size)
+{
+	journal_t *journal;
+	transaction_t *commit_trans;
+	int ret = 0;
+
+	if (!inode->i_transaction && !inode->i_next_transaction)
+		goto out;
+	journal = inode->i_transaction->t_journal;
+	spin_lock(&journal->j_state_lock);
+	commit_trans = journal->j_committing_transaction;
+	spin_unlock(&journal->j_state_lock);
+	if (inode->i_transaction == commit_trans) {
+		ret = __filemap_fdatawrite_range(inode->i_vfs_inode->i_mapping,
+			new_size, LLONG_MAX, WB_SYNC_ALL);
+		if (ret)
+			journal_abort(journal, ret);
+	}
+out:
+	return ret;
+}
diff --git a/fs/mpage.c b/fs/mpage.c
index 235e4d3..4f66bae 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -527,7 +527,10 @@ static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
 
 		map_bh.b_state = 0;
 		map_bh.b_size = 1 << blkbits;
-		if (mpd->get_block(inode, block_in_file, &map_bh, 1))
+		if (mpd->get_block(inode, block_in_file, &map_bh,
+				   !wbc->skip_unmapped))
+			goto confused;
+		if (!buffer_mapped(&map_bh))
 			goto confused;
 		if (buffer_new(&map_bh))
 			unmap_underlying_metadata(map_bh.b_bdev,
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 36c5403..7aa8327 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -826,6 +826,7 @@ int ext3_get_blocks_handle(handle_t *handle, struct inode *inode,
 extern struct inode *ext3_iget(struct super_block *, unsigned long);
 extern int  ext3_write_inode (struct inode *, int);
 extern int  ext3_setattr (struct dentry *, struct iattr *);
+extern void ext3_drop_inode (struct inode *);
 extern void ext3_delete_inode (struct inode *);
 extern int  ext3_sync_inode (handle_t *, struct inode *);
 extern void ext3_discard_reservation (struct inode *);
diff --git a/include/linux/ext3_fs_i.h b/include/linux/ext3_fs_i.h
index 7894dd0..afd77b0 100644
--- a/include/linux/ext3_fs_i.h
+++ b/include/linux/ext3_fs_i.h
@@ -142,6 +142,7 @@ struct ext3_inode_info {
 	 */
 	struct mutex truncate_mutex;
 	struct inode vfs_inode;
+	struct jbd_inode jinode;
 };
 
 #endif	/* _LINUX_EXT3_FS_I */
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index b18fd3b..847328c 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -345,6 +345,38 @@ static inline void jbd_unlock_bh_journal_head(struct buffer_head *bh)
 	bit_spin_unlock(BH_JournalHead, &bh->b_state);
 }
 
+/* Flags in jbd_inode->i_flags */
+#define __JI_COMMIT_RUNNING 0
+/* Commit of the inode data in progress. We use this flag to protect us from
+ * concurrent deletion of inode. We cannot use reference to inode for this
+ * since we cannot afford doing last iput() on behalf of kjournald
+ */
+#define JI_COMMIT_RUNNING (1 << __JI_COMMIT_RUNNING)
+
+/**
+ * struct jbd_inode is the structure linking inodes in ordered mode
+ *   present in a transaction so that we can sync them during commit.
+ */
+struct jbd_inode {
+	/* Which transaction does this inode belong to? Either the running
+	 * transaction or the committing one. [j_list_lock] */
+	transaction_t *i_transaction;
+
+	/* Pointer to the running transaction modifying inode's data in case
+	 * there is already a committing transaction touching it. [j_list_lock] */
+	transaction_t *i_next_transaction;
+
+	/* List of inodes in the i_transaction [j_list_lock] */
+	struct list_head i_list;
+
+	/* VFS inode this inode belongs to [constant during the lifetime
+	 * of the structure] */
+	struct inode *i_vfs_inode;
+
+	/* Flags of inode [j_list_lock] */
+	unsigned int i_flags;
+};
+
 struct jbd_revoke_table_s;
 
 /**
@@ -466,24 +498,12 @@ struct transaction_s
 	struct journal_head	*t_reserved_list;
 
 	/*
-	 * Doubly-linked circular list of all buffers under writeout during
-	 * commit [j_list_lock]
-	 */
-	struct journal_head	*t_locked_list;
-
-	/*
 	 * Doubly-linked circular list of all metadata buffers owned by this
 	 * transaction [j_list_lock]
 	 */
 	struct journal_head	*t_buffers;
 
 	/*
-	 * Doubly-linked circular list of all data buffers still to be
-	 * flushed before this transaction can be committed [j_list_lock]
-	 */
-	struct journal_head	*t_sync_datalist;
-
-	/*
 	 * Doubly-linked circular list of all forget buffers (superseded
 	 * buffers which we can un-checkpoint once this transaction commits)
 	 * [j_list_lock]
@@ -522,6 +542,12 @@ struct transaction_s
 	struct journal_head	*t_log_list;
 
 	/*
+	 * List of inodes whose data we've modified in data=ordered mode.
+	 * [j_list_lock]
+	 */
+	struct list_head	t_inode_list;
+
+	/*
 	 * Protects info related to handles
 	 */
 	spinlock_t		t_handle_lock;
@@ -928,6 +954,10 @@ extern void	   journal_ack_err    (journal_t *);
 extern int	   journal_clear_err  (journal_t *);
 extern int	   journal_bmap(journal_t *, unsigned long, unsigned long *);
 extern int	   journal_force_commit(journal_t *);
+int journal_file_inode(handle_t *handle, struct jbd_inode *inode);
+int journal_begin_ordered_truncate(struct jbd_inode *inode, loff_t new_size);
+void journal_init_jbd_inode(struct jbd_inode *jinode, struct inode *inode);
+void journal_release_jbd_inode(journal_t *journal, struct jbd_inode *jinode);
 
 /*
  * journal_head management
@@ -1063,15 +1093,13 @@ static inline int jbd_space_needed(journal_t *journal)
 
 /* journaling buffer types */
 #define BJ_None		0	/* Not journaled */
-#define BJ_SyncData	1	/* Normal data: flush before commit */
-#define BJ_Metadata	2	/* Normal journaled metadata */
-#define BJ_Forget	3	/* Buffer superseded by this transaction */
-#define BJ_IO		4	/* Buffer is for temporary IO use */
-#define BJ_Shadow	5	/* Buffer contents being shadowed to the log */
-#define BJ_LogCtl	6	/* Buffer contains log descriptors */
-#define BJ_Reserved	7	/* Buffer is reserved for access by journal */
-#define BJ_Locked	8	/* Locked for I/O during commit */
-#define BJ_Types	9
+#define BJ_Metadata	1	/* Normal journaled metadata */
+#define BJ_Forget	2	/* Buffer superseded by this transaction */
+#define BJ_IO		3	/* Buffer is for temporary IO use */
+#define BJ_Shadow	4	/* Buffer contents being shadowed to the log */
+#define BJ_LogCtl	5	/* Buffer contains log descriptors */
+#define BJ_Reserved	6	/* Buffer is reserved for access by journal */
+#define BJ_Types	7
 
 extern int jbd_blocks_per_page(struct inode *inode);
 
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index b7b3362..2725e8b 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -63,6 +63,7 @@ struct writeback_control {
 	unsigned for_writepages:1;	/* This is a writepages() call */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned more_io:1;		/* more io to be dispatched */
+	unsigned skip_unmapped:1;	/* A kjournald commit */
 };
 
 /*
