From: Marius Bakke <mbakke@fastmail.com>
Subject: Re: [PATCH e2fsprogs] tests: Fixup for new r_move_itable tests.
Date: Sat, 13 Jan 2018 06:37:04 +0100
Message-ID: <87mv1ie2v3.fsf@fastmail.com>
References: <20171111075540.21722-1-mbakke@fastmail.com> <20180111191327.GA5559@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34267 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750728AbeAMFmy (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 13 Jan 2018 00:42:54 -0500
In-Reply-To: <20180111191327.GA5559@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Theodore Ts'o <tytso@mit.edu> writes:

> On Sat, Nov 11, 2017 at 08:55:40AM +0100, Marius Bakke wrote:
>> Commits 257f009d1034737096f197dc875931207bcdfc75 and
>> 2b50c18a8a12781c26b71873f4368fe61711d9f9 missed one pass in expected
>> output.
>>=20
>> Signed-off-by: Marius Bakke <mbakke@fastmail.com>
>
> Hi, what architecture did you discover this on?  I don't need this
> change on x86, but I was seeing some mysterious regression test
> failures on a big-endian system which seemed to look like this.  I
> didn't have time to follow up on it then, but I suspect that this may
> be what you are running into.

Thanks for the reply.  I get this on x86, but upon further
investigation, it only happens in the Guix build container.

Running "make check" interactively in a terminal works.  Do you have any
idea what may cause these two tests to extend the inode table when run
in the isolated build chroot?

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEu7At3yzq9qgNHeZDoqBt8qM6VPoFAlpZmwAACgkQoqBt8qM6
VPqzlgf6A+yOb9O9tCbw7hs+FQ6imyuNPAzmnSp+3ql7GvhAV1symyaNBr/tDtUb
avZ3/8l+S9IRhni/+Uik6/dhkylMmR6NwNwOFc59xphdALr1p3cwAYooU80jDyL2
6s8kOVhSOF2HJglunVaebB99wU8jmHSBgHPOovkgJTpMrKflyRPI16oL3e8XID2q
G3kLu/Z4XDFD3HMhzBOWXL6cjhDaKdAJDjD7EfLjtNUTC+KZcwyWYmDHdp5Segmp
mSkv3msvcWyU3CbAWa8eEEZlsh5UMmBrNJwEozijw1+RqXxeILgAc6NzWYqZCsEP
a1P1deCLOfvT4r2p36fHa18QvEa59w==
=gAHt
-----END PGP SIGNATURE-----
--=-=-=--
