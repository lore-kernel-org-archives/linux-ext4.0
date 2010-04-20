From: Andre Noll <maan@systemlinux.org>
Subject: Re: ext4: (2.6.34-rc4): This should not happen!!  Data will be lost
Date: Tue, 20 Apr 2010 20:35:33 +0200
Message-ID: <20100420183533.GA21495@skl-net.de>
References: <20100416123526.GW21495@skl-net.de> <20100420153723.GE25507@skl-net.de> <4BCDDB7F.6040903@redhat.com> <201004201926.33908.bernd.schubert@fastmail.fm>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xp8Ni8nhoc60gS0v"
Cc: Eric Sandeen <sandeen@redhat.com>,
	Andrew Vasquez <andrew.vasquez@qlogic.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Linux Driver <Linux-Driver@qlogic.com>,
	Thomas Helle <Helle@tuebingen.mpg.de>
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from systemlinux.org ([83.151.29.59]:37568 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754956Ab0DTSgE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 20 Apr 2010 14:36:04 -0400
Content-Disposition: inline
In-Reply-To: <201004201926.33908.bernd.schubert@fastmail.fm>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--xp8Ni8nhoc60gS0v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 19:26, Bernd Schubert wrote:
> On Tuesday 20 April 2010, Eric Sandeen wrote:
> I think interesting at this point would be the exact model of the Infortr=
end=20
> device.

Here's the system information as reported by the telnet interface:

	CPU Type             PPC750FX       =20
	Total Cache Size     2048MB DDR(ECC)=20
	Firmware Version     3.42I.03       =20
	Bootrecord Version   1.23A          =20
	FW Upgradability     Rev. C         =20
	Serial Number        6912121        =20
	Battery Backup Unit  Present        =20
	Base Board Rev. ID   0              =20
	Base Board ID        81             =20
	ID of NVRAM Defaults A16F-G2221 V6.10
	Controller Position  Slot A         =20

> There are some completely broken models (IMHO), which have two=20
> controllers for redundancy.

This is a 4 year old system (which does not support Raid6). It has only
a single controller though.

> Now with enabled write-back cache, it can happen that those units run
> into some kind of firmware bug. It then takes about 2h to flush 2GB of
> write-back cache.  The telnet interface will show the status of the
> cache.

Hey, I saw this once on a different (newer) infortrend system. However,
it might still be hapening on this system as well and cause the timeout
problems.

Guess I'll have to check if there's a more recent firmware for this
system..

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--xp8Ni8nhoc60gS0v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFLzfP1Wto1QDEAkw8RAqN6AJ9npu8Ke2YMEhjyqodpgNblau3cJQCfaLBL
mqSV/z2/kcq95xUslbU8lNo=
=6bIs
-----END PGP SIGNATURE-----

--xp8Ni8nhoc60gS0v--
