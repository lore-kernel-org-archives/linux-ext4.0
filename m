From: Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] configure: Disable libblkid by default
Date: Fri, 17 Jul 2009 16:14:54 +0100
Message-ID: <1247843694.4524.13.camel@quest>
References: <E1MRWBp-0000yN-9a@zelda.netsplit.com>
	 <20090717143637.GM8508@mit.edu> <1247842479.4524.11.camel@quest>
	 <20090717150207.GA29705@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-MwYmzHNOljM2OAGKCehp"
Cc: linux-ext4@vger.kernel.org, util-linux-ng@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zelda.netsplit.com ([87.194.19.211]:53800 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934689AbZGQPOy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Jul 2009 11:14:54 -0400
In-Reply-To: <20090717150207.GA29705@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-MwYmzHNOljM2OAGKCehp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-17 at 11:02 -0400, Theodore Tso wrote:

> > > ... at the minimum I'll want to make sure that the debian/rules file
> > > packaged with e2fsprogs can build both for util-linux and
> > > util-linux-ng for similar reasons, especially since Lamont hasn't
> > > gotten back to us about potentially getting util-linux-ng packaged fo=
r
> > > Debian yet.
>=20
> So the patch ideal patch I'd like to see is one where you can toggle a
> flag and debian/rules will either build for util-linux or
> util-linux-ng.  If you've sent such a patch, my apologies for
> overlooking it
>=20
I did, it's the patches that are applied to the Ubuntu source package:

http://kernel.ubuntu.com/git?p=3Dscott/e2fsprogs.git;a=3Dcommit;h=3Dd69bff0=
1e2c034c7d620f7c0baf9b700761034a4

http://kernel.ubuntu.com/git?p=3Dscott/e2fsprogs.git;a=3Dcommit;h=3D1e86919=
5141920331b00c0d594898b8b322e07a3

http://kernel.ubuntu.com/git?p=3Dscott/e2fsprogs.git;a=3Dcommit;h=3D2177ed0=
c6a8f83afa7a9fbef0c04b699c3d52238

> > I've done the packaging for him, it's just waiting on him to get back
> > home to sponsor the uploads.
>=20
> Are the .deb packages somewhere where I can examine them?
>=20
Yes, they're in Ubuntu.

Scott
--=20
Scott James Remnant
scott@ubuntu.com

--=-MwYmzHNOljM2OAGKCehp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpglW4ACgkQSnQiFMl4yK6pLQCdG4UMr2xahVZqkkSm5foXK5gx
g6QAnj+SPLE3P7B/ta961LNFPFGkNv1m
=g429
-----END PGP SIGNATURE-----

--=-MwYmzHNOljM2OAGKCehp--

