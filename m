From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Regarding random grouop search start for allocation of inode.
Date: Fri, 4 Dec 2015 14:54:59 -0700
Message-ID: <AB526984-C3CC-4EBF-BF17-D7AAE33F2337@dilger.ca>
References: <CAKJOkCrU7b3XLKHFUS-_eyZ9Lvh7XoPcU15pjAs+qGy2o6XA-w@mail.gmail.com> <CAKJOkCoZExQv6mNMQ7kM_ihQ4B41WoNQJYF+pOhXKJLg-OOt+Q@mail.gmail.com> <ED92218E-3E81-456C-A6C6-37C2D32AD06B@dilger.ca> <CAKJOkCr7fsyTxCxPivOp9-0MsbPL0nMQCnAcGUjd=gDq7zS6uQ@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_8508C28C-81E0-4D0F-8449-6B998D8EDF58"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4@vger.kernel.org
To: lokesh jaliminche <lokesh.jaliminche@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:33904 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbbLDVzF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Dec 2015 16:55:05 -0500
Received: by igvg19 with SMTP id g19so45338691igv.1
        for <linux-ext4@vger.kernel.org>; Fri, 04 Dec 2015 13:55:04 -0800 (PST)
In-Reply-To: <CAKJOkCr7fsyTxCxPivOp9-0MsbPL0nMQCnAcGUjd=gDq7zS6uQ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_8508C28C-81E0-4D0F-8449-6B998D8EDF58
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Dec 3, 2015, at 12:13 PM, lokesh jaliminche =
<lokesh.jaliminche@gmail.com> wrote:
>=20
> Ohh thanks for the clarification. There is one more thing I would like
> to point out here.
> In the code there  is a loop to scan the groups for inode
> alllocation(Inside find_group_orlov function).
> There are some policies for group selection . while scanning the
> groups, it checks for these
> policies to be satisfied.
> If a particular group satisfy these properties it should get selected
> for inode allocation but instead
> it does further lookup in next groups.
> I think there is missing breaking condition. I have added break over
> there and here is the
> patch for that. Any reason for not having break condition over here ?
>=20
> diff -Nur linux-2.6.32-431.17.1.el6.x86_64/fs/ext4/ialloc.c
> linux-2.6.32-431.17.1.el6.x86_64/fs/ext4/ialloc.c
> --- linux-2.6.32-431.17.1.el6.x86_64/fs/ext4/ialloc.c    2014-04-12
> 01:20:31.000000000 +0530
> +++ linux-2.6.32-431.17.1.el6.x86_64/fs/ext4/ialloc.c    2015-11-29
> 21:36:51.805542209 +0530
> @@ -529,6 +529,7 @@
>             grp =3D g;
>             ret =3D 0;
>             best_ndir =3D stats.used_dirs;
> +            break;
>         }
>         if (ret)
>         goto fallback;

No, this isn't correct.  This loop is looking for the *best* group it =
can find,
and your "break" would have it exit the loop as soon as the *first* =
directory
that matches the conditions is found.  Since those conditions are fairly =
weak,
for example that the group actually has free inodes, and it has better =
than
average free inodes and blocks, it makes sense to search beyond just the =
first
matching group.

That said, it also doesn't make sense to search beyond a "perfect" group =
that
has no allocated inodes and no allocated blocks, so a break condition =
could be
added to this loop and make it more efficient, especially for very large
filesystems that have 128k+ groups.

