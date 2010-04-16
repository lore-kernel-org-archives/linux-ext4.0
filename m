From: Andre Noll <maan@systemlinux.org>
Subject: Re: ext4: (2.6.34-rc4): This should not happen!!  Data will be lost
Date: Fri, 16 Apr 2010 19:07:07 +0200
Message-ID: <20100416170707.GB25507@skl-net.de>
References: <20100416123526.GW21495@skl-net.de> <4BC87BF6.2040104@redhat.com> <20100416153024.GY25507@skl-net.de> <4BC885B9.2000902@redhat.com> <20100416155221.GA57840@plapa.qlogic.org> <20100416160856.GA25507@skl-net.de> <20100416163654.GD58339@plapa.qlogic.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2bJ57vwr75KGnr5s"
Cc: Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Driver <Linux-Driver@qlogic.com>,
	Thomas Helle <Helle@tuebingen.mpg.de>
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:47724 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758653Ab0DPRHb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 16 Apr 2010 13:07:31 -0400
Content-Disposition: inline
In-Reply-To: <20100416163654.GD58339@plapa.qlogic.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--2bJ57vwr75KGnr5s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09:36, Andrew Vasquez wrote:
> > > 	qla2xxx 0000:06:09.0: scsi(0:0:0): Abort command issued -- 1 fa6a73 =
2002.
> > >=20
> > > I can't explain why the storage did not complete the request in the
> > > allotted time.
> >=20
> > Ah, that's valuable information, thanks. The underlying Infortrend
> > Raid System is rather old but worked without any problems for several
> > years. We recently replaced its 400G disks by new 2T WD disks. Maybe
> > the new disks have longer response times, could that be the reason? And
> > is there a way to increase the timeout value?
>=20
> To update the default timeout value (30 seconds) for commands
> submitted to /dev/sdn to 60 seconds:
>=20
>         $ echo 60 > /sys/block/sdn/device/timeout

I will re-run the stress test with a 60 seconds timeout value and follow
up if this did not help.

Thanks again
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--2bJ57vwr75KGnr5s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFLyJk7Wto1QDEAkw8RAj9XAJ9nbBmgpu+zMEKKl3IbOLCyLDtpEQCffQ/u
EHT8ybIvOH7vBO0ZjW7VkYQ=
=Jfv+
-----END PGP SIGNATURE-----

--2bJ57vwr75KGnr5s--
