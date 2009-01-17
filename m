From: Malte =?UTF-8?B?U2NocsO2ZGVy?= <maltesch@gmx.de>
Subject: ext4-stable build failure (Re: Ext4 tree backports for 2.6.27.10
 and 2.6.28)
Date: Sat, 17 Jan 2009 23:16:51 +0100
Message-ID: <20090117231651.78b2cce5@highlander.home.lan>
References: <E1LOG9D-0006h4-7R@closure.thunk.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/fbmCJe6QILaJEzIoBW9xfC1";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54395 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758154AbZAQWQ5 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 17 Jan 2009 17:16:57 -0500
In-Reply-To: <E1LOG9D-0006h4-7R@closure.thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

--Sig_/fbmCJe6QILaJEzIoBW9xfC1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello,

On Sat, 17 Jan 2009 13:43:55 -0500
"Theodore Ts'o" <tytso@mit.edu> wrote:

>=20
> I've created a couple of ext4 backport branches which have been uploaded
> to the ext4 git tree:
>=20
>    git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git=20
>    http://git.kernel.org/?p=3Dlinux/kernel/git/tytso/ext4.git
>=20

kernel 2.6.28 with ext4-stable fails to build for SMP on AMD64.

Building modules, stage 2.
MODPOST 905 modules
ERROR: "inode_lock" [fs/ext4/ext4.ko] undefined!

I had to revert 5cb8613e44b6e6c77dcf231d691b96c91a5adeab (ext4: Add a
delayed allocation debugging ioctl), after that it works.

Regards
Malte Schr=C3=B6der

--Sig_/fbmCJe6QILaJEzIoBW9xfC1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklyWNMACgkQ4q3E2oMjYtUxlACgzjK+7pVjiEI6Ju3zSHE8r1/t
kRcAn3JrdpLOvDBpQGtlq4XbcCGT01DI
=mfUA
-----END PGP SIGNATURE-----

--Sig_/fbmCJe6QILaJEzIoBW9xfC1--
