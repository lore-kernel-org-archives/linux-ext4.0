From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] extend e2fsprogs functionality to add EXT2_FLAG_DIRECT
 option
Date: Tue, 12 Jan 2010 08:47:57 -0400
Message-ID: <FFF8D206-0904-4A29-92A3-E1350495B321@sun.com>
References: <4B46FCB2.1090308@redhat.com> <4B4B84E2.1050508@redhat.com>
 <4B4C54DC.4040006@redhat.com> <4B4C6429.6090803@redhat.com>
 <4B4C67F5.1020009@redhat.com> <20100112122319.GA20596@infradead.org>
 <4B4C6B70.1050205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Christoph Hellwig <hch@infradead.org>,
	Ric Wheeler <rwheeler@redhat.com>, linux-ext4@vger.kernel.org
To: Michal Novotny <minovotn@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:48760 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912Ab0ALMr6 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jan 2010 07:47:58 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o0CClw5J015068
	for <linux-ext4@vger.kernel.org>; Tue, 12 Jan 2010 04:47:58 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KW400B00WHPOD00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Tue,
 12 Jan 2010 04:47:58 -0800 (PST)
In-reply-to: <4B4C6B70.1050205@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-01-12, at 08:30, Michal Novotny wrote:
> On 01/12/2010 01:23 PM, Christoph Hellwig wrote:
>> So to get things staigt:  you're using e2fsprogs to manipulate a life
>> filesystem and thing using O_DIRECT saves your ass?  I think you  
>> need to
>> rething your model of operation fundamentally in that case.
>>
>
> Not really, pygrub doesn't do any manipulation with file system and  
> also, it's not working on a life file system. It's called before the  
> guest boots up to read information about grub.conf/initrd and kernel  
> for PV guest and after this is read and selected in pygrub then the  
> guest is booted using the kernel and initrd extracted from the image  
> (after which the file is closed). Once again, nothing uses write  
> support and it was added just to make it use O_DIRECT for both read  
> and write operations but only pygrub uses only read support and  
> O_DIRECT passed here is the only way to make it use non-cached data.


Michal, I think the thing that is confusing everyone is that if you  
are not accessing a live filesystem, and you are not doing the writes  
yourself, then why is it bad to read cached data?  How is it that the  
cached data becomes stale if pygrub isn't modifying it, and there is  
nothing else mounting the filesystem?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

