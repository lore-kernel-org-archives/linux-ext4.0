From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Fix delalloc sync hang with journal lock
	inversion
Date: Thu, 22 May 2008 23:53:27 +0530
Message-ID: <20080522182327.GA7404@skywalker>
References: <1211391859-17399-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1211391859-17399-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1211391859-17399-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1211391859-17399-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080522102548.GB30056@skywalker> <1211479115.8596.37.camel@BVR-FS.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, sandeen@redhat.com
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp05.in.ibm.com ([59.145.155.5]:43754 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756552AbYEVSXo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 22 May 2008 14:23:44 -0400
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28smtp05.in.ibm.com (8.13.1/8.13.1) with ESMTP id m4MINYpf012463
	for <linux-ext4@vger.kernel.org>; Thu, 22 May 2008 23:53:34 +0530
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4MINLsF1101996
	for <linux-ext4@vger.kernel.org>; Thu, 22 May 2008 23:53:21 +0530
Received: from d28av04.in.ibm.com (loopback [127.0.0.1])
	by d28av04.in.ibm.com (8.13.1/8.13.3) with ESMTP id m4MINXwG003975
	for <linux-ext4@vger.kernel.org>; Thu, 22 May 2008 23:53:33 +0530
Content-Disposition: inline
In-Reply-To: <1211479115.8596.37.camel@BVR-FS.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 22, 2008 at 10:58:35AM -0700, Mingming wrote:
> 
> On Thu, 2008-05-22 at 15:55 +0530, Aneesh Kumar K.V wrote:
> > On Wed, May 21, 2008 at 11:14:17PM +0530, Aneesh Kumar K.V wrote:
> > > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > > ---
> > >  fs/ext4/inode.c |   10 +++++++---
> > >  1 files changed, 7 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > > index 46cc610..076d00f 100644
> > > --- a/fs/ext4/inode.c
> > > +++ b/fs/ext4/inode.c
> > > @@ -1571,13 +1571,17 @@ static int ext4_da_writepages(struct address_space *mapping,
> > >  		 */
> > >  		if (wbc->nr_to_write > EXT4_MAX_WRITEBACK_PAGES)
> > >  			wbc->nr_to_write = EXT4_MAX_WRITEBACK_PAGES;
> > > -		to_write -= wbc->nr_to_write;
> > > 
> > > +		to_write -= wbc->nr_to_write;
> > >  		ret = mpage_da_writepages(mapping, wbc, ext4_da_get_block_write);
> > >  		ext4_journal_stop(handle);
> > > -		to_write +=wbc->nr_to_write;
> > > +		if (wbc->nr_to_write) {
> > > +			/* We failed to write what we requested for */
> > > +			to_write += wbc->nr_to_write;
> > > +			break;
> > > +		}
> > > +		wbc->nr_to_write = to_write;
> > >  	}
> > > -
> > >  out_writepages:
> > >  	wbc->nr_to_write = to_write;
> > >  	wbc->range_cyclic = range_cyclic;
> > 
> > We need related fix for ext4_da_writepage. We need to allocate blocks in
> > ext4_da_writepage and we are called with page_lock. The handle
> > will be NULL in the below case and that would result in
> > ext4_get_block starting a new transaction when allocating blocks.
> > 
> 
> Hi Aneesh, the blocks are not allocated at ext4_da_writepage() time, 
> 
> the block allocation has been done in this path: 
> 
> ext4_da_writepages()->mpage_da_writepages()->write_cache_pages()->
> __mpage_da_writepage()->mpage_da_map_blocks() will ensure blocks are all
> mapped before mpage_da_submit_io() calling
> __mpage_writepage()->ext4_da_writepage() to submit the IO.
> 

Does that mean we don't allocate new blocks at all in ext4_da_writepage.
Then I will put a BUG() if we get passed a page that doesn't have all
the buffer head mapped in ext4_da_writepage.

We still need a diff as below

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 46cc610..8327796 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1498,9 +1498,8 @@ static int __ext4_da_writepage(struct page *page,
 {
 	struct inode *inode = page->mapping->host;
 	handle_t *handle = NULL;
-	int ret = 0;
+	int ret = 0, err;
 
-	handle = ext4_journal_current_handle();
 
 	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
 		ret = nobh_writepage(page, ext4_get_block, wbc);
@@ -1508,12 +1507,21 @@ static int __ext4_da_writepage(struct page *page,
 		ret = block_write_full_page(page, ext4_get_block, wbc);
 
 	if (!ret && inode->i_size > EXT4_I(inode)->i_disksize) {
+		handle = ext4_journal_start(inode, 1);
+		if (IS_ERR(handle)) {
+			ret = PTR_ERR(handle);
+			goto out;
+		}
 		EXT4_I(inode)->i_disksize = inode->i_size;
-		ext4_mark_inode_dirty(handle, inode);
+		ret = ext4_mark_inode_dirty(handle, inode);
+		err = ext4_journal_stop(handle);
+		if (!ret)
+			ret = err;
 	}
