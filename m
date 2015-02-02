From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 92271] Provide a way to really delete files, please
Date: Mon, 02 Feb 2015 11:13:06 +0000
Message-ID: <bug-92271-13602-HKOEU3CSg3@https.bugzilla.kernel.org/>
References: <bug-92271-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:55371 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754848AbbBBLNL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Feb 2015 06:13:11 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 939FD201F4
	for <linux-ext4@vger.kernel.org>; Mon,  2 Feb 2015 11:13:09 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id CF65120212
	for <linux-ext4@vger.kernel.org>; Mon,  2 Feb 2015 11:13:06 +0000 (UTC)
In-Reply-To: <bug-92271-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D92271

--- Comment #20 from Alexander Holler <holler@ahsoftware.de> ---
My proof of concepts now works for fat and ext4 (just by overwriting bl=
ocks w/o
secure_trim, but that's not necessary for the proof):

=3D=3D=3D=3D=3D
laptopahbt ~ # dd if=3D/dev/zero of=3D/tmp/test.img bs=3D1M count=3D50
50+0 Datens=C3=A4tze ein
50+0 Datens=C3=A4tze aus
52428800 Bytes (52 MB) kopiert, 0,0372579 s, 1,4 GB/s
laptopahbt ~ # mkfs.ext4 /tmp/test.img                =20
mke2fs 1.42.10 (18-May-2014)
Bl=C3=B6cke des Ger=C3=A4tes werden verworfen: erledigt                =
       =20
Creating filesystem with 51200 1k blocks and 12824 inodes
=46ilesystem UUID: fece1e42-07d5-449f-be29-650a8514648b
Superblock-Sicherungskopien gespeichert in den Bl=C3=B6cken:=20
        8193, 24577, 40961

Platz f=C3=BCr Gruppentabellen wird angefordert: erledigt              =
         =20
Inode-Tabellen werden geschrieben: erledigt                       =20
Erstelle Journal (4096 Bl=C3=B6cke): erledigt
Schreibe Superbl=C3=B6cke und Dateisystem-Accountinginformationen: erle=
digt

laptopahbt ~ # grep -a akrakadabra /tmp/test.img=20
laptopahbt ~ # mount -o loop /tmp/test.img /mnt/
laptopahbt ~ # echo akrakadabra >/mnt/foo.txt
laptopahbt ~ # umount /mnt/
laptopahbt ~ # grep -a akrakadabra /tmp/test.img=20
=EF=BF=BD@@#=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=E2=96=92=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD7((=EF=BF=BD=E2=96=92=EF=BF=BD=EF=BF=BD=EF=
=BF=BD((=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD7((+Q=EF=BF=BD=EF=BF=BD~ ((=
s=EF=BF=BD=EF=BF=BDc7((i=EF=BF=BD=EF=BF=BD=EF=BF=BDH=EF=BF=BD((=EF=BF=BD=
1akrakadabra
laptopahbt ~ # mount -o loop /tmp/test.img /mnt/
laptopahbt ~ # rm -s /mnt/foo.txt=20
laptopahbt ~ # umount /mnt/
laptopahbt ~ # grep -a akrakadabra /tmp/test.img=20
laptopahbt ~ # mount -o loop /tmp/test.img /mnt/
laptopahbt ~ # echo akrakadabra >/mnt/foo.txt
laptopahbt ~ # umount /mnt/
laptopahbt ~ # mount -o loop /tmp/test.img /mnt/
laptopahbt ~ # rm /mnt/foo.txt=20
laptopahbt ~ # umount /mnt/
laptopahbt ~ # grep -a akrakadabra /tmp/test.img=20
=EF=BF=BD@@#=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=E2=96=92=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD7((=EF=BF=BD=E2=96=92=EF=BF=BD=EF=BF=BD=EF=
=BF=BD((=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD7((+Q=EF=BF=BD=EF=BF=BD~ ((=
s=EF=BF=BD=EF=BF=BDc7((i=EF=BF=BD=EF=BF=BD=EF=BF=BDH=EF=BF=BD((=EF=BF=BD=
1akrakadabra
laptopahbt ~ # cd /usr/src/linux
laptopahbt linux # PAGER=3D git diff --stat HEAD~5
 arch/x86/syscalls/syscall_32.tbl      |  1 +
 arch/x86/syscalls/syscall_64.tbl      |  1 +
 fs/ext4/ext4.h                        |  2 ++
 fs/ext4/mballoc.c                     | 21 ++++++++++++++++++++-
 fs/ext4/super.c                       | 10 ++++++++++
 fs/fat/fat.h                          |  1 +
 fs/fat/fatent.c                       | 17 +++++++++++++++++
 fs/fat/inode.c                        | 14 ++++++++++++++
 fs/namei.c                            | 35 +++++++++++++++++++++++++++=
+++-----
 include/asm-generic/audit_dir_write.h |  1 +
 include/linux/fs.h                    |  1 +
 include/linux/syscalls.h              |  1 +
 include/uapi/asm-generic/unistd.h     |  4 +++-
 tools/perf/builtin-trace.c            |  2 ++
 14 files changed, 104 insertions(+), 7 deletions(-)
=3D=3D=3D=3D=3D

Most changes are to add the new syscall unlinkat_s(), the changes for f=
at and
ext4 itself are pretty small.

Will post patches when I've found the time to make them such, that I do=
n't end
up again in silly discussions.

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
