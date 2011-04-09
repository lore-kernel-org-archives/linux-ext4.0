From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: tune2fs can't be used on a mounted ext4, or...?
Date: Sun, 10 Apr 2011 03:50:05 +0600
Message-ID: <20110410035005.64f565e3@natsu>
References: <20110410003954.4108b9c9@natsu>
	<14B9D41F-4D38-4F01-97E9-17E86DA578FC@dilger.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/n0RhOXw4KHcGWB8PQ/+hhq9"; protocol="application/pgp-signature"
Cc: linux-ext4@vger.kernel.org, linux-raid@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from luna.romanrm.ru ([199.19.226.215]:59732 "EHLO luna.romanrm.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221Ab1DIVui (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 9 Apr 2011 17:50:38 -0400
In-Reply-To: <14B9D41F-4D38-4F01-97E9-17E86DA578FC@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--Sig_/n0RhOXw4KHcGWB8PQ/+hhq9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 9 Apr 2011 15:30:42 -0600
Andreas Dilger <adilger@dilger.ca> wrote:

> The online resize shouldn't take more than a few minutes, unless the disk=
 is
> crazy busy and you are going from 16GB to 16TB or something.

I was resizing from 4 TB to 6 TB, and during the time (okay, maybe it was j=
ust
an hour) I saw disk free space slowly increase at about 1 GB per couple of
seconds. RAID6 also was in a degraded state (one disk missing), so maybe
that's why it was slower than it should usually be.

> > Then I started copying files from another array to the one on which the
> > above operations were conducted. I did:
> >=20
> >  cp -Rp /mnt/array1/data/* /mnt/array2/new-data/
>=20
> What kernel version do you have, and what version of coreutils?  Is this
> perhaps a bleeding-edge kernel/coreutils with the "FIEMAP" bug?

Kernel version 2.6.38.2, cp (GNU coreutils) 8.5.

Also, what I didn't mention in my previous post, is that during that sessio=
n I
also had one E-Mail message which was just received by the mail client (not
copied from another disk via cp or otherwise) truncate too. The mail client=
 is
claws-mail and it stores individual messages on disk as regular files, a fi=
le
per message, and that one file was 0 bytes in size. At first I didn't think=
 it
was related, but it looks like all disk access is/was affected, not just
cp/coreutils.

> Were the source files that had problems recently written themselves in th=
is
> case?

Recently, as in "while on 2.6.38x kernels", or "in the past N minutes"?
Latter - definitely not (except for that one E-Mail mentioned above), forme=
r -
maybe, but unlikely.

--=20
With respect,
Roman

--Sig_/n0RhOXw4KHcGWB8PQ/+hhq9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2g1I0ACgkQTLKSvz+PZwiCMgCcCJzksTQ58jcSNq7W6nzyq4LL
0h4AoJfvPdqxFh0+/MvRoR9b+h8cV+wt
=Rhf+
-----END PGP SIGNATURE-----

--Sig_/n0RhOXw4KHcGWB8PQ/+hhq9--
