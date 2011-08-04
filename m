From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 1/1 v3] ext4: fix xfstests 75, 112, 127 punch hole
 failure
Date: Thu, 04 Aug 2011 10:44:00 -0700
Message-ID: <1312479840.7732.7.camel@mingming-laptop>
References: <4E396744.2030003@linux.vnet.ibm.com>
	 <20110804005001.GI3150@thunk.org> <4E3A48D2.3070905@linux.vnet.ibm.com>
	 <20110804152519.GJ3150@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:60231 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555Ab1HDRoq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 4 Aug 2011 13:44:46 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p74HFI0g017672
	for <linux-ext4@vger.kernel.org>; Thu, 4 Aug 2011 13:15:18 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p74Hi9JH045204
	for <linux-ext4@vger.kernel.org>; Thu, 4 Aug 2011 13:44:12 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p74Hi6eg018815
	for <linux-ext4@vger.kernel.org>; Thu, 4 Aug 2011 13:44:08 -0400
In-Reply-To: <20110804152519.GJ3150@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2011-08-04 at 11:25 -0400, Ted Ts'o wrote:
> On Thu, Aug 04, 2011 at 12:22:58AM -0700, Allison Henderson wrote:
> > 
> > Oh, I think we do avoid calling the unmap for this last condition
> > though.  The first and last page offsets are calculated earlier for
> > calling truncate_inode_pages_range to release all the pages in the
> > hole. The idea is that everything from first_page_offset to
> > last_page_offset covers all the page aligned pages in the hole.  So
> > then if offset and length are aligned, we basically end up with
> > first_page_offset = offset and last_page_offset = offset + length,
> > and the page_len will turn out to be zero.  Right math?  Maybe we
> > can add some comments or something to help clarify.
> 
> Yeah, sorry, I wasn't clear enough about the condition.  Consider the
> situation where we punch the region:
> 
>    4092 -- 8197
> 
> In the previous section of code, we would zero out the byte ranges
> 4092--4095 and 8192--8197.  What's left is a completely page-aligned
> range, which would have already been taken care of already.  But since
> we're calculating based on offsets, I believe there will be an
> unnecessary call to ext4_unmap_page_range().  
> 

Yep, for the default 4k block size, if the offset is not block aligned,
with the patch we could end of unnecessary unamp_page_range.

> BTW, the name ext4_unmap_page_range() is a bit confusing; maybe we
> should rename it to ext4_unmap_partial_page_buffers()?
> 

The new name sounds better. It should only called for punch hole in the
range (blocksize != pagesize) and (offset is block aligned) and (offset
is not page aligned)

> I know you were copying from the ext4_block_zero_page_range() function
> and its calling sequence (but in my opinion that function wasn't named
> well and the comments in that code aren't good either).
> 
> I also wonder why we can't fold the functionality found in
> ext4_unmap_page_range() into ext4_block_zero_page_range().  Did you
> look into that option?
> 

ext4_block_zero_page_range() also called from ext4 truncate code path,
which only zero out within a block, but do not need to handle the
partial page unmap. There are two logical steps need by punch hole, one
is to zero out the non-block-aligned portion(like truncate), second is
to unmap_partial_page_buffers(). It seems cleaner to separate the two
logical steps out from the code simplify point of view.

Regards,
Mingming
> Regards,
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


