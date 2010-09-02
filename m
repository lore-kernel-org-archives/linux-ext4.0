From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15349] kernel BUG at fs/ext4/inode.c:1853!
Date: Thu, 2 Sep 2010 12:40:39 GMT
Message-ID: <201009021240.o82CedCD013788@demeter1.kernel.org>
References: <bug-15349-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:37770 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab0IBMkq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 2 Sep 2010 08:40:46 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id o82CejPj013797
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 2 Sep 2010 12:40:45 GMT
In-Reply-To: <bug-15349-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=15349


Tobias Matzat <tobiasmatzat@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tobiasmatzat@gmail.com




--- Comment #1 from Tobias Matzat <tobiasmatzat@gmail.com>  2010-09-02 12:39:21 ---
Hi,

I have a similar bug message in my kernel log. It occurs on a DELL R710 that is
acting as an FTP server:

Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.363908] ------------[
cut here ]------------
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.363920] kernel BUG at
/usr/src/packages/BUILD/kernel-desktop-2.6.31.12/linux-2.6.31/fs/ext4/inode.c:1853!
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.363929] invalid opcode:
0000 [#1] PREEMPT SMP 
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.363936] last sysfs file:
/sys/devices/system/cpu/cpu7/cache/index2/shared_cpu_map
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.363943] CPU 4 
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.363947] Modules linked
in: af_packet iptable_filter ip_tables x_tables edd bonding fuse loop dm_mod
sr_mod iTCO_wdt ses joydev bnx2 serio_raw iTCO_vendor_support pcspkr cdrom
dcdbas button enclosure sg ext4 jbd2 crc16 fan processor pata_acpi thermal
thermal_sys megaraid_sas
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.363984] Pid: 29290,
comm: pure-ftpd Not tainted 2.6.31.12-0.1-desktop #1 PowerEdge R710
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.363991] RIP:
0010:[<ffffffffa0076055>]  [<ffffffffa0076055>] T.965+0x1e5/0x1f0 [ext4]
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364014] RSP:
0018:ffff8800c416b828  EFLAGS: 00010287
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364019] RAX:
000000000000001f RBX: ffff88011dc508d0 RCX: 0000000000000154
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364025] RDX:
0000000000000020 RSI: 000000000000001f RDI: 0000000000000153
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364032] RBP:
ffff8800c416b878 R08: 0000000000000001 R09: ffff880227c7e270
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364038] R10:
0000000000000000 R11: ffff880081012268 R12: ffff88011dc50830
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364044] R13:
000000000000001f R14: 0000000000386fd1 R15: ffff88011dc50b98
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364051] FS: 
00007f19f911b710(0000) GS:ffff8800090ba000(0000) knlGS:0000000000000000
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364058] CS:  0010 DS:
0000 ES: 0000 CR0: 000000008005003b
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364063] CR2:
00007fff79663000 CR3: 00000000379e4000 CR4: 00000000000006e0
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364070] DR0:
0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364076] DR3:
0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364082] Process
pure-ftpd (pid: 29290, threadinfo ffff8800c416a000, task ffff8800c416c2c0)
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364089] Stack:
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364093] 
0000000000386fd1 ffff88022cb5a000 000000001dc50830 00000000a63357c2
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364099] <0>
0000000000000000 ffff880081012268 ffffffffffff0000 ffff88011dc508d0
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364108] <0>
0000000000386fd1 0000000000000000 ffff8800c416b8b8 ffffffffa0079080
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364119] Call Trace:
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364143] 
[<ffffffffa0079080>] ext4_da_get_block_prep+0xe0/0x120 [ext4]
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364161] 
[<ffffffff8117da69>] __block_prepare_write+0x1d9/0x5f0
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364172] 
[<ffffffff8117e072>] block_write_begin+0x72/0x120
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364188] 
[<ffffffffa007bc3d>] ext4_da_write_begin+0x14d/0x2d0 [ext4]
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364205] 
[<ffffffff81100e75>] generic_perform_write+0xc5/0x220
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364215] 
[<ffffffff81101060>] generic_file_buffered_write+0x90/0x160
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364224] 
[<ffffffff8110181f>] __generic_file_aio_write_nolock+0x28f/0x4d0
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364234] 
[<ffffffff81101bbf>] generic_file_aio_write+0x7f/0x110
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364250] 
[<ffffffffa0070598>] ext4_file_write+0x58/0x190 [ext4]
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364261] 
[<ffffffff8114bd22>] do_sync_write+0x102/0x160
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364269] 
[<ffffffff8114c0a8>] vfs_write+0xd8/0x1c0
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364277] 
[<ffffffff8114ca3b>] sys_write+0x5b/0xa0
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364287] 
[<ffffffff8100c682>] system_call_fastpath+0x16/0x1b
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364297] 
[<00007f19f7a9ab10>] 0x7f19f7a9ab10
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364302] Code: 84 00 00
00 00 00 4c 89 ff e8 f8 06 4e e1 41 83 84 24 58 03 00 00 01 45 01 ac 24 5c 03
00 00 4c 89 ff e8 0f 0b 4e e1 31 c0 eb b0 <0f> 0b eb fe 0f 1f 80 00 00 00 00 55
48 89 e5 41 57 41 56 41 55 
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364347] RIP 
[<ffffffffa0076055>] T.965+0x1e5/0x1f0 [ext4]
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364362]  RSP
<ffff8800c416b828>
Sep  2 09:42:51 movie2me-viasat-london kernel: [864018.364368] ---[ end trace
98ba3823ba5a95cf ]---

As soon as the error message occurs the system has to be restarted.

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
