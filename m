Return-Path: <SRS0=F3Rs=OG=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mx1.hrz.uni-dortmund.de ([129.217.128.51]:33610 "EHLO
        unimail.uni-dortmund.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726381AbeK1CFO (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Nov 2018 21:05:14 -0500
To: Jan Kara <jack@suse.cz>
Cc: Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        linux-ext4@vger.kernel.org
From: Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
Subject: [PATCH] inode_has_no_xattr() does not use proper sync
Message-ID: <ce8c29d7-7f5e-5c78-dbd9-15364a384138@tu-dortmund.de>
Date: Tue, 27 Nov 2018 15:54:28 +0100
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="Lz3rPUvLvUHq6MAurzvaFbaqH4Mjd2O68"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Lz3rPUvLvUHq6MAurzvaFbaqH4Mjd2O68
Content-Type: multipart/mixed; boundary="9Ts6RDfIpviu5kSXZ92QAT7aFoLnnlWAo";
 protected-headers="v1"
From: Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
To: Jan Kara <jack@suse.cz>
Cc: Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
 linux-ext4@vger.kernel.org
Message-ID: <ce8c29d7-7f5e-5c78-dbd9-15364a384138@tu-dortmund.de>
Subject: [PATCH] inode_has_no_xattr() does not use proper sync

--9Ts6RDfIpviu5kSXZ92QAT7aFoLnnlWAo
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable


inode.i_flags is modified without any proper
synchronisation used. inode_set_flags() is now used.

Found by LockDoc (Alexander Lochmann, Horst Schirmeier and Olaf
Spinczyk)

Signed-off-by: Alexander Lochmann <alexander.lochmann@tu-dortmund.de>
Signed-off-by: Horst Schirmeier <horst.schirmeier@tu-dortmund.de>
---
 include/linux/fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index c95c0807471f..54f3a21668a6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3446,7 +3446,7 @@ static inline int check_sticky(struct inode *dir,
struct inode *inode)
 static inline void inode_has_no_xattr(struct inode *inode)
 {
 	if (!is_sxid(inode->i_mode) && (inode->i_sb->s_flags & SB_NOSEC))
-		inode->i_flags |=3D S_NOSEC;
+		inode_set_flags(inode, S_NOSEC, S_NOSEC);
 }

 static inline bool is_root_inode(struct inode *inode)
--=20
2.19.1


--9Ts6RDfIpviu5kSXZ92QAT7aFoLnnlWAo--

--Lz3rPUvLvUHq6MAurzvaFbaqH4Mjd2O68
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEElhZsUHzVP0dbkjCRWT7tBbw+9v0FAlv9WqQACgkQWT7tBbw+
9v22DQ/+PtgGQv0PAcOy1Ek4nMdd9rnURlvpEyxnjwYW924l4wVREkOxphGVaL5h
inT7JZfO+egiVkLKEJ/EdS9woanp3XVArHSwOvuKIRcBC+gHrp48MUYQnKgiV0Gn
izBq1ubnUID5JARZIhL4Hs0XgWSX6y5tEZuPjZoNIYGlg26ncG4FtO53CNGyAC5Z
ev9lnY8Pmi7KMsbn/80BGzmyhR9+26YVI6bCX/93r7OK29T5z9XmByXw+qw+aldW
Wd6ihjEIagd+qaVyHjqmnLlS2IFiXrOYjkZFE7D17Z0Jy773rlz8hZWagMyoibMo
mYRKNq0FjweQ23GQf7nLk0hA9RNwVC95OrXDT5T+g0EPi03Z7uHGW1vcaDe/+EBX
Y+AyalOwn045monQaHmHs0343UQkIbvuxTLUWBaipgtUmXCrBr/aPa7vUeM/94Vv
SMnlNFqijquR+VpkyjnNiSSL/od9l8eyN71hV1g6SAHEAL0UKRKP2CsbxWNlfmje
9ZFuDpBGMEWXhfCp9R7T0TOGw1o9be4WCRaFfeFYno5C+mSrziRLtmUaayKLs+Zk
LBY+mWzGlCYgeB3762fSyE2/ML/miTqlsL+nC0CeANXUK4U+FxdA3nM4Jr201h+3
qKNvVv4lHlKu6p9G04PLHHFst/tgNDsEBiraVly7xS4Q8/EVbr4=
=7Mxw
-----END PGP SIGNATURE-----

--Lz3rPUvLvUHq6MAurzvaFbaqH4Mjd2O68--
