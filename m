From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH] ext4:Fix a bug in ext4_ext_fiemap_cb().
Date: Wed, 23 Feb 2011 23:59:39 +0800
Message-ID: <1298476779-27883-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: sandeen@redhat.com, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40221 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab1BWP6Q (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Feb 2011 10:58:16 -0500
Received: by qyg14 with SMTP id 14so2981715qyg.19
        for <linux-ext4@vger.kernel.org>; Wed, 23 Feb 2011 07:58:15 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

1] Delayed extents after a hole are neglected.

   By using find_get_pages() instead of find_get_page() to
   lookup pagecache, delayed extents can be found, because
   find_get_pages() with nr_pages=1 will return the next page
   in pagecache.

2] Extents after a delayed extent or a hole are neglected as well.

   Fix it by accurating the request range by the result of
   ext4_ext_next_allocated_block().

Reported by Chris Mason <chris.mason@oracle.com>:
We've had reports on btrfs that cp is giving us files full of zeros
instead of actually copying them.  It was tracked down to a bug with
the btrfs fiemap implementation where it was returning holes for
delalloc ranges.

Newer versions of cp are trusting fiemap to tell it where the holes
are, which does seem like a pretty neat trick.

I decided to give xfs and ext4 a shot with a few tests cases too, xfs
passed with all the ones btrfs was getting wrong, and ext4 got the basic
delalloc case right.
$ mkfs.ext4 /dev/xxx
$ mount /dev/xxx /mnt
$ dd if=/dev/zero of=/mnt/foo bs=1M count=1
$ fiemap-test foo
ext:   0 logical: [       0..     255] phys:        0..     255 
flags: 0x007 tot: 256

Horray!  But once we throw a hole in, things go bad:
$ mkfs.ext4 /dev/xxx
$ mount /dev/xxx /mnt
$ dd if=/dev/zero of=/mnt/foo bs=1M count=1 seek=1
$ fiemap-test foo
< no output >

We've got a delalloc extent after the hole and ext4 fiemap didn't find
it.  If I run sync to kick the delalloc out:
$sync
$ fiemap-test foo
ext:   0 logical: [     256..     511] phys:    34048..   34303 
flags: 0x001 tot: 256

fiemap-test is sitting in my /usr/local/bin, and I have no idea how it
got there.  It's full of pretty comments so I know it isn't mine, but
you can grab it here:

http://oss.oracle.com/~mason/fiemap-test.c

xfsqa has a fiemap program too.

After Fix, test results are as follows:
ext:   0 logical: [     256..     511] phys:        0..     255 
flags: 0x007 tot: 256
ext:   0 logical: [     256..     511] phys:    33280..   33535 
flags: 0x001 tot: 256

Signe-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/extents.c |   26 +++++++++++++++++++++++---
 mm/filemap.c      |    1 +
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ccce8a7..ad455a0 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3788,17 +3788,27 @@ static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
 	__u64	physical;
 	__u64	length;
 	__u32	flags = 0;
+	ext4_lblk_t end;
 	int	error;
 
 	logical =  (__u64)newex->ec_block << blksize_bits;
 
-	if (newex->ec_start == 0) {
+	if (!newex->ec_start) {
+		/* 
+		 * There is no extent contains @newex->ec_block block.
+		 * It implies that @newex->ec_block block lies 1)a hole 
+		 * or 2)delayed-allocated blocks that has not been
+		 * allocated, so pagecache is needed to lookup. 
+		 *
+		 * And if it is case 2, @newex->ec_len needs to be corrected.
+		 * 
+		 */
 		pgoff_t offset;
 		struct page *page;
 		struct buffer_head *bh = NULL;
 
 		offset = logical >> PAGE_SHIFT;
-		page = find_get_page(inode->i_mapping, offset);
+		(void)find_get_pages(inode->i_mapping, offset, 1, &page);
 		if (!page || !page_has_buffers(page))
 			return EXT_CONTINUE;
 
@@ -3807,8 +3817,13 @@ static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
 		if (!bh)
 			return EXT_CONTINUE;
 
+		/* Assume block-size equals page-size. */
 		if (buffer_delay(bh)) {
 			flags |= FIEMAP_EXTENT_DELALLOC;
+			if (page->index > offset) {
+				logical =  ((__u64)page->index << PAGE_SHIFT);
+				newex->ec_block = logical >> blksize_bits;
+			}	
 			page_cache_release(page);
 		} else {
 			page_cache_release(page);
@@ -3830,7 +3845,8 @@ static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
 	 *
 	 * XXX this might miss a single-block extent at EXT_MAX_BLOCK
 	 */
-	if (ext4_ext_next_allocated_block(path) == EXT_MAX_BLOCK ||
+	end = ext4_ext_next_allocated_block(path);
+	if (end == EXT_MAX_BLOCK ||
 	    newex->ec_block + newex->ec_len - 1 == EXT_MAX_BLOCK) {
 		loff_t size = i_size_read(inode);
 		loff_t bs = EXT4_BLOCK_SIZE(inode->i_sb);
@@ -3839,8 +3855,12 @@ static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
 		if ((flags & FIEMAP_EXTENT_DELALLOC) &&
 		    logical+length > size)
 			length = (size - logical + bs - 1) & ~(bs-1);
+	} else {
+		newex->ec_len = end - newex->ec_block;
+		length = (__u64)newex->ec_len << blksize_bits;
 	}
 
+	
 	error = fiemap_fill_next_extent(fieinfo, logical, physical,
 					length, flags);
 	if (error < 0)
diff --git a/mm/filemap.c b/mm/filemap.c
index 83a45d3..1c01ffc 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -803,6 +803,7 @@ repeat:
 	rcu_read_unlock();
 	return ret;
 }
+EXPORT_SYMBOL(find_get_pages);
 
 /**
  * find_get_pages_contig - gang contiguous pagecache lookup
-- 
1.5.6.5

