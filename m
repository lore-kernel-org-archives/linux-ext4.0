From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: info about filesystem errors in /sys/fs/ext4/... ?
Date: Mon, 5 May 2014 09:08:23 +0200
Message-ID: <20140505070823.GM3017@pcnci.linuxbox.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pz/qqzCPDfGwIFOg"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gwu.lbox.cz ([62.245.111.132]:58937 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754619AbaEEHOD (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 May 2014 03:14:03 -0400
Received: from pcnci.linuxbox.cz (pcnci.linuxbox.cz [10.76.3.14])
	by gwu.lbox.cz (Sendmail) with ESMTP id s4578NQG023558
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 5 May 2014 09:08:23 +0200
Received: from pcnci.linuxbox.cz (localhost.localdomain [127.0.0.1])
	by pcnci.linuxbox.cz (8.14.7/8.14.7) with SMTP id s4578Nok023002
	for <linux-ext4@vger.kernel.org>; Mon, 5 May 2014 09:08:23 +0200
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--Pz/qqzCPDfGwIFOg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I was wondering, is it possible to find out whether some filesystem with
errors in mounted apart from parsing kernel log?

Would it be too complicated to add such info to /sys/fs/ext4/.../ or to
some other location? Would such change make sense to you?

with regards

nik



--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28.rijna 168, 709 00 Ostrava

tel.:   +420 591 166 214
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--Pz/qqzCPDfGwIFOg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAlNnOOcACgkQ3xdJJrLygV5oFQCgkVbXfHVQ9EGDhtlI6Hmuiwrv
oWwAn2R+fmo5+qlHDC9hNBH+HfkuHdZl
=SKLv
-----END PGP SIGNATURE-----

--Pz/qqzCPDfGwIFOg--
