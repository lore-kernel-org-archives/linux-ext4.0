From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: e2fsprogs - possible regression between 1.42.7 and 1.42.8
Date: Mon, 29 Jul 2013 10:39:41 +0200
Message-ID: <20130729083941.GG28871@pcnci.linuxbox.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eVzOFob/8UvintSX"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gwu.lbox.cz ([62.245.111.132]:59835 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904Ab3G2Iyw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Jul 2013 04:54:52 -0400
Received: from pcnci.linuxbox.cz (pcnci.linuxbox.cz [10.76.3.14])
	by gwu.lbox.cz (Sendmail) with ESMTP id r6T8dfhX009553
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 29 Jul 2013 10:39:41 +0200
Received: from pcnci.linuxbox.cz (localhost.localdomain [127.0.0.1])
	by pcnci.linuxbox.cz (8.14.7/8.14.5) with SMTP id r6T8dfYb018043
	for <linux-ext4@vger.kernel.org>; Mon, 29 Jul 2013 10:39:41 +0200
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--eVzOFob/8UvintSX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

trying to compile latest e2fsprogs and running check under RHEL6-compatible
distro (centos) fails:

r_1024_small_bg: ext2 1024 blocksize with small block groups: failed
r_ext4_small_bg: ext4 1024 blocksize with small block groups: failed

dunno whether this is known issue... will bisect help?

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

--eVzOFob/8UvintSX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAlH2Kk0ACgkQ3xdJJrLygV7p2ACgjKZXvNnHDgBfcXYpDi7H3AHA
ITMAoIBFPMBguzVwJ23lXwunaIYjz+zD
=Gh5C
-----END PGP SIGNATURE-----

--eVzOFob/8UvintSX--
