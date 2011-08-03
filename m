From: "markus hansen" <hansenmarkus@gmx.de>
Subject: fsck.ext4 multiply-claimed blocks
Date: Wed, 03 Aug 2011 11:10:53 +0200
Message-ID: <20110803091053.316860@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:34920 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752637Ab1HCJK5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 3 Aug 2011 05:10:57 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I have a huge crashed ext4 filesystem with lots of Hardlinks in it. fsc=
k.ext4 has not completed after 24h, handling "multiply-claimed blocks" =
eats the time. Stupid beginner question: Are the offered two Options (a=
) "copy multiply claimed blocks" (b) "delete inodes" useful in case mul=
tiple hardlinks point to same blocks? Isnt it ok in that case, that blo=
cks are multiply claimed?

regards,

Markus
--=20
NEU: FreePhone - 0ct/min Handyspartarif mit Geld-zur=C3=BCck-Garantie!	=
=09
Jetzt informieren: http://www.gmx.net/de/go/freephone
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
