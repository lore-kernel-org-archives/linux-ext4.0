From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12885] New: kernel BUG at fs/jbd/transaction.c:1376!
Date: Mon, 16 Mar 2009 12:42:50 -0700 (PDT)
Message-ID: <bug-12885-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752320AbZCPTna (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Mar 2009 15:43:30 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2GJgpM0000729
	for <linux-ext4@vger.kernel.org>; Mon, 16 Mar 2009 12:43:27 -0700
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12885

           Summary: kernel BUG at fs/jbd/transaction.c:1376!
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.28
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: andy-kernelbugzilla@splashground.de


Latest working kernel version: 2.6.28
Earliest failing kernel version: 2.6.28
Distribution: Archlinux
Hardware Environment:x86_64
Software Environment:
Problem Description:
------------[ cut here ]------------
kernel BUG at fs/jbd/transaction.c:1376!
invalid opcode: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/devices/platform/coretemp.1/temp1_input
CPU 1
Modules linked in: xt_tcpudp iptable_mangle xt_MARK ip_tables x_tables
cpufreq_ondemand ext3 jbd ext2 lrw joydev usbhid hid uhci_hcd snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss ohci1394
i2c_i801 i2c_core ieee1394 ehci_hcd skge snd_hda_intel snd_pcm snd_timer
snd_page_alloc snd_hwdep snd soundcore pcspkr usbcore intel_agp iTCO_wdt
iTCO_vendor_support sg battery ac tun fuse sky2 evdev acpi_cpufreq freq_table
coretemp button fan thermal processor rtc_cmos rtc_core rtc_lib ext4 mbcache
jbd2 crc16 aes_x86_64 aes_generic xts gf128mul dm_crypt dm_mod sd_mod sr_mod
cdrom pata_acpi ata_generic ahci ata_piix pata_marvell libata scsi_mod
Pid: 11065, comm: scp Not tainted 2.6.28-ARCH #1
RIP: 0010:[<ffffffffa039119e>]  [<ffffffffa039119e>] journal_stop+0x1ee/0x200
[jbd]
RSP: 0018:ffff88009121bd48  EFLAGS: 00010282
RAX: ffff8800cf9c2520 RBX: 0000000000000000 RCX: 0000000000000034
RDX: ffff88020d93eb88 RSI: ffff88022f7fb5d0 RDI: ffff88022f7fb5d0
RBP: ffff880216f6e3c0 R08: 0400000000000000 R09: 0000000000000000
R10: ffff88022e848000 R11: ffffffff80321f00 R12: ffff88022f7fb5d0
R13: ffff88022ea8a000 R14: 00000000000081f8 R15: ffff88009121bdbc
FS:  00002abe4691f810(0000) GS:ffff88022f802900(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 000000000192c428 CR3: 00000000cfb9f000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process scp (pid: 11065, threadinfo ffff88009121a000, task ffff8800cf9c2520)
Stack:
 ffffffff80488675 0000000000000000 ffff88022ea89800 ffffffffa03b77f6
 ffff88020d93eb88 00000000000081f8 ffff88009121bdbc ffffffffa03b12dd
 ffff88021a7c97d8 ffff88022f7fb5d0 0000000000000000 ffffffffa03abaef
Call Trace:
 [<ffffffff80488675>] ? _spin_unlock+0x5/0x30
 [<ffffffffa03b12dd>] ? __ext3_journal_stop+0x2d/0x60 [ext3]
 [<ffffffffa03abaef>] ? ext3_create+0x3f/0x130 [ext3]
 [<ffffffff802bc1a7>] ? vfs_create+0xf7/0x140
 [<ffffffff802bf17c>] ? do_filp_open+0x85c/0x980
 [<ffffffff802572a0>] ? autoremove_wake_function+0x0/0x30
 [<ffffffff802b5b73>] ? vfs_stat_fd+0x23/0x60
 [<ffffffff80488675>] ? _spin_unlock+0x5/0x30
 [<ffffffff802c8b42>] ? alloc_fd+0x122/0x150
 [<ffffffff802af640>] ? do_sys_open+0x80/0x110
 [<ffffffff8020c50a>] ? system_call_fastpath+0x16/0x1b
Code: e8 58 3b ea df 41 8b 75 28 85 f6 0f 84 37 ff ff ff 49 8d 7d 78 31 c9 ba
01 00 00 00 be 03 00 00 00 e8 37 3b ea df e9 1d ff ff ff <0f> 0b eb fe 66 66 66
66 66 2e 0f 1f 84 00 00 00 00 00 41 57 41
RIP  [<ffffffffa039119e>] journal_stop+0x1ee/0x200 [jbd]
 RSP <ffff88009121bd48>


Steps to reproduce:

Don't know.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
