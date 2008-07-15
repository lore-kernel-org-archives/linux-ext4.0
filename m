From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: ext4 64bit (disk >16TB) question
Date: Tue, 15 Jul 2008 10:08:42 -0400
Message-ID: <487CAF6A.8070403@redhat.com>
References: <87bq10w8gv.fsf@frosties.localdomain> <87y743vh3q.fsf@frosties.localdomain> <487CA331.8050403@redhat.com> <200807151601.20881.bs@q-leap.de>
Reply-To: rwheeler@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Goswin von Brederlow <goswin-v-b@web.de>,
	linux-ext4@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60391 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756118AbYGOOIp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jul 2008 10:08:45 -0400
In-Reply-To: <200807151601.20881.bs@q-leap.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Bernd Schubert wrote:
> On Tuesday 15 July 2008 15:16:33 Ric Wheeler wrote:
>   
>> Goswin von Brederlow wrote:
>>     
>>> Theodore Tso <tytso@mit.edu> writes:
>>>       
>>>> On Mon, Jul 14, 2008 at 09:50:56PM +0200, Goswin von Brederlow wrote:
>>>>         
>>>>> I found ext4 64bit patches for e2fsprogs 1.39 that fix at least
>>>>> mkfs. Does anyone know if there is an updated patch set for 1.41
>>>>> anywhere? And when will that be added to e2fsprogs upstream?
>>>>>           
>>>> Yes, this is correct.  The 1.39 64-bit patches break the shared
>>>> library ABI, and also there were some long-term problems with having
>>>> super-large bitmaps taking huge amounts of memory without some kind of
>>>> run-length encoding or other compression technique.  I decided to
>>>> reject the 1.39 approach because it would have caused short- and
>>>> long-term maintenance issues.
>>>>         
>>> Is that a problem for the kernel or for the user space? I notices that
>>> mke2fs 1.39 used over a gigabyte memory to format a >16TiB disk. While
>>> being a lot that is not really a problem here.
>>>
>>>       
>>>> At the moment 1.41 does not support > 32 bit block numbers.  The
>>>> priority was to get something which supported all of the other ext4
>>>> features out the door, since that would allow much better testing of
>>>> the ext4 code base.  We are now working on 64-bit support in
>>>> e2fsprogs, with mke2fs coming first, and the other tools coming later.
>>>> But yeah, good quality 64-bit e2fsprogs support is going to lag for a
>>>> bit.  Sorry, we're working as fast as we can, given the resources we
>>>> have.
>>>>         
>>> Will there be filesystem changes as well? The above mentioned
>>> run-length encoding sounds a bit like a new bitmap format or is that
>>> only supposed to be the in memory format in userspace?
>>>
>>> What is the plan of how to add 64-bit support to the shared lib now?
>>> Will you introduce a do_foo64() function in parallel to do_foo() to
>>> maintain abi compatibility? Will you add versioned symbols? Or will
>>> there be an abi break at some point?
>>>
>>> The reason I ask all this is because I'm willing to spend some time
>>> patching and testing. A single >16TiB filesystem instead of multiple
>>> smaller ones would be a great benefit for us.
>>>       
>> Can you give us any details about your use case? Is it hundreds of very
>> large files, or 100 million little ones?
>>     
>
> Depends on our customers. Though lustre is rather slow for small files and we 
> try to inform our customers about that. On the other hand there also also no 
> choices of cluster filesystem for small files.
>   

Thanks - so this is not an internal application, but hosting for various 
workloads? We have different scalability issues depending on the nature 
and mix of file sizes, etc.

>   
>> Any interesting hardware in the mix on the storage or server side?
>>     
>
> What exactly do you want to know? Usually we have a server-pair and Infortrend 
> Raid-units. Since lustre doesn't do any redundancy on its own, we usually 
> also have a raid1, raid5 or raid6 of several raid units.
>   

One thing that we have been working on/thinking about is how best to 
automatically self tune a file system to the storage. Today, XFS is 
probably the best normal linux file system at figuring out raid stripe 
size, etc. Getting this enhanced in ext4 could lead to a significant 
performance win for users who are not masters of performance tuning, etc.

How long would you wait for something like fsck to run to completion 
before you would need to go to back up tapes? 6 hours? 1 day? 1 week ;-) ?

> For ease of management and optimal performance, we need single partitions 
> larger than 8TiB (raid1) or 16TiB (raid5 or raid6). And the present 8TiB 
> limit strongly bites us.
>
>
> Cheers,
> Bernd
>   

Makes sense, thanks for the information!

Regards,

Ric


