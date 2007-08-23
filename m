From: Coly Li <coyli@suse.de>
Subject: [PATCH 2/5] document: remove masix from data structure
Date: Thu, 23 Aug 2007 15:08:35 +0800
Message-ID: <46CD3273.9080008@suse.de>
Reply-To: coyli@suse.de
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8B8A6475E56BDD02C0E93089"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:41036 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbXHWHIO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 23 Aug 2007 03:08:14 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8B8A6475E56BDD02C0E93089
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

This patch remove masix union from data structure in ext2ed-design.sgml.

Signed-off-by: Coly Li <coyli@suse.de>

diff --git a/ext2ed/doc/ext2ed-design.sgml b/ext2ed/doc/ext2ed-design.sgm=
l
index 3eaca69..ad2df96 100644
--- a/ext2ed/doc/ext2ed-design.sgml
+++ b/ext2ed/doc/ext2ed-design.sgml
@@ -2722,9 +2722,6 @@ struct ext2_inode {
 		struct {
 			__u32  h_i_translator;
 		} hurd1;
-		struct {
-			__u32  m_i_reserved1;
-		} masix1;
 	} osd1;				/* OS dependent 1 */
 	__u32	i_block[EXT2_N_BLOCKS];	/* Pointers to blocks */
 	__u32	i_version;		/* File version (for NFS) */
@@ -2746,12 +2743,6 @@ struct ext2_inode {
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
 </ProgramListing>




--=20
Coly Li
SuSE PRC Labs



--------------enig8B8A6475E56BDD02C0E93089
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGzTJzuTp8cyZ5lTERAg2TAKCvtg5xNiEyFbZbX0ccGsyCgyauIACfQRQN
BNnpylQWWnOIVYQ7rVHx0DI=
=uajA
-----END PGP SIGNATURE-----

--------------enig8B8A6475E56BDD02C0E93089--
