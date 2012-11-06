From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: still got few EXT4-fs errors
Date: Tue, 06 Nov 2012 22:13:49 +0100
Message-ID: <50997D8D.40509@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:59430 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751801Ab2KFVNx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Nov 2012 16:13:53 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With kernel 3.6.6-rc1 I got :

n22 ~ # zgrep -e 'EXT4-fs error' -e JBD2 /var/log/messages
2012-11-05T13:40:44.460+01:00 n22 kernel: EXT4-fs error (device sdb3) i=
n ext4_new_inode:933: IO failure
2012-11-05T13:41:25.982+01:00 n22 kernel: EXT4-fs error (device sdb3) i=
n ext4_new_inode:933: IO failure
2012-11-05T13:41:26.543+01:00 n22 kernel: EXT4-fs error (device sdb3): =
ext4_mb_generate_buddy:741: group 771, 31096 clusters in bitmap, 31095 =
in gd
2012-11-05T13:41:26.543+01:00 n22 kernel: JBD2: Spotted dirty metadata =
buffer (dev =3D sdb3, blocknr =3D 0). There's a risk of filesystem corr=
uption in case of system crash.
2012-11-05T13:45:02.077+01:00 n22 kernel: EXT4-fs error (device sdb3): =
ext4_mb_generate_buddy:741: group 1123, 31721 clusters in bitmap, 31720=
 in gd
2012-11-05T13:45:02.077+01:00 n22 kernel: JBD2: Spotted dirty metadata =
buffer (dev =3D sdb3, blocknr =3D 0). There's a risk of filesystem corr=
uption in case of system crash.
2012-11-05T13:54:41.729+01:00 n22 kernel: EXT4-fs error (device sdb3): =
mb_free_blocks:1300: group 1123, block 36808224:freeing already freed b=
lock (bit 9760)
2012-11-05T13:54:41.729+01:00 n22 kernel: EXT4-fs error (device sdb3): =
mb_free_blocks:1300: group 771, block 25264846:freeing already freed bl=
ock (bit 718)


It is an almost stable Gentoo Linux 32 bit, booted from an external USB=
 disk.

What I did at that time was to compile the 3.6.6 final stable kernel.


--
=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
