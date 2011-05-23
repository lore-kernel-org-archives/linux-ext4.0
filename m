From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH 1/2] ext3: Add fixed tracepoints
Date: Mon, 23 May 2011 17:02:56 +0200
Message-ID: <1306162977-23061-2-git-send-email-lczerner@redhat.com>
References: <1306162977-23061-1-git-send-email-lczerner@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Lukas Czerner <lczerner@redhat.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751802Ab1EWPDY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 May 2011 11:03:24 -0400
In-Reply-To: <1306162977-23061-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This commit adds fixed tracepoints to the ext3 code. It is based on ext4
tracepoints, however due to the differences of both file systems, there
are some tracepoints missing (those for delaloc and for multi-block
allocator) and there are some ext3 specific as well (for reservation
windows).

Here is a list:

ext3_free_inode
ext3_request_inode
ext3_allocate_inode
ext3_evict_inode
ext3_drop_inode
ext3_mark_inode_dirty
ext3_write_begin
ext3_ordered_write_end
ext3_writeback_write_end
ext3_journalled_write_end
ext3_ordered_writepage
ext3_writeback_writepage
ext3_journalled_writepage
ext3_readpage
ext3_releasepage
ext3_invalidatepage
ext3_discard_blocks
ext3_request_blocks
ext3_allocate_blocks
ext3_free_blocks
ext3_sync_file_enter
ext3_sync_file_exit
ext3_sync_fs
ext3_rsv_window_add
ext3_discard_reservation
ext3_alloc_new_reservation
ext3_reserved
ext3_forget
ext3_read_block_bitmap
ext3_direct_IO_enter
ext3_direct_IO_exit
ext3_unlink_enter
ext3_unlink_exit
ext3_truncate_enter
ext3_truncate_exit
ext3_get_blocks_enter
ext3_get_blocks_exit
ext3_load_inode

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Cc: Jan Kara <jack@suse.cz>
---
 fs/ext3/balloc.c            |   34 +-
 fs/ext3/fsync.c             |   15 +-
 fs/ext3/ialloc.c            |    4 +
 fs/ext3/inode.c             |   29 ++
 fs/ext3/namei.c             |    3 +
 fs/ext3/super.c             |   13 +
 include/trace/events/ext3.h |  888 +++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 970 insertions(+), 16 deletions(-)
 create mode 100644 include/trace/events/ext3.h

diff --git a/fs/ext3/balloc.c b/fs/ext3/balloc.c
index fe52297..f7d111e 100644
--- a/fs/ext3/balloc.c
+++ b/fs/ext3/balloc.c
@@ -21,6 +21,7 @@
 #include <linux/quotaops.h>
 #include <linux/buffer_head.h>
 #include <linux/blkdev.h>
+#include <trace/events/ext3.h>
 
 /*
  * balloc.c contains the blocks allocation and deallocation routines
@@ -161,6 +162,7 @@ read_block_bitmap(struct super_block *sb, unsigned int block_group)
 	desc = ext3_get_group_desc(sb, block_group, NULL);
 	if (!desc)
 		return NULL;
+	trace_ext3_read_block_bitmap(sb, block_group);
 	bitmap_blk = le32_to_cpu(desc->bg_block_bitmap);
 	bh = sb_getblk(sb, bitmap_blk);
 	if (unlikely(!bh)) {
@@ -351,6 +353,7 @@ void ext3_rsv_window_add(struct super_block *sb,
 	struct rb_node * parent = NULL;
 	struct ext3_reserve_window_node *this;
 
+	trace_ext3_rsv_window_add(sb, rsv);
 	while (*p)
 	{
 		parent = *p;
@@ -476,8 +479,10 @@ void ext3_discard_reservation(struct inode *inode)
 	rsv = &block_i->rsv_window_node;
 	if (!rsv_is_empty(&rsv->rsv_window)) {
 		spin_lock(rsv_lock);
-		if (!rsv_is_empty(&rsv->rsv_window))
+		if (!rsv_is_empty(&rsv->rsv_window)) {
+			trace_ext3_discard_reservation(inode, rsv);
 			rsv_window_remove(inode->i_sb, rsv);
+		}
 		spin_unlock(rsv_lock);
 	}
 }
@@ -683,14 +688,10 @@ error_return:
 void ext3_free_blocks(handle_t *handle, struct inode *inode,
 			ext3_fsblk_t block, unsigned long count)
 {
-	struct super_block * sb;
+	struct super_block *sb = inode->i_sb;
 	unsigned long dquot_freed_blocks;
 
-	sb = inode->i_sb;
-	if (!sb) {
-		printk ("ext3_free_blocks: nonexistent device");
-		return;
-	}
+	trace_ext3_free_blocks(inode, block, count);
 	ext3_free_blocks_sb(handle, sb, block, count, &dquot_freed_blocks);
 	if (dquot_freed_blocks)
 		dquot_free_block(inode, dquot_freed_blocks);
@@ -1136,6 +1137,7 @@ static int alloc_new_reservation(struct ext3_reserve_window_node *my_rsv,
 	else
 		start_block = grp_goal + group_first_block;
 
+	trace_ext3_alloc_new_reservation(sb, start_block);
 	size = my_rsv->rsv_goal_size;
 
 	if (!rsv_is_empty(&my_rsv->rsv_window)) {
@@ -1230,8 +1232,11 @@ retry:
 	 * check if the first free block is within the
 	 * free space we just reserved
 	 */
