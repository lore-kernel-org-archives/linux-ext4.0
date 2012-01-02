From: Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH] ext4: Report max_batch_time option correctly
Date: Mon, 02 Jan 2012 14:13:02 +0000
Message-ID: <1325513582.13595.213.camel@deadeye>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-x/d4o0ih4Oahw/u1Vurn"
Cc: linux-ext4@vger.kernel.org, Russell Coker <russell@coker.com.au>,
	654206@bugs.debian.org
To: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48789 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752653Ab2ABONS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Jan 2012 09:13:18 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-x/d4o0ih4Oahw/u1Vurn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Currently the value reported for max_batch_time is really the
value of min_batch_time.

Reported-by: Russell Coker <russell@coker.com.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/super.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 3e1329e..410e993 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1096,7 +1096,7 @@ static int ext4_show_options(struct seq_file *seq, st=
ruct vfsmount *vfs)
 	}
 	if (sbi->s_max_batch_time !=3D EXT4_DEF_MAX_BATCH_TIME) {
 		seq_printf(seq, ",max_batch_time=3D%u",
-			   (unsigned) sbi->s_min_batch_time);
+			   (unsigned) sbi->s_max_batch_time);
 	}
=20
 	/*
--=20
1.7.7.3



--=-x/d4o0ih4Oahw/u1Vurn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATwG7bue/yOyVhhEJAQqB9RAAnSAUja74AA4nqEUFORvYT9mYmCyHscJC
L0T7Vrb0LXoTw01G0lk3my34yEOfwpmp0wg6pbGHfd9MpdbOMWN9RDb3M6Qky+ec
usSbGKGaz5l6bHTTMjxGi4IMLSx2MmwRDqKyugNePk+LQjKiLRCEG8IyllBH57J/
SU+zpLxEu0Bm5QLtkeDkRYrON9PcQjxisSG9CWtpCYu+tzRDfffXDI5++hd21PL+
RYg6nnqwjgYfsg8YlxsaMllmyLH1/4helVt8I/eUw5Lv2Lp3S2CDP3Uieubj/gxF
+iPQC/tKyZPENvA8apy1j3pNgyTIpv3g6lq1QsfT4Vt31o7xBYFtqAKSAy//zvgs
JfbAQ+uvNiFSsV5vVbfSQ5INI2uUfeqUUo8LPngJv5mdoPatSwx1xDzKbZEFtslf
5dX8TMzvTYw7GtqLeNFWNMjdmh6QSuPrN/2prfsKom6rttOjVY0/4riTaTuvTdKc
NxCvRvCEq5CWOayOaKCilueZnoQLEy2AW3wibdaZgdrn/n3XvWXVlVIbX+zl95cu
wbOHyTnZYI0JhffG2/st/Bjjn0Xzphn/XR3WuFKn/Jw0K+zhLoUC2WcKCm1EZxDr
U0zXSXd6Hl88tu3BM7U/zK5GOGeR98VZSN+gmjHPM+Bp2tIYoXHQbuRmBUTKXBZ7
kfDFF/As4Ic=
=s3rL
-----END PGP SIGNATURE-----

--=-x/d4o0ih4Oahw/u1Vurn--
