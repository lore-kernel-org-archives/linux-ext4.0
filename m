From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: RE: [PATCH] ext4: fix data integrity sync in ordered mode
Date: Fri, 02 May 2014 20:35:56 +0900
Message-ID: <001f01cf65fa$aec13240$0c4396c0$@samsung.com>
References: <004201cf645b$430004f0$c9000ed0$@samsung.com>
 <20140430160118.GB802@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: 'Theodore Ts'o' <tytso@mit.edu>,
	'linux-ext4' <linux-ext4@vger.kernel.org>,
	'Ashish Sangwan' <a.sangwan@samsung.com>
To: 'Jan Kara' <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:53499 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaEBLf6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 2 May 2014 07:35:58 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0N4Y00K3U2VWJM30@mailout1.samsung.com> for
 linux-ext4@vger.kernel.org; Fri, 02 May 2014 20:35:56 +0900 (KST)
In-reply-to: <20140430160118.GB802@quack.suse.cz>
Content-language: ko
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> 
>   Hello,
> 
> On Wed 30-04-14 19:02:14, Namjae Jeon wrote:
> > When we perform a data integrity sync we tag all the dirty pages with
> > PAGECACHE_TAG_TOWRITE at start of ext4_da_writepages.
> > Later we check for this tag in write_cache_pages_da and creates a
> > struct mpage_da_data containing contiguously indexed pages tagged with this
> > tag and sync these pages with a call to mpage_da_map_and_submit.
> > This process is done in while loop until all the PAGECACHE_TAG_TOWRITE pages
> > are synced. We also do journal start and stop in each iteration.
> > journal_stop could initiate journal commit which would call ext4_writepage
> > which in turn will call ext4_bio_write_page even for delayed OR unwritten
> > buffers. When ext4_bio_write_page is called for such buffers, even though it
> > does not sync them but it clears the PAGECACHE_TAG_TOWRITE of the corresponding
> > page and hence these pages are also not synced by the currently running data
> > integrity sync. We will end up with dirty pages although sync is completed.
> >
> > This could cause a potential data loss when the sync call is followed by a
> > truncate_pagecache call, which is exactly the case in collapse_range.
> > (It will cause generic/127 failure in xfstests)
>   This is well spotted. Thanks for finding this bug. See my comment below
> regarding the fix.
> 
> > Cc: stable@vger.kernel.org
> > Cc: Jan kara <jack@suse.de>
> > Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> > Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> > ---
> >  fs/ext4/inode.c | 11 +++++++++--
> >  1 file changed, 9 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index b1dc334..bd85712 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -1865,12 +1865,19 @@ static int ext4_writepage(struct page *page,
> >  	if (ext4_walk_page_buffers(NULL, page_bufs, 0, len, NULL,
> >  				   ext4_bh_delay_or_unwritten)) {
> >  		redirty_page_for_writepage(wbc, page);
> > -		if (current->flags & PF_MEMALLOC) {
> > +		if ((current->flags & PF_MEMALLOC) ||
> > +		     radix_tree_tag_get(&page->mapping->page_tree,
> > +					page->index, PAGECACHE_TAG_TOWRITE)) {
>   I don't think your fix is correct. journal_submit_inode_data_buffers()
> uses WB_SYNC_ALL mode to write the pages and thus all the pages you'll see
> in ext4_writepage() are going to have TOWRITE tag set. And even if that
> wasn't the case you'll have problems when blocksize < pagesize. Because in
> data=ordered mode we want to writeout allocated (mapped) blocks in the page
> to avoid exposure of uninitialized data after a crash (e.g. in case we have
> allocated some blocks in the current transaction but not yet finished
> writing them out and there are other blocks underlying the page which
> aren't allocated yet). Fixing this isn't easy I'm afraid.
> 
> What we could do is to create a variant of set_page_writeback() which
> doesn't clear TOWRITE tag and use that in ext4_bio_write_page() if we are
> writing out just some buffers in a page and leaving other dirty buffers
> behind. It would have a down side that we would be leaving TOWRITE tagged
> pages behind in case when we actually don't race with other writeback but
> I don't see that causing any real problems.

Hi Jan.
Thanks for your reply.

I agree about your opinion. But set_page_writeback is used on many place.
So I think it is expected to change too much if set_page_writeback is modified.

How about change like this ?

diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 4acf1f7..680f12f 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -373,14 +373,14 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 	unsigned block_start, blocksize;
 	struct buffer_head *bh, *head;
 	int ret = 0;
-	int nr_submitted = 0;
+	int nr_submitted = 0, dirty_buffers =0, unmapped_dirty_buffers = 0;
+	bool needs_tag_towrite = 0;
 
 	blocksize = 1 << inode->i_blkbits;
 
 	BUG_ON(!PageLocked(page));
 	BUG_ON(PageWriteback(page));
 
-	set_page_writeback(page);
 	ClearPageError(page);
 
 	/*
@@ -418,6 +418,8 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 				clear_buffer_dirty(bh);
 			if (io->io_bio)
 				ext4_io_submit(io);
+			if ((buffer_delay(bh) || buffer_unwritten(bh)) && buffer_dirty(bh))
+				unmapped_dirty_buffers++;
 			continue;
 		}
 		if (buffer_new(bh)) {
@@ -425,8 +427,21 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 			unmap_underlying_metadata(bh->b_bdev, bh->b_blocknr);
 		}
 		set_buffer_async_write(bh);
+		dirty_buffers++;
 	} while ((bh = bh->b_this_page) != head);
 
+	if (!dirty_buffers) {
+		unlock_page(page);
+		return ret;
+	}
+
+	if (unmapped_dirty_buffers &&
+	    radix_tree_tag_get(&page->mapping->page_tree, page->index,
+			       PAGECACHE_TAG_TOWRITE))
+		needs_tag_towrite = 1;
+
+	set_page_writeback(page);
+
 	/* Now submit buffers to write */
 	bh = head = page_buffers(page);
 	do {
@@ -457,5 +472,10 @@ int ext4_bio_write_page(struct ext4_io_submit *io,
 	/* Nothing submitted - we have to end page writeback */
 	if (!nr_submitted)
 		end_page_writeback(page);
+
+	if (needs_tag_towrite)
+		tag_pages_for_writeback(page->mapping, page->index,
+					page->index);
+	
 	return ret;
}

Thanks!
> 
> 								Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR

