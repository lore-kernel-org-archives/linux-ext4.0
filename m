From: Bruce Guenter <lists-linux-ext4@bruce-guenter.dyndns.org>
Subject: Re: ext4 unlink performance
Date: Thu, 20 Nov 2008 16:49:03 -0600
Message-ID: <20081120224903.GA25280@untroubled.org>
References: <20081113191000.GA11516@untroubled.org> <20081113204240.GF21652@mit.edu> <20081114041121.GB11746@untroubled.org> <20081114145914.GE25117@mit.edu> <20081115204423.GA4671@untroubled.org> <20081116005610.GI22948@mit.edu> <20081117004330.GC3436@webber.adilger.int> <20081119024021.GA10185@mit.edu> <20081119181000.GD3186@webber.adilger.int> <20081119211840.GA8021@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zak.futurequest.net ([69.5.6.152]:58813 "HELO
	zak.futurequest.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752642AbYKTWtJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Nov 2008 17:49:09 -0500
Content-Disposition: inline
In-Reply-To: <20081119211840.GA8021@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 19, 2008 at 04:18:40PM -0500, Theodore Tso wrote:
> It would be good for us to get confirmation one way or another about
> this theory.  Bruce, if you have multiple CPU's (or cores on your
> system --- i.e., cat /proc/cpuinfo reports multiple processors),

The test system has only a single core CPU.

--=20
Bruce Guenter <bruce@untroubled.org>                http://untroubled.org/

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iD8DBQFJJelf6W+y3GmZgOgRAjmFAJ9nUtFA8AwzZ8wjprdaT9Hc3VR/kgCeO/gl
JjX0jE47kOeTc1bEbPmrzh0=
=8D71
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
