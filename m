From: Chris Mason <chris.mason@oracle.com>
Subject: [RFC] ext3 data=guarded was Re: [GIT PULL] Ext3 latency fixes
Date: Mon, 13 Apr 2009 22:29:02 -0400
Message-ID: <1239676142.22460.5.camel@think.oraclecorp.com>
References: <E1LrhNF-0002zd-BG@closure.thunk.org>
	 <alpine.LFD.2.00.0904090836060.4583@localhost.localdomain>
	 <1239294219.31257.10.camel@think.oraclecorp.com>
	 <20090409174932.GD26552@atrey.karlin.mff.cuni.cz>
	 <1239300603.31257.26.camel@think.oraclecorp.com>
	 <20090409190400.GA3886@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet11.oracle.com ([148.87.113.123]:55706 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721AbZDNCaD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 13 Apr 2009 22:30:03 -0400
In-Reply-To: <20090409190400.GA3886@duck.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello everyone,

Here's my current half tested code to use delayed i_size updates to
prevent garbage in ext3 after a crash.

This is still certain to be broken, I'm sending it only for comments.
I'll do benchmarking, cleanup and real testing in the morning.

In this patch, writing to holes with writepage or file-write go through
the old data=ordered, and the orphan inode list is used to make sure
that if we crash files are truncated back to the safe i_size we've
preserved.

-chris

diff --git a/fs/ext3/Makefile b/fs/ext3/Makefile
index e77766a..f3a9dc1 100644
--- a/fs/ext3/Makefile
+++ b/fs/ext3/Makefile
@@ -5,7 +5,8 @@
 obj-$(CONFIG_EXT3_FS) += ext3.o
 
 ext3-y	:= balloc.o bitmap.o dir.o file.o fsync.o ialloc.o inode.o \
-	   ioctl.o namei.o super.o symlink.o hash.o resize.o ext3_jbd.o
+	   ioctl.o namei.o super.o symlink.o hash.o resize.o ext3_jbd.o \
+	   ordered-data.o
 
 ext3-$(CONFIG_EXT3_FS_XATTR)	 += xattr.o xattr_user.o xattr_trusted.o
 ext3-$(CONFIG_EXT3_FS_POSIX_ACL) += acl.o
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index fcfa243..746a9c4 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -38,6 +38,7 @@
 #include <linux/bio.h>
 #include <linux/fiemap.h>
 #include <linux/namei.h>
+#include <linux/workqueue.h>
 #include "xattr.h"
 #include "acl.h"
 
@@ -204,6 +205,13 @@ void ext3_delete_inode (struct inode * inode)
 	if (IS_SYNC(inode))
 		handle->h_sync = 1;
 	inode->i_size = 0;
+
+	/*
+	 * make sure we clean up any ordered extents that didn't get
+	 * IO started on them because i_size shrunk down to zero.
+	 */
+	ext3_truncate_ordered_extents(inode, 0);
+
 	if (inode->i_blocks)
 		ext3_truncate(inode);
 	/*
@@ -767,6 +775,24 @@ err_out:
 }
 
 /*
+ * This protects the disk i_size with the  spinlock for the ordered
+ * extent tree.  It returns 1 when the inode needs to be logged
+ * because the i_disksize has been updated.
+ */
+static int maybe_update_disk_isize(struct inode *inode, loff_t new_size)
+{
+	int ret = 0;
+
+	ext3_ordered_lock(inode);
+	if (EXT3_I(inode)->i_disksize < new_size) {
+		EXT3_I(inode)->i_disksize = new_size;
+		ret = 1;
+	}
+	ext3_ordered_unlock(inode);
+	return ret;
+}
+
+/*
  * Allocation strategy is simple: if we have to allocate something, we will
  * have to go the whole way to leaf. So let's do it before attaching anything
  * to tree, set linkage between the newborn blocks, write them if sync is
@@ -815,6 +841,7 @@ int ext3_get_blocks_handle(handle_t *handle, struct inode *inode,
 	if (!partial) {
 		first_block = le32_to_cpu(chain[depth - 1].key);
 		clear_buffer_new(bh_result);
+		clear_buffer_datanew(bh_result);
 		count++;
 		/*map more blocks*/
 		while (count < maxblocks && count <= blocks_to_boundary) {
@@ -873,6 +900,7 @@ int ext3_get_blocks_handle(handle_t *handle, struct inode *inode,
 			if (err)
 				goto cleanup;
 			clear_buffer_new(bh_result);
+			clear_buffer_datanew(bh_result);
 			goto got_it;
 		}
 	}
@@ -915,14 +943,19 @@ int ext3_get_blocks_handle(handle_t *handle, struct inode *inode,
 	 * i_disksize growing is protected by truncate_mutex.  Don't forget to
 	 * protect it if you're about to implement concurrent
 	 * ext3_get_block() -bzzz
+	 *
+	 * FIXME, I think this only needs to extend the disk i_size when
+	 * we're filling holes that came from using ftruncate to increase
+	 * i_size.  Need to verify.
 	*/
-	if (!err && extend_disksize && inode->i_size > ei->i_disksize)
-		ei->i_disksize = inode->i_size;
+	if (!ext3_should_guard_data(inode) && !err && extend_disksize)
+		maybe_update_disk_isize(inode, inode->i_size);
 	mutex_unlock(&ei->truncate_mutex);
 	if (err)
 		goto cleanup;
 
 	set_buffer_new(bh_result);
+	set_buffer_datanew(bh_result);
 got_it:
 	map_bh(bh_result, inode->i_sb, le32_to_cpu(chain[depth-1].key));
 	if (count > blocks_to_boundary)
@@ -1079,6 +1112,126 @@ struct buffer_head *ext3_bread(handle_t *handle, struct inode *inode,
 	return NULL;
 }
 
+/*
+ * after a data=guarded IO is done, we need to update the
+ * disk i_size to reflect the data we've written.  If there are
+ * no more ordered data extents left in the tree, we need to
+ * get rid of the orphan entry making sure the file's
+ * block pointers match the i_size after a crash
+ */
+static void log_inode_ordered_end(struct inode *inode)
+{
+	handle_t *handle;
+	int orphan_cleanup;
+
+	handle = ext3_journal_start(inode, 3);
+
+	/*
+	 * uhoh, should we flag the FS as readonly here? ext3_dirty_inode
+	 * doesn't, which is what we're modeling ourselves after
+	 */
+	if (IS_ERR(handle))
+		return;
+
+	/*
+	 * we don't add orphan while cleaning up orphans, it kills
+	 * orphans
+	 */
+	orphan_cleanup = EXT3_SB(inode->i_sb)->s_mount_state & EXT3_ORPHAN_FS;
+	ext3_ordered_lock(inode);
+	if (!orphan_cleanup && inode->i_nlink &&
+	    RB_EMPTY_ROOT(&EXT3_I(inode)->ordered_tree.tree)) {
+		/* this also ends up  writing our new disk i_size */
+		ext3_ordered_unlock(inode);
+		ext3_orphan_del(handle, inode);
+
+		/*
+		 * now we check again to see if we might have dropped
+		 * the orphan just after someone added a new ordered extent
+		 */
+		ext3_ordered_lock(inode);
+		if (!RB_EMPTY_ROOT(&EXT3_I(inode)->ordered_tree.tree) &&
+		    list_empty(&EXT3_I(inode)->i_orphan)) {
+			ext3_ordered_unlock(inode);
+			ext3_orphan_add(handle, inode);
+		} else {
+			ext3_ordered_unlock(inode);
+		}
+	} else {
+		ext3_ordered_unlock(inode);
+		ext3_mark_inode_dirty(handle, inode);
+	}
+	ext3_journal_stop(handle);
+}
+
+/*
+ * data=guarded updates are handled in a workqueue after the IO
+ * is done.  This runs through the list of buffer heads that are pending
+ * processing.
+ */
+void ext3_run_guarded_work(struct work_struct *work)
+{
+	struct ext3_sb_info *sbi =
+		container_of(work, struct ext3_sb_info, guarded_work);
+	struct buffer_head *bh;
+	struct ext3_ordered_extent *ordered;
+	struct inode *inode;
+	struct page *page;
+	int must_log;
+
+	spin_lock_irq(&sbi->guarded_lock);
+	while(!list_empty(&sbi->guarded_buffers)) {
+		ordered = list_entry(sbi->guarded_buffers.next,
+				     struct ext3_ordered_extent, list);
+		bh = ordered->bh;
+		must_log = 0;
+
+		WARN_ON(!buffer_dataguarded(bh));
+
+		/* we don't need a reference on the buffer head because
+		 * it is locked until the end_io handler his called.
+		 *
+		 * This means the page can't go away, which means the
+		 * inode can't go away
+		 */
+		list_del(&ordered->list);
+		spin_unlock_irq(&sbi->guarded_lock);
+
+		page = bh->b_page;
+		inode = page->mapping->host;
+
+		ext3_ordered_lock(inode);
+		if (ordered->bh) {
+			/*
+			 * someone might have decided this buffer didn't
+			 * really need to be ordered and removed us from
+			 * the rb tree.  They set ordered->bh to null
+			 * when that happens.
+			 */
+			must_log = ext3_ordered_update_i_size(inode, ordered);
+			ext3_remove_ordered_extent(inode, ordered);
+		}
+		ext3_ordered_unlock(inode);
+
+		/*
+		 * drop the reference taken when this ordered extent was
+		 * put onto the guarded_buffers list
+		 */
+		ext3_put_ordered_extent(ordered);
+
+		if (must_log > 0)
+			log_inode_ordered_end(inode);
+
+		/*
+		 * finally, call the real bh end_io function to do
+		 * all the hard work of maintaining page writeback.
+		 */
+		end_buffer_async_write(bh, buffer_uptodate(bh));
+		spin_lock_irq(&sbi->guarded_lock);
+	}
+	spin_unlock_irq(&sbi->guarded_lock);
+}
+
 static int walk_page_buffers(	handle_t *handle,
 				struct buffer_head *head,
 				unsigned from,
@@ -1144,6 +1297,41 @@ static int do_journal_get_write_access(handle_t *handle,
 	return ext3_journal_get_write_access(handle, bh);
 }
 
+/*
+ * this is used during write_begin to find all the buffers that
+ * must be protected by the data=guarded code
+ */
+static int walk_page_for_guard(handle_t *handle, struct buffer_head *bh)
+{
+	struct inode *inode = bh->b_page->mapping->host;
+	u64 offset = page_offset(bh->b_page) + bh_offset(bh);
+	int ret;
+
+	/*
+	 * we can trust buffer_new during write_begin,
+	 * and we only guard new buffers
+	 */
+	if (!buffer_mapped(bh) || buffer_freed(bh) || !buffer_new(bh) ||
+	    offset + bh->b_size <= EXT3_I(inode)->i_disksize)
+		return 0;
+
+	ret = ext3_add_ordered_extent(inode, offset, bh);
+
+	/* if we crash before the IO is done, i_size will be small
+	 * but these blocks will still be allocated to the file.
+	 *
+	 * So, add an orphan entry for the file, which will truncate it
+	 * down to the i_size it finds after the crash.
+	 *
+	 * The orphan is cleaned up when the IO is done
+	 */
+	if (ret == 0 && buffer_dataguarded(bh) &&
+	    list_empty(&EXT3_I(inode)->i_orphan) &&
+	    !(EXT3_SB(inode->i_sb)->s_mount_state & EXT3_ORPHAN_FS))
+			ret = ext3_orphan_add(handle, inode);
+	return ret;
+}
+
 static int ext3_write_begin(struct file *file, struct address_space *mapping,
 				loff_t pos, unsigned len, unsigned flags,
 				struct page **pagep, void **fsdata)
@@ -1185,6 +1373,16 @@ retry:
 		ret = walk_page_buffers(handle, page_buffers(page),
 				from, to, NULL, do_journal_get_write_access);
 	}
+
+	if (ext3_should_guard_data(inode)) {
+		/*
+		 * we must do this before the block_write_end because it can
+		 * decide to clear the buffer_new bit
+		 */
+		ret = walk_page_buffers(handle, page_buffers(page),
+			from, to, NULL, walk_page_for_guard);
+	}
+
 write_begin_failed:
 	if (ret) {
 		/*
@@ -1212,7 +1410,13 @@ out:
 
 int ext3_journal_dirty_data(handle_t *handle, struct buffer_head *bh)
 {
-	int err = journal_dirty_data(handle, bh);
+	int err;
+
+	/* don't take buffers from the data=guarded list */
+	if (buffer_dataguarded(bh))
+		return 0;
+
+	err = journal_dirty_data(handle, bh);
 	if (err)
 		ext3_journal_abort_handle(__func__, __func__,
 						bh, handle, err);
@@ -1231,6 +1435,32 @@ static int journal_dirty_data_fn(handle_t *handle, struct buffer_head *bh)
 	return 0;
 }
 
+/*
+ * This does old-style data=ordered fallback for data=guarded mode.
+ * We must do the old data=ordered mode when filling holes in the
+ * file, since i_size doesn't protect these at all.
+ *
+ * So, we look for new blocks inside i_disksize.  We use buffer_datanew
+ * because buffer_new is cleared in many many places in fs/buffer.c
+ */
+static int journal_dirty_data_guarded_fn(handle_t *handle,
+					 struct buffer_head *bh)
+{
+	u64 offset = page_offset(bh->b_page) + bh_offset(bh);
+	struct inode *inode = bh->b_page->mapping->host;
+
+	/*
+	 * Write could have mapped the buffer but it didn't copy the data in
+	 * yet. So avoid filing such buffer into a transaction.
+	 */
+	if (buffer_mapped(bh) && buffer_uptodate(bh) &&
+	    offset + bh->b_size < EXT3_I(inode)->i_disksize &&
+	    buffer_datanew(bh)) {
+		return ext3_journal_dirty_data(handle, bh);
+	}
+	return 0;
+}
+
 /* For write_end() in data=journal mode */
 static int write_end_fn(handle_t *handle, struct buffer_head *bh)
 {
@@ -1251,10 +1481,8 @@ static void update_file_sizes(struct inode *inode, loff_t pos, unsigned copied)
 	/* What matters to us is i_disksize. We don't write i_size anywhere */
 	if (pos + copied > inode->i_size)
 		i_size_write(inode, pos + copied);
-	if (pos + copied > EXT3_I(inode)->i_disksize) {
-		EXT3_I(inode)->i_disksize = pos + copied;
+	if (maybe_update_disk_isize(inode, pos + copied))
 		mark_inode_dirty(inode);
-	}
 }
 
 /*
@@ -1300,6 +1528,50 @@ static int ext3_ordered_write_end(struct file *file,
 	return ret ? ret : copied;
 }
 
+static int ext3_guarded_write_end(struct file *file,
+				struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned copied,
+				struct page *page, void *fsdata)
+{
+	handle_t *handle = ext3_journal_current_handle();
+	struct inode *inode = file->f_mapping->host;
+	unsigned from, to;
+	int ret = 0, ret2;
+
+	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
+
+	from = pos & (PAGE_CACHE_SIZE - 1);
+	to = from + copied;
+	ret = walk_page_buffers(handle, page_buffers(page),
+		from, to, NULL, journal_dirty_data_guarded_fn);
+
+	/*
+	 * we only update the in-memory i_size.  The disk i_size is done
+	 * by the end io handlers
+	 */
+	if (ret == 0 && pos + copied > inode->i_size)
+		i_size_write(inode, pos + copied);
+
+	from = pos & (PAGE_CACHE_SIZE - 1);
+	to = from + copied;
+
+	/*
+	 * There may be allocated blocks outside of i_size because
+	 * we failed to copy some data. Prepare for truncate.
+	 */
+	if (pos + len > inode->i_size)
+		ext3_orphan_add(handle, inode);
+	ret2 = ext3_journal_stop(handle);
+	if (!ret)
+		ret = ret2;
+	unlock_page(page);
+	page_cache_release(page);
+
+	if (pos + len > inode->i_size)
+		vmtruncate(inode, inode->i_size);
+	return ret ? ret : copied;
+}
+
 static int ext3_writeback_write_end(struct file *file,
 				struct address_space *mapping,
 				loff_t pos, unsigned len, unsigned copied,
@@ -1311,6 +1583,7 @@ static int ext3_writeback_write_end(struct file *file,
 
 	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
 	update_file_sizes(inode, pos, copied);
+
 	/*
 	 * There may be allocated blocks outside of i_size because
 	 * we failed to copy some data. Prepare for truncate.
@@ -1439,6 +1712,7 @@ static int bget_one(handle_t *handle, struct buffer_head *bh)
 
 static int bput_one(handle_t *handle, struct buffer_head *bh)
 {
+	clear_buffer_datanew(bh);
 	put_bh(bh);
 	return 0;
 }
@@ -1574,6 +1848,134 @@ out_fail:
 	return ret;
 }
 
+/*
+ * Completion handler for block_write_full_page().  This will
+ * kick off the data=guarded workqueue as the IO finishes.
+ */
+static void end_buffer_async_write_guarded(struct buffer_head *bh,
+					   int uptodate)
+{
+	struct ext3_sb_info *sbi;
+	struct address_space *mapping;
+	struct ext3_ordered_extent *ordered;
+	unsigned long flags;
+
+	mapping = bh->b_page->mapping;
+	if (!mapping || !bh->b_private || !buffer_dataguarded(bh)) {
+noguard:
+		end_buffer_async_write(bh, uptodate);
+		return;
+	}
+
+	/*
+	 * the guarded workqueue function checks the uptodate bit on the
+	 * bh and uses that to tell the real end_io handler if things worked
+	 * out or not.
+	 */
+	if (uptodate)
+		set_buffer_uptodate(bh);
+	else
+		clear_buffer_uptodate(bh);
+
+	sbi = EXT3_SB(mapping->host->i_sb);
+
+	spin_lock_irqsave(&sbi->guarded_lock, flags);
+
+	/*
+	 * remove any chance that a truncate traced in and cleared
+	 * our dataguard flag, which also freed the ordered extent in
+	 * our b_private.
+	 */
+	if (!buffer_dataguarded(bh)) {
+		spin_unlock_irqrestore(&sbi->guarded_lock, flags);
+		goto noguard;
+	}
+	ordered = bh->b_private;
+	list_add_tail(&ordered->list, &sbi->guarded_buffers);
+	ext3_get_ordered_extent(ordered);
+	spin_unlock_irqrestore(&sbi->guarded_lock, flags);
+
+	queue_work(sbi->guarded_wq, &sbi->guarded_work);
+}
+
+static int ext3_guarded_writepage(struct page *page,
+				struct writeback_control *wbc)
+{
+	struct inode *inode = page->mapping->host;
+	struct buffer_head *page_bufs;
+	handle_t *handle = NULL;
+	int ret = 0;
+	int err;
+
+	J_ASSERT(PageLocked(page));
+
+	/*
+	 * We give up here if we're reentered, because it might be for a
+	 * different filesystem.
+	 */
+	if (ext3_journal_current_handle())
+		goto out_fail;
+
+	if (!page_has_buffers(page)) {
+		create_empty_buffers(page, inode->i_sb->s_blocksize,
+				(1 << BH_Dirty)|(1 << BH_Uptodate));
+		page_bufs = page_buffers(page);
+	} else {
+		page_bufs = page_buffers(page);
+		if (!walk_page_buffers(NULL, page_bufs, 0, PAGE_CACHE_SIZE,
+				       NULL, buffer_unmapped)) {
+			/* Provide NULL get_block() to catch bugs if buffers
+			 * weren't really mapped */
+			 return block_write_full_page_endio(page, NULL, wbc,
+					  end_buffer_async_write_guarded);
+		}
+	}
+	handle = ext3_journal_start(inode, ext3_writepage_trans_blocks(inode));
+
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out_fail;
+	}
+
+	walk_page_buffers(handle, page_bufs, 0,
+			PAGE_CACHE_SIZE, NULL, bget_one);
+
+	ret = block_write_full_page_endio(page, ext3_get_block, wbc,
+					  end_buffer_async_write_guarded);
+
+	/*
+	 * The page can become unlocked at any point now, and
+	 * truncate can then come in and change things.  So we
+	 * can't touch *page from now on.  But *page_bufs is
+	 * safe due to elevated refcount.
+	 */
+
+	/*
+	 * And attach them to the current transaction.  But only if
+	 * block_write_full_page() succeeded.  Otherwise they are unmapped,
+	 * and generally junk.
+	 */
+	if (ret == 0) {
+		err = walk_page_buffers(handle, page_bufs, 0, PAGE_CACHE_SIZE,
+					NULL, journal_dirty_data_guarded_fn);
+		if (!ret)
+			ret = err;
+	}
+	walk_page_buffers(handle, page_bufs, 0,
+			PAGE_CACHE_SIZE, NULL, bput_one);
+	err = ext3_journal_stop(handle);
+	if (!ret)
+		ret = err;
+	return ret;
+
+out_fail:
+	redirty_page_for_writepage(wbc, page);
+	unlock_page(page);
+	return ret;
+}
+
+
+
 static int ext3_writeback_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
@@ -1842,6 +2244,21 @@ static const struct address_space_operations ext3_writeback_aops = {
 	.is_partially_uptodate  = block_is_partially_uptodate,
 };
 
+static const struct address_space_operations ext3_guarded_aops = {
+	.readpage		= ext3_readpage,
+	.readpages		= ext3_readpages,
+	.writepage		= ext3_guarded_writepage,
+	.sync_page		= block_sync_page,
+	.write_begin		= ext3_write_begin,
+	.write_end		= ext3_guarded_write_end,
+	.bmap			= ext3_bmap,
+	.invalidatepage		= ext3_invalidatepage,
+	.releasepage		= ext3_releasepage,
+	.direct_IO		= ext3_direct_IO,
+	.migratepage		= buffer_migrate_page,
+	.is_partially_uptodate  = block_is_partially_uptodate,
+};
+
 static const struct address_space_operations ext3_journalled_aops = {
 	.readpage		= ext3_readpage,
 	.readpages		= ext3_readpages,
@@ -1860,6 +2277,8 @@ void ext3_set_aops(struct inode *inode)
 {
 	if (ext3_should_order_data(inode))
 		inode->i_mapping->a_ops = &ext3_ordered_aops;
+	else if (ext3_should_guard_data(inode))
+		inode->i_mapping->a_ops = &ext3_guarded_aops;
 	else if (ext3_should_writeback_data(inode))
 		inode->i_mapping->a_ops = &ext3_writeback_aops;
 	else
@@ -2376,7 +2795,8 @@ void ext3_truncate(struct inode *inode)
 	if (!ext3_can_truncate(inode))
 		return;
 
-	if (inode->i_size == 0 && ext3_should_writeback_data(inode))
+	if (inode->i_size == 0 && (ext3_should_writeback_data(inode) ||
+				   ext3_should_guard_data(inode)))
 		ei->i_state |= EXT3_STATE_FLUSH_ON_CLOSE;
 
 	/*
@@ -3107,13 +3527,49 @@ int ext3_setattr(struct dentry *dentry, struct iattr *attr)
 	    attr->ia_valid & ATTR_SIZE && attr->ia_size < inode->i_size) {
 		handle_t *handle;
 
+		/*
+		 * we need to make sure any data=guarded pages
+		 * are on disk before we force a new disk i_size
+		 * down into the inode.  The crucial range is
+		 * anything between the disksize on disk now
+		 * and the new size we're going to set.
+		 *
+		 * We're holding i_mutex here, so we know new
+		 * ordered extents are not going to appear in the inode
+		 */
+		if (ext3_should_guard_data(inode) &&
+		    EXT3_I(inode)->i_disksize < attr->ia_size) {
+			filemap_write_and_wait_range(inode->i_mapping,
+						 EXT3_I(inode)->i_disksize,
+						 attr->ia_size);
+		}
 		handle = ext3_journal_start(inode, 3);
 		if (IS_ERR(handle)) {
 			error = PTR_ERR(handle);
 			goto err_out;
 		}
 
+		/*
+		 * chop off all the ordered extents after the new
+		 * i_size.  This prevents leaking of ordered extents
+		 * and it also makes sure we the ordered extent code
+		 * doesn't mess with the orphan link
+		 */
+		if (ext3_should_guard_data(inode))
+			ext3_truncate_ordered_extents(inode, attr->ia_size);
+
 		error = ext3_orphan_add(handle, inode);
+
+		/*
+		 * this is pretty confusing, but we don't need to worry
+		 * about guarded i_size here because ext3 truncate fixes
+		 * it to the correct i_size when the truncate is all done,
+		 * and the ext3_orphan_add makes sure we'll have a sane
+		 * i_size after a crash
+		 *
+		 * Hmmm, why do we set i_disksize here and then again
+		 * in ext3_truncate?
+		 */
 		EXT3_I(inode)->i_disksize = attr->ia_size;
 		rc = ext3_mark_inode_dirty(handle, inode);
 		if (!error)
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 6ff7b97..ac3991a 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -2410,7 +2410,8 @@ static int ext3_rename (struct inode * old_dir, struct dentry *old_dentry,
 		ext3_mark_inode_dirty(handle, new_inode);
 		if (!new_inode->i_nlink)
 			ext3_orphan_add(handle, new_inode);
-		if (ext3_should_writeback_data(new_inode))
+		if (ext3_should_writeback_data(new_inode) ||
+		    ext3_should_guard_data(new_inode))
 			flush_file = 1;
 	}
 	retval = 0;
diff --git a/fs/ext3/ordered-data.c b/fs/ext3/ordered-data.c
new file mode 100644
index 0000000..e9633cc
--- /dev/null
+++ b/fs/ext3/ordered-data.c
@@ -0,0 +1,304 @@
+/*
+ * Copyright (C) 2009 Oracle.  All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+#include <linux/gfp.h>
+#include <linux/slab.h>
+#include <linux/blkdev.h>
+#include <linux/writeback.h>
+#include <linux/pagevec.h>
+#include <linux/buffer_head.h>
+#include <linux/ext3_jbd.h>
+
+
+/*
+ * These routines actually implement data=guarded mode, but the
+ * idea is that it may replace data=ordered mode as it becomes stable.
+ */
+
+static u64 entry_end(struct ext3_ordered_extent *entry, unsigned blocksize)
+{
+	return entry->start + blocksize;
+}
+
+/*
+ * returns NULL if the insertion worked, or it returns the node it did find
+ * in the tree
+ */
+static struct rb_node *tree_insert(struct rb_root *root, u64 start,
+				   unsigned blocksize, struct rb_node *node)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct ext3_ordered_extent *entry;
+
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct ext3_ordered_extent, rb_node);
+
+		if (start < entry->start)
+			p = &(*p)->rb_left;
+		else if (start >= entry_end(entry, blocksize))
+			p = &(*p)->rb_right;
+		else
+			return parent;
+	}
+
+	rb_link_node(node, parent, p);
+	rb_insert_color(node, root);
+	return NULL;
+}
+
+/*
+ * find the ordered struct that has this offset
+ */
+static inline struct rb_node *tree_search(struct ext3_ordered_inode_tree *tree,
+					  u64 start, unsigned blocksize)
+{
+	struct rb_node *ret;
+	struct rb_node *n = tree->tree.rb_node;
+	struct ext3_ordered_extent *entry;
+
+	while (n) {
+		entry = rb_entry(n, struct ext3_ordered_extent, rb_node);
+
+		if (start < entry->start)
+			n = n->rb_left;
+		else if (start >= entry_end(entry, blocksize))
+			n = n->rb_right;
+		else
+			return n;
+	}
+	return NULL;
+	return ret;
+}
+
+/* allocate and add a new ordered_extent into the per-inode tree.
+ * start is the logical offset in the file
+ *
+ * The tree is given a single reference on the ordered extent that was
+ * inserted, and it also takes a reference on the buffer head.
+ */
+int ext3_add_ordered_extent(struct inode *inode, u64 start,
+			    struct buffer_head *bh)
+{
+	struct ext3_ordered_inode_tree *tree;
+	struct rb_node *node;
+	struct ext3_ordered_extent *entry;
+	int ret = 0;
+
+	lock_buffer(bh);
+
+	/* ordered extent already there, or in old style data=ordered */
+	if (bh->b_private) {
+		ret = 0;
+		goto out;
+	}
+
+	tree = &EXT3_I(inode)->ordered_tree;
+	entry = kzalloc(sizeof(*entry), GFP_NOFS);
+	if (!entry) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	spin_lock(&tree->lock);
+	entry->start = start;
+
+	get_bh(bh);
+	entry->bh = bh;
+	bh->b_private = entry;
+	set_buffer_dataguarded(bh);
+
+	/* one ref for the tree */
+	atomic_set(&entry->refs, 1);
+	INIT_LIST_HEAD(&entry->list);
+	node = tree_insert(&tree->tree, start,
+			   inode->i_sb->s_blocksize, &entry->rb_node);
+	BUG_ON(node);
+
+	spin_unlock(&tree->lock);
+out:
+	unlock_buffer(bh);
+	return ret;
+}
+
+/*
+ * used to drop a reference on an ordered extent.  This will free
+ * the extent if the last reference is dropped
+ */
+int ext3_put_ordered_extent(struct ext3_ordered_extent *entry)
+{
+	if (atomic_dec_and_test(&entry->refs)) {
+		WARN_ON(entry->bh);
+		kfree(entry);
+	}
+	return 0;
+}
+
+/*
+ * remove an ordered extent from the tree.  This removes the
+ * reference held by the rbtree on 'entry' and the
+ * reference on the buffer head held by the entry.
+ */
+int ext3_remove_ordered_extent(struct inode *inode,
+				struct ext3_ordered_extent *entry)
+{
+	struct ext3_ordered_inode_tree *tree;
+	struct rb_node *node;
+
+	tree = &EXT3_I(inode)->ordered_tree;
+	node = &entry->rb_node;
+	clear_buffer_dataguarded(entry->bh);
+	entry->bh->b_private = NULL;
+	brelse(entry->bh);
+	rb_erase(node, &tree->tree);
+	ext3_put_ordered_extent(entry);
+	return 0;
+}
+
+/*
+ * After an extent is done, call this to conditionally update the on disk
+ * i_size.  i_size is updated to cover any fully written part of the file.
+ *
+ * This returns < 0 on error, zero if no action needs to be taken and
+ * 1 if the inode must be logged.
+ */
+int ext3_ordered_update_i_size(struct inode *inode,
+			       struct ext3_ordered_extent *entry)
+{
+	u64 new_i_size;
+	u64 i_size_test;
+	u64 disk_i_size;
+	struct rb_node *node;
+	struct ext3_ordered_extent *test;
+	unsigned blocksize = inode->i_sb->s_blocksize;
+	int ret = 0;
+
+	disk_i_size = EXT3_I(inode)->i_disksize;
+
+	/*
+	 * if the disk i_size is already at the inode->i_size, or
+	 * this ordered extent is inside the disk i_size, we're done
+	 */
+	if (disk_i_size >= inode->i_size ||
+	    entry_end(entry, blocksize) <= disk_i_size)
+		goto out;
+
+	/*
+	 * walk backward from this ordered extent to disk_i_size.
+	 * if we find an ordered extent then we can't update disk i_size
+	 * yet
+	 */
+	node = &entry->rb_node;
+	while (1) {
+		node = rb_prev(node);
+		if (!node)
+			break;
+		test = rb_entry(node, struct ext3_ordered_extent, rb_node);
+		if (entry_end(test, blocksize) <= disk_i_size)
+			break;
+		if (test->start >= inode->i_size)
+			break;
+		if (test->start >= disk_i_size)
+			goto out;
+	}
+
+	/* from here, the caller will have to log something, set ret to 1 */
+	ret = 1;
+
+	/*
+	 * at this point, we know we can safely update i_size to at least
+	 * the offset from this ordered extent.  But, we need to
+	 * walk forward and see if ios from higher up in the file have
+	 * finished.
+	 */
+	node = rb_next(&entry->rb_node);
+	i_size_test = 0;
+	if (node) {
+		/*
+		 * do we have an area where IO might have finished
+		 * between our ordered extent and the next one.
+		 */
+		test = rb_entry(node, struct ext3_ordered_extent, rb_node);
+		if (test->start >= entry_end(entry, blocksize))
+			i_size_test = test->start;
+	} else {
+		i_size_test = i_size_read(inode);
+	}
+
+	new_i_size = min_t(u64, i_size_test, i_size_read(inode));
+
+	EXT3_I(inode)->i_disksize = new_i_size;
+out:
+	return ret;
+}
+
+/*
+ * during a truncate or delete, we need to get rid of pending
+ * ordered extents so that isn't a war over who updates disk i_size first.
+ * This does that, without waiting for any of the IO to actually finish.
+ *
+ * When the IO does finish, it will find the ordered extent removed from the
+ * tree and all will work properly.
+ */
+void ext3_truncate_ordered_extents(struct inode *inode, u64 offset)
+{
+	struct ext3_ordered_inode_tree *tree = &EXT3_I(inode)->ordered_tree;
+	struct rb_node *node;
+	struct ext3_ordered_extent *test;
+
+	spin_lock(&tree->lock);
+	node = rb_last(&tree->tree);
+	while(node) {
+		test = rb_entry(node, struct ext3_ordered_extent, rb_node);
+		/* truncate is going to end up waiting for pages that
+		 * straddle the new i_size.  So, we can drop the
+		 * ordered record for anything that starts before the new
+		 * i_size.
+		 *
+		 * The main goal here is to avoid confusion between the
+		 * code in truncate and our end_io handlers
+		 */
+		if (test->start < offset)
+			break;
+		node = rb_prev(&test->rb_node);
+
+		/*
+		 * once this is called, the end_io handler won't run,
+		 * and we won't update disk_i_size to include this buffer.
+		 *
+		 * That's ok for truncates because the truncate code is
+		 * writing a new i_size.
+		 *
+		 * This ignores any IO in flight, which is ok
+		 * because the guarded_buffers list has a reference
+		 * on the ordered extent
+		 */
+		ext3_remove_ordered_extent(inode, test);
+	}
+	spin_unlock(&tree->lock);
+	return;
+
+}
+
+void ext3_ordered_inode_init(struct ext3_inode_info *ei)
+{
+	ei->ordered_tree.tree.rb_node = NULL;
+	spin_lock_init(&ei->ordered_tree.lock);
+}
+
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 599dbfe..8ca37ab 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -37,6 +37,7 @@
 #include <linux/quotaops.h>
 #include <linux/seq_file.h>
 #include <linux/log2.h>
+#include <linux/workqueue.h>
 
 #include <asm/uaccess.h>
 
@@ -399,6 +400,9 @@ static void ext3_put_super (struct super_block * sb)
 	struct ext3_super_block *es = sbi->s_es;
 	int i, err;
 
+	flush_workqueue(sbi->guarded_wq);
+	destroy_workqueue(sbi->guarded_wq);
+
 	ext3_xattr_put_super(sb);
 	err = journal_destroy(sbi->s_journal);
 	sbi->s_journal = NULL;
@@ -468,6 +472,8 @@ static struct inode *ext3_alloc_inode(struct super_block *sb)
 #endif
 	ei->i_block_alloc_info = NULL;
 	ei->vfs_inode.i_version = 1;
+	ext3_ordered_inode_init(ei);
+
 	return &ei->vfs_inode;
 }
 
