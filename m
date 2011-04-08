From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH] e2fsprogs: don't set stripe/stride to 1 block in mkfs
Date: Thu, 7 Apr 2011 18:13:23 -0600
Message-ID: <73371424-8E17-4BF4-BBF8-BA4E9B9EA7C1@dilger.ca>
References: <4D9A17F8.4000406@redhat.com> <F8519658-E9FA-4DD5-9980-59006CDACC8C@dilger.ca> <4D9B45AB.8000208@redhat.com> <4D9B49A6.7000709@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Zeev Tarantov <zeev.tarantov@gmail.com>,
	Alex Zhuravlev <bzzz@whamcloud.com>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:44908 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757140Ab1DHAN2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Apr 2011 20:13:28 -0400
In-Reply-To: <4D9B49A6.7000709@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On 2011-04-05, at 10:56 AM, Eric Sandeen wrote:

> On 4/5/11 9:39 AM, Eric Sandeen wrote:
>> Andreas Dilger wrote:
>>> I don't think it is harmful to specify an mballoc alignment that is
>>> an even multiple of the underlying device IO size (e.g. at least
>>> 256kB or 512kB).
>>> 
>>> If the underlying device (e.g. zram) is reporting 16kB or 64kB opt_io
>>> size because that is PAGE_SIZE, but blocksize is 4kB, then we will
>>> have the same performance problem again.> 
>>> Cheers, Andreas
>> 
>> I need to look into why ext4_mb_scan_aligned is so inefficient for a block-sized stripe.
>> 
>> In practice I don't think we've seen this problem with stripe size at 4 or 8 or 16 blocks; it may just be less apparent.  I think the function steps through by stripe-sized units, and if that is 1 block, it's a lot of stepping.  
>> 
>>        while (i < EXT4_BLOCKS_PER_GROUP(sb)) {
>> ...
>>                if (!mb_test_bit(i, bitmap)) {
> 
> Offhand I think maybe mb_find_next_zero_bit would be more efficient.
> 
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -1939,16 +1939,14 @@ void ext4_mb_scan_aligned(struct ext4_allocation_context *ac,
>        i = (a * sbi->s_stripe) - first_group_block;
> 
>        while (i < EXT4_BLOCKS_PER_GROUP(sb)) {
> -               if (!mb_test_bit(i, bitmap)) {
> -                       max = mb_find_extent(e4b, 0, i, sbi->s_stripe, &ex);
> -                       if (max >= sbi->s_stripe) {
> -                               ac->ac_found++;
> -                               ac->ac_b_ex = ex;
> -                               ext4_mb_use_best_found(ac, e4b);
> -                               break;
> -                       }
> +               i = mb_find_next_zero_bit(bitmap, EXT4_BLOCKS_PER_GROUP(sb), i);
> +               max = mb_find_extent(e4b, 0, i, sbi->s_stripe, &ex);
> +               if (max >= sbi->s_stripe) {
> +                       ac->ac_found++;
> +                       ac->ac_b_ex = ex;
> +                       ext4_mb_use_best_found(ac, e4b);
> +                       break;
>                }
> -               i += sbi->s_stripe;
>        }
> }
> 
> totally untested, but I think we have better ways to step through the bitmap.

This changes the allocation completely, AFAICS.  Instead of doing checks for chunks of free space aligned on sbi->s_stripe boundaries, it is instead finding the first free space of size s_stripe regardless of alignment.  That is not good for RAID back-ends, and is the primary reason for ext4_mb_scan_aligned() to exist.

I think my original assertion holds - that regardless of what the "optimal IO" size reported by the underlying device, doing larger allocations at the mballoc level that are even multiples of this size isn't harmful.  That avoids not only the performance impact of 4kB-sized "optimal IO", but also the (lesser) impact of 8kB-64kB "optimal IO" allocations as well.

Cheers, Andreas





