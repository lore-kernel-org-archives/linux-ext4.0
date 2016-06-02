From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 119491] New: UBSAN: Undefined behaviour in
 /home/vitti/1tb/vitti/rpmbuild/SOURCES/linux-4.5/fs/ext4/mballoc.c:1274
Date: Thu, 02 Jun 2016 04:43:38 +0000
Message-ID: <bug-119491-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41226 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbcFBEnm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 2 Jun 2016 00:43:42 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 099822010B
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jun 2016 04:43:41 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 3064220114
	for <linux-ext4@vger.kernel.org>; Thu,  2 Jun 2016 04:43:39 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=119491

            Bug ID: 119491
           Summary: UBSAN: Undefined behaviour in
                    /home/vitti/1tb/vitti/rpmbuild/SOURCES/linux-4.5/fs/ex
                    t4/mballoc.c:1274
           Product: File System
           Version: 2.5
    Kernel Version: 4.5.5
          Hardware: x86-64
                OS: Linux
              Tree: Fedora
            Status: NEW
          Severity: low
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: zeccav@gmail.com
        Regression: No

At boot time I get the following:

Jun 02 04:01:53 nero21 kernel:
================================================================================
Jun 02 04:01:53 nero21 kernel: UBSAN: Undefined behaviour in
/home/vitti/1tb/vitti/rpmbuild/SOURCES/linux-4.5/fs/ext4/mballoc.c:1274:11
Jun 02 04:01:53 nero21 kernel: shift exponent -1 is negative
Jun 02 04:01:53 nero21 kernel: CPU: 1 PID: 1 Comm: systemd Not tainted 4.5.5 #1
Jun 02 04:01:53 nero21 kernel: Hardware name: To Be Filled By O.E.M. To Be
Filled By O.E.M./H81M-DGS R2.0, BIOS P1.30 07/02/2014
Jun 02 04:01:53 nero21 kernel:  0000000000000000 0000000006c36e94
ffff88040cf5b868 ffffffff820d38ba
Jun 02 04:01:53 nero21 kernel:  ffffffff87f8c73e 0000000006c36e94
ffff88040cf5b890 ffffffff87f8c73e
Jun 02 04:01:53 nero21 kernel:  ffff88040cf5b880 ffffffff8215e6a4
ffffffffffffffff ffff88040cf5b918
Jun 02 04:01:53 nero21 kernel: Call Trace:
Jun 02 04:01:53 nero21 kernel:  [<ffffffff820d38ba>] dump_stack+0x74/0xaf
Jun 02 04:01:53 nero21 kernel:  [<ffffffff8215e6a4>] ubsan_epilogue+0xd/0x3b
Jun 02 04:01:53 nero21 kernel:  [<ffffffff8215eff5>]
__ubsan_handle_shift_out_of_bounds+0xf9/0x14b
Jun 02 04:01:53 nero21 kernel:  [<ffffffff816c84bc>] ?
ext4_mb_init_cache+0x3ed/0x129a
Jun 02 04:01:53 nero21 kernel:  [<ffffffff816c1037>]
mb_find_order_for_block+0xff/0x143
Jun 02 04:01:53 nero21 kernel:  [<ffffffff816c1968>] mb_find_extent+0xd7/0x4dd
Jun 02 04:01:53 nero21 kernel:  [<ffffffff820dcda2>] ?
radix_tree_lookup_slot+0x22/0x47
Jun 02 04:01:53 nero21 kernel:  [<ffffffff816c5f38>]
ext4_mb_complex_scan_group+0x12b/0x577
Jun 02 04:01:53 nero21 kernel:  [<ffffffff813d35ad>] ?
pagecache_get_page+0x1da/0x516
Jun 02 04:01:53 nero21 kernel:  [<ffffffff8148ac9f>] ?
___slab_alloc+0x3fe/0xa5c
Jun 02 04:01:53 nero21 kernel:  [<ffffffff816cf0b3>]
ext4_mb_regular_allocator+0x2e4/0x78d
Jun 02 04:01:53 nero21 kernel:  [<ffffffff816d2b60>]
ext4_mb_new_blocks+0x3cd/0xaa3
Jun 02 04:01:53 nero21 kernel:  [<ffffffff816b0660>] ?
ext4_ext_put_gap_in_cache+0xe7/0x181
Jun 02 04:01:53 nero21 kernel:  [<ffffffff816b8570>]
ext4_ext_map_blocks+0xa6c/0x16bf
Jun 02 04:01:53 nero21 kernel:  [<ffffffff816bdd01>] ?
__ext4_handle_dirty_metadata+0x48/0x374
Jun 02 04:01:53 nero21 kernel:  [<ffffffff816e19b9>] ?
ext4_es_lookup_extent+0x37/0x3d8
Jun 02 04:01:53 nero21 kernel:  [<ffffffff8165eeb4>]
ext4_map_blocks+0x1c5/0x639
Jun 02 04:01:53 nero21 kernel:  [<ffffffff8166504b>] ?
ext4_mark_inode_dirty+0x86/0x415
Jun 02 04:01:53 nero21 kernel:  [<ffffffff816600cf>] ext4_getblk+0x4e/0x285
Jun 02 04:01:53 nero21 kernel:  [<ffffffff81660328>] ext4_bread+0x22/0xce
Jun 02 04:01:53 nero21 kernel:  [<ffffffff816708c9>] ext4_append+0x89/0x1bf
Jun 02 04:01:53 nero21 kernel:  [<ffffffff8167a7ed>] ext4_mkdir+0x2e9/0x6ff
Jun 02 04:01:53 nero21 kernel:  [<ffffffff814eb1a2>] vfs_mkdir+0xe7/0x246
Jun 02 04:01:53 nero21 kernel:  [<ffffffff814eb51b>] SyS_mkdir+0x9e/0x17d
Jun 02 04:01:53 nero21 kernel:  [<ffffffff85c8ec67>] ?
SyS_socketpair+0x1cb/0x326
Jun 02 04:01:53 nero21 kernel:  [<ffffffff865aa3ee>]
entry_SYSCALL_64_fastpath+0x12/0x71
Jun 02 04:01:53 nero21 kernel:
================================================================================

mballoc.c:1274 is "bb += 1 << (e4b->bd_blkbits - order);"

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
