From: Bruce Guenter <lists-linux-ext4@bruce-guenter.dyndns.org>
Subject: Re: ext4 unlink performance
Date: Fri, 14 Nov 2008 09:48:48 -0600
Message-ID: <20081114154848.GA21361@untroubled.org>
References: <20081113185712.GB11204@untroubled.org> <20081113191000.GA11516@untroubled.org> <20081113204240.GF21652@mit.edu> <20081114041121.GB11746@untroubled.org> <20081114145914.GE25117@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zak.futurequest.net ([69.5.6.152]:60838 "HELO
	zak.futurequest.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751305AbYKNPsw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 14 Nov 2008 10:48:52 -0500
Content-Disposition: inline
In-Reply-To: <20081114145914.GE25117@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2008 at 09:59:14AM -0500, Theodore Tso wrote:
> This is beginning to perhaps sound like a layout problem of some kind.
> How big is the filesystem that you are testing against?

The partition is almost 30GB.

> I'm guessing
> that if you have 725,000 small files, that it can't be much more than
> a gig or two, right?

The compressed stream itself expands to 4.4GB, and more on disk due to
block sizes.

> Can you send me the output of=20
>=20
>     e2image -r /dev/XXX - | bzip2 ext4.e2i.bz2
>=20
> for both the ext4 and ext3 filesystems, after you have loaded them
> with your small files, and before you delete them?

Will do.  Can you accept LZMA so I can save a bit of bandwidth?

--=20
Bruce Guenter <bruce@untroubled.org>                http://untroubled.org/

--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iD8DBQFJHZ3g6W+y3GmZgOgRAvtIAKCWg6jFv4R6pcq/cH3yrudFaOl2sgCgnFkA
yCPD3Gl3Vjc7n+ahckdOMkc=
=DwXB
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
