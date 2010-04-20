From: Andre Noll <maan@systemlinux.org>
Subject: Re: ext4: (2.6.34-rc4): This should not happen!!  Data will be lost
Date: Tue, 20 Apr 2010 19:46:10 +0200
Message-ID: <20100420174610.GZ21495@skl-net.de>
References: <20100416123526.GW21495@skl-net.de> <20100416163654.GD58339@plapa.qlogic.org> <20100416170707.GB25507@skl-net.de> <201004171855.36874.bernd.schubert@fastmail.fm> <4BCA1DFB.5030501@redhat.com> <20100417223854.GD25507@skl-net.de> <20100420153723.GE25507@skl-net.de> <4BCDDB7F.6040903@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bCncd2H9lvi1JwMR"
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>,
	Andrew Vasquez <andrew.vasquez@qlogic.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Driver <Linux-Driver@qlogic.com>,
	Thomas Helle <Helle@tuebingen.mpg.de>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:32774 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755005Ab0DTRqy (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Apr 2010 13:46:54 -0400
Content-Disposition: inline
In-Reply-To: <4BCDDB7F.6040903@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--bCncd2H9lvi1JwMR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11:51, Eric Sandeen wrote:
> On 04/20/2010 10:37 AM, Andre Noll wrote:
> ...
>=20
> > - device timeout 30s, nobarrier
> > 	No problem at all, all three runs OK.
> >=20
> > Eric, are you still interested in seeing the blktrace output? Suppose,
> > I should use a 30s timeout, nodealloc and barriers=3D1 as this triggers
> > the problem within minutes.
>=20
> Hm, so something about barriers being issued is causing timeout
> problems on the device...?

Yes, that's what it looks like.

> To be honest I'm not sure what I would do with the blktrace data now,
> but perhaps someone might be interested to see it; I'd at least gather it.

OK, will send it tomorrow.

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--bCncd2H9lvi1JwMR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFLzehiWto1QDEAkw8RAsoKAKCXBlSudrZldGmk5yT1pVKrJ+tQuQCdF96M
ncRXhRJu32O4KgDGD/1Yl6g=
=MuRf
-----END PGP SIGNATURE-----

--bCncd2H9lvi1JwMR--
