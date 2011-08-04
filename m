From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1 v3] ext4: fix xfstests 75, 112, 127 punch hole failure
Date: Thu, 04 Aug 2011 09:10:12 -0700
Message-ID: <4E3AC464.30709@linux.vnet.ibm.com>
References: <4E396744.2030003@linux.vnet.ibm.com> <20110804005001.GI3150@thunk.org> <4E3A48D2.3070905@linux.vnet.ibm.com> <20110804152519.GJ3150@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:54926 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab1HDQKh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Aug 2011 12:10:37 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p74G4EQs027041
	for <linux-ext4@vger.kernel.org>; Thu, 4 Aug 2011 10:04:14 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id p74GAPq9069522
	for <linux-ext4@vger.kernel.org>; Thu, 4 Aug 2011 10:10:26 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p74GAP1x020349
	for <linux-ext4@vger.kernel.org>; Thu, 4 Aug 2011 10:10:25 -0600
In-Reply-To: <20110804152519.GJ3150@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/04/2011 08:25 AM, Ted Ts'o wrote:
> On Thu, Aug 04, 2011 at 12:22:58AM -0700, Allison Henderson wrote:
>>
>> Oh, I think we do avoid calling the unmap for this last condition
>> though.  The first and last page offsets are calculated earlier for
>> calling truncate_inode_pages_range to release all the pages in the
>> hole. The idea is that everything from first_page_offset to
>> last_page_offset covers all the page aligned pages in the hole.  So
>> then if offset and length are aligned, we basically end up with
>> first_page_offset = offset and last_page_offset = offset + length,
>> and the page_len will turn out to be zero.  Right math?  Maybe we
>> can add some comments or something to help clarify.
>
> Yeah, sorry, I wasn't clear enough about the condition.  Consider the
> situation where we punch the region:
>
>     4092 -- 8197
>
> In the previous section of code, we would zero out the byte ranges
> 4092--4095 and 8192--8197.  What's left is a completely page-aligned
> range, which would have already been taken care of already.  But since
> we're calculating based on offsets, I believe there will be an
> unnecessary call to ext4_unmap_page_range().

Oh I see, that makes sense now :)  I will add in something to check for 
that condition.

>
> BTW, the name ext4_unmap_page_range() is a bit confusing; maybe we
> should rename it to ext4_unmap_partial_page_buffers()?
>
> I know you were copying from the ext4_block_zero_page_range() function
> and its calling sequence (but in my opinion that function wasn't named
> well and the comments in that code aren't good either).
>
> I also wonder why we can't fold the functionality found in
> ext4_unmap_page_range() into ext4_block_zero_page_range().  Did you
> look into that option?

Yes, an earlier version of this patch looked a lot like that. (It was 
reviewed on an internal list before it came to the ext4 list, but I keep 
the version numbers so that people on both lists dont get confused).  I 
guess it's just a question of whether people would prefer one complex 
function or two simple functions. I will send v2 to the ext4 list so 
that people can get an idea of what the complex version looks like.

I do think ext4_unmap_partial_page_buffers is probably a more 
descriptive name though. If we choose to keep it as a separate function, 
I will add that in.

Allison Henderson

>
> Regards,
>
> 						- Ted

