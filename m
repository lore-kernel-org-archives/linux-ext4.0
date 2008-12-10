From: Peng Tao <bergwolf@gmail.com>
Subject: [PATCH 3/3][e2fsprogs] tune2fs: Don't allow tune2fs -I if flex_bg
 on
Date: Wed, 10 Dec 2008 16:05:38 +0800
Message-ID: <493F7852.2040201@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB7EFD56DB42F1C6B759E2AFB"
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.186]:58206 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883AbYLJIFo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Dec 2008 03:05:44 -0500
Received: by ti-out-0910.google.com with SMTP id b6so216037tic.23
        for <linux-ext4@vger.kernel.org>; Wed, 10 Dec 2008 00:05:43 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB7EFD56DB42F1C6B759E2AFB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


    add force flag to tune2fs -I, because it may cause data corruption
when the
    last inode table block is followed by a in-use data block. If user
really want to
    tune the inode size, they should be warned about this.

    Signed-off-by: Peng Tao <bergwolf@gmail.com>

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 453a529..1227802 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -107,7 +107,7 @@ static void usage(void)
 		  "[-L volume_label]\n"
 		  "\t[-M last_mounted_dir] [-O [^]feature[,...]]\n"
 		  "\t[-E extended-option[,...]] [-T last_check_time] "
-		  "[-U UUID]\n\t[ -I new_inode_size ] device\n"), program_name);
+		  "[-U UUID]\n\t[ -I new_inode_size ] [-f] device\n"), program_name);
 	exit (1);
 }

@@ -1598,6 +1598,13 @@ retry_open:
 		ext2fs_mark_super_dirty(fs);
 	}
 	if (I_flag) {
+		if (!f_flag) {
+			fputs(_("Enlarging inode size may cause data "
+				"corruption.\nUse with -f at your warranty. "
+				"Abort.\n"), stderr);
+			exit(1);
+		}
+
 		if (mount_flags & EXT2_MF_MOUNTED) {
 			fputs(_("The inode size may only be "
 				"changed when the filesystem is "


--------------enigB7EFD56DB42F1C6B759E2AFB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkk/eFIACgkQEyny3P47hFH30QCeIC/DTd4gTbARe5N6CmAN18YB
MIQAnjun04eUqcu3dOg4359EnpMs/6No
=G2Um
-----END PGP SIGNATURE-----

--------------enigB7EFD56DB42F1C6B759E2AFB--
