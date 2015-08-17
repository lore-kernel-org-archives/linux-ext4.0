From: Felipe Balbi <balbi@ti.com>
Subject: Please revert 08439fec266c3cc5702953b4f54bdf5649357de0
Date: Mon, 17 Aug 2015 14:45:03 -0500
Message-ID: <20150817194502.GC16201@saruman.tx.rr.com>
Reply-To: <balbi@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xesSdrSSBC0PokLI"
Cc: Nishanth Menon <nm@ti.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>,
	<linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

--xesSdrSSBC0PokLI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Theodore,

as you already know, commit 08439fec266c (ext4: remove
block_device_ejected) caused a regression for (at least) USB attached
storage devices.

You provided a fix for the regression by reverting that commit in
b9e43f49f672 (Revert "ext4: remove block_device_ejected"). This
revert is, currently, on linux-next but broken commit is part of
v4.1-final and, thus, part of v4.1 LTS.

Could you please mark your revert for v4.1+ stable ? If it's not too
late to get it in v4.2-final, that would be great, otherwise we a Cc
stable would suffice anyway.

In summary, commit 08439fec266c needs to be reverted on both v4.1-stable
and v4.2.

Thanks

--=20
balbi

--xesSdrSSBC0PokLI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJV0jm+AAoJEIaOsuA1yqREuGoQAIe/3BQ7shjRXrmXwi++lrwL
Cun+HBxVhUF59QAjIPWDUmoLKKocr0ooHruocOTSUzr+YKmX+FtXiZQSrC7rm4br
QgCHbB/kR2m4yo87iCkLg43B8KD4xaDs4nvYwy2gunHPQvBDPAcxJWFODCWthZ4v
DKB3YR7bbzo6qc8ZwFXjnM8iSNE8EegthMlDBZEeI/Lg2HxsRZGL8yn9x+o+rkWW
T77KoIw1ciMUgiUqQz/zsdufX7qMrKX13n9vMTNyA+VIWhCCEw1y64ML79O+1UXV
DdgWgsc+wYxSBjzOCvvOOOIbX4/3ZywCHRt8zKkgW4Krn/kOuiKPNWWAoAUnHZAK
JEfPtup8kkY35GPwCP96deRMpGrdIe4kYI+EYs32l3KiwWIMezO+ZVN66YBSw2iq
I/MTrPOSLYIIXAKhPDMJxQG7Xe0gYRX/16J0YyV1uMuZfGASYqu9VVbyW3oTkXxD
l9a10TEeYuyzWdvvmJeqUwBDkxlUH+V9s//rgoxmr2/vBShtfwd73gtWMNGnCkHn
69OhXaEuVlIj/qXHTbegcHCtR8rKPJCOx74Z33bfIRvfzxZ+QPurXTAAFPI0i3J+
f3ZXbQ4xNG5ymJwkOrQDPy4sILdOwNAGDXoTp0FTrclGwAqCxSfBYjLRXX7hnU7f
k72VgEKhHEg4nJfLXsu8
=w3aw
-----END PGP SIGNATURE-----

--xesSdrSSBC0PokLI--
