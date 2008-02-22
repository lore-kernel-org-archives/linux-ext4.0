From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] ext4: Convert uninitialized extent to initialized
	extent in case of file system full
Date: Fri, 22 Feb 2008 21:12:18 +0530
Message-ID: <20080222154218.GB6629@skywalker>
References: <20080221191747.GA8292@skywalker> <1203628037.3638.21.camel@localhost.localdomain> <20080222143128.GA6354@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:52489 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753041AbYBVPmb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Feb 2008 10:42:31 -0500
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by e28esmtp03.in.ibm.com (8.13.1/8.13.1) with ESMTP id m1MFgTcv001753
	for <linux-ext4@vger.kernel.org>; Fri, 22 Feb 2008 21:12:29 +0530
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1MFgTJS1146946
	for <linux-ext4@vger.kernel.org>; Fri, 22 Feb 2008 21:12:29 +0530
Received: from d28av01.in.ibm.com (loopback [127.0.0.1])
	by d28av01.in.ibm.com (8.13.1/8.13.3) with ESMTP id m1MFgXDr004659
	for <linux-ext4@vger.kernel.org>; Fri, 22 Feb 2008 15:42:34 GMT
Content-Disposition: inline
In-Reply-To: <20080222143128.GA6354@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 22, 2008 at 08:01:28PM +0530, Aneesh Kumar K.V wrote:
> > > +
> > > +		/* Now write all the buffer_heads in the page */
> > > +		do {
> > > +			set_buffer_uptodate(bh);
> > > +			if (ext4_should_journal_data(inode)) {
> > > +				err = ext4_journal_get_write_access(handle, bh);
> > > +				/* do we have that many credits ??*/
> > > +				if (err)
> > > +					goto err_out;
> > > +			}
> > > +			zero_user(page, offset, blocksize);
> > 
> > Ah oh, you are trying to zero out the pages in the page cache, that's
> > seems wrong to me. By the time get_block() is called from writepages(),
> > the pages should have meaningful content that needs to flush to disk,
> > zero the pages out will lost the data.
> > 
> 
> It is writebegin.  In case of writebegin the pages doesn't have the content. By the
> time we reach write begin the page is supposed to have buffer heads that
> are alreayd mapped. So we won't end up calling get_blk. Even in case of
> mmap with page_mkwrite change we would have called writebegin equivalent
> before the writepage.

I guess the above para is confusing.

The callback is actually writebegin.In case of writebegin the page
doesn't have the content. With respect to writepage by the time we call the
callback the buffer_heads related to the page would already be mapped.
So we won't end up calling get_blk.


-aneesh
