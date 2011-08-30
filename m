From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 42052] New: kernel BUG at
 build/buildd/linux-2.6.38/kernel/timer.c:668
Date: Tue, 30 Aug 2011 15:02:33 GMT
Message-ID: <bug-42052-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:39581 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab1H3PCe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Aug 2011 11:02:34 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.4) with ESMTP id p7UF2XKD024584
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 30 Aug 2011 15:02:33 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=42052

           Summary: kernel BUG at
                    build/buildd/linux-2.6.38/kernel/timer.c:668
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.38.8
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: sanjeevmk4890@gmail.com
        Regression: No


+++ This bug was initially created as a clone of Bug #12370 +++

Latest working kernel version: none
Earliest failing kernel version: 2.6.28
Distribution: mint

Hardware Environment: 
   Processor - 6x AMD Phenom II X6 1055T
   RAM - 1GB

Software Environment:
   Linux Mint 11 (Katya)
   Kernel - 2.6.38-8-generic(i686)

Problem Description:
On mounting the attached ext4 image the kernel prints a backtrace. The
backtrace ends with: *ERROR* invalid framebuffer id. The backtrace pasted here:

[  447.967920] ------------[ cut here ]------------
[  447.971889] kernel BUG at /build/buildd/linux-2.6.38/kernel/timer.c:668!
[  447.971889] invalid opcode: 0000 [#3] SMP
[  447.971889] last sysfs file: /sys/devices/virtual/block/loop2/removable
[  447.971889] Modules linked in: binfmt_misc pci_stub vboxpci vboxnetadp
vboxnetflt vboxdrv dm_crypt sp5100_tco i2c_piix4 snd_hda_codec_hdmi
asus_atk0110 snd_hda_codec_via snd_hda_intel k10temp snd_hda_codec ppdev
snd_hwdep snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event shpchp snd_seq
snd_timer snd_seq_device snd soundcore snd_page_alloc parport_pc lp parport
dm_raid45 xor btrfs zlib_deflate libcrc32c radeon ttm drm_kms_helper
firewire_ohci drm firewire_core usbhid ahci hid libahci crc_itu_t r8169
i2c_algo_bit pata_atiixp
[  447.971889]
[  447.971889] Pid: 2414, comm: mount Tainted: G      D     2.6.38-8-generic
#42-Ubuntu System manufacturer System Product Name/M4A785TD-V EVO
[  447.971889] EIP: 0060:[<c105e392>] EFLAGS: 00010246 CPU: 4
[  447.971889] EIP is at mod_timer+0x232/0x250
[  447.971889] EAX: 00000000 EBX: 014a277f ECX: 00000000 EDX: 014a277f
[  447.971889] ESI: ef5cae20 EDI: 000001ac EBP: ee91dc80 ESP: ee91dc64
[  447.971889]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[  448.072035] Process mount (pid: 2414, ti=ee91c000 task=ee92a5e0
task.ti=ee91c000)
[  448.072035] Stack:
[  448.072035]  ee91dc74 c10b6882 014a277f 00000000 f45b1400 ef656b7c 000001ac
ee91dc98
[  448.072035]  c11c144a c152dda2 ef656a00 00000000 00000000 ee91dca4 c11c5aa6
ef2d5f68
[  448.072035]  ee91dcd8 c11c7816 c15082d1 00000002 f6038310 f45b1400 00000000
ee92a5e0
[  448.072035] Call Trace:
[  448.072035]  [<c10b6882>] ? __delayacct_blkio_end+0x32/0x60
[  448.072035]  [<c11c144a>] __save_error_info.clone.59+0x7a/0xf0
[  448.072035]  [<c11c5aa6>] save_error_info+0x16/0x30
[  448.072035]  [<c11c7816>] ext4_error_inode+0x46/0xe0
[  448.072035]  [<c15082d1>] ? out_of_line_wait_on_bit+0x61/0x70
[  448.072035]  [<c106d3c0>] ? wake_bit_function+0x0/0x60
[  448.072035]  [<c11ce0a5>] __ext4_ext_check+0x1b5/0x210
[  448.072035]  [<c11cfdb0>] ext4_ext_check_inode+0x30/0x40
[  448.072035]  [<c11af86f>] ext4_iget+0x60f/0x730
[  448.072035]  [<c10fae58>] ? pcpu_next_pop+0x38/0x50
[  448.072035]  [<c10fba32>] ? pcpu_populate_chunk+0x92/0x360
[  448.072035]  [<c10fb399>] ? pcpu_alloc_area+0x109/0x250
[  448.072035]  [<c11c6c20>] ext4_get_journal+0x30/0x130
[  448.072035]  [<c10fc1ac>] ? pcpu_alloc+0x26c/0x360
[  448.072035]  [<c11c8292>] ext4_load_journal+0xa2/0x4c0
[  448.072035]  [<c11ca967>] ext4_fill_super+0x1347/0x1a70
[  448.072035]  [<c10fc1ac>] ? pcpu_alloc+0x26c/0x360
[  448.072035]  [<c1129a21>] mount_bdev+0x191/0x1d0
[  448.072035]  [<c11c9620>] ? ext4_fill_super+0x0/0x1a70
[  448.072035]  [<c11bfd0f>] ext4_mount+0x1f/0x30
[  448.072035]  [<c11c9620>] ? ext4_fill_super+0x0/0x1a70
[  448.072035]  [<c1129315>] vfs_kern_mount+0x75/0x250
[  448.072035]  [<c113fa63>] ? get_fs_type+0x33/0xb0
[  448.072035]  [<c11bfcf0>] ? ext4_mount+0x0/0x30
[  448.072035]  [<c112954e>] do_kern_mount+0x3e/0xe0
[  448.072035]  [<c1142993>] do_mount+0x1b3/0x1e0
[  448.072035]  [<c1142d2b>] sys_mount+0x6b/0xa0
[  448.072035]  [<c1509bf4>] syscall_call+0x7/0xb
[  448.072035] Code: ff 8b 5d ec 29 c3 c1 eb 08 e9 18 fe ff ff 8d 76 00 c7 45
e4 01 00 00 00 8b 45 e4 83 c4 10 5b 5e 5f 5d c3 8b 5d e8 e9 c3 fe ff ff <0f> 0b
8b 55 04 89 f0 e8 02 f9 ff ff e9 0a fe ff ff 8d b6 00 00
[  448.072035] EIP: [<c105e392>] mod_timer+0x232/0x250 SS:ESP 0068:ee91dc64
[  448.140440] ---[ end trace b3d414c7835387c1 ]---
[  460.292249] [drm:drm_mode_getfb] *ERROR* invalid framebuffer id


Was working on bug #12370. Followed the steps to reproduce the bug (given in
#12370) on 2.6.38 (what i'm using) and the backtrace was printed, mount failed. 

Steps to reproduce:
Mount the image provided with the following command:
mount -t ext4  -o loop ext4.212.img /media/tmp

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
