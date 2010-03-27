From: Andreas Dilger <andreas.dilger@oracle.com>
Subject: Re: FIEMAP sometimes returns bad information for delalloc extents
Date: Sat, 27 Mar 2010 11:52:56 -0600
Message-ID: <DB0601D5-963C-4017-B7EA-A3764D2067EF@oracle.com>
References: <E1NvXbm-00087i-Tf@closure.thunk.org>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:25431 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597Ab0C0Ryf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 27 Mar 2010 13:54:35 -0400
In-Reply-To: <E1NvXbm-00087i-Tf@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-03-27, at 09:07, Theodore Ts'o wrote:
> I was monitoring the progress of a distributed download program, and  
> saw
> the following output from two runs of filefrag taken a few seconds
> apart:
>
>   8     790  8825663  8825551     65
>   9     855        0  8825727    319 unknown,delalloc
>  10    1174  8798367      318    128
>
>   7     790  8825663  8825559     69
>   8    1174  8798367  8825731    128
>
> The length of the delalloc extent, 319, is bogus.  The 319 seems to  
> come
> from 1174 - 855.   But it's not actually the number of delayed
> allocation blocks, as we can see when the blocks finally get written;
> apparently it was only 4 blocks long.

I'm surprised it shows anything at all for delalloc blocks, since  
AFAIK FIEMAP is only walking the extent tree.  It would be interesting  
if it walked the VM pagetable for unallocated extents in the file, and  
beyond i_size.

> I don't have time to try to track this down just now, and it's not all
> that serious a bug since delalloc regions are by definition highly
> transient, but it does look like we have a bug here.


Cheers, Andreas
--
Andreas Dilger
Principal Engineer, Lustre Group
Oracle Corporation Canada Inc.

