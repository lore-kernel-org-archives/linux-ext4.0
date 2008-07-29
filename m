From: akpm@linux-foundation.org
Subject: - vfs-pagecache-usage-optimization-onpagesize=blocksize-environment.patch removed from -mm tree
Date: Tue, 29 Jul 2008 13:30:05 -0700
Message-ID: <200807292030.m6TKU5Wp019762@imap1.linux-foundation.org>
To: hifumi.hisashi@oss.ntt.co.jp, hch@infradead.org, jack@ucw.cz,
	linux-ext4@vger.kernel.org, nickpiggin@yahoo.com.au,
	mm-commits@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752565AbYG2UaR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jul 2008 16:30:17 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


The patch titled
     vfs: pagecache usage optimization for pagesize!=blocksize
has been removed from the -mm tree.  Its filename was
     vfs-pagecache-usage-optimization-onpagesize=blocksize-environment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

I wrote a benchmark program and got result number with this program.

This benchmark do:

  1: mount and open a test file.

  2: create a 512MB file.

  3: close a file and umount.

  4: mount and again open a test file.

  5: pwrite randomly 300000 times on a test file.  offset is aligned
     by IO size(1024bytes).

  6: measure time of preading randomly 100000 times on a test file.

The result was:
	2.6.26
        330 sec

	2.6.26-patched
        226 sec

Arch:i386 
Filesystem:ext3
Blocksize:1024 bytes
Memory: 1GB

On ext3/4, a file is written through buffer/block.  So random read/write
mixed workloads or random read after random write workloads are optimized
with this patch under pagesize != blocksize environment.  This test result
showed this.


The benchmark program is as follows:

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mount.h>

#define LEN 1024
#define LOOP 1024*512 /* 512MB */

main(void)
{
	unsigned long i, offset, filesize;
	int fd;
	char buf[LEN];
	time_t t1, t2;

	if (mount("/dev/sda1", "/root/test1/", "ext3", 0, 0) < 0) {
		perror("cannot mount\n");
		exit(1);
	}
	memset(buf, 0, LEN);
	fd = open("/root/test1/testfile", O_CREAT|O_RDWR|O_TRUNC);
	if (fd < 0) {
		perror("cannot open file\n");
		exit(1);
	}
	for (i = 0; i < LOOP; i++)
		write(fd, buf, LEN);
	close(fd);
	if (umount("/root/test1/") < 0) {
		perror("cannot umount\n");
		exit(1);
	}
	if (mount("/dev/sda1", "/root/test1/", "ext3", 0, 0) < 0) {
		perror("cannot mount\n");
		exit(1);
	}
	fd = open("/root/test1/testfile", O_RDWR);
	if (fd < 0) {
		perror("cannot open file\n");
		exit(1);
	}

	filesize = LEN * LOOP;
	for (i = 0; i < 300000; i++){
		offset = (random() % filesize) & (~(LEN - 1));
		pwrite(fd, buf, LEN, offset);
	}
	printf("start test\n");
	time(&t1);
	for (i = 0; i < 100000; i++){
		offset = (random() % filesize) & (~(LEN - 1));
		pread(fd, buf, LEN, offset);
	}
	time(&t2);
	printf("%ld sec\n", t2-t1);
	close(fd);
	if (umount("/root/test1/") < 0) {
		perror("cannot umount\n");
		exit(1);
	}
}

Signed-off-by: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@ucw.cz>
Cc: <linux-ext4@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/buffer.c                 |   46 +++++++++++++++++
 fs/ext2/inode.c             |    1 
 fs/ext3/inode.c             |   67 ++++++++++++------------
 fs/ext4/inode.c             |   92 +++++++++++++++++-----------------
 include/linux/buffer_head.h |    2 
 include/linux/fs.h          |   44 ++++++++--------
 mm/filemap.c                |   14 ++++-
 7 files changed, 167 insertions(+), 99 deletions(-)

diff -puN fs/buffer.c~vfs-pagecache-usage-optimization-onpagesize=blocksize-environment fs/buffer.c
--- a/fs/buffer.c~vfs-pagecache-usage-optimization-onpagesize=blocksize-environment
+++ a/fs/buffer.c
@@ -2096,6 +2096,52 @@ int generic_write_end(struct file *file,
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
@@ -2806,59 +2806,63 @@ static int ext4_journalled_set_page_dirt
 }
 
 static const struct address_space_operations ext4_ordered_aops = {
-	.readpage	= ext4_readpage,
-	.readpages	= ext4_readpages,
-	.writepage	= ext4_normal_writepage,
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
+	.writepage		= ext4_normal_writepage,
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
-	.writepage	= ext4_normal_writepage,
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
+	.writepage		= ext4_normal_writepage,
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
 
 static const struct address_space_operations ext4_da_aops = {
-	.readpage	= ext4_readpage,
-	.readpages	= ext4_readpages,
-	.writepage	= ext4_da_writepage,
-	.writepages	= ext4_da_writepages,
-	.sync_page	= block_sync_page,
-	.write_begin	= ext4_da_write_begin,
-	.write_end	= ext4_da_write_end,
-	.bmap		= ext4_bmap,
-	.invalidatepage	= ext4_da_invalidatepage,
-	.releasepage	= ext4_releasepage,
-	.direct_IO	= ext4_direct_IO,
-	.migratepage	= buffer_migrate_page,
+	.readpage		= ext4_readpage,
+	.readpages		= ext4_readpages,
+	.writepage		= ext4_da_writepage,
+	.writepages		= ext4_da_writepages,
+	.sync_page		= block_sync_page,
+	.write_begin		= ext4_da_write_begin,
+	.write_end		= ext4_da_write_end,
+	.bmap			= ext4_bmap,
+	.invalidatepage		= ext4_da_invalidatepage,
+	.releasepage		= ext4_releasepage,
+	.direct_IO		= ext4_direct_IO,
+	.migratepage		= buffer_migrate_page,
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
@@ -443,6 +443,27 @@ static inline size_t iov_iter_count(stru
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
@@ -484,6 +505,8 @@ struct address_space_operations {
 	int (*migratepage) (struct address_space *,
 			struct page *, struct page *);
 	int (*launder_page) (struct page *);
+	int (*is_partially_uptodate) (struct page *, read_descriptor_t *,
+					unsigned long);
 };
 
 /*
@@ -1198,27 +1221,6 @@ struct block_device_operations {
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
@@ -1023,8 +1023,17 @@ find_page:
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
@@ -1094,6 +1103,7 @@ page_not_up_to_date:
 		if (lock_page_killable(page))
 			goto readpage_eio;
 
+page_not_up_to_date_locked:
 		/* Did it get truncated before we got the lock? */
 		if (!page->mapping) {
 			unlock_page(page);
_

Patches currently in -mm which might be from hifumi.hisashi@oss.ntt.co.jp are


