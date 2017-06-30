From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 196223] jdb2 journal - hung after suspend-resume test
Date: Fri, 30 Jun 2017 07:41:27 +0000
Message-ID: <bug-196223-13602-azSAL8DVP6@https.bugzilla.kernel.org/>
References: <bug-196223-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-ext4@kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.wl.linuxfoundation.org ([198.145.29.98]:54364 "EHLO
        mail.wl.linuxfoundation.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751810AbdF3Hl3 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 30 Jun 2017 03:41:29 -0400
Received: from mail.wl.linuxfoundation.org (localhost [127.0.0.1])
        by mail.wl.linuxfoundation.org (Postfix) with ESMTP id 829922847C
        for <linux-ext4@vger.kernel.org>; Fri, 30 Jun 2017 07:41:28 +0000 (UTC)
In-Reply-To: <bug-196223-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=196223

--- Comment #1 from Marta Löfstedt (marta.lofstedt@intel.com) ---
reproduced with 4.12.0-rc7-next-20170630

[ 1209.338769] INFO: task systemd:1 blocked for more than 120 seconds.
[ 1209.338848]       Tainted: G     U  W       4.12.0-rc7-next-20170630 #2
[ 1209.338916] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 1209.338996] systemd         D    0     1      0 0x00000000
[ 1209.339002] Call Trace:
[ 1209.339015]  __schedule+0x3c7/0x830
[ 1209.339022]  ? bit_wait+0x60/0x60
[ 1209.339026]  schedule+0x36/0x80
[ 1209.339031]  io_schedule+0x16/0x40
[ 1209.339036]  bit_wait_io+0x11/0x60
[ 1209.339041]  __wait_on_bit+0x58/0x90
[ 1209.339047]  ? submit_bio+0x73/0x150
[ 1209.339052]  out_of_line_wait_on_bit+0x8e/0xb0
[ 1209.339058]  ? bit_waitqueue+0x40/0x40
[ 1209.339064]  __wait_on_buffer+0x32/0x40
[ 1209.339070]  __ext4_get_inode_loc+0x1b3/0x400
[ 1209.339076]  ext4_iget+0x92/0xbc0
[ 1209.339082]  ext4_iget_normal+0x2f/0x40
[ 1209.339087]  ext4_lookup+0xea/0x270
[ 1209.339091]  lookup_slow+0xa5/0x160
[ 1209.339096]  walk_component+0x1bf/0x370
[ 1209.339099]  ? path_init+0x1e4/0x3a0
[ 1209.339103]  path_lookupat+0x73/0x220
[ 1209.339107]  filename_lookup+0xb8/0x1a0
[ 1209.339113]  ? __check_object_size+0xb3/0x190
[ 1209.339119]  ? strncpy_from_user+0x4d/0x170
[ 1209.339124]  user_path_at_empty+0x36/0x40
[ 1209.339127]  ? user_path_at_empty+0x36/0x40
[ 1209.339132]  vfs_statx+0x83/0xf0
[ 1209.339137]  SYSC_newstat+0x3d/0x70
[ 1209.339144]  ? __do_page_fault+0x266/0x4e0
[ 1209.339149]  SyS_newstat+0xe/0x10
[ 1209.339153]  entry_SYSCALL_64_fastpath+0x1e/0xa9
[ 1209.339157] RIP: 0033:0x7f3dc48a4215
[ 1209.339160] RSP: 002b:00007ffe95210158 EFLAGS: 00000246 ORIG_RAX:
0000000000000004
[ 1209.339164] RAX: ffffffffffffffda RBX: 00007ffe95210360 RCX:
00007f3dc48a4215
[ 1209.339166] RDX: 00007ffe952101f0 RSI: 00007ffe952101f0 RDI:
00007f3dc4938038
[ 1209.339168] RBP: 0000000000000001 R08: 000000512bfda2a0 R09:
0000000000000020
[ 1209.339170] R10: 2ce33e6c02ce33e7 R11: 0000000000000246 R12:
0000000000000000
[ 1209.339172] R13: 0000000000000000 R14: 00007ffe95210370 R15:
000000512bfb9c88

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
