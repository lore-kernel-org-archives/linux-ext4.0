From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 55081] New: BUG while unlinking inode with an xattr
Date: Mon, 11 Mar 2013 18:47:37 +0000 (UTC)
Message-ID: <bug-55081-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:48062 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686Ab3CKSrm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Mar 2013 14:47:42 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 287C9202E0
	for <linux-ext4@vger.kernel.org>; Mon, 11 Mar 2013 18:47:40 +0000 (UTC)
Received: from bugzilla.kernel.org (bugzilla.kernel.org [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id D558E20195
	for <linux-ext4@vger.kernel.org>; Mon, 11 Mar 2013 18:47:37 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=55081

           Summary: BUG while unlinking inode with an xattr
           Product: File System
           Version: 2.5
    Kernel Version: 3.9-rc2
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext2
        AssignedTo: fs_ext2@kernel-bugs.osdl.org
        ReportedBy: tyhicks@canonical.com
        Regression: Yes


While running the eCryptfs regression test on 3.9-rc2, I hit a new BUG() when
eCryptf was mounted on top of ext2. I then determined that it was an
ext2-specific bug (doesn't happen on ext3, ext4, or other filesystems) and that
it happens without eCryptfs. So, I removed eCryptfs from the picture and
then distilled the test case down into a few commands.

Mount entry in /proc/mounts:

/dev/loop0 /tmp/ext2 ext2 rw,relatime,errors=continue,user_xattr,acl 0 0

Steps to reproduce:

$ cd /tmp/ext2
$ mkdir foo
$ setfacl -dm m:rwx foo
$ rm -rf foo

Note: I've also verified that the BUG is hit with a regular file and a user
xattr:

$ cd /tmp/ext2
$ touch foo
$ setfattr -n user.test -v test foo
$ rm foo

Relevant log entries (for the mkdir -> setfacl -> rm -rf reproducer):

------------[ cut here ]------------
kernel BUG at /var/scm/kernel/linux/fs/inode.c:570!
invalid opcode: 0000 [#1] PREEMPT SMP 
Modules linked in: ext2 fuse dm_crypt psmouse virtio_balloon nfsd nfs_acl
auth_rpcgss nfs fscache lockd sunrpc btrfs raid6_pq lzo_compress xor
zlib_deflate libcrc32c virtio_blk virtio_net virtio_pci virtio_ring virtio
CPU 0 
Pid: 2195, comm: rm Not tainted 3.9.0-rc2 #52 Bochs Bochs
RIP: 0010:[<ffffffff81184260>]  [<ffffffff81184260>] evict+0x190/0x1a0
RSP: 0018:ffff880073a1bdf8  EFLAGS: 00010202
RAX: ffff88007ff8dd38 RBX: ffff88007a237698 RCX: 0000000000000034
RDX: 0000000000000003 RSI: ffff88007a237768 RDI: ffff88007ff8dd00
RBP: ffff880073a1be10 R08: d018000000000000 R09: 007a2377680c0000
R10: ff67dca720d1da03 R11: 0000000000000001 R12: ffff88007a237720
R13: ffffffffa02788c0 R14: ffffffffa02788c0 R15: ffff88007d345d60
FS:  00007f6e29440700(0000) GS:ffff88007fc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000878588 CR3: 00000000341ae000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process rm (pid: 2195, threadinfo ffff880073a1a000, task ffff880079b80000)
Stack:
 ffff88007a237698 ffff88007a237720 ffff8800779537b0 ffff880073a1be40
 ffffffff81184945 ffff88007a7be880 ffff88007a237698 ffff88007a261f80
 ffff88007a7be8e0 ffff880073a1be68 ffffffff811804f8 ffff88007a7be880
Call Trace:
 [<ffffffff81184945>] iput+0x105/0x1a0
 [<ffffffff811804f8>] d_kill+0xd8/0x120
 [<ffffffff81180cc2>] dput+0xe2/0x1d0
 [<ffffffff8116aaa6>] __fput+0x166/0x2f0
 [<ffffffff8116ac3e>] ____fput+0xe/0x10
 [<ffffffff810645e4>] task_work_run+0xb4/0xf0
 [<ffffffff810029d5>] do_notify_resume+0x75/0x80
 [<ffffffff81518c52>] int_signal+0x12/0x17
Code: 70 03 00 00 00 0f 84 4e ff ff ff 48 89 df e8 28 9f fe ff e9 41 ff ff ff
0f 1f 00 48 8d bb e0 01 00 00 31 f6 e8 62 87 f9 ff eb 92 <0f> 0b 0f 0b 0f 0b 66
2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 
RIP  [<ffffffff81184260>] evict+0x190/0x1a0
 RSP <ffff880073a1bdf8>
---[ end trace 2787ce3bd787beee ]---
BUG: sleeping function called from invalid context at
/var/scm/kernel/linux/kernel/rwsem.c:20
in_atomic(): 1, irqs_disabled(): 0, pid: 2195, name: rm
INFO: lockdep is turned off.
Pid: 2195, comm: rm Tainted: G      D      3.9.0-rc2 #52
Call Trace:
 [<ffffffff8107626f>] __might_sleep+0xff/0x130
 [<ffffffff8150de24>] down_read+0x24/0x5c
 [<ffffffff8106ee5b>] ? __validate_process_creds+0x5b/0xf0
 [<ffffffff81058924>] exit_signals+0x24/0x130
 [<ffffffff8104695c>] do_exit+0xbc/0xaa0
 [<ffffffff81044bd1>] ? kmsg_dump+0x101/0x110
 [<ffffffff81044af5>] ? kmsg_dump+0x25/0x110
 [<ffffffff8151201b>] oops_end+0xab/0xf0
 [<ffffffff81005bc8>] die+0x58/0x90
 [<ffffffff8151189b>] do_trap+0x6b/0x170
 [<ffffffff81002f95>] do_invalid_op+0x95/0xb0
 [<ffffffff81184260>] ? evict+0x190/0x1a0
 [<ffffffff812eb17d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff81511164>] ? restore_args+0x30/0x30
 [<ffffffff81519abb>] invalid_op+0x1b/0x20
 [<ffffffff81184260>] ? evict+0x190/0x1a0
 [<ffffffff811841c0>] ? evict+0xf0/0x1a0
 [<ffffffff81184945>] iput+0x105/0x1a0
 [<ffffffff811804f8>] d_kill+0xd8/0x120
 [<ffffffff81180cc2>] dput+0xe2/0x1d0
 [<ffffffff8116aaa6>] __fput+0x166/0x2f0
 [<ffffffff8116ac3e>] ____fput+0xe/0x10
 [<ffffffff810645e4>] task_work_run+0xb4/0xf0
 [<ffffffff810029d5>] do_notify_resume+0x75/0x80
 [<ffffffff81518c52>] int_signal+0x12/0x17
note: rm[2195] exited with preempt_count 1
BUG: scheduling while atomic: rm/2195/0x10000002
INFO: lockdep is turned off.
Modules linked in: ext2 fuse dm_crypt psmouse virtio_balloon nfsd nfs_acl
auth_rpcgss nfs fscache lockd sunrpc btrfs raid6_pq lzo_compress xor
zlib_deflate libcrc32c virtio_blk virtio_net virtio_pci virtio_ring virtio
Pid: 2195, comm: rm Tainted: G      D      3.9.0-rc2 #52
Call Trace:
 [<ffffffff81506890>] __schedule_bug+0x66/0x75
 [<ffffffff8150ed3f>] __schedule+0x89f/0x960
 [<ffffffff812e7592>] ? number.isra.1+0x322/0x360
 [<ffffffff81153188>] ? alloc_pages_current+0xb8/0x180
 [<ffffffff81077e88>] __cond_resched+0x18/0x30
 [<ffffffff8150ee7f>] _cond_resched+0x2f/0x40
 [<ffffffff811361f2>] unmap_single_vma+0x3f2/0x7f0
 [<ffffffff81136d59>] unmap_vmas+0x49/0x60
 [<ffffffff8113f228>] exit_mmap+0x88/0x150
 [<ffffffff8103e3f5>] mmput+0x65/0xe0
 [<ffffffff81046b34>] do_exit+0x294/0xaa0
 [<ffffffff81044bd1>] ? kmsg_dump+0x101/0x110
 [<ffffffff81044af5>] ? kmsg_dump+0x25/0x110
 [<ffffffff8151201b>] oops_end+0xab/0xf0
 [<ffffffff81005bc8>] die+0x58/0x90
 [<ffffffff8151189b>] do_trap+0x6b/0x170
 [<ffffffff81002f95>] do_invalid_op+0x95/0xb0
 [<ffffffff81184260>] ? evict+0x190/0x1a0
 [<ffffffff812eb17d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
 [<ffffffff81511164>] ? restore_args+0x30/0x30
 [<ffffffff81519abb>] invalid_op+0x1b/0x20
 [<ffffffff81184260>] ? evict+0x190/0x1a0
 [<ffffffff811841c0>] ? evict+0xf0/0x1a0
 [<ffffffff81184945>] iput+0x105/0x1a0
 [<ffffffff811804f8>] d_kill+0xd8/0x120
 [<ffffffff81180cc2>] dput+0xe2/0x1d0
 [<ffffffff8116aaa6>] __fput+0x166/0x2f0
 [<ffffffff8116ac3e>] ____fput+0xe/0x10
 [<ffffffff810645e4>] task_work_run+0xb4/0xf0
 [<ffffffff810029d5>] do_notify_resume+0x75/0x80
 [<ffffffff81518c52>] int_signal+0x12/0x17

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
