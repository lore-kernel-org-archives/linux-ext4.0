From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] VFS: Pagecache usage optimization onpagesize!=blocksize
 environment
Date: Fri, 11 Jul 2008 16:39:01 -0700
Message-ID: <20080711163901.e6adee6c.akpm@linux-foundation.org>
References: <6.0.0.20.2.20080513205758.03a7a6b0@172.19.0.2>
	<20080521001930.202446eb.akpm@linux-foundation.org>
	<6.0.0.20.2.20080522160939.051ca938@172.19.0.2>
	<20080522010355.32590474.akpm@linux-foundation.org>
	<6.0.0.20.2.20080527172732.05447770@172.19.0.2>
	<20080527015135.561eeb6d.akpm@linux-foundation.org>
	<6.0.0.20.2.20080527175418.0554f348@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39938 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752278AbYGKXjg (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Jul 2008 19:39:36 -0400
In-Reply-To: <6.0.0.20.2.20080527175418.0554f348@172.19.0.2>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 27 May 2008 18:34:02 +0900 Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp> wrote:

> When we read some part of a file through pagecache, if there is a pagecache 
> of corresponding index but this page is not uptodate, read IO is issued and
> this page will be uptodate.
> I think this is good for pagesize == blocksize environment but there is room
> for improvement on pagesize != blocksize environment. Because in this case
> a page can have multiple buffers and even if a page is not uptodate, some buffers 
> can be uptodate. So I suggest that when all buffers which correspond to a part
> of a file that we want to read are uptodate, use this pagecache and copy data
> from this pagecache to user buffer even if a page is not uptodate. This can
> reduce read IO and improve system throughput.
> 
> v2: add new address_space_operations member is_partially_uptodate, and 
>      block_is_partially_uptodate was registered to ext2/3/4's aops.
>      modify do_generic_file_read to use this aops callback.
> v3: use unsigned instead of unsigned long in block_is_partially_uptodate.
>      cleaned up and simplified page buffer iteration code in block_is_partially_uptodate.
> 
> Signed-off-by :Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

ext4 has now gained a new set of address_space_operations:
ext4_da_aops.  I put a

        .is_partially_uptodate  = block_is_partially_uptodate,

into there as well, but I have no clue whether it will work OK.

