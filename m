From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Regarding random grouop search start for allocation of inode.
Date: Tue, 15 Dec 2015 14:32:52 -0700
Message-ID: <9260CD06-FEF8-4312-84CE-DA5053979297@dilger.ca>
References: <CAKJOkCrU7b3XLKHFUS-_eyZ9Lvh7XoPcU15pjAs+qGy2o6XA-w@mail.gmail.com> <CAKJOkCoZExQv6mNMQ7kM_ihQ4B41WoNQJYF+pOhXKJLg-OOt+Q@mail.gmail.com> <ED92218E-3E81-456C-A6C6-37C2D32AD06B@dilger.ca> <CAKJOkCr7fsyTxCxPivOp9-0MsbPL0nMQCnAcGUjd=gDq7zS6uQ@mail.gmail.com> <AB526984-C3CC-4EBF-BF17-D7AAE33F2337@dilger.ca> <CAKJOkCr5W-=9hu_pq9jvJ_+Fr_sjfNHK_d6vg+Oa5TeF0rHMMA@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: multipart/signed; boundary="Apple-Mail=_6D46A4A6-84B5-42A9-84E5-73A77FBE11C3"; protocol="application/pgp-signature"; micalg=pgp-sha256
Cc: linux-ext4@vger.kernel.org
To: lokesh jaliminche <lokesh.jaliminche@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:36135 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339AbbLOVdA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 15 Dec 2015 16:33:00 -0500
Received: by mail-io0-f182.google.com with SMTP id o67so34379020iof.3
        for <linux-ext4@vger.kernel.org>; Tue, 15 Dec 2015 13:32:59 -0800 (PST)
In-Reply-To: <CAKJOkCr5W-=9hu_pq9jvJ_+Fr_sjfNHK_d6vg+Oa5TeF0rHMMA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_6D46A4A6-84B5-42A9-84E5-73A77FBE11C3
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

On Dec 15, 2015, at 3:33 AM, lokesh jaliminche =
<lokesh.jaliminche@gmail.com> wrote:
>=20
> "No, this isn't correct.  This loop is looking for the *best* group it
> can find, and your "break" would have it exit the loop as soon as the
> *first* group that matches the conditions is found."
>=20
> But as we are checking  all the groups with the same conditions then
> how it guarantees better group selection ? As per my understanding  we
> are just wasting time in looping.

The important part of the loop is ensuring that the selected group is =
always
improving over the previous one:

			if (le16_to_cpu(desc->bg_used_dirs_count) >=3D =
best_ndir)
                                continue;

The "best_ndir" value tracks for the best group found so far the number =
of
used directories in the group, and if the new directory has fewer =
directories
than the  previous "best" directory and still meets all the other =
criteria
(fewer than average inodes allocated, etc) then the new group will be =
chosen.

That said, you are correct that the loop can spend a lot of time =
searching
needlessly.  It would be trivial to add a check at the start of the =
loop:

			/* the group can't get any better than empty */
			if (desc->bg_free_inodes_count =3D=3D =
inodes_per_group &&
			    desc->bg_free_blocks_count =3D=3D
						=
EXT4_BLOCKS_PER_GROUP(sb))
				goto found;

This jumps directly to "found" with "desc" and "group" already set, so
there is no need to go through the extra steps of setting "best_desc" =
and
"best_group" and then break out of the loop just to set "desc" and =
"group"
again.

Since you are the one to find this optimization, could you please submit =
a
patch to this effect so you get the credit.

Cheers, Andreas

