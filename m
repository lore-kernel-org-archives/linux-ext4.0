Return-Path: <SRS0=bs/x=OQ=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-wm1-f41.google.com ([209.85.128.41]:51236 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbeLGKic (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 7 Dec 2018 05:38:32 -0500
MIME-Version: 1.0
From: Ming Lei <tom.leiming@gmail.com>
Date: Fri, 7 Dec 2018 18:38:16 +0800
Message-ID: <CACVXFVPmePk83bUaRJSztmj3+f-_Msjt4Ah=mtAe=oPLd5pATg@mail.gmail.com>
Subject: BUG: v4.20-rc5+ warning on two tests(xfstests ext4/034 and generic/406)
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        "open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Just found the following warning is triggered on xfstests/ext4, and
the test kernel is cf76c364a1e1.

[1] warning on ext4/034

[  334.304384] run fstests ext4/034 at 2018-12-06 18:47:33
[  334.681910] EXT4-fs (sda): mounted filesystem with ordered data
mode. Opts: acl,user_xattr
[  335.512621] EXT4-fs (vda): mounted filesystem with ordered data
mode. Opts: acl,user_xattr,dioread_nolock,nodelalloc
[  335.806890] WARNING: CPU: 1 PID: 139 at fs/ext4/ext4_jbd2.c:271
__ext4_handle_dirty_metadata+0x8c/0x197
[  335.808442] Modules linked in: isofs iTCO_wdt iTCO_vendor_support
lpc_ich i2c_i801 i2c_core mfd_core ip_tables sr_mod cdrom sd_mod ahci
libahci virtio_scsi libata crc32c_intel qemu_fw_cfg usb_storage
dm_mirror dm_region_hash dm_log dm_mod
[  335.811319] CPU: 1 PID: 139 Comm: kworker/u8:3 Not tainted
4.20.0-rc5_cf76c364a1e1_master+ #1
[  335.812463] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
BIOS 1.10.2-2.fc27 04/01/2014
[  335.813611] Workqueue: ext4-rsv-conversion ext4_end_io_rsv_work
[  335.814419] RIP: 0010:__ext4_handle_dirty_metadata+0x8c/0x197
[  335.815202] Code: 41 89 c6 0f 85 1e 01 00 00 49 8b 07 48 85 c0 0f
84 12 01 00 00 48 8b 00 f6 00 02 0f 85 06 01 00 00 45 85 f6 0f 84 a9
00 00 00 <0f> 0b 48 c7 c2 e0 1d c4 81 45 89 f0 4c 89 f9 44 89 ee 4c 89
e7 e8
[  335.817696] RSP: 0018:ffffc900017ffbd8 EFLAGS: 00010286
[  335.818407] RAX: ffff888273a22000 RBX: ffff888275b32e38 RCX: 0000000000000000
[  335.819364] RDX: ffff8882683cb060 RSI: ffff888275b32e38 RDI: 00000000ffffffff
[  335.820321] RBP: 0000000000000000 R08: ffff888275b32e38 R09: ffff88827584e800
[  335.821277] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff81c431a0
[  335.822232] R13: 000000000000134a R14: 00000000ffffffe4 R15: ffff8882683cb060
[  335.823185] FS:  0000000000000000(0000) GS:ffff888277a80000(0000)
knlGS:0000000000000000
[  335.824272] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  335.825043] CR2: 00007f7e6003b6c4 CR3: 00000002769f4005 CR4: 0000000000760ee0
[  335.826015] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  335.826977] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  335.827940] PKRU: 55555554
[  335.828343] Call Trace:
[  335.828783]  ext4_free_blocks+0x514/0x99a
[  335.829367]  ? _raw_read_unlock+0x18/0x29
[  335.829911]  ext4_ext_map_blocks+0x57c/0xe2e
[  335.830503]  ? _raw_read_unlock+0x18/0x29
[  335.831053]  ? start_this_handle+0x328/0x36e
[  335.831651]  ? preempt_count_add+0x8a/0x9c
[  335.832211]  ? _raw_read_lock+0x13/0x2e
[  335.832736]  ext4_map_blocks+0x247/0x4d8
[  335.833288]  ext4_convert_unwritten_extents+0xee/0x19b
[  335.833987]  ext4_end_io_rsv_work+0xc8/0x16b
[  335.834579]  process_one_work+0x1da/0x313
[  335.835135]  ? rescuer_thread+0x282/0x282
[  335.835684]  worker_thread+0x1ca/0x295
[  335.836198]  kthread+0x115/0x11d
[  335.836763]  ? kthread_park+0x76/0x76
[  335.837438]  ret_from_fork+0x35/0x40
[  335.838091] ---[ end trace 438789bd10bc57b6 ]---
[  335.838958] EXT4-fs: ext4_free_blocks:4938: aborting transaction:
error 28 in __ext4_handle_dirty_metadata
[  335.840655] EXT4: jbd2_journal_dirty_metadata failed: handle type
11 started at line 4921, credits 4/0, errcode -28
[  335.840658] EXT4-fs error (device vda) in ext4_free_blocks:4950: error 28
[  335.843391] EXT4-fs error (device vda) in
ext4_do_update_inode:5341: Readonly filesystem
[  335.844788] EXT4-fs warning (device vda):
ext4_convert_unwritten_extents:4949: inode #12: block 1: len 1:
ext4_ext_map_blocks returned -30
[  335.846472] EXT4-fs error (device vda) in
ext4_do_update_inode:5341: Readonly filesystem
[  335.847801] EXT4-fs error (device vda) in
ext4_convert_unwritten_extents:4957: error 28
[  335.849085] EXT4-fs (vda): failed to convert unwritten extents to
written extents -- potential data loss!  (inode 12, offset 4096, size
4096, error -30)
[  335.948841] EXT4-fs (vda): warning: mounting fs with errors,
running e2fsck is recommended
[  335.950647] EXT4-fs (vda): mounted filesystem with ordered data
mode. Opts: acl,user_xattr

