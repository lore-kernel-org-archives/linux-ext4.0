From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 89621] EXT4-fs error (device dm-1):
 ext4_mb_release_inode_pa:3773: group 24089, free 34, pa_free 32
Date: Tue, 11 Aug 2015 15:15:01 +0000
Message-ID: <bug-89621-13602-6fGpmsmQCE@https.bugzilla.kernel.org/>
References: <bug-89621-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:40588 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965074AbbHKPPG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Aug 2015 11:15:06 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3AE9A204C9
	for <linux-ext4@vger.kernel.org>; Tue, 11 Aug 2015 15:15:04 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id BC15F205CB
	for <linux-ext4@vger.kernel.org>; Tue, 11 Aug 2015 15:15:01 +0000 (UTC)
In-Reply-To: <bug-89621-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=89621

--- Comment #16 from John Hughes <john@calva.com> ---
Ok, I've now seen the bug while running 3.18.19 (compiled by me straight from
kernel git).

It stayed up for way longer this time :-) but then...

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.18.19-jh1 (john@olympic) (gcc version 4.7.2
(Debian 4.7.2-5) ) #1 SMP Thu Jul 23 14:54:25 CEST 2015
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.18.19-jh1
root=/dev/mapper/olympic-olympic--root ro console=tty0 console=ttyS0,19200n8
quiet
...
[    5.310778] EXT4-fs (dm-0): re-mounted. Opts: errors=remount-ro
[    7.917833] EXT4-fs (vda1): mounting ext3 file system using the ext4
subsystem
[    7.937645] EXT4-fs (vda1): mounted filesystem with ordered data mode. Opts:
errors=remount-ro
[    7.973622] EXT4-fs (dm-2): mounting ext3 file system using the ext4
subsystem
[    8.020501] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts:
errors=remount-ro
[    8.051234] EXT4-fs (dm-3): mounting ext3 file system using the ext4
subsystem
[    8.084443] EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts:
errors=remount-ro
[    8.110174] EXT4-fs: Warning: mounting with data=journal disables delayed
allocation and O_DIRECT support!
[    8.110180] EXT4-fs (dm-4): mounting ext3 file system using the ext4
subsystem
[    8.163955] EXT4-fs (dm-4): mounted filesystem with journalled data mode.
Opts: data=journal,errors=remount-ro
...
[1570311.174406] EXT4-fs (dm-2): pa ffff8800281ac980: logic 0, phys. 1351168,
len 512
[1570311.176802] EXT4-fs error (device dm-2): ext4_mb_release_inode_pa:3773:
group 41, free 431, pa_free 430
[1570311.179413] Aborting journal on device dm-2-8.
[1570311.199091] EXT4-fs (dm-2): Remounting filesystem read-only


On reboot the system complained about dm-2 being bad:

[    9.196972] EXT4-fs (dm-2): mounting ext3 file system using the ext4
subsystem
[   10.134032] EXT4-fs warning (device dm-2): ext4_clear_journal_err:4659:
Filesystem error recorded from previous mount: IO failure
[   10.136694] EXT4-fs warning (device dm-2): ext4_clear_journal_err:4660:
Marking fs in need of filesystem check.
[   10.158051] EXT4-fs (dm-2): warning: mounting fs with errors, running e2fsck
is recommended
[   10.171173] EXT4-fs (dm-2): Errors on filesystem, clearing orphan list.
[   10.171173]
[   10.173578] EXT4-fs (dm-2): recovery complete
[   10.188013] EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts:
errors=remount-ro


So I unmounted it and did a fsck:

Script started on Tue Aug 11 16:54:56 2015
root@olympic:~# fsck -y -f /dev/mapper/olympic-olympic--home 
fsck from util-linux 2.20.1
e2fsck 1.42.5 (29-Jul-2012)
Pass 1: Checking inodes, blocks, and sizes
Inodes that were part of a corrupted orphan linked list found.  Fix? yes

Inode 3827814 was part of the orphaned inode list.  FIXED.
Deleted inode 3828431 has zero dtime.  Fix? yes

Inode 4137318 was part of the orphaned inode list.  FIXED.
Inode 4137485 was part of the orphaned inode list.  FIXED.
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
Block bitmap differences:  -(723856--723871) -(738144--738172) +1351589
-7897632 -(7926715--7926730) -(11616272--11616287) -(11627328--11627356)
-18842491 -(18846824--18846839) -29065743 -(29093767--29093782) -32965419
-(32983830--32983845) -(36864912--36864919) -(36965200--36965204)
Fix? yes

Free blocks count wrong for group #22 (27818, counted=27863).
Fix? yes

Free blocks count wrong for group #241 (25273, counted=25290).
Fix? yes

Free blocks count wrong for group #354 (23179, counted=23224).
Fix? yes

Free blocks count wrong for group #575 (25214, counted=25231).
Fix? yes

Free blocks count wrong for group #887 (24494, counted=24511).
Fix? yes

Free blocks count wrong for group #1006 (21249, counted=21266).
Fix? yes

Free blocks count wrong for group #1125 (25845, counted=25853).
Fix? yes

Free blocks count wrong for group #1128 (28938, counted=28943).
Fix? yes

Free blocks count wrong (22597710, counted=22597881).
Fix? yes

Inode bitmap differences:  -3827814 -3828431 -4137318 -4137485
Fix? yes

Free inodes count wrong for group #467 (5325, counted=5327).
Fix? yes

Free inodes count wrong for group #505 (6985, counted=6987).
Fix? yes

Free inodes count wrong (9975485, counted=9975489).
Fix? yes


olympic-home: ***** FILE SYSTEM WAS MODIFIED *****
olympic-home: 510271/10485760 files (13.1% non-contiguous), 19345159/41943040
blocks
root@olympic:~# exit

Script done on Tue Aug 11 17:01:11 2015

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
