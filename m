From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: ext4_page_mkwrite and delalloc
Date: Sat, 14 Jun 2008 12:13:47 +0530
Message-ID: <20080614064347.GB11866@skywalker>
References: <20080612181407.GE22481@skywalker> <1213304446.3698.9.camel@localhost.localdomain> <20080613032006.GC12892@skywalker> <1213396521.27507.7.camel@BVR-FS.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4 <linux-ext4@vger.kernel.org>
To: Mingming <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:55032 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbYFNGoE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 14 Jun 2008 02:44:04 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id m5E6hVOK025585
	for <linux-ext4@vger.kernel.org>; Sat, 14 Jun 2008 16:43:31 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m5E6heOK3633216
	for <linux-ext4@vger.kernel.org>; Sat, 14 Jun 2008 16:43:42 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m5E6hxIT020758
	for <linux-ext4@vger.kernel.org>; Sat, 14 Jun 2008 16:44:00 +1000
Content-Disposition: inline
In-Reply-To: <1213396521.27507.7.camel@BVR-FS.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 13, 2008 at 03:35:21PM -0700, Mingming wrote:
> > 
> > Since we are not doing any real copy here I guess we can say that
> > we don't do short write. The flag means that.
> > 
> > #define AOP_FLAG_UNINTERRUPTIBLE        0x0001 /* will not do a short write */
> > 
> > > > +	if (ret < 0)
> > > > +		goto out_unlock;
> > > > +	ret = mapping->a_ops->write_end(file, mapping, page_offset(page),
> > > > +			len, len, page, NULL);
> > > 
> > > I am still puzzled why we need to mark the page dirty in write_end here.
> > > Thought only do block reservation in write_begin is enough, we haven't
> > > write anything yet...
> > 
> > 
> > The reason is to get the ordered and journaled mode behavior correct.
> > We need ensure that the meta-data that got allocated in the write_begin
> > get commited in the right order.
> 
> I am confused here, I thought this patch is to take advantage of delayed
> allocation, so that we could just call the write_begin in mkwrite, there
> is only block reservation, but no real block allocation and meta-data
> changes?  Thus no need to worry about the ordering?
> 


The changes are update to ext4_page_mkwrite. This call back is used when
we try to write to page. With nodelalloc and ordered mode we need to
make sure we allocate blocks in ext4_page_mkwrite. Because we can't
allocate blocks in writepage with nodelalloc. So we use write_begin and
write_end. This will ensure that we use block reservation in case of
delayed allocation and do block allocation in case of nodelalloc.

Earlier it used writepage always. That would not work with delayed
allocation. Hence the changes.






> >  We need add the buffer_heads
> > corresponding to the data (page) to the right list in the journal.
> > write_end mostly does that.
> > 
> I probably missed the basic here, I was assuming the patch also based on
> the new orderd mode? But with the new ordered mode, this part(using
> buffer heads) is replaced with the journal inode list, and with delayed
> allocation, the code to ensure the ordering is pushed later at
> writepages() time.
> 


-aneesh
