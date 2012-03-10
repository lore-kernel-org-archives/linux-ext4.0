From: Sami Liedes <sami.liedes@iki.fi>
Subject: [PATCH 3/5] libext2fs: Document EXT2_FLAG_64BITS in ext2fs_open2().
Date: Sat, 10 Mar 2012 23:36:59 +0200
Message-ID: <20120310213659.GN6961@sli.dy.fi>
References: <20120310213321.GK6961@sli.dy.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="eHmdSDY+kY2au76U"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-1.hut.fi ([130.233.228.91]:37313 "EHLO smtp-1.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486Ab2CJVnR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 10 Mar 2012 16:43:17 -0500
Received: from localhost (katosiko.hut.fi [130.233.228.115])
	by smtp-1.hut.fi (8.13.6/8.12.10) with ESMTP id q2ALhFd8019558
	for <linux-ext4@vger.kernel.org>; Sat, 10 Mar 2012 23:43:15 +0200
Received: from smtp-1.hut.fi ([130.233.228.91])
 by localhost (katosiko.hut.fi [130.233.228.115]) (amavisd-new, port 10024)
 with LMTP id 05012-914 for <linux-ext4@vger.kernel.org>;
 Sat, 10 Mar 2012 23:43:15 +0200 (EET)
Received: from kosh.localdomain (kosh.hut.fi [130.233.228.12])
	by smtp-1.hut.fi (8.13.6/8.12.10) with ESMTP id q2ALaxhH019343
	for <linux-ext4@vger.kernel.org>; Sat, 10 Mar 2012 23:36:59 +0200
Content-Disposition: inline
In-Reply-To: <20120310213321.GK6961@sli.dy.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--eHmdSDY+kY2au76U
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom 5c7302de65d689ad84427649aab4d361b21270df Mon Sep 17 00:00:00 2001
=46rom: Sami Liedes <sami.liedes@iki.fi>
Date: Sat, 10 Mar 2012 22:25:55 +0200
Subject: [PATCH] libext2fs: Document EXT2_FLAG_64BITS in ext2fs_open2().

Signed-off-by: Sami Liedes <sami.liedes@iki.fi>

diff --git a/lib/ext2fs/openfs.c b/lib/ext2fs/openfs.c
index 32e068c..55082c4 100644
--- a/lib/ext2fs/openfs.c
+++ b/lib/ext2fs/openfs.c
@@ -87,6 +87,7 @@ errcode_t ext2fs_open(const char *name, int flags, int su=
perblock,
  *				features aren't supported.
  *	EXT2_FLAG_JOURNAL_DEV_OK - Open an ext3 journal device
  *	EXT2_FLAG_SKIP_MMP - Open without multi-mount protection check.
+ *	EXT2_FLAG_64BITS - Allow 64-bit bitfields (needed for large filesystems=
).
  */
 errcode_t ext2fs_open2(const char *name, const char *io_options,
 		       int flags, int superblock,

--eHmdSDY+kY2au76U
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJPW8l7AAoJEKLT589SE0a01bgP/iZR0NoD74w/RFwS9BTnn9gQ
GEOmK87fMf5mGOdtt0W6tAhR5sa5Y23Vsu/SeWcuwzVUmNJUnXMau3q0n1ThuELe
LOL41CaFu/O1ONBwjSJOnl1m7CdSINCvc4IEZ6abJrv4GhVhIabi2iOYk9ZDSGZt
bVSD+XC1Tbopozmun5KU9k78yfUil8GM+wWHfSKZ8gMt0eO5CNvfGI8eWyJV+8CK
cUS9Jv2O7Wddib/AaZdYLfv2aRJdRi99oJ2tnGJF6TG4lvIqqES7jYo9dg9sf5FU
rCG/DSix4eWWYfMS1dR0gxYvYYGKwp9pMY8GDdkOhPmczgteUgI6nZxBDvrEWJus
LD0UYjyX9uhlNijXxsBk00TvMYcQlJme3XBA3Sc0YAdG2wlSU4+WzWWFCF1sdsQ8
8qeGb4eq8WYDBrlx8VVZ92yV2nET4rJ+uJnxXv7GeAgOZiYCvHZl2WlH8AlvH0oU
qgCXdJ2Qk6u4PWaC7qQTU2PUP1It1Vic9Ht/uyGnlulrr2ApXiK1XH99IbvkrgFi
5MHhJvFi6Mtwi6X6JEvBnfuN/ienVHrASGLi4Lprv1OX8GGxB+6JrDAUfOTH01KI
FcgxQR+wzMCAZYjKQIe4MSYj9wOTN37pDQhVuV/TUMB3c/q3O2U+3+cmmAFpLWNu
05slWPp8giUW3pVGn82y
=atWj
-----END PGP SIGNATURE-----

--eHmdSDY+kY2au76U--