-	if (start_block >= my_rsv->rsv_start && start_block <= my_rsv->rsv_end)
+	if (start_block >= my_rsv->rsv_start &&
+	    start_block <= my_rsv->rsv_end) {
+		trace_ext3_reserved(sb, start_block, my_rsv);
 		return 0;		/* success */
+	}
 	/*
 	 * if the first free bit we found is out of the reservable space
 	 * continue search for next reservable space,
@@ -1514,10 +1519,6 @@ ext3_fsblk_t ext3_new_blocks(handle_t *handle, struct inode *inode,
 
 	*errp = -ENOSPC;
 	sb = inode->i_sb;
-	if (!sb) {
-		printk("ext3_new_block: nonexistent device");
-		return 0;
-	}
 
 	/*
 	 * Check quota for allocation of this block.
@@ -1528,8 +1529,10 @@ ext3_fsblk_t ext3_new_blocks(handle_t *handle, struct inode *inode,
 		return 0;
 	}
 
+	trace_ext3_request_blocks(inode, goal, num);
+
 	sbi = EXT3_SB(sb);
-	es = EXT3_SB(sb)->s_es;
+	es = sbi->s_es;
 	ext3_debug("goal=%lu.\n", goal);
 	/*
 	 * Allocate a block from reservation only when
@@ -1742,6 +1745,10 @@ allocated:
 	brelse(bitmap_bh);
 	dquot_free_block(inode, *count-num);
 	*count = num;
+
+	trace_ext3_allocate_blocks(inode, goal, num,
+				   (unsigned long long)ret_block);
+
 	return ret_block;
 
 io_error:
@@ -1996,6 +2003,7 @@ ext3_grpblk_t ext3_trim_all_free(struct super_block *sb, unsigned int group,
 		if ((next - start) < minblocks)
 			goto free_extent;
 
+		trace_ext3_discard_blocks(sb, discard_block, next - start);
 		 /* Send the TRIM command down to the device */
 		err = sb_issue_discard(sb, discard_block, next - start,
 				       GFP_NOFS, 0);
diff --git a/fs/ext3/fsync.c b/fs/ext3/fsync.c
index 09b13bb..06a4394 100644
--- a/fs/ext3/fsync.c
+++ b/fs/ext3/fsync.c
@@ -30,6 +30,7 @@
 #include <linux/jbd.h>
 #include <linux/ext3_fs.h>
 #include <linux/ext3_jbd.h>
+#include <trace/events/ext3.h>
 
 /*
  * akpm: A new design for ext3_sync_file().
@@ -51,10 +52,13 @@ int ext3_sync_file(struct file *file, int datasync)
 	int ret, needs_barrier = 0;
 	tid_t commit_tid;
 
+	J_ASSERT(ext3_journal_current_handle() == NULL);
+
+	trace_ext3_sync_file_enter(file, datasync);
+
 	if (inode->i_sb->s_flags & MS_RDONLY)
 		return 0;
 
-	J_ASSERT(ext3_journal_current_handle() == NULL);
 
 	/*
 	 * data=writeback,ordered:
@@ -70,8 +74,10 @@ int ext3_sync_file(struct file *file, int datasync)
 	 *  (they were dirtied by commit).  But that's OK - the blocks are
 	 *  safe in-journal, which is all fsync() needs to ensure.
 	 */
-	if (ext3_should_journal_data(inode))
-		return ext3_force_commit(inode->i_sb);
+	if (ext3_should_journal_data(inode)) {
+		ret = ext3_force_commit(inode->i_sb);
+		goto out;
+	}
 
 	if (datasync)
 		commit_tid = atomic_read(&ei->i_datasync_tid);
@@ -91,5 +97,8 @@ int ext3_sync_file(struct file *file, int datasync)
 	 */
 	if (needs_barrier)
 		blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
+
+out:
+	trace_ext3_sync_file_exit(inode, ret);
 	return ret;
 }
diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
index bfc2dc4..bf09cbf 100644
--- a/fs/ext3/ialloc.c
+++ b/fs/ext3/ialloc.c
@@ -23,6 +23,7 @@
 #include <linux/buffer_head.h>
 #include <linux/random.h>
 #include <linux/bitops.h>
+#include <trace/events/ext3.h>
 
 #include <asm/byteorder.h>
 
@@ -118,6 +119,7 @@ void ext3_free_inode (handle_t *handle, struct inode * inode)
 
 	ino = inode->i_ino;
 	ext3_debug ("freeing inode %lu\n", ino);
+	trace_ext3_free_inode(inode);
 
 	is_directory = S_ISDIR(inode->i_mode);
 
@@ -426,6 +428,7 @@ struct inode *ext3_new_inode(handle_t *handle, struct inode * dir,
 		return ERR_PTR(-EPERM);
 
 	sb = dir->i_sb;
+	trace_ext3_request_inode(dir, mode);
 	inode = new_inode(sb);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
@@ -601,6 +604,7 @@ got:
 	}
 
 	ext3_debug("allocating inode %lu\n", inode->i_ino);
+	trace_ext3_allocate_inode(inode, dir, mode);
 	goto really_out;
 fail:
 	ext3_std_error(sb, err);
diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 68b2e43..e2bedd1 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -38,6 +38,7 @@
 #include <linux/bio.h>
 #include <linux/fiemap.h>
 #include <linux/namei.h>
+#include <trace/events/ext3.h>
 #include "xattr.h"
 #include "acl.h"
 
