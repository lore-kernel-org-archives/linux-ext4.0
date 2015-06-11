From: Seunghun Lee <waydi1@gmail.com>
Subject: ext4: truncate issue in ext4 encryption.
Date: Thu, 11 Jun 2015 09:08:36 +0900
Message-ID: <5578D184.40808@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:35490 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbbFKAV5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Jun 2015 20:21:57 -0400
Received: by pdbnf5 with SMTP id nf5so47249376pdb.2
        for <linux-ext4@vger.kernel.org>; Wed, 10 Jun 2015 17:21:57 -0700 (PDT)
Received: from [192.168.0.4] ([61.77.65.80])
        by mx.google.com with ESMTPSA id y2sm9623654pdk.67.2015.06.10.17.08.37
        for <linux-ext4@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jun 2015 17:08:38 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I was running fsstress on encrypted ext4 image,
and I hit BUG_ON(blocksize != PAGE_CACHE_SIZE); in __ext4_block_zero_page_range.

It occurs when I'm using filesytem that has small block size(1024 bytes).

reproducible test case and is below.

root@qemux86:~# mount -t ext4 hi.img tmp -o test_dummy_encryption
root@qemux86:~# echo hello > tmp/testfile                                     
root@qemux86:~# echo 2 > /proc/sys/vm/drop_caches
root@qemux86:~# truncate --size 3 tmp/testfile
[  361.108795] ------------[ cut here ]------------
[  361.108990] kernel BUG at fs/ext4/inode.c:3378!
[  361.109080] invalid opcode: 0000 [#1] SMP
[  361.109080] Modules linked in:
[  361.109080] CPU: 0 PID: 1436 Comm: truncate Not tainted 4.1.0-rc4+ #10
[  361.109080] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
[  361.109080] task: ffff88001eb2f5d0 ti: ffff88001e130000 task.ti: ffff88001e130000
[  361.109080] RIP: 0010:[<ffffffff811e94d5>]  [<ffffffff811e94d5>] ext4_block_zero_page_range+0x425/0x430
[  361.109080] RSP: 0018:ffff88001e133d08  EFLAGS: 00000287
[  361.109080] RAX: 0000000000000001 RBX: ffff88001dd4df08 RCX: 000000000000002b
[  361.109080] RDX: 0000000000000000 RSI: ffff88001eb2f5d0 RDI: ffff88001de0ec90
[  361.109080] RBP: ffff88001e133d68 R08: ffff88001e130000 R09: 0000000000000001
[  361.109080] R10: 000000000000bbe2 R11: 0000000000000400 R12: 00000000000003fd
[  361.109080] R13: ffff88001de0ec90 R14: 0000000000000003 R15: ffffea00007eeec0
[  361.109080] FS:  0000000000000000(0000) GS:ffff88001fc00000(0063) knlGS:00000000f770d6c0
[  361.109080] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[  361.109080] CR2: 0000000008181004 CR3: 000000001d975000 CR4: 00000000000006f0
[  361.109080] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  361.109080] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[  361.109080] Stack:
[  361.109080]  ffffffff811eca0d 0000040000000000 0000000000000400 ffff88001dd73810
[  361.109080]  ffff88001e133d78 ffff88001dd4df08 0000000000000004 ffff88001dd73810
[  361.109080]  ffff88001de0ec90 ffff88001de0ede0 0000000000002068 0000000000000000
[  361.109080] Call Trace:
[  361.109080]  [<ffffffff811eca0d>] ? ext4_truncate+0x12d/0x3d0
[  361.109080]  [<ffffffff811ecbfd>] ext4_truncate+0x31d/0x3d0
[  361.109080]  [<ffffffff81124f78>] ? truncate_pagecache+0x58/0x70
[  361.109080]  [<ffffffff811ee560>] ext4_setattr+0x380/0x730
[  361.109080]  [<ffffffff8118444c>] notify_change+0x1ec/0x3a0
[  361.109080]  [<ffffffff81166a98>] do_truncate+0x68/0xa0
[  361.109080]  [<ffffffff81166dfc>] do_sys_ftruncate.constprop.18+0xfc/0x150
[  361.109080]  [<ffffffff81166e79>] SyS_ftruncate+0x9/0x10
[  361.109080]  [<ffffffff8104cd83>] sys32_ftruncate64+0x13/0x20
[  361.109080]  [<ffffffff8189b715>] ia32_do_call+0x13/0x13
[  361.109080] Code: fc ff ff 49 8b b5 18 02 00 00 48 8b 7d b8 e8 23 e9 04 00 89 c3 e9 fe fd ff ff b8 f4 ff ff ff e9 06 fe ff ff 0f 0b e8 9a 4d 6a 00 <0f> 0b 0f 0b 0f 1f 80 00 00 00 00 55 b9 0b 00 00 00 48 89 e5 e8
[  361.109080] RIP  [<ffffffff811e94d5>] ext4_block_zero_page_range+0x425/0x430
[  361.109080]  RSP <ffff88001e133d08>
[  361.116796] ---[ end trace 7f5b0e6b82cd8fc5 ]---
Segmentation fault


Thanks.
