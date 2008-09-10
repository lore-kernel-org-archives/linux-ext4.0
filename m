From: Nick Piggin <npiggin@suse.de>
Subject: [patch] fs: revert 8ab22b9a
Date: Wed, 10 Sep 2008 06:52:09 +0200
Message-ID: <20080910045209.GA27092@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
	Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@ucw.cz>,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	L
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:50639 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbYIJEwM (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Sep 2008 00:52:12 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Patch 8ab22b9a, "vfs: pagecache usage optimization for pagesize!=blocksize",
introduces a data race that might cause uninitialized data to be exposed to
userland. The race is conceptually the same as the one fixed for page
uptodateness, fixed by 0ed361de.

The problem is that a buffer_head flags will be set uptodate after the
stores to bring its pagecache data uptodate[*]. This patch introduces a
possibility to read that pagecache data if the buffer_head flag has been
found uptodate. The problem is there are no barriers or locks ordering
the store/store vs the load/load.

To illustrate:
 CPU0: write(2) (1024 bytes)           CPU1: read(2) (1024 bytes)
 1. allocate new pagecache page        A. locate page, not fully uptodate
 2. copy_from_user to part of page     B. partially uptodate? load bh flags
 3. mark that buffer uptodate          C. if yes, then copy_to_user

So if the store 3 is allowed to execute before the store 2, and/or the
load in C is allowed to execute before the load in B, then we can wind
up loading !uptodate data.

[*] Is this always the case? I know we had a *lot* of sites setting the page
    uptodate before even trying to initialize it (because I had to fix them).
    With buffer heads, the problem is potentially worse, because previously
    it would actually be legitimate (though nasty) for the filesystem to mark
    a buffer uptodate before actually bringing it uptodate, provided the page
    is locked... Perhaps the audit has been done, but not by me at any rate.

Anyway, I believe at this point we should revert the patch for 2.6.27 at
least. The problem with allowing the buggy patch to remain is that if we
ever decide that the best fix is to remove it completely, then we can
introduce performance regressions for people who have been using it in
2.6.27.

One way to solve this is to add barriers to the buffer head operations
similarly to the fix for the page issue. The problem is that, unlike the
page race, we don't actually *need* to do that if we decide not to support
this functionality. The barriers are quite heavyweight on some
architectures, and we haven't seen really compelling numbers in favour of
this patch yet (a best-case microbenchmark showed some improvement of
course, but with memory barriers we could also produce a worst-case bench
that shows some slowdown on many architectures).

I was hoping to see a better way to fix this by leveraging some of the
locking rules (eg. page always locked when buffer is brought uptodate).
That is probably the best way to fix it, but that condition does not hold
true for all filesystems at the moment, and would need an audit (and may
need non trivial rework).

Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@ucw.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Nick Piggin <npiggin@suse.de>
---
Index: linux-2.6/fs/buffer.c
===================================================================
--- linux-2.6.orig/fs/buffer.c
+++ linux-2.6/fs/buffer.c
@@ -2096,52 +2096,6 @@ int generic_write_end(struct file *file,
 EXPORT_SYMBOL(generic_write_end);
 
 /*
- * block_is_partially_uptodate checks whether buffers within a page are
- * uptodate or not.
- *
- * Returns true if all buffers which correspond to a file portion
- * we want to read are uptodate.
- */
-int block_is_partially_uptodate(struct page *page, read_descriptor_t *desc,
-					unsigned long from)
-{
-	struct inode *inode = page->mapping->host;
-	unsigned block_start, block_end, blocksize;
-	unsigned to;
-	struct buffer_head *bh, *head;
-	int ret = 1;
-
-	if (!page_has_buffers(page))
-		return 0;
-
-	blocksize = 1 << inode->i_blkbits;
-	to = min_t(unsigned, PAGE_CACHE_SIZE - from, desc->count);
-	to = from + to;
-	if (from < blocksize && to > PAGE_CACHE_SIZE - blocksize)
-		return 0;
-
-	head = page_buffers(page);
-	bh = head;
-	block_start = 0;
-	do {
-		block_end = block_start + blocksize;
-		if (block_end > from && block_start < to) {
-			if (!buffer_uptodate(bh)) {
-				ret = 0;
-				break;
-			}
-			if (block_end >= to)
-				break;
-		}
-		block_start = block_end;
-		bh = bh->b_this_page;
-	} while (bh != head);
-
-	return ret;
-}
-EXPORT_SYMBOL(block_is_partially_uptodate);
-
-/*
  * Generic "read page" function for block devices that have the normal
  * get_block functionality. This is most of the block device filesystems.
  * Reads the page asynchronously --- the unlock_buffer() and
Index: linux-2.6/fs/ext2/inode.c
===================================================================
--- linux-2.6.orig/fs/ext2/inode.c
+++ linux-2.6/fs/ext2/inode.c
@@ -791,7 +791,6 @@ const struct address_space_operations ex
 	.direct_IO		= ext2_direct_IO,
 	.writepages		= ext2_writepages,
 	.migratepage		= buffer_migrate_page,
-	.is_partially_uptodate	= block_is_partially_uptodate,
 };
 
 const struct address_space_operations ext2_aops_xip = {
Index: linux-2.6/fs/ext3/inode.c
===================================================================
--- linux-2.6.orig/fs/ext3/inode.c
+++ linux-2.6/fs/ext3/inode.c
@@ -1767,47 +1767,44 @@ static int ext3_journalled_set_page_dirt
 }
 
 static const struct address_space_operations ext3_ordered_aops = {
-	.readpage		= ext3_readpage,
-	.readpages		= ext3_readpages,
-	.writepage		= ext3_ordered_writepage,
-	.sync_page		= block_sync_page,
-	.write_begin		= ext3_write_begin,
-	.write_end		= ext3_ordered_write_end,
-	.bmap			= ext3_bmap,
-	.invalidatepage		= ext3_invalidatepage,
-	.releasepage		= ext3_releasepage,
-	.direct_IO		= ext3_direct_IO,
-	.migratepage		= buffer_migrate_page,
-	.is_partially_uptodate  = block_is_partially_uptodate,
+	.readpage	= ext3_readpage,
+	.readpages	= ext3_readpages,
+	.writepage	= ext3_ordered_writepage,
+	.sync_page	= block_sync_page,
+	.write_begin	= ext3_write_begin,
+	.write_end	= ext3_ordered_write_end,
+	.bmap		= ext3_bmap,
+	.invalidatepage	= ext3_invalidatepage,
+	.releasepage	= ext3_releasepage,
+	.direct_IO	= ext3_direct_IO,
+	.migratepage	= buffer_migrate_page,
 };
 
 static const struct address_space_operations ext3_writeback_aops = {
-	.readpage		= ext3_readpage,
-	.readpages		= ext3_readpages,
-	.writepage		= ext3_writeback_writepage,
-	.sync_page		= block_sync_page,
-	.write_begin		= ext3_write_begin,
-	.write_end		= ext3_writeback_write_end,
-	.bmap			= ext3_bmap,
-	.invalidatepage		= ext3_invalidatepage,
-	.releasepage		= ext3_releasepage,
-	.direct_IO		= ext3_direct_IO,
-	.migratepage		= buffer_migrate_page,
-	.is_partially_uptodate  = block_is_partially_uptodate,
+	.readpage	= ext3_readpage,
+	.readpages	= ext3_readpages,
+	.writepage	= ext3_writeback_writepage,
+	.sync_page	= block_sync_page,
+	.write_begin	= ext3_write_begin,
+	.write_end	= ext3_writeback_write_end,
+	.bmap		= ext3_bmap,
+	.invalidatepage	= ext3_invalidatepage,
+	.releasepage	= ext3_releasepage,
+	.direct_IO	= ext3_direct_IO,
+	.migratepage	= buffer_migrate_page,
 };
 
 static const struct address_space_operations ext3_journalled_aops = {
-	.readpage		= ext3_readpage,
-	.readpages		= ext3_readpages,
-	.writepage		= ext3_journalled_writepage,
-	.sync_page		= block_sync_page,
-	.write_begin		= ext3_write_begin,
-	.write_end		= ext3_journalled_write_end,
-	.set_page_dirty		= ext3_journalled_set_page_dirty,
-	.bmap			= ext3_bmap,
-	.invalidatepage		= ext3_invalidatepage,
-	.releasepage		= ext3_releasepage,
-	.is_partially_uptodate  = block_is_partially_uptodate,
+	.readpage	= ext3_readpage,
+	.readpages	= ext3_readpages,
+	.writepage	= ext3_journalled_writepage,
+	.sync_page	= block_sync_page,
+	.write_begin	= ext3_write_begin,
+	.write_end	= ext3_journalled_write_end,
+	.set_page_dirty	= ext3_journalled_set_page_dirty,
+	.bmap		= ext3_bmap,
+	.invalidatepage	= ext3_invalidatepage,
+	.releasepage	= ext3_releasepage,
 };
 
 void ext3_set_aops(struct inode *inode)
Index: linux-2.6/fs/ext4/inode.c
===================================================================
--- linux-2.6.orig/fs/ext4/inode.c
+++ linux-2.6/fs/ext4/inode.c
@@ -2949,63 +2949,59 @@ static int ext4_journalled_set_page_dirt
 }
 
 static const struct address_space_operations ext4_ordered_aops = {
-	.readpage		= ext4_readpage,
-	.readpages		= ext4_readpages,
-	.writepage		= ext4_normal_writepage,
-	.sync_page		= block_sync_page,
-	.write_begin		= ext4_write_begin,
-	.write_end		= ext4_ordered_write_end,
-	.bmap			= ext4_bmap,
-	.invalidatepage		= ext4_invalidatepage,
-	.releasepage		= ext4_releasepage,
-	.direct_IO		= ext4_direct_IO,
-	.migratepage		= buffer_migrate_page,
-	.is_partially_uptodate  = block_is_partially_uptodate,
+	.readpage	= ext4_readpage,
+	.readpages	= ext4_readpages,
+	.writepage	= ext4_normal_writepage,
+	.sync_page	= block_sync_page,
+	.write_begin	= ext4_write_begin,
+	.write_end	= ext4_ordered_write_end,
+	.bmap		= ext4_bmap,
+	.invalidatepage	= ext4_invalidatepage,
+	.releasepage	= ext4_releasepage,
+	.direct_IO	= ext4_direct_IO,
+	.migratepage	= buffer_migrate_page,
 };
 
 static const struct address_space_operations ext4_writeback_aops = {
-	.readpage		= ext4_readpage,
-	.readpages		= ext4_readpages,
-	.writepage		= ext4_normal_writepage,
-	.sync_page		= block_sync_page,
-	.write_begin		= ext4_write_begin,
-	.write_end		= ext4_writeback_write_end,
-	.bmap			= ext4_bmap,
-	.invalidatepage		= ext4_invalidatepage,
-	.releasepage		= ext4_releasepage,
-	.direct_IO		= ext4_direct_IO,
-	.migratepage		= buffer_migrate_page,
-	.is_partially_uptodate  = block_is_partially_uptodate,
+	.readpage	= ext4_readpage,
+	.readpages	= ext4_readpages,
+	.writepage	= ext4_normal_writepage,
+	.sync_page	= block_sync_page,
+	.write_begin	= ext4_write_begin,
+	.write_end	= ext4_writeback_write_end,
+	.bmap		= ext4_bmap,
+	.invalidatepage	= ext4_invalidatepage,
+	.releasepage	= ext4_releasepage,
+	.direct_IO	= ext4_direct_IO,
+	.migratepage	= buffer_migrate_page,
 };
 
 static const struct address_space_operations ext4_journalled_aops = {
-	.readpage		= ext4_readpage,
-	.readpages		= ext4_readpages,
-	.writepage		= ext4_journalled_writepage,
-	.sync_page		= block_sync_page,
-	.write_begin		= ext4_write_begin,
-	.write_end		= ext4_journalled_write_end,
-	.set_page_dirty		= ext4_journalled_set_page_dirty,
-	.bmap			= ext4_bmap,
-	.invalidatepage		= ext4_invalidatepage,
-	.releasepage		= ext4_releasepage,
-	.is_partially_uptodate  = block_is_partially_uptodate,
+	.readpage	= ext4_readpage,
+	.readpages	= ext4_readpages,
+	.writepage	= ext4_journalled_writepage,
+	.sync_page	= block_sync_page,
+	.write_begin	= ext4_write_begin,
+	.write_end	= ext4_journalled_write_end,
+	.set_page_dirty	= ext4_journalled_set_page_dirty,
+	.bmap		= ext4_bmap,
+	.invalidatepage	= ext4_invalidatepage,
+	.releasepage	= ext4_releasepage,
 };
 
 static const struct address_space_operations ext4_da_aops = {
-	.readpage		= ext4_readpage,
-	.readpages		= ext4_readpages,
-	.writepage		= ext4_da_writepage,
-	.writepages		= ext4_da_writepages,
-	.sync_page		= block_sync_page,
-	.write_begin		= ext4_da_write_begin,
-	.write_end		= ext4_da_write_end,
-	.bmap			= ext4_bmap,
-	.invalidatepage		= ext4_da_invalidatepage,
-	.releasepage		= ext4_releasepage,
-	.direct_IO		= ext4_direct_IO,
-	.migratepage		= buffer_migrate_page,
-	.is_partially_uptodate  = block_is_partially_uptodate,
+	.readpage	= ext4_readpage,
+	.readpages	= ext4_readpages,
+	.writepage	= ext4_da_writepage,
+	.writepages	= ext4_da_writepages,
+	.sync_page	= block_sync_page,
+	.write_begin	= ext4_da_write_begin,
+	.write_end	= ext4_da_write_end,
+	.bmap		= ext4_bmap,
+	.invalidatepage	= ext4_da_invalidatepage,
+	.releasepage	= ext4_releasepage,
+	.direct_IO	= ext4_direct_IO,
+	.migratepage	= buffer_migrate_page,
 };
 
 void ext4_set_aops(struct inode *inode)
Index: linux-2.6/include/linux/buffer_head.h
===================================================================
--- linux-2.6.orig/include/linux/buffer_head.h
+++ linux-2.6/include/linux/buffer_head.h
@@ -204,8 +204,6 @@ void block_invalidatepage(struct page *p
 int block_write_full_page(struct page *page, get_block_t *get_block,
 				struct writeback_control *wbc);
 int block_read_full_page(struct page*, get_block_t*);
-int block_is_partially_uptodate(struct page *page, read_descriptor_t *desc,
-				unsigned long from);
 int block_write_begin(struct file *, struct address_space *,
 				loff_t, unsigned, unsigned,
 				struct page **, void **, get_block_t*);
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h
+++ linux-2.6/include/linux/fs.h
@@ -443,27 +443,6 @@ static inline size_t iov_iter_count(stru
 	return i->count;
 }
 
-/*
- * "descriptor" for what we're up to with a read.
- * This allows us to use the same read code yet
- * have multiple different users of the data that
- * we read from a file.
- *
- * The simplest case just copies the data to user
- * mode.
- */
-typedef struct {
-	size_t written;
-	size_t count;
-	union {
-		char __user *buf;
-		void *data;
-	} arg;
-	int error;
-} read_descriptor_t;
-
-typedef int (*read_actor_t)(read_descriptor_t *, struct page *,
-		unsigned long, unsigned long);
 
 struct address_space_operations {
 	int (*writepage)(struct page *page, struct writeback_control *wbc);
@@ -505,8 +484,6 @@ struct address_space_operations {
 	int (*migratepage) (struct address_space *,
 			struct page *, struct page *);
 	int (*launder_page) (struct page *);
-	int (*is_partially_uptodate) (struct page *, read_descriptor_t *,
-					unsigned long);
 };
 
 /*
@@ -1221,6 +1198,27 @@ struct block_device_operations {
 	struct module *owner;
 };
 
+/*
+ * "descriptor" for what we're up to with a read.
+ * This allows us to use the same read code yet
+ * have multiple different users of the data that
+ * we read from a file.
+ *
+ * The simplest case just copies the data to user
+ * mode.
+ */
+typedef struct {
+	size_t written;
+	size_t count;
+	union {
+		char __user * buf;
+		void *data;
+	} arg;
+	int error;
+} read_descriptor_t;
+
+typedef int (*read_actor_t)(read_descriptor_t *, struct page *, unsigned long, unsigned long);
+
 /* These macros are for out of kernel modules to test that
  * the kernel supports the unlocked_ioctl and compat_ioctl
  * fields in struct file_operations. */
Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c
+++ linux-2.6/mm/filemap.c
@@ -1023,17 +1023,8 @@ find_page:
 					ra, filp, page,
 					index, last_index - index);
 		}
-		if (!PageUptodate(page)) {
-			if (inode->i_blkbits == PAGE_CACHE_SHIFT ||
-					!mapping->a_ops->is_partially_uptodate)
-				goto page_not_up_to_date;
-			if (!trylock_page(page))
-				goto page_not_up_to_date;
-			if (!mapping->a_ops->is_partially_uptodate(page,
-								desc, offset))
-				goto page_not_up_to_date_locked;
-			unlock_page(page);
-		}
+		if (!PageUptodate(page))
+			goto page_not_up_to_date;
 page_ok:
 		/*
 		 * i_size must be checked after we know the page is Uptodate.
@@ -1103,7 +1094,6 @@ page_not_up_to_date:
 		if (lock_page_killable(page))
 			goto readpage_eio;
 
-page_not_up_to_date_locked:
 		/* Did it get truncated before we got the lock? */
 		if (!page->mapping) {
 			unlock_page(page);
