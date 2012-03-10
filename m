From: Sami Liedes <sami.liedes@iki.fi>
Subject: Re: [PATCH 1/5] libext2fs: Move a modulo operation out of a hot loop.
Date: Sat, 10 Mar 2012 23:34:56 +0200
Message-ID: <20120310213456.GL6961@sli.dy.fi>
References: <20120310213321.GK6961@sli.dy.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+2GlJm56SCtLHYlr"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-4.hut.fi ([130.233.228.94]:44270 "EHLO smtp-4.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377Ab2CJVzb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 10 Mar 2012 16:55:31 -0500
Received: from localhost (katosiko.hut.fi [130.233.228.115])
	by smtp-4.hut.fi (8.13.6/8.12.10) with ESMTP id q2ALYw4M004411
	for <linux-ext4@vger.kernel.org>; Sat, 10 Mar 2012 23:34:58 +0200
Received: from smtp-4.hut.fi ([130.233.228.94])
 by localhost (katosiko.hut.fi [130.233.228.115]) (amavisd-new, port 10024)
 with LMTP id 05077-913 for <linux-ext4@vger.kernel.org>;
 Sat, 10 Mar 2012 23:34:58 +0200 (EET)
Received: from kosh.localdomain (kosh.hut.fi [130.233.228.12])
	by smtp-4.hut.fi (8.13.6/8.12.10) with ESMTP id q2ALYvgX004407
	for <linux-ext4@vger.kernel.org>; Sat, 10 Mar 2012 23:34:57 +0200
Content-Disposition: inline
In-Reply-To: <20120310213321.GK6961@sli.dy.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--+2GlJm56SCtLHYlr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom 8d712d4e49cdc8a0b82f27b5b62a7691fafcacbf Mon Sep 17 00:00:00 2001
=46rom: Sami Liedes <sami.liedes@iki.fi>
Date: Sat, 10 Mar 2012 22:13:12 +0200
Subject: [PATCH] libext2fs: Move a modulo operation out of a hot loop.

Filesystem shrinking in particular is a heavy user of this loop in
ext2fs_new_inode(). This change makes resize2fs use 24% less CPU time
for shrinking a 100G filesystem.

Signed-off-by: Sami Liedes <sami.liedes@iki.fi>

diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index 948a0ec..eb4e0f5 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -109,6 +109,7 @@ errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t d=
ir,
 	ext2_ino_t	dir_group =3D 0;
 	ext2_ino_t	i;
 	ext2_ino_t	start_inode;
+	ext2_ino_t	modulo;
=20
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
=20
@@ -126,17 +127,21 @@ errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t=
 dir,
 	if (start_inode > fs->super->s_inodes_count)
 		return EXT2_ET_INODE_ALLOC_FAIL;
 	i =3D start_inode;
+	modulo =3D (i - 1) % EXT2_INODES_PER_GROUP(fs->super);
=20
 	do {
-		if (((i - 1) % EXT2_INODES_PER_GROUP(fs->super)) =3D=3D 0)
+		if (modulo =3D=3D 0)
 			check_inode_uninit(fs, map, (i - 1) /
 					   EXT2_INODES_PER_GROUP(fs->super));
=20
 		if (!ext2fs_fast_test_inode_bitmap2(map, i))
 			break;
-		i++;
-		if (i > fs->super->s_inodes_count)
+		if (++modulo =3D=3D EXT2_INODES_PER_GROUP(fs->super))
+			modulo =3D 0;
+		if (++i > fs->super->s_inodes_count) {
 			i =3D EXT2_FIRST_INODE(fs->super);
+			modulo =3D (i - 1) % EXT2_INODES_PER_GROUP(fs->super);
+		}
 	} while (i !=3D start_inode);
=20
 	if (ext2fs_test_inode_bitmap2(map, i))

--+2GlJm56SCtLHYlr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJPW8kAAAoJEKLT589SE0a0YbcQAJNt7Cyg1kRJrpBNIHWDhv/j
NjQgDYpWxXCKWY6fg8yAViMuGnNSMsOzXViDwocUupH4kgZOO51s95Kx49AVsZwK
9T31/OFY20dVMQTYk9ThT0vz3kSJBEQjnSxq/R3+zRN5/Bpvm3c2npFKu7K0BJsT
K2y3nF0g1MKvPchlXPEJl2rh33v9dj+/DrHsfK8+W8KJO1CBImCA7NrAhHuYpQ+f
nW51hUo/cPhJkcjrwGU1kfr0cI7gWLnZ6POcD+AaUzXDeBAnD6DGvEQN/3CGoADX
vJZa9wiFlUi0o6jn/XThkxWT5houxtaDkUF/rQZvHuFObjWRwYgR1+aq87YVBF72
a+6Mdo6edbmUfBMmNQwOtFetguLCqHhT20BZ18yKHWI7U+45bt3HigdLskQ54xMl
xtFHgFhzTpKEIZ3ujI1D/rH+sxueR+I/B74oxeArRfW0jC4ZT3bWOeLI+K94w1qS
FzvBDRAzH3NvvfD8yw/4NBbUQvYaxtpwU10RtOWQvJ6auVHzap6H4FtcleTJVx4m
Gehccg6dayLks3RgkoDIUEYFyhqJwYw/9ems9xxv2Loq/7iAN0/H3Y0OLeigPis5
sgQbGybNPWKBYtigG+vsC6w78oJmEK6VnUhg4OdGEgr77aoGprcSpN0t209qDWO0
6LOgatYGpbGdV3qQcP0X
=zY1T
-----END PGP SIGNATURE-----

--+2GlJm56SCtLHYlr--
