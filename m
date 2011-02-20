From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 29492] New: [173348.989645] kernel BUG at
 /home/kernel-ppa/COD/linux/fs/inode.c:1421!
Date: Sun, 20 Feb 2011 00:09:38 GMT
Message-ID: <bug-29492-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:50463 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab1BTAJj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 19 Feb 2011 19:09:39 -0500
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.3) with ESMTP id p1K09cPn026625
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Sun, 20 Feb 2011 00:09:38 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=29492

           Summary: [173348.989645] kernel BUG at
                    /home/kernel-ppa/COD/linux/fs/inode.c:1421!
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.38-rc5
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: caravena@gmail.com
        Regression: No


Created an attachment (id=48452)
 --> (https://bugzilla.kernel.org/attachment.cgi?id=48452)
dmesg 2.6.38-rc5

Hello,

1) mount hardisk external USB
2) hard disk 3 partitions
3) delete partitions
4) create one partitions NTFS
5) unplugged hard disk, and message in dmesg

[173348.920276] ------------[ cut here ]------------
[173348.920329] kernel BUG at /home/kernel-ppa/COD/linux/fs/inode.c:1421!
[173348.920383] invalid opcode: 0000 [#1] SMP 
[173348.920416] last sysfs file:
/sys/devices/pci0000:00/0000:00:1d.7/usb2/speed
[173348.920459] CPU 0 
[173348.920474] Modules linked in: usb_storage uas btrfs zlib_deflate libcrc32c
ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs xfs exportfs reiserfs
binfmt_misc vboxnetadp vboxnetflt vboxdrv parport_pc ppdev
snd_hda_codec_realtek snd_hda_intel snd_hda_codec arc4 uvcvideo snd_hwdep
videodev snd_pcm ath9k mac80211 ath9k_common ath9k_hw v4l2_compat_ioctl32
snd_seq_midi snd_rawmidi snd_seq_midi_event joydev snd_seq snd_timer
snd_seq_device ath i915 snd cfg80211 soundcore drm_kms_helper drm
snd_page_alloc i2c_algo_bit sony_laptop video psmouse serio_raw lp parport
usbhid hid sdhci_pci sdhci firewire_ohci firewire_core crc_itu_t ahci libahci
sky2
[173348.921118] 
[173348.921132] Pid: 11218, comm: umount Not tainted 2.6.38-020638rc5-generic
#201102160907 Sony Corporation VGN-NS130FE/VAIO
[173348.921217] RIP: 0010:[<ffffffff81177d09>]  [<ffffffff81177d09>]
iput+0x49/0x50
[173348.921277] RSP: 0000:ffff880015831e08  EFLAGS: 00010202
[173348.921307] RAX: 0000000000003c3c RBX: ffff8800b3c2b1a0 RCX:
ffff8800235e73c0
[173348.921353] RDX: 0000000000000001 RSI: ffffffff81a317e0 RDI:
ffff8800b3c2b1a0
[173348.921401] RBP: ffff880015831e18 R08: ffff8800b4002300 R09:
ffff880066e03800
[173348.921452] R10: 0000000000000002 R11: 0000000000016bd0 R12:
ffff8800b3c2b0c0
[173348.921501] R13: ffff8800962f5c00 R14: ffff8800b3c2b0e0 R15:
0000000000000000
[173348.921554] FS:  00007fd85582f740(0000) GS:ffff8800b7800000(0000)
knlGS:0000000000000000
[173348.924068] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[173348.926515] CR2: 00007f6fae76a000 CR3: 000000004ae34000 CR4:
00000000000006f0
[173348.929054] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[173348.930017] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[173348.930017] Process umount (pid: 11218, threadinfo ffff880015830000, task
ffff88000e098000)
[173348.930017] Stack:
[173348.930017]  ffff880015831e28 ffff8800b3c2a3c0 ffff880015831e28
ffffffff81190d02
[173348.930017]  ffff880015831e68 ffffffff81191fda 000000830019f400
ffff8800b3c2b0c0
[173348.930017]  ffff8800b3c2b001 0000000000000083 ffff8800b3c2b0e0
0000000000000000
[173348.930017] Call Trace:
[173348.930017]  [<ffffffff81190d02>] bdput+0x12/0x20
[173348.930017]  [<ffffffff81191fda>] __blkdev_put+0xfa/0x1d0
[173348.930017]  [<ffffffff81192167>] blkdev_put+0xb7/0x160
[173348.930017]  [<ffffffff81160daa>] kill_block_super+0x4a/0x80
[173348.930017]  [<ffffffff8125bae4>] fuse_kill_sb_blk+0x54/0x70
[173348.930017]  [<ffffffff81160ea0>] deactivate_locked_super+0x30/0x60
[173348.930017]  [<ffffffff81161205>] deactivate_super+0x45/0x50
[173348.930017]  [<ffffffff8117c209>] mntput_no_expire+0x99/0xe0
[173348.930017]  [<ffffffff8117c7ca>] sys_umount+0x7a/0xd0
[173348.930017]  [<ffffffff8100c002>] system_call_fastpath+0x16/0x1b
[173348.930017] Code: bf b0 00 00 00 48 c7 c6 c0 b4 ce 81 e8 e1 73 15 00 85 c0
75 07 48 83 c4 08 5b c9 c3 48 89 df e8 ee fd ff ff 48 83 c4 08 5b c9 c3 <0f> 0b
eb fe 0f 1f 00 55 48 89 e5 41 56 41 55 41 54 53 0f 1f 44 
[173348.930017] RIP  [<ffffffff81177d09>] iput+0x49/0x50
[173348.930017]  RSP <ffff880015831e08>
[173348.987392] ------------[ cut here ]------------
[173348.989645] kernel BUG at /home/kernel-ppa/COD/linux/fs/inode.c:1421!
[173348.990413] invalid opcode: 0000 [#2] SMP 
[173348.990413] last sysfs file:
/sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda6/stat
[173348.990413] CPU 0 
[173348.990413] Modules linked in: usb_storage uas btrfs zlib_deflate libcrc32c
ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs xfs exportfs reiserfs
binfmt_misc vboxnetadp vboxnetflt vboxdrv parport_pc ppdev
snd_hda_codec_realtek snd_hda_intel snd_hda_codec arc4 uvcvideo snd_hwdep
videodev snd_pcm ath9k mac80211 ath9k_common ath9k_hw v4l2_compat_ioctl32
snd_seq_midi snd_rawmidi snd_seq_midi_event joydev snd_seq snd_timer
snd_seq_device ath i915 snd cfg80211 soundcore drm_kms_helper drm
snd_page_alloc i2c_algo_bit sony_laptop video psmouse serio_raw lp parport
usbhid hid sdhci_pci sdhci firewire_ohci firewire_core crc_itu_t ahci libahci
sky2
[173348.990413] 
[173348.990413] Pid: 11222, comm: umount Not tainted 2.6.38-020638rc5-generic
#201102160907 Sony Corporation VGN-NS130FE/VAIO
[173348.990413] RIP: 0010:[<ffffffff81177d09>]  [<ffffffff81177d09>]
iput+0x49/0x50
[173348.990413] RSP: 0018:ffff880075e3fe08  EFLAGS: 00010202
[173348.990413] RAX: 0000000000005a5a RBX: ffff8800b3c2ab20 RCX:
ffff8800235e78d0
[173348.990413] RDX: 0000000000000001 RSI: ffffffff81a317e0 RDI:
ffff8800b3c2ab20
[173348.990413] RBP: ffff880075e3fe18 R08: ffff8800b4002300 R09:
ffff880066e03800
[173348.990413] R10: ffff8800b0848660 R11: 0000000000000001 R12:
ffff8800b3c2aa40
[173348.990413] R13: ffff8800962f5c00 R14: ffff8800b3c2aa60 R15:
0000000000000000
[173348.990413] FS:  00007fe6c719b740(0000) GS:ffff8800b7800000(0000)
knlGS:0000000000000000
[173348.990413] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[173348.990413] CR2: 00007f6fae76a000 CR3: 0000000012ab6000 CR4:
00000000000006f0
[173348.990413] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[173348.990413] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[173348.990413] Process umount (pid: 11222, threadinfo ffff880075e3e000, task
ffff880017d1c440)
[173348.990413] Stack:
[173348.990413]  ffff880075e3fe28 ffff8800b3c2a3c0 ffff880075e3fe28
ffffffff81190d02
[173348.990413]  ffff880075e3fe68 ffffffff81191fda 0000008300069400
ffff8800b3c2aa40
[173348.990413]  ffff8800b3c2aa01 0000000000000083 ffff8800b3c2aa60
0000000000000000
[173348.990413] Call Trace:
[173348.990413]  [<ffffffff81190d02>] bdput+0x12/0x20
[173348.990413]  [<ffffffff81191fda>] __blkdev_put+0xfa/0x1d0
[173348.990413]  [<ffffffff81192167>] blkdev_put+0xb7/0x160
[173348.990413]  [<ffffffff81160daa>] kill_block_super+0x4a/0x80
[173348.990413]  [<ffffffff8125bae4>] fuse_kill_sb_blk+0x54/0x70
[173348.990413]  [<ffffffff81160ea0>] deactivate_locked_super+0x30/0x60
[173348.990413]  [<ffffffff81161205>] deactivate_super+0x45/0x50
[173348.990413]  [<ffffffff8117c209>] mntput_no_expire+0x99/0xe0
[173348.990413]  [<ffffffff8117c7ca>] sys_umount+0x7a/0xd0
[173348.990413]  [<ffffffff8100c002>] system_call_fastpath+0x16/0x1b
[173348.990413] Code: bf b0 00 00 00 48 c7 c6 c0 b4 ce 81 e8 e1 73 15 00 85 c0
75 07 48 83 c4 08 5b c9 c3 48 89 df e8 ee fd ff ff 48 83 c4 08 5b c9 c3 <0f> 0b
eb fe 0f 1f 00 55 48 89 e5 41 56 41 55 41 54 53 0f 1f 44 
[173348.990413] RIP  [<ffffffff81177d09>] iput+0x49/0x50
[173348.990413]  RSP <ffff880075e3fe08>
[173349.087964] ---[ end trace f1a0bedd8445bc21 ]---
[173349.151227] ---[ end trace f1a0bedd8445bc22 ]---
[173362.986378] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
