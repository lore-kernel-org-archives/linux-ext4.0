Return-Path: <SRS0=Xbv+=M6=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-io1-f48.google.com ([209.85.166.48]:45072 "EHLO
        mail-io1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbeJSDqD (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 18 Oct 2018 23:46:03 -0400
Received: by mail-io1-f48.google.com with SMTP id e12-v6so21659443iok.12
        for <linux-ext4@vger.kernel.org>; Thu, 18 Oct 2018 12:43:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAAQ4vX2wrzxzP6=bP9Bbt89Hvs_JRJuZxSQGfPw2vUrtOqh3UA@mail.gmail.com>
 <20180913223252.GD30588@thunk.org> <CAAQ4vX2nujND+s7mK-3EztS+MtLeNsNgmd=kwFQmVSa1ABjrKQ@mail.gmail.com>
In-Reply-To: <CAAQ4vX2nujND+s7mK-3EztS+MtLeNsNgmd=kwFQmVSa1ABjrKQ@mail.gmail.com>
From: Nathan Peterson <nathan@uwgrads.com>
Date: Thu, 18 Oct 2018 12:43:18 -0700
Message-ID: <CAAQ4vX3a5RrD_Dt7tFJ23cof=FAK3fd5jrF+c45YujbjwNcKmw@mail.gmail.com>
Subject: Re: Unable to mount an ext4 RAID6 array
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello All,

Just a follow up, are there any further logs or information you need
from me, or is the data lost forever?

I have since powered the box off.

Regards,
Nathan
On Fri, Sep 14, 2018 at 6:08 AM Nathan Peterson <nathan@uwgrads.com> wrote:
>
> Thank you very much for your quick response.(I did not expect a
> response from the person who created e2fsprogs :))
>
> The correct word I should have used was "freezes".  The system freezes
> permanently and all internet within the house is knocked off line,
> until it system is rebooted or CAT is removed(somebody told me that is
> a possible kernel panic).
>
> Kernel:
> 4.15.0-34-generic
> Distro:
> Ubuntu 18.04 LTS (Bionic Beaver)
> HW:
> 2 LSI Logic SAS 9207-8i Storage Controller LSI00301(Symbios Logic
> SAS2308 PCI-Express Fusion-MPT SAS-2 (rev 05))
> Intel(R) Core(TM) i3-4360 CPU @ 3.70GHz
> SATA controller: Intel Corporation 9 Series Chipset Family SATA
> Controller [AHCI Mode]
>
>
> I upgraded e2fsprogs from 1.44.1 to 1.44.4 yesterday and started the
> check again.  Here is what I have observed so far(check is still
> running)
>
> e2fsck 1.44.4 (18-Aug-2018)
> ext2fs_check_desc: Corrupt group descriptor: bad block for inode table
> e2fsck: Group descriptors look bad... trying backup blocks...
> /dev/mapper/enc6 was not cleanly unmounted, check forced.
> Pass 1: Checking inodes, blocks, and sizes
> Group 15's inode table at 6860 conflicts with some other fs block.
> Relocate? yes
>
> Root inode is not a directory.  Clear? yes
>
> /dev/mapper/enc6: |                                                /  0.2%
> after this is pages and pages of:
> Inode 610452616 block 704643072 conflicts with critical metadata,
> skipping block checks.
> Inode 610452616 block 350749440 conflicts with critical metadata,
> skipping block checks.
> Inode 610452616 block 26 conflicts with critical metadata, skipping
> block checks.
> Inode 610452616 block 361234729 conflicts with critical metadata,
> skipping block checks.
>
>
> Dmesg:
> [ +11.907528] EXT4-fs error (device dm-0): ext4_iget:4748: inode #2:
> comm mount:                                              root inode
> unallocated
> [  +0.193901] EXT4-fs (dm-0): get root inode failed
> [  +0.000003] EXT4-fs (dm-0): mount failed
> [Sep13 01:43] EXT4-fs (dm-1): mounted filesystem with ordered data
> mode. Opts: (                                             null)
> [Sep13 17:01] perf: interrupt took too long (2524 > 2500), lowering
> kernel.perf_
> event_max_sample_rate to 79000
> [Sep13 19:46] ata1: exception Emask 0x50 SAct 0x0 SErr 0x4090800
> action 0xe froz                                             en
> [  +0.000002] ata1: irq_stat 0x00400040, connection status changed
> [  +0.000002] ata1: SError: { HostInt PHYRdyChg 10B8B DevExch }
> [  +0.000003] ata1: hard resetting link
> [  +5.657999] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  +0.001820] ata1.00: configured for UDMA/133
> [  +0.000006] ata1: EH complete
> [  +1.003669] ata1: exception Emask 0x50 SAct 0x0 SErr 0x4090800
> action 0xe froz                                             en
> [  +0.000006] ata1: irq_stat 0x00400040, connection status changed
> [  +0.000004] ata1: SError: { HostInt PHYRdyChg 10B8B DevExch }
> [  +0.000005] ata1: hard resetting link
> [  +5.634542] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  +0.001809] ata1.00: configured for UDMA/133
> [  +0.000003] ata1: EH complete
> [Sep13 19:47] ata1: exception Emask 0x50 SAct 0x0 SErr 0x4090800
> action 0xe froz                                             en
> [  +0.000004] ata1: irq_stat 0x00400040, connection status changed
> [  +0.000003] ata1: SError: { HostInt PHYRdyChg 10B8B DevExch }
> [  +0.000003] ata1: hard resetting link
> [  +5.630704] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  +0.001781] ata1.00: configured for UDMA/133
> [  +0.000002] ata1: EH complete
> [Sep13 20:19] ata1: exception Emask 0x50 SAct 0x0 SErr 0x4090800
> action 0xe frozen
> [  +0.000003] ata1: irq_stat 0x00400040, connection status changed
> [  +0.000003] ata1: SError: { HostInt PHYRdyChg 10B8B DevExch }
> [  +0.000005] ata1: hard resetting link
> [  +5.629992] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  +0.002201] ata1.00: configured for UDMA/133
> [  +0.000007] ata1: EH complete
> [Sep13 20:49] ata1: exception Emask 0x50 SAct 0x0 SErr 0x4090800
> action 0xe frozen
> [  +0.000005] ata1: irq_stat 0x00400040, connection status changed
> [  +0.000004] ata1: SError: { HostInt PHYRdyChg 10B8B DevExch }
> [  +0.000006] ata1: hard resetting link
> [  +5.692823] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  +0.001971] ata1.00: configured for UDMA/133
> [  +0.000004] ata1: EH complete
> [Sep13 21:03] ata7: exception Emask 0x10 SAct 0x0 SErr 0x90002 action 0xe frozen
> [  +0.000004] ata7: irq_stat 0x00400000, PHY RDY changed
> [  +0.000002] ata7: SError: { RecovComm PHYRdyChg 10B8B }
> [  +0.000004] ata7: hard resetting link
> [  +6.483742] ata7: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  +5.216068] ata7.00: qc timeout (cmd 0xec)
> [  +0.000018] ata7.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [  +0.000003] ata7.00: revalidation failed (errno=-5)
> [  +0.000010] ata7: hard resetting link
> [  +0.475940] ata7: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  +0.097915] ata7.00: configured for UDMA/133
> [  +0.000003] ata7: EH complete
> [Sep13 21:49] ata1: exception Emask 0x50 SAct 0x0 SErr 0x4090800
> action 0xe frozen
> [  +0.000003] ata1: irq_stat 0x00400040, connection status changed
> [  +0.000004] ata1: SError: { HostInt PHYRdyChg 10B8B DevExch }
> [  +0.000004] ata1: hard resetting link
> [  +5.692985] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  +0.001830] ata1.00: configured for UDMA/133
> [  +0.000003] ata1: EH complete
> [Sep13 22:19] ata1: exception Emask 0x50 SAct 0x0 SErr 0x4090800
> action 0xe frozen
> [  +0.000003] ata1: irq_stat 0x00400040, connection status changed
> [  +0.000001] ata1: SError: { HostInt PHYRdyChg 10B8B DevExch }
> [  +0.000003] ata1: hard resetting link
> [  +5.689847] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  +0.001789] ata1.00: configured for UDMA/133
> [  +0.000002] ata1: EH complete
> [Sep13 23:49] ata1: exception Emask 0x50 SAct 0x0 SErr 0x4090800
> action 0xe frozen
> [  +0.000003] ata1: irq_stat 0x00400040, connection status changed
> [  +0.000004] ata1: SError: { HostInt PHYRdyChg 10B8B DevExch }
> [  +0.000003] ata1: hard resetting link
> [  +5.689514] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  +0.001774] ata1.00: configured for UDMA/133
> [  +0.000002] ata1: EH complete
> [  +4.713309] ata1: exception Emask 0x50 SAct 0x0 SErr 0x4090800
> action 0xe frozen
> [  +0.000002] ata1: irq_stat 0x00400040, connection status changed
> [  +0.000002] ata1: SError: { HostInt PHYRdyChg 10B8B DevExch }
> [  +0.000002] ata1: hard resetting link
> [  +5.632984] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  +0.001773] ata1.00: configured for UDMA/133
> [  +0.000002] ata1: EH complete
> [Sep14 00:21] INFO: task start-stop-daem:25273 blocked for more than
> 120 seconds.
> [  +0.000003]       Not tainted 4.15.0-34-generic #37-Ubuntu
> [  +0.000000] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  +0.000002] start-stop-daem D    0 25273  25270 0x00000000
> [  +0.000001] Call Trace:
> [  +0.000005]  __schedule+0x291/0x8a0
> [  +0.000003]  ? blk_queue_bio+0x26c/0x450
> [  +0.000001]  ? bit_wait+0x60/0x60
> [  +0.000001]  schedule+0x2c/0x80
> [  +0.000002]  io_schedule+0x16/0x40
> [  +0.000001]  bit_wait_io+0x11/0x60
> [  +0.000001]  __wait_on_bit+0x4c/0x90
> [  +0.000001]  ? submit_bio+0x73/0x140
> [  +0.000001]  out_of_line_wait_on_bit+0x90/0xb0
> [  +0.000003]  ? bit_waitqueue+0x40/0x40
> [  +0.000001]  __wait_on_buffer+0x32/0x40
> [  +0.000003]  __ext4_get_inode_loc+0x1b5/0x410
> [  +0.000001]  ext4_iget+0x8e/0xbd0
> [  +0.000002]  ? legitimize_path.isra.28+0x2e/0x60
> [  +0.000001]  ext4_iget_normal+0x30/0x40
> [  +0.000002]  ext4_lookup+0xf0/0x210
> [  +0.000001]  path_openat+0xd30/0x1770
> [  +0.000003]  ? flush_tlb_func_common.constprop.11+0x149/0x220
> [  +0.000001]  do_filp_open+0x9b/0x110
> [  +0.000003]  ? ___slab_alloc+0xf2/0x4b0
> [  +0.000001]  ? __slab_free+0x14d/0x2c0
> [  +0.000002]  ? tlb_finish_mmu+0x23/0x30
> [  +0.000001]  ? _cond_resched+0x19/0x40
> [  +0.000001]  ? __kmalloc+0x1e7/0x220
> [  +0.000002]  ? security_prepare_creds+0x9c/0xc0
> [  +0.000002]  do_open_execat+0x7e/0x1e0
> [  +0.000002]  ? prepare_creds+0xd5/0x110
> [  +0.000001]  ? do_open_execat+0x7e/0x1e0
> [  +0.000002]  do_execveat_common.isra.34+0x1c7/0x810
> [  +0.000001]  SyS_execve+0x31/0x40
> [  +0.000003]  do_syscall_64+0x73/0x130
> [  +0.000003]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> [  +0.000001] RIP: 0033:0x7f5188395e37
> [  +0.000001] RSP: 002b:00007ffc867c3a68 EFLAGS: 00000246 ORIG_RAX:
> 000000000000003b
> [  +0.000001] RAX: ffffffffffffffda RBX: 00007ffc867c3d38 RCX: 00007f5188395e37
> [  +0.000000] RDX: 00007ffc867c3d50 RSI: 00007ffc867c3d30 RDI: 00007ffc867c4ed1
> [  +0.000001] RBP: 00007ffc867c4ed1 R08: 00007f5187627330 R09: 00007ffc867c3418
> [  +0.000001] R10: 00007f5187627330 R11: 0000000000000246 R12: 0000000000000000
> [  +0.000000] R13: 0000556a94fd22a0 R14: 00000000ffffffff R15: 00007ffc867c4eff
> [Sep14 00:23] INFO: task start-stop-daem:25273 blocked for more than
> 120 seconds.
> [  +0.000003]       Not tainted 4.15.0-34-generic #37-Ubuntu
> [  +0.000000] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  +0.000002] start-stop-daem D    0 25273  25270 0x00000000
> [  +0.000001] Call Trace:
> [  +0.000005]  __schedule+0x291/0x8a0
> [  +0.000003]  ? blk_queue_bio+0x26c/0x450
> [  +0.000001]  ? bit_wait+0x60/0x60
> [  +0.000001]  schedule+0x2c/0x80
> [  +0.000002]  io_schedule+0x16/0x40
> [  +0.000001]  bit_wait_io+0x11/0x60
> [  +0.000001]  __wait_on_bit+0x4c/0x90
> [  +0.000001]  ? submit_bio+0x73/0x140
> [  +0.000001]  out_of_line_wait_on_bit+0x90/0xb0
> [  +0.000002]  ? bit_waitqueue+0x40/0x40
> [  +0.000002]  __wait_on_buffer+0x32/0x40
> [  +0.000002]  __ext4_get_inode_loc+0x1b5/0x410
> [  +0.000002]  ext4_iget+0x8e/0xbd0
> [  +0.000002]  ? legitimize_path.isra.28+0x2e/0x60
> [  +0.000001]  ext4_iget_normal+0x30/0x40
> [  +0.000002]  ext4_lookup+0xf0/0x210
> [  +0.000001]  path_openat+0xd30/0x1770
> [  +0.000002]  ? flush_tlb_func_common.constprop.11+0x149/0x220
> [  +0.000002]  do_filp_open+0x9b/0x110
> [  +0.000002]  ? ___slab_alloc+0xf2/0x4b0
> [  +0.000001]  ? __slab_free+0x14d/0x2c0
> [  +0.000002]  ? tlb_finish_mmu+0x23/0x30
> [  +0.000001]  ? _cond_resched+0x19/0x40
> [  +0.000001]  ? __kmalloc+0x1e7/0x220
> [  +0.000002]  ? security_prepare_creds+0x9c/0xc0
> [  +0.000003]  do_open_execat+0x7e/0x1e0
> [  +0.000001]  ? prepare_creds+0xd5/0x110
> [  +0.000001]  ? do_open_execat+0x7e/0x1e0
> [  +0.000002]  do_execveat_common.isra.34+0x1c7/0x810
> [  +0.000002]  SyS_execve+0x31/0x40
> [  +0.000003]  do_syscall_64+0x73/0x130
> [  +0.000002]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> [  +0.000001] RIP: 0033:0x7f5188395e37
> [  +0.000001] RSP: 002b:00007ffc867c3a68 EFLAGS: 00000246 ORIG_RAX:
> 000000000000003b
> [  +0.000001] RAX: ffffffffffffffda RBX: 00007ffc867c3d38 RCX: 00007f5188395e37
> [  +0.000001] RDX: 00007ffc867c3d50 RSI: 00007ffc867c3d30 RDI: 00007ffc867c4ed1
> [  +0.000000] RBP: 00007ffc867c4ed1 R08: 00007f5187627330 R09: 00007ffc867c3418
> [  +0.000001] R10: 00007f5187627330 R11: 0000000000000246 R12: 0000000000000000
> [  +0.000000] R13: 0000556a94fd22a0 R14: 00000000ffffffff R15: 00007ffc867c4eff
> [Sep14 00:25] INFO: task start-stop-daem:25273 blocked for more than
> 120 seconds.
> [  +0.000003]       Not tainted 4.15.0-34-generic #37-Ubuntu
> [  +0.000001] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  +0.000001] start-stop-daem D    0 25273  25270 0x00000000
> [  +0.000002] Call Trace:
> [  +0.000005]  __schedule+0x291/0x8a0
> [  +0.000002]  ? blk_queue_bio+0x26c/0x450
> [  +0.000001]  ? bit_wait+0x60/0x60
> [  +0.000001]  schedule+0x2c/0x80
> [  +0.000003]  io_schedule+0x16/0x40
> [  +0.000001]  bit_wait_io+0x11/0x60
> [  +0.000001]  __wait_on_bit+0x4c/0x90
> [  +0.000001]  ? submit_bio+0x73/0x140
> [  +0.000001]  out_of_line_wait_on_bit+0x90/0xb0
> [  +0.000002]  ? bit_waitqueue+0x40/0x40
> [  +0.000002]  __wait_on_buffer+0x32/0x40
> [  +0.000002]  __ext4_get_inode_loc+0x1b5/0x410
> [  +0.000001]  ext4_iget+0x8e/0xbd0
> [  +0.000002]  ? legitimize_path.isra.28+0x2e/0x60
> [  +0.000002]  ext4_iget_normal+0x30/0x40
> [  +0.000001]  ext4_lookup+0xf0/0x210
> [  +0.000001]  path_openat+0xd30/0x1770
> [  +0.000003]  ? flush_tlb_func_common.constprop.11+0x149/0x220
> [  +0.000001]  do_filp_open+0x9b/0x110
> [  +0.000003]  ? ___slab_alloc+0xf2/0x4b0
> [  +0.000001]  ? __slab_free+0x14d/0x2c0
> [  +0.000002]  ? tlb_finish_mmu+0x23/0x30
> [  +0.000001]  ? _cond_resched+0x19/0x40
> [  +0.000001]  ? __kmalloc+0x1e7/0x220
> [  +0.000002]  ? security_prepare_creds+0x9c/0xc0
> [  +0.000002]  do_open_execat+0x7e/0x1e0
> [  +0.000002]  ? prepare_creds+0xd5/0x110
> [  +0.000001]  ? do_open_execat+0x7e/0x1e0
> [  +0.000001]  do_execveat_common.isra.34+0x1c7/0x810
> [  +0.000002]  SyS_execve+0x31/0x40
> [  +0.000003]  do_syscall_64+0x73/0x130
> [  +0.000002]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> [  +0.000001] RIP: 0033:0x7f5188395e37
> [  +0.000001] RSP: 002b:00007ffc867c3a68 EFLAGS: 00000246 ORIG_RAX:
> 000000000000003b
> [  +0.000001] RAX: ffffffffffffffda RBX: 00007ffc867c3d38 RCX: 00007f5188395e37
> [  +0.000001] RDX: 00007ffc867c3d50 RSI: 00007ffc867c3d30 RDI: 00007ffc867c4ed1
> [  +0.000000] RBP: 00007ffc867c4ed1 R08: 00007f5187627330 R09: 00007ffc867c3418
> [  +0.000001] R10: 00007f5187627330 R11: 0000000000000246 R12: 0000000000000000
> [  +0.000001] R13: 0000556a94fd22a0 R14: 00000000ffffffff R15: 00007ffc867c4eff
> [Sep14 00:27] INFO: task start-stop-daem:25273 blocked for more than
> 120 seconds.
> [  +0.000002]       Not tainted 4.15.0-34-generic #37-Ubuntu
> [  +0.000001] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  +0.000001] start-stop-daem D    0 25273  25270 0x00000000
> [  +0.000002] Call Trace:
> [  +0.000005]  __schedule+0x291/0x8a0
> [  +0.000002]  ? blk_queue_bio+0x26c/0x450
> [  +0.000002]  ? bit_wait+0x60/0x60
> [  +0.000000]  schedule+0x2c/0x80
> [  +0.000003]  io_schedule+0x16/0x40
> [  +0.000001]  bit_wait_io+0x11/0x60
> [  +0.000001]  __wait_on_bit+0x4c/0x90
> [  +0.000001]  ? submit_bio+0x73/0x140
> [  +0.000001]  out_of_line_wait_on_bit+0x90/0xb0
> [  +0.000002]  ? bit_waitqueue+0x40/0x40
> [  +0.000002]  __wait_on_buffer+0x32/0x40
> [  +0.000002]  __ext4_get_inode_loc+0x1b5/0x410
> [  +0.000001]  ext4_iget+0x8e/0xbd0
> [  +0.000002]  ? legitimize_path.isra.28+0x2e/0x60
> [  +0.000002]  ext4_iget_normal+0x30/0x40
> [  +0.000001]  ext4_lookup+0xf0/0x210
> [  +0.000002]  path_openat+0xd30/0x1770
> [  +0.000002]  ? flush_tlb_func_common.constprop.11+0x149/0x220
> [  +0.000002]  do_filp_open+0x9b/0x110
> [  +0.000002]  ? ___slab_alloc+0xf2/0x4b0
> [  +0.000001]  ? __slab_free+0x14d/0x2c0
> [  +0.000002]  ? tlb_finish_mmu+0x23/0x30
> [  +0.000001]  ? _cond_resched+0x19/0x40
> [  +0.000001]  ? __kmalloc+0x1e7/0x220
> [  +0.000002]  ? security_prepare_creds+0x9c/0xc0
> [  +0.000003]  do_open_execat+0x7e/0x1e0
> [  +0.000001]  ? prepare_creds+0xd5/0x110
> [  +0.000001]  ? do_open_execat+0x7e/0x1e0
> [  +0.000002]  do_execveat_common.isra.34+0x1c7/0x810
> [  +0.000002]  SyS_execve+0x31/0x40
> [  +0.000003]  do_syscall_64+0x73/0x130
> [  +0.000002]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> [  +0.000001] RIP: 0033:0x7f5188395e37
> [  +0.000001] RSP: 002b:00007ffc867c3a68 EFLAGS: 00000246 ORIG_RAX:
> 000000000000003b
> [  +0.000001] RAX: ffffffffffffffda RBX: 00007ffc867c3d38 RCX: 00007f5188395e37
> [  +0.000001] RDX: 00007ffc867c3d50 RSI: 00007ffc867c3d30 RDI: 00007ffc867c4ed1
> [  +0.000000] RBP: 00007ffc867c4ed1 R08: 00007f5187627330 R09: 00007ffc867c3418
> [  +0.000001] R10: 00007f5187627330 R11: 0000000000000246 R12: 0000000000000000
> [  +0.000000] R13: 0000556a94fd22a0 R14: 00000000ffffffff R15: 00007ffc867c4eff
> [Sep14 00:29] INFO: task start-stop-daem:25273 blocked for more than
> 120 seconds.
> [  +0.000003]       Not tainted 4.15.0-34-generic #37-Ubuntu
> [  +0.000001] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  +0.000001] start-stop-daem D    0 25273  25270 0x00000000
> [  +0.000001] Call Trace:
> [  +0.000005]  __schedule+0x291/0x8a0
> [  +0.000003]  ? blk_queue_bio+0x26c/0x450
> [  +0.000001]  ? bit_wait+0x60/0x60
> [  +0.000001]  schedule+0x2c/0x80
> [  +0.000002]  io_schedule+0x16/0x40
> [  +0.000001]  bit_wait_io+0x11/0x60
> [  +0.000001]  __wait_on_bit+0x4c/0x90
> [  +0.000001]  ? submit_bio+0x73/0x140
> [  +0.000001]  out_of_line_wait_on_bit+0x90/0xb0
> [  +0.000003]  ? bit_waitqueue+0x40/0x40
> [  +0.000001]  __wait_on_buffer+0x32/0x40
> [  +0.000003]  __ext4_get_inode_loc+0x1b5/0x410
> [  +0.000001]  ext4_iget+0x8e/0xbd0
> [  +0.000002]  ? legitimize_path.isra.28+0x2e/0x60
> [  +0.000002]  ext4_iget_normal+0x30/0x40
> [  +0.000001]  ext4_lookup+0xf0/0x210
> [  +0.000001]  path_openat+0xd30/0x1770
> [  +0.000003]  ? flush_tlb_func_common.constprop.11+0x149/0x220
> [  +0.000001]  do_filp_open+0x9b/0x110
> [  +0.000003]  ? ___slab_alloc+0xf2/0x4b0
> [  +0.000001]  ? __slab_free+0x14d/0x2c0
> [  +0.000002]  ? tlb_finish_mmu+0x23/0x30
> [  +0.000001]  ? _cond_resched+0x19/0x40
> [  +0.000001]  ? __kmalloc+0x1e7/0x220
> [  +0.000002]  ? security_prepare_creds+0x9c/0xc0
> [  +0.000002]  do_open_execat+0x7e/0x1e0
> [  +0.000002]  ? prepare_creds+0xd5/0x110
> [  +0.000001]  ? do_open_execat+0x7e/0x1e0
> [  +0.000002]  do_execveat_common.isra.34+0x1c7/0x810
> [  +0.000001]  SyS_execve+0x31/0x40
> [  +0.000003]  do_syscall_64+0x73/0x130
> [  +0.000003]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> [  +0.000001] RIP: 0033:0x7f5188395e37
> [  +0.000001] RSP: 002b:00007ffc867c3a68 EFLAGS: 00000246 ORIG_RAX:
> 000000000000003b
> [  +0.000001] RAX: ffffffffffffffda RBX: 00007ffc867c3d38 RCX: 00007f5188395e37
> [  +0.000000] RDX: 00007ffc867c3d50 RSI: 00007ffc867c3d30 RDI: 00007ffc867c4ed1
> [  +0.000001] RBP: 00007ffc867c4ed1 R08: 00007f5187627330 R09: 00007ffc867c3418
> [  +0.000001] R10: 00007f5187627330 R11: 0000000000000246 R12: 0000000000000000
> [  +0.000000] R13: 0000556a94fd22a0 R14: 00000000ffffffff R15: 00007ffc867c4eff
> [Sep14 00:31] INFO: task start-stop-daem:25273 blocked for more than
> 120 seconds.
> [  +0.000002]       Not tainted 4.15.0-34-generic #37-Ubuntu
> [  +0.000001] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  +0.000001] start-stop-daem D    0 25273  25270 0x00000000
> [  +0.000002] Call Trace:
> [  +0.000005]  __schedule+0x291/0x8a0
> [  +0.000002]  ? blk_queue_bio+0x26c/0x450
> [  +0.000002]  ? bit_wait+0x60/0x60
> [  +0.000001]  schedule+0x2c/0x80
> [  +0.000002]  io_schedule+0x16/0x40
> [  +0.000001]  bit_wait_io+0x11/0x60
> [  +0.000001]  __wait_on_bit+0x4c/0x90
> [  +0.000001]  ? submit_bio+0x73/0x140
> [  +0.000001]  out_of_line_wait_on_bit+0x90/0xb0
> [  +0.000002]  ? bit_waitqueue+0x40/0x40
> [  +0.000002]  __wait_on_buffer+0x32/0x40
> [  +0.000002]  __ext4_get_inode_loc+0x1b5/0x410
> [  +0.000001]  ext4_iget+0x8e/0xbd0
> [  +0.000003]  ? legitimize_path.isra.28+0x2e/0x60
> [  +0.000001]  ext4_iget_normal+0x30/0x40
> [  +0.000001]  ext4_lookup+0xf0/0x210
> [  +0.000002]  path_openat+0xd30/0x1770
> [  +0.000002]  ? flush_tlb_func_common.constprop.11+0x149/0x220
> [  +0.000002]  do_filp_open+0x9b/0x110
> [  +0.000002]  ? ___slab_alloc+0xf2/0x4b0
> [  +0.000001]  ? __slab_free+0x14d/0x2c0
> [  +0.000002]  ? tlb_finish_mmu+0x23/0x30
> [  +0.000001]  ? _cond_resched+0x19/0x40
> [  +0.000001]  ? __kmalloc+0x1e7/0x220
> [  +0.000002]  ? security_prepare_creds+0x9c/0xc0
> [  +0.000003]  do_open_execat+0x7e/0x1e0
> [  +0.000001]  ? prepare_creds+0xd5/0x110
> [  +0.000001]  ? do_open_execat+0x7e/0x1e0
> [  +0.000002]  do_execveat_common.isra.34+0x1c7/0x810
> [  +0.000002]  SyS_execve+0x31/0x40
> [  +0.000002]  do_syscall_64+0x73/0x130
> [  +0.000003]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> [  +0.000001] RIP: 0033:0x7f5188395e37
> [  +0.000001] RSP: 002b:00007ffc867c3a68 EFLAGS: 00000246 ORIG_RAX:
> 000000000000003b
> [  +0.000001] RAX: ffffffffffffffda RBX: 00007ffc867c3d38 RCX: 00007f5188395e37
> [  +0.000000] RDX: 00007ffc867c3d50 RSI: 00007ffc867c3d30 RDI: 00007ffc867c4ed1
> [  +0.000001] RBP: 00007ffc867c4ed1 R08: 00007f5187627330 R09: 00007ffc867c3418
> [  +0.000001] R10: 00007f5187627330 R11: 0000000000000246 R12: 0000000000000000
> [  +0.000000] R13: 0000556a94fd22a0 R14: 00000000ffffffff R15: 00007ffc867c4eff
> [Sep14 00:33] INFO: task start-stop-daem:25273 blocked for more than
> 120 seconds.
> [  +0.000003]       Not tainted 4.15.0-34-generic #37-Ubuntu
> [  +0.000001] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  +0.000002] start-stop-daem D    0 25273  25270 0x00000000
> [  +0.000001] Call Trace:
> [  +0.000005]  __schedule+0x291/0x8a0
> [  +0.000002]  ? blk_queue_bio+0x26c/0x450
> [  +0.000002]  ? bit_wait+0x60/0x60
> [  +0.000001]  schedule+0x2c/0x80
> [  +0.000002]  io_schedule+0x16/0x40
> [  +0.000001]  bit_wait_io+0x11/0x60
> [  +0.000001]  __wait_on_bit+0x4c/0x90
> [  +0.000001]  ? submit_bio+0x73/0x140
> [  +0.000001]  out_of_line_wait_on_bit+0x90/0xb0
> [  +0.000003]  ? bit_waitqueue+0x40/0x40
> [  +0.000001]  __wait_on_buffer+0x32/0x40
> [  +0.000002]  __ext4_get_inode_loc+0x1b5/0x410
> [  +0.000002]  ext4_iget+0x8e/0xbd0
> [  +0.000002]  ? legitimize_path.isra.28+0x2e/0x60
> [  +0.000001]  ext4_iget_normal+0x30/0x40
> [  +0.000002]  ext4_lookup+0xf0/0x210
> [  +0.000001]  path_openat+0xd30/0x1770
> [  +0.000003]  ? flush_tlb_func_common.constprop.11+0x149/0x220
> [  +0.000001]  do_filp_open+0x9b/0x110
> [  +0.000003]  ? ___slab_alloc+0xf2/0x4b0
> [  +0.000001]  ? __slab_free+0x14d/0x2c0
> [  +0.000002]  ? tlb_finish_mmu+0x23/0x30
> [  +0.000001]  ? _cond_resched+0x19/0x40
> [  +0.000001]  ? __kmalloc+0x1e7/0x220
> [  +0.000002]  ? security_prepare_creds+0x9c/0xc0
> [  +0.000002]  do_open_execat+0x7e/0x1e0
> [  +0.000001]  ? prepare_creds+0xd5/0x110
> [  +0.000002]  ? do_open_execat+0x7e/0x1e0
> [  +0.000001]  do_execveat_common.isra.34+0x1c7/0x810
> [  +0.000002]  SyS_execve+0x31/0x40
> [  +0.000003]  do_syscall_64+0x73/0x130
> [  +0.000002]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> [  +0.000001] RIP: 0033:0x7f5188395e37
> [  +0.000001] RSP: 002b:00007ffc867c3a68 EFLAGS: 00000246 ORIG_RAX:
> 000000000000003b
> [  +0.000001] RAX: ffffffffffffffda RBX: 00007ffc867c3d38 RCX: 00007f5188395e37
> [  +0.000001] RDX: 00007ffc867c3d50 RSI: 00007ffc867c3d30 RDI: 00007ffc867c4ed1
> [  +0.000000] RBP: 00007ffc867c4ed1 R08: 00007f5187627330 R09: 00007ffc867c3418
> [  +0.000001] R10: 00007f5187627330 R11: 0000000000000246 R12: 0000000000000000
> [  +0.000001] R13: 0000556a94fd22a0 R14: 00000000ffffffff R15: 00007ffc867c4eff
> [Sep14 00:35] INFO: task start-stop-daem:25273 blocked for more than
> 120 seconds.
> [  +0.000002]       Not tainted 4.15.0-34-generic #37-Ubuntu
> [  +0.000001] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  +0.000001] start-stop-daem D    0 25273  25270 0x00000000
> [  +0.000002] Call Trace:
> [  +0.000005]  __schedule+0x291/0x8a0
> [  +0.000002]  ? blk_queue_bio+0x26c/0x450
> [  +0.000002]  ? bit_wait+0x60/0x60
> [  +0.000000]  schedule+0x2c/0x80
> [  +0.000003]  io_schedule+0x16/0x40
> [  +0.000001]  bit_wait_io+0x11/0x60
> [  +0.000001]  __wait_on_bit+0x4c/0x90
> [  +0.000001]  ? submit_bio+0x73/0x140
> [  +0.000001]  out_of_line_wait_on_bit+0x90/0xb0
> [  +0.000002]  ? bit_waitqueue+0x40/0x40
> [  +0.000002]  __wait_on_buffer+0x32/0x40
> [  +0.000002]  __ext4_get_inode_loc+0x1b5/0x410
> [  +0.000001]  ext4_iget+0x8e/0xbd0
> [  +0.000002]  ? legitimize_path.isra.28+0x2e/0x60
> [  +0.000002]  ext4_iget_normal+0x30/0x40
> [  +0.000001]  ext4_lookup+0xf0/0x210
> [  +0.000002]  path_openat+0xd30/0x1770
> [  +0.000002]  ? flush_tlb_func_common.constprop.11+0x149/0x220
> [  +0.000002]  do_filp_open+0x9b/0x110
> [  +0.000002]  ? ___slab_alloc+0xf2/0x4b0
> [  +0.000001]  ? __slab_free+0x14d/0x2c0
> [  +0.000002]  ? tlb_finish_mmu+0x23/0x30
> [  +0.000001]  ? _cond_resched+0x19/0x40
> [  +0.000001]  ? __kmalloc+0x1e7/0x220
> [  +0.000002]  ? security_prepare_creds+0x9c/0xc0
> [  +0.000002]  do_open_execat+0x7e/0x1e0
> [  +0.000002]  ? prepare_creds+0xd5/0x110
> [  +0.000001]  ? do_open_execat+0x7e/0x1e0
> [  +0.000002]  do_execveat_common.isra.34+0x1c7/0x810
> [  +0.000001]  SyS_execve+0x31/0x40
> [  +0.000003]  do_syscall_64+0x73/0x130
> [  +0.000002]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> [  +0.000002] RIP: 0033:0x7f5188395e37
> [  +0.000000] RSP: 002b:00007ffc867c3a68 EFLAGS: 00000246 ORIG_RAX:
> 000000000000003b
> [  +0.000002] RAX: ffffffffffffffda RBX: 00007ffc867c3d38 RCX: 00007f5188395e37
> [  +0.000000] RDX: 00007ffc867c3d50 RSI: 00007ffc867c3d30 RDI: 00007ffc867c4ed1
> [  +0.000001] RBP: 00007ffc867c4ed1 R08: 00007f5187627330 R09: 00007ffc867c3418
> [  +0.000000] R10: 00007f5187627330 R11: 0000000000000246 R12: 0000000000000000
> [  +0.000001] R13: 0000556a94fd22a0 R14: 00000000ffffffff R15: 00007ffc867c4eff
> [Sep14 00:37] INFO: task start-stop-daem:25273 blocked for more than
> 120 seconds.
> [  +0.000003]       Not tainted 4.15.0-34-generic #37-Ubuntu
> [  +0.000001] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  +0.000001] start-stop-daem D    0 25273  25270 0x00000000
> [  +0.000002] Call Trace:
> [  +0.000005]  __schedule+0x291/0x8a0
> [  +0.000002]  ? blk_queue_bio+0x26c/0x450
> [  +0.000002]  ? bit_wait+0x60/0x60
> [  +0.000001]  schedule+0x2c/0x80
> [  +0.000002]  io_schedule+0x16/0x40
> [  +0.000001]  bit_wait_io+0x11/0x60
> [  +0.000001]  __wait_on_bit+0x4c/0x90
> [  +0.000001]  ? submit_bio+0x73/0x140
> [  +0.000001]  out_of_line_wait_on_bit+0x90/0xb0
> [  +0.000002]  ? bit_waitqueue+0x40/0x40
> [  +0.000002]  __wait_on_buffer+0x32/0x40
> [  +0.000002]  __ext4_get_inode_loc+0x1b5/0x410
> [  +0.000001]  ext4_iget+0x8e/0xbd0
> [  +0.000003]  ? legitimize_path.isra.28+0x2e/0x60
> [  +0.000001]  ext4_iget_normal+0x30/0x40
> [  +0.000001]  ext4_lookup+0xf0/0x210
> [  +0.000002]  path_openat+0xd30/0x1770
> [  +0.000002]  ? flush_tlb_func_common.constprop.11+0x149/0x220
> [  +0.000002]  do_filp_open+0x9b/0x110
> [  +0.000002]  ? ___slab_alloc+0xf2/0x4b0
> [  +0.000001]  ? __slab_free+0x14d/0x2c0
> [  +0.000002]  ? tlb_finish_mmu+0x23/0x30
> [  +0.000001]  ? _cond_resched+0x19/0x40
> [  +0.000001]  ? __kmalloc+0x1e7/0x220
> [  +0.000002]  ? security_prepare_creds+0x9c/0xc0
> [  +0.000002]  do_open_execat+0x7e/0x1e0
> [  +0.000002]  ? prepare_creds+0xd5/0x110
> [  +0.000001]  ? do_open_execat+0x7e/0x1e0
> [  +0.000002]  do_execveat_common.isra.34+0x1c7/0x810
> [  +0.000001]  SyS_execve+0x31/0x40
> [  +0.000003]  do_syscall_64+0x73/0x130
> [  +0.000002]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> [  +0.000002] RIP: 0033:0x7f5188395e37
> [  +0.000000] RSP: 002b:00007ffc867c3a68 EFLAGS: 00000246 ORIG_RAX:
> 000000000000003b
> [  +0.000002] RAX: ffffffffffffffda RBX: 00007ffc867c3d38 RCX: 00007f5188395e37
> [  +0.000000] RDX: 00007ffc867c3d50 RSI: 00007ffc867c3d30 RDI: 00007ffc867c4ed1
> [  +0.000001] RBP: 00007ffc867c4ed1 R08: 00007f5187627330 R09: 00007ffc867c3418
> [  +0.000000] R10: 00007f5187627330 R11: 0000000000000246 R12: 0000000000000000
> [  +0.000001] R13: 0000556a94fd22a0 R14: 00000000ffffffff R15: 00007ffc867c4eff
> [Sep14 00:39] INFO: task start-stop-daem:25273 blocked for more than
> 120 seconds.
> [  +0.000003]       Not tainted 4.15.0-34-generic #37-Ubuntu
> [  +0.000001] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [  +0.000001] start-stop-daem D    0 25273  25270 0x00000000
> [  +0.000001] Call Trace:
> [  +0.000005]  __schedule+0x291/0x8a0
> [  +0.000003]  ? blk_queue_bio+0x26c/0x450
> [  +0.000001]  ? bit_wait+0x60/0x60
> [  +0.000001]  schedule+0x2c/0x80
> [  +0.000002]  io_schedule+0x16/0x40
> [  +0.000001]  bit_wait_io+0x11/0x60
> [  +0.000001]  __wait_on_bit+0x4c/0x90
> [  +0.000001]  ? submit_bio+0x73/0x140
> [  +0.000001]  out_of_line_wait_on_bit+0x90/0xb0
> [  +0.000003]  ? bit_waitqueue+0x40/0x40
> [  +0.000002]  __wait_on_buffer+0x32/0x40
> [  +0.000002]  __ext4_get_inode_loc+0x1b5/0x410
> [  +0.000001]  ext4_iget+0x8e/0xbd0
> [  +0.000002]  ? legitimize_path.isra.28+0x2e/0x60
> [  +0.000002]  ext4_iget_normal+0x30/0x40
> [  +0.000001]  ext4_lookup+0xf0/0x210
> [  +0.000001]  path_openat+0xd30/0x1770
> [  +0.000003]  ? flush_tlb_func_common.constprop.11+0x149/0x220
> [  +0.000001]  do_filp_open+0x9b/0x110
> [  +0.000003]  ? ___slab_alloc+0xf2/0x4b0
> [  +0.000001]  ? __slab_free+0x14d/0x2c0
> [  +0.000002]  ? tlb_finish_mmu+0x23/0x30
> [  +0.000001]  ? _cond_resched+0x19/0x40
> [  +0.000001]  ? __kmalloc+0x1e7/0x220
> [  +0.000002]  ? security_prepare_creds+0x9c/0xc0
> [  +0.000002]  do_open_execat+0x7e/0x1e0
> [  +0.000002]  ? prepare_creds+0xd5/0x110
> [  +0.000001]  ? do_open_execat+0x7e/0x1e0
> [  +0.000002]  do_execveat_common.isra.34+0x1c7/0x810
> [  +0.000001]  SyS_execve+0x31/0x40
> [  +0.000003]  do_syscall_64+0x73/0x130
> [  +0.000002]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> [  +0.000002] RIP: 0033:0x7f5188395e37
> [  +0.000000] RSP: 002b:00007ffc867c3a68 EFLAGS: 00000246 ORIG_RAX:
> 000000000000003b
> [  +0.000002] RAX: ffffffffffffffda RBX: 00007ffc867c3d38 RCX: 00007f5188395e37
> [  +0.000000] RDX: 00007ffc867c3d50 RSI: 00007ffc867c3d30 RDI: 00007ffc867c4ed1
> [  +0.000001] RBP: 00007ffc867c4ed1 R08: 00007f5187627330 R09: 00007ffc867c3418
> [  +0.000000] R10: 00007f5187627330 R11: 0000000000000246 R12: 0000000000000000
> [  +0.000001] R13: 0000556a94fd22a0 R14: 00000000ffffffff R15: 00007ffc867c4eff
> [Sep14 01:19] ata1: exception Emask 0x50 SAct 0x0 SErr 0x4090800
> action 0xe frozen
> [  +0.000003] ata1: irq_stat 0x00400040, connection status changed
> [  +0.000002] ata1: SError: { HostInt PHYRdyChg 10B8B DevExch }
> [  +0.000002] ata1: hard resetting link
> [  +5.631459] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  +0.001774] ata1.00: configured for UDMA/133
> [  +0.000003] ata1: EH complete
> [Sep14 03:49] ata1: exception Emask 0x50 SAct 0x0 SErr 0x4090800
> action 0xe frozen
> [  +0.000003] ata1: irq_stat 0x00400040, connection status changed
> [  +0.000002] ata1: SError: { HostInt PHYRdyChg 10B8B DevExch }
> [  +0.000002] ata1: hard resetting link
> [  +0.431291] ata7: exception Emask 0x10 SAct 0x0 SErr 0x90002 action 0xe frozen
> [  +0.000002] ata7: irq_stat 0x00400000, PHY RDY changed
> [  +0.000001] ata7: SError: { RecovComm PHYRdyChg 10B8B }
> [  +0.000002] ata7: hard resetting link
> [  +5.606028] ata1: link is slow to respond, please be patient (ready=0)
> [  +0.480000] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  +0.001779] ata1.00: configured for UDMA/133
> [  +0.000002] ata1: EH complete
> [  +0.282233] ata7: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  +0.444108] ata1: exception Emask 0x50 SAct 0x0 SErr 0x4090800
> action 0xe frozen
> [  +0.000002] ata1: irq_stat 0x00400040, connection status changed
> [  +0.000002] ata1: SError: { HostInt PHYRdyChg 10B8B DevExch }
> [  +0.000002] ata1: hard resetting link
> [  +4.639880] ata7.00: qc timeout (cmd 0xec)
> [  +0.000012] ata7.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [  +0.000001] ata7.00: revalidation failed (errno=-5)
> [  +0.000003] ata7: hard resetting link
> [  +0.476000] ata7: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  +0.097927] ata7.00: configured for UDMA/133
> [  +0.000002] ata7: EH complete
> [  +0.418059] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  +0.001792] ata1.00: configured for UDMA/133
> [  +0.000002] ata1: EH complete
> [Sep14 04:19] ata1: exception Emask 0x50 SAct 0x0 SErr 0x4090800
> action 0xe frozen
> [  +0.000002] ata1: irq_stat 0x00400040, connection status changed
> [  +0.000002] ata1: SError: { HostInt PHYRdyChg 10B8B DevExch }
> [  +0.000003] ata1: hard resetting link
> [  +0.000236] ata7: exception Emask 0x10 SAct 0x0 SErr 0x90002 action 0xe frozen
> [  +0.000002] ata7: irq_stat 0x00400000, PHY RDY changed
> [  +0.000002] ata7: SError: { RecovComm PHYRdyChg 10B8B }
> [  +0.000002] ata7: hard resetting link
> [  +5.691920] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  +0.001783] ata1.00: configured for UDMA/133
> [  +0.000002] ata1: EH complete
> [  +0.658234] ata7: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  +5.096036] ata7.00: qc timeout (cmd 0xec)
> [  +0.000012] ata7.00: failed to IDENTIFY (I/O error, err_mask=0x4)
> [  +0.000001] ata7.00: revalidation failed (errno=-5)
> [  +0.000003] ata7: hard resetting link
> [  +0.476004] ata7: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [  +0.097898] ata7.00: configured for UDMA/133
> [  +0.000002] ata7: EH complete
> [  +4.332656] systemd[1]: systemd-journald.service: Main process
> exited, code=dumped, status=6/AB
> [  +0.000056] systemd[1]: systemd-journald.service: Failed with result
> 'watchdog'.
> [  +0.133014] systemd[1]: systemd-journald.service: Service has no
> hold-off time, scheduling rest
> [  +0.000044] systemd[1]: systemd-journald.service: Scheduled restart
> job, restart counter is at
> [  +0.043206] systemd[1]: Stopped Flush Journal to Persistent Storage.
> [  +0.000018] systemd[1]: Stopping Flush Journal to Persistent Storage...
> [  +0.000005] systemd[1]: Stopped Journal Service.
> [  +0.038398] systemd[1]: Starting Journal Service...
> [  +1.293208] systemd-journald[25839]: File
> /var/log/journal/bf8d6c0b215e483e86b0bb9b4a217fdb/sysleanly shut down,
> renaming and replacing.
> [  +1.234730] systemd[1]: Started Journal Service.
>
> These are just some of the errors that are repeated.
>
> The error with ata7 is strange because I found and removed this drive
> the other day(as well as changed sata cables).  ata1 error is new and
> have never observed this before(this location has also had its sata
> cable swapped).  However, when I looked for the location of these
> drives they are plugged directly into the motherboard.  I assume these
> errors are not a good sign.
>
> Regards,
> Nathan
