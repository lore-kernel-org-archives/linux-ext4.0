From: "jon ernst" <jonernst07@gmx.com>
Subject: "block_dump, bd" in debugfs
Date: Wed, 26 Jun 2013 23:05:13 -0400
Message-ID: <20130627030513.217820@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([74.208.4.201]:52077 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab3F0DFT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Jun 2013 23:05:19 -0400
Received: from mailout-us.gmx.com ([172.19.198.47]) by mrigmx.server.lan
 (mrigmxus002) with ESMTP (Nemesis) id 0LoHnh-1UKdVq0JDd-00gJyC for
 <linux-ext4@vger.kernel.org>; Thu, 27 Jun 2013 05:05:15 +0200
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,=20
When I use "block_dump" to dump certain block. I got 12288 bytes dumped=
=2E=20
But I checked my block_size, it is 4k.
At debugfs interactive prompt, it says "Dump contents of a block". So I=
 am confused here.=C2=A0
 I read the code, it has=C2=A0 =C2=A0 for (i=3D0; i<current_fs->blocksi=
ze; i+=3D16) ,I don't understand why I can get 12k output.

Also at the beginning of each line. The output pattern is "0000, 0020, =
0040, 0060, 0100, 0120", where are numbers such as"0080,"?

Thanks in advance for any explanation.
=C2=A0
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
