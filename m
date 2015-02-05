From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 92781] New: mounting via qemu-nbd and killing the process
 causes kernel BUG at fs/buffer.c:3006
Date: Thu, 05 Feb 2015 11:03:10 +0000
Message-ID: <bug-92781-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:33966 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756648AbbBELDP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 5 Feb 2015 06:03:15 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id DCA5020270
	for <linux-ext4@vger.kernel.org>; Thu,  5 Feb 2015 11:03:12 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id B45D720268
	for <linux-ext4@vger.kernel.org>; Thu,  5 Feb 2015 11:03:11 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=92781

            Bug ID: 92781
           Summary: mounting via qemu-nbd and killing the process causes
                    kernel BUG at fs/buffer.c:3006
           Product: File System
           Version: 2.5
    Kernel Version: 3.19-rc7
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: james410@cowgill.org.uk
        Regression: No

Mounting an ext4 image using qmeu-nbd and then killing the nbd process seems to
cause a kernel bug in the ext4 driver. Also seems to affect the ext2 driver but
not other filesystems. It affects Debian's 3.2.65 kernel as well. I can
reproduce this 100% of the time. The 'sleep 1' seems to be important - if you
remove that line the BUG does not occur (but will if you later run ls /mnt
manually).

root@helena-test:~# cat test-nbd 
#!/bin/sh -ex
cd /root
qemu-img create -f qcow2 image.img 1G
mkfs.ext4 image.img
modprobe nbd || true
qemu-nbd -c /dev/nbd0 image.img
mount /dev/nbd0 /mnt
killall -KILL qemu-nbd
sleep 1
ls /mnt

root@helena-test:~# ./test-nbd 
+ cd /root
+ qemu-img create -f qcow2 image.img 1G
Formatting 'image.img', fmt=qcow2 size=1073741824 encryption=off
cluster_size=65536 lazy_refcounts=off 
+ mkfs.ext4 image.img
mke2fs 1.42.12 (29-Aug-2014)

Filesystem too small for a journal
Discarding device blocks: done                            
Creating filesystem with 192 1k blocks and 24 inodes

Allocating group tables: done                            
Writing inode tables: done                            
Writing superblocks and filesystem accounting information: done

