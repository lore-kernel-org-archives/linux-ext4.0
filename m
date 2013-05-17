From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
Subject: Re: v3.10: unmount won't work
Date: Fri, 17 May 2013 20:08:49 +0200
Message-ID: <51967231.1040509@gmx.de>
References: <51928CB5.2050406@gmx.de> <5192A8CE.30809@redhat.com> <5195402A.20100@gmx.de> <51954330.1080106@redhat.com> <519544F5.8010703@gmx.de> <51954640.5050709@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:57999 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315Ab3EQSIx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 May 2013 14:08:53 -0400
Received: from mailout-de.gmx.net ([10.1.76.1]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0M0vpJ-1UMi9E49qp-00v5UP for
 <linux-ext4@vger.kernel.org>; Fri, 17 May 2013 20:08:52 +0200
In-Reply-To: <51954640.5050709@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 05/16/2013 10:49 PM, Eric Sandeen wrote:
> On 5/16/13 3:43 PM, Toralf F=C3=B6rster wrote:
>> On 05/16/2013 10:36 PM, Eric Sandeen wrote:
>>> any chance you've got anything crazy going on like mounting the sam=
e loop
>>> file on 2 machines via an nfs export, or anything else out of the o=
rdinary?
>>>
>> I mount that directory only from 1 UML guest and only once.
>> The I run a lot of trinity test in the UML guest suing that share.
>=20
> which apparently manages to break things - as intended.  ;)

yes - I'm calling for trouble and I get it - but by this (uncommon) sce=
nario few real NFSv4 and UML bugs were found.

> Can you narrow down which syscalls cause the problem?

Till now not to a single one (would be nice, I know).
Currently I observed that issue not with host kernel 3.9, but with host=
 kernel 3.10-rc1.
=46urthermore on the UML guest trinity has to be run long enough (hours=
) to produce warnings like :
# zgrep "v4 server returned" /var/log/messages* | cut -f3- -d' '
kernel: NFS: v4 server returned a bad sequence-id error on an unconfirm=
ed sequence 0c6a41f0!
kernel: NFS: v4 server returned a bad sequence-id error on an unconfirm=
ed sequence 3fe4fa60!
kernel: NFS: v4 server returned a bad sequence-id error on an unconfirm=
ed sequence 4143f790!
kernel: NFS: v4 server returned a bad sequence-id error on an unconfirm=
ed sequence 48f401f0!
=2E..

> Is this the very first umount call . . . ?

yes, before that probably the NFS service was either restarted or just =
halted.

--=20
MfG/Sincerely
Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
