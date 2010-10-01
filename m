From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 19432] New: ext4 crashes in journal code/barrier
Date: Fri, 1 Oct 2010 15:47:28 GMT
Message-ID: <bug-19432-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from [140.211.167.42] ([140.211.167.42]:42799 "EHLO
	demeter2.kernel.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab0JAPra (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Oct 2010 11:47:30 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.3) with ESMTP id o91FlSI2014380
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Fri, 1 Oct 2010 15:47:28 GMT
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=19432

           Summary: ext4 crashes in journal code/barrier
           Product: File System
           Version: 2.5
    Kernel Version: Ubuntu Linux 2.6.32-24-generic
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: valerio@aimale.com
        Regression: No


I've seen several kernel crashes inside the ext4 journal/barrire code. It's a
db mysql server with Adaptec RAID Controller. The RAID controller is an Adaptec
RAID 52445, with battery-backed write cache

06:00.0 RAID bus controller: Adaptec AAC-RAID (rev 09)
    Subsystem: Adaptec Device 02d0
    Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
    Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort- >SERR- <PERR- INTx-
    Latency: 0, Cache Line Size: 32 bytes
    Interrupt: pin A routed to IRQ 16
    Region 0: Memory at fb200000 (64-bit, non-prefetchable) [size=2M]
    Expansion ROM at fb180000 [disabled] [size=512K]
    Capabilities: <access denied>
    Kernel driver in use: aacraid
    Kernel modules: aacraid

The kernel crashes when mysql accesses a 4TB RAID10 disk (4 2TB disks).
The disk fsck's OK even with forcing.

====================================
Sep 29 23:49:51 rembrandt kernel: [480678.084872] mysqld        D
ffff88002820fb08     0  8217      1 0x00000000
Sep 29 23:49:51 rembrandt kernel: [480678.084879]  ffff88008442b958
0000000000000082 0000000000000000 ffffffff81215643
Sep 29 23:49:51 rembrandt kernel: [480678.084886]  ffff880000000041
ffff88008442b908 ffff88042e2116c0 0000000102de6b4e
Sep 29 23:49:51 rembrandt kernel: [480678.084892]  ffff8804298a03c0
ffff88008442bfd8 000000000000fb08 ffff8804298a03c0
Sep 29 23:49:51 rembrandt kernel: [480678.084899] Call Trace:
Sep 29 23:49:51 rembrandt kernel: [480678.084907]  [<ffffffff81215643>] ?
do_get_write_access+0x383/0x5e0
Sep 29 23:49:51 rembrandt kernel: [480678.084909]  [<ffffffff812155dd>]
do_get_write_access+0x31d/0x5e0
Sep 29 23:49:51 rembrandt kernel: [480678.084913]  [<ffffffff81082500>] ?
wake_bit_function+0x0/0x40
Sep 29 23:49:51 rembrandt kernel: [480678.084915]  [<ffffffff81215a31>]
jbd2_journal_get_write_access+0x31/0x50
Sep 29 23:49:51 rembrandt kernel: [480678.084918]  [<ffffffff811fd098>]
__ext4_journal_get_write_access+0x38/0x70
Sep 29 23:49:51 rembrandt kernel: [480678.084921]  [<ffffffff8120430f>]
ext4_mb_free_blocks+0x29f/0x880
Sep 29 23:49:51 rembrandt kernel: [480678.084924]  [<ffffffff81167798>] ?
__find_get_block+0xc8/0x200
Sep 29 23:49:51 rembrandt kernel: [480678.084927]  [<ffffffff811d06fd>]
ext4_free_blocks+0x3d/0x100
Sep 29 23:49:51 rembrandt kernel: [480678.084929]  [<ffffffff811fa264>]
ext4_ext_truncate+0x884/0xa40
Sep 29 23:49:51 rembrandt kernel: [480678.084932]  [<ffffffff811db748>]
ext4_truncate+0x4a8/0x640
Sep 29 23:49:51 rembrandt kernel: [480678.084934]  [<ffffffff811d664a>] ?
ext4_mark_iloc_dirty+0x36a/0x5b0
Sep 29 23:49:51 rembrandt kernel: [480678.084937]  [<ffffffff811d81a3>] ?
ext4_mark_inode_dirty+0x83/0x1d0
Sep 29 23:49:51 rembrandt kernel: [480678.084939]  [<ffffffff811f20a8>] ?
ext4_journal_start_sb+0xf8/0x130
Sep 29 23:49:51 rembrandt kernel: [480678.084941]  [<ffffffff811dca80>] ?
ext4_delete_inode+0x0/0x2e0
Sep 29 23:49:51 rembrandt kernel: [480678.084943]  [<ffffffff811dcd08>]
ext4_delete_inode+0x288/0x2e0
Sep 29 23:49:51 rembrandt kernel: [480678.084945]  [<ffffffff811dca80>] ?
ext4_delete_inode+0x0/0x2e0
Sep 29 23:49:51 rembrandt kernel: [480678.084948]  [<ffffffff81156793>]
generic_delete_inode+0xe3/0x1c0
Sep 29 23:49:51 rembrandt kernel: [480678.084950]  [<ffffffff811568d5>]
generic_drop_inode+0x65/0x80
Sep 29 23:49:51 rembrandt kernel: [480678.084952]  [<ffffffff81155642>]
iput+0x62/0x70
Sep 29 23:49:51 rembrandt kernel: [480678.084955]  [<ffffffff81151a00>]
dentry_iput+0x90/0x100
Sep 29 23:49:51 rembrandt kernel: [480678.084956]  [<ffffffff81151b80>]
d_kill+0x50/0x80
Sep 29 23:49:51 rembrandt kernel: [480678.084958]  [<ffffffff811539d7>]
dput+0xb7/0x1b0
Sep 29 23:49:51 rembrandt kernel: [480678.084961]  [<ffffffff81140301>]
__fput+0x181/0x210
Sep 29 23:49:51 rembrandt kernel: [480678.084962]  [<ffffffff811403b5>]
fput+0x25/0x30
Sep 29 23:49:51 rembrandt kernel: [480678.084965]  [<ffffffff8113c4dd>]
filp_close+0x5d/0x90
Sep 29 23:49:51 rembrandt kernel: [480678.084967]  [<ffffffff8113c5c7>]
sys_close+0xb7/0x120
Sep 29 23:49:51 rembrandt kernel: [480678.084971]  [<ffffffff810120f2>]
system_call_fastpath+0x16/0x1b
Sep 29 23:51:51 rembrandt kernel: [480797.804576] mysqld        D
ffff88002820fb08     0  8217      1 0x00000000
Sep 29 23:51:51 rembrandt kernel: [480797.804583]  ffff88008442b958
0000000000000082 0000000000000000 ffffffff81215643
Sep 29 23:51:51 rembrandt kernel: [480797.804590]  ffff880000000041
ffff88008442b908 ffff88042e2116c0 0000000102de6b4e
Sep 29 23:51:51 rembrandt kernel: [480797.804596]  ffff8804298a03c0
ffff88008442bfd8 000000000000fb08 ffff8804298a03c0
Sep 29 23:51:51 rembrandt kernel: [480797.804602] Call Trace:
Sep 29 23:51:51 rembrandt kernel: [480797.804615]  [<ffffffff81215643>] ?
do_get_write_access+0x383/0x5e0
Sep 29 23:51:51 rembrandt kernel: [480797.804618]  [<ffffffff812155dd>]
do_get_write_access+0x31d/0x5e0
Sep 29 23:51:51 rembrandt kernel: [480797.804621]  [<ffffffff81082500>] ?
wake_bit_function+0x0/0x40
Sep 29 23:51:51 rembrandt kernel: [480797.804624]  [<ffffffff81215a31>]
jbd2_journal_get_write_access+0x31/0x50
Sep 29 23:51:51 rembrandt kernel: [480797.804627]  [<ffffffff811fd098>]
__ext4_journal_get_write_access+0x38/0x70
Sep 29 23:51:51 rembrandt kernel: [480797.804630]  [<ffffffff8120430f>]
ext4_mb_free_blocks+0x29f/0x880
Sep 29 23:51:51 rembrandt kernel: [480797.804633]  [<ffffffff81167798>] ?
__find_get_block+0xc8/0x200
Sep 29 23:51:51 rembrandt kernel: [480797.804637]  [<ffffffff811d06fd>]
ext4_free_blocks+0x3d/0x100
Sep 29 23:51:51 rembrandt kernel: [480797.804639]  [<ffffffff811fa264>]
ext4_ext_truncate+0x884/0xa40
Sep 29 23:51:51 rembrandt kernel: [480797.804642]  [<ffffffff811db748>]
ext4_truncate+0x4a8/0x640
Sep 29 23:51:51 rembrandt kernel: [480797.804644]  [<ffffffff811d664a>] ?
ext4_mark_iloc_dirty+0x36a/0x5b0
Sep 29 23:51:51 rembrandt kernel: [480797.804646]  [<ffffffff811d81a3>] ?
ext4_mark_inode_dirty+0x83/0x1d0
Sep 29 23:51:51 rembrandt kernel: [480797.804649]  [<ffffffff811f20a8>] ?
ext4_journal_start_sb+0xf8/0x130
Sep 29 23:51:51 rembrandt kernel: [480797.804651]  [<ffffffff811dca80>] ?
ext4_delete_inode+0x0/0x2e0
Sep 29 23:51:51 rembrandt kernel: [480797.804653]  [<ffffffff811dcd08>]
ext4_delete_inode+0x288/0x2e0
Sep 29 23:51:51 rembrandt kernel: [480797.804655]  [<ffffffff811dca80>] ?
ext4_delete_inode+0x0/0x2e0
Sep 29 23:51:51 rembrandt kernel: [480797.804658]  [<ffffffff81156793>]
generic_delete_inode+0xe3/0x1c0
Sep 29 23:51:51 rembrandt kernel: [480797.804660]  [<ffffffff811568d5>]
generic_drop_inode+0x65/0x80
Sep 29 23:51:51 rembrandt kernel: [480797.804662]  [<ffffffff81155642>]
iput+0x62/0x70
Sep 29 23:51:51 rembrandt kernel: [480797.804664]  [<ffffffff81151a00>]
dentry_iput+0x90/0x100
Sep 29 23:51:51 rembrandt kernel: [480797.804666]  [<ffffffff81151b80>]
d_kill+0x50/0x80
Sep 29 23:51:51 rembrandt kernel: [480797.804668]  [<ffffffff811539d7>]
dput+0xb7/0x1b0
Sep 29 23:51:51 rembrandt kernel: [480797.804670]  [<ffffffff81140301>]
__fput+0x181/0x210
Sep 29 23:51:51 rembrandt kernel: [480797.804672]  [<ffffffff811403b5>]
fput+0x25/0x30
Sep 29 23:51:51 rembrandt kernel: [480797.804675]  [<ffffffff8113c4dd>]
filp_close+0x5d/0x90
Sep 29 23:51:51 rembrandt kernel: [480797.804677]  [<ffffffff8113c5c7>]
sys_close+0xb7/0x120
Sep 29 23:51:51 rembrandt kernel: [480797.804680]  [<ffffffff810120f2>]
system_call_fastpath+0x16/0x1b
Sep 29 23:53:51 rembrandt kernel: [480917.524309] mysqld        D
ffff88002820fb08     0  8217      1 0x00000000
Sep 29 23:53:51 rembrandt kernel: [480917.524316]  ffff88008442b958
0000000000000082 0000000000000000 ffffffff81215643
Sep 29 23:53:51 rembrandt kernel: [480917.524323]  ffff880000000041
ffff88008442b908 ffff88042e2116c0 0000000102de6b4e
Sep 29 23:53:51 rembrandt kernel: [480917.524330]  ffff8804298a03c0
ffff88008442bfd8 000000000000fb08 ffff8804298a03c0
Sep 29 23:53:51 rembrandt kernel: [480917.524332] Call Trace:
Sep 29 23:53:51 rembrandt kernel: [480917.524339]  [<ffffffff81215643>] ?
do_get_write_access+0x383/0x5e0
Sep 29 23:53:51 rembrandt kernel: [480917.524342]  [<ffffffff812155dd>]
do_get_write_access+0x31d/0x5e0
Sep 29 23:53:51 rembrandt kernel: [480917.524345]  [<ffffffff81082500>] ?
wake_bit_function+0x0/0x40
Sep 29 23:53:51 rembrandt kernel: [480917.524347]  [<ffffffff81215a31>]
jbd2_journal_get_write_access+0x31/0x50
Sep 29 23:53:51 rembrandt kernel: [480917.524351]  [<ffffffff811fd098>]
__ext4_journal_get_write_access+0x38/0x70
Sep 29 23:53:51 rembrandt kernel: [480917.524354]  [<ffffffff8120430f>]
ext4_mb_free_blocks+0x29f/0x880
Sep 29 23:53:51 rembrandt kernel: [480917.524357]  [<ffffffff81167798>] ?
__find_get_block+0xc8/0x200
Sep 29 23:53:51 rembrandt kernel: [480917.524360]  [<ffffffff811d06fd>]
ext4_free_blocks+0x3d/0x100
Sep 29 23:53:51 rembrandt kernel: [480917.524362]  [<ffffffff811fa264>]
ext4_ext_truncate+0x884/0xa40
Sep 29 23:53:51 rembrandt kernel: [480917.524365]  [<ffffffff811db748>]
ext4_truncate+0x4a8/0x640
Sep 29 23:53:51 rembrandt kernel: [480917.524367]  [<ffffffff811d664a>] ?
ext4_mark_iloc_dirty+0x36a/0x5b0
Sep 29 23:53:51 rembrandt kernel: [480917.524370]  [<ffffffff811d81a3>] ?
ext4_mark_inode_dirty+0x83/0x1d0
Sep 29 23:53:51 rembrandt kernel: [480917.524372]  [<ffffffff811f20a8>] ?
ext4_journal_start_sb+0xf8/0x130
Sep 29 23:53:51 rembrandt kernel: [480917.524374]  [<ffffffff811dca80>] ?
ext4_delete_inode+0x0/0x2e0
Sep 29 23:53:51 rembrandt kernel: [480917.524376]  [<ffffffff811dcd08>]
ext4_delete_inode+0x288/0x2e0
Sep 29 23:53:51 rembrandt kernel: [480917.524378]  [<ffffffff811dca80>] ?
ext4_delete_inode+0x0/0x2e0
Sep 29 23:53:51 rembrandt kernel: [480917.524382]  [<ffffffff81156793>]
generic_delete_inode+0xe3/0x1c0
Sep 29 23:53:51 rembrandt kernel: [480917.524384]  [<ffffffff811568d5>]
generic_drop_inode+0x65/0x80
Sep 29 23:53:51 rembrandt kernel: [480917.524386]  [<ffffffff81155642>]
iput+0x62/0x70
Sep 29 23:53:51 rembrandt kernel: [480917.524388]  [<ffffffff81151a00>]
dentry_iput+0x90/0x100
Sep 29 23:53:51 rembrandt kernel: [480917.524390]  [<ffffffff81151b80>]
d_kill+0x50/0x80
Sep 29 23:53:51 rembrandt kernel: [480917.524391]  [<ffffffff811539d7>]
dput+0xb7/0x1b0
Sep 29 23:53:51 rembrandt kernel: [480917.524394]  [<ffffffff81140301>]
__fput+0x181/0x210
Sep 29 23:53:51 rembrandt kernel: [480917.524396]  [<ffffffff811403b5>]
fput+0x25/0x30
Sep 29 23:53:51 rembrandt kernel: [480917.524399]  [<ffffffff8113c4dd>]
filp_close+0x5d/0x90
Sep 29 23:53:51 rembrandt kernel: [480917.524401]  [<ffffffff8113c5c7>]
sys_close+0xb7/0x120
Sep 29 23:53:51 rembrandt kernel: [480917.524404]  [<ffffffff810120f2>]
system_call_fastpath+0x16/0x1b
Sep 29 23:55:51 rembrandt kernel: [481037.243988] mysqld        D
ffff88002820fb08     0  8217      1 0x00000000
Sep 29 23:55:51 rembrandt kernel: [481037.243995]  ffff88008442b958
0000000000000082 0000000000000000 ffffffff81215643
Sep 29 23:55:51 rembrandt kernel: [481037.244002]  ffff880000000041
ffff88008442b908 ffff88042e2116c0 0000000102de6b4e
Sep 29 23:55:51 rembrandt kernel: [481037.244008]  ffff8804298a03c0
ffff88008442bfd8 000000000000fb08 ffff8804298a03c0
Sep 29 23:55:51 rembrandt kernel: [481037.244014] Call Trace:
Sep 29 23:55:51 rembrandt kernel: [481037.244021]  [<ffffffff81215643>] ?
do_get_write_access+0x383/0x5e0
Sep 29 23:55:51 rembrandt kernel: [481037.244024]  [<ffffffff812155dd>]
do_get_write_access+0x31d/0x5e0
Sep 29 23:55:51 rembrandt kernel: [481037.244027]  [<ffffffff81082500>] ?
wake_bit_function+0x0/0x40
Sep 29 23:55:51 rembrandt kernel: [481037.244029]  [<ffffffff81215a31>]
jbd2_journal_get_write_access+0x31/0x50
Sep 29 23:55:51 rembrandt kernel: [481037.244033]  [<ffffffff811fd098>]
__ext4_journal_get_write_access+0x38/0x70
Sep 29 23:55:51 rembrandt kernel: [481037.244036]  [<ffffffff8120430f>]
ext4_mb_free_blocks+0x29f/0x880
Sep 29 23:55:51 rembrandt kernel: [481037.244039]  [<ffffffff81167798>] ?
__find_get_block+0xc8/0x200
Sep 29 23:55:51 rembrandt kernel: [481037.244042]  [<ffffffff811d06fd>]
ext4_free_blocks+0x3d/0x100
Sep 29 23:55:51 rembrandt kernel: [481037.244044]  [<ffffffff811fa264>]
ext4_ext_truncate+0x884/0xa40
Sep 29 23:55:51 rembrandt kernel: [481037.244047]  [<ffffffff811db748>]
ext4_truncate+0x4a8/0x640
Sep 29 23:55:51 rembrandt kernel: [481037.244050]  [<ffffffff811d664a>] ?
ext4_mark_iloc_dirty+0x36a/0x5b0
Sep 29 23:55:51 rembrandt kernel: [481037.244052]  [<ffffffff811d81a3>] ?
ext4_mark_inode_dirty+0x83/0x1d0
Sep 29 23:55:51 rembrandt kernel: [481037.244054]  [<ffffffff811f20a8>] ?
ext4_journal_start_sb+0xf8/0x130
Sep 29 23:55:51 rembrandt kernel: [481037.244056]  [<ffffffff811dca80>] ?
ext4_delete_inode+0x0/0x2e0
Sep 29 23:55:51 rembrandt kernel: [481037.244059]  [<ffffffff811dcd08>]
ext4_delete_inode+0x288/0x2e0
Sep 29 23:55:51 rembrandt kernel: [481037.244061]  [<ffffffff811dca80>] ?
ext4_delete_inode+0x0/0x2e0
Sep 29 23:55:51 rembrandt kernel: [481037.244063]  [<ffffffff81156793>]
generic_delete_inode+0xe3/0x1c0
Sep 29 23:55:51 rembrandt kernel: [481037.244066]  [<ffffffff811568d5>]
generic_drop_inode+0x65/0x80
Sep 29 23:55:51 rembrandt kernel: [481037.244068]  [<ffffffff81155642>]
iput+0x62/0x70
Sep 29 23:55:51 rembrandt kernel: [481037.244070]  [<ffffffff81151a00>]
dentry_iput+0x90/0x100
Sep 29 23:55:51 rembrandt kernel: [481037.244071]  [<ffffffff81151b80>]
d_kill+0x50/0x80
Sep 29 23:55:51 rembrandt kernel: [481037.244073]  [<ffffffff811539d7>]
dput+0xb7/0x1b0
Sep 29 23:55:51 rembrandt kernel: [481037.244076]  [<ffffffff81140301>]
__fput+0x181/0x210
Sep 29 23:55:51 rembrandt kernel: [481037.244078]  [<ffffffff811403b5>]
fput+0x25/0x30
Sep 29 23:55:51 rembrandt kernel: [481037.244080]  [<ffffffff8113c4dd>]
filp_close+0x5d/0x90
Sep 29 23:55:51 rembrandt kernel: [481037.244083]  [<ffffffff8113c5c7>]
sys_close+0xb7/0x120
Sep 29 23:55:51 rembrandt kernel: [481037.244086]  [<ffffffff810120f2>]
system_call_fastpath+0x16/0x1b
Sep 29 23:59:51 rembrandt kernel: [481276.683396] mysqld        D
ffff88002820fb08     0  8217      1 0x00000000
Sep 29 23:59:51 rembrandt kernel: [481276.683403]  ffff88008442bde8
0000000000000082 0000000000000000 0000000000000000
Sep 29 23:59:51 rembrandt kernel: [481276.683409]  ffff88042919a0a0
ffff88042919a0a8 ffff88008442bd88 0000000102df6598
Sep 29 23:59:51 rembrandt kernel: [481276.683415]  ffff8804298a03c0
ffff88008442bfd8 000000000000fb08 ffff8804298a03c0
Sep 29 23:59:51 rembrandt kernel: [481276.683423] Call Trace:
Sep 29 23:59:51 rembrandt kernel: [481276.683430]  [<ffffffff8121cdd5>]
jbd2_log_wait_commit+0xc5/0x150
Sep 29 23:59:51 rembrandt kernel: [481276.683433]  [<ffffffff810824c0>] ?
autoremove_wake_function+0x0/0x40
Sep 29 23:59:51 rembrandt kernel: [481276.683435]  [<ffffffff8121ce96>] ?
__jbd2_log_start_commit+0x36/0x40
Sep 29 23:59:51 rembrandt kernel: [481276.683439]  [<ffffffff811d259c>]
ext4_sync_file+0x13c/0x2e0
Sep 29 23:59:51 rembrandt kernel: [481276.683443]  [<ffffffff811656a1>]
vfs_fsync_range+0xa1/0xe0
Sep 29 23:59:51 rembrandt kernel: [481276.683445]  [<ffffffff8116574d>]
vfs_fsync+0x1d/0x20
Sep 29 23:59:51 rembrandt kernel: [481276.683447]  [<ffffffff8116578e>]
do_fsync+0x3e/0x60
Sep 29 23:59:51 rembrandt kernel: [481276.683449]  [<ffffffff811657c3>]
sys_fdatasync+0x13/0x20
Sep 29 23:59:51 rembrandt kernel: [481276.683452]  [<ffffffff810120f2>]
system_call_fastpath+0x16/0x1b
Sep 30 00:01:51 rembrandt kernel: [481396.403126] mysqld        D
ffff88002820fb08     0  8217      1 0x00000000
Sep 30 00:01:51 rembrandt kernel: [481396.403133]  ffff88008442bde8
0000000000000082 0000000000000000 0000000000000000
Sep 30 00:01:51 rembrandt kernel: [481396.403140]  ffff88042919a0a0
ffff88042919a0a8 ffff88008442bd88 0000000102df6598
Sep 30 00:01:51 rembrandt kernel: [481396.403145]  ffff8804298a03c0
ffff88008442bfd8 000000000000fb08 ffff8804298a03c0
Sep 30 00:01:51 rembrandt kernel: [481396.403152] Call Trace:
Sep 30 00:01:51 rembrandt kernel: [481396.403158]  [<ffffffff8121cdd5>]
jbd2_log_wait_commit+0xc5/0x150
Sep 30 00:01:51 rembrandt kernel: [481396.403162]  [<ffffffff810824c0>] ?
autoremove_wake_function+0x0/0x40
Sep 30 00:01:51 rembrandt kernel: [481396.403164]  [<ffffffff8121ce96>] ?
__jbd2_log_start_commit+0x36/0x40
Sep 30 00:01:51 rembrandt kernel: [481396.403167]  [<ffffffff811d259c>]
ext4_sync_file+0x13c/0x2e0
Sep 30 00:01:51 rembrandt kernel: [481396.403171]  [<ffffffff811656a1>]
vfs_fsync_range+0xa1/0xe0
Sep 30 00:01:51 rembrandt kernel: [481396.403173]  [<ffffffff8116574d>]
vfs_fsync+0x1d/0x20
Sep 30 00:01:51 rembrandt kernel: [481396.403175]  [<ffffffff8116578e>]
do_fsync+0x3e/0x60
Sep 30 00:01:51 rembrandt kernel: [481396.403178]  [<ffffffff811657c3>]
sys_fdatasync+0x13/0x20
Sep 30 00:01:51 rembrandt kernel: [481396.403181]  [<ffffffff810120f2>]
system_call_fastpath+0x16/0x1b
Sep 30 00:03:51 rembrandt kernel: [481516.122819] mysqld        D
ffff88002820fb08     0  8217      1 0x00000000
Sep 30 00:03:51 rembrandt kernel: [481516.122826]  ffff88008442bde8
0000000000000082 0000000000000000 0000000000000000
Sep 30 00:03:51 rembrandt kernel: [481516.122832]  ffff88042919a0a0
ffff88042919a0a8 ffff88008442bd88 0000000102df6598
Sep 30 00:03:51 rembrandt kernel: [481516.122841]  ffff8804298a03c0
ffff88008442bfd8 000000000000fb08 ffff8804298a03c0
Sep 30 00:03:51 rembrandt kernel: [481516.122844] Call Trace:
Sep 30 00:03:51 rembrandt kernel: [481516.122850]  [<ffffffff8121cdd5>]
jbd2_log_wait_commit+0xc5/0x150
Sep 30 00:03:51 rembrandt kernel: [481516.122854]  [<ffffffff810824c0>] ?
autoremove_wake_function+0x0/0x40
Sep 30 00:03:51 rembrandt kernel: [481516.122856]  [<ffffffff8121ce96>] ?
__jbd2_log_start_commit+0x36/0x40
Sep 30 00:03:51 rembrandt kernel: [481516.122859]  [<ffffffff811d259c>]
ext4_sync_file+0x13c/0x2e0
Sep 30 00:03:51 rembrandt kernel: [481516.122863]  [<ffffffff811656a1>]
vfs_fsync_range+0xa1/0xe0
Sep 30 00:03:51 rembrandt kernel: [481516.122865]  [<ffffffff8116574d>]
vfs_fsync+0x1d/0x20
Sep 30 00:03:51 rembrandt kernel: [481516.122867]  [<ffffffff8116578e>]
do_fsync+0x3e/0x60
Sep 30 00:03:51 rembrandt kernel: [481516.122869]  [<ffffffff811657c3>]
sys_fdatasync+0x13/0x20
Sep 30 00:03:51 rembrandt kernel: [481516.122873]  [<ffffffff810120f2>]
system_call_fastpath+0x16/0x1b
Sep 30 04:57:51 rembrandt kernel: [499114.929336] mysqld        D
ffff88002820fb08     0 29529      1 0x00000000
Sep 30 04:57:51 rembrandt kernel: [499114.929343]  ffff88040ccb9cf8
0000000000000082 0000000000000000 ffff88040ccb9d18
Sep 30 04:57:51 rembrandt kernel: [499114.929350]  ffff88040ccb9c78
ffffffff811539ff ffff88040ccb9d18 0000000102fab0f0
Sep 30 04:57:51 rembrandt kernel: [499114.929356]  ffff8803de475f80
ffff88040ccb9fd8 000000000000fb08 ffff8803de475f80
Sep 30 04:57:51 rembrandt kernel: [499114.929363] Call Trace:
Sep 30 04:57:51 rembrandt kernel: [499114.929369]  [<ffffffff811539ff>] ?
dput+0xdf/0x1b0
Sep 30 04:57:51 rembrandt kernel: [499114.929373]  [<ffffffff8121cdd5>]
jbd2_log_wait_commit+0xc5/0x150
Sep 30 04:57:51 rembrandt kernel: [499114.929376]  [<ffffffff812196ba>] ?
__jbd2_log_space_left+0x1a/0x40
Sep 30 04:57:51 rembrandt kernel: [499114.929380]  [<ffffffff810824c0>] ?
autoremove_wake_function+0x0/0x40
Sep 30 04:57:51 rembrandt kernel: [499114.929383]  [<ffffffff81018d59>] ?
read_tsc+0x9/0x20
Sep 30 04:57:51 rembrandt kernel: [499114.929386]  [<ffffffff81213f0b>]
jbd2_journal_stop+0x27b/0x2c0
Sep 30 04:57:51 rembrandt kernel: [499114.929388]  [<ffffffff81214825>] ?
jbd2_journal_start+0xb5/0x100
Sep 30 04:57:51 rembrandt kernel: [499114.929390]  [<ffffffff81214897>]
jbd2_journal_force_commit+0x27/0x30
Sep 30 04:57:51 rembrandt kernel: [499114.929393]  [<ffffffff811f0179>]
ext4_force_commit+0xb9/0xe0
Sep 30 04:57:51 rembrandt kernel: [499114.929396]  [<ffffffff811d253e>]
ext4_sync_file+0xde/0x2e0
Sep 30 04:57:51 rembrandt kernel: [499114.929400]  [<ffffffff811656a1>]
vfs_fsync_range+0xa1/0xe0
Sep 30 04:57:51 rembrandt kernel: [499114.929402]  [<ffffffff8116574d>]
vfs_fsync+0x1d/0x20
Sep 30 04:57:51 rembrandt kernel: [499114.929404]  [<ffffffff8116578e>]
do_fsync+0x3e/0x60
Sep 30 04:57:51 rembrandt kernel: [499114.929406]  [<ffffffff811657c3>]
sys_fdatasync+0x13/0x20
Sep 30 04:57:51 rembrandt kernel: [499114.929409]  [<ffffffff810120f2>]
system_call_fastpath+0x16/0x1b
Sep 30 04:59:51 rembrandt kernel: [499234.649054] mysqld        D
ffff88002820fb08     0 29529      1 0x00000000
Sep 30 04:59:51 rembrandt kernel: [499234.649061]  ffff88040ccb9cf8
0000000000000082 0000000000000000 ffff88040ccb9d18
Sep 30 04:59:51 rembrandt kernel: [499234.649068]  ffff88040ccb9c78
ffffffff811539ff ffff88040ccb9d18 0000000102fab0f0
Sep 30 04:59:51 rembrandt kernel: [499234.649073]  ffff8803de475f80
ffff88040ccb9fd8 000000000000fb08 ffff8803de475f80
Sep 30 04:59:51 rembrandt kernel: [499234.649082] Call Trace:
Sep 30 04:59:51 rembrandt kernel: [499234.649089]  [<ffffffff811539ff>] ?
dput+0xdf/0x1b0
Sep 30 04:59:51 rembrandt kernel: [499234.649092]  [<ffffffff8121cdd5>]
jbd2_log_wait_commit+0xc5/0x150
Sep 30 04:59:51 rembrandt kernel: [499234.649096]  [<ffffffff812196ba>] ?
__jbd2_log_space_left+0x1a/0x40
Sep 30 04:59:51 rembrandt kernel: [499234.649099]  [<ffffffff810824c0>] ?
autoremove_wake_function+0x0/0x40
Sep 30 04:59:51 rembrandt kernel: [499234.649102]  [<ffffffff81018d59>] ?
read_tsc+0x9/0x20
Sep 30 04:59:51 rembrandt kernel: [499234.649105]  [<ffffffff81213f0b>]
jbd2_journal_stop+0x27b/0x2c0
Sep 30 04:59:51 rembrandt kernel: [499234.649107]  [<ffffffff81214825>] ?
jbd2_journal_start+0xb5/0x100
Sep 30 04:59:51 rembrandt kernel: [499234.649109]  [<ffffffff81214897>]
jbd2_journal_force_commit+0x27/0x30
Sep 30 04:59:51 rembrandt kernel: [499234.649112]  [<ffffffff811f0179>]
ext4_force_commit+0xb9/0xe0
Sep 30 04:59:51 rembrandt kernel: [499234.649115]  [<ffffffff811d253e>]
ext4_sync_file+0xde/0x2e0
Sep 30 04:59:51 rembrandt kernel: [499234.649119]  [<ffffffff811656a1>]
vfs_fsync_range+0xa1/0xe0
Sep 30 04:59:51 rembrandt kernel: [499234.649121]  [<ffffffff8116574d>]
vfs_fsync+0x1d/0x20
Sep 30 04:59:51 rembrandt kernel: [499234.649123]  [<ffffffff8116578e>]
do_fsync+0x3e/0x60
Sep 30 04:59:51 rembrandt kernel: [499234.649125]  [<ffffffff811657c3>]
sys_fdatasync+0x13/0x20
Sep 30 04:59:51 rembrandt kernel: [499234.649128]  [<ffffffff810120f2>]
system_call_fastpath+0x16/0x1b
Sep 30 05:01:51 rembrandt kernel: [499354.368766] mysqld        D
ffff88002820fb08     0 29529      1 0x00000000
Sep 30 05:01:51 rembrandt kernel: [499354.368773]  ffff88040ccb9cf8
0000000000000082 0000000000000000 ffff88040ccb9d18
Sep 30 05:01:51 rembrandt kernel: [499354.368780]  ffff88040ccb9c78
ffffffff811539ff ffff88040ccb9d18 0000000102fab0f0
Sep 30 05:01:51 rembrandt kernel: [499354.368786]  ffff8803de475f80
ffff88040ccb9fd8 000000000000fb08 ffff8803de475f80
Sep 30 05:01:51 rembrandt kernel: [499354.368789] Call Trace:
Sep 30 05:01:51 rembrandt kernel: [499354.368795]  [<ffffffff811539ff>] ?
dput+0xdf/0x1b0
Sep 30 05:01:51 rembrandt kernel: [499354.368799]  [<ffffffff8121cdd5>]
jbd2_log_wait_commit+0xc5/0x150
Sep 30 05:01:51 rembrandt kernel: [499354.368802]  [<ffffffff812196ba>] ?
__jbd2_log_space_left+0x1a/0x40
Sep 30 05:01:51 rembrandt kernel: [499354.368805]  [<ffffffff810824c0>] ?
autoremove_wake_function+0x0/0x40
Sep 30 05:01:51 rembrandt kernel: [499354.368809]  [<ffffffff81018d59>] ?
read_tsc+0x9/0x20
Sep 30 05:01:51 rembrandt kernel: [499354.368811]  [<ffffffff81213f0b>]
jbd2_journal_stop+0x27b/0x2c0
Sep 30 05:01:51 rembrandt kernel: [499354.368813]  [<ffffffff81214825>] ?
jbd2_journal_start+0xb5/0x100
Sep 30 05:01:51 rembrandt kernel: [499354.368815]  [<ffffffff81214897>]
jbd2_journal_force_commit+0x27/0x30
Sep 30 05:01:51 rembrandt kernel: [499354.368819]  [<ffffffff811f0179>]
ext4_force_commit+0xb9/0xe0
Sep 30 05:01:51 rembrandt kernel: [499354.368822]  [<ffffffff811d253e>]
ext4_sync_file+0xde/0x2e0
Sep 30 05:01:51 rembrandt kernel: [499354.368825]  [<ffffffff811656a1>]
vfs_fsync_range+0xa1/0xe0
Sep 30 05:01:51 rembrandt kernel: [499354.368827]  [<ffffffff8116574d>]
vfs_fsync+0x1d/0x20
Sep 30 05:01:51 rembrandt kernel: [499354.368829]  [<ffffffff8116578e>]
do_fsync+0x3e/0x60
Sep 30 05:01:51 rembrandt kernel: [499354.368831]  [<ffffffff811657c3>]
sys_fdatasync+0x13/0x20
Sep 30 05:01:51 rembrandt kernel: [499354.368834]  [<ffffffff810120f2>]
system_call_fastpath+0x16/0x1b
=======================================================

Yesterday I've remounted with

noatime,data=writeback,barrier=0,nobh,errors=remount-ro

And have not seen a crash yet. But it might just take more time/server abuse to
have it manifest.

That's all the info I have so far. I'm available to run some tests.


Valerio

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
