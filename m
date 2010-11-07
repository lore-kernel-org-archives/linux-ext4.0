From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH -BUGFIX] Re: BUG in ext4 with 2.6.37-rc1
Date: Sun, 7 Nov 2010 16:21:43 -0500
Message-ID: <20101107212143.GA28396@thunk.org>
References: <20101102202013.GA3861@elliptictech.com>
 <20101103181412.GH25614@thunk.org>
 <20101103182229.GA8766@elliptictech.com>
 <20101103205306.GA3627@elliptictech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38806 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823Ab0KGVVu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 7 Nov 2010 16:21:50 -0500
Content-Disposition: inline
In-Reply-To: <20101103205306.GA3627@elliptictech.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 03, 2010 at 04:53:06PM -0400, Nick Bowler wrote:
> 
> OK, it's 100% reproducible: the kernel BUGs, without fail, every time I
> do 'make install' in the gcc build tree.  After applying the patch, it
> seems that the original BUG is gone, but now there's a new one:

OK, I think I have a new version of the patch that should fix both the
original and the second BUG_ON which you reported.  Unfortunately,
I've not been able to reproduce the BUG_ON, even by downloading gcc
4.5.1, configuring to build just gcc, and then doing a "make install".
I'm not sure what languages you had enabled, or how much memory you
have on your machine, etc., all of which might have made it harder for
me to repro the bug.  Still, I think I now understand what's causing
it.

Can you give this a try and let me know if this fixes things for you?

    	     	    	    	   	   - Ted

>From 94acf883b316f50b38018f710341a943cdd38d0d Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Sun, 7 Nov 2010 16:11:42 -0500
Subject: [PATCH -v2] ext4: handle writeback of inodes which are being freed

The following BUG can occur when an inode which is getting freed when
it still has dirty pages outstanding, and it gets deleted (in this
because it was the target of a rename).  In ordered mode, we need to
make sure the data pages are written just in case we crash before the
rename (or unlink) is committed.  If the inode is being freed then
when we try to igrab the inode, we end up tripping the BUG_ON at
fs/ext4/page-io.c:146.

In this case, don't need to do any of the endio handling, so we can
drop the BUG_ON and then arrange to make ext4_bio_end() handle this
case appropriately by releasing the pages and ending the writeback on
those pages, and then returning early without queueing the io_end
structure on the workqueue.

  kernel BUG at /scratch_space/linux-2.6/fs/ext4/page-io.c:146!
  Call Trace:
   [<ffffffff811075b1>] ext4_bio_write_page+0x172/0x307
   [<ffffffff811033a7>] mpage_da_submit_io+0x2f9/0x37b
   [<ffffffff811068d7>] mpage_da_map_and_submit+0x2cc/0x2e2
   [<ffffffff811069b3>] mpage_add_bh_to_extent+0xc6/0xd5
   [<ffffffff81106c66>] write_cache_pages_da+0x2a4/0x3ac
   [<ffffffff81107044>] ext4_da_writepages+0x2d6/0x44d
   [<ffffffff81087910>] do_writepages+0x1c/0x25
   [<ffffffff810810a4>] __filemap_fdatawrite_range+0x4b/0x4d
   [<ffffffff810815f5>] filemap_fdatawrite_range+0xe/0x10
   [<ffffffff81122a2e>] jbd2_journal_begin_ordered_truncate+0x7b/0xa2
   [<ffffffff8110615d>] ext4_evict_inode+0x57/0x24c
   [<ffffffff810c14a3>] evict+0x22/0x92
   [<ffffffff810c1a3d>] iput+0x212/0x249
   [<ffffffff810bdf16>] dentry_iput+0xa1/0xb9
   [<ffffffff810bdf6b>] d_kill+0x3d/0x5d
   [<ffffffff810be613>] dput+0x13a/0x147
   [<ffffffff810b990d>] sys_renameat+0x1b5/0x258
   [<ffffffff81145f71>] ? _atomic_dec_and_lock+0x2d/0x4c
   [<ffffffff810b2950>] ? cp_new_stat+0xde/0xea
   [<ffffffff810b29c1>] ? sys_newlstat+0x2d/0x38
   [<ffffffff810b99c6>] sys_rename+0x16/0x18
   [<ffffffff81002a2b>] system_call_fastpath+0x16/0x1b