[2] warning on  generic/406

[ 2025.890352] run fstests generic/406 at 2018-12-06 19:15:45
[ 2026.635261] EXT4-fs (vda): mounted filesystem with ordered data
mode. Opts: acl,user_xattr
[ 2074.010514] watchdog: BUG: soft lockup - CPU#2 stuck for 31s! [crond:785]
[ 2074.011820] Modules linked in: dm_thin_pool dm_persistent_data
dm_bio_prison dm_snapshot dm_bufio xfs libcrc32c dm_flakey isofs
iTCO_wdt iTCO_vendor_support lpc_ich i2c_i801 i2c_core mfd_core
ip_tables sr_mod cdrom sd_mod ahci libahci virtio_scsi libata
crc32c_intel qemu_fw_cfg usb_storage dm_mirror dm_region_hash dm_log
dm_mod [last unloaded: scsi_debug]
[ 2074.016173] CPU: 2 PID: 785 Comm: crond Tainted: G        W
4.20.0-rc5_cf76c364a1e1_master+ #1
[ 2074.017464] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
BIOS 1.10.2-2.fc27 04/01/2014
[ 2074.018708] RIP: 0010:_raw_spin_unlock_irq+0x13/0x2e
[ 2074.019409] Code: 00 e8 1a 8b a2 ff 65 8b 05 45 eb 99 7e 85 c0 75
05 e8 a1 c1 98 ff c3 0f 1f 44 00 00 e8 3d d9 a4 ff 66 90 fb 66 0f 1f
44 00 00 <bf> 01 00 00 00 e8 ec 8a a2 ff 65 8b 05 17 eb 99 7e 85 c0 75
05 e8
[ 2074.022159] RSP: 0018:ffffc9000142fda0 EFLAGS: 00000246 ORIG_RAX:
ffffffffffffff13
[ 2074.023501] RAX: 0000000000000001 RBX: ffff888106e09e40 RCX: 00000000c0000100
[ 2074.024576] RDX: 0000000000000000 RSI: ffffffff81e74515 RDI: ffff888277b22b00
[ 2074.025562] RBP: ffffc9000142fdd8 R08: 00000000000005ca R09: 0000000000000000
[ 2074.026552] R10: 000000000000024d R11: ffffffff815449e5 R12: ffff888277b22b00
[ 2074.027532] R13: ffff888274230000 R14: ffff888275ff3c80 R15: 0000000000000000
[ 2074.028513] FS:  00007f8791f1d840(0000) GS:ffff888277b00000(0000)
knlGS:0000000000000000
[ 2074.029656] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2074.030447] CR2: 00007f3cf5fb8d58 CR3: 0000000276874001 CR4: 0000000000760ee0
[ 2074.031437] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2074.032401] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 2074.033379] PKRU: 55555554
[ 2074.033764] Call Trace:
[ 2074.034188]  finish_task_switch+0x179/0x232
[ 2074.034824]  __schedule+0x724/0x781
[ 2074.035314]  ? _raw_spin_unlock_irqrestore+0x20/0x31
[ 2074.036002]  schedule+0x7e/0x99
[ 2074.036445]  do_nanosleep+0x87/0x160
[ 2074.036951]  hrtimer_nanosleep+0x9e/0xfe
[ 2074.037506]  ? hrtimer_init+0xf3/0xf3
[ 2074.038011]  __se_sys_nanosleep+0x7e/0x99
[ 2074.038575]  do_syscall_64+0x84/0x13f
[ 2074.039087]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 2074.039794] RIP: 0033:0x7f87911af541
[ 2074.040294] Code: 2e 00 f7 d8 64 89 02 b8 ff ff ff ff eb c5 66 2e
0f 1f 84 00 00 00 00 00 90 8b 05 0a 23 2f 00 85 c0 75 16 b8 23 00 00
00 0f 05 <48> 3d 00 f0 ff ff 77 47 f3 c3 0f 1f 44 00 00 55 53 48 89 f5
48 89
[ 2074.042817] RSP: 002b:00007ffe04e8b7b8 EFLAGS: 00000246 ORIG_RAX:
0000000000000023
[ 2074.043843] RAX: ffffffffffffffda RBX: fffffffffffffe98 RCX: 00007f87911af541
[ 2074.044814] RDX: 0000000000000000 RSI: 00007ffe04e8b7c0 RDI: 00007ffe04e8b7c0
[ 2074.045783] RBP: 000000000000000a R08: 00007f8791261aa0 R09: a3d70a3d70a3d70b
[ 2074.046754] R10: 2ce33e6c02ce33e7 R11: 0000000000000246 R12: 000000000188b0e4
[ 2074.047724] R13: 00007ffe04e8b850 R14: 00007ffe04e8b858 R15: 0000000000000005
[ 2074.055280] sd 2:0:0:0: [sdb] tag#28 FAILED Result: hostbyte=DID_OK
driverbyte=DRIVER_TIMEOUT
[ 2074.056320] sd 2:0:0:0: [sdb] tag#28 CDB: Write(10) 2a 00 00 38 4f
28 00 00 a8 00
[ 2074.057295] print_req_error: 71 callbacks suppressed
[ 2074.057297] print_req_error: I/O error, dev sdb, sector 3690280
[ 2074.058728] Aborting journal on device sdb1-8.
[ 2074.058785] EXT4-fs (sdb1): ext4_writepages: jbd2_start: 1023
pages, ino 407194; err -30
[ 2074.059292] EXT4-fs error (device sdb1) in ext4_orphan_add:2822:
Journal has aborted
[ 2074.071133] EXT4-fs error (device sdb1):
ext4_journal_check_start:61: Detected aborted journal
[ 2074.071567] EXT4-fs error (device sdb1) in
ext4_reserve_inode_write:5877: Journal has aborted
[ 2074.072614] EXT4-fs (sdb1): Remounting filesystem read-only
[ 2074.081079] EXT4-fs (sdb1): ext4_writepages: jbd2_start: 1024
pages, ino 407195; err -30



Thanks,
Ming Lei
