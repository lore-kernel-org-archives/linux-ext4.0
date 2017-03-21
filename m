From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: 64-bit inode number
Date: Tue, 21 Mar 2017 12:13:36 -0400
Message-ID: <A32DD67A-F005-42BF-B243-A56208421EBA@dilger.ca>
References: <0E4E58F6-53E5-4FD0-A00F-910225E04201@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.2 \(3259\))
Content-Type: multipart/signed;
 boundary="Apple-Mail=_3C529051-9160-40B0-BBB2-3736B39937DA";
 protocol="application/pgp-signature"; micalg=pgp-sha1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Alexey Lyashkov <alexey.lyashkov@gmail.com>,
        Ts'o Theodore <tytso@mit.edu>
To: =?utf-8?B?0JHQu9Cw0LPQvtC00LDRgNC10L3QutC+INCQ0YDRgtGR0Lw=?=
        <artem.blagodarenko@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:34343 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933214AbdCUQNn (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Mar 2017 12:13:43 -0400
Received: by mail-qk0-f195.google.com with SMTP id v127so22706683qkb.1
        for <linux-ext4@vger.kernel.org>; Tue, 21 Mar 2017 09:13:42 -0700 (PDT)
In-Reply-To: <0E4E58F6-53E5-4FD0-A00F-910225E04201@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Apple-Mail=_3C529051-9160-40B0-BBB2-3736B39937DA
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8

On Mar 20, 2017, at 6:22 AM, =D0=91=D0=BB=D0=B0=D0=B3=D0=BE=D0=B4=D0=B0=D1=
=80=D0=B5=D0=BD=D0=BA=D0=BE =D0=90=D1=80=D1=82=D1=91=D0=BC =
<artem.blagodarenko@gmail.com> wrote:
>=20
> Hello,
>=20
> This topic was mentioned in "Add largedir feature=E2=80=9D, but need =
to be discussed in
> a separate thread.
> Increasing maximum inode count is useful with and without larg_dir. =
There is at
> least one user who needs 64 bit inode number - Lustre FS.
>=20
> As mentioned, MDS has 0-size files to store some information about =
Lustre FS
> files. Current MDS disk sizes allow to store large amount of such =
files, but
> EXT4 limits this number to ~4 billions.
>=20
> Lustre FS has features like DNE to distribute MDS over many targets =
(disks),
> but disks are used  not effectively. It would be great to have ability =
to
> store more then  ~4 billions inodes on one EXT4 file system.

I guess the major potential problem with more than 4B inodes in a single
filesystem (and also the large 300TB+ filesystems you are using) is that
running e2fsck could take a very long time.  Conversely, using DNE to =
spread
the metadata across multiple filesystems/servers allows e2fsck to run in
parallel and limits any failures to a smaller subset of the filesystem.

That doesn't mean I'm totally against this feature, since > 8TB disks =
are
becoming common.

> I know there is dirdata feature that allows to store higher 32 bit of =
inode
> number in ext4 dirent. As I know, direct was not merged yet because of =
user
> absence. Quote of Andreas from "Add largedir feature=E2=80=9D
>=20
>> Mostly because there hasn't been any interest for it whenever I =
proposed
>> merging it in the past. If there is some renewed interest in merging =
it
>> I could look into it =E2=80=A6
>=20
> It looks like Lustre FS requires this feature now.
>=20
> There is another approach how to solve this problem. It is obvious, =
but
> require change on disk format. Theodore=E2=80=99s quote from "Add =
largedir feature=E2=80=9D
>=20
>> I can imagine a new feature flag which defines the use a 64-bit inode
>> number, but that's more for people who are creating a file system =
that
>> takes advantage of 64-bit block numbers, and they are intending on
>> using all of that space to store small (< 4k or < 8k) files.
>=20
> This is exact Lustre FS MDS example. Many small inodes. If it possible =
to add new feature flag, probably this is the best solution: simple, =
obvious, fast.
>=20
> Please, help with this questions:
> 1. Do we need 64 bit number now? (My opinion - we need it)
> 2. What solution from two above to choose? Another solution?

It wasn't clear from Ted's comments whether he was proposing the feature
flag to store 64-bit inode numbers directly into a new ext4_dir_entry64,
or to use the dir_data to hold the high 32 bits?  My preference would be =
to
store the high bits of the inode number into dir_data.  The reasons are:
- this won't use more space for 64-bit inodes than ext4_dir_entry64
- for 32-bit inode numbers will have smaller dirents
- significantly more 32-bit dirents can fit into a leaf block (i.e. =
10-25%)
- it is backwards compatible with existing directories and can =
transparently
  store 64-bit inode numbers into 32-bit directories without a full =
update
- it avoids duplicate code paths for ext4_dir_entry vs ext4_dir_entry64
- it would be possible to only store high 16 bits (2^48 inodes) since =
this
  may be enough for ext4, since ext4_extent can only address 2^48 blocks
  (2^60 bytes) and there isn't much value to more inodes than blocks?

Cheers, Andreas






--Apple-Mail=_3C529051-9160-40B0-BBB2-3736B39937DA
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iD8DBQFY0VExpIg59Q01vtYRAvKCAKCpK9sW4MRYCQmPcjc7OWzC7wSqRACfaKhN
uKcVJ+xI78HaTiP2pQb+cQ4=
=3AmA
-----END PGP SIGNATURE-----

--Apple-Mail=_3C529051-9160-40B0-BBB2-3736B39937DA--
