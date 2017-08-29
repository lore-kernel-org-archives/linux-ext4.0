From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] Documentation: fix little inconsistencies
Date: Tue, 29 Aug 2017 09:27:08 +0200
Message-ID: <20170829072708.GA30643@amd>
References: <20170828094638.GA15378@amd>
 <20170828161707.GA4750@magnolia>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        tytso@mit.edu, corbet@lwn.net, linux-ext4@vger.kernel.org,
        Andrew Morton <akpm@osdl.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170828161707.GA4750@magnolia>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



> > index 5e40e1f..6309e90 100644
> > --- a/Documentation/networking/switchdev.txt
> > +++ b/Documentation/networking/switchdev.txt
> > @@ -29,7 +29,7 @@ with SR-IOV or soft switches, such as OVS, are possib=
le.
> >  =E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=
=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=
=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89sw1p1=E2=80=89 +  sw1=
p3  + =E2=80=89sw1p5  +  =E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=
=80=89=E2=80=89=E2=80=89eth1
> >  =E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=
=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=
=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89+=
=E2=80=89=E2=80=89=E2=80=89=E2=80=89|=E2=80=89=E2=80=89=E2=80=89=E2=80=89+=
=E2=80=89=E2=80=89=E2=80=89=E2=80=89|=E2=80=89=E2=80=89=E2=80=89=E2=80=89+=
=E2=80=89=E2=80=89=E2=80=89=E2=80=89|=E2=80=89=E2=80=89=E2=80=89=E2=80=89=
=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89+
> >  =E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=
=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=
=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89|=
=E2=80=89=E2=80=89=E2=80=89=E2=80=89|=E2=80=89=E2=80=89=E2=80=89=E2=80=89|=
=E2=80=89=E2=80=89=E2=80=89=E2=80=89|=E2=80=89=E2=80=89=E2=80=89=E2=80=89|=
=E2=80=89=E2=80=89=E2=80=89=E2=80=89|=E2=80=89=E2=80=89=E2=80=89=E2=80=89=
=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89|
> > -=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=
=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=
=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89+--+----+----+----+-+--+----+-=
--+=E2=80=89=E2=80=89+-----+-----+
> > +=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=
=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=
=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89+--+----+----+----+----+----+-=
--+=E2=80=89=E2=80=89+-----+-----+
>=20
> Except for this last part, looks ok.

Anything wrong here? It is fixing extra '+' in the ascii art...
									Pavel

> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>=20
> --D
>=20
> >  =E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=
=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=
=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89|=E2=80=89=E2=80=89=E2=80=89=
=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89Switch=E2=80=89driver=
=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=
=80=89|=E2=80=89=E2=80=89|=E2=80=89=E2=80=89=E2=80=89=E2=80=89mgmt=E2=80=89=
=E2=80=89=E2=80=89|
> >  =E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=
=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=
=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89|=E2=80=89=E2=80=89=E2=80=89=
=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89(this=E2=80=89document)=E2=80=
=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89|=E2=80=
=89=E2=80=89|=E2=80=89=E2=80=89=E2=80=89driver=E2=80=89=E2=80=89|
> >  =E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=
=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=
=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89|=E2=80=89=E2=80=89=E2=80=89=
=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=
=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=
=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=
=E2=80=89=E2=80=89=E2=80=89|=E2=80=89=E2=80=89|=E2=80=89=E2=80=89=E2=80=89=
=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89=E2=80=89|
> >=20
> > --=20
> > (english) http://www.livejournal.com/~pavelmachek
> > (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses=
/blog.html
>=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlmlF0wACgkQMOfwapXb+vJW2wCeIxV/bXfM0ul4yfv1+p65D/RV
KNMAnjkBrj2+ULe5CpIxT8KoUqrCxaMi
=m6cL
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
