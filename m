From: =?iso-8859-1?Q?J=F6rg?= Sommer <joerg@alea.gnuu.de>
Subject: Re: e2fsck doesn't repair broken ext4
Date: Fri, 16 Apr 2010 12:11:56 +0200
Message-ID: <20100416101156.GB1556@alea.gnuu.de>
References: <20100312205435.GG32664@alea.gnuu.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rS8CxjVDS/+yyDmU"
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from uucp.gnuu.de ([83.246.114.63]:4036 "EHLO uucp.gnuu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756924Ab0DPKMv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Apr 2010 06:12:51 -0400
Content-Disposition: inline
In-Reply-To: <20100312205435.GG32664@alea.gnuu.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--rS8CxjVDS/+yyDmU
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

J=F6rg Sommer hat am Fri 12. Mar, 21:54 (+0100) geschrieben:
> after a system crash, I had a problem with ext4 that e2fsck didn't fix. I
> don't know if e2fsck or ext4 was wrong. In the end, I had to remove the
> broken directory, which succeed and solved my problem.
>=20
> These are the steps I did:
>=20
> 01 % e2fsck -fy /dev/root
> 02 % dumpe2fsck -x /dev/root
> 03 % e2image -r /dev/root
> 04 % apt-get install
> 05 % dmesg
> 06 % dumpe2fs -x /dev/root
> 07 % e2image -r /dev/root
> 08 % e2fsck -y /dev/root
> 09 % dumpe2fs -x /dev/root
> 10 % e2image -r /dev/root
> 11 % apt-get install
> 12 % dmesg
>=20
> I've put the output and images of all these commands at
> <http://alioth.debian.org/~jo-guest/ext4/>. I hope they help you somehow.

I would like to ask, if there was any result from this issue? Did you
found a bug in e2fsck?

Bye, J=F6rg.
--=20
< Mr X.> jo: contact an admin to mount it for you
< jo> The admin is not, well how should I say it, he isn't very familiar wi=
th
      the system. What should I tell my admin, what he should do?
< Mr X.> taking a sun solaris administration course.

--rS8CxjVDS/+yyDmU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature http://en.wikipedia.org/wiki/OpenPGP
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvIN+sACgkQwe0mZwH1VIDGHgCfRPXG79kBCogWYHF266g6f9NV
SP4An0eTcwXTcajVjMLT52hROJWVs9Lg
=mwVL
-----END PGP SIGNATURE-----

--rS8CxjVDS/+yyDmU--
