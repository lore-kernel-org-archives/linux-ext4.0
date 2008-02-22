From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] ext4: Convert uninitialized extent to initialized
	extent in case of file system full
Date: Fri, 22 Feb 2008 20:01:28 +0530
Message-ID: <20080222143128.GA6354@skywalker>
References: <20080221191747.GA8292@skywalker> <1203628037.3638.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:54985 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbYBVOb7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Feb 2008 09:31:59 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp01.au.ibm.com (8.13.1/8.13.1) with ESMTP id m1MEWjZr011953
	for <linux-ext4@vger.kernel.org>; Sat, 23 Feb 2008 01:32:45 +1100
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1MEVvsj2908212
	for <linux-ext4@vger.kernel.org>; Sat, 23 Feb 2008 01:31:57 +1100
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1MEW12V007877
	for <linux-ext4@vger.kernel.org>; Sat, 23 Feb 2008 01:32:01 +1100
Content-Disposition: inline
In-Reply-To: <1203628037.3638.21.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 21, 2008 at 01:07:17PM -0800, Mingming Cao wrote:
> Hi Aneesh,
> 
> It's a good start, a few comments below..
> 

.....


> > +			page = __grab_cache_page(mapping, index);
> > +			if (!page)
> > +				return -ENOMEM;
> > +		}
> > +
> 
> I the page is already locked before calling get_block() via writepage(),
> isn't it? and the journal transaction already started...
> 

It would be via write_begin or writepage. But both the callbacks lock
the page before their call getblock for all the blocks corresponding to
the page.


> 
> > +		if (!page_has_buffers(page))
> > +			create_empty_buffers(page, blocksize, 0);
> > +
> > +		head = page_buffers(page);
> > +		/* Look for the buffer_head which map the block */
> > +		bh = head;
> > +		while (offset > 0) {
> > +			bh = bh->b_this_page;
> > +			offset -= blocksize;
> > +		}
> > +		offset = (pos & (PAGE_CACHE_SIZE - 1));
> > +
> > +		/* Now write all the buffer_heads in the page */
> > +		do {
> > +			set_buffer_uptodate(bh);
> > +			if (ext4_should_journal_data(inode)) {
> > +				err = ext4_journal_get_write_access(handle, bh);
> > +				/* do we have that many credits ??*/
> > +				if (err)
> > +					goto err_out;
> > +			}
> > +			zero_user(page, offset, blocksize);
> 
> Ah oh, you are trying to zero out the pages in the page cache, that's
> seems wrong to me. By the time get_block() is called from writepages(),
> the pages should have meaningful content that needs to flush to disk,
> zero the pages out will lost the data.
> 

It is writebegin.  In case of writebegin the pages doesn't have the content. By the
time we reach write begin the page is supposed to have buffer heads that
are alreayd mapped. So we won't end up calling get_blk. Even in case of
mmap with page_mkwrite change we would have called writebegin equivalent
before the writepage.


> > +			offset += blocksize;
> > +			if (ext4_should_journal_data(inode)) {
> > +				err = ext4_journal_dirty_metadata(handle, bh);
> > +				if (err)
> > +					goto err_out;
> > +			} else {
> > +				if (ext4_should_order_data(inode)) {
> > +					err = ext4_journal_dirty_data(handle,
> > +									bh);
> > +					if (err)
> > +						goto err_out;
> > +				}
> > +				mark_buffer_dirty(bh);
> > +			}
> > +
> > +			bh = bh->b_this_page;
> > +			blkcount--;
> > +		} while ((bh != head) && (blkcount > 0));
> > +		/* only unlock if we have locked */
> > +		if (index != skip_index)
> > +			unlock_page(page);
> > +		page_cache_release(page);
> > +	}
> > +
> > +	return 0;
> > +err_out:
> > +	unlock_page(page);
> > +	page_cache_release(page);
> > +	return err;
> > +}
> > +
> 
> I was thinking just simply create a new bh, zero out the bh, then map
> the bh with the block number to zero out, lastly submit a IO via
> ll_rw_block. It maybe more efficient to do this via bio(perhaps cooking
> a bio with zeroed out pages and submit_bio) but I have not look very
> closely to it. Just throw out my thoughts.
> 

But we would still need pages. buffer head need to have a mapped page 
b_page. Also if we don't take the page from page cache then we would
have to wait for the I/O to complete using wait_on_buffer before we can
update the extent information. Using page cache also plug it nicely with
different journalling mode.

-aneesh
