From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: info about filesystem errors in /sys/fs/ext4/... ?
Date: Mon, 5 May 2014 13:14:20 +0200
Message-ID: <20140505111420.GJ11499@pcnci.linuxbox.cz>
References: <20140505070823.GM3017@pcnci.linuxbox.cz>
 <alpine.LFD.2.00.1405051253400.2223@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SCOJXUq1iwCn05li"
Cc: linux-ext4@vger.kernel.org
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gwu.lbox.cz ([62.245.111.132]:59163 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222AbaEELO1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 May 2014 07:14:27 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1405051253400.2223@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--SCOJXUq1iwCn05li
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello Luk=C3=A1=C5=A1,

> Currently I do not think there is a way to check whether mounted
> file system contains errors (EXT2_ERROR_FS flag is set in super
> block).
>=20
> You either have to check the logs, or run fsck before mounting the
> file system.
>=20
> It really seems like a optimal thing to provide a way to inform user
> space about this without the need to parse the log. I think that
> sysfs is a perfect place for this.
>=20
> However we might to go a step further, because I do not
> really like the idea of allowing to mount the file system with
> errors by default. It does not really make sense to me and I wonder
> whether someone actually intend to do it this way.
>=20
> What about having this scenario respect "errors=3D" setting ? Of
> course it might not make sense to panic when mounting file system
> with errors with "errors=3Dpanic" option, we can just fail the mount.
>=20
> Will that help your case ?

Yes for some cases, no for others :)  For example I do not want server to
fail booting if it could otherwise start (even though it might need some
intervention, at least running fsck). Giving simple way (like mentioned sys=
fs
access) would make monitoring such issues much simpler.

Of course for some cases, it's for sure safer to disallow mounting rather
then risking further data corruption...

I'm not sure how big is chance that mounting filesystem with errors can
cause more errors, I guess it depends on the nature of the problem..

cheers!

nik


>=20
> Thanks!
> -Lukas
>=20

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

--SCOJXUq1iwCn05li
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAlNncowACgkQ3xdJJrLygV5guACbBvow9k88MvoLTJCqwHYEKW9F
MBkAoLVcULmmpfRSVc4LRgmFoqxKiMu/
=A0Nq
-----END PGP SIGNATURE-----

--SCOJXUq1iwCn05li--
