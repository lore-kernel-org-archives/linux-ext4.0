Return-Path: <SRS0=Ur5Y=RR=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C06C43381
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Mar 2019 19:28:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A795217F5
	for <linux-ext4@archiver.kernel.org>; Thu, 14 Mar 2019 19:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfCNT2s convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 14 Mar 2019 15:28:48 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:38552 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726848AbfCNT2s (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 14 Mar 2019 15:28:48 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B6CB62A6DC
        for <linux-ext4@vger.kernel.org>; Thu, 14 Mar 2019 19:28:47 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id AB4A42A6DA; Thu, 14 Mar 2019 19:28:47 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 202925] BUG: failure at
 fs/buffer.c:195/__find_get_block_slow()!
Date:   Thu, 14 Mar 2019 19:28:46 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: ext4
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: normal
X-Bugzilla-Who: jungyeon@gatech.edu
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: fs_ext4@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-202925-13602-4pHvF7lShl@https.bugzilla.kernel.org/>
In-Reply-To: <bug-202925-13602@https.bugzilla.kernel.org/>
References: <bug-202925-13602@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=202925

--- Comment #1 from Jungyeon (jungyeon@gatech.edu) ---
I'm attaching original messages without BUG_ON inserted, just in case.

[    0.000000] Linux version 5.0.0+ (jungyeon@copper) (gcc version 7.3.0
(Ubuntu 7.3.0-27ubuntu1~18.04)) #1 Tue Mar 12 20:26:38 EDT 2019
[    0.000000] memblock address range: 0x7fffe4000000 - 0x7fffebfff000
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 32319
[    0.000000] Kernel command line: mem=128M virtio_mmio.device=316@0x1000000:1
[    0.000000] Dentry cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 8192 (order: 4, 65536 bytes)
[    0.000000] Memory available: 129044k/131068k RAM
[    0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] NR_IRQS: 4096
[    0.000000] lkl: irqs initialized
[    0.000000] clocksource: lkl: mask: 0xffffffffffffffff max_cycles:
0x1cd42e4dffb, max_idle_ns: 881590591483 ns
[    0.000001] lkl: time and timers initialized (irq2)
[    0.000008] pid_max: default: 4096 minimum: 301
[    0.000073] Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
[    0.000083] Mountpoint-cache hash table entries: 512 (order: 0, 4096 bytes)
[    0.002211] printk: console [lkl_console0] enabled
[    0.002242] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff,
max_idle_ns: 19112604462750000 ns
[    0.004003] clocksource: Switched to clocksource lkl
[    0.004291] virtio-mmio: Registering device virtio-mmio.0 at
0x1000000-0x100013b, IRQ 1.
[    0.004761] workingset: timestamp_bits=62 max_order=15 bucket_order=0
[    0.015057] virtio-mmio virtio-mmio.0: Failed to enable 64-bit or 32-bit
DMA.  Trying to continue, but this might not work.
[    0.015283] virtio_blk virtio0: [vda] 32768 512-byte logical blocks (16.8
MB/16.0 MiB)
[    0.016182] random: get_random_bytes called from init_oops_id+0x35/0x40 with
crng_init=0
[    0.016509] Warning: unable to open an initial console.
[    0.016545] This architecture does not have kernel memory protection.
[    0.016550] Run /init as init process
[    0.019152] EXT4-fs warning (device vda): ext4_clear_journal_err:4988:
Filesystem error recorded from previous mount: Readonly filesystem
[    0.019166] EXT4-fs warning (device vda): ext4_clear_journal_err:4989:
Marking fs in need of filesystem check.
[    0.019503] EXT4-fs (vda): warning: mounting fs with errors, running e2fsck
is recommended
[    0.019672] EXT4-fs (vda): mounted filesystem with writeback data mode.
Opts: errors=remount-ro
        v13 = syscall(SYS_open, (long)v12, 65536, 0);
        syscall(SYS_getdents64, (long)v13, (long)v1, 1435);
        syscall(SYS_fsync, (long)v13);
        v15 = syscall(SYS_open, (long)v14, 66, 438);
        syscall(SYS_fdatasync, (long)v15);
        syscall(SYS_newlstat, (long)v9, (long)v1);
        syscall(SYS_link, (long)v4, (long)v16);
        syscall(SYS_fsync, (long)v15);
        syscall(SYS_fsync, (long)v15);
        syscall(SYS_ftruncate, (long)v15, 6784);
        syscall(SYS_ftruncate, (long)v15, 4214);
        syscall(SYS_fsync, (long)v15);
        syscall(SYS_ftruncate, (long)v15, 150);
        syscall(SYS_removexattr, (long)v2, (long)v17);
        syscall(SYS_write, (long)v15, (long)v1, 7533);
        syscall(SYS_ftruncate, (long)v15, 7340);
        syscall(SYS_fsync, (long)v13);
        syscall(SYS_listxattr, (long)v12, (long)v1, 2897);
        syscall(SYS_ftruncate, (long)v15, 4203);
        syscall(SYS_write, (long)v15, (long)v1, 7906);
        syscall(SYS_symlink, (long)v5, (long)v18);
        syscall(SYS_write, (long)v15, (long)v1, 3168);
        syscall(SYS_write, (long)v15, (long)v1, 8165);
        syscall(SYS_readlink, (long)v2, (long)v1, 8192);
        syscall(SYS_symlink, (long)v11, (long)v19);
        syscall(SYS_fsync, (long)v13);
        syscall(SYS_pwrite64, (long)v15, (long)v1, 1395, 6228);
        syscall(SYS_lseek, (long)v15, 943, 4);
        syscall(SYS_fsync, (long)v15);
        syscall(SYS_read, (long)v15, (long)v0, 143);
        syscall(SYS_setxattr, (long)v2, (long)v21, (long)v20, 47, 1);
        syscall(SYS_newlstat, (long)v4, (long)v1);
        syscall(SYS_lseek, (long)v15, 6040, 2);
        syscall(SYS_ftruncate, (long)v15, 7971);
        syscall(SYS_write, (long)v15, (long)v1, 6752);
        syscall(SYS_ftruncate, (long)v15, 2719);
        syscall(SYS_truncate, (long)v7, 7015);
        syscall(SYS_fsync, (long)v13);
        syscall(SYS_write, (long)v15, (long)v1, 7688);
        syscall(SYS_rmdir, (long)v4);
        syscall(SYS_ftruncate, (long)v15, 6532);
        syscall(SYS_access, (long)v3, 4);
        syscall(SYS_fsync, (long)v15);
        syscall(SYS_write, (long)v15, (long)v1, 2075);
        syscall(SYS_chmod, (long)v8, 3072);
        syscall(SYS_access, (long)v6, 4);
        syscall(SYS_symlink, (long)v3, (long)v22);
        syscall(SYS_fsync, (long)v13);
        syscall(SYS_write, (long)v15, (long)v1, 2053);
        syscall(SYS_newlstat, (long)v10, (long)v1);
        syscall(SYS_pwrite64, (long)v15, (long)v1, 8187, 6095);
        syscall(SYS_fsync, (long)v15);
        syscall(SYS_rmdir, (long)v12);
        syscall(SYS_unlink, (long)v18);
        syscall(SYS_link, (long)v19, (long)v23);
        syscall(SYS_rmdir, (long)v16);
        syscall(SYS_listxattr, (long)v11, (long)v1, 3204);
        syscall(SYS_truncate, (long)v14, 1234);
        syscall(SYS_unlink, (long)v14);
        syscall(SYS_write, (long)v15, (long)v1, 5057);
        syscall(SYS_fsync, (long)v15);
        syscall(SYS_access, (long)v5, 2);
        syscall(SYS_write, (long)v15, (long)v1, 3487);
        v25 = syscall(SYS_open, (long)v24, 66, 438);
        syscall(SYS_listxattr, (long)v23, (long)v1, 5475);
        syscall(SYS_unlink, (long)v19);
        syscall(SYS_write, (long)v15, (long)v1, 6720);
        syscall(SYS_truncate, (long)v10, 4907);
        syscall(SYS_getdents64, (long)v13, (long)v1, 2280);
        syscall(SYS_fsync, (long)v15);
        syscall(SYS_fdatasync, (long)v25);
        syscall(SYS_pwrite64, (long)v25, (long)v1, 6152, 4834);
        syscall(SYS_removexattr, (long)v23, (long)v26);
        syscall(SYS_lseek, (long)v25, 3817, 2);
        v28 = syscall(SYS_open, (long)v27, 66, 438);
        syscall(SYS_pwrite64, (long)v28, (long)v1, 7246, 2701);
        syscall(SYS_newlstat, (long)v24, (long)v1);
        syscall(SYS_lseek, (long)v28, 2201, 0);
        syscall(SYS_fsync, (long)v28);
        syscall(SYS_lseek, (long)v25, 118, 3);
        syscall(SYS_lseek, (long)v25, 731, 4);
        syscall(SYS_lseek, (long)v25, 3045, 2);
        syscall(SYS_newstat, (long)v5, (long)v1);
        v29 = syscall(SYS_open, (long)v3, 65536, 0);
        syscall(SYS_link, (long)v7, (long)v30);
        syscall(SYS_lseek, (long)v25, 3463, 3);
        syscall(SYS_removexattr, (long)v27, (long)v31);
        syscall(SYS_fsync, (long)v25);
        v33 = syscall(SYS_open, (long)v32, 66, 438);
        syscall(SYS_mkdir, (long)v34, 511);
        syscall(SYS_fdatasync, (long)v33);
        syscall(SYS_write, (long)v33, (long)v1, 1254);
        syscall(SYS_utimes, (long)v24, (long)v1);
        syscall(SYS_chmod, (long)v32, 3072);
        syscall(SYS_truncate, (long)v3, 537);
        syscall(SYS_removexattr, (long)v5, (long)v35);
        syscall(SYS_fsync, (long)v29);
Segmentation fault (core dumped)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
