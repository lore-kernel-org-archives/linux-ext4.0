From: Sami Liedes <sami.liedes@iki.fi>
Subject: [PATCH 4/5] libext2fs: Implement
 ext2fs_find_first_zero_generic_bmap().
Date: Sat, 10 Mar 2012 23:37:40 +0200
Message-ID: <20120310213740.GO6961@sli.dy.fi>
References: <20120310213321.GK6961@sli.dy.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dT+85zccSFkyJC53"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-4.hut.fi ([130.233.228.94]:44272 "EHLO smtp-4.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752377Ab2CJVzd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 10 Mar 2012 16:55:33 -0500
Received: from localhost (katosiko.hut.fi [130.233.228.115])
	by smtp-4.hut.fi (8.13.6/8.12.10) with ESMTP id q2ALbq84004547
	for <linux-ext4@vger.kernel.org>; Sat, 10 Mar 2012 23:37:52 +0200
Received: from smtp-4.hut.fi ([130.233.228.94])
 by localhost (katosiko.hut.fi [130.233.228.115]) (amavisd-new, port 10024)
 with LMTP id 04946-870 for <linux-ext4@vger.kernel.org>;
 Sat, 10 Mar 2012 23:37:51 +0200 (EET)
Received: from kosh.localdomain (kosh.hut.fi [130.233.228.12])
	by smtp-4.hut.fi (8.13.6/8.12.10) with ESMTP id q2ALbehQ004540
	for <linux-ext4@vger.kernel.org>; Sat, 10 Mar 2012 23:37:40 +0200
Content-Disposition: inline
In-Reply-To: <20120310213321.GK6961@sli.dy.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--dT+85zccSFkyJC53
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom a58c07c019e4a7e6181f021ae022ebcdc5cce4e2 Mon Sep 17 00:00:00 2001
=46rom: Sami Liedes <sami.liedes@iki.fi>
Date: Sat, 10 Mar 2012 22:36:12 +0200
Subject: [PATCH] libext2fs: Implement ext2fs_find_first_zero_generic_bmap().

This function searches a bitmap for the first zero bit within a range.
It checks if there is a bitmap backend specific implementation
available (if the relevant field in bitmap_ops is non-NULL). If not,
it uses a generic and slow method by repeatedly calling test_bmap() in
a loop. Also change ext2fs_new_inode() to use this new function.

This change in itself does not result in a large speedup, rather it
refactors the code in preparation for the introduction of a faster
find_first_zero() for bitarray based bitmaps.

Signed-off-by: Sami Liedes <sami.liedes@iki.fi>

diff --git a/lib/ext2fs/alloc.c b/lib/ext2fs/alloc.c
index eb4e0f5..1da9532 100644
--- a/lib/ext2fs/alloc.c
+++ b/lib/ext2fs/alloc.c
@@ -109,7 +109,8 @@ errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t d=
ir,
 	ext2_ino_t	dir_group =3D 0;
 	ext2_ino_t	i;
 	ext2_ino_t	start_inode;
-	ext2_ino_t	modulo;
+	ext2_ino_t	modulo, upto, first_zero;
+	errcode_t	err;
=20
 	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
