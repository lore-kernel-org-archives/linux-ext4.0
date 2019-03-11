Return-Path: <SRS0=9ApQ=RO=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC935C43381
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Mar 2019 18:51:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B284120643
	for <linux-ext4@archiver.kernel.org>; Mon, 11 Mar 2019 18:51:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbfCKSvC convert rfc822-to-8bit (ORCPT
        <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 11 Mar 2019 14:51:02 -0400
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:39658 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726942AbfCKSvC (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 11 Mar 2019 14:51:02 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id B49162928F
        for <linux-ext4@vger.kernel.org>; Mon, 11 Mar 2019 18:51:00 +0000 (UTC)
Received: by mail.wl.linuxfoundation.org (Postfix, from userid 486)
        id A6DC02929A; Mon, 11 Mar 2019 18:51:00 +0000 (UTC)
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-ext4@vger.kernel.org
Subject: [Bug 202877] New: failure at
 fs/jbd2/commit.c:818/jbd2_journal_commit_transaction()!
Date:   Mon, 11 Mar 2019 18:50:59 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: new
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
X-Bugzilla-Changed-Fields: bug_id short_desc product version
 cf_kernel_version rep_platform op_sys cf_tree bug_status bug_severity
 priority component assigned_to reporter cf_regression attachments.created
Message-ID: <bug-202877-13602@https.bugzilla.kernel.org/>
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

https://bugzilla.kernel.org/show_bug.cgi?id=202877

            Bug ID: 202877
           Summary: failure at
                    fs/jbd2/commit.c:818/jbd2_journal_commit_transaction()
                    !
           Product: File System
           Version: 2.5
    Kernel Version: 5.0.0-rc6
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: jungyeon@gatech.edu
        Regression: No

Created attachment 281723
  --> https://bugzilla.kernel.org/attachment.cgi?id=281723&action=edit
The (compressed) crafted image which causes crash

- Overview
After mounting crafted image, I got this kernel panic while running attached
program.
I also tried to reproduce on vm, but it only fails on lkl.

- Produces
./lkl/tools/lkl/ext4-combined -t ext4 -i tmp.img -p min_02.c.raw -v
(min_02.c shows it's internal programs)

- Messages

./lkl/tools/lkl/ext4-combined -t ext4 -i tmp.img -p min_02.c.raw -v
[ 0.000000] Linux version 5.0.0-rc6+ (jungyeon@copper) (gcc version 7.3.0
(Ubuntu 7.3.0-27ubuntu1~18.04)) #1 Fri Mar 8 14:10:53 EST 2019
[ 0.000000] memblock address range: 0x7fba88000000 - 0x7fba8ffff000
[ 0.000000] Built 1 zonelists, mobility grouping on. Total pages: 32319
[ 0.000000] Kernel command line: mem=128M virtio_mmio.device=316@0x1000000:1
[ 0.000000] Dentry cache hash table entries: 16384 (order: 5, 131072 bytes)
[ 0.000000] Inode-cache hash table entries: 8192 (order: 4, 65536 bytes)
[ 0.000000] Memory available: 129044k/131068k RAM
[ 0.000000] SLUB: HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[ 0.000000] NR_IRQS: 4096
[ 0.000000] lkl: irqs initialized
[ 0.000000] clocksource: lkl: mask: 0xffffffffffffffff max_cycles:
0x1cd42e4dffb, max_idle_ns: 881590591483 ns
[ 0.000003] lkl: time and timers initialized (irq2)
[ 0.000009] pid_max: default: 4096 minimum: 301
[ 0.000056] Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
[ 0.000064] Mountpoint-cache hash table entries: 512 (order: 0, 4096 bytes)
[ 0.002528] printk: console [lkl_console0] enabled
[ 0.002556] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff,
max_idle_ns: 19112604462750000 ns
[ 0.003919] clocksource: Switched to clocksource lkl
[ 0.004137] virtio-mmio: Registering device virtio-mmio.0 at
0x1000000-0x100013b, IRQ 1.
[ 0.004390] workingset: timestamp_bits=62 max_order=15 bucket_order=0
[ 0.011219] virtio-mmio virtio-mmio.0: Failed to enable 64-bit or 32-bit DMA.
Trying to continue, but this might not work.
[ 0.011376] virtio_blk virtio0: [vda] 32768 512-byte logical blocks (16.8
MB/16.0 MiB)
[ 0.011809] random: get_random_bytes called from init_oops_id+0x35/0x40 with
crng_init=0
[ 0.011975] Warning: unable to open an initial console.
[ 0.011999] This architecture does not have kernel memory protection.
[ 0.012003] Run /init as init process
[ 0.012966] EXT4-fs (vda): barriers disabled
[ 0.013321] [EXT4 FS bs=1024, gc=2, bpg=8192, ipg=2048, mo=e000c42c, mo2=0002]
[ 0.013338] System zones: 1-2, 66-581, 8193-8194
[ 0.013481] EXT4-fs (vda): mounting with "discard" option, but the device does
not support discard
[ 0.013492] EXT4-fs (vda): mounted filesystem with journalled data mode. Opts:
errors=remount-ro
v13 = syscall(SYS_open, (long)v2, 65536, 0);
syscall(SYS_getdents64, (long)v13, (long)v1, 2344);
syscall(SYS_fsync, (long)v13);
syscall(SYS_fsync, (long)v13);
syscall(SYS_readlink, (long)v10, (long)v1, 8192);
v15 = syscall(SYS_open, (long)v14, 66, 438);
syscall(SYS_write, (long)v15, (long)v1, 2229);
syscall(SYS_write, (long)v15, (long)v1, 3563);
syscall(SYS_ftruncate, (long)v15, 7336);
syscall(SYS_getdents64, (long)v13, (long)v1, 4633);
syscall(SYS_mkdir, (long)v16, 511);
syscall(SYS_fsync, (long)v13);
syscall(SYS_fsync, (long)v15);
syscall(SYS_unlink, (long)v8);
syscall(SYS_write, (long)v15, (long)v1, 7178);
syscall(SYS_readlink, (long)v14, (long)v1, 8192);
syscall(SYS_utimes, (long)v11, (long)v1);
syscall(SYS_ftruncate, (long)v15, 4018);
syscall(SYS_utimes, (long)v10, (long)v1);
syscall(SYS_ftruncate, (long)v15, 6005);
syscall(SYS_fsync, (long)v15);
syscall(SYS_rmdir, (long)v12);
syscall(SYS_pwrite64, (long)v15, (long)v1, 8027, 643);
syscall(SYS_getdents64, (long)v13, (long)v1, 3796);
syscall(SYS_mkdir, (long)v17, 511);
syscall(SYS_removexattr, (long)v3, (long)v18);
syscall(SYS_ftruncate, (long)v15, 53);
syscall(SYS_listxattr, (long)v5, (long)v1, 4138);
syscall(SYS_pwrite64, (long)v15, (long)v1, 7728, 1584);
syscall(SYS_fsync, (long)v15);
syscall(SYS_fsync, (long)v15);
syscall(SYS_write, (long)v15, (long)v1, 5164);
syscall(SYS_unlink, (long)v14);
syscall(SYS_write, (long)v15, (long)v1, 1752);
syscall(SYS_getdents64, (long)v13, (long)v1, 1582);
syscall(SYS_pwrite64, (long)v15, (long)v1, 5142, 5178);
syscall(SYS_removexattr, (long)v16, (long)v19);
v20 = syscall(SYS_open, (long)v3, 65536, 0);
syscall(SYS_fsync, (long)v15);
syscall(SYS_symlink, (long)v5, (long)v21);
syscall(SYS_link, (long)v10, (long)v22);
v23 = syscall(SYS_open, (long)v7, 2, 0);
syscall(SYS_ftruncate, (long)v15, 2545);
syscall(SYS_write, (long)v23, (long)v1, 901);
syscall(SYS_fdatasync, (long)v23);
syscall(SYS_link, (long)v10, (long)v24);
syscall(SYS_symlink, (long)v9, (long)v25);
syscall(SYS_fsync, (long)v15);
syscall(SYS_mkdir, (long)v26, 511);
[ 0.026492] random: fast init done
syscall(SYS_fdatasync, (long)v23);
syscall(SYS_write, (long)v23, (long)v1, 969);
syscall(SYS_readlink, (long)v2, (long)v1, 8192);
syscall(SYS_chmod, (long)v25, 3072);
syscall(SYS_fdatasync, (long)v23);
syscall(SYS_pwrite64, (long)v23, (long)v1, 1520, 1423);
syscall(SYS_fallocate, (long)v15, 65, 5353, 6797);
syscall(SYS_fsync, (long)v23);
syscall(SYS_listxattr, (long)v22, (long)v1, 1808);
syscall(SYS_pwrite64, (long)v23, (long)v1, 4742, 7814);
syscall(SYS_newlstat, (long)v21, (long)v1);
syscall(SYS_fsync, (long)v20);
syscall(SYS_write, (long)v15, (long)v1, 7312);
syscall(SYS_unlink, (long)v21);
syscall(SYS_fallocate, (long)v15, 1, 2243, 3657);
syscall(SYS_pread64, (long)v15, (long)v0, 3050, 4738);
syscall(SYS_fsync, (long)v15);
syscall(SYS_mkdir, (long)v27, 511);
syscall(SYS_fsync, (long)v20);
syscall(SYS_unlink, (long)v10);
syscall(SYS_access, (long)v27, 4);
syscall(SYS_rmdir, (long)v17);
syscall(SYS_pread64, (long)v15, (long)v0, 1206, 6444);
syscall(SYS_fdatasync, (long)v23);
syscall(SYS_rename, (long)v22, (long)v22);
syscall(SYS_fsync, (long)v15);
syscall(SYS_fsync, (long)v20);
syscall(SYS_pwrite64, (long)v15, (long)v1, 1720, 2884);
syscall(SYS_write, (long)v23, (long)v1, 3129);
syscall(SYS_access, (long)v9, 0);
syscall(SYS_write, (long)v15, (long)v1, 6250);
syscall(SYS_readlink, (long)v25, (long)v1, 8192);
[ 0.030600] JBD2: Spotted dirty metadata buffer (dev = vda, blocknr = 8541).
There's a risk of filesystem corruption in case of system crash.
[ 0.030742] BUG: failure at
fs/jbd2/commit.c:818/jbd2_journal_commit_transaction()!
[ 0.030754] Kernel panic - not syncing: BUG!
[ 0.030766] ---[ end Kernel panic - not syncing: BUG! ]---
ext4-combined: lib/posix-host.c:302: panic: Assertion `0' failed.
Aborted (core dumped)

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
