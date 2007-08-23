From: Coly Li <coyli@suse.de>
Subject: [PATCH 3/5] libext2fs: remove masix support
Date: Thu, 23 Aug 2007 15:08:30 +0800
Message-ID: <46CD326E.9020801@suse.de>
Reply-To: coyli@suse.de
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7C5A45810F494707EA96F865"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:41035 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbXHWHIO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Aug 2007 03:08:14 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7C5A45810F494707EA96F865
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

This patch remove masix support from lib/ext2fs.

Signed-off-by: Coly Li <coyli@suse.de>

diff --git a/lib/ext2fs/ext2_fs.h b/lib/ext2fs/ext2_fs.h
index a316665..3585baf 100644
--- a/lib/ext2fs/ext2_fs.h
+++ b/lib/ext2fs/ext2_fs.h
@@ -315,9 +315,6 @@ struct ext2_inode {
 		struct {
 			__u32  h_i_translator;
 		} hurd1;
-		struct {
-			__u32  m_i_reserved1;
-		} masix1;
 	} osd1;				/* OS dependent 1 */
 	__u32	i_block[EXT2_N_BLOCKS];/* Pointers to blocks */
 	__u32	i_generation;	/* File version (for NFS) */
@@ -340,12 +337,6 @@ struct ext2_inode {
 			__u16	h_i_gid_high;
 			__u32	h_i_author;
 		} hurd2;
-		struct {
-			__u8	m_i_frag;	/* Fragment number */
-			__u8	m_i_fsize;	/* Fragment size */
-			__u16	m_pad1;
-			__u32	m_i_reserved2[2];
-		} masix2;
 	} osd2;				/* OS dependent 2 */
 };

@@ -371,9 +362,6 @@ struct ext2_inode_large {
 		struct {
 			__u32  h_i_translator;
 		} hurd1;
-		struct {
-			__u32  m_i_reserved1;
-		} masix1;
 	} osd1;				/* OS dependent 1 */
 	__u32	i_block[EXT2_N_BLOCKS];/* Pointers to blocks */
 	__u32	i_generation;	/* File version (for NFS) */
@@ -396,12 +384,6 @@ struct ext2_inode_large {
 			__u16	h_i_gid_high;
 			__u32	h_i_author;
 		} hurd2;
-		struct {
-			__u8	m_i_frag;	/* Fragment number */
-			__u8	m_i_fsize;	/* Fragment size */
-			__u16	m_pad1;
-			__u32	m_i_reserved2[2];
-		} masix2;
 	} osd2;				/* OS dependent 2 */
 	__u16	i_extra_isize;
 	__u16	i_pad1;
@@ -437,17 +419,6 @@ struct ext2_inode_large {
 #define inode_uid(inode)	((inode).i_uid | (inode).i_uid_high << 16)
 #define inode_gid(inode)	((inode).i_gid | (inode).i_gid_high << 16)

-#else
-#if defined(__masix__)
-
-#define i_reserved1	osd1.masix1.m_i_reserved1
-#define i_frag		osd2.masix2.m_i_frag
-#define i_fsize		osd2.masix2.m_i_fsize
-#define i_reserved2	osd2.masix2.m_i_reserved2
-#define inode_uid(inode)	((inode).i_uid)
-#define inode_gid(inode)	((inode).i_gid)
-
-#endif  /* __masix__ */
 #endif  /* __GNU__ */
 #endif	/* defined(__KERNEL__) || defined(__linux__) */

@@ -585,7 +556,7 @@ struct ext2_super_block {
  */
 #define EXT2_OS_LINUX		0
 #define EXT2_OS_HURD		1
-#define EXT2_OS_MASIX		2
+#define EXT2_OBSO_OS_MASIX	2
 #define EXT2_OS_FREEBSD		3
 #define EXT2_OS_LITES		4

diff --git a/lib/ext2fs/swapfs.c b/lib/ext2fs/swapfs.c
index bd0844d..040e3dd 100644
--- a/lib/ext2fs/swapfs.c
+++ b/lib/ext2fs/swapfs.c
@@ -198,16 +198,7 @@ void ext2fs_swap_inode_full(ext2_filsys fs, struct e=
xt2_inode_large *t,
 		t->osd2.hurd2.h_i_author =3D
 		  ext2fs_swab32 (f->osd2.hurd2.h_i_author);
 		break;
-	case EXT2_OS_MASIX:
-		t->osd1.masix1.m_i_reserved1 =3D
-			ext2fs_swab32(f->osd1.masix1.m_i_reserved1);
-		t->osd2.masix2.m_i_frag =3D f->osd2.masix2.m_i_frag;
-		t->osd2.masix2.m_i_fsize =3D f->osd2.masix2.m_i_fsize;
-		t->osd2.masix2.m_pad1 =3D ext2fs_swab16(f->osd2.masix2.m_pad1);
-		t->osd2.masix2.m_i_reserved2[0] =3D
-			ext2fs_swab32(f->osd2.masix2.m_i_reserved2[0]);
-		t->osd2.masix2.m_i_reserved2[1] =3D
-			ext2fs_swab32(f->osd2.masix2.m_i_reserved2[1]);
+	default:
 		break;
 	}




--=20
Coly Li
SuSE PRC Labs



--------------enig7C5A45810F494707EA96F865
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGzTJuuTp8cyZ5lTERAnfoAKCHM3H5/d1wGd6fQgaZzKUIFpmOVwCeP2U9
vcLsDOr1PuckIRj9bIN4+TY=
=U2XJ
-----END PGP SIGNATURE-----

--------------enig7C5A45810F494707EA96F865--
