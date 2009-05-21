From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12624] umount hangs after fsstress with data=journal
Date: Thu, 21 May 2009 12:25:23 GMT
Message-ID: <200905211225.n4LCPNLg004134@demeter.kernel.org>
References: <bug-12624-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58041 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbZEUMZY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 21 May 2009 08:25:24 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4LCPNrA004135
	for <linux-ext4@vger.kernel.org>; Thu, 21 May 2009 12:25:23 GMT
In-Reply-To: <bug-12624-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12624





--- Comment #2 from Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>  2009-05-21 12:25:23 ---
Testing with the latest patch queue hit the BUG_ON 
noalloc_get_block_write. I guess for data=journal
noalloc_get_block_write can get called with create = 1;
------------[ cut here ]------------
kernel BUG at fs/ext4/inode.c:2454!
invalid opcode: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:01:01.0/class
Modules linked in: autofs4 hidp sbs sbshc battery ac parport_pc lp parport
i2c_i801 i2c_core e752x_edac edac_core i6300esb tg3 libphy qla2xxx
scsi_transport_fc dm_multipath dm_mirror dm_region_hash dm_log dm_mod loop
xt_tcpudp ip6t_REJECT ipv6 ipt_REJECT x_tables sunrpc rfcomm bnep l2cap
bluetooth bridge stp sg rtc_cmos rtc_core rtc_lib pcspkr button ata_piix libata
mptspi mptscsih mptbase scsi_transport_spi sd_mod scsi_mod ext3 jbd uhci_hcd
ohci_hcd ehci_hcd [last unloaded: ip_tables]

Pid: 2641, comm: pdflush Not tainted (2.6.30-rc6-autotest #1) IBM BladeCenter
HS20 -[88432RG]-
EIP: 0060:[<c04e195b>] EFLAGS: 00010246 CPU: 3
EIP is at noalloc_get_block_write+0x44/0x61
EAX: 00000000 EBX: f71069d0 ECX: f63b2720 EDX: 00000001
ESI: 00000011 EDI: 00000000 EBP: e0cc4d90 ESP: e0cc4d84
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process pdflush (pid: 2641, ti=e0cc4000 task=f63b2230 task.ti=e0cc4000)
Stack:
 00000000 c56da980 e0cc4f70 e0cc4df4 c04ac354 f7086dd8 00000001 f6d32d00
 00000000 c56da980 f71069d0 00000800 00000011 00000000 00000400 f7086390
 e0cc4ddc fffffc00 fffffc00 00000400 f63b2230 00000800 f63b26f8 e0cc4e00
Call Trace:
 [<c04ac354>] ? __block_prepare_write+0x13b/0x311
 [<c04ac542>] ? block_prepare_write+0x18/0x27
 [<c04e1917>] ? noalloc_get_block_write+0x0/0x61
 [<c04e3f9e>] ? ext4_journalled_writepage+0xd8/0x1fa
 [<c04e1917>] ? noalloc_get_block_write+0x0/0x61
 [<c04714b4>] ? __writepage+0xb/0x23
 [<c04718b6>] ? write_cache_pages+0x1c0/0x2b3
 [<c04714a9>] ? __writepage+0x0/0x23
 [<c04719c6>] ? generic_writepages+0x1d/0x27
 [<c04719fc>] ? do_writepages+0x2c/0x34
 [<c04a7602>] ? __writeback_single_inode+0x145/0x275
 [<c04a7a74>] ? generic_sync_sb_inodes+0x1a9/0x2de
 [<c04a7bb1>] ? sync_sb_inodes+0x8/0xa
 [<c04a7d24>] ? writeback_inodes+0x52/0x95
 [<c04725c7>] ? wb_kupdate+0x8b/0xed
 [<c0472985>] ? pdflush+0x0/0x1d5
 [<c0472a7d>] ? pdflush+0xf8/0x1d5
 [<c047253c>] ? wb_kupdate+0x0/0xed
 [<c043bba6>] ? kthread+0x45/0x6b
 [<c043bb61>] ? kthread+0x0/0x6b
 [<c040345b>] ? kernel_thread_helper+0x7/0x10
Code: 00 00 3b 50 0c 74 04 0f 0b eb fe 6a 00 31 c0 ff 75 08 d3 ea 52 89 da 57
56 e8 f1 fc ff ff 83 c4 14 83 7d 0c 00 74 08 85 c0 75 04 <0f> 0b eb fe 85 c0 7e
0d 8b 4b 64 8b 55 08 d3 e0 89 42 14 31 c0
EIP: [<c04e195b>] noalloc_get_block_write+0x44/0x61 SS:ESP 0068:e0cc4d84
---[ end trace 994dd47b9422fac1 ]---


-aneesh

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
