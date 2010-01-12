From: Michal Novotny <minovotn@redhat.com>
Subject: Re: [PATCH] extend e2fsprogs functionality to add EXT2_FLAG_DIRECT
 option
Date: Tue, 12 Jan 2010 14:04:05 +0100
Message-ID: <4B4C7345.8040306@redhat.com>
References: <4B46FCB2.1090308@redhat.com> <4B4B84E2.1050508@redhat.com> <4B4C54DC.4040006@redhat.com> <4B4C6429.6090803@redhat.com> <4B4C67F5.1020009@redhat.com> <20100112122319.GA20596@infradead.org> <4B4C6B70.1050205@redhat.com> <FFF8D206-0904-4A29-92A3-E1350495B321@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch@infradead.org>,
	Ric Wheeler <rwheeler@redhat.com>, linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27620 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab0ALNEf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Jan 2010 08:04:35 -0500
In-Reply-To: <FFF8D206-0904-4A29-92A3-E1350495B321@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/12/2010 01:47 PM, Andreas Dilger wrote:
> On 2010-01-12, at 08:30, Michal Novotny wrote:
>> On 01/12/2010 01:23 PM, Christoph Hellwig wrote:
>>> So to get things staigt:  you're using e2fsprogs to manipulate a life
>>> filesystem and thing using O_DIRECT saves your ass?  I think you 
>>> need to
>>> rething your model of operation fundamentally in that case.
>>>
>>
>> Not really, pygrub doesn't do any manipulation with file system and 
>> also, it's not working on a life file system. It's called before the 
>> guest boots up to read information about grub.conf/initrd and kernel 
>> for PV guest and after this is read and selected in pygrub then the 
>> guest is booted using the kernel and initrd extracted from the image 
>> (after which the file is closed). Once again, nothing uses write 
>> support and it was added just to make it use O_DIRECT for both read 
>> and write operations but only pygrub uses only read support and 
>> O_DIRECT passed here is the only way to make it use non-cached data.
>
>
> Michal, I think the thing that is confusing everyone is that if you 
> are not accessing a live filesystem, and you are not doing the writes 
> yourself, then why is it bad to read cached data?  How is it that the 
> cached data becomes stale if pygrub isn't modifying it, and there is 
> nothing else mounting the filesystem?
>
Hi Andreas,
it really is bad because the host have data about grub.conf, kernel and 
initrd cached but if you run the guest, update kernel or grub.conf etc., 
you need to see the changes here to boot the new/updated kernel now. Not 
the old, cached one. This is why it is bad to read cached data. Pygrub 
isn't modifying it but the guest can modify the data itself...

Thanks,
Michal
