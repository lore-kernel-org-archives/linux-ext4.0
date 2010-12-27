From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: question about file space preallocation with fallocate
Date: Mon, 27 Dec 2010 11:11:14 -0800
Message-ID: <4D18E4D2.2040504@oracle.com>
References: <AANLkTinRcYrMrOUYqqCM3Lkpnhinm4NXqzDg1p2p0+68@mail.gmail.com>	<4D18CA33.6050800@oracle.com> <AANLkTinEnRaOEqZM9inVyVYW=hh68BC05f6d4Z6Cp7JF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Filipe David Manana <fdmanana@apache.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:22371 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab0L0TLw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Dec 2010 14:11:52 -0500
In-Reply-To: <AANLkTinEnRaOEqZM9inVyVYW=hh68BC05f6d4Z6Cp7JF@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/27/2010 09:57 AM, Filipe David Manana wrote:
> On Mon, Dec 27, 2010 at 5:17 PM, Sunil Mushran<sunil.mushran@oracle.com>  wrote:
>> fallocate() gives users the ability to allocate space instantly. One way
>> to compare would be to time just fallocate() with another program
>> writing zeros for that length.
>>
>> But that's not the aim of the syscall. The aim is to allow the fs to
>> allocate
>> the space in as large chunks as possible to allow for better read
>> performance.
>>
>> If you don't do fallocate() and allow writes to allocate in small chunks,
>> as you are doing, the allocations on disks could be interleaved in face of
>> multiple processes doing the same. Fragmented allocations can only hurt
>> read performance.
>>
> Thanks for the clarification Sunil. But preallocation of blocks
> shouldn't also improve write operations? Since each write operation
> will no longer cause the OS/filesystem to allocate blocks for the
> file, therefore should be faster.
>
> Also, any particular advice for improving write performance when all
> the writes are done in append-only fashion?

Even with meta-data journaling, the allocation overhead is tiny
compared to the 1G data write overhead.

Considering you are using ext4, you should benefit from delayed
allocation. But for that you'll need to have enough memory and
be running a 64-bit kernel. That way you wont be limited by the
speed of the disk.

Other option is submitting writes in larger chunks. Say 1MB rather
than 1KB.
