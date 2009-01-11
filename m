From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12433] New: Oops while resizing an ext4 LVM2 volume
Date: Sun, 11 Jan 2009 12:20:13 -0800 (PST)
Message-ID: <bug-12433-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751859AbZAKUUR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Jan 2009 15:20:17 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0BKKDvU016512
	for <linux-ext4@vger.kernel.org>; Sun, 11 Jan 2009 12:20:14 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12433

           Summary: Oops while resizing an ext4 LVM2 volume
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.29-rc1
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: peter@kerwien.homeip.net


Latest working kernel version: N/A
Earliest failing kernel version: 2.6.29-rc1
Distribution: Gentoo Linux amd64
Hardware Environment: 
Software Environment: e2fsprogs-1.41.3
Problem Description: During a resize of an ext4 formated lvm2 volume, a NULL
pointer was derefrenced.

When I executed this command on a mounted LVM2 volume:

# resize2fs /dev/vg1/ftp

The following error happened:

Jan 11 20:56:41 kerwien kernel: BUG: unable to handle kernel NULL pointer
dereference at (null)
Jan 11 20:56:41 kerwien kernel: IP: [<ffffffffa01c6b59>]
ext4_block_bitmap+0x9/0x30 [ext4]
Jan 11 20:56:41 kerwien kernel: PGD 1a873067 PUD 3eded067 PMD 0 
Jan 11 20:56:41 kerwien kernel: Oops: 0000 [#1] SMP 
Jan 11 20:56:41 kerwien kernel: last sysfs file:
/sys/devices/virtual/block/dm-0/range
Jan 11 20:56:41 kerwien kernel: CPU 0 
Jan 11 20:56:41 kerwien kernel: Modules linked in: ide_cd_mod cdrom dm_mod
zlib_deflate zlib_inflate cryptomgr aead crypto_blkcipher crc32c libcrc32c
crypto_hash crypto_algapi nfs lockd sunrpc cpufreq_ondemand snd_seq
snd_seq_device ext4 jbd2 crc16 powernow_k8 freq_table usbhid snd_intel8x0
snd_ac97_codec ac97_bus snd_pcm ehci_hcd ohci_hcd snd_timer floppy snd sg
usbcore forcedeth soundcore k8temp snd_page_alloc hwmon thermal processor
button ext3 jbd mbcache sata_nv libata sd_mod amd74xx [last unloaded: cdrom]
Jan 11 20:56:41 kerwien kernel: Pid: 5202, comm: resize2fs Not tainted
2.6.29-rc1 #3
Jan 11 20:56:41 kerwien kernel: RIP: 0010:[<ffffffffa01c6b59>] 
[<ffffffffa01c6b59>] ext4_block_bitmap+0x9/0x30 [ext4]
Jan 11 20:56:41 kerwien kernel: RSP: 0018:ffff88001a9cdbc0  EFLAGS: 00010246
Jan 11 20:56:41 kerwien kernel: RAX: ffff88003ec90000 RBX: 0000000000000200
RCX: 00000000c0000100
Jan 11 20:56:41 kerwien kernel: RDX: 0000000000000000 RSI: 0000000000000000
RDI: ffff8800333dfc00
Jan 11 20:56:41 kerwien kernel: RBP: ffff8800333dfc00 R08: ffff88001a9cc000
R09: 0000000000000000
Jan 11 20:56:41 kerwien kernel: R10: ffff880001011ff0 R11: 0000000000000001
R12: 0000000000000202
Jan 11 20:56:41 kerwien kernel: R13: ffff88003ec90000 R14: 0000000000000000
R15: ffff88003ec90000
Jan 11 20:56:41 kerwien kernel: FS:  00007fa469b62710(0000)
GS:ffffffff80593040(0000) knlGS:00000000f7caeaf0
Jan 11 20:56:41 kerwien kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Jan 11 20:56:41 kerwien kernel: CR2: 0000000000000000 CR3: 000000003eaa6000
CR4: 00000000000006e0
Jan 11 20:56:41 kerwien kernel: DR0: 0000000000000000 DR1: 0000000000000000
DR2: 0000000000000000
Jan 11 20:56:41 kerwien kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0
DR7: 0000000000000400
Jan 11 20:56:41 kerwien kernel: Process resize2fs (pid: 5202, threadinfo
ffff88001a9cc000, task ffff88003ef5e310)
Jan 11 20:56:41 kerwien kernel: Stack:
Jan 11 20:56:41 kerwien kernel:  ffffffffa01b8877 0000000000000003
0000000000000246 0000800000000191
Jan 11 20:56:41 kerwien kernel:  ffff88003f7b0a20 0000000000000000
ffff88000a5c23d8 0000000000000000
Jan 11 20:56:41 kerwien kernel:  ffff88003ed400c0 ffff88003e40e888
ffff8800333dfc00 0000000000000191
Jan 11 20:56:41 kerwien kernel: Call Trace:
Jan 11 20:56:41 kerwien kernel:  [<ffffffffa01b8877>] ?
ext4_init_block_bitmap+0x347/0x3d0 [ext4]
Jan 11 20:56:41 kerwien kernel:  [<ffffffffa01d5955>] ?
ext4_mb_add_groupinfo+0x105/0x1f0 [ext4]
Jan 11 20:56:41 kerwien kernel:  [<ffffffffa01cdbf1>] ?
ext4_group_add+0xa01/0x1330 [ext4]
Jan 11 20:56:41 kerwien kernel:  [<ffffffff802b3c80>] ? sync_buffer+0x0/0x50
Jan 11 20:56:41 kerwien kernel:  [<ffffffff80430290>] ? io_schedule+0x20/0x30
Jan 11 20:56:41 kerwien kernel:  [<ffffffff8024fa70>] ?
wake_bit_function+0x0/0x30
Jan 11 20:56:41 kerwien kernel:  [<ffffffffa01c26bf>] ? ext4_ioctl+0x55f/0x6d0
[ext4]
Jan 11 20:56:41 kerwien kernel:  [<ffffffff8035af48>] ?
do_output_char+0x208/0x210
Jan 11 20:56:41 kerwien kernel:  [<ffffffff8024fc39>] ?
remove_wait_queue+0x19/0x60
Jan 11 20:56:41 kerwien kernel:  [<ffffffff80230903>] ? __wake_up+0x43/0x70
Jan 11 20:56:41 kerwien kernel:  [<ffffffff8029f74f>] ? vfs_ioctl+0x2f/0xa0
Jan 11 20:56:41 kerwien kernel:  [<ffffffff8029f9db>] ?
do_vfs_ioctl+0x21b/0x530
Jan 11 20:56:41 kerwien kernel:  [<ffffffff8042fc9f>] ?
thread_return+0x41/0x592
Jan 11 20:56:41 kerwien kernel:  [<ffffffff8029fd39>] ? sys_ioctl+0x49/0x80
Jan 11 20:56:41 kerwien kernel:  [<ffffffff8020c335>] ?
device_not_available+0x15/0x20
Jan 11 20:56:41 kerwien kernel:  [<ffffffff8020b61b>] ?
system_call_fastpath+0x16/0x1b
Jan 11 20:56:41 kerwien kernel: Code: 66 90 48 89 c7 45 31 ed e8 15 bd 0e e0 e9
e1 fa ff ff 0f 0b eb fe 90 90 90 90 90 90 90 90 90 90 90 90 48 8b 87 88 02 00
00 31 d2 <8b> 0e 48 83 38 3f 76 07 8b 56 20 48 c1 e2 20 89 c8 48 09 c2 48 
Jan 11 20:56:41 kerwien kernel: RIP  [<ffffffffa01c6b59>]
ext4_block_bitmap+0x9/0x30 [ext4]
Jan 11 20:56:41 kerwien kernel:  RSP <ffff88001a9cdbc0>
Jan 11 20:56:41 kerwien kernel: CR2: 0000000000000000
Jan 11 20:56:41 kerwien kernel: ---[ end trace 19e39679f9447577 ]---
Jan 11 20:56:41 kerwien kernel: ------------[ cut here ]------------
Jan 11 20:56:41 kerwien kernel: WARNING: at kernel/exit.c:1010
do_exit+0x72b/0x850()
Jan 11 20:56:41 kerwien kernel: Hardware name:  
Jan 11 20:56:41 kerwien kernel: Modules linked in: ide_cd_mod cdrom dm_mod
zlib_deflate zlib_inflate cryptomgr aead crypto_blkcipher crc32c libcrc32c
crypto_hash crypto_algapi nfs lockd sunrpc cpufreq_ondemand snd_seq
snd_seq_device ext4 jbd2 crc16 powernow_k8 freq_table usbhid snd_intel8x0
snd_ac97_codec ac97_bus snd_pcm ehci_hcd ohci_hcd snd_timer floppy snd sg
usbcore forcedeth soundcore k8temp snd_page_alloc hwmon thermal processor
button ext3 jbd mbcache sata_nv libata sd_mod amd74xx [last unloaded: cdrom]
Jan 11 20:56:41 kerwien kernel: Pid: 5202, comm: resize2fs Tainted: G      D   
2.6.29-rc1 #3
Jan 11 20:56:41 kerwien kernel: Call Trace:
Jan 11 20:56:41 kerwien kernel:  [<ffffffff8023afc2>] warn_slowpath+0xf2/0x130
Jan 11 20:56:41 kerwien kernel:  [<ffffffff80367f65>] notify_update+0x25/0x30
Jan 11 20:56:41 kerwien kernel:  [<ffffffff80368213>]
vt_console_print+0x223/0x2f0
Jan 11 20:56:41 kerwien kernel:  [<ffffffff8020bf4e>] common_interrupt+0xe/0x13
Jan 11 20:56:41 kerwien kernel:  [<ffffffff8023bca7>] vprintk+0x227/0x390
Jan 11 20:56:41 kerwien kernel:  [<ffffffff8023be5e>] printk+0x4e/0x60
Jan 11 20:56:41 kerwien kernel:  [<ffffffff8023be5e>] printk+0x4e/0x60
Jan 11 20:56:41 kerwien kernel:  [<ffffffff8023e73b>] do_exit+0x72b/0x850
Jan 11 20:56:41 kerwien kernel:  [<ffffffff80253886>] up+0x16/0x50
Jan 11 20:56:41 kerwien kernel:  [<ffffffff8032ccb0>] bit_cursor+0x0/0x5e0
Jan 11 20:56:41 kerwien kernel:  [<ffffffff8023b7e5>]
release_console_sem+0x1b5/0x1f0
Jan 11 20:56:41 kerwien kernel:  [<ffffffff8020f5a5>] oops_end+0xa5/0xb0
Jan 11 20:56:41 kerwien kernel:  [<ffffffff80228b53>] do_page_fault+0x323/0x890
Jan 11 20:56:41 kerwien kernel:  [<ffffffffa01c7fe6>] ext4_error+0x96/0xc0
[ext4]
Jan 11 20:56:41 kerwien kernel:  [<ffffffff80431cef>] page_fault+0x1f/0x30
Jan 11 20:56:41 kerwien kernel:  [<ffffffffa01c6b59>]
ext4_block_bitmap+0x9/0x30 [ext4]
Jan 11 20:56:41 kerwien kernel:  [<ffffffffa01b8877>]
ext4_init_block_bitmap+0x347/0x3d0 [ext4]
Jan 11 20:56:41 kerwien kernel:  [<ffffffffa01d5955>]
ext4_mb_add_groupinfo+0x105/0x1f0 [ext4]
Jan 11 20:56:41 kerwien kernel:  [<ffffffffa01cdbf1>]
ext4_group_add+0xa01/0x1330 [ext4]
Jan 11 20:56:41 kerwien kernel:  [<ffffffff802b3c80>] sync_buffer+0x0/0x50
Jan 11 20:56:41 kerwien kernel:  [<ffffffff80430290>] io_schedule+0x20/0x30
Jan 11 20:56:41 kerwien kernel:  [<ffffffff8024fa70>]
wake_bit_function+0x0/0x30
Jan 11 20:56:41 kerwien kernel:  [<ffffffffa01c26bf>] ext4_ioctl+0x55f/0x6d0
[ext4]
Jan 11 20:56:41 kerwien kernel:  [<ffffffff8035af48>]
do_output_char+0x208/0x210
Jan 11 20:56:41 kerwien kernel:  [<ffffffff8024fc39>]
remove_wait_queue+0x19/0x60
Jan 11 20:56:41 kerwien kernel:  [<ffffffff80230903>] __wake_up+0x43/0x70
Jan 11 20:56:41 kerwien kernel:  [<ffffffff8029f74f>] vfs_ioctl+0x2f/0xa0
Jan 11 20:56:41 kerwien kernel:  [<ffffffff8029f9db>] do_vfs_ioctl+0x21b/0x530
Jan 11 20:56:41 kerwien kernel:  [<ffffffff8042fc9f>] thread_return+0x41/0x592
Jan 11 20:56:41 kerwien kernel:  [<ffffffff8029fd39>] sys_ioctl+0x49/0x80
Jan 11 20:56:41 kerwien kernel:  [<ffffffff8020c335>]
device_not_available+0x15/0x20
Jan 11 20:56:41 kerwien kernel:  [<ffffffff8020b61b>]
system_call_fastpath+0x16/0x1b
Jan 11 20:56:41 kerwien kernel: ---[ end trace 19e39679f9447578 ]---
Jan 11 20:57:27 kerwien kernel: ------------[ cut here ]------------
Jan 11 20:57:27 kerwien kernel: WARNING: at fs/namespace.c:636
mntput_no_expire+0x146/0x150()
Jan 11 20:57:27 kerwien kernel: Hardware name:  
Jan 11 20:57:27 kerwien kernel: Modules linked in: ide_cd_mod cdrom dm_mod
zlib_deflate zlib_inflate cryptomgr aead crypto_blkcipher crc32c libcrc32c
crypto_hash crypto_algapi nfs lockd sunrpc cpufreq_ondemand snd_seq
snd_seq_device ext4 jbd2 crc16 powernow_k8 freq_table usbhid snd_intel8x0
snd_ac97_codec ac97_bus snd_pcm ehci_hcd ohci_hcd snd_timer floppy snd sg
usbcore forcedeth soundcore k8temp snd_page_alloc hwmon thermal processor
button ext3 jbd mbcache sata_nv libata sd_mod amd74xx [last unloaded: cdrom]
Jan 11 20:57:27 kerwien kernel: Pid: 5230, comm: umount Tainted: G      D W 
2.6.29-rc1 #3
Jan 11 20:57:27 kerwien kernel: Call Trace:
Jan 11 20:57:27 kerwien kernel:  [<ffffffff8023afc2>] warn_slowpath+0xf2/0x130
Jan 11 20:57:27 kerwien kernel:  [<ffffffff802a8c75>]
mntput_no_expire+0x35/0x150
Jan 11 20:57:27 kerwien kernel:  [<ffffffff8029cf29>]
__link_path_walk+0xbe9/0xd50
Jan 11 20:57:27 kerwien kernel:  [<ffffffff802305cc>] update_curr+0x6c/0xc0
Jan 11 20:57:27 kerwien kernel:  [<ffffffff802305cc>] update_curr+0x6c/0xc0
Jan 11 20:57:27 kerwien kernel:  [<ffffffff8023055a>]
wakeup_preempt_entity+0x3a/0x40
Jan 11 20:57:27 kerwien kernel:  [<ffffffff80237413>]
check_preempt_wakeup+0x113/0x150
Jan 11 20:57:27 kerwien kernel:  [<ffffffff80233dae>]
try_to_wake_up+0x10e/0x1b0
Jan 11 20:57:27 kerwien kernel:  [<ffffffff802a1bd5>] pollwake+0x55/0x60
Jan 11 20:57:27 kerwien kernel:  [<ffffffff80233e50>]
default_wake_function+0x0/0x10
Jan 11 20:57:27 kerwien kernel:  [<ffffffff8022fdcb>]
__wake_up_common+0x5b/0x90
Jan 11 20:57:27 kerwien kernel:  [<ffffffff802a8d86>]
mntput_no_expire+0x146/0x150
Jan 11 20:57:27 kerwien kernel:  [<ffffffff802a9066>] sys_umount+0x76/0x380
Jan 11 20:57:27 kerwien kernel:  [<ffffffff8020b61b>]
system_call_fastpath+0x16/0x1b
Jan 11 20:57:27 kerwien kernel: ---[ end trace 19e39679f9447579 ]---

Steps to reproduce: Unknown. I have resized ext4 volumes a couple of time. This
error has only happened once so far.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
