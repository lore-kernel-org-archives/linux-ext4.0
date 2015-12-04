From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: v4.4-rc3 ext4 memory leak
Date: Fri, 4 Dec 2015 10:22:32 -0500
Message-ID: <20151204152232.GB3548@thunk.org>
References: <5660C06B.4010003@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38823 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753130AbbLDPWf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Dec 2015 10:22:35 -0500
Content-Disposition: inline
In-Reply-To: <5660C06B.4010003@sandisk.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 03, 2015 at 02:21:31PM -0800, Bart Van Assche wrote:
> Hello,
> 
> Running xfstests on top of an ext4 filesystem causes kmemleak to report the
> following memory leak multiple times:
> 
> unreferenced object 0xffff880408709730 (size 96):
>   comm "fsstress", pid 35588, jiffies 4295006079 (age 11865.680s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 01 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff8151056a>] kmemleak_alloc+0x7a/0xc0
>     [<ffffffff81165e6e>] __kmalloc+0xde/0x140
>     [<ffffffffa022472e>] ext4_find_extent+0x26e/0x310 [ext4]
>     [<ffffffffa0227f15>] ext4_insert_range+0x255/0x3c0 [ext4]
>     [<ffffffffa022aca1>] ext4_fallocate+0x1f1/0x210 [ext4]
>     [<ffffffff81175fb6>] vfs_fallocate+0x156/0x1e0
>     [<ffffffff8117608e>] SyS_fallocate+0x4e/0x80
>     [<ffffffff8151b617>] entry_SYSCALL_64_fastpath+0x12/0x6f
>     [<ffffffffffffffff>] 0xffffffffffffffff

Is this something new?   i..e, was this reproducible on v4.3?

And can you isolate this to a specific test in xfstests?

Thanks,

						- Ted
