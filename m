From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: exclude bitmap update
Date: Wed, 22 Jun 2011 15:04:01 +0300
Message-ID: <BANLkTi=n=mZNdoSxxNcOLQ_tztYJBR6QOg@mail.gmail.com>
References: <BANLkTin2Q_U1Yi+-Pe0BZ2hcxsowEM5b0g@mail.gmail.com>
	<BANLkTikcvkre+=cVgt_jbN5g+BxZeuEs6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>, Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Yongqiang Yang <xiaoqiangnk@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56063 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582Ab1FVMED convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 22 Jun 2011 08:04:03 -0400
Received: by wyb38 with SMTP id 38so503107wyb.19
        for <linux-ext4@vger.kernel.org>; Wed, 22 Jun 2011 05:04:01 -0700 (PDT)
In-Reply-To: <BANLkTikcvkre+=cVgt_jbN5g+BxZeuEs6g@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 22, 2011 at 2:17 PM, Yongqiang Yang <xiaoqiangnk@gmail.com>=
 wrote:
> Hi Amir,
>
> Now the resize's input is a struct which determines blockbitmap ,
> inode bitmap and inode tables, then the kernel add groups.
>
> What we want to do is as follows.
>
> We need to remove IOC_EXTEND_GROUP and IOC_GROUP_ADD, and add

We do not remove them. we leave them to support resize with old
e2fsprogs version
when new features are not enabled (exclude_bitmap, big_alloc)

> IOC_RESIZE, =A0the input of which is a 64 bit argument which indicate=
s
> the nr. of blocks we want to add.

The argument is new nr. of blocks, just like in EXT4_IOC_GROUP_EXTEND,
not the nr. of blocks we want to add.

>
> Then the kernel will extend original last group and add groups and
> allocate bitmaps and inode tables for new groups.

Correct, and init them if needed (no uninit_bg, first flex_bg group,
last partial group).

>
> Am I right? =A0I am right, I am willing to propose a design to you. =A0=
If
> you think it is no problem, I will do the code work.
>

Please do the code work.

> If I am right, resize in userspace will be simpler.
>

Yes, it will. very simple.
The only thing you need to do in userspace is check for online resize
support in the kernel,
like mke2fs does for lazy_itable_init:

        if (access("/sys/fs/ext4/features/lazy_itable_init", R_OK) =3D=3D=
 0)
                lazy_itable_init =3D 1;


We can either just create the /sys/fs/ext4/features/online_resize entry=
 in
ext4_feat_attrs array with:
EXT4_INFO_ATTR(online_resize);
to indicate the new ioctl is implemented by the kernel.

Or we can export the specific features which are supported by online
resize with:
EXT4_RO_ATTR(online_resize);
and an online_resize_show() function.

Then, for example, if Andreas's group will add support for online resiz=
e with
64bit and meta_bg features, they could use this interface to advertise =
the
new resize capabilities to userspace.

Maybe somebody has a better suggestion or maybe we should just
let the ioctl return ENOTSUP, like today, with unsupported features for=
 resize.

Cheers,
Amir.

> Thank you,
> Yongqiang.
>
> On Tue, Jun 21, 2011 at 12:06 AM, Amir Goldstein <amir73il@gmail.com>=
 wrote:
>> Hi,
>>
>> A quick update from todays' ext4 conf call.
>> Ted says we should allow to add exclude bitmap by tune2fs.
>> And he says new resize ioctl should be just passing to the kernel th=
e
>> new 64bit size
>> and let the kernel do all the bitmap allocation logic.
>> So it simplifies the patch to resize2fs and adds another
>> exclude bitmap patch to the kernel.
>>
>> I will send a detailed design to the list later on.
>> As usual, please let me know if you want to continue this task
>> or to hand it over to me.
>>
>> Thanks,
>> Amir.
>>
>
>
>
> --
> Best Wishes
> Yongqiang Yang
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
