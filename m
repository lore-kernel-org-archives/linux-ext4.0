From: Coly Li <coyli@suse.de>
Subject: [PATCH 4/5] e2fsck: remove masix support
Date: Thu, 23 Aug 2007 15:08:18 +0800
Message-ID: <46CD3262.2040104@suse.de>
Reply-To: coyli@suse.de
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA47E2CBFEA5B07681C540C2E"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:41034 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbXHWHIO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Aug 2007 03:08:14 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA47E2CBFEA5B07681C540C2E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

This patch remove masix support from e2fsck.

Signed-off-by: Coly Li <coyli@suse.de>

diff --git a/e2fsck/pass1.c b/e2fsck/pass1.c
index ceb9c7f..d072e73 100644
--- a/e2fsck/pass1.c
+++ b/e2fsck/pass1.c
@@ -834,10 +834,6 @@ void e2fsck_pass1(e2fsck_t ctx)
 			frag =3D inode->osd2.hurd2.h_i_frag;
 			fsize =3D inode->osd2.hurd2.h_i_fsize;
 			break;
-		    case EXT2_OS_MASIX:
-			frag =3D inode->osd2.masix2.m_i_frag;
-			fsize =3D inode->osd2.masix2.m_i_fsize;
-			break;
 		    default:
 			frag =3D fsize =3D 0;
 		}
diff --git a/e2fsck/pass2.c b/e2fsck/pass2.c
index 7f7635f..b6e496f 100644
--- a/e2fsck/pass2.c
+++ b/e2fsck/pass2.c
@@ -1253,10 +1253,6 @@ extern int e2fsck_process_bad_inode(e2fsck_t ctx, =
ext2_ino_t dir,
 		frag =3D &inode.osd2.hurd2.h_i_frag;
 		fsize =3D &inode.osd2.hurd2.h_i_fsize;
 		break;
-	    case EXT2_OS_MASIX:
-		frag =3D &inode.osd2.masix2.m_i_frag;
-		fsize =3D &inode.osd2.masix2.m_i_fsize;
-		break;
 	    default:
 		frag =3D fsize =3D 0;
 	}



--=20
Coly Li
SuSE PRC Labs



--------------enigA47E2CBFEA5B07681C540C2E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGzTJmuTp8cyZ5lTERAvW1AJ9Vlow/1Qa5zSrcdDSUR0bfqQtrkwCgpiIJ
X+77sokWyOa514WaP/Kfsqs=
=c5Lc
-----END PGP SIGNATURE-----

--------------enigA47E2CBFEA5B07681C540C2E--
