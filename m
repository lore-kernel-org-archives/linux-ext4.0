From: Peng Tao <bergwolf@gmail.com>
Subject: [PATCH 2/3][e2fsprogs] tune2fs: Don't allow tune2fs -I if flex_bg
 on
Date: Wed, 10 Dec 2008 16:05:23 +0800
Message-ID: <493F7843.5030808@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDFA78ADC5B5FC8AFE17896E9"
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.186]:58206 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372AbYLJIF3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Dec 2008 03:05:29 -0500
Received: by ti-out-0910.google.com with SMTP id b6so216037tic.23
        for <linux-ext4@vger.kernel.org>; Wed, 10 Dec 2008 00:05:28 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDFA78ADC5B5FC8AFE17896E9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

    tune2fs: don't resize inode if flex_bg is on.

    Signed-off-by: Peng Tao <bergwolf@gmail.com>

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 8bb6fd2..453a529 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -1604,6 +1604,13 @@ retry_open:
 				"unmounted.\n"), stderr);
 			exit(1);
 		}
+		if (fs->super->s_feature_incompat &
+		    EXT4_FEATURE_INCOMPAT_FLEX_BG) {
+			fputs(_("Filesystem has flex_bg feature. Resizing "
+				"inode will mess up inode table. Abort.\n"),
+				stderr);
+			exit(1);
+		}
 		/*
 		 * We want to update group descriptor also
 		 * with the new free inode count


--------------enigDFA78ADC5B5FC8AFE17896E9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkk/eEMACgkQEyny3P47hFErZwCdGXjRKRI+T/X48dJ6JrwilDtl
KicAn2gDdbpLpccJbYYsGkDM4P3DaDiY
=nuOr
-----END PGP SIGNATURE-----

--------------enigDFA78ADC5B5FC8AFE17896E9--
