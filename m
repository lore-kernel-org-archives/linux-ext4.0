From: "George Spelvin" <linux@sciencehorizons.net>
Subject: Ext4 deadlock (+lockdep splat) during rsync
Date: 8 Jan 2017 17:41:14 -0500
Message-ID: <20170108224114.27157.qmail@ns.sciencehorizons.net>
Cc: linux@sciencehorizons.net
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ns.sciencehorizons.net ([71.41.210.147]:48105 "HELO
        ns.sciencehorizons.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1757216AbdAHWr5 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 8 Jan 2017 17:47:57 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

After replacing a drive in a RAID array, I tried to bring some things
up to date with rsync and ran into an annoyingly repeatable deadlock.

So I found a chance to boot with a lockdep kernel and immediately turned up the following:

[  755.740865] =============================================
[  755.741072] [ INFO: possible recursive locking detected ]
[  755.741279] 4.9.1-00126-gfbb9fcc9-dirty #576 Not tainted
[  755.741489] ---------------------------------------------
[  755.741699] rsync/14818 is trying to acquire lock:
[  755.741907]  (&ei->xattr_sem){++++..}, at: [<ffffffff81234603>] ext4_expand_extra_isize_ea+0x63/0x850
[  755.742145] but task is already holding lock:
[  755.742742]  (&ei->xattr_sem){++++..}, at: [<ffffffff81236f95>] ext4_try_add_inline_entry+0x55/0x1a0
[  755.743102] other info that might help us debug this:
[  755.743802]  Possible unsafe locking scenario:
[  755.743802]        CPU0
[  755.743802]        ----
[  755.743802]   lock(&ei->xattr_sem);
[  755.743802]   lock(&ei->xattr_sem);
[  755.743802] *** DEADLOCK ***
[  755.743802]  May be due to missing lock nesting notation
[  755.743802] 4 locks held by rsync/14818:
[  755.743802]  #0:  (sb_writers#3){.+.+.+}, at: [<ffffffff811a0fef>] mnt_want_write+0x1f/0x50
[  755.743802]  #1:  (&type->i_mutex_dir_key){++++++}, at: [<ffffffff8118b058>] path_openat+0x2f8/0x9f0
[  755.743802]  #2:  (jbd2_handle){++++..}, at: [<ffffffff81239aa6>] start_this_handle+0x196/0x540
[  755.743802]  #3:  (&ei->xattr_sem){++++..}, at: [<ffffffff81236f95>] ext4_try_add_inline_entry+0x55/0x1a0
[  755.743802] stack backtrace:
[  755.743802] CPU: 0 PID: 14818 Comm: rsync Not tainted 4.9.1-00126-gfbb9fcc9-dirty #576
[  755.743802] Hardware name: Gigabyte Technology Co., Ltd. To be filled by O.E.M./X79-UP4, BIOS F7 03/19/2014
[  755.743802]  ffffc9000c273820 ffffffff812a6d05 ffffffff8253a080 ffffffff8253a080
[  755.743802]  ffffc9000c2738d8 ffffffff810c7eab ffffc9000c272000 ffffc90000000004
[  755.743802]  0000000000000000 ffffffff81e0b100 1a883a7e30ec461a ffffffff8253a080
[  755.743802] Call Trace:
[  755.743802]  [<ffffffff812a6d05>] dump_stack+0x68/0x93
[  755.743802]  [<ffffffff810c7eab>] __lock_acquire+0x7ab/0x1270
[  755.743802]  [<ffffffff810c8d10>] lock_acquire+0x60/0x80
[  755.743802]  [<ffffffff81234603>] ? ext4_expand_extra_isize_ea+0x63/0x850
[  755.743802]  [<ffffffff81793a44>] down_write+0x44/0x80
[  755.743802]  [<ffffffff81234603>] ? ext4_expand_extra_isize_ea+0x63/0x850
[  755.743802]  [<ffffffff81234603>] ext4_expand_extra_isize_ea+0x63/0x850
[  755.743802]  [<ffffffff81795ec2>] ? _raw_read_unlock+0x22/0x30
[  755.743802]  [<ffffffff8123a542>] ? jbd2_journal_extend+0x132/0x1b0
[  755.743802]  [<ffffffff812002c9>] ext4_mark_inode_dirty+0x129/0x180
[  755.743802]  [<ffffffff81235d64>] ext4_add_dirent_to_inline.isra.16+0xe4/0x100
[  755.743802]  [<ffffffff81236fd9>] ext4_try_add_inline_entry+0x99/0x1a0
[  755.743802]  [<ffffffff8120b102>] ext4_add_entry+0x1d2/0x370
[  755.743802]  [<ffffffff8120b2b9>] ext4_add_nondir+0x19/0x70
[  755.743802]  [<ffffffff8120b523>] ext4_create+0xc3/0x150
[  755.743802]  [<ffffffff8118aaf8>] lookup_open+0x3d8/0x640
[  755.743802]  [<ffffffff8118b072>] path_openat+0x312/0x9f0
[  755.743802]  [<ffffffff8118d309>] do_filp_open+0x79/0xd0
[  755.743802]  [<ffffffff81795bc2>] ? _raw_spin_unlock+0x22/0x30
[  755.743802]  [<ffffffff8119d9b3>] ? __alloc_fd+0xf3/0x200
[  755.743802]  [<ffffffff8117b4fe>] do_sys_open+0x11e/0x1f0
[  755.743802]  [<ffffffff811d2046>] compat_SyS_open+0x16/0x20
[  755.743802]  [<ffffffff810027e4>] do_fast_syscall_32+0x94/0x210
[  755.743802]  [<ffffffff81797da1>] entry_SYSENTER_compat+0x51/0x60

Followed by repetitions of 
[ 1105.549736] INFO: task rsync:14818 blocked for more than 120 seconds.
[ 1105.550089]       Not tainted 4.9.1-00126-gfbb9fcc9-dirty #576
[ 1105.550436] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1105.550801] rsync           D    0 14818      1 0x20020004
[ 1105.551173]  ffff88040f7f1900 ffff88042d660000 0000000000000000 ffff8804082a2b00
[ 1105.551552]  ffff88042f216298 ffffc9000c273820 ffffffff8178fc08 0000000000000046
[ 1105.551933]  ffff8804082a3060 ffff88042f216298 ffff88042f216280 ffff8804082a2b00
[ 1105.552311] Call Trace:
[ 1105.552678]  [<ffffffff8178fc08>] ? __schedule+0x2b8/0x840
[ 1105.553051]  [<ffffffff817901c8>] schedule+0x38/0x90
[ 1105.553438]  [<ffffffff817945b5>] ? rwsem_down_write_failed+0x2a5/0x450
[ 1105.553810]  [<ffffffff817945ba>] rwsem_down_write_failed+0x2aa/0x450
[ 1105.554186]  [<ffffffff81794360>] ? rwsem_down_write_failed+0x50/0x450
[ 1105.554571]  [<ffffffff812b41d7>] call_rwsem_down_write_failed+0x17/0x30
[ 1105.554953]  [<ffffffff812a6d21>] ? dump_stack+0x84/0x93
[ 1105.555335]  [<ffffffff81793a5f>] down_write+0x5f/0x80
[ 1105.555720]  [<ffffffff81234603>] ? ext4_expand_extra_isize_ea+0x63/0x850
[ 1105.556111]  [<ffffffff81234603>] ext4_expand_extra_isize_ea+0x63/0x850
[ 1105.556502]  [<ffffffff81795ec2>] ? _raw_read_unlock+0x22/0x30
[ 1105.556900]  [<ffffffff8123a542>] ? jbd2_journal_extend+0x132/0x1b0
[ 1105.557282]  [<ffffffff812002c9>] ext4_mark_inode_dirty+0x129/0x180
[ 1105.557675]  [<ffffffff81235d64>] ext4_add_dirent_to_inline.isra.16+0xe4/0x100
[ 1105.558065]  [<ffffffff81236fd9>] ext4_try_add_inline_entry+0x99/0x1a0
[ 1105.558448]  [<ffffffff8120b102>] ext4_add_entry+0x1d2/0x370
[ 1105.558832]  [<ffffffff8120b2b9>] ext4_add_nondir+0x19/0x70
[ 1105.559208]  [<ffffffff8120b523>] ext4_create+0xc3/0x150
[ 1105.559575]  [<ffffffff8118aaf8>] lookup_open+0x3d8/0x640
[ 1105.559943]  [<ffffffff8118b072>] path_openat+0x312/0x9f0
[ 1105.560287]  [<ffffffff8118d309>] do_filp_open+0x79/0xd0
[ 1105.560637]  [<ffffffff81795bc2>] ? _raw_spin_unlock+0x22/0x30
[ 1105.560978]  [<ffffffff8119d9b3>] ? __alloc_fd+0xf3/0x200
[ 1105.561316]  [<ffffffff8117b4fe>] do_sys_open+0x11e/0x1f0
[ 1105.561652]  [<ffffffff811d2046>] compat_SyS_open+0x16/0x20
[ 1105.561984]  [<ffffffff810027e4>] do_fast_syscall_32+0x94/0x210
[ 1105.562313]  [<ffffffff81797da1>] entry_SYSENTER_compat+0x51/0x60
[ 1105.562639] INFO: lockdep is turned off.

Problem first observed with a 4.8 kernel, but the lockdep one is 4.9.
I have metadata checksums turned on, 

Filesystem features:      has_journal resize_inode dir_index sparse_super2 filetype needs_recovery extent flex_bg inline_data sparse_super large_file extra_isize metadata_csum
Journal features:         journal_incompat_revoke journal_checksum_v3
Inode size:               256
Required extra isize:     28
Desired extra isize:      28

It's awakward to reboot in the middle of sending e-mail, but when I do
I can strace the rsync and find the path it's trying to create, if that
is helpful to debugging.
