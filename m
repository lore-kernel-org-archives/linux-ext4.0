From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 195757] New: WARNING: CPU: 0 PID: 761 at
 /home/kernel/COD/linux/fs/super.c:1281 super_setup_bdi_name+0xcf/0xe0
Date: Sun, 14 May 2017 16:46:30 +0000
Message-ID: <bug-195757-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:44862 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754032AbdENQqd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 14 May 2017 12:46:33 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 8A27E2894F
        for <linux-ext4@vger.kernel.org>; Sun, 14 May 2017 16:46:32 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=195757

            Bug ID: 195757
           Summary: WARNING: CPU: 0 PID: 761 at
                    /home/kernel/COD/linux/fs/super.c:1281
                    super_setup_bdi_name+0xcf/0xe0
           Product: File System
           Version: 2.5
    Kernel Version: 4.12.0-041200rc1-generic
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: caravena@gmail.com
        Regression: No

Created attachment 256517
  --> https://bugzilla.kernel.org/attachment.cgi?id=256517&action=edit
dmesg - Linux version 4.12.0-041200rc1-generic

dmesg:
[    9.153856] ------------[ cut here ]------------
[    9.153864] WARNING: CPU: 0 PID: 761 at
/home/kernel/COD/linux/fs/super.c:1281 super_setup_bdi_name+0xcf/0xe0
[    9.153865] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_realtek
snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep
snd_pcm uvcvideo videobuf2_vmalloc videobuf2_memops snd_seq_midi samsung_laptop
videobuf2_v4l2 snd_seq_midi_event videobuf2_core intel_rapl videodev
x86_pkg_temp_thermal intel_powerclamp coretemp snd_rawmidi media btusb arc4
kvm_intel btrtl iwldvm btbcm btintel mac80211 kvm bluetooth snd_seq irqbypass
crct10dif_pclmul crc32_pclmul ecdh_generic ghash_clmulni_intel snd_seq_device
cryptd intel_cstate iwlwifi snd_timer intel_rapl_perf snd joydev input_leds
cfg80211 serio_raw mei_me mei lpc_ich soundcore shpchp dell_smo8800 mac_hid
parport_pc ppdev lp parport ip_tables x_tables autofs4 btrfs xor raid6_pq
hid_generic usbhid hid i915 i2c_algo_bit drm_kms_helper
[    9.153920]  syscopyarea sysfillrect sysimgblt psmouse r8169 fb_sys_fops
ahci drm libahci mii wmi video
[    9.153933] CPU: 0 PID: 761 Comm: mount.ntfs Not tainted
4.12.0-041200rc1-generic #201705131731
[    9.153934] Hardware name: SAMSUNG ELECTRONICS CO., LTD.
530U3C/530U4C/SAMSUNG_NP1234567890, BIOS P14AAJ 04/15/2013
[    9.153936] task: ffff9abf4e2f1680 task.stack: ffffbb4742200000
[    9.153939] RIP: 0010:super_setup_bdi_name+0xcf/0xe0
[    9.153940] RSP: 0018:ffffbb4742203c50 EFLAGS: 00010283
[    9.153943] RAX: 0000000000000000 RBX: ffff9abf4c2ea400 RCX:
0000000000000002
[    9.153944] RDX: 0000000000000001 RSI: 00000000fffffe01 RDI:
ffffffffa0fd81bb
[    9.153945] RBP: ffffbb4742203cd0 R08: ffff9abf4e72e7b8 R09:
0000000000000000
[    9.153947] R10: fffffb3b8c24ae00 R11: 0000000000000000 R12:
ffff9abf4eb1e000
[    9.153948] R13: ffffffffa1ad914c R14: ffffbb4742203ce0 R15:
ffff9abf4eaa8d00
[    9.153950] FS:  00007f9c1f954e80(0000) GS:ffff9abf5f200000(0000)
knlGS:0000000000000000
[    9.153952] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    9.153953] CR2: 00007fff690d3be8 CR3: 0000000309073000 CR4:
00000000000406f0
[    9.153955] Call Trace:
[    9.153962]  ? kmem_cache_alloc_trace+0x181/0x190
[    9.153965]  fuse_fill_super+0x3b3/0x6a0
[    9.153968]  ? vsnprintf+0x24b/0x4d0
[    9.153970]  ? snprintf+0x45/0x70
[    9.153973]  mount_bdev+0x178/0x1b0
[    9.153975]  ? mount_bdev+0x178/0x1b0
[    9.153977]  ? fuse_get_root_inode+0x70/0x70
[    9.153980]  fuse_mount_blk+0x15/0x20
[    9.153982]  mount_fs+0x38/0x140
[    9.153987]  vfs_kern_mount+0x67/0x110
[    9.153989]  do_mount+0x1e1/0xca0
[    9.153993]  ? __check_object_size+0xb3/0x190
[    9.153996]  ? _copy_from_user+0x21/0x70
[    9.153998]  ? kmem_cache_alloc_trace+0x142/0x190
[    9.154001]  SyS_mount+0x83/0xd0
[    9.154005]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[    9.154007] RIP: 0033:0x7f9c1ee358fa
[    9.154008] RSP: 002b:00007fff690d4c38 EFLAGS: 00000246 ORIG_RAX:
00000000000000a5
[    9.154010] RAX: ffffffffffffffda RBX: 000055bd7a4ad500 RCX:
00007f9c1ee358fa
[    9.154012] RDX: 000055bd7bb938f0 RSI: 000055bd7bb8ec60 RDI:
000055bd7bb93c10
[    9.154013] RBP: 00007fff690d5f72 R08: 000055bd7bb93af0 R09:
0000000000000028
[    9.154014] R10: 0000000000000000 R11: 0000000000000246 R12:
000055bd7a2a6ca0
[    9.154015] R13: 0000000000000000 R14: 000055bd7bb8a010 R15:
000055bd7bb93820
[    9.154017] Code: a0 65 48 33 0c 25 28 00 00 00 75 2a 48 83 c4 58 5b 41 5a
41 5c 41 5d 41 5e 5d c3 48 89 df 89 45 84 e8 f6 10 f9 ff 8b 45 84 eb d2 <0f> ff
eb c6 b8 f4 ff ff ff eb c7 e8 01 d5 e3 ff 90 66 66 66 66 
[    9.154057] ---[ end trace 46647b011f6a356f ]---
[    9.208670] ------------[ cut here ]------------
[    9.208678] WARNING: CPU: 0 PID: 754 at
/home/kernel/COD/linux/fs/super.c:1281 super_setup_bdi_name+0xcf/0xe0
[    9.208679] Modules linked in: snd_hda_codec_hdmi snd_hda_codec_realtek
snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hda_core snd_hwdep
snd_pcm uvcvideo videobuf2_vmalloc videobuf2_memops snd_seq_midi samsung_laptop
videobuf2_v4l2 snd_seq_midi_event videobuf2_core intel_rapl videodev
x86_pkg_temp_thermal intel_powerclamp coretemp snd_rawmidi media btusb arc4
kvm_intel btrtl iwldvm btbcm btintel mac80211 kvm bluetooth snd_seq irqbypass
crct10dif_pclmul crc32_pclmul ecdh_generic ghash_clmulni_intel snd_seq_device
cryptd intel_cstate iwlwifi snd_timer intel_rapl_perf snd joydev input_leds
cfg80211 serio_raw mei_me mei lpc_ich soundcore shpchp dell_smo8800 mac_hid
parport_pc ppdev lp parport ip_tables x_tables autofs4 btrfs xor raid6_pq
hid_generic usbhid hid i915 i2c_algo_bit drm_kms_helper
[    9.208734]  syscopyarea sysfillrect sysimgblt psmouse r8169 fb_sys_fops
ahci drm libahci mii wmi video
[    9.208746] CPU: 0 PID: 754 Comm: mount.ntfs Tainted: G        W      
4.12.0-041200rc1-generic #201705131731
[    9.208747] Hardware name: SAMSUNG ELECTRONICS CO., LTD.
530U3C/530U4C/SAMSUNG_NP1234567890, BIOS P14AAJ 04/15/2013
[    9.208749] task: ffff9abf47610000 task.stack: ffffbb474207c000
[    9.208752] RIP: 0010:super_setup_bdi_name+0xcf/0xe0
[    9.208753] RSP: 0018:ffffbb474207fc50 EFLAGS: 00010283
[    9.208755] RAX: 0000000000000000 RBX: ffff9abf4c2e8000 RCX:
0000000000000002
[    9.208757] RDX: 0000000000000001 RSI: 00000000fffffe01 RDI:
ffffffffa0fd81bb
[    9.208758] RBP: ffffbb474207fcd0 R08: ffff9abf4e72dc38 R09:
0000000000000000
[    9.208759] R10: fffffb3b8c24ae00 R11: 0000000000000000 R12:
ffff9abf4eb1b800
[    9.208761] R13: ffffffffa1ad914c R14: ffffbb474207fce0 R15:
ffff9abf4e336800
[    9.208763] FS:  00007fa928d44e80(0000) GS:ffff9abf5f200000(0000)
knlGS:0000000000000000
[    9.208764] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    9.208766] CR2: 0000555e0063f5b0 CR3: 00000003089da000 CR4:
00000000000406f0
[    9.208767] Call Trace:
[    9.208774]  ? kmem_cache_alloc_trace+0x181/0x190
[    9.208778]  fuse_fill_super+0x3b3/0x6a0
[    9.208781]  ? vsnprintf+0x24b/0x4d0
[    9.208783]  ? snprintf+0x45/0x70
[    9.208786]  mount_bdev+0x178/0x1b0
[    9.208788]  ? mount_bdev+0x178/0x1b0
[    9.208790]  ? fuse_get_root_inode+0x70/0x70
[    9.208793]  fuse_mount_blk+0x15/0x20
[    9.208795]  mount_fs+0x38/0x140
[    9.208801]  vfs_kern_mount+0x67/0x110
[    9.208804]  do_mount+0x1e1/0xca0
[    9.208809]  ? __check_object_size+0xb3/0x190
[    9.208813]  ? _copy_from_user+0x21/0x70
[    9.208817]  ? kmem_cache_alloc_trace+0x142/0x190
[    9.208820]  SyS_mount+0x83/0xd0
[    9.208825]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[    9.208828] RIP: 0033:0x7fa9282258fa
[    9.208830] RSP: 002b:00007ffd7ec01958 EFLAGS: 00000246 ORIG_RAX:
00000000000000a5
[    9.208833] RAX: ffffffffffffffda RBX: 0000000000000000 RCX:
00007fa9282258fa
[    9.208836] RDX: 0000555e0119aa50 RSI: 0000555e01195c60 RDI:
0000555e0119ad70
[    9.208838] RBP: 00007ffd7ec01d40 R08: 0000555e0119ac50 R09:
0000000000000028
[    9.208840] R10: 0000000000000000 R11: 0000000000000246 R12:
0000555e0119a9e0
[    9.208842] R13: 0000000000000000 R14: 0000555e01191010 R15:
0000555e01191010
[    9.208844] Code: a0 65 48 33 0c 25 28 00 00 00 75 2a 48 83 c4 58 5b 41 5a
41 5c 41 5d 41 5e 5d c3 48 89 df 89 45 84 e8 f6 10 f9 ff 8b 45 84 eb d2 <0f> ff
eb c6 b8 f4 ff ff ff eb c7 e8 01 d5 e3 ff 90 66 66 66 66 
[    9.208902] ---[ end trace 46647b011f6a3570 ]---

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
