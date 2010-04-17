From: Andre Noll <maan@systemlinux.org>
Subject: Re: ext4: (2.6.34-rc4): This should not happen!!  Data will be lost
Date: Sat, 17 Apr 2010 20:19:12 +0200
Message-ID: <20100417181912.GC25507@skl-net.de>
References: <20100416123526.GW21495@skl-net.de> <20100416163654.GD58339@plapa.qlogic.org> <20100416170707.GB25507@skl-net.de> <201004171855.36874.bernd.schubert@fastmail.fm>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FMJTF8LVhUQkvsEb"
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>,
	Eric Sandeen <sandeen@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Driver <Linux-Driver@qlogic.com>,
	Thomas Helle <Helle@tuebingen.mpg.de>
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:39492 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357Ab0DQSTk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Apr 2010 14:19:40 -0400
Content-Disposition: inline
In-Reply-To: <201004171855.36874.bernd.schubert@fastmail.fm>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--FMJTF8LVhUQkvsEb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18:55, Bernd Schubert wrote:
> > > To update the default timeout value (30 seconds) for commands
> > > submitted to /dev/sdn to 60 seconds:
> > >
> > >         $ echo 60 > /sys/block/sdn/device/timeout
> >=20
> > I will re-run the stress test with a 60 seconds timeout value and follow
> > up if this did not help.
>=20
> That will not help if the command is "SYNCHRONIZE_CACHE", as that ignores=
=20
> device settings, but uses scsi default timeout (30s), which is far too sm=
all=20
> for SATA based raid units. Scsi maintainers ignored that and a couple of =
other=20
> patches I wrote to improve error handling with Infortrend units. Will sen=
d the=20
> patches again soon.

Please CC me when you do so. The machine I am having trouble with is
only our fallback server. I can use it freely for testing and am willing
to give your patches a try.

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--FMJTF8LVhUQkvsEb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFLyfugWto1QDEAkw8RAkqwAKCYWQI96mHzLS3e25ejNafrcoWszQCeMLqF
VMwLwVRmiLc63xitdussUps=
=F51k
-----END PGP SIGNATURE-----

--FMJTF8LVhUQkvsEb--
