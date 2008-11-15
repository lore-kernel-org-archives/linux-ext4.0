From: Bruce Guenter <lists-linux-ext4@bruce-guenter.dyndns.org>
Subject: Re: ext4 unlink performance
Date: Sat, 15 Nov 2008 14:44:23 -0600
Message-ID: <20081115204423.GA4671@untroubled.org>
References: <20081113185712.GB11204@untroubled.org> <20081113191000.GA11516@untroubled.org> <20081113204240.GF21652@mit.edu> <20081114041121.GB11746@untroubled.org> <20081114145914.GE25117@mit.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zak.futurequest.net ([69.5.6.152]:37751 "HELO
	zak.futurequest.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751652AbYKOUo0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 15 Nov 2008 15:44:26 -0500
Content-Disposition: inline
In-Reply-To: <20081114145914.GE25117@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2008 at 09:59:14AM -0500, Theodore Tso wrote:
> This is beginning to perhaps sound like a layout problem of some kind.

To test this theory, I ran one test where I populated the filesystem
with ext3 and then mounted as ext4 to do the unlinking.  This produced
unlink times comparable with ext3.  That is, the degredation is occuring
when the filesystem is populated, not when it is cleaned.

--=20
Bruce Guenter <bruce@untroubled.org>                http://untroubled.org/

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iD8DBQFJHzSn6W+y3GmZgOgRAqu/AJ91wOIlKsJ01XbJ7GWh2yg1BZChlgCfVTov
9Z00NK/rrcwY7zsLKDWk5g4=
=Ahah
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
