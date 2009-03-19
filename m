From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12885] kernel BUG at fs/jbd/transaction.c:1376!
Date: Thu, 19 Mar 2009 02:37:35 -0700 (PDT)
Message-ID: <20090319093736.0F6E310800E@picon.linux-foundation.org>
References: <bug-12885-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753908AbZCSJio (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Mar 2009 05:38:44 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n2J9baGE029472
	for <linux-ext4@vger.kernel.org>; Thu, 19 Mar 2009 02:38:12 -0700
In-Reply-To: <bug-12885-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12885





------- Comment #18 from andy-kernelbugzilla@splashground.de  2009-03-19 02:37 -------
Booting a new Archlinux kernel 2.6.28.8, I got this on booting:

Adding 1999992k swap on /a.swap.  Priority:-1 extents:462 across:8115000k
JBD: barrier-based sync failed on dm-0:8 - disabling barriers
sky2 eth0: enabling interface
sky2 eth0: Link is up at 1000 Mbps, full duplex, flow control both
general protection fault: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/block/dm-2/size
CPU 0
Modules linked in: ext2 lrw joydev usbhid hid uhci_hcd snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss ohci1394
ieee1394 ehci_hcd snd_hda_intel snd_pcm snd_timer snd_page_alloc snd_hwdep snd
soundcore skge i2c_i801 i2c_core usbcore intel_agp pcspkr iTCO_wdt
iTCO_vendor_support sg battery ac tun fuse sky2 evdev acpi_cpufreq freq_table
coretemp button fan thermal processor rtc_cmos rtc_core rtc_lib ext4 mbcache
jbd2 crc16 aes_x86_64 aes_generic xts gf128mul dm_crypt dm_mod sd_mod sr_mod
cdrom pata_acpi ata_generic ahci ata_piix pata_marvell libata scsi_mod
Pid: 4955, comm: hald Not tainted 2.6.28-ARCH #1
RIP: 0010:[<ffffffffa01620ab>]  [<ffffffffa01620ab>]
acpi_processor_info_seq_show+0x10/0x69 [processor]
RSP: 0018:ffff88022e571e48  EFLAGS: 00010206
RAX: ffff88022ee1f760 RBX: ffff88022e513380 RCX: 2222222222222222
RDX: 0038004000000000 RSI: 0000000000000001 RDI: ffff88022e513380
RBP: 0000000000000001 R08: 00000000ffffffff R09: 0000000000000000
R10: 0000000000000022 R11: ffff88022e513380 R12: 0000000000000001
R13: ffff88022e571e98 R14: 0000000000000000 R15: 0000000000000400
FS:  00007fadef4276f0(0000) GS:ffffffff8065e000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000435660 CR3: 000000022cbf1000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process hald (pid: 4955, threadinfo ffff88022e570000, task ffff88022e61dcd0)
Stack:
 ffff88022e8fa900 ffff88022e571f50 0000000000000400 ffffffff802cd9c6
 00000007fadef2c2 ffff88022e571f50 0000000000655860 ffff88022e8fa900
 ffff88022e5133b0 0000000000000000 0000000000000000 ffff88022eb28480
Call Trace:
 [<ffffffff802cd9c6>] ? seq_read+0xd6/0x360
 [<ffffffff802cd8f0>] ? seq_read+0x0/0x360
 [<ffffffff802fec51>] ? proc_reg_read+0x81/0xd0
 [<ffffffff802b23f8>] ? vfs_read+0xc8/0x180
 [<ffffffff802b25b3>] ? sys_read+0x53/0xa0
 [<ffffffff8020c50a>] ? system_call_fastpath+0x16/0x1b
Code: c3 48 8b 47 e8 48 89 f1 48 c7 c6 9b 20 16 a0 48 89 cf 48 8b 50 60 e9 e5
bc 16 e0 48 83 ec 18 48 8b 57 70 49 89 fb 48 85 d2 74 52 <8a> 42 1c 49 c7 c0 ce
6a 16 a0 48 c7 c6 d1 6a 16 a0 4d 89 c2 4c
RIP  [<ffffffffa01620ab>] acpi_processor_info_seq_show+0x10/0x69 [processor]
 RSP <ffff88022e571e48>
---[ end trace 7a143c8d515d5620 ]---


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
