From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re:  [PATCH] fs:ext3: remove lock_buffer in bclean() and setup_new_group_blocks
Date: Sun, 02 Dec 2012 16:36:26 +0100
Message-ID: <50BB757A.7020102@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Cong Ding <dinggnu@gmail.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:47653 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752048Ab2LBPg3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 2 Dec 2012 10:36:29 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Your patch might call memcpy up to 3x more often than the current code
or ? If yes then to avoid this the current code might be desigend for ?

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
