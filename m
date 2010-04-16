From: Andre Noll <maan@systemlinux.org>
Subject: Re: ext4: (2.6.34-rc4): This should not happen!!  Data will be lost
Date: Fri, 16 Apr 2010 17:30:24 +0200
Message-ID: <20100416153024.GY25507@skl-net.de>
References: <20100416123526.GW21495@skl-net.de> <4BC87BF6.2040104@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ONmcTkPhtkbQYSLg"
Cc: linux-ext4@vger.kernel.org, linux-driver@qlogic.com,
	Thomas Helle <Helle@tuebingen.mpg.de>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:39988 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710Ab0DPPas (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Apr 2010 11:30:48 -0400
Content-Disposition: inline
In-Reply-To: <4BC87BF6.2040104@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--ONmcTkPhtkbQYSLg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10:02, Eric Sandeen wrote:

> > I'm seeing the following errors when writing to an ext4 file system:
> >=20
> > 	qla2xxx 0000:06:09.0: scsi(0:0:0): Abort command issued -- 1 fa6a73 20=
02.
> > 	end_request: I/O error, dev sda, sector 7812771880
>=20
> Sounds like a hardware failure

Yes, or a problem with the qla2xxx driver. However, it's a bit
surprising that the hardware survived the stress test for more than
one day and went south just at the moment the fs was completely filled.

My first guess was that the problem might be caused by a reported
device size which is slightly larger than the actual size. But then

	ddrescue -i 7440Gi /dev/zero /dev/sda

would have resulted in a similar error. This command completed without
errors though.

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--ONmcTkPhtkbQYSLg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFLyIKQWto1QDEAkw8RAqWyAJ4hQm2p4ZPTN0BliHp+h6c4vgYPgQCfUV8V
04nPTCoelSeZhG4qxiTB7oY=
=yD31
-----END PGP SIGNATURE-----

--ONmcTkPhtkbQYSLg--