+ modprobe nbd
modprobe: ERROR: ../libkmod/libkmod.c:557 kmod_search_moddep() could not open
moddep file '/lib/modules/3.19.0-rc7/modules.dep.bin'
+ true
+ qemu-nbd -c /dev/nbd0 image.img
+ mount /dev/nbd0 /mnt
[   11.972324] EXT4-fs (nbd0): mounted filesystem without journal. Opts: (null)
+ killall -KILL qemu-nbd
[   11.996675] nbd (pid 1480: qemu-nbd) got signal 9
[   11.997437] block nbd0: shutting down socket
[   11.997987] block nbd0: Receive control failed (result -4)
[   11.999345] block nbd0: queue cleared
+ sleep 1
+ ls /mnt
[   13.030364] block nbd0: Attempted send on closed socket
[   13.034188] blk_update_request: I/O error, dev nbd0, sector 8
[   13.038737] EXT4-fs warning (device nbd0): __ext4_read_dirblock:884: error
-5 reading directory block (ino 2, block 0)
[   13.045232] block nbd0: Attempted send on closed socket
[   13.048804] blk_update_request: I/O error, dev nbd0, sector 72
[   13.053099] block nbd0: Attempted send on closed socket
[   13.055493] blk_update_request: I/O error, dev nbd0, sector 70
[   13.056417] EXT4-fs error (device nbd0): __ext4_get_inode_loc:3769: inode
#2: block 35: comm ls: unable to read itable block
[   13.057817] ------------[ cut here ]------------
[   13.058487] kernel BUG at fs/buffer.c:3006!
[   13.058797] invalid opcode: 0000 [#1] SMP 
[   13.058797] CPU: 0 PID: 1489 Comm: ls Not tainted 3.19.0-rc7 #3
[   13.058797] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.7.5-20140531_083030-gandalf 04/01/2014
[   13.058797] task: ffff88003ce3ac10 ti: ffff88003d5e4000 task.ti:
ffff88003d5e4000
[   13.058797] RIP: 0010:[<ffffffff8118a480>]  [<ffffffff8118a480>]
_submit_bh+0x160/0x180
[   13.058797] RSP: 0000:ffff88003d5e7ba8  EFLAGS: 00010246
[   13.058797] RAX: 0000000000000005 RBX: ffff88003d22ad68 RCX:
0000000000000001
[   13.058797] RDX: 0000000000000000 RSI: ffff88003d22ad68 RDI:
0000000000000411
[   13.058797] RBP: ffff88003d5e7bc8 R08: ffffffff81cc75a0 R09:
00000000000001b7
[   13.058797] R10: 0000000000000000 R11: 00000000000001b7 R12:
0000000000000411
[   13.058797] R13: ffff88003cc43400 R14: 0000000000000002 R15:
ffff88003d691000
[   13.058797] FS:  00007f5b0e2f1800(0000) GS:ffff88003fc00000(0000)
knlGS:0000000000000000
[   13.058797] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   13.058797] CR2: 00007f307f381000 CR3: 000000003ce02000 CR4:
00000000000006f0
[   13.058797] Stack:
[   13.058797]  ffff88003d22ad68 0000000000000411 ffff88003cc43400
0000000000000002
[   13.058797]  ffff88003d5e7be8 ffffffff8118a9a9 ffffffff81cc75a0
ffff88003d22ad68
[   13.058797]  ffff88003d5e7bf8 ffffffff8118aa6e ffff88003d5e7c48
ffffffff811f02c0
[   13.058797] Call Trace:
[   13.058797]  [<ffffffff8118a9a9>] __sync_dirty_buffer+0x59/0x110
[   13.058797]  [<ffffffff8118aa6e>] sync_dirty_buffer+0xe/0x10
[   13.058797]  [<ffffffff811f02c0>] ext4_commit_super+0x1b0/0x240
[   13.058797]  [<ffffffff811f0835>] __ext4_error_inode+0x85/0x150
[   13.058797]  [<ffffffff811d38b9>] __ext4_get_inode_loc+0x209/0x400
[   13.058797]  [<ffffffff811d5458>] ext4_get_inode_loc+0x18/0x20
[   13.058797]  [<ffffffff811d6ebf>] ext4_reserve_inode_write+0x1f/0x90
[   13.058797]  [<ffffffff811da35b>] ? ext4_dirty_inode+0x3b/0x60
[   13.058797]  [<ffffffff811d6f78>] ext4_mark_inode_dirty+0x48/0x1f0
[   13.058797]  [<ffffffff811da35b>] ext4_dirty_inode+0x3b/0x60
[   13.058797]  [<ffffffff81182a86>] __mark_inode_dirty+0x186/0x290
[   13.058797]  [<ffffffff811710a9>] update_time+0x79/0xc0
[   13.058797]  [<ffffffff81172fc6>] touch_atime+0xc6/0x130
[   13.058797]  [<ffffffff8116b100>] iterate_dir+0xe0/0x130
[   13.058797]  [<ffffffff8116b25c>] SyS_getdents+0x7c/0xf0
[   13.058797]  [<ffffffff8116ae10>] ? fillonedir+0xd0/0xd0
[   13.058797]  [<ffffffff81040d6c>] ? do_page_fault+0xc/0x10
[   13.058797]  [<ffffffff81729152>] system_call_fastpath+0x12/0x17
[   13.058797] Code: d8 5b 41 5c 41 5d 41 5e 5d c3 90 40 f6 c7 01 0f 84 0e ff
ff ff 3e 80 63 01 f7 e9 04 ff ff ff 0f 1f 40 00 0f 0b 66 0f 1f 44 00 00 <0f> 0b
66 0f 1f 44 00 00 0f 0b 66 0f 1f 44 00 00 0f 0b 66 0f 1f 
[   13.058797] RIP  [<ffffffff8118a480>] _submit_bh+0x160/0x180
[   13.058797]  RSP <ffff88003d5e7ba8>
[   13.094762] ---[ end trace 781a35c72740e2c9 ]---
Segmentation fault

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
