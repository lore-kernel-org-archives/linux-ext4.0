Return-Path: <SRS0=QVqk=OH=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx2.mailbox.org ([80.241.60.215]:9748 "EHLO mx2.mailbox.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728883AbeK2ECK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 28 Nov 2018 23:02:10 -0500
Subject: Re: ext4 file system corruption with v4.19.3 / v4.19.4
To: "Theodore Y. Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        "Andrey Jr. Melnikov" <temnota.am@gmail.com>,
        linux-ext4@vger.kernel.org
References: <065643a0-f9aa-a361-715a-03ca978d9228@roeck-us.net>
 <20181128041555.GE31885@thunk.org> <en52df-5dh.ln1@banana.localnet>
 <2547416.7Vy7A2kRpU@siriux> <20181128161033.GH31885@thunk.org>
From: Rainer Fiebig <jrf@mailbox.org>
Message-ID: <ca0f3f35-aff6-78c9-3669-adb4acf7d46f@mailbox.org>
Date: Wed, 28 Nov 2018 18:01:32 +0100
MIME-Version: 1.0
In-Reply-To: <20181128161033.GH31885@thunk.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="0QsFQGjkMyMDnEK94FEOhomEecNK9Layx"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--0QsFQGjkMyMDnEK94FEOhomEecNK9Layx
Content-Type: multipart/mixed; boundary="WXuAiaQpiTEknLRql6T46iqdg4NFSo8N5";
 protected-headers="v1"
From: Rainer Fiebig <jrf@mailbox.org>
To: "Theodore Y. Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
 "Andrey Jr. Melnikov" <temnota.am@gmail.com>, linux-ext4@vger.kernel.org
Message-ID: <ca0f3f35-aff6-78c9-3669-adb4acf7d46f@mailbox.org>
Subject: Re: ext4 file system corruption with v4.19.3 / v4.19.4
References: <065643a0-f9aa-a361-715a-03ca978d9228@roeck-us.net>
 <20181128041555.GE31885@thunk.org> <en52df-5dh.ln1@banana.localnet>
 <2547416.7Vy7A2kRpU@siriux> <20181128161033.GH31885@thunk.org>
In-Reply-To: <20181128161033.GH31885@thunk.org>

--WXuAiaQpiTEknLRql6T46iqdg4NFSo8N5
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 28.11.18 um 17:10 schrieb Theodore Y. Ts'o:
> On Wed, Nov 28, 2018 at 04:56:51PM +0100, Rainer Fiebig wrote:
>>
>> If you still see the errors, at least the Ubuntu-kernel could be ruled=
 out.
>=20
> My impression is that some of the people reporting problems have been
> using stock upstream kernels, so I wasn't really worried about the
> Ubuntu kernel (although it could be something about the default
> configs that Ubuntu sets up).  What I was more wondering was whether
> there was something about userspace or default configs of Ubuntu.
> This isn't necessarily a *problem* per se; for examople, not that long
> ago some users were getting surprised when a problem showed up with an
> older version of the LVM2 userspace with newer upstream kernels.
> After a while, you learn to get super paranoid about making sure to
> rule out all possibilities when trying to debug problems that are only
> hitting a set of users.
>=20
> 						- Ted
>=20

OK, thanks. Perhaps Andrey can tell us then what impact the default
=2Econfig had on the problem.

Rainer Fiebig


--WXuAiaQpiTEknLRql6T46iqdg4NFSo8N5--

--0QsFQGjkMyMDnEK94FEOhomEecNK9Layx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE6yx5PjBNuGB2qJXG8OH3JiWK+PUFAlv+yfoACgkQ8OH3JiWK
+PWHcxAAz1aNEye1dotyGls5Dh8WTLd/DAF8ddd80Gql+zta0h2AYT8vvbRQwZOI
UO4qHPtL8Xgoh0uAibHjQ4sn5/t5Sr7PPQmYcft5aTS5SZ8I7NpS7yWtYwtN7258
af+r0bFNJVP2iAqp/oPMSGB0AsyPK0SlZ6RhWP5wtpYYpaOR7ycfa7px/aMcpBne
MOZKPR5O4mPU1tsHjxIFiCM8gXW1rVFqSdDkz0uiHNh65pssjnKGS3GdcYcq1gow
bYTAUEGZRgx1vrKnS9phRypG5Vu6FVnVIRroJi+Lxf1vcH39Tvz47SP+zUv/1ecE
LNm6hC5ZJX2wXLlkDrxKL6lGMZbd5PWLyGodbjNrHMurtbGwUrdKtRbMaaxJBt25
m4aOnXS3vG6rSARXBSZY9hCBdDVxrv3wMT3GLSOjcKqsxnIsI6w8NwnNhkA4GcfO
mkbUI6/+xviYIUOGW/bj5SEhy+KjyJvmeTAuGthDf7xB6glp6/tnPqIm17nKTNIz
EepX7iEBEX8S54FCo1Kr9/C9ujeKCEfRLNKQmyC9Uhf2InOSNXyitBPm8Otjp7pU
MIyeG87yLKS0Jokn6k+Zwe/htu1KE8DxR8I9j/42D8L1/VV0GXHziDHzOtrJn2Qu
Vj0qUGlD1m6NPCiFqmKgbk7J2ndko//tzaDfjFK7XGz4o+HNKXw=
=aOUD
-----END PGP SIGNATURE-----

--0QsFQGjkMyMDnEK94FEOhomEecNK9Layx--
