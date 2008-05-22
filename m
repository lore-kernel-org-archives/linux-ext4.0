From: Mingming <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: Fix delalloc sync hang with journal lock
	inversion
Date: Thu, 22 May 2008 10:58:35 -0700
Message-ID: <1211479115.8596.37.camel@BVR-FS.beaverton.ibm.com>
References: <1211391859-17399-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1211391859-17399-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1211391859-17399-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1211391859-17399-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <20080522102548.GB30056@skywalker>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, sandeen@redhat.com
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:53931 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755985AbYEVR6q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 May 2008 13:58:46 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m4MHweUv009774
	for <linux-ext4@vger.kernel.org>; Thu, 22 May 2008 13:58:40 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m4MHwZ7q112790
	for <linux-ext4@vger.kernel.org>; Thu, 22 May 2008 13:58:35 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m4MHwZ6P013599
	for <linux-ext4@vger.kernel.org>; Thu, 22 May 2008 13:58:35 -0400
In-Reply-To: <20080522102548.GB30056@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Thu, 2008-05-22 at 15:55 +0530, Aneesh Kumar K.V wrote:
> On Wed, May 21, 2008 at 11:14:17PM +0530, Aneesh Kumar K.V wrote:
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > ---
> >  fs/ext4/inode.c |   10 +++++++---
> >  1 files changed, 7 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index 46cc610..076d00f 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -1571,13 +1571,17 @@ static int ext4_da_writepages(struct address_space *mapping,
> >  		 */
> >  		if (wbc->nr_to_write > EXT4_MAX_WRITEBACK_PAGES)
> >  			wbc->nr_to_write = EXT4_MAX_WRITEBACK_PAGES;
> > -		to_write -= wbc->nr_to_write;
> > 
> > +		to_write -= wbc->nr_to_write;
> >  		ret = mpage_da_writepages(mapping, wbc, ext4_da_get_block_write);
> >  		ext4_journal_stop(handle);
> > -		to_write +=wbc->nr_to_write;
> > +		if (wbc->nr_to_write) {
> > +			/* We failed to write what we requested for */
> > +			to_write += wbc->nr_to_write;
> > +			break;
> > +		}
> > +		wbc->nr_to_write = to_write;
> >  	}
> > -
> >  out_writepages:
> >  	wbc->nr_to_write = to_write;
> >  	wbc->range_cyclic = range_cyclic;
> 
> We need related fix for ext4_da_writepage. We need to allocate blocks in
> ext4_da_writepage and we are called with page_lock. The handle
> will be NULL in the below case and that would result in
> ext4_get_block starting a new transaction when allocating blocks.
> 

Hi Aneesh, the blocks are not allocated at ext4_da_writepage() time, 

the block allocation has been done in this path: 

ext4_da_writepages()->mpage_da_writepages()->write_cache_pages()->
__mpage_da_writepage()->mpage_da_map_blocks() will ensure blocks are all
mapped before mpage_da_submit_io() calling
__mpage_writepage()->ext4_da_writepage() to submit the IO.

> 
> static int __ext4_da_writepage(struct page *page,
> 				struct writeback_control *wbc)
> {
> 	struct inode *inode = page->mapping->host;
> 	handle_t *handle = NULL;
> 	int ret = 0;
> 
> 	handle = ext4_journal_current_handle();
> 
> 	if (test_opt(inode->i_sb, NOBH) && ext4_should_writeback_data(inode))
> 		ret = nobh_writepage(page, ext4_get_block, wbc);
> 	else
> 		ret = block_write_full_page(page, ext4_get_block, wbc);
> 
> 	if (!ret && inode->i_size > EXT4_I(inode)->i_disksize) {
> 		EXT4_I(inode)->i_disksize = inode->i_size;
> 		ext4_mark_inode_dirty(handle, inode);
> 	}
> 
> 	return ret;
> }
> 
> -aneesh

