From: Andre Noll <maan@systemlinux.org>
Subject: Re: ext4: (2.6.34-rc4): This should not happen!!  Data will be lost
Date: Fri, 16 Apr 2010 17:57:10 +0200
Message-ID: <20100416155710.GZ25507@skl-net.de>
References: <20100416123526.GW21495@skl-net.de> <4BC87BF6.2040104@redhat.com> <20100416153024.GY25507@skl-net.de> <4BC885B9.2000902@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wwSFAA0Com6UqrPP"
Cc: linux-ext4@vger.kernel.org, linux-driver@qlogic.com,
	Thomas Helle <Helle@tuebingen.mpg.de>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:55742 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932274Ab0DPP5c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Apr 2010 11:57:32 -0400
Content-Disposition: inline
In-Reply-To: <4BC885B9.2000902@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--wwSFAA0Com6UqrPP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10:43, Eric Sandeen wrote:

> Well, the error was on sector 7812771880 of the device ...
>=20
> can you reliably write directly to that sector w/o the filesystem in
> between?

Yes, that does not result in any errors.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--wwSFAA0Com6UqrPP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFLyIjWWto1QDEAkw8RAtzmAJ9TniiYm5ZPfLAP/+++RqZROvTCggCfdx+g
ofmSdON+1a+fufFrgcKrguw=
=cNrQ
-----END PGP SIGNATURE-----

--wwSFAA0Com6UqrPP--
