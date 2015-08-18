From: Felipe Balbi <balbi@ti.com>
Subject: Re: Please revert 08439fec266c3cc5702953b4f54bdf5649357de0
Date: Tue, 18 Aug 2015 10:19:19 -0500
Message-ID: <20150818151919.GE9143@saruman.tx.rr.com>
References: <20150817194502.GC16201@saruman.tx.rr.com>
 <20150818005437.GA7535@thunk.org>
Reply-To: <balbi@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RpqchZ26BWispMcB"
To: "Theodore Ts'o" <tytso@mit.edu>, Felipe Balbi <balbi@ti.com>,
	Christoph Hellwig <hch@lst.de>, <linux-ext4@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
	Nishanth Menon <nm@ti.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150818005437.GA7535@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--RpqchZ26BWispMcB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 17, 2015 at 08:54:37PM -0400, Theodore Ts'o wrote:
> On Mon, Aug 17, 2015 at 02:45:03PM -0500, Felipe Balbi wrote:
> > Hi Theodore,
> >=20
> > as you already know, commit 08439fec266c (ext4: remove
> > block_device_ejected) caused a regression for (at least) USB attached
> > storage devices.
> >=20
> > You provided a fix for the regression by reverting that commit in
> > b9e43f49f672 (Revert "ext4: remove block_device_ejected"). This
> > revert is, currently, on linux-next but broken commit is part of
> > v4.1-final and, thus, part of v4.1 LTS.
> >=20
> > Could you please mark your revert for v4.1+ stable ? If it's not too
> > late to get it in v4.2-final, that would be great, otherwise we a Cc
> > stable would suffice anyway.
> >=20
> > In summary, commit 08439fec266c needs to be reverted on both v4.1-stable
> > and v4.2.
>=20
> Already done.  See the latest version of the dev branch.  I noticed
> this morning that I needed to mark it for stable, and took care of it.

cool, thanks

--=20
balbi

--RpqchZ26BWispMcB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJV00z3AAoJEIaOsuA1yqREPnoQAI0OLEYU8jJZQlOIQQSU7QG6
AquOGkskaNQdJXNZ482UZmoynBaNaNx5NlY3Kip78MLa68GKbNACe3Og7PtRrZ+f
sWjBPJyrh+NYUJneHnW5KA7RMKMD87HEphS/npHZTTMfc5imHrOHeJt7NTC3/yUx
v8gIMFb4/+Sf0gih4yZrqYrHdRFIjCuV+eI4Zwup+xxRc+tPfIAxqVU0Oa8vNqNf
8eyvpvYrkQhGeaXpNT8NT/XYpZ4b0Y/j3ecNi7AtEb0aBZfmEx5oZL7J254nTU6x
bc+O+5Tqgrps61+WaKyq0UhE12/Eq+Vg0w2LtMIog4LQZzIMR4Fr07K48TOBOeTn
6ESd4Rd/ij83ag9QhBKonIN8QlLCrouG2txOyLneisXsGYtQ+iSrFvoV5GU5L+TX
JTVrNSnOA7p/0fRWdKjKSWjemGHeX5vzoR7UZHP+Z2FYz7wbx9hi3O8oNTlz/g/u
X1k+8WXY0uG5x6vMo6XpOuaRcNA2Fm/mEwAIRepbk4XDu7RdlGQ+WExEavEDVikX
d3xukPDHr7kq3pEWsrm3jBTxSptsc4aPStOGCIBejhN4j+T6E/5aTVXi1RcfnGtk
96dLF5tNjwfI3tJp+dYzi4eo+BcujqIkQ+J2PXsRPxtLiKIcmHVa+HZzAPlCwxXj
nzHqA5oVYNnyUWRRE6gm
=Lfcs
-----END PGP SIGNATURE-----

--RpqchZ26BWispMcB--
