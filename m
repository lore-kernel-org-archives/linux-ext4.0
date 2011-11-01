From: Coly Li <i@coly.li>
Subject: Re: bigalloc and max file size
Date: Tue, 01 Nov 2011 20:22:17 +0800
Message-ID: <4EAFE479.3050304@coly.li>
References: <B327AF5F-B58A-43A2-BCB2-D0345F550D43@mit.edu> <97D9C5CC-0F22-4BC7-BDFA-7781D33CA7F3@whamcloud.com> <E0A4425F-9C68-4929-83CD-9B2CA3F87979@mit.edu> <4EACE2B7.9070402@coly.li> <F1D09DA1-3E1E-4D31-9F26-4AADAAF7A91D@mit.edu> <4EAE6BD4.9080705@coly.li> <583E0040-4EFA-4EBC-A738-A8968BB9135C@mit.edu> <422BEB28-76D0-4FD8-B7AE-130C9AAE10C0@dilger.ca> <20111031162223.GD16825@thunk.org> <4EAEDD56.6000709@coly.li> <20111031193837.GH16825@thunk.org> <4EAF471E.3030701@coly.li> <898A7160-25A8-44BA-B08B-C8FADC87F8EA@MIT.EDU>
Reply-To: i@coly.li
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>,
	Andreas Dilger <adilger@whamcloud.com>,
	linux-ext4 development <linux-ext4@vger.kernel.org>,
	Alex Zhuravlev <bzzz@whamcloud.com>, Tao Ma <tm@tao.ma>,
	"hao.bigrat@gmail.com" <hao.bigrat@gmail.com>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:58653 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753942Ab1KAMMY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Nov 2011 08:12:24 -0400
In-Reply-To: <898A7160-25A8-44BA-B08B-C8FADC87F8EA@MIT.EDU>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011=E5=B9=B411=E6=9C=8801=E6=97=A5 19:47, Theodore Tso Wrote:
>=20
> On Oct 31, 2011, at 9:10 PM, Coly Li wrote:
>>
>>> I assume the issue then is you
>>> want to minimize the number of extents, limited by the 15-bit exten=
t
>>> length field?
>> Not only extents, but also minimize inode table blocks, bitmap block=
s.
>=20
>=20
> So this makes no sense to me.  Bigalloc doesn't have any effect on th=
e number of inode table blocks, and while it certainly shrinks the numb=
er block allocation bitmap blocks, changing the extent tree format has =
no effect on the number of bitmap blocks.
>=20

In mkfs.ext4, with -N 16, there are still much more inodes allocated, b=
ecause for each block group there has to be some
inode blocks to be allocated. For bigalloc, same file system size may h=
ave less block groups, which results less inode
blocks.

>>>
>>> What cluster size are you thinking about?
>> Currently we test 1MB cluster size. The extreme ideal configuration =
(of one use case) is, there is only one block group
>> on the whole file system. (In this use case) we are willing to try b=
iggest possible cluster size if we are able to.
>=20
> This is where you have a single file which is nearly as big as the en=
tire file system?   In that case, why are you using an ext4 file system=
 at all?   Why not just use a raw partition instead, plus an auxiliary =
partition for the smaller files?
>=20

To make management simple and easy, sys-admin team trends to use on-han=
d Linux tools to manage the data, a raw disk
format is the last choice. Yes, your suggestion make senses, while ther=
e is open source project using raw disk for the
similar purpose, but it takes quit long time to deploy another stable s=
ystem to online servers ...

> I'm not being critical; I'm just trying to understand your use case a=
nd constraints.
>=20

I try to explain in one line why we are interested on bigalloc: try bes=
t to minimize all kinds of metadata space, both
on disk and in memory.

Thanks.
--=20
Coly Li
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
