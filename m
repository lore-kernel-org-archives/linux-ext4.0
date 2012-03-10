From: Sami Liedes <sami.liedes@iki.fi>
Subject: Re: [PATCH 2/5] resize2fs: Use EXT2_FLAG_64BITS.
Date: Sat, 10 Mar 2012 23:35:35 +0200
Message-ID: <20120310213535.GM6961@sli.dy.fi>
References: <20120310213321.GK6961@sli.dy.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="WU3I8Do+sziGY3UL"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-2.hut.fi ([130.233.228.92]:38970 "EHLO smtp-2.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377Ab2CJVzC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 10 Mar 2012 16:55:02 -0500
Received: from localhost (katosiko.hut.fi [130.233.228.115])
	by smtp-2.hut.fi (8.13.6/8.12.10) with ESMTP id q2ALZcUR011144
	for <linux-ext4@vger.kernel.org>; Sat, 10 Mar 2012 23:35:38 +0200
Received: from smtp-2.hut.fi ([130.233.228.92])
 by localhost (katosiko.hut.fi [130.233.228.115]) (amavisd-new, port 10024)
 with LMTP id 05037-879 for <linux-ext4@vger.kernel.org>;
 Sat, 10 Mar 2012 23:35:37 +0200 (EET)
Received: from kosh.localdomain (kosh.hut.fi [130.233.228.12])
	by smtp-2.hut.fi (8.13.6/8.12.10) with ESMTP id q2ALZZlt011136
	for <linux-ext4@vger.kernel.org>; Sat, 10 Mar 2012 23:35:35 +0200
Content-Disposition: inline
In-Reply-To: <20120310213321.GK6961@sli.dy.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--WU3I8Do+sziGY3UL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom 975ea6001ab14b02b1197588bbe40ea133e17568 Mon Sep 17 00:00:00 2001
=46rom: Sami Liedes <sami.liedes@iki.fi>
Date: Sun, 26 Feb 2012 21:54:23 +0200
Subject: [PATCH] resize2fs: Use EXT2_FLAG_64BITS.

By passing EXT2_FLAG_64BITS to ext2fs_open2() we can avoid some
unnecessary redirection in critical paths. While resize2fs does not
currently otherwise support so big filesystems that this would matter,
passing this flag is entirely harmless and only tells libext2fs that
the caller has been recompiled against current headers.

With this change the CPU time needed to shrink a 100G filesystem drops
by 20%.

Signed-off-by: Sami Liedes <sami.liedes@iki.fi>

diff --git a/resize/main.c b/resize/main.c
index ffefe01..e6604f2 100644
--- a/resize/main.c
+++ b/resize/main.c
@@ -294,6 +294,9 @@ int main (int argc, char ** argv)
=20
 	if (!(mount_flags & EXT2_MF_MOUNTED))
 		io_flags =3D EXT2_FLAG_RW | EXT2_FLAG_EXCLUSIVE;
+
+	io_flags |=3D EXT2_FLAG_64BITS;
+
 	retval =3D ext2fs_open2(device_name, io_options, io_flags,
 			      0, 0, io_ptr, &fs);
 	if (retval) {

--WU3I8Do+sziGY3UL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJPW8knAAoJEKLT589SE0a0xoYQALIM0WiRswja+Nttha5bOQpl
mBeeG/TmFEYP8g+W19tGL9etAfgF7CCIqUbkC/Rn3SVthYFdBcuTJgqoeoirC4j0
cZYLzlkTEZmOggPS6jehq86Cg0LxCXPQBSR/Q7B3pCSRBrrUe3CALAMUGsfKjXqq
kLfw5q6OXBjcbPcPAMhgU4abkkN1PO4PjkeZhFnRNaR1pNmat0zdrpWZdBk7+ghC
/iL9YdduIrC2xQuG2vaBlu794sW18jer9nTprROCA3o7xrDRn3BmD369CKa1hibS
tz4RzqkVKBBUGSYPiPm3CTmLhtxB7v+hJuoHp/4s80T7IjxRGktraPUidpzInwlu
rXCvqJzaLjlhe90McjJvXeQ8s5UUyVHLpTi+0QVXMjb+Pas1FfEk8i/pckYih3uq
rWG8neK2OuKUcmABOkQAZGCKtEgd/iPwqctOL+Tmoo4ScHFkoFEzyuclmQol9Mmd
426IzTSYcm3shAD5CmRSGXr0R5ETJC3IspLYSDr/cCI64e3nRWGfA2bXkypyYxY4
1g7tlKiGYgTqtSlro4Z+SOrKfDu15lnevRW/paILLA1kVm5liasiwyWM/A354OX3
qsZvKrPl8j+mJlAE3aJ2TuwBd4l98KOCBL+1OK5wyjk8+MF8FJ/qWSf5LpY9LTNf
GF1ANlO0sLd8LqUvI0Wk
=pOTy
-----END PGP SIGNATURE-----

--WU3I8Do+sziGY3UL--
