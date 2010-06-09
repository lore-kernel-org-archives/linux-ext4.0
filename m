From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16165] Wrong data returned on read after write if file size was
 changed with ftruncate before
Date: Wed, 9 Jun 2010 15:26:31 GMT
Message-ID: <201006091526.o59FQVbq002858@demeter.kernel.org>
References: <bug-16165-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:59538 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790Ab0FIP0d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jun 2010 11:26:33 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o59FQVAw002859
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 9 Jun 2010 15:26:31 GMT
In-Reply-To: <bug-16165-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=3D16165





--- Comment #5 from Alexander Eichner <Alexander.Eichner@sun.com>  2010=
-06-09 15:26:17 ---
Seems the bug doesn't trigger always. The first invocation of the testc=
ase on a
fresh created ext4 succeeds but the second one and any other run fails.
This is what I've done (the mkfs.ext4 output is in german but should be
uninteresting):

alexander@Hatak:~$ sudo mkfs.ext4 /dev/sda1
mke2fs 1.41.11 (14-Mar-2010)
Dateisystem-Label=3D
OS-Typ: Linux
Blockgr=C3=B6=C3=9Fe=3D4096 (log=3D2)
=46ragmentgr=C3=B6=C3=9Fe=3D4096 (log=3D2)
Stride=3D0 blocks, Stripe width=3D0 blocks
1876800 Inodes, 7506363 Bl=C3=B6cke
375318 Bl=C3=B6cke (5.00%) reserviert f=C3=BCr den Superuser
Erster Datenblock=3D0
Maximale Dateisystem-Bl=C3=B6cke=3D4294967296
230 Blockgruppen
32768 Bl=C3=B6cke pro Gruppe, 32768 Fragmente pro Gruppe
8160 Inodes pro Gruppe
Superblock-Sicherungskopien gespeichert in den Bl=C3=B6cken:=20
    32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654=
208,=20
    4096000

Schreibe Inode-Tabellen: erledigt                       =20
Erstelle Journal (32768 Bl=C3=B6cke): erledigt
Schreibe Superbl=C3=B6cke und Dateisystem-Accountinginformationen: erle=
digt

Das Dateisystem wird automatisch nach jeweils 32 Einh=C3=A4ng-Vorg=C3=A4=
ngen bzw.
alle 180 Tage =C3=BCberpr=C3=BCft, je nachdem, was zuerst eintritt. Ver=
=C3=A4nderbar mit
tune2fs -c oder -t .
alexander@Hatak:~$ sudo mount /dev/sda1 /mnt
alexander@Hatak:~$ sudo ./aio_corrupt /mnt/test
Success!
alexander@Hatak:~$ sudo ./aio_corrupt /mnt/test2
Corrupted buffer!

This is with the standard Ubuntu 2.6.32 kernel.

--=20
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=3Demai=
l
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
