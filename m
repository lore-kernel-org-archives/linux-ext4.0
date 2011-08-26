From: Justin Maggard <jmaggard10@gmail.com>
Subject: Re: New resize interface implementation
Date: Fri, 26 Aug 2011 13:06:48 -0700
Message-ID: <CAKgsxVRTwoFgdsnbF7nd9AmQjsbHaK93AVMSpM1ac_wTifBbvw@mail.gmail.com>
References: <1313033308-882-1-git-send-email-xiaoqiangnk@gmail.com>
	<CAKgsxVQAwEetdyGcOciA8+wi_eLA7Fmq60kfDvEK1WzgYxdUMQ@mail.gmail.com>
	<CAGBYx2bdaGRMLmWiz752AGs9EfygXQU3nEMYxLNCCjVYkiuG-A@mail.gmail.com>
	<CAKgsxVSfrCt6tyxDdczLYFu0YeGXfuEAA=o_5T4TOkeNXSG8iA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61987 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab1HZUGt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Aug 2011 16:06:49 -0400
Received: by gya6 with SMTP id 6so3129321gya.19
        for <linux-ext4@vger.kernel.org>; Fri, 26 Aug 2011 13:06:48 -0700 (PDT)
In-Reply-To: <CAKgsxVSfrCt6tyxDdczLYFu0YeGXfuEAA=o_5T4TOkeNXSG8iA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Aug 17, 2011 at 12:28 AM, Yongqiang Yang <xiaoqiangnk@gmail.com=
> wrote:
> On Tue, Aug 16, 2011 at 8:22 AM, Justin Maggard <jmaggard10@gmail.com=
> wrote:
> > Does this patch set combined with your e2fsprogs patch add 64-bit r=
esize
> > support now, or does it just make it easier to add later?
> YES. e2fsprgos's patch is ready too.

So I finally got around to gather the hardware and patching all the
software components to try out this 64-bit expansion code. =A0The first
thing I noticed is that there is still a check to make sure the block
count is 32 bits. =A0However, I can get around it by specifying a size
string (something like "20T") rather than a block count, in which case
it will actually try the expansion.

> > If I am making a 64-bit ext4 filesystem today (20TB), and hoping to=
 resize
> > it next year to 30TB what features should I set? =A0In my searching=
 it sounded
> > like maybe I would need meta_bg, but it is not compatible with the =
default
> > resize_inode.
> You can understand meta_bg here http://linuxsoftware.co.nz/wiki/ext4.
> Now, ext4 with meta_bg does not support resize. =A0It is in ext4's TO=
DO list.
> The feature you should set is resize_inode.
>
> > Also, if I am making a <16TB filesystem today, should I turn on the=
 64-bit
> > flag in order to expand to >16TB in the future?
> Yes. =A0You should turn on 64 bit feature. =A0If the block number is =
32
> bit, the size it can support is 2^32 * 2^(log blocksize), =A04K
> blocksize as an example, it maximum size of a filesystem is 2^32 *
> 2^12 =3D 2^44 =3D 16TB.

I think this is where the real problem is with this 64-bit resize
support. =A0With the 64-bit flag set, the most I can expand by online i=
s
just 8TB over the life of the filesystem, because my reserved GDT
blocks get used up twice as fast as with a 32-bit filesystem. =A0Is
there any way around this?

-Justin
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
