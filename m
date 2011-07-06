From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Change the handling of RAID stripe width
Date: Wed, 06 Jul 2011 17:40:33 -0500
Message-ID: <4E14E461.9080100@redhat.com>
References: <1309985245-14835-1-git-send-email-dehrenberg@google.com>	<4E14D130.6080605@redhat.com> <CAAK6Zt2RW_J7zPJfDWbN8kKBGx+bVCRXUEvbVoGrma_VD9i6Tw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>
To: Daniel Ehrenberg <dehrenberg@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574Ab1GFWkj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Jul 2011 18:40:39 -0400
In-Reply-To: <CAAK6Zt2RW_J7zPJfDWbN8kKBGx+bVCRXUEvbVoGrma_VD9i6Tw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 7/6/11 5:17 PM, Daniel Ehrenberg wrote:
> On Wed, Jul 6, 2011 at 2:18 PM, Eric Sandeen <sandeen@redhat.com> wrote:
>> On 7/6/11 3:47 PM, Dan Ehrenberg wrote:
>>> Previously, the stripe width was blindly used for determining the size
>>> of allocations. Now, the stripe width is used as a hint for the initial
>>> mb_group_prealloc; if it is greater than 1, then we make sure that
>>> mb_group_prealloc is some multiple of it, and otherwise it is ignored.
>>> mb_group_prealloc is always usable to adjust the preallocation strategy,
>>> not just when the stripe-width is 0 as before.
>>>
>>> Signed-off-by: Dan Ehrenberg <dehrenberg@google.com>
>>> ---
>>>  fs/ext4/mballoc.c |   40 +++++++++++++++++++++++++++++-----------
>>>  1 files changed, 29 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>>> index 6ed859d..710c27f 100644
>>> --- a/fs/ext4/mballoc.c
>>> +++ b/fs/ext4/mballoc.c
>>> @@ -127,13 +127,14 @@
>>>   * based on file size. This can be found in ext4_mb_normalize_request. If
>>>   * we are doing a group prealloc we try to normalize the request to
>>>   * sbi->s_mb_group_prealloc. Default value of s_mb_group_prealloc is
>>> - * 512 blocks. This can be tuned via
>>> - * /sys/fs/ext4/<partition/mb_group_prealloc. The value is represented in
>>> - * terms of number of blocks. If we have mounted the file system with -O
>>> + * 512 blocks. If we have mounted the file system with -O
>>>   * stripe=<value> option the group prealloc request is normalized to the
>>> - * stripe value (sbi->s_stripe)
>>> + * the smallest multiple of the stripe value (sbi->s_stripe) which is
>>> + * greater than the default mb_group_prealloc. This can be tuned via
>>> + * /sys/fs/ext4/<partition>/mb_group_prealloc. The value is represented in
>>> + * terms of number of blocks.
>>>   *
>>> - * The regular allocator(using the buddy cache) supports few tunables.
>>> + * The regular allocator (using the buddy cache) supports a few tunables.
>>>   *
>>>   * /sys/fs/ext4/<partition>/mb_min_to_scan
>>>   * /sys/fs/ext4/<partition>/mb_max_to_scan
>>> @@ -2471,7 +2472,26 @@ int ext4_mb_init(struct super_block *sb, int needs_recovery)
>>>       sbi->s_mb_stats = MB_DEFAULT_STATS;
>>>       sbi->s_mb_stream_request = MB_DEFAULT_STREAM_THRESHOLD;
>>>       sbi->s_mb_order2_reqs = MB_DEFAULT_ORDER2_REQS;
>>> +     /*
>>> +      * If the stripe width is 1, this makes no sense and
>>> +      * we set it to 0 to turn off stripe handling code.
>>> +      */
>>> +     if (sbi->s_stripe == 1)
>>> +             sbi->s_stripe = 0;
>>
>> This strikes me as a weird band-aid-y place to fix this up.
>>
>> Wouldn't it be better suited for the option-parsing code, and/or
>> in ext4_get_stripe_size()?  Why let a value of 1 get this far
>> only to override it here?
>>
>> -Eric
> 
> The mount option parsing code wouldn't be a working place to do it,
> since it can be specified on-disk what the stripe size is. But

well I think that the mount option overrides the on disk value, since the
first thing that ext4_get_stripe_size() does is look for s_stripe
and return it if it's already set.

I just think it's good to keep this stuff consolidated, and not
sprinkle special-cases and error checking around in the code 
too much... complicated enough already IMHO.

-Eric

> ext4_get_stripe_size might be a good place to put it instead. I guess
> there are two unrelated parts to this patch: handling where the stripe
> width was set to 1, and handling where it's more than 1 but much less
> than what it should be.
> 
> Dan
> 
> Dan

