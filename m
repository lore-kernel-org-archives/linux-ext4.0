From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: [PATCH v1] ext4:Make FIEMAP and delayed allocation play well together.
Date: Fri, 25 Feb 2011 00:15:12 +0800
Message-ID: <1298564112-11078-1-git-send-email-xiaoqiangnk@gmail.com>
Cc: sandeen@redhat.com, Yongqiang Yang <xiaoqiangnk@gmail.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:48782 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab1BXQLz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Feb 2011 11:11:55 -0500
Received: by gxk8 with SMTP id 8so328872gxk.19
        for <linux-ext4@vger.kernel.org>; Thu, 24 Feb 2011 08:11:54 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

1. lookup dirty pages with specified range in pagecache.
   If no page is got, then there is no delayed-extent and
   return with EXT_CONTINUE.
2. find the 1st mapped buffer,
3. check if the mapped buffer is both in the request range
   and a delayed buffer. If not, there is no delayed-extent,
   then return.
4. a delayed-extent is found, the extent will be collected.

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

$ mkfs.ext4 /dev/xxx
$ mount /dev/xxx /mnt
$ dd if=/dev/zero of=/mnt/foo bs=1M count=1 seek=1
$ sync
$ dd if=/dev/zero of=/mnt/foo bs=1M count=1 seek=3
$ dd if=/dev/zero of=/mnt/foo bs=1M count=1 seek=5
$ fiemap-test foo
ext:   0 logical: [     256..     511] phys:    33280..   33535
flags: 0x000 tot: 256
ext:   1 logical: [     768..    1023] phys:        0..     255
flags: 0x006 tot: 256
ext:   2 logical: [    1280..    1535] phys:        0..     255
flags: 0x007 tot: 256

Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
---
 fs/ext4/extents.c |  183 +++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 144 insertions(+), 39 deletions(-)

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ccce8a7..710d46e 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3778,42 +3778,155 @@ int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
 /*
  * Callback function called for each extent to gather FIEMAP information.
  */
