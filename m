From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC] Metadata Replication for Ext4
Date: Fri, 21 Oct 2011 10:52:11 -0500
Message-ID: <4EA1952B.9070404@redhat.com>
References: <CAGr1F2EHCE2D-Sf+RS7q20huToUtqD3xqn9G8dtKrVxxpP4Hcw@mail.gmail.com> <alpine.LFD.2.00.1110191553500.29698@dhcp-27-109.brq.redhat.com> <FF85E3C6-8AB3-4A63-9E3D-06D06C778CEC@dilger.ca> <CAGr1F2GWXd=pfb3JECDwwzd70AczBHb3_yimaRRxmRAe9du_CQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>,
	Lukas Czerner <lczerner@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Nauman Rafique <nauman@google.com>,
	TheodoreTso <tytso@google.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	"Alasdair G.Kergon" <agk@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
To: Aditya Kali <adityakali@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751976Ab1JUPwV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Oct 2011 11:52:21 -0400
In-Reply-To: <CAGr1F2GWXd=pfb3JECDwwzd70AczBHb3_yimaRRxmRAe9du_CQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 10/20/11 5:45 PM, Aditya Kali wrote:
> On Wed, Oct 19, 2011 at 9:19 AM, Andreas Dilger <adilger@dilger.ca> wrote:
>> On 2011-10-19, at 8:10 AM, Lukas Czerner <lczerner@redhat.com> wrote:

...

>>> This way we'll get generic solution for all file systems, the only thing
>>> that file system should do in order to take an advantage of this is to
>>> mark its metadata writes accordingly.
>>>
>>> However there is one glitch, which is that we currently do not have an
>>> fs - dm(or raid, or whatever) interface, which would allow file system
>>> to ask for mirrored data (or fixed by error correction codes) in case
>>> that the original data are corrupted. But that is something which has to
>>> be done anyway, so we just have one more reason to do this sooner
>>> that later.
>>
>> Right, there needs to be some way for the upper layer to know which
>> copy was read, so that in case of a checksum failure it can request
>> the other copy. For RAID-5/6 it would need to know which disks were
>> used for parity (if any) and then request parity reconstruction
>> with a different disk until it matches the checksum.
>>
> 
> A generic block-replication mechanism would certainly be good to have.
> But I am not sure if doing it this way is easy or even the best way
> (wouldn't it break the abstraction if filesystem was to know about the
> raid layout underneath?). Even after adding support to raid layer to
> rebuild corrupted blocks at runtime (which probably won't be easy), we
> still need higher level setup (partitioning and dm setup) to make it
> work. This adds prohibitive management cost for using raid and device
> mapper setup on large number of machines in production.
> 
> We mainly came up with this approach to add resiliency at filesystem
> level irrespective of what (unreliable) hardware lies beneath.
> Moreover, we are planing to use this approach on SSDs (where the
> problem is observed to be more severe) with the replica stored on the
> same device. Having this as a filesystem feature provides simplicity
> in management and avoids overhead of going through more layers of
> code. The replica code will hook into just one or two places in the
> ext4 and the overhead introduced by it will be predictable and
> measurable.
> 
> What do you think ?
> 
> Thanks,

With an SSD, you -really- don't know the independent failure domains,
with all the garbage collection & remapping that they may do, right?

I have to say I'm in the same camp as others - this seems like a lot
of complexity for questionable gain.

Mitigating risks from unreliable hardware has almost always been done
more generically at the storage level with raid, etc.  That's the most
widely-applicable place to do it, without special casing one filesystem
on one problematic type of storage (in one company?)

If you have no concerns about your replica being on the same piece
of hardware, Dave's suggestion of a metadata device could still be used,
just carve out 3 partitions, mirror 2, use that for metadata, and put
data on the rest.

Admin complexity can easily be encapsulated in a script, right?

-Eric
