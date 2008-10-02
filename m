From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] Improve buffered streaming write ordering
Date: Thu, 2 Oct 2008 23:48:56 +0530
Message-ID: <20081002181856.GB29613@skywalker>
References: <1222886451.9158.34.camel@think.oraclecorp.com> <20081001215239.ee2ae63f.akpm@linux-foundation.org> <1222950054.6745.18.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	ext4 <linux-ext4@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:45759 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbYJBSTS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Oct 2008 14:19:18 -0400
Content-Disposition: inline
In-Reply-To: <1222950054.6745.18.camel@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 02, 2008 at 08:20:54AM -0400, Chris Mason wrote:
> On Wed, 2008-10-01 at 21:52 -0700, Andrew Morton wrote:
> > On Wed, 01 Oct 2008 14:40:51 -0400 Chris Mason <chris.mason@oracle.com> wrote:
> > 
> > > The patch below changes write_cache_pages to only use writeback_index
> > > when current_is_pdflush().  The basic idea is that pdflush is the only
> > > one who has concurrency control against the bdi, so it is the only one
> > > who can safely use and update writeback_index.
> > 
> > Another approach would be to only update mapping->writeback_index if
> > nobody else altered it meanwhile.
> > 
> 
> Ok, I can give that a short.
> 
> > That being said, I don't really see why we get lots of seekiness when
> > two threads start their writing the file from the same offset.
> 
> For metadata, it makes sense.  Pages get dirtied in strange order, and
> if writeback_index is jumping around, we'll get the seeky metadata
> writeback.
> 
> Data makes less sense, especially the very high extent count from ext4.
> An extra printk shows that ext4 is calling redirty_page_for_writepage
> quite a bit in ext4_da_writepage.  This should be enough to make us jump
> around in the file.


We need to do  start the journal before locking the page with jbd2.
That prevent us from doing any block allocation in writepage() call
back. So with ext4/jbd2 we do block allocation only in writepages()
call back where we start the journal with credit needed to write
a single extent. Then we look for contiguous unallocated logical
block and request the block allocator for 'x' blocks. If we get
less than that. The rest of the pages which we iterated in
writepages  are redirtied so that we try to allocate them again.
We loop inside ext4_da_writepages itself looking at wbc->pages_skipped

2481         if (wbc->range_cont && (pages_skipped != wbc->pages_skipped)) {
2482                 /* We skipped pages in this loop */
2483                 wbc->range_start = range_start;
2484                 wbc->nr_to_write = to_write +


> 
> For a 4.5GB streaming buffered write, this printk inside
> ext4_da_writepage shows up 37,2429 times in /var/log/messages.
> 

Part of that can happen due to shrink_page_list -> pageout -> writepagee
call back with lots of unallocated buffer_heads(blocks). Also a journal
commit with jbd2 looks at the inode and all the dirty pages, rather than
the buffer_heads (journal_submit_data_buffers). We don't force commit
pages that doesn't have blocks allocated with the ext4. The consistency
is only with i_size and data.

> 	if (page_has_buffers(page)) {
> 		page_bufs = page_buffers(page);
> 		if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
> 					ext4_bh_unmapped_or_delay)) {
> 			/*
> 			 * We don't want to do  block allocation
> 			 * So redirty the page and return
> 			 * We may reach here when we do a journal commit
> 			 * via journal_submit_inode_data_buffers.
> 			 * If we don't have mapping block we just ignore
> 			 * them. We can also reach here via shrink_page_list
> 			 */
> 			redirty_page_for_writepage(wbc, page);
> 
> printk("redirty page %Lu\n", page_offset(page));
> 
> 			unlock_page(page);
> 			return 0;
> 		}
> 	} else {
> 
> -chris
> 
> 

-aneesh
