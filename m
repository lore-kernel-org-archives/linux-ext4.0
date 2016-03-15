From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 114701] New: ubsan: "shift exponent -1 is negative" in
 fs/ext4/mballoc.c:2612:15
Date: Tue, 15 Mar 2016 19:53:38 +0000
Message-ID: <bug-114701-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:52689 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934911AbcCOTxm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 15 Mar 2016 15:53:42 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 91B73203E6
	for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2016 19:53:40 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id DE7A82037C
	for <linux-ext4@vger.kernel.org>; Tue, 15 Mar 2016 19:53:38 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=114701

            Bug ID: 114701
           Summary: ubsan: "shift exponent -1 is negative" in
                    fs/ext4/mballoc.c:2612:15
           Product: File System
           Version: 2.5
    Kernel Version: 4.5.0
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
          Assignee: fs_ext4@kernel-bugs.osdl.org
          Reporter: peter@arbitrary.ch
        Regression: No

The following message appeared during boot:

Mar 15 12:09:22 ivy kernel:
================================================================================
Mar 15 12:09:22 ivy kernel: UBSAN: Undefined behaviour in
fs/ext4/mballoc.c:2612:15
Mar 15 12:09:22 ivy kernel: shift exponent -1 is negative
Mar 15 12:09:22 ivy kernel: CPU: 1 PID: 657 Comm: mount Not tainted 4.5.0-pege1
#1
Mar 15 12:09:22 ivy kernel: Hardware name: Hewlett-Packard HP ENVY dv6 Notebook
PC/181B, BIOS F.29 10/03/2013
Mar 15 12:09:22 ivy kernel:  0000000000000000 00000000450d838f ffffffff816fcef7
0000000000000001
Mar 15 12:09:22 ivy kernel:  00000000450d838f ffff880449cfbb90 ffff880449cfbc10
ffffffff817952a9
Mar 15 12:09:22 ivy kernel:  ffffffffc324f17e ffffffff81795caa 0000000000000202
000000000000312d
Mar 15 12:09:22 ivy kernel: Call Trace:
Mar 15 12:09:22 ivy kernel:  [<ffffffff816fcef7>] ? dump_stack+0x70/0xb9
Mar 15 12:09:22 ivy kernel:  [<ffffffff817952a9>] ? ubsan_epilogue+0x9/0x40
Mar 15 12:09:22 ivy kernel:  [<ffffffff81795caa>] ?
__ubsan_handle_shift_out_of_bounds+0xfa/0x150
Mar 15 12:09:22 ivy kernel:  [<ffffffff81380031>] ? use_mm+0x3e1/0x5d0
Mar 15 12:09:22 ivy kernel:  [<ffffffffc310e408>] ? ext4_mb_init+0xbf8/0xf70
[ext4]
Mar 15 12:09:22 ivy kernel:  [<ffffffffc31146db>] ?
ext4_setup_system_zone+0x20b/0x4d0 [ext4]
Mar 15 12:09:22 ivy kernel:  [<ffffffffc30cbd5e>] ?
ext4_fill_super+0x52fe/0x83a0 [ext4]
Mar 15 12:09:22 ivy kernel:  [<ffffffff817252b9>] ? snprintf+0x49/0x60
Mar 15 12:09:22 ivy kernel:  [<ffffffffc30c6a60>] ?
ext4_calculate_overhead+0xc90/0xc90 [ext4]
Mar 15 12:09:22 ivy kernel:  [<ffffffff8145a549>] ? mount_bdev+0x1a9/0x290
Mar 15 12:09:22 ivy kernel:  [<ffffffff8145bbba>] ? mount_fs+0x4a/0x280
Mar 15 12:09:22 ivy kernel:  [<ffffffff81499906>] ? vfs_kern_mount+0x76/0x290
Mar 15 12:09:22 ivy kernel:  [<ffffffff814a118c>] ? do_mount+0x2ac/0x1be0
Mar 15 12:09:22 ivy kernel:  [<ffffffff814a0bd5>] ?
copy_mount_options+0x35/0x320
Mar 15 12:09:22 ivy kernel:  [<ffffffff814a3274>] ? SyS_mount+0x84/0xc0
Mar 15 12:09:22 ivy kernel:  [<ffffffff81dfbcf6>] ?
entry_SYSCALL_64_fastpath+0x16/0x75
Mar 15 12:09:22 ivy kernel:
================================================================================

Let me know if you need more information.

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
