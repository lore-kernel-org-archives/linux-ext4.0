From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: ext4 -next: Oops at ext4_fill_super()
Date: Fri, 5 Dec 2014 00:23:22 +0900
Message-ID: <20141204152322.GA1123@swordfish>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:38391 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbaLDPWr (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Dec 2014 10:22:47 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

3.18.0-rc7-next-20141204

mount

[   26.664641] PGD 375d0067 PUD 0 
[   26.664936] Oops: 0000 [#1] SMP 
[   26.665237] Modules linked in: crc32c_intel broadcom tg3 i2c_i801 microcode psmouse lpc_ich battery evdev ac processor wmi ehci_pci ehci_hcd usbcore sd_mod ahci
[   26.666753] CPU: 1 PID: 470 Comm: mount Not tainted 3.18.0-rc7-next-20141204-dbg-00001-gdd4d02a-dirty #408
[   26.667045] Hardware name: Acer             Aspire 5741G    /Aspire 5741G    , BIOS V1.20 02/08/2011
[   26.667333] task: ffff880151550000 ti: ffff88014ef5c000 task.ti: ffff88014ef5c000
[   26.667618] RIP: 0010:[<ffffffff8119e7c6>]  [<ffffffff8119e7c6>] ext4_fill_super+0x1088/0x2a04
[   26.667967] RSP: 0018:ffff88014ef5fcb8  EFLAGS: 00010246
[   26.668146] RAX: 0000001400009001 RBX: ffff88009accb800 RCX: 0000000000000028
[   26.668327] RDX: 00000000000010e2 RSI: 0000000000000001 RDI: ffffffff81831840
[   26.668509] RBP: ffff88014ef5fd88 R08: 0000000000000500 R09: 0000000000000000
[   26.668690] R10: 0000000000000001 R11: 0000000000001000 R12: ffff880152841000
[   26.668872] R13: 000000000870a895 R14: ffff880095bd2400 R15: 0000000000000000
[   26.669059] FS:  00007f8a9cce1780(0000) GS:ffff880157c80000(0000) knlGS:0000000000000000
[   26.669347] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   26.669526] CR2: 0000001400009013 CR3: 000000014ef00000 CR4: 00000000000007e0
[   26.669706] Stack:
[   26.669875]  0000000100000000 ffffffffff0a0210 ffff880151550000 ffff88010000000f
[   26.670406]  0000000000000022 ffff880151b457f0 ffff88019b028668 000010e200000022
[   26.670936]  0000000000000000 ffff88009accbd20 0000001400009001 ffff880152841000
[   26.671465] Call Trace:
[   26.671644]  [<ffffffff810ea862>] mount_bdev+0x143/0x19a
[   26.671822]  [<ffffffff8119d73e>] ? ext4_calculate_overhead+0x2b6/0x2b6
[   26.672009]  [<ffffffff810c67f2>] ? pcpu_alloc+0x3e1/0x4c0
[   26.672190]  [<ffffffff811991a7>] ext4_mount+0x10/0x12
[   26.672370]  [<ffffffff810eb31a>] mount_fs+0x64/0x151
[   26.672550]  [<ffffffff810c68f0>] ? __alloc_percpu+0x10/0x12
[   26.672729]  [<ffffffff81101d57>] vfs_kern_mount+0x67/0x13c
[   26.672910]  [<ffffffff81104d61>] do_mount+0x996/0xa70
[   26.673095]  [<ffffffff8110505d>] SyS_mount+0x72/0xa1
[   26.673278]  [<ffffffff813d22d6>] system_call_fastpath+0x16/0x1b
[   26.673457] Code: 49 09 c5 49 ff cd eb 17 48 8b 83 50 05 00 00 48 8b 8d 70 ff ff ff 48 8b 40 10 4c 8d 6c 01 ff 39 95 6c ff ff ff 75 18 48 8b 45 80 <f6> 40 12 04 8b 85 6c ff ff ff 0f 44 45 98 89 85 6c ff ff ff 48 
[   26.678113]  RSP <ffff88014ef5fcb8>
[   26.678287] CR2: 0000001400009013
[   26.678478] ---[ end trace 796def2f0d28d90d ]---



$ addr2line -e vmlinux -i ffffffff8119e7c6
/home/ss/_next/fs/ext4/super.c:2082
/home/ss/_next/fs/ext4/super.c:3909

$ addr2line -e vmlinux -i ffffffff810ea862
fs/super.c:1004

$ addr2line -e vmlinux -i ffffffff8119d73e
fs/ext4/super.c:3401

$ addr2line -e vmlinux -i ffffffff810c67f2
mm/percpu.c:1029 (discriminator 1)

$ addr2line -e vmlinux -i ffffffff811991a7
fs/ext4/super.c:5443



which led to fs corruption

[  549.812389] EXT4-fs (sda6): ext4_check_descriptors: Checksum for group 128 failed (26094!=25856)
[  549.812394] EXT4-fs (sda6): group descriptors corrupted!


	-ss
