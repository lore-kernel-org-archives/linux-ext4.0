From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: ext4 fs errors - immediately reboot needed ?
Date: Mon, 19 Nov 2012 19:45:41 +0100
Message-ID: <50AA7E55.2090707@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:39018 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753954Ab2KSSpq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Nov 2012 13:45:46 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

/me wonders, whether the following messages should force me to *immedia=
tely*
reboot the system of whether I should schedule a reboot in the near fut=
ure :

2012-11-19T19:23:53.099+01:00 n22 kernel: EXT4-fs error (device sdb3) i=
n ext4_new_inode:933: IO failure
2012-11-19T19:24:04.971+01:00 n22 kernel: EXT4-fs error (device sdb3): =
ext4_mb_generate_buddy:741: group 409, 11806 clusters in bitmap, 11805 =
in gd
2012-11-19T19:24:04.971+01:00 n22 kernel: JBD2: Spotted dirty metadata =
buffer (dev =3D sdb3, blocknr =3D 0). There's a risk of filesystem corr=
uption in case of system crash.
2012-11-19T19:37:20.188+01:00 n22 kernel: EXT4-fs error (device sdb3) i=
n ext4_new_inode:933: IO failure
2012-11-19T19:44:28.552+01:00 n22 kernel: EXT4-fs error (device sdb3): =
ext4_mb_generate_buddy:741: group 424, 27235 clusters in bitmap, 27234 =
in gd
2012-11-19T19:44:28.552+01:00 n22 kernel: JBD2: Spotted dirty metadata =
buffer (dev =3D sdb3, blocknr =3D 0). There's a risk of filesystem corr=
uption in case of system crash.
2012-11-19T19:44:33.734+01:00 n22 kernel: EXT4-fs error (device sdb3): =
mb_free_blocks:1300: group 424, block 13916749:freeing already freed bl=
ock (bit 23117)
2012-11-19T19:44:33.734+01:00 n22 kernel: EXT4-fs error (device sdb3): =
mb_free_blocks:1300: group 409, block 13431904:freeing already freed bl=
ock (bit 29792)

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
