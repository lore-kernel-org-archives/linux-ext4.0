From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: v3.10: unmount won't work
Date: Thu, 16 May 2013 22:45:33 +0200
Message-ID: <5195456D.8030805@gmx.de>
References: <51928CB5.2050406@gmx.de> <5192A8CE.30809@redhat.com> <5195402A.20100@gmx.de> <51954330.1080106@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:62636 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531Ab3EPUph (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 May 2013 16:45:37 -0400
Received: from mailout-de.gmx.net ([10.1.76.17]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MYIEJ-1UymlS2DYH-00VBSs for
 <linux-ext4@vger.kernel.org>; Thu, 16 May 2013 22:45:35 +0200
In-Reply-To: <51954330.1080106@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

=46orget to mention, that now df shows for the loop the same values as =
for / :

n22 ~ # df
=46ilesystem     1K-blocks     Used Available Use% Mounted on
rootfs         188262740 32904632 145771804  19% /
/dev/root      188262740 32904632 145771804  19% /
devtmpfs         4086480        0   4086480   0% /dev
tmpfs            4086744      888   4085856   1% /run
shm              4086744        0   4086744   0% /dev/shm
cgroup_root        10240        0     10240   0% /sys/fs/cgroup
/dev/sdb4      530428688 24466632 505962056   5% /mnt/E
tmpfs            3145728   243872   2901856   8% /mnt/ramdisk
/dev/loop0     188262740 32904632 145771804  19% /mnt/trinity


--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