@@ -481,6 +487,8 @@ static void ext3_destroy_inode(struct inode *inode)
 				false);
 		dump_stack();
 	}
+	if (EXT3_I(inode)->ordered_tree.tree.rb_node)
+		printk("EXT3 ordered data tree not empty on clear inode\n");
 	kmem_cache_free(ext3_inode_cachep, EXT3_I(inode));
 }
 
@@ -528,6 +536,13 @@ static void ext3_clear_inode(struct inode *inode)
 		EXT3_I(inode)->i_default_acl = EXT3_ACL_NOT_CACHED;
 	}
 #endif
+	/*
+	 * If pages got cleaned by truncate, truncate should have
+	 * gotten rid of the ordered extents.  Just in case, drop them
+	 * here.
+	 */
+	ext3_truncate_ordered_extents(inode, 0);
+
 	ext3_discard_reservation(inode);
 	EXT3_I(inode)->i_block_alloc_info = NULL;
 	if (unlikely(rsv))
@@ -634,6 +649,8 @@ static int ext3_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_puts(seq, ",data=journal");
 	else if (test_opt(sb, DATA_FLAGS) == EXT3_MOUNT_ORDERED_DATA)
 		seq_puts(seq, ",data=ordered");
+	else if (test_opt(sb, GUARDED_DATA) == EXT3_MOUNT_GUARDED_DATA)
+		seq_puts(seq, ",data=guarded");
 	else if (test_opt(sb, DATA_FLAGS) == EXT3_MOUNT_WRITEBACK_DATA)
 		seq_puts(seq, ",data=writeback");
 
