From: Scott James Remnant <scott-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH] configure.in: add --disable-libuuid option (Was:
 libuuid (Re: blkid: util-linux-ng vs. e2fsprogs))
Date: Tue, 16 Jun 2009 14:36:14 +0100
Message-ID: <1245159374.4225.7.camel@quest>
References: <200905311113.23004.arvidjaar@mail.ru>
	 <20090601124857.GF31943@mit.edu>  <20090603085140.GA4060@nb.net.home>
	 <1244021945.4120.4.camel@quest>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-UDgNFD+Lb+aOrw3Luz0f"
Cc: Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org>, Andrey Borzenkov <arvidjaar-JGs/UdohzUI@public.gmane.org>,
	util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1244021945.4120.4.camel@quest>
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org


--=-UDgNFD+Lb+aOrw3Luz0f
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Ted, any good?

On Wed, 2009-06-03 at 10:39 +0100, Scott James Remnant wrote:
> On Wed, 2009-06-03 at 10:51 +0200, Karel Zak wrote:
>=20
> > On Mon, Jun 01, 2009 at 08:48:57AM -0400, Theodore Tso wrote:
> > > It is supposed to be safe to replace the built-in libblkid in
> > > e2fsprogs with the one in util-linux-ng.  There may be bugs, but if
> > > there are report them, and we'll work to get them fixed.  I'll try to
> > > keep the bug fixes in e2fsprogs and util-linux-ng roughly synchronize=
d
> > > for at least a while, since it takes a while for distributions to mak=
e
> > > the switch.  So a brusque, "drop libblkid, who cares if we screw over
> > > distro's that haven't yet moved to util-linux-ng" is not in the cards=
,
> > > no.  In terms of formal plan, probably in a year or so.  I'm believer
> > > in long compatibility windows.
> >=20
> >  Yes, this is our plan.
> >=20
> >  This reminds me...
> >=20
> >  The next step is to move libuuid from e2fsprogs to util-linux-ng.
> >  Currently, this library is widely used by many packages (Fedora-11):
> >=20
> >    $ repoquery --qf=3D"%{NAME}" --whatrequires libuuid* | sort -u | wc =
-l
> >    74
> >=20
> >  The util-linux-ng code is already prepared for this change and the
> >  library has been merged into git tree.
> >=20
> >  It would be nice to add the --disable-uuid option to e2fsprogs. If I
> >  good remember Scott has a patch for this change. Scott?
> >=20
> Right ;)
>=20
> attached
>=20
> Scott
--=20
Scott James Remnant
scott-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org

--=-UDgNFD+Lb+aOrw3Luz0f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAko3n80ACgkQSnQiFMl4yK538QCdFnDAJBUE+WV9BNaKKm1pVnUa
JhIAnjgvev43P9rMsPJkxeQ2YBrIMtzc
=4yjL
-----END PGP SIGNATURE-----

--=-UDgNFD+Lb+aOrw3Luz0f--

--
To unsubscribe from this list: send the line "unsubscribe util-linux-ng" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
