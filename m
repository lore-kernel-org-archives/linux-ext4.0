From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12885] kernel BUG at fs/jbd/transaction.c:1376!
Date: Tue, 17 Mar 2009 02:30:40 -0700 (PDT)
Message-ID: <20090317093040.4A26E10800E@picon.linux-foundation.org>
References: <bug-12885-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761744AbZCQJbs (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Mar 2009 05:31:48 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2H9Ue25022298
	for <linux-ext4@vger.kernel.org>; Tue, 17 Mar 2009 02:31:18 -0700
In-Reply-To: <bug-12885-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12885





------- Comment #1 from andy-kernelbugzilla@splashground.de  2009-03-17 02:30 -------
Another one:
------------[ cut here ]------------
kernel BUG at fs/jbd/transaction.c:1376!
invalid opcode: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/devices/platform/coretemp.1/temp1_input
CPU 0 
Modules linked in: xt_tcpudp iptable_mangle xt_MARK ip_tables x_tables
cpufreq_ondemand ext3 jbd ext2 lrw joydev snd_seq_oss snd_seq_midi_event
snd_seq snd_seq_device usbhid hid snd_pcm_oss snd_mixer_oss ohci1394 uhci_hcd
snd_hda_intel snd_pcm snd_timer snd_page_alloc snd_hwdep ieee1394 skge snd
pcspkr ehci_hcd soundcore i2c_i801 i2c_core usbcore iTCO_wdt intel_agp
iTCO_vendor_support sg battery ac tun fuse sky2 evdev acpi_cpufreq freq_table
coretemp button fan thermal processor rtc_cmos rtc_core rtc_lib ext4 mbcache
jbd2 crc16 aes_x86_64 aes_generic xts gf128mul dm_crypt dm_mod sr_mod cdrom
sd_mod pata_acpi ata_generic ahci ata_piix pata_marvell libata scsi_mod
Pid: 6706, comm: unrar Not tainted 2.6.28-ARCH #1
RIP: 0010:[<ffffffffa039119e>]  [<ffffffffa039119e>] journal_stop+0x1ee/0x200
[jbd]
RSP: 0000:ffff8800cfac5de8  EFLAGS: 00010286
RAX: ffff8801b33a2b50 RBX: 0000000000000000 RCX: 0000000000000034
RDX: ffff880160894770 RSI: ffff880229b61390 RDI: ffff880229b61390
RBP: ffff8801a01e0180 R08: 0400000000000000 R09: 0000000000000000
R10: ffff88022e758000 R11: ffffffff80321f00 R12: ffff880229b61390
R13: ffff88022554ec00 R14: 00000000000041fd R15: ffff880141756ea0
FS:  00002af651d5bb20(0000) GS:ffffffff8065e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007f6c80ef9000 CR3: 00000000cfb7c000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process unrar (pid: 6706, threadinfo ffff8800cfac4000, task ffff8801b33a2b50)
Stack:
 ffff8800432cd310 0000000000000000 ffff88022554c800 ffffffffa03b77c8
 ffff8800432cd310 00000000000041fd ffff880141756ea0 ffffffffa03b12dd
 ffff8801608bab88 ffff880229b61390 ffff880160894770 ffffffffa03aba2e
Call Trace:
 [<ffffffffa03b12dd>] ? __ext3_journal_stop+0x2d/0x60 [ext3]
 [<ffffffffa03aba2e>] ? ext3_mkdir+0x24e/0x2d0 [ext3]
 [<ffffffff802bbc67>] ? vfs_mkdir+0xe7/0x130
 [<ffffffff80488675>] ? _spin_unlock+0x5/0x30
 [<ffffffff802be27c>] ? sys_mkdirat+0x11c/0x130
 [<ffffffff80488675>] ? _spin_unlock+0x5/0x30
 [<ffffffff802c8b42>] ? alloc_fd+0x122/0x150
 [<ffffffff8020c50a>] ? system_call_fastpath+0x16/0x1b
Code: e8 58 3b ea df 41 8b 75 28 85 f6 0f 84 37 ff ff ff 49 8d 7d 78 31 c9 ba
01 00 00 00 be 03 00 00 00 e8 37 3b ea df e9 1d ff ff ff <0f> 0b eb fe 66 66 66
66 66 2e 0f 1f 84 00 00 00 00 00 41 57 41 
RIP  [<ffffffffa039119e>] journal_stop+0x1ee/0x200 [jbd]
 RSP <ffff8800cfac5de8>
---[ end trace 0b2b3734ee2df4f1 ]---


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
