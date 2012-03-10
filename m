From: Sami Liedes <sami.liedes@iki.fi>
Subject: [PATCH 5/5] libext2fs: Implement fast find_first_zero() for bitarray
 bitmaps.
Date: Sat, 10 Mar 2012 23:38:40 +0200
Message-ID: <20120310213840.GP6961@sli.dy.fi>
References: <20120310213321.GK6961@sli.dy.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4dIe/AmYstFUGHTF"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-3.hut.fi ([130.233.228.93]:52076 "EHLO smtp-3.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392Ab2CJVin (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 10 Mar 2012 16:38:43 -0500
Received: from localhost (katosiko.hut.fi [130.233.228.115])
	by smtp-3.hut.fi (8.13.6/8.12.10) with ESMTP id q2ALcfw4023045
	for <linux-ext4@vger.kernel.org>; Sat, 10 Mar 2012 23:38:41 +0200
Received: from smtp-3.hut.fi ([130.233.228.93])
 by localhost (katosiko.hut.fi [130.233.228.115]) (amavisd-new, port 10024)
 with LMTP id 05030-916 for <linux-ext4@vger.kernel.org>;
 Sat, 10 Mar 2012 23:38:41 +0200 (EET)
Received: from kosh.localdomain (kosh.hut.fi [130.233.228.12])
	by smtp-3.hut.fi (8.13.6/8.12.10) with ESMTP id q2ALceeO023038
	for <linux-ext4@vger.kernel.org>; Sat, 10 Mar 2012 23:38:40 +0200
Content-Disposition: inline
In-Reply-To: <20120310213321.GK6961@sli.dy.fi>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--4dIe/AmYstFUGHTF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom 020d7721d9de525e511b4778795d375675160844 Mon Sep 17 00:00:00 2001
=46rom: Sami Liedes <sami.liedes@iki.fi>
Date: Sat, 10 Mar 2012 22:50:51 +0200
Subject: [PATCH] libext2fs: Implement fast find_first_zero() for bitarray
 bitmaps.

With this change the CPU time needed to shrink a 100G filesystem drops
to 0.8% of the original (17 CPU seconds instead of 2057).

Signed-off-by: Sami Liedes <sami.liedes@iki.fi>

diff --git a/lib/ext2fs/blkmap64_ba.c b/lib/ext2fs/blkmap64_ba.c
index 3f0c643..8eddde9 100644
--- a/lib/ext2fs/blkmap64_ba.c
+++ b/lib/ext2fs/blkmap64_ba.c
@@ -317,6 +317,86 @@ static void ba_print_stats(ext2fs_generic_bitmap bitma=
p)
 		sizeof(struct ext2fs_ba_private_struct));
 }
