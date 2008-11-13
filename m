From: Bruce Guenter <lists-linux-ext4@bruce-guenter.dyndns.org>
Subject: Re: ext4 unlink performance
Date: Thu, 13 Nov 2008 13:10:00 -0600
Message-ID: <20081113191000.GA11516@untroubled.org>
References: <20081113185712.GB11204@untroubled.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zak.futurequest.net ([69.5.6.152]:33868 "HELO
	zak.futurequest.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751579AbYKMTKD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Nov 2008 14:10:03 -0500
Content-Disposition: inline
In-Reply-To: <20081113185712.GB11204@untroubled.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2008 at 12:57:12PM -0600, Bruce Guenter wrote:
> Ouch.  Why is ext4 so much slower than ext3 here,

I forgot to mention one important detail.  I started running 'vmstat 5'
during one of the unlink runs, and noticed that there were intervals of
15 or 20 seconds where no blocks were being read or written, and minimal
CPU was being used.  I do not observe the same stalls when using ext3.

--=20
Bruce Guenter <bruce@untroubled.org>                http://untroubled.org/

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iD8DBQFJHHuI6W+y3GmZgOgRAlpqAJ9cql2PqyMrytywjxPSIOTg4oTB7gCfc8Nr
KFOSQDMIx8UTfvbawJJ2fkM=
=jDp3
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
