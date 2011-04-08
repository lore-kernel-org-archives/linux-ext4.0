From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs: don't set stripe/stride to 1 block in mkfs
Date: Thu, 07 Apr 2011 17:24:32 -0700
Message-ID: <4D9E55C0.5000607@redhat.com>
References: <4D9A17F8.4000406@redhat.com> <F8519658-E9FA-4DD5-9980-59006CDACC8C@dilger.ca> <4D9B45AB.8000208@redhat.com> <4D9B49A6.7000709@redhat.com> <73371424-8E17-4BF4-BBF8-BA4E9B9EA7C1@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Zeev Tarantov <zeev.tarantov@gmail.com>,
	Alex Zhuravlev <bzzz@whamcloud.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755609Ab1DHAYp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 7 Apr 2011 20:24:45 -0400
In-Reply-To: <73371424-8E17-4BF4-BBF8-BA4E9B9EA7C1@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/7/11 5:13 PM, Andreas Dilger wrote:
> 
> On 2011-04-05, at 10:56 AM, Eric Sandeen wrote:
> 
>> On 4/5/11 9:39 AM, Eric Sandeen wrote:
>>> Andreas Dilger wrote:
>>>> I don't think it is harmful to specify an mballoc alignment that is
>>>> an even multiple of the underlying device IO size (e.g. at least
>>>> 256kB or 512kB).
>>>>
>>>> If the underlying device (e.g. zram) is reporting 16kB or 64kB opt_io
>>>> size because that is PAGE_SIZE, but blocksize is 4kB, then we will
>>>> have the same performance problem again.> 
>>>> Cheers, Andreas
>>>
>>> I need to look into why ext4_mb_scan_aligned is so inefficient for a block-sized stripe.
>>>
>>> In practice I don't think we've seen this problem with stripe size at 4 or 8 or 16 blocks; it may just be less apparent.  I think the function steps through by stripe-sized units, and if that is 1 block, it's a lot of stepping.  
>>>
>>>        while (i < EXT4_BLOCKS_PER_GROUP(sb)) {
>>> ...
>>>                if (!mb_test_bit(i, bitmap)) {
>>
>> Offhand I think maybe mb_find_next_zero_bit would be more efficient.
>>
>> --- a/fs/ext4/mballoc.c
>> +++ b/fs/ext4/mballoc.c
>> @@ -1939,16 +1939,14 @@ void ext4_mb_scan_aligned(struct ext4_allocation_context *ac,
>>        i = (a * sbi->s_stripe) - first_group_block;
>>
>>        while (i < EXT4_BLOCKS_PER_GROUP(sb)) {
>> -               if (!mb_test_bit(i, bitmap)) {
>> -                       max = mb_find_extent(e4b, 0, i, sbi->s_stripe, &ex);
>> -                       if (max >= sbi->s_stripe) {
>> -                               ac->ac_found++;
>> -                               ac->ac_b_ex = ex;
>> -                               ext4_mb_use_best_found(ac, e4b);
>> -                               break;
>> -                       }
>> +               i = mb_find_next_zero_bit(bitmap, EXT4_BLOCKS_PER_GROUP(sb), i);
>> +               max = mb_find_extent(e4b, 0, i, sbi->s_stripe, &ex);
>> +               if (max >= sbi->s_stripe) {
>> +                       ac->ac_found++;
>> +                       ac->ac_b_ex = ex;
>> +                       ext4_mb_use_best_found(ac, e4b);
>> +                       break;
>>                }
>> -               i += sbi->s_stripe;
>>        }
>> }
>>
>> totally untested, but I think we have better ways to step through the bitmap.
> 
> This changes the allocation completely, AFAICS. Instead of doing
> checks for chunks of free space aligned on sbi->s_stripe boundaries,
> it is instead finding the first free space of size s_stripe
> regardless of alignment. That is not good for RAID back-ends, and is
> the primary reason for ext4_mb_scan_aligned() to exist.

Oh, er, right.  It's what I get for coding-at-conference, sorry.

I do wonder if test-bit/advance/test-bit/advance can be made a bit more efficient with something like find_next_bit.  I just did it wrong. :(

I'll revisit it when I get back home.

> I think my original assertion holds - that regardless of what the
> "optimal IO" size reported by the underlying device, doing larger
> allocations at the mballoc level that are even multiples of this size
> isn't harmful. That avoids not only the performance impact of
> 4kB-sized "optimal IO", but also the (lesser) impact of 8kB-64kB
> "optimal IO" allocations as well.> 
> Cheers, Andreas

I'll give that some thought; really, the whole align-on-a-stripe mechanism needs work, at least outside of the Lustre workload :)

Thanks,
-Eric
