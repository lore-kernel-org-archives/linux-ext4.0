From: Peng Tao <bergwolf@gmail.com>
Subject: [PATCH][e2fsprogs] [resend]tune2fs: add force flag to tune2fs -I
Date: Thu, 11 Dec 2008 09:53:07 +0800
Message-ID: <49407283.8090804@gmail.com>
References: <493F7852.2040201@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig20D55F6D3FCD7E9D5AA5F93B"
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.187]:21014 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbYLKBx3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Dec 2008 20:53:29 -0500
Received: by ti-out-0910.google.com with SMTP id b6so467822tic.23
        for <linux-ext4@vger.kernel.org>; Wed, 10 Dec 2008 17:53:28 -0800 (PST)
In-Reply-To: <493F7852.2040201@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig20D55F6D3FCD7E9D5AA5F93B
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Sorry, just found out that I messed up this patch...
----------------------------------------

add force flag to tune2fs -I, because it may cause data corruption when
the last inode table block is followed by a in-use data block. If user
really want to tune the inode size, they should be warned about this.

Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 misc/tune2fs.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 453a529..7308773 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -1598,6 +1598,12 @@ retry_open:
 		ext2fs_mark_super_dirty(fs);
 	}
 	if (I_flag) {
+		if (f_flag) {
+			fputs(_("Enlarging inode size may cause data "
+				"corruption.\nUse with -f at your warranty. "
+				"Abort.\n"), stderr);
+			exit(1);
+		}
 		if (mount_flags & EXT2_MF_MOUNTED) {
 			fputs(_("The inode size may only be "
 				"changed when the filesystem is "







--------------enig20D55F6D3FCD7E9D5AA5F93B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAklAcpEACgkQEyny3P47hFHkIwCfe7kW8S0ZBBnkdFHjm4Pas8Af
yLsAn269t9HJWagD4bAAIGv+D2t6VMx8
=waz6
-----END PGP SIGNATURE-----

--------------enig20D55F6D3FCD7E9D5AA5F93B--
