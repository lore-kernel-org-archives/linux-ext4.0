From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 38372] New: unable to handle kernel NULL pointer dereference in
 ext3
Date: Mon, 27 Jun 2011 23:12:44 GMT
Message-ID: <bug-38372-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from demeter1.kernel.org ([140.211.167.39]:56730 "EHLO
	demeter1.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab1F0XMp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 27 Jun 2011 19:12:45 -0400
Received: from demeter1.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter1.kernel.org (8.14.4/8.14.4) with ESMTP id p5RNCisG018205
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 27 Jun 2011 23:12:44 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=38372

           Summary: unable to handle kernel NULL pointer dereference in
                    ext3
           Product: File System
           Version: 2.5
    Kernel Version: 2.6.37.6
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: high
          Priority: P1
         Component: ext3
        AssignedTo: fs_ext3@kernel-bugs.osdl.org
        ReportedBy: rdewit@wise-guys.nl
        Regression: No


Unable to handle kernel NULL pointer dereference in ext3

after that every read/write on filesystem hangs.

System is a dual 4-core Supermicro with 64GB RAM, running 64-bit kernel running
on a 32-bit OS using 32-bit compatibility in the kernel.


Here's a log, if anything more is needed I'll add it.

Jun 27 22:44:46 kernel: BUG: unable to handle kernel NULL pointer dereference
at 0000000000000010
Jun 27 22:44:46 kernel: IP: [<ffffffff811e2f35>] rb_insert_color+0x17/0xd9
Jun 27 22:44:46 kernel: PGD 9b570b067 PUD 597522067 PMD 0
Jun 27 22:44:46 kernel: Oops: 0000 [#1] SMP
Jun 27 22:44:46 kernel: last sysfs file: /sys/block/sdd/queue/scheduler
Jun 27 22:44:46 kernel: CPU 7
Jun 27 22:44:46 kernel: Modules linked in: i2c_dev i2c_core fuse ip6t_LOG
ipt_REJECT ipt_LOG xt_limit xt_state xt_mark ip6tabl
e_mangle iptable_mangle iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack
nf_defrag_ipv4 iptable_filter ip_tables ip6table_filter ip6_t
ables
Jun 27 22:44:46 kernel:
Jun 27 22:44:46 kernel: Pid: 12128, comm: zsh Tainted: G   M        2.6.37.6 #2
Supermicro X8DTU/X8DTU
Jun 27 22:44:46 kernel: RIP: 0010:[<ffffffff811e2f35>]  [<ffffffff811e2f35>]
rb_insert_color+0x17/0xd9
Jun 27 22:44:46 kernel: RSP: 0000:ffff8808179f3ca8  EFLAGS: 00010246
Jun 27 22:44:46 kernel: RAX: ffff880ef08d01c0 RBX: ffff8809b2b947c8 RCX:
0000000000000000
Jun 27 22:44:46 kernel: RDX: ffff8809b2b947d0 RSI: ffff880eb486ce80 RDI:
ffff880ef08d01c8
Jun 27 22:44:46 kernel: RBP: 0000000000000000 R08: 0000000043a5870e R09:
000000000e0e7368
Jun 27 22:44:46 kernel: R10: 000000007468732e R11: 000000006c656e67 R12:
ffff880ef08d01c8
Jun 27 22:44:46 kernel: R13: ffff880eb486ce80 R14: 000000000000003b R15:
ffff88103ba8c540
Jun 27 22:44:46 kernel: FS:  0000000000000000(0000) GS:ffff8800bf5c0000(0063)
knlGS:00000000f761d6c0
Jun 27 22:44:46 kernel: CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
Jun 27 22:44:46 kernel: CR2: 0000000000000010 CR3: 0000000c43672000 CR4:
00000000000006e0
Jun 27 22:44:46 kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
Jun 27 22:44:46 kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
Jun 27 22:44:46 kernel: Process zsh (pid: 12128, threadinfo ffff8808179f2000,
task ffff880820177300)
Jun 27 22:44:46 kernel: Stack:
Jun 27 22:44:46 kernel:  ffff8809b2b947c8 ffff880c6c0be544 ffff880eb486ce80
0000000041b9c94d
Jun 27 22:44:46 kernel:  000000000000003b ffffffff81108d4d ffff880c6c0be544
ffff88103fbfca68
Jun 27 22:44:46 kernel:  ffff880c6c0be544 ffff880ed7317cf8 ffff8808179f3db8
ffffffff811108b4
Jun 27 22:44:46 kernel: Call Trace:
Jun 27 22:44:46 kernel:  [<ffffffff81108d4d>] ?
ext3_htree_store_dirent+0xe0/0xef
Jun 27 22:44:46 kernel:  [<ffffffff811108b4>] ?
htree_dirblock_to_tree+0xef/0x144
Jun 27 22:44:46 kernel:  [<ffffffff81090b23>] ? file_sb_list_add+0xd/0x42
Jun 27 22:44:46 kernel:  [<ffffffff81110983>] ? ext3_htree_fill_tree+0x7a/0x1e6
Jun 27 22:44:46 kernel:  [<ffffffff81084963>] ?
page_add_new_anon_rmap+0x47/0x6c
Jun 27 22:44:46 kernel:  [<ffffffff8110887d>] ? ext3_readdir+0x174/0x536
Jun 27 22:44:46 kernel:  [<ffffffff810c1912>] ? compat_filldir64+0x0/0xd6
Jun 27 22:44:46 kernel:  [<ffffffff8101de7b>] ? do_page_fault+0x31b/0x354
Jun 27 22:44:46 kernel:  [<ffffffff810c1912>] ? compat_filldir64+0x0/0xd6
Jun 27 22:44:46 kernel:  [<ffffffff8109c8c5>] ? vfs_readdir+0x64/0x9c
Jun 27 22:44:46 kernel:  [<ffffffff810c3424>] ? compat_sys_getdents64+0x77/0xbf
Jun 27 22:44:46 kernel:  [<ffffffff814512df>] ? page_fault+0x1f/0x30
Jun 27 22:44:46 kernel:  [<ffffffff81021e43>] ? ia32_sysret+0x0/0x5
Jun 27 22:44:46 kernel: Code: 42 10 eb 03 48 89 06 48 8b 17 83 e2 03 48 09 c2
48 89 17 c3 41 56 41 55 49 89 f5 41 54 49 89 fc
55 53 e9 9e 00 00 00 48 83 e5 fc <48> 8b 45 10 48 39 c3 75 41 48 8b 45 08 48 85
c0 74 08 48 8b 10
Jun 27 22:44:46 kernel: RIP  [<ffffffff811e2f35>] rb_insert_color+0x17/0xd9
Jun 27 22:44:46 kernel:  RSP <ffff8808179f3ca8>
Jun 27 22:44:46 kernel: CR2: 0000000000000010
Jun 27 22:44:46 kernel: ---[ end trace 377318b2e1c551de ]---

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
