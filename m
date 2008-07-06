From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: New ext4 patchset 2.6.26-rc8-ext4-1
Date: Sat, 5 Jul 2008 22:41:15 -0400
Message-ID: <20080706024115.GH20240@mit.edu>
References: <E1KFBPc-0006yI-Gx@closure.thunk.org> <20080705175047.GA11243@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755491AbYGFCly@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080705175047.GA11243@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Jul 05, 2008 at 01:50:47PM -0400, Christoph Hellwig wrote:
> Strong NACK.  For one thing the code added to mpage.c doesn't belong
> there.  It's far inferior to the existing delalloc code we already have
> and that could be made generic easily, or the next generation code
> developed by Chris mason.  It's an ext4-specific hack and doesn't belong
> into common code.  I'm pretty sure we agreed on not having it in
> common code long ago.

Looking back at the mailing list history, yes, we did.  I think the
reason why we didn't was Andrew had expressed a vague wish that the
ext4 and xfs developers would get together and try to hash out a
common layer that all filesystems could work with.  But given that
nothing has happened in the many months since that discussion, you're
absolutely right.

I've reworked the vfs generic patch in the patch series to be much
smaller --- mainly what's left is simply exporting some mpage
interfaces that would be needed by ext4.  I trust this is much more to
your liking?

						- Ted

commit 2962918ce8fa666bdab5b189cc4ed4b3d08a33f8
Author: Alex Tomas <alex@clusterfs.com>
Date:   Sat Jul 5 21:25:20 2008 -0400

    vfs: add hooks for ext4's delayed allocation support
    
    Export mpage_bio_submit() and __mpage_writepage() for the benefit of
    ext4's delayed allocation support.   Also change __block_write_full_page
    so that if buffers that have the BH_Delay flag set it will call
    get_block() to get the physical block allocated, just as in the
    !BH_Mapped case.
    
    Signed-off-by: Alex Tomas <alex@clusterfs.com>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/buffer.c b/fs/buffer.c
index a413008..d2541a0 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1691,11 +1691,13 @@ static int __block_write_full_page(struct inode *inode, struct page *page,
 			 */
 			clear_buffer_dirty(bh);
 			set_buffer_uptodate(bh);
-		} else if (!buffer_mapped(bh) && buffer_dirty(bh)) {
+		} else if ((!buffer_mapped(bh) || buffer_delay(bh)) &&
+			   buffer_dirty(bh)) {
 			WARN_ON(bh->b_size != blocksize);
 			err = get_block(inode, block, bh, 1);
 			if (err)
 				goto recover;
+			clear_buffer_delay(bh);
 			if (buffer_new(bh)) {
 				/* blockdev mappings never come here */
 				clear_buffer_new(bh);
@@ -1774,7 +1776,8 @@ recover:
 	bh = head;
 	/* Recovery: lock and submit the mapped buffers */
 	do {
-		if (buffer_mapped(bh) && buffer_dirty(bh)) {
+		if (buffer_mapped(bh) && buffer_dirty(bh) &&
+		    !buffer_delay(bh)) {
 			lock_buffer(bh);
 			mark_buffer_async_write(bh);
 		} else {
diff --git a/fs/mpage.c b/fs/mpage.c
index 235e4d3..dbcc7af 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -82,7 +82,7 @@ static void mpage_end_io_write(struct bio *bio, int err)
 	bio_put(bio);
 }
 
-static struct bio *mpage_bio_submit(int rw, struct bio *bio)
+struct bio *mpage_bio_submit(int rw, struct bio *bio)
 {
 	bio->bi_end_io = mpage_end_io_read;
 	if (rw == WRITE)
@@ -90,6 +90,7 @@ static struct bio *mpage_bio_submit(int rw, struct bio *bio)
 	submit_bio(rw, bio);
 	return NULL;
 }
+EXPORT_SYMBOL(mpage_bio_submit);
 
 static struct bio *
 mpage_alloc(struct block_device *bdev,
@@ -435,15 +436,9 @@ EXPORT_SYMBOL(mpage_readpage);
  * written, so it can intelligently allocate a suitably-sized BIO.  For now,
  * just allocate full-size (16-page) BIOs.
  */
-struct mpage_data {
-	struct bio *bio;
-	sector_t last_block_in_bio;
-	get_block_t *get_block;
-	unsigned use_writepage;
-};
 
-static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
-			     void *data)
+int __mpage_writepage(struct page *page, struct writeback_control *wbc,
+		      void *data)
 {
 	struct mpage_data *mpd = data;
 	struct bio *bio = mpd->bio;
@@ -651,6 +646,7 @@ out:
 	mpd->bio = bio;
 	return ret;
 }
+EXPORT_SYMBOL(__mpage_writepage);
 
 /**
  * mpage_writepages - walk the list of dirty pages of the given address space & writepage() all of them
diff --git a/include/linux/mpage.h b/include/linux/mpage.h
index 068a0c9..5c42821 100644
--- a/include/linux/mpage.h
+++ b/include/linux/mpage.h
@@ -11,11 +11,21 @@
  */
 #ifdef CONFIG_BLOCK
 
+struct mpage_data {
+	struct bio *bio;
+	sector_t last_block_in_bio;
+	get_block_t *get_block;
+	unsigned use_writepage;
+};
+
 struct writeback_control;
 
+struct bio *mpage_bio_submit(int rw, struct bio *bio);
 int mpage_readpages(struct address_space *mapping, struct list_head *pages,
 				unsigned nr_pages, get_block_t get_block);
 int mpage_readpage(struct page *page, get_block_t get_block);
+int __mpage_writepage(struct page *page, struct writeback_control *wbc,
+		      void *data);
 int mpage_writepages(struct address_space *mapping,
 		struct writeback_control *wbc, get_block_t get_block);
 int mpage_writepage(struct page *page, get_block_t *get_block,