@@ -790,7 +807,7 @@ enum {
 	Opt_reservation, Opt_noreservation, Opt_noload, Opt_nobh, Opt_bh,
 	Opt_commit, Opt_journal_update, Opt_journal_inum, Opt_journal_dev,
 	Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_data_writeback,
-	Opt_data_err_abort, Opt_data_err_ignore,
+	Opt_data_guarded, Opt_data_err_abort, Opt_data_err_ignore,
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
 	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
@@ -832,6 +849,7 @@ static const match_table_t tokens = {
 	{Opt_abort, "abort"},
 	{Opt_data_journal, "data=journal"},
 	{Opt_data_ordered, "data=ordered"},
+	{Opt_data_guarded, "data=guarded"},
 	{Opt_data_writeback, "data=writeback"},
 	{Opt_data_err_abort, "data_err=abort"},
 	{Opt_data_err_ignore, "data_err=ignore"},
@@ -1034,6 +1052,9 @@ static int parse_options (char *options, struct super_block *sb,
 		case Opt_data_ordered:
 			data_opt = EXT3_MOUNT_ORDERED_DATA;
 			goto datacheck;
+		case Opt_data_guarded:
+			data_opt = EXT3_MOUNT_GUARDED_DATA;
+			goto datacheck;
 		case Opt_data_writeback:
 			data_opt = EXT3_MOUNT_WRITEBACK_DATA;
 		datacheck:
@@ -1949,11 +1970,23 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 			clear_opt(sbi->s_mount_opt, NOBH);
 		}
 	}
+
+	/*
+	 * setup the guarded work list
+	 */
+	INIT_LIST_HEAD(&EXT3_SB(sb)->guarded_buffers);
+	INIT_WORK(&EXT3_SB(sb)->guarded_work, ext3_run_guarded_work);
+	spin_lock_init(&EXT3_SB(sb)->guarded_lock);
+	EXT3_SB(sb)->guarded_wq = create_workqueue("ext3-guard");
+	if (!EXT3_SB(sb)->guarded_wq) {
+		printk(KERN_ERR "EXT3-fs: failed to create workqueue\n");
+		goto failed_mount_guard;
+	}
+
 	/*
 	 * The journal_load will have done any necessary log recovery,
 	 * so we can safely mount the rest of the filesystem now.
 	 */
-
 	root = ext3_iget(sb, EXT3_ROOT_INO);
 	if (IS_ERR(root)) {
 		printk(KERN_ERR "EXT3-fs: get root inode failed\n");
@@ -1965,6 +1998,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 		printk(KERN_ERR "EXT3-fs: corrupt root inode, run e2fsck\n");
 		goto failed_mount4;
 	}
+
 	sb->s_root = d_alloc_root(root);
 	if (!sb->s_root) {
 		printk(KERN_ERR "EXT3-fs: get root dentry failed\n");
@@ -1974,6 +2008,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 	}
 
 	ext3_setup_super (sb, es, sb->s_flags & MS_RDONLY);
+
 	/*
 	 * akpm: core read_super() calls in here with the superblock locked.
 	 * That deadlocks, because orphan cleanup needs to lock the superblock
@@ -1989,9 +2024,10 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 		printk (KERN_INFO "EXT3-fs: recovery complete.\n");
 	ext3_mark_recovery_complete(sb, es);
 	printk (KERN_INFO "EXT3-fs: mounted filesystem with %s data mode.\n",
-		test_opt(sb,DATA_FLAGS) == EXT3_MOUNT_JOURNAL_DATA ? "journal":
-		test_opt(sb,DATA_FLAGS) == EXT3_MOUNT_ORDERED_DATA ? "ordered":
-		"writeback");
+	      test_opt(sb,DATA_FLAGS) == EXT3_MOUNT_JOURNAL_DATA ? "journal":
+	      test_opt(sb,GUARDED_DATA) == EXT3_MOUNT_GUARDED_DATA ? "guarded":
+	      test_opt(sb,DATA_FLAGS) == EXT3_MOUNT_ORDERED_DATA ? "ordered":
+	      "writeback");
 
 	lock_kernel();
 	return 0;
@@ -2003,6 +2039,8 @@ cantfind_ext3:
 	goto failed_mount;
 
 failed_mount4:
+	destroy_workqueue(EXT3_SB(sb)->guarded_wq);
+failed_mount_guard:
 	journal_destroy(sbi->s_journal);
 failed_mount3:
 	percpu_counter_destroy(&sbi->s_freeblocks_counter);
diff --git a/fs/jbd/transaction.c b/fs/jbd/transaction.c
index ed886e6..1354a55 100644
--- a/fs/jbd/transaction.c
+++ b/fs/jbd/transaction.c
@@ -2018,6 +2018,7 @@ zap_buffer_unlocked:
 	clear_buffer_mapped(bh);
 	clear_buffer_req(bh);
 	clear_buffer_new(bh);
+	clear_buffer_datanew(bh);
 	bh->b_bdev = NULL;
 	return may_free;
 }
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 634a5e5..09faa88 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -18,6 +18,7 @@
 
 #include <linux/types.h>
 #include <linux/magic.h>
+#include <linux/workqueue.h>
 
 /*
  * The second extended filesystem constants/structures
@@ -398,7 +399,6 @@ struct ext3_inode {
 #define EXT3_MOUNT_MINIX_DF		0x00080	/* Mimics the Minix statfs */
 #define EXT3_MOUNT_NOLOAD		0x00100	/* Don't use existing journal*/
 #define EXT3_MOUNT_ABORT		0x00200	/* Fatal error detected */
-#define EXT3_MOUNT_DATA_FLAGS		0x00C00	/* Mode for data writes: */
 #define EXT3_MOUNT_JOURNAL_DATA		0x00400	/* Write data to journal */
 #define EXT3_MOUNT_ORDERED_DATA		0x00800	/* Flush data before commit */
 #define EXT3_MOUNT_WRITEBACK_DATA	0x00C00	/* No data ordering */
@@ -414,6 +414,12 @@ struct ext3_inode {
 #define EXT3_MOUNT_GRPQUOTA		0x200000 /* "old" group quota */
 #define EXT3_MOUNT_DATA_ERR_ABORT	0x400000 /* Abort on file data write
 						  * error in ordered mode */
+#define EXT3_MOUNT_GUARDED_DATA		0x800000 /* guard new writes with
+						    i_size */
+#define EXT3_MOUNT_DATA_FLAGS		(EXT3_MOUNT_JOURNAL_DATA | \
+					 EXT3_MOUNT_ORDERED_DATA | \
+					 EXT3_MOUNT_WRITEBACK_DATA | \
+					 EXT3_MOUNT_GUARDED_DATA)
 
 /* Compatibility, for having both ext2_fs.h and ext3_fs.h included at once */
 #ifndef _LINUX_EXT2_FS_H
@@ -892,6 +898,7 @@ extern void ext3_get_inode_flags(struct ext3_inode_info *);
 extern void ext3_set_aops(struct inode *inode);
 extern int ext3_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		       u64 start, u64 len);
