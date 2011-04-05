From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] e2fsprogs: don't set stripe/stride to 1 block in mkfs
Date: Tue, 05 Apr 2011 09:56:06 -0700
Message-ID: <4D9B49A6.7000709@redhat.com>
References: <4D9A17F8.4000406@redhat.com> <F8519658-E9FA-4DD5-9980-59006CDACC8C@dilger.ca> <4D9B45AB.8000208@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Zeev Tarantov <zeev.tarantov@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849Ab1DEQ4L (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 Apr 2011 12:56:11 -0400
In-Reply-To: <4D9B45AB.8000208@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/5/11 9:39 AM, Eric Sandeen wrote:
> On 4/5/11 1:10 AM, Andreas Dilger wrote:
>> On 2011-04-04, at 9:11 AM, Eric Sandeen wrote:
>>> Block devices may set minimum or optimal IO hints equal to
>>> blocksize; in this case there is really nothing for ext4
>>> to do with this information (i.e. search for a block-aligned
>>> allocation?) so don't set fs geometry with single-block
>>> values.
>>>
>>> Zeev also reported that with a block-sized stripe, the
>>> ext4 allocator spends time spinning in ext4_mb_scan_aligned(),
>>> oddly enough.
>>>
>>> Reported-by: Zeev Tarantov <zeev.tarantov@gmail.com>
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>> ---
>>>
>>> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
>>> index 9798b88..74b838c 100644
>>> --- a/misc/mke2fs.c
>>> +++ b/misc/mke2fs.c
>>> @@ -1135,8 +1135,11 @@ static int get_device_geometry(const char *file,
>>> 	if ((opt_io == 0) && (psector_size > blocksize))
>>> 		opt_io = psector_size;
>>>
>>> -	fs_param->s_raid_stride = min_io / blocksize;
>>> -	fs_param->s_raid_stripe_width = opt_io / blocksize;
>>> +	/* setting stripe/stride to blocksize is pointless */
>>> +	if (min_io > blocksize)
>>> +		fs_param->s_raid_stride = min_io / blocksize;
>>> +	if (opt_io > blocksize)
>>> +		fs_param->s_raid_stripe_width = opt_io / blocksize;
>>
>> I don't think it is harmful to specify an mballoc alignment that is
>> an even multiple of the underlying device IO size (e.g. at least
>> 256kB or 512kB).
>>
>> If the underlying device (e.g. zram) is reporting 16kB or 64kB opt_io
>> size because that is PAGE_SIZE, but blocksize is 4kB, then we will
>> have the same performance problem again.> 
>> Cheers, Andreas
> 
> I need to look into why ext4_mb_scan_aligned is so inefficient for a block-sized stripe.
> 
> In practice I don't think we've seen this problem with stripe size at 4 or 8 or 16 blocks; it may just be less apparent.  I think the function steps through by stripe-sized units, and if that is 1 block, it's a lot of stepping.  
> 
>         while (i < EXT4_BLOCKS_PER_GROUP(sb)) {
> ...
>                 if (!mb_test_bit(i, bitmap)) {

Offhand I think maybe mb_find_next_zero_bit would be more efficient.

--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1939,16 +1939,14 @@ void ext4_mb_scan_aligned(struct ext4_allocation_context *ac,
        i = (a * sbi->s_stripe) - first_group_block;
 
        while (i < EXT4_BLOCKS_PER_GROUP(sb)) {
-               if (!mb_test_bit(i, bitmap)) {
-                       max = mb_find_extent(e4b, 0, i, sbi->s_stripe, &ex);
-                       if (max >= sbi->s_stripe) {
-                               ac->ac_found++;
-                               ac->ac_b_ex = ex;
-                               ext4_mb_use_best_found(ac, e4b);
-                               break;
-                       }
+               i = mb_find_next_zero_bit(bitmap, EXT4_BLOCKS_PER_GROUP(sb), i);
+               max = mb_find_extent(e4b, 0, i, sbi->s_stripe, &ex);
+               if (max >= sbi->s_stripe) {
+                       ac->ac_found++;
+                       ac->ac_b_ex = ex;
+                       ext4_mb_use_best_found(ac, e4b);
+                       break;
                }
-               i += sbi->s_stripe;
        }
 }

totally untested, but I think we have better ways to step through the bitmap.

-Eric

> ...
>                 }
>                 i += sbi->s_stripe;
>         }
> 
> But in any case, setting stripe alignment to 1 block makes no sense to me, and I see no reason to do it at mkfs time...
> 
> -Eric
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

