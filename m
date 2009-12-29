From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Tue, 29 Dec 2009 13:18:06 GMT
Message-ID: <200912291318.nBTDI6el017549@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:57940 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbZL2NSH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Dec 2009 08:18:07 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id nBTDI6uc017550
	for <linux-ext4@vger.kernel.org>; Tue, 29 Dec 2009 13:18:06 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256


carlos.velasco@nimastelecom.com changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |carlos.velasco@nimastelecom
                   |                            |.com




--- Comment #17 from carlos.velasco@nimastelecom.com  2009-12-29 13:18:03 ---
I have reproduced the exact same problem in a new LFS system using 2.6.32.2
kernel.

The bug is definitely triggered but issuing a "make check" of eglibc before a
reboot. You do not need to install it or just build it, whatever triggers this
bug is related to something that eglibc makes during tests.

---

brw-rw---- 1 root disk 253, 3 Dec 29  2009 /dev/dm-3

brw-------  1 root root 253,  3 Dec 29  2009 LV0-tmp


Unmounting all other currently mounted file systems...
/etc/rc.d/rc6.d/S70mountfs: line 18: 22979 Segmentation fault      umount -a -d
-r > /dev/null
[ FAIL ]


[  903.074244] sb orphan head is 13
[  903.088507] sb_info orphan list:
[  903.102590]   inode dm-3:13 at ffff880114948a10: mode 100600, nlink 0, next
12
[  903.131992]   inode dm-3:12 at ffff880114907340: mode 100600, nlink 0, next
0
[  903.149056] ------------[ cut here ]------------
[  903.149057] kernel BUG at fs/ext3/super.c:435!
[  903.149058] invalid opcode: 0000 [#1] SMP 
[  903.149060] last sysfs file: /sys/class/net/bonding_masters
[  903.149061] CPU 2 
[  903.149062] Modules linked in: bonding ipv6 bnx2 usbhid button hpilo
[  903.149067] Pid: 22979, comm: umount Not tainted 2.6.32.2 #1 ProLiant DL360
G6
[  903.149068] RIP: 0010:[<ffffffff8117d883>]  [<ffffffff8117d883>]
ext3_put_super+0x233/0x280
[  903.149075] RSP: 0018:ffff88011cd6be28  EFLAGS: 00010202
[  903.149076] RAX: ffff8801149489c8 RBX: ffff88011d857e00 RCX:
ffffffff815e0800
[  903.149077] RDX: 00000000007f3f13 RSI: 0000000000000046 RDI:
ffffffff816dc130
[  903.149078] RBP: ffff88011cd6be58 R08: 0000000000000000 R09:
0000000000000001
[  903.149080] R10: 0000000000000000 R11: 000000000e200000 R12:
ffff88011d3db400
[  903.149081] R13: ffff88011d857f98 R14: ffff88011d857f98 R15:
ffff88011d0cc060
[  903.149083] FS:  00007f9f88456730(0000) GS:ffff88002c040000(0000)
knlGS:0000000000000000
[  903.149084] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  903.149086] CR2: 00007f9f8845c000 CR3: 000000011dc84000 CR4:
00000000000006e0
[  903.149087] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  903.149088] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[  903.149090] Process umount (pid: 22979, threadinfo ffff88011cd6a000, task
ffff88011d0cc060)
[  903.149091] Stack:
[  903.149092]  ffff880100000000 ffff88011d3db400 ffff88011d3db400
ffffffff814a4ac0
[  903.149094] <0> ffffffff8163d1b8 ffff88011d3db400 ffff88011cd6be78
ffffffff810f6cc1
[  903.149096] <0> ffff88011f29de40 0000000000000003 ffff88011cd6be98
ffffffff810f6d8c
[  903.149098] Call Trace:
[  903.149104]  [<ffffffff810f6cc1>] generic_shutdown_super+0x51/0xf0
[  903.149106]  [<ffffffff810f6d8c>] kill_block_super+0x2c/0x50
[  903.149109]  [<ffffffff810f81ea>] deactivate_super+0x6a/0xf0
[  903.149112]  [<ffffffff81113d6e>] mntput_no_expire+0x9e/0xf0
[  903.149114]  [<ffffffff8111518e>] sys_umount+0x5e/0x460
[  903.149117]  [<ffffffff8100baeb>] system_call_fastpath+0x16/0x1b
[  903.149118] Code: c7 b1 de 54 81 31 c0 e8 3c 4d 30 00 4c 8b b3 98 01 00 00
49 8b 06 4d 39 f5 0f 18 08 75 11 4c 3b ab 98 01 00 00 0f 84 c4 fe ff ff <0f> 0b
eb fe 49 8d 46 80 49 8d 4e 48 48 8b b0 c8 01 00 00 44 8b 
[  903.149131] RIP  [<ffffffff8117d883>] ext3_put_super+0x233/0x280
[  903.149134]  RSP <ffff88011cd6be28>
[  903.159165] ---[ end trace 3ed92bd591190341 ]---
[  903.159166] ------------[ cut here ]------------
[  903.159169] WARNING: at kernel/exit.c:895 do_exit+0x94a/0x9e0()
[  903.159170] Hardware name: ProLiant DL360 G6
[  903.159171] Modules linked in: bonding ipv6 bnx2 usbhid button hpilo
[  903.159175] Pid: 22979, comm: umount Tainted: G      D    2.6.32.2 #1
[  903.159176] Call Trace:
[  903.159179]  [<ffffffff8104c218>] warn_slowpath_common+0x78/0xf0
[  903.159181]  [<ffffffff8104c29f>] warn_slowpath_null+0xf/0x20
[  903.159183]  [<ffffffff81050fca>] do_exit+0x94a/0x9e0
[  903.159187]  [<ffffffff8106de01>] ? down_trylock+0x31/0x50
[  903.159190]  [<ffffffff81010305>] oops_end+0x75/0xa0
[  903.159192]  [<ffffffff810108a1>] die+0xd1/0x110
[  903.159194]  [<ffffffff8100d0d4>] do_trap+0xc4/0x170
[  903.159196]  [<ffffffff8100d580>] do_invalid_op+0x90/0xb0
[  903.159198]  [<ffffffff8117d883>] ? ext3_put_super+0x233/0x280
[  903.159200]  [<ffffffff8100c815>] invalid_op+0x15/0x20
[  903.159203]  [<ffffffff8117d883>] ? ext3_put_super+0x233/0x280
[  903.159205]  [<ffffffff8117d8c7>] ? ext3_put_super+0x277/0x280
[  903.159207]  [<ffffffff810f6cc1>] generic_shutdown_super+0x51/0xf0
[  903.159209]  [<ffffffff810f6d8c>] kill_block_super+0x2c/0x50
[  903.159211]  [<ffffffff810f81ea>] deactivate_super+0x6a/0xf0
[  903.159213]  [<ffffffff81113d6e>] mntput_no_expire+0x9e/0xf0
[  903.159215]  [<ffffffff8111518e>] sys_umount+0x5e/0x460
[  903.159217]  [<ffffffff8100baeb>] system_call_fastpath+0x16/0x1b
[  903.159218] ---[ end trace 3ed92bd591190342 ]---

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
