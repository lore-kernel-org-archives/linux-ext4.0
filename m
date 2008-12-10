From: Andres Freund <andres@anarazel.de>
Subject: Re: EXT4 ENOSPC Bug
Date: Wed, 10 Dec 2008 01:07:57 +0100
Message-ID: <200812100108.04163.andres@anarazel.de>
References: <200811291418.24672.andres@anarazel.de>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8098954.BVZABXChbZ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: adilger@sun.com, LKML <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org,
	"Jonathan Bastien-Filiatrault" <joe@x2a.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.anarazel.de ([217.115.131.40]:53474 "EHLO smtp.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbYLJAIO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Dec 2008 19:08:14 -0500
In-Reply-To: <200811291418.24672.andres@anarazel.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--nextPart8098954.BVZABXChbZ
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Ted,

Very Strange:
I booted (after an crash which I did not see) a somewhat older kernel and I=
=20
once more caught the issue. Unfortunately I do not have your patch in this=
=20
older kernel.


older kernel: 2.6.28-rc5-andres-00070-g4e14e83
kernel I rean whole last week: 2.6.28-rc6-andres-00007-ged31348
There seem to have been no significant ext4 related changes to the kernel =
=20
between those.

for i in `seq 1 1000`;do touch tmp$i;done
touch: cannot touch `tmp139': No space left on device
=2E..

rm tmp*;for i in `seq 1 200`;do dd if=3D/dev/zero of=3Dtmp$i bs=3D1024k cou=
nt=3D1;done
dd: opening `tmp139': No space left on device
139
=2E.

Various different blocksizes and filesizes all return the same result.

This all hints to the patch Anesh linked. But it is included in 2.6.28-rc5.=
=20
Any idea how that could happen?

The kernel install is just a "make;make install; update-initramfs -c -k `ma=
ke=20
kernelrelease`; update-grub" run...

A short idea how I could verify on binary level what kernelrelease it reall=
y=20
is?


If a somehow corrupted compile (murked ccache?) is the culprit of this (in=
=20
addition to my inaccuracies) I am very sorry for all your work.

I let this kernel run for the next hours if you want to run some tests...

Thanks,

Andres



--nextPart8098954.BVZABXChbZ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkk/CF4ACgkQporPraT14ig7mQCgljDsBQtzENxJBx8lmaeDRE4V
QkUAnRP3u2fDzIiyjlVEmlboLe6eDtE0
=8lJm
-----END PGP SIGNATURE-----

--nextPart8098954.BVZABXChbZ--
