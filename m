From: Ted Ts'o <tytso@mit.edu>
Subject: Re: bug#8411: due to missing sync even on 2.6.39, cp fails to copy
 an odd file
Date: Sat, 2 Apr 2011 19:00:05 -0400
Message-ID: <20110402230005.GL21075@thunk.org>
References: <87fwq0gay0.fsf@rho.meyering.net>
 <4D9724AC.2070009@draigBrady.com>
 <8739m0g3u7.fsf@rho.meyering.net>
 <87d3l4edb1.fsf@rho.meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>,
	8411@debbugs.gnu.org, linux-ext4@vger.kernel.org
To: Jim Meyering <jim@meyering.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:47774 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017Ab1DBXAN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Apr 2011 19:00:13 -0400
Content-Disposition: inline
In-Reply-To: <87d3l4edb1.fsf@rho.meyering.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Apr 02, 2011 at 08:08:34PM +0200, Jim Meyering wrote:
> From 0a6d128d0d17c1604245f1caafe6af73584a0bb8 Mon Sep 17 00:00:00 2001
> From: Jim Meyering <meyering@redhat.com>
> Date: Sat, 2 Apr 2011 19:59:30 +0200
> Subject: [PATCH] copy: require fiemap sync also for 2.6.38 and 2.6.39 kernels
> 
> * src/extent-scan.c (extent_need_sync): Require sync also for 2.6.38
> and 2.6.39.  Without this, part of the cp/fiemap-empty test would fail
> both on F15-to-be and rawhide.  For discussion and details, see:
> http://thread.gmane.org/gmane.comp.gnu.coreutils.bugs/22190

FYI, the following fix has been merged into mainline, which should fix
the problem for 2.6.39 once it is finally released, at least for ext4.
It was merged right before Linus released 2.6.39-rc1.  I'm assuming
that Rawhide released a pre-2.6.39-rc1 kernel in the middle of the
merge window.

Some distro's will informally, but incorrectly, refer to such a
release as "2.6.39-rc0".  I prefer the more technically correct
2.6.38-git18 (which is the first git tag in the Linux git repo which
contained the patch below, as of March 25, 2011).  Unfortunately, RPM
doesn't understand that 2.6.38-rc1 sorts before 2.6.38, while
2.6.38-git17 sorts *after* 2.6.38.  (Hence the incorrect, but
convenient, use of 2.6.39-rc0.)

					- Ted

commit 6d9c85eb700bd3ac59e63bb9de463dea1aca084c
Author: Yongqiang Yang <xiaoqiangnk@gmail.com>
Date:   Sun Feb 27 17:25:47 2011 -0500

    ext4: make FIEMAP and delayed allocation play well together
    
    Fix the FIEMAP ioctl so that it returns all of the page ranges which
    are still subject to delayed allocation.  We were missing some cases
    if the file was sparse.
    
    Reported by Chris Mason <chris.mason@oracle.com>:
    >We've had reports on btrfs that cp is giving us files full of zeros
    >instead of actually copying them.  It was tracked down to a bug with
    >the btrfs fiemap implementation where it was returning holes for
    >delalloc ranges.
    >
    >Newer versions of cp are trusting fiemap to tell it where the holes
    >are, which does seem like a pretty neat trick.
    >
    >I decided to give xfs and ext4 a shot with a few tests cases too, xfs
    >passed with all the ones btrfs was getting wrong, and ext4 got the basic
    >delalloc case right.
    >$ mkfs.ext4 /dev/xxx
    >$ mount /dev/xxx /mnt
    >$ dd if=/dev/zero of=/mnt/foo bs=1M count=1
    >$ fiemap-test foo
    >ext:   0 logical: [       0..     255] phys:        0..     255
    >flags: 0x007 tot: 256
    >
    >Horray!  But once we throw a hole in, things go bad:
    >$ mkfs.ext4 /dev/xxx
    >$ mount /dev/xxx /mnt
    >$ dd if=/dev/zero of=/mnt/foo bs=1M count=1 seek=1
    >$ fiemap-test foo
    >< no output >
    >
    >We've got a delalloc extent after the hole and ext4 fiemap didn't find
    >it.  If I run sync to kick the delalloc out:
    >$sync
    >$ fiemap-test foo
    >ext:   0 logical: [     256..     511] phys:    34048..   34303
    >flags: 0x001 tot: 256
    >
    >fiemap-test is sitting in my /usr/local/bin, and I have no idea how it
    >got there.  It's full of pretty comments so I know it isn't mine, but
    >you can grab it here:
    >
    >http://oss.oracle.com/~mason/fiemap-test.c
    >
    >xfsqa has a fiemap program too.
    
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
    
    Tested-by: Eric Sandeen <sandeen@redhat.com>
    Reviewed-by: Andreas Dilger <adilger@dilger.ca>
    Signed-off-by: Yongqiang Yang <xiaoqiangnk@gmail.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index d16f6b5..9ea1bc6 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -3775,6 +3775,7 @@ int ext4_convert_unwritten_extents(struct inode *inode, loff_t offset,
 	}
 	return ret > 0 ? ret2 : ret;
 }
+
 /*
  * Callback function called for each extent to gather FIEMAP information.
  */
