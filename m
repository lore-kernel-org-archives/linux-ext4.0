From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: running mkfs.ext4 causes very high system load
Date: Thu, 22 Mar 2012 15:05:47 +0100
Message-ID: <20120322140547.GA10657@pcnci2.linuxbox.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Cc: nikola.ciprich@linuxbox.cz, Radovan Mzik <radovan.mzik@linuxbox.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gwu.lbox.cz ([62.245.111.132]:55729 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458Ab2CVOV0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 22 Mar 2012 10:21:26 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

we've hit strange problem on one of our servers today.
We needed to add new logical volume, so created 320GB LV,
and tried to create ext4 using:

$ mkfs.ext4 /dev/vg/home2

the problem is, it progressed very slow, and seemed to block all
other applications currently trying to access disks, thus causing system lo=
ad
jumping much over 150.

The system itself is not idle, but it's not too loaded too (loadavg is usua=
lly
<1), it's x86_64 centos5 running 2.6.32.59 with 4GB RAM and common SATA dri=
ves.

I tried running mkfs.ext4 via ionice, but it didn't get much better.

we're using e2fsprogs-1.41.14

Is this common that mkfs can load system that much? Is it possible to
mitigate this negative effect somehow?

(I think that using 3.3 kernel might improve disk load handling, but
I need to stick to 2.6.32 for some more time)

thanks a lot in advance!

nik


--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 01 Ostrava

tel.:   +420 596 603 142
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAk9rMbsACgkQ3xdJJrLygV5B0QCghR87tgCVxfqiTiMCas/RKM+/
ibEAoNg12V/UVXehK2tn8TfzY7CGWupT
=V0aq
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
