From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: v3.10: unmount won't work
Date: Thu, 16 May 2013 22:43:33 +0200
Message-ID: <519544F5.8010703@gmx.de>
References: <51928CB5.2050406@gmx.de> <5192A8CE.30809@redhat.com> <5195402A.20100@gmx.de> <51954330.1080106@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:61643 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185Ab3EPUnh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 May 2013 16:43:37 -0400
Received: from mailout-de.gmx.net ([10.1.76.28]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0MLUcO-1UddFl3HWM-000ZZp for
 <linux-ext4@vger.kernel.org>; Thu, 16 May 2013 22:43:35 +0200
In-Reply-To: <51954330.1080106@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/16/2013 10:36 PM, Eric Sandeen wrote:
> any chance you've got anything crazy going on like mounting the same =
loop
> file on 2 machines via an nfs export, or anything else out of the ord=
inary?
>=20
I mount that directory only from 1 UML guest and only once.
The I run a lot of trinity test in the UML guest suing that share.
After that the UML guest was shutdowned.
=46inally I stoped teh NFS daemon at the host.
Then I tried to unmount the the drive.

> If you mount it and do "find -inum 32017 /mount/point" for each of th=
e inode
> numbers below, do the files in question have anything unique going on=
?


n22 ~ # find /mnt/trinity/ -inum 32017


=46WIW :

n22 ~ # umount /mnt/trinity/
umount: /mnt/trinity: not mounted

n22 ~ # grep trinity /etc/mtab /proc/mounts
/etc/mtab:/dev/loop0 /mnt/trinity ext4 rw 0 0



--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
