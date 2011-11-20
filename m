From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH v4 0/15] ext4: add new online resize interface
Date: Sun, 20 Nov 2011 11:14:20 +0800
Message-ID: <CAGBYx2a0T7sK9REJ8tb_FrVrPDBMfhHZj-mjS1ueSbznQy9JPg@mail.gmail.com>
References: <1321696641-14437-1-git-send-email-xiaoqiangnk@gmail.com>
	<E4904E52-7428-478D-AE2E-B29EA825CDB1@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"adilger@dilger.ca" <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <aedilger@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35391 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754901Ab1KTDOV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Nov 2011 22:14:21 -0500
Received: by ywt32 with SMTP id 32so3696099ywt.19
        for <linux-ext4@vger.kernel.org>; Sat, 19 Nov 2011 19:14:20 -0800 (PST)
In-Reply-To: <E4904E52-7428-478D-AE2E-B29EA825CDB1@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 20, 2011 at 2:13 AM, Andreas Dilger <aedilger@gmail.com> wr=
ote:
> On 2011-11-19, at 2:57, Yongqiang Yang <xiaoqiangnk@gmail.com> wrote:
>> This patch series adds new resize implementation to ext4.
>>
>> -- What's new resize implementation?
>> =A0 It is a new online resize interface for ext4. =A0It can be used =
via
>> =A0 ioctl with EXT4_IOC_RESIZE_FS and a 64 bit integer indicating si=
ze
>> =A0 of the resized fs in block.
>>
>> -- Difference between current resize and new resize.
>> =A0 New resize lets kernel do all work, like allocating bitmaps and
>> =A0 inode tables and can support flex_bg and BLOCK_UNINIT features.
>> =A0 Besides these, new resize is much faster than current resize.
>>
>> =A0 Below are benchmarks I made on my personal computer, fses with
>> =A0 flex_bg size =3D 16 were resized to 230GB evry time. The first
>> =A0 row shows the size of a fs from which the fs was resized to 230G=
B.
>> =A0 The datas were collected by 'time resize2fs'.
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0new resize
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A020GB =A0 =A0 =A0 =A0 =A050GB =A0 =A0 =
=A0100GB
>> =A0 =A0 =A0real =A0 =A00m3.558s =A0 =A0 0m2.891s =A0 =A00m0.394s
>> =A0 =A0 =A0user =A0 =A00m0.004s =A0 =A0 0m0.000s =A0 =A00m0.394s
>> =A0 =A0 =A0sys =A0 =A0 0m0.048s =A0 =A0 0m0.048s =A0 =A00m0.028s
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0current resize
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A020GB =A0 =A0 =A0 =A0 =A050GB =A0 =A0 =
=A0100GB
>> =A0 =A0 =A0real =A0 =A05m2.770s =A0 =A0 4m43.757s =A03m14.840s
>> =A0 =A0 =A0user =A0 =A00m0.040s =A0 =A0 0m0.032s =A0 0m0.024s
>> =A0 =A0 =A0sys =A0 =A0 0m0.464s =A0 =A0 0m0.432s =A0 0m0.324s
>
> These stats must be backward, because resizing 20GB takes more time t=
han resizing 100GB.
Every time, the filesystem was resized from 20/50/100GB to 230GB, so
resizing 20GB should takes more time than resizing 100GB.   I am not
sure what you meant.

Yongqiang.
>
>> =A0 According to data above, new resize is faster than current resiz=
e in both
>> =A0 user and sys time. =A0New resize performs well in sys time, beca=
use it
>> =A0 supports BLOCK_UNINIT and adds multi-groups each time.
>>
>> -- About supporting new features.
>> =A0 YES! New resize can support new feature like bigalloc and exclud=
e bitmap
>> =A0 easily. =A0Because it lets kernel do all work.
>>
>> V3->V4:
>> =A0 rename __ext4_group_extend to ext4_group_extend_no_check.
>>
>> V2->V3:
>> =A0 initialize block bitmap of last group.
>> =A0 remove code initalizing inode bitmap and inode tables.
>>
>> Yongqiang.
>>
>> git diff --stat
>>
>> Documentation/filesystems/ext4.txt | =A0 =A07 +
>> fs/ext4/ext4.h =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0 10 +
>> fs/ext4/ioctl.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0| =A0 39 ++
>> fs/ext4/resize.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | 1167 ++++++++=
+++++++++++++++++++---------
>> 4 files changed, 942 insertions(+), 281 deletions(-)
>>
>>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
