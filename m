From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [PATCH 0/2] ext3: Reduce calling ext3_mark_inode_dirty() for
 speedup
Date: Mon, 06 Feb 2012 13:13:17 +0900
Message-ID: <4F2F535D.7050202@sx.jp.nec.com>
References: <4F2657AD.9060901@sx.jp.nec.com>	<97F0BDAD-B6D8-4246-B790-E269025F4A7D@dilger.ca>	<4F28F962.2040209@sx.jp.nec.com>	<E2F2E1D0-8937-419F-8201-B2E9F3961AD7@dilger.ca>	<4F2B919D.1030307@sx.jp.nec.com> <CAGBYx2ZATt7KG0oUvYSVWkwpVdio7iAJHHVHXFFkPqFp13Xi-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@dilger.ca>,
	ext4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:34382 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab2BFEQm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 Feb 2012 23:16:42 -0500
In-Reply-To: <CAGBYx2ZATt7KG0oUvYSVWkwpVdio7iAJHHVHXFFkPqFp13Xi-Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/02/03 22:28, Yongqiang Yang wrote:
> On Fri, Feb 3, 2012 at 3:49 PM, Kazuya Mio<k-mio@sx.jp.nec.com>  wrote:
>> 2012/02/03 7:36, Andreas Dilger wrote:
>>>>
>>>>   filesystem        time(sec)  call extX_mark_inode_dirty(times)
>>>>   ---
>>>>   ext3              220.5      50,338,104
>>>>   ext3 (patched)    196.3      25,169,658
>>>>   ext4 (*1)         190.3      28,465,799
>>>>   ext4 (*2)         201.5      27,963,473
>>>>   ext4 (default)    223.3      14,026,118
>>>>
>>>>   *1 disable ext4-specific options (delalloc, extent, and so on)
>>>>   *2 disable only delalloc option
>>>
>>> This shows that ext4 with extents+delalloc is _slower_ than ext3, which
>>> is very strange.  In other similar tests of write performance (see
>>
>>
>> One more thing is that ext4+delalloc is slower than ext4+nodelalloc.
> And according to the data, maybe ext4+extent is also slower than ext4+noextent.
>
> What's the size of the fs?  and what kind of the tested device?

I tested on Express5800/A1080a-S (4-way server with 8-core processors).
Filesystem size was 100GB. I used the 266GB LUN from the FC-SAN storage.

Regards,
Kazuya Mio