@@ -3782,38 +3783,162 @@ static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
 		       struct ext4_ext_cache *newex, struct ext4_extent *ex,
 		       void *data)
 {
-	struct fiemap_extent_info *fieinfo = data;
-	unsigned char blksize_bits = inode->i_sb->s_blocksize_bits;
 	__u64	logical;
 	__u64	physical;
 	__u64	length;
+	loff_t	size;
 	__u32	flags = 0;
-	int	error;
+	int		ret = 0;
+	struct fiemap_extent_info *fieinfo = data;
+	unsigned char blksize_bits;
 
-	logical =  (__u64)newex->ec_block << blksize_bits;
+	blksize_bits = inode->i_sb->s_blocksize_bits;
+	logical = (__u64)newex->ec_block << blksize_bits;
 
 	if (newex->ec_start == 0) {
-		pgoff_t offset;
-		struct page *page;
+		/*
+		 * No extent in extent-tree contains block @newex->ec_start,
+		 * then the block may stay in 1)a hole or 2)delayed-extent.
+		 *
+		 * Holes or delayed-extents are processed as follows.
+		 * 1. lookup dirty pages with specified range in pagecache.
+		 *    If no page is got, then there is no delayed-extent and
+		 *    return with EXT_CONTINUE.
+		 * 2. find the 1st mapped buffer,
+		 * 3. check if the mapped buffer is both in the request range
+		 *    and a delayed buffer. If not, there is no delayed-extent,
+		 *    then return.
+		 * 4. a delayed-extent is found, the extent will be collected.
+		 */
+		ext4_lblk_t	end = 0;
+		pgoff_t		last_offset;
+		pgoff_t		offset;
+		pgoff_t		index;
+		struct page	**pages = NULL;
 		struct buffer_head *bh = NULL;
+		struct buffer_head *head = NULL;
+		unsigned int nr_pages = PAGE_SIZE / sizeof(struct page *);
+
+		pages = kmalloc(PAGE_SIZE, GFP_KERNEL);
+		if (pages == NULL)
+			return -ENOMEM;
 
 		offset = logical >> PAGE_SHIFT;
-		page = find_get_page(inode->i_mapping, offset);
-		if (!page || !page_has_buffers(page))
-			return EXT_CONTINUE;
+repeat:
+		last_offset = offset;
+		head = NULL;
+		ret = find_get_pages_tag(inode->i_mapping, &offset,
+					PAGECACHE_TAG_DIRTY, nr_pages, pages);
+
+		if (!(flags & FIEMAP_EXTENT_DELALLOC)) {
+			/* First time, try to find a mapped buffer. */
+			if (ret == 0) {
+out:
+				for (index = 0; index < ret; index++)
+					page_cache_release(pages[index]);
+				/* just a hole. */
+				kfree(pages);
+				return EXT_CONTINUE;
+			}
 
-		bh = page_buffers(page);
+			/* Try to find the 1st mapped buffer. */
+			end = ((__u64)pages[0]->index << PAGE_SHIFT) >>
+				  blksize_bits;
+			if (!page_has_buffers(pages[0]))
+				goto out;
+			head = page_buffers(pages[0]);
+			if (!head)
+				goto out;
 
-		if (!bh)
-			return EXT_CONTINUE;
+			bh = head;
+			do {
+				if (buffer_mapped(bh)) {
+					/* get the 1st mapped buffer. */
+					if (end > newex->ec_block +
+						newex->ec_len)
+						/* The buffer is out of
+						 * the request range.
+						 */
+						goto out;
+					goto found_mapped_buffer;
+				}
+				bh = bh->b_this_page;
+				end++;
+			} while (bh != head);
 
-		if (buffer_delay(bh)) {
-			flags |= FIEMAP_EXTENT_DELALLOC;
-			page_cache_release(page);
+			/* No mapped buffer found. */
+			goto out;
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
+		if (bh != NULL && buffer_delay(bh)) {
+			/* 1st or contiguous delayed buffer found. */
+			if (!(flags & FIEMAP_EXTENT_DELALLOC)) {
+				/*
+				 * 1st delayed buffer found, record
+				 * the start of extent.
+				 */
+				flags |= FIEMAP_EXTENT_DELALLOC;
+				newex->ec_block = end;
+				logical = (__u64)end << blksize_bits;
+			}
+			/* Find contiguous delayed buffers. */
+			do {
+				if (!buffer_delay(bh))
+					goto found_delayed_extent;
+				bh = bh->b_this_page;
+				end++;
+			} while (bh != head);
+
+			for (index = 1; index < ret; index++) {
+				if (!page_has_buffers(pages[index])) {
+					bh = NULL;
+					break;
+				}
+				head = page_buffers(pages[index]);
+				if (!head) {
+					bh = NULL;
+					break;
+				}
+				if (pages[index]->index !=
+					pages[0]->index + index) {
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
+					end++;
+				} while (bh != head);
+			}
+		} else if (!(flags & FIEMAP_EXTENT_DELALLOC))
+			/* a hole found. */
+			goto out;
+
+found_delayed_extent:
+		newex->ec_len = min(end - newex->ec_block,
+						(ext4_lblk_t)EXT_INIT_MAX_LEN);
+		if (ret == nr_pages && bh != NULL &&
+			newex->ec_len < EXT_INIT_MAX_LEN &&
+			buffer_delay(bh)) {
+			/* Have not collected an extent and continue. */
+			for (index = 0; index < ret; index++)
+				page_cache_release(pages[index]);
+			goto repeat;
 		}
+
+		for (index = 0; index < ret; index++)
+			page_cache_release(pages[index]);
+		kfree(pages);
 	}
 
 	physical = (__u64)newex->ec_start << blksize_bits;
@@ -3822,32 +3947,16 @@ static int ext4_ext_fiemap_cb(struct inode *inode, struct ext4_ext_path *path,
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
-		loff_t bs = EXT4_BLOCK_SIZE(inode->i_sb);
-
+	size = i_size_read(inode);
+	if (logical + length >= size)
 		flags |= FIEMAP_EXTENT_LAST;
-		if ((flags & FIEMAP_EXTENT_DELALLOC) &&
-		    logical+length > size)
-			length = (size - logical + bs - 1) & ~(bs-1);
-	}
 
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
