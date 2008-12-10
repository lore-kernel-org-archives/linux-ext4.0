From: Peng Tao <bergwolf@gmail.com>
Subject: [PATCH 1/3][e2fsprogs] tune2fs: don't allow -O flex_bg because it's
 not supported
Date: Wed, 10 Dec 2008 16:05:06 +0800
Message-ID: <493F7832.6000503@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE73CBDF57E2045C36AB47900"
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.186]:58206 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbYLJIFO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Dec 2008 03:05:14 -0500
Received: by ti-out-0910.google.com with SMTP id b6so216037tic.23
        for <linux-ext4@vger.kernel.org>; Wed, 10 Dec 2008 00:05:12 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE73CBDF57E2045C36AB47900
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

The following three patches are a simple solution for tune2fs bugs
against flex_bg and resizing inode.
----------------

    Don't allow add tune2fs -O flex_bg because it's not support.

    Signed-off-by: Peng Tao <bergwolf@gmail.com>

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index a1fa57b..8bb6fd2 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -117,8 +117,7 @@ static __u32 ok_features[3] =3D {
 		EXT2_FEATURE_COMPAT_DIR_INDEX,
 	/* Incompat */
 	EXT2_FEATURE_INCOMPAT_FILETYPE |
-		EXT3_FEATURE_INCOMPAT_EXTENTS |
-		EXT4_FEATURE_INCOMPAT_FLEX_BG,
+		EXT3_FEATURE_INCOMPAT_EXTENTS,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|


--------------enigE73CBDF57E2045C36AB47900
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkk/eDIACgkQEyny3P47hFFbbwCeI5DJg9ukGEVwxtBF4WRJEaeD
p1YAnRuNQE5RVj5NxSNSZC/N8hqiCrDc
=SBit
-----END PGP SIGNATURE-----

--------------enigE73CBDF57E2045C36AB47900--
