From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12885] kernel BUG at fs/jbd/transaction.c:1376!
Date: Wed, 18 Mar 2009 14:50:55 -0700 (PDT)
Message-ID: <20090318215055.E853110800E@picon.linux-foundation.org>
References: <bug-12885-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39170 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760277AbZCRVwV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Mar 2009 17:52:21 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2ILouf1017434
	for <linux-ext4@vger.kernel.org>; Wed, 18 Mar 2009 14:51:32 -0700
In-Reply-To: <bug-12885-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12885





------- Comment #16 from andy-kernelbugzilla@splashground.de  2009-03-18 14:50 -------
So after rebooting and manual fsck, a simple touch is triggering it,
or something similar:

$ fsck /dev/mapper/media
fsck 1.41.4 (27-Jan-2009)
e2fsck 1.41.4 (27-Jan-2009)
/dev/mapper/media: recovering journal
/dev/mapper/media has been mounted 157 times without being checked, check
forced.
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/mapper/media: 21438/24420352 files (30.1% non-contiguous),
89299732/97677469 blocks


$ touch x
[1]    5794 segmentation fault  touch x

dmesg:
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
------------[ cut here ]------------
kernel BUG at fs/jbd/transaction.c:1376!
invalid opcode: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/devices/platform/coretemp.1/temp1_input
CPU 1
Modules linked in: ext3 jbd xt_tcpudp iptable_mangle xt_MARK ip_tables x_tables
cpufreq_ondemand ext2 lrw joydev usbhid hid uhci_hcd snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss ohci1394
ieee1394 pcspkr skge ehci_hcd i2c_i801 i2c_core snd_hda_intel snd_pcm snd_timer
snd_page_alloc snd_hwdep snd soundcore usbcore intel_agp iTCO_wdt
iTCO_vendor_support sg battery ac tun fuse sky2 evdev acpi_cpufreq freq_table
coretemp button fan thermal processor rtc_cmos rtc_core rtc_lib ext4 mbcache
jbd2 crc16 aes_x86_64 aes_generic xts gf128mul dm_crypt dm_mod sr_mod cdrom
sd_mod pata_acpi ata_generic ahci ata_piix pata_marvell libata scsi_mod
Pid: 5794, comm: touch Not tainted 2.6.28-ARCH #1
RIP: 0010:[<ffffffffa053019e>]  [<ffffffffa053019e>] journal_stop+0x1ee/0x200
[jbd]
RSP: 0018:ffff88021acfbd48  EFLAGS: 00010282
RAX: ffff8802190e18c0 RBX: 0000000000000000 RCX: 0000000000000034
RDX: ffff8801b799fbf0 RSI: ffff88022f516168 RDI: ffff88022f516168
RBP: ffff8801ac5f6780 R08: 0400000000000000 R09: 0000000000000000
R10: ffff88020b544000 R11: ffffffff80321f00 R12: ffff88022f516168
R13: ffff88020b401800 R14: 00000000000081b4 R15: ffff88021acfbdbc
FS:  00002ab790209000(0000) GS:ffff88022f802900(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000406da0 CR3: 0000000228bf2000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process touch (pid: 5794, threadinfo ffff88021acfa000, task ffff8802190e18c0)
Stack:
 ffffffff80488675 0000000000000000 ffff88020b401000 ffffffffa05567f6
 ffff8801b799fbf0 00000000000081b4 ffff88021acfbdbc ffffffffa05502dd
 ffff8801ce594e00 ffff88022f516168 0000000000000000 ffffffffa054aaef
Call Trace:
 [<ffffffff80488675>] ? _spin_unlock+0x5/0x30
 [<ffffffffa05502dd>] ? __ext3_journal_stop+0x2d/0x60 [ext3]
 [<ffffffffa054aaef>] ? ext3_create+0x3f/0x130 [ext3]
 [<ffffffffa054ae7b>] ? ext3_lookup+0xcb/0x100 [ext3]
 [<ffffffff802bc1a7>] ? vfs_create+0xf7/0x140
 [<ffffffff802bf17c>] ? do_filp_open+0x85c/0x980
 [<ffffffff80488675>] ? _spin_unlock+0x5/0x30
 [<ffffffff802c8b42>] ? alloc_fd+0x122/0x150
 [<ffffffff802af640>] ? do_sys_open+0x80/0x110
 [<ffffffff8020c50a>] ? system_call_fastpath+0x16/0x1b
Code: e8 58 4b d0 df 41 8b 75 28 85 f6 0f 84 37 ff ff ff 49 8d 7d 78 31 c9 ba
01 00 00 00 be 03 00 00 00 e8 37 4b d0 df e9 1d ff ff ff <0f> 0b eb fe 66 66 66
66 66 2e 0f 1f 84 00 00 00 00 00 41 57 41
RIP  [<ffffffffa053019e>] journal_stop+0x1ee/0x200 [jbd]
 RSP <ffff88021acfbd48>
---[ end trace 778583b30cdd0759 ]---


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