+void ext3_run_guarded_work(struct work_struct *work);
 
 /* ioctl.c */
 extern long ext3_ioctl(struct file *, unsigned int, unsigned long);
@@ -945,7 +952,31 @@ extern const struct inode_operations ext3_special_inode_operations;
 extern const struct inode_operations ext3_symlink_inode_operations;
 extern const struct inode_operations ext3_fast_symlink_inode_operations;
 
+/* ordered-data.c */
+int ext3_add_ordered_extent(struct inode *inode, u64 file_offset,
+			    struct buffer_head *bh);
+int ext3_put_ordered_extent(struct ext3_ordered_extent *entry);
+int ext3_remove_ordered_extent(struct inode *inode,
+				struct ext3_ordered_extent *entry);
+int ext3_ordered_update_i_size(struct inode *inode,
+			       struct ext3_ordered_extent *entry);
+void ext3_ordered_inode_init(struct ext3_inode_info *ei);
+void ext3_truncate_ordered_extents(struct inode *inode, u64 offset);
+
+static inline void ext3_ordered_lock(struct inode *inode)
+{
+	spin_lock(&EXT3_I(inode)->ordered_tree.lock);
+}
 
+static inline void ext3_ordered_unlock(struct inode *inode)
+{
+	spin_unlock(&EXT3_I(inode)->ordered_tree.lock);
+}
+
+static inline void ext3_get_ordered_extent(struct ext3_ordered_extent *entry)
+{
+	atomic_inc(&entry->refs);
+}
 #endif	/* __KERNEL__ */
 
 #endif	/* _LINUX_EXT3_FS_H */
