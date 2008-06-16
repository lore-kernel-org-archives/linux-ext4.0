From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC] ext4: Semantics of delalloc,data=ordered
Date: Mon, 16 Jun 2008 21:32:51 +0530
Message-ID: <20080616160251.GA14214@skywalker>
References: <1213284316-22063-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20080616150533.GB3279@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, sandeen@redhat.com,
	linux-ext4@vger.kernel.org, adilger@sun.com
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:56796 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbYFPQD1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 16 Jun 2008 12:03:27 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp04.au.ibm.com (8.13.1/8.13.1) with ESMTP id m5GG2Z4F025966
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jun 2008 02:02:35 +1000
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5GG3N5o076336
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jun 2008 02:03:23 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5GG3Mwq026319
	for <linux-ext4@vger.kernel.org>; Tue, 17 Jun 2008 02:03:22 +1000
Content-Disposition: inline
In-Reply-To: <20080616150533.GB3279@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 16, 2008 at 05:05:33PM +0200, Jan Kara wrote:
>   Hi Aneesh,
> 
>   First, I'd like to see some short comment on what semantics
> delalloc,data=ordered is going to have. At least I can imagine at least
> two sensible approaches:
>   1) All we guarantee is that user is not going to see uninitialized data.
> We send writes to disk (and allocate blocks) whenever it fits our needs
> (usually when pdflush finds them).
>   2) We guarantee that when transaction commits, your data is on disk -
> i.e., we allocate actual blocks on transaction commit.
> 
>   Both these possibilities have their pros and cons. Most importantly,
> 1) gives better disk layout while 2) gives higher consistency
> guarantees. Note that with 1), it can under some circumstances happen,
> that after a crash you see block 1 and 3 of your 3-block-write on disk,
> while block 2 is still a hole. 1) is easy to implement (you mostly did
> it below), 2) is harder. I think there should be broader consensus on
> what the semantics should be (changed subject to catch more attention
> ;).
> 
>   A few comments to your patch are also below.
> 
> 								Honza

The way I was looking at ordered mode was, we only guarantee that the
meta-data blocks corresponding to the data block allocated get committed
only after the data-blocks are written to the disk. As long as we don't
allocate blocks corresponding to a page we don't write the  page to
disk. This should also speed up the "sync slowness" that lot of people
are reporting with ordered mode. Can you explain
"
1), it can under some circumstances happen, that after a crash you see
block 1 and 3 of your 3-block-write on disk, while block 2 is still a hole.
"


> 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > ---
> >  fs/ext4/inode.c  |  169 +++++++++++++++++++++++++++++++++++++++++++++++++++--
> >  fs/jbd2/commit.c |   41 ++++++++++++--
> >  2 files changed, 198 insertions(+), 12 deletions(-)
> > 
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index 63355ab..7d87641 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -1606,13 +1606,12 @@ static int ext4_bh_unmapped_or_delay(handle_t *handle, struct buffer_head *bh)
> >  	return !buffer_mapped(bh) || buffer_delay(bh);
> >  }
> >  
> > -/* FIXME!! only support data=writeback mode */
> >  /*
> >   * get called vi ext4_da_writepages after taking page lock
> >   * We may end up doing block allocation here in case
> >   * mpage_da_map_blocks failed to allocate blocks.
> >   */
> > -static int ext4_da_writepage(struct page *page,
> > +static int ext4_da_writeback_writepage(struct page *page,
> >  				struct writeback_control *wbc)
> >  {
> >  	int ret = 0;
> > @@ -1660,6 +1659,61 @@ static int ext4_da_writepage(struct page *page,
> >  	return ret;
> >  }
> >  
> > +/*
> > + * get called vi ext4_da_writepages after taking page lock
> > + * We may end up doing block allocation here in case
> > + * mpage_da_map_blocks failed to allocate blocks.
> > + *
> > + * We also get called via journal_submit_inode_data_buffers
> > + */
> > +static int ext4_da_ordered_writepage(struct page *page,
> > +				struct writeback_control *wbc)
> > +{
> > +	int ret = 0;
> > +	loff_t size;
> > +	unsigned long len;
> > +	handle_t *handle = NULL;
> > +	struct buffer_head *page_bufs;
> > +	struct inode *inode = page->mapping->host;
> > +
> > +	handle = ext4_journal_current_handle();
> > +	if (!handle) {
> > +		/*
> > +		 * This can happen when we aren't called via
> > +		 * ext4_da_writepages() but directly (shrink_page_list).
> > +		 * We cannot easily start a transaction here so we just skip
> > +		 * writing the page in case we would have to do so.
> > +		 */
> > +		size = i_size_read(inode);
> > +
> > +		page_bufs = page_buffers(page);
> > +		if (page->index == size >> PAGE_CACHE_SHIFT)
> > +			len = size & ~PAGE_CACHE_MASK;
> > +		else
> > +			len = PAGE_CACHE_SIZE;
> > +
> > +		if (walk_page_buffers(NULL, page_bufs, 0,
> > +				len, NULL, ext4_bh_unmapped_or_delay)) {
> > +			/*
> > +			 * We can't do block allocation under
> > +			 * page lock without a handle . So redirty
> > +			 * the page and return.
> > +			 * We may reach here when we do a journal commit
> > +			 * via journal_submit_inode_data_buffers.
> > +			 * If we don't have mapping block we just ignore
> > +			 * them
> > +			 *
> > +			 */
> > +			redirty_page_for_writepage(wbc, page);
> > +			unlock_page(page);
> > +			return 0;
> > +		}
> > +	}
> > +
> > +	ret = block_write_full_page(page, ext4_da_get_block_write, wbc);
> > +
> > +	return ret;
> > +}
>   If you're going to use this writepage() implementation from commit
> code, you cannot simply do redirty_page_for_writepage() and bail out
> when there's an unmapped buffer. You must write out at least mapped
> buffers to satisfy ordering guarantees (think of filesystems with
> blocksize < page size).

With delalloc is it possible to have a page that have some buffer_heads
marked delay ?



-aneesh
