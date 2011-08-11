From: Allison Henderson <achender@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1 v4] ext4: fix xfstests 75, 112, 127 punch hole failure
Date: Thu, 11 Aug 2011 14:31:01 -0700
Message-ID: <4E444A15.6000405@linux.vnet.ibm.com>
References: <1312698112-7836-1-git-send-email-achender@linux.vnet.ibm.com> <20110808024213.GC11497@thunk.org> <4E404D06.6010002@linux.vnet.ibm.com> <20110809164524.GA3422@thunk.org> <4E41A254.3030300@linux.vnet.ibm.com> <20110811031712.GF3625@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:48571 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210Ab1HKVbO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Aug 2011 17:31:14 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e35.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p7BLBcMa014952
	for <linux-ext4@vger.kernel.org>; Thu, 11 Aug 2011 15:11:38 -0600
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p7BLV2m2121350
	for <linux-ext4@vger.kernel.org>; Thu, 11 Aug 2011 15:31:05 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p7BLagjQ021629
	for <linux-ext4@vger.kernel.org>; Thu, 11 Aug 2011 15:36:42 -0600
In-Reply-To: <20110811031712.GF3625@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/10/2011 08:17 PM, Ted Ts'o wrote:
> On Tue, Aug 09, 2011 at 02:10:44PM -0700, Allison Henderson wrote:
>>> 	/*
>>> 	 * Now we need to zero out the non-block-aligned data.
>>> 	 * If the file space being truncated is smaller than
>>> 	 * than a block, just zero out the middle
>>> 	 */
>>>
>> Hmm, for this piece here, Im not sure I quite follow you.  I was
>> pretty sure that ext4_block_zero_page() only deals with ranges that
>> appear with in one block.
>
> Yes, that's true.  What I was objecting to in the comment is the
> phrase "smaller than a block".  That's not right, or it's only right
> if blocksize == page size.  That comment should really read, "if the
> file space is smaller than a ***page***" zero out the middle.
>
> That's what happens in ext4_block_zero_page(), and so it works
> correctly; but the comment is confusing, and it makes the reader think
> that all we only need to zero is based on block boundaries, when in
> fact when we look at zeroing memory, we have to base it on page
> boundaries.
>
> Basically for either punch or truncate what we must do is:
>
>     *) Zero partial pages
>     *) Unmap full pages
>     *) We take buffer_heads which have been freed and either
>        (a) detach them, or
>        (b) clear the mapped flag, to indicate that the block number
>             in the bh is invalid
>
> Using "unmap" for both pages and blocks can be confusing, since for
> pages, unmapping means that we remove the page completely from the
> page cache, so any future attempt to read from that virtual memory
> address will result in a zero page getting mapped in.
>
> However, for buffers, "unmapping" merely means that we are removing
> the mapping to the disk block which has been deallocated by the punch
> operation.  It does not result in anything getting zero'ed out in the
> _page_ cache, which is why we need to zero out partial pages.
>
> Does that make sense?
>
> 						- Ted

Ah, ok then that makes sense.  So maybe what I need to do is modify the 
ext4_block_zero_page routine to zero everything in the specified range 
and then clear the mapped flag for any buffer header that is fully 
zeroed.  I'm not sure I'm clear about what it means to be detached 
though.  What is the difference between clearing the flag and detaching 
the buffer head?  Thank you for all the explaining!

Allison Henderson

