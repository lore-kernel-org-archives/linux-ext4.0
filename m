From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: Fix max file size of extent format file
Date: Fri, 3 Jun 2011 20:08:03 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106032005390.3601@dhcp-27-109.brq.redhat.com>
References: <4DCA4406.4030601@sx.jp.nec.com> <alpine.LFD.2.00.1105130829160.3768@dhcp-27-109.brq.redhat.com> <F5B1FA61-6FD0-4A8A-8EEB-F4514116057E@dilger.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, Theodore Tso <tytso@mit.edu>,
	Kazuya Mio <k-mio@sx.jp.nec.com>,
	ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:32448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205Ab1FCSIN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 3 Jun 2011 14:08:13 -0400
In-Reply-To: <F5B1FA61-6FD0-4A8A-8EEB-F4514116057E@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 3 Jun 2011, Andreas Dilger wrote:

> On 2011-05-13, at 12:34 AM, Lukas Czerner wrote:
> > On Wed, 11 May 2011, Kazuya Mio wrote:
> >> We hit BUG_ON in ext4_ext_put_gap_in_cache() while creating a file
> >> whose size is the max file size of extent format. Because the extent cache
> >> length is 0 when we allocate two blocks to the file offset 2^32-2, and then
> >> the offset 2^32-1. To fix it, we decrease the max file size to
> >> (2^32-2)*blocksize. In this way, we would be able to allocate a block up to
> >> the offset 2^32-2. I think there is no data loss because we can read all files
> >> created before applying this patch.
> >> 
> >> How to reproduce:
> >> I'm running 2.6.39-rc6. Note that i386 architecture and 4KB blocksize cannot
> >> reproduce this problem.
> >> 
> >> # dd if=/dev/zero of=/mnt/mp1/file bs=<blocksize> count=1 seek=$((2**32-2))
> >> # sync
> >> # dd if=/dev/zero of=/mnt/mp1/file bs=<blocksize> count=1 seek=$((2**32-1))
> > 
> > Hi Kazuya,
> > 
> > Thanks for the patch, however I think that there is a better solution
> > than lowering the max file size, which is not necessary. I would rather
> > fix ext4_ext_put_gap_in_cache() and allow to invalidate the cache by
> > setting the length to zero.
> > 
> > Please see the following patch, if it works for you.
> 
> This thread has stalled.  Until we can come up with a better fix, I think
> we should land Kazuya's patch for the current merge window and then worry
> about allocating that last 4kB at the end of the 16TB file later (2.3e-6%
> of the file :-).

Wait just a sec, I am testing new version of my patch. I have tried and
failed with my approach. It seems that there is no way to do that
without also changing the struct ext4_ext_cache and other structures,
resulting in different on-disk format.

So I think that Kazuyas fix is good after all, however there is
unconsistency in using EXT_MAX_BLOCK and in comments as well. So I fixed
that as well.

Also I hit another bug, while testing this change so I'll send both as
a series shortly.

Thanks!
-Lukas

> 
> >> Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
> >> ---
> >> fs/ext4/super.c |    2 +-
> >> 1 file changed, 1 insertion(+), 1 deletion(-)
> >> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> >> index 8553dfb..fce0249 100644
> >> --- a/fs/ext4/super.c
> >> +++ b/fs/ext4/super.c
> >> @@ -2248,8 +2248,8 @@ static loff_t ext4_max_size(int blkbits, int has_huge_files)
> >> 
> >> 	/* 32-bit extent-start container, ee_block */
> >> 	res = 1LL << 32;
> >> -	res <<= blkbits;
> >> 	res -= 1;
> >> +	res <<= blkbits;
> >> 
> >> 	/* Sanity check against vm- & vfs- imposed limits */
> >> 	if (res > upper_limit)
> >> 
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 
> 

-- 
