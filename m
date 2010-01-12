From: Michal Novotny <minovotn@redhat.com>
Subject: Re: [PATCH] extend e2fsprogs functionality to add EXT2_FLAG_DIRECT
 option
Date: Tue, 12 Jan 2010 14:23:22 +0100
Message-ID: <4B4C77CA.3020007@redhat.com>
References: <4B46FCB2.1090308@redhat.com> <4B4B84E2.1050508@redhat.com> <4B4C54DC.4040006@redhat.com> <4B4C6429.6090803@redhat.com> <4B4C67F5.1020009@redhat.com> <20100112122319.GA20596@infradead.org> <4B4C6B70.1050205@redhat.com> <20100112124600.GA7151@infradead.org> <4B4C7297.5030905@redhat.com> <4B4C736B.6080403@redhat.com> <4B4C7547.8020309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201Ab0ALNXw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Jan 2010 08:23:52 -0500
In-Reply-To: <4B4C7547.8020309@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/12/2010 02:12 PM, Michal Novotny wrote:
> On 01/12/2010 02:04 PM, Ric Wheeler wrote:
>> On 01/12/2010 08:01 AM, Michal Novotny wrote:
>>> On 01/12/2010 01:46 PM, Christoph Hellwig wrote:
>>>> On Tue, Jan 12, 2010 at 01:30:40PM +0100, Michal Novotny wrote:
>>>>> Not really, pygrub doesn't do any manipulation with file system and
>>>>> also, it's not working on a life file system. It's called before the
>>>>> guest boots up to read information about grub.conf/initrd and 
>>>>> kernel for
>>>>> PV guest and after this is read and selected in pygrub then the 
>>>>> guest is
>>>>> booted using the kernel and initrd extracted from the image (after 
>>>>> which
>>>>> the file is closed). Once again, nothing uses write support and it 
>>>>> was
>>>>> added just to make it use O_DIRECT for both read and write operations
>>>>> but only pygrub uses only read support and O_DIRECT passed here is 
>>>>> the
>>>>> only way to make it use non-cached data.
>>>> So what caches get in the way? From the above it seems the situation
>>>> is the following:
>>>>
>>>> - filesystem N is a guest filesystem. It's not usually mounted on the
>>>> host, except for initial setup long time ago
>>>
>>> Yes, it is really a guest file system. This is not mounted in the host
>>> and the reason is to get actual version of grub.conf, initrd and kernel
>>> to be booted...
>>>
>>>> - before booting a guest your "pygrub" tools needs to read files on
>>>> it, and it's doing so using e2fsprogs
>>>
>>> Correct.
>>>
>>>> - once the guest is life it uses the extN kernel driver to access the
>>>> filesystem
>>>
>>> That's right. So this is no longer pygrub responsibility...
>>>
>>>> nowhere in this cycle you should have any stale cached data. The 
>>>> kernel
>>>> always makes sure to write back data on umount/reboot, as does 
>>>> e2fsprogs
>>>> if actually used to write data (which you said is not the case 
>>>> anyway).
>>>
>>> In fact I was unable to run into those problems myself but
>>> reporter/customer did.
>>>
>>>> The only data that may be in the cache are unmodified data from reads
>>>> on the block device from either e2fsprogs or a suboptimal virtual 
>>>> block
>>>> device implementation, but these can't cause any problems.
>>> Michal
>>
>> If the guest is the only one (when running) that installs a new 
>> grub.conf file and kernel and it shuts down properly, you should be 
>> good. It if does not shut down cleanly, it could have a stale 
>> grub.conf file (or worse, a partially written one), but using 
>> O_DIRECT to bypass the file system cache should not help.
>>
>> If we cannot reproduce this failure, sounds like we need to go back 
>> and get a better understanding of what the customer saw?
>>
>> ric
>>
> That's right. I am going write an e-mail regarding this information to 
> the reproducer if this bug and tell him that I need more information 
> about what's happening at the customer side.
>
One more thing to point out, let's have a look at: 
https://bugzilla.redhat.com/show_bug.cgi?id=466681#c15 .This is about 
workaround to drop caches to be added to pygrub in the host machine 
using this command:

echo 1>  /proc/sys/vm/drop_caches

So this really looks like the caching issue if it's working fine after 
dropping the caches. That may be the reason why this could be fine with 
this patch present in e2fsprogs.

  Michal
