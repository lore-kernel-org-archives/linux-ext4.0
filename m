From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 60786] xfstest generic/068 failure - kernel BUG at
 fs/jbd2/transaction.c:2143!
Date: Wed, 12 Mar 2014 20:44:05 +0000
Message-ID: <bug-60786-13602-fNucqVjd0P@https.bugzilla.kernel.org/>
References: <bug-60786-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:60762 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbaCLUoK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Mar 2014 16:44:10 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 13A0220163
	for <linux-ext4@vger.kernel.org>; Wed, 12 Mar 2014 20:44:09 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id 129312016C
	for <linux-ext4@vger.kernel.org>; Wed, 12 Mar 2014 20:44:06 +0000 (UTC)
In-Reply-To: <bug-60786-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=60786

Theodore Tso <tytso@mit.edu> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |tytso@mit.edu

--- Comment #1 from Theodore Tso <tytso@mit.edu> ---
As I mentioned on the list, I'm able to reproduce this very easily these days
by running xfstests generic/068 with data=journal.

With some additional debugging code, it looks like this is a race between
writeback and truncate.

[   36.049876] jbd2_journal_dirty_metadata: vdc-8: bad jh for block 66150:
transaction (f545d980, 55), jh->b_transaction (  (null), 0),
jh->b_next_transaction (  (null), 0), jlist 0
[   36.049892] ------------[ cut here ]------------
[   36.049894] kernel BUG at
/usr/projects/linux/ext4/fs/jbd2/transaction.c:2147!
[   36.049896] invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
[   36.049897] Modules linked in:
[   36.049899] CPU: 0 PID: 3127 Comm: fstest Not tainted
3.14.0-rc2-00026-gaa2b10b-dirty #1679
[   36.049900] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   36.049901] task: f4b6a910 ti: f5bfc000 task.ti: f5bfc000
[   36.049902] EIP: 0060:[<c02e1421>] EFLAGS: 00010206 CPU: 0
[   36.049906] EIP is at jbd2_journal_invalidatepage+0x208/0x279
[   36.049907] EAX: 00e2c025 EBX: f45cc4c8 ECX: 00000000 EDX: 00000001
[   36.049908] ESI: f221e800 EDI: f7817f1c EBP: f5bfdcdc ESP: f5bfdca8
[   36.049908]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   36.049909] CR0: 80050033 CR2: b759e000 CR3: 3484a000 CR4: 000006f0
[   36.049915] Stack:
[   36.049917]  00000001 f45cc4c8 00001000 f45cc4c8 00001000 00000000 00000001
00000000
[   36.049919]  f221eb54 f221e814 c02a395d f7817f1c 00001000 f5bfdcfc c02a3955
00001000
[   36.049921]  f221e800 00000000 c02a395d c025bd12 f7817f1c f5bfdd04 c02a396a
f5bfdd14
[   36.049921] Call Trace:
[   36.049925]  [<c02a395d>] ? __ext4_journalled_invalidatepage+0xc4/0xc4
[   36.049927]  [<c02a3955>] __ext4_journalled_invalidatepage+0xbc/0xc4
[   36.049928]  [<c02a395d>] ? __ext4_journalled_invalidatepage+0xc4/0xc4
[   36.049932]  [<c025bd12>] ? buffer_check_dirty_writeback+0x74/0x74
[   36.049933]  [<c02a396a>] ext4_journalled_invalidatepage+0xd/0x22
[   36.049936]  [<c020a7f6>] do_invalidatepage+0x22/0x26
[   36.049937]  [<c020a849>] truncate_inode_page+0x4f/0x77
[   36.049939]  [<c020a9aa>] truncate_inode_pages_range+0x108/0x2b7
[   36.049940]  [<c020ab6a>] truncate_inode_pages+0x11/0x15
[   36.049942]  [<c020abc5>] truncate_pagecache+0x57/0x73
[   36.049943]  [<c02a962c>] ext4_setattr+0x403/0x4a9
[   36.049946]  [<c024b9d3>] notify_change+0x1b7/0x295
[   36.049949]  [<c0236693>] do_truncate+0x65/0x84
[   36.049951]  [<c023654f>] ? do_dentry_open+0x157/0x1f4
[   36.049953]  [<c0241cbf>] do_last+0x795/0x87f
[   36.049954]  [<c0241fa2>] path_openat+0x1f9/0x426
[   36.049958]  [<c018fdcd>] ? sched_clock_cpu+0xc6/0xe7
[   36.049959]  [<c0243000>] do_filp_open+0x2c/0x65
[   36.049962]  [<c0237098>] do_sys_open+0x59/0xce
[   36.049965]  [<c07b81a4>] ? setup_singlestep+0x9/0xf0
[   36.049967]  [<c023712a>] SyS_open+0x1d/0x1f
[   36.049968]  [<c07bc846>] sysenter_do_call+0x12/0x38
[   36.049981] Code: e0 ff ff 8b 45 f0 e8 26 50 4d 00 8b 55 cc eb 05 ba 01 00
00 00 89 d8 89 55 cc e8 61 de ff ff 8b 03 8b 55 cc a9 00 00 40 00 74 02 <0f> 0b
f0 80 23 df f0 80 23 f7 f0 80 23 bf f0 80 63 01 fd f0 80
[   36.049984] EIP: [<c02e1421>] jbd2_journal_invalidatepage+0x208/0x279 SS:ESP
0068:f5bfdca8
[   36.049986] ---[ end trace bc4c15dc0d962c6e ]---
[   36.115606] ------------[ cut here ]------------
[   36.116785] WARNING: CPU: 1 PID: 714 at
/usr/projects/linux/ext4/fs/jbd2/transaction.c:1359
jbd2_journal_dirty_metadata+0x16c/0x1d0()
[   36.119764] Modules linked in:
[   36.120601] CPU: 1 PID: 714 Comm: kworker/u8:2 Tainted: G      D     
3.14.0-rc2-00026-gaa2b10b-dirty #1679
[   36.123024] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   36.124502] Workqueue: writeback bdi_writeback_workfn (flush-254:32)
[   36.126168]  c01aa168 00000000 f505db80 c07af560 00000000 f505db98 c0168591
c02e0fc6
[   36.128457]  f46044b0 f545d980 f221eb10 f505dba8 c016861b 00000009 00000000
f505dbc8
[   36.130665]  c02e0fc6 00000000 f221e800 f45cc4c8 f45cc4c8 f545c7d8 00001000
f505dbe4
[   36.132851] Call Trace:
[   36.133595]  [<c01aa168>] ? console_unlock+0x355/0x382
[   36.134886]  [<c07af560>] dump_stack+0x48/0x60
[   36.136018]  [<c0168591>] warn_slowpath_common+0x66/0x7d
[   36.137387]  [<c02e0fc6>] ? jbd2_journal_dirty_metadata+0x16c/0x1d0
[   36.138919]  [<c016861b>] warn_slowpath_null+0x14/0x18
[   36.139876]  [<c02e0fc6>] jbd2_journal_dirty_metadata+0x16c/0x1d0
[   36.140812]  [<c02c6c4c>] __ext4_handle_dirty_metadata+0xd4/0x180
[   36.142349]  [<c02a3a46>] write_end_fn+0x3b/0x52
[   36.143540]  [<c02a55eb>] ext4_walk_page_buffers+0x4e/0x6a
[   36.144918]  [<c02a648e>] ext4_writepage+0x2f8/0x363
[   36.146172]  [<c02a3a0b>] ? ext4_bh_delay_or_unwritten+0x21/0x21
[   36.147709]  [<c02a397f>] ? ext4_journalled_invalidatepage+0x22/0x22
[   36.149307]  [<c02071a0>] ? dec_bdi_stat+0x46/0x4d
[   36.150539]  [<c02a64f9>] ? ext4_writepage+0x363/0x363
[   36.151829]  [<c02a6509>] __writepage+0x10/0x2e
[   36.152974]  [<c0207807>] write_cache_pages+0x1f8/0x2f7
[   36.154325]  [<c02a64f9>] ? ext4_writepage+0x363/0x363
[   36.155621]  [<c02a77e5>] ext4_writepages+0xb7/0x513
[   36.156894]  [<c01383e7>] ? paravirt_sched_clock+0x9/0xd
[   36.158224]  [<c0138b9f>] ? sched_clock+0x9/0xc
[   36.159371]  [<c018fac4>] ? sched_clock_local+0x11/0xfa
[   36.160714]  [<c018fe38>] ? local_clock+0x18/0x22
[   36.161911]  [<c019cb8a>] ? lock_release_holdtime.part.26+0x65/0x72
[   36.163524]  [<c0208769>] do_writepages+0x1c/0x29
[   36.164711]  [<c0255ab4>] __writeback_single_inode+0x78/0x2d6
[   36.166155]  [<c0256859>] writeback_sb_inodes+0x19c/0x2ee
[   36.167536]  [<c0256a17>] __writeback_inodes_wb+0x6c/0x95
[   36.168881]  [<c0256b68>] wb_writeback+0x128/0x2e7
[   36.169773]  [<c019e523>] ? trace_hardirqs_on+0xb/0xd
[   36.170738]  [<c0256ec1>] bdi_writeback_workfn+0x85/0x31f
[   36.172055]  [<c017cf45>] ? process_one_work+0x149/0x3ad
[   36.173379]  [<c017cfdf>] process_one_work+0x1e3/0x3ad
[   36.174670]  [<c017da00>] worker_thread+0x12c/0x1c9
[   36.175873]  [<c017d8d4>] ? rescuer_thread+0x221/0x221
[   36.177195]  [<c01823ba>] kthread+0x93/0x98
[   36.178239]  [<c019e523>] ? trace_hardirqs_on+0xb/0xd
[   36.179514]  [<c07bc7b7>] ret_from_kernel_thread+0x1b/0x28
[   36.180921]  [<c0182327>] ? __kthread_parkme+0x55/0x55
[   36.182206] ---[ end trace bc4c15dc0d962c6f ]---
[   36.183387] ------------[ cut here ]------------
[   36.184568] WARNING: CPU: 1 PID: 714 at
/usr/projects/linux/ext4/fs/ext4/ext4_jbd2.c:259
__ext4_handle_dirty_metadata+0xf6/0x180()
[   36.187507] Modules linked in:
[   36.188317] CPU: 1 PID: 714 Comm: kworker/u8:2 Tainted: G      D W   
3.14.0-rc2-00026-gaa2b10b-dirty #1679
[   36.190760] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
[   36.192191] Workqueue: writeback bdi_writeback_workfn (flush-254:32)
[   36.193870]  c01aa168 00000000 f505dba0 c07af560 00000000 f505dbb8 c0168591
c02c6c6e
[   36.196040]  f45cc4c8 f545c7d8 ffffffea f505dbc8 c016861b 00000009 00000000
f505dbe4
[   36.198229]  c02c6c6e 0000040f c07f8cb4 f45cc4c8 f545c7d8 00001000 f505dbfc
c02a3a46
[   36.199931] Call Trace:
[   36.200322]  [<c01aa168>] ? console_unlock+0x355/0x382
[   36.201518]  [<c07af560>] dump_stack+0x48/0x60
[   36.202613]  [<c0168591>] warn_slowpath_common+0x66/0x7d
[   36.203972]  [<c02c6c6e>] ? __ext4_handle_dirty_metadata+0xf6/0x180
[   36.205496]  [<c016861b>] warn_slowpath_null+0x14/0x18
[   36.206773]  [<c02c6c6e>] __ext4_handle_dirty_metadata+0xf6/0x180
[   36.208269]  [<c02a3a46>] write_end_fn+0x3b/0x52
[   36.209423]  [<c02a55eb>] ext4_walk_page_buffers+0x4e/0x6a
[   36.210807]  [<c02a648e>] ext4_writepage+0x2f8/0x363
[   36.212023]  [<c02a3a0b>] ? ext4_bh_delay_or_unwritten+0x21/0x21
[   36.213519]  [<c02a397f>] ? ext4_journalled_invalidatepage+0x22/0x22
[   36.215066]  [<c02071a0>] ? dec_bdi_stat+0x46/0x4d
[   36.216246]  [<c02a64f9>] ? ext4_writepage+0x363/0x363
[   36.217573]  [<c02a6509>] __writepage+0x10/0x2e
[   36.218692]  [<c0207807>] write_cache_pages+0x1f8/0x2f7
[   36.219975]  [<c02a64f9>] ? ext4_writepage+0x363/0x363
[   36.221262]  [<c02a77e5>] ext4_writepages+0xb7/0x513
[   36.222472]  [<c01383e7>] ? paravirt_sched_clock+0x9/0xd
[   36.223823]  [<c0138b9f>] ? sched_clock+0x9/0xc
[   36.224935]  [<c018fac4>] ? sched_clock_local+0x11/0xfa
[   36.226215]  [<c018fe38>] ? local_clock+0x18/0x22
[   36.227397]  [<c019cb8a>] ? lock_release_holdtime.part.26+0x65/0x72
[   36.228919]  [<c0208769>] do_writepages+0x1c/0x29
[   36.229744]  [<c0255ab4>] __writeback_single_inode+0x78/0x2d6
[   36.230848]  [<c0256859>] writeback_sb_inodes+0x19c/0x2ee
[   36.232194]  [<c0256a17>] __writeback_inodes_wb+0x6c/0x95
[   36.233565]  [<c0256b68>] wb_writeback+0x128/0x2e7
[   36.234734]  [<c019e523>] ? trace_hardirqs_on+0xb/0xd
[   36.235968]  [<c0256ec1>] bdi_writeback_workfn+0x85/0x31f
[   36.237337]  [<c017cf45>] ? process_one_work+0x149/0x3ad
[   36.238632]  [<c017cfdf>] process_one_work+0x1e3/0x3ad
[   36.239896]  [<c017da00>] worker_thread+0x12c/0x1c9
[   36.241120]  [<c017d8d4>] ? rescuer_thread+0x221/0x221
[   36.242395]  [<c01823ba>] kthread+0x93/0x98
[   36.243467]  [<c019e523>] ? trace_hardirqs_on+0xb/0xd
[   36.244738]  [<c07bc7b7>] ret_from_kernel_thread+0x1b/0x28
[   36.246084]  [<c0182327>] ? __kthread_parkme+0x55/0x55
[   36.247369] ---[ end trace bc4c15dc0d962c70 ]---
[   36.248505] EXT4-fs: write_end_fn:1039: aborting transaction: error 22 in
__ext4_handle_dirty_metadata
[   36.250813] EXT4: jbd2_journal_dirty_metadata failed: handle type 2 started
at line 1753, credits 9/8, errcode -22
[   36.253304] EXT4-fs error (device vdc) in __ext4_journalled_writepage:1776:
error 22

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
