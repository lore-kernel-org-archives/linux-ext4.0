From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: [PATCH 2/2] Add batched discard support for ext4.
Date: Sat, 24 Apr 2010 14:41:37 -0400
Message-ID: <4BD33B61.2080807@redhat.com>
References: <1271674527-2977-1-git-send-email-lczerner@redhat.com>	 <x49zl0w1uhh.fsf@segfault.boston.devel.redhat.com>	 <k2y87f94c371004211344xfd17387fwc62432d022145376@mail.gmail.com>	 <alpine.LFD.2.00.1004230944070.2814@localhost>	 <w2x87f94c371004240624iba3cc79az1becd78ae0c0ce2@mail.gmail.com>	 <4BD2F69D.7070508@redhat.com>	 <o2y87f94c371004240730x389391dfka42a1e8abc498e1a@mail.gmail.com>	 <4BD30393.4050800@redhat.com>	 <h2n87f94c371004240803obefca41cg1ca8a727c1726827@mail.gmail.com>	 <4BD324B5.4030808@redhat.com> <p2i87f94c371004241130ya1642597g42bd77c3e3c351f1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Lukas Czerner <lczerner@redhat.com>,
	Jeff Moyer <jmoyer@redhat.com>,
	Mark Lord <kernel@teksavvy.com>, linux-ext4@vger.kernel.org,
	Edward Shishkin <eshishki@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021Ab0DXSlp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 24 Apr 2010 14:41:45 -0400
In-Reply-To: <p2i87f94c371004241130ya1642597g42bd77c3e3c351f1@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 04/24/2010 02:30 PM, Greg Freemyer wrote:
> On Sat, Apr 24, 2010 at 1:04 PM, Ric Wheeler<rwheeler@redhat.com>  wrote:
> <snip>
>    
>> Let's summarize.
>>
>> 1. Everyone agrees that doing larger discard instead of little discards is a
>> good thing.
>>
>> 2. Some devices care about this more than others (various types of SSD's and
>> arrays have different designs and performance with discards). Some devices
>> do small discards well, others don't.
>>
>> 3. How you get to those bigger discards in our implementation - using a
>> series of single range requests, using vectored requests, tracking extents
>> that can be combined in an rbtree or not - is something that we are working
>> on. Using rbtrees versus a bitmap efficiency is about DRAM consumption, not
>> performance of the resulting discard on the target.
>>
>> 4. Devices (some devices) can export their preferences in a standard way
>> (look in /sys/block/....).
>>
>> If you want to influence the code, please do try the various options on
>> devices you have at hand and report results.  That is what we are doing (we
>> includes Lukas, Eric, Jeff and others on this thread) will real devices from
>> vendors that have given us access. We are talking to them directly and
>> trying out different work loads but certainly welcome real world results and
>> suggestions.
>>
>> Thanks!
>>
>> Ric
>>      
> Ric,
>
> Is it also agreed by all that the current ext4 kernel implementation
> of calling discard is a poor solution for most hardware / block layers
> stacks / workloads and therefore is not worth retaining nor performing
> further benchmarks?
>
> I've not seen anyone arguing to keep the current kernel implementation
> and I for one accept the previously posted benchmarks that show it is
> not adding any value relative to the traditional non-discard case.
>
> Therefore benchmarks between the current hdparm/wiper.sh userspace
> implementation and a proposed new kernel implementation would be the
> most beneficial?
>
> I have yet to see any of those benchmarks posted.
>
> Greg
>    

Greg,

I don't like the user space wiper.sh approach in general, but running 
wiper.sh is entirely your choice.

Most users prefer having the file system and the IO stack take care of 
this for them, but again, entirely configurable.

The benchmarks we have done are often done on hardware that is under NDA 
so we cannot publish results across the board.

Feel free to run on hardware that you buy and share the results.

Thanks!

Ric

