From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: [PATCH 0/2] ext3: Reduce calling ext3_mark_inode_dirty() for
 speedup
Date: Fri, 03 Feb 2012 16:49:49 +0900
Message-ID: <4F2B919D.1030307@sx.jp.nec.com>
References: <4F2657AD.9060901@sx.jp.nec.com> <97F0BDAD-B6D8-4246-B790-E269025F4A7D@dilger.ca> <4F28F962.2040209@sx.jp.nec.com> <E2F2E1D0-8937-419F-8201-B2E9F3961AD7@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:37830 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab2BCHwY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Feb 2012 02:52:24 -0500
In-Reply-To: <E2F2E1D0-8937-419F-8201-B2E9F3961AD7@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/02/03 7:36, Andreas Dilger wrote:
>>   filesystem        time(sec)  call extX_mark_inode_dirty(times)
>>   ---
>>   ext3              220.5      50,338,104
>>   ext3 (patched)    196.3      25,169,658
>>   ext4 (*1)         190.3      28,465,799
>>   ext4 (*2)         201.5      27,963,473
>>   ext4 (default)    223.3      14,026,118
>>
>>   *1 disable ext4-specific options (delalloc, extent, and so on)
>>   *2 disable only delalloc option
> This shows that ext4 with extents+delalloc is _slower_ than ext3, which
> is very strange.  In other similar tests of write performance (see

One more thing is that ext4+delalloc is slower than ext4+nodelalloc.

> http://downloads.linux.hp.com/~enw/ext4/3.2/large_file_creates.html,
> showing multi-threaded 1GB file writes) ext4 is much faster than ext3.

I guess write buffer size of my test is different from ffsb's one.
My test calls write systemcall every time one block is allocated,
so it is close to the stress test I think.

> Looking at your original email, is ext4 being tested on a RHEL 5.5
> (2.6.18) kernel, or a more recent kernel?  It would be more useful
> to run this on a more modern kernel, since the ext4 code backported
> to RHEL5 was barely supporting delalloc at all, if I remember correctly.

I tested on the recent kernel (3.3-rc1).
I also tested on RHEL5.5, and its result showed that ext3 was much slower than
the recent kernel's one.

   filesystem        time(sec)
   ---
   ext3(RHEL5.5)     438.6
   ext3(3.3-rc1)     220.5

Regards,
Kazuya Mio
