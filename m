From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: New resize interface implementation
Date: Wed, 17 Aug 2011 15:28:28 +0800
Message-ID: <CAGBYx2bdaGRMLmWiz752AGs9EfygXQU3nEMYxLNCCjVYkiuG-A@mail.gmail.com>
References: <1313033308-882-1-git-send-email-xiaoqiangnk@gmail.com>
	<CAKgsxVQAwEetdyGcOciA8+wi_eLA7Fmq60kfDvEK1WzgYxdUMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Justin Maggard <jmaggard10@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:48978 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab1HQH23 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 17 Aug 2011 03:28:29 -0400
Received: by mail-pz0-f42.google.com with SMTP id 37so608488pzk.1
        for <linux-ext4@vger.kernel.org>; Wed, 17 Aug 2011 00:28:29 -0700 (PDT)
In-Reply-To: <CAKgsxVQAwEetdyGcOciA8+wi_eLA7Fmq60kfDvEK1WzgYxdUMQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 16, 2011 at 8:22 AM, Justin Maggard <jmaggard10@gmail.com> =
wrote:
> Hi,
Hi Justin,
> I saw your patch, and I am excited to see online resize support of ve=
ry
> large filesystems. =A0I was hoping you could answer a few additional =
questions
> for me.
My pleasure.
> Does this patch set combined with your e2fsprogs patch add 64-bit res=
ize
> support now, or does it just make it easier to add later?
YES. e2fsprgos's patch is ready too.

> If I am making a 64-bit ext4 filesystem today (20TB), and hoping to r=
esize
> it next year to 30TB what features should I set? =A0In my searching i=
t sounded
> like maybe I would need meta_bg, but it is not compatible with the de=
fault
> resize_inode.
You can understand meta_bg here http://linuxsoftware.co.nz/wiki/ext4.
Now, ext4 with meta_bg does not support resize.  It is in ext4's TODO l=
ist.
The feature you should set is resize_inode.

> Also, if I am making a <16TB filesystem today, should I turn on the 6=
4-bit
> flag in order to expand to >16TB in the future?
Yes.  You should turn on 64 bit feature.  If the block number is 32
bit, the size it can support is 2^32 * 2^(log blocksize),  4K
blocksize as an example, it maximum size of a filesystem is 2^32 *
2^12 =3D 2^44 =3D 16TB.

> Thank you for your time,
You are welcome.
> -Justin
> On Wed, Aug 10, 2011 at 8:28 PM, Yongqiang Yang <xiaoqiangnk@gmail.co=
m>
> wrote:
>>
>> Hi all,
>>
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
>>
>> =A0 According to data above, new resize is faster than current resiz=
e in
>> both
>> =A0 user and sys time. =A0New resize performs well in sys time, beca=
use it
>> =A0 supports BLOCK_UNINIT and adds multi-groups each time.
>>
>> -- About supporting new features.
>> =A0 YES! New resize can support new feature like bigalloc and exclud=
e bitmap
>> =A0 easily. =A0Because it lets kernel do all work.
>>
>> [PATCH 01/13] ext4: add a function which extends a group without
>> [PATCH 02/13] ext4: add a function which adds a new desc to a fs
>> [PATCH 03/13] ext4: add a function which sets up a new group desc
>> [PATCH 04/13] ext4: add a function which updates super block
>> [PATCH 05/13] ext4: add a structure which will be used by
>> [PATCH 06/13] ext4: add a function which sets up group blocks of a
>> [PATCH 07/13] ext4: add a function which adds several group
>> [PATCH 08/13] ext4: add a function which sets up a flex groups each
>> [PATCH 09/13] ext4: enable ext4_update_super() to handle a flex
>> [PATCH 10/13] ext4: pass verify_reserved_gdb() the number of group
>> [PATCH 11/13] ext4: add a new function which allocates bitmaps and
>> [PATCH 12/13] ext4: add a new function which adds a flex group to a
>> [PATCH 13/13] ext4: add new online resize interface
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
