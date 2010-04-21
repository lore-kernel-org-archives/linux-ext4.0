From: Andre Noll <maan@systemlinux.org>
Subject: Re: ext4: (2.6.34-rc4): This should not happen!!  Data will be lost
Date: Wed, 21 Apr 2010 15:47:35 +0200
Message-ID: <20100421134735.GB21495@skl-net.de>
References: <20100416123526.GW21495@skl-net.de> <20100416163654.GD58339@plapa.qlogic.org> <20100416170707.GB25507@skl-net.de> <201004171855.36874.bernd.schubert@fastmail.fm> <4BCA1DFB.5030501@redhat.com> <20100417223854.GD25507@skl-net.de> <20100420153723.GE25507@skl-net.de> <87ljch5giz.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="faftCqpOTSjrV+Vj"
Cc: Eric Sandeen <sandeen@redhat.com>,
	Bernd Schubert <bernd.schubert@fastmail.fm>,
	Andrew Vasquez <andrew.vasquez@qlogic.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Driver <Linux-Driver@qlogic.com>,
	Thomas Helle <Helle@tuebingen.mpg.de>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:53303 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754531Ab0DUNtG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 21 Apr 2010 09:49:06 -0400
Content-Disposition: inline
In-Reply-To: <87ljch5giz.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--faftCqpOTSjrV+Vj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12:57, Dmitry Monakhov wrote:
> > 	- run stress -d 5 --hdd-bytes 10G --hdd-noclean until it dies
> what 'stress' process do?  was it posted already?

stress is a simple, yet useful program which imposes certain types of
stress on a machine. With the above command line options, it simply
writes 5 files in parallel, each 10G large, in an endless loop until
the file system is full (or becomes read-only due to errors). It
helped me more than once to identify hardware or software problems,
_before_ the machine went into production use.

> > Summary: Increasing the device timeout to 60s _or_ disabling barriers
> > makes the problem go away. Deactivating delayed allocation makes the
> > problem worse.
> 2Gb cache is really huge.

Really? This is a four year old el-cheapo hardware raid system with
16 SATA slots. You can easily spend twice the money and get much more
cache memory then.

> barriers=3D0 , result in less disk wcache activity, but more real IO
> And nodelaloc result in more real IO due, so imho this is looks like
> device issue.

Yes, I think we all agree that the problem is not ext4-related but
is most likely an issue with the infortrend hardware. However, ext4
seems to be very good at triggering that particular problem.

> about nodelalloc: It is unlikely to see "This should not happen!!=20
> Data will be lost" because this message appear from writepage
> so may happens only when you rewrite an existing file(below i_size).

Nope, this definitely occured while stress was writing new files and
the file system was nearly full.

> BTW, you already noted that you have performed some stress on the device
> without filesystem. What was they doing?

I only ran ddrescue /dev/sda /dev/null once to make sure everything
is readable. This completed with no problems, so I created an ext4
file system and used the above stress command which resulted in write
errors. I then used ddrescue again to rewrite the sector on which
the error occured. This also succeeded which indicates a transient
problem, i.e. no problem with the particular sector.

Regards
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--faftCqpOTSjrV+Vj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFLzwH3Wto1QDEAkw8RAuuNAJ9Cl6rFklsADUUiPX9Q545DXSP0PACgmdNp
NnLwc0sNE8bPkZHtoAi2orM=
=hFet
-----END PGP SIGNATURE-----

--faftCqpOTSjrV+Vj--
