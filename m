From: Andrey Borzenkov <arvidjaar@mail.ru>
Subject: 2.6.28-rc3: ext4_ext_search_right: =?utf-8?q?=E2=80=98ix=E2=80=99_may_be_used?= uninitialized
Date: Mon, 3 Nov 2008 11:12:59 +0300
Message-ID: <200811031113.01297.arvidjaar@mail.ru>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1574675.CcO6eUx3RS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pusher.mail.ru ([194.67.23.231]:7102 "EHLO mx48.mail.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753238AbYKCINH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 3 Nov 2008 03:13:07 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--nextPart1574675.CcO6eUx3RS
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

  CC [M]  fs/ext4/extents.o
/home/bor/src/linux-git/fs/ext4/extents.c: In function =E2=80=98ext4_ext_se=
arch_right=E2=80=99:
/home/bor/src/linux-git/fs/ext4/extents.c:1120: warning: =E2=80=98ix=E2=80=
=99 may be used uninitialized in this function

{pts/1}% rpm -q gcc
gcc-4.3.2-3mnb2
{pts/1}%      =20

on Mandriva cooker

--nextPart1574675.CcO6eUx3RS
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkOso0ACgkQR6LMutpd94z+9QCgxclE6QaQ98NCiVVXy0dMIHz3
0roAoJ/+IUfJftcC9fVlUZrSBzkMGJjs
=4FO/
-----END PGP SIGNATURE-----

--nextPart1574675.CcO6eUx3RS--
