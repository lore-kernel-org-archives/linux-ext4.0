From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: ext4_free_inode:319: comm krunner: bit already cleared for inode
 6293718
Date: Thu, 03 Jan 2013 18:49:57 +0100
Message-ID: <50E5C4C5.9040701@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:50560 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771Ab3ACRzC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Jan 2013 12:55:02 -0500
Received: from mailout-de.gmx.net ([10.1.76.1]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0MaXUl-1Tb5Sg0Mf3-00KBoi for
 <linux-ext4@vger.kernel.org>; Thu, 03 Jan 2013 18:49:59 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=46or the following 3 errors I think the last 2 are related to the fact=
,
that I'm booting a Gentoo Linux (kernel 3.7.1) from an external USB 2.0=
 drive,
but the first error, is that related too to the external drive itslef ?=
 :

2013-01-03T16:28:04.305+01:00 n22 kernel: EXT4-fs error (device sdb3): =
ext4_free_inode:319: comm krunner: bit already cleared for inode 629371=
8
2013-01-03T16:28:07.426+01:00 n22 kernel: EXT4-fs error (device sdb3) i=
n ext4_new_inode:942: IO failure
2013-01-03T16:28:10.683+01:00 n22 kernel: EXT4-fs error (device sdb3) i=
n ext4_new_inode:942: IO failure


--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
