From: Andre Noll <maan@systemlinux.org>
Subject: Re: ext4: (2.6.34-rc4): This should not happen!!  Data will be lost
Date: Sun, 18 Apr 2010 00:38:54 +0200
Message-ID: <20100417223854.GD25507@skl-net.de>
References: <20100416123526.GW21495@skl-net.de> <20100416163654.GD58339@plapa.qlogic.org> <20100416170707.GB25507@skl-net.de> <201004171855.36874.bernd.schubert@fastmail.fm> <4BCA1DFB.5030501@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G2kvLHdEX2DcGdqq"
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>,
	Andrew Vasquez <andrew.vasquez@qlogic.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Driver <Linux-Driver@qlogic.com>,
	Thomas Helle <Helle@tuebingen.mpg.de>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:46389 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755447Ab0DQWjW (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Apr 2010 18:39:22 -0400
Content-Disposition: inline
In-Reply-To: <4BCA1DFB.5030501@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--G2kvLHdEX2DcGdqq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 15:45, Eric Sandeen wrote:
> Interesting that it only happens at enospc time though - the fs would
> be sending barriers in general usage.
>=20
> Although, as ext4 fills, it does do more syncing/flushing to try to
> eke out that last bit of space.... hmm....
>=20
> Andre, just for fun, you might try mounting -o nodelalloc, fill it again,
> and see if you see the same behavior.

Will do. This will take some time though as I destroyed the fs by
writing directly to the device, so I had to recreate it and start from
scratch. I'm currently filling the new fs using a 60s device timeout as
suggested by Andrew.

> If not, you might do it again w/ defaults, and capture blktrace data, whi=
ch
> I think will trace barrier requests as well.
>=20
> (or, maybe also try testing with -o nobarrier)
>=20
> I still don't think it's likely a filesystem problem but maybe you can
> pinpoint the fs behavior that triggers it.

I'll try to reproduce the problem using different timeout values and the
ext4 options you suggest. If I can find a reliable reproducer, I'll run
blktrace and post the results.

Regards
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--G2kvLHdEX2DcGdqq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFLyjh+Wto1QDEAkw8RAi9SAJ9/pa1ja7ffAH09x6vzp6YGKxrpxACfZq4J
vVdxu7seFQwRavahwZNBAnc=
=MlhY
-----END PGP SIGNATURE-----

--G2kvLHdEX2DcGdqq--
