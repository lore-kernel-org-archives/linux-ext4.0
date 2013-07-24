From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 0/4] ext4: Fix overflows in ext4 code
Date: Wed, 24 Jul 2013 05:46:02 +0100
Message-ID: <1374641162.18653.20.camel@deadeye.wl.decadent.org.uk>
References: <1369829133-4307-1-git-send-email-jack@suse.cz>
	 <51DC1AC5.8010809@redhat.com> <20130709143855.GF6000@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-yx3IvL0cPngsNZqpvJDI"
Cc: Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20130709143855.GF6000@thunk.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


--=-yx3IvL0cPngsNZqpvJDI
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-07-09 at 10:38 -0400, Theodore Ts'o wrote:
> On Tue, Jul 09, 2013 at 09:14:29AM -0500, Eric Sandeen wrote:
> >=20
> > I don't think these did get cc'd to stable.  Was there a reason for tha=
t,
> > or was it an oversight?
>=20
> It was an oversight; my fault, sorry.  I'll send a request to the
> stable kernel tree for the following patches:
>=20
> 8af8eec ext4: fix overflow when counting used blocks on 32-bit architectu=
res
> a60697f ext4: fix data offset overflow in ext4_xattr_fiemap() on 32-bit a=
rchs

Both queued up for 3.2, thanks.

> e7293fd ext4: fix overflows in SEEK_HOLE, SEEK_DATA implementations
> eaf3793 ext4: fix data offset overflow on 32-bit archs in ext4_inline_dat=
a_fiemap()

These are for features that were added after 3.2.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-yx3IvL0cPngsNZqpvJDI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUe9cCue/yOyVhhEJAQr+DhAAmb4FJXx8IwtBpYmN/bf9VwoQow8GkIJP
vdJIlH5nCk01jg9cAw3CZds/WAmLKGxoNl7sYSsV5Et7ptySOyc3jypH0tq4+dRC
rE3nydgKDuTPhsAdfpUEw2FoJm/mN/eDuXHsXNRxGRbXAne71kahcuUPNmTyj06e
a61n5uEARgIGNO7IlTYg3QTksr08z8gN1em8L9Z+XB9y/Tr9/ItGdD08Bwn+r52E
XFiMmitU1Sl+LQ6M4hQ2aQ9IEvdd2Oa1RFd0SDZbM8m3DlG2eGINYE1sJNCMoCka
NWAefjFO0I6VhNX95rRVJ6PzC1io2B90le9H8SNtR/eqh1XdxtTX7JDoirH6a/m6
/IIyv1G7l3HF1x4/yYh3dQnzh4oWrJ0NnkoE4HkxbeQys642JbrETigGjgy6ZZPk
j0HODkyCHs0lj9vsBNuKN/jFhC5V66TwyANkgr3uEruWs2GrSZEiC3/aUXUiJZvp
iewxCE0tUdfaFAgHPTnoFJa33T8xGm8R9c+ddroszADPhvQjU3738eMznL+KNfiv
jj5mvQ0QVENi/KjFmc9x6kOskn53zOA+g7eUIfkb5hqu6/iiv3vKRXyyae+8jp00
2mpTJuI0dJmljx9ZnGOJxOaQ7M1U+7r3vduWJqnjj3OQd4ezXaUFHOoK191kNfYU
TonENrsRZoM=
=gLr2
-----END PGP SIGNATURE-----

--=-yx3IvL0cPngsNZqpvJDI--