@@ -70,6 +71,7 @@ int ext3_forget(handle_t *handle, int is_metadata, struct inode *inode,
 
 	might_sleep();
 
+	trace_ext3_forget(inode, is_metadata, blocknr);
 	BUFFER_TRACE(bh, "enter");
 
 	jbd_debug(4, "forgetting bh %p: is_metadata = %d, mode %o, "
@@ -198,6 +200,7 @@ void ext3_evict_inode (struct inode *inode)
 	handle_t *handle;
 	int want_delete = 0;
 
+	trace_ext3_evict_inode(inode);
 	if (!inode->i_nlink && !is_bad_inode(inode)) {
 		dquot_initialize(inode);
 		want_delete = 1;
@@ -842,6 +845,7 @@ int ext3_get_blocks_handle(handle_t *handle, struct inode *inode,
 	ext3_fsblk_t first_block = 0;
 
 
+	trace_ext3_get_blocks_enter(inode, iblock, maxblocks, create);
 	J_ASSERT(handle != NULL || create == 0);
 	depth = ext3_block_to_path(inode,iblock,offsets,&blocks_to_boundary);
 
@@ -970,6 +974,9 @@ cleanup:
 	}
 	BUFFER_TRACE(bh_result, "returned");
 out:
+	trace_ext3_get_blocks_exit(inode, iblock,
+				   le32_to_cpu(chain[depth-1].key),
+				   count, err);
 	return err;
 }
 
@@ -1217,6 +1224,8 @@ static int ext3_write_begin(struct file *file, struct address_space *mapping,
 	 * we allocate blocks but write fails for some reason */
 	int needed_blocks = ext3_writepage_trans_blocks(inode) + 1;
 
+	trace_ext3_write_begin(inode, pos, len, flags);
+
 	index = pos >> PAGE_CACHE_SHIFT;
 	from = pos & (PAGE_CACHE_SIZE - 1);
 	to = from + len;
@@ -1332,6 +1341,7 @@ static int ext3_ordered_write_end(struct file *file,
 	unsigned from, to;
 	int ret = 0, ret2;
 
+	trace_ext3_ordered_write_end(inode, pos, len, copied);
 	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
 
 	from = pos & (PAGE_CACHE_SIZE - 1);
@@ -1367,6 +1377,7 @@ static int ext3_writeback_write_end(struct file *file,
 	struct inode *inode = file->f_mapping->host;
 	int ret;
 
+	trace_ext3_writeback_write_end(inode, pos, len, copied);
 	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
 	update_file_sizes(inode, pos, copied);
 	/*
@@ -1395,6 +1406,7 @@ static int ext3_journalled_write_end(struct file *file,
 	int partial = 0;
 	unsigned from, to;
 
+	trace_ext3_journalled_write_end(inode, pos, len, copied);
 	from = pos & (PAGE_CACHE_SIZE - 1);
 	to = from + len;
 
@@ -1577,6 +1589,7 @@ static int ext3_ordered_writepage(struct page *page,
 	if (ext3_journal_current_handle())
 		goto out_fail;
 
+	trace_ext3_ordered_writepage(inode, page);
 	if (!page_has_buffers(page)) {
 		create_empty_buffers(page, inode->i_sb->s_blocksize,
 				(1 << BH_Dirty)|(1 << BH_Uptodate));
@@ -1647,6 +1660,7 @@ static int ext3_writeback_writepage(struct page *page,
 	if (ext3_journal_current_handle())
 		goto out_fail;
 
+	trace_ext3_writeback_writepage(inode, page);
 	if (page_has_buffers(page)) {
 		if (!walk_page_buffers(NULL, page_buffers(page), 0,
 				      PAGE_CACHE_SIZE, NULL, buffer_unmapped)) {
@@ -1689,6 +1703,7 @@ static int ext3_journalled_writepage(struct page *page,
 	if (ext3_journal_current_handle())
 		goto no_write;
 
+	trace_ext3_journalled_writepage(inode, page);
 	handle = ext3_journal_start(inode, ext3_writepage_trans_blocks(inode));
 	if (IS_ERR(handle)) {
 		ret = PTR_ERR(handle);
@@ -1739,6 +1754,7 @@ out_unlock:
 
 static int ext3_readpage(struct file *file, struct page *page)
 {
+	trace_ext3_readpage(page);
 	return mpage_readpage(page, ext3_get_block);
 }
 
@@ -1753,6 +1769,8 @@ static void ext3_invalidatepage(struct page *page, unsigned long offset)
 {
 	journal_t *journal = EXT3_JOURNAL(page->mapping->host);
 
+	trace_ext3_invalidatepage(page, offset);
+
 	/*
 	 * If it's a full truncate we just forget about the pending dirtying
 	 */
@@ -1766,6 +1784,7 @@ static int ext3_releasepage(struct page *page, gfp_t wait)
 {
 	journal_t *journal = EXT3_JOURNAL(page->mapping->host);
 
+	trace_ext3_releasepage(page);
 	WARN_ON(PageChecked(page));
 	if (!page_has_buffers(page))
 		return 0;
@@ -1794,6 +1813,8 @@ static ssize_t ext3_direct_IO(int rw, struct kiocb *iocb,
 	size_t count = iov_length(iov, nr_segs);
 	int retries = 0;
 
+	trace_ext3_direct_IO_enter(inode, offset, iov_length(iov, nr_segs), rw);
+
 	if (rw == WRITE) {
 		loff_t final_size = offset + count;
 
@@ -1868,6 +1889,8 @@ retry:
 			ret = err;
 	}
 out:
+	trace_ext3_direct_IO_exit(inode, offset,
+				iov_length(iov, nr_segs), rw, ret);
 	return ret;
 }
 
@@ -2446,6 +2469,8 @@ void ext3_truncate(struct inode *inode)
 	unsigned blocksize = inode->i_sb->s_blocksize;
 	struct page *page;
 
+	trace_ext3_truncate_enter(inode);
+
 	if (!ext3_can_truncate(inode))
 		goto out_notrans;
 
@@ -2597,6 +2622,7 @@ out_stop:
 		ext3_orphan_del(handle, inode);
 
 	ext3_journal_stop(handle);
+	trace_ext3_truncate_exit(inode);
 	return;
 out_notrans:
 	/*
@@ -2605,6 +2631,7 @@ out_notrans:
 	 */
 	if (inode->i_nlink)
 		ext3_orphan_del(NULL, inode);
+	trace_ext3_truncate_exit(inode);
 }
 
 static ext3_fsblk_t ext3_get_inode_block(struct super_block *sb,
@@ -2746,6 +2773,7 @@ make_io:
 		 * has in-inode xattrs, or we don't have this inode in memory.
 		 * Read the block from disk.
 		 */
+		trace_ext3_load_inode(inode);
 		get_bh(bh);
 		bh->b_end_io = end_buffer_read_sync;
 		submit_bh(READ_META, bh);
@@ -3372,6 +3400,7 @@ int ext3_mark_inode_dirty(handle_t *handle, struct inode *inode)
 	int err;
 
 	might_sleep();
+	trace_ext3_mark_inode_dirty(inode, _RET_IP_);
 	err = ext3_reserve_inode_write(handle, inode, &iloc);
 	if (!err)
 		err = ext3_mark_iloc_dirty(handle, inode, &iloc);
diff --git a/fs/ext3/namei.c b/fs/ext3/namei.c
index 32f3b86..cb91337 100644
--- a/fs/ext3/namei.c
+++ b/fs/ext3/namei.c
@@ -36,6 +36,7 @@
 #include <linux/quotaops.h>
 #include <linux/buffer_head.h>
 #include <linux/bio.h>
+#include <trace/events/ext3.h>
 
 #include "namei.h"
 #include "xattr.h"
@@ -2135,6 +2136,7 @@ static int ext3_unlink(struct inode * dir, struct dentry *dentry)
 	struct ext3_dir_entry_2 * de;
 	handle_t *handle;
 
+	trace_ext3_unlink_enter(dir, dentry);
 	/* Initialize quotas before so that eventual writes go
 	 * in separate transaction */
 	dquot_initialize(dir);
@@ -2180,6 +2182,7 @@ static int ext3_unlink(struct inode * dir, struct dentry *dentry)
 end_unlink:
 	ext3_journal_stop(handle);
 	brelse (bh);
+	trace_ext3_unlink_exit(dentry, retval);
 	return retval;
 }
 
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 3c6a9e0..f6521fc 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -43,6 +43,9 @@
 #include "acl.h"
 #include "namei.h"
 
+#define CREATE_TRACE_POINTS
+#include <trace/events/ext3.h>
+
 #ifdef CONFIG_EXT3_DEFAULTS_TO_ORDERED
   #define EXT3_MOUNT_DEFAULT_DATA_MODE EXT3_MOUNT_ORDERED_DATA
 #else
@@ -496,6 +499,14 @@ static struct inode *ext3_alloc_inode(struct super_block *sb)
 	return &ei->vfs_inode;
 }
 
+static int ext3_drop_inode(struct inode *inode)
+{
+	int drop = generic_drop_inode(inode);
+
+	trace_ext3_drop_inode(inode, drop);
+	return drop;
+}
+
 static void ext3_i_callback(struct rcu_head *head)
 {
 	struct inode *inode = container_of(head, struct inode, i_rcu);
@@ -787,6 +798,7 @@ static const struct super_operations ext3_sops = {
 	.destroy_inode	= ext3_destroy_inode,
 	.write_inode	= ext3_write_inode,
 	.dirty_inode	= ext3_dirty_inode,
+	.drop_inode	= ext3_drop_inode,
 	.evict_inode	= ext3_evict_inode,
 	.put_super	= ext3_put_super,
 	.sync_fs	= ext3_sync_fs,
@@ -2505,6 +2517,7 @@ static int ext3_sync_fs(struct super_block *sb, int wait)
 {
 	tid_t target;
 
+	trace_ext3_sync_fs(sb, wait);
 	if (journal_start_commit(EXT3_SB(sb)->s_journal, &target)) {
 		if (wait)
 			log_wait_commit(EXT3_SB(sb)->s_journal, target);
diff --git a/include/trace/events/ext3.h b/include/trace/events/ext3.h
new file mode 100644
index 0000000..63f6b8d
--- /dev/null
+++ b/include/trace/events/ext3.h
@@ -0,0 +1,888 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM ext3
+
+#if !defined(_TRACE_EXT3_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_EXT3_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(ext3_free_inode,
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	ino_t,	ino			)
+		__field(	umode_t, mode			)
+		__field(	uid_t,	uid			)
+		__field(	gid_t,	gid			)
+		__field(	blkcnt_t, blocks		)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->mode	= inode->i_mode;
+		__entry->uid	= inode->i_uid;
+		__entry->gid	= inode->i_gid;
+		__entry->blocks	= inode->i_blocks;
+	),
+
+	TP_printk("dev %d,%d ino %lu mode 0%o uid %u gid %u blocks %lu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  __entry->mode, __entry->uid, __entry->gid,
+		  (unsigned long) __entry->blocks)
+);
+
+TRACE_EVENT(ext3_request_inode,
+	TP_PROTO(struct inode *dir, int mode),
+
+	TP_ARGS(dir, mode),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	ino_t,	dir			)
+		__field(	umode_t, mode			)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= dir->i_sb->s_dev;
+		__entry->dir	= dir->i_ino;
+		__entry->mode	= mode;
+	),
+
+	TP_printk("dev %d,%d dir %lu mode 0%o",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->dir, __entry->mode)
+);
+
+TRACE_EVENT(ext3_allocate_inode,
+	TP_PROTO(struct inode *inode, struct inode *dir, int mode),
+
+	TP_ARGS(inode, dir, mode),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	ino_t,	ino			)
+		__field(	ino_t,	dir			)
+		__field(	umode_t, mode			)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->dir	= dir->i_ino;
+		__entry->mode	= mode;
+	),
+
+	TP_printk("dev %d,%d ino %lu dir %lu mode 0%o",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  (unsigned long) __entry->dir, __entry->mode)
+);
+
+TRACE_EVENT(ext3_evict_inode,
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	ino_t,	ino			)
+		__field(	int,	nlink			)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->nlink	= inode->i_nlink;
+	),
+
+	TP_printk("dev %d,%d ino %lu nlink %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino, __entry->nlink)
+);
+
+TRACE_EVENT(ext3_drop_inode,
+	TP_PROTO(struct inode *inode, int drop),
+
+	TP_ARGS(inode, drop),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	ino_t,	ino			)
+		__field(	int,	drop			)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->drop	= drop;
+	),
+
+	TP_printk("dev %d,%d ino %lu drop %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino, __entry->drop)
+);
+
+TRACE_EVENT(ext3_mark_inode_dirty,
+	TP_PROTO(struct inode *inode, unsigned long IP),
+
+	TP_ARGS(inode, IP),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	ino_t,	ino			)
+		__field(unsigned long,	ip			)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->ip	= IP;
+	),
+
+	TP_printk("dev %d,%d ino %lu caller %pF",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino, (void *)__entry->ip)
+);
+
+TRACE_EVENT(ext3_write_begin,
+	TP_PROTO(struct inode *inode, loff_t pos, unsigned int len,
+		 unsigned int flags),
+
+	TP_ARGS(inode, pos, len, flags),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	ino_t,	ino			)
+		__field(	loff_t,	pos			)
+		__field(	unsigned int, len		)
+		__field(	unsigned int, flags		)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->pos	= pos;
+		__entry->len	= len;
+		__entry->flags	= flags;
+	),
+
+	TP_printk("dev %d,%d ino %lu pos %llu len %u flags %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  (unsigned long long) __entry->pos, __entry->len,
+		  __entry->flags)
+);
+
+DECLARE_EVENT_CLASS(ext3__write_end,
+	TP_PROTO(struct inode *inode, loff_t pos, unsigned int len,
+			unsigned int copied),
+
+	TP_ARGS(inode, pos, len, copied),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	ino_t,	ino			)
+		__field(	loff_t,	pos			)
+		__field(	unsigned int, len		)
+		__field(	unsigned int, copied		)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->pos	= pos;
+		__entry->len	= len;
+		__entry->copied	= copied;
+	),
+
+	TP_printk("dev %d,%d ino %lu pos %llu len %u copied %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  (unsigned long long) __entry->pos, __entry->len,
+		  __entry->copied)
+);
+
+DEFINE_EVENT(ext3__write_end, ext3_ordered_write_end,
+
+	TP_PROTO(struct inode *inode, loff_t pos, unsigned int len,
+		 unsigned int copied),
+
+	TP_ARGS(inode, pos, len, copied)
+);
+
+DEFINE_EVENT(ext3__write_end, ext3_writeback_write_end,
+
+	TP_PROTO(struct inode *inode, loff_t pos, unsigned int len,
+		 unsigned int copied),
+
+	TP_ARGS(inode, pos, len, copied)
+);
+
+DEFINE_EVENT(ext3__write_end, ext3_journalled_write_end,
+
+	TP_PROTO(struct inode *inode, loff_t pos, unsigned int len,
+		 unsigned int copied),
+
+	TP_ARGS(inode, pos, len, copied)
+);
+
+DECLARE_EVENT_CLASS(ext3__writepage,
+	TP_PROTO(struct inode *inode, struct page *page),
+
+	TP_ARGS(inode, page),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	ino_t,	ino			)
+		__field(	pgoff_t, index			)
+
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->index	= page->index;
+	),
+
+	TP_printk("dev %d,%d ino %lu page_index %lu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino, __entry->index)
+);
+
+DEFINE_EVENT(ext3__writepage, ext3_ordered_writepage,
+
+	TP_PROTO(struct inode *inode, struct page *page),
+
+	TP_ARGS(inode, page)
+);
+
+DEFINE_EVENT(ext3__writepage, ext3_writeback_writepage,
+
+	TP_PROTO(struct inode *inode, struct page *page),
+
+	TP_ARGS(inode, page)
+);
+
+DEFINE_EVENT(ext3__writepage, ext3_journalled_writepage,
+
+	TP_PROTO(struct inode *inode, struct page *page),
+
+	TP_ARGS(inode, page)
+);
+
+DECLARE_EVENT_CLASS(ext3__page_op,
+	TP_PROTO(struct page *page),
+
+	TP_ARGS(page),
+
+	TP_STRUCT__entry(
+		__field(	pgoff_t, index			)
+		__field(	ino_t,	ino			)
+		__field(	dev_t,	dev			)
+
+	),
+
+	TP_fast_assign(
+		__entry->index	= page->index;
+		__entry->ino	= page->mapping->host->i_ino;
+		__entry->dev	= page->mapping->host->i_sb->s_dev;
+	),
+
+	TP_printk("dev %d,%d ino %lu page_index %lu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  __entry->index)
+);
+
+DEFINE_EVENT(ext3__page_op, ext3_readpage,
+
+	TP_PROTO(struct page *page),
+
+	TP_ARGS(page)
+);
+
+DEFINE_EVENT(ext3__page_op, ext3_releasepage,
+
+	TP_PROTO(struct page *page),
+
+	TP_ARGS(page)
+);
+
+TRACE_EVENT(ext3_invalidatepage,
+	TP_PROTO(struct page *page, unsigned long offset),
+
+	TP_ARGS(page, offset),
+
+	TP_STRUCT__entry(
+		__field(	pgoff_t, index			)
+		__field(	unsigned long, offset		)
+		__field(	ino_t,	ino			)
+		__field(	dev_t,	dev			)
+
+	),
+
+	TP_fast_assign(
+		__entry->index	= page->index;
+		__entry->offset	= offset;
+		__entry->ino	= page->mapping->host->i_ino;
+		__entry->dev	= page->mapping->host->i_sb->s_dev;
+	),
+
+	TP_printk("dev %d,%d ino %lu page_index %lu offset %lu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  __entry->index, __entry->offset)
+);
+
+TRACE_EVENT(ext3_discard_blocks,
+	TP_PROTO(struct super_block *sb, unsigned long blk,
+			unsigned long count),
+
+	TP_ARGS(sb, blk, count),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,		dev		)
+		__field(	unsigned long,	blk		)
+		__field(	unsigned long,	count		)
+
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+		__entry->blk	= blk;
+		__entry->count	= count;
+	),
+
+	TP_printk("dev %d,%d blk %lu count %lu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->blk, __entry->count)
+);
+
+TRACE_EVENT(ext3_request_blocks,
+	TP_PROTO(struct inode *inode, unsigned long goal,
+		 unsigned long count),
+
+	TP_ARGS(inode, goal, count),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	ino_t,	ino			)
+		__field(	unsigned long, count		)
+		__field(	unsigned long,	goal		)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->count	= count;
+		__entry->goal	= goal;
+	),
+
+	TP_printk("dev %d,%d ino %lu count %lu goal %lu ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  __entry->count, __entry->goal)
+);
+
+TRACE_EVENT(ext3_allocate_blocks,
+	TP_PROTO(struct inode *inode, unsigned long goal,
+		 unsigned long count, unsigned long block),
+
+	TP_ARGS(inode, goal, count, block),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	ino_t,	ino			)
+		__field(	unsigned long,	block		)
+		__field(	unsigned long, count		)
+		__field(	unsigned long,	goal		)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->block	= block;
+		__entry->count	= count;
+		__entry->goal	= goal;
+	),
+
+	TP_printk("dev %d,%d ino %lu count %lu block %lu goal %lu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		   __entry->count, __entry->block,
+		  __entry->goal)
+);
+
+TRACE_EVENT(ext3_free_blocks,
+	TP_PROTO(struct inode *inode, unsigned long block,
+		 unsigned long count),
+
+	TP_ARGS(inode, block, count),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	ino_t,	ino			)
+		__field(	umode_t, mode			)
+		__field(	unsigned long,	block		)
+		__field(	unsigned long,	count		)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= inode->i_sb->s_dev;
+		__entry->ino		= inode->i_ino;
+		__entry->mode		= inode->i_mode;
+		__entry->block		= block;
+		__entry->count		= count;
+	),
+
+	TP_printk("dev %d,%d ino %lu mode 0%o block %lu count %lu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  __entry->mode, __entry->block, __entry->count)
+);
+
+TRACE_EVENT(ext3_sync_file_enter,
+	TP_PROTO(struct file *file, int datasync),
+
+	TP_ARGS(file, datasync),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	ino_t,	ino			)
+		__field(	ino_t,	parent			)
+		__field(	int,	datasync		)
+	),
+
+	TP_fast_assign(
+		struct dentry *dentry = file->f_path.dentry;
+
+		__entry->dev		= dentry->d_inode->i_sb->s_dev;
+		__entry->ino		= dentry->d_inode->i_ino;
+		__entry->datasync	= datasync;
+		__entry->parent		= dentry->d_parent->d_inode->i_ino;
+	),
+
+	TP_printk("dev %d,%d ino %lu parent %ld datasync %d ",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  (unsigned long) __entry->parent, __entry->datasync)
+);
+
+TRACE_EVENT(ext3_sync_file_exit,
+	TP_PROTO(struct inode *inode, int ret),
+
+	TP_ARGS(inode, ret),
+
+	TP_STRUCT__entry(
+		__field(	int,	ret			)
+		__field(	ino_t,	ino			)
+		__field(	dev_t,	dev			)
+	),
+
+	TP_fast_assign(
+		__entry->ret		= ret;
+		__entry->ino		= inode->i_ino;
+		__entry->dev		= inode->i_sb->s_dev;
+	),
+
+	TP_printk("dev %d,%d ino %lu ret %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  __entry->ret)
+);
+
+TRACE_EVENT(ext3_sync_fs,
+	TP_PROTO(struct super_block *sb, int wait),
+
+	TP_ARGS(sb, wait),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	int,	wait			)
+
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+		__entry->wait	= wait;
+	),
+
+	TP_printk("dev %d,%d wait %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->wait)
+);
+
+TRACE_EVENT(ext3_rsv_window_add,
+	TP_PROTO(struct super_block *sb,
+		 struct ext3_reserve_window_node *rsv_node),
+
+	TP_ARGS(sb, rsv_node),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	start		)
+		__field(	unsigned long,	end		)
+		__field(	dev_t,	dev			)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+		__entry->start	= rsv_node->rsv_window._rsv_start;
+		__entry->end	= rsv_node->rsv_window._rsv_end;
+	),
+
+	TP_printk("dev %d,%d start %lu end %lu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->start, __entry->end)
+);
+
+TRACE_EVENT(ext3_discard_reservation,
+	TP_PROTO(struct inode *inode,
+		 struct ext3_reserve_window_node *rsv_node),
+
+	TP_ARGS(inode, rsv_node),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	start		)
+		__field(	unsigned long,	end		)
+		__field(	ino_t,	ino			)
+		__field(	dev_t,	dev			)
+	),
+
+	TP_fast_assign(
+		__entry->start	= rsv_node->rsv_window._rsv_start;
+		__entry->end	= rsv_node->rsv_window._rsv_end;
+		__entry->ino	= inode->i_ino;
+		__entry->dev	= inode->i_sb->s_dev;
+	),
+
+	TP_printk("dev %d,%d ino %lu start %lu end %lu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long)__entry->ino, __entry->start,
+		  __entry->end)
+);
+
+TRACE_EVENT(ext3_alloc_new_reservation,
+	TP_PROTO(struct super_block *sb, unsigned long goal),
+
+	TP_ARGS(sb, goal),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	unsigned long,	goal		)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+		__entry->goal	= goal;
+	),
+
+	TP_printk("dev %d,%d goal %lu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->goal)
+);
+
+TRACE_EVENT(ext3_reserved,
+	TP_PROTO(struct super_block *sb, unsigned long block,
+		 struct ext3_reserve_window_node *rsv_node),
+
+	TP_ARGS(sb, block, rsv_node),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	block		)
+		__field(	unsigned long,	start		)
+		__field(	unsigned long,	end		)
+		__field(	dev_t,	dev			)
+	),
+
+	TP_fast_assign(
+		__entry->block	= block;
+		__entry->start	= rsv_node->rsv_window._rsv_start;
+		__entry->end	= rsv_node->rsv_window._rsv_end;
+		__entry->dev	= sb->s_dev;
+	),
+
+	TP_printk("dev %d,%d block %lu, start %lu end %lu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->block, __entry->start, __entry->end)
+);
+
+TRACE_EVENT(ext3_forget,
+	TP_PROTO(struct inode *inode, int is_metadata, unsigned long block),
+
+	TP_ARGS(inode, is_metadata, block),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	ino_t,	ino			)
+		__field(	umode_t, mode			)
+		__field(	int,	is_metadata		)
+		__field(	unsigned long,	block		)
+	),
+
+	TP_fast_assign(
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->ino	= inode->i_ino;
+		__entry->mode	= inode->i_mode;
+		__entry->is_metadata = is_metadata;
+		__entry->block	= block;
+	),
+
+	TP_printk("dev %d,%d ino %lu mode 0%o is_metadata %d block %lu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  __entry->mode, __entry->is_metadata, __entry->block)
+);
+
+TRACE_EVENT(ext3_read_block_bitmap,
+	TP_PROTO(struct super_block *sb, unsigned int group),
+
+	TP_ARGS(sb, group),
+
+	TP_STRUCT__entry(
+		__field(	dev_t,	dev			)
+		__field(	__u32,	group			)
+
+	),
+
+	TP_fast_assign(
+		__entry->dev	= sb->s_dev;
+		__entry->group	= group;
+	),
+
+	TP_printk("dev %d,%d group %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->group)
+);
+
+TRACE_EVENT(ext3_direct_IO_enter,
+	TP_PROTO(struct inode *inode, loff_t offset, unsigned long len, int rw),
+
+	TP_ARGS(inode, offset, len, rw),
+
+	TP_STRUCT__entry(
+		__field(	ino_t,	ino			)
+		__field(	dev_t,	dev			)
+		__field(	loff_t,	pos			)
+		__field(	unsigned long,	len		)
+		__field(	int,	rw			)
+	),
+
+	TP_fast_assign(
+		__entry->ino	= inode->i_ino;
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->pos	= offset;
+		__entry->len	= len;
+		__entry->rw	= rw;
+	),
+
+	TP_printk("dev %d,%d ino %lu pos %llu len %lu rw %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  (unsigned long long) __entry->pos, __entry->len,
+		  __entry->rw)
+);
+
+TRACE_EVENT(ext3_direct_IO_exit,
+	TP_PROTO(struct inode *inode, loff_t offset, unsigned long len,
+		 int rw, int ret),
+
+	TP_ARGS(inode, offset, len, rw, ret),
+
+	TP_STRUCT__entry(
+		__field(	ino_t,	ino			)
+		__field(	dev_t,	dev			)
+		__field(	loff_t,	pos			)
+		__field(	unsigned long,	len		)
+		__field(	int,	rw			)
+		__field(	int,	ret			)
+	),
+
+	TP_fast_assign(
+		__entry->ino	= inode->i_ino;
+		__entry->dev	= inode->i_sb->s_dev;
+		__entry->pos	= offset;
+		__entry->len	= len;
+		__entry->rw	= rw;
+		__entry->ret	= ret;
+	),
+
+	TP_printk("dev %d,%d ino %lu pos %llu len %lu rw %d ret %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  (unsigned long long) __entry->pos, __entry->len,
+		  __entry->rw, __entry->ret)
+);
+
+TRACE_EVENT(ext3_unlink_enter,
+	TP_PROTO(struct inode *parent, struct dentry *dentry),
+
+	TP_ARGS(parent, dentry),
+
+	TP_STRUCT__entry(
+		__field(	ino_t,	parent			)
+		__field(	ino_t,	ino			)
+		__field(	loff_t,	size			)
+		__field(	dev_t,	dev			)
+	),
+
+	TP_fast_assign(
+		__entry->parent		= parent->i_ino;
+		__entry->ino		= dentry->d_inode->i_ino;
+		__entry->size		= dentry->d_inode->i_size;
+		__entry->dev		= dentry->d_inode->i_sb->s_dev;
+	),
+
+	TP_printk("dev %d,%d ino %lu size %lld parent %ld",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  (unsigned long long)__entry->size,
+		  (unsigned long) __entry->parent)
+);
+
+TRACE_EVENT(ext3_unlink_exit,
+	TP_PROTO(struct dentry *dentry, int ret),
+
+	TP_ARGS(dentry, ret),
+
+	TP_STRUCT__entry(
+		__field(	ino_t,	ino			)
+		__field(	dev_t,	dev			)
+		__field(	int,	ret			)
+	),
+
+	TP_fast_assign(
+		__entry->ino		= dentry->d_inode->i_ino;
+		__entry->dev		= dentry->d_inode->i_sb->s_dev;
+		__entry->ret		= ret;
+	),
+
+	TP_printk("dev %d,%d ino %lu ret %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  __entry->ret)
+);
+
+DECLARE_EVENT_CLASS(ext3__truncate,
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode),
+
+	TP_STRUCT__entry(
+		__field(	ino_t,		ino		)
+		__field(	dev_t,		dev		)
+		__field(	blkcnt_t,	blocks		)
+	),
+
+	TP_fast_assign(
+		__entry->ino    = inode->i_ino;
+		__entry->dev    = inode->i_sb->s_dev;
+		__entry->blocks	= inode->i_blocks;
+	),
+
+	TP_printk("dev %d,%d ino %lu blocks %lu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino, (unsigned long) __entry->blocks)
+);
+
+DEFINE_EVENT(ext3__truncate, ext3_truncate_enter,
+
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode)
+);
+
+DEFINE_EVENT(ext3__truncate, ext3_truncate_exit,
+
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode)
+);
+
+TRACE_EVENT(ext3_get_blocks_enter,
+	TP_PROTO(struct inode *inode, unsigned long lblk,
+		 unsigned long len, int create),
+
+	TP_ARGS(inode, lblk, len, create),
+
+	TP_STRUCT__entry(
+		__field(	ino_t,		ino		)
+		__field(	dev_t,		dev		)
+		__field(	unsigned long,	lblk		)
+		__field(	unsigned long,	len		)
+		__field(	int,		create		)
+	),
+
+	TP_fast_assign(
+		__entry->ino    = inode->i_ino;
+		__entry->dev    = inode->i_sb->s_dev;
+		__entry->lblk	= lblk;
+		__entry->len	= len;
+		__entry->create	= create;
+	),
+
+	TP_printk("dev %d,%d ino %lu lblk %lu len %lu create %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		  __entry->lblk, __entry->len, __entry->create)
+);
+
+TRACE_EVENT(ext3_get_blocks_exit,
+	TP_PROTO(struct inode *inode, unsigned long lblk,
+		 unsigned long pblk, unsigned long len, int ret),
+
+	TP_ARGS(inode, lblk, pblk, len, ret),
+
+	TP_STRUCT__entry(
+		__field(	ino_t,		ino		)
+		__field(	dev_t,		dev		)
+		__field(	unsigned long,	lblk		)
+		__field(	unsigned long,	pblk		)
+		__field(	unsigned long,	len		)
+		__field(	int,		ret		)
+	),
+
+	TP_fast_assign(
+		__entry->ino    = inode->i_ino;
+		__entry->dev    = inode->i_sb->s_dev;
+		__entry->lblk	= lblk;
+		__entry->pblk	= pblk;
+		__entry->len	= len;
+		__entry->ret	= ret;
+	),
+
+	TP_printk("dev %d,%d ino %lu lblk %lu pblk %lu len %lu ret %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino,
+		   __entry->lblk, __entry->pblk,
+		  __entry->len, __entry->ret)
+);
+
+TRACE_EVENT(ext3_load_inode,
+	TP_PROTO(struct inode *inode),
+
+	TP_ARGS(inode),
+
+	TP_STRUCT__entry(
+		__field(	ino_t,	ino		)
+		__field(	dev_t,	dev		)
+	),
+
+	TP_fast_assign(
+		__entry->ino		= inode->i_ino;
+		__entry->dev		= inode->i_sb->s_dev;
+	),
+
+	TP_printk("dev %d,%d ino %lu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  (unsigned long) __entry->ino)
+);
+
+#endif /* _TRACE_EXT3_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.4.4

