From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 56241] running e4defrag provokes "kernel BUG at
 fs/buffer.c:1833!"
Date: Mon,  8 Apr 2013 16:07:40 +0000 (UTC)
Message-ID: <20130408160740.17C5A11FB5C@bugzilla.kernel.org>
References: <bug-56241-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:54266 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100Ab3DHQHu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Apr 2013 12:07:50 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 13811201D0
	for <linux-ext4@vger.kernel.org>; Mon,  8 Apr 2013 16:07:49 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 1C3F9202F0
	for <linux-ext4@vger.kernel.org>; Mon,  8 Apr 2013 16:07:40 +0000 (UTC)
In-Reply-To: <bug-56241-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=56241


Dmitry Monakhov <dmonakhov@openvz.org> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |dmonakhov@openvz.org




--- Comment #1 from Dmitry Monakhov <dmonakhov@openvz.org>  2013-04-08 16:07:39 ---
Ok I've able to reproduce this on 64k pages and 1k fsblock size
Probably this is my bug

10477.714752] EXT4-fs (dm-3): mounted filesystem with ordered data mode. Opts:
acl,user_xattr
[10480.693978] kernel BUG at fs/buffer.c:1833!
[10480.698233] fio[10780]: bugcheck! 0 [1]
[10480.702141] Modules linked in: ext4 jbd2 crc16 nls_iso8859_1 nls_cp437 vfat
fat dm_mod sg loop sr_mod cdrom hid_generic ehci_pci ext3 jbd mbcache
usb_storage usbhid hid hpsa cciss mptsas mptscsih mptbase scsi_transport_sas
tg3 libphy ptp scsi_mod ohci_hcd ehci_hcd usbcore pps_core usb_common
[10480.702223] 
[10480.702223] Pid: 10780, CPU 2, comm:                  fio
[10480.702223] psr : 00001010085a6018 ifs : 8000000000000ea1 ip  :
[<a00000010026f500>]    Not tainted (3.8.0)
[10480.702223] ip is at __block_write_begin+0xe0/0xa40
[10480.702223] unat: 0000000000000000 pfs : 0000000000000ea1 rsc :
0000000000000003
[10480.702223] rnat: 0009804c8a70033f bsps: 0000000000004000 pr  :
00000000a9a94955
[10480.702223] ldrs: 0000000000000000 ccv : 000000000d220691 fpsr:
0009804c8a70033f
[10480.702223] csd : 0000000000000000 ssd : 0000000000000000
[10480.702223] b0  : a00000010026f500 b6  : a00000010042f760 b7  :
a000000100554f30
[10480.702223] f6  : 1003e00000354df80f716 f7  : 1003e000000000000015e
[10480.702223] f8  : 1003e00000354df80f5b8 f9  : 1003e0000000000000001
[10480.702223] f10 : 1003e00000000052ba885 f11 : 1003e20c49ba5e353f7cf
[10480.702223] r1  : a000000100e50e20 r2  : 0000000000006760 r3  :
000000000000fffe
[10480.702223] r8  : 000000000000001f r9  : 00000000000005f5 r10 :
00000000000005f5
[10480.702223] r11 : 000000000000675e r12 : e00000022ecafd20 r13 :
e00000022eca0000
[10480.702223] r14 : 0000000000006760 r15 : 0000000000004000 r16 :
00000000000033af
[10480.702223] r17 : 0000000000000001 r18 : 000000000000675e r19 :
a000000100c5d138
[10480.702223] r20 : 000000000000675c r21 : 0000000000000000 r22 :
a000000100cf87a8
[10480.702223] r23 : a0000001009feb48 r24 : a000000100553a70 r25 :
0000000000000700
[10480.702223] r26 : a000000100cf88e0 r27 : a0000001009feb38 r28 :
0000000000000000
[10480.702223] r29 : a000000100cf87a0 r30 : 0000000000000c34 r31 :
a000000100cf878a
[10480.702223] 
[10480.702223] Call Trace:
[10480.702223]  [<a000000100014d10>] show_stack+0x50/0xa0
[10480.702223]                                 sp=e00000022ecaf8f0
bsp=e00000022eca14c0
[10480.702223]  [<a000000100015590>] show_regs+0x830/0x870
[10480.702223]                                 sp=e00000022ecafac0
bsp=e00000022eca1460
[10480.702223]  [<a00000010003a900>] die+0x1a0/0x2f0
[10480.702223]                                 sp=e00000022ecafad0
bsp=e00000022eca1420
[10480.702223]  [<a00000010003aaa0>] die_if_kernel+0x50/0x70
[10480.702223]                                 sp=e00000022ecafad0
bsp=e00000022eca13e8
[10480.702223]  [<a00000010082d7e0>] ia64_bad_break+0x240/0x420
[10480.702223]                                 sp=e00000022ecafad0
bsp=e00000022eca13c0
[10480.702223]  [<a00000010000bc40>] ia64_native_leave_kernel+0x0/0x270
[10480.702223]                                 sp=e00000022ecafb50
bsp=e00000022eca13c0
[10480.702223]  [<a00000010026f500>] __block_write_begin+0xe0/0xa40
[10480.702223]                                 sp=e00000022ecafd20
bsp=e00000022eca12b8
[10480.702223]  [<a000000203673df0>] ext4_move_extents+0x13b0/0x1c60 [ext4]
[10480.702223]                                 sp=e00000022ecafd40
bsp=e00000022eca10c8
[10480.702223]  [<a000000203623100>] ext4_ioctl+0x1200/0x1b30 [ext4]
[10480.702223]                                 sp=e00000022ecafd60
bsp=e00000022eca1058
[10480.702223]  [<a00000010022f690>] do_vfs_ioctl+0xf00/0x1010
[10480.702223]                                 sp=e00000022ecafdd0
bsp=e00000022eca1008
[10480.702223]  [<a00000010022f840>] sys_ioctl+0xa0/0x120
[10480.702223]                                 sp=e00000022ecafe10
bsp=e00000022eca0f80
[10480.702223]  [<a00000010000bac0>] ia64_ret_from_syscall+0x0/0x20
[10480.702223]                                 sp=e00000022ecafe30
bsp=e00000022eca0f80
[10480.702223]  [<a000000000040720>] ia64_ivt+0xffffffff00040720/0x400
[10480.702223]                                 sp=e00000022ecb0000
bsp=e00000022eca0f80
[10480.702223] Disabling lock debugging due to kernel taint

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
