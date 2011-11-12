From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: ext4 on 32GB SD card.
Date: Fri, 11 Nov 2011 22:31:42 -0700
Message-ID: <943B6DE9-565D-45F7-8288-11E9BAC3EFE1@dilger.ca>
References: <CAAMvbhF2tBWZduzZFx_sp_V2YVssPjTqVJROyTHnpLBDJ1XK9g@mail.gmail.com> <20111112012019.GB4055@thunk.org>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: James Courtier-Dutton <james.dutton@gmail.com>,
	linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:61370 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab1KLFbo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 12 Nov 2011 00:31:44 -0500
In-Reply-To: <20111112012019.GB4055@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-11-11, at 6:20 PM, Ted Ts'o wrote:
> On Fri, Nov 11, 2011 at 12:31:19PM +0000, James Courtier-Dutton wrote:
>> 
>> I wish to use an SD card in an embedded device use the ext4 filesystem on it.
>> How much RAM would ext4 need to support this?
>> I am assuming ext4 holds some sort of allocation table/metadata in RAM.
> 
> The minimum amount of space which ext4 keeps pinned in memory for a
> 32G file system is 3 4k blocks, plus an in-core memory.  If you
> include things like the root directory that always have to be there,
> we're talking maybe 24k or so.  Of course, the moment you actually
> *do* something with the file system more metadata will get paged in,
> and if you are running with very little memory, blocks will get pushed
> out of memory, and then will have to read back into memory, and things
> like delayed allocation won't work as well.

Also, if you are running with a journal (which most ext4 users are),
the memory of the journal can be pinned in RAM as well.  The minimum
journal size is 1024 blocks, or 4MB with 4kB blocksize.  If your IO
or metadata rate is relatively low, then having a small journal is not
a serious impact to the performance.

> So you have to distinguish between "the bare minimum so you can mount
> a file system", and "what you need so that you have acceptably good
> performance for your workload" --- and that's going to be very
> dependent on your workload.
> 
> Also, note that with performance, it's highly dependant on the SD
> card; some SD cards are crap, and only support one write window at a
> time, and others may support 8 or more write windows.
> 
> The other question is making sure you have enough memory so that you
> can run e2fsck on a 32GB file system.
> 
> In general, the best thing to do is to try it, and see if it works.
> 
> Regards,
> 
> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





