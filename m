From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14911] New: kernel BUG at fs/ext4/inode.c
Date: Mon, 28 Dec 2009 00:56:52 GMT
Message-ID: <bug-14911-13602@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:48620 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbZL1A4w (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 27 Dec 2009 19:56:52 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id nBS0uqRj026910
	for <linux-ext4@vger.kernel.org>; Mon, 28 Dec 2009 00:56:52 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

http://bugzilla.kernel.org/show_bug.cgi?id=14911

           Summary: kernel BUG at fs/ext4/inode.c
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.33-rc2
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: pl4nkton@googlemail.com
        Regression: No


[ 5518.650885] ------------[ cut here ]------------
[ 5518.650893] kernel BUG at fs/ext4/inode.c:1063!
[ 5518.650897] invalid opcode: 0000 [#1] SMP 
[ 5518.650904] last sysfs file:
/sys/devices/pci0000:00/0000:00:0a.0/0000:04:00.0/class
[ 5518.650909] CPU 0 
[ 5518.650915] Pid: 1065, comm: flush-8:0 Tainted: G        W  2.6.33-rc2 #1
M3A78-T/System Product Name
[ 5518.650921] RIP: 0010:[<ffffffffa00a8b46>]  [<ffffffffa00a8b46>]
ext4_get_blocks+0x426/0x430 [ext4]
[ 5518.650939] RSP: 0018:ffff88011998b920  EFLAGS: 00010297
[ 5518.650946] RAX: 00000000000000ca RBX: ffff88011998b9d0 RCX:
0000000000000002
[ 5518.650953] RDX: 0000000000000001 RSI: 00000000000000ca RDI:
0000000000000153
[ 5518.650959] RBP: ffff8800b428c0a0 R08: 0000000000000002 R09:
ffffffff81486450
[ 5518.650966] R10: 0000000000000102 R11: 0000000000000001 R12:
0000000000000201
[ 5518.650973] R13: ffff8800b428c000 R14: ffff8800b428c088 R15:
00000000000109db
[ 5518.650980] FS:  00007f1ed7a016f0(0000) GS:ffff880028200000(0000)
knlGS:0000000000000000
[ 5518.650990] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 5518.650996] CR2: 00007fec025b6230 CR3: 00000000b030f000 CR4:
00000000000006f0
[ 5518.651003] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[ 5518.651010] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[ 5518.651017] Process flush-8:0 (pid: 1065, threadinfo ffff88011998a000, task
ffff88011bbc9470)
[ 5518.651027] Stack:
[ 5518.651031]  ffffea0000506e10 ffffffff810eb4d8 ffff8800b428c0a0
0000000000001000
[ 5518.651042] <0> ffff880100000001 000000000003a346 ffff88011937fc00
000000041998b9c0
[ 5518.651059] <0> 0000000000000000 ffff88011998bc30 000000000003a346
ffff88011998bd90
[ 5518.651080] Call Trace:
[ 5518.651089]  [<ffffffff810eb4d8>] ? __block_write_full_page+0x1f8/0x390
[ 5518.651099]  [<ffffffffa00a9cfb>] ? mpage_da_map_blocks+0xbb/0x450 [ext4]
[ 5518.651107]  [<ffffffff8115f933>] ?
radix_tree_gang_lookup_tag_slot+0x93/0xf0
[ 5518.651117]  [<ffffffff810895b3>] ? find_get_pages_tag+0x33/0x140
[ 5518.651126]  [<ffffffffa00aa6da>] ? __mpage_da_writepage+0x3a/0x190 [ext4]
[ 5518.651134]  [<ffffffff8108f697>] ? write_cache_pages+0x197/0x380
[ 5518.651143]  [<ffffffffa00aa6a0>] ? __mpage_da_writepage+0x0/0x190 [ext4]
[ 5518.651153]  [<ffffffffa00aa351>] ? ext4_da_writepages+0x2c1/0x550 [ext4]
[ 5518.651161]  [<ffffffff81054734>] ? bit_waitqueue+0x14/0xc0
[ 5518.651168]  [<ffffffff810e4171>] ? writeback_single_inode+0xe1/0x3b0
[ 5518.651175]  [<ffffffff810e487d>] ? writeback_inodes_wb+0x32d/0x4d0
[ 5518.651182]  [<ffffffff810e4b2d>] ? wb_writeback+0x10d/0x1d0
[ 5518.651189]  [<ffffffff810e4e61>] ? wb_do_writeback+0x191/0x1a0
[ 5518.651196]  [<ffffffff810492a0>] ? process_timeout+0x0/0x10
[ 5518.651203]  [<ffffffff810e4ed2>] ? bdi_writeback_task+0x62/0xa0
[ 5518.651210]  [<ffffffff8109b3f0>] ? bdi_start_fn+0x0/0xc0
[ 5518.651217]  [<ffffffff8109b453>] ? bdi_start_fn+0x63/0xc0
[ 5518.651223]  [<ffffffff8109b3f0>] ? bdi_start_fn+0x0/0xc0
[ 5518.651230]  [<ffffffff810543be>] ? kthread+0x8e/0xa0
[ 5518.651237]  [<ffffffff81003c24>] ? kernel_thread_helper+0x4/0x10
[ 5518.651244]  [<ffffffff81054330>] ? kthread+0x0/0xa0
[ 5518.651251]  [<ffffffff81003c20>] ? kernel_thread_helper+0x0/0x10
[ 5518.651256] Code: ff ff 0f 1f 00 a8 08 66 0f 1f 44 00 00 0f 84 00 ff ff ff
a8 20 0f 85 f8 fe ff ff 66 90 eb b9 0f 0b 0f 1f 40 00 eb fa 0f 0b eb fe <0f> 0b
eb fe 66 0f 1f 44 00 00 48 83 ec 28 48 89 1c 24 48 89 6c 
[ 5518.651399] RIP  [<ffffffffa00a8b46>] ext4_get_blocks+0x426/0x430 [ext4]
[ 5518.651409]  RSP <ffff88011998b920>
[ 5518.651636] ---[ end trace 0e4167af3a1b2fd2 ]---

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
