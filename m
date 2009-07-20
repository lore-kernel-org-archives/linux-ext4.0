From: Scott James Remnant <scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] configure: Disable libblkid by default
Date: Mon, 20 Jul 2009 15:37:02 +0100
Message-ID: <1248100622.4524.41.camel@quest>
References: <E1MRWBp-0000yN-9a@zelda.netsplit.com>
	 <20090717143637.GM8508@mit.edu> <1247842479.4524.11.camel@quest>
	 <20090717150207.GA29705@mit.edu> <1247843694.4524.13.camel@quest>
	 <20090719115617.GF2416@mit.edu> <20090719212714.GA6886@nb.net.home>
	 <20090720142337.GH2416@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7nsyXBtgh5r0evu8u070"
Cc: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090720142337.GH2416-3s7WtUTddSA@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org


--=-7nsyXBtgh5r0evu8u070
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-20 at 10:23 -0400, Theodore Tso wrote:

> On Sun, Jul 19, 2009 at 11:27:14PM +0200, Karel Zak wrote:
> >  Maybe we can add --disable-{libuuid,libblkid}-versioning for people
> >  who need to bypass the default behaviour.
>=20
> There are some commercial programs that might use libuuid --- minor
> ones, like SAP R/3.  So they might want to create programs that work
> on both RHEL 5 and RHEL 6.  The only way I can think of doing this is
> to build the link libraries without the map file, and the shared
> library with the map file.
>=20
Actually, it's far easier than that - just build on RHEL 5

You have to do that to be safe against symbol changes in other libraries
(like libc) anyway.

Scott
--=20
Scott James Remnant
scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org

--=-7nsyXBtgh5r0evu8u070
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpkgQ4ACgkQSnQiFMl4yK4R7wCZAchtPau3N4QBeKYhMRwgG6VB
97kAoJxYOH1FXya8VW6OZrIpCeX8pmF2
=zVnv
-----END PGP SIGNATURE-----

--=-7nsyXBtgh5r0evu8u070--

--
To unsubscribe from this list: send the line "unsubscribe util-linux-ng" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
