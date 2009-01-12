From: "Rohit Sharma" <imreckless@gmail.com>
Subject: Re: Copying Data Blocks
Date: Mon, 12 Jan 2009 11:48:26 +0530
Message-ID: <2d08ef090901112218v1c6820d7q98d39af1350a07a0@mail.gmail.com>
References: <2d08ef090901060236p46d4d396x797e4bceb24a2a34@mail.gmail.com>
	 <804dabb00901110715x2baf84e8kc0fc5d6fa2512fe8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>,
	Kernelnewbies <kernelnewbies@nl.linux.org>
To: "Peter Teoh" <htmldeveloper@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:57164 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbZALGS1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 12 Jan 2009 01:18:27 -0500
Received: by rv-out-0506.google.com with SMTP id k40so10079999rvb.1
        for <linux-ext4@vger.kernel.org>; Sun, 11 Jan 2009 22:18:26 -0800 (PST)
In-Reply-To: <804dabb00901110715x2baf84e8kc0fc5d6fa2512fe8@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I am having some issues in locking inode while copying data blocks.
We are trying to keep file system live during this operation, so
both read and write operations should work.
In this case what type of lock on inode should be used, semaphore,
mutex or spinlock?


On Sun, Jan 11, 2009 at 8:45 PM, Peter Teoh <htmldeveloper@gmail.com> wrote:
> Sorry.....some mistakes...a resent:
>
> Here are some tips on the blockdevice API:
>
> http://lkml.org/lkml/2006/1/24/287
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2006-01/msg09388.html
>
> as indicated, documentation is rather sparse in this area.
>
> not sure if anyone else have a summary list of blockdevice API and its
> explanation?
>
> not wrt the following "cleanup patch", i am not sure how the API will change:
>
> http://lwn.net/Articles/304485/
>
> thanks.
>
> On Tue, Jan 6, 2009 at 6:36 PM, Rohit Sharma <imreckless@gmail.com> wrote:
>>
>> I want to read data blocks from one inode
>> and copy it to other inode.
>>
>> I mean to copy data from data blocks associated with one inode
>> to the data blocks associated with other inode.
>>
>> Is that possible in kernel space.?
>> --
>
>
>
> --
> Regards,
> Peter Teoh
>
