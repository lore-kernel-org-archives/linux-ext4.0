From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: ext4 64bit (disk >16TB) question
Date: Tue, 15 Jul 2008 09:16:33 -0400
Message-ID: <487CA331.8050403@redhat.com>
References: <87bq10w8gv.fsf@frosties.localdomain>	<20080714234616.GD3382@mit.edu> <87y743vh3q.fsf@frosties.localdomain>
Reply-To: rwheeler@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116AbYGONQf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Jul 2008 09:16:35 -0400
In-Reply-To: <87y743vh3q.fsf@frosties.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Goswin von Brederlow wrote:
> Theodore Tso <tytso@mit.edu> writes:
>
>   
>> On Mon, Jul 14, 2008 at 09:50:56PM +0200, Goswin von Brederlow wrote:
>>     
>>> I found ext4 64bit patches for e2fsprogs 1.39 that fix at least
>>> mkfs. Does anyone know if there is an updated patch set for 1.41
>>> anywhere? And when will that be added to e2fsprogs upstream?
>>>       
>> Yes, this is correct.  The 1.39 64-bit patches break the shared
>> library ABI, and also there were some long-term problems with having
>> super-large bitmaps taking huge amounts of memory without some kind of
>> run-length encoding or other compression technique.  I decided to
>> reject the 1.39 approach because it would have caused short- and
>> long-term maintenance issues.
>>     
>
> Is that a problem for the kernel or for the user space? I notices that
> mke2fs 1.39 used over a gigabyte memory to format a >16TiB disk. While
> being a lot that is not really a problem here.
>
>   
>> At the moment 1.41 does not support > 32 bit block numbers.  The
>> priority was to get something which supported all of the other ext4
>> features out the door, since that would allow much better testing of
>> the ext4 code base.  We are now working on 64-bit support in
>> e2fsprogs, with mke2fs coming first, and the other tools coming later.
>> But yeah, good quality 64-bit e2fsprogs support is going to lag for a
>> bit.  Sorry, we're working as fast as we can, given the resources we
>> have.
>>     
>
> Will there be filesystem changes as well? The above mentioned
> run-length encoding sounds a bit like a new bitmap format or is that
> only supposed to be the in memory format in userspace?
>
> What is the plan of how to add 64-bit support to the shared lib now?
> Will you introduce a do_foo64() function in parallel to do_foo() to
> maintain abi compatibility? Will you add versioned symbols? Or will
> there be an abi break at some point?
>
> The reason I ask all this is because I'm willing to spend some time
> patching and testing. A single >16TiB filesystem instead of multiple
> smaller ones would be a great benefit for us.
>
>   
Can you give us any details about your use case? Is it hundreds of very 
large files, or 100 million little ones?

Any interesting hardware in the mix on the storage or server side?

Thanks!

Ric

