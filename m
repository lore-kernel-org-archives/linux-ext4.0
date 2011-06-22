From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: exclude bitmap update
Date: Wed, 22 Jun 2011 21:04:29 +0300
Message-ID: <BANLkTinJvsEDCGqcQ_c2c8m4b-ZWJ7VJ7g@mail.gmail.com>
References: <BANLkTin2Q_U1Yi+-Pe0BZ2hcxsowEM5b0g@mail.gmail.com>
	<BANLkTikcvkre+=cVgt_jbN5g+BxZeuEs6g@mail.gmail.com>
	<BANLkTi=n=mZNdoSxxNcOLQ_tztYJBR6QOg@mail.gmail.com>
	<84DFE1C1-8604-4C1D-A50B-89F74FD9D143@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Yongqiang Yang <xiaoqiangnk@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:34109 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758489Ab1FVSEa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Jun 2011 14:04:30 -0400
Received: by wwg11 with SMTP id 11so1467245wwg.1
        for <linux-ext4@vger.kernel.org>; Wed, 22 Jun 2011 11:04:29 -0700 (PDT)
In-Reply-To: <84DFE1C1-8604-4C1D-A50B-89F74FD9D143@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 22, 2011 at 8:47 PM, Andreas Dilger <adilger@dilger.ca> wro=
te:
> On 2011-06-22, at 6:04 AM, Amir Goldstein wrote:
>
>> On Wed, Jun 22, 2011 at 2:17 PM, Yongqiang Yang <xiaoqiangnk@gmail.c=
om> wrote:
>>> If I am right, resize in userspace will be simpler.
>>
>> Yes, it will. very simple.
>> The only thing you need to do in userspace is check for online resiz=
e
>> support in the kernel,
>> like mke2fs does for lazy_itable_init:
>>
>> =A0 =A0 =A0 if (access("/sys/fs/ext4/features/lazy_itable_init", R_O=
K) =3D=3D 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 lazy_itable_init =3D 1;
>>
>>
>> We can either just create the /sys/fs/ext4/features/online_resize en=
try in
>> ext4_feat_attrs array with: EXT4_INFO_ATTR(online_resize);
>> to indicate the new ioctl is implemented by the kernel.
>>
>> Or we can export the specific features which are supported by online
>> resize with:
>> EXT4_RO_ATTR(online_resize);
>> and an online_resize_show() function.
>
> No, this is all much too complex, and not needed.

I suppose you are referring to advertising the features supported by re=
size.
I did get a bit carried away there ;-)

I see no harm is advertising the new ioctl support via
/sys/fs/ext4/features/online_resize.
Do you have an objection to that?

>
>> Maybe somebody has a better suggestion or maybe we should just
>> let the ioctl return ENOTSUP, like today, with unsupported features =
for resize.
>
> Right. =A0This will fail for old kernels where the ioctl isn't suppor=
ted, and
> succeed for new kernels where it is supported, and has no added compl=
exity.
>
>> Then, for example, if Andreas's group will add support for online re=
size with
>> 64bit and meta_bg features, they could use this interface to adverti=
se the
>> new resize capabilities to userspace.
>
> There is no need for this either. =A0If the kernel can do the resize =
(regardless
> of the features involved) it will succeed, and if it fails, it fails.=
 =A0Passing
> the new filesystem size is all that is needed. =A0If the user wants t=
o enable
> META_BG for resizing, this can be done via tune2fs/resize2fs from use=
rspace
> with the "s_first_meta_bg" value set to be the group after the end of=
 the
> filesystem, or possibly after the last group that would fit within th=
e last
> regular group descriptor block.
>
> Cheers, Andreas
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
