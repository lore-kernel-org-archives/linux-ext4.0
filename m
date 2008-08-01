From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Rework the ext4_da_writepages
Date: Fri, 1 Aug 2008 10:37:25 +0530
Message-ID: <20080801050725.GC25255@skywalker>
References: <1217525605-23000-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080731201055.GM3292@webber.adilger.int> <20080801045412.GB25255@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:55982 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbYHAFHp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2008 01:07:45 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id m71583HI023460
	for <linux-ext4@vger.kernel.org>; Fri, 1 Aug 2008 15:08:03 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7157e9m223690
	for <linux-ext4@vger.kernel.org>; Fri, 1 Aug 2008 15:07:40 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7157dIF016366
	for <linux-ext4@vger.kernel.org>; Fri, 1 Aug 2008 15:07:40 +1000
Content-Disposition: inline
In-Reply-To: <20080801045412.GB25255@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 01, 2008 at 10:24:12AM +0530, Aneesh Kumar K.V wrote:
> On Thu, Jul 31, 2008 at 02:10:55PM -0600, Andreas Dilger wrote:
> > On Jul 31, 2008  23:03 +0530, Aneesh Kumar wrote:
> > > With the below changes we reserve credit needed to insert only one extent
> > > resulting from a call to single get_block. That make sure we don't take
> > > too much journal credits during writeout. We also don't limit the pages
> > > to write. That means we loop through the dirty pages building largest
> > > possible contiguous block request. Then we issue a single get_block request.
> > > We may get less block that we requested. If so we would end up not mapping
> > > some of the buffer_heads. That means those buffer_heads are still marked delay.
> > > Later in the writepage callback via __mpage_writepage we redirty those pages.
> > 
> > Can you please clarify this?  Does this mean we take one pass through the
> > dirty pages, but possibly do not allocate some subset of the pages.  Then,
> > at some later time these holes are written out separately?  This seems
> > like it would produce fragmentation if we do not work to ensure the pages
> > are allocated in sequence.  Maybe I'm misunderstanding your comment and
> > the unmapped pages are immediately mapped on the next loop?
> 
> We take multiple pass through the dirty pages until wbc->nr_to_write is
> <= 0 or we don't have anything more to write. But if get_block doesn't
> return the requested number of blocks we may possibly not writeout
> some of the pages. Whether this can result in a disk layout worse than
> the current, I am not sure. I haven't looked at the layout yet.
> But these pages which are skipped are redirtied again via
> reditry_pages_for_writepage and will be forced for writeout. Well
> we can do better by setting  wbc->encountered_congestion = 1; even
> though we are not really congested. That would cause most of the pdflush
> work func to retry writeback_indoes.
> 
> for(;;) {
> ...
> wbc.pages_skipped = 0;
> writeback_inodes(&wbc);
> ...
> 
> if (wbc.nr_to_write > 0 || wbc.pages_skipped > 0) {
> 	/* Wrote less than expected */
> 	if (wbc.encountered_congestion || wbc.more_io)
> 		congestion_wait(WRITE, HZ/10);
> 	else
> 		break;
> }
> 
> }
> 

like below ?

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 53a8fc7..6fd527c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1773,6 +1773,14 @@ static void mpage_da_map_blocks(struct mpage_da_data *mpd)
 		return;
 	BUG_ON(new.b_size == 0);
 
+	if (new.b_size < lbh->b_size) {
+		/*
+		 * allocated less blocks. force writepages
+		 * to be called again
+		 */
+		mpd->wbc->more_io = 1;
+	}
+
 	if (buffer_new(&new))
 		__unmap_underlying_blocks(mpd->inode, &new);
 
@@ -1876,6 +1884,8 @@ static int __mpage_da_writepage(struct page *page,
 			 * skip rest of the page in the page_vec
 			 */
 			mpd->io_done = 1;
+			/* We want writepages to be called again */
+			wbc->more_io = 1;
 			redirty_page_for_writepage(wbc, page);
 			unlock_page(page);
 			return MPAGE_DA_EXTENT_TAIL;
