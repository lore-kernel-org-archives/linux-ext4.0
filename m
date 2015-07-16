From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] ext4: Return the length of a hole from get_block
Date: Thu, 16 Jul 2015 11:46:47 +1000
Message-ID: <20150716014647.GK7943@dastard>
References: <1435936511-17705-1-git-send-email-matthew.r.wilcox@intel.com>
 <20150713151610.GC17075@quack.suse.cz>
 <20150713152615.GH13681@linux.intel.com>
 <20150714090246.GA24369@quack.suse.cz>
 <20150714134851.GK13681@linux.intel.com>
 <20150715095903.GE22609@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthew Wilcox <willy@linux.intel.com>,
	Matthew Wilcox <matthew.r.wilcox@intel.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:32788 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754727AbbGPBs5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 15 Jul 2015 21:48:57 -0400
Content-Disposition: inline
In-Reply-To: <20150715095903.GE22609@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 15, 2015 at 11:59:03AM +0200, Jan Kara wrote:
> On Tue 14-07-15 09:48:51, Matthew Wilcox wrote:
> > On Tue, Jul 14, 2015 at 11:02:46AM +0200, Jan Kara wrote:
> > > On Mon 13-07-15 11:26:15, Matthew Wilcox wrote:
> > > > On Mon, Jul 13, 2015 at 05:16:10PM +0200, Jan Kara wrote:
> > > > > On Fri 03-07-15 11:15:11, Matthew Wilcox wrote:
> > > > > > From: Matthew Wilcox <willy@linux.intel.com>
> > > > > > 
> > > > > > Currently, if ext4's get_block encounters a hole, it does not modify the
> > > > > > buffer_head.  That's fine for many callers, but for DAX, it's useful to
> > > > > > know how large the hole is.  XFS already returns the length of the hole,
> > > > > > so this improvement should not confuse any callers.
> > > > > > 
> > > > > > Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> > > > > 
> > > > > So I'm somewhat wondering: What is the reason of BH_Uptodate flag being
> > > > > set? I can see the XFS sets it in some cases as well but the use of the
> > > > > flag isn't really clear to me...
> > > > 
> > > > No clue.  I'm just following the documentation in buffer.c:
> > > > 
> > > >  * NOTE! All mapped/uptodate combinations are valid:
> > > >  *
> > > >  *      Mapped  Uptodate        Meaning
> > > >  *
> > > >  *      No      No              "unknown" - must do get_block()
> > > >  *      No      Yes             "hole" - zero-filled
> > > >  *      Yes     No              "allocated" - allocated on disk, not read in
> > > >  *      Yes     Yes             "valid" - allocated and up-to-date in memory.
> > > 
> > > OK, but that speaks about buffer head attached to a page. get_block()
> > > callback gets a temporary bh (at least in some cases) only so that it can
> > > communicate result of block mapping. And BH_Uptodate should be set only if
> > > data in the buffer is properly filled (which cannot be the case for
> > > temporary bh which doesn't have *any* data) and it simply isn't the case
> > > even for bh attached to a page because ext4 get_block() functions don't
> > > touch bh->b_data at all. So I just wouldn't set BH_Uptodate in get_block()
> > > at all..
> > 
> > OK, but how should DAX then distinguish between an old-style filesystem
> > (like current ext4) which reports "unknown" and leaves b_size untouched
> > when it encounters a hole, versus a new-style filesystem (XFS, ext4 with
> > this patch) which wants to report the size of a hole in b_size?  The use
> > of Uptodate currently distinguishes the two cases.
> > 
> > Plus, why would you want bh's to be treated differently, depending on
> > whether they're stack-based or attached to a page?  That seems even more
> > confusing than bh's already are.
> 
> Well, you may want to treat them differently because they *are* different.
> For example touching b_size of page-attached buffer_head is a no-go.
> get_block() interface is abusing buffer_head structure for historical
> reasons.
> 
> Seeing you have hit issues with using buffer_head for passing mapping
> information I agree with Dave that we should convert DAX code to use
> iomaps instead of cluttering get_block() via buffer_head further. You can
> lift struct iomap from include/linux/exportfs.h (and related constant
> definitions) and use it for passing map information. It should be quite
> straightforward and simple now that DAX doesn't have many users. We will
> have:
> 
> typedef int (iomap_fn_t)(struct inode *inode, loff_t offset, u64 length,
> 			 bool create, struct iomap *iomap);
> 
> and DAX functions will take this instead of get_block_t. Adding a wrapper
> to ext4_map_blocks() to work as iomap_fn_t is pretty straightforward as
> well.

I've got one of them sitting around in a multipage write patchset
somewhere. See below.

> I'm sorry we didn't come up with this immediately when you started
> implementing DAX...

I thought I did but, IIRC, there were more important things to get
working than an new iomap interface....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

multipage write: Add generic block write begin/end support

From: Dave Chinner <dchinner@redhat.com>

Add support into the generic buffer based IO paths for iomap based
writes. This requires being able to pass the iomap rather than a
get_blocks callback to the mapping functions and mapping buffers
from the iomap rather than a callout. Also provide an exported
write_begin function that takes an iomap rather than an opaque
fsdata blob.

Signed-off-by: Dave Chinner <dchinner@redhat.com>

diff --git a/fs/buffer.c b/fs/buffer.c
index 3e7dca2..02ddaf8 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -21,6 +21,7 @@
 #include <linux/kernel.h>
 #include <linux/syscalls.h>
 #include <linux/fs.h>
+#include <linux/iomap.h>
 #include <linux/mm.h>
 #include <linux/percpu.h>
 #include <linux/slab.h>
@@ -1834,8 +1835,67 @@ void page_zero_new_buffers(struct page *page, unsigned from, unsigned to)
 }
 EXPORT_SYMBOL(page_zero_new_buffers);
 
-int block_prepare_write(struct page *page, unsigned from, unsigned to,
-		get_block_t *get_block)
+static void
+iomap_to_bh(struct inode *inode, sector_t block, struct buffer_head *bh,
+		struct iomap *iomap)
+{
+	loff_t offset = block << inode->i_blkbits;
+
+	printk("iomap_to_bh block %lld\n", block);
+
+	/* XXX: bdev needs to be put into iomap */
+	bh->b_bdev = inode->i_sb->s_bdev;
+
+	/*
+	 * block points to offset in file we need to map, iomap contains
+	 * the offset at which the map starts. If the map ends before the
+	 * current block, then do not map the buffer and let the caller
+	 * handle it.
+	 */
+	if (offset >= iomap->offset + iomap->length)
+		return;
+
+	switch (iomap->type) {
+	case IOMAP_HOLE:
+		/*
+		 * if the buffer is not up to date or beyond the current EOF, we
+		 * need to mark it as new to ensure sub-block zeroing is executed
+		 * if necessary.
+		 */
+		if (!buffer_uptodate(bh) ||
+		    (offset >= i_size_read(inode)))
+			set_buffer_new(bh);
+		break;
+	case IOMAP_DELALLOC:
+		if (!buffer_uptodate(bh) ||
+		    (offset >= i_size_read(inode)))
+			set_buffer_new(bh);
+		set_buffer_uptodate(bh);
+		set_buffer_mapped(bh);
+		set_buffer_delay(bh);
+		break;
+	case IOMAP_UNWRITTEN:
+		/*
+		 * for unwritten regions, we always need to ensure that
+		 * sub-block writes cause the regions in the block we are not
+		 * writing to are zeroed. Set the buffer as new to ensre this.
+		 */
+		set_buffer_new(bh);
+		set_buffer_unwritten(bh);
+		/* fall through */
+	case IOMAP_MAPPED:
+		if (offset >= i_size_read(inode))
+			set_buffer_new(bh);
+		bh->b_blocknr = iomap->blkno +
+				((offset - iomap->offset) >> inode->i_blkbits);
+		set_buffer_mapped(bh);
+		break;
+	}
+
+}
+
+static int __block_prepare_write(struct page *page, unsigned from,
+		unsigned to, int use_get_block, void *map)
 {
 	struct inode *inode = page->mapping->host;
 	unsigned block_start, block_end;
@@ -1849,6 +1909,9 @@ int block_prepare_write(struct page *page, unsigned from, unsigned to,
 	BUG_ON(to > PAGE_CACHE_SIZE);
 	BUG_ON(from > to);
 
+	if (!use_get_block)
+		printk("prep_write from %lld, to %lld\n", from, to);
+
 	blocksize = 1 << inode->i_blkbits;
 	if (!page_has_buffers(page))
 		create_empty_buffers(page, blocksize, 0);
@@ -1871,9 +1934,15 @@ int block_prepare_write(struct page *page, unsigned from, unsigned to,
 			clear_buffer_new(bh);
 		if (!buffer_mapped(bh)) {
 			WARN_ON(bh->b_size != blocksize);
-			err = get_block(inode, block, bh, 1);
-			if (err)
-				break;
+			if (use_get_block) {
+				get_block_t *get_block = map;
+				err = get_block(inode, block, bh, 1);
+				if (err)
+					break;
+			} else {
+				iomap_to_bh(inode, block, bh, map);
+			}
+
 			if (buffer_new(bh)) {
 				unmap_underlying_metadata(bh->b_bdev,
 							bh->b_blocknr);
@@ -1916,6 +1985,12 @@ int block_prepare_write(struct page *page, unsigned from, unsigned to,
 	}
 	return err;
 }
+
+int block_prepare_write(struct page *page, unsigned from, unsigned to,
+		get_block_t *get_block)
+{
+	return __block_prepare_write(page, from, to, 1, get_block);
+}
 EXPORT_SYMBOL(block_prepare_write);
 
 static int __block_commit_write(struct inode *inode, struct page *page,
@@ -1963,6 +2038,41 @@ int __block_write_begin(struct page *page, loff_t pos, unsigned len,
 EXPORT_SYMBOL(__block_write_begin);
 
 /*
+ * Filesystems implementing the new truncate sequence should use the
+ * _newtrunc postfix variant which won't incorrectly call vmtruncate.
+ * The filesystem needs to handle block truncation upon failure.
+ */
+int block_write_begin_iomap(struct address_space *mapping, loff_t pos,
+		unsigned len, unsigned flags, struct page **pagep,
+		void **fsdata)
+{
+	struct iomap *iomap = fsdata;
+	pgoff_t index = pos >> PAGE_CACHE_SHIFT;
+	unsigned start = pos & (PAGE_CACHE_SIZE - 1);
+	struct page *page;
+	int status = 0;
+
+	/* if we are off the iomap, then we are done with it */
+	if (pos >= iomap->offset + iomap->length)
+		return -ERANGE;
+
+	page = grab_cache_page_write_begin(mapping, index, flags);
+	if (!page)
+		return -ENOMEM;
+
+	status = __block_prepare_write(page, start, start + len, 0, fsdata);
+	if (unlikely(status)) {
+		unlock_page(page);
+		page_cache_release(page);
+		page = NULL;
+	}
+
+	*pagep = page;
+	return status;
+}
+EXPORT_SYMBOL(block_write_begin_iomap);
+
+/*
  * block_write_begin takes care of the basic task of block allocation and
  * bringing partial write blocks uptodate first.
  *
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index ec94c12..a9ae5e0 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -205,6 +205,9 @@ int block_is_partially_uptodate(struct page *page, read_descriptor_t *desc,
 				unsigned long from);
 int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
 		unsigned flags, struct page **pagep, get_block_t *get_block);
+int block_write_begin_iomap(struct address_space *mapping, loff_t pos,
+		unsigned len, unsigned flags, struct page **pagep,
+		void **fsdata);
 int __block_write_begin(struct page *page, loff_t pos, unsigned len,
 		get_block_t *get_block);
 int block_write_end(struct file *, struct address_space *,
