From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [RFC][PATCH] ext4: Convert uninitialized extent to initialized
 extent in case of file system full
Date: Fri, 22 Feb 2008 09:28:12 -0800
Message-ID: <47BF062C.8000306@us.ibm.com>
References: <20080221191747.GA8292@skywalker> <1203628037.3638.21.camel@localhost.localdomain> <20080222143128.GA6354@skywalker> <20080222154218.GB6629@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:49101 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756518AbYBVR2Z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 22 Feb 2008 12:28:25 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1MHSMPE020820
	for <linux-ext4@vger.kernel.org>; Fri, 22 Feb 2008 12:28:22 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1MHSMPP243566
	for <linux-ext4@vger.kernel.org>; Fri, 22 Feb 2008 12:28:22 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1MHSMuN015460
	for <linux-ext4@vger.kernel.org>; Fri, 22 Feb 2008 12:28:22 -0500
In-Reply-To: <20080222154218.GB6629@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> On Fri, Feb 22, 2008 at 08:01:28PM +0530, Aneesh Kumar K.V wrote:
>>>> +
>>>> +		/* Now write all the buffer_heads in the page */
>>>> +		do {
>>>> +			set_buffer_uptodate(bh);
>>>> +			if (ext4_should_journal_data(inode)) {
>>>> +				err = ext4_journal_get_write_access(handle, bh);
>>>> +				/* do we have that many credits ??*/
>>>> +				if (err)
>>>> +					goto err_out;
>>>> +			}
>>>> +			zero_user(page, offset, blocksize);
>>> Ah oh, you are trying to zero out the pages in the page cache, that's
>>> seems wrong to me. By the time get_block() is called from writepages(),
>>> the pages should have meaningful content that needs to flush to disk,
>>> zero the pages out will lost the data.
>>>
>> It is writebegin.  In case of writebegin the pages doesn't have the content. By the
>> time we reach write begin the page is supposed to have buffer heads that
>> are alreayd mapped. So we won't end up calling get_blk. Even in case of
>> mmap with page_mkwrite change we would have called writebegin equivalent
>> before the writepage.
> 
> I guess the above para is confusing.
> 
> The callback is actually writebegin.In case of writebegin the page
> doesn't have the content. With respect to writepage by the time we call the
> callback the buffer_heads related to the page would already be mapped.
> So we won't end up calling get_blk.
> 
> 

Ah, right, the callback at this moment is from write_begin(),as 
get_block() with create==1 is called then (with the recently fix:-)).

But I am thinking from delayed allocation view, since I am looking at it 
recently.:-) get_block() with create ==1 will be defered at writepages 
time, then I am afraid this will broken.

I could be wrong but the code seems only working for buffered IO. What 
about DIO writes to the uninit extents? Since there is no mapping in the 
pagecache, then DIO starts calling get_block() with create ==1. What 
happened in this case? I had a feeling this also broken, isn't it?

Regards,

Mingmng
