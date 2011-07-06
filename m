From: Daniel Ehrenberg <dehrenberg@google.com>
Subject: Re: [PATCH] ext4: Change the handling of RAID stripe width
Date: Wed, 6 Jul 2011 15:17:26 -0700
Message-ID: <CAAK6Zt2RW_J7zPJfDWbN8kKBGx+bVCRXUEvbVoGrma_VD9i6Tw@mail.gmail.com>
References: <1309985245-14835-1-git-send-email-dehrenberg@google.com>
	<4E14D130.6080605@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:38981 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab1GFWR3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 6 Jul 2011 18:17:29 -0400
Received: from kpbe14.cbf.corp.google.com (kpbe14.cbf.corp.google.com [172.25.105.78])
	by smtp-out.google.com with ESMTP id p66MHRRv012373
	for <linux-ext4@vger.kernel.org>; Wed, 6 Jul 2011 15:17:28 -0700
Received: from ywa12 (ywa12.prod.google.com [10.192.1.12])
	by kpbe14.cbf.corp.google.com with ESMTP id p66MGtlH032240
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-ext4@vger.kernel.org>; Wed, 6 Jul 2011 15:17:26 -0700
Received: by ywa12 with SMTP id 12so185887ywa.20
        for <linux-ext4@vger.kernel.org>; Wed, 06 Jul 2011 15:17:26 -0700 (PDT)
In-Reply-To: <4E14D130.6080605@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 6, 2011 at 2:18 PM, Eric Sandeen <sandeen@redhat.com> wrote=
:
> On 7/6/11 3:47 PM, Dan Ehrenberg wrote:
>> Previously, the stripe width was blindly used for determining the si=
ze
>> of allocations. Now, the stripe width is used as a hint for the init=
ial
>> mb_group_prealloc; if it is greater than 1, then we make sure that
>> mb_group_prealloc is some multiple of it, and otherwise it is ignore=
d.
>> mb_group_prealloc is always usable to adjust the preallocation strat=
egy,
>> not just when the stripe-width is 0 as before.
>>
>> Signed-off-by: Dan Ehrenberg <dehrenberg@google.com>
>> ---
>> =A0fs/ext4/mballoc.c | =A0 40 +++++++++++++++++++++++++++++---------=
--
>> =A01 files changed, 29 insertions(+), 11 deletions(-)
>>
>> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
>> index 6ed859d..710c27f 100644
>> --- a/fs/ext4/mballoc.c
>> +++ b/fs/ext4/mballoc.c
>> @@ -127,13 +127,14 @@
>> =A0 * based on file size. This can be found in ext4_mb_normalize_req=
uest. If
>> =A0 * we are doing a group prealloc we try to normalize the request =
to
>> =A0 * sbi->s_mb_group_prealloc. Default value of s_mb_group_prealloc=
 is
>> - * 512 blocks. This can be tuned via
>> - * /sys/fs/ext4/<partition/mb_group_prealloc. The value is represen=
ted in
>> - * terms of number of blocks. If we have mounted the file system wi=
th -O
>> + * 512 blocks. If we have mounted the file system with -O
>> =A0 * stripe=3D<value> option the group prealloc request is normaliz=
ed to the
>> - * stripe value (sbi->s_stripe)
>> + * the smallest multiple of the stripe value (sbi->s_stripe) which =
is
>> + * greater than the default mb_group_prealloc. This can be tuned vi=
a
>> + * /sys/fs/ext4/<partition>/mb_group_prealloc. The value is represe=
nted in
>> + * terms of number of blocks.
>> =A0 *
>> - * The regular allocator(using the buddy cache) supports few tunabl=
es.
>> + * The regular allocator (using the buddy cache) supports a few tun=
ables.
>> =A0 *
>> =A0 * /sys/fs/ext4/<partition>/mb_min_to_scan
>> =A0 * /sys/fs/ext4/<partition>/mb_max_to_scan
>> @@ -2471,7 +2472,26 @@ int ext4_mb_init(struct super_block *sb, int =
needs_recovery)
>> =A0 =A0 =A0 sbi->s_mb_stats =3D MB_DEFAULT_STATS;
>> =A0 =A0 =A0 sbi->s_mb_stream_request =3D MB_DEFAULT_STREAM_THRESHOLD=
;
>> =A0 =A0 =A0 sbi->s_mb_order2_reqs =3D MB_DEFAULT_ORDER2_REQS;
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* If the stripe width is 1, this makes no sense and
>> + =A0 =A0 =A0* we set it to 0 to turn off stripe handling code.
>> + =A0 =A0 =A0*/
>> + =A0 =A0 if (sbi->s_stripe =3D=3D 1)
>> + =A0 =A0 =A0 =A0 =A0 =A0 sbi->s_stripe =3D 0;
>
> This strikes me as a weird band-aid-y place to fix this up.
>
> Wouldn't it be better suited for the option-parsing code, and/or
> in ext4_get_stripe_size()? =A0Why let a value of 1 get this far
> only to override it here?
>
> -Eric

The mount option parsing code wouldn't be a working place to do it,
since it can be specified on-disk what the stripe size is. But
ext4_get_stripe_size might be a good place to put it instead. I guess
there are two unrelated parts to this patch: handling where the stripe
width was set to 1, and handling where it's more than 1 but much less
than what it should be.

Dan

Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
