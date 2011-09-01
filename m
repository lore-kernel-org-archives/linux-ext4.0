From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: New resize interface implementation
Date: Thu, 1 Sep 2011 14:30:03 +0200
Message-ID: <CAOQ4uxg1JeyhpR4i5Krt0RJs5txpa+kKrMoBbU_n26Gzq+xkFw@mail.gmail.com>
References: <1313033308-882-1-git-send-email-xiaoqiangnk@gmail.com>
	<CAKgsxVQAwEetdyGcOciA8+wi_eLA7Fmq60kfDvEK1WzgYxdUMQ@mail.gmail.com>
	<CAGBYx2bdaGRMLmWiz752AGs9EfygXQU3nEMYxLNCCjVYkiuG-A@mail.gmail.com>
	<CAKgsxVSfrCt6tyxDdczLYFu0YeGXfuEAA=o_5T4TOkeNXSG8iA@mail.gmail.com>
	<CAKgsxVRTwoFgdsnbF7nd9AmQjsbHaK93AVMSpM1ac_wTifBbvw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Yongqiang Yang <xiaoqiangnk@gmail.com>
To: Justin Maggard <jmaggard10@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54521 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757370Ab1IAMaG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Sep 2011 08:30:06 -0400
Received: by wyh22 with SMTP id 22so927626wyh.19
        for <linux-ext4@vger.kernel.org>; Thu, 01 Sep 2011 05:30:05 -0700 (PDT)
In-Reply-To: <CAKgsxVRTwoFgdsnbF7nd9AmQjsbHaK93AVMSpM1ac_wTifBbvw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 26, 2011 at 10:06 PM, Justin Maggard <jmaggard10@gmail.com>=
 wrote:
> On Wed, Aug 17, 2011 at 12:28 AM, Yongqiang Yang <xiaoqiangnk@gmail.c=
om> wrote:
>> On Tue, Aug 16, 2011 at 8:22 AM, Justin Maggard <jmaggard10@gmail.co=
m> wrote:
>> > Does this patch set combined with your e2fsprogs patch add 64-bit =
resize
>> > support now, or does it just make it easier to add later?
>> YES. e2fsprgos's patch is ready too.
>
> So I finally got around to gather the hardware and patching all the
> software components to try out this 64-bit expansion code. =A0The fir=
st
> thing I noticed is that there is still a check to make sure the block
> count is 32 bits. =A0However, I can get around it by specifying a siz=
e
> string (something like "20T") rather than a block count, in which cas=
e
> it will actually try the expansion.

The fact that you can get around this check is a bug.
As you have observed, things won't be pretty if you try to resize over =
16TB
using resize inode and I don't think it is intended to work.


>
>> > If I am making a 64-bit ext4 filesystem today (20TB), and hoping t=
o resize
>> > it next year to 30TB what features should I set? =A0In my searchin=
g it sounded
>> > like maybe I would need meta_bg, but it is not compatible with the=
 default
>> > resize_inode.
>> You can understand meta_bg here http://linuxsoftware.co.nz/wiki/ext4=
=2E
>> Now, ext4 with meta_bg does not support resize. =A0It is in ext4's T=
ODO list.
>> The feature you should set is resize_inode.
>>
>> > Also, if I am making a <16TB filesystem today, should I turn on th=
e 64-bit
>> > flag in order to expand to >16TB in the future?
>> Yes. =A0You should turn on 64 bit feature. =A0If the block number is=
 32
>> bit, the size it can support is 2^32 * 2^(log blocksize), =A04K
>> blocksize as an example, it maximum size of a filesystem is 2^32 *
>> 2^12 =3D 2^44 =3D 16TB.
>
> I think this is where the real problem is with this 64-bit resize
> support. =A0With the 64-bit flag set, the most I can expand by online=
 is
> just 8TB over the life of the filesystem, because my reserved GDT
> blocks get used up twice as fast as with a 32-bit filesystem. =A0Is
> there any way around this?

The maximum reserved GDT blocks is EXT2_ADDR_PER_BLOCK(sb),
which is 1024 by default, just enough for expanding the 64-bit fs by 8T=
B,
as you have observed.
But also, resize inode cannot store 64-bit block addresses of GDT backu=
ps
beyond 16TB, so your fs (resize inode in particular) are most likely co=
rrupted.

There is no point in getting around these issues.
We should get on top of them and implement online resize of meta_bg.
If your intention is to create a 20TB fs today and resize it in the
(not very near) future
then you should probably use meta_bg instead of resize_inode.

Amir.
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
