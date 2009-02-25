From: Andreas Friedrich Berendsen <afberendsen@gmail.com>
Subject: Kernel bug while cpio + resize2fs
Date: Wed, 25 Feb 2009 18:39:26 +1300
Message-ID: <1235540366.11758.44.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.217.174]:55159 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbZBYFji (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Feb 2009 00:39:38 -0500
Received: by gxk22 with SMTP id 22so8175267gxk.13
        for <linux-ext4@vger.kernel.org>; Tue, 24 Feb 2009 21:39:35 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Kernel: 26.6.28.7
efs2progs: 1.41.4

- One session cpio from a LV to a second LV
- A second session resizing dynamically the second LV

/* ---- output from the resize2fs command ---- */

[Linux 2.6.28.7.afb.fc10.4.x86_amd64/bash]
root@storage.berendsen.local:/root
# resize2fs -p /dev/mapper/vgstore-lvol13
resize2fs 1.41.4 (27-Jan-2009)
Filesystem at /dev/mapper/vgstore-lvol13 is mounted on /store/programs;
on-line resizing required
old desc_blocks = 51, new_desc_blocks = 54
Performing an on-line resize of /dev/mapper/vgstore-lvol13 to 225443840
(4k) blocks.
Killed

Message from syslogd@storage at Feb 25 18:30:48 ...
 kernel:Oops: 0002 [#1] SMP 

Message from syslogd@storage at Feb 25 18:30:48 ...
 kernel:last sysfs file: /sys/devices/pci0000:00/0000:00:09.0/irq


/* ---- Contents of /var/log/messages ---- */

Feb 25 18:30:48 storage kernel: BUG: unable to handle kernel paging
request at 000000000000ca84
Feb 25 18:30:48 storage kernel: IP: [<ffffffffa0d31d80>] ext4_group_add
+0x1394/0x147c [ext4]
Feb 25 18:30:48 storage kernel: PGD a8774067 PUD 73d2a067 PMD 0 
Feb 25 18:30:48 storage kernel: Oops: 0002 [#1] SMP 
Feb 25 18:30:48 storage kernel: last sysfs
file: /sys/devices/pci0000:00/0000:00:09.0/irq
Feb 25 18:30:48 storage kernel: Dumping ftrace buffer:
Feb 25 18:30:48 storage kernel:   (ftrace buffer empty)
Feb 25 18:30:48 storage kernel: CPU 0 
Feb 25 18:30:48 storage kernel: Modules linked in: ext4 jbd2 crc16 ext2
raid456 async_xor async_memcpy async_tx xor fuse ipt_MASQUERADE
iptable_nat nf_nat bridge stp nfsd lockd nfs_acl auth_rpcgss exportfs
vboxnetflt vboxdrv sunrpc bonding ipv6 dm_multipath kvm_amd kvm uinput
snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq
snd_seq_device snd_pcm_oss cfi_cmdset_0002 usblp jedec_probe
snd_mixer_oss snd_pcm cfi_probe nvidia(P) firewire_ohci snd_timer
snd_page_alloc snd_hwdep joydev serio_raw k8temp firewire_core pcspkr
snd hwmon forcedeth gen_probe sata_nv soundcore cfi_util crc_itu_t
ck804xrom mtd i2c_nforce2 chipreg i2c_core map_funcs usb_storage
ata_generic pata_acpi pata_amd [last unloaded: freq_table]
Feb 25 18:30:48 storage kernel: Pid: 25772, comm: resize2fs Tainted: P
W  2.6.28.7.afb.fc10.4.x86_amd64 #1
Feb 25 18:30:48 storage kernel: RIP: 0010:[<ffffffffa0d31d80>]
[<ffffffffa0d31d80>] ext4_group_add+0x1394/0x147c [ext4]
Feb 25 18:30:48 storage kernel: RSP: 0018:ffff8800a6a19bf8  EFLAGS:
00010202
Feb 25 18:30:48 storage kernel: RAX: 000000000000ca80 RBX:
ffff8800a6a19e18 RCX: 000000000000ca80
Feb 25 18:30:48 storage kernel: RDX: 0000000000007dfe RSI:
0000000000002000 RDI: ffff88011e1000e8
Feb 25 18:30:48 storage kernel: RBP: ffff8800a6a19de8 R08:
0000000000000000 R09: ffff88019f18d800
Feb 25 18:30:48 storage kernel: R10: ffff8800a6a19be8 R11:
ffff8800a6a19be8 R12: 0000000000000000
Feb 25 18:30:48 storage kernel: R13: 0000000000000000 R14:
0000000000000200 R15: ffff88019f18d800
Feb 25 18:30:48 storage kernel: FS:  00007ff1fea65710(0000)
GS:ffffffff8177b000(0000) knlGS:0000000000000000
Feb 25 18:30:48 storage kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
000000008005003b
Feb 25 18:30:48 storage kernel: CR2: 000000000000ca84 CR3:
0000000001e54000 CR4: 00000000000006e0
Feb 25 18:30:48 storage kernel: DR0: 0000000000000000 DR1:
0000000000000000 DR2: 0000000000000000
Feb 25 18:30:48 storage kernel: DR3: 0000000000000000 DR6:
00000000ffff0ff0 DR7: 0000000000000400
Feb 25 18:30:48 storage kernel: Process resize2fs (pid: 25772,
threadinfo ffff8800a6a18000, task ffff88017eee1700)
Feb 25 18:30:48 storage kernel: Stack:
Feb 25 18:30:48 storage kernel: ffff880028051540 ffff880028051ec0
ffff8800a690b000 ffff880102b0c538
Feb 25 18:30:48 storage kernel: 0000000000391d4b ffff8800280515b0
ffff880102b0c500 0000000000000003
Feb 25 18:30:48 storage kernel: ffff8800a6a19c68 000080008103990e
ffff8800a6a19e18 0000000000001950
Feb 25 18:30:48 storage kernel: Call Trace:
Feb 25 18:30:48 storage kernel: [<ffffffff8103de83>] ?
default_wake_function+0xd/0xf
Feb 25 18:30:48 storage kernel: [<ffffffff81058876>] ?
autoremove_wake_function+0x11/0x38
Feb 25 18:30:48 storage kernel: [<ffffffff8103553e>] ? __wake_up_common
+0x46/0x75
Feb 25 18:30:48 storage kernel: [<ffffffff81349afa>] ? _spin_lock
+0x9/0xc
Feb 25 18:30:48 storage kernel: [<ffffffffa0d27795>] ext4_ioctl
+0x568/0x656 [ext4]
Feb 25 18:30:48 storage kernel: [<ffffffff810d1b88>] vfs_ioctl+0x2a/0x78
Feb 25 18:30:48 storage kernel: [<ffffffff810d1f68>] do_vfs_ioctl
+0x392/0x3c0
Feb 25 18:30:48 storage kernel: [<ffffffff810d1feb>] sys_ioctl+0x55/0x77
Feb 25 18:30:48 storage kernel: [<ffffffff8101104a>]
system_call_fastpath+0x16/0x1b
Feb 25 18:30:48 storage kernel: Code: 40 60 f6 40 61 02 74 41 48 8b 95
80 fe ff ff 8b 03 8b 8a 18 23 00 00 48 d3 e8 48 c1 e0 03 48 89 c1 48 03
8a 20 23 00 00 8b 53 28 <01> 51 04 48 8b 8d 80 fe ff ff 49 8b 97 a0 02
00 00 48 03 81 20 
Feb 25 18:30:48 storage kernel: RIP  [<ffffffffa0d31d80>] ext4_group_add
+0x1394/0x147c [ext4]
Feb 25 18:30:48 storage kernel: RSP <ffff8800a6a19bf8>
Feb 25 18:30:48 storage kernel: CR2: 000000000000ca84
Feb 25 18:30:48 storage kernel: ---[ end trace e5919bb42fc21cbd ]---
Feb 25 18:30:48 storage kernel: ------------[ cut here ]------------
Feb 25 18:30:48 storage kernel: WARNING: at kernel/exit.c:1005 do_exit
+0x41/0x859()
Feb 25 18:30:48 storage kernel: Modules linked in: ext4 jbd2 crc16 ext2
raid456 async_xor async_memcpy async_tx xor fuse ipt_MASQUERADE
iptable_nat nf_nat bridge stp nfsd lockd nfs_acl auth_rpcgss exportfs
vboxnetflt vboxdrv sunrpc bonding ipv6 dm_multipath kvm_amd kvm uinput
snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq
snd_seq_device snd_pcm_oss cfi_cmdset_0002 usblp jedec_probe
snd_mixer_oss snd_pcm cfi_probe nvidia(P) firewire_ohci snd_timer
snd_page_alloc snd_hwdep joydev serio_raw k8temp firewire_core pcspkr
snd hwmon forcedeth gen_probe sata_nv soundcore cfi_util crc_itu_t
ck804xrom mtd i2c_nforce2 chipreg i2c_core map_funcs usb_storage
ata_generic pata_acpi pata_amd [last unloaded: freq_table]
Feb 25 18:30:48 storage kernel: Pid: 25772, comm: resize2fs Tainted: P
D W  2.6.28.7.afb.fc10.4.x86_amd64 #1
Feb 25 18:30:48 storage kernel: Call Trace:
Feb 25 18:30:48 storage kernel: [<ffffffff8104516d>] warn_on_slowpath
+0x58/0x7d
Feb 25 18:30:48 storage kernel: [<ffffffff810458a5>] ?
release_console_sem+0x1c6/0x1fb
Feb 25 18:30:48 storage kernel: [<ffffffff810458a5>] ?
release_console_sem+0x1c6/0x1fb
Feb 25 18:30:48 storage kernel: [<ffffffff810483de>] do_exit+0x41/0x859
Feb 25 18:30:48 storage kernel: [<ffffffff8134ae02>] oops_begin+0x0/0x8c
Feb 25 18:30:48 storage kernel: [<ffffffff8134cbd5>] do_page_fault
+0x9d7/0xacb
Feb 25 18:30:48 storage kernel: [<ffffffff81096555>] ?
__rmqueue_smallest+0x108/0x14f
Feb 25 18:30:48 storage kernel: [<ffffffff810965bb>] ? __rmqueue
+0x1f/0x1de
Feb 25 18:30:48 storage kernel: [<ffffffff8103de64>] ? try_to_wake_up
+0x267/0x279
Feb 25 18:30:48 storage kernel: [<ffffffff81096801>] ? rmqueue_bulk
+0x87/0x99
Feb 25 18:30:48 storage kernel: [<ffffffff8109ff78>] ? zone_statistics
+0x62/0x67
Feb 25 18:30:48 storage kernel: [<ffffffff810984e4>] ?
get_page_from_freelist+0x482/0x6d1
Feb 25 18:30:48 storage kernel: [<ffffffff8109aeec>] ?
add_page_to_lru_list+0x3c/0x41
Feb 25 18:30:48 storage kernel: [<ffffffff8109b918>] ? activate_page
+0x11c/0x130
Feb 25 18:30:48 storage kernel: [<ffffffff8109b984>] ?
mark_page_accessed+0x58/0x77
Feb 25 18:30:48 storage kernel: [<ffffffff810e3b63>] ? __find_get_block
+0x1aa/0x1bc
Feb 25 18:30:48 storage kernel: [<ffffffff81349afa>] ? _spin_lock
+0x9/0xc
Feb 25 18:30:48 storage kernel: [<ffffffff81349afa>] ? _spin_lock
+0x9/0xc
Feb 25 18:30:48 storage kernel: [<ffffffffa0d0f410>] ?
find_revoke_record+0x8c/0x9e [jbd2]
Feb 25 18:30:48 storage kernel: [<ffffffffa0d0a214>] ?
__jbd2_journal_temp_unlink_buffer+0x41/0xf6 [jbd2]
Feb 25 18:30:48 storage kernel: [<ffffffffa0d0f8b0>] ?
jbd2_journal_cancel_revoke+0x123/0x16f [jbd2]
Feb 25 18:30:48 storage kernel: [<ffffffff813499ce>] ?
trace_hardirqs_off_thunk+0x3a/0x6c
Feb 25 18:30:48 storage kernel: [<ffffffff81349f9f>] error_exit+0x0/0x75
Feb 25 18:30:48 storage kernel: [<ffffffffa0d31d80>] ? ext4_group_add
+0x1394/0x147c [ext4]
Feb 25 18:30:48 storage kernel: [<ffffffffa0d31d4c>] ? ext4_group_add
+0x1360/0x147c [ext4]
Feb 25 18:30:48 storage kernel: [<ffffffff8103de83>] ?
default_wake_function+0xd/0xf
Feb 25 18:30:48 storage kernel: [<ffffffff81058876>] ?
autoremove_wake_function+0x11/0x38
Feb 25 18:30:48 storage kernel: [<ffffffff8103553e>] ? __wake_up_common
+0x46/0x75
Feb 25 18:30:48 storage kernel: [<ffffffff81349afa>] ? _spin_lock
+0x9/0xc
Feb 25 18:30:48 storage kernel: [<ffffffffa0d27795>] ext4_ioctl
+0x568/0x656 [ext4]
Feb 25 18:30:48 storage kernel: [<ffffffff810d1b88>] vfs_ioctl+0x2a/0x78
Feb 25 18:30:48 storage kernel: [<ffffffff810d1f68>] do_vfs_ioctl
+0x392/0x3c0
Feb 25 18:30:48 storage kernel: [<ffffffff810d1feb>] sys_ioctl+0x55/0x77
Feb 25 18:30:48 storage kernel: [<ffffffff8101104a>]
system_call_fastpath+0x16/0x1b
Feb 25 18:30:48 storage kernel: ---[ end trace e5919bb42fc21cbd ]---
Feb 25 18:30:58 storage kerneloops: Submitted 1 kernel oopses to
www.kerneloops.org


