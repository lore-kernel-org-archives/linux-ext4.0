From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [ext4 BUG?] task pdflush:3880 blocked for more than 120 seconds
Date: Mon, 06 Oct 2008 11:00:59 +0800
Message-ID: <48E97F6B.9060409@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:56010 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbYJFDBZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Oct 2008 23:01:25 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This bug exists both in mainline and ext4-patch-queue.

Procedures to reproduce it:
1. mkfs.ext4dev -I 256 -b 4096 -O extents /dev/sdb1
2. mount -t ext4dev -o delalloc /dev/sdb1 mnt_point/
3. run ffsb until filesystem is full and ffsb exits with failure
4. umount mnt_point

And then umount stuck at D state.

The output of ps:
 3873 ?        D<     0:07 [kjournald2]
 3880 ?        D      0:00 [pdflush]
 3885 ?        S      0:00 [pdflush]
 3944 ?        S      0:00 [pdflush]
 3957 ?        S      0:00 [pdflush]
 3962 ?        S      0:00 [pdflush]
 3974 ?        S      0:00 [pdflush]
 3975 ?        S      0:00 [pdflush]
 3979 pts/1    D+     0:01 umount mnt_point

dmesg:

EXT4-fs: barriers enabled
kjournald2 starting.  Commit interval 5 seconds
EXT4 FS on sdb1, internal journal on sdb1:8
EXT4-fs: mounted filesystem with ordered data mode.
EXT4-fs: delayed allocation enabled
EXT4-fs: file extents enabled
EXT4-fs: mballoc enabled
ffsb[3888]: segfault at 8 ip 0000003878832dc7 sp 00000000425f5fa0 error 4 in libc-2.5.so[3878800000+146000]
INFO: task pdflush:3880 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
pdflush       D ffff88013c6eb700     0  3880      2
 ffff88009a623df0 0000000000000046 0000000000000000 ffffffff80254c20
 ffff8800bfa63040 ffff8800bfa63040 ffff88013faf3040 ffff8800bfa63398
 00000002bfa63040 000000010009baab ffffffffffffffff ffffffffffffffff
Call Trace:
 [<ffffffff80254c20>] __lock_acquire+0x6ad/0x716
 [<ffffffff8049e9de>] __down_read+0x7e/0x96
 [<ffffffff802a32a6>] sync_supers+0x3f/0xb3
 [<ffffffff802a32a6>] sync_supers+0x3f/0xb3
 [<ffffffff8027d50e>] pdflush+0x0/0x207
 [<ffffffff8027d0bf>] wb_kupdate+0x2d/0x10d
 [<ffffffff8027d50e>] pdflush+0x0/0x207
 [<ffffffff8027d50e>] pdflush+0x0/0x207
 [<ffffffff8027d664>] pdflush+0x156/0x207
 [<ffffffff8027d092>] wb_kupdate+0x0/0x10d
 [<ffffffff8024961b>] kthread+0x47/0x74
 [<ffffffff8049ea30>] trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8020cea9>] child_rip+0xa/0x11
 [<ffffffff8020c4df>] restore_args+0x0/0x30
 [<ffffffff802495d4>] kthread+0x0/0x74
 [<ffffffff8020ce9f>] child_rip+0x0/0x11

1 lock held by pdflush/3880:
 #0:  (&type->s_umount_key#21){----}, at: [<ffffffff802a32a6>] sync_supers+0x3f/0xb3
INFO: task pdflush:3880 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
pdflush       D ffff88013c6eb700     0  3880      2
 ffff88009a623df0 0000000000000046 0000000000000000 ffffffff80254c20
 ffff8800bfa63040 ffff8800bfa63040 ffff88013faf3040 ffff8800bfa63398
 00000002bfa63040 000000010009baab ffffffffffffffff ffffffffffffffff
Call Trace:
 [<ffffffff80254c20>] __lock_acquire+0x6ad/0x716
 [<ffffffff8049e9de>] __down_read+0x7e/0x96
 [<ffffffff802a32a6>] sync_supers+0x3f/0xb3
 [<ffffffff802a32a6>] sync_supers+0x3f/0xb3
 [<ffffffff8027d50e>] pdflush+0x0/0x207
 [<ffffffff8027d0bf>] wb_kupdate+0x2d/0x10d
 [<ffffffff8027d50e>] pdflush+0x0/0x207
 [<ffffffff8027d50e>] pdflush+0x0/0x207
 [<ffffffff8027d664>] pdflush+0x156/0x207
 [<ffffffff8027d092>] wb_kupdate+0x0/0x10d
 [<ffffffff8024961b>] kthread+0x47/0x74
 [<ffffffff8049ea30>] trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8020cea9>] child_rip+0xa/0x11
 [<ffffffff8020c4df>] restore_args+0x0/0x30
 [<ffffffff802495d4>] kthread+0x0/0x74
 [<ffffffff8020ce9f>] child_rip+0x0/0x11

1 lock held by pdflush/3880:
 #0:  (&type->s_umount_key#21){----}, at: [<ffffffff802a32a6>] sync_supers+0x3f/0xb3
