From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Enable asynchronous commits by default patch revoked?
Date: Mon, 24 Aug 2009 18:12:11 -0400
Message-ID: <4A93103B.2000909@redhat.com>
References: <200908241033.10527.Christian.Fischer@easterngraphics.com> <20090824133447.GH23677@mit.edu> <20090824183119.GI5931@webber.adilger.int> <20090824201027.GC17684@mit.edu> <4A92F7E0.9010001@redhat.com> <20090824220738.GG17684@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@sun.com>,
	Christian Fischer <Christian.Fischer@easterngraphics.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901AbZHXWM4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Aug 2009 18:12:56 -0400
In-Reply-To: <20090824220738.GG17684@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> On Mon, Aug 24, 2009 at 04:28:16PM -0400, Ric Wheeler wrote:
>   
>> My issue with the async commit is that it is basically a detection  
>> mechanism.
>>
>> Drives will (almost always) write to platter sequential writes in order.  
>> Async commit lets us send down things out of order which means that we  
>> have a wider window of "bad state" for any given transaction...
>>     
>
> Sure, agreed.  But let's look a bit closer at what "async commit"
> really means.
>
> What ext3 and ext4 does by default is this:
>
> 1)  Write data blocks required by data=ordered mode (if any)
>
> 2)  Write the journal blocks
>
> 3)  Wait for the journal blocks to be sent to disk.  (We don't actually
> do a barrier operation), so this just means the blocks have been sent
> to the disk, not necessarily that they are forced to a platter.
>
> 4)  Write the commit block, with the barrier flag set.
>
> 5)  Wait for the commit block.
>
> -----
>
> What the current async commit code does is this:
>
> 1)  Write data blocks required by data=ordered mode (if any)
>
> 2)  Write the journal blocks
>
> 3)  Write the commit block, without a barrier.
>
> 4)  Wait for the journal blocks to be sent to disk.
>
> 5)  Wait for the commit block (since a barrier is requested, this is
> just when it was sent to the disk, not when it is actually committed
> to stable store).
>
> Since there are no barriers at all, the async mount option basically
> works the same as barriers=0, and is subject to exactly the same
> problems as barrier=0 --- problems which I've actually demonstrated
> exist in practice.
>
> ----
>
> What I think we can do safely in ext4 is this:
>
> 1)  Write data blocks required by data=ordered mode (if any)
>
> 2)  Write the journal blocks
>
> 3)  Write the commit block, WITH a barrier requested.
>
> 4)  Wait for the commit block to be completed.
>
> 5)  Wait for the journal blocks to be sent to disk.  #4 implies that
> all of the journal block I/O will have been completed, so this is just
> to collect the commit completion status; we should actually block
> during step #5, assuming the block layer's barrier operation was
> implemented correctly.
>
>
> This should save us a little bit, since it implies the commit record
> will be sent to disk in the same I/O request to the storage device as
> the the other journal blocks, which is _not_ currently the case today.
>
>
> Technically, what ext3 does today could result in problems, since
> without the barrier between the journal blocks and the commit block,
> the two could theoretically get reordered by the disk such that the
> commit block is written before the journal blocks are completely
> written --- and since ext3 doesn't have journal checksumming, this
> would never be noticed.  Fortunately in practice this generally won't
> happen since the commit block is adjacent to the rest of the journal
> blocks, so a sane disk drive will likely coalesce the two write
> requests together.
>
> 						- Ted
>
>   
I see that this might be slightly faster, but would be very interested 
in seeing that the gain is big enough to warrant the complexity :-)

ric

