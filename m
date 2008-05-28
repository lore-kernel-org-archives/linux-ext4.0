From: akpm@linux-foundation.org
Subject: + vfs-pagecache-usage-optimization-onpagesize=blocksize-environment.patch added to -mm tree
Date: Wed, 28 May 2008 16:23:06 -0700
Message-ID: <200805282323.m4SNND87005575@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Cc: hifumi.hisashi@oss.ntt.co.jp, jack@ucw.cz,
	linux-ext4@vger.kernel.org, nickpiggin@yahoo.com.au
To: mm-commits@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


The patch titled
     vfs: pagecache usage optimization for pagesize!=blocksize
has been added to the -mm tree.  Its filename is
     vfs-pagecache-usage-optimization-onpagesize=blocksize-environment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: pagecache usage optimization for pagesize!=blocksize
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

When we read some part of a file through pagecache, if there is a
pagecache of corresponding index but this page is not uptodate, read IO is
issued and this page will be uptodate.

I think this is good for pagesize == blocksize environment but there is
room for improvement on pagesize != blocksize environment.  Because in
this case a page can have multiple buffers and even if a page is not
uptodate, some buffers can be uptodate.

So I suggest that when all buffers which correspond to a part of a file
that we want to read are uptodate, use this pagecache and copy data from
this pagecache to user buffer even if a page is not uptodate.  This can
reduce read IO and improve system throughput.

Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Jan Kara <jack@ucw.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   46 +++++++++++++++++++++++
 fs/ext2/inode.c             |    1 
 fs/ext3/inode.c             |   67 +++++++++++++++++-----------------
 fs/ext4/inode.c             |   67 +++++++++++++++++-----------------
 include/linux/buffer_head.h |    2 +
 include/linux/fs.h          |   44 +++++++++++-----------
 mm/filemap.c                |   14 ++++++-
 7 files changed, 154 insertions(+), 87 deletions(-)

