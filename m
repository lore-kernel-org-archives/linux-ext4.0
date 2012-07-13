From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 44731] New: ext4 deadlock under heavy io?
Date: Fri, 13 Jul 2012 12:23:13 +0000 (UTC)
Message-ID: <bug-44731-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:48770 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932526Ab2GMMXX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 13 Jul 2012 08:23:23 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id A84E4201AB
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jul 2012 12:23:19 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 91841201C5
	for <linux-ext4@vger.kernel.org>; Fri, 13 Jul 2012 12:23:13 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=44731

           Summary: ext4 deadlock under heavy io?
           Product: File System
           Version: 2.5
    Kernel Version: Linux 3.2.0-23-generic #36-Ubuntu SMP Tue Apr 10
                    20:39:51 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
          Platform: All
        OS/Version: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: ext4
        AssignedTo: fs_ext4@kernel-bugs.osdl.org
        ReportedBy: mirek@me.com
        Regression: No


I'm experiencing some problems with ext4 when doing intensive io (mainly
fallocating/writing/moving files) with up to 32 threads on 8 core xeon where
(rarely) everything hangs until killed after hung_task_timeout_sec (120).

Here are 3 kern logs but have more of them if needed.

kernlog1.txt:

[ 1198.383215] INFO: task jbd2/sdf1-8:694 blocked for more than 120 seconds.
[ 1198.383771] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 1198.384281] jbd2/sdf1-8     D ffffffff81806240     0   694      2 0x00000000
[ 1198.384287]  ffff880231c83ce0 0000000000000046 ffff880231c83c80
ffffffff811a86ce
[ 1198.384293]  ffff880231c83fd8 ffff880231c83fd8 ffff880231c83fd8
0000000000013780
[ 1198.384298]  ffffffff81c0d020 ffff88022dab44d0 ffff880231c83cf0
ffff880231c83df8
[ 1198.384303] Call Trace:
[ 1198.384313]  [<ffffffff811a86ce>] ? __wait_on_buffer+0x2e/0x30
[ 1198.384318]  [<ffffffff8165a55f>] schedule+0x3f/0x60
[ 1198.384325]  [<ffffffff8126052a>]
jbd2_journal_commit_transaction+0x18a/0x1240
[ 1198.384330]  [<ffffffff8165c6fe>] ? _raw_spin_lock_irqsave+0x2e/0x40
[ 1198.384336]  [<ffffffff81077198>] ? lock_timer_base.isra.29+0x38/0x70
[ 1198.384341]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[ 1198.384345]  [<ffffffff812652ab>] kjournald2+0xbb/0x220
[ 1198.384348]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[ 1198.384352]  [<ffffffff812651f0>] ? commit_timeout+0x10/0x10
[ 1198.384356]  [<ffffffff8108a42c>] kthread+0x8c/0xa0
[ 1198.384361]  [<ffffffff81666bf4>] kernel_thread_helper+0x4/0x10
[ 1198.384365]  [<ffffffff8108a3a0>] ? flush_kthread_worker+0xa0/0xa0
[ 1198.384369]  [<ffffffff81666bf0>] ? gs_change+0x13/0x13
[ 1198.384375] INFO: task pifs4/eio:3851 blocked for more than 120 seconds.
[ 1198.384734] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 1198.385358] pifs4/eio       D ffffffff81806240     0  3851      1 0x00000000
[ 1198.385362]  ffff88022fc61d08 0000000000000086 ffff88023fc93780
ffff88022de9ade0
[ 1198.385367]  ffff88022fc61fd8 ffff88022fc61fd8 ffff88022fc61fd8
0000000000013780
[ 1198.385372]  ffffffff81c0d020 ffff880231a15bc0 ffff88022fc61d18
ffff88022d842800
[ 1198.385377] Call Trace:
[ 1198.385380]  [<ffffffff8165a55f>] schedule+0x3f/0x60
[ 1198.385385]  [<ffffffff8125dcba>] start_this_handle.isra.9+0x2aa/0x3e0
[ 1198.385389]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[ 1198.385393]  [<ffffffff8125deba>] jbd2__journal_start+0xca/0x110
[ 1198.385398]  [<ffffffff8125df13>] jbd2_journal_start+0x13/0x20
[ 1198.385403]  [<ffffffff8123587f>] ext4_journal_start_sb+0x7f/0x1d0
[ 1198.385408]  [<ffffffff8122013c>] ? ext4_mkdir+0x11c/0x370
[ 1198.385413]  [<ffffffff81186eea>] ? kern_path_create+0x8a/0x120
[ 1198.385418]  [<ffffffff8122013c>] ext4_mkdir+0x11c/0x370
[ 1198.385421]  [<ffffffff81183c21>] vfs_mkdir+0xa1/0x110
[ 1198.385425]  [<ffffffff81187cf2>] sys_mkdirat+0xe2/0xf0
[ 1198.385429]  [<ffffffff81187d18>] sys_mkdir+0x18/0x20
[ 1198.385433]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
[ 1198.385436] INFO: task pifs4/eio:3879 blocked for more than 120 seconds.
[ 1198.385979] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 1198.386710] pifs4/eio       D ffffffff81806240     0  3879      1 0x00000000
[ 1198.386714]  ffff880231cf99c8 0000000000000086 ffff880231cf9998
ffffffff8109502d
[ 1198.386719]  ffff880231cf9fd8 ffff880231cf9fd8 ffff880231cf9fd8
0000000000013780
[ 1198.386732]  ffff8802321e16f0 ffff88022e0096f0 ffff880231cf99d8
ffff88022d842800
[ 1198.386737] Call Trace:
[ 1198.386740]  [<ffffffff8109502d>] ? ktime_get_ts+0xad/0xe0
[ 1198.386744]  [<ffffffff8165a55f>] schedule+0x3f/0x60
[ 1198.386747]  [<ffffffff8125dcba>] start_this_handle.isra.9+0x2aa/0x3e0
[ 1198.386760]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[ 1198.386764]  [<ffffffff8125deba>] jbd2__journal_start+0xca/0x110
[ 1198.386769]  [<ffffffff8125df13>] jbd2_journal_start+0x13/0x20
[ 1198.386772]  [<ffffffff8123587f>] ext4_journal_start_sb+0x7f/0x1d0
[ 1198.386777]  [<ffffffff8121b486>] ? ext4_dirty_inode+0x26/0x60
[ 1198.386780]  [<ffffffff81252110>] ? ext4_xattr_get+0x60/0xa0
[ 1198.386784]  [<ffffffff8121b486>] ext4_dirty_inode+0x26/0x60
[ 1198.386789]  [<ffffffff811a0610>] __mark_inode_dirty+0x40/0x2a0
[ 1198.386794]  [<ffffffff81191314>] file_update_time+0xe4/0x150
[ 1198.386800]  [<ffffffff81119148>] __generic_file_aio_write+0x1f8/0x440
[ 1198.386805]  [<ffffffff81119402>] generic_file_aio_write+0x72/0xe0
[ 1198.386809]  [<ffffffff81210b9f>] ext4_file_write+0xbf/0x260
[ 1198.386813]  [<ffffffff8109ec1f>] ? futex_wait+0x15f/0x210
[ 1198.386817]  [<ffffffff81177342>] do_sync_write+0xd2/0x110
[ 1198.386821]  [<ffffffff8109ee33>] ? futex_wake+0x113/0x130
[ 1198.386827]  [<ffffffff812d7448>] ? apparmor_file_permission+0x18/0x20
[ 1198.386831]  [<ffffffff8129cc9c>] ? security_file_permission+0x2c/0xb0
[ 1198.386835]  [<ffffffff811778d1>] ? rw_verify_area+0x61/0xf0
[ 1198.386838]  [<ffffffff81177c33>] vfs_write+0xb3/0x180
[ 1198.386841]  [<ffffffff81177f5a>] sys_write+0x4a/0x90
[ 1198.386845]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
[ 1198.386848] INFO: task pifs4/eio:3963 blocked for more than 120 seconds.
[ 1198.387720] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 1198.388422] pifs4/eio       D ffffffff81806240     0  3963      1 0x00000000
[ 1198.388425]  ffff8802303b3d08 0000000000000086 ffff8802322625d8
ffff8802322625c0
[ 1198.388429]  ffff8802303b3fd8 ffff8802303b3fd8 ffff8802303b3fd8
0000000000013780
[ 1198.388433]  ffff8802322196f0 ffff88022e098000 ffff8802303b3d18
ffff88022d842800
[ 1198.388437] Call Trace:
[ 1198.388440]  [<ffffffff8165a55f>] schedule+0x3f/0x60
[ 1198.388444]  [<ffffffff8125dcba>] start_this_handle.isra.9+0x2aa/0x3e0
[ 1198.388447]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[ 1198.388451]  [<ffffffff8125deba>] jbd2__journal_start+0xca/0x110
[ 1198.388455]  [<ffffffff8125df13>] jbd2_journal_start+0x13/0x20
[ 1198.388458]  [<ffffffff8123587f>] ext4_journal_start_sb+0x7f/0x1d0
[ 1198.388461]  [<ffffffff8122013c>] ? ext4_mkdir+0x11c/0x370
[ 1198.388464]  [<ffffffff81186eea>] ? kern_path_create+0x8a/0x120
[ 1198.388468]  [<ffffffff8122013c>] ext4_mkdir+0x11c/0x370
[ 1198.388471]  [<ffffffff81183c21>] vfs_mkdir+0xa1/0x110
[ 1198.388474]  [<ffffffff81187cf2>] sys_mkdirat+0xe2/0xf0
[ 1198.388477]  [<ffffffff81187d18>] sys_mkdir+0x18/0x20
[ 1198.388480]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
[ 1198.388483] INFO: task pifs4/eio:3965 blocked for more than 120 seconds.
[ 1198.389028] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 1198.389680] pifs4/eio       D ffffffff81806240     0  3965      1 0x00000000
[ 1198.389684]  ffff880230397d08 0000000000000086 ffff880230397d18
ffffffff81659f0c
[ 1198.389688]  ffff880230397fd8 ffff880230397fd8 ffff880230397fd8
0000000000013780
[ 1198.389693]  ffff8802321e16f0 ffff880230815bc0 ffff880230397d18
ffff88022d842800
[ 1198.389698] Call Trace:
[ 1198.389701]  [<ffffffff81659f0c>] ? __schedule+0x3cc/0x6f0
[ 1198.389705]  [<ffffffff8165a55f>] schedule+0x3f/0x60
[ 1198.389709]  [<ffffffff8125dcba>] start_this_handle.isra.9+0x2aa/0x3e0
[ 1198.389713]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[ 1198.389717]  [<ffffffff8125deba>] jbd2__journal_start+0xca/0x110
[ 1198.389722]  [<ffffffff8125df13>] jbd2_journal_start+0x13/0x20
[ 1198.389725]  [<ffffffff8123587f>] ext4_journal_start_sb+0x7f/0x1d0
[ 1198.389729]  [<ffffffff8122013c>] ? ext4_mkdir+0x11c/0x370
[ 1198.389733]  [<ffffffff81186eea>] ? kern_path_create+0x8a/0x120
[ 1198.389737]  [<ffffffff8122013c>] ext4_mkdir+0x11c/0x370
[ 1198.389741]  [<ffffffff81183c21>] vfs_mkdir+0xa1/0x110
[ 1198.389744]  [<ffffffff81187cf2>] sys_mkdirat+0xe2/0xf0
[ 1198.389748]  [<ffffffff81187d18>] sys_mkdir+0x18/0x20
[ 1198.389751]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
[ 1198.389755] INFO: task pifs4/eio:3969 blocked for more than 120 seconds.
[ 1198.390298] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 1198.390949] pifs4/eio       D ffffffff81806240     0  3969      1 0x00000000
[ 1198.390953]  ffff88023020faf8 0000000000000086 ffff88023020fab8
ffffffff811a9383
[ 1198.390958]  ffff88023020ffd8 ffff88023020ffd8 ffff88023020ffd8
0000000000013780
[ 1198.390963]  ffff8802321e16f0 ffff880231a116f0 ffff88023020fb08
ffff88022d842800
[ 1198.390968] Call Trace:
[ 1198.390971]  [<ffffffff811a9383>] ? __getblk+0x33/0x70
[ 1198.390974]  [<ffffffff8165a55f>] schedule+0x3f/0x60
[ 1198.390978]  [<ffffffff8125dcba>] start_this_handle.isra.9+0x2aa/0x3e0
[ 1198.390982]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[ 1198.390987]  [<ffffffff8125deba>] jbd2__journal_start+0xca/0x110
[ 1198.390991]  [<ffffffff8125df13>] jbd2_journal_start+0x13/0x20
[ 1198.390994]  [<ffffffff8123587f>] ext4_journal_start_sb+0x7f/0x1d0
[ 1198.390999]  [<ffffffff8121ff56>] ? ext4_create+0x76/0x140
[ 1198.391003]  [<ffffffff8121e8ab>] ? ext4_lookup.part.27+0x6b/0x120
[ 1198.391007]  [<ffffffff8121ff56>] ext4_create+0x76/0x140
[ 1198.391011]  [<ffffffff811843a4>] vfs_create+0xb4/0x120
[ 1198.391015]  [<ffffffff81185f79>] do_last+0x5c9/0x730
[ 1198.391018]  [<ffffffff81187481>] path_openat+0xd1/0x3f0
[ 1198.391022]  [<ffffffff811878c2>] do_filp_open+0x42/0xa0
[ 1198.391028]  [<ffffffff81318ce1>] ? strncpy_from_user+0x31/0x40
[ 1198.391032]  [<ffffffff81182c0a>] ? do_getname+0x10a/0x180
[ 1198.391035]  [<ffffffff8165c46e>] ? _raw_spin_lock+0xe/0x20
[ 1198.391039]  [<ffffffff81194b67>] ? alloc_fd+0xf7/0x150
[ 1198.391043]  [<ffffffff81176f6d>] do_sys_open+0xed/0x220
[ 1198.391046]  [<ffffffff811770e1>] sys_openat+0x11/0x20
[ 1198.391050]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
[ 1198.391053] INFO: task pifs4/eio:3970 blocked for more than 120 seconds.
[ 1198.391603] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 1198.392259] pifs4/eio       D ffffffff81806240     0  3970      1 0x00000000
[ 1198.392262]  ffff8802302e7d08 0000000000000086 ffff8802302e7d18
ffffffff81659f0c
[ 1198.392266]  ffff8802302e7fd8 ffff8802302e7fd8 ffff8802302e7fd8
0000000000013780
[ 1198.392271]  ffff8802321e16f0 ffff88022de9dbc0 ffff8802302e7d18
ffff88022d842800
[ 1198.392275] Call Trace:
[ 1198.392277]  [<ffffffff81659f0c>] ? __schedule+0x3cc/0x6f0
[ 1198.392280]  [<ffffffff8165a55f>] schedule+0x3f/0x60
[ 1198.392284]  [<ffffffff8125dcba>] start_this_handle.isra.9+0x2aa/0x3e0
[ 1198.392287]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[ 1198.392291]  [<ffffffff8125deba>] jbd2__journal_start+0xca/0x110
[ 1198.392295]  [<ffffffff8125df13>] jbd2_journal_start+0x13/0x20
[ 1198.392297]  [<ffffffff8123587f>] ext4_journal_start_sb+0x7f/0x1d0
[ 1198.392301]  [<ffffffff8122013c>] ? ext4_mkdir+0x11c/0x370
[ 1198.392304]  [<ffffffff81186eea>] ? kern_path_create+0x8a/0x120
[ 1198.392308]  [<ffffffff8122013c>] ext4_mkdir+0x11c/0x370
[ 1198.392311]  [<ffffffff81183c21>] vfs_mkdir+0xa1/0x110
[ 1198.392314]  [<ffffffff81187cf2>] sys_mkdirat+0xe2/0xf0
[ 1198.392317]  [<ffffffff81187d18>] sys_mkdir+0x18/0x20
[ 1198.392320]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
[ 1198.392322] INFO: task pifs4/eio:3973 blocked for more than 120 seconds.
[ 1198.392866] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 1198.393517] pifs4/eio       D ffffffff81806240     0  3973      1 0x00000000
[ 1198.393521]  ffff8801fdf0fd08 0000000000000086 ffff8801fdf0fd18
ffffffff81659f0c
[ 1198.393525]  ffff8801fdf0ffd8 ffff8801fdf0ffd8 ffff8801fdf0ffd8
0000000000013780
[ 1198.393530]  ffff8802321e16f0 ffff88022de9c4d0 ffff8801fdf0fd18
ffff88022d842800
[ 1198.393535] Call Trace:
[ 1198.393538]  [<ffffffff81659f0c>] ? __schedule+0x3cc/0x6f0
[ 1198.393541]  [<ffffffff8165a55f>] schedule+0x3f/0x60
[ 1198.393545]  [<ffffffff8125dcba>] start_this_handle.isra.9+0x2aa/0x3e0
[ 1198.393549]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[ 1198.393554]  [<ffffffff8125deba>] jbd2__journal_start+0xca/0x110
[ 1198.393558]  [<ffffffff8125df13>] jbd2_journal_start+0x13/0x20
[ 1198.393561]  [<ffffffff8123587f>] ext4_journal_start_sb+0x7f/0x1d0
[ 1198.393566]  [<ffffffff8122013c>] ? ext4_mkdir+0x11c/0x370
[ 1198.393569]  [<ffffffff81186eea>] ? kern_path_create+0x8a/0x120
[ 1198.393574]  [<ffffffff8122013c>] ext4_mkdir+0x11c/0x370
[ 1198.393577]  [<ffffffff81183c21>] vfs_mkdir+0xa1/0x110
[ 1198.393581]  [<ffffffff81187cf2>] sys_mkdirat+0xe2/0xf0
[ 1198.393584]  [<ffffffff81187d18>] sys_mkdir+0x18/0x20
[ 1198.393588]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
[ 1198.393591] INFO: task pifs4/eio:3974 blocked for more than 120 seconds.
[ 1198.394132] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 1198.394791] pifs4/eio       D ffffffff81806240     0  3974      1 0x00000000
[ 1198.394795]  ffff8801fdf2faa8 0000000000000086 ffff880100000000
ffff8801fdf2fb20
[ 1198.394799]  ffff8801fdf2ffd8 ffff8801fdf2ffd8 ffff8801fdf2ffd8
0000000000013780
[ 1198.394804]  ffff8802322596f0 ffff88022de996f0 ffff8801fdf2fab8
ffff88022d842800
[ 1198.394809] Call Trace:
[ 1198.394812]  [<ffffffff8165a55f>] schedule+0x3f/0x60
[ 1198.394816]  [<ffffffff8125dcba>] start_this_handle.isra.9+0x2aa/0x3e0
[ 1198.394820]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[ 1198.394825]  [<ffffffff8125deba>] jbd2__journal_start+0xca/0x110
[ 1198.394829]  [<ffffffff8125df13>] jbd2_journal_start+0x13/0x20
[ 1198.394832]  [<ffffffff8123587f>] ext4_journal_start_sb+0x7f/0x1d0
[ 1198.394837]  [<ffffffff81220c07>] ? ext4_rename+0x87/0x890
[ 1198.394841]  [<ffffffff81220c07>] ext4_rename+0x87/0x890
[ 1198.394845]  [<ffffffff8119535e>] ? vfsmount_lock_local_unlock+0x1e/0x30
[ 1198.394851]  [<ffffffff811656fd>] ? __kmalloc_track_caller+0x13d/0x190
[ 1198.394855]  [<ffffffff8118407e>] vfs_rename_other+0xde/0x130
[ 1198.394859]  [<ffffffff81184fbb>] vfs_rename+0xbb/0x240
[ 1198.394862]  [<ffffffff811832b1>] ? __lookup_hash.part.28+0x31/0xe0
[ 1198.394866]  [<ffffffff8118356a>] ? inode_permission+0x4a/0x110
[ 1198.394870]  [<ffffffff81188268>] sys_renameat+0x218/0x240
[ 1198.394873]  [<ffffffff8109e856>] ? get_futex_key+0x166/0x2d0
[ 1198.394877]  [<ffffffff8165c46e>] ? _raw_spin_lock+0xe/0x20
[ 1198.394880]  [<ffffffff8109ee33>] ? futex_wake+0x113/0x130
[ 1198.394885]  [<ffffffff811be216>] ? eventfd_write+0x1b6/0x220
[ 1198.394889]  [<ffffffff810a0b5a>] ? sys_futex+0x10a/0x1a0
[ 1198.394893]  [<ffffffff81177c90>] ? vfs_write+0x110/0x180
[ 1198.394896]  [<ffffffff81177f77>] ? sys_write+0x67/0x90
[ 1198.394900]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
[ 1198.394903] INFO: task pifs4/eio:3975 blocked for more than 120 seconds.
[ 1198.395450] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 1198.396107] pifs4/eio       D ffffffff81806240     0  3975      1 0x00000000
[ 1198.396110]  ffff8801fdf31d08 0000000000000086 0000000000000000
ffff8802304dc000
[ 1198.396114]  ffff8801fdf31fd8 ffff8801fdf31fd8 ffff8801fdf31fd8
0000000000013780
[ 1198.396119]  ffffffff81c0d020 ffff88022e00dbc0 ffffffff81c0d020
ffff88022dc1bac0
[ 1198.396122] Call Trace:
[ 1198.396125]  [<ffffffff8165a55f>] schedule+0x3f/0x60
[ 1198.396128]  [<ffffffff8165b367>] __mutex_lock_slowpath+0xd7/0x150
[ 1198.396131]  [<ffffffff8165af7a>] mutex_lock+0x2a/0x50
[ 1198.396134]  [<ffffffff811830dc>] lock_rename+0x3c/0xe0
[ 1198.396137]  [<ffffffff8118815d>] sys_renameat+0x10d/0x240
[ 1198.396140]  [<ffffffff8109e856>] ? get_futex_key+0x166/0x2d0
[ 1198.396144]  [<ffffffff8165c46e>] ? _raw_spin_lock+0xe/0x20
[ 1198.396147]  [<ffffffff8109ee33>] ? futex_wake+0x113/0x130
[ 1198.396150]  [<ffffffff811be216>] ? eventfd_write+0x1b6/0x220
[ 1198.396153]  [<ffffffff810a0b5a>] ? sys_futex+0x10a/0x1a0
[ 1198.396156]  [<ffffffff81177c90>] ? vfs_write+0x110/0x180
[ 1198.396159]  [<ffffffff81177f77>] ? sys_write+0x67/0x90
[ 1198.396162]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b

