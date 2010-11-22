From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: Apply 'ext4: fix NULL pointer dereference in print_daily_error_info()'
 to 2.6.36.y?
Date: Mon, 22 Nov 2010 21:45:00 +0100
Message-ID: <4CEAD64C.5090600@archlinux.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------enig28CE0DF67F32AF9A12B8AC87"
Cc: Theodore Ts'o <tytso@mit.edu>,
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
	Greg KH <greg@kroah.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, richard@netwichtig.de
To: stable@kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig28CE0DF67F32AF9A12B8AC87
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hello,

we discovered this kernel panic [1] in 2.6.36. Apparently, commit
a1c6c5698d53db4c47a25c3a8d11731a4d7b8370 was supposed to fix it, but
never made it to 2.6.36(.1). Can this please be queued up for the next
stable kernel? This is a pretty serious issue and can reproducibly crash
the kernel.

This was mentioned at [2], but nothing more happened. Added some ext4
guys to CC.

Regards
Thomas

[1] http://richard.qasl.de/panic.JPG
[2] http://lkml.org/lkml/2010/11/20/64


--------------enig28CE0DF67F32AF9A12B8AC87
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEAREIAAYFAkzq1kwACgkQEda5KzHP/VAiOQCZAZKWnXKGu+4+xvMHEpgtqEsq
vLgAmQFVjzMiwF+c3yzW6GWnAi21LwnU
=cs+e
-----END PGP SIGNATURE-----

--------------enig28CE0DF67F32AF9A12B8AC87--