diff -puN fs/buffer.c~vfs-pagecache-usage-optimization-onpagesize=blocksize-environment fs/buffer.c
--- a/fs/buffer.c~vfs-pagecache-usage-optimization-onpagesize=blocksize-environment
+++ a/fs/buffer.c
@@ -2084,6 +2084,52 @@ int generic_write_end(struct file *file,
 EXPORT_SYMBOL(generic_write_end);
 
 /*
+ * block_is_partially_uptodate checks whether buffers within a page are
+ * uptodate or not.
+ *
+ * Returns true if all buffers which correspond to a file portion
+ * we want to read are uptodate.
+ */
+int block_is_partially_uptodate(struct page *page, read_descriptor_t *desc,
+					unsigned long from)
+{
+	struct inode *inode = page->mapping->host;
+	unsigned block_start, block_end, blocksize;
+	unsigned to;
+	struct buffer_head *bh, *head;
+	int ret = 1;
+
+	if (!page_has_buffers(page))
+		return 0;
+
+	blocksize = 1 << inode->i_blkbits;
+	to = min_t(unsigned, PAGE_CACHE_SIZE - from, desc->count);
+	to = from + to;
+	if (from < blocksize && to > PAGE_CACHE_SIZE - blocksize)
+		return 0;
+
+	head = page_buffers(page);
+	bh = head;
+	block_start = 0;
+	do {
+		block_end = block_start + blocksize;
+		if (block_end > from && block_start < to) {
+			if (!buffer_uptodate(bh)) {
+				ret = 0;
+				break;
+			}
+			if (block_end >= to)
+				break;
+		}
+		block_start = block_end;
+		bh = bh->b_this_page;
+	} while (bh != head);
+
+	return ret;
+}
+EXPORT_SYMBOL(block_is_partially_uptodate);
+
+/*
  * Generic "read page" function for block devices that have the normal
  * get_block functionality. This is most of the block device filesystems.
  * Reads the page asynchronously --- the unlock_buffer() and
diff -puN fs/ext2/inode.c~vfs-pagecache-usage-optimization-onpagesize=blocksize-environment fs/ext2/inode.c
--- a/fs/ext2/inode.c~vfs-pagecache-usage-optimization-onpagesize=blocksize-environment
+++ a/fs/ext2/inode.c
@@ -791,6 +791,7 @@ const struct address_space_operations ex
 	.direct_IO		= ext2_direct_IO,
 	.writepages		= ext2_writepages,
 	.migratepage		= buffer_migrate_page,
+	.is_partially_uptodate	= block_is_partially_uptodate,
 };
 
 const struct address_space_operations ext2_aops_xip = {
diff -puN fs/ext3/inode.c~vfs-pagecache-usage-optimization-onpagesize=blocksize-environment fs/ext3/inode.c
--- a/fs/ext3/inode.c~vfs-pagecache-usage-optimization-onpagesize=blocksize-environment
+++ a/fs/ext3/inode.c
@@ -1767,44 +1767,47 @@ static int ext3_journalled_set_page_dirt
 }
 
 static const struct address_space_operations ext3_ordered_aops = {
-	.readpage	= ext3_readpage,
-	.readpages	= ext3_readpages,
-	.writepage	= ext3_ordered_writepage,
-	.sync_page	= block_sync_page,
-	.write_begin	= ext3_write_begin,
-	.write_end	= ext3_ordered_write_end,
-	.bmap		= ext3_bmap,
-	.invalidatepage	= ext3_invalidatepage,
-	.releasepage	= ext3_releasepage,
-	.direct_IO	= ext3_direct_IO,
-	.migratepage	= buffer_migrate_page,
+	.readpage		= ext3_readpage,
+	.readpages		= ext3_readpages,
+	.writepage		= ext3_ordered_writepage,
+	.sync_page		= block_sync_page,
+	.write_begin		= ext3_write_begin,
+	.write_end		= ext3_ordered_write_end,
+	.bmap			= ext3_bmap,
+	.invalidatepage		= ext3_invalidatepage,
+	.releasepage		= ext3_releasepage,
+	.direct_IO		= ext3_direct_IO,
+	.migratepage		= buffer_migrate_page,
+	.is_partially_uptodate  = block_is_partially_uptodate,
 };
 
 static const struct address_space_operations ext3_writeback_aops = {
-	.readpage	= ext3_readpage,
-	.readpages	= ext3_readpages,
-	.writepage	= ext3_writeback_writepage,
-	.sync_page	= block_sync_page,
-	.write_begin	= ext3_write_begin,
-	.write_end	= ext3_writeback_write_end,
-	.bmap		= ext3_bmap,
-	.invalidatepage	= ext3_invalidatepage,
-	.releasepage	= ext3_releasepage,
-	.direct_IO	= ext3_direct_IO,
-	.migratepage	= buffer_migrate_page,
+	.readpage		= ext3_readpage,
+	.readpages		= ext3_readpages,
+	.writepage		= ext3_writeback_writepage,
+	.sync_page		= block_sync_page,
+	.write_begin		= ext3_write_begin,
+	.write_end		= ext3_writeback_write_end,
+	.bmap			= ext3_bmap,
+	.invalidatepage		= ext3_invalidatepage,
+	.releasepage		= ext3_releasepage,
+	.direct_IO		= ext3_direct_IO,
+	.migratepage		= buffer_migrate_page,
+	.is_partially_uptodate  = block_is_partially_uptodate,
 };
 
 static const struct address_space_operations ext3_journalled_aops = {
-	.readpage	= ext3_readpage,
-	.readpages	= ext3_readpages,
-	.writepage	= ext3_journalled_writepage,
-	.sync_page	= block_sync_page,
-	.write_begin	= ext3_write_begin,
-	.write_end	= ext3_journalled_write_end,
-	.set_page_dirty	= ext3_journalled_set_page_dirty,
-	.bmap		= ext3_bmap,
-	.invalidatepage	= ext3_invalidatepage,
-	.releasepage	= ext3_releasepage,
+	.readpage		= ext3_readpage,
+	.readpages		= ext3_readpages,
+	.writepage		= ext3_journalled_writepage,
+	.sync_page		= block_sync_page,
+	.write_begin		= ext3_write_begin,
+	.write_end		= ext3_journalled_write_end,
+	.set_page_dirty		= ext3_journalled_set_page_dirty,
+	.bmap			= ext3_bmap,
+	.invalidatepage		= ext3_invalidatepage,
+	.releasepage		= ext3_releasepage,
+	.is_partially_uptodate  = block_is_partially_uptodate,
 };
 
 void ext3_set_aops(struct inode *inode)
diff -puN fs/ext4/inode.c~vfs-pagecache-usage-optimization-onpagesize=blocksize-environment fs/ext4/inode.c
--- a/fs/ext4/inode.c~vfs-pagecache-usage-optimization-onpagesize=blocksize-environment
+++ a/fs/ext4/inode.c
@@ -1821,44 +1821,47 @@ static int ext4_journalled_set_page_dirt
 }
 
 static const struct address_space_operations ext4_ordered_aops = {
-	.readpage	= ext4_readpage,
-	.readpages	= ext4_readpages,
-	.writepage	= ext4_ordered_writepage,
-	.sync_page	= block_sync_page,
-	.write_begin	= ext4_write_begin,
-	.write_end	= ext4_ordered_write_end,
-	.bmap		= ext4_bmap,
-	.invalidatepage	= ext4_invalidatepage,
-	.releasepage	= ext4_releasepage,
-	.direct_IO	= ext4_direct_IO,
-	.migratepage	= buffer_migrate_page,
+	.readpage		= ext4_readpage,
+	.readpages		= ext4_readpages,
+	.writepage		= ext4_ordered_writepage,
+	.sync_page		= block_sync_page,
+	.write_begin		= ext4_write_begin,
+	.write_end		= ext4_ordered_write_end,
+	.bmap			= ext4_bmap,
+	.invalidatepage		= ext4_invalidatepage,
+	.releasepage		= ext4_releasepage,
+	.direct_IO		= ext4_direct_IO,
+	.migratepage		= buffer_migrate_page,
+	.is_partially_uptodate  = block_is_partially_uptodate,
 };
 
 static const struct address_space_operations ext4_writeback_aops = {
-	.readpage	= ext4_readpage,
-	.readpages	= ext4_readpages,
-	.writepage	= ext4_writeback_writepage,
-	.sync_page	= block_sync_page,
-	.write_begin	= ext4_write_begin,
-	.write_end	= ext4_writeback_write_end,
-	.bmap		= ext4_bmap,
-	.invalidatepage	= ext4_invalidatepage,
-	.releasepage	= ext4_releasepage,
-	.direct_IO	= ext4_direct_IO,
-	.migratepage	= buffer_migrate_page,
+	.readpage		= ext4_readpage,
+	.readpages		= ext4_readpages,
+	.writepage		= ext4_writeback_writepage,
+	.sync_page		= block_sync_page,
+	.write_begin		= ext4_write_begin,
+	.write_end		= ext4_writeback_write_end,
+	.bmap			= ext4_bmap,
+	.invalidatepage		= ext4_invalidatepage,
+	.releasepage		= ext4_releasepage,
+	.direct_IO		= ext4_direct_IO,
+	.migratepage		= buffer_migrate_page,
+	.is_partially_uptodate  = block_is_partially_uptodate,
 };
 
 static const struct address_space_operations ext4_journalled_aops = {
-	.readpage	= ext4_readpage,
-	.readpages	= ext4_readpages,
-	.writepage	= ext4_journalled_writepage,
-	.sync_page	= block_sync_page,
-	.write_begin	= ext4_write_begin,
-	.write_end	= ext4_journalled_write_end,
-	.set_page_dirty	= ext4_journalled_set_page_dirty,
-	.bmap		= ext4_bmap,
-	.invalidatepage	= ext4_invalidatepage,
-	.releasepage	= ext4_releasepage,
+	.readpage		= ext4_readpage,
+	.readpages		= ext4_readpages,
+	.writepage		= ext4_journalled_writepage,
+	.sync_page		= block_sync_page,
+	.write_begin		= ext4_write_begin,
+	.write_end		= ext4_journalled_write_end,
+	.set_page_dirty		= ext4_journalled_set_page_dirty,
+	.bmap			= ext4_bmap,
+	.invalidatepage		= ext4_invalidatepage,
+	.releasepage		= ext4_releasepage,
+	.is_partially_uptodate  = block_is_partially_uptodate,
 };
 
 void ext4_set_aops(struct inode *inode)
diff -puN include/linux/buffer_head.h~vfs-pagecache-usage-optimization-onpagesize=blocksize-environment include/linux/buffer_head.h
--- a/include/linux/buffer_head.h~vfs-pagecache-usage-optimization-onpagesize=blocksize-environment
+++ a/include/linux/buffer_head.h
@@ -205,6 +205,8 @@ void block_invalidatepage(struct page *p
 int block_write_full_page(struct page *page, get_block_t *get_block,
 				struct writeback_control *wbc);
 int block_read_full_page(struct page*, get_block_t*);
+int block_is_partially_uptodate(struct page *page, read_descriptor_t *desc,
+				unsigned long from);
 int block_write_begin(struct file *, struct address_space *,
 				loff_t, unsigned, unsigned,
 				struct page **, void **, get_block_t*);
diff -puN include/linux/fs.h~vfs-pagecache-usage-optimization-onpagesize=blocksize-environment include/linux/fs.h
--- a/include/linux/fs.h~vfs-pagecache-usage-optimization-onpagesize=blocksize-environment
+++ a/include/linux/fs.h
@@ -444,6 +444,27 @@ static inline size_t iov_iter_count(stru
 	return i->count;
 }
 
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
+		char __user *buf;
+		void *data;
+	} arg;
+	int error;
+} read_descriptor_t;
+
+typedef int (*read_actor_t)(read_descriptor_t *, struct page *,
+		unsigned long, unsigned long);
 
 struct address_space_operations {
 	int (*writepage)(struct page *page, struct writeback_control *wbc);
@@ -485,6 +506,8 @@ struct address_space_operations {
 	int (*migratepage) (struct address_space *,
 			struct page *, struct page *);
 	int (*launder_page) (struct page *);
+	int (*is_partially_uptodate) (struct page *, read_descriptor_t *,
+					unsigned long);
 };
 
 /*
@@ -1193,27 +1216,6 @@ struct block_device_operations {
 	struct module *owner;
 };
 
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
-		char __user * buf;
-		void *data;
-	} arg;
-	int error;
-} read_descriptor_t;
-
-typedef int (*read_actor_t)(read_descriptor_t *, struct page *, unsigned long, unsigned long);
-
 /* These macros are for out of kernel modules to test that
  * the kernel supports the unlocked_ioctl and compat_ioctl
  * fields in struct file_operations. */
diff -puN mm/filemap.c~vfs-pagecache-usage-optimization-onpagesize=blocksize-environment mm/filemap.c
--- a/mm/filemap.c~vfs-pagecache-usage-optimization-onpagesize=blocksize-environment
+++ a/mm/filemap.c
@@ -929,8 +929,17 @@ find_page:
 					ra, filp, page,
 					index, last_index - index);
 		}
-		if (!PageUptodate(page))
-			goto page_not_up_to_date;
+		if (!PageUptodate(page)) {
+			if (inode->i_blkbits == PAGE_CACHE_SHIFT ||
+					!mapping->a_ops->is_partially_uptodate)
+				goto page_not_up_to_date;
+			if (TestSetPageLocked(page))
+				goto page_not_up_to_date;
+			if (!mapping->a_ops->is_partially_uptodate(page,
+								desc, offset))
+				goto page_not_up_to_date_locked;
+			unlock_page(page);
+		}
 page_ok:
 		/*
 		 * i_size must be checked after we know the page is Uptodate.
@@ -1000,6 +1009,7 @@ page_not_up_to_date:
 		if (lock_page_killable(page))
 			goto readpage_eio;
 
+page_not_up_to_date_locked:
 		/* Did it get truncated before we got the lock? */
 		if (!page->mapping) {
 			unlock_page(page);
_

Patches currently in -mm which might be from hifumi.hisashi@oss.ntt.co.jp are

vfs-pagecache-usage-optimization-onpagesize=blocksize-environment.patch

