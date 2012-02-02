From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 0/2] ext3: Reduce calling ext3_mark_inode_dirty() for speedup
Date: Thu, 2 Feb 2012 15:36:27 -0700
Message-ID: <E2F2E1D0-8937-419F-8201-B2E9F3961AD7@dilger.ca>
References: <4F2657AD.9060901@sx.jp.nec.com> <97F0BDAD-B6D8-4246-B790-E269025F4A7D@dilger.ca> <4F28F962.2040209@sx.jp.nec.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
To: Kazuya Mio <k-mio@sx.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:56194 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933144Ab2BBWg3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Feb 2012 17:36:29 -0500
In-Reply-To: <4F28F962.2040209@sx.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-02-01, at 1:35 AM, Kazuya Mio wrote:
> 2012/01/31 5:36, Andreas Dilger wrote:
>> Can you please run this same measurement on ext4 formatted and running
>> with the default options?  I'd like to know if this is still a problem
>> in ext4 or not.
> 
> I performed the same measurement on ext4 with the default options.

Kazuya,
thank you for running this test.  I'm unfortunately confused by the result.

> Here is its result:
> 
>   filesystem        time(sec)  call extX_mark_inode_dirty(times)
>   ---
>   ext3              220.5      50,338,104
>   ext3 (patched)    196.3      25,169,658
>   ext4 (*1)         190.3      28,465,799
>   ext4 (*2)         201.5      27,963,473
>   ext4 (default)    223.3      14,026,118
> 
>   *1 disable ext4-specific options (delalloc, extent, and so on)
>   *2 disable only delalloc option

This shows that ext4 with extents+delalloc is _slower_ than ext3, which
is very strange.  In other similar tests of write performance (see
http://downloads.linux.hp.com/~enw/ext4/3.2/large_file_creates.html,
showing multi-threaded 1GB file writes) ext4 is much faster than ext3.

Looking at your original email, is ext4 being tested on a RHEL 5.5
(2.6.18) kernel, or a more recent kernel?  It would be more useful
to run this on a more modern kernel, since the ext4 code backported
to RHEL5 was barely supporting delalloc at all, if I remember correctly.

The good news is that the number of extN_mark_inode_dirty() calls is
far lower in ext4 than in ext3, though this doesn't seem to be the
primary factor in the performance in this case.

Cheers, Andreas





