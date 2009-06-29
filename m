From: =?UTF-8?Q?Krzysztof_Kosi=C5=84ski?= <tweenk.pl@gmail.com>
Subject: Massive corruption on RAID0
Date: Mon, 29 Jun 2009 02:38:10 +0200
Message-ID: <298610bb0906281738u2e1ce91fnc753acc145d759bb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:60525 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759569AbZF2AiJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 28 Jun 2009 20:38:09 -0400
Received: by fxm18 with SMTP id 18so683770fxm.37
        for <linux-ext4@vger.kernel.org>; Sun, 28 Jun 2009 17:38:11 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello

Here is my story: I recently migrated a server from Windows to Ubuntu
9.04. I formatted all disks with ext4. The server has 5 disks: three
SCSI (9GB for /, 2x18GB for /data/small and /home) and two IDE
(2x300GB). I put the IDE disks in a RAID0: each had a single partition
with type set to "fd", and the entire resulting device (/dev/md0) was
formatted with ext4 as:

mkfs.ext4 -b 4096 -E stride=3D16 /dev/md0

All was well until a power outage that left the filesystem on /dev/md0
unmountable (the others were fine after an fsck). I made a backup of
the corrupted array to another disk and ran fsck, but it ended up in
an infinite loop. After some unsuccessful tinkering, I restored the
backup and found out that large portions of the group descriptor table
are filled with random junk. Moreover, all backup superblocks are
either corrupted or zeroed, and I found partial copies of an
identically corrupted table at various weird offsets (including
176888, 600344, 1036536, 1462520, 1887256 and 5326832); neither of
these copies were preceded by anything resembling a superblock. Here
is a copy of first 39 blocks of the corrupted disk:
http://tweenk.artfx.pl/super.bin

The group descriptors that are not filled with random junk all follow
a simple pattern, but filling the group descriptor table with with an
extension of it didn't yield anything interesting. A smartctl check
revealed that one of the disks forming the array has
Reallocated_Sector_Ct =3D 17 and Reallocated_Event_Count =3D 1
(coincidentally, 17 is also the number of backup superblocks this
device should have), the other has zero; however, this doesn't explain
the massive corruption.

Regards, Krzysztof Kosi=C5=84ski

PS Please CC replies to me as I'm not subscribed
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
