From: LuVar <luvar@plaintext.sk>
Subject: ext4 unknown problem
Date: Mon, 30 Jul 2012 20:26:20 +0100 (GMT+01:00)
Message-ID: <361097150.179261343676380170.JavaMail.root@shiva>
References: <805800905.179241343676287217.JavaMail.root@shiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: info <info@plaintext.sk>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.plaintext.sk ([81.0.124.6]:51228 "EHLO shiva.plaintext.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab2G3Tfw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 30 Jul 2012 15:35:52 -0400
In-Reply-To: <805800905.179241343676287217.JavaMail.root@shiva>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
I have seriouse issue here. I have copyied about 7GB files to one of my=
 ext4 partitions and from that point of time there is sustained write t=
o that partition from jbd2/dm-3-8 process. I have lunched "sudo sync" c=
ommand (about day ago :) and a few hours a after sync start, I have try=
ied to use umount on that partition... Booth of them are still running.=
=2E.

I have no serious data there, but if I could be helpfull in bugreport, =
give me some info what to do.

# uname -a
Linux blacktroja 3.2.12-gentoo #1 SMP Wed Jun 27 15:09:02 CEST 2012 x86=
_64 Intel(R) Core(TM) i7 CPU 930 @ 2.80GHz GenuineIntel GNU/Linux

# df -h /var/lib/mpd/music/local
S=C3=BAborov=C3=BD syst=C3=A9m       Ve=C4=BEk  Pou=C5=BE  Dost Pou% Pr=
ipojen=C3=BD na
/dev/mapper/vg-music   24G   17G  5,8G  75% /var/lib/mpd/music/local

I am ready to do anything with current state of that partition to provi=
de valuable informations for development.

PS: that partition is on top of lvm which is on top of sw raid (mdraid)=
 level 5.

Bye,
--
LuVar
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
