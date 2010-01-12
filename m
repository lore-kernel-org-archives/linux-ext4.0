From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14256] kernel BUG at fs/ext3/super.c:435
Date: Tue, 12 Jan 2010 17:30:55 GMT
Message-ID: <201001121730.o0CHUtJx007171@demeter.kernel.org>
References: <bug-14256-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:54206 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab0ALRaz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Jan 2010 12:30:55 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0CHUtoK007172
	for <linux-ext4@vger.kernel.org>; Tue, 12 Jan 2010 17:30:55 GMT
In-Reply-To: <bug-14256-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14256





--- Comment #21 from carlos.velasco@nimastelecom.com  2010-01-12 17:30:52 ---
I don't see any ld-linux process after make -k check

bash-4.0# ps -ef | grep -i ld-linux
root     13640 18376  0 18:27 ?        00:00:00 grep -i ld-linux

bash-4.0# umount /tmp
[435397.580983] sb orphan head is 14
[435397.595803] sb_info orphan list:
[435397.611165]   inode dm-3:14 at ffff8800c7880d28: mode 100600, nlink 0, next
13
[435397.639671]   inode dm-3:13 at ffff8800df2566e0: mode 100600, nlink 0, next
12
[435397.672072]   inode dm-3:12 at ffff8800df2560b0: mode 100600, nlink 0, next
0
bash-4.0# [435397.672080] ------------[ cut here ]------------
[435397.672082] kernel BUG at fs/ext3/super.c:435!
[435397.672083] invalid opcode: 0000 [#1] SMP 
[435397.672085] last sysfs file: /sys/class/net/bonding_masters
[435397.672086] CPU 2 
[435397.672087] Modules linked in: bonding ipv6 usbhid bnx2 hpilo button
[435397.672092] Pid: 13641, comm: umount Not tainted 2.6.32.3 #1 ProLiant DL360
G6
[435397.672093] RIP: 0010:[<ffffffff8117da53>]  [<ffffffff8117da53>]
ext3_put_super+0x233/0x280
[435397.672099] RSP: 0018:ffff88011cda5e28  EFLAGS: 00010206
[435397.672101] RAX: ffff8800c7880ce0 RBX: ffff88011cd54e00 RCX:
000000000001055f
[435397.672102] RDX: 0000000000004646 RSI: 0000000000000082 RDI:
ffffffff815e6330
[435397.672104] RBP: ffff88011cda5e58 R08: 000000000001055e R09:
ffffffff816dd240
[435397.672105] R10: 0000000000000013 R11: ffffffff816dd240 R12:
ffff88011d13b400
[435397.672106] R13: ffff88011cd54f98 R14: ffff88011cd54f98 R15:
ffff88011d3e1350
[435397.672108] FS:  00007f910e82b730(0000) GS:ffff88002c040000(0000)
knlGS:0000000000000000
[435397.672110] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[435397.672111] CR2: 00007f910dedb32e CR3: 000000011cf65000 CR4:
00000000000006e0
[435397.672112] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[435397.672114] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[435397.672116] Process umount (pid: 13641, threadinfo ffff88011cda4000, task
ffff88011d3e1350)
[435397.672117] Stack:
[435397.672118]  ffff880100000000 ffff88011d13b400 ffff88011d13b400
ffffffff814a4ac0
[435397.672120] <0> ffffffff8163d1b8 ffff88011d13b400 ffff88011cda5e78
ffffffff810f6cd1
[435397.672121] <0> ffff88011f016180 0000000000000003 ffff88011cda5e98
ffffffff810f6d9c
[435397.672124] Call Trace:
[435397.672130]  [<ffffffff810f6cd1>] generic_shutdown_super+0x51/0xf0
[435397.672132]  [<ffffffff810f6d9c>] kill_block_super+0x2c/0x50
[435397.672134]  [<ffffffff810f81fa>] deactivate_super+0x6a/0xf0
[435397.672137]  [<ffffffff81113dce>] mntput_no_expire+0x9e/0xf0
[435397.672140]  [<ffffffff811151ee>] sys_umount+0x5e/0x460
[435397.672143]  [<ffffffff8100baeb>] system_call_fastpath+0x16/0x1b
[435397.672144] Code: c7 41 df 54 81 31 c0 e8 b7 52 30 00 4c 8b b3 98 01 00 00
49 8b 06 4d 39 f5 0f 18 08 75 11 4c 3b ab 98 01 00 00 0f 84 c4 fe ff ff <0f> 0b
eb fe 49 8d 46 80 49 8d 4e 48 48 8b b0 c8 01 00 00 44 8b 
[435397.672158] RIP  [<ffffffff8117da53>] ext3_put_super+0x233/0x280
[435397.672160]  RSP <ffff88011cda5e28>
[435397.682079] ---[ end trace 7a92197c0643be5c ]---
[435397.682080] ------------[ cut here ]------------
[435397.682083] WARNING: at kernel/exit.c:895 do_exit+0x94a/0x9e0()
[435397.682084] Hardware name: ProLiant DL360 G6
[435397.682085] Modules linked in: bonding ipv6 usbhid bnx2 hpilo button
[435397.682088] Pid: 13641, comm: umount Tainted: G      D    2.6.32.3 #1
[435397.682090] Call Trace:
[435397.682093]  [<ffffffff8104c208>] warn_slowpath_common+0x78/0xf0
[435397.682095]  [<ffffffff8104c28f>] warn_slowpath_null+0xf/0x20
[435397.682097]  [<ffffffff81050fba>] do_exit+0x94a/0x9e0
[435397.682100]  [<ffffffff8106ddf1>] ? down_trylock+0x31/0x50
[435397.682104]  [<ffffffff81010305>] oops_end+0x75/0xa0
[435397.682106]  [<ffffffff810108a1>] die+0xd1/0x110
[435397.682108]  [<ffffffff8100d0d4>] do_trap+0xc4/0x170
[435397.682110]  [<ffffffff8100d580>] do_invalid_op+0x90/0xb0
[435397.682112]  [<ffffffff8117da53>] ? ext3_put_super+0x233/0x280
[435397.682114]  [<ffffffff8106ddf1>] ? down_trylock+0x31/0x50
[435397.682117]  [<ffffffff8100c815>] invalid_op+0x15/0x20
[435397.682119]  [<ffffffff8117da53>] ? ext3_put_super+0x233/0x280
[435397.682121]  [<ffffffff8117da97>] ? ext3_put_super+0x277/0x280
[435397.682123]  [<ffffffff810f6cd1>] generic_shutdown_super+0x51/0xf0
[435397.682126]  [<ffffffff810f6d9c>] kill_block_super+0x2c/0x50
[435397.682128]  [<ffffffff810f81fa>] deactivate_super+0x6a/0xf0
[435397.682130]  [<ffffffff81113dce>] mntput_no_expire+0x9e/0xf0
[435397.682132]  [<ffffffff811151ee>] sys_umount+0x5e/0x460
[435397.682134]  [<ffffffff8100baeb>] system_call_fastpath+0x16/0x1b
[435397.682135] ---[ end trace 7a92197c0643be5d ]---


There are many many tests, difficult finding which one.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
