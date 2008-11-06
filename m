From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: ext3: kernel BUG at fs/jbd/journal.c:412!
Date: Thu, 6 Nov 2008 21:20:25 +0530
Message-ID: <20081106155025.GE25194@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:44413 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbYKFP6s (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 6 Nov 2008 10:58:48 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by ausmtp04.au.ibm.com (8.13.8/8.13.8) with ESMTP id mA6G6Qgn172650
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 03:06:27 +1100
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mA6FpB2K2777126
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 02:51:11 +1100
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mA6Fp6Nw009597
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 02:51:06 +1100
Received: from skywalker ([9.77.192.236])
	by d23av02.au.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id mA6FoQaW008900
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 7 Nov 2008 02:51:02 +1100
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I get this with ext4-patchqueue. I guess we have some ext3 patches queued there.

------------[ cut here ]------------
kernel BUG at fs/jbd/journal.c:412!
invalid opcode: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:03.0/0000:04:00.2/0000:05:01.1/irq
Modules linked in: autofs4 hidp rfkill input_polldev sbs sbshc battery ac parport_pc lp parport i6300esb i2c_i801 i2c_core e752x_edac edac_core tg3 libphy qla2xxx scsi_transport_fc dm_multipath dm_mirror dm_region_hash dm_log dm_mod loop xt_tcpudp ip6t_REJECT ipv6 ipt_REJECT x_tables sunrpc rfcomm bnep l2cap bluetooth bridge stp sg rtc_cmos rtc_core rtc_lib pcspkr button ata_piix libata mptspi mptscsih mptbase scsi_transport_spi sd_mod scsi_mod ext3 jbd uhci_hcd ohci_hcd ehci_hcd [last unloaded: ip_tables]

Pid: 29321, comm: fsstress Not tainted (2.6.28-rc3-autokern1 #2) IBM BladeCenter HS20 -[88432RG]-
EIP: 0060:[<c88808a0>] EFLAGS: 00210246 CPU: 0
EIP is at __log_space_left+0x15/0x2d [jbd]
EAX: 000000dd EBX: 00002000 ECX: 000024b1 EDX: 0000dddd
ESI: c68fc800 EDI: 00000000 EBP: c1a8cef8 ESP: c1a8cef8
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process fsstress (pid: 29321, ti=c1a8c000 task=c375b160 task.ti=c1a8c000)
Stack:
 c1a8cf10 c88800bd 00000000 c6df1b3c c6df1b00 c68fc800 c1a8cf4c c887ce08
 c4e38288 c68fc800 c68fc814 00000001 00000000 c1a8cf4c c044333c c4e3829c
 c1a8cf50 00200282 c4e38288 c68fc800 c4e3829c c1a8cf70 c887ceee 00000000
Call Trace:
 [<c88800bd>] ? __log_wait_for_space+0xdd/0x137 [jbd]
 [<c887ce08>] ? start_this_handle+0x2de/0x31d [jbd]
 [<c044333c>] ? lockdep_init_map+0x74/0x317
 [<c887ceee>] ? journal_start+0xa7/0xf2 [jbd]
 [<c887cf46>] ? journal_force_commit+0xd/0x1f [jbd]
 [<c88c069c>] ? ext3_force_commit+0x22/0x24 [ext3]
 [<c88c0f82>] ? ext3_sync_fs+0x10/0x29 [ext3]
 [<c0482e6c>] ? sync_filesystems+0xa4/0xe9
 [<c0499c4f>] ? do_sync+0x31/0x5a
 [<c0499c85>] ? sys_sync+0xd/0x14
 [<c0403a65>] ? sysenter_do_call+0x12/0x31
Code: 88 c8 00 00 00 00 a1 a0 82 88 c8 85 c0 74 05 e8 46 d0 bf f7 5d c3 55 8b 50 14 8b 88 cc 01 00 00 89 e5 89 d0 c1 f8 08 38 d0 75 04 <0f> 0b eb fe 8d 51 e0 31 c0 85 d2 7e 09 89 d0 c1 f8 03 29 c2 89
EIP: [<c88808a0>] __log_space_left+0x15/0x2d [jbd] SS:ESP 0068:c1a8cef8
---[ end trace e677f87f47dd07ca ]---

