From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14562] New: On umount warn in page_alloc.c:1751
 __alloc_pages_slowpath
Date: Sun, 8 Nov 2009 22:52:59 GMT
Message-ID: <bug-14562-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:42956 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755626AbZKHWwx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 8 Nov 2009 17:52:53 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id nA8MqxD2022072
	for <linux-ext4@vger.kernel.org>; Sun, 8 Nov 2009 22:52:59 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14562

           Summary: On umount warn in page_alloc.c:1751
                    __alloc_pages_slowpath
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.31
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: tkrah@fachschaft.imn.htwk-leipzig.de
        Regression: No


Created a new ext4 fs on sda5.
Did copy my backup (about 40Gig back) und did a umount to the fs.
After this i got this warning:

[40844.609540] EXT4-fs (sda5): barriers enabled
[40844.627485] kjournald2 starting: pid 573, dev sda5:8, commit interval 5
seconds
[40844.627690] EXT4-fs (sda5): internal journal on sda5:8
[40844.627702] EXT4-fs (sda5): delayed allocation enabled
[40844.627711] EXT4-fs: file extents enabled
[40844.643621] EXT4-fs: mballoc enabled
[40844.643641] EXT4-fs (sda5): mounted filesystem with ordered data mode
[43805.914965] EXT4-fs: mballoc: 9254958 blocks 101031 reqs (81545 success)
[43805.914978] EXT4-fs: mballoc: 21054 extents scanned, 11670 goal hits, 18363
2^N hits, 0 breaks, 0 lost
[43805.914987] EXT4-fs: mballoc: 315 generated and it took 2147482
[43805.914995] EXT4-fs: mballoc: 6643657 preallocated, 1203082 discarded
[43809.377291] ------------[ cut here ]------------
[43809.377320] WARNING: at /build/buildd/linux-2.6.31/mm/page_alloc.c:1751
__alloc_pages_slowpath+0x459/0x480()
[43809.377330] Hardware name: CoronaR
[43809.377335] Modules linked in: usb_storage tun binfmt_misc lp vboxnetadp
vboxnetflt vboxdrv kqemu usblp snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm_oss
snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi pcmcia snd_rawmidi
snd_seq_midi_event snd_seq snd_timer yenta_socket snd_seq_device iptable_filter
rsrc_nonstatic iTCO_wdt ip_tables x_tables ipw2200 pcmcia_core snd soundcore
iTCO_vendor_support snd_page_alloc joydev libipw lib80211 shpchp ppdev
parport_pc parport asus_laptop led_class psmouse serio_raw irda crc_ccitt sbp2
fbcon tileblit font bitblit softcursor radeon ttm drm 8139too radeonfb fb_ddc
i2c_algo_bit 8139cp mii ohci1394 ieee1394 video output intel_agp agpgart
[43809.377504] Pid: 1017, comm: mount Tainted: G        W  2.6.31-14-generic
#48-Ubuntu
[43809.377512] Call Trace:
[43809.377531]  [<c014518d>] warn_slowpath_common+0x6d/0xa0
[43809.377544]  [<c01b8429>] ? __alloc_pages_slowpath+0x459/0x480
[43809.377556]  [<c01b8429>] ? __alloc_pages_slowpath+0x459/0x480
[43809.377569]  [<c01451d5>] warn_slowpath_null+0x15/0x20
[43809.377580]  [<c01b8429>] __alloc_pages_slowpath+0x459/0x480
[43809.377593]  [<c01b7e50>] ? get_page_from_freelist+0x1e0/0x360
[43809.377607]  [<c01b855f>] __alloc_pages_nodemask+0x10f/0x120
[43809.377620]  [<c01b85b7>] __get_free_pages+0x17/0x30
[43809.377633]  [<c01e088f>] __kmalloc+0xdf/0x180
[43809.377646]  [<c031974e>] match_number+0x2e/0xa0
[43809.377657]  [<c03197ea>] match_int+0xa/0x10
[43809.377670]  [<c0274102>] parse_options+0x152/0x810
[43809.377683]  [<c0209686>] ? __wait_on_buffer+0x26/0x30
[43809.377697]  [<c027be96>] ext4_fill_super+0x3f6/0x1900
[43809.377712]  [<c01ea0e5>] get_sb_bdev+0x135/0x170
[43809.377724]  [<c027baa0>] ? ext4_fill_super+0x0/0x1900
[43809.377737]  [<c01b8500>] ? __alloc_pages_nodemask+0xb0/0x120
[43809.377749]  [<c0272e21>] ext4_get_sb+0x21/0x30
[43809.377760]  [<c027baa0>] ? ext4_fill_super+0x0/0x1900
[43809.377772]  [<c01e9cde>] vfs_kern_mount+0x5e/0x120
[43809.377784]  [<c01e9df9>] do_kern_mount+0x39/0xd0
[43809.377797]  [<c01fee2e>] do_new_mount+0x6e/0xa0
[43809.377808]  [<c01ff7f9>] do_mount+0x1c9/0x1e0
[43809.377819]  [<c01ff876>] sys_mount+0x66/0xa0
[43809.377831]  [<c010336c>] syscall_call+0x7/0xb
[43809.377840] ---[ end trace a7919e7f17c0a727 ]---


I am using Ubuntu 9.10. Kernel config attached. e2fsprogs version 1.41.9.

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
