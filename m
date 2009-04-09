From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Ext3 latency fixes
Date: Thu, 09 Apr 2009 12:23:39 -0400
Message-ID: <1239294219.31257.10.camel@think.oraclecorp.com>
References: <E1LrhNF-0002zd-BG@closure.thunk.org>
	 <alpine.LFD.2.00.0904090836060.4583@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:30605 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935342AbZDIQvz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Apr 2009 12:51:55 -0400
In-Reply-To: <alpine.LFD.2.00.0904090836060.4583@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2009-04-09 at 08:49 -0700, Linus Torvalds wrote:
> 
> On Wed, 8 Apr 2009, Theodore Ts'o wrote:
> > 
> > One of these patches fixes a performance regression caused by a64c8610,
> > which unplugged the write queue after every page write.  Now that Jens
> > added WRITE_SYNC_PLUG.the patch causes us to use it instead of
> > WRITE_SYNC, to avoid the implicit unplugging.  These patches also seem
> > to further improbve ext3 latency, especially during the "sync" command
> > in Linus's write-big-file-and-sync workload.
> 
> So here's a question and a untested _conceptual_ patch. 
> 
> The kind of writeback mode I'd personally prefer would be more of a 
> mixture of the current "data=writeback" and "data=ordered" modes, with 
> something of the best of both worlds. I'd like the data writeback to get 
> _started_ when the journal is written to disk, but I'd like it to not 
> block journal updates.
> 
> IOW, it wouldn't be "strictly ordered", but at the same time it wouldn't 
> be totally unordered either.
> 

I started working on the xfs style i_size updates last night, and here's
my current (most definitely broken) proof of concept.  I call it
data=guarded.

In guarded mode the on disk i_size is not updated until after the data
writes are complete.  I've got a per FS work queue and I'm abusing
bh->b_private as a list pointer.  So, what happens is:

* writepage sets up the buffer with the guarded end_io handler

* The end_io handler puts the buffer onto the per-sb list of guarded
buffers and then it kicks the work queue

* The workqueue updates the on disk i_size to the min of the end of the
buffer or the in-memory i_size, and then it logs the inode.

* Then the regular async bh end_io handler is called to end writeback on
the page.

One big gotcha is that we starting a transaction while a page is
writeback.  It means that anyone who waits for writeback to finish on
the datapage with a transaction running could deadlock against the work
queue func trying to start a transaction.

I couldn't find anyone doing that, but if it matters, we can always just
mark the inode dirty and let some other async func handle the logging.
We could also play tricks with logging the inode after the real end_io
handler clears PG_writeback.

This code doesn't:

* Deal with hole filling (plan is just to use the ordered code there)

* Make sure all the blocks are on disk between the new disk i_size and
the old one.  For this, I'll add an rbtree to track BH_New buffers and
delay updating the disk isize until the pending BH_New IO is on disk.
Btrfs already does this, so I should have a handle on the spots I need
to fiddle.

There's a ton of room for optimization like not doing async end_io if
we're already inside disk i_size.

-chris

diff --git a/fs/buffer.c b/fs/buffer.c
index 891e1c7..c5e1ffd 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -505,7 +505,7 @@ still_busy:
  * Completion handler for block_write_full_page() - pages which are unlocked
  * during I/O, and which have PageWriteback cleared upon I/O completion.
  */
-static void end_buffer_async_write(struct buffer_head *bh, int uptodate)
+void end_buffer_async_write(struct buffer_head *bh, int uptodate)
 {
 	char b[BDEVNAME_SIZE];
 	unsigned long flags;
@@ -583,11 +583,17 @@ static void mark_buffer_async_read(struct buffer_head *bh)
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
 
 
@@ -1706,7 +1712,8 @@ EXPORT_SYMBOL(unmap_underlying_metadata);
  * prevents this contention from occurring.
  */
 static int __block_write_full_page(struct inode *inode, struct page *page,
-			get_block_t *get_block, struct writeback_control *wbc)
+			get_block_t *get_block, struct writeback_control *wbc,
+			bh_end_io_t *handler)
 {
 	int err;
 	sector_t block;
@@ -1789,7 +1796,7 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 			continue;
 		}
 		if (test_clear_buffer_dirty(bh)) {
-			mark_buffer_async_write(bh);
+			mark_buffer_async_write_endio(bh, handler);
 		} else {
 			unlock_buffer(bh);
 		}
