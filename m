From: micah anderson <micah@riseup.net>
Subject: Re: ext4 corruption
Date: Mon, 06 Jun 2011 13:11:32 -0400
Message-ID: <87aaduopff.fsf@algae.riseup.net>
References: <87pqmrobix.fsf@algae.riseup.net> <20110606041950.GH7180@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.riseup.net ([204.13.164.18]:49146 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab1FFRLf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 6 Jun 2011 13:11:35 -0400
In-Reply-To: <20110606041950.GH7180@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 6 Jun 2011 00:19:50 -0400, Ted Ts'o <tytso@mit.edu> wrote:
> On Sun, Jun 05, 2011 at 11:59:34PM -0400, Micah Anderson wrote:
> >=20
> > I previously wrote about a recent conversion from ext3 to ext4 (on
> > Debian Squeeze), which went well. However, I seem to be having problems
> > with the ext4 filesystem.
>=20
> Are you using the 2.6.32 kernel (the Debian squeeze default)?  Try

Yes, we are using 2.6.32-34squeeze1.

> updating to 2.6.39.1, and see if that stablizes things.  There have
> been a huge number of bug fixes since 2.6.32, and no one has been
> really backporting patches to such an ancient kernel.  This is one of
> the ways in which Debian Obsolete^H^H^H^H^H^H^H^H Stable can be
> somewhat of a disadvantage.  Unlike the RHEL kernels, no one is
> backporting ext4 bugfixes to older Debian stable kernels, and ext4 was
> still getting a lot of bug fixes in the 2.6.32 days.

Well, it does seem like 2.6.32.y contains quite a number of ext4 fixes:

$ git rev-list v2.6.32..v2.6.32.41 fs/ext4 | wc -l
92

Not an insignificant amount, although it seems the latest was in
2.6.32.23 which was some time ago.

I'm sure that the debian-kernel team would welcome some help with this,
even if it is just some help determining the most important issues to
resolve.=20

I would guess that RHEL is in a better position to integrate more
invasive fixes.

> That being said, you're seeing some pretty severe inode *and* block
> allocation bitmap problems, and that doesn't sound like anything I
> remember even back in the 2.6.32 days.  It does make me wonder about
> the stability of the hardware and of the software raid code...

Yeah, so once we've done some destructive badblocks tests on the drives,
we should be able to rule out drive issues at least.

micah

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJN7QpEAAoJEIy/mjIoYaeQeUQQAKIEOzfM+sOpnu7eJMl0ak5i
ahyKF9aY2IDEtt4eBM4xdU/xv5FVLKTTeujNf7tK4aK5kvxPdgTWFuL1a07MyPPV
NS8b70WiSzazawBsgsdNfnFMGBa+5Ca9N898ZWXSvigumyZqXGjznWWncSTKqBNn
+riUx7Vu8bobJA7OpLSEz8Gm76JIAwlU4eGznmaWu0DNp74syao5OLZjO4Ai7tod
FzOpE1hj3gBzbQwEHmCUdDn7QY5DYcZZG+eO65rMlAI3oUIvC99GZ7Bdbaomfuwo
d5H05eyA2f6DlTfuEKmDxNy53Type/1xwMSD/tQoYnJE2kvLA9+WeQd2FiUVdFJq
MCOjD1rxSA103Kjuqgl9qaIfT8A3mcW5cLSIvDYVQmb2r3ZiZ9xT7w/L/YoTV6Pj
DMNMsEk2N16HVUinYu9vnq7LWDI+IN4J1adNE5pIAWqaxm12esLU8Ipovdjb0QmN
ppsN8TBea+AixO+m6WmwhPgPYUQcGxrDuBZPLHDtN8Zc6XN2FZHCyzk/jeSkftiz
M5izSxTc65lk/DWSNY7QG/O3YVsOISliqFn6B94jpNXpgP1vobUJq7VspiB0CNZW
xtlhKU3ZTC6eEiuUFFjrZ52n29bdAznXvXnnqebuT3RVkUyFZbVXV9qfyh9gFlSt
itjDsVU+DO+xkfWPlj44
=rFh1
-----END PGP SIGNATURE-----
--=-=-=--
