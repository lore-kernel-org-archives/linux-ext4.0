From: Michal Novotny <minovotn@redhat.com>
Subject: Re: [PATCH] extend e2fsprogs functionality to add EXT2_FLAG_DIRECT
 option
Date: Tue, 12 Jan 2010 18:00:39 +0100
Message-ID: <4B4CAAB7.5030008@redhat.com>
References: <4B46FCB2.1090308@redhat.com> <4B4B84E2.1050508@redhat.com> <4B4C54DC.4040006@redhat.com> <4B4C6429.6090803@redhat.com> <4B4C67F5.1020009@redhat.com> <20100112122319.GA20596@infradead.org> <4B4C6B70.1050205@redhat.com> <20100112124600.GA7151@infradead.org> <4B4C7297.5030905@redhat.com> <20100112163828.GA14633@infradead.org> <4B4CA6A9.3030401@redhat.com> <4B4CA868.2080204@redhat.com> <4B4CA916.7060405@redhat.com> <4B4CA9A6.1080608@redhat.com> <4B4CAA84.5060603@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338Ab0ALRBK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Jan 2010 12:01:10 -0500
In-Reply-To: <4B4CAA84.5060603@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/12/2010 05:59 PM, Ric Wheeler wrote:
> On 01/12/2010 11:56 AM, Eric Sandeen wrote:
>> Michal Novotny wrote:
>>> On 01/12/2010 05:50 PM, Ric Wheeler wrote:
>>>> On 01/12/2010 11:43 AM, Michal Novotny wrote:
>>>>> On 01/12/2010 05:38 PM, Christoph Hellwig wrote:
>>>>>> Ok, I looked at the issue. The problem is that the Xen backend 
>>>>>> drivers
>>>>>> are (as expected) utterly braindead and submit bios directly from 
>>>>>> the
>>>>>> virtualization backed without using proper abstractions and thus
>>>>>> bypassing all the cache coherency features in the fileystems (the 
>>>>>> block
>>>>>> device nodes are just another mini-filesystem in that respect). So
>>>>>> when you first have buffered access in the host pages may stay in 
>>>>>> cache
>>>>>> and get overwritten directly on disk by a Xen guest, and once the 
>>>>>> guest
>>>>>> is down the host may still use the now stale cached data.
>>>>>>
>>>>>> I would recommend to migrate your cutomers to KVM which uses the 
>>>>>> proper
>>>>>> abtractions and thus doesn't have this problem. There's a reason 
>>>>>> after
>>>>>> all why all the Xen dom0 mess never got merged to mainline.
>>>>> So, do you think the problem is in the Xen backend drivers and to 
>>>>> make
>>>>> it working right in Xen the driver fix is needed?
>>>>
>>>> If XEN drivers by pass the normal IO and FS stack on the host, then I
>>>> can understand why the hack to e2fsprogs works but it does not seem
>>>> like a good fix.
>>>>
>>>> Specifically, the data will continue to be cached (and if dirty, might
>>>> be written back to the storage eventually).
>>>>
>>>> If we need a work around, you need to drop VM caches for that device
>>>> before you update the guest's files and possibly again afterwards (and
>>>> make sure that nothing pulls the data into cache during the 
>>>> operation).
>>>>
>>>> Basically, this sounds like the backend drivers are doing something
>>>> really, really dangerous....
>>>>
>>>> ric
>>>>
>>> Ok, so you think this is not good to do this patch for e2fsprogs for
>>> direct access support? The only things we could do now is to fix the
>>> backend drivers or create a workaround to drop caches? I need to 
>>> discuss
>>> this further with guys in my team...
>>
>> I do think that patching it up in e2fsprogs is unnecessarily invasive;
>> it's fixing it at the wrong spot.
>>
>> Any block dev IO from the host is dangerous; fixing it only in e2fsprogs
>> for this one case doesn't seem like the right course of action.
>>
>> -Eric
>
> It actually could produce some nastier issues where it would work a 
> bit, the bad data gets flushed back to the backing store and then your 
> O_DIRECT read would be broken.
>
> Also, for normal users of e2fsprogs, they should never bypass the 
> cache...
>
> ric
Ok, good to know the normal users should never bypass the cache. That 
way this seems to be some kind of kernel bug...

Thank you all for your input,
Michal
