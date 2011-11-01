From: Coly Li <i@coly.li>
Subject: Re: bigalloc and max file size
Date: Tue, 01 Nov 2011 09:10:54 +0800
Message-ID: <4EAF471E.3030701@coly.li>
References: <B327AF5F-B58A-43A2-BCB2-D0345F550D43@mit.edu> <97D9C5CC-0F22-4BC7-BDFA-7781D33CA7F3@whamcloud.com> <E0A4425F-9C68-4929-83CD-9B2CA3F87979@mit.edu> <4EACE2B7.9070402@coly.li> <F1D09DA1-3E1E-4D31-9F26-4AADAAF7A91D@mit.edu> <4EAE6BD4.9080705@coly.li> <583E0040-4EFA-4EBC-A738-A8968BB9135C@mit.edu> <422BEB28-76D0-4FD8-B7AE-130C9AAE10C0@dilger.ca> <20111031162223.GD16825@thunk.org> <4EAEDD56.6000709@coly.li> <20111031193837.GH16825@thunk.org>
Reply-To: i@coly.li
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>,
	Andreas Dilger <adilger@whamcloud.com>,
	linux-ext4 development <linux-ext4@vger.kernel.org>,
	Alex Zhuravlev <bzzz@whamcloud.com>, Tao Ma <tm@tao.ma>,
	"hao.bigrat@gmail.com" <hao.bigrat@gmail.com>
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:59867 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933239Ab1KABBE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Oct 2011 21:01:04 -0400
In-Reply-To: <20111031193837.GH16825@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011=E5=B9=B411=E6=9C=8801=E6=97=A5 03:38, Ted Ts'o Wrote:
> On Tue, Nov 01, 2011 at 01:39:34AM +0800, Coly Li wrote:
>> In some application, we allocate a big file which occupies most spac=
e of a file system, while the file system built on
>> (expensive) SSD. In such configuration, we want less blocks allocate=
d for inode table and bitmap. If the max extent
>> length could be much big, there is chance to have much less block gr=
oups, which results more blocks for regular file.
>> Current bigalloc code does well already, but there is still chance t=
o do better. The sys-admin team believe
>> cluster-based-extent can help Ext4 to consume as less meta data memo=
ry as raw disk does, and gain as more available data
>> blocks as raw disks does, too. This is a small number on one single =
SSD, but in our cluster environment, this effort can
>> help to save a recognized amount of capex.
>=20
> OK, but you're not running into the 16TB file size limitation, are
> you? =20
No, we are not in this problem.

> That would be a lot of SSD's. =20
Yes, IMHO that's a lot of SSDs.

>I assume the issue then is you
> want to minimize the number of extents, limited by the 15-bit extent
> length field?
Not only extents, but also minimize inode table blocks, bitmap blocks.

>=20
> What cluster size are you thinking about?
Currently we test 1MB cluster size. The extreme ideal configuration (of=
 one use case) is, there is only one block group
on the whole file system. (In this use case) we are willing to try bigg=
est possible cluster size if we are able to.

And how do you plan to
> initialize it?  Via fallocate, or by explicitly writing zeros to the
> whole file (so all of the blocks are marked as initialzied?  Is it
> going to be sparse file?
In the above application I mentioned, the file is allocated by fallocat=
e(2). Writing to the file is appending write with
8MB length, when writing reaches file end, it goes back to the beginnin=
g of the file and continue to write.

Thanks.
--=20
Coly Li
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