It should be noted that this part of the algorithm only applies to "top =
level"
directories (those below the root inode, or with the EXT4_INODE_TOPDIR =
flag
set, so searching a bit longer for a good group is not a bad idea in =
this case.

Cheers, Andreas.

> Thanks & Regards,
>   Lokesh
>=20
>=20
>=20
> On Thu, Dec 3, 2015 at 11:28 PM, Andreas Dilger <adilger@dilger.ca> =
wrote:
>> On Dec 3, 2015, at 01:07, lokesh jaliminche =
<lokesh.jaliminche@gmail.com> wrote:
>>>=20
>>> Thought of giving more clarification on my question
>>> why group search start is random ? because we can also start  search
>>> for valid groups for inode allocation from the start. As this group
>>> search is random  inode selection might go to end of groups which
>>> might affect IO performance
>>=20
>> Starting the inode search at the beginning of the disk each time
>> means that inode allocation will be inefficient because it will =
search
>> over groups that are mostly or entirely full already.
>>=20
>> Allocating the new directory in a semi-random group, one that is
>> relatively unused, ensures that new
>> inode and block allocations are relatively efficient afterward.
>>=20
>> Cheers, Andreas
>>=20
>>> On Thu, Dec 3, 2015 at 1:14 PM, lokesh jaliminche
>>> <lokesh.jaliminche@gmail.com> wrote:
>>>> hello folks,
>>>>               I am new to ext4 code. I was going through the
>>>> ext4-source for allocation of inode.
>>>> There is one thing that I did not understand while selection of =
groups
>>>> for inode allocation . I came across this code snippet which is =
part
>>>> of find_group_orlov function. question is, why group search start =
is
>>>> random ?
>>>>=20
>>>> Code snippet:
>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>> =D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7if (qstr) {
>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7hinfo.hash_=
version =3D LDISKFS_DX_HASH_HALF_MD4;
>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7hinfo.seed =
=3D sbi->s_hash_seed;
>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7ldiskfsfs_d=
irhash(qstr->name, qstr->len, &hinfo);
>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7grp =3D =
hinfo.hash;
>>>> =D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=
=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7} else
>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7get_random_=
bytes(&grp, sizeof(grp));
>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7parent_group =3D (unsigned)grp =
% ngroups;
>>>> =D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=
=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7for (i =3D 0; i < =
ngroups; i++) {
>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7g =3D =
(parent_group + i) % ngroups;
>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7get_orlov_s=
tats(sb, g, flex_size, &stats);
>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7if =
(!stats.free_inodes)
>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=
=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7continue;
>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7if =
(stats.used_dirs >=3D best_ndir)
>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=
=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7continue;
>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7if =
(stats.free_inodes < avefreei)
>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=
=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7continue;
>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7if =
(stats.free_blocks < avefreeb)
>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=
=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7continue;
>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7grp =3D =
g;
>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7ret =3D =
0;
>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7best_ndir =
=3D stats.used_dirs;
>>>> =D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=
=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7}
>>>>=20
>>>> Thanks & Regards,
>>>> Lokesh
>>> =
N=E2=80=B9=C2=A7=D0=86=D0=B6=D0=BCr=D1=91=E2=80=BAy=D1=8A=D0=B8=D1=99=D0=A8=
b=D0=86X=C2=AC=C2=B6=D0=97=C2=A7v=D0=A8^=E2=80=93)=D0=AE=D1=94{.n=D0=97+=E2=
=80=B0=C2=B7=D2=90=D0=89{=C2=B1{ x=D0=89{ay=D1=94 =D0=9A=E2=80=A1=D0=AA=E2=
=84=A2=D0=BB,j =C2=AD=D1=9Ef=D0=88=D1=9E=C2=B7h=D1=99=E2=80=B9=D0=B0z=E2=84=
=96 =C2=AEw=D2=90=D1=9E=D1=91 =D1=9E=C2=B7=C2=A6j:+v=E2=80=B0=D0=81=D0=89w=
=D0=B8j=D0=A8m=C2=B6=D1=9F=D1=8F=D1=95 =
=C2=AB=E2=80=98=D0=BA=D0=B7zZ+=D1=93=D1=89=D1=99=D0=8B=D0=89=D0=AD=D1=9Ej"=
=D1=9C=D1=8A!=C2=B6i


Cheers, Andreas






--Apple-Mail=_8508C28C-81E0-4D0F-8449-6B998D8EDF58
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVmILtHKl2rkXzB/gAQhx8A//cOY1heopfzVlw3IVBVIHTsp0M1AJ1BKp
fBb1KYehoPhwGLw9IOU02Z/ydEnw9EVKsJCCVnKDN3pI+qHNS1d2zAmICnfDHTrK
mRBfGwN5DPsGfTkUA3mN1EKdmrjQi1eNllinMrDHi9H8ajjHrgjmGrCg5bn6c/Ae
ilVpUEiiLAldm1txcfqMNAwXVcZqtEzzS30xO2eQCoOnZQ3Nw/cq9dTpV3cnHf2k
8Mcr1d8c7EHtsG9FpciaKKPasJ75ehS7krsHO4Xe9ZEzNZFKufWnLl2/KgmMJWmk
GklsfOpGGGdb0PhDnjAI5+kQ0U1tKXyKTpc6CQODfzndxUd9eXqSDT00Qk9nmEvZ
R/gCldjgtpWnlcez4YmRnNgeMjI0PjlBQpRn0nwgT3zxfqJ0PYyYtlQiG5AaRiBg
zsfylLJpBjmR70CC+xe8Ya3VtJw6nVaTF6CZ2wqoe0kgMAL3vRfAcyQg0pGL6P72
LXgvFMAxH8TtYO8ZuhtB9AMuwmQlWTtW6AsKWdy/8MdLXyUg8rfwWqVxoLtAgIMy
dX8/onrkL9d+uxSf32tEVVhb0RP2sB0cMLhbbWeLHr8N1F+WB/DAiPzaV8WEkusD
fjsrn7tK7TpkK5DLzoCkwrU8GcRxZEkEvr4pahjcNzO+ZEm0pqIHW32bRJL8L7JT
ldA2LK7rlHQ=
=Phn8
-----END PGP SIGNATURE-----

--Apple-Mail=_8508C28C-81E0-4D0F-8449-6B998D8EDF58--