Reported-by: Nick Bowler <nbowler@elliptictech.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/page-io.c |   45 ++++++++++++++++++++++-----------------------
 1 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 46a7d6a..94bbdb4 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -143,7 +143,6 @@ ext4_io_end_t *ext4_init_io_end(struct inode *inode, gfp_t flags)
 	if (io) {
 		memset(io, 0, sizeof(*io));
 		io->inode = igrab(inode);
-		BUG_ON(!io->inode);
 		INIT_WORK(&io->work, ext4_end_io_work);
 		INIT_LIST_HEAD(&io->list);
 	}
@@ -171,35 +170,15 @@ static void ext4_end_bio(struct bio *bio, int error)
 	struct workqueue_struct *wq;
 	struct inode *inode;
 	unsigned long flags;
-	ext4_fsblk_t err_block;
 	int i;
 
 	BUG_ON(!io_end);
-	inode = io_end->inode;
 	bio->bi_private = NULL;
 	bio->bi_end_io = NULL;
 	if (test_bit(BIO_UPTODATE, &bio->bi_flags))
 		error = 0;
-	err_block = bio->bi_sector >> (inode->i_blkbits - 9);
 	bio_put(bio);
 
-	if (!(inode->i_sb->s_flags & MS_ACTIVE)) {
-		pr_err("sb umounted, discard end_io request for inode %lu\n",
-			io_end->inode->i_ino);
-		ext4_free_io_end(io_end);
-		return;
-	}
-
-	if (error) {
-		io_end->flag |= EXT4_IO_END_ERROR;
-		ext4_warning(inode->i_sb, "I/O error writing to inode %lu "
-			     "(offset %llu size %ld starting block %llu)",
-			     inode->i_ino,
-			     (unsigned long long) io_end->offset,
-			     (long) io_end->size,
-			     (unsigned long long) err_block);
-	}
-
 	for (i = 0; i < io_end->num_io_pages; i++) {
 		struct page *page = io_end->pages[i]->p_page;
 		struct buffer_head *bh, *head;
@@ -254,9 +233,30 @@ static void ext4_end_bio(struct bio *bio, int error)
 		if (!partial_write)
 			SetPageUptodate(page);
 	}
-
 	io_end->num_io_pages = 0;
 
+	if ((inode = io_end->inode) == NULL)
+		goto no_work;
+
+	if (!(inode->i_sb->s_flags & MS_ACTIVE)) {
+		pr_err("sb umounted, discard end_io request for inode %lu\n",
+			io_end->inode->i_ino);
+	no_work:
+		ext4_free_io_end(io_end);
+		return;
+	}
+
+	if (error) {
+		io_end->flag |= EXT4_IO_END_ERROR;
+		ext4_warning(inode->i_sb, "I/O error writing to inode %lu "
+			     "(offset %llu size %ld starting block %llu)",
+			     inode->i_ino,
+			     (unsigned long long) io_end->offset,
+			     (long) io_end->size,
+			     (unsigned long long)
+			     bio->bi_sector >> (inode->i_blkbits - 9));
+	}
+
 	/* Add the io_end to per-inode completed io list*/
 	spin_lock_irqsave(&EXT4_I(inode)->i_completed_io_lock, flags);
 	list_add_tail(&io_end->list, &EXT4_I(inode)->i_completed_io_list);
@@ -305,7 +305,6 @@ static int io_submit_init(struct ext4_io_submit *io,
 	bio->bi_private = io->io_end = io_end;
 	bio->bi_end_io = ext4_end_bio;
 
-	io_end->inode = inode;
 	io_end->offset = (page->index << PAGE_CACHE_SHIFT) + bh_offset(bh);
 
 	io->io_bio = bio;
-- 
1.7.3.1

