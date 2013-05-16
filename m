From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: v3.10: unmount won't work
Date: Thu, 16 May 2013 15:49:04 -0500
Message-ID: <51954640.5050709@redhat.com>
References: <51928CB5.2050406@gmx.de> <5192A8CE.30809@redhat.com> <5195402A.20100@gmx.de> <51954330.1080106@redhat.com> <519544F5.8010703@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751185Ab3EPUtK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 16 May 2013 16:49:10 -0400
In-Reply-To: <519544F5.8010703@gmx.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/16/13 3:43 PM, Toralf F=C3=B6rster wrote:
> On 05/16/2013 10:36 PM, Eric Sandeen wrote:
>> any chance you've got anything crazy going on like mounting the same=
 loop
>> file on 2 machines via an nfs export, or anything else out of the or=
dinary?
>>
> I mount that directory only from 1 UML guest and only once.
> The I run a lot of trinity test in the UML guest suing that share.

which apparently manages to break things - as intended.  ;)

Can you narrow down which syscalls cause the problem?

> After that the UML guest was shutdowned.
> Finally I stoped teh NFS daemon at the host.
> Then I tried to unmount the the drive.
>=20
>> If you mount it and do "find -inum 32017 /mount/point" for each of t=
he inode
>> numbers below, do the files in question have anything unique going o=
n?
>=20
>=20
> n22 ~ # find /mnt/trinity/ -inum 32017
>=20
>=20
> FWIW :
>=20
> n22 ~ # umount /mnt/trinity/
> umount: /mnt/trinity: not mounted

Is this the very first umount call . . . ?

> n22 ~ # grep trinity /etc/mtab /proc/mounts
> /etc/mtab:/dev/loop0 /mnt/trinity ext4 rw 0 0

=2E.. because it seems to already be unmounted, if it's
not in /proc/mounts (though checking for loop0 in /proc/mounts
might be worthwhile too)

-Eric

>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
