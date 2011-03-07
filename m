From: Eric Whitney <eric.whitney@hp.com>
Subject: Re: [PATCH] ext4: Use single thread to perform DIO unwritten convertion
Date: Mon, 07 Mar 2011 10:47:25 -0500
Message-ID: <4D74FE0D.4090207@hp.com>
References: <1299180594.2826.6.camel@mingming-laptop> <20110305174639.GD11120@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:16473 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab1CGPrW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Mar 2011 10:47:22 -0500
In-Reply-To: <20110305174639.GD11120@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 03/05/2011 12:46 PM, Ted Ts'o wrote:
> On Thu, Mar 03, 2011 at 11:29:54AM -0800, Mingming Cao wrote:
>> While running ext4 testing on multiple core, we found there are per
>> cpu ext4-dio-unwritten threads processing conversion from unwritten
>> extents to written for IOs completed from async direct IO patch.
>> Per filesystem is enough, we don't need per cpu threads to work on
>> conversion.
>>
>> Signed-off-by: Mingming Cao<cmm@us.ibm.com>
>
> Eric, would you be able to do a very quick sanity check on your
> 48-core machine?  I can definitely see how having a huge number of
> threads per file system could be problematic, especially on a system
> with 32 or 64 ext4 file systems.  I'm curious though if we'll end up
> taking a performance hit on direct I/O workloads.
>

Hi Ted:

Sure, I can do that - I'll queue it up once I'm done with the "for .39" 
patch measurements.

> If I remember correctly we currently have large file create with DIO
> turned off, right?  Would it be possible to do a large file create
> with DIO enabled, and do a quick run both with and without this patch?

That's right, we're not measuring DIO right now.  I think I've got 
enough hardware to run a filesystem per core (or more), and I think it 
should be straightforward to write a modified ffsb profile to run (say) 
48 filesystems in parallel.

>
> In the future it would also be interesting to see how we are doing
> versus other file systems using a DIO workload.  This is a probably
> another area where I suspect some lockstat and oprofile runs may give
> us opportunities for further optimization.

Yes - as discussed at Plumber's.  I'll put that on the list as well. 
With luck, there should be some time towards the end of the .39 merge 
window.

Eric

>
>         	     	  	  	      - Ted
