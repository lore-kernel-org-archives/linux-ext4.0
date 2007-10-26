From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: problem with delayed allocation option
Date: Fri, 26 Oct 2007 10:58:14 -0700
Message-ID: <1193421494.3895.53.camel@localhost.localdomain>
References: <4721DD74.20806@bull.net>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Alex Tomas <alex@clusterfs.com>,
	Andreas Dilger <adilger@clusterfs.com>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:54407 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652AbXJZR6P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 26 Oct 2007 13:58:15 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9QHwBUY024470
	for <linux-ext4@vger.kernel.org>; Fri, 26 Oct 2007 13:58:11 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9QHwBJR139558
	for <linux-ext4@vger.kernel.org>; Fri, 26 Oct 2007 13:58:11 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9QHwBqc014860
	for <linux-ext4@vger.kernel.org>; Fri, 26 Oct 2007 13:58:11 -0400
In-Reply-To: <4721DD74.20806@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 2007-10-26 at 14:28 +0200, Valerie Clement wrote:
> Hi all,
>=20
Hi Valerie,

> I ran a small test which creates one directory and 2O 8-KB size files=
 in it.
>=20
> When the filesystem is mounted without the delalloc option, here is t=
he
> output of the command dumpe2fs for the group in which the directory a=
nd=20
> the files are created:
>=20
> Group 532 : (Blocks 17432576-17465343)
>    Block bitmap at 17432576 (+0), Inode bitmap at 17432577 (+1)
>    Inode table at 17432578-17433089 (+2)
>    32213 free blocks, 16363 free inodes, 1 directories
>    Free blocks : 17433090-17459199, 17459241-17465343
>    Free inodes : 8716310-8732672
>=20
>=20
> When the filesystem is mounted with the delalloc option, the same tes=
t
> gives a different result:
>=20
> Group 395 : (Blocks 12943360-12976127)
>    Block bitmap at 12943360 (+0), Inode bitmap at 12943361 (+1)
>    Inode table at 12943362-12943873 (+2)
>    32213 free blocks, 16363 free inodes, 1 directories
>    Free blocks : 12943874-12955647, 12955650-12955655,=20
> 12955658-12955663, 12955666-12955671, 12955674-12955679,=20
> 12955682-12955687, 12955690-12955695, 12955698-12955703,=20
> 12955706-12955711, 12955714-12955719, 12955722-12955727,=20
> 12955730-12955735, 12955738-12955743, 12955746-12955751,=20
> 12955754-12955759, 12955762-12955767, 12955770-12955775,=20
> 12955778-12955783, 12955786-12955791, 12955794-12955799,=20
> 12955802-12961791, 12961793-12976127
>    Free inodes : 6471702-6488064
>=20
> In the first case, the allocated blocks are contiguous whereas they a=
re
> not in the second case.
>=20
> After adding traces in the code to understand why the behavior is
> different with the delalloc option, I found that the problem is relat=
ed
> to the inode reservation window.

> To simplify, without the delalloc option we have the following scenar=
io:
> For each inode,
>   - call alloc_new_reservation() to allocate a new reservation window
>   - allocate blocks for data
>   - write data to disk
>   - ext4_discard_reservation() when the inode is closed.
>=20
> With the delalloc option, when the data are written to disk we have:
> For each inode,
>   - call alloc_new_reservation() to allocate a new reservation window
>   - allocate blocks for data
>   - write data to disk
>=20
>=20
> I think a call to ext4_discard_reservation() is missing somewhere and
> the question is where.
>=20
Oh, that should be block reservation, not inode reservation window.

The problem with delayed allocation and block reservation is, we don't
know when suppose to close the window, as the file maybe closed with
diry data in cache,and the blocks has not be allocated yet. We would
like to keep the window open so that later delayed allocation happens,
the allocation could take advantage of the reservation. But on the othe=
r
hand, that may leads fs external fragmentation.

with mballoc, ext3 block reservation should be turned off and replaced
with the group-in-core-preallocation.=20

Has the new delayed allocation integrated with mballoc yet?

> I tried to add this call at the end of the ext4_da_get_block_write()
> function. This seems to fix the problem as the blocks are allocated
> contiguously on disk but the function seems to be called too many tim=
es
> so I think it is perhaps not the right place to call it.
>=20
> Who could look into this problem?
> I've got a few days off so I couldn't help more next days, but the
> problem is easily reproductible.
>=20
> Wouldn't this also explain why the compilebench results posted by Chr=
is
> Mason are bad in some cases?
>=20
>    Val=C3=A9rie
>=20
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
