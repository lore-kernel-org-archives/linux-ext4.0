From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42859] New: kernel BUG at fs/ext4/extents.c:1953
Date: Sun, 4 Mar 2012 14:39:09 GMT
Message-ID: <bug-42859-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bugzilla.kernel.org ([198.145.19.204]:55301 "EHLO
	bugzilla.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab2CDOjK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 4 Mar 2012 09:39:10 -0500
Received: from bugzilla.kernel.org (localhost [127.0.0.1])
	by bugzilla.kernel.org (8.14.5/8.14.5) with ESMTP id q24Ed9en003972
	for <linux-ext4@vger.kernel.org>; Sun, 4 Mar 2012 14:39:09 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42859

           Summary: kernel BUG at fs/ext4/extents.c:1953
           Product: File System
           Version: 2.5
    Kernel Version: 3.2.1, 3.2.9
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: merll@web.de
        Regression: No


Messages "kernel BUG at fs/ext4/extents.c:1953" occur, which seem to be
triggered when running certain processes (reproducible with init and gdm). The
volume can be mounted without any apparent problems and e2fsck does not report
any errors. Nevertheless, the file system may have been corrupted during an
earlier system crash.

For example, the following message can be produced when running "shutdown -r
now":

------------[ cut here ]------------
kernel BUG at fs/ext4/extents.c:1953!
invalid opcode: 0000 [#1] SMP 
CPU 0 
Modules linked in: vfat fat firewire_sbp2 uvcvideo videodev firewire_ohci
snd_usb_audio firewire_core btusb v4l2_compat_ioctl32 crc_itu_t snd_usbmidi_lib
bluetooth snd_rawmidi

Pid: 1, comm: init Not tainted 3.2.9-gentoo #4 Gigabyte Technology Co., Ltd.
EX38-DS4/EX38-DS4
RIP: 0010:[<ffffffff81194746>]  [<ffffffff81194746>]
ext4_ext_put_in_cache+0x76/0x80
RSP: 0018:ffff88011aa4d7a8  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88011acc5350 RCX: 0000000000508274
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88011acc5350
RBP: 0000000000000000 R08: ffff880119427ae0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000508274 R12: 0000000000000000
R13: ffff880119b81800 R14: 0000000000508274 R15: 0000000000000000
FS:  00007f8703c7d700(0000) GS:ffff88011fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff54d5fff8 CR3: 000000011ab1a000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process init (pid: 1, threadinfo ffff88011aa4c000, task ffff88011aa58000)
Stack:
ffff880119427ae0 ffff88011aa4d998 ffff88011acc5350 ffff880119b81800
ffff88011acc52cc ffffffff8119780f 0000000100014341 ffff88011fffbe00
ffff88011fffbe00 ffffffff810e720d 0000000000000000 0000000000508274
Call Trace:
[<ffffffff8119780f>] ? ext4_ext_map_blocks+0x15f/0x1b00
[<ffffffff810e720d>] ? zone_statistics+0x9d/0xa0
[<ffffffff810d78f9>] ? get_page_from_freelist+0x309/0x720
[<ffffffff8144ab9e>] ? __schedule+0x29e/0x740
[<ffffffff8117ec61>] ? ext4_da_get_block_prep+0x141/0x2c0
[<ffffffff8113eb31>] ? alloc_page_buffers+0x71/0xe0
[<ffffffff81141316>] ? __block_write_begin+0x206/0x560
[<ffffffff8117eb20>] ? ext4_bmap+0x110/0x110
[<ffffffff81180d47>] ? ext4_da_write_begin+0xc7/0x1c0
[<ffffffff81061183>] ? __wake_up+0x43/0x70
[<ffffffff810d0860>] ? generic_file_buffered_write+0x120/0x2c0
[<ffffffff810d2469>] ? __generic_file_aio_write+0x219/0x410
[<ffffffff810d8453>] ? __alloc_pages_nodemask+0x123/0x810
[<ffffffff810d26d9>] ? generic_file_aio_write+0x79/0x100
[<ffffffff8117b20e>] ? ext4_file_write+0x6e/0x290
[<ffffffff8110454e>] ? alloc_pages_vma+0x5e/0x220
[<ffffffff81114ddf>] ? do_sync_write+0xbf/0x100
[<ffffffff8115797f>] ? fcntl_setlk+0x5f/0x330
[<ffffffff81115646>] ? vfs_write+0xc6/0x170
[<ffffffff8111592e>] ? sys_write+0x4e/0x90
[<ffffffff8144d8bb>] ? system_call_fastpath+0x16/0x1b
Code: 00 4d 89 b5 98 02 00 00 fe 83 7c 02 00 00 48 8b 1c 24 48 8b 6c 24 08 4c
8b 64 24 10 4c 8b 6c 24 18 4c 8b 74 24 20 48 83 c4 28 c3 <0f> 0b 0f 1f 84 00 00
00 00 00 41 57 41 56 41 55 41 54 49 89 cc
RIP  [<ffffffff81194746>] ext4_ext_put_in_cache+0x76/0x80
RSP <ffff88011aa4d7a8>
---[ end trace 050481fbd074e5e1 ]---

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
