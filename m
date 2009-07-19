From: Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] debian: Remove uuid packages
Date: Sun, 19 Jul 2009 15:56:24 +0100
Message-ID: <1248015384.4524.23.camel@quest>
References: <E1MRWBq-0000yy-0F@zelda.netsplit.com>
	 <20090717064851.GJ4207@webber.adilger.int>  <20090719011329.GC2416@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-zSOv/MEdMEyjVzzlnEjq"
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	util-linux-ng@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zelda.netsplit.com ([87.194.19.211]:60223 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374AbZGSO4N (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 19 Jul 2009 10:56:13 -0400
In-Reply-To: <20090719011329.GC2416@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-zSOv/MEdMEyjVzzlnEjq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-07-18 at 21:13 -0400, Theodore Tso wrote:

> On Fri, Jul 17, 2009 at 02:48:51AM -0400, Andreas Dilger wrote:
> > On Jul 16, 2009  19:59 +0100, Scott James Remnant wrote:
> > > +Build-Depends: texi2html (>=3D 1.76), gettext, texinfo, dc, pkg-conf=
ig, dietlibc-dev (>> 0.30) [alpha amd64 arm hppa i386 ia64 mips mipsel powe=
rpc ppc64 s390 sparc], debhelper (>=3D 7.0), libblkid-dev (>=3D 2.16), libu=
uid-dev (>=3D 2.16)
> >=20
> > Same question as for libblkid-dev...  Ideally, even thought the package
> > version is 2.x, the ABI hasn't changed (AFAIK, that was a hard requirem=
ent)
> > so this should really still be called libuuid1 for compatibility.
>=20
> The so version number for the package is still 1; so the packages
> containing the binary shared libraries are libuuid1 and libblkid1.
> What gets confusing is that version numbers for libblkid-dev,
> libuuid-dev, libblkid1, and libuuid1 will be 2.16.x, not because of
> any soversion number, but because that's the version number of
> util-linux-ng.
>=20
It's always dangerous to start confusing SONAMEs or version numbers, and
doubly so to attempt to make them match.

The SONAME of a library reflects its ABI, the version number of software
reflects the author's opinions about it.

Scott
--=20
Scott James Remnant
scott@ubuntu.com

--=-zSOv/MEdMEyjVzzlnEjq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpjNBcACgkQSnQiFMl4yK75YwCfY0RJoCiaqR58DgQCATDcu9o3
PZUAoJpRTpZ8OExuogRpm1R/fbTlpoFO
=wPpU
-----END PGP SIGNATURE-----

--=-zSOv/MEdMEyjVzzlnEjq--

