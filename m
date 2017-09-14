From: ChunYu Wang <chunwang@redhat.com>
Subject: Re: kernel BUG at fs/ext4/fsync.c:LINE!
Date: Thu, 14 Sep 2017 23:04:40 +0800
Message-ID: <CAOm2TWy7OJ0MAAbQ+U4deNuMtL9nwRv5nauEpOj-Ry8=uPVoog@mail.gmail.com>
References: <CACbyUSr1AEJ3E+wB7a1ftuxH4sSK=i5v1Z+KUJ0TMygUrtdPRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller <syzkaller@googlegroups.com>
To: GeneBlue <geneblue.mail@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACbyUSr1AEJ3E+wB7a1ftuxH4sSK=i5v1Z+KUJ0TMygUrtdPRQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi GeneBlue,

Thanks for this reporting, do you have any logs related to the bug and
could find the syscalls enabled for fuzzing during triggering this
bug? I do not think it is not reproducible, but first, it needs some
inspections manually.


- ChunYu

On Thu, Sep 14, 2017 at 7:54 PM, GeneBlue <geneblue.mail@gmail.com> wrote:
> Hi:
>   I've got this crash when fuzzing linux kernel 4.13.0-rc7 on commit
> 42ff72cf27027fa28dd79acabe01d9196f1480a7. Unfortunately this crash is not
> reproducible. And this crash was found by syzkaller.
>
>
> ------------[ cut here ]------------
> kernel BUG at fs/ext4/fsync.c:106!
> invalid opcode: 0000 [#1] SMP KASAN
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in:
> CPU: 0 PID: 25424 Comm: syz-executor5 Not tainted 4.13.0-rc7+ #2
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> rel-1.10.2-0-g5f4c7b1-prebuilt.qemu-project.org 04/01/2014
> task: ffff880038690000 task.stack: ffff880024648000
> RIP: 0010:ext4_sync_file+0x7b6/0xfb0 fs/ext4/fsync.c:106
> RSP: 0018:ffff88003ec07ae0 EFLAGS: 00010206
> RAX: ffff880038690000 RBX: ffff8800239adaa0 RCX: dffffc0000000000
> RDX: 0000000000000100 RSI: 1ffff100070d21ff RDI: ffff880038690ff8
> RBP: ffff88003ec07b30 R08: dffffc0000000000 R09: 1ffff1000cbf5730
> R10: dffffc0000000000 R11: 1ffff1000cbf58f7 R12: ffff880065fab300
> R13: ffff88003dc36a80 R14: ffff880065fac400 R15: ffff880038690000
> FS:  0000000002188940(0000) GS:ffff88003ec00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffd1350fbb0 CR3: 000000002718d000 CR4: 00000000000006f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
> Call Trace:
>  <IRQ>
>  vfs_fsync_range+0x10c/0x250 fs/sync.c:195
>  generic_write_sync include/linux/fs.h:2625 [inline]
>  dio_complete+0x564/0x710 fs/direct-io.c:282
>  dio_bio_end_aio+0x120/0x360 fs/direct-io.c:323
>  bio_endio+0x1df/0x5d0 block/bio.c:1839
>  req_bio_endio block/blk-core.c:204 [inline]
>  blk_update_request+0x210/0xd30 block/blk-core.c:2729
>  scsi_end_request+0xa7/0x5b0 drivers/scsi/scsi_lib.c:634
>  scsi_io_completion+0x73d/0x1430 drivers/scsi/scsi_lib.c:834
>  scsi_finish_command+0x3e9/0x560 drivers/scsi/scsi.c:248
>  scsi_softirq_done+0x2db/0x360 drivers/scsi/scsi_lib.c:1602
>  blk_done_softirq+0x247/0x380 block/blk-softirq.c:36
>  __do_softirq+0x23f/0x924 kernel/softirq.c:284
>  invoke_softirq kernel/softirq.c:364 [inline]
>  irq_exit+0x1a7/0x1e0 kernel/softirq.c:405
>  exiting_irq arch/x86/include/asm/apic.h:638 [inline]
>  do_IRQ+0x81/0x1a0 arch/x86/kernel/irq.c:256
>  common_interrupt+0x93/0x93 arch/x86/entry/entry_64.S:482
> RIP: 0010:__ext4_handle_dirty_metadata+0x5d/0x5c0 fs/ext4/ext4_jbd2.c:275
> RSP: 0018:ffff88002464f9d0 EFLAGS: 00000297 ORIG_RAX: ffffffffffffffc1
> RAX: ffff880038690000 RBX: ffff88003e4199d8 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffff88003e4199d8 RDI: ffff88003869004c
> RBP: ffff88002464fa18 R08: 0000000000000007 R09: dffffc0000000000
> R10: 1ffff100070d211c R11: 0000000000000000 R12: ffff8800381f95c0
> R13: 0000000000000000 R14: 00000000000000a0 R15: 000000000000141f
>  </IRQ>
>  ext4_do_update_inode fs/ext4/inode.c:5151 [inline]
>  ext4_mark_iloc_dirty+0x17e1/0x2980 fs/ext4/inode.c:5673
>  ext4_orphan_del+0x711/0x930 fs/ext4/namei.c:2901
>  ext4_evict_inode+0xe6b/0x1690 fs/ext4/inode.c:308
>  evict+0x248/0x620 fs/inode.c:553
>  iput_final fs/inode.c:1514 [inline]
>  iput+0x538/0x840 fs/inode.c:1541
>  do_unlinkat+0x28b/0x640 fs/namei.c:4049
>  SYSC_unlink fs/namei.c:4090 [inline]
>  SyS_unlink+0x1a/0x20 fs/namei.c:4088
>  entry_SYSCALL_64_fastpath+0x1f/0xbe
> RIP: 0033:0x447077
> RSP: 002b:00007ffd135102e8 EFLAGS: 00000206 ORIG_RAX: 0000000000000057
> RAX: ffffffffffffffda RBX: 0000000000000066 RCX: 0000000000447077
> RDX: 00007ffd13510300 RSI: 00007ffd13510390 RDI: 00007ffd13510390
> RBP: 0000000000000046 R08: 0000000000000000 R09: 000000000218acdb
> R10: 0000000000000005 R11: 0000000000000206 R12: 00000000004a8919
> R13: 00007ffd13510218 R14: 0000000000000001 R15: 00007ffd13510218
> Code: 8b 4d c0 41 f6 01 20 0f 85 1c 03 00 00 e8 f3 ae bb ff 48 8b 7d c0 44
> 89 e6 e8 37 76 13 00 41 89 c4 e9 dc fa ff ff e8 da ae bb ff <0f> 0b e8 d3 ae
> bb ff 8b 4d d4 48 8b 55 b0 4c 89 ef 48 8b 75 b8
> RIP: ext4_sync_file+0x7b6/0xfb0 fs/ext4/fsync.c:106 RSP: ffff88003ec07ae0
> ---[ end trace 3049124842185959 ]---
>
> --
> You received this message because you are subscribed to the Google Groups
> "syzkaller" group.
> To unsubscribe from this group and stop receiving emails from it, send an
> email to syzkaller+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/d/optout.
