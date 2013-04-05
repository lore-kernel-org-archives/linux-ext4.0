From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 56241] New: running e4defrag provokes "kernel BUG at
 fs/buffer.c:1833!"
Date: Fri,  5 Apr 2013 11:29:27 +0000 (UTC)
Message-ID: <bug-56241-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:39824 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979Ab3DEL3n (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 5 Apr 2013 07:29:43 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 3B811201A7
	for <linux-ext4@vger.kernel.org>; Fri,  5 Apr 2013 11:29:34 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 88F5E201BB
	for <linux-ext4@vger.kernel.org>; Fri,  5 Apr 2013 11:29:28 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=56241

           Summary: running e4defrag provokes "kernel BUG at
                    fs/buffer.c:1833!"
           Product: File System
           Version: 2.5
    Kernel Version: 3.8.5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: j.fikar@gmail.com
        Regression: Yes


I recently discovered, that "e4defrag /boot" produces an error and blocks the
/boot even for umount. It was not the case some kernels before, not completely
sure when, maybe around 3.5-3.6?

[81924.524369] ------------[ cut here ]------------
[81924.524556] kernel BUG at fs/buffer.c:1833!
[81924.524700] invalid opcode: 0000 [#1] PREEMPT SMP 
[81924.524883] Modules linked in: zram(C) iptable_filter ip_tables x_tables
arc4 uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core videodev
microcode snd_hda_codec_idt radeon ath9k ath9k_common ath9k_hw ath mac80211
r8169 cfg80211 drm_kms_helper snd_hda_intel snd_hda_codec k10temp snd_hwdep ttm
video ohci_hcd
[81924.526007] CPU 1 
[81924.526090] Pid: 10555, comm: e4defrag Tainted: G         C   3.8.5 #2
Hewlett-Packard HP Pavilion dv7 Notebook PC/363A
[81924.526435] RIP: 0010:[<ffffffff81126605>]  [<ffffffff81126605>]
__block_write_begin+0x455/0x460
[81924.526740] RSP: 0018:ffff880179ccdae8  EFLAGS: 00010206
[81924.526915] RAX: 8000000000000029 RBX: 0000000000000c00 RCX:
ffffffff81186ed0
[81924.527143] RDX: 0000000000001c00 RSI: 0000000000000c00 RDI:
ffffea0006294800
[81924.527370] RBP: ffff880179ccdc80 R08: 0000000000014780 R09:
ffff88021fd14780
[81924.527597] R10: ffffea0005bbc4c0 R11: ffffffff811ac642 R12:
ffff880179ccdc80
[81924.527824] R13: 0000000000000000 R14: 0000000000000400 R15:
ffffea0006294800
[81924.528054] FS:  00007fe4a7b0e740(0000) GS:ffff88021fd00000(0000)
knlGS:0000000000000000
[81924.528310] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[81924.528495] CR2: 0000003de2d61728 CR3: 000000014c137000 CR4:
00000000000007e0
[81924.528722] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[81924.528949] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[81924.529178] Process e4defrag (pid: 10555, threadinfo ffff880179ccc000, task
ffff8802057b5820)
[81924.529444] Stack:
[81924.529514]  ffff880179ccdb60 ffff880117361190 ffff88016ef130c0
ffff8801236d94f0
[81924.529781]  ffff880117361190 00000c0000001c00 ffff880117361190
ffffffff81186ed0
[81924.530048]  0000000000000400 ffffffff815b4f9b ffff8801236d9458
0000000181123260
[81924.530314] Call Trace:
[81924.530414]  [<ffffffff81186ed0>] ? ext4_get_block_write+0x10/0x10
[81924.530621]  [<ffffffff815b4f9b>] ? out_of_line_wait_on_bit+0x7b/0x90
[81924.530837]  [<ffffffff811acb74>] ? move_extent_per_page.isra.17+0x424/0x8e0
[81924.531069]  [<ffffffff8119d048>] ? ext4_ext_find_extent+0x2f8/0x370
[81924.531279]  [<ffffffff811ad6bd>] ? ext4_move_extents+0x68d/0xa00
[81924.531483]  [<ffffffff8118bab5>] ? ext4_ioctl+0xa55/0xaf0
[81924.531667]  [<ffffffff810c5526>] ? tlb_finish_mmu+0x16/0x50
[81924.531857]  [<ffffffff810cc2b1>] ? unmap_region+0xd1/0x130
[81924.532046]  [<ffffffff811099bd>] ? do_vfs_ioctl+0x43d/0x510
[81924.532235]  [<ffffffff810ce2f9>] ? do_munmap+0x329/0x420
[81924.532416]  [<ffffffff81109adc>] ? sys_ioctl+0x4c/0xa0
[81924.532594]  [<ffffffff815b7f56>] ? system_call_fastpath+0x1a/0x1f
[81924.532790] Code: 24 10 e9 42 fd ff ff 8b 54 24 28 8b 74 24 2c 4c 89 ff 89
44 24 18 e8 8b f2 ff ff 8b 44 24 18 e9 bb fe ff ff 0f 0b e8 28 88 48 00 <0f> 0b
0f 0b 0f 1f 80 00 00 00 00 48 83 ec 28 4c 89 6c 24 20 48 
[81924.533932] RIP  [<ffffffff81126605>] __block_write_begin+0x455/0x460
[81924.534150]  RSP <ffff880179ccdae8>
[81924.590443] ---[ end trace c154515de3642cfd ]---

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