> On Sat, Dec 5, 2015 at 3:24 AM, Andreas Dilger <adilger@dilger.ca> =
wrote:
>>=20
>>> On Dec 3, 2015, at 12:13 PM, lokesh jaliminche =
<lokesh.jaliminche@gmail.com> wrote:
>>>=20
>>> Ohh thanks for the clarification. There is one more thing I would =
like
>>> to point out here.
>>> In the code there  is a loop to scan the groups for inode
>>> alllocation(Inside find_group_orlov function).
>>> There are some policies for group selection . while scanning the
>>> groups, it checks for these
>>> policies to be satisfied.
>>> If a particular group satisfy these properties it should get =
selected
>>> for inode allocation but instead
>>> it does further lookup in next groups.
>>> I think there is missing breaking condition. I have added break over
>>> there and here is the
>>> patch for that. Any reason for not having break condition over here =
?
>>>=20
>>> diff -Nur linux-2.6.32-431.17.1.el6.x86_64/fs/ext4/ialloc.c
>>> linux-2.6.32-431.17.1.el6.x86_64/fs/ext4/ialloc.c
>>> --- linux-2.6.32-431.17.1.el6.x86_64/fs/ext4/ialloc.c    2014-04-12
>>> 01:20:31.000000000 +0530
>>> +++ linux-2.6.32-431.17.1.el6.x86_64/fs/ext4/ialloc.c    2015-11-29
>>> 21:36:51.805542209 +0530
>>> @@ -529,6 +529,7 @@
>>>            grp =3D g;
>>>            ret =3D 0;
>>>            best_ndir =3D stats.used_dirs;
>>> +            break;
>>>        }
>>>        if (ret)
>>>        goto fallback;
>>=20
>> No, this isn't correct.  This loop is looking for the *best* group it =
can find,
>> and your "break" would have it exit the loop as soon as the *first* =
directory
>> that matches the conditions is found.  Since those conditions are =
fairly weak,
>> for example that the group actually has free inodes, and it has =
better than
>> average free inodes and blocks, it makes sense to search beyond just =
the first
>> matching group.
>>=20
>> That said, it also doesn't make sense to search beyond a "perfect" =
group that
>> has no allocated inodes and no allocated blocks, so a break condition =
could be
>> added to this loop and make it more efficient, especially for very =
large
>> filesystems that have 128k+ groups.
>>=20
>> It should be noted that this part of the algorithm only applies to =
"top level"
>> directories (those below the root inode, or with the =
EXT4_INODE_TOPDIR flag
>> set, so searching a bit longer for a good group is not a bad idea in =
this case.
>>=20
>> Cheers, Andreas.
>>=20
>>> Thanks & Regards,
>>>  Lokesh
>>>=20
>>>=20
>>>=20
>>> On Thu, Dec 3, 2015 at 11:28 PM, Andreas Dilger <adilger@dilger.ca> =
wrote:
>>>> On Dec 3, 2015, at 01:07, lokesh jaliminche =
<lokesh.jaliminche@gmail.com> wrote:
>>>>>=20
>>>>> Thought of giving more clarification on my question
>>>>> why group search start is random ? because we can also start  =
search
>>>>> for valid groups for inode allocation from the start. As this =
group
>>>>> search is random  inode selection might go to end of groups which
>>>>> might affect IO performance
>>>>=20
>>>> Starting the inode search at the beginning of the disk each time
>>>> means that inode allocation will be inefficient because it will =
search
>>>> over groups that are mostly or entirely full already.
>>>>=20
>>>> Allocating the new directory in a semi-random group, one that is
>>>> relatively unused, ensures that new
>>>> inode and block allocations are relatively efficient afterward.
>>>>=20
>>>> Cheers, Andreas
>>>>=20
>>>>> On Thu, Dec 3, 2015 at 1:14 PM, lokesh jaliminche
>>>>> <lokesh.jaliminche@gmail.com> wrote:
>>>>>> hello folks,
>>>>>>              I am new to ext4 code. I was going through the
>>>>>> ext4-source for allocation of inode.
>>>>>> There is one thing that I did not understand while selection of =
groups
>>>>>> for inode allocation . I came across this code snippet which is =
part
>>>>>> of find_group_orlov function. question is, why group search start =
is
>>>>>> random ?
>>>>>>=20
>>>>>> Code snippet:
>>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>>>> =D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7if (qstr) {
>>>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7hinfo.hash_=
version =3D LDISKFS_DX_HASH_HALF_MD4;
>>>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7hinfo.seed =
=3D sbi->s_hash_seed;
>>>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7ldiskfsfs_d=
irhash(qstr->name, qstr->len, &hinfo);
>>>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7grp =3D =
hinfo.hash;
>>>>>> =D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=
=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7} else
>>>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7get_random_=
bytes(&grp, sizeof(grp));
>>>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7parent_group =3D (unsigned)grp =
% ngroups;
>>>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7for (i =3D 0; i < ngroups; =
i++) {
>>>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7g =3D =
(parent_group + i) % ngroups;
>>>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7get_orlov_s=
tats(sb, g, flex_size, &stats);
>>>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7if =
(!stats.free_inodes)
>>>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=
=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7continue;
>>>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7if =
(stats.used_dirs >=3D best_ndir)
>>>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=
=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7continue;
>>>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7if =
(stats.free_inodes < avefreei)
>>>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=
=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7continue;
>>>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7if =
(stats.free_blocks < avefreeb)
>>>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=
=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7continue;
>>>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7grp =3D =
g;
>>>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7ret =3D =
0;
>>>>>> =
=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=
=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=
=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7best_ndir =
=3D stats.used_dirs;
>>>>>> =D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=
=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=BB=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=
=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7=D0=92=C2=B7}
>>>>>>=20
>>>>>> Thanks & Regards,
>>>>>> Lokesh
>>>>> =
N=E2=80=B9=C2=A7=D0=86=D0=B6=D0=BCr=D1=91=E2=80=BAy=D1=8A=D0=B8=D1=99=D0=A8=
b=D0=86X=C2=AC=C2=B6=D0=97=C2=A7v=D0=A8^=E2=80=93)=D0=AE=D1=94{.n=D0=97+=E2=
=80=B0=C2=B7=D2=90=D0=89{=C2=B1{ x=D0=89{ay=D1=94 =D0=9A=E2=80=A1=D0=AA=E2=
=84=A2=D0=BB,j =C2=AD=D1=9Ef=D0=88=D1=9E=C2=B7h=D1=99=E2=80=B9=D0=B0z=E2=84=
=96 =C2=AEw=D2=90=D1=9E=D1=91 =D1=9E=C2=B7=C2=A6j:+v=E2=80=B0=D0=81=D0=89w=
=D0=B8j=D0=A8m=C2=B6=D1=9F=D1=8F=D1=95 =
=C2=AB=E2=80=98=D0=BA=D0=B7zZ+=D1=93=D1=89=D1=99=D0=8B=D0=89=D0=AD=D1=9Ej"=
=D1=9C=D1=8A!=C2=B6i
>>=20
>>=20
>> Cheers, Andreas
>>=20
>>=20
>>=20
>>=20
>>=20


Cheers, Andreas






--Apple-Mail=_6D46A4A6-84B5-42A9-84E5-73A77FBE11C3
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVnCHBXKl2rkXzB/gAQi6txAAv0UNBZsrrYsVuWrz9dGfn2ei7mVhxLpx
hObAV0HZMSj0C12zxiN3hqd9/FQ+5r4YFBwDxZ7gPsAiiDyDo5O4LkSFXOwekb25
kQJFA5v6tw/OMe5T5ZGMy6rEHj9trvhVd8y2HxxFS70VgN5ENkyuztZbhOurmfQp
KoXdvGvK1w6c8LV0/QhOz5G+ImxGKTj2gCdfDW85X3n0VOVk6nkhNV5bpEBl3EWI
QdGnIAC8ziRifHjvxCd25uCKoy1mG+cj2/XidlMyaVNP0erZY2OGlXFE75yiXLWp
7qqdodQ2bH1ds0FhwfhAoF6k8M3McHq7CAK/8x6mJUJDGFOEoxnhuphJtGCoLWq3
IIMOyhUpZXy221aFcQRL5HQ+6WDYgV3fl0c6jA99Tv4+UwLrxyi+ZxvmOKLRxw/D
+z5zaenUGsmc3ya3SdX8FFspqcxNCr8HPsRPAENzfGn0fKBYWsfcT5+Tg+RwrnBC
pIUdYvpgDhPPuFsUD290oZJ4sJtIhXl+yPaKTqn3YQ+zy8WOjY6d5Kk4vBeROjSs
BR3/w0+3eqGTzlj8ST6hIkjKzm4O9bPDpHw3jZnTEWPCmZfEFYZIgQNzgdBMkPba
7unnHfrSdWwvvJ9OT75gHyn1XJQeirCF8wscbn6SGy3dOYqS/5fE0yjWsl9jBHNL
TfTRy0fu88s=
=fSxj
-----END PGP SIGNATURE-----

--Apple-Mail=_6D46A4A6-84B5-42A9-84E5-73A77FBE11C3--
