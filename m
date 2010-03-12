From: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
Subject: e2fsck doesn't repair broken ext4
Date: Fri, 12 Mar 2010 21:54:36 +0100
Message-ID: <20100312205435.GG32664@alea.gnuu.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kbCYTQG2MZjuOjyn"
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from uucp.gnuu.de ([83.246.114.63]:2560 "EHLO uucp.gnuu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753582Ab0CLVrc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 12 Mar 2010 16:47:32 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--kbCYTQG2MZjuOjyn
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

after a system crash, I had a problem with ext4 that e2fsck didn't fix. I
don't know if e2fsck or ext4 was wrong. In the end, I had to remove the
broken directory, which succeed and solved my problem.

These are the steps I did:

01 % e2fsck -fy /dev/root
02 % dumpe2fsck -x /dev/root
03 % e2image -r /dev/root
04 % apt-get install
05 % dmesg
06 % dumpe2fs -x /dev/root
07 % e2image -r /dev/root
08 % e2fsck -y /dev/root
09 % dumpe2fs -x /dev/root
10 % e2image -r /dev/root
11 % apt-get install
12 % dmesg

I've put the output and images of all these commands at
<http://alioth.debian.org/~jo-guest/ext4/>. I hope they help you somehow.

Regards, J=F6rg.
--=20
Eine Blume geht =FCber eine Wiese, sieht einen sch=F6nen Menschen und rei=
=DFt
ihm den Kopf ab.

--kbCYTQG2MZjuOjyn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature http://en.wikipedia.org/wiki/OpenPGP
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuaqgsACgkQwe0mZwH1VIBYKQCdHlZpv5l4fXUYDVk+5l8Tg/f/
V6cAn2X7Z9yINIylkG4Rpxqyh264wRrx
=FOnm
-----END PGP SIGNATURE-----

--kbCYTQG2MZjuOjyn--
