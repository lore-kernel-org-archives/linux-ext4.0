From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: Question about extents.c/ext4_ext_punch_hole
Date: Mon, 16 Jul 2012 08:36:06 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1207160829280.3857@dhcp-1-248.brq.redhat.com>
References: <5002BFAE.9030408@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	Lukas Czerner <lczerner@redhat.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Wang Sheng-Hui <shhuiw@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798Ab2GPGgS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Jul 2012 02:36:18 -0400
In-Reply-To: <5002BFAE.9030408@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 15 Jul 2012, Wang Sheng-Hui wrote:

> Date: Sun, 15 Jul 2012 21:03:42 +0800
> From: Wang Sheng-Hui <shhuiw@gmail.com>
> To: Allison Henderson <achender@linux.vnet.ibm.com>,
>     Lukas Czerner <lczerner@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
>     linux-ext4@vger.kernel.org
> Subject: Question about extents.c/ext4_ext_punch_hole
> 
> Dear all,
> 
> I'm reading the code of extents.c, and confused by the function "ext4_ext_punch_hole".
> 
> In my understanding, if we want to punch hole for the range (loff_t offset, loff_t length),
> then we finally will get one hole block-size aligned, right?
> 
> [code in ext4_ext_punch_hole]
> 	first_block = (offset + sb->s_blocksize - 1) >>
> 		EXT4_BLOCK_SIZE_BITS(sb);
> 	stop_block = (offset + length) >> EXT4_BLOCK_SIZE_BITS(sb);
> [code]
> 
> From the code, we'll get one hole range contained in the range [offset, length+offset-1].
> 
> For example, we set the block size to 1K, and we specify the range [offset:1000, offset:2000].
> Then we'll get first_block:1,stop_block:2, with some head/tail range ignored.
>       {-23------|===========|----952---}
>      1000      1024       2048        2999
>      offset                        offset+length-1
> '==='means punched hole here.
> 
> Please correct me if I'm wrong.
> 
> 
> Regards,

Hi,

your understanding is partially right. Indeed we're going to align
the range to the block size, but that's because blocks in this range
are going to be freed. Then, the rest of the range (non block
aligned) is going to be zeroed manually. The reason is that we can
not free those blocks, because it still contains valid data and we
can not just leave it alone, since after the punch hole finishes
we'll have to read zeroes from entire punched region.

Btw, there is a patch set on the list which reworks part of the
punch hole code patch, it starts with the path:

[PATCH 01/12 v2] Revert "ext4: remove no longer used functions in
inode.c"

I hope that helps.
-Lukas