diff --git a/include/linux/ext3_fs_i.h b/include/linux/ext3_fs_i.h
index 7894dd0..6892c48 100644
--- a/include/linux/ext3_fs_i.h
+++ b/include/linux/ext3_fs_i.h
@@ -20,6 +20,7 @@
 #include <linux/rbtree.h>
 #include <linux/seqlock.h>
 #include <linux/mutex.h>
+#include <linux/rbtree.h>
 
 /* data type for block offset of block group */
 typedef int ext3_grpblk_t;
@@ -65,6 +66,39 @@ struct ext3_block_alloc_info {
 #define rsv_end rsv_window._rsv_end
 
 /*
+ * used to prevent garbage in files after a crash by
+ * making sure i_size isn't updated until after the IO
+ * is done.
+ *
+ * See fs/ext3/ordered-data.c for the code that uses these.
+ */
+struct buffer_head;
+struct ext3_ordered_inode_tree {
+	/* protects the tree and disk i_size */
+	spinlock_t lock;
+
+	/* rb tree of IO that needs to happen before i_size can be updated */
+	struct rb_root tree;
+};
+
+struct ext3_ordered_extent {
+	/* logical offset of the block in the file */
+	u64 start;
+
+	/* buffer head being written */
+	struct buffer_head *bh;
+
+	/* number of refs on this ordered extent */
+	atomic_t refs;
+
+	/* for the rb tree */
+	struct rb_node rb_node;
+
+	/* list of things being processed by the workqueue */
+	struct list_head list;
+};
+
+/*
  * third extended file system inode data in memory
  */
 struct ext3_inode_info {
@@ -141,6 +175,8 @@ struct ext3_inode_info {
 	 * by other means, so we have truncate_mutex.
 	 */
 	struct mutex truncate_mutex;
+
+	struct ext3_ordered_inode_tree ordered_tree;
 	struct inode vfs_inode;
 };
 
diff --git a/include/linux/ext3_fs_sb.h b/include/linux/ext3_fs_sb.h
index f07f34d..5dbdbeb 100644
--- a/include/linux/ext3_fs_sb.h
+++ b/include/linux/ext3_fs_sb.h
@@ -21,6 +21,7 @@
 #include <linux/wait.h>
 #include <linux/blockgroup_lock.h>
 #include <linux/percpu_counter.h>
+#include <linux/workqueue.h>
 #endif
 #include <linux/rbtree.h>
 
@@ -82,6 +83,11 @@ struct ext3_sb_info {
 	char *s_qf_names[MAXQUOTAS];		/* Names of quota files with journalled quota */
 	int s_jquota_fmt;			/* Format of quota to use */
 #endif
+
+	struct workqueue_struct *guarded_wq;
+	struct work_struct guarded_work;
+	struct list_head guarded_buffers;
+	spinlock_t guarded_lock;
 };
 
 static inline spinlock_t *
diff --git a/include/linux/ext3_jbd.h b/include/linux/ext3_jbd.h
index cf82d51..45cb4aa 100644
--- a/include/linux/ext3_jbd.h
+++ b/include/linux/ext3_jbd.h
@@ -212,6 +212,17 @@ static inline int ext3_should_order_data(struct inode *inode)
 	return 0;
 }
 
+static inline int ext3_should_guard_data(struct inode *inode)
+{
+	if (!S_ISREG(inode->i_mode))
+		return 0;
+	if (EXT3_I(inode)->i_flags & EXT3_JOURNAL_DATA_FL)
+		return 0;
+	if (test_opt(inode->i_sb, GUARDED_DATA) == EXT3_MOUNT_GUARDED_DATA)
+		return 1;
+	return 0;
+}
+
 static inline int ext3_should_writeback_data(struct inode *inode)
 {
 	if (!S_ISREG(inode->i_mode))
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index 53ae439..fc220b5 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -291,6 +291,13 @@ enum jbd_state_bits {
 	BH_State,		/* Pins most journal_head state */
 	BH_JournalHead,		/* Pins bh->b_private and jh->b_bh */
 	BH_Unshadow,		/* Dummy bit, for BJ_Shadow wakeup filtering */
+	BH_DataGuarded,		/* ext3 data=guarded mode buffer
+				 * these have something other than a
+				 * journal_head at b_private */
+	BH_DataNew,		/* BH_new gets cleared too early for
+				 * data=guarded to use it.  So,
+				 * this gets set instead.
+				 */
 };
 
 BUFFER_FNS(JBD, jbd)
@@ -302,6 +309,8 @@ TAS_BUFFER_FNS(Revoked, revoked)
 BUFFER_FNS(RevokeValid, revokevalid)
 TAS_BUFFER_FNS(RevokeValid, revokevalid)
 BUFFER_FNS(Freed, freed)
+BUFFER_FNS(DataGuarded, dataguarded)
+BUFFER_FNS(DataNew, datanew)
 
 static inline struct buffer_head *jh2bh(struct journal_head *jh)
 {
diff --git a/mm/filemap.c b/mm/filemap.c
index 2e2d38e..04e2160 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -441,6 +441,7 @@ int filemap_write_and_wait_range(struct address_space *mapping,
 	}
 	return err;
 }
+EXPORT_SYMBOL(filemap_write_and_wait_range);
 
 /**
  * add_to_page_cache_locked - add a locked page to the pagecache
diff --git a/fs/buffer.c b/fs/buffer.c
index 13edf7a..308865b 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -360,7 +360,7 @@ still_busy:
  * Completion handler for block_write_full_page() - pages which are unlocked
  * during I/O, and which have PageWriteback cleared upon I/O completion.
  */
-static void end_buffer_async_write(struct buffer_head *bh, int uptodate)
+void end_buffer_async_write(struct buffer_head *bh, int uptodate)
 {
 	char b[BDEVNAME_SIZE];
 	unsigned long flags;
@@ -438,11 +438,17 @@ static void mark_buffer_async_read(struct buffer_head *bh)
 	set_buffer_async_read(bh);
 }
 
-void mark_buffer_async_write(struct buffer_head *bh)
+void mark_buffer_async_write_endio(struct buffer_head *bh,
+				   bh_end_io_t *handler)
 {
-	bh->b_end_io = end_buffer_async_write;
+	bh->b_end_io = handler;
 	set_buffer_async_write(bh);
 }
+
+void mark_buffer_async_write(struct buffer_head *bh)
+{
+	mark_buffer_async_write_endio(bh, end_buffer_async_write);
+}
 EXPORT_SYMBOL(mark_buffer_async_write);
 
 
@@ -1608,7 +1614,8 @@ EXPORT_SYMBOL(unmap_underlying_metadata);
  * unplugging the device queue.
  */
 static int __block_write_full_page(struct inode *inode, struct page *page,
-			get_block_t *get_block, struct writeback_control *wbc)
+			get_block_t *get_block, struct writeback_control *wbc,
+			bh_end_io_t *handler)
 {
 	int err;
 	sector_t block;
@@ -1693,7 +1700,7 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 			continue;
 		}
 		if (test_clear_buffer_dirty(bh)) {
-			mark_buffer_async_write(bh);
+			mark_buffer_async_write_endio(bh, handler);
 		} else {
 			unlock_buffer(bh);
 		}
@@ -1746,7 +1753,7 @@ recover:
 		if (buffer_mapped(bh) && buffer_dirty(bh) &&
 		    !buffer_delay(bh)) {
 			lock_buffer(bh);
-			mark_buffer_async_write(bh);
+			mark_buffer_async_write_endio(bh, handler);
 		} else {
 			/*
 			 * The buffer may have been set dirty during
@@ -2672,7 +2679,8 @@ int nobh_writepage(struct page *page, get_block_t *get_block,
 out:
 	ret = mpage_writepage(page, get_block, wbc);
 	if (ret == -EAGAIN)
-		ret = __block_write_full_page(inode, page, get_block, wbc);
+		ret = __block_write_full_page(inode, page, get_block, wbc,
+					      end_buffer_async_write);
 	return ret;
 }
 EXPORT_SYMBOL(nobh_writepage);
@@ -2830,9 +2838,10 @@ out:
 
 /*
  * The generic ->writepage function for buffer-backed address_spaces
+ * this form passes in the end_io handler used to finish the IO.
  */
-int block_write_full_page(struct page *page, get_block_t *get_block,
-			struct writeback_control *wbc)
+int block_write_full_page_endio(struct page *page, get_block_t *get_block,
+			struct writeback_control *wbc, bh_end_io_t *handler)
 {
 	struct inode * const inode = page->mapping->host;
 	loff_t i_size = i_size_read(inode);
@@ -2841,7 +2850,8 @@ int block_write_full_page(struct page *page, get_block_t *get_block,
 
 	/* Is the page fully inside i_size? */
 	if (page->index < end_index)
-		return __block_write_full_page(inode, page, get_block, wbc);
+		return __block_write_full_page(inode, page, get_block, wbc,
+					       handler);
 
 	/* Is the page fully outside i_size? (truncate in progress) */
 	offset = i_size & (PAGE_CACHE_SIZE-1);
@@ -2864,9 +2874,20 @@ int block_write_full_page(struct page *page, get_block_t *get_block,
 	 * writes to that region are not written out to the file."
 	 */
 	zero_user_segment(page, offset, PAGE_CACHE_SIZE);
-	return __block_write_full_page(inode, page, get_block, wbc);
+	return __block_write_full_page(inode, page, get_block, wbc, handler);
 }
 
+/*
+ * The generic ->writepage function for buffer-backed address_spaces
+ */
+int block_write_full_page(struct page *page, get_block_t *get_block,
+			struct writeback_control *wbc)
+{
+	return block_write_full_page_endio(page, get_block, wbc,
+					   end_buffer_async_write);
+}
+
+
 sector_t generic_block_bmap(struct address_space *mapping, sector_t block,
 			    get_block_t *get_block)
 {
@@ -3335,9 +3356,11 @@ EXPORT_SYMBOL(block_read_full_page);
 EXPORT_SYMBOL(block_sync_page);
 EXPORT_SYMBOL(block_truncate_page);
 EXPORT_SYMBOL(block_write_full_page);
+EXPORT_SYMBOL(block_write_full_page_endio);
 EXPORT_SYMBOL(cont_write_begin);
 EXPORT_SYMBOL(end_buffer_read_sync);
 EXPORT_SYMBOL(end_buffer_write_sync);
+EXPORT_SYMBOL(end_buffer_async_write);
 EXPORT_SYMBOL(file_fsync);
 EXPORT_SYMBOL(generic_block_bmap);
 EXPORT_SYMBOL(generic_cont_expand_simple);
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 7b73bb8..16ed028 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -155,6 +155,7 @@ void create_empty_buffers(struct page *, unsigned long,
 			unsigned long b_state);
 void end_buffer_read_sync(struct buffer_head *bh, int uptodate);
 void end_buffer_write_sync(struct buffer_head *bh, int uptodate);
+void end_buffer_async_write(struct buffer_head *bh, int uptodate);
 
 /* Things to do with buffers at mapping->private_list */
 void mark_buffer_dirty_inode(struct buffer_head *bh, struct inode *inode);
@@ -197,6 +198,8 @@ extern int buffer_heads_over_limit;
 void block_invalidatepage(struct page *page, unsigned long offset);
 int block_write_full_page(struct page *page, get_block_t *get_block,
 				struct writeback_control *wbc);
+int block_write_full_page_endio(struct page *page, get_block_t *get_block,
+			struct writeback_control *wbc, bh_end_io_t *handler);
 int block_read_full_page(struct page*, get_block_t*);
 int block_is_partially_uptodate(struct page *page, read_descriptor_t *desc,
 				unsigned long from);


