From: Coly Li <i@coly.li>
Subject: Re: bigalloc and max file size
Date: Tue, 01 Nov 2011 01:39:34 +0800
Message-ID: <4EAEDD56.6000709@coly.li>
References: <5846CEDC-A1ED-4BB4-8A3E-E726E696D3E9@mit.edu> <EB03FF23-73BC-4FDC-B991-5EB3FEEB8DAE@whamcloud.com> <B327AF5F-B58A-43A2-BCB2-D0345F550D43@mit.edu> <97D9C5CC-0F22-4BC7-BDFA-7781D33CA7F3@whamcloud.com> <E0A4425F-9C68-4929-83CD-9B2CA3F87979@mit.edu> <4EACE2B7.9070402@coly.li> <F1D09DA1-3E1E-4D31-9F26-4AADAAF7A91D@mit.edu> <4EAE6BD4.9080705@coly.li> <583E0040-4EFA-4EBC-A738-A8968BB9135C@mit.edu> <422BEB28-76D0-4FD8-B7AE-130C9AAE10C0@dilger.ca> <20111031162223.GD16825@thunk.org>
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
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:52854 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932861Ab1JaRaH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 31 Oct 2011 13:30:07 -0400
In-Reply-To: <20111031162223.GD16825@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011=E5=B9=B411=E6=9C=8801=E6=97=A5 00:22, Ted Ts'o Wrote:
> On Mon, Oct 31, 2011 at 10:08:20AM -0600, Andreas Dilger wrote:
>> On 2011-10-31, at 4:22 AM, Theodore Tso <tytso@MIT.EDU> wrote:
[snip]
> I'm curious why TaoBao is so interested in changing the extent
> encoding for bigalloc file systems.  Currently we can support up to 1
> EB worth of physical block numbers, and 16TB of logical block numbers=
=2E
> Are you concerned about bumping into the 1 EB file system limit?  Or
> the 16 TB file size limit?  Or something else?
>=20
In some application, we allocate a big file which occupies most space o=
f a file system, while the file system built on
(expensive) SSD. In such configuration, we want less blocks allocated f=
or inode table and bitmap. If the max extent
length could be much big, there is chance to have much less block group=
s, which results more blocks for regular file.
Current bigalloc code does well already, but there is still chance to d=
o better. The sys-admin team believe
cluster-based-extent can help Ext4 to consume as less meta data memory =
as raw disk does, and gain as more available data
blocks as raw disks does, too. This is a small number on one single SSD=
, but in our cluster environment, this effort can
help to save a recognized amount of capex.

=46urther more, for HDFS with 128MB data block file, and the file syste=
m is formatted with 1MB cluster bigalloc. In worst
case, only one extent block read is needed to access an 128MB data bloc=
k file. (However, this case is about a chunk size
more than 64K, not compulsory for cluster-based-extent)

With inline-data and cluster-based-extent to bigalloc, we get more clos=
ed to the above goal.

P.S. When I finish typing this email, I find Andreas also explain the s=
imilar reason in his email, much more simple and
clear :-)
--=20
Coly Li
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
