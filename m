From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC PATCH 1/1] ext4: Try to better reuse recently freed space
Date: Mon, 7 Apr 2014 14:01:23 -0600
Message-ID: <A876B6E7-58CA-4825-B1BC-1B8A266FE9E6@dilger.ca>
References: <alpine.LFD.2.00.1312021727150.2284@localhost.localdomain> <20140401053018.GP4911@thunk.org>
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Content-Type: multipart/signed; boundary="Apple-Mail=_5CD55C49-EECD-4601-8669-C2688DD60BAB"; protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:59992 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755330AbaDGUBb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 7 Apr 2014 16:01:31 -0400
Received: by mail-ig0-f171.google.com with SMTP id c1so4182918igq.10
        for <linux-ext4@vger.kernel.org>; Mon, 07 Apr 2014 13:01:31 -0700 (PDT)
In-Reply-To: <20140401053018.GP4911@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_5CD55C49-EECD-4601-8669-C2688DD60BAB
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

On Mar 31, 2014, at 11:30 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Mon, Dec 02, 2013 at 05:32:06PM +0100, Luk=E1=9A Czerner wrote:
>> Hi all,
>>=20
>> this is the patch I send a while ago to fix the issue I've seen with
>> a global allocation goal. This might no longer apply to the current
>> kernel and it might not be the best approach, but I use this example
>> just to start a discussion about those allocation goals and how to
>> use, or change them.
>>=20
>> I think that we agree that the long term fix would be to have free
>> extent map. But we might be able to do something quickly, unless
>> someone commits to make the free extent map reality :)
>=20
> Hi Andreas,
>=20
> We discussed possibly applying this patch last week at the ext4
> workshop, possibly as early as for the 3.15 merge window:
>=20
> 	http://patchwork.ozlabs.org/patch/295956/

Sorry for the delay in replying, I was away the past couple of weeks
on vacation, and am heading this week to the Lustre conference.

> However, I'm guessing that Lustre has the workload which is most
> likely to regress if we were to simply apply this patch.  But, it's
> likely it will improve things for many/most other ext4 workloads.

I definitely agree that this will help with SSD storage, and thinp
workloads that end up doing random IO to the underlying storage.
The main reason for using the global goal is to maximize the chance
of getting large contiguous allocations, since it does a round-robin
traversal of the groups and maximizes the time that other blocks can
be freed in each group.  It also minimizes the churn of allocating
large files in groups that may not have large contiguous extents (e.g.
if small files/extents have just been freed in a group, but not all
of the blocks in that group are freed).

The global goal avoids not only the higher chance of finding free small
chunks for the file, but also the CPU overhead of re-scanning groups
that are partially full to find large free extents.

> We did talk about trying to assemble some block allocation performance
> tests so we can better measure proposed changes to the block
> allocator, but that's not something we have yet.  However, this global
> goal is definitely causing problems for a number of use cases,
> including thinp and being flash friendly.

An important question is whether thinp and flash are the main uses for =
ext4?
I could imagine ignoring the global goal if rotational =3D=3D 0, or if =
some
large fraction of the filesystem was just deleted, but this change means
that each inode will have to re-scan the free groups to find large =
extents
and I think this will have a long-term negative impact on file extent =
size.

Note that the global goal is only used if the per-inode goal is already
full (i.e. ext4_mb_regular_allocator->ext4_mb_find_by_goal() fails), so
it will need to find a new allocation every time.

I think typical benchmarks that allocate and then free all space in a =
new
filesystem will not exercise this code properly.  Something that =
allocates
space but then only frees some of it, preferably multi-threaded.

> Would you be willing to apply this patch and then run some benchmarks
> to see if Lustre would be impacted negatively if we were to apply this
> patch for the next development cycle (i.e., not for 3.15, but for the
> next merge window)?

Since most of the Lustre developers are travelling this week, it will be
hard to get this patch suitably tested quickly.  Also, Lustre servers =
are
not running on 3.14 kernels yet, so the patch would need to be =
backported
to a kernel that the Lustre server is currently running on.

Some minor notes about the patch itself:
- if there is a desire to land this patch quickly, it would be great to
have this behaviour at least selectable via mount option and/or /sys/fs
tuneable that turns this off and on.  That would allow the patch to land
and simplify testing, and disable it if it later shows regressions.
- the i_last_group and i_last_start are unsigned long, but only need to =
be
unsigned int like fe_group (ext4_group_t) and fe_start (ext4_grpblk_t).
That saves 8 bytes per inode that didn't matter in the superblock.
- there is no locking for the update of i_last_{group,start} if there =
are
parallel writers on the same inode
- rather than dropping the global goal entirely, it would be better to =
have
a list of groups that have relatively free space.  I know we also =
discussed
using an rbtree to locate free extents instead of per-group buddy =
bitmaps.
That would probably avoid the need for the global goal.

Cheers, Andreas






--Apple-Mail=_5CD55C49-EECD-4601-8669-C2688DD60BAB
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU0MEE3Kl2rkXzB/gAQJs2g//WaQC8KOdy0ckQqPYoK98W6EKYLS+qbwl
2Wts/HjhdKymPAXCtXxMGi8xvcV/zYpM7dpLGxddfWeyVroN1O8+qPIk1Y4EStCp
/xNq7XDzTa0BqxUKIfpHotX9l4R/KIEEKD2Vm6DPR5m5aq35I0+ihr+JQDx2Qcze
g8+6D1JuUcfOxQogMHp1W7xhr0sGxlhijinQnrJ9di6eo9xf5bFEn02tbGdpu7FC
Z47LlTqE1Bm8F7ponYM38I09t1ROpm084YtM+Xmbl3wMMg+BT8b9Rh5IbF6sMSNa
nvJlVpqOt9+gJ2lEZt676+sSl8rkvvgZANtYo1kCd9yKmv3nlU3Rh+sW3JaBT+l8
w38Uh2cLFAcQFDEnmN/KatIoOm0zh0O8U4tHewu0Bl41l7oJqKwEKz40hsU8F/Ii
oQieSrUf0oim5DyC5ngWXZPg18H044A1DbtlHg0zlX5KN0dgTFboNJo8PlF7nfkT
76RA5oEyHQpepLxK4Cj6r2pOi9G6OE3rAaSdrvCfSRVLo6wXnDxKH+svLmeAu/9E
TJmK+9QYAb9PiGCjbN2ccvoAIor+rHwnvNkhr92ecCoIYZv+1tHkbf0EhLGclfl7
vGunjRQ/lAPeTUdIHfc53EMTrDCcbQkW1wA71e16EBfbO6cCgwCEg3MNvOwpTIdH
xOer+Yv9pIA=
=MJbs
-----END PGP SIGNATURE-----

--Apple-Mail=_5CD55C49-EECD-4601-8669-C2688DD60BAB--
