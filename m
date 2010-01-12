From: Michal Novotny <minovotn@redhat.com>
Subject: Re: [PATCH] extend e2fsprogs functionality to add EXT2_FLAG_DIRECT
 option
Date: Tue, 12 Jan 2010 16:46:08 +0100
Message-ID: <4B4C9940.8060004@redhat.com>
References: <4B46FCB2.1090308@redhat.com> <4B4B84E2.1050508@redhat.com> <4B4C54DC.4040006@redhat.com> <4B4C6429.6090803@redhat.com> <4B4C67F5.1020009@redhat.com> <20100112122319.GA20596@infradead.org> <4B4C9244.2050704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	Ric Wheeler <rwheeler@redhat.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745Ab0ALPqh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Jan 2010 10:46:37 -0500
In-Reply-To: <4B4C9244.2050704@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/12/2010 04:16 PM, Eric Sandeen wrote:
> Christoph Hellwig wrote:
>    
>> On Tue, Jan 12, 2010 at 01:15:49PM +0100, Michal Novotny wrote:
>>      
>>> I don't really know if I see your point but the thing here is that there
>>> was no way to open a file directly (ie. using O_DIRECT). The direct
>>> write support has been added only to make it possible to use both read
>>> and write directly. The main reason to create this patch was to add
>>> direct read support and flush capability won't help me at all. I am
>>> working in Red Hat, Virtualization team on Xen so I am really not that
>>> much familiar with file systems but what I needed was an option to read
>>> the data directly (using O_DIRECT) in e2fsprogs. One bug was about
>>> pygrub (Python version of GRUB of Xen PV guests that is internally using
>>> e2fsprogs functionality to access data on ext2/3/4 partition to boot the
>>> PV guests) uses outdated/cached data so some modifications were
>>> necessary to open everything directly...
>>>        
>> So to get things staigt:  you're using e2fsprogs to manipulate a life
>> filesystem and thing using O_DIRECT saves your ass?  I think you need to
>> rething your model of operation fundamentally in that case.
>>
>>      
> Christoph -
>
> It's my understanding that nobody is doing concurrent access.
>
>    

Eric,
indeed, no concurrent accesses are happening that time. The guests file 
system seems to be cached since after dropping caches in host (dom0) it 
is reported to work correctly.

> If the host reads the block device via pygrub to boot the guest,
> the guest while running updates the same device when installing
> a new kernel (either through the fs, or by writing to the bdev;
> probably the former...), and then the guest shuts down - is there
> something which will sync the host's cache (cached from the
> prior read) with the updates from the guest?
>    

It appears that the data are cached in host (dom0) and another access 
(after guest update/shutdown sequence) makes dom0 still provide old 
(cached) data and not the current (newest) data.

Michal
