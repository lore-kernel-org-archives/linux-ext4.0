From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 112161] New: UBSAN: Undefined behaviour in
 fs/ext4/mballoc.c:1274:11
Date: Mon, 08 Feb 2016 15:10:51 +0000
Message-ID: <bug-112161-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:59505 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbcBHPK4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Feb 2016 10:10:56 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 5A2262039E
	for <linux-ext4@vger.kernel.org>; Mon,  8 Feb 2016 15:10:55 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 1D9CC203C3
	for <linux-ext4@vger.kernel.org>; Mon,  8 Feb 2016 15:10:52 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=112161

            Bug ID: 112161
           Summary: UBSAN: Undefined behaviour in
                    fs/ext4/mballoc.c:1274:11
           Product: File System
           Version: 2.5
    Kernel Version: 4.5.0-rc3
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: onorua@gmail.com
        Regression: No

Created attachment 203141
  --> https://bugzilla.kernel.org/attachment.cgi?id=203141&action=edit
journal-b1 output

After the upgrade to new kernel I've got following stack trace:
Feb 08 22:58:57 x kernel:
================================================================================
Feb 08 22:58:57 x kernel: UBSAN: Undefined behaviour in
fs/ext4/mballoc.c:1274:11
Feb 08 22:58:57 x kernel: shift exponent -1 is negative
Feb 08 22:58:57 x kernel: CPU: 2 PID: 1550 Comm: alsactl Tainted: G           O
   4.5.0-rc3 #98
Feb 08 22:58:57 x kernel: Hardware name: LENOVO 20BSCTO1WW/20BSCTO1WW, BIOS
N14ET32W (1.10 ) 08/13/2015
Feb 08 22:58:57 x kernel:  0000000000000000 000000004a465bb8 ffff8802211a7908
ffffffff81832ca4
Feb 08 22:58:57 x kernel:  ffffffffffffffff 000000004a465bb8 ffff8802211a7930
0000000000000001
Feb 08 22:58:57 x kernel:  ffff8802211a7920 ffffffff818a6360 ffffffff82dbd13e
ffff8802211a79c0
Feb 08 22:58:57 x kernel: Call Trace:
Feb 08 22:58:57 x kernel:  [<ffffffff81832ca4>] dump_stack+0xaf/0x10c
Feb 08 22:58:57 x kernel:  [<ffffffff818a6360>] ubsan_epilogue+0x14/0x56
Feb 08 22:58:57 x kernel:  [<ffffffff818a6e04>]
__ubsan_handle_shift_out_of_bounds+0x190/0x1c9
Feb 08 22:58:57 x kernel:  [<ffffffff8234999a>] ? _raw_spin_unlock+0x6e/0xac
Feb 08 22:58:57 x kernel:  [<ffffffff815ccb4e>] ?
ext4_mb_init_cache+0x12fd/0x1355
Feb 08 22:58:57 x kernel:  [<ffffffff815c85ea>]
mb_find_order_for_block+0x1a6/0x1ed
Feb 08 22:58:57 x kernel:  [<ffffffff815c85ea>] ?
mb_find_order_for_block+0x1a6/0x1ed
Feb 08 22:58:57 x kernel:  [<ffffffff815c9702>] mb_find_extent+0x213/0x63f
Feb 08 22:58:57 x kernel:  [<ffffffff815d1f17>]
ext4_mb_complex_scan_group+0x148/0x7f2
Feb 08 22:58:57 x kernel:  [<ffffffff81129fbb>] ? get_parent_ip+0x14/0x6d
Feb 08 22:58:57 x kernel:  [<ffffffff815d2d8c>]
ext4_mb_regular_allocator+0x7cb/0x9d2
Feb 08 22:58:57 x kernel:  [<ffffffff815dcd55>] ext4_mb_new_blocks+0x750/0x104e
Feb 08 22:58:57 x kernel:  [<ffffffff815b1778>] ? ext4_find_extent+0x6b6/0x6e6
Feb 08 22:58:57 x kernel:  [<ffffffff815bb9d4>]
ext4_ext_map_blocks+0x17a2/0x217c
Feb 08 22:58:57 x kernel:  [<ffffffff815419ba>] ext4_map_blocks+0x5c1/0x95b
Feb 08 22:58:57 x kernel:  [<ffffffff81541dcc>] ext4_getblk+0x78/0x32a
Feb 08 22:58:57 x kernel:  [<ffffffff815420a7>] ext4_bread+0x29/0x144
Feb 08 22:58:57 x kernel:  [<ffffffff81559dc2>] ext4_append+0x196/0x2d7
Feb 08 22:58:57 x kernel:  [<ffffffff815656ca>] ext4_mkdir+0x56d/0x998
Feb 08 22:58:57 x kernel:  [<ffffffff813fe640>] vfs_mkdir+0x23b/0x355
Feb 08 22:58:57 x kernel:  [<ffffffff814094ea>] SyS_mkdirat+0x163/0x1d9
Feb 08 22:58:57 x kernel:  [<ffffffff81409580>] SyS_mkdir+0x20/0x29
Feb 08 22:58:57 x kernel:  [<ffffffff82349e57>]
entry_SYSCALL_64_fastpath+0x12/0x66
Feb 08 22:58:57 x kernel:
================================================================================

Please let me know if you need any further information

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
