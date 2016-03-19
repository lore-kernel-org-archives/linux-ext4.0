From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 102731] I have a cough.
Date: Sat, 19 Mar 2016 17:49:56 +0000
Message-ID: <bug-102731-13602-f35mbIySQo@https.bugzilla.kernel.org/>
References: <bug-102731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40968 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933455AbcCSRuB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Mar 2016 13:50:01 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 84DC3200CC
	for <linux-ext4@vger.kernel.org>; Sat, 19 Mar 2016 17:49:59 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 85998202BE
	for <linux-ext4@vger.kernel.org>; Sat, 19 Mar 2016 17:49:56 +0000 (UTC)
In-Reply-To: <bug-102731-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D102731

--- Comment #40 from Vaclav Ovsik <vaclav.ovsik@gmail.com> ---
Issue attributes should be changed. This is not about filesystem in VM.=
 The
colleague had fail with btrfs in VM too...


-------- P=C5=99eposlan=C3=A1 zpr=C3=A1va --------
P=C5=99edm=C4=9Bt:     [logcheck] ttrss.home.nahorany.net 2016-03-11 15=
:00 +0100 Security
Events
Datum:     Fri, 11 Mar 2016 15:00:16 +0100 (CET)
Od:     logcheck system account <logcheck@home.nahorany.net>
Komu:     centrino@nahorany.net



Security Events for kernel
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-
Mar 11 14:41:06 ttrss kernel: [2816393.980768] end_request: I/O error, =
dev vda,
sector 2195232
Mar 11 14:41:06 ttrss kernel: [2816393.980768] end_request: I/O error, =
dev vda,
sector 2198280
Mar 11 14:41:06 ttrss kernel: [2816393.980768] end_request: I/O error, =
dev vda,
sector 2973336
Mar 11 14:41:06 ttrss kernel: [2816393.980768] end_request: I/O error, =
dev vda,
sector 3351896
Mar 11 14:41:06 ttrss kernel: [2816393.980768] end_request: I/O error, =
dev vda,
sector 2198280
Mar 11 14:41:06 ttrss kernel: [2816393.980768] end_request: I/O error, =
dev vda,
sector 2973336
Mar 11 14:41:06 ttrss kernel: [2816393.980768] end_request: I/O error, =
dev vda,
sector 3351896

System Events
=3D-=3D-=3D-=3D-=3D-=3D-=3D
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80Mar
11 14:41:36 ttrss sshd[23130]: Received disconnect from 172.16.0.22: 11=
:
disconnected by user
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=C2=80=
=C2=80=C2=80Mar
11 14:41:06 ttrss kernel: [2816393.980768] end_request: I/O error, dev =
vda,
sector 2195232
Mar 11 14:23:32 ttrss ansible-command: Invoked with warn=3DTrue executa=
ble=3DNone
chdir=3DNone _raw_params=3Dapt-get update removes=3DNone creates=3DNone
_uses_shell=3DFalse
Mar 11 14:25:14 ttrss ansible-command: Invoked with warn=3DTrue executa=
ble=3DNone
chdir=3DNone _raw_params=3Dapt-get upgrade -y removes=3DNone creates=3D=
None
_uses_shell=3DFalse
Mar 11 14:39:19 ttrss kernel: [2816286.989244] device-mapper: uevent: v=
ersion
1.0.3
Mar 11 14:39:19 ttrss kernel: [2816287.638040] device-mapper: ioctl:
4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
Mar 11 14:39:19 ttrss kernel: [2816286.989244] device-mapper: uevent: v=
ersion
1.0.3
Mar 11 14:39:19 ttrss kernel: [2816287.638040] device-mapper: ioctl:
4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
Mar 11 14:39:26 ttrss kernel: [2816295.076906] SGI XFS with ACLs, secur=
ity
attributes, realtime, large block/inode numbers, no debug enabled
Mar 11 14:39:26 ttrss kernel: [2816295.076906] SGI XFS with ACLs, secur=
ity
attributes, realtime, large block/inode numbers, no debug enabled
Mar 11 14:39:27 ttrss kernel: [2816295.173689] JFS: nTxBlock =3D 1938, =
nTxLock =3D
15510
Mar 11 14:39:27 ttrss kernel: [2816295.414255] ntfs: driver 2.1.30 [Fla=
gs: R/W
MODULE].
Mar 11 14:39:27 ttrss kernel: [2816295.721879] QNX4 filesystem 0.2.3
registered.
Mar 11 14:39:27 ttrss kernel: [2816295.173689] JFS: nTxBlock =3D 1938, =
nTxLock =3D
15510
Mar 11 14:39:27 ttrss kernel: [2816295.414255] ntfs: driver 2.1.30 [Fla=
gs: R/W
MODULE].
Mar 11 14:39:27 ttrss kernel: [2816295.721879] QNX4 filesystem 0.2.3
registered.
Mar 11 14:39:28 ttrss kernel: [2816296.129309] fuse init (API version 7=
=2E23)
Mar 11 14:39:28 ttrss kernel: [2816296.129309] fuse init (API version 7=
=2E23)
Mar 11 14:39:28 ttrss os-prober: debug: /dev/vda1: is active swap
Mar 11 14:39:29 ttrss ansible-command: Invoked with warn=3DTrue executa=
ble=3DNone
chdir=3DNone _raw_params=3Dapt-get -y upgrade removes=3DNone creates=3D=
None
_uses_shell=3DFalse
Mar 11 14:41:06 ttrss kernel: [2816393.980768] BTRFS: bdev /dev/vda2 er=
rs: wr
1, rd 0, flush 0, corrupt 0, gen 0
Mar 11 14:41:06 ttrss kernel: [2816393.980768] BTRFS: bdev /dev/vda2 er=
rs: wr
2, rd 0, flush 0, corrupt 0, gen 0
Mar 11 14:41:06 ttrss kernel: [2816393.980768] BTRFS: bdev /dev/vda2 er=
rs: wr
3, rd 0, flush 0, corrupt 0, gen 0
Mar 11 14:41:06 ttrss kernel: [2816393.980768] BTRFS: bdev /dev/vda2 er=
rs: wr
4, rd 0, flush 0, corrupt 0, gen 0
Mar 11 14:41:06 ttrss kernel: [2816393.980768] BTRFS: bdev /dev/vda2 er=
rs: wr
1, rd 0, flush 0, corrupt 0, gen 0
Mar 11 14:41:06 ttrss kernel: [2816393.980768] BTRFS: bdev /dev/vda2 er=
rs: wr
2, rd 0, flush 0, corrupt 0, gen 0
Mar 11 14:41:06 ttrss kernel: [2816393.980768] BTRFS: bdev /dev/vda2 er=
rs: wr
3, rd 0, flush 0, corrupt 0, gen 0
Mar 11 14:41:06 ttrss kernel: [2816393.980768] BTRFS: bdev /dev/vda2 er=
rs: wr
4, rd 0, flush 0, corrupt 0, gen 0
Mar 11 14:45:30 ttrss ansible-command: Invoked with warn=3DTrue executa=
ble=3DNone
chdir=3DNone _raw_params=3Dapt-get -y upgrade removes=3DNone creates=3D=
None
_uses_shell=3DFalse

--=20
Zito

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
