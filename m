From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] ext4: Fix max file size of extent format file
Date: Fri, 3 Jun 2011 11:35:54 -0600
Message-ID: <F5B1FA61-6FD0-4A8A-8EEB-F4514116057E@dilger.ca>
References: <4DCA4406.4030601@sx.jp.nec.com> <alpine.LFD.2.00.1105130829160.3768@dhcp-27-109.brq.redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Kazuya Mio <k-mio@sx.jp.nec.com>, ext4 <linux-ext4@vger.kernel.org>
To: Lukas Czerner <lczerner@redhat.com>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:61536 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab1FCRf5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Jun 2011 13:35:57 -0400
In-Reply-To: <alpine.LFD.2.00.1105130829160.3768@dhcp-27-109.brq.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-05-13, at 12:34 AM, Lukas Czerner wrote:
> On Wed, 11 May 2011, Kazuya Mio wrote:
>> We hit BUG_ON in ext4_ext_put_gap_in_cache() while creating a file
>> whose size is the max file size of extent format. Because the extent cache
>> length is 0 when we allocate two blocks to the file offset 2^32-2, and then
>> the offset 2^32-1. To fix it, we decrease the max file size to
>> (2^32-2)*blocksize. In this way, we would be able to allocate a block up to
>> the offset 2^32-2. I think there is no data loss because we can read all files
>> created before applying this patch.
>> 
>> How to reproduce:
>> I'm running 2.6.39-rc6. Note that i386 architecture and 4KB blocksize cannot
>> reproduce this problem.
>> 
>> # dd if=/dev/zero of=/mnt/mp1/file bs=<blocksize> count=1 seek=$((2**32-2))
>> # sync
>> # dd if=/dev/zero of=/mnt/mp1/file bs=<blocksize> count=1 seek=$((2**32-1))
> 
> Hi Kazuya,
> 
> Thanks for the patch, however I think that there is a better solution
> than lowering the max file size, which is not necessary. I would rather
> fix ext4_ext_put_gap_in_cache() and allow to invalidate the cache by
> setting the length to zero.
> 
> Please see the following patch, if it works for you.

This thread has stalled.  Until we can come up with a better fix, I think
we should land Kazuya's patch for the current merge window and then worry
about allocating that last 4kB at the end of the 16TB file later (2.3e-6%
of the file :-).

>> Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
>> ---
>> fs/ext4/super.c |    2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
>> index 8553dfb..fce0249 100644
>> --- a/fs/ext4/super.c
>> +++ b/fs/ext4/super.c
>> @@ -2248,8 +2248,8 @@ static loff_t ext4_max_size(int blkbits, int has_huge_files)
>> 
>> 	/* 32-bit extent-start container, ee_block */
>> 	res = 1LL << 32;
>> -	res <<= blkbits;
>> 	res -= 1;
>> +	res <<= blkbits;
>> 
>> 	/* Sanity check against vm- & vfs- imposed limits */
>> 	if (res > upper_limit)
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas





