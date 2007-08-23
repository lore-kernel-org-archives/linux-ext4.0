From: Coly Li <coyli@suse.de>
Subject: [PATCH 1/5] debugfs: remove masix support
Date: Thu, 23 Aug 2007 15:08:37 +0800
Message-ID: <46CD3275.3000603@suse.de>
Reply-To: coyli@suse.de
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig73EF2A823871892207818707"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:41063 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbXHWHI3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Aug 2007 03:08:29 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig73EF2A823871892207818707
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

This patch remove masix supporting from debugfs.

Singed-off-by: Coly Li <coyli@suse.de>
--
diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
index 190c4b7..37dbeba 100644
--- a/debugfs/debugfs.c
+++ b/debugfs/debugfs.c
@@ -569,10 +569,6 @@ void internal_dump_inode(FILE *out, const char *pref=
ix,
 		frag =3D inode->osd2.hurd2.h_i_frag;
 		fsize =3D inode->osd2.hurd2.h_i_fsize;
 		break;
-	    case EXT2_OS_MASIX:
-		frag =3D inode->osd2.masix2.m_i_frag;
-		fsize =3D inode->osd2.masix2.m_i_fsize;
-		break;
 	    default:
 		frag =3D fsize =3D 0;
 	}
@@ -899,10 +895,6 @@ void do_modify_inode(int argc, char *argv[])
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



--------------enig73EF2A823871892207818707
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGzTJ1uTp8cyZ5lTERAidZAJ0eV1EXvKVY8I0t+Z7uzrCPDfwd1gCfeUPP
khjRztHqTEYcKF80aTFU9I4=
=usfg
-----END PGP SIGNATURE-----

--------------enig73EF2A823871892207818707--
