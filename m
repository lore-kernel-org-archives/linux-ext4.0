From: Peng Tao <bergwolf@gmail.com>
Subject: [PATCH][e2fsprogs]tune2fs: refuse to unmark flex_bg via clear_ok_features
Date: Fri, 21 Nov 2008 21:36:34 +0800
Message-ID: <4926B962.8010306@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA12C96A7A5975A70D4E65548"
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.187]:46785 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbYKUNgt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Nov 2008 08:36:49 -0500
Received: by ti-out-0910.google.com with SMTP id b6so635691tic.23
        for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2008 05:36:47 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA12C96A7A5975A70D4E65548
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

IIUC, clear_ok_features is the gateway for all features that can be
cleared by tune2fs. So refuse to unmark flex_bg via clear_ok_features
instead of dealing with it alone. Having flex_bg in clear_ok_features is
quite misleading.

Signed-off-by: Peng Tao <bergwolf@gmail.com>

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index e72518a..c1876d1 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -136,8 +136,7 @@ static __u32 clear_ok_features[3] =3D {
 		EXT2_FEATURE_COMPAT_RESIZE_INODE |
 		EXT2_FEATURE_COMPAT_DIR_INDEX,
 	/* Incompat */
-	EXT2_FEATURE_INCOMPAT_FILETYPE |
-		EXT4_FEATURE_INCOMPAT_FLEX_BG,
+	EXT2_FEATURE_INCOMPAT_FILETYPE,
 	/* R/O compat */
 	EXT2_FEATURE_RO_COMPAT_LARGE_FILE |
 		EXT4_FEATURE_RO_COMPAT_HUGE_FILE|
@@ -407,15 +406,6 @@ static void update_feature_set(ext2_filsys fs, char
*features)
 			uuid_generate((unsigned char *) sb->s_hash_seed);
 	}

-	if (FEATURE_OFF(E2P_FEATURE_INCOMPAT, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {=

-		if (ext2fs_check_desc(fs)) {
-			fputs(_("Clearing the flex_bg flag would "
-				"cause the the filesystem to be\n"
-				"inconsistent.\n"), stderr);
-			exit(1);
-		}
-	}
-
 	if (FEATURE_OFF(E2P_FEATURE_RO_INCOMPAT,
 			    EXT4_FEATURE_RO_COMPAT_HUGE_FILE)) {
 		if ((mount_flags & EXT2_MF_MOUNTED) &&

--=20
Cheers,

Bergwolf

Here lieth one whose name was writ on water.


--------------enigA12C96A7A5975A70D4E65548
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkkmuWcACgkQEyny3P47hFF0ZwCeKi3Jl9sxMmo/1iYgY04czQql
uFIAmgNIINDMULrL3vysbr/sEuNi8FyI
=Qceo
-----END PGP SIGNATURE-----

--------------enigA12C96A7A5975A70D4E65548--
