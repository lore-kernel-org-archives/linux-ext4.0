From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 12429] New: "BUG: spinlock cpu recursion on CPU#0, rm/699" on intentionally corrupted ext4 fs
Date: Sun, 11 Jan 2009 08:02:30 -0800 (PST)
Message-ID: <bug-12429-13602@http.bugzilla.kernel.org/>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40991 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751880AbZAKQDE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 11 Jan 2009 11:03:04 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id n0BG2Uid002999
	for <linux-ext4@vger.kernel.org>; Sun, 11 Jan 2009 08:02:31 -0800
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=12429

           Summary: "BUG: spinlock cpu recursion on CPU#0, rm/699" on
                    intentionally corrupted ext4 fs
           Product: File System
           Version: 2.5
     KernelVersion: 2.6.28
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: sliedes@cc.hut.fi


Latest working kernel version:
Earliest failing kernel version:
Hardware Environment: qemu x86
Software Environment: Minimal Debian sid/unstable
Problem Description:

On accessing the attached intentionally corrupted ext4 filesystem, the kernel
spinlocks recursively and hence locks up.

Steps to reproduce:

1. gunzip the filesystem image
2. mount hdb.20000030 /mnt -t ext4 -o loop,errors=continue
3. cd /mnt
4. rm -rf /mnt/*

Here's the output on dmesg:

------------------------------------------------------------
fstest:~# mount /dev/hdb /mnt -t ext4 -o errors=continue
EXT4-fs: barriers enabled
kjournald2 starting.  Commit interval 5 seconds
EXT4 FS on hdb, internal journal on hdb:8
EXT4-fs: delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
EXT4-fs: mounted filesystem with ordered data mode.
fstest:~# cd /mnt
fstest:/mnt# rm -rf /mnt/*
EXT4-fs error (device hdb): ext4_mb_free_metadata: Double free of blocks 2071
(2059 40)

rm: cannot remove directory `/mnt/dev/.udev/db': Directory not empty
EXT4-fs error (device hdb): mb_free_blocks: double-free of inode 0's block
2073(bit 2072 in group 0)

BUG: spinlock cpu recursion on CPU#0, rm/699
 lock: c7a6b9fc, .magic: dead4ead, .owner: kjournald2/698, .owner_cpu: 0
Pid: 699, comm: rm Not tainted 2.6.28 #1
Call Trace:
 [<c0560abb>] ? printk+0x18/0x1a
 [<c047b6ea>] spin_bug+0x98/0xe0
 [<c047b81b>] _raw_spin_lock+0x76/0x138
 [<c0563581>] _spin_lock+0x3a/0x40
 [<c032ccb5>] ? do_get_write_access+0x3f3/0x4a4
 [<c032ccb5>] do_get_write_access+0x3f3/0x4a4
 [<c0235118>] ? wake_bit_function+0x0/0x47
 [<c032cd81>] jbd2_journal_get_write_access+0x1b/0x2a
 [<c031ac69>] __ext4_journal_get_write_access+0x19/0x3f
 [<c030c679>] ext4_delete_entry+0xa9/0x112
 [<c030f9b7>] ext4_rmdir+0xf5/0x1f0
 [<c027b845>] vfs_rmdir+0x7e/0xb3
 [<c027d1df>] do_rmdir+0xb7/0xc3
 [<c027d21c>] sys_unlinkat+0x31/0x36
 [<c020309e>] syscall_call+0x7/0xb


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
