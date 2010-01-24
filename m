From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: 2.6.32.4 - still getting ext4 related crashes
Date: Sun, 24 Jan 2010 08:19:43 +0100
Message-ID: <20100124071943.GA4407@nik-comp.linuxbox.cz>
References: <20100122085035.GA5020@nik-nb2.linuxbox.cz>
 <20100122213827.GH21263@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Cc: Nikola Ciprich <extmaillist@linuxbox.cz>,
	ext4 maillist <linux-ext4@vger.kernel.org>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gwu.lbox.cz ([62.245.111.132]:39837 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932069Ab0AXHT3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 24 Jan 2010 02:19:29 -0500
Content-Disposition: inline
In-Reply-To: <20100122213827.GH21263@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,
yes, I can reproduce it reliably, I'll give it a try tomorrow and
report.
have a nice day.
nik

> I think this problem has been solved in 2.6.33-rc3+, but it's a bunch
> of patches that need to be backported into the stable branch.  Can you
> reproduce this failure reliably?  Would you be willing to try
> 2.6.33-rc5 and letting me know if you can reproduce it?
>=20
> Many thanks,
>=20
> 					- Ted
>=20

--=20
-------------------------------------
Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFLW/SP3xdJJrLygV4RAixrAKDm4if1WIrnFjnON223wyQxII8ZEwCeJBMp
F3fhz8FHmZMLdG3yqHTmtpM=
=rydp
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
