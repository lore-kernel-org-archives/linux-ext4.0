From: Coly Li <coyli@suse.de>
Subject: [PATCH 5/5] mke2fs: remove masix support
Date: Thu, 23 Aug 2007 15:09:03 +0800
Message-ID: <46CD328F.2000909@suse.de>
Reply-To: coyli@suse.de
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig70118D557C6A573C5388C580"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:41084 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbXHWHIo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Aug 2007 03:08:44 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig70118D557C6A573C5388C580
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

This patch remove masix support from mke2fs.

Signed-off-by: Coly Li <coyli@suse.de>

diff --git a/misc/mke2fs.c b/misc/mke2fs.c
index 4a6cace..e317d48 100644
--- a/misc/mke2fs.c
+++ b/misc/mke2fs.c
@@ -740,8 +740,6 @@ static int set_os(struct ext2_super_block *sb, char *=
os)
 		sb->s_creator_os =3D EXT2_OS_LINUX;
 	else if (strcasecmp(os, "GNU") =3D=3D 0 || strcasecmp(os, "hurd") =3D=3D=
 0)
 		sb->s_creator_os =3D EXT2_OS_HURD;
-	else if (strcasecmp(os, "masix") =3D=3D 0)
-		sb->s_creator_os =3D EXT2_OS_MASIX;
 	else if (strcasecmp(os, "freebsd") =3D=3D 0)
 		sb->s_creator_os =3D EXT2_OS_FREEBSD;
 	else if (strcasecmp(os, "lites") =3D=3D 0)



--=20
Coly Li
SuSE PRC Labs



--------------enig70118D557C6A573C5388C580
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGzTKPuTp8cyZ5lTERAtwtAJ4tDsa6UP7c71SrVN33OTKNLXFJXACeI6YC
z+06yKDtdEQznZ6lzu43YSg=
=B8jt
-----END PGP SIGNATURE-----

--------------enig70118D557C6A573C5388C580--
