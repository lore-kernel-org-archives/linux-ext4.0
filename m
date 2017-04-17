From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: ext4-lazy (SMR-optimizations) landing to kernel?
Date: Mon, 17 Apr 2017 09:18:11 -0500
Message-ID: <c2d584af-c91b-bcbb-ac13-d1e9e6162a4b@redhat.com>
References: <6B0F0C59-6930-41B3-8EE4-EA5BEECEB9F9@dilger.ca>
Reply-To: sandeen@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="nEmVIw6nmQhOa96kmITbc1PCU7LBDH0qp"
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>, Ts'o Theodore <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35770 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751874AbdDQOSS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 17 Apr 2017 10:18:18 -0400
In-Reply-To: <6B0F0C59-6930-41B3-8EE4-EA5BEECEB9F9@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--nEmVIw6nmQhOa96kmITbc1PCU7LBDH0qp
Content-Type: multipart/mixed; boundary="ND59xDfAuHpw14RCcFxCIev46QW4cDpis";
 protected-headers="v1"
From: Eric Sandeen <esandeen@redhat.com>
Reply-To: sandeen@redhat.com
To: Andreas Dilger <adilger@dilger.ca>, Ts'o Theodore <tytso@mit.edu>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
Message-ID: <c2d584af-c91b-bcbb-ac13-d1e9e6162a4b@redhat.com>
Subject: Re: ext4-lazy (SMR-optimizations) landing to kernel?
References: <6B0F0C59-6930-41B3-8EE4-EA5BEECEB9F9@dilger.ca>
In-Reply-To: <6B0F0C59-6930-41B3-8EE4-EA5BEECEB9F9@dilger.ca>

--ND59xDfAuHpw14RCcFxCIev46QW4cDpis
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 4/10/17 10:06 PM, Andreas Dilger wrote:
> Hi Ted,
> now that FAST'17 is behind us, is there any plan to land the ext4-lazy =
code
> (SMR optimizations) to the upstream kernel?  This looks like it improve=
s
> some workloads even without SMR disks, and doesn't have any noticeable
> overhead for other workloads.
>=20
> I'd guess the one thing that we might want to do is still allow the jou=
rnal
> to optionally checkpoint the metadata to the filesystem in the backgrou=
nd,
> when the filesystem is otherwise idle, so that in case of journal loss =
for
> some reason the whole filesystem is not lost?

IIRC even the new larger default journal size was a big win by itself, ye=
s?

-Eric


--ND59xDfAuHpw14RCcFxCIev46QW4cDpis--

--nEmVIw6nmQhOa96kmITbc1PCU7LBDH0qp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2
Comment: GPGTools - http://gpgtools.org

iQIcBAEBCAAGBQJY9M6oAAoJECCuFpLhPd7gjr0QALu5J0o8YUyCPsSv2bZTsuUl
9jrGUPyhVyCoLPUm8oAGDlhnr9eUzRCqfxhT1l1v9Hq1v4lE40EabCEqeb64icp8
YMVJ9TkmO5Pcp9FtDjrMVXHf66mrKiAj2GDpddqVa89S+rjaed+/AyoCYoB+2G8A
YXmuxBa97UPdAtqggt+bnGt+MXf7pA2iLzqaRhBfwDkMYnOluRqCzfGnV0gxAwle
MFaWK7zt+L369JojJDNAQ/vu1CStGTsu5rEX6kYXoNwD0JK0E1JAg/gqAL6okG3t
5p1xp/uJqOVdA2dea4wlSCFdq6beUy2cZA6GXAZt2wKtNyHNKcGpFgIguUJLXMc1
5Dq59s3pRVejX7e91Y7jFcbgrrZO3b2N8WiSMj9+hJvUpaP6kepWIYSH42XX2sih
+XYnUjl3/zuurxWbKSynESv9icird6mOGRE+QJ74ILjRi5SH/QwXCsTq1KGnoLq/
Cwrl/3vuY66hjhzoNzcA4hVWdHmAaS+mQiiu0w5YtC5tmmnmHRsVwseUuO5U9U7B
hlF+nl36QNmNh7dCgHbC7yB/a0H89zyFikNdBhpgQ0AOqElcxbtYxAuA9epRxr41
pj4xCdUYvlAEnz2eFwSqMZmqWxqwrI3D+sV73pQGRp3kg1SyP4IPu+RaRKL8SHX1
tWNLT46b3B3Qmmvcua2w
=uRa0
-----END PGP SIGNATURE-----

--nEmVIw6nmQhOa96kmITbc1PCU7LBDH0qp--
