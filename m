From: Michal Novotny <minovotn@redhat.com>
Subject: Re: [PATCH] extend e2fsprogs functionality to add EXT2_FLAG_DIRECT
 option
Date: Tue, 12 Jan 2010 13:15:49 +0100
Message-ID: <4B4C67F5.1020009@redhat.com>
References: <4B46FCB2.1090308@redhat.com> <4B4B84E2.1050508@redhat.com> <4B4C54DC.4040006@redhat.com> <4B4C6429.6090803@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51916 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112Ab0ALMQS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Jan 2010 07:16:18 -0500
In-Reply-To: <4B4C6429.6090803@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/12/2010 12:59 PM, Ric Wheeler wrote:
> On 01/12/2010 05:54 AM, Michal Novotny wrote:
>> On 01/11/2010 09:06 PM, Ric Wheeler wrote:
>>> On 01/08/2010 04:36 AM, Michal Novotny wrote:
>>>> This patch extends functionality of e{2|4}fsprogs to add
>>>> EXT2_FLAG_DIRECT flag to be passed to ext2fs_open2() function. This
>>>> internally calls open() function with O_DIRECT and handles the memory
>>>> alignment for both read and write operations.
>>>> In some cases direct access to devices is necessary and that was the
>>>> main reason for this patch to be done.
>>>>
>>>> The main reason why this was done is that pygrub (used by xen
>>>> virtualization user-space package, it's a python version of grub for
>>>> paravirtualized guests) sometimes uses outdated version of grub.conf
>>>> file. Modifications to xen package were *not* enough because
>>>> e2fsprogs doesn't open the files directly. That's why I added
>>>> EXT2_FLAG_DIRECT support to make read/write operations work directly
>>>> when passed. It's been tested with pygrub like mentioned above for
>>>> read operation and it's working fine.
>>>>
>>>> Signed-off-by: Michal Novotny <minovotn@redhat.com>
>>>
>>> Can you add to this some kind of data flow overview? Seems like a
>>> really odd way to update this file system...
>>>
>>> ric
>>>
>> What do you mean by adding some kind of data flow overview? I am not
>> working on file systems but I needed option open files directly to be
>> added to e2fsprogs to make pygrub working right with not using
>> cached/outdated data so this was the first patch I did for file system
>> so I don't realy know what do you mean by data flow overview ...
>>
>> Thanks,
>> Michal
>
> Hi Michael,
>
> What would be useful is where the data is written (guest/host) and the 
> state of the file system (mounted/unmounted). Which app it is that 
> writes the data that gets cached, who needs to read it and misses that 
> cached data.
>
> From the above, it is really not clear that you should not be able to 
> use existing interfaces to flush any cached data to disk....
>
> ric
>
Hi Ric,
I don't really know if I see your point but the thing here is that there 
was no way to open a file directly (ie. using O_DIRECT). The direct 
write support has been added only to make it possible to use both read 
and write directly. The main reason to create this patch was to add 
direct read support and flush capability won't help me at all. I am 
working in Red Hat, Virtualization team on Xen so I am really not that 
much familiar with file systems but what I needed was an option to read 
the data directly (using O_DIRECT) in e2fsprogs. One bug was about 
pygrub (Python version of GRUB of Xen PV guests that is internally using 
e2fsprogs functionality to access data on ext2/3/4 partition to boot the 
PV guests) uses outdated/cached data so some modifications were 
necessary to open everything directly... It was done to Xen by a 
collegue but there was some open() call with no O_DIRECT set so I 
investigated this further and it turned out that this call was coming 
from e2fsprogs library. That was the reason why I needed to add O_DIRECT 
read support and O_DIRECT write support was added just to make it for 
both read and write. For write, yes, there may be the option to flush 
the disk but not for read. To workaround this but dropping caches is a 
really ugly idea so finally patching e2fsprogs too (along with Xen) 
turned out to the best idea. Once again, this was done to support 
O_DIRECT for read function only - it is *not* used for write function 
and it was added just to make it complete for both read and write 
functions. Regarding the functionality of read function, this is done in 
the host machine before the PV guest boots. It reads grub.conf, then it 
reads initrd and kernel and boots from it... Some incidents of booting 
outdated grub.conf/initrd and kernel has been reported to us and this 
patch is to make it don't use caches so outdated data can't be used...

Is the scenario clear or do you need some other information about that?

Thanks,
Michal