@@ -1842,7 +1849,7 @@ recover:
 		if (buffer_mapped(bh) && buffer_dirty(bh) &&
 		    !buffer_delay(bh)) {
 			lock_buffer(bh);
-			mark_buffer_async_write(bh);
+			mark_buffer_async_write_endio(bh, handler);
 		} else {
 			/*
 			 * The buffer may have been set dirty during
@@ -2760,7 +2767,8 @@ int nobh_writepage(struct page *page, get_block_t *get_block,
 out:
 	ret = mpage_writepage(page, get_block, wbc);
 	if (ret == -EAGAIN)
-		ret = __block_write_full_page(inode, page, get_block, wbc);
+		ret = __block_write_full_page(inode, page, get_block, wbc,
+					      end_buffer_async_write);
 	return ret;
 }
 EXPORT_SYMBOL(nobh_writepage);
@@ -2918,9 +2926,10 @@ out:
 
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
@@ -2929,7 +2938,8 @@ int block_write_full_page(struct page *page, get_block_t *get_block,
 
 	/* Is the page fully inside i_size? */
 	if (page->index < end_index)
-		return __block_write_full_page(inode, page, get_block, wbc);
+		return __block_write_full_page(inode, page, get_block, wbc,
+					       handler);
 
 	/* Is the page fully outside i_size? (truncate in progress) */
 	offset = i_size & (PAGE_CACHE_SIZE-1);
@@ -2952,9 +2962,20 @@ int block_write_full_page(struct page *page, get_block_t *get_block,
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
@@ -3422,9 +3443,11 @@ EXPORT_SYMBOL(block_read_full_page);
 EXPORT_SYMBOL(block_sync_page);
 EXPORT_SYMBOL(block_truncate_page);
 EXPORT_SYMBOL(block_write_full_page);
+EXPORT_SYMBOL(block_write_full_page_endio);
 EXPORT_SYMBOL(cont_write_begin);
 EXPORT_SYMBOL(end_buffer_read_sync);
 EXPORT_SYMBOL(end_buffer_write_sync);
+EXPORT_SYMBOL_GPL(end_buffer_async_write);
 EXPORT_SYMBOL(file_fsync);
 EXPORT_SYMBOL(fsync_bdev);
 EXPORT_SYMBOL(generic_block_bmap);
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 5fa453b..64995d0 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -38,6 +38,7 @@
 #include <linux/bio.h>
 #include <linux/fiemap.h>
 #include <linux/namei.h>
+#include <linux/workqueue.h>
 #include "xattr.h"
 #include "acl.h"
 
@@ -766,6 +767,21 @@ err_out:
 	return err;
 }
 
+static int maybe_update_disk_isize(struct inode *inode, loff_t new_size)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	/* FIXME add a lock in the inode */
+	spin_lock_irqsave(&EXT3_SB(inode->i_sb)->guarded_lock, flags);
+	if (EXT3_I(inode)->i_disksize < new_size) {
+		EXT3_I(inode)->i_disksize = new_size;
+		ret = 1;
+	}
+	spin_unlock_irqrestore(&EXT3_SB(inode->i_sb)->guarded_lock, flags);
+	return ret;
+}
+
 /*
  * Allocation strategy is simple: if we have to allocate something, we will
  * have to go the whole way to leaf. So let's do it before attaching anything
@@ -915,9 +931,13 @@ int ext3_get_blocks_handle(handle_t *handle, struct inode *inode,
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
@@ -1079,6 +1099,50 @@ struct buffer_head *ext3_bread(handle_t *handle, struct inode *inode,
 	return NULL;
 }
 
+void ext3_run_guarded_work(struct work_struct *work)
+{
+	struct ext3_sb_info *sbi =
+		container_of(work, struct ext3_sb_info, guarded_work);
+	struct buffer_head *bh;
+	struct buffer_head *next;
+	struct inode *inode;
+	struct page *page;
+	struct address_space *mapping;
+	loff_t offset;
+
+	spin_lock_irq(&sbi->guarded_lock);
+	while(sbi->guarded_buffers) {
+		bh = sbi->guarded_buffers;
+		next = bh->b_private;
+		if (!next)
+			sbi->guarded_tail = NULL;
+		sbi->guarded_buffers = next;
+		bh->b_private = NULL;
+		spin_unlock_irq(&sbi->guarded_lock);
+
+		page = bh->b_page;
+		mapping = page->mapping;
+		if (!mapping)
+			goto out;
+
+		/* set the offset to the end of this buffer */
+		offset = page_offset(page) + bh_offset(bh) + bh->b_size;
+		inode = mapping->host;
+
+		/*
+		 * then chomp back to i_size if that is smaller than the
+		 * offset
+		 */
+		offset = min(offset, inode->i_size);
+		if (maybe_update_disk_isize(inode, offset))
+			ext3_dirty_inode(inode);
+out:
+		end_buffer_async_write(bh, buffer_uptodate(bh));
+		spin_lock_irq(&sbi->guarded_lock);
+	}
+	spin_unlock_irq(&sbi->guarded_lock);
+}
+
 static int walk_page_buffers(	handle_t *handle,
 				struct buffer_head *head,
 				unsigned from,
@@ -1275,8 +1339,7 @@ static int ext3_ordered_write_end(struct file *file,
 		loff_t new_i_size;
 
 		new_i_size = pos + copied;
-		if (new_i_size > EXT3_I(inode)->i_disksize)
-			EXT3_I(inode)->i_disksize = new_i_size;
+		maybe_update_disk_isize(inode, new_i_size);
 		ret2 = ext3_generic_write_end(file, mapping, pos, len, copied,
 							page, fsdata);
 		copied = ret2;
@@ -1303,8 +1366,30 @@ static int ext3_writeback_write_end(struct file *file,
 	loff_t new_i_size;
 
 	new_i_size = pos + copied;
-	if (new_i_size > EXT3_I(inode)->i_disksize)
-		EXT3_I(inode)->i_disksize = new_i_size;
+	maybe_update_disk_isize(inode, new_i_size);
+
+	ret2 = ext3_generic_write_end(file, mapping, pos, len, copied,
+							page, fsdata);
+	copied = ret2;
+	if (ret2 < 0)
+		ret = ret2;
+
+	ret2 = ext3_journal_stop(handle);
+	if (!ret)
+		ret = ret2;
+	unlock_page(page);
+	page_cache_release(page);
+
+	return ret ? ret : copied;
+}
+
+static int ext3_guarded_write_end(struct file *file,
+				struct address_space *mapping,
+				loff_t pos, unsigned len, unsigned copied,
+				struct page *page, void *fsdata)
+{
+	handle_t *handle = ext3_journal_current_handle();
+	int ret = 0, ret2;
 
 	ret2 = ext3_generic_write_end(file, mapping, pos, len, copied,
 							page, fsdata);
@@ -1553,6 +1638,74 @@ out_fail:
 	return ret;
 }
 
+/*
+ * Completion handler for block_write_full_page() - pages which are unlocked
+ * during I/O, and which have PageWriteback cleared upon I/O completion.
+ */
+static void end_buffer_async_write_guarded(struct buffer_head *bh,
+					   int uptodate)
+{
+	struct ext3_sb_info *sbi;
+	struct address_space *mapping;
+	unsigned long flags;
+
+	mapping = bh->b_page->mapping;
+	if (!mapping || bh->b_private) {
+		end_buffer_async_write(bh, uptodate);
+		return;
+	}
+
+	/*
+	 * the end_io callback deals with IO errors later
+	 */
+	if (uptodate)
+		set_buffer_uptodate(bh);
+	else
+		clear_buffer_uptodate(bh);
+
+	sbi = EXT3_SB(mapping->host->i_sb);
+	spin_lock_irqsave(&sbi->guarded_lock, flags);
+	if (sbi->guarded_tail) {
+		struct buffer_head *last = sbi->guarded_tail;
+		last->b_private = bh;
+	} else
+		sbi->guarded_buffers = bh;
+	sbi->guarded_tail = bh;
+	spin_unlock_irqrestore(&sbi->guarded_lock, flags);
+	queue_work(sbi->guarded_wq, &sbi->guarded_work);
+}
+
+static int ext3_guarded_writepage(struct page *page,
+				struct writeback_control *wbc)
+{
+	struct inode *inode = page->mapping->host;
+	handle_t *handle = NULL;
+	int ret = 0;
+	int err;
+
+	if (ext3_journal_current_handle())
+		goto out_fail;
+
+	handle = ext3_journal_start(inode, ext3_writepage_trans_blocks(inode));
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out_fail;
+	}
+
+	ret = block_write_full_page_endio(page, ext3_get_block, wbc,
+					  end_buffer_async_write_guarded);
+
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
 static int ext3_writeback_writepage(struct page *page,
 				struct writeback_control *wbc)
 {
@@ -1812,6 +1965,21 @@ static const struct address_space_operations ext3_writeback_aops = {
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
@@ -1830,6 +1998,8 @@ void ext3_set_aops(struct inode *inode)
 {
 	if (ext3_should_order_data(inode))
 		inode->i_mapping->a_ops = &ext3_ordered_aops;
+	else if (ext3_should_guard_data(inode))
+		inode->i_mapping->a_ops = &ext3_guarded_aops;
 	else if (ext3_should_writeback_data(inode))
 		inode->i_mapping->a_ops = &ext3_writeback_aops;
 	else
@@ -3081,6 +3251,14 @@ int ext3_setattr(struct dentry *dentry, struct iattr *attr)
 		}
 
 		error = ext3_orphan_add(handle, inode);
+
+		/*
+		 * this is pretty confusing, but we don't need to worry
+		 * about guarded i_size here because ext3 truncate fixes
+		 * it to the correct i_size when the truncate is all done,
+		 * and the ext3_orphan_add makes sure we'll have a sane
+		 * i_size after a crash
+		 */
 		EXT3_I(inode)->i_disksize = attr->ia_size;
 		rc = ext3_mark_inode_dirty(handle, inode);
 		if (!error)
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 4a97041..0534a95 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -37,6 +37,7 @@
 #include <linux/quotaops.h>
 #include <linux/seq_file.h>
 #include <linux/log2.h>
+#include <linux/workqueue.h>
 
 #include <asm/uaccess.h>
 
@@ -393,6 +394,9 @@ static void ext3_put_super (struct super_block * sb)
 	struct ext3_super_block *es = sbi->s_es;
 	int i, err;
 
+	flush_workqueue(sbi->guarded_wq);
+	destroy_workqueue(sbi->guarded_wq);
+
 	ext3_xattr_put_super(sb);
 	err = journal_destroy(sbi->s_journal);
 	sbi->s_journal = NULL;
@@ -628,6 +632,8 @@ static int ext3_show_options(struct seq_file *seq, struct vfsmount *vfs)
 		seq_puts(seq, ",data=journal");
 	else if (test_opt(sb, DATA_FLAGS) == EXT3_MOUNT_ORDERED_DATA)
 		seq_puts(seq, ",data=ordered");
+	else if (test_opt(sb, GUARDED_DATA) == EXT3_MOUNT_GUARDED_DATA)
+		seq_puts(seq, ",data=guarded");
 	else if (test_opt(sb, DATA_FLAGS) == EXT3_MOUNT_WRITEBACK_DATA)
 		seq_puts(seq, ",data=writeback");
 
@@ -786,7 +792,7 @@ enum {
 	Opt_reservation, Opt_noreservation, Opt_noload, Opt_nobh, Opt_bh,
 	Opt_commit, Opt_journal_update, Opt_journal_inum, Opt_journal_dev,
 	Opt_abort, Opt_data_journal, Opt_data_ordered, Opt_data_writeback,
-	Opt_data_err_abort, Opt_data_err_ignore,
+	Opt_data_guarded, Opt_data_err_abort, Opt_data_err_ignore,
 	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
 	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
 	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
@@ -828,6 +834,7 @@ static const match_table_t tokens = {
 	{Opt_abort, "abort"},
 	{Opt_data_journal, "data=journal"},
 	{Opt_data_ordered, "data=ordered"},
+	{Opt_data_guarded, "data=guarded"},
 	{Opt_data_writeback, "data=writeback"},
 	{Opt_data_err_abort, "data_err=abort"},
 	{Opt_data_err_ignore, "data_err=ignore"},
@@ -1030,6 +1037,9 @@ static int parse_options (char *options, struct super_block *sb,
 		case Opt_data_ordered:
 			data_opt = EXT3_MOUNT_ORDERED_DATA;
 			goto datacheck;
+		case Opt_data_guarded:
+			data_opt = EXT3_MOUNT_GUARDED_DATA;
+			goto datacheck;
 		case Opt_data_writeback:
 			data_opt = EXT3_MOUNT_WRITEBACK_DATA;
 		datacheck:
@@ -1945,11 +1955,24 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 			clear_opt(sbi->s_mount_opt, NOBH);
 		}
 	}
+
+	/*
+	 * setup the guarded work list
+	 */
+	EXT3_SB(sb)->guarded_buffers = NULL;
+	EXT3_SB(sb)->guarded_tail = NULL;
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
@@ -1961,6 +1984,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 		printk(KERN_ERR "EXT3-fs: corrupt root inode, run e2fsck\n");
 		goto failed_mount4;
 	}
+
 	sb->s_root = d_alloc_root(root);
 	if (!sb->s_root) {
 		printk(KERN_ERR "EXT3-fs: get root dentry failed\n");
@@ -1970,6 +1994,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 	}
 
 	ext3_setup_super (sb, es, sb->s_flags & MS_RDONLY);
+
 	/*
 	 * akpm: core read_super() calls in here with the superblock locked.
 	 * That deadlocks, because orphan cleanup needs to lock the superblock
@@ -1985,9 +2010,10 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
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
@@ -1999,6 +2025,8 @@ cantfind_ext3:
 	goto failed_mount;
 
 failed_mount4:
+	destroy_workqueue(EXT3_SB(sb)->guarded_wq);
+failed_mount_guard:
 	journal_destroy(sbi->s_journal);
 failed_mount3:
 	percpu_counter_destroy(&sbi->s_freeblocks_counter);
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index bd7ac79..507b38d 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -155,6 +155,7 @@ void create_empty_buffers(struct page *, unsigned long,
 			unsigned long b_state);
 void end_buffer_read_sync(struct buffer_head *bh, int uptodate);
 void end_buffer_write_sync(struct buffer_head *bh, int uptodate);
+void end_buffer_async_write(struct buffer_head *bh, int uptodate);
 
 /* Things to do with buffers at mapping->private_list */
 void mark_buffer_dirty_inode(struct buffer_head *bh, struct inode *inode);
@@ -204,6 +205,8 @@ extern int buffer_heads_over_limit;
 void block_invalidatepage(struct page *page, unsigned long offset);
 int block_write_full_page(struct page *page, get_block_t *get_block,
 				struct writeback_control *wbc);
+int block_write_full_page_endio(struct page *page, get_block_t *get_block,
+			struct writeback_control *wbc, bh_end_io_t *handler);
 int block_read_full_page(struct page*, get_block_t*);
 int block_is_partially_uptodate(struct page *page, read_descriptor_t *desc,
 				unsigned long from);
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index dd495b8..7966bdb 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -18,6 +18,7 @@
 
 #include <linux/types.h>
 #include <linux/magic.h>
+#include <linux/workqueue.h>
 
 /*
  * The second extended filesystem constants/structures
@@ -397,7 +398,6 @@ struct ext3_inode {
 #define EXT3_MOUNT_MINIX_DF		0x00080	/* Mimics the Minix statfs */
 #define EXT3_MOUNT_NOLOAD		0x00100	/* Don't use existing journal*/
 #define EXT3_MOUNT_ABORT		0x00200	/* Fatal error detected */
-#define EXT3_MOUNT_DATA_FLAGS		0x00C00	/* Mode for data writes: */
 #define EXT3_MOUNT_JOURNAL_DATA		0x00400	/* Write data to journal */
 #define EXT3_MOUNT_ORDERED_DATA		0x00800	/* Flush data before commit */
 #define EXT3_MOUNT_WRITEBACK_DATA	0x00C00	/* No data ordering */
@@ -413,6 +413,12 @@ struct ext3_inode {
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
@@ -891,6 +897,7 @@ extern void ext3_get_inode_flags(struct ext3_inode_info *);
 extern void ext3_set_aops(struct inode *inode);
 extern int ext3_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		       u64 start, u64 len);
+void ext3_run_guarded_work(struct work_struct *work);
 
 /* ioctl.c */
 extern int ext3_ioctl (struct inode *, struct file *, unsigned int,
diff --git a/include/linux/ext3_fs_sb.h b/include/linux/ext3_fs_sb.h
index f07f34d..868d2cd 100644
--- a/include/linux/ext3_fs_sb.h
+++ b/include/linux/ext3_fs_sb.h
@@ -21,6 +21,7 @@
 #include <linux/wait.h>
 #include <linux/blockgroup_lock.h>
 #include <linux/percpu_counter.h>
+#include <linux/workqueue.h>
 #endif
 #include <linux/rbtree.h>
 
@@ -82,6 +83,12 @@ struct ext3_sb_info {
 	char *s_qf_names[MAXQUOTAS];		/* Names of quota files with journalled quota */
 	int s_jquota_fmt;			/* Format of quota to use */
 #endif
+
+	struct workqueue_struct *guarded_wq;
+	struct work_struct guarded_work;
+	struct buffer_head *guarded_buffers;
+	struct buffer_head *guarded_tail;
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