kernlog2.txt:

[ 4071.691405] INFO: task jbd2/sdc1-8:1802 blocked for more than 120 seconds.
[ 4071.694513] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 4071.698369] jbd2/sdc1-8     D ffffffff81806240     0  1802      2 0x00000000
[ 4071.698374]  ffff88010d963ce0 0000000000000046 ffff88023fd13780
000000000000023c
[ 4071.698378]  ffff88010d963fd8 ffff88010d963fd8 ffff88010d963fd8
0000000000013780
[ 4071.698381]  ffff8802321e16f0 ffff88021ac50000 ffff88010d963cf0
ffff88010d963df8
[ 4071.698384] Call Trace:
[ 4071.698390]  [<ffffffff8165a55f>] schedule+0x3f/0x60
[ 4071.698396]  [<ffffffff8126052a>]
jbd2_journal_commit_transaction+0x18a/0x1240
[ 4071.698402]  [<ffffffff8165c6fe>] ? _raw_spin_lock_irqsave+0x2e/0x40
[ 4071.698409]  [<ffffffff81077198>] ? lock_timer_base.isra.29+0x38/0x70
[ 4071.698413]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[ 4071.698418]  [<ffffffff812652ab>] kjournald2+0xbb/0x220
[ 4071.698422]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[ 4071.698426]  [<ffffffff812651f0>] ? commit_timeout+0x10/0x10
[ 4071.698430]  [<ffffffff8108a42c>] kthread+0x8c/0xa0
[ 4071.698435]  [<ffffffff81666bf4>] kernel_thread_helper+0x4/0x10
[ 4071.698449]  [<ffffffff8108a3a0>] ? flush_kthread_worker+0xa0/0xa0
[ 4071.698454]  [<ffffffff81666bf0>] ? gs_change+0x13/0x13
[ 4071.698457] INFO: task ext4lazyinit:1804 blocked for more than 120 seconds.
[ 4071.702716] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 4071.707530] ext4lazyinit    D ffffffff81806240     0  1804      2 0x00000000
[ 4071.707533]  ffff880230c87c30 0000000000000046 0000000000000000
0000000000000000
[ 4071.707536]  ffff880230c87fd8 ffff880230c87fd8 ffff880230c87fd8
0000000000013780
[ 4071.707540]  ffff8802321e16f0 ffff88021ac544d0 ffff880230c87c40
ffff880231d7b000
[ 4071.707543] Call Trace:
[ 4071.707545]  [<ffffffff8165a55f>] schedule+0x3f/0x60
[ 4071.707549]  [<ffffffff8125dcba>] start_this_handle.isra.9+0x2aa/0x3e0
[ 4071.707552]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[ 4071.707555]  [<ffffffff8125deba>] jbd2__journal_start+0xca/0x110
[ 4071.707558]  [<ffffffff8125df13>] jbd2_journal_start+0x13/0x20
[ 4071.707561]  [<ffffffff8123587f>] ext4_journal_start_sb+0x7f/0x1d0
[ 4071.707565]  [<ffffffff812135bb>] ? ext4_init_inode_table+0xab/0x370
[ 4071.707568]  [<ffffffff81077bd2>] ? try_to_del_timer_sync+0x92/0x130
[ 4071.707571]  [<ffffffff812135bb>] ext4_init_inode_table+0xab/0x370
[ 4071.707573]  [<ffffffff8165aa75>] ? schedule_timeout+0x175/0x320
[ 4071.707576]  [<ffffffff81226f65>] ext4_run_li_request+0x85/0xe0
[ 4071.707579]  [<ffffffff8122705c>] ext4_lazyinit_thread+0x9c/0x1c0
[ 4071.707581]  [<ffffffff81226fc0>] ? ext4_run_li_request+0xe0/0xe0
[ 4071.707584]  [<ffffffff8108a42c>] kthread+0x8c/0xa0
[ 4071.707586]  [<ffffffff81666bf4>] kernel_thread_helper+0x4/0x10
[ 4071.707589]  [<ffffffff8108a3a0>] ? flush_kthread_worker+0xa0/0xa0
[ 4071.707592]  [<ffffffff81666bf0>] ? gs_change+0x13/0x13
[ 4071.707594] INFO: task pifs4/eio:7152 blocked for more than 120 seconds.
[ 4071.713389] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 4071.719407] pifs4/eio       D ffffffff81806240     0  7152      1 0x00000000
[ 4071.719410]  ffff88022d0559c8 0000000000000082 ffff88022d055968
ffffffff81119f55
[ 4071.719414]  ffff88022d055fd8 ffff88022d055fd8 ffff88022d055fd8
0000000000013780
[ 4071.719417]  ffffffff81c0d020 ffff88022e12ade0 ffff88022d0559d8
ffff880231d7b000
[ 4071.719420] Call Trace:
[ 4071.719424]  [<ffffffff81119f55>] ? mempool_alloc_slab+0x15/0x20
[ 4071.719427]  [<ffffffff8165a55f>] schedule+0x3f/0x60
[ 4071.719431]  [<ffffffff8125dcba>] start_this_handle.isra.9+0x2aa/0x3e0
[ 4071.719435]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[ 4071.719440]  [<ffffffff8125deba>] jbd2__journal_start+0xca/0x110
[ 4071.719444]  [<ffffffff8125df13>] jbd2_journal_start+0x13/0x20
[ 4071.719448]  [<ffffffff8123587f>] ext4_journal_start_sb+0x7f/0x1d0
[ 4071.719453]  [<ffffffff8121b486>] ? ext4_dirty_inode+0x26/0x60
[ 4071.719459]  [<ffffffff8141fea0>] ? scsi_finish_command+0x120/0x120
[ 4071.719465]  [<ffffffff810567fe>] ? update_curr+0x21e/0x230
[ 4071.719469]  [<ffffffff8121b486>] ext4_dirty_inode+0x26/0x60
[ 4071.719474]  [<ffffffff811a0610>] __mark_inode_dirty+0x40/0x2a0
[ 4071.719480]  [<ffffffff81191314>] file_update_time+0xe4/0x150
[ 4071.719485]  [<ffffffff81119148>] __generic_file_aio_write+0x1f8/0x440
[ 4071.719490]  [<ffffffff8101ae59>] ? sched_clock+0x9/0x10
[ 4071.719495]  [<ffffffff81119402>] generic_file_aio_write+0x72/0xe0
[ 4071.719499]  [<ffffffff81210b9f>] ext4_file_write+0xbf/0x260
[ 4071.719504]  [<ffffffff8104c1b8>] ? __wake_up_common+0x58/0x90
[ 4071.719508]  [<ffffffff81177342>] do_sync_write+0xd2/0x110
[ 4071.719513]  [<ffffffff8104c228>] ? __wake_up_locked_key+0x18/0x20
[ 4071.719519]  [<ffffffff812d7448>] ? apparmor_file_permission+0x18/0x20
[ 4071.719524]  [<ffffffff8129cc9c>] ? security_file_permission+0x2c/0xb0
[ 4071.719528]  [<ffffffff811778d1>] ? rw_verify_area+0x61/0xf0
[ 4071.719531]  [<ffffffff81177c33>] vfs_write+0xb3/0x180
[ 4071.719535]  [<ffffffff81177f5a>] sys_write+0x4a/0x90
[ 4071.719540]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
[ 4071.719543] INFO: task pifs4/eio:7153 blocked for more than 120 seconds.
[ 4071.725869] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 4071.733410] pifs4/eio       D ffffffff81806240     0  7153      1 0x00000000
[ 4071.733413]  ffff880231b3fc58 0000000000000082 ffff88022d01301d
ffff880231b3fd40
[ 4071.733416]  ffff880231b3ffd8 ffff880231b3ffd8 ffff880231b3ffd8
0000000000013780
[ 4071.733419]  ffff8802322196f0 ffff88022f5896f0 ffff880231b3fc68
ffff880231d7b000
[ 4071.733423] Call Trace:
[ 4071.733425]  [<ffffffff8165a55f>] schedule+0x3f/0x60
[ 4071.733428]  [<ffffffff8125dcba>] start_this_handle.isra.9+0x2aa/0x3e0
[ 4071.733431]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[ 4071.733434]  [<ffffffff8125deba>] jbd2__journal_start+0xca/0x110
[ 4071.733437]  [<ffffffff8125df13>] jbd2_journal_start+0x13/0x20
[ 4071.733441]  [<ffffffff8123587f>] ext4_journal_start_sb+0x7f/0x1d0
[ 4071.733446]  [<ffffffff81221479>] ? ext4_rmdir+0x69/0x250
[ 4071.733451]  [<ffffffff811865fd>] ? path_lookupat+0x6d/0x750
[ 4071.733455]  [<ffffffff8165c46e>] ? _raw_spin_lock+0xe/0x20
[ 4071.733460]  [<ffffffff81221479>] ext4_rmdir+0x69/0x250
[ 4071.733464]  [<ffffffff81184c87>] vfs_rmdir.part.27+0xb7/0x110
[ 4071.733468]  [<ffffffff81184d1f>] vfs_rmdir+0x3f/0x60
[ 4071.733472]  [<ffffffff8118736a>] do_rmdir+0x12a/0x130
[ 4071.733476]  [<ffffffff81177c90>] ? vfs_write+0x110/0x180
[ 4071.733480]  [<ffffffff81187d36>] sys_rmdir+0x16/0x20
[ 4071.733484]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
[ 4071.733488] INFO: task pifs4/eio:7170 blocked for more than 120 seconds.
[ 4071.741067] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 4071.749709] pifs4/eio       D ffffffff81806240     0  7170      1 0x00000000
[ 4071.749711]  ffff88010d8539c8 0000000000000082 ffff88010d853968
ffffffff81119f55
[ 4071.749715]  ffff88010d853fd8 ffff88010d853fd8 ffff88010d853fd8
0000000000013780
[ 4071.749718]  ffff8802322196f0 ffff88022e1296f0 ffff88010d8539d8
ffff880231d7b000
[ 4071.749721] Call Trace:
[ 4071.749724]  [<ffffffff81119f55>] ? mempool_alloc_slab+0x15/0x20
[ 4071.749727]  [<ffffffff8165a55f>] schedule+0x3f/0x60
[ 4071.749730]  [<ffffffff8125dcba>] start_this_handle.isra.9+0x2aa/0x3e0
[ 4071.749735]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[ 4071.749739]  [<ffffffff8125deba>] jbd2__journal_start+0xca/0x110
[ 4071.749744]  [<ffffffff8125df13>] jbd2_journal_start+0x13/0x20
[ 4071.749748]  [<ffffffff8123587f>] ext4_journal_start_sb+0x7f/0x1d0
[ 4071.749752]  [<ffffffff8121b486>] ? ext4_dirty_inode+0x26/0x60
[ 4071.749757]  [<ffffffff8121b486>] ext4_dirty_inode+0x26/0x60
[ 4071.749761]  [<ffffffff811a0610>] __mark_inode_dirty+0x40/0x2a0
[ 4071.749766]  [<ffffffff81191314>] file_update_time+0xe4/0x150
[ 4071.749771]  [<ffffffff81119148>] __generic_file_aio_write+0x1f8/0x440
[ 4071.749775]  [<ffffffff8165c46e>] ? _raw_spin_lock+0xe/0x20
[ 4071.749779]  [<ffffffff81119402>] generic_file_aio_write+0x72/0xe0
[ 4071.749783]  [<ffffffff81210b9f>] ext4_file_write+0xbf/0x260
[ 4071.749788]  [<ffffffff8109ec1f>] ? futex_wait+0x15f/0x210
[ 4071.749792]  [<ffffffff81177342>] do_sync_write+0xd2/0x110
[ 4071.749796]  [<ffffffff8109ee33>] ? futex_wake+0x113/0x130
[ 4071.749801]  [<ffffffff812d7448>] ? apparmor_file_permission+0x18/0x20
[ 4071.749805]  [<ffffffff8129cc9c>] ? security_file_permission+0x2c/0xb0
[ 4071.749809]  [<ffffffff811778d1>] ? rw_verify_area+0x61/0xf0
[ 4071.749813]  [<ffffffff81177c33>] vfs_write+0xb3/0x180
[ 4071.749817]  [<ffffffff81177f5a>] sys_write+0x4a/0x90
[ 4071.749821]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
[ 4071.749824] INFO: task pifs4/eio:7171 blocked for more than 120 seconds.
[ 4071.758803] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 4071.767997] pifs4/eio       D ffffffff81806240     0  7171      1 0x00000000
[ 4071.768000]  ffff88010d8b79c8 0000000000000082 ffff88010d8b7968
ffffffff81119f55
[ 4071.768004]  ffff88010d8b7fd8 ffff88010d8b7fd8 ffff88010d8b7fd8
0000000000013780
[ 4071.768007]  ffff8802322316f0 ffff88022da78000 ffff88010d8b79d8
ffff880231d7b000
[ 4071.768010] Call Trace:
[ 4071.768013]  [<ffffffff81119f55>] ? mempool_alloc_slab+0x15/0x20
[ 4071.768017]  [<ffffffff8165a55f>] schedule+0x3f/0x60
[ 4071.768022]  [<ffffffff8125dcba>] start_this_handle.isra.9+0x2aa/0x3e0
[ 4071.768026]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[ 4071.768031]  [<ffffffff8125deba>] jbd2__journal_start+0xca/0x110
[ 4071.768036]  [<ffffffff8125df13>] jbd2_journal_start+0x13/0x20
[ 4071.768040]  [<ffffffff8123587f>] ext4_journal_start_sb+0x7f/0x1d0
[ 4071.768044]  [<ffffffff8121b486>] ? ext4_dirty_inode+0x26/0x60
[ 4071.768057]  [<ffffffff8121b486>] ext4_dirty_inode+0x26/0x60
[ 4071.768061]  [<ffffffff811a0610>] __mark_inode_dirty+0x40/0x2a0
[ 4071.768065]  [<ffffffff81191314>] file_update_time+0xe4/0x150
[ 4071.768069]  [<ffffffff81119148>] __generic_file_aio_write+0x1f8/0x440
[ 4071.768073]  [<ffffffff8165c46e>] ? _raw_spin_lock+0xe/0x20
[ 4071.768077]  [<ffffffff81119402>] generic_file_aio_write+0x72/0xe0
[ 4071.768081]  [<ffffffff81210b9f>] ext4_file_write+0xbf/0x260
[ 4071.768084]  [<ffffffff8109ec1f>] ? futex_wait+0x15f/0x210
[ 4071.768088]  [<ffffffff81177342>] do_sync_write+0xd2/0x110
[ 4071.768092]  [<ffffffff8109ee33>] ? futex_wake+0x113/0x130
[ 4071.768096]  [<ffffffff812d7448>] ? apparmor_file_permission+0x18/0x20
[ 4071.768099]  [<ffffffff8129cc9c>] ? security_file_permission+0x2c/0xb0
[ 4071.768103]  [<ffffffff811778d1>] ? rw_verify_area+0x61/0xf0
[ 4071.768106]  [<ffffffff81177c33>] vfs_write+0xb3/0x180
[ 4071.768110]  [<ffffffff81177f5a>] sys_write+0x4a/0x90
[ 4071.768113]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
[ 4071.768116] INFO: task pifs4/eio:7172 blocked for more than 120 seconds.
[ 4071.778160] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 4071.788666] pifs4/eio       D ffffffff81806240     0  7172      1 0x00000000
[ 4071.788669]  ffff880105265a98 0000000000000082 ffff880105265a98
ffff8802307f3090
[ 4071.788672]  ffff880105265fd8 ffff880105265fd8 ffff880105265fd8
0000000000013780
[ 4071.788676]  ffff8802322196f0 ffff88022e3a16f0 ffff880105265aa8
ffff880231d7b000
[ 4071.788679] Call Trace:
[ 4071.788681]  [<ffffffff8165a55f>] schedule+0x3f/0x60
[ 4071.788684]  [<ffffffff8125dcba>] start_this_handle.isra.9+0x2aa/0x3e0
[ 4071.788687]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[ 4071.788692]  [<ffffffff8125deba>] jbd2__journal_start+0xca/0x110
[ 4071.788696]  [<ffffffff8125df13>] jbd2_journal_start+0x13/0x20
[ 4071.788701]  [<ffffffff8123587f>] ext4_journal_start_sb+0x7f/0x1d0
[ 4071.788705]  [<ffffffff81220c07>] ? ext4_rename+0x87/0x890
[ 4071.788710]  [<ffffffff81220c07>] ext4_rename+0x87/0x890
[ 4071.788715]  [<ffffffff81012728>] ? __switch_to+0x138/0x360
[ 4071.788719]  [<ffffffff8119535e>] ? vfsmount_lock_local_unlock+0x1e/0x30
[ 4071.788726]  [<ffffffff811656fd>] ? __kmalloc_track_caller+0x13d/0x190
[ 4071.788730]  [<ffffffff8118407e>] vfs_rename_other+0xde/0x130
[ 4071.788741]  [<ffffffff81184fbb>] vfs_rename+0xbb/0x240
[ 4071.788743]  [<ffffffff811832b1>] ? __lookup_hash.part.28+0x31/0xe0
[ 4071.788746]  [<ffffffff8118356a>] ? inode_permission+0x4a/0x110
[ 4071.788749]  [<ffffffff81188268>] sys_renameat+0x218/0x240
[ 4071.788752]  [<ffffffff8165c46e>] ? _raw_spin_lock+0xe/0x20
[ 4071.788755]  [<ffffffff8109ee33>] ? futex_wake+0x113/0x130
[ 4071.788758]  [<ffffffff810a0978>] ? do_futex+0xd8/0x1b0
[ 4071.788761]  [<ffffffff812110fb>] ? ext4_sync_file+0x14b/0x2d0
[ 4071.788764]  [<ffffffff810a0b5a>] ? sys_futex+0x10a/0x1a0
[ 4071.788766]  [<ffffffff81177c90>] ? vfs_write+0x110/0x180
[ 4071.788769]  [<ffffffff811882ab>] sys_rename+0x1b/0x20
[ 4071.788772]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
[ 4071.788774] INFO: task pifs4/eio:7177 blocked for more than 120 seconds.
[ 4071.800218] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 4071.811537] pifs4/eio       D ffffffff81806240     0  7177      1 0x00000000
[ 4071.811540]  ffff88011101fc58 0000000000000082 ffff88007f8d001d
ffff88011101fd40
[ 4071.811543]  ffff88011101ffd8 ffff88011101ffd8 ffff88011101ffd8
0000000000013780
[ 4071.811546]  ffff8802322916f0 ffff88022e085bc0 ffff88011101fc68
ffff880231d7b000
[ 4071.811549] Call Trace:
[ 4071.811552]  [<ffffffff8165a55f>] schedule+0x3f/0x60
[ 4071.811555]  [<ffffffff8125dcba>] start_this_handle.isra.9+0x2aa/0x3e0
[ 4071.811558]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[ 4071.811561]  [<ffffffff8125deba>] jbd2__journal_start+0xca/0x110
[ 4071.811564]  [<ffffffff8125df13>] jbd2_journal_start+0x13/0x20
[ 4071.811566]  [<ffffffff8123587f>] ext4_journal_start_sb+0x7f/0x1d0
[ 4071.811571]  [<ffffffff81221479>] ? ext4_rmdir+0x69/0x250
[ 4071.811575]  [<ffffffff811865fd>] ? path_lookupat+0x6d/0x750
[ 4071.811579]  [<ffffffff8165c46e>] ? _raw_spin_lock+0xe/0x20
[ 4071.811583]  [<ffffffff81221479>] ext4_rmdir+0x69/0x250
[ 4071.811595]  [<ffffffff81184c87>] vfs_rmdir.part.27+0xb7/0x110
[ 4071.811599]  [<ffffffff81184d1f>] vfs_rmdir+0x3f/0x60
[ 4071.811602]  [<ffffffff8118736a>] do_rmdir+0x12a/0x130
[ 4071.811606]  [<ffffffff81177c90>] ? vfs_write+0x110/0x180
[ 4071.811610]  [<ffffffff81187d36>] sys_rmdir+0x16/0x20
[ 4071.811613]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
[ 4071.811616] INFO: task pifs4/eio:7178 blocked for more than 120 seconds.
[ 4071.823305] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 4071.835634] pifs4/eio       D ffffffff81806240     0  7178      1 0x00000000
[ 4071.835636]  ffff8801052cdc78 0000000000000082 ffff8802271fc200
ffff8801052cde38
[ 4071.835640]  ffff8801052cdfd8 ffff8801052cdfd8 ffff8801052cdfd8
0000000000013780
[ 4071.835643]  ffff8802321e16f0 ffff88022e3a44d0 0000000000000081
ffff8801374f3850
[ 4071.835646] Call Trace:
[ 4071.835649]  [<ffffffff8165a55f>] schedule+0x3f/0x60
[ 4071.835651]  [<ffffffff8165b367>] __mutex_lock_slowpath+0xd7/0x150
[ 4071.835654]  [<ffffffff8165af7a>] mutex_lock+0x2a/0x50
[ 4071.835656]  [<ffffffff81185c64>] do_last+0x2b4/0x730
[ 4071.835659]  [<ffffffff81187481>] path_openat+0xd1/0x3f0
[ 4071.835662]  [<ffffffff811878c2>] do_filp_open+0x42/0xa0
[ 4071.835668]  [<ffffffff81318ce1>] ? strncpy_from_user+0x31/0x40
[ 4071.835672]  [<ffffffff81182c0a>] ? do_getname+0x10a/0x180
[ 4071.835676]  [<ffffffff8165c46e>] ? _raw_spin_lock+0xe/0x20
[ 4071.835680]  [<ffffffff81194b67>] ? alloc_fd+0xf7/0x150
[ 4071.835692]  [<ffffffff81176f6d>] do_sys_open+0xed/0x220
[ 4071.835695]  [<ffffffff811770e1>] sys_openat+0x11/0x20
[ 4071.835699]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
[ 4071.835702] INFO: task pifs4/eio:7179 blocked for more than 120 seconds.
[ 4071.849628] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 4071.863253] pifs4/eio       D ffffffff81806240     0  7179      1 0x00000000
[ 4071.863256]  ffff88010522dc78 0000000000000082 ffff8802271fc200
ffff88010522de38
[ 4071.863259]  ffff88010522dfd8 ffff88010522dfd8 ffff88010522dfd8
0000000000013780
[ 4071.863262]  ffff8802322596f0 ffff88022e3a0000 0000000000000081
ffff8801374f3850
[ 4071.863266] Call Trace:
[ 4071.863269]  [<ffffffff8165a55f>] schedule+0x3f/0x60
[ 4071.863273]  [<ffffffff8165b367>] __mutex_lock_slowpath+0xd7/0x150
[ 4071.863277]  [<ffffffff8165af7a>] mutex_lock+0x2a/0x50
[ 4071.863281]  [<ffffffff81185c64>] do_last+0x2b4/0x730
[ 4071.863285]  [<ffffffff81187481>] path_openat+0xd1/0x3f0
[ 4071.863289]  [<ffffffff811878c2>] do_filp_open+0x42/0xa0
[ 4071.863294]  [<ffffffff81318ce1>] ? strncpy_from_user+0x31/0x40
[ 4071.863298]  [<ffffffff81182c0a>] ? do_getname+0x10a/0x180
[ 4071.863302]  [<ffffffff8165c46e>] ? _raw_spin_lock+0xe/0x20
[ 4071.863314]  [<ffffffff81194b67>] ? alloc_fd+0xf7/0x150
[ 4071.863317]  [<ffffffff81176f6d>] do_sys_open+0xed/0x220
[ 4071.863321]  [<ffffffff811770e1>] sys_openat+0x11/0x20
[ 4071.863324]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b

