From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ext4_page_mkwrite and delalloc
Date: Fri, 13 Jun 2008 08:50:06 +0530
Message-ID: <20080613032006.GC12892@skywalker>
References: <20080612181407.GE22481@skywalker> <1213304446.3698.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4 <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:45795 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbYFMDYC (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 12 Jun 2008 23:24:02 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m5D3NO96012679
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 13:23:24 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5D3KEFt057154
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 13:20:14 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5D3KE2C028467
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jun 2008 13:20:14 +1000
Content-Disposition: inline
In-Reply-To: <1213304446.3698.9.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 12, 2008 at 02:00:46PM -0700, Mingming Cao wrote:
> On Thu, 2008-06-12 at 23:44 +0530, Aneesh Kumar K.V wrote:
> > Hi,
> > 
> > With delalloc we should not do writepage in ext4_page_mkwrite. The idea
> > with delalloc is to delay the block allocation and make sure we allocate
> > chunks of blocks together at writepages. So i guess we should update
> > ext4_page_mkwrite to use write_begin and write_end instead of writepage.
> 
> I agree with delayed allocation page_mkwrite is much simplier, just to
> block reservation to prevent ENOSPC
> 
> > Taking i_alloc_sem should protect against parallel truncate and the page
> > lock should protect against parallel write_begin/write_end.
> > 
> > How about the patch below ?
> > 
> 
> Do we plan to support page_mkwrite for non delalloc? the following patch
> seems suggesting that we only do page_mkwrite with delalloc?

Yes it is needed for non delalloc also. The primary requirement is for
lock inversion patches. With lock inversion patches we don't do
block allocation in writepage


> 
> > diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> > index cac132b..7f162cc 100644
> > --- a/fs/ext4/inode.c
> > +++ b/fs/ext4/inode.c
> > @@ -3543,18 +3543,6 @@ int ext4_change_inode_journal_flag(struct inode *inode, int val)
> >  	return err;
> >  }
> > 
> > -static int ext4_bh_prepare_fill(handle_t *handle, struct buffer_head *bh)
> > -{
> > -	if (!buffer_mapped(bh)) {
> > -		/*
> > -		 * Mark buffer as dirty so that
> > -		 * block_write_full_page() writes it
> > -		 */
> > -		set_buffer_dirty(bh);
> > -	}
> > -	return 0;
> > -}
> > -
> >  static int ext4_bh_unmapped(handle_t *handle, struct buffer_head *bh)
> >  {
> >  	return !buffer_mapped(bh);
> > @@ -3596,24 +3584,22 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, struct page *page)
> >  		if (!walk_page_buffers(NULL, page_buffers(page), 0, len, NULL,
> >  				       ext4_bh_unmapped))
> >  			goto out_unlock;
> > -		/*
> > -		 * Now mark all the  buffer head dirty so
> > -		 * that writepage can write it
> > -		 */
> > -		walk_page_buffers(NULL, page_buffers(page), 0, len,
> > -					NULL, ext4_bh_prepare_fill);
> >  	}
> >  	/*
> > -	 * OK, we need to fill the hole... Lock the page and do writepage.
> > -	 * We can't do write_begin and write_end here because we don't
> > -	 * have inode_mutex and that allow parallel write_begin, write_end call.
> > +	 * OK, we need to fill the hole... Lock the page and do write_begin
> > +	 * write_end. We are not holding inode.i__mutex here. That allow
> > +	 * parallel write_begin, write_end call.
> >  	 * (lock_page prevent this from happening on the same page though)
> >  	 */
> > -	lock_page(page);
> > -	wbc.range_start = page_offset(page);
> > -	wbc.range_end = page_offset(page) + len;
> > -	ret = mapping->a_ops->writepage(page, &wbc);
> > -	/* writepage unlocks the page */
> > +	ret = mapping->a_ops->write_begin(file, mapping, page_offset(page),
> > +			len, AOP_FLAG_UNINTERRUPTIBLE, &page, NULL);
> 
> What is this AOP_FLAG_UNINTERRUPTIBLE flag ? Also shouldn't we test
> delalloc is enabled?
> 

Since we are not doing any real copy here I guess we can say that
we don't do short write. The flag means that.

#define AOP_FLAG_UNINTERRUPTIBLE        0x0001 /* will not do a short write */

> > +	if (ret < 0)
> > +		goto out_unlock;
> > +	ret = mapping->a_ops->write_end(file, mapping, page_offset(page),
> > +			len, len, page, NULL);
> 
> I am still puzzled why we need to mark the page dirty in write_end here.
> Thought only do block reservation in write_begin is enough, we haven't
> write anything yet...


The reason is to get the ordered and journaled mode behavior correct.
We need ensure that the meta-data that got allocated in the write_begin
get commited in the right order. We need add the buffer_heads
corresponding to the data (page) to the right list in the journal.
write_end mostly does that.

-aneesh
