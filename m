From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: question about file space preallocation with fallocate
Date: Mon, 27 Dec 2010 09:17:39 -0800
Message-ID: <4D18CA33.6050800@oracle.com>
References: <AANLkTinRcYrMrOUYqqCM3Lkpnhinm4NXqzDg1p2p0+68@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Filipe David Manana <fdmanana@apache.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:20378 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab0L0RUA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Dec 2010 12:20:00 -0500
In-Reply-To: <AANLkTinRcYrMrOUYqqCM3Lkpnhinm4NXqzDg1p2p0+68@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/27/2010 06:47 AM, Filipe David Manana wrote:
> Hi,
>
> I have been playing around with fallocate to preallocate space for a
> file with the mode FALLOC_FL_KEEP_SIZE.
> I'm running with Linux kernel 2.6.35-24 and ext4 as the fs.
>
> I'm allocating 1Gb for a newly created file and then in a loop I write
> 1Gb of data into that file in chunks of 1Kb.
> fallocate is returning me 0, therefore it was successful.
> However I don't see any performance gains compared to a version of
> that same code that doesn't call fallocate.
>
> The test code which does this is:  http://friendpaste.com/2UR0n2U851u4IXmubeLZh0
>
> Am I doing something wrong?

fallocate() gives users the ability to allocate space instantly. One way
to compare would be to time just fallocate() with another program
writing zeros for that length.

But that's not the aim of the syscall. The aim is to allow the fs to 
allocate
the space in as large chunks as possible to allow for better read
performance.

If you don't do fallocate() and allow writes to allocate in small chunks,
as you are doing, the allocations on disks could be interleaved in face of
multiple processes doing the same. Fragmented allocations can only hurt
read performance.