kernlog3.txt:

[  360.312602] INFO: task jbd2/sdc1-8:660 blocked for more than 120 seconds.
[  360.313022] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  360.313474] jbd2/sdc1-8     D ffffffff81806240     0   660      2 0x00000000
[  360.313480]  ffff880231701ce0 0000000000000046 ffff880231701c80
ffffffff811a86ce
[  360.313486]  ffff880231701fd8 ffff880231701fd8 ffff880231701fd8
0000000000013780
[  360.313491]  ffffffff81c0d020 ffff880231715bc0 ffff880231701cf0
ffff880231701df8
[  360.313497] Call Trace:
[  360.313507]  [<ffffffff811a86ce>] ? __wait_on_buffer+0x2e/0x30
[  360.313512]  [<ffffffff8165a55f>] schedule+0x3f/0x60
[  360.313518]  [<ffffffff8126052a>]
jbd2_journal_commit_transaction+0x18a/0x1240
[  360.313524]  [<ffffffff8165c6fe>] ? _raw_spin_lock_irqsave+0x2e/0x40
[  360.313529]  [<ffffffff81077198>] ? lock_timer_base.isra.29+0x38/0x70
[  360.313534]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[  360.313538]  [<ffffffff812652ab>] kjournald2+0xbb/0x220
[  360.313542]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[  360.313546]  [<ffffffff812651f0>] ? commit_timeout+0x10/0x10
[  360.313550]  [<ffffffff8108a42c>] kthread+0x8c/0xa0
[  360.313555]  [<ffffffff81666bf4>] kernel_thread_helper+0x4/0x10
[  360.313559]  [<ffffffff8108a3a0>] ? flush_kthread_worker+0xa0/0xa0
[  360.313563]  [<ffffffff81666bf0>] ? gs_change+0x13/0x13
[  360.313570] INFO: task pifs4/eio:1125 blocked for more than 120 seconds.
[  360.313947] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  360.314395] pifs4/eio       D ffffffff81806240     0  1125   1042 0x00000000
[  360.314400]  ffff8802323db9c8 0000000000000086 ffff88022da90000
ffff8802323db988
[  360.314405]  ffff8802323dbfd8 ffff8802323dbfd8 ffff8802323dbfd8
0000000000013780
[  360.314410]  ffff8802322196f0 ffff88022da90000 ffff8802323db9d8
ffff88022db8a000
[  360.314414] Call Trace:
[  360.314418]  [<ffffffff8165a55f>] schedule+0x3f/0x60
[  360.314422]  [<ffffffff8125dcba>] start_this_handle.isra.9+0x2aa/0x3e0
[  360.314426]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[  360.314431]  [<ffffffff8125deba>] jbd2__journal_start+0xca/0x110
[  360.314435]  [<ffffffff8125df13>] jbd2_journal_start+0x13/0x20
[  360.314440]  [<ffffffff8123587f>] ext4_journal_start_sb+0x7f/0x1d0
[  360.314446]  [<ffffffff8121b486>] ? ext4_dirty_inode+0x26/0x60
[  360.314449]  [<ffffffff81252110>] ? ext4_xattr_get+0x60/0xa0
[  360.314453]  [<ffffffff8121b486>] ext4_dirty_inode+0x26/0x60
[  360.314458]  [<ffffffff811a0610>] __mark_inode_dirty+0x40/0x2a0
[  360.314463]  [<ffffffff81191314>] file_update_time+0xe4/0x150
[  360.314469]  [<ffffffff81119148>] __generic_file_aio_write+0x1f8/0x440
[  360.314474]  [<ffffffff81119402>] generic_file_aio_write+0x72/0xe0
[  360.314478]  [<ffffffff81210b9f>] ext4_file_write+0xbf/0x260
[  360.314483]  [<ffffffff8109ec1f>] ? futex_wait+0x15f/0x210
[  360.314487]  [<ffffffff81177342>] do_sync_write+0xd2/0x110
[  360.314491]  [<ffffffff8109ee33>] ? futex_wake+0x113/0x130
[  360.314497]  [<ffffffff812d7448>] ? apparmor_file_permission+0x18/0x20
[  360.314501]  [<ffffffff8129cc9c>] ? security_file_permission+0x2c/0xb0
[  360.314505]  [<ffffffff811778d1>] ? rw_verify_area+0x61/0xf0
[  360.314508]  [<ffffffff81177c33>] vfs_write+0xb3/0x180
[  360.314511]  [<ffffffff81177f5a>] sys_write+0x4a/0x90
[  360.314516]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
[  480.035798] INFO: task jbd2/sdc1-8:660 blocked for more than 120 seconds.
[  480.036211] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  480.036692] jbd2/sdc1-8     D ffffffff81806240     0   660      2 0x00000000
[  480.036698]  ffff880231701ce0 0000000000000046 ffff880231701c80
ffffffff811a86ce
[  480.036712]  ffff880231701fd8 ffff880231701fd8 ffff880231701fd8
0000000000013780
[  480.036716]  ffffffff81c0d020 ffff880231715bc0 ffff880231701cf0
ffff880231701df8
[  480.036721] Call Trace:
[  480.036740]  [<ffffffff811a86ce>] ? __wait_on_buffer+0x2e/0x30
[  480.036745]  [<ffffffff8165a55f>] schedule+0x3f/0x60
[  480.036751]  [<ffffffff8126052a>]
jbd2_journal_commit_transaction+0x18a/0x1240
[  480.036757]  [<ffffffff8165c6fe>] ? _raw_spin_lock_irqsave+0x2e/0x40
[  480.036762]  [<ffffffff81077198>] ? lock_timer_base.isra.29+0x38/0x70
[  480.036767]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[  480.036771]  [<ffffffff812652ab>] kjournald2+0xbb/0x220
[  480.036775]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[  480.036778]  [<ffffffff812651f0>] ? commit_timeout+0x10/0x10
[  480.036782]  [<ffffffff8108a42c>] kthread+0x8c/0xa0
[  480.036787]  [<ffffffff81666bf4>] kernel_thread_helper+0x4/0x10
[  480.036791]  [<ffffffff8108a3a0>] ? flush_kthread_worker+0xa0/0xa0
[  480.036795]  [<ffffffff81666bf0>] ? gs_change+0x13/0x13
[  480.036798] INFO: task jbd2/sdd1-8:666 blocked for more than 120 seconds.
[  480.037207] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  480.037685] jbd2/sdd1-8     D ffffffff81806240     0   666      2 0x00000000
[  480.037689]  ffff8802317f3ce0 0000000000000046 ffff8802317f3c90
0000000300000001
[  480.037695]  ffff8802317f3fd8 ffff8802317f3fd8 ffff8802317f3fd8
0000000000013780
[  480.037699]  ffffffff81c0d020 ffff8802317116f0 ffff8802317f3cf0
ffff8802317f3df8
[  480.037704] Call Trace:
[  480.037707]  [<ffffffff8165a55f>] schedule+0x3f/0x60
[  480.037712]  [<ffffffff8126052a>]
jbd2_journal_commit_transaction+0x18a/0x1240
[  480.037717]  [<ffffffff8165c6fe>] ? _raw_spin_lock_irqsave+0x2e/0x40
[  480.037721]  [<ffffffff81077198>] ? lock_timer_base.isra.29+0x38/0x70
[  480.037725]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[  480.037729]  [<ffffffff812652ab>] kjournald2+0xbb/0x220
[  480.037732]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[  480.037736]  [<ffffffff812651f0>] ? commit_timeout+0x10/0x10
[  480.037739]  [<ffffffff8108a42c>] kthread+0x8c/0xa0
[  480.037744]  [<ffffffff81666bf4>] kernel_thread_helper+0x4/0x10
[  480.037747]  [<ffffffff8108a3a0>] ? flush_kthread_worker+0xa0/0xa0
[  480.037751]  [<ffffffff81666bf0>] ? gs_change+0x13/0x13
[  480.037765] INFO: task flush-8:48:846 blocked for more than 120 seconds.
[  480.038183] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  480.038655] flush-8:48      D ffffffff81806240     0   846      2 0x00000000
[  480.038658]  ffff880230459880 0000000000000046 ffff880230459840
ffff880200000002
[  480.038663]  ffff880230459fd8 ffff880230459fd8 ffff880230459fd8
0000000000013780
[  480.038676]  ffff8802322196f0 ffff88023041dbc0 ffff880230459890
ffff88022db89800
[  480.038681] Call Trace:
[  480.038684]  [<ffffffff8165a55f>] schedule+0x3f/0x60
[  480.038689]  [<ffffffff8125dcba>] start_this_handle.isra.9+0x2aa/0x3e0
[  480.038692]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[  480.038697]  [<ffffffff8125deba>] jbd2__journal_start+0xca/0x110
[  480.038701]  [<ffffffff8125df13>] jbd2_journal_start+0x13/0x20
[  480.038706]  [<ffffffff8123587f>] ext4_journal_start_sb+0x7f/0x1d0
[  480.038711]  [<ffffffff8121acba>] ? ext4_da_writepages+0x32a/0x640
[  480.038716]  [<ffffffff81213ed5>] ? ext4_meta_trans_blocks+0xa5/0xb0
[  480.038720]  [<ffffffff8121acba>] ext4_da_writepages+0x32a/0x640
[  480.038726]  [<ffffffff812f3208>] ? blk_finish_plug+0x18/0x50
[  480.038732]  [<ffffffff8130b006>] ? cpumask_next_and+0x36/0x50
[  480.038737]  [<ffffffff8105a471>] ? find_busiest_group+0x171/0xbb0
[  480.038742]  [<ffffffff81122a01>] do_writepages+0x21/0x40
[  480.038746]  [<ffffffff811a0ed0>] writeback_single_inode+0x180/0x430
[  480.038751]  [<ffffffff811a1596>] writeback_sb_inodes+0x1b6/0x270
[  480.038755]  [<ffffffff811a16ee>] __writeback_inodes_wb+0x9e/0xd0
[  480.038759]  [<ffffffff811a199b>] wb_writeback+0x27b/0x330
[  480.038764]  [<ffffffff810126e5>] ? __switch_to+0xf5/0x360
[  480.038768]  [<ffffffff81193082>] ? get_nr_dirty_inodes+0x52/0x80
[  480.038772]  [<ffffffff811a1aef>] wb_check_old_data_flush+0x9f/0xb0
[  480.038776]  [<ffffffff811a29e1>] wb_do_writeback+0x151/0x1d0
[  480.038781]  [<ffffffff81076af0>] ? usleep_range+0x50/0x50
[  480.038785]  [<ffffffff811a2ae3>] bdi_writeback_thread+0x83/0x2a0
[  480.038789]  [<ffffffff811a2a60>] ? wb_do_writeback+0x1d0/0x1d0
[  480.038793]  [<ffffffff8108a42c>] kthread+0x8c/0xa0
[  480.038797]  [<ffffffff81666bf4>] kernel_thread_helper+0x4/0x10
[  480.038801]  [<ffffffff8108a3a0>] ? flush_kthread_worker+0xa0/0xa0
[  480.038805]  [<ffffffff81666bf0>] ? gs_change+0x13/0x13
[  480.038809] INFO: task pifs4/eio:1125 blocked for more than 120 seconds.
[  480.039178] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  480.039617] pifs4/eio       D ffffffff81806240     0  1125   1042 0x00000000
[  480.039622]  ffff8802323db9c8 0000000000000086 ffff88022da90000
ffff8802323db988
[  480.039626]  ffff8802323dbfd8 ffff8802323dbfd8 ffff8802323dbfd8
0000000000013780
[  480.039631]  ffff8802322196f0 ffff88022da90000 ffff8802323db9d8
ffff88022db8a000
[  480.039636] Call Trace:
[  480.039639]  [<ffffffff8165a55f>] schedule+0x3f/0x60
[  480.039644]  [<ffffffff8125dcba>] start_this_handle.isra.9+0x2aa/0x3e0
[  480.039648]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[  480.039652]  [<ffffffff8125deba>] jbd2__journal_start+0xca/0x110
[  480.039656]  [<ffffffff8125df13>] jbd2_journal_start+0x13/0x20
[  480.039660]  [<ffffffff8123587f>] ext4_journal_start_sb+0x7f/0x1d0
[  480.039664]  [<ffffffff8121b486>] ? ext4_dirty_inode+0x26/0x60
[  480.039668]  [<ffffffff81252110>] ? ext4_xattr_get+0x60/0xa0
[  480.039672]  [<ffffffff8121b486>] ext4_dirty_inode+0x26/0x60
[  480.039676]  [<ffffffff811a0610>] __mark_inode_dirty+0x40/0x2a0
[  480.039681]  [<ffffffff81191314>] file_update_time+0xe4/0x150
[  480.039687]  [<ffffffff81119148>] __generic_file_aio_write+0x1f8/0x440
[  480.039692]  [<ffffffff81119402>] generic_file_aio_write+0x72/0xe0
[  480.039696]  [<ffffffff81210b9f>] ext4_file_write+0xbf/0x260
[  480.039700]  [<ffffffff8109ec1f>] ? futex_wait+0x15f/0x210
[  480.039704]  [<ffffffff81177342>] do_sync_write+0xd2/0x110
[  480.039708]  [<ffffffff8109ee33>] ? futex_wake+0x113/0x130
[  480.039714]  [<ffffffff812d7448>] ? apparmor_file_permission+0x18/0x20
[  480.039718]  [<ffffffff8129cc9c>] ? security_file_permission+0x2c/0xb0
[  480.039722]  [<ffffffff811778d1>] ? rw_verify_area+0x61/0xf0
[  480.039725]  [<ffffffff81177c33>] vfs_write+0xb3/0x180
[  480.039744]  [<ffffffff81177f5a>] sys_write+0x4a/0x90
[  480.039748]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
[  480.039751] INFO: task pifs4/eio:1126 blocked for more than 120 seconds.
[  480.040147] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  480.040654] pifs4/eio       D ffffffff81806240     0  1126   1042 0x00000000
[  480.040658]  ffff880231d519c8 0000000000000086 0000000000000000
ffff88023fc937f0
[  480.040662]  ffff880231d51fd8 ffff880231d51fd8 ffff880231d51fd8
0000000000013780
[  480.040666]  ffffffff81c0d020 ffff88022f5244d0 ffff880231d519d8
ffff88022db89800
[  480.040670] Call Trace:
[  480.040673]  [<ffffffff8165a55f>] schedule+0x3f/0x60
[  480.040677]  [<ffffffff8125dcba>] start_this_handle.isra.9+0x2aa/0x3e0
[  480.040681]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[  480.040685]  [<ffffffff8125deba>] jbd2__journal_start+0xca/0x110
[  480.040688]  [<ffffffff8125df13>] jbd2_journal_start+0x13/0x20
[  480.040692]  [<ffffffff8123587f>] ext4_journal_start_sb+0x7f/0x1d0
[  480.040695]  [<ffffffff8121b486>] ? ext4_dirty_inode+0x26/0x60
[  480.040698]  [<ffffffff81252110>] ? ext4_xattr_get+0x60/0xa0
[  480.040702]  [<ffffffff8121b486>] ext4_dirty_inode+0x26/0x60
[  480.040705]  [<ffffffff811a0610>] __mark_inode_dirty+0x40/0x2a0
[  480.040710]  [<ffffffff81191314>] file_update_time+0xe4/0x150
[  480.040714]  [<ffffffff81119148>] __generic_file_aio_write+0x1f8/0x440
[  480.040717]  [<ffffffff8165c46e>] ? _raw_spin_lock+0xe/0x20
[  480.040722]  [<ffffffff81119402>] generic_file_aio_write+0x72/0xe0
[  480.040725]  [<ffffffff81210b9f>] ext4_file_write+0xbf/0x260
[  480.040728]  [<ffffffff8109ec1f>] ? futex_wait+0x15f/0x210
[  480.040731]  [<ffffffff81177342>] do_sync_write+0xd2/0x110
[  480.040735]  [<ffffffff8109ee33>] ? futex_wake+0x113/0x130
[  480.040738]  [<ffffffff812d7448>] ? apparmor_file_permission+0x18/0x20
[  480.040742]  [<ffffffff8129cc9c>] ? security_file_permission+0x2c/0xb0
[  480.040745]  [<ffffffff811778d1>] ? rw_verify_area+0x61/0xf0
[  480.040748]  [<ffffffff81177c33>] vfs_write+0xb3/0x180
[  480.040751]  [<ffffffff81177f5a>] sys_write+0x4a/0x90
[  480.040754]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
[  480.040757] INFO: task pifs4/eio:1958 blocked for more than 120 seconds.
[  480.041159] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  480.041627] pifs4/eio       D ffffffff81806240     0  1958   1042 0x00000000
[  480.041630]  ffff8802307a59c8 0000000000000086 ffff8802307a5998
ffffffff8109502d
[  480.041635]  ffff8802307a5fd8 ffff8802307a5fd8 ffff8802307a5fd8
0000000000013780
[  480.041639]  ffffffff81c0d020 ffff880231db5bc0 ffff8802307a59d8
ffff88022db89800
[  480.041643] Call Trace:
[  480.041647]  [<ffffffff8109502d>] ? ktime_get_ts+0xad/0xe0
[  480.041650]  [<ffffffff8165a55f>] schedule+0x3f/0x60
[  480.041654]  [<ffffffff8125dcba>] start_this_handle.isra.9+0x2aa/0x3e0
[  480.041657]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[  480.041661]  [<ffffffff8125deba>] jbd2__journal_start+0xca/0x110
[  480.041665]  [<ffffffff8125df13>] jbd2_journal_start+0x13/0x20
[  480.041668]  [<ffffffff8123587f>] ext4_journal_start_sb+0x7f/0x1d0
[  480.041672]  [<ffffffff8121b486>] ? ext4_dirty_inode+0x26/0x60
[  480.041676]  [<ffffffff8121b486>] ext4_dirty_inode+0x26/0x60
[  480.041679]  [<ffffffff811a0610>] __mark_inode_dirty+0x40/0x2a0
[  480.041683]  [<ffffffff81191314>] file_update_time+0xe4/0x150
[  480.041687]  [<ffffffff81119148>] __generic_file_aio_write+0x1f8/0x440
[  480.041691]  [<ffffffff8165c46e>] ? _raw_spin_lock+0xe/0x20
[  480.041695]  [<ffffffff81119402>] generic_file_aio_write+0x72/0xe0
[  480.041698]  [<ffffffff81210b9f>] ext4_file_write+0xbf/0x260
[  480.041701]  [<ffffffff8109ec1f>] ? futex_wait+0x15f/0x210
[  480.041705]  [<ffffffff81177342>] do_sync_write+0xd2/0x110
[  480.041708]  [<ffffffff8109ee33>] ? futex_wake+0x113/0x130
[  480.041711]  [<ffffffff812d7448>] ? apparmor_file_permission+0x18/0x20
[  480.041714]  [<ffffffff8129cc9c>] ? security_file_permission+0x2c/0xb0
[  480.041718]  [<ffffffff811778d1>] ? rw_verify_area+0x61/0xf0
[  480.041721]  [<ffffffff81177c33>] vfs_write+0xb3/0x180
[  480.041724]  [<ffffffff81177f5a>] sys_write+0x4a/0x90
[  480.041727]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
[  480.041730] INFO: task pifs4/eio:1959 blocked for more than 120 seconds.
[  480.042122] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  480.065078] pifs4/eio       D ffffffff81806240     0  1959   1042 0x00000000
[  480.065082]  ffff880231bcf9c8 0000000000000086 ffff880231bcf998
ffffffff8109502d
[  480.065087]  ffff880231bcffd8 ffff880231bcffd8 ffff880231bcffd8
0000000000013780
[  480.065092]  ffffffff81c0d020 ffff88022dc18000 ffff880231bcf9d8
ffff88022db89800
[  480.065096] Call Trace:
[  480.065100]  [<ffffffff8109502d>] ? ktime_get_ts+0xad/0xe0
[  480.065104]  [<ffffffff8165a55f>] schedule+0x3f/0x60
[  480.065108]  [<ffffffff8125dcba>] start_this_handle.isra.9+0x2aa/0x3e0
[  480.065112]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[  480.065119]  [<ffffffff8125deba>] jbd2__journal_start+0xca/0x110
[  480.065127]  [<ffffffff8125df13>] jbd2_journal_start+0x13/0x20
[  480.065133]  [<ffffffff8123587f>] ext4_journal_start_sb+0x7f/0x1d0
[  480.065141]  [<ffffffff8121b486>] ? ext4_dirty_inode+0x26/0x60
[  480.065147]  [<ffffffff81252110>] ? ext4_xattr_get+0x60/0xa0
[  480.065154]  [<ffffffff8121b486>] ext4_dirty_inode+0x26/0x60
[  480.065161]  [<ffffffff811a0610>] __mark_inode_dirty+0x40/0x2a0
[  480.065169]  [<ffffffff81191314>] file_update_time+0xe4/0x150
[  480.065176]  [<ffffffff81119148>] __generic_file_aio_write+0x1f8/0x440
[  480.065184]  [<ffffffff8101ae59>] ? sched_clock+0x9/0x10
[  480.065192]  [<ffffffff81119402>] generic_file_aio_write+0x72/0xe0
[  480.065199]  [<ffffffff81210b9f>] ext4_file_write+0xbf/0x260
[  480.065206]  [<ffffffff8104c1b8>] ? __wake_up_common+0x58/0x90
[  480.065213]  [<ffffffff81177342>] do_sync_write+0xd2/0x110
[  480.065220]  [<ffffffff8104c228>] ? __wake_up_locked_key+0x18/0x20
[  480.065228]  [<ffffffff812d7448>] ? apparmor_file_permission+0x18/0x20
[  480.065234]  [<ffffffff8129cc9c>] ? security_file_permission+0x2c/0xb0
[  480.065241]  [<ffffffff811778d1>] ? rw_verify_area+0x61/0xf0
[  480.065248]  [<ffffffff81177c33>] vfs_write+0xb3/0x180
[  480.065254]  [<ffffffff81177f5a>] sys_write+0x4a/0x90
[  480.065261]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b
[  480.065267] INFO: task pifs4/eio:1960 blocked for more than 120 seconds.
[  480.077071] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  480.100924] pifs4/eio       D ffffffff81806240     0  1960   1042 0x00000000
[  480.100928]  ffff88023072b9c8 0000000000000086 ffff88023072b998
ffffffff8109502d
[  480.100933]  ffff88023072bfd8 ffff88023072bfd8 ffff88023072bfd8
0000000000013780
[  480.100938]  ffff8802322196f0 ffff88022dc1c4d0 ffff88023072b9d8
ffff88022db89800
[  480.100943] Call Trace:
[  480.100947]  [<ffffffff8109502d>] ? ktime_get_ts+0xad/0xe0
[  480.100951]  [<ffffffff8165a55f>] schedule+0x3f/0x60
[  480.100956]  [<ffffffff8125dcba>] start_this_handle.isra.9+0x2aa/0x3e0
[  480.100963]  [<ffffffff8108aec0>] ? add_wait_queue+0x60/0x60
[  480.100979]  [<ffffffff8125deba>] jbd2__journal_start+0xca/0x110
[  480.100986]  [<ffffffff8125df13>] jbd2_journal_start+0x13/0x20
[  480.100992]  [<ffffffff8123587f>] ext4_journal_start_sb+0x7f/0x1d0
[  480.100999]  [<ffffffff8121b486>] ? ext4_dirty_inode+0x26/0x60
[  480.101005]  [<ffffffff8121b486>] ext4_dirty_inode+0x26/0x60
[  480.101011]  [<ffffffff811a0610>] __mark_inode_dirty+0x40/0x2a0
[  480.101018]  [<ffffffff81191314>] file_update_time+0xe4/0x150
[  480.101025]  [<ffffffff81119148>] __generic_file_aio_write+0x1f8/0x440
[  480.101032]  [<ffffffff8165c46e>] ? _raw_spin_lock+0xe/0x20
[  480.101039]  [<ffffffff81119402>] generic_file_aio_write+0x72/0xe0
[  480.101045]  [<ffffffff81210b9f>] ext4_file_write+0xbf/0x260
[  480.101051]  [<ffffffff8109ec1f>] ? futex_wait+0x15f/0x210
[  480.101057]  [<ffffffff81177342>] do_sync_write+0xd2/0x110
[  480.101063]  [<ffffffff8109ee33>] ? futex_wake+0x113/0x130
[  480.101069]  [<ffffffff812d7448>] ? apparmor_file_permission+0x18/0x20
[  480.101075]  [<ffffffff8129cc9c>] ? security_file_permission+0x2c/0xb0
[  480.101081]  [<ffffffff811778d1>] ? rw_verify_area+0x61/0xf0
[  480.101087]  [<ffffffff81177c33>] vfs_write+0xb3/0x180
[  480.101092]  [<ffffffff81177f5a>] sys_write+0x4a/0x90
[  480.101098]  [<ffffffff81664a82>] system_call_fastpath+0x16/0x1b

Mirek Rusin

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
