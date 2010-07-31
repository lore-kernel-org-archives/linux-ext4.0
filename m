From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 16486] New: general protection fault: 0000 [#1] PREEMPT SMP
Date: Sat, 31 Jul 2010 20:33:26 GMT
Message-ID: <bug-16486-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:35797 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab0GaUd1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 31 Jul 2010 16:33:27 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.4/8.14.3) with ESMTP id o6VKXQ8g002389
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sat, 31 Jul 2010 20:33:26 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=16486

           Summary: general protection fault: 0000 [#1] PREEMPT SMP
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.35-rc6-00156-gfc0f5ac
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: ojab@ojab.ru
        Regression: No


[122308.842580] general protection fault: 0000 [#1] PREEMPT SMP 
[122308.842585] last sysfs file: /sys/devices/virtual/vc/vcsa7/uevent
[122308.842587] CPU 1 
[122308.842588] Modules linked in: snd_usb_audio ipv6 af_packet xt_tcpudp
ipt_REJECT ipt_LOG ipt_MASQUERADE nf_nat_ftp iptable_nat nf_nat xt_state
nf_conntrack_ftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_filter
ip_tables x_tables usbhid hid snd_usbmidi_lib radeon arc4 ecb snd_rawmidi
snd_seq_device ttm ath9k drm_kms_helper ath9k_common drm ath9k_hw i2c_algo_bit
snd_hda_codec i2c_piix4 ath mac80211 i2c_core snd_hwdep snd_pcm evdev sr_mod
snd_timer cfbcopyarea snd 8250_pnp processor ohci_hcd psmouse thermal button
ehci_hcd cdrom r8169 cfbimgblt edac_core cfg80211 soundcore mii led_class
rtc_cmos sg cfbfillrect thermal_sys usbcore rtc_core 8250 snd_page_alloc
k10temp hwmon serial_core rtc_lib shpchp pci_hotplug unix fbcon tileblit font
bitblit fbcon_rotate fbcon_cw fbcon_ud fbcon_ccw softcursor fb fbdev [last
unloaded: snd_hda_intel]
[122308.842634] 
[122308.842637] Pid: 398, comm: cp Not tainted 2.6.35-rc6-ojab-00156-gfc0f5ac
#1 790GX-G65 (MS-7576)        /MS-7576
[122308.842639] RIP: 0010:[<ffffffff8109778c>]  [<ffffffff8109778c>]
find_get_page+0x3c/0xb0
[122308.842646] RSP: 0018:ffff880076cb5b28  EFLAGS: 00010293
[122308.842647] RAX: d491210000300187 RBX: ffff88003fa773f8 RCX:
ffff880000800040
[122308.842649] RDX: 0000000000000001 RSI: 0000000000000005 RDI:
d491210000300188
[122308.842651] RBP: 0000000000000005 R08: d491210000300188 R09:
ffff880076cb5ce0
[122308.842652] R10: a80004a59fc00000 R11: 0000000000000000 R12:
d491210000300188
[122308.842654] R13: 0000000000000005 R14: 00000000000000d0 R15:
0000000000000000
[122308.842656] FS:  00007f13900a5720(0000) GS:ffff880001900000(0000)
knlGS:0000000000000000
[122308.842658] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[122308.842660] CR2: 0000000000520950 CR3: 0000000076d28000 CR4:
00000000000006e0
[122308.842662] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[122308.842663] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[122308.842665] Process cp (pid: 398, threadinfo ffff880076cb4000, task
ffff88007c81b560)
[122308.842667] Stack:
[122308.842668]  ffff88003fa773f0 0000000000000005 ffff88003fa773f0
ffffffff8109781f
[122308.842671] <0> 0000000000000001 ffffffff810406d9 0000000000000001
00000000ffffffff
[122308.842673] <0> 0000000000001000 ffffffff810978cb 0000000000001000
ffffffff81145fc3
[122308.842677] Call Trace:
[122308.842680]  [<ffffffff8109781f>] ? find_lock_page+0x1f/0x80
[122308.842683]  [<ffffffff810406d9>] ? get_parent_ip+0x9/0x20
[122308.842686]  [<ffffffff810978cb>] ? grab_cache_page_write_begin+0x4b/0xd0
[122308.842689]  [<ffffffff81145fc3>] ? ext3_mark_inode_dirty+0x33/0x50
[122308.842691]  [<ffffffff81148340>] ? ext3_write_begin+0x80/0x240
[122308.842694]  [<ffffffff8109739d>] ? generic_file_buffered_write+0xfd/0x280
[122308.842698]  [<ffffffff810ffe0a>] ? generic_getxattr+0x5a/0x80
[122308.842701]  [<ffffffff81098659>] ? __generic_file_aio_write+0x229/0x420
[122308.842703]  [<ffffffff81098e70>] ? generic_file_aio_read+0x550/0x6a0
[122308.842706]  [<ffffffff810988b3>] ? generic_file_aio_write+0x63/0xd0
[122308.842709]  [<ffffffff810e2d3f>] ? do_sync_write+0xbf/0x100
[122308.842711]  [<ffffffff810e3446>] ? vfs_write+0xb6/0x190
[122308.842714]  [<ffffffff810e378e>] ? sys_write+0x4e/0x90
[122308.842716]  [<ffffffff81002d02>] ? system_call_fastpath+0x16/0x1b
[122308.842718] Code: fe ff 48 89 ee 48 89 df e8 42 e6 0f 00 48 85 c0 48 89 c1
74 4a 48 8b 38 40 f6 c7 01 75 e4 48 8d 47 ff 49 89 fc 48 83 f8 fd 77 d7 <8b> 57
08 4c 8d 4f 08 85 d2 74 cc 44 8d 42 01 89 d0 f0 44 0f b1 
[122308.842742] RIP  [<ffffffff8109778c>] find_get_page+0x3c/0xb0
[122308.842745]  RSP <ffff880076cb5b28>
[122308.842747] ---[ end trace 87329d9708ff3d77 ]---

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
