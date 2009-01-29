From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12568] New: BUG: filefrag errors on non-journal ext4 filesystem
Date: Wed, 28 Jan 2009 16:50:33 -0800 (PST)
Message-ID: <bug-12568-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49136 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754264AbZA2AvG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Jan 2009 19:51:06 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0T0oX5E027483
	for <linux-ext4@vger.kernel.org>; Wed, 28 Jan 2009 16:50:34 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12568

           Summary: BUG: filefrag errors on non-journal ext4 filesystem
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.29-rc1
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: k-mio@sx.jp.nec.com


Latest working kernel version: unknown
Earliest failing kernel version: 2.6.29-rc1
Distribution: CentOS 5.2 (x86_64)
Hardware Environment: MY20R/B-4(CPU: Intel(R) Core(TM) 2 Duo E4400, MEM: 2560MB
Software Environment: e2fsprogs-1.41.3

Problem Description:
2.6.29-rc1 + the most recent ext4 patch queue

When mounting ext4 filesystem without a journal, BUG_ON panic occurs by
executing filefrag command.
The following error messages show in the system logs:

Jan 27 15:56:53 bsdB08126 kernel: kernel BUG at fs/ext4/inode.c:2825!
Jan 27 15:56:53 bsdB08126 kernel: invalid opcode: 0000 [0000001] SMP
Jan 27 15:56:53 bsdB08126 kernel: last sysfs file: /sys/class/drm/card0/dev
Jan 27 15:56:53 bsdB08126 kernel: CPU 0
Jan 27 15:56:53 bsdB08126 kernel: Modules linked in: i915 drm i2c_algo_bit
autofs4 hidp rfcomm l2cap bluetooth sunrpc iptable_filter ip_tables ip6t_REJECT
xt_tcpudp ip6table_filter ip6_tables x_tables dm_mirror dm_region_hash dm_log
dm_multipath dm_mod sbs sbshc battery acpi_memhotplug ac ipv6 lp
snd_hda_codec_realtek snd_hda_intel sg snd_hda_codec snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm
serio_raw sr_mod rtc_cmos cdrom parport_pc snd_timer rtc_core parport rtc_lib
snd button i2c_i801 e1000e soundcore pcspkr snd_page_alloc i2c_core ata_piix
libata sd_mod scsi_mod uhci_hcd ohci_hcd ehci_hcd [last unloaded: microcode]
Jan 27 15:56:53 bsdB08126 kernel: Pid: 3902, comm: filefrag Not tainted
2.6.29-rc1 0000012
Jan 27 15:56:53 bsdB08126 kernel: RIP: 0010:[<ffffffff803043a9>]
[<ffffffff803043a9>] ext4_bmap+0x5a/0xc8
Jan 27 15:56:53 bsdB08126 kernel: RSP: 0018:ffff880064857ea8 EFLAGS: 00010202
Jan 27 15:56:53 bsdB08126 kernel: RAX: 0000000000000000 RBX: ffff88006380d490
RCX: 0000000000000015
Jan 27 15:56:53 bsdB08126 kernel: RDX: 0000000000000000 RSI: 0000000000000000
RDI: ffff88006380d5a8
Jan 27 15:56:53 bsdB08126 kernel: RBP: ffff88006380d5a0 R08: ffff880064857e68
R09: 0000000000000000
Jan 27 15:56:53 bsdB08126 kernel: R10: 74616d726f662073 R11: ffff8800905d6380
R12: 00000000000063ff
Jan 27 15:56:53 bsdB08126 kernel: R13: 00000000000063ff R14: 0000000000000003
R15: 0000000000000000
Jan 27 15:56:53 bsdB08126 kernel: FS: 00007f4b8eb586e0(0000)
GS:ffffffff8086c080(0000) knlGS:0000000000000000
Jan 27 15:56:53 bsdB08126 kernel: CS: 0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Jan 27 15:56:53 bsdB08126 kernel: CR2: 00000031b8e62b80 CR3: 0000000062015000
CR4: 00000000000006e0
Jan 27 15:56:53 bsdB08126 kernel: DR0: 0000000000000000 DR1: 0000000000000000
DR2: 0000000000000000
Jan 27 15:56:54 bsdB08126 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0
DR7: 0000000000000400
Jan 27 15:56:54 bsdB08126 kernel: Process filefrag (pid: 3902, threadinfo
ffff880064856000, task ffff88007386e970)
Jan 27 15:56:54 bsdB08126 kernel: Stack:
Jan 27 15:56:54 bsdB08126 kernel: 0000000000000001 ffff88006380d5a0
00007fff96b70fb4 00000000000063ff
Jan 27 15:56:55 bsdB08126 kernel: 0000000000000000 ffffffff802aa43f
0000000000000000 0000000000000000
Jan 27 15:56:55 bsdB08126 kernel: 0000000000000000 0000000000000000
0000000000000000 ffffffff804e9068
Jan 27 15:56:56 bsdB08126 kernel: Call Trace:
Jan 27 15:56:56 bsdB08126 kernel: [<ffffffff802aa43f>] ?
do_vfs_ioctl+0x2bf/0x4a3
Jan 27 15:56:56 bsdB08126 kernel: [<ffffffff804e9068>] ?
do_page_fault+0x3a8/0x72f
Jan 27 15:56:57 bsdB08126 kernel: [<ffffffff802aa674>] ? sys_ioctl+0x51/0x70
Jan 27 15:56:58 bsdB08126 kernel: [<ffffffff8020bedb>] ?
system_call_fastpath+0x16/0x1b
Jan 27 15:56:58 bsdB08126 kernel: Code: 08 74 08 48 89 ef e8 28 fe f6 ff 48 8b
83 f8 00 00 00 48 8b 80 90 02 00 00 48 8b 80 90 41 00 00 48 85 c0 75 0f f6 43
a0 01 74 04 <0f> 0b eb fe 48 85 c0 74 42 8b 43 a0 a8 01 74 3b 83 e0 fe 89 43
Jan 27 15:56:58 bsdB08126 kernel: RIP [<ffffffff803043a9>] ext4_bmap+0x5a/0xc8
Jan 27 15:56:58 bsdB08126 kernel: RSP <ffff880064857ea8>
Jan 27 15:56:58 bsdB08126 kernel: ---[ end trace 60cf7e0d66d2b1ce ]---

Whenever __ext4_journalled_writepage() or ext4_journalled_write_end() is
called, EXT4_STATE_JDATA is set in i_state in spite of non-journal ext4.
That's weird.

Steps to reproduce:
1. mke2fs -O extents /dev/sdaX
2. mount -t ext4 /dev/sdaX /mnt/mpX
3. dd if=/dev/urandom of=/mnt/mpX/file bs=1K count=102400
4. filefrag /mnt/mpX/file


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
