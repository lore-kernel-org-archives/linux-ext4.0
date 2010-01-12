From: Michal Novotny <minovotn@redhat.com>
Subject: Re: [PATCH] extend e2fsprogs functionality to add EXT2_FLAG_DIRECT
 option
Date: Tue, 12 Jan 2010 13:30:40 +0100
Message-ID: <4B4C6B70.1050205@redhat.com>
References: <4B46FCB2.1090308@redhat.com> <4B4B84E2.1050508@redhat.com> <4B4C54DC.4040006@redhat.com> <4B4C6429.6090803@redhat.com> <4B4C67F5.1020009@redhat.com> <20100112122319.GA20596@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ric Wheeler <rwheeler@redhat.com>, linux-ext4@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41745 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743Ab0ALMbI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 Jan 2010 07:31:08 -0500
In-Reply-To: <20100112122319.GA20596@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 01/12/2010 01:23 PM, Christoph Hellwig wrote:
> On Tue, Jan 12, 2010 at 01:15:49PM +0100, Michal Novotny wrote:
>    
>> I don't really know if I see your point but the thing here is that there
>> was no way to open a file directly (ie. using O_DIRECT). The direct
>> write support has been added only to make it possible to use both read
>> and write directly. The main reason to create this patch was to add
>> direct read support and flush capability won't help me at all. I am
>> working in Red Hat, Virtualization team on Xen so I am really not that
>> much familiar with file systems but what I needed was an option to read
>> the data directly (using O_DIRECT) in e2fsprogs. One bug was about
>> pygrub (Python version of GRUB of Xen PV guests that is internally using
>> e2fsprogs functionality to access data on ext2/3/4 partition to boot the
>> PV guests) uses outdated/cached data so some modifications were
>> necessary to open everything directly...
>>      
> So to get things staigt:  you're using e2fsprogs to manipulate a life
> filesystem and thing using O_DIRECT saves your ass?  I think you need to
> rething your model of operation fundamentally in that case.
>
>    
Not really, pygrub doesn't do any manipulation with file system and 
also, it's not working on a life file system. It's called before the 
guest boots up to read information about grub.conf/initrd and kernel for 
PV guest and after this is read and selected in pygrub then the guest is 
booted using the kernel and initrd extracted from the image (after which 
the file is closed). Once again, nothing uses write support and it was 
added just to make it use O_DIRECT for both read and write operations 
but only pygrub uses only read support and O_DIRECT passed here is the 
only way to make it use non-cached data.
