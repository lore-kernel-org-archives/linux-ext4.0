From: Scott James Remnant <scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] configure: Disable libblkid by default
Date: Fri, 17 Jul 2009 15:54:39 +0100
Message-ID: <1247842479.4524.11.camel@quest>
References: <E1MRWBp-0000yN-9a@zelda.netsplit.com>
	 <20090717143637.GM8508@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-xNJLmlRqGXW7m33PFu6P"
Cc: linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20090717143637.GM8508-3s7WtUTddSA@public.gmane.org>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org


--=-xNJLmlRqGXW7m33PFu6P
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-07-17 at 10:36 -0400, Theodore Tso wrote:

> On Thu, Jul 16, 2009 at 07:46:13PM +0100, Scott James Remnant wrote:
> > Since util-linux-ng now builds libblkid by default, e2fsprogs
> > should not do so.
>=20
> I'm not going to be applying these patches for quite some time.  I'd
> much rather have packaging scripts that *know* they will be packaging
> alongside util-linux-ng use --disable-libblkid, etc. so we don't break
> things for folks who might need to build e2fsprogs for distributions
> that are still using util-linux --- which at the moment still have the
> vast majority of the installed base, and every so often people do
> actually care about running updated filesystem utilities on an older
> enterprise distribution.
>=20
But you didn't accept those patches I sent either.

> The at the minimum I'll want to make sure that the debian/rules file
> packaged with e2fsprogs can build both for util-linux and
> util-linux-ng for similar reasons, especially since Lamont hasn't
> gotten back to us about potentially getting util-linux-ng packaged for
> Debian yet.
>=20
I've done the packaging for him, it's just waiting on him to get back
home to sponsor the uploads.

Scott
--=20
Scott James Remnant
scott-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org

--=-xNJLmlRqGXW7m33PFu6P
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpgkK8ACgkQSnQiFMl4yK5kRgCfWXxFxO5e7kV2Czk53OGMY5yz
itQAn2+EHIBiD9lxEhfhsSpkl8Ggfi59
=qgsa
-----END PGP SIGNATURE-----

--=-xNJLmlRqGXW7m33PFu6P--

--
To unsubscribe from this list: send the line "unsubscribe util-linux-ng" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
