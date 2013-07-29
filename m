From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: e2fsprogs - possible regression between 1.42.7 and 1.42.8
Date: Mon, 29 Jul 2013 18:00:05 +0200
Message-ID: <20130729160005.GA4676@nik-comp.linuxbox.cz>
References: <20130729083941.GG28871@pcnci.linuxbox.cz>
 <20130729144033.GA11816@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Cc: linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gwu.lbox.cz ([62.245.111.132]:55122 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756370Ab3G2P7U (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Jul 2013 11:59:20 -0400
Content-Disposition: inline
In-Reply-To: <20130729144033.GA11816@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Mon, Jul 29, 2013 at 10:40:33AM -0400, Theodore Ts'o wrote:
> What platform are you running this on?  X86?  I generally do a full
> regression test run before I do an e2fsprogs release, so it may very
> well be something which might be platform or compiler specific.

it's x86_64 running kernel 3.0.88-rc1. I also tried x86_64 centos 5, and
different test fails (I was successfully compiling previous releases on tho=
se
boxes).

>=20
> Can you send me the r_1024_small_bg.failed and r_ext4_small_bg.failed
> files?
sure, although both those files are empty.. I've uploaded test logs (includ=
ing
rhel5 failed one) here:

http://nik.lbox.cz/download/e2fsprogs-tests/

please let me know if I could provide more information

BR

nik



>=20
> Thanks,
>=20
> 						- Ted
>=20

--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28. rijna 168, 709 00 Ostrava

tel.:   +420 591 166 214
fax:    +420 596 621 273
mobil:  +420 777 093 799

www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAlH2kYUACgkQ3xdJJrLygV6RtwCgi6ls8GIZ0yzp/FNzbyE9+SlL
gdcAoN4yWJg0hrnWZxPMjuMIKUwCAcEH
=Xj7u
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