=20
@@ -128,16 +129,27 @@ errcode_t ext2fs_new_inode(ext2_filsys fs, ext2_ino_t=
 dir,
 		return EXT2_ET_INODE_ALLOC_FAIL;
 	i =3D start_inode;
 	modulo =3D (i - 1) % EXT2_INODES_PER_GROUP(fs->super);
-
 	do {
 		if (modulo =3D=3D 0)
 			check_inode_uninit(fs, map, (i - 1) /
 					   EXT2_INODES_PER_GROUP(fs->super));
=20
-		if (!ext2fs_fast_test_inode_bitmap2(map, i))
+		upto =3D i + (EXT2_INODES_PER_GROUP(fs->super) - modulo);
+		if (i < start_inode && upto >=3D start_inode)
+			upto =3D start_inode - 1;
+		if (upto > fs->super->s_inodes_count)
+			upto =3D fs->super->s_inodes_count;
+
+		err =3D ext2fs_find_first_zero_inode_bitmap2(map, i, upto, &first_zero);
+		if (!err) {
+			i =3D first_zero;
 			break;
-		if (++modulo =3D=3D EXT2_INODES_PER_GROUP(fs->super))
-			modulo =3D 0;
+		} else {
+			if (err !=3D ENOENT)
+				return EXT2_ET_INODE_ALLOC_FAIL;
+			i =3D upto;
+		}
+
 		if (++i > fs->super->s_inodes_count) {
 			i =3D EXT2_FIRST_INODE(fs->super);
 			modulo =3D (i - 1) % EXT2_INODES_PER_GROUP(fs->super);
diff --git a/lib/ext2fs/bitops.h b/lib/ext2fs/bitops.h
index 83a01e4..70caa86 100644
--- a/lib/ext2fs/bitops.h
+++ b/lib/ext2fs/bitops.h
@@ -188,6 +188,9 @@ extern void ext2fs_mark_block_bitmap_range2(ext2fs_bloc=
k_bitmap bitmap,
 					    blk64_t block, unsigned int num);
 extern void ext2fs_unmark_block_bitmap_range2(ext2fs_block_bitmap bitmap,
 					      blk64_t block, unsigned int num);
+extern errcode_t ext2fs_find_first_zero_generic_bmap(ext2fs_generic_bitmap=
 bitmap,
+						     __u64 start, __u64 end,
+						     __u64 *out);
=20
 /*
  * The inline routines themselves...
@@ -593,6 +596,19 @@ _INLINE_ int ext2fs_fast_test_inode_bitmap2(ext2fs_ino=
de_bitmap bitmap,
 					inode);
 }
=20
+_INLINE_ errcode_t ext2fs_find_first_zero_inode_bitmap2(ext2fs_inode_bitma=
p bitmap,
+							ext2_ino_t start,
+							ext2_ino_t end,
+							ext2_ino_t *out)
+{
+	__u64 o;
+	errcode_t rv =3D ext2fs_find_first_zero_generic_bmap((ext2fs_generic_bitm=
ap) bitmap,
+							   start, end, &o);
+	if (!rv)
+		*out =3D o;
+	return rv;
+}
+
 _INLINE_ blk64_t ext2fs_get_block_bitmap_start2(ext2fs_block_bitmap bitmap)
 {
 	return ext2fs_get_generic_bmap_start((ext2fs_generic_bitmap) bitmap);
diff --git a/lib/ext2fs/bmap64.h b/lib/ext2fs/bmap64.h
index 288e1b6..f44d379 100644
--- a/lib/ext2fs/bmap64.h
+++ b/lib/ext2fs/bmap64.h
@@ -89,6 +89,11 @@ struct ext2_bitmap_ops {
 				    __u64 start, size_t num, void *out);
 	void (*clear_bmap)(ext2fs_generic_bitmap bitmap);
 	void (*print_stats)(ext2fs_generic_bitmap);
+
+	/* Find the first zero bit between start and end, inclusive.
+	 * May be NULL, in which case a generic function is used. */
+	errcode_t (*find_first_zero)(ext2fs_generic_bitmap bitmap,
+				     __u64 start, __u64 end, __u64 *out);
 };
=20
 extern struct ext2_bitmap_ops ext2fs_blkmap64_bitarray;
diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
index fa8d7b7..b57df54 100644
--- a/lib/ext2fs/gen_bitmap64.c
+++ b/lib/ext2fs/gen_bitmap64.c
@@ -762,3 +762,31 @@ errcode_t ext2fs_convert_subcluster_bitmap(ext2_filsys=
 fs,
 	*bitmap =3D cmap;
 	return 0;
 }
+
+errcode_t ext2fs_find_first_zero_generic_bmap(ext2fs_generic_bitmap bitmap,
+					      __u64 start, __u64 end, __u64 *out)
+{
+	int b;
+
+	if (bitmap->bitmap_ops->find_first_zero)
+		return bitmap->bitmap_ops->find_first_zero(bitmap, start, end, out);
+
+	if (!bitmap || !EXT2FS_IS_64_BITMAP(bitmap) || bitmap->cluster_bits)
+		return EINVAL;
+
+	if (start < bitmap->start || end > bitmap->end || start > end) {
+		warn_bitmap(bitmap, EXT2FS_TEST_ERROR, start);
+		return EINVAL;
+	}
+
+	while (start <=3D end) {
+		b =3D bitmap->bitmap_ops->test_bmap(bitmap, start);
+		if (!b) {
+			*out =3D start;
+			return 0;
+		}
+		start++;
+	}
+
+	return ENOENT;
+}

--dT+85zccSFkyJC53
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJPW8mkAAoJEKLT589SE0a03aMP/2pkccJOPsLlEa0OpK9j2ooO
PnX5ev6tHSoC9nUQMWpfmAULgIchjjPmHf8WSUn5F4C52lg7rvT2SNmlMzT+09YJ
7qKs1+HrTzMlnDlAgEpioaas8YP+CZwBlBtOJQs11N1Rprnh9/zpaSXtZvU/5E+k
GgMiHKQR8EsiD58FhQEoXmfggp4domkx2i2eTj9kRkmP6HgxeXLDeftgZQOC5VFj
aNqjumZqYYCFCY29Na2SuEd7zOwJyn1bSufLmi/YQxqlelUpfc42YZV9jzglYEJA
tWfOpcD6Aco4AUkY+p3cXgzloZVwUiyLl0y5s+2i9untUf12geeHciWjERl5FHyq
gxN06fSs3SyDg6Putt3208WXWr+sk1iYflrDIOBcJ5iIsRmGw4evZ3g0eoH/CCWv
onbFt68sxdWpQGMYyMvlVTU/SRovrSH7EydBCW/n32moez1AjnegXeeMj5194qwo
Pw5lXNxzImlhSLnnzdvo8D9j5X2fGMQsEK+EOlPNWedEMHzbwlGjZBLN19xO8tbh
R7GxKxQW4IJbmHO+IFeOureh7BeA2rOHXom999Rj/bnWt5nO7mYKb8JXVs6l1y0x
vQWnjYeXYdoPz3twgW+bsQBlLPSo2JH5N/KCQWaTGVjsW/n1UQd2F4bB7+h0Q7Cr
NWdmdcScpSJnHwZGrIEi
=POvq
-----END PGP SIGNATURE-----

--dT+85zccSFkyJC53--