=20
+/* Find the first zero bit between start and end, inclusive. */
+static errcode_t ba_find_first_zero(ext2fs_generic_bitmap bitmap,
+				    __u64 start, __u64 end, __u64 *out)
+{
+	ext2fs_ba_private bp =3D (ext2fs_ba_private)bitmap->private;
+	unsigned long bitpos =3D start - bitmap->start;
+	unsigned long count =3D end - start + 1;
+	int byte_found =3D 0; /* whether a !=3D 0xff byte has been found */
+	const unsigned char *pos;
+	unsigned long max_loop_count, i;
+
+	if (start < bitmap->start || end > bitmap->end || start > end)
+		return EINVAL;
+
+	if (bitmap->cluster_bits)
+		return EINVAL;
+
+	/* scan bits until we hit a byte boundary */
+	while ((bitpos & 0x7) !=3D 0 && count > 0) {
+		if (!ext2fs_test_bit64(bitpos, bp->bitarray)) {
+			*out =3D bitpos + bitmap->start;
+			return 0;
+		}
+		bitpos++;
+		count--;
+	}
+
+	if (!count)
+		return ENOENT;
+
+	pos =3D ((unsigned char *)bp->bitarray) + (bitpos >> 3);
+	/* scan bytes until 8-byte (64-bit) aligned */
+	while (count >=3D 8 && (((unsigned long)pos) & 0x07)) {
+		if (*pos !=3D 0xff) {
+			byte_found =3D 1;
+			break;
+		}
+		pos++;
+		count -=3D 8;
+		bitpos +=3D 8;
+	}
+
+	if (!byte_found) {
+		max_loop_count =3D count >> 6; /* 8-byte blocks */
+		i =3D max_loop_count;
+		while (i) {
+			if (*((const __u64 *)pos) !=3D ((__u64)-1))
+				break;
+			pos +=3D 8;
+			i--;
+		}
+		count -=3D 64 * (max_loop_count - i);
+		bitpos +=3D 64 * (max_loop_count - i);
+
+		max_loop_count =3D count >> 3;
+		i =3D max_loop_count;
+		while (i) {
+			if (*pos !=3D 0xff) {
+				byte_found =3D 1;
+				break;
+			}
+			pos++;
+			i--;
+		}
+		count -=3D 8 * (max_loop_count - i);
+		bitpos +=3D 8 * (max_loop_count - i);
+	}
+
+	/* Here either count < 8 or byte_found =3D=3D 1. */
+	while (count-- > 0) {
+		if (!ext2fs_test_bit64(bitpos, bp->bitarray)) {
+			*out =3D bitpos + bitmap->start;
+			return 0;
+		}
+		bitpos++;
+	}
+
+	return ENOENT;
+}
+
 struct ext2_bitmap_ops ext2fs_blkmap64_bitarray =3D {
 	.type =3D EXT2FS_BMAP64_BITARRAY,
 	.new_bmap =3D ba_new_bmap,
@@ -333,4 +413,5 @@ struct ext2_bitmap_ops ext2fs_blkmap64_bitarray =3D {
 	.get_bmap_range =3D ba_get_bmap_range,
 	.clear_bmap =3D ba_clear_bmap,
 	.print_stats =3D ba_print_stats,
+	.find_first_zero =3D ba_find_first_zero
 };

--4dIe/AmYstFUGHTF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCgAGBQJPW8ngAAoJEKLT589SE0a07lYP/28JIEabhto6VcLEmLM/Sh34
do6euri/eyt0Q8Z6ra7gOd0Pf0Sp9yrENAcCem4QRD3ooalyOdMis9JAMQUDafZx
aAXOLRWItp+bxj2k4XluRxvHWAXuxE4phJ6U6tN5k9X5OshvxicsUXBdnrdj6noQ
F0+AiWvdU7Qpg8aleG+4qFnPZakZMVrsbbcijnkI2PxqQGz3tkNn/i/cOcHoVfLj
W12BFmGEk5aocNPdHANhq49fxsBT1ap2Ilako91ZgDQI7buQpuQcRRtiYnav9R+S
CKvGZK9tC399NPo3KXtCNAaaRY0Gv8OXQuyDxS9aMFMSKmU4SMdfoCQUcXhqsTEy
LmpUFA9LeHb3qlpn/rpsreNrUzPLsRgMxJeq2JGNp4hwxq7ZnQ1sgmJbutAzeYZH
s+iDwxSPRYC2uYdvZK3gMA1F3z+YezpARviyImQtitmcFChowMsmlEV9NKMXQQA4
rmNE8Kt5VC5jx3fSpbTpJ8Tv7n4BvXd7i6qz25Iq8DjM4K9kehsMrgvJrlt0ipBd
0hgYRuYXBeBdEOGFNejAnjijgjUjASfs0q5sVrHc+9E/ESH7St5NqfP9cN0WYH6h
JC365JnDIyA8SWjTaaGtaS+z+CjxwspNERiVigmNQKV4wce3sRbmUYtnHzTI1N0+
6L1B4f/h1zAP7+boQ0NQ
=0IK0
-----END PGP SIGNATURE-----

--4dIe/AmYstFUGHTF--
