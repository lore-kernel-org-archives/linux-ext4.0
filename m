From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: File System Selection
Date: Wed, 06 May 2009 10:04:19 -0500
Message-ID: <4A01A6F3.9010306@redhat.com>
References: <1241609864.806615859@192.168.1.201>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: ext3-users@redhat.com, linux-ext4@vger.kernel.org,
	A Garg <agarg@arasan.com>, Prashant <prashant@arasan.com>,
	Sridevi <sridevi@arasan.com>
To: Ramesh <ramesh@arasan.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33168 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655AbZEFPEV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 May 2009 11:04:21 -0400
In-Reply-To: <1241609864.806615859@192.168.1.201>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ramesh wrote:
> Hi Eric,
> 
> Thanks for your prompt and informative reply.
> 
>>>> do you mean sector size of the block device, or block size of
>>>> the fileystem?
> For our device sector size is 4906 bytes. But the maximum allowed
> data chunk to read/write is 512( a.k.a Block size), restricted by
> specification.
> 
> By referring the wiki pages of EXT3
> (http://en.wikipedia.org/wiki/Ext3), I saw the below table.
> 
> Block size       Max file size  Max filesystem size
> 1 KiB            16 GiB         <2 TiB
> 2 KiB            256 GiB        <4 TiB
> 4 KiB            2 TiB          <8 TiB
> 8 KiB[limits 1]  2 TiB          <16 TiB

Above, block size means the filesystem block size.

For ext3, all 32 bits should be safe on recent kernels and userspace, so
I think the max filesystem sizes listed above are too small by half.

IOW, 4k filesystem blocks -> 16T max filesystem size.

> And by taking the values with the table, then for 512 bytes block
> size, Max file system supported is 1 TB only. Please correct me, if I
> assumed wrongly.

you cannot have a 512 byte block size in ext3, 1k is the minimum.

>>>> I guess it doesn't matter much either way, 2^32*512 is 2T.
> 
> In that 32 bit, it using the MSB as signed bit. So it can use maximum
> of 31 bits only. Is this correct?

all 32 bits should be safe now.

>>>> On a 32 bit machine you will be limited to 16T, this is
>>>> actually a page cache limitation.  But 2T should be fine.
> 
> Please clarify me that Ext4 is using a 48 bit addressing. Is this
> necessary to go for 64 bit machines to utilize Ext4 and manage up to
> and including 2TB size file system... Please clarify me.

The ext4 ondisk format does use 48 bits for physical addressing, but
userspace is still 32 bits only even for ext4.

-Eric

> Thanks in advance.
> 
> 
> Regards, Ramesh
