From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: data corruption with ext4 (from 2.6.27.4) exposed by rtorrent
Date: Thu, 6 Nov 2008 19:29:54 +0530
Message-ID: <20081106135954.GD25194@skywalker>
References: <3d3ce57e0811030442o377cf2bet212eefba79d714bb@mail.gmail.com> <20081103134008.GE29102@mit.edu> <319012f0811030734s6d14b2b3t13c32a41ac48e852@mail.gmail.com> <20081103165144.6514f003@starbug.prg01.itonis.net> <18705.63392.489856.682976@frecb006361.adech.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jindrich Makovicka <makovick@gmail.com>, linux-ext4@vger.kernel.org
To: Solofo.Ramangalahy@bull.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:54691 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777AbYKFOAI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 09:00:08 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp02.in.ibm.com (8.13.1/8.13.1) with ESMTP id mA6E044s011799
	for <linux-ext4@vger.kernel.org>; Thu, 6 Nov 2008 19:30:04 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA6DxtVD2662554
	for <linux-ext4@vger.kernel.org>; Thu, 6 Nov 2008 19:29:56 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id mA6E03VE005728
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 01:00:03 +1100
Content-Disposition: inline
In-Reply-To: <18705.63392.489856.682976@frecb006361.adech.frec.bull.fr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 05, 2008 at 08:44:32PM +0100, Solofo.Ramangalahy@bull.net wrote:
> Hi Jindrich,
> 
> Jindrich Makovicka writes:
>  > The following testcase was used to trigger the infamous MAP_SHARED
>  > dirty flag bug. Maybe it could be of some help here too:
>  > 
>  > http://lkml.org/lkml/2006/12/27/180
> 
> Thanks for remembering!
> 
> The test case triggers corruption with 2.6.28-rc3 + ext4 patch queue:
> . bunch of errors like
>   Chunk 71637 corrupted (0-1339)  (2756-4095)
>   Expected 213, got 0
>   with default mount.
> . nodelalloc is ok.

I think below patch is needed. But even with the patch I am hitting the
corruption. So patch doesn't solve the problem. The change from tag
dirty lookup to index lookup should not have much impact because we are
writing from first_page to next_page - 1 contiguous page which should be
marked dirty anyway because we did a tag dirty lookup in
write_cache_pages and we did a lock page there.

commit 714736001d68cff26258bb80891c566a65a682c2
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Thu Nov 6 09:01:21 2008 +0530

    ext4: Fix the delalloc writepages to allocate blocks at the right offset.
    
    When iterating through the pages with all mapped buffer_heads
    we failed to update the b_state value. This result in allocating
    blocks at logical offset 0.
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7d2d2ea..2808984 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1667,35 +1667,41 @@ static void ext4_da_page_release_reservation(struct page *page,
  */
 static int mpage_da_submit_io(struct mpage_da_data *mpd)
 {
-	struct address_space *mapping = mpd->inode->i_mapping;
-	int ret = 0, err, nr_pages, i;
-	unsigned long index, end;
-	struct pagevec pvec;
 	long pages_skipped;
+	struct pagevec pvec;
+	unsigned long index, end;
+	int ret = 0, err, nr_pages, i;
+	struct inode *inode = mpd->inode;
+	struct buffer_head *lbh = &mpd->lbh;
+	struct address_space *mapping = inode->i_mapping;
 
 	BUG_ON(mpd->next_page <= mpd->first_page);
-	pagevec_init(&pvec, 0);
+	/*
+	 * we need to start from the first_page to the next_page - 1
+	 * That is to make sure we also write the mapped dirty
+	 * buffer_heads. If we look at mpd->lbh.b_blocknr we
+	 * would only be looking at currently mapped buffer_heads.
+	 */
 	index = mpd->first_page;
 	end = mpd->next_page - 1;
 
+	pagevec_init(&pvec, 0);
 	while (index <= end) {
-		/*
-		 * We can use PAGECACHE_TAG_DIRTY lookup here because
-		 * even though we have cleared the dirty flag on the page
-		 * We still keep the page in the radix tree with tag
-		 * PAGECACHE_TAG_DIRTY. See clear_page_dirty_for_io.
-		 * The PAGECACHE_TAG_DIRTY is cleared in set_page_writeback
-		 * which is called via the below writepage callback.
-		 */
-		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
-					PAGECACHE_TAG_DIRTY,
-					min(end - index,
-					(pgoff_t)PAGEVEC_SIZE-1) + 1);
+		nr_pages = pagevec_lookup(&pvec, mapping, index, PAGEVEC_SIZE);
 		if (nr_pages == 0)
 			break;
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
 
+			index = page->index;
+			if (index > end)
+				break;
+			index++;
+
+			BUG_ON(!PageLocked(page));
+			BUG_ON(PageWriteback(page));
+			BUG_ON(!page_has_buffers(page));
+
 			pages_skipped = mpd->wbc->pages_skipped;
 			err = mapping->a_ops->writepage(page, mpd->wbc);
 			if (!err && (pages_skipped == mpd->wbc->pages_skipped))
@@ -2109,11 +2115,29 @@ static int __mpage_da_writepage(struct page *page,
 		bh = head;
 		do {
 			BUG_ON(buffer_locked(bh));
+			/*
+			 * We need to try to allocte
+			 * unmapped blocks in the same page.
+			 * Otherwise we won't make progress
+			 * with the page in ext4_da_writepage
+			 */
 			if (buffer_dirty(bh) &&
 				(!buffer_mapped(bh) || buffer_delay(bh))) {
 				mpage_add_bh_to_extent(mpd, logical, bh);
 				if (mpd->io_done)
 					return MPAGE_DA_EXTENT_TAIL;
+			} else if (buffer_dirty(bh) && (buffer_mapped(bh))) {
+				/*
+				 * mapped dirty buffer. We need to update
+				 * the b_state because we look at
+				 * b_state in mpage_da_map_blocks. We don't
+				 * update b_size because if we find an
+				 * unmapped buffer_head later we need to
+				 * use the b_state flag of that buffer_head.
+				 */
+				if (mpd->lbh.b_size == 0)
+					mpd->lbh.b_state =
+						bh->b_state & BH_FLAGS;
 			}
 			logical++;
 		} while ((bh = bh->b_this_page) != head);
