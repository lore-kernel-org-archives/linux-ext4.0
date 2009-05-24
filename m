From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 13369] kernel BUG at fs/ext4/inode.c:3123
Date: Sun, 24 May 2009 20:43:23 GMT
Message-ID: <200905242043.n4OKhNfc005658@demeter.kernel.org>
References: <bug-13369-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43339 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbZEXUnV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 24 May 2009 16:43:21 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n4OKhN5M005659
	for <linux-ext4@vger.kernel.org>; Sun, 24 May 2009 20:43:23 GMT
In-Reply-To: <bug-13369-13602@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=13369





--- Comment #13 from Chris Komner <ckom26@gmail.com>  2009-05-24 20:43:22 ---
I applied both patches, recompiled and rebooted. A few seconds after ktorrent
started, I got this:

kernel BUG at fs/ext4/inode.c:3123!
invalid opcode: 0000 [#1] PREEMPT SMP 
last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq
Modules linked in: nvidia(P) oss_usb oss_hdaudio osscore aes_i586 aes_generic
ipt_MASQUERADE ipt_REDIRECT xt_multiport xt_tcpudp xt_conntrack xt_state
iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter
ip_tables x_tables uvcvideo videodev v4l1_compat uhci_hcd sr_mod ohci1394
sdhci_pci sdhci ieee1394 cdrom mmc_core ehci_hcd ac button battery sg i2c_i801
usbcore i2c_core psmouse ata_piix evdev arc4 ecb iwl3945 iwlcore mac80211
led_class cfg80211 fuse dell_laptop backlight rfkill b44 dcdbas mii rtc_cmos
rtc_core rtc_lib [last unloaded: soundcore]

Pid: 1060, comm: kjournald2 Tainted: P           (2.6.30-rc6-git6 #2) Vostro
1500                     
EIP: 0060:[<c01ffd13>] EFLAGS: 00010202 CPU: 1
EIP is at ext4_normal_writepage+0x183/0x190
EAX: 00000001 EBX: c28cb8e0 ECX: 00001000 EDX: 00000000
ESI: 00001000 EDI: 00000000 EBP: f756be00 ESP: f756bdd4
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process kjournald2 (pid: 1060, ti=f756a000 task=f6d33390 task.ti=f756a000)
Stack:
 00001000 00000000 c01fc0f0 8000082d 0000000c 00000000 f756bf1c 10541259
 eb4d7d30 00000002 eb4d7d30 f756bea0 c01780d7 10541259 c28cb8e0 c01789b9
 00000000 00000007 10541259 00000000 00000001 eb4d7d30 c01780c0 f74fc0a8
Call Trace:
 [<c01fc0f0>] ? ext4_bh_unmapped_or_delay+0x0/0x50
 [<c01780d7>] ? __writepage+0x17/0x60
 [<c01789b9>] ? write_cache_pages+0x1a9/0x3f0
 [<c01780c0>] ? __writepage+0x0/0x60
 [<c01ffb90>] ? ext4_normal_writepage+0x0/0x190
 [<c0178c27>] ? generic_writepages+0x27/0x50
 [<c02228d2>] ? jbd2_journal_commit_transaction+0x3b2/0x12b0
 [<c013eeaf>] ? try_to_del_timer_sync+0x4f/0x70
 [<c0227a87>] ? kjournald2+0xd7/0x230
 [<c014c430>] ? autoremove_wake_function+0x0/0x60
 [<c02279b0>] ? kjournald2+0x0/0x230
 [<c014c002>] ? kthread+0x52/0xa0
 [<c014bfb0>] ? kthread+0x0/0xa0
 [<c0103d67>] ? kernel_thread_helper+0x7/0x10
Code: 00 00 00 75 21 8b 4c 24 18 89 d8 83 c4 20 ba b0 17 20 c0 5b 5e 5f c9 e9
fc e5 fc ff f3 90 8b 4f 48 e9 b4 fe ff ff e8 6d 30 f3 ff <0f> 0b eb fe 0f 0b eb
fe 90 8d 74 26 00 55 89 e5 57 56 89 ce 53 
EIP: [<c01ffd13>] ext4_normal_writepage+0x183/0x190 SS:ESP 0068:f756bdd4
---[ end trace d3629642779515bf ]---


In between, I had booted the stock archlinux kernel, version 2.6.29.4 and I
couldn't reproduce the bug; instead I got these errors, which might be odd
because I had just e2fsck'ed the device:
ext4: find_group_flex failed, fallback succeeded dir 572486
ext4: find_group_flex failed, fallback succeeded dir 572439
ext4: find_group_flex failed, fallback succeeded dir 572469
ext4: find_group_flex failed, fallback succeeded dir 572470
ext4: find_group_flex failed, fallback succeeded dir 572478
ext4: find_group_flex failed, fallback succeeded dir 572444
ext4: find_group_flex failed, fallback succeeded dir 572477
ext4: find_group_flex failed, fallback succeeded dir 572447
ext4: find_group_flex failed, fallback succeeded dir 572482
ext4: find_group_flex failed, fallback succeeded dir 572446

Fsck is always needed for this partition, after the inode.c bug and the
mandatory cold reboot, otherwise it aborts:
ext4_abort called.
EXT4-fs error (device sda9): ext4_put_super: Couldn't clean up the journal

My kernel .config follows.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
