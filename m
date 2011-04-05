From: Zeev Tarantov <zeev.tarantov@gmail.com>
Subject: Re: [PATCH] e2fsprogs: don't set stripe/stride to 1 block in mkfs
Date: Tue, 5 Apr 2011 11:43:01 +0300
Message-ID: <BANLkTikNXr9R+odfKMnYGWNqDBYtu0ZTvw@mail.gmail.com>
References: <4D9A17F8.4000406@redhat.com> <F8519658-E9FA-4DD5-9980-59006CDACC8C@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Sandeen <sandeen@redhat.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45607 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab1DEInV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 5 Apr 2011 04:43:21 -0400
Received: by pvg12 with SMTP id 12so60209pvg.19
        for <linux-ext4@vger.kernel.org>; Tue, 05 Apr 2011 01:43:21 -0700 (PDT)
In-Reply-To: <F8519658-E9FA-4DD5-9980-59006CDACC8C@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Apr 5, 2011 at 11:10, Andreas Dilger <adilger@dilger.ca> wrote:
> On 2011-04-04, at 9:11 AM, Eric Sandeen wrote:
>> Block devices may set minimum or optimal IO hints equal to
>> blocksize; in this case there is really nothing for ext4
>> to do with this information (i.e. search for a block-aligned
>> allocation?) so don't set fs geometry with single-block
>> values.
>>
>> Zeev also reported that with a block-sized stripe, the
>> ext4 allocator spends time spinning in ext4_mb_scan_aligned(),
>> oddly enough.
>>
>> Reported-by: Zeev Tarantov <zeev.tarantov@gmail.com>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
>> index 9798b88..74b838c 100644
>> --- a/misc/mke2fs.c
>> +++ b/misc/mke2fs.c
>> @@ -1135,8 +1135,11 @@ static int get_device_geometry(const char *fi=
le,
>> =A0 =A0 =A0 if ((opt_io =3D=3D 0) && (psector_size > blocksize))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 opt_io =3D psector_size;
>>
>> - =A0 =A0 fs_param->s_raid_stride =3D min_io / blocksize;
>> - =A0 =A0 fs_param->s_raid_stripe_width =3D opt_io / blocksize;
>> + =A0 =A0 /* setting stripe/stride to blocksize is pointless */
>> + =A0 =A0 if (min_io > blocksize)
>> + =A0 =A0 =A0 =A0 =A0 =A0 fs_param->s_raid_stride =3D min_io / block=
size;
>> + =A0 =A0 if (opt_io > blocksize)
>> + =A0 =A0 =A0 =A0 =A0 =A0 fs_param->s_raid_stripe_width =3D opt_io /=
 blocksize;
>
> I don't think it is harmful to specify an mballoc alignment that is a=
n even multiple of the underlying device IO size (e.g. at least 256kB o=
r 512kB).
>
> If the underlying device (e.g. zram) is reporting 16kB or 64kB opt_io=
 size because that is PAGE_SIZE, but blocksize is 4kB, then we will hav=
e the same performance problem again.

I think I'm not understanding you. Are you objecting to the patch? If s=
o, why?
If io block is an even multiple of fs blocks, then mballoc really does
need to use the fancier aligning code (though for a ratio that is a
power of two, it shouldn't need to be slow).
In your example, If PAGE_SIZE is 16k and zram reports min and opt io
size as 16k but fs block is 4k, then Eric Sandeen's new code will set
stride and stripe to 4, as it should. Then mballoc will really need to
align blocks in groups of 4 and spending time doing that is not a
performance problem.

This patch is only meant to _not_ set stripe and stride to 1, which
cannot help block allocation and does in fact cause the kernel to
spend more cpu time because it does not detect the degenerate case.
Making the allocator faster in the case of a ratio that is a power of
two is the work of a different patch someone may want to write.
Using larger fs blocks in case the underlying block device prefers
larger io blocks is the work of the admin, I think.

> Cheers, Andreas

-Z.T.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