+#define NR_PAGES_PER_TIME 128
+
 static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
 		       struct ext4_ext_cache *newex, struct ext4_extent *ex,
 		       void *data)
 {
+	struct page *pages[NR_PAGES_PER_TIME];
+	__u64  logical;
+	__u64  physical;
+	__u64  length;
+
+	loff_t  size = i_size_read(inode);
+	pgoff_t index = 0;
+	ext4_lblk_t end = 0;
+
+	__u32  flags = 0;
+	int	   ret = 0;
 	struct fiemap_extent_info *fieinfo = data;
+
 	unsigned char blksize_bits = inode->i_sb->s_blocksize_bits;
-	__u64	logical;
-	__u64	physical;
-	__u64	length;
-	__u32	flags = 0;
-	int	error;
 
 	logical =  (__u64)newex->ec_block << blksize_bits;
 
 	if (newex->ec_start == 0) {
+		/*
+		 * No extent in extent-tree contains block @newex->ec_start,
+		 * then the block may stay in 1)a hole or 2)delayed-extent.
+		 * 
+ 		 * Holes or delayed-extents are processed as follows.
+		 * 1. lookup dirty pages with specified range in pagecache.
+		 *    If no page is got, then there is no delayed-extent and 
+		 *    return with EXT_CONTINUE. 
+		 * 2. find the 1st mapped buffer,  	 
+		 * 3. check if the mapped buffer is both in the request range 
+		 *    and a delayed buffer. If not, there is no delayed-extent, 
+		 *    then return.
+		 * 4. a delayed-extent is found, the extent will be collected.
+		 */
+		pgoff_t last_offset;
 		pgoff_t offset;
-		struct page *page;
 		struct buffer_head *bh = NULL;
+		struct buffer_head *head = NULL;
+		unsigned int nr_pages = NR_PAGES_PER_TIME;
 
 		offset = logical >> PAGE_SHIFT;
-		page = find_get_page(inode->i_mapping, offset);
-		if (!page || !page_has_buffers(page))
-			return EXT_CONTINUE;
-
-		bh = page_buffers(page);
-
-		if (!bh)
-			return EXT_CONTINUE;
-
-		if (buffer_delay(bh)) {
-			flags |= FIEMAP_EXTENT_DELALLOC;
-			page_cache_release(page);
+repeat:
+		index = 0;	
+		last_offset = offset;
+		head = NULL;	
+		ret = find_get_pages_tag(inode->i_mapping, &offset,
+					PAGECACHE_TAG_DIRTY, nr_pages, pages);
+
+		if (!(flags & FIEMAP_EXTENT_DELALLOC)) {
+			/* First time, try to find a mapped buffer. */
+			if (ret == 0)
+				/* just a hole. */
+				return EXT_CONTINUE;
+		
+			/* Try to find the 1st mapped buffer. */
+			end = ((__u64)pages[0]->index << PAGE_SHIFT) >> blksize_bits; 
+			for (index = 0; index < ret; index ++) {
+				if (!page_has_buffers(pages[index]))
+					goto out;
+				head = page_buffers(pages[index]);
+				if (!head)
+					goto out;
+			
+				bh = head;
+				do {
+					if (buffer_mapped(bh)) {
+						/* get the 1st mapped buffer. */
+						if (end > newex->ec_block + newex->ec_len)
+							/* The buffer is out of the request range. */ 
+							goto out;
+						goto found_mapped_buffer;
+					}
+					bh = bh->b_this_page;
+					end ++;
+				} while (bh != head);
+			}			
+			
+			if (index == ret)
+				/* No mapped buffer found? */
+				BUG();
 		} else {
-			page_cache_release(page);
-			return EXT_CONTINUE;
+			/*Find contiguous delayed buffers. */
+			if (ret > 0 && pages[0]->index == last_offset)
+				head = page_buffers(pages[0]);
+			bh = head;
+		} 
+
+found_mapped_buffer:		
+		if (bh && buffer_delay(bh)) {
+			/* 1st or contiguous delayed buffer found. */
+			if (!(flags & FIEMAP_EXTENT_DELALLOC)) {
+				/* 1st delayed buffer found, record the start of extent. */
+				flags |= FIEMAP_EXTENT_DELALLOC;
+				newex->ec_block = end;
+				logical =  (__u64)end << blksize_bits;
+			}
+			/* Find contiguous delayed buffers. */
+			do {
+				if (!buffer_delay(bh))
+					goto found_delayed_extent;
+				bh = bh->b_this_page;
+				end ++;
+			} while (bh != head);
+
+			for (index ++; index < ret; index ++) {
+				if (!page_has_buffers(pages[index])) {
+					bh = NULL;
+					break;
+				}
+				head = page_buffers(pages[index]);
+				if (!head) {
+					bh = NULL;
+					break;
+				}
+				if (pages[index]->index != pages[0]->index + index) {
+					/* Blocks are not contiguous. */
+					bh = NULL;
+					break;
+				}
+				bh = head;
+				do {
+					if (!buffer_delay(bh))
+						/* Delayed-extent ends. */
+						goto found_delayed_extent;
+					bh = bh->b_this_page;
+					end ++;
+				} while (bh != head); 
+			}
+		} else if (!(flags & FIEMAP_EXTENT_DELALLOC))
+			/* a hole found. */
+			goto out;
+
+found_delayed_extent:
+		newex->ec_len = min(end - newex->ec_block,
+						(ext4_lblk_t)EXT_INIT_MAX_LEN);
+		if (ret == nr_pages && newex->ec_len < EXT_INIT_MAX_LEN 
+			&& bh && buffer_delay(bh)) {
+			/* Have not collected an extent and continue. */
+			for (index =0; index < ret; index ++) 
+				page_cache_release(pages[index]);
+			goto repeat;
 		}
+
+		for (index =0; index < ret; index ++) 
+			page_cache_release(pages[index]);
 	}
 
 	physical = (__u64)newex->ec_start << blksize_bits;
@@ -3822,32 +3935,24 @@ static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
 	if (ex && ext4_ext_is_uninitialized(ex))
 		flags |= FIEMAP_EXTENT_UNWRITTEN;
 
-	/*
-	 * If this extent reaches EXT_MAX_BLOCK, it must be last.
-	 *
-	 * Or if ext4_ext_next_allocated_block is EXT_MAX_BLOCK,
-	 * this also indicates no more allocated blocks.
-	 *
-	 * XXX this might miss a single-block extent at EXT_MAX_BLOCK
-	 */
-	if (ext4_ext_next_allocated_block(path) == EXT_MAX_BLOCK ||
-	    newex->ec_block + newex->ec_len - 1 == EXT_MAX_BLOCK) {
-		loff_t size = i_size_read(inode);
+	if (logical + length >= size) {
 		loff_t bs = EXT4_BLOCK_SIZE(inode->i_sb);
-
-		flags |= FIEMAP_EXTENT_LAST;
-		if ((flags & FIEMAP_EXTENT_DELALLOC) &&
-		    logical+length > size)
+			flags |= FIEMAP_EXTENT_LAST;
+		if (flags & FIEMAP_EXTENT_DELALLOC)
 			length = (size - logical + bs - 1) & ~(bs-1);
 	}
 
-	error = fiemap_fill_next_extent(fieinfo, logical, physical,
+	ret = fiemap_fill_next_extent(fieinfo, logical, physical,
 					length, flags);
-	if (error < 0)
-		return error;
-	if (error == 1)
+	if (ret < 0)
+		return ret;
+	if (ret == 1)
 		return EXT_BREAK;
 
+out:
+	for (index =0; index < ret; index ++) 
+		page_cache_release(pages[index]);
+
 	return EXT_CONTINUE;
 }
 
-- 
1.7.4

